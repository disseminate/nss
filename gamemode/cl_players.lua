local function nPlayers( len )

	local n = net.ReadUInt( 7 );

	for i = 1, n do

		local ply = net.ReadEntity();
		ply.Joined = net.ReadBool();

	end

end
net.Receive( "nPlayers", nPlayers );
