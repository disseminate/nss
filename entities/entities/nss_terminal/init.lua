AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );
include( "shared.lua" );

function ENT:SelectRandomProblem()
	
	local id = table.Random( table.GetKeys( GAMEMODE.Subsystems ) );
	local ss = GAMEMODE.Subsystems[id];

	self:SetSubsystem( id );
	self:SetExplodeDuration( math.Rand( 30, 120 ) );
	self:SetStartTime( CurTime() );
	self:SetTerminalSolveMode( math.random( TASK_MASH, TASK_ROW ) );

	self:EmitSound( Sound( "npc/attack_helicopter/aheli_damaged_alarm1.wav" ) );

end

function ENT:SelectProblem( id )

	local ss = GAMEMODE.Subsystems[id];

	self:SetSubsystem( id );
	self:SetExplodeDuration( math.Rand( 300, 1200 ) );
	self:SetStartTime( CurTime() );
	self:SetTerminalSolveMode( math.random( TASK_MASH, TASK_ROW ) );

	self:EmitSound( Sound( "npc/attack_helicopter/aheli_damaged_alarm1.wav" ) );

end

function ENT:ProblemSolve( ply )

	GAMEMODE:SetSubsystemState( self:GetSubsystem(), SUBSYSTEM_STATE_GOOD );

	self:SetSubsystem( "" );
	self:SetExplodeDuration( 0 );
	self:SetStartTime( 0 );

	self:EmitSound( Sound( "buttons/button5.wav" ) );

	if( ply and ply:IsValid() ) then
		ply:EmitSound( Sound( "ambient/machines/keyboard7_clicks_enter.wav" ) );
	end

end

function ENT:Think()

	if( #player.GetJoined() == 0 ) then return end
	if( GAMEMODE:GetState() != STATE_GAME ) then return end

	if( self:GetStartTime() > 0 ) then

		if( CurTime() >= self:GetStartTime() + self:GetExplodeDuration() ) then
			
			self:Explode();

		end

		if( !self.WarningSound ) then
			local rf = RecipientFilter();
			rf:AddAllPlayers();
			self.WarningSound = CreateSound( self, Sound( "ambient/alarms/combine_bank_alarm_loop4.wav" ), rf );
			self.WarningSound:SetSoundLevel( 90 );
			self.WarningSound:PlayEx( 1, math.random( 90, 110 ) );
		elseif( !self.WarningSound:IsPlaying() ) then
			self.WarningSound:Play();
		end

	elseif( self.WarningSound ) then
		self.WarningSound:Stop();
		self.WarningSound = nil;
	end

end

function ENT:OnRemove()

	if( self.WarningSound ) then
		self.WarningSound:Stop();
		self.WarningSound = nil;
	end

end

function ENT:Explode()

	local ed = EffectData();
	ed:SetOrigin( self:GetPos() + Vector( 0, 0, 8 ) );
	util.Effect( "Explosion", ed );

	util.BlastDamage( game.GetWorld(), self, self:GetPos() + Vector( 0, 0, 8 ), 256, 80 );

	self:ProblemSolve();
	--GAMEMODE:DamageShip( self:GetSubsystem() );

	--self:Remove();

end

function ENT:Use( ply )

	if( self:IsDamaged() ) then

		-- todo: skill
		GAMEMODE:StartTerminalSolve( self, ply );
		--self:ProblemSolve();

	else

		self:EmitSound( Sound( "buttons/button10.wav" ) );

	end

end

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS;

end