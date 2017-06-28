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
	self.MapSettingsPanel:DockPadding( 10, 34, 10, 10 );

	local b = self:CreateButton( self.MapSettingsPanel, BOTTOM, 0, 30, I18( "map_editor_clear_all" ), "NSS 18", function()

		self:CreateConfirm( "Are you sure? All map entities will be removed.", function()
			net.Start( "nMapEditorClear" );
			net.SendToServer();
		end );

	end );
	b:DockMargin( 0, 50, 0, 0 );
	b:SetBackgroundColor( self:GetSkin().COLOR_LOSE );

	local b = self:CreateButton( self.MapSettingsPanel, TOP, 0, 50, I18( "map_editor_update_cam_pos" ), "NSS 18", function()

		net.Start( "nSetMapEditorCamera" );
		net.SendToServer();

		chat.AddText( self:GetSkin().COLOR_WHITE, I18( "map_editor_updated_cam_pos" ) );

	end );

end