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

	for k, v in pairs( self.Subsystems ) do

		if( self.SubsystemStates[k] == SUBSYSTEM_STATE_BROKEN and v.DestroyedPlayerSpeed ) then

			mul = mul * v.DestroyedPlayerSpeed( ply );

		end

	end

	local run = mul * 400;
	local walk = mul * 200;

	if( ply:GetWalkSpeed() != walk ) then
		ply:SetWalkSpeed( walk );
	end

	if( ply:GetRunSpeed() != run ) then
		ply:SetRunSpeed( run );
	end

end