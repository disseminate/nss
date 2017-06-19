local meta = FindMetaTable( "Player" );

GM.Items = RequireDir( "items" );

function meta:CheckInventory()

	if( !self.Inventory ) then
		self.Inventory = { };
	end

end

function meta:InvHasSpace()

	self:CheckInventory();

	if( table.Count( self.Inventory ) >= 6 ) then return false; end

	return true;

end