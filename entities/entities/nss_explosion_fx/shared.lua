ENT.Base = "base_anim";
ENT.Type = "anim";

function ENT:Initialize()

	self:SetModel( "models/props_combine/combine_interface00" .. math.random( 1, 3 ) .. ".mdl" );

	self:PhysicsInit( SOLID_NONE );
	self:SetMoveType( MOVETYPE_NONE );
	self:SetSolid( SOLID_NONE );

	if( CLIENT ) then

		self:SetRenderBounds( Vector( -16384, -16384, -16384 ), Vector( 16384, 16384, 16384 ) );

	end

end