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

function GM:MakeTerminalSolve( ply, ent, diff )

	ply.TerminalSolveActive = true;
	ply.TerminalSolveEnt = ent;
	ply.TerminalSolveDiff = diff;
	
	self.TerminalPanel = self:CreateFrame( I18( "terminal" ), 600, 600 );
	self.TerminalPanel:SetKeyboardInputEnabled( true );
	self.TerminalPanel.OnClose = function()
		self:ClearTerminalSolve( LocalPlayer() );
	end;
	self.TerminalPanel.Puzzle = self:CreateSpinnerPuzzle( self.TerminalPanel, FILL, nil, nil, diff, function()
	
		if( LocalPlayer().TerminalSolveEnt and LocalPlayer().TerminalSolveEnt:IsValid() ) then
			net.Start( "nTerminalSolve" );
				net.WriteEntity( LocalPlayer().TerminalSolveEnt );
			net.SendToServer();
		end

		self:ClearTerminalSolve( LocalPlayer() );
	
	end );

	local pInfo = self:CreatePanel( self.TerminalPanel, BOTTOM, 0, 80 );
	pInfo:DockPadding( 10, 10, 10, 10 );
	self:CreateLabel( pInfo, TOP, self.Subsystems[ent:GetSubsystem()].Name, "NSS 18", 7 ):DockMargin( 0, 0, 0, 10 );
	local l = self:CreateLabel( pInfo, FILL, self.Subsystems[ent:GetSubsystem()].Desc or "", "NSS 16", 7 );
	l:SetWrap( true );

	if( ply == LocalPlayer() ) then
		self:HideItemPanel();
	end

end

function GM:ClearTerminalSolve( ply )

	ply.TerminalSolveActive = false;
	ply.TerminalSolveEnt = nil;
	ply.TerminalSolveDiff = nil;

	if( ply == LocalPlayer() ) then
		self:ShowItemPanel();
		self.TerminalSolveProgress = nil;

		if( self.TerminalPanel and self.TerminalPanel:IsValid() ) then
			self.TerminalPanel:FadeOut();
		end
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
	
	local diff = ent:GetTerminalSolveDiff();

	GAMEMODE:MakeTerminalSolve( ply, ent, diff );

end
net.Receive( "nStartTerminalSolve", nStartTerminalSolve );
