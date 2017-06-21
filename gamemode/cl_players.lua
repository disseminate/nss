local function nPlayers( len )

	local n = net.ReadUInt( 7 );

	for i = 1, n do

		local ply = net.ReadEntity();
		ply.Joined = net.ReadBool();

	end

end
net.Receive( "nPlayers", nPlayers );

local function nSetSpawnTime( len )

	local len = net.ReadFloat();
	local r = net.ReadUInt( 4 );
	local cam = net.ReadBool();

	LocalPlayer().NextSpawnTime = len;
	LocalPlayer().DeadReason = r;
	LocalPlayer().DeadThirdCam = cam;

end
net.Receive( "nSetSpawnTime", nSetSpawnTime );

local function nBroadcastStats( len )

	local ply = net.ReadEntity();
	for i = STAT_TERMINALS, STAT_DMG do
		local n = net.ReadUInt( 16 );
		ply:SetStat( i, n );
	end

end
net.Receive( "nBroadcastStats", nBroadcastStats );

function GM:NetworkEntityCreated( ent )

	if( ent and ent:IsValid() ) then

		if( ent:IsPlayer() and ent:IsBot() ) then

			ent.Joined = true;

		end

	end

end

local function nSetGesture( len )

	local ent = net.ReadEntity();
	local g = net.ReadUInt( 12 );

	ent:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, g, true );

end
net.Receive( "nSetGesture", nSetGesture );

local function nSetGestureTyping( len )

	local ent = net.ReadEntity();

	ent:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_FRENZY, true );

end
net.Receive( "nSetGestureTyping", nSetGestureTyping );
