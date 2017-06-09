SKIN = { }

SKIN.PrintName		= "NSS Skin"
SKIN.Author			= "disseminate"
SKIN.DermaVersion	= 1
SKIN.GwenTexture	= Material( "gwenskin/GModDefault.png" )

SKIN.COLOR_WHITE = Color( 255, 255, 255 );
SKIN.COLOR_WHITE_TRANS = Color( 255, 255, 255, 100 );
SKIN.COLOR_GLASS = Color( 0, 0, 0, 150 );

SKIN.COLOR_STATUS_GOOD = Color( 139, 255, 94 );
SKIN.COLOR_STATUS_DANGER = Color( 255, 144, 0 );
SKIN.COLOR_STATUS_DESTROYED = Color( 255, 60, 53 );

derma.DefineSkin( "NSS", "NSS Skin", SKIN );

function GM:ForceDermaSkin()

	return "NSS";

end

function GM:GetSkin()

	return derma.GetNamedSkin( "NSS" );

end

derma.RefreshSkins();