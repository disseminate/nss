local meta = FindMetaTable( "Player" );

function GM:ResetState()

	self.StateCycleStart = CurTime();
	self.Lost = false;
	self.CacheState = nil;

	self:BroadcastState();

end

function GM:Reset( nospawn )

	self:ResetState();

	self.ShipHealth = SHIP_HEALTH;
	net.Start( "nSetShipHealth" );
		net.WriteUInt( self.ShipHealth, MaxUIntBits( SHIP_HEALTH ) );
	net.Broadcast();

	self:ResetSubsystems();

	self.LoseResetTime = nil;

	game.CleanUpMap();
	self:InitPostEntity();

	for _, v in pairs( player.GetAll() ) do

		if( !nospawn ) then
			v:Spawn();
		end

		v:ResetAllStats();
		v:ClearInventory();
		v.Powerup = nil;

		v:RemoveEFlags( EFL_NOCLIP_ACTIVE );
		v:SetMoveType( MOVETYPE_WALK );

	end

	for k, v in pairs( team.GetAllTeams() ) do
		team.SetScore( k, 0 );
	end

	if( self:AreTeamsUnbalanced() ) then
		self:RebalanceTeams();
	end

	for k, v in pairs( self.Subsystems ) do

		if( v.Restore ) then

			v.Restore();

		end

	end

end

function GM:StateThink()
	
	if( #player.GetJoined() == 0 ) then return end

	if( self:GetState() != self.CacheState ) then

		self:OnStateTransition( self.CacheState, self:GetState() );
		self.CacheState = self:GetState();
		
	end

	if( self:GetState() == STATE_LOST ) then
		
		local tl = self:TimeLeftInState();
		if( tl <= 0 ) then

			self:Reset();

		end

	end

end

function GM:BroadcastState()

	if( !self.StateCycleStart ) then return end
	
	net.Start( "nReceiveState" );
		net.WriteFloat( self.StateCycleStart );
		net.WriteBool( self.Lost );
	net.Broadcast();

end
util.AddNetworkString( "nReceiveState" );

function meta:SendState()

	if( !GAMEMODE.StateCycleStart ) then return end

	net.Start( "nReceiveState" );
		net.WriteFloat( GAMEMODE.StateCycleStart );
		net.WriteBool( self.Lost );
	net.Send( self );

end

function GM:OnReloaded()

	self:BroadcastState();

end

function GM:WinShip()

	self.StateCycleStart = CurTime() - STATE_TIMES[STATE_GAME] - STATE_TIMES[STATE_PREGAME] + 1;

	for _, v in pairs( player.GetAll() ) do
		v:BroadcastStats();
	end

	self:BroadcastState();

end