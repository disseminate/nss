local tab = { };
tab.Name = "Gravity Generators";
tab.Acronym = "GRV";

tab.OnDestroyed = function() end;
tab.DestroyedThink = function() end;

EXPORTS["gravity"] = tab;