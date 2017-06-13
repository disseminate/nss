function GM:CalcView( ply, origin, angles, fov, znear, zfar )

	local tab = table.Copy( self.BaseClass:CalcView( ply, origin, angles, fov, znear, zfar ) );

	local intro = self.IntroCam[game.GetMap()];

	if( intro ) then
		
		if( !LocalPlayer().Joined or self:GetState() == STATE_LOST ) then
			
			tab.origin = intro[1];
			tab.angles = intro[2];

		elseif( LocalPlayer().DeadThirdCam and !LocalPlayer():Alive() ) then

			tab.origin = intro[1];
			tab.angles = intro[2];
			self.CamZoomStart = CurTime();

		else

			if( !self.CamZoomStart ) then
				self.CamZoomStart = CurTime();
			end

			local perc = math.EaseInOut( math.Clamp( CurTime() - self.CamZoomStart, 0, 1 ), 0, 1 );
			if( perc < 1 ) then

				tab.origin = LerpVector( perc, intro[1], origin );
				tab.angles = LerpAngle( perc, intro[2], angles );

			end

		end
		
	end

	return tab;

end

function GM:ShouldDrawLocalPlayer( ply )

	if( !LocalPlayer().Joined ) then return true end
	if( self.CamZoomStart and CurTime() - self.CamZoomStart <= 1 ) then return true end
	if( self:GetState() == STATE_LOST ) then return true end
	
	return self.BaseClass:ShouldDrawLocalPlayer( ply );

end