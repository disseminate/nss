GM.NoHUDDraw = {
	"CHudAmmo",
	"CHudBattery",
	"CHudHealth",
	"CHudSecondaryAmmo",
	"CHudWeaponSelection",
	"CHudDamageIndicator"
};

function GM:HUDShouldDraw( element )

	if( table.HasValue( self.NoHUDDraw, element ) ) then return false end
	return self.BaseClass:HUDShouldDraw( element );

end

function surface.DrawProgressCircle( x, y, perc, radius, bgCol )

	perc = math.Clamp( perc, 0, 1 );
	
	local nOuterVerts = 64;
	local v = { };

	surface.SetDrawColor( GAMEMODE:GetSkin().COLOR_WHITE );

	for outer = 0, nOuterVerts do
		local perc1 = outer / nOuterVerts;
		local perc2 = ( outer + 1 ) / nOuterVerts;
		local r1 = ( perc1 - 0.25 ) * ( 2 * math.pi );
		local r2 = ( perc2 - 0.25 ) * ( 2 * math.pi );
		
		local x1 = math.cos( r1 ) * radius;
		local y1 = math.sin( r1 ) * radius;
		local x2 = math.cos( r2 ) * radius;
		local y2 = math.sin( r2 ) * radius;

		table.insert( v, { x = x + x1, y = y + y1 } );

		if( perc1 <= perc and perc > 0 ) then
			surface.DrawLine( x + x1, y + y1, x + x2, y + y2 );
		end
	end

	bgCol = bgCol or GAMEMODE:GetSkin().COLOR_GLASS;
	
	surface.SetDrawColor( bgCol );
	draw.NoTexture();
	surface.DrawPoly( v );

end

function surface.DrawSegmentedCircle( x0, y0, r, ang )

	surface.SetMaterial( GAMEMODE:GetSkin().MAT_RING );

	surface.DrawTexturedRectRotated( x0, y0, r * 2, r * 2, ang );

end

function HUDHasMap( key )

	if( GAMEMODE["HUDTween_" .. key] ) then
		return true;
	end

	return false;

end

function HUDSetMap( key, val )

	GAMEMODE["HUDTween_" .. key] = val;

end

function HUDGetMap( key, default )

	return GAMEMODE["HUDTween_" .. key] or default;

end

function HUDApproachMap( key, val, tween )
	tween = tween or FrameTime();

	if( !GAMEMODE["HUDTween_" .. key] ) then
		GAMEMODE["HUDTween_" .. key] = val;
	else
		GAMEMODE["HUDTween_" .. key] = GAMEMODE["HUDTween_" .. key] + ( val - GAMEMODE["HUDTween_" .. key] ) * tween;
	end
	
	return GAMEMODE["HUDTween_" .. key];

end

function GM:HUDPaint()

	if( self:GetState() != STATE_LOST ) then
		HUDSetMap( "LoseX", -ScrW() );
		HUDSetMap( "LoseX2", -ScrW() );
		HUDSetMap( "LoseX3", -ScrW() );
	end

	if( self:GetState() != STATE_POSTGAME ) then
		HUDSetMap( "WinX", -ScrW() );
		HUDSetMap( "WinX2", -ScrW() );
		HUDSetMap( "WinX3", -ScrW() );
	end

	if( self:GetState() == STATE_GAME ) then
		HUDSetMap( "StatsY", -ScrH() );
		HUDSetMap( "StatsY2", -ScrH() );
		HUDSetMap( "StatsY3", -ScrH() );
	end

	if( LocalPlayer().Joined and self.MapEditMode ) then
		self:HUDPaintMapEditor();
		self:HUDDrawVersion();
		return;
	end

	if( !LocalPlayer().Joined ) then
		self:HUDPaintNotJoined();
	elseif( self:GetState() == STATE_LOST ) then
		self:HUDPaintLost();
	elseif( self:GetState() == STATE_POSTGAME ) then
		self:HUDPaintWon();
	elseif( !LocalPlayer():Alive() ) then
		self:HUDPaintDead();
	else
		self:HUDPaintItems();
		self:HUDPaintPlayers();

		self:HUDPaintTime();
		self:HUDPaintSubsystems();
		self:HUDPaintHealth();
		self:HUDPaintPowerup();

		if( LocalPlayer().Powerup and self.Powerups[LocalPlayer().Powerup].DrawHUD ) then
			self.Powerups[LocalPlayer().Powerup].DrawHUD();
		end

		self:HUDPaintHints();

		self.LostHUDTime = nil;
	end

	if( LocalPlayer().Joined ) then
		self:HUDDrawVersion();
	end

