resource.AddWorkshop( "959507256" ); -- Main NSS file

WORKSHOP_IDS = { };
WORKSHOP_IDS["gm_lunarbase"] = "337825623";
WORKSHOP_IDS["gm_uplink_facility"] = "600105925";
WORKSHOP_IDS["drp_bahamut"] = "259909876";

if( WORKSHOP_IDS[game.GetMap()] ) then
	resource.AddWorkshop( WORKSHOP_IDS[game.GetMap()] );
end