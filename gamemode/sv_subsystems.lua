function GM:SubsystemThink()

	if( #player.GetJoined() == 0 ) then return end
	if( self:GetState() != STATE_GAME ) then return end

	if( !self.NextDamage or CurTime() >= self.NextDamage ) then

		self.NextDamage = CurTime() + math.Rand( 1, 4 );
		self:DeploySubsystemFault();

	end

end

function GM:SetSubsystemState( id, state )

	self.SubsystemStates[id] = state;

	net.Start( "nSetSubsystemState" );
		net.WriteString( id );
		net.WriteUInt( state, 2 );
	net.Broadcast();

end
util.AddNetworkString( "nSetSubsystemState" );

function GM:GetUnaffectedSubsystems()

	local tab = { };
	for k, v in pairs( self.Subsystems ) do

		if( self:GetSubsystemState( k ) == SUBSYSTEM_STATE_GOOD ) then

			table.insert( tab, k );

		end

	end

	return tab;

end

function GM:DeploySubsystemFault()

	local tab = { };

	for _, v in pairs( ents.FindByClass( "nss_terminal" ) ) do

		if( !v:IsDamaged() ) then

			table.insert( tab, v );

		end

	end

	local ssTab = self:GetUnaffectedSubsystems();

	local t = table.Random( tab );
	local ss = table.Random( ssTab );
	if( t and ss ) then

		t:SelectProblem( ss );
		self:SetSubsystemState( ss, SUBSYSTEM_STATE_DANGER );

	end

end