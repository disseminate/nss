STATE_PREGAME = 0;
STATE_GAME = 1;
STATE_POSTGAME = 2;
STATE_LOST = 3;

STATE_TIMES = {
	[STATE_PREGAME] = 10,
	[STATE_GAME] = 360,
	[STATE_POSTGAME] = 30
};

SUBSYSTEM_STATE_GOOD = 0;
SUBSYSTEM_STATE_DANGER = 1;
SUBSYSTEM_STATE_BROKEN = 2;

TASK_MASH = 0;
TASK_ALTERNATE = 1;
TASK_ROW = 2;

STAT_TERMINALS = 0;
STAT_DMG = 1;

TEAM_ENG = 1;
TEAM_PRO = 2;
TEAM_OFF = 3;
TEAM_UNJOINED = 999;

team.SetUp( TEAM_ENG, "Engineers", Color( 255, 33, 26 ), true );
team.SetUp( TEAM_PRO, "Programmers", Color( 52, 119, 255 ), true );
team.SetUp( TEAM_OFF, "Officers", Color( 255, 176, 62 ), true );
team.SetUp( TEAM_UNJOINED, "Unconnected", Color( 180, 180, 180 ), false );
