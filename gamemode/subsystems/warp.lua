local tab = { };
tab.Name = "Warp";
tab.Acronym = "WRP";

tab.OnDestroyed = function() end;
tab.DestroyedThink = function() end;

EXPORTS["warp"] = tab;