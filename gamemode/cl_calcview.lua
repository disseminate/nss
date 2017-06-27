function GM:CalcView( ply, origin, angles, fov, znear, zfar )

	local tab = table.Copy( self.BaseClass:CalcView( ply, origin, angles, fov, znear, zfar ) );

	local intro = self.IntroCam[game.GetMap()];

	if( !LocalPlayer().Joined and intro ) then
		
		tab.origin = intro[1];
		tab.angles = intro[2];

	elseif( LocalPlayer().DeadThirdCam and !LocalPlayer():Alive() and intro ) then

		tab.origin = intro[1];
		tab.angles = intro[2];
		self.CamZoomStart = CurTime();

	else

		if( self:GetState() == STATE_LOST and self.OutroStart and intro ) then
		
			local perc = math.EaseInOut( math.Clamp( CurTime() - self.OutroStart, 0, 2 ) / 2, 0, 1 );
			tab.origin = LerpVector( perc, origin, intro[1] );
			tab.angles = LerpAngle( perc, angles, intro[2] );
			self.CamZoomStart = CurTime();
			
		elseif( ply.TerminalSolveActive and ply.TerminalSolveEnt and ply.TerminalSolveEnt:IsValid() ) then

			local ang = ( ply.TerminalSolveEnt:GetPos() - ply:EyePos() ):Angle();
			tab.origin = tab.origin + Angle( 0, ang.y, 0 ):Forward() * -40;
			tab.origin = tab.origin + Angle( 0, ang.y, 0 ):Right() * -40;
			tab.origin = tab.origin + Angle( 0, ang.y, 0 ):Up() * 30;

			tab.angles = ( ply:EyePos() - tab.origin ):Angle();

			tab.angles:RotateAroundAxis( tab.angles:Forward(), math.sin( CurTime() * 1 ) * 0.5 );
			tab.angles:RotateAroundAxis( tab.angles:Right(), math.cos( CurTime() * 1 ) * 0.5 );

		elseif( ply.Workbench and ply.WorkbenchEnt and ply.WorkbenchEnt:IsValid() ) then

			local ang = ( ply.WorkbenchEnt:GetPos() - ply:EyePos() ):Angle();
			tab.origin = tab.origin + Angle( 0, ang.y, 0 ):Forward() * -40;
			tab.origin = tab.origin + Angle( 0, ang.y, 0 ):Right() * -40;
			tab.origin = tab.origin + Angle( 0, ang.y, 0 ):Up() * 30;

			tab.angles = ( ply:EyePos() - tab.origin ):Angle();

			tab.angles:RotateAroundAxis( tab.angles:Forward(), math.sin( CurTime() * 1 ) * 0.5 );
			tab.angles:RotateAroundAxis( tab.angles:Right(), math.cos( CurTime() * 1 ) * 0.5 );

		elseif( intro ) then

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
	if( ply.TerminalSolveActive ) then return true end
	if( ply.Workbench ) then return true end
	
	return self.BaseClass:ShouldDrawLocalPlayer( ply );

end