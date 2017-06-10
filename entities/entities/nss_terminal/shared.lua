ENT.Base = "base_anim";
ENT.Type = "anim";

function ENT:SetupDataTables()

	self:NetworkVar( "String", 0, "Subsystem" );
	self:NetworkVar( "Float", 0, "ExplodeTime" );

end
