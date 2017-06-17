local tab = { };
tab.Name = "Temperature";
tab.Acronym = "TMP";
tab.Teams = { TEAM_ENG, TEAM_OFF };

tab.OnDestroyed = function() end;
tab.DestroyedThink = function() end;

EXPORTS["temperature"] = tab;