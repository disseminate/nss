GM.ShipHealth = GM.ShipHealth or SHIP_HEALTH;

function GM:GetNextDamageTime()

	if( #player.GetJoined() == 0 ) then return 1e10; end
	if( self:GetState() != STATE_GAME ) then return 1e10; end

	local tmul = 1 - ( self:TimeLeftInState() / STATE_TIMES[STATE_GAME] );

	return math.Rand( 15 - tmul * 10, 30 - tmul * 10 ) / ( #player.GetJoined() / 2 ); -- / 2 for team balance sake

end

function GM:SubsystemThink()

	if( #player.GetJoined() == 0 ) then return end
	if( self:GetState() != STATE_GAME ) then return end

	if( !self.NextDamage or CurTime() >= self.NextDamage ) then

		self.NextDamage = CurTime() + self:GetNextDamageTime();
		self:DeploySubsystemFault();

	end

	for k, v in pairs( self.Subsystems ) do

		if( self:SubsystemBroken( k ) ) then
			
			if( v.DestroyedThink ) then

				v.DestroyedThink();

			end

			if( v.ASS ) then

				for _, ply in pairs( player.GetAll() ) do

					if( ply:Alive() and ply.Joined ) then
						
						if( !ply.NextASS ) then
							ply.NextASS = CurTime();
						end

						if( CurTime() >= ply.NextASS ) then
							ply.NextASS = CurTime() + 1;

							local md = false;
							for _, n in pairs( ents.FindByClass( "nss_ass" ) ) do

								if( n:GetPos():Distance( ply:GetPos() ) < 256 ) then

									md = true;
									break;

								end

							end

							if( !md and ply.Powerup != "spacesuit" ) then
								
								local dmgamt = math.random( 1, 5 );

								local dmg = DamageInfo();
								dmg:SetAttacker( game.GetWorld() );
								dmg:SetInflictor( game.GetWorld() );
								dmg:SetDamage( dmgamt );
								dmg:SetDamageType( v.DamageType );
								ply:TakeDamageInfo( dmg );

								if( !ply.ASSDamage ) then
									ply.ASSDamage = 0;
								end
								ply.ASSDamage = math.min( ply.ASSDamage + dmgamt, 100 );

							else

								if( ply.ASSDamage and ply.ASSDamage > 0 ) then

									local amt = math.min( ply.ASSDamage, 5 );
									ply:SetHealth( ply:Health() + amt );
									ply.ASSDamage = ply.ASSDamage - amt;

								end

							end
							
						end

					else

						ply.ASSDamage = nil;

					end

				end

			end

		end

	end

	if( self:SubsystemBroken( "vacuum" ) and self:SubsystemBroken( "airlock" ) ) then

		for _, v in pairs( player.GetAll() ) do

			local vel = Vector();
			
			for _, n in pairs( ents.FindByClass( "nss_func_space" ) ) do

				local a, b = n:GetRotatedAABB( n:OBBMins(), n:OBBMaxs() );
				local pos = ( n:GetPos() + ( a + b ) / 2 );

				local s = ( pos - v:GetPos() );
				vel = vel + s:GetNormal() * ( 1 / math.pow( v:GetPos():DistToSqr( pos ), 1.5 ) ) * 1.5e8;
				
			end

			v:SetVelocity( vel );

		end

	end

	for _, v in pairs( player.GetAll() ) do
		
		if( v.TerminalSolveActive ) then

			if( !v:Alive() ) then

				self:ClearTerminalSolve( v );

			else
				
				if( !v.TerminalSolveEnt or !v.TerminalSolveEnt:IsValid() ) then
					self:ClearTerminalSolve( v );
				elseif( !v.TerminalSolveEnt:IsDamaged() ) then
					self:ClearTerminalSolve( v );
				elseif( v.TerminalSolveEnt:GetPos():Distance( v:GetPos() ) > 100 ) then
					self:ClearTerminalSolve( v );
				end

			end

		end

	end

end

function GM:DamageShip( sys )
	
	--if( true ) then GAMEMODE:SetSubsystemState( sys, SUBSYSTEM_STATE_GOOD ) return end

	GAMEMODE:SetSubsystemState( sys, SUBSYSTEM_STATE_BROKEN );

	ScreenShake( 3 );

	if( self.Subsystems[sys].OnDestroyed ) then

		self.Subsystems[sys].OnDestroyed();

	end

	self.ShipHealth = self.ShipHealth - 1;

	if( self.ShipHealth == 0 ) then
		self:KillShip();
	end

	net.Start( "nSetShipHealth" );
		net.WriteUInt( self.ShipHealth, MaxUIntBits( SHIP_HEALTH ) );
	net.Broadcast();

end
util.AddNetworkString( "nSetShipHealth" );

function GM:KillShip()

	self.Lost = true;

	for _, v in pairs( player.GetAll() ) do
		v:BroadcastStats();
	end
	self:BroadcastState();

end

function GM:SetSubsystemState( id, state )

	self.SubsystemStates[id] = state;

	net.Start( "nSetSubsystemState" );
		net.WriteString( id );
		net.WriteUInt( state, 2 );
	net.Broadcast();

end
util.AddNetworkString( "nSetSubsystemState" );

function GM:ResetSubsystems()

	for k, v in pairs( self.SubsystemStates ) do

		self:SetSubsystemState( k, SUBSYSTEM_STATE_GOOD );

	end

	net.Start( "nResetSubsystems" );
	net.Broadcast();

end
util.AddNetworkString( "nResetSubsystems" );

function GM:GetUnaffectedSubsystems( teamTab )

	local tab = { };
	for k, v in pairs( self.Subsystems ) do

		if( self:GetSubsystemState( k ) == SUBSYSTEM_STATE_GOOD ) then

			local teamsGood = true;
			for _, n in pairs( v.Teams ) do
				if( !table.HasValue( teamTab, n ) ) then
					teamsGood = false;
				end
			end

			if( teamsGood ) then
				table.insert( tab, k );
			end

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

	local teamTab = { };
	if( #team.GetPlayers( TEAM_ENG ) > 0 ) then table.insert( teamTab, TEAM_ENG ); end
	if( #team.GetPlayers( TEAM_PRO ) > 0 ) then table.insert( teamTab, TEAM_PRO ); end
	if( #team.GetPlayers( TEAM_OFF ) > 0 ) then table.insert( teamTab, TEAM_OFF ); end

	local ssTab = self:GetUnaffectedSubsystems( teamTab );

	local t = table.Random( tab );
	local ss = table.Random( ssTab );
	if( t and ss ) then

		t:SelectProblem( ss );
		self:SetSubsystemState( ss, SUBSYSTEM_STATE_DANGER );

	end

end

function GM:StartTerminalSolve( ent, ply )

	ply.TerminalSolveActive = true;
	ply.TerminalSolveEnt = ent;
	ply.TerminalSolveDiff = ent:GetTerminalSolveDiff();

	net.Start( "nStartTerminalSolve" );
		net.WriteEntity( ply );
		net.WriteEntity( ent );
	net.Broadcast();

end
util.AddNetworkString( "nStartTerminalSolve" );

function GM:ClearTerminalSolve( ply )

	ply.TerminalSolveActive = false;
	ply.TerminalSolveEnt = nil;
	ply.TerminalSolveDiff = nil;

	net.Start( "nClearTerminalSolve" );
		net.WriteEntity( ply );
	net.Broadcast();

end
util.AddNetworkString( "nClearTerminalSolve" );

local function nTerminalSolve( len, ply )

	local e = net.ReadEntity();
	if( !e or !e:IsValid() ) then return end

	if( ply:GetPos():Distance( e:GetPos() ) > 100 ) then return end

	e:ProblemSolve( ply );

	ply:AddToStat( STAT_TERMINALS, 1 );
	team.SetScore( ply:Team(), team.GetScore( ply:Team() ) + 1 );

end
net.Receive( "nTerminalSolve", nTerminalSolve );
util.AddNetworkString( "nTerminalSolve" );

local function nTerminalSolveFX( len, ply )

	if( !ply.TerminalSolveActive ) then return end

	ply:EmitSound( Sound( "ambient/machines/keyboard" .. math.random( 1, 6 ) .. "_clicks.wav" ) );

	net.Start( "nSetGestureTyping" );
		net.WriteEntity( ply );
	net.Broadcast();

end
net.Receive( "nTerminalSolveFX", nTerminalSolveFX );
util.AddNetworkString( "nTerminalSolveFX" );