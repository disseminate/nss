local meta = FindMetaTable( "Player" );

GM.State = GM.State or STATE_PREGAME;
GM.NextStateChange = GM.NextStateChange or CurTime() + 10;

function GM:StateThink()
	
	if( CurTime() >= self.NextStateChange ) then

		local newState = self.State + 1;
		if( newState > STATE_POSTGAME ) then
			newState = STATE_PREGAME;
		end
		
		self.NextStateChange = CurTime() + STATE_TIMES[newState];
		self.State = newState;

		MsgN( "STATE CHANGE" );

		self:BroadcastStateChange();

	end

end

function GM:BroadcastStateChange()

	net.Start( "nReceiveState" );
		net.WriteUInt( self.State, 2 );
		net.WriteFloat( self.NextStateChange );
	net.Broadcast();

end
util.AddNetworkString( "nReceiveState" );

function meta:SendState()

	net.Start( "nReceiveState" );
		net.WriteUInt( GAMEMODE.State, 2 );
		net.WriteFloat( GAMEMODE.NextStateChange );
	net.Send( self );

end

function GM:OnReloaded()

	self:BroadcastStateChange();

end