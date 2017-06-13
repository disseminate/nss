function GM:PostDraw2DSkyBox()

	render.OverrideDepthEnable( true, false );

	for k, v in pairs( self.Subsystems ) do

		if( self.SubsystemStates[k] == SUBSYSTEM_STATE_BROKEN and v.DestroyedPostDrawSkybox ) then

			v.DestroyedPostDrawSkybox();

		end

	end

	render.OverrideDepthEnable( false, false );

end

function GM:SetSkybox( sky )

	local textures = { "bk", "dn", "ft", "lf", "rt", "up" };
	local skyname = GetConVarString( "sv_skyname" );

	for _, v in pairs( textures ) do

		local m = Material( "skybox/" .. skyname .. v );
		m:SetTexture( "$basetexture", "skybox/" .. sky .. v );
		m:Recompute();

	end

end