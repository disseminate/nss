GM.NoHUDDraw = {
	"CHudAmmo",
	"CHudBattery",
	"CHudCrosshair",
	"CHudHealth",
	"CHudSecondaryAmmo",
	"CHudWeaponSelection"
};

function GM:HUDShouldDraw( element )

	if( table.HasValue( self.NoHUDDraw, element ) ) then return false end
	return self.BaseClass:HUDShouldDraw( element );

end

function surface.DrawProgressCircle( x, y, perc, radius )

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

		if( perc1 <= perc ) then
			surface.DrawLine( x + x1, y + y1, x + x2, y + y2 );
		end
	end
	
	surface.SetDrawColor( GAMEMODE:GetSkin().COLOR_GLASS );
	surface.DrawPoly( v );

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

	if( !LocalPlayer().Joined ) then
		self:HUDPaintNotJoined();
	elseif( self:GetState() == STATE_LOST ) then
		self:HUDPaintLost();
	elseif( self:GetState() == STATE_POSTGAME ) then
		self:HUDPaintWon();
	elseif( !LocalPlayer():Alive() ) then
		self:HUDPaintDead();
	else
		self:HUDPaintTime();
		self:HUDPaintSubsystems();
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
		
		local text = "Press Space";
		local w2, h2 = surface.GetTextSize( text );
		surface.SetTextPos( ScrW() / 2 - w2 / 2, ScrH() / 2 + h / 2 );
		surface.DrawText( text );

	end

end

function GM:HUDPaintDead()

	surface.BackgroundBlur( 0, 0, ScrW(), ScrH() );
	
	surface.SetDrawColor( self:GetSkin().COLOR_BLACK );
	surface.DrawRect( 0, 0, ScrW(), 50 );
	surface.DrawRect( 0, ScrH() - 50, ScrW(), 50 );

	surface.SetFont( "NSS Title 100" );
	surface.SetTextColor( self:GetSkin().COLOR_WHITE );
	
	local titleText = "You Died";
	local w, h = surface.GetTextSize( titleText );
	surface.SetTextPos( ScrW() / 2 - w / 2, ScrH() / 2 - h / 2 );
	surface.DrawText( titleText );

	surface.SetFont( "NSS 32" );
	
	local dt = LocalPlayer().NextSpawnTime or 0;
	local tl = math.ceil( math.max( dt - CurTime(), 0 ) );
	local text;
	if( tl == 0 ) then
		text = "You can respawn.";
	else
		text = "You can respawn in " .. string.ToMinutesSeconds( tl ) .. ".";
	end
	local w2, h2 = surface.GetTextSize( text );
	surface.SetTextPos( ScrW() / 2 - w2 / 2, ScrH() / 2 + h / 2 );
	surface.DrawText( text );

end

function GM:HUDPaintLost()

	surface.BackgroundBlur( 0, 0, ScrW(), ScrH() );
	
	surface.SetDrawColor( self:GetSkin().COLOR_BLACK );
	surface.DrawRect( 0, 0, ScrW(), 50 );
	surface.DrawRect( 0, ScrH() - 50, ScrW(), 50 );


	local text = "Ship Lost";
	local col = self:GetSkin().COLOR_LOSE;

	surface.SetFont( "NSS Title 100" );

	local w2, h2 = surface.GetTextSize( text );

	surface.SetTextColor( col );
	surface.SetTextPos( ScrW() / 2 - w2 / 2, 90 );
	surface.DrawText( text );


	local timeLeft = self:TimeLeftInState();

	local text = string.ToMinutesSeconds( math.floor( timeLeft ) + 1 );
	local col = self:GetSkin().COLOR_GRAY;

	surface.SetFont( "NSS Title 48" );

	local w, h = surface.GetTextSize( text );

	surface.SetTextColor( col );
	surface.SetTextPos( ScrW() / 2 - w / 2, ScrH() - 50 - h - 40 );
	surface.DrawText( text );

	local text = "Resetting in";
	local col = self:GetSkin().COLOR_GRAY;

	surface.SetFont( "NSS 20" );

	local w2, h2 = surface.GetTextSize( text );

	surface.SetTextColor( col );
	surface.SetTextPos( ScrW() / 2 - w2 / 2, ScrH() - 50 - h - 40 - h2 - 20 );
	surface.DrawText( text );

end

function GM:HUDPaintWon()

	surface.SetDrawColor( self:GetSkin().COLOR_BLACK );
	surface.DrawRect( 0, 0, ScrW(), 50 );
	surface.DrawRect( 0, ScrH() - 50, ScrW(), 50 );


	local text = "Rescued";
	local col = self:GetSkin().COLOR_WIN;

	surface.SetFont( "NSS Title 100" );

	local w2, h2 = surface.GetTextSize( text );

	surface.SetTextColor( col );
	surface.SetTextPos( ScrW() / 2 - w2 / 2, 90 );
	surface.DrawText( text );


	local timeLeft = self:TimeLeftInState();

	local text = string.ToMinutesSeconds( math.floor( timeLeft ) + 1 );
	local col = self:GetSkin().COLOR_GRAY;

	surface.SetFont( "NSS Title 48" );

	local w, h = surface.GetTextSize( text );

	surface.SetTextColor( col );
	surface.SetTextPos( ScrW() / 2 - w / 2, ScrH() - 50 - h - 40 );
	surface.DrawText( text );

	local text = "Resetting in";
	local col = self:GetSkin().COLOR_GRAY;

	surface.SetFont( "NSS 20" );

	local w2, h2 = surface.GetTextSize( text );

	surface.SetTextColor( col );
	surface.SetTextPos( ScrW() / 2 - w2 / 2, ScrH() - 50 - h - 40 - h2 - 20 );
	surface.DrawText( text );

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

		if( ssState == SUBSYSTEM_STATE_DANGER ) then
			local ent = self:GetSubsystemTerminal( k );

			if( ent and ent:IsValid() ) then
				local fwd = LocalPlayer():EyeAngles().y;
				local diffPos = ( ent:GetPos() - LocalPlayer():EyePos() );
				local tdir = diffPos:Angle().y;
				local adist = math.AngleDifference( tdir, fwd );

				surface.SetDrawColor( self:GetSkin().COLOR_WHITE );
				surface.SetMaterial( self:GetSkin().ICON_ARROW );
				surface.DrawTexturedRectRotated( x + rowWidth - 20 + 10 - 2, y + 10 - 2, 16, 16, adist + 90 );

				local dist = math.ceil( diffPos:Length() * 19.05 / ( 10 * 100 ) );
				local text = dist .. "m";
				local w, _ = surface.GetTextSize( text );
				surface.SetTextPos( x + rowWidth - 20 - w - 4, y + ( py - fontSize ) / 2 );
				surface.DrawText( text );
				
				local tr = math.ceil( ent:TimeRemaining() );
				if( tr > 0 ) then
					local text = tr .. "s";
					local w, _ = surface.GetTextSize( text );
					surface.SetTextPos( x + rowWidth - 20 - w - 4 - 50, y + ( py - fontSize ) / 2 );
					surface.DrawText( text );
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