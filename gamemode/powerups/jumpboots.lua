local tab = { };
tab.Name = "Jump Boots";
tab.Desc = "Lets you jump higher.";
tab.Ingredients = { "metal", "circuitry", "circuitry", "fuel" };

tab.JumpMul = 3.5;

tab.OnJump = function( ply )

	if( SERVER ) then
		
		ply:EmitSound( Sound( "ambient/machines/machine1_hit" .. math.random( 1, 2 ) .. ".wav" ), 80, math.random( 90, 110 ) );

		net.Start( "nJumpBoots" );
			net.WriteEntity( ply );
		net.SendPVS( ply:GetPos() );

	end

end

if( CLIENT ) then

	net.Receive( "nJumpBoots", function( len )

		local ply = net.ReadEntity();

		local ed = EffectData();
		ed:SetEntity( ply );
		ed:SetNormal( Vector( 0, 0, -1 ) );
		ed:SetMagnitude( 0 );
		util.Effect( "nss_rocket", ed );

	end );

else

	util.AddNetworkString( "nJumpBoots" );

end

EXPORTS["jumpboots"] = tab;