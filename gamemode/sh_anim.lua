function GM:CalcMainActivity( ply, vel )

	local c, s = self.BaseClass:CalcMainActivity( ply, vel );

	--return ACT_HL2MP_IDLE_DUEL, -1;

	return c, s;

end