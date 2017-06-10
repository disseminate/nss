local tab = { };
tab.Name = "Electrical";
tab.Acronym = "ELE";

tab.OnDestroyed = function() end;
tab.DestroyedThink = function() end;

EXPORTS["electrical"] = tab;