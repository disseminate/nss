function player.GetJoined()

	local tab = { };

	for _, v in pairs( player.GetAll() ) do

		if( v.Joined ) then

			table.insert( tab, v );

		end

	end

	return tab;

end

function GM:StartCommand( ply, cmd )

	if( !ply.Joined ) then
		cmd:ClearButtons();
		cmd:ClearMovement();
	end

	if( self:GetState() == STATE_LOST ) then
		cmd:ClearButtons();
		cmd:ClearMovement();
	end

end

function GM:SetupMove( ply, mv, cmd )

	local mul = 1;
	local jmul = 1;

	for k, v in pairs( self.Subsystems ) do

		if( self.SubsystemStates[k] == SUBSYSTEM_STATE_BROKEN and v.DestroyedPlayerSpeed ) then

			mul = mul * v.DestroyedPlayerSpeed( ply );

		end

		if( self.SubsystemStates[k] == SUBSYSTEM_STATE_BROKEN and v.DestroyedPlayerJump ) then

			mul = mul * v.DestroyedPlayerJump( ply );

		end

	end

	for k, v in pairs( self.Powerups ) do

		if( k == ply.Powerup ) then

			if( v.JumpMul ) then

				jmul = jmul * v.JumpMul;

			end

			if( v.SpeedMul ) then

				mul = mul * v.SpeedMul;

			end

			if( v.OnJump ) then

				if( mv:KeyPressed( IN_JUMP ) and ply:OnGround() ) then

					if( !ply.NextJump ) then ply.NextJump = CurTime(); end
					if( CurTime() >= ply.NextJump ) then
						
						ply.NextJump = CurTime() + 0.1;
						v.OnJump( ply );

					end

				end

			end

			if( v.MouseDown ) then

				if( mv:KeyDown( IN_ATTACK ) ) then

					v.MouseDown( ply, mv, cmd );

				end

			end

		end

	end

	local run = mul * 400;
	local walk = mul * 200;
	local jump = jmul * 200;

	if( ply:GetWalkSpeed() != walk ) then
		ply:SetWalkSpeed( walk );
	end

	if( ply:GetRunSpeed() != run ) then
		ply:SetRunSpeed( run );
	end

	if( ply:GetJumpPower() != jump ) then
		ply:SetJumpPower( jump );
	end

end

function GM:ShouldCollide( e1, e2 )

	if( e1:IsPlayer() and e2:IsPlayer() ) then return false end

	return self.BaseClass:ShouldCollide( e1, e2 );

end

function GM:PlayerButtonDown( ply, i )

	if( CLIENT and IsFirstTimePredicted() and ply:Alive() and !self.MapEditMode ) then

		ply:CheckInventory();

		-- Needs to be clientside to check for this:
		if( !ply.Workbench ) then

			if( !ply.NextItemThrow or ( ply.NextItemThrow and CurTime() >= ply.NextItemThrow ) ) then
				
				if( i >= KEY_1 and i <= KEY_6 ) then

					local n = i - KEY_1 + 1;

					if( ply.Inventory[n] ) then

						net.Start( "nDropInventory" );
							net.WriteUInt( n, MaxUIntBits( INV_SIZE ) );
						net.SendToServer();

						ply.Inventory[n] = nil;

						self:UpdateItemHUD();

						self:SetHint( "inv_throw" );

					end

				end

			end

		end

	end

	if( self.MapEditMode and ply:Alive() and ply.Joined and ply:IsSuperAdmin() ) then

		if( i >= KEY_1 and i <= KEY_6 ) then

			local n = i - KEY_1 + 1;

			if( SERVER ) then
				ply:CreateMapEnt( n );
			elseif( IsFirstTimePredicted() ) then
				if( n == 6 ) then
					self:CreateMapSettings();
				end
			end

		end

	end

end