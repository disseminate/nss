GM.IntroCam = { };
GM.IntroCam["nss_test"] = { Vector( 364, 430, 338 ), Angle( 25, -128, 0 ) };
GM.IntroCam["nss_infalliable"] = { Vector( -4613, -2872, 695 ), Angle( 5, 45, 0 ) };

local function nSendMapInfo( len )

	local pos = net.ReadVector();
	local ang = net.ReadAngle();

	if( pos != Vector() or ang != Angle() ) then
		GAMEMODE.IntroCam[game.GetMap()] = { pos, ang };
	end

end
net.Receive( "nSendMapInfo", nSendMapInfo );