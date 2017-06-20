local tab = { };
tab.Name = "Gravity Generators";
tab.Acronym = "GRV";
tab.Teams = { TEAM_PRO, TEAM_OFF };

tab.OnDestroyed = function()

	for _, v in pairs( player.GetAll() ) do

		if( v.Powerup != "gravitygenerator" ) then
			
			v:SetGravity( 0.2 );

		end

	end

	physenv.SetGravity( Vector( 0, 0, 0 ) );

end;
tab.OnDestroyedPlayerJoin = function( ply )

	ply:SetGravity( 0.2 );

end;
tab.Restore = function()

	for _, v in pairs( player.GetAll() ) do

		v:SetGravity( 1 );

	end

	physenv.SetGravity( Vector( 0, 0, -600 ) );

end;

EXPORTS["gravity"] = tab;