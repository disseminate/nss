ENT.Base = "base_anim";
ENT.Type = "anim";

function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "Subsystem" );
	self:NetworkVar( "Float", 0, "ExplodeTime" );

end

function ENT:Initialize()

	self:SetModel( "models/props_combine/combine_interface00" .. math.random( 1, 3 ) .. ".mdl" );

	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_NONE );
	self:SetSolid( SOLID_VPHYSICS );

end

function ENT:SelectRandomProblem()

	local id = table.Random( table.GetKeys( GAMEMODE.Subsystems ) );
	local ss = GAMEMODE.Subsystems[id];

	self:SetSubsystem( id );
	self:SetExplodeTime( CurTime() + math.Rand( 30, 120 ) );

end

function ENT:ProblemSolve()

	self:SetSubsystem( 0 );
	self:SetSubsystemTime( 0 );

end

function ENT:Think()

	if( self:GetExplodeTime() and self:GetExplodeTime() > 0 ) then

		if( CurTime() > self:GetExplodeTime() ) then
			
			self:Remove();

		end

	end

end