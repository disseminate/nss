GM.ShipHealth = GM.ShipHealth or 5;

function GM:SubsystemThink()

	if( #player.GetJoined() == 0 ) then return end
	if( self:GetState() != STATE_GAME ) then return end

	if( !self.NextDamage or CurTime() >= self.NextDamage ) then

		self.NextDamage = CurTime() + math.Rand( 1, 4 );
		self:DeploySubsystemFault();

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
		net.WriteEntity( ent );
		net.WriteUInt( math.random( TASK_MASH, TASK_ROW ), 5 );
	net.Send( ply );

end
util.AddNetworkString( "nStartTerminalSolve" );

local function nTerminalSolve( len, ply )

	local e = net.ReadEntity();
	if( !e or !e:IsValid() ) then return end

	if( ply:GetPos():Distance( e:GetPos() ) > 100 ) then return end

	e:ProblemSolve( ply );

end
net.Receive( "nTerminalSolve", nTerminalSolve );
util.AddNetworkString( "nTerminalSolve" );