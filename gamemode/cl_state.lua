local function nReceiveState( len )

	GAMEMODE.StateCycleStart = net.ReadFloat();
	GAMEMODE.Lost = net.ReadBool();

end
net.Receive( "nReceiveState", nReceiveState );

local function nJoin( len )

	local ply = net.ReadEntity();
	ply.Joined = true;

end
net.Receive( "nJoin", nJoin );