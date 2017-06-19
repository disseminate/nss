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