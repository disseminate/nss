include( "shared.lua" );

function ENT:Draw()

	self:DrawModel();

	if( #player.GetJoined() == 0 ) then return end

	local cang = self:GetAngles();
	cang:RotateAroundAxis( self:GetUp(), 90 );
	cang:RotateAroundAxis( self:GetRight(), -90 );

	cam.Start3D2D( self:GetPos() + self:GetUp() * 40 + self:GetForward() * -20, cang, 0.125 );
		surface.SetFont( "NSS Title 64" );
		surface.SetTextColor( Color( 255, 255, 255 ) );
		local t = I18( "workbench" );
		local w, h = surface.GetTextSize( t );
		surface.SetTextPos( -w / 2, -h / 2 );
		surface.DrawText( t );
	cam.End3D2D();

end