local function nPlayers( len )

	local n = net.ReadUInt( 7 );

	for i = 1, n do

		local ply = net.ReadEntity();
		ply.Joined = net.ReadBool();

	end

end
net.Receive( "nPlayers", nPlayers );

local function nSetSpawnTime( len )

	local len = net.ReadFloat();
	local cam = net.ReadBool();

	LocalPlayer().NextSpawnTime = len;
	LocalPlayer().DeadThirdCam = cam;

end
net.Receive( "nSetSpawnTime", nSetSpawnTime );