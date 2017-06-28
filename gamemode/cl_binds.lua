function GM:PlayerBindPress( ply, bind, down )

	if( down ) then
		
		if( bind == "+jump" and !LocalPlayer().Joined ) then

			LocalPlayer().Joined = true;
			net.Start( "nJoin" );
			net.SendToServer();

			return true;

		end

		if( bind == "gm_showteam" and LocalPlayer().Joined ) then

			if( self:GetState() != STATE_GAME ) then

				self:ChangeTeamDialogue();
				return true;

			else
		
				chat.AddText( Color( 255, 255, 255 ), I18( "no_change_team_ingame" ) );

			end

		end

		if( bind == "+menu" and LocalPlayer().Joined and LocalPlayer():IsSuperAdmin() and ( self:GetState() != STATE_POSTGAME and self:GetState() != STATE_LOST ) ) then

			net.Start( "nSetMapEditMode" );
				net.WriteBool( !GAMEMODE.MapEditMode );
			net.SendToServer();

			return true;

		end

		if( GAMEMODE.MapEditMode and LocalPlayer().Joined and LocalPlayer():IsSuperAdmin() ) then

			if( bind == "undo" ) then

				net.Start( "nMapEditorUndo" );
				net.SendToServer();

				return true;

			end

			if( bind == "+reload" ) then
				
				net.Start( "nMapEditorEditPos" );
				net.SendToServer();

				return true;

			end

			if( bind == "+attack2" ) then

				net.Start( "nMapEditorRemove" );
				net.SendToServer();

				return true;

			end

			if( bind == "noclip" ) then

				net.Start( "nMapEditorNoclip" );
				net.SendToServer();

				return true;

			end

		end

	end

	return self.BaseClass:PlayerBindPress( ply, bind, down );

end

function GM:ChatText( idx, name, text, type )

	if( type == "servermsg" ) then return true end

end