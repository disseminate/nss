GM.Subsystems = RequireDir( "subsystems" );

function GM:SubsystemThink()

	if( !self.NextDamage or CurTime() >= self.NextDamage ) then

		self.NextDamage = CurTime() + math.Rand( 1, 4 );
		self:DeploySubsystemFault();

	end

end

function GM:DeploySubsystemFault()

	local tab = { };

	for _, v in pairs( ents.FindByClass( "nss_terminal" ) ) do

		if( !v:IsDamaged() ) then

			table.insert( tab, v );

		end

	end

	local t = table.Random( tab );
	if( t ) then

		t:SelectRandomProblem();

	end

end