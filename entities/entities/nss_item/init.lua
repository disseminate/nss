AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );
include( "shared.lua" );

function ENT:Think()

	if( self:GetDieTime() > 0 and CurTime() >= self:GetDieTime() ) then

		self:Remove();

	end

end

function ENT:AttemptPickup( ply )

	if( ply:InvHasSpace() ) then

		if( !ply.NextInvPickup or ( ply.NextInvPickup and CurTime() >= ply.NextInvPickup ) ) then
			
			local id = ply:AddItem( self:GetItem() );
			ply:SendInventoryID( id );

			ply:EmitSound( Sound( "physics/plaster/ceiling_tile_impact_soft" .. math.random( 1, 3 ) .. ".wav" ) );

			self:Remove();

		end

	end

end

function ENT:StartTouch( ply )

	if( !ply or !ply:IsValid() or !ply:IsPlayer() ) then return end

	self:AttemptPickup( ply );

end

function ENT:Use( ply )

	if( !ply or !ply:IsValid() or !ply:IsPlayer() ) then return end

	self:AttemptPickup( ply );

end