local function nMapEditMode( len )

	local b = net.ReadBool();
	GAMEMODE.MapEditMode = b;

	if( !b ) then

		if( GAMEMODE.MapSettingsPanel and GAMEMODE.MapSettingsPanel:IsValid() ) then
			GAMEMODE.MapSettingsPanel:FadeOut();
		end

	end

	GAMEMODE:UpdateItemHUD();

end
net.Receive( "nMapEditMode", nMapEditMode );

function GM:CreateMapSettings()

	if( self.MapSettingsPanel and self.MapSettingsPanel:IsValid() ) then
		self.MapSettingsPanel:FadeOut();
	end

	self.MapSettingsPanel = self:CreateFrame( "Map Settings", 300, 600 );
	local b = self:CreateButton( self.MapSettingsPanel, BOTTOM, 0, 50, I18( "map_editor_update_cam_pos" ), "NSS 18", function()

		net.Start( "nSetMapEditorCamera" );
		net.SendToServer();

		chat.AddText( self:GetSkin().COLOR_WHITE, I18( "map_editor_updated_cam_pos" ) );

	end );

end