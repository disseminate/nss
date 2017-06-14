local tab = { };
tab.Name = "Anti-Electrostatics";
tab.Acronym = "FRI";

tab.OnDestroyed = function()

	if( SERVER ) then
		
		game.ConsoleCommand( "sv_friction 1\n" );

	end

end;
tab.Restore = function()

	if( SERVER ) then
		
		game.ConsoleCommand( "sv_friction 8\n" );

	end

end;

EXPORTS["electrostatics"] = tab;