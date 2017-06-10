local function nReceiveState( len )

	local nt = net.ReadFloat();
	GAMEMODE.StateCycleStart = nt;

end
net.Receive( "nReceiveState", nReceiveState );