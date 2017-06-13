local tab = { };
tab.Name = "Warp";
tab.Acronym = "WRP";

local mat;
if( CLIENT ) then
	mat = CreateMaterial( "nss_warp_" .. CurTime(), "UnlitGeneric", {
		["$basetexture"] = "vgui/white",
		["$translucent"] = "1"
	} );
end

tab.DestroyedPostDrawSkybox = function()

	if( !GAMEMODE.NextWarpFlash ) then
		GAMEMODE.NextWarpFlash = CurTime();
	end

	if( CurTime() >= GAMEMODE.NextWarpFlash ) then
		GAMEMODE.NextWarpFlash = CurTime() + math.Rand( 3, 7 );

		GAMEMODE.WarpFlashTime = CurTime();

		GAMEMODE:SetSkybox( "nss_" .. math.random( 1, 3 ) );

		EmitSound( Sound( "ambient/machines/machine1_hit" .. math.random( 1, 2 ) .. ".wav" ), LocalPlayer():EyePos(), LocalPlayer():EntIndex(), CHAN_AUTO, 0.3, 120, 0, math.random( 80, 120 ) );
	end

	if( GAMEMODE.WarpFlashTime ) then
		local t = math.Clamp( CurTime() - GAMEMODE.WarpFlashTime, 0, 0.5 );
		local a = 1 - ( t * 2 );
		
		if( a > 0 ) then
			mat:SetFloat( "$alpha", a );
			render.SetMaterial( mat );
			render.DrawScreenQuad();
		end
	end

end;

tab.Restore = function()

	if( CLIENT ) then
		GAMEMODE:SetSkybox( "nss_1" );
	end

end

EXPORTS["warp"] = tab;