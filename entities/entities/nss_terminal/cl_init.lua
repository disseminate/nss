include( "shared.lua" );

ENT.SpriteMat = Material( "nss/sprites/glow01" );

function ENT:Draw()

	self:DrawModel();

	if( self:GetExplodeTime() > 0 and CurTime() < self:GetExplodeTime() ) then

		local tl = self:GetExplodeTime() - CurTime();
		local id = self:GetSubsystem();
		local ss = GAMEMODE.Subsystems[id];

		local fps = 1;

		if( tl < 4 ) then
			fps = 0.1;
		elseif( tl < 10 ) then
			fps = 0.2;
		elseif( tl < 20 ) then
			fps = 0.4;
		elseif( tl < 40 ) then
			fps = 0.7;
		end

		local on = CurTime() % fps < ( fps / 2 );

		if( on ) then

			render.SetMaterial( self.SpriteMat );
			render.DrawSprite( self:GetPos() + self:GetUp() * 48 + self:GetForward() * 4, 16, 16, Color( 255, 0, 0 ) );

		end

		local cang = self:GetAngles();
		cang:RotateAroundAxis( self:GetUp(), 90 );
		cang:RotateAroundAxis( self:GetRight(), -90 );

		cam.Start3D2D( self:GetPos() + self:GetUp() * 80 + self:GetForward() * -20, cang, 0.25 );
			surface.SetFont( "NSS Title 24" );

			local tAcro = ss.Acronym;
			local tTime = math.ceil( tl );
			local w, h = surface.GetTextSize( tAcro );

			local y = -h / 2;

			surface.SetTextColor( Color( 255, 255, 255 ) );
			surface.SetTextPos( -w / 2, y );
			surface.DrawText( tAcro );

			y = y + h;

			surface.SetFont( "NSS Title 48" );
			local w, h = surface.GetTextSize( tTime );
			surface.SetTextPos( -w / 2, y );
			surface.DrawText( tTime );
		cam.End3D2D();
		
	end

end