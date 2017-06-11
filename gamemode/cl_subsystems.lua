GM.ShipHealth = GM.ShipHealth or 5;

local function nSetSubsystemState( len )

	local id = net.ReadString();
	local state = net.ReadUInt( 2 );

	GAMEMODE.SubsystemStates[id] = state;

end
net.Receive( "nSetSubsystemState", nSetSubsystemState );

local function nResetSubsystems( len )

	for k, v in pairs( GAMEMODE.Subsystems ) do
		GAMEMODE.SubsystemStates[k] = SUBSYSTEM_STATE_GOOD;
	end

end
net.Receive( "nResetSubsystems", nResetSubsystems );

local function nSetShipHealth( len )

	local hp = net.ReadUInt( 4 );

	GAMEMODE.ShipHealth = hp;

end
net.Receive( "nSetShipHealth", nSetShipHealth );