local meta = FindMetaTable( "Player" );

GM.Items = RequireDir( "items" );
GM.Powerups = RequireDir( "powerups" );

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

function meta:HasItem( class, tab )

	self:CheckInventory();

	for k, v in pairs( self.Inventory ) do

		if( v == class and !tab[k] ) then

			return k;

		end

	end

end