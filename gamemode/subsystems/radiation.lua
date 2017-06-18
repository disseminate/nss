local tab = { };
tab.Name = "Radiation";
tab.Acronym = "RAD";
tab.Teams = { TEAM_PRO };

tab.DestroyedPlayerSpeed = function( ply )

	return 0.6;
	
end

EXPORTS["radiation"] = tab;