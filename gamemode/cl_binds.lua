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
		
				chat.AddText( Color( 255, 255, 255 ), "You can't change your team during the game!" );

			end

		end

	end

	return self.BaseClass:PlayerBindPress( ply, bind, down );

end

function GM:ChatText( idx, name, text, type )

	if( type == "servermsg" ) then return true end

end