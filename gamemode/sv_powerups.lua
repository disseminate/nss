local meta = FindMetaTable( "Player" );

function meta:AddItem( class )

	self:CheckInventory();

	if( table.Count( self.Inventory ) >= 6 ) then return end

	for i = 1, 6 do
		if( !self.Inventory[i] ) then
			self.Inventory[i] = class;
			return i;
		end
	end

end

function meta:DropItem( id )

	self:CheckInventory();

	self.NextInvPickup = CurTime() + 0.5;

	if( self.Inventory[id] ) then
		
		local class = self.Inventory[id];

		local i = ents.Create( "nss_item" );
		i:SetItem( class );
		i:SetPos( self:GetShootPos() + self:GetAimVector() * 12 );
		i:SetAngles( Angle( math.Rand( -180, 180 ), math.Rand( -180, 180 ), math.Rand( -180, 180 ) ) );
		i:Spawn();
		i:Activate();

		local phys = i:GetPhysicsObject();
		if( phys and phys:IsValid() ) then
			phys:SetVelocity( self:GetAimVector() * 800 + self:GetVelocity() );

			local a = 500;
			phys:AddAngleVelocity( Vector( math.Rand( -a, a ), math.Rand( -a, a ), math.Rand( -a, a ) ) );
		end

		self:EmitSound( Sound( "physics/plaster/ceiling_tile_impact_soft" .. math.random( 1, 3 ) .. ".wav" ) );

	end

	self.Inventory[id] = nil;

end

function meta:SendInventory()

	net.Start( "nInvSend" );
		net.WriteUInt( table.Count( self.Inventory ), MaxUIntBits( 6 ) );
		for k, v in pairs( self.Inventory ) do
			net.WriteUInt( k, MaxUIntBits( 6 ) );
			net.WriteString( v );
		end
	net.Send( self );

end
util.AddNetworkString( "nInvSend" );

function meta:ClearInventory()

	self.Inventory = { };

	net.Start( "nInvClear" );
	net.Send( self );

end
util.AddNetworkString( "nInvClear" );

function meta:SendInventoryID( k )

	self:CheckInventory();
	if( !self.Inventory[k] ) then return end

	net.Start( "nInvAdd" );
		net.WriteUInt( k, MaxUIntBits( 6 ) );
		net.WriteString( self.Inventory[k] );
	net.Send( self );

end
util.AddNetworkString( "nInvAdd" );

local function nDropInventory( len, ply )
	
	local k = net.ReadUInt( MaxUIntBits( 6 ) );

	ply:CheckInventory();
	if( !ply.Inventory[k] ) then return end

	ply:DropItem( k );

end
net.Receive( "nDropInventory", nDropInventory );
util.AddNetworkString( "nDropInventory" );

local function nCreatePowerup( len, ply )

	ply:CheckInventory();

	if( GAMEMODE:GetState() != STATE_GAME ) then return end

	local powerup = net.ReadString();
	if( !GAMEMODE.Powerups[powerup] ) then return end

	local wb = net.ReadEntity();
	if( !wb or !wb:IsValid() or wb:GetClass() != "nss_workbench" ) then return end
	local d = ply:GetPos():Distance( wb:GetPos() );
	if( d > 100 ) then return end

	local used = { };
	
	for _, v in pairs( GAMEMODE.Powerups[powerup].Ingredients ) do

		local k = ply:HasItem( v, used );
		if( !k ) then return end

		used[k] = true;

	end

	for k, _ in pairs( used ) do

		ply.Inventory[k] = nil;

	end

	ply:EmitSound( Sound( "buttons/combine_button" .. math.random( 1, 3 ) .. ".wav" ) );

	ply.Powerup = powerup;

	net.Start( "nSetPowerup" );
		net.WriteEntity( ply );
		net.WriteString( powerup );
	net.Broadcast();

	if( GAMEMODE.Powerups[powerup].OnCreate ) then
		GAMEMODE.Powerups[powerup].OnCreate( ply );
	end

end
net.Receive( "nCreatePowerup", nCreatePowerup );
util.AddNetworkString( "nCreatePowerup" );
util.AddNetworkString( "nSetPowerup" );