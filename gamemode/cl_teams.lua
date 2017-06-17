local function nSetTeamAuto( len )

	local t = net.ReadUInt( 4 );
	chat.AddText( Color( 255, 255, 255 ), "You have been assigned to the ", team.GetColor( t ), team.GetName( t ), Color( 255, 255, 255 ), " team. Look for subsystem failures with your color and fix them!" );

end
net.Receive( "nSetTeamAuto", nSetTeamAuto );

local function nSetTeamAutoRebalance( len )

	local t = net.ReadUInt( 4 );
	chat.AddText( Color( 255, 255, 255 ), "Teams have been rebalanced. You have been auto-assigned to the ", team.GetColor( t ), team.GetName( t ), Color( 255, 255, 255 ), " team." );

end
net.Receive( "nSetTeamAutoRebalance", nSetTeamAutoRebalance );

local function nChangedTeam( len )

	local t = net.ReadUInt( 4 );
	chat.AddText( Color( 255, 255, 255 ), "You have changed to the ", team.GetColor( t ), team.GetName( t ), Color( 255, 255, 255 ), " team." );

end
net.Receive( "nChangedTeam", nChangedTeam );

local function nChangeTeamError( len )

	chat.AddText( Color( 255, 255, 255 ), "You can't change your team to that right now." );

end
net.Receive( "nChangeTeamError", nChangeTeamError );

function GM:ChangeTeamDialogue()

	local f = self:CreateFrame( "Choose a Team", 750, 400 );
	f:SetKeyboardInputEnabled( false );

	local leftPan = self:CreatePanel( f, LEFT, 250, 0 );
	leftPan:SetPaintBackground( true );
	leftPan:SetBackgroundColor( self:GetSkin().COLOR_GLASS_LIGHT );
	leftPan:DockPadding( 10, 10, 10, 10 );
		local l = self:CreateLabel( leftPan, TOP, "Engineers", "NSS Title 32", 8 );
		l:SetColor( team.GetColor( TEAM_ENG ) );

		local l = self:CreateLabel( leftPan, TOP, "Fix engine- and mechanics-related problems.", "NSS 16", 8 );
		l:DockMargin( 10, 20, 10, 0 );
		l:SetWrap( true );
		l:SetAutoStretchVertical( true );
		l:SetTall( 4 * 16 );

		local b = self:CreateButton( leftPan, BOTTOM, 0, 50, "Join", "NSS 24", function()
			net.Start( "nChangeTeam" );
				net.WriteUInt( TEAM_ENG, 4 );
			net.SendToServer();

			f:FadeOut();
		end );
		b:SetBackgroundColor( team.GetColor( TEAM_ENG ) );

	local midPan = self:CreatePanel( f, FILL, 0, 0 );
	midPan:SetPaintBackground( false );
	midPan:DockPadding( 10, 10, 10, 10 );
		local l = self:CreateLabel( midPan, TOP, "Programmers", "NSS Title 32", 8 );
		l:SetColor( team.GetColor( TEAM_PRO ) );

		local l = self:CreateLabel( midPan, TOP, "On-the-fly hotfixes and patches for drivers gone bad.", "NSS 16", 8 );
		l:DockMargin( 10, 20, 10, 0 );
		l:SetWrap( true );
		l:SetAutoStretchVertical( true );
		l:SetTall( 4 * 16 );

		local b = self:CreateButton( midPan, BOTTOM, 0, 50, "Join", "NSS 24", function()
			net.Start( "nChangeTeam" );
				net.WriteUInt( TEAM_PRO, 4 );
			net.SendToServer();

			f:FadeOut();
		end );
		b:SetBackgroundColor( team.GetColor( TEAM_PRO ) );

	local rightPan = self:CreatePanel( f, RIGHT, 250, 0 );
	rightPan:SetPaintBackground( true );
	rightPan:SetBackgroundColor( self:GetSkin().COLOR_GLASS_LIGHT );
	rightPan:DockPadding( 10, 10, 10, 10 );
		local l = self:CreateLabel( rightPan, TOP, "Officers", "NSS Title 32", 8 );
		l:SetColor( team.GetColor( TEAM_OFF ) );

		local l = self:CreateLabel( rightPan, TOP, "Coordination, honor, and drive are this team's forte.", "NSS 16", 8 );
		l:DockMargin( 10, 20, 10, 0 );
		l:SetWrap( true );
		l:SetAutoStretchVertical( true );
		l:SetTall( 4 * 16 );

		local b = self:CreateButton( rightPan, BOTTOM, 0, 50, "Join", "NSS 24", function()
			net.Start( "nChangeTeam" );
				net.WriteUInt( TEAM_OFF, 4 );
			net.SendToServer();

			f:FadeOut();
		end );
		b:SetBackgroundColor( team.GetColor( TEAM_OFF ) );

end