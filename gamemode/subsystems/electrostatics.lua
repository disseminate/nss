local tab = { };
tab.Name = "Anti-Electrostatics";
tab.Acronym = "FRI";
tab.Desc = "Prevents dust particles from coating surfaces. Destruction would lead to decreased friction.";
tab.Teams = { TEAM_PRO };

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