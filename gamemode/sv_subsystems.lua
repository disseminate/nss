GM.ShipHealth = GM.ShipHealth or 5;

function GM:GetNextDamageTime()

	if( #player.GetJoined() == 0 ) then return 1e10; end
	if( self:GetState() != STATE_GAME ) then return 1e10; end

	local tmul = 0;
	local tleft = 1 - ( self:TimeLeftInState() / STATE_TIMES[STATE_GAME] );

	return math.Rand( 25 - tmul * 10, 40 - tmul * 10 ) / #player.GetJoined();

end

function GM:SubsystemThink()

	if( #player.GetJoined() == 0 ) then return end
	if( self:GetState() != STATE_GAME ) then return end

	if( !self.NextDamage or CurTime() >= self.NextDamage ) then

		self.NextDamage = CurTime() + self:GetNextDamageTime();
		self:DeploySubsystemFault();

	end

	for k, v in pairs( self.Subsystems ) do

		if( self:SubsystemBroken( k ) and v.DestroyedThink ) then

			v.DestroyedThink();

		end

	end

	if( self:SubsystemBroken( "vacuum" ) and self:SubsystemBroken( "airlock" ) ) then

		for _, v in pairs( player.GetAll() ) do

			local vel = Vector();
			
			for _, n in pairs( ents.FindByClass( "nss_func_space" ) ) do

				local a, b = n:GetRotatedAABB( n:OBBMins(), n:OBBMaxs() );
				local pos = ( n:GetPos() + ( a + b ) / 2 );

				local s = ( pos - v:GetPos() );
				vel = vel + s:GetNormal() * ( 1 / math.pow( v:GetPos():DistToSqr( pos ), 1.5 ) ) * 1e8;
				
			end

			v:SetVelocity( vel );

		end

	end

end

function GM:DamageShip( sys )

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
		net.WriteUInt( self.ShipHealth, 4 );
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

function GM:StartTerminalSolve( ent, ply )

	net.Start( "nStartTerminalSolve" );
		net.WriteEntity( ply );
		net.WriteEntity( ent );
	net.Broadcast();

end
util.AddNetworkString( "nStartTerminalSolve" );

local function nTerminalSolve( len, ply )

	local e = net.ReadEntity();
	if( !e or !e:IsValid() ) then return end

	if( ply:GetPos():Distance( e:GetPos() ) > 100 ) then return end

	e:ProblemSolve( ply );

	ply:AddToStat( STAT_TERMINALS, 1 );

end
net.Receive( "nTerminalSolve", nTerminalSolve );
util.AddNetworkString( "nTerminalSolve" );