function GM:PostDraw2DSkyBox()

	render.OverrideDepthEnable( true, false );

	for k, v in pairs( self.Subsystems ) do

		if( self.SubsystemStates[k] == SUBSYSTEM_STATE_BROKEN and v.DestroyedPostDrawSkybox ) then

			v.DestroyedPostDrawSkybox();

		end

	end

	render.OverrideDepthEnable( false, false );

end

function GM:PrePlayerDraw( ply )

	if( !ply:IsBot() ) then
		if( !ply.Joined ) then return true end
	end

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

function GM:SetupWorldFog()

	if( self:GetState() != STATE_LOSE and LocalPlayer().JOINED ) then

		if( self:ASSTriggered() ) then

			if( !self.FogStart ) then
				self.FogStart = CurTime();
			end

			local max = 0.1;
			if( self:SubsystemBroken( "electrical" ) ) then
				max = 0.07;
			end
			local d = math.Clamp( max * ( CurTime() - self.FogStart ) / 3, 0, max );

			render.FogMode( MATERIAL_FOG_LINEAR );
			render.FogStart( 128 );
			render.FogEnd( 4096 );
			render.FogMaxDensity( d );
			render.FogColor( 200, 220, 255 );

		else

			self.FogStart = nil;

		end

		return true;

	else

		self.FogStart = nil;

	end

end

function GM:SetupSkyboxFog()

	return self:SetupWorldFog();

end