end

function GM:HUDPaintMapEditor()

	surface.SetTextColor( self:GetSkin().COLOR_WHITE );
	
	if( LocalPlayer():IsSuperAdmin() ) then
		
		local y = 40;
		for i = 1, 4 do
			
			if( i == 1 ) then
				surface.SetFont( "NSS 20" );
			else
				surface.SetFont( "NSS 16" );
			end
			local text = I18( "map_editor_prompt" .. i );
			local w2, h2 = surface.GetTextSize( text );
			surface.SetTextPos( 40, y );
			surface.DrawText( text );

			if( i == 1 ) then
				y = y + 30;
			else
				y = y + 16;
			end

		end

	else

		surface.SetFont( "NSS 20" );
		local y = 40;
		for i = 1, 2 do
			local text = I18( "map_editor_user" .. i );
			local w2, h2 = surface.GetTextSize( text );
			surface.SetTextPos( 40, y );
			surface.DrawText( text );

			y = y + 20;
		end

	end

end

function GM:HUDPaintNotJoined()

	if( !LocalPlayer().Joined ) then

		surface.BackgroundBlur( 0, 0, ScrW(), ScrH() );
		
		surface.SetDrawColor( self:GetSkin().COLOR_BLACK );
		surface.DrawRect( 0, 0, ScrW(), 50 );
		surface.DrawRect( 0, ScrH() - 50, ScrW(), 50 );

		surface.SetFont( "NSS Title 100" );
		surface.SetTextColor( self:GetSkin().COLOR_WHITE );
		
		local titleText = "Need Some Space";
		local w, h = surface.GetTextSize( titleText );
		surface.SetTextPos( ScrW() / 2 - w / 2, ScrH() / 2 - h / 2 );
		surface.DrawText( titleText );

		surface.SetFont( "NSS 32" );
		
		local text = I18( "press_space" );
		local w2, h2 = surface.GetTextSize( text );
		surface.SetTextPos( ScrW() / 2 - w2 / 2, ScrH() - 90 - h / 2 );
		surface.DrawText( text );

	end

end

function GM:HUDPaintDead()

	surface.BackgroundBlur( 0, 0, ScrW(), ScrH() );

	surface.SetFont( "NSS Title 100" );
	surface.SetTextColor( self:GetSkin().COLOR_WHITE );
	
	local titleText = I18( "you_died" );
	local reasonText;
	if( LocalPlayer().DeadReason == 1 ) then
		reasonText = I18( "death_airlock" );
	elseif( LocalPlayer().DeadReason == 2 ) then
		reasonText = I18( "death_terminal_explosion" );
	end

	local w, h = surface.GetTextSize( titleText );
	surface.SetTextPos( ScrW() / 2 - w / 2, ScrH() / 2 - h / 2 );
	surface.DrawText( titleText );

	surface.SetFont( "NSS 24" );

	local hh = 0;

	if( reasonText ) then

		local w2, h2 = surface.GetTextSize( "(" .. reasonText .. ")" );
		surface.SetTextPos( ScrW() / 2 - w2 / 2, ScrH() / 2 + h / 2 );
		surface.DrawText( "(" .. reasonText .. ")" );

		hh = h2 + 40;

	end

	surface.SetFont( "NSS 32" );
	
	local dt = LocalPlayer().NextSpawnTime or 0;
	local tl = math.ceil( math.max( dt - CurTime(), 0 ) );
	local text;
	if( tl == 0 ) then
		text = I18( "can_respawn" );
	else
		text = I18( "can_respawn_in", tl );
	end
	local w2, h2 = surface.GetTextSize( text );
	surface.SetTextPos( ScrW() / 2 - w2 / 2, ScrH() / 2 + h / 2 + hh );
	surface.DrawText( text );

