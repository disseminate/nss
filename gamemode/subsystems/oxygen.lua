local tab = { };
tab.Name = "Oxygen";
tab.Acronym = "OXY";
tab.Teams = { TEAM_ENG };

tab.OnDestroyed = function() end;
tab.DestroyedThink = function() end;

EXPORTS["oxygen"] = tab;