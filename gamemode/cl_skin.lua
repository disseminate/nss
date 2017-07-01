SKIN = { }

SKIN.PrintName		= "NSS Skin"
SKIN.Author			= "disseminate"
SKIN.DermaVersion	= 1
SKIN.GwenTexture	= Material( "gwenskin/GModDefault.png" )

SKIN.COLOR_WHITE = Color( 255, 255, 255 );
SKIN.COLOR_GRAY = Color( 255, 255, 255, 150 );
SKIN.COLOR_WHITE_TRANS = Color( 255, 255, 255, 100 );
SKIN.COLOR_GLASS_LIGHT = Color( 0, 0, 0, 80 );
SKIN.COLOR_GLASS = Color( 0, 0, 0, 150 );
SKIN.COLOR_GLASS_DARK = Color( 0, 0, 0, 170 );
SKIN.COLOR_GLASS_DARKER = Color( 0, 0, 0, 230 );
SKIN.COLOR_GLASS_DISABLED = Color( 255, 255, 255, 6 );
SKIN.COLOR_BLACK = Color( 0, 0, 0, 255 );

SKIN.COLOR_STATUS_GOOD = Color( 139, 255, 94 );
SKIN.COLOR_STATUS_DANGER = Color( 255, 202, 0 );
SKIN.COLOR_STATUS_DESTROYED = Color( 255, 60, 53 );

SKIN.COLOR_HEALTH = Color( 255, 30, 30 );
SKIN.COLOR_LOSE = Color( 200, 0, 0 );
SKIN.COLOR_WIN = Color( 50, 255, 100 );
SKIN.COLOR_TERMINALSOLVE = Color( 40, 160, 255 );

SKIN.COLOR_CLOSEBUTTON = Color( 220, 0, 0 );

SKIN.COLOR_GOLD = Color( 201, 137, 16 );
SKIN.COLOR_SILVER = Color( 168, 168, 168 );
SKIN.COLOR_BRONZE = Color( 150, 90, 56 );

SKIN.ICON_AUDIO_ON = Material( "nss/icons/audio-on" );
SKIN.ICON_AUDIO_OFF = Material( "nss/icons/audio-off" );
SKIN.ICON_ARROW = Material( "nss/icons/arrow" );
SKIN.ICON_ARROW2 = Material( "nss/icons/arrow2" );
SKIN.ICON_CHEVRON = Material( "nss/icons/chevron" );
SKIN.ICON_KEYCAP = Material( "nss/icons/keycap" );
SKIN.ICON_NO = Material( "nss/icons/no" );
SKIN.ICON_CHECK = Material( "nss/icons/check" );
SKIN.ICON_CLOSE = Material( "nss/icons/close" );

SKIN.MAT_RING = Material( "nss/vgui/openring" );

function SKIN:PaintFrame( panel, w, h )

	surface.SetDrawColor( self.COLOR_GLASS );
	surface.DrawRect( 0, 0, w, h );
	surface.DrawRect( 0, 0, w, 24 );

end

function SKIN:PaintButton( panel, w, h )

	if( panel.BackgroundColor ) then

		if( panel:GetDisabled() ) then

			surface.SetDrawColor( self.COLOR_GLASS_DISABLED );
			surface.DrawRect( 0, 0, w, h );

		elseif( panel:IsDown() ) then

			surface.SetDrawColor( panel.DarkBackgroundColor );
			surface.DrawRect( 0, 0, w, h );

		elseif( panel:IsHovered() ) then

			surface.SetDrawColor( panel.LightBackgroundColor );
			surface.DrawRect( 0, 0, w, h );

		else
			
			surface.SetDrawColor( panel.BackgroundColor );
			surface.DrawRect( 0, 0, w, h );

		end

	else
		
		if( panel:GetDisabled() ) then

			surface.SetDrawColor( self.COLOR_GLASS_DISABLED );
			surface.DrawRect( 0, 0, w, h );

		elseif( panel:IsDown() ) then

			surface.SetDrawColor( self.COLOR_GLASS_DARK );
			surface.DrawRect( 0, 0, w, h );

		elseif( panel:IsHovered() ) then

			surface.SetDrawColor( self.COLOR_GLASS_LIGHT );
			surface.DrawRect( 0, 0, w, h );

		else
			
			surface.SetDrawColor( self.COLOR_GLASS_DARK );
			surface.DrawRect( 0, 0, w, h );

		end

	end

end

function SKIN:PaintTooltip( panel, w, h )

	surface.SetDrawColor( self.COLOR_GLASS_DARK );
	surface.DrawRect( 0, 0, w, h );

	if( !panel._SetUp ) then
		panel._SetUp = true;

		panel:SetFont( "NSS 16" );
		panel:SetTextColor( self.COLOR_WHITE );
	end

end

function SKIN:PaintVScrollBar( panel, w, h )



end

function SKIN:PaintScrollBarGrip( panel, w, h )

	surface.SetDrawColor( self.COLOR_GLASS );
	surface.DrawRect( 0, 0, w, h );

end

function SKIN:PaintButtonDown( panel, w, h )

	surface.SetDrawColor( self.COLOR_GLASS );
	surface.DrawRect( 0, 0, w, h );

end

function SKIN:PaintButtonUp( panel, w, h )

	surface.SetDrawColor( self.COLOR_GLASS );
	surface.DrawRect( 0, 0, w, h );

end

derma.DefineSkin( "NSS", "NSS Skin", SKIN );

function GM:ForceDermaSkin()

	return "NSS";

end

function GM:GetSkin()

	return derma.GetNamedSkin( "NSS" );

end

derma.RefreshSkins();