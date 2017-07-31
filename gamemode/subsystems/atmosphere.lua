local tab = { };
tab.Name = "Atmospheric Shielding";
tab.Acronym = "SHI";
tab.Desc = "Prevents debris from damaging the exterior.";
tab.Teams = { TEAM_ENG };

tab.DestroyedThink = function()

	if( !SERVER ) then return end

	if( !GAMEMODE.NextAtmShake ) then
		GAMEMODE.NextAtmShake = CurTime();
	end

	if( CurTime() >= GAMEMODE.NextAtmShake ) then
		GAMEMODE.NextAtmShake = CurTime() + math.Rand( 10, 40 );
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

EXPORTS["atmosphere"] = tab;