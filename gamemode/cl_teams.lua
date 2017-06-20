local function nSetTeamAuto( len )

	local t = net.ReadUInt( 4 );
	chat.AddText( Color( 255, 255, 255 ), I18( "team_initial_assign_1" ), " ", team.GetColor( t ), team.GetName( t ), Color( 255, 255, 255 ), " ", I18( "team_initial_assign_2" ) );

end
net.Receive( "nSetTeamAuto", nSetTeamAuto );

local function nSetTeamAutoRebalance( len )

	local t = net.ReadUInt( 4 );
	chat.AddText( Color( 255, 255, 255 ), I18( "team_rebalance_1" ), " ", team.GetColor( t ), team.GetName( t ), Color( 255, 255, 255 ), " ", I18( "team_rebalance_2" ) );

end
net.Receive( "nSetTeamAutoRebalance", nSetTeamAutoRebalance );

local function nChangedTeam( len )

	local t = net.ReadUInt( 4 );
	chat.AddText( Color( 255, 255, 255 ), I18( "team_change_1" ), " ", team.GetColor( t ), team.GetName( t ), Color( 255, 255, 255 ), I18( "team_change_2" ) );

end
net.Receive( "nChangedTeam", nChangedTeam );

local function nChangeTeamError( len )

	chat.AddText( Color( 255, 255, 255 ), I18( "team_change_error" ) );

end
net.Receive( "nChangeTeamError", nChangeTeamError );

function GM:ChangeTeamDialogue()

	local f = self:CreateFrame( I18( "team_choose_title" ), 750, 400 );
	f:SetBackgroundBlur( true );

	local leftPan = self:CreatePanel( f, LEFT, 250, 0 );
	leftPan:SetPaintBackground( true );
	leftPan:SetBackgroundColor( self:GetSkin().COLOR_GLASS_LIGHT );
	leftPan:DockPadding( 10, 10, 10, 10 );
		local l = self:CreateLabel( leftPan, TOP, I18( "team_engineers" ), "NSS Title 32", 8 );
		l:SetColor( team.GetColor( TEAM_ENG ) );

		local l = self:CreateLabel( leftPan, TOP, I18( "team_engineers_desc" ), "NSS 16", 8 );
		l:DockMargin( 10, 20, 10, 0 );
		l:SetWrap( true );
		l:SetAutoStretchVertical( true );
		l:SetTall( 4 * 16 );

		local b = self:CreateButton( leftPan, BOTTOM, 0, 50, I18( "team_join" ), "NSS 24", function()
			net.Start( "nChangeTeam" );
				net.WriteUInt( TEAM_ENG, 4 );
			net.SendToServer();

			f:FadeOut();
		end );
		b:SetBackgroundColor( team.GetColor( TEAM_ENG ) );

	local midPan = self:CreatePanel( f, FILL, 0, 0 );
	midPan:SetPaintBackground( false );
	midPan:DockPadding( 10, 10, 10, 10 );
		local l = self:CreateLabel( midPan, TOP, I18( "team_programmers" ), "NSS Title 32", 8 );
		l:SetColor( team.GetColor( TEAM_PRO ) );

		local l = self:CreateLabel( midPan, TOP, I18( "team_programmers_desc" ), "NSS 16", 8 );
		l:DockMargin( 10, 20, 10, 0 );
		l:SetWrap( true );
		l:SetAutoStretchVertical( true );
		l:SetTall( 4 * 16 );

		local b = self:CreateButton( midPan, BOTTOM, 0, 50, I18( "team_join" ), "NSS 24", function()
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
		local l = self:CreateLabel( rightPan, TOP, I18( "team_officers" ), "NSS Title 32", 8 );
		l:SetColor( team.GetColor( TEAM_OFF ) );

		local l = self:CreateLabel( rightPan, TOP, I18( "team_officers_desc" ), "NSS 16", 8 );
		l:DockMargin( 10, 20, 10, 0 );
		l:SetWrap( true );
		l:SetAutoStretchVertical( true );
		l:SetTall( 4 * 16 );

		local b = self:CreateButton( rightPan, BOTTOM, 0, 50, I18( "team_join" ), "NSS 24", function()
			net.Start( "nChangeTeam" );
				net.WriteUInt( TEAM_OFF, 4 );
			net.SendToServer();

			f:FadeOut();
		end );
		b:SetBackgroundColor( team.GetColor( TEAM_OFF ) );

end