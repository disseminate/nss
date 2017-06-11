local titleSizes = { 20, 24, 32, 48, 64, 100, 128 };
local textSizes = { 12, 14, 16, 18, 20, 24, 32 };

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
		font = "Tahoma",
		size = v,
		weight = 400
	} );

end

local matBlurScreen = Material( "pp/blurscreen" );

function surface.BackgroundBlur( x, y, w, h )

	local Fraction = 1;

	DisableClipping( true );

	surface.SetMaterial( matBlurScreen );
	surface.SetDrawColor( 255, 255, 255, 255 );

	for i=0.33, 1, 0.33 do
		matBlurScreen:SetFloat( "$blur", 5 * i );
		matBlurScreen:Recompute();
		if( render ) then render.UpdateScreenEffectTexture() end -- Todo: Make this available to menu Lua
		surface.DrawTexturedRect( x * -1, y * -1, w, h );
	end

	DisableClipping( false );

end