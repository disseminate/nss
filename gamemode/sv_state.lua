local meta = FindMetaTable( "Player" );

function GM:ResetState()

	self.StateCycleStart = CurTime();
	self.Lost = false;
	self.CacheState = nil;

	self:BroadcastState();

end

function GM:Reset()

	self:ResetState();

	self.ShipHealth = 5;
	net.Start( "nSetShipHealth" );
		net.WriteUInt( self.ShipHealth, 4 );
	net.Broadcast();

	self:ResetSubsystems();

	self.LoseResetTime = nil;

	game.CleanUpMap();

	for _, v in pairs( player.GetAll() ) do

		v:Spawn();

	end

end

function GM:StateThink()
	
	if( #player.GetJoined() == 0 ) then return end

	if( self:GetState() != self.CacheState ) then
		self.CacheState = self:GetState();

		self:OnStateTransition( self.CacheState );
	end

	if( self:GetState() == STATE_LOST ) then
		
		local tl = self:TimeLeftInState();
		if( tl <= 0 ) then

			self:Reset();

		end

	end

end

function GM:OnStateTransition( state )



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