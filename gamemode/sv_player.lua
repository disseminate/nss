local meta = FindMetaTable( "Player" );

function GM:PlayerLoadout( ply )

	

end

function GM:PlayerInitialSpawn( ply )

	self.BaseClass:PlayerInitialSpawn( ply );

	ply.Joined = false;

	ply:SendPlayers();
	ply:SendState();
	ply:SendShipHealth();

	for k, v in pairs( self.Subsystems ) do

		if( self.SubsystemStates[k] == SUBSYSTEM_STATE_BROKEN and v.OnDestroyedPlayerJoin ) then

			v.OnDestroyedPlayerJoin( ply );

		end

	end

end

local function nJoin( len, ply )

	if( !ply.Joined ) then
		ply.Joined = true;

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
		net.WriteUInt( GAMEMODE.ShipHealth, 4 );
	net.Send( self );

end
