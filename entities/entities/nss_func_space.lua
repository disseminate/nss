ENT.Base = "base_brush";
ENT.Type = "brush";

function ENT:Initialize()

	self:SetTrigger( true );

end

function ENT:PassesTriggerFilters( ent )

	return ent:IsPlayer() and ent:Alive();

end

function ENT:StartTouch( ply )

	local dmg = DamageInfo();
	dmg:SetAttacker( game.GetWorld() );
	dmg:SetInflictor( self );
	dmg:SetDamage( ply:Health() );
	dmg:SetDamageType( DMG_DISSOLVE );
	ply:TakeDamageInfo( dmg );

end