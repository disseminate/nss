local tab = { };
tab.Name = "Gravity Generator";
tab.Desc = "Ignore the effects of low-gravity.";
tab.Ingredients = { "metal", "metal", "circuitry", "interface" };

tab.OnCreate = function( ply )

	ply:SetGravity( 1 );

end

EXPORTS["gravitygenerator"] = tab;