AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );
include( "shared.lua" );

function ENT:SelectRandomProblem()
	
	local id = table.Random( table.GetKeys( GAMEMODE.Subsystems ) );
	self:SelectProblem( id );

end

function ENT:SelectProblem( id )

	local ss = GAMEMODE.Subsystems[id];

	self:SetSubsystem( id );
	self:SetExplodeDuration( math.Rand( 25, 55 ) );
	self:SetStartTime( CurTime() );
	self:SetTerminalSolveMode( math.random( TASK_MASH, TASK_ROW ) );

	for i = 1, 3 do
		if( table.HasValue( ss.Teams, i ) ) then
			self:SetNeedsTeam( i, true );
		end
	end

	self:EmitSound( Sound( "npc/attack_helicopter/aheli_damaged_alarm1.wav" ) );

end

function ENT:ProblemSolve( ply )

	if( ply and ply:IsValid() and self:GetNeedsTeam( ply:Team() ) ) then
		self:SetNeedsTeam( ply:Team(), false );
	end

	local solved = true;
	for i = 1, 3 do
		if( self:GetNeedsTeam( i ) ) then
			solved = false;
			break;
		end
	end

	if( solved ) then
		
		GAMEMODE:SetSubsystemState( self:GetSubsystem(), SUBSYSTEM_STATE_GOOD );

		self:SetSubsystem( "" );
		self:SetExplodeDuration( 0 );
		self:SetStartTime( 0 );

	end

	self:EmitSound( Sound( "buttons/button5.wav" ) );

	if( ply and ply:IsValid() ) then
		ply:EmitSound( Sound( "ambient/machines/keyboard7_clicks_enter.wav" ) );

		self:CreateRandomItem( ply );
	end

end

function ENT:CreateRandomItem( ply )

	local key = table.Random( table.GetKeys( GAMEMODE.Items ) );

	if( ply:InvHasSpace() ) then

		local id = ply:AddItem( key );
		ply:SendInventoryID( id );

	else

		local i = ents.Create( "nss_item" );
		i:SetItem( key );
		i:SetPos( ply:GetPos() + Vector( 0, 0, 32 ) );
		i:SetAngles( Angle( math.Rand( -180, 180 ), math.Rand( -180, 180 ), math.Rand( -180, 180 ) ) );
		i:Spawn();
		i:Activate();

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

	GAMEMODE:DamageShip( self:GetSubsystem() );

	self:Remove();

end

function ENT:Use( ply )

	if( self:IsDamaged() and self:GetNeedsTeam( ply:Team() ) ) then

		GAMEMODE:StartTerminalSolve( self, ply );

	else

		self:EmitSound( Sound( "buttons/button10.wav" ) );

	end

end

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS;

end