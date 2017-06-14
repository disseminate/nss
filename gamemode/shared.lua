DeriveGamemode( "base" );

function RequireDir( dir )

	local files = file.Find( GM.Folder .. "/gamemode/" .. dir .. "/*.lua", "GAME" );
	if( CLIENT ) then
		files = file.Find( GM.FolderName .. "/gamemode/" .. dir .. "/*.lua", "LUA" );
	end

	EXPORTS = { };

	for _, v in pairs( files ) do

		include( dir .. "/" .. v );

		if( SERVER ) then

			AddCSLuaFile( dir .. "/" .. v );

		end

	end

	return EXPORTS;

end

function ScreenShake( size )

	local amp, freq, dur;
	if( size == 1 ) then
		amp = 2;
		freq = 10;
		dur = 1;
	elseif( size == 2 ) then
		amp = 4;
		freq = 10;
		dur = 2;
	else
		amp = 10;
		freq = 10;
		dur = 3;
	end

	util.ScreenShake( Vector(), amp, freq, dur, 32768 );

end