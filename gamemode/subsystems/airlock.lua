local tab = { };
tab.Name = "Airlock Controllers";
tab.Acronym = "ALC";

tab.OnDestroyed = function()

	for _, v in pairs( ents.FindByName( "ship_airlock" ) ) do

		v:Fire( "Open" );

	end

end;
tab.Restore = function()

	-- handled by game.CleanUpMap()

end;

EXPORTS["airlock"] = tab;