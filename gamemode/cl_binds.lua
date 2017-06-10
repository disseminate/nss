function GM:PlayerBindPress( ply, bind, down )

	if( down ) then
		
		if( bind == "+jump" and !LocalPlayer().Joined ) then

			LocalPlayer().Joined = true;
			net.Start( "nJoin" );
			net.SendToServer();

		end

	end

end