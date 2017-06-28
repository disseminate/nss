include( "shared.lua" );

function ENT:Draw()

	self:DrawModel();

end

function ENT:RenderOverride()

	self:DrawModel();

	if( GAMEMODE:ASSTriggered() or GAMEMODE.MapEditMode ) then

		if( !self.Mesh ) then
			self:CreateMesh();
		end

		render.SetMaterial( self.MeshMat );
		self.Mesh:Draw();

	end

end

function ENT:CreateMesh()

	self.Mesh = Mesh();
	self.MeshMat = CreateMaterial( "nss_greenstripe_" .. CurTime(), "UnlitGeneric", {
		["$basetexture"] = "nss/vgui/stripe",
		["$translucent"] = 1,
		["$vertexcolor"] = 1,
		["$vertexalpha"] = 1,
		Proxies = {
			TextureScroll = {
				["textureScrollRate"] = 0.6,
				["textureScrollAngle"] = 0,
				["textureScrollVar"] = "$basetexturetransform"
			}
		}
	} );

	self.Verts = { };

	local segments = 64;
	local rad = 256;
	
	local da = 2 * math.pi / segments;
	local texRepeat = 20;

	for ang = -math.pi, math.pi, da do

		local x = math.cos( ang ) * rad;
		local y = math.sin( ang ) * rad;

		local x2 = math.cos( ang + da ) * rad;
		local y2 = math.sin( ang + da ) * rad;

		local posTab = {
			Vector( x, y, -24 ),
			Vector( 0, 0, -24 ),
			Vector( x2, y2, -24 )
		};

		for k, v in pairs( posTab ) do

			table.insert( self.Verts, {
				pos = self:GetPos() + v,
				u = texRepeat * ( 0.5 * v.x / rad + 0.5 ),
				v = texRepeat * ( 0.5 * v.y / rad + 0.5 ),
				normal = Vector( 0, 0, 1 ),
				color = Color( 0, 255, 0, 30 )
			} );

		end

	end
	
	self.Mesh:BuildFromTriangles( self.Verts );

end