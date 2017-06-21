EFFECT.Smoke = {
	Material( "particle/smokesprites_0001" ),
	Material( "particle/smokesprites_0002" ),
	Material( "particle/smokesprites_0003" ),
	Material( "particle/smokesprites_0004" ),
	Material( "particle/smokesprites_0005" ),
	Material( "particle/smokesprites_0006" ),
	Material( "particle/smokesprites_0007" ),
	Material( "particle/smokesprites_0008" ),
	Material( "particle/smokesprites_0009" ),
	Material( "particle/smokesprites_0010" ),
	Material( "particle/smokesprites_0011" ),
	Material( "particle/smokesprites_0012" ),
	Material( "particle/smokesprites_0013" ),
	Material( "particle/smokesprites_0014" ),
	Material( "particle/smokesprites_0015" ),
	Material( "particle/smokesprites_0016" ),
};

function EFFECT:Init( data )

	self.StartTime = CurTime();
	self.Ent = data:GetEntity();
	self.Dir = data:GetNormal();
	self.Offset = data:GetMagnitude();

	self.Emitter = ParticleEmitter( self.Ent:GetPos(), false );

	for i = 17, #self.Smoke do
		self.Smoke[i] = nil;
	end

end

function EFFECT:Think()

	if( self.Ent and self.Ent:IsValid() ) then
		
		if( self.Emitter and self.Ent != LocalPlayer() ) then
			self.Emitter:SetPos( self.Ent:GetPos() );
			local mat = table.Random( self.Smoke );

			local pos = Vector();
			local t = math.Rand( -math.pi, math.pi );
			local p = math.Rand( 0, math.pi );
			local r = 8;
			pos.x = r * math.sin( t ) * math.cos( p );
			pos.y = r * math.sin( t ) * math.sin( p );
			pos.z = r * math.cos( p );
			
			local p = self.Emitter:Add( mat, self.Ent:GetPos() + pos + Vector( 0, 0, self.Offset ) );
			if( p ) then

				p:SetAirResistance( 1 );
				p:SetCollide( false );
				if( math.random( 1, 2 ) == 1 ) then
					p:SetColor( 255, math.random( 100, 200 ), math.random( 10, 50 ) );
				else
					p:SetColor( 255, 255, 255 );
				end
				p:SetDieTime( 1 );
				p:SetEndAlpha( 0 );
				p:SetEndSize( 24 );
				p:SetGravity( Vector( 0, 0, -8 ) );
				p:SetLifeTime( 0 );
				p:SetRoll( math.Rand( -math.pi, math.pi ) );
				p:SetRollDelta( math.Rand( -math.pi, math.pi ) );
				p:SetStartAlpha( 100 );
				p:SetStartSize( 8 );

				local noise = Vector();
				local t = math.Rand( -math.pi, math.pi );
				local phi = math.Rand( 0, math.pi );
				local r = 20;
				noise.x = r * math.sin( t ) * math.cos( phi );
				noise.y = r * math.sin( t ) * math.sin( phi );
				noise.z = r * math.cos( phi );

				local dir = self.Dir; 
				local thrust = math.Rand( 40, 80 );

				local vel = Vector( dir.x * thrust + noise.x, dir.y * thrust + noise.y, dir.z * thrust + noise.z );
				p:SetVelocity( vel );

			end
		end

	end

	if( CurTime() - self.StartTime > 0.3 ) then
		self.Emitter:Finish();
	end

	return CurTime() - self.StartTime < 0.3;

end

function EFFECT:Render()



end