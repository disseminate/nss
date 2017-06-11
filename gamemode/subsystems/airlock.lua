local tab = { };
tab.Name = "Airlock Controllers";
tab.Acronym = "ALC";

tab.OnDestroyed = function() end;
tab.DestroyedThink = function() end;

EXPORTS["airlock"] = tab;