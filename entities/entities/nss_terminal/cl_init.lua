include( "shared.lua" );

ENT.SpriteMat = Material( "nss/sprites/glow01" );

function ENT:Draw()

	self:DrawModel();

	if( #player.GetJoined() == 0 ) then return end
	if( GAMEMODE:GetState() != STATE_GAME ) then return end

	if( self:IsDamaged() ) then

		local tl = self:GetExplodeDuration() - ( CurTime() - self:GetStartTime() );
		local id = self:GetSubsystem();
		local ss = GAMEMODE.Subsystems[id];

		local fps = math.Clamp( 1 - ( CurTime() - self:GetStartTime() ) / self:GetExplodeDuration(), 0.01, 1 );

		if( self.LightOn == nil ) then
			self.LightOn = false;
			self.NextLightToggle = CurTime();
		end

		if( self.NextLightToggle and CurTime() >= self.NextLightToggle ) then
			self.NextLightToggle = CurTime() + fps;
			self.LightOn = !self.LightOn;
		end

		if( self.LightOn ) then

			render.SetMaterial( self.SpriteMat );
			render.DrawSprite( self:GetPos() + self:GetUp() * 48 + self:GetForward() * 4, 16, 16, Color( 255, 0, 0 ) );

		end

		local cang = self:GetAngles();
		cang:RotateAroundAxis( self:GetUp(), 90 );
		cang:RotateAroundAxis( self:GetRight(), -90 );

		cam.Start3D2D( self:GetPos() + self:GetUp() * 90 + self:GetForward() * -20, cang, 0.125 );
			surface.DrawProgressCircle( 0, 32, ( CurTime() - self:GetStartTime() ) / self:GetExplodeDuration(), 100 );

			surface.SetFont( "NSS Title 32" );

			local tAcro = ss.Acronym;
			local tTime = math.ceil( tl );
			local w, h = surface.GetTextSize( tAcro );

			local y = -h / 2;

			surface.SetTextColor( Color( 255, 255, 255 ) );
			surface.SetTextPos( -w / 2, y );
			surface.DrawText( tAcro );

			y = y + h;

			surface.SetFont( "NSS Title 64" );
			local w, h = surface.GetTextSize( tTime );
			surface.SetTextPos( -w / 2, y );
			surface.DrawText( tTime );
		cam.End3D2D();
		
	end

end