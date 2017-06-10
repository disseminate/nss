GM.Subsystems = RequireDir( "subsystems" );
GM.SubsystemStates = { };

function GM:GetSubsystemState( id )

	if( !self.SubsystemStates[id] ) then return SUBSYSTEM_STATE_GOOD end
	return self.SubsystemStates[id];

end
