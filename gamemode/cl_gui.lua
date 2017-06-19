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

function meta:FadeOut( close )

	self:AlphaTo( 0, 0.1, 0, function()
		
		if( close ) then
			
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
	end );
	closeBut:SetPos( w - 24, 0 );

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

function GM:CreateScrollPanel( p, dock )

	local n = vgui.Create( "DScrollPanel", p );
	n:Dock( dock );

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

	function n:SetIcon( icon )

		self.Icon = icon;

	end

	function n:Paint( w, h )

		local dim = 16;
		local x = ( w - dim ) / 2;
		local y = ( h - dim ) / 2;

		surface.SetMaterial( self.Icon );
		surface.SetDrawColor( self:GetSkin().COLOR_WHITE );
		surface.DrawTexturedRect( x, y, dim, dim );

	end

	n.DoClick = click;

	return n;

end

function GM:CreateSpawnIcon( p, dock, w, h, mdl )

	local n = vgui.Create( "SpawnIcon", p );
	n:Dock( dock );
	n:SetSize( w, h );
	n:SetModel( mdl );
	
	return n;

end