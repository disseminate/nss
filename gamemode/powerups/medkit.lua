local tab = { };
tab.Name = "Medkit";
tab.Desc = "Take 1/3 as much damage.";
tab.Ingredients = { "interface", "interface", "circuitry", "interface" };

tab.DamageMul = 0.333;

EXPORTS["medkit"] = tab;