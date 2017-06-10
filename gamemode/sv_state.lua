local meta = FindMetaTable( "Player" );

GM.StateCycleStart = GM.StateCycleStart or CurTime();

function GM:StateThink()
	
	if( !self.StateCycleStart ) then
		self.StateCycleStart = CurTime();
	end

	if( self:GetState() != self.CacheState ) then
		self.CacheState = self:GetState();

		self:OnStateTransition( self.CacheState );
	end

end

function GM:OnStateTransition( state )



end

function GM:BroadcastState()

	net.Start( "nReceiveState" );
		net.WriteFloat( self.StateCycleStart );
	net.Broadcast();

end
util.AddNetworkString( "nReceiveState" );

function meta:SendState()

	net.Start( "nReceiveState" );
		net.WriteFloat( GAMEMODE.StateCycleStart );
	net.Send( self );

end

function GM:OnReloaded()

	self:BroadcastState();

end