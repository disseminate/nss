local titleSizes = { 20, 24, 32, 48, 64 };
local textSizes = { 12, 14, 16, 18, 20, 24, 32 };

for _, v in pairs( titleSizes ) do

	surface.CreateFont( "NSS Title " .. v, {
		font = "Maassslicer",
		size = v,
		weight = 400,
		italic = true
	} );

end

for _, v in pairs( textSizes ) do

	surface.CreateFont( "NSS " .. v, {
		font = "Tahoma",
		size = v,
		weight = 400
	} );

end