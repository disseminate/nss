local tab = { };
tab.Name = "Temperature";
tab.Acronym = "TMP";
tab.Teams = { TEAM_ENG, TEAM_OFF };

tab.ASS = true;
tab.DamageType = DMG_BURN;

tab.OnDestroyed = function() end;
tab.DestroyedThink = function() end;

EXPORTS["temperature"] = tab;