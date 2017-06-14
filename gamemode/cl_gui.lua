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

function GM:CreatePanel( p, dock, w, h )

	local n = vgui.Create( "DPanel", p );
	n:Dock( dock );
	n:SetSize( w, h );

	function n:Paint( w, h )

		if( self:GetPaintBackground() ) then

			surface.SetDrawColor( GAMEMODE:GetSkin().COLOR_GLASS_DARK );
			surface.DrawRect( 0, 0, w, h );

		end

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

		local dim = math.min( w, h );

		surface.SetMaterial( self.Icon );
		surface.SetDrawColor( self:GetSkin().COLOR_WHITE );
		surface.DrawTexturedRect( 0, 0, dim, dim );

	end

	n.DoClick = click;

	return n;

end