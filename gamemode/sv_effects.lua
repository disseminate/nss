function GM:EffectsThink()

	if( !self.NextShake ) then
		self.NextShake = CurTime() + math.Rand( 4, 10 );
	end

	if( CurTime() >= self.NextShake ) then

		self.NextShake = CurTime() + math.Rand( 4, 10 );

		if( self:GetState() == STATE_GAME ) then

			ScreenShake( math.random( 1, 2 ) );

		end

	end

end