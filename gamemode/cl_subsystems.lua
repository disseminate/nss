GM.ShipHealth = GM.ShipHealth or SHIP_HEALTH;

local function nSetSubsystemState( len )

	local id = net.ReadString();
	local state = net.ReadUInt( 2 );

	GAMEMODE.SubsystemStates[id] = state;

	if( state == SUBSYSTEM_STATE_DESTROYED and GAMEMODE.Subsystems[id].OnDestroyed ) then

		GAMEMODE.Subsystems[sys].OnDestroyed();

	end

end
net.Receive( "nSetSubsystemState", nSetSubsystemState );

local function nResetSubsystems( len )

	for k, v in pairs( GAMEMODE.Subsystems ) do
		GAMEMODE.SubsystemStates[k] = SUBSYSTEM_STATE_GOOD;
		
		if( v.Restore ) then

			v.Restore();

		end
		
	end

end
net.Receive( "nResetSubsystems", nResetSubsystems );

local function nSetShipHealth( len )

	local hp = net.ReadUInt( MaxUIntBits( SHIP_HEALTH ) );

	GAMEMODE.ShipHealth = hp;

end
net.Receive( "nSetShipHealth", nSetShipHealth );

function GM:SubsystemThink()

	for k, v in pairs( self.Subsystems ) do

		if( self:SubsystemBroken( k ) ) then
			
			if( v.DestroyedThink ) then

				v.DestroyedThink();

			end

		end

	end

end

function GM:MakeTerminalSolve( ply, ent, mode )

	ply.TerminalSolveActive = true;
	ply.TerminalSolveEnt = ent;
	ply.TerminalSolveMode = mode;
	if( ply == LocalPlayer() ) then
		self.NextTerminalSolveKey = KEY_1;
		self:HideItemPanel();

		self.TerminalSolveProgress = 0;
	end

end

function GM:TerminalIncrement( mul )

	local add = math.Rand( 0.02, 0.1 ) * ( mul or 1 );
	if( self:SubsystemBroken( "terminal" ) ) then
		add = add * 0.8;
	end
	
	if( LocalPlayer().Powerup and self.Powerups[LocalPlayer().Powerup].FaultMul ) then
		add = add * self.Powerups[LocalPlayer().Powerup].FaultMul;
	end

	self.TerminalSolveProgress = math.Clamp( self.TerminalSolveProgress + add, 0, 1 );
	if( self.TerminalSolveProgress >= 1 ) then
		if( LocalPlayer().TerminalSolveEnt and LocalPlayer().TerminalSolveEnt:IsValid() ) then
			net.Start( "nTerminalSolve" );
				net.WriteEntity( LocalPlayer().TerminalSolveEnt );
			net.SendToServer();
		end

		LocalPlayer().NextItemThrow = CurTime() + 1;

		self:ClearTerminalSolve( LocalPlayer() );
	end

end

function GM:ClearTerminalSolve( ply )

	ply.TerminalSolveActive = false;
	ply.TerminalSolveEnt = nil;
	ply.TerminalSolveMode = nil;

	if( ply == LocalPlayer() ) then
		self:ShowItemPanel();
		self.TerminalSolveProgress = nil;
	end

end

local function nClearTerminalSolve( len )

	local ply = net.ReadEntity();
	if( ply and ply:IsValid() ) then

		GAMEMODE:ClearTerminalSolve( ply );

	end

end
net.Receive( "nClearTerminalSolve", nClearTerminalSolve );

local function nStartTerminalSolve( len )

	local ply = net.ReadEntity();
	local ent = net.ReadEntity();

	if( !ent or !ent:IsValid() ) then return end
	
	local mode = ent:GetTerminalSolveMode();

	GAMEMODE:MakeTerminalSolve( ply, ent, mode );

end
net.Receive( "nStartTerminalSolve", nStartTerminalSolve );
