local tab = { };
tab.Name = "Oxygen";
tab.Acronym = "OXY";
tab.Teams = { TEAM_ENG };

tab.ASS = true;
tab.DamageType = DMG_GENERIC;

tab.OnDestroyed = function() end;
tab.DestroyedThink = function() end;

EXPORTS["oxygen"] = tab;