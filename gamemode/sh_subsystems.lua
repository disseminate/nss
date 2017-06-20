GM.Subsystems = RequireDir( "subsystems" );
GM.SubsystemStates = { };

function GM:GetSubsystemState( id )

	if( !self.SubsystemStates[id] ) then return SUBSYSTEM_STATE_GOOD end
	return self.SubsystemStates[id];

end

function GM:SubsystemBroken( id )

	return self:GetSubsystemState( id ) == SUBSYSTEM_STATE_BROKEN;

end

function GM:GetSubsystemTerminal( id )

	for _, v in pairs( ents.FindByClass( "nss_terminal" ) ) do

		if( v:GetSubsystem() == id and v:GetStartTime() > 0 ) then
			
			return v;

		end

	end

end

function GM:ASSMul()

	local count = 0;

	for k, v in pairs( self.Subsystems ) do

		if( v.ASS and self:GetSubsystemState( k ) == SUBSYSTEM_STATE_BROKEN ) then

			count = count + 1;

		end

	end

	return count;

end

function GM:ASSTriggered() -- hehe

	return self:ASSMul() > 0;

end