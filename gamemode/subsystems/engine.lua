local tab = { };
tab.Name = "Engine";
tab.Acronym = "ENG";
tab.Desc = "Provides control for main thrusters.";
tab.Teams = { TEAM_ENG, TEAM_PRO, TEAM_OFF };

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

			local tab = player.GetAll();
			table.Merge( tab, ents.FindByClass( "nss_item" ) );

			for _, v in pairs( tab ) do

				if( v:OnGround() ) then

					local a = math.Rand( 0, 2 * math.pi );

					v:SetVelocity( Vector( math.cos( a ) * math.Rand( 0, 1000 ), math.sin( a ) * math.Rand( 0, 1000 ), math.Rand( 100, 600 ) ) );

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