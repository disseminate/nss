ENT.Base = "base_anim";
ENT.Type = "anim";

function ENT:Initialize()

	self:SetModel( "models/props_combine/combine_interface00" .. ( ( self:EntIndex() % 3 ) + 1 ) .. ".mdl" );

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
	self:NetworkVar( "Int", 0, "TerminalSolveMode" );

	self:NetworkVar( "Bool", 0, "NeedsTeam1" ); -- teams
	self:NetworkVar( "Bool", 1, "NeedsTeam2" );
	self:NetworkVar( "Bool", 2, "NeedsTeam3" );

end

function ENT:SetNeedsTeam( team, val )

	return self["SetNeedsTeam" .. team]( self, val );

end

function ENT:GetNeedsTeam( team )

	if( !team ) then return false end
	if( !self["GetNeedsTeam" .. team] ) then return false end
	return self["GetNeedsTeam" .. team]( self );

end

function ENT:IsDamaged()

	return self:GetExplodeDuration() > 0 and self:TimeRemaining() > 0;

end

function ENT:TimeRemaining()
	
	return self:GetExplodeDuration() - ( CurTime() - self:GetStartTime() );

end