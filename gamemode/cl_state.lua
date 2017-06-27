local function nReceiveState( len )

	GAMEMODE.StateCycleStart = net.ReadFloat();
	GAMEMODE.Lost = net.ReadBool();

	if( GAMEMODE.Lost ) then
		GAMEMODE.OutroStart = CurTime();
	end

end
net.Receive( "nReceiveState", nReceiveState );

local function nJoin( len )

	local ply = net.ReadEntity();
	ply.Joined = true;

	if( ply == LocalPlayer() and GAMEMODE.MapEditMode and ply:IsSuperAdmin() ) then

		GAMEMODE:UpdateItemHUD();

	end

end
net.Receive( "nJoin", nJoin );

function GM:StateThink()
	
	if( #player.GetJoined() == 0 ) then return end

	if( self:GetState() != self.CacheState ) then
		
		self:OnStateTransition( self.CacheState, self:GetState() );
		self.CacheState = self:GetState();
		
	end

end