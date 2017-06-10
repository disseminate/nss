AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );
include( "shared.lua" );

function ENT:Initialize()

	self:SetModel( "models/props_combine/combine_interface00" .. math.random( 1, 3 ) .. ".mdl" );

	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_NONE );
	self:SetSolid( SOLID_VPHYSICS );

	self:SetUseType( SIMPLE_USE );

end

function ENT:SelectRandomProblem()

	local id = table.Random( table.GetKeys( GAMEMODE.Subsystems ) );
	local ss = GAMEMODE.Subsystems[id];

	self:SetSubsystem( id );
	self:SetExplodeDuration( math.Rand( 30, 120 ) );
	self:SetStartTime( CurTime() );

	self:EmitSound( Sound( "npc/attack_helicopter/aheli_damaged_alarm1.wav" ) );

end

function ENT:SelectProblem( id )

	local ss = GAMEMODE.Subsystems[id];

	self:SetSubsystem( id );
	self:SetExplodeDuration( math.Rand( 5, 20 ) );
	self:SetStartTime( CurTime() );

	self:EmitSound( Sound( "npc/attack_helicopter/aheli_damaged_alarm1.wav" ) );

end

function ENT:ProblemSolve()

	GAMEMODE:SetSubsystemState( self:GetSubsystem(), SUBSYSTEM_STATE_GOOD );

	self:SetSubsystem( "" );
	self:SetExplodeDuration( 0 );
	self:SetStartTime( 0 );

end

function ENT:Think()

	if( self:GetStartTime() > 0 ) then

		if( CurTime() >= self:GetStartTime() + self:GetExplodeDuration() ) then
			
			self:Explode(); -- TODO
			--self:ProblemSolve();

		end

	end

end

function ENT:Explode()

	local ed = EffectData();
	ed:SetOrigin( self:GetPos() + Vector( 0, 0, 8 ) );
	util.Effect( "Explosion", ed );

	GAMEMODE:SetSubsystemState( self:GetSubsystem(), SUBSYSTEM_STATE_BROKEN );

	self:Remove();

end

function ENT:Use( ply )

	if( self:IsDamaged() ) then

		-- todo: skill
		self:ProblemSolve();
		self:EmitSound( Sound( "buttons/button5.wav" ) );

	else

		self:EmitSound( Sound( "buttons/button10.wav" ) );

	end

end