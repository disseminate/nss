local tab = { };
tab.Name = "Temperature";
tab.Acronym = "TMP";

tab.OnDestroyed = function() end;
tab.DestroyedThink = function() end;

EXPORTS["temperature"] = tab;