local meta = FindMetaTable( "Entity" );

function meta:IsTerminal()

	return self:GetClass() == "nss_terminal";

end

function GM:MapHasTerminals()

	local etab = ents.FindByClass( "nss_terminal" );
	if( #etab == 0 ) then return false end

	for _, v in pairs( etab ) do
		
		if( v:MapCreationID() >= 0 ) then

			return true;

		end

	end

	return false;

end

local widget_mapedit_move = {
	Base = "widget_axis",

	Setup = function( self, ent, rotate )

		self:SetParent( ent );
		local a, b = ent:GetRotatedAABB( ent:OBBMins(), ent:OBBMaxs() );

		self:SetLocalPos( ( a + b ) / 2 )
		self:SetLocalAngles( Angle( 0, 0, 0 ) )

		local EntName = "widget_axis_arrow"
		if ( rotate ) then EntName = "widget_axis_disc" end

		self.ArrowX = ents.Create( EntName )
		self.ArrowX:SetParent( self )
		self.ArrowX:SetColor( Color( 255, 0, 0, 255 ) )
		self.ArrowX:Spawn()
		self.ArrowX:SetLocalPos( Vector( 0, 0, 0 ) )
		self.ArrowX:SetLocalAngles( Vector( 1, 0, 0 ):Angle() )
		self.ArrowX:SetAxisIndex( 1 )
		self.ArrowX:SetSize( 64 );

		self.ArrowY = ents.Create( EntName )
		self.ArrowY:SetParent( self )
		self.ArrowY:SetColor( Color( 0, 230, 50, 255 ) )
		self.ArrowY:Spawn()
		self.ArrowY:SetLocalPos( Vector( 0, 0, 0 ) )
		self.ArrowY:SetLocalAngles( Vector( 0, 1, 0 ):Angle() )
		self.ArrowY:SetAxisIndex( 2 )
		self.ArrowY:SetSize( 64 );

		self.ArrowZ = ents.Create( EntName )
		self.ArrowZ:SetParent( self )
		self.ArrowZ:SetColor( Color( 50, 100, 255, 255 ) )
		self.ArrowZ:Spawn()
		self.ArrowZ:SetLocalPos( Vector( 0, 0, 0 ) )
		self.ArrowZ:SetLocalAngles( Vector( 0.01, 0, 1 ):Angle() ) -- bugged
		self.ArrowZ:SetAxisIndex( 3 )
		self.ArrowZ:SetSize( 64 );

	end,

	OnArrowDragged = function( self, num, dist, pl, mv )

		-- Prediction doesn't work properly yet.. because of the confusion with the bone moving, and the parenting, Agh.
		if ( CLIENT ) then return end

		local ent = self:GetParent()
		if ( !IsValid( ent ) ) then return end

		local v = Vector( 0, 0, 0 )

		if ( num == 1 ) then v.x = -dist end
		if ( num == 2 ) then v.y = -dist end
		if ( num == 3 ) then v.z = dist end

		local ang = ent:GetAngles();

		if( self.Rotate == 1 ) then
			ang:RotateAroundAxis( ang:Forward(), -v.x );
			ang:RotateAroundAxis( ang:Right(), v.y );
			ang:RotateAroundAxis( ang:Up(), v.z );
			ent:SetAngles( ang );
		else
			local newPos = ent:GetPos() + ang:Forward() * -v.x + ang:Right() * v.y + ang:Up() * v.z;
			local trace = { };
			trace.start = newPos;
			trace.endpos = trace.start;
			trace.filter = ent;

			local a, b = ent:GetRotatedAABB( ent:OBBMins(), ent:OBBMaxs() );
			trace.mins = a;
			trace.maxs = b;
			local tr = util.TraceHull( trace );

			if( !tr.HitWorld ) then
				ent:SetPos( newPos );
			end
		end

	end
}

scripted_ents.Register( widget_mapedit_move, "widget_mapedit_move" );
