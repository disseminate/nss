function GM:GetState()

	if( !self.StateCycleStart ) then
		return STATE_PREGAME;
	end

	if( self.Lost ) then
		return STATE_LOST;
	end

	local t = ( CurTime() - self.StateCycleStart ) % ( STATE_TIMES[STATE_PREGAME] + STATE_TIMES[STATE_GAME] + STATE_TIMES[STATE_POSTGAME] );
	
	if( t < STATE_TIMES[STATE_PREGAME] ) then
		return STATE_PREGAME;
	elseif( t >= STATE_TIMES[STATE_PREGAME] and t < STATE_TIMES[STATE_PREGAME] + STATE_TIMES[STATE_GAME] ) then
		return STATE_GAME;
	else
		return STATE_POSTGAME;
	end

end

function GM:TimeLeftInState()

	if( !self.StateCycleStart ) then
		return 0;
	end

	local state = self:GetState();

	if( state == STATE_LOST ) then
		if( !self.LoseResetTime ) then
			self.LoseResetTime = CurTime();
		end

		return math.Clamp( 3000 - ( CurTime() - self.LoseResetTime ), 0, 3000 );
	elseif( self.LoseResetTime ) then
		self.LoseResetTime = nil;
	end

	local state = self:GetState();
	local el = ( CurTime() - self.StateCycleStart ) % ( STATE_TIMES[STATE_PREGAME] + STATE_TIMES[STATE_GAME] + STATE_TIMES[STATE_POSTGAME] );

	if( state == STATE_PREGAME ) then
		return STATE_TIMES[STATE_PREGAME] - el;
	elseif( state == STATE_GAME ) then
		return STATE_TIMES[STATE_GAME] - ( el - STATE_TIMES[STATE_PREGAME] );
	else
		return STATE_TIMES[STATE_POSTGAME] - ( el - STATE_TIMES[STATE_PREGAME] - STATE_TIMES[STATE_GAME] );
	end

end

function GM:OnStateTransition( prev, state )

	if( SERVER and prev == STATE_POSTGAME ) then
		self:Reset();
	end

	if( CLIENT and state == STATE_POSTGAME ) then
		self.OutroStart = CurTime();
	end

end