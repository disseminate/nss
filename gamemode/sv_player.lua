local meta = FindMetaTable( "Player" );

function GM:PlayerLoadout( ply )

	

end

function GM:PlayerInitialSpawn( ply )

	self.BaseClass:PlayerInitialSpawn( ply );

	ply.Joined = false;

	ply:SendPlayers();
	ply:SendState();
	ply:SendShipHealth();
	ply:ResetAllStats();
	ply:SendMapEditMode();
	ply:SendCameraInfo();

	ply:SetTeam( TEAM_UNJOINED );

	ply:SetCustomCollisionCheck( true );

	for k, v in pairs( self.Subsystems ) do

		if( self.SubsystemStates[k] == SUBSYSTEM_STATE_BROKEN and v.OnDestroyedPlayerJoin ) then

			v.OnDestroyedPlayerJoin( ply );

		end

	end

	for _, v in pairs( player.GetAll() ) do

		if( v.Powerup ) then

			net.Start( "nSetPowerup" );
				net.WriteEntity( v );
				net.WriteString( v.Powerup );
			net.Send( ply );

		end

	end

end

function GM:PlayerSpawn( ply )

	player_manager.SetPlayerClass( ply, "nss" );

	ply:UnSpectate();

	ply:SetupHands();

	player_manager.OnPlayerSpawn( ply );
	player_manager.RunClass( ply, "Spawn" );
	hook.Call( "PlayerSetModel", GAMEMODE, ply );

	ply:SetColorToTeam();

	if( ply:IsBot() and !ply.Joined ) then

		ply.Joined = true;

		ply:SetTeamAuto();
		ply:SetColorToTeam();
		ply:ClearInventory();

	end
	
	if( ply.Powerup ) then
		ply.Powerup = nil;

		net.Start( "nClearPowerup" );
			net.WriteEntity( ply );
		net.Broadcast();
	end

end
util.AddNetworkString( "nClearPowerup" );
util.AddNetworkString( "nShowItemPanel" );

function GM:PlayerDeathThink( ply )

	if( ply.NextSpawnTime && ply.NextSpawnTime > CurTime() ) then return end

	if( ply:IsBot() or ply:KeyPressed( IN_ATTACK ) or ply:KeyPressed( IN_ATTACK2 ) or ply:KeyPressed( IN_JUMP ) ) then
	
		ply:Spawn();

		net.Start( "nShowItemPanel" );
		net.Send( ply );
	
	end
	
end

function meta:SetColorToTeam()

	local col = team.GetColor( self:Team() );
	self:SetPlayerColor( Vector( col.r / 255, col.g / 255, col.b / 255 ) );

end

local function nJoin( len, ply )

	if( !ply.Joined ) then
		ply.Joined = true;

		ply:SetTeamAuto();
		ply:SetColorToTeam();
		ply:ClearInventory();

		net.Start( "nJoin" );
			net.WriteEntity( ply );
		net.Broadcast();

		if( #player.GetJoined() == 1 ) then
			GAMEMODE:ResetState();
		end
	end

end
net.Receive( "nJoin", nJoin );
util.AddNetworkString( "nJoin" );

function meta:SendPlayers()

	net.Start( "nPlayers" );
		net.WriteUInt( #player.GetAll(), 7 );
		for _, v in pairs( player.GetAll() ) do

			net.WriteEntity( v );
			net.WriteBool( v.Joined );

		end
	net.Send( self );

end
util.AddNetworkString( "nPlayers" );

function meta:SendShipHealth()

	net.Start( "nSetShipHealth" );
		net.WriteUInt( GAMEMODE.ShipHealth, MaxUIntBits( SHIP_HEALTH ) );
	net.Send( self );

end

function GM:PlayerDeath( ply, inflictor, attacker )

	self.BaseClass:PlayerDeath( ply, inflictor, attacker );
	ply.NextSpawnTime = CurTime() + 20;

	local r = 0;

	local cam = false;
	if( inflictor:GetClass() == "nss_func_space" ) then
		cam = true;
		r = 1;
	elseif( inflictor:GetClass() == "nss_terminal" ) then
		r = 2;
	end

	net.Start( "nSetSpawnTime" );
		net.WriteFloat( ply.NextSpawnTime );
		net.WriteUInt( r, 4 );
		net.WriteBool( cam );
	net.Send( ply );

end
util.AddNetworkString( "nSetSpawnTime" );

function GM:PlayerShouldTakeDamage( ply, attacker )

	return self:GetState() == STATE_GAME;

end

function GM:ScalePlayerDamage( ply, hg, dmg )

	if( ply.Powerup and self.Powerups[ply.Powerup].DamageMul ) then
		dmg:ScaleDamage( self.Powerups[ply.Powerup].DamageMul );
	end

	ply:AddToStat( STAT_DMG, dmg:GetDamage() );

	return self.BaseClass:ScalePlayerDamage( ply, hg, dmg );

end

function meta:BroadcastStats()

	net.Start( "nBroadcastStats" );
		net.WriteEntity( self );
		for i = STAT_TERMINALS, STAT_DMG do
			net.WriteUInt( self:GetStat( i ), 16 );
		end
	net.Broadcast();

end
util.AddNetworkString( "nBroadcastStats" );

function GM:GetFallDamage( ply, speed )

	return 0;

end

function GM:PlayerSwitchFlashlight( ply, enabled )

	if( enabled and !ply.Joined ) then return false end

	return true;

end

util.AddNetworkString( "nSetGestureTyping" );

function GM:CanPlayerSuicide( ply )

	return !self.MapEditMode;

end