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

local function nBroadcastStats( len )

	local ply = net.ReadEntity();
	for i = STAT_TERMINALS, STAT_DMG do
		local n = net.ReadUInt( 16 );
		ply:SetStat( i, n );
	end

end
net.Receive( "nBroadcastStats", nBroadcastStats );

function GM:PlayerButtonDown( ply, i )

	if( ply.TerminalSolveActive ) then

		local g = ACT_GMOD_GESTURE_RANGE_FRENZY;

		if( ply.TerminalSolveMode == TASK_MASH ) then

			if( i == KEY_1 ) then

				self:TerminalIncrement( 0.4 );
				ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, g, true );
				ply:EmitSound( Sound( "ambient/machines/keyboard" .. math.random( 1, 6 ) .. "_clicks.wav" ) );

			end

		elseif( ply.TerminalSolveMode == TASK_ALTERNATE ) then

			if( !self.NextTerminalSolveKey ) then
				self.NextTerminalSolveKey = KEY_1;
			end

			if( i == self.NextTerminalSolveKey ) then

				self:TerminalIncrement( 0.7 );
				ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, g, true );
				ply:EmitSound( Sound( "ambient/machines/keyboard" .. math.random( 1, 6 ) .. "_clicks.wav" ) );

				if( self.NextTerminalSolveKey == KEY_1 ) then
					self.NextTerminalSolveKey = KEY_2;
				else
					self.NextTerminalSolveKey = KEY_1;
				end

			end

		elseif( ply.TerminalSolveMode == TASK_ROW ) then

			if( !self.NextTerminalSolveKey ) then
				self.NextTerminalSolveKey = KEY_1;
			end

			if( i == self.NextTerminalSolveKey ) then

				self:TerminalIncrement();
				ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, g, true );
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

	else

		if( IsFirstTimePredicted() ) then

			ply:CheckInventory();

			if( !ply.Workbench ) then

				if( !ply.NextItemThrow or ( ply.NextItemThrow and CurTime() >= ply.NextItemThrow ) ) then
					
					if( i >= KEY_1 and i <= KEY_6 ) then

						local n = i - KEY_1 + 1;

						if( ply.Inventory[n] ) then

							net.Start( "nDropInventory" );
								net.WriteUInt( n, MaxUIntBits( 6 ) );
							net.SendToServer();

							ply.Inventory[n] = nil;

							self:UpdateItemHUD();

						end

					end

				end

			end

		end

	end

end