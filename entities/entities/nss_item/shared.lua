ENT.Base = "base_anim";
ENT.Type = "anim";

function ENT:Initialize()

	self:SetModel( GAMEMODE.Items[self:GetItem()].Model );

	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS );

	self:SetDieTime( CurTime() + 15 );

	if( SERVER ) then

		local phys = self:GetPhysicsObject();
		if( phys and phys:IsValid() ) then

			phys:SetMass( 4 );
			phys:Wake();

		end

		self:SetTrigger( true );
		self:SetUseType( SIMPLE_USE );

	end

end

function ENT:SetupDataTables()

	self:NetworkVar( "String", 0, "Item" );
	self:NetworkVar( "Float", 0, "DieTime" );

end