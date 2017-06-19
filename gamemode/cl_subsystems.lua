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

function GM:SubsystemThink()

	for k, v in pairs( self.Subsystems ) do

		if( self:SubsystemBroken( k ) and v.DestroyedThink ) then

			v.DestroyedThink();

		end

	end

end

function GM:MakeTerminalSolve( ply, ent, mode )

	self:HideItemPanel();

	ply.TerminalSolveActive = true;
	ply.TerminalSolveEnt = ent;
	ply.TerminalSolveMode = mode;
	if( ply == LocalPlayer() ) then
		self.NextTerminalSolveKey = KEY_1;

		self.TerminalSolveProgress = 0;
	end

end

function GM:TerminalIncrement( mul )

	local add = math.Rand( 0.02, 0.1 ) * ( mul or 1 );
	if( self:SubsystemBroken( "terminal" ) ) then
		add = add * 0.8;
	end

	self.TerminalSolveProgress = self.TerminalSolveProgress + add;
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
	
	self:ShowItemPanel();

	ply.TerminalSolveActive = false;
	ply.TerminalSolveEnt = nil;
	ply.TerminalSolveMode = nil;

	if( ply == LocalPlayer() ) then
		self.TerminalSolveProgress = nil;
	end

end

local function nStartTerminalSolve( len )

	local ply = net.ReadEntity();
	local ent = net.ReadEntity();

	if( !ent or !ent:IsValid() ) then return end
	
	local mode = ent:GetTerminalSolveMode();

	GAMEMODE:MakeTerminalSolve( ply, ent, mode );

end
net.Receive( "nStartTerminalSolve", nStartTerminalSolve );

function GM:TerminalSolveThink()

	for _, v in pairs( player.GetAll() ) do
		
		if( v.TerminalSolveActive ) then

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