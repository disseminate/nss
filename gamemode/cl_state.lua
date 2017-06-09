GM.State = GM.State or STATE_PREGAME;
GM.NextStateChange = GM.NextStateChange or CurTime() + 10;

local function nReceiveState( len )

	local n = net.ReadUInt( 2 );
	local nt = net.ReadFloat();

	GAMEMODE.State = n;
	GAMEMODE.NextStateChange = nt;

end
net.Receive( "nReceiveState", nReceiveState );