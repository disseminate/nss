local meta = FindMetaTable( "Player" );

local function nChangeTeam( len, ply )

	if( !ply.Joined ) then return end
	if( GAMEMODE:GetState() == STATE_GAME ) then return end

	local targ = net.ReadUInt( 4 );

	if( GAMEMODE:CanChangeTeam( ply:Team(), targ ) ) then

		ply:SetTeam( targ );
		ply:SetColorToTeam();

		net.Start( "nChangedTeam" );
			net.WriteUInt( targ, 4 );
		net.Send( ply );

	else

		net.Start( "nChangeTeamError" );
			net.WriteUInt( targ, 4 );
		net.Send( ply );

	end

end
net.Receive( "nChangeTeam", nChangeTeam );
util.AddNetworkString( "nChangeTeam" );
util.AddNetworkString( "nChangedTeam" );
util.AddNetworkString( "nChangeTeamError" );

function meta:SetTeamAuto( noMsg )

	local eng = #team.GetPlayers( TEAM_ENG );
	local pro = #team.GetPlayers( TEAM_PRO );
	local off = #team.GetPlayers( TEAM_OFF );

	local lowest = TEAM_ENG;
	if( pro < eng ) then
		lowest = TEAM_PRO;
	end
	if( off < eng and off < pro ) then
		lowest = TEAM_OFF;
	end

	self:SetTeam( lowest );

	if( !noMsg ) then

		net.Start( "nSetTeamAuto" );
			net.WriteUInt( lowest, 4 );
		net.Send( self );

	end

end
util.AddNetworkString( "nSetTeamAuto" );

function GM:AreTeamsUnbalanced()

	return !self:CanChangeTeam();

end

function GM:CanChangeTeam( cur, targ )

	local eng = #team.GetPlayers( TEAM_ENG );
	local pro = #team.GetPlayers( TEAM_PRO );
	local off = #team.GetPlayers( TEAM_OFF );

	if( cur and targ ) then

		if( cur == TEAM_ENG ) then eng = eng - 1 end
		if( cur == TEAM_PRO ) then pro = pro - 1 end
		if( cur == TEAM_OFF ) then off = off - 1 end

		if( targ == TEAM_ENG ) then eng = eng + 1 end
		if( targ == TEAM_PRO ) then pro = pro + 1 end
		if( targ == TEAM_OFF ) then off = off + 1 end

	end

	local d1 = math.abs( eng - pro );
	if( d1 > 1 ) then return false end

	local d2 = math.abs( eng - off );
	if( d2 > 1 ) then return false end

	local d3 = math.abs( pro - off );
	if( d3 > 1 ) then return false end

	return true;

end

function GM:RebalanceTeams()

	for _, v in pairs( player.GetAll() ) do

		v:SetTeam( TEAM_UNJOINED );

	end

	for _, v in pairs( player.GetAll() ) do

		v:SetTeamAuto( true );
		v:SetColorToTeam();

		net.Start( "nSetTeamAutoRebalance" );
			net.WriteUInt( v:Team(), 4 );
		net.Send( v );

	end

end
