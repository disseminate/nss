ENT.Base = "base_anim";
ENT.Type = "anim";

function ENT:SetupDataTables()

	self:NetworkVar( "String", 0, "Subsystem" );
	self:NetworkVar( "Float", 0, "ExplodeDuration" );
	self:NetworkVar( "Float", 1, "StartTime" );

end

function ENT:IsDamaged()

	return self:GetExplodeDuration() > 0 and ( CurTime() - self:GetStartTime() ) < self:GetExplodeDuration();

end