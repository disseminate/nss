STATE_PREGAME = 0;
STATE_GAME = 1;
STATE_POSTGAME = 2;

STATE_TIMES = {
	[STATE_PREGAME] = 10,
	[STATE_GAME] = 600,
	[STATE_POSTGAME] = 30
};

SUBSYSTEMS = {
	{ "ELE", "Electrical" },
	{ "OXY", "Oxygen" },
	{ "TMP", "Temperature" },
	{ "RAD", "Radiation Shielding" },
	{ "GRV", "Gravity Generators" },
	{ "ALC", "Airlock Controllers" },
	{ "ATM", "Atmospheric Shielding" },
	{ "WRP", "Warp Regulators" },
	{ "ENG", "Engine Reactors" },
	{ "BRG", "Bridge" },
	{ "VAC", "Vacuum Protection" },
	{ "AEL", "Anti-Electrostatics" },
	{ "TRM", "Terminal Controllers" }
};