end

function GM:HUDPaintLost()

	local a = 0;

	if( !self.OutroStart ) then return end

	local tSince = CurTime() - self.OutroStart;

	if( tSince > 1.5 ) then
		a = math.Clamp( tSince - 1.5, 0, 1 );
			
		surface.BackgroundBlur( 0, 0, ScrW(), ScrH(), a );

		surface.SetAlphaMultiplier( a );

		local text = I18( "lose_title" );
		local col = self:GetSkin().COLOR_LOSE;

		surface.SetFont( "NSS Title 100" );

		local w2, h2 = surface.GetTextSize( text );

		local x = HUDApproachMap( "LoseX", ScrW() / 2 - w2 / 2, FrameTime() * 4 );

		surface.SetTextColor( col );
		surface.SetTextPos( x, 90 );
		surface.DrawText( text );


		local timeLeft = self:TimeLeftInState();

		local text = string.ToMinutesSeconds( math.floor( timeLeft ) + 1 );
		local col = self:GetSkin().COLOR_GRAY;

		surface.SetFont( "NSS Title 48" );

		local w, h = surface.GetTextSize( text );

		local x = HUDApproachMap( "LoseX3", ScrW() / 2 - w / 2, FrameTime() * 2 );

		surface.SetTextColor( col );
		surface.SetTextPos( x, ScrH() - 50 - h - 40 );
		surface.DrawText( text );

		local text = I18( "resetting" );
		local col = self:GetSkin().COLOR_GRAY;

		surface.SetFont( "NSS 20" );

		local w2, h2 = surface.GetTextSize( text );

		local x = HUDApproachMap( "LoseX2", ScrW() / 2 - w2 / 2, FrameTime() * 3 );

		surface.SetTextColor( col );
		surface.SetTextPos( x, ScrH() - 50 - h - 40 - h2 - 20 );
		surface.DrawText( text );

		self:HUDPaintStats( tSince - 1.5 );

		surface.SetAlphaMultiplier( 1 );

		if( !self.ExplosionFXTime ) then
			self.ExplosionFXTime = CurTime();
			surface.PlaySound( Sound( "ambient/explosions/explode_" .. math.random( 2, 6 ) .. ".wav" ) );
			surface.PlaySound( Sound( "music/stingers/hl1_stinger_song16.mp3" ) );
		end

		if( CurTime() - self.ExplosionFXTime < 2 ) then
			if( CurTime() - self.ExplosionFXTime < 1 ) then

			elseif( CurTime() - self.ExplosionFXTime < 2 ) then
				surface.SetAlphaMultiplier( 1 - ( CurTime() - self.ExplosionFXTime - 1 ) );
			end

			surface.SetDrawColor( self:GetSkin().COLOR_WHITE );
			surface.DrawRect( 0, 0, ScrW(), ScrH() );

			surface.SetAlphaMultiplier( 1 );
		end

	else

		self.ExplosionFXTime = nil;

	end

end

function GM:HUDPaintWon()

	local text = I18( "success_title" );
	local col = self:GetSkin().COLOR_WIN;

	surface.SetFont( "NSS Title 100" );

	local w2, h2 = surface.GetTextSize( text );

	local x = HUDApproachMap( "WinX", ScrW() / 2 - w2 / 2, FrameTime() * 4 );

	surface.SetTextColor( col );
	surface.SetTextPos( x, 90 );
	surface.DrawText( text );


	local timeLeft = self:TimeLeftInState();

	local text = string.ToMinutesSeconds( math.floor( timeLeft ) + 1 );
	local col = self:GetSkin().COLOR_GRAY;

	surface.SetFont( "NSS Title 48" );

	local w, h = surface.GetTextSize( text );

	local x = HUDApproachMap( "WinX3", ScrW() / 2 - w / 2, FrameTime() * 2 );

	surface.SetTextColor( col );
	surface.SetTextPos( x, ScrH() - 50 - h - 40 );
	surface.DrawText( text );

	local text = I18( "resetting" );
	local col = self:GetSkin().COLOR_GRAY;

	surface.SetFont( "NSS 20" );

	local w2, h2 = surface.GetTextSize( text );

	local x = HUDApproachMap( "WinX2", ScrW() / 2 - w2 / 2, FrameTime() * 3 );

	surface.SetTextColor( col );
	surface.SetTextPos( x, ScrH() - 50 - h - 40 - h2 - 20 );
	surface.DrawText( text );

	if( self.OutroStart ) then

		local tSince = CurTime() - self.OutroStart;
		self:HUDPaintStats( tSince );

	end

end

function GM:HUDPaintStats( ct ) -- ct starts at 0

	if( ct < 0 ) then return end

	local colw = 250;
	local pad = 40;

	local x = ScrW() / 2 - ( pad / 2 ) - colw - pad - colw;
	local y = HUDApproachMap( "StatsY", 240, FrameTime() * 4 );

	local colh = math.min( ScrH() * 0.5, ScrH() - y - 200 );

	surface.SetDrawColor( self:GetSkin().COLOR_GLASS_DARKER );
	surface.DrawRect( x, y, colw, colh );

	surface.SetFont( "NSS 32" );
	surface.SetTextPos( x + 20, y + 20 );
	surface.SetTextColor( self:GetSkin().COLOR_WHITE );
	surface.DrawText( I18( "stat_damage" ) );

	local plTab = player.GetAll();
	table.sort( plTab, function( a, b ) return a:GetStat( STAT_DMG ) > b:GetStat( STAT_DMG ); end );

	local function drawPlayerList( tab, stat, x, y )

		local _y = y + 20 + 20 + 30;

		local i = 1;
		while( tab[i] and ( _y - y ) < colh - 30 ) do
			local dy = 0;
			if( i == 1 ) then
				surface.SetFont( "NSS 30" );
				surface.SetTextColor( self:GetSkin().COLOR_GOLD );
				dy = 10;
			elseif( i == 2 ) then
				surface.SetFont( "NSS 26" );
				surface.SetTextColor( self:GetSkin().COLOR_SILVER );
				dy = 6;
			elseif( i == 3 ) then
				surface.SetFont( "NSS 24" );
				surface.SetTextColor( self:GetSkin().COLOR_BRONZE );
				dy = 4;
			else
				surface.SetFont( "NSS 20" );
				surface.SetTextColor( self:GetSkin().COLOR_WHITE );
			end
			local _w, _ = surface.GetTextSize( "" .. tab[i]:GetStat( stat ) );
			surface.SetTextPos( x + 20, _y );
			surface.DrawText( tab[i]:Nick() );

			surface.SetTextColor( self:GetSkin().COLOR_WHITE );
			surface.SetTextPos( x + colw - _w - 20, _y );
			surface.DrawText( "" .. tab[i]:GetStat( stat ) );

			_y = _y + 30 + dy;
			i = i + 1;
		end

	end;

	local function drawTeamList( tab, x, y )

		local _y = y + 20 + 20 + 30;
		for i = 1, math.min( #tab, 10 ) do
			local dy = 0;
			surface.SetTextColor( team.GetColor( tab[i] ) );
			if( i == 1 ) then
				surface.SetFont( "NSS 30" );
				dy = 10;
			elseif( i == 2 ) then
				surface.SetFont( "NSS 26" );
				dy = 6;
			elseif( i == 3 ) then
				surface.SetFont( "NSS 24" );
				dy = 4;
			else
				surface.SetFont( "NSS 20" );
			end

			local _w, _ = surface.GetTextSize( "" .. team.GetScore( tab[i] ) );
			surface.SetTextPos( x + 20, _y );
			surface.DrawText( team.GetName( tab[i] ) );

			surface.SetTextColor( self:GetSkin().COLOR_WHITE );
			surface.SetTextPos( x + colw - _w - 20, _y );
			surface.DrawText( "" .. team.GetScore( tab[i] ) );

			_y = _y + 30 + dy;
		end

	end;

	drawPlayerList( plTab, STAT_DMG, x, y );

	local x = ScrW() / 2 - ( pad / 2 ) - colw;
	local y = HUDApproachMap( "StatsY2", 240, FrameTime() * 3 );

	surface.SetDrawColor( self:GetSkin().COLOR_GLASS_DARKER );
	surface.DrawRect( x, y, colw, colh );

	surface.SetFont( "NSS 32" );
	surface.SetTextPos( x + 20, y + 20 );
	surface.SetTextColor( self:GetSkin().COLOR_WHITE );
	surface.DrawText( I18( "stat_terminals" ) );

	local plTab = player.GetAll();
	table.sort( plTab, function( a, b ) return a:GetStat( STAT_TERMINALS ) > b:GetStat( STAT_TERMINALS ); end );
	drawPlayerList( plTab, STAT_TERMINALS, x, y );

	local x = ScrW() / 2 + ( pad / 2 );
	local y = HUDApproachMap( "StatsY3", 240, FrameTime() * 2 );

	surface.SetDrawColor( self:GetSkin().COLOR_GLASS_DARKER );
	surface.DrawRect( x, y, colw, colh );
	
	surface.SetFont( "NSS 32" );
	surface.SetTextPos( x + 20, y + 20 );
	surface.SetTextColor( self:GetSkin().COLOR_WHITE );
	surface.DrawText( I18( "stat_useless" ) );

	local plTab = player.GetAll();
	table.sort( plTab, function( a, b ) return a:GetStat( STAT_TERMINALS ) < b:GetStat( STAT_TERMINALS ); end );
	drawPlayerList( plTab, STAT_TERMINALS, x, y );

	local x = ScrW() / 2 + ( pad / 2 ) + colw + pad;
	local y = HUDApproachMap( "StatsY3", 240, FrameTime() * 2 );

	surface.SetDrawColor( self:GetSkin().COLOR_GLASS_DARKER );
	surface.DrawRect( x, y, colw, colh );
	
	surface.SetFont( "NSS 32" );
	surface.SetTextPos( x + 20, y + 20 );
	surface.SetTextColor( self:GetSkin().COLOR_WHITE );
	surface.DrawText( I18( "stat_team" ) );

	local teamTab = { TEAM_ENG, TEAM_PRO, TEAM_OFF };
	table.sort( teamTab, function( a, b ) return team.GetScore( a ) > team.GetScore( b ); end );
	drawTeamList( teamTab, x, y );

end

function GM:HUDPaintItems()

	surface.SetDrawColor( self:GetSkin().COLOR_WHITE );

	for _, v in pairs( ents.FindByClass( "nss_item" ) ) do

		local p = v:GetPos();

		local dist = LocalPlayer():GetPos():Distance( p );

		if( dist < 1000 ) then

			local amul = 1;
			if( dist >= 700 ) then

				amul = 1 - ( ( dist - 700 ) / 300 );

			end

			surface.SetAlphaMultiplier( amul );
			
			local r = v:GetPos() + Vector( v:BoundingRadius(), v:BoundingRadius(), v:BoundingRadius() );
			
			local pp = p:ToScreen();
			local pr = r:ToScreen();
			local rad = math.sqrt( math.pow( pp.x - pr.x, 2 ) + math.pow( pp.y - pr.y, 2 ) ) / 2;

			local p = math.Clamp( ( v:GetDieTime() - CurTime() ) / 15, 0, 1 );
			
			surface.DrawProgressCircle( pp.x, pp.y, p, rad )

			local t = self.Items[v:GetItem()].Name;

			surface.SetFont( "NSS 20" );
			surface.SetTextColor( self:GetSkin().COLOR_WHITE );
			local w, h = surface.GetTextSize( t );
			surface.SetTextPos( pp.x - w / 2, pp.y + ( rad * 1.3 ) );
			surface.DrawText( t );

			surface.SetAlphaMultiplier( 1 );

		end

	end

end

function GM:HUDPaintPlayers()

	local padding = 6;

	for _, v in pairs( player.GetAll() ) do

		if( v:Alive() ) then
			
			if( v != LocalPlayer() or ( v == LocalPlayer() and hook.Run( "ShouldDrawLocalPlayer", LocalPlayer() ) ) ) then

				local p = v:GetPos();

				local dist = LocalPlayer():GetPos():Distance( p );

				if( dist < 1000 ) then

					local amul = 1;
					if( dist >= 700 ) then

						amul = 1 - ( ( dist - 700 ) / 300 );

					end

					local r = v:EyePos() + Vector( 0, 0, 10 );

					local trace = { };
					trace.start = EyePos();
					trace.endpos = v:EyePos();
					trace.filter = { LocalPlayer(), v };
					trace.mask = MASK_BLOCKLOS
					local tr = util.TraceLine( trace );

					if( tr.Fraction == 1.0 ) then

						surface.SetAlphaMultiplier( amul );
						local pr = r:ToScreen();
						
						local t = v:Nick();

						surface.SetFont( "NSS 18" );
						surface.SetTextColor( self:GetSkin().COLOR_WHITE );
						local w, h = surface.GetTextSize( t );

						local wSpace = 10;

						w = w + wSpace;

						local x = pr.x - w / 2;
						local y = pr.y - h / 2 - 48;

						local drawHealth = false;
						if( v:Health() < v:GetMaxHealth() ) then
							drawHealth = true;
						end

						local hAdd = 0;
						if( drawHealth ) then
							hAdd = 14 + padding;
						end

						surface.SetDrawColor( self:GetSkin().COLOR_GLASS_DARK );
						surface.DrawRect( x - padding, y - padding, w + padding * 2, h + padding * 2 + hAdd );

						surface.SetDrawColor( team.GetColor( v:Team() ) );
						surface.DrawRect( x + w - wSpace + ( wSpace / 2 - 4 / 2 + padding / 2 ), y + h / 2 - 4 / 2, 4, 4 );

						surface.SetTextPos( x, y );
						surface.DrawText( t );

						y = y + h + padding;

						if( drawHealth ) then

							local t = v:Health() .. "%";
							surface.SetFont( "NSS 14" );
							surface.SetTextColor( self:GetSkin().COLOR_HEALTH );
							local w, h = surface.GetTextSize( t );
							surface.SetTextPos( pr.x - w / 2, y );
							surface.DrawText( t );

						end

						surface.SetAlphaMultiplier( 1 );

					end

				end

			end

		end

	end

end

function GM:HUDPaintTime()

	if( #player.GetJoined() == 0 ) then return end

	local state = self:GetState();
	local timeLeft = self:TimeLeftInState();
	local text;
	local text2 = " / " .. string.ToMinutesSeconds( STATE_TIMES[state] );
	local col = self:GetSkin().COLOR_WHITE;
	if( state == STATE_PREGAME ) then
		text = string.ToMinutesSeconds( math.floor( timeLeft ) + 1 );
		col = self:GetSkin().COLOR_GRAY;
	elseif( state == STATE_GAME ) then
 		text = string.ToMinutesSeconds( STATE_TIMES[state] - timeLeft );
	else
		text = string.ToMinutesSeconds( math.floor( timeLeft ) + 1 );
		col = self:GetSkin().COLOR_GRAY;
	end

	surface.SetFont( "NSS Title 48" );

	local w, h = surface.GetTextSize( text );

	surface.SetTextColor( col );
	surface.SetTextPos( ScrW() / 2 - w / 2, 40 );
	surface.DrawText( text );

	surface.SetFont( "NSS Title 32" );

	local w2, h2 = surface.GetTextSize( text2 );

	surface.SetTextColor( self:GetSkin().COLOR_WHITE_TRANS );
	surface.SetTextPos( ScrW() / 2 + w / 2 + 10, 40 );
	surface.DrawText( text2 );

end

function GM:HUDPaintSubsystems()

	local x = 40;
	local y = 40;

	local py = 20;
	local rw = 240;
	local sh = 14;
	local fontSize = 16;

	if( LocalPlayer():KeyDown( IN_SCORE ) ) then
		rw = 350;
	end

	local rowWidth = HUDApproachMap( "SubsystemRowWidth", rw, FrameTime() * 10 );

	local n = 1;
	for k, v in pairs( self.Subsystems ) do

		surface.SetDrawColor( self:GetSkin().COLOR_GLASS );
		surface.DrawRect( x, y, rowWidth, py );

		local ssState = self:GetSubsystemState( k );

		if( ssState == SUBSYSTEM_STATE_GOOD ) then
			surface.SetDrawColor( self:GetSkin().COLOR_STATUS_GOOD );
		elseif( ssState == SUBSYSTEM_STATE_DANGER ) then
			surface.SetDrawColor( self:GetSkin().COLOR_STATUS_DANGER );
		elseif( ssState == SUBSYSTEM_STATE_BROKEN ) then
			surface.SetDrawColor( self:GetSkin().COLOR_STATUS_DESTROYED );
		end
		surface.DrawRect( x + ( ( py - sh ) / 2 ), y + ( ( py - sh ) / 2 ), sh, sh );

		local text = v.Acronym;
		if( LocalPlayer():KeyDown( IN_SCORE ) ) then
			text = v.Name;
		end
		
		surface.SetFont( "NSS " .. fontSize );
		surface.SetTextColor( self:GetSkin().COLOR_WHITE );
		surface.SetTextPos( x + sh + 10, y + ( py - fontSize ) / 2 );
		surface.DrawText( text );

		local _w, _ = surface.GetTextSize( text );
		local xInd = x + sh + 10 + _w + 10;

		if( ssState == SUBSYSTEM_STATE_DANGER ) then
			local ent = self:GetSubsystemTerminal( k );

			if( ent and ent:IsValid() ) then

				for _, v in pairs( v.Teams ) do
					if( ent:GetNeedsTeam( v ) ) then
						surface.SetDrawColor( team.GetColor( v ) );
						surface.DrawRect( xInd, y + 7, 6, 6 );
						xInd = xInd + 6 + 4;
					end
				end

				if( ent:GetNeedsTeam( LocalPlayer():Team() ) ) then

					local fwd = LocalPlayer():EyeAngles().y;
					local diffPos = ( ent:GetPos() - LocalPlayer():EyePos() );
					local tdir = diffPos:Angle().y;
					local adist = math.AngleDifference( tdir, fwd );

					local xx = x + rowWidth - 20 + 10 - 2;

					surface.SetDrawColor( self:GetSkin().COLOR_WHITE );
					surface.SetMaterial( self:GetSkin().ICON_ARROW );
					surface.DrawTexturedRectRotated( xx, y + 10 - 2, 16, 16, adist + 90 );

					xx = xx - 16 - 4;

					if( diffPos.z > 100 ) then
						surface.SetMaterial( self:GetSkin().ICON_CHEVRON );
						surface.DrawTexturedRectRotated( xx, y + 10 - 2, 16, 16, 90 );
					elseif( diffPos.z < -100 ) then
						surface.SetMaterial( self:GetSkin().ICON_CHEVRON );
						surface.DrawTexturedRectRotated( xx, y + 10 - 2, 16, 16, 270 );
					end

					xx = xx - 16 - 30;

					local dist = math.ceil( diffPos:Length() * 19.05 / ( 10 * 100 ) ) - 2;
					local text = dist .. "m";
					local w, _ = surface.GetTextSize( text );
					surface.SetTextPos( xx, y + ( py - fontSize ) / 2 );
					surface.DrawText( text );
					
					local tr = ent:TimeRemaining();
					local tt = ent:GetExplodeDuration();
					if( math.ceil( tr ) > 0 ) then
						local text = math.ceil( tr ) .. "s";
						local w, _ = surface.GetTextSize( text );
						surface.SetTextPos( xx - 50, y + ( py - fontSize ) / 2 );
						surface.DrawText( text );
	--[[
						local perc = tr / tt;
						surface.SetDrawColor( self:GetSkin().COLOR_HEALTH );
						surface.DrawRect( x, y + py - 1, rowWidth * perc, 1 );
						--]]
					end
				end
			end
		end
		
		y = y + py + 10;
		n = n + 1;

	end

	surface.SetDrawColor( self:GetSkin().COLOR_GLASS );
	surface.DrawRect( x, y, 200, 10 );
	surface.SetDrawColor( self:GetSkin().COLOR_HEALTH );

	local hp = HUDApproachMap( "ShipHealth", self.ShipHealth, FrameTime() * 4 );

	local w0 = 200 - 4;
	local w = w0 * ( hp / 5 );
	surface.DrawRect( x + 2, y + 2, w, 10 - 4 );

end

function GM:HUDPaintHealth()

	local ha = 255;
	if( LocalPlayer():Health() >= LocalPlayer():GetMaxHealth() ) then
		ha = 0;
	end
	local a = HUDApproachMap( "SelfHealthAlpha", ha, FrameTime() * 20 );
	surface.SetAlphaMultiplier( a );

	local barh = 20;
	local barw = 200;

	local x = 40;
	local y = ScrH() - 40 - barh;

	surface.SetDrawColor( self:GetSkin().COLOR_GLASS );
	surface.DrawRect( x, y, barw, barh );
	surface.SetDrawColor( self:GetSkin().COLOR_HEALTH );

	local hp = HUDApproachMap( "SelfHealth", math.Clamp( LocalPlayer():Health(), 0, LocalPlayer():GetMaxHealth() ), FrameTime() * 10 );

	local w0 = barw - 4;
	local w = w0 * ( hp / LocalPlayer():GetMaxHealth() );
	surface.DrawRect( x + 2, y + 2, w, barh - 4 );

	surface.SetAlphaMultiplier( 1 );

end

function GM:HUDPaintPowerup()

	if( LocalPlayer().Powerup and LocalPlayer().Powerup != "" ) then

		surface.SetFont( "NSS 24" );
		surface.SetTextColor( self:GetSkin().COLOR_WHITE );
		local t = self.Powerups[LocalPlayer().Powerup].Name;
		local w, h = surface.GetTextSize( t );
		surface.SetDrawColor( self:GetSkin().COLOR_GLASS );
		surface.DrawRect( ScrW() - 40 - w - 12, ScrH() - 40 - h - 12, w + 12, h + 12 );
		surface.SetTextPos( ScrW() - 40 - w - 6, ScrH() - 40 - h - 6 );
		surface.DrawText( t );

	end

end

function GM:HUDPaintHints()

	LocalPlayer():CheckInventory();

	if( !self:Hint( "inv_throw" ) and table.Count( LocalPlayer().Inventory ) > 0 ) then

		surface.SetTextColor( self:GetSkin().COLOR_WHITE );
		surface.SetTextPos( ScrW() / 2 + 230, ScrH() - 32 - 20 + 3 );
		surface.SetFont( "NSS 20" );
		surface.DrawText( I18( "inv_throw_hint" ) );

	end

end

function GM:HUDDrawVersion()

	local y = 40;
	
	surface.SetTextColor( self:GetSkin().COLOR_WHITE_TRANS );
	surface.SetFont( "NSS 16" );
	local t = "Need Some Space β";
	local w, h = surface.GetTextSize( t );
	surface.SetTextPos( ScrW() - w - 40, y );
	surface.DrawText( t );

	y = y + h;
	surface.SetFont( "NSS 14" );
	local t = "Subject to change.";
	local w, h = surface.GetTextSize( t );
	surface.SetTextPos( ScrW() - w - 40, y );
	surface.DrawText( t );

	local endTime = 1501545599;
	if( os.time() < endTime ) then

		surface.SetTextColor( self:GetSkin().COLOR_WHITE );

		y = y + h + 20;
		surface.SetFont( "NSS 14" );
		local t = "Time Until Contest Deadline";
		local w, h = surface.GetTextSize( t );
		surface.SetTextPos( ScrW() - w - 40, y );
		surface.DrawText( t );

		y = y + h;
		surface.SetFont( "NSS 16" );
		local t = os.date( "%d days, %H hours, %M minutes", os.difftime( endTime, os.time() ) );
		local w, h = surface.GetTextSize( t );
		surface.SetTextPos( ScrW() - w - 40, y );
		surface.DrawText( t );

	end

end