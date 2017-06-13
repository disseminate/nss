AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );
include( "shared.lua" );

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

	if( #player.GetJoined() == 0 ) then return end
	if( GAMEMODE:GetState() != STATE_GAME ) then return end

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

	self:ProblemSolve();

	--GAMEMODE:DamageShip( self:GetSubsystem() );

	--self:Remove();

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

function ENT:UpdateTransmitState()

	if( GAMEMODE:GetState() != STATE_GAME ) then return TRANSMIT_PVS; end
	return TRANSMIT_ALWAYS;

end