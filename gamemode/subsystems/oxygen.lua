local tab = { };
tab.Name = "Oxygen";
tab.Acronym = "OXY";
tab.Desc = "Controls oxygen dispensers on the ship. Destruction results in compromise of life support.";
tab.Teams = { TEAM_ENG };

tab.ASS = true;
tab.DamageType = DMG_GENERIC;

tab.OnDestroyed = function() end;
tab.DestroyedThink = function() end;

EXPORTS["oxygen"] = tab;