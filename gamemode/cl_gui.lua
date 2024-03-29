local meta = FindMetaTable( "Panel" );

local titleSizes = { 20, 24, 32, 48, 64, 100, 128 };
local textSizes = { 12, 14, 16, 18, 20, 24, 26, 28, 30, 32, 34, 48, 64 };

for _, v in pairs( titleSizes ) do

	surface.CreateFont( "NSS Title " .. v, {
		font = "Maassslicer",
		size = v,
		weight = 400,
		italic = true
	} );

end

for _, v in pairs( textSizes ) do

	surface.CreateFont( "NSS " .. v, {
		font = "Sani Trixie Sans",
		size = v,
		weight = 400
	} );

end

local matBlurScreen = Material( "pp/blurscreen" );

function surface.BackgroundBlur( x, y, w, h, a )

	if( a == 0 ) then return end
	
	local Fraction = 1;

	DisableClipping( true );

	surface.SetMaterial( matBlurScreen );
	surface.SetDrawColor( 255, 255, 255, 255 * ( a or 1 ) );

	for i=0.33, 1, 0.33 do
		matBlurScreen:SetFloat( "$blur", 5 * i );
		matBlurScreen:Recompute();
		if( render ) then render.UpdateScreenEffectTexture() end -- Todo: Make this available to menu Lua
		surface.DrawTexturedRect( x * -1, y * -1, w, h );
	end

	DisableClipping( false );

end

function Lighten( col, amt )

	local c = table.Copy( col );
	c.r = Lerp( amt, c.r, 255 );
	c.g = Lerp( amt, c.g, 255 );
	c.b = Lerp( amt, c.b, 255 );
	return c;

end

function Darken( col, amt )

	local c = table.Copy( col );
	c.r = Lerp( amt, c.r, 0 );
	c.g = Lerp( amt, c.g, 0 );
	c.b = Lerp( amt, c.b, 0 );
	return c;

end

function meta:FadeIn()

	self:SetAlpha( 0 );
	self:AlphaTo( 255, 0.1 );

	self:SetMouseInputEnabled( true );

end

function meta:FadeOut( noclose )

	self:AlphaTo( 0, 0.1, 0, function()
		
		if( !noclose ) then
			
			self:Remove();
			
		end
		
	end );

	self:SetMouseInputEnabled( false );

end

function meta:DockMarginUniform()

	self:DockMargin( 10, 10, 10, 10 );
	return self;

end

function meta:DockMarginInline( a, b, c, d )

	self:DockMargin( a, b, c, d );
	return self;

end

function GM:CreateFrame( title, w, h )

	local n = vgui.Create( "DFrame" );
	n:SetTitle( title );
	n:SetSize( w, h );
	n:Center();
	n:MakePopup();
	n:FadeIn();
	n:DockPadding( 0, 24, 0, 0 );
	n:SetKeyboardInputEnabled( false );

	function n:ShowCloseButton() end
	function n:PerformLayout()
		if( self.lblTitle and self.lblTitle:IsValid() ) then
			self.lblTitle:SetPos( 8, 2 );
			self.lblTitle:SetSize( self:GetWide() - 25, 20 );
			self.lblTitle:SetTextColor( Color( 255, 255, 255 ) );
		end
	end

	n.btnClose:Remove();
	n.btnMaxim:Remove();
	n.btnMinim:Remove();

	n.lblTitle:SetFont( "NSS 20" );

	local closeBut = self:CreateIconButton( n, NODOCK, 24, 24, self:GetSkin().ICON_CLOSE, function()
		n:FadeOut();

		if( n.OnClose ) then
			n.OnClose();
		end
	end );
	closeBut:SetPos( w - 24, 0 );
	closeBut:SetIconPadding( 4 );
	closeBut:SetIconColor( self:GetSkin().COLOR_CLOSEBUTTON );

	return n;

end

function GM:CreatePanel( p, dock, w, h )

	local n = vgui.Create( "DPanel", p );
	n:Dock( dock );
	n:SetSize( w, h );

	function n:Paint( w, h )

		if( self:GetPaintBackground() ) then

			surface.SetDrawColor( self.BackgroundColor and self.BackgroundColor or GAMEMODE:GetSkin().COLOR_GLASS_DARK );
			surface.DrawRect( 0, 0, w, h );

		end

	end

	function n:SetBackgroundColor( col )
		self.BackgroundColor = col;
	end
	
	return n;

end

function GM:CreateLabel( p, dock, text, font, align )

	local n = vgui.Create( "DLabel", p );
	n:Dock( dock );
	n:SetText( text );
	n:SetFont( font );
	n:SizeToContents();
	n:SetTextColor( self:GetSkin().COLOR_WHITE );

	if( align ) then
		n:SetContentAlignment( align );
	end

	return n;

end

function GM:CreateScrollPanel( p, dock, w, h )

	local n = vgui.Create( "DScrollPanel", p );
	n:Dock( dock );
	if( w and h ) then
		n:SetSize( w, h );
	end

	return n;

end

function GM:CreateButton( p, dock, w, h, text, font, click )

	local n = vgui.Create( "DButton", p );
	n:Dock( dock );
	n:SetSize( w, h );
	n:SetText( text );
	n:SetFont( font );

	function n:SetBackgroundColor( col )

		self.BackgroundColor = col;
		self.LightBackgroundColor = Lighten( col, 0.1 );
		self.DarkBackgroundColor = Darken( col, 0.1 );

	end

	function n:UpdateColours( skin )

		return self:SetTextStyleColor( skin.COLOR_WHITE );

	end
	n:ApplySchemeSettings();

	n.DoClick = click;

	return n;

end

function GM:CreateIconButton( p, dock, w, h, icon, click )

	local n = vgui.Create( "DButton", p );
	n:Dock( dock );
	n:SetSize( w, h );
	n:SetText( "" );
	n.Icon = icon;
	n.IconPadding = 0;

	function n:SetIcon( icon )

		self.Icon = icon;

	end

	function n:Paint( w, h )

		local dim = 24;
		local x = ( w - dim ) / 2;
		local y = ( h - dim ) / 2;

		surface.SetMaterial( self.Icon );
		surface.SetDrawColor( self.IconColor or self:GetSkin().COLOR_WHITE );
		surface.DrawTexturedRect( x + self.IconPadding, y + self.IconPadding, dim - self.IconPadding * 2, dim - self.IconPadding * 2 );

	end

	function n:SetIconColor( col )

		self.IconColor = col;

	end

	function n:SetIconPadding( pad )

		self.IconPadding = pad;

	end

	n.DoClick = click;

	return n;

end

function GM:CreateSpawnIcon( p, dock, w, h, mdl, tt )

	local n = vgui.Create( "SpawnIcon", p );
	n:Dock( dock );
	n:SetSize( w, h );
	n:SetModel( mdl );

	function n:PaintOver( w, h )

		if( self:GetDisabled() ) then
			surface.SetDrawColor( self:GetSkin().COLOR_WHITE );
			surface.SetMaterial( self:GetSkin().ICON_NO );
			surface.DrawTexturedRect( 16, 16, w - 32, h - 32 );
		else

			if( self.OverlayFade > 0 ) then
				
				surface.SetAlphaMultiplier( self.OverlayFade / 255 );
					surface.SetDrawColor( self:GetSkin().COLOR_WHITE );
					surface.DrawOutlinedRect( 0, 0, w, h );
				surface.SetAlphaMultiplier( 1 );

			end
			
		end
	end

	n:SetTooltip( tt or "" );
	
	return n;

end

function GM:CreateConfirm( text, cb )

	local f = self:CreateFrame( "Confirm", 270, 130 );
	f:DockPadding( 10, 34, 10, 10 );

	local p = self:CreatePanel( f, BOTTOM, 0, 30 );
	p:SetPaintBackground( false );
		self:CreateButton( p, RIGHT, 80, 0, I18( "ok" ), "NSS 18", function()
			f:FadeOut();
			cb();
		end ):DockMargin( 10, 0, 0, 0 );
		self:CreateButton( p, FILL, 80, 0, I18( "cancel" ), "NSS 18", function()
			f:FadeOut();
		end );
	local t = self:CreateLabel( f, FILL, text, "NSS 16", 7 );
	t:SetWrap( true );

end

function GM:CreateSpinnerPuzzle( p, dock, w, h, diff, onSuccess )

	local f = vgui.Create( "DPanel", p );
	f:Dock( dock );
	if( w and h ) then
		f:SetSize( w, h );
	end

	f.CursorPos = 0;
	f.CursorLevel = 0;

	local levels = {
		{ 1, 100 },
		{ 0.7, 150 },
		{ 0.45, 200 },
		{ 0.25, 300 },
	};

	function f:Paint( w, h )

		surface.SetDrawColor( self:GetSkin().COLOR_WHITE );
		for i = 1, diff do
			surface.DrawSegmentedCircle( w / 2, h / 2, 0.8 * ( h / 2 ) * levels[i][1], CurTime() * levels[i][2] );
		end

		surface.SetMaterial( self:GetSkin().ICON_TARGET );
		surface.DrawTexturedRect( w / 2 - w / 14, h / 2 - w / 14, w / 7, w / 7 );

		if( levels[self.CursorLevel + 1] ) then

			surface.SetMaterial( self:GetSkin().ICON_ARROW2 );
			local x = math.cos( self.CursorPos - math.pi / 2 ) * ( 0.9 * h / 2 ) * ( levels[self.CursorLevel + 1][1] );
			local y = math.sin( self.CursorPos - math.pi / 2 ) * ( 0.9 * h / 2 ) * ( levels[self.CursorLevel + 1][1] );
			
			surface.DrawTexturedRectRotated( w / 2 + x, h / 2 + y, w / 24, w / 24, 180 - self.CursorPos * ( 180 / math.pi ) + 90 );

		end

	end

	function f:Think()
		
		if( input.IsKeyDown( KEY_A ) ) then
			f.CursorPos = f.CursorPos - FrameTime();
		elseif( input.IsKeyDown( KEY_D ) ) then
			f.CursorPos = f.CursorPos + FrameTime();
		end

	end

	function f:OnKeyCodePressed( i )

		if( i == KEY_W ) then
			self:Advance();
		end

	end

	function f:Advance()
		local pos = self.CursorPos * ( 180 / math.pi );
		local ringPos = -math.abs( CurTime() * levels[self.CursorLevel + 1][2] ) % 360;

		net.Start( "nTerminalSolveFX" );
		net.SendToServer();
		
		if( math.abs( math.AngleDifference( pos, ringPos ) ) < 15 ) then
			self.CursorLevel = math.Clamp( self.CursorLevel + 1, 0, 4 );
		else
			self.CursorLevel = math.Clamp( self.CursorLevel - 1, 0, 4 );
		end

		if( self.CursorLevel == diff ) then
			onSuccess();
		end

	end

	f:RequestFocus();

	return f;

end