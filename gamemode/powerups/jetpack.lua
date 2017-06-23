local tab = { };
tab.Name = "Jetpack";
tab.Desc = "Click to leap in a direction.";
tab.Ingredients = { "fuel", "fuel", "fuel", "metal" };

tab.MouseDown = function( ply, mv, cmd )

	if( !ply.NextJetpack ) then
		ply.NextJetpack = CurTime();
	end

	if( CurTime() >= ply.NextJetpack ) then
		ply.NextJetpack = CurTime() + 1.5;

		cmd:ClearButtons();
		cmd:ClearMovement();
		mv:SetVelocity( ply:GetAimVector() * 800 );

		if( SERVER ) then
			
			ply:EmitSound( Sound( "ambient/machines/machine1_hit" .. math.random( 1, 2 ) .. ".wav" ), 80, math.random( 90, 110 ) );

			net.Start( "nJetpackEffect" );
				net.WriteEntity( ply );
			net.SendPVS( ply:GetPos() );

		end

	end

end

tab.DrawHUD = function()
	
	if( LocalPlayer().NextJetpack and CurTime() < LocalPlayer().NextJetpack ) then

		surface.DrawProgressCircle( ScrW() / 2, ScrH() / 2, ( LocalPlayer().NextJetpack - CurTime() ) / 1.5, 16 );

	end

end

if( CLIENT ) then

	net.Receive( "nJetpackEffect", function( len )

		local ply = net.ReadEntity();

		local ed = EffectData();
		ed:SetEntity( ply );
		ed:SetNormal( ply:GetAimVector() * -1 );
		ed:SetMagnitude( 32 );
		util.Effect( "nss_rocket", ed );

	end );

else

	util.AddNetworkString( "nJetpackEffect" );

end

EXPORTS["jetpack"] = tab;