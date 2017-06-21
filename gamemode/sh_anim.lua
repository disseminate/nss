function GM:CalcMainActivity( ply, vel )

	local c, s = self.BaseClass:CalcMainActivity( ply, vel );
	
	if( ply.Powerup == "rocketboots" and c == ACT_MP_RUN ) then
		c = ACT_HL2MP_RUN_CHARGING;
	end

	--return ACT_HL2MP_IDLE_DUEL, -1;

	return c, s;

end