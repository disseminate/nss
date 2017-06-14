local function nPlayers( len )

	local n = net.ReadUInt( 7 );

	for i = 1, n do

		local ply = net.ReadEntity();
		ply.Joined = net.ReadBool();

	end

end
net.Receive( "nPlayers", nPlayers );

local function nSetSpawnTime( len )

	local len = net.ReadFloat();
	local r = net.ReadUInt( 4 );
	local cam = net.ReadBool();

	LocalPlayer().NextSpawnTime = len;
	LocalPlayer().DeadReason = r;
	LocalPlayer().DeadThirdCam = cam;

end
net.Receive( "nSetSpawnTime", nSetSpawnTime );

function GM:PlayerButtonDown( ply, i )

	if( self.TerminalSolveActive ) then

		if( self.TerminalSolveMode == TASK_MASH ) then

			if( i == KEY_1 ) then

				self:TerminalIncrement( 0.2 );
				ply:EmitSound( Sound( "ambient/machines/keyboard" .. math.random( 1, 6 ) .. "_clicks.wav" ) );

			end

		elseif( self.TerminalSolveMode == TASK_ALTERNATE ) then

			if( !self.NextTerminalSolveKey ) then
				self.NextTerminalSolveKey = KEY_1;
			end

			if( i == self.NextTerminalSolveKey ) then

				self:TerminalIncrement( 0.4 );
				ply:EmitSound( Sound( "ambient/machines/keyboard" .. math.random( 1, 6 ) .. "_clicks.wav" ) );

				if( self.NextTerminalSolveKey == KEY_1 ) then
					self.NextTerminalSolveKey = KEY_2;
				else
					self.NextTerminalSolveKey = KEY_1;
				end

			end

		elseif( self.TerminalSolveMode == TASK_ROW ) then

			if( !self.NextTerminalSolveKey ) then
				self.NextTerminalSolveKey = KEY_1;
			end

			if( i == self.NextTerminalSolveKey ) then

				self:TerminalIncrement();
				ply:EmitSound( Sound( "ambient/machines/keyboard" .. math.random( 1, 6 ) .. "_clicks.wav" ) );

				if( self.NextTerminalSolveKey == KEY_1 ) then
					self.NextTerminalSolveKey = KEY_2;
				elseif( self.NextTerminalSolveKey == KEY_2 ) then
					self.NextTerminalSolveKey = KEY_3;
				elseif( self.NextTerminalSolveKey == KEY_3 ) then
					self.NextTerminalSolveKey = KEY_4;
				else
					self.NextTerminalSolveKey = KEY_1;
				end

			end

		end

	end

end