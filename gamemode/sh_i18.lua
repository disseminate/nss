GM.Languages = RequireDir( "i18" );

local l = GetConVarString( "gmod_language" );

if( l and GM.Languages[l] ) then
	GM.Language = GM.Languages[l];
else
	GM.Language = GM.Languages["en"];
end

function I18( str, ... )

	local tabReplace = { ... };
	local s;
	if( GAMEMODE ) then
		s = GAMEMODE.Language[str] or str;
	elseif( GM ) then
		s = GM.Language[str] or str;
	end

	for i = 1, 9 do

		if( tabReplace[i] ) then
			s = string.Replace( s, "$" .. i, tabReplace[i] );
			s = string.Replace( s, "@" .. i, string.ToMinutesSeconds( tabReplace[i] ) );
		end

	end

	return s;

end

team.SetUp( TEAM_ENG, I18( "team_engineers" ), Color( 255, 33, 26 ), true );
team.SetUp( TEAM_PRO, I18( "team_programmers" ), Color( 52, 119, 255 ), true );
team.SetUp( TEAM_OFF, I18( "team_officers" ), Color( 255, 176, 62 ), true );
team.SetUp( TEAM_UNJOINED, I18( "team_unconnected" ), Color( 180, 180, 180 ), false );