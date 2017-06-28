AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );
include( "shared.lua" );

function ENT:Use( ply )

	if( GAMEMODE:GetState() == STATE_GAME ) then

		net.Start( "nOpenWorkbench" );
			net.WriteEntity( self );
		net.Send( ply );

	end

end

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS;

end

util.AddNetworkString( "nOpenWorkbench" );