ENT.Base = "base_anim";
ENT.Type = "anim";

function ENT:Initialize()

	self:SetModel( "models/props_combine/combine_interface00" .. math.random( 1, 3 ) .. ".mdl" );

	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );

	if( SERVER ) then

		self:SetUseType( SIMPLE_USE );

		local phys = self:GetPhysicsObject();
		if( phys and phys:IsValid() ) then

			phys:EnableMotion( false );

		end

	end

end

function ENT:SetupDataTables()

	self:NetworkVar( "String", 0, "Subsystem" );
	self:NetworkVar( "Float", 0, "ExplodeDuration" );
	self:NetworkVar( "Float", 1, "StartTime" );

end

function ENT:IsDamaged()

	return self:GetExplodeDuration() > 0 and ( CurTime() - self:GetStartTime() ) < self:GetExplodeDuration();

end