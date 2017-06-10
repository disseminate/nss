local function nSetSubsystemState( len )

	local id = net.ReadString();
	local state = net.ReadUInt( 2 );

	GAMEMODE.SubsystemStates[id] = state;

end
net.Receive( "nSetSubsystemState", nSetSubsystemState );
