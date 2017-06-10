local function nReceiveState( len )

	local nt = net.ReadFloat();
	GAMEMODE.StateCycleStart = nt;

end
net.Receive( "nReceiveState", nReceiveState );

local function nJoin( len )

	local ply = net.ReadEntity();
	ply.Joined = true;

end
net.Receive( "nJoin", nJoin );