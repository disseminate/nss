include( "shared.lua" );

function ENT:Draw()

	if( !self.FireMat ) then
		self.FireMat = Material( "effects/fire_cloud" .. math.random( 1, 2 ) );
	end

	if( !self.RotateSpeed ) then
		self.RotateSpeed = math.Rand( 1, 2 ) * ( math.random( 0, 1 ) * 2 - 1 );
	end
	
	if( GAMEMODE:GetState() == STATE_LOST ) then

		if( !GAMEMODE.OutroStart ) then return end

		local tSince = CurTime() - GAMEMODE.OutroStart;

		if( tSince > 1.5 ) then
			
			local ang = EyeAngles();
			local axis = ( self:GetPos() - EyePos() ):GetNormal();
			ang:RotateAroundAxis( axis, CurTime() * self.RotateSpeed );

			cam.Start3D( EyePos(), ang );
				render.SetMaterial( self.FireMat );
				render.DrawSprite( self:GetPos(), 2048, 2048, Color( 255, 255, 255 ) );
			cam.End3D();

		end

	end

end
