local tab = { };
tab.Name = "Electrical";
tab.Acronym = "ELE";
tab.Teams = { TEAM_ENG };

tab.OnDestroyed = function()

	for _, v in pairs( ents.FindByName( "ship_light" ) ) do

		v:Fire( "TurnOff" );

	end

	for _, v in pairs( ents.FindByName( "ship_spotlight" ) ) do

		v:Fire( "LightOff" );

	end

	for _, v in pairs( ents.FindByName( "ship_light_prop" ) ) do

		v:SetSkin( 1 );

	end

end;
tab.Restore = function()

	-- handled by game.CleanUpMap()

end;

EXPORTS["electrical"] = tab;