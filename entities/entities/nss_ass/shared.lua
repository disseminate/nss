ENT.Base = "base_anim";
ENT.Type = "anim";

function ENT:Initialize()

	self:SetModel( "models/props_c17/gaspipes006a.mdl" );

	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );

	if( SERVER ) then

		local phys = self:GetPhysicsObject();
		if( phys and phys:IsValid() ) then

			phys:EnableMotion( false );

		end

	else

		self:SetRenderBounds( Vector( -256, -256, -256 ), Vector( 256, 256, 256 ) );

	end

end
