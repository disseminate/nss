local tab = { };
tab.Name = "Temperature";
tab.Acronym = "TMP";
tab.Desc = "Ensures appropriate human-liveable temperature modulation. Destruction would trigger life-support failure.";
tab.Teams = { TEAM_ENG, TEAM_OFF };

tab.ASS = true;
tab.DamageType = DMG_BURN;

tab.OnDestroyed = function() end;
tab.DestroyedThink = function() end;

EXPORTS["temperature"] = tab;