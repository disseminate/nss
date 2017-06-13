GM.Subsystems = RequireDir( "subsystems" );
GM.SubsystemStates = { };

function GM:GetSubsystemState( id )

	if( !self.SubsystemStates[id] ) then return SUBSYSTEM_STATE_GOOD end
	return self.SubsystemStates[id];

end

function GM:GetSubsystemTerminal( id )

	for _, v in pairs( ents.FindByClass( "nss_terminal" ) ) do

		if( v:GetSubsystem() == id and v:GetStartTime() > 0 ) then
			
			return v;

		end

	end

end