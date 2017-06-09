function GM:PlayerLoadout( ply )

	

end

function GM:PlayerInitialSpawn( ply )

	self.BaseClass:PlayerInitialSpawn( ply );

	ply:SendState();

end