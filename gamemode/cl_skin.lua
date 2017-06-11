SKIN = { }

SKIN.PrintName		= "NSS Skin"
SKIN.Author			= "disseminate"
SKIN.DermaVersion	= 1
SKIN.GwenTexture	= Material( "gwenskin/GModDefault.png" )

SKIN.COLOR_WHITE = Color( 255, 255, 255 );
SKIN.COLOR_GRAY = Color( 255, 255, 255, 150 );
SKIN.COLOR_WHITE_TRANS = Color( 255, 255, 255, 100 );
SKIN.COLOR_GLASS = Color( 0, 0, 0, 150 );
SKIN.COLOR_GLASS_DARK = Color( 0, 0, 0, 170 );
SKIN.COLOR_BLACK = Color( 0, 0, 0, 255 );

SKIN.COLOR_STATUS_GOOD = Color( 139, 255, 94 );
SKIN.COLOR_STATUS_DANGER = Color( 255, 202, 0 );
SKIN.COLOR_STATUS_DESTROYED = Color( 255, 60, 53 );

SKIN.COLOR_HEALTH = Color( 255, 30, 30 );
SKIN.COLOR_LOSE = Color( 200, 0, 0 );
SKIN.COLOR_WIN = Color( 50, 255, 100 );

local png = "unlitgeneric noclamp";
SKIN.ICON_AUDIO_ON = Material( "nss/icons/audio-on.png", png );
SKIN.ICON_AUDIO_OFF = Material( "nss/icons/audio-off.png", png );

derma.DefineSkin( "NSS", "NSS Skin", SKIN );

function GM:ForceDermaSkin()

	return "NSS";

end

function GM:GetSkin()

	return derma.GetNamedSkin( "NSS" );

end

derma.RefreshSkins();