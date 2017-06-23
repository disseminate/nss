function GM:SetHint( key )

	if( !self:Hint( key ) ) then
		cookie.Set( "nss_hint_" .. key, "1" );
	end

end

function GM:Hint( key )

	return cookie.GetNumber( "nss_hint_" .. key ) == 1;

end