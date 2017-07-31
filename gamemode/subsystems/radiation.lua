local tab = { };
tab.Name = "Radiation";
tab.Acronym = "RAD";
tab.Desc = "Prevents solar radiation and wind from penetrating the ship.";
tab.Teams = { TEAM_PRO };

tab.DestroyedPlayerSpeed = function( ply )

	return 0.7;
	
end

EXPORTS["radiation"] = tab;