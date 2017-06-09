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

function GM:HUDPaint()

	self:HUDPaintTime();
	self:HUDPaintResources();

end

function GM:HUDPaintTime()

	local text = string.ToMinutesSecondsMilliseconds( 500.134 );

	surface.SetFont( "NSS Title 48" );

	local w, h = surface.GetTextSize( text );

	surface.SetTextColor( self:GetSkin().COLOR_WHITE );
	surface.SetTextPos( ScrW() / 2 - w / 2, 40 );
	surface.DrawText( text );

	local text = " / 10:00:00";

	surface.SetFont( "NSS Title 32" );

	local w2, h2 = surface.GetTextSize( text );

	surface.SetTextColor( self:GetSkin().COLOR_WHITE_TRANS );
	surface.SetTextPos( ScrW() / 2 + w / 2 + 10, 40 );
	surface.DrawText( text );

end

function GM:HUDPaintResources()

	local x = 40;
	local y = 40;

	local py = 20;
	local sh = 14;
	local fontSize = 16;

	for k, v in pairs( SUBSYSTEMS ) do

		surface.SetDrawColor( self:GetSkin().COLOR_GLASS );
		surface.DrawRect( x, y, 170, py );

		surface.SetDrawColor( self:GetSkin().COLOR_STATUS_GOOD );
		surface.DrawRect( x + ( ( py - sh ) / 2 ), y + ( ( py - sh ) / 2 ), sh, sh );

		local text = v[1];
		surface.SetFont( "NSS " .. fontSize );
		surface.SetTextColor( self:GetSkin().COLOR_WHITE );
		surface.SetTextPos( x + sh + 10, y + ( py - fontSize ) / 2 );
		surface.DrawText( text );
		
		y = y + py + 10;

	end

end