local meta = FindMetaTable( "Player" );

function meta:ResetAllStats()

	self.Stats = { };

end

function meta:ResetStat( name, val )

	if( !self.Stats ) then
		self.Stats = { };
	end

	self.Stats[name] = val or 0;

end

function meta:SetStat( name, val )
	self:ResetStat( name, val );
end

function meta:AddToStat( name, val )

	if( !self.Stats ) then
		self.Stats = { };
	end

	self.Stats[name] = ( self.Stats[name] or 0 ) + val;

end

function meta:GetStat( name )

	if( !self.Stats ) then
		self.Stats = { };
	end

	return self.Stats[name] or 0;
	
end