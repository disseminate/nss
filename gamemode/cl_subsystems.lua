GM.ShipHealth = GM.ShipHealth or 5;

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

	local hp = net.ReadUInt( 4 );

	GAMEMODE.ShipHealth = hp;

end
net.Receive( "nSetShipHealth", nSetShipHealth );

function GM:MakeTerminalSolve( ent, mode )

	self.TerminalSolveActive = true;
	self.TerminalSolveMode = mode;
	self.TerminalSolveEnt = ent;
	self.NextTerminalSolveKey = KEY_1;

	self.TerminalSolveProgress = 0;

end

function GM:TerminalIncrement( mul )

	self.TerminalSolveProgress = self.TerminalSolveProgress + math.Rand( 0.02, 0.1 ) * ( mul or 1 );
	if( self.TerminalSolveProgress >= 1 ) then
		if( self.TerminalSolveEnt and self.TerminalSolveEnt:IsValid() ) then
			net.Start( "nTerminalSolve" );
				net.WriteEntity( self.TerminalSolveEnt );
			net.SendToServer();
		end

		self:ClearTerminalSolve();
	end

end

function GM:ClearTerminalSolve()

	self.TerminalSolveActive = false;

	self.TerminalSolveMode = nil;
	self.TerminalSolveProgress = nil;
	self.TerminalSolveEnt = nil;

end

local function nStartTerminalSolve( len )

	local ent = net.ReadEntity();
	local mode = net.ReadUInt( 5 );

	GAMEMODE:MakeTerminalSolve( ent, mode );

end
net.Receive( "nStartTerminalSolve", nStartTerminalSolve );

function GM:TerminalSolveThink()

	if( self.TerminalSolveActive ) then

		if( !self.TerminalSolveEnt or !self.TerminalSolveEnt:IsValid() ) then
			self:ClearTerminalSolve();
		elseif( !self.TerminalSolveEnt:IsDamaged() ) then
			self:ClearTerminalSolve();
		elseif( self.TerminalSolveEnt:GetPos():Distance( LocalPlayer():GetPos() ) > 100 ) then
			self:ClearTerminalSolve();
		end

	end

end