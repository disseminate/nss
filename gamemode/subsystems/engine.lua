local tab = { };
tab.Name = "Engine";
tab.Acronym = "ENG";

tab.DestroyedThink = function()

	if( !SERVER ) then return end

	if( !GAMEMODE.NextEngineShake ) then
		GAMEMODE.NextEngineShake = CurTime();
	end

	if( CurTime() >= GAMEMODE.NextEngineShake ) then
		GAMEMODE.NextEngineShake = CurTime() + math.Rand( 10, 40 );
		ScreenShake( math.random( 2, 3 ) );

		if( SERVER ) then

			net.Start( "nEmitExplosionSound" );
			net.Broadcast();

			for _, v in pairs( player.GetAll() ) do

				if( v:OnGround() ) then

					local a = math.Rand( 0, 2 * math.pi );

					v:SetVelocity( Vector( math.cos( a ) * math.Rand( 0, 500 ), math.sin( a ) * math.Rand( 0, 500 ), math.Rand( 100, 300 ) ) );

				end

			end

		end

	end

end;

if( SERVER ) then

	util.AddNetworkString( "nEmitExplosionSound" );

else

	local function nEmitExplosionSound( len )

		EmitSound( Sound( "ambient/explosions/exp" .. math.random( 1, 4 ) .. ".wav" ), LocalPlayer():EyePos(), LocalPlayer():EntIndex(), CHAN_AUTO, 0.3, 120, 0, math.random( 80, 120 ) );

	end
	net.Receive( "nEmitExplosionSound", nEmitExplosionSound );

end

EXPORTS["engine"] = tab;