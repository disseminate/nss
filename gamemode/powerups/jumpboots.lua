local tab = { };
tab.Name = "Jump Boots";
tab.Desc = "Lets you jump higher.";
tab.Ingredients = { "metal", "circuitry", "circuitry", "fuel" };

tab.JumpMul = 3.5;

tab.OnJump = function( ply )

	if( SERVER ) then
		
		ply:EmitSound( Sound( "ambient/machines/machine1_hit" .. math.random( 1, 2 ) .. ".wav" ), 80, math.random( 90, 110 ) );

	end

end

EXPORTS["jumpboots"] = tab;