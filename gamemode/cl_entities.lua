local function nMapEditMode( len )

	local b = net.ReadBool();
	GAMEMODE.MapEditMode = b;

	GAMEMODE:UpdateItemHUD();

end
net.Receive( "nMapEditMode", nMapEditMode );
