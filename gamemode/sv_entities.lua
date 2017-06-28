local meta = FindMetaTable( "Player" );

sql.Query( "CREATE TABLE IF NOT EXISTS nss_creations (Map TEXT, ID INT, Class INT, Pos TEXT, Ang TEXT);" );
sql.Query( "CREATE TABLE IF NOT EXISTS nss_cameras (Map TEXT, Pos TEXT, Ang TEXT);" );

function meta:SendMapEditMode()

	net.Start( "nMapEditMode" );
		net.WriteBool( GAMEMODE.MapEditMode );
	net.Send( self );

end
util.AddNetworkString( "nMapEditMode" );

function meta:SendMapInfo()

	net.Start( "nSendMapInfo" );
		net.WriteVector( GAMEMODE.CamPos or Vector() );
		net.WriteAngle( GAMEMODE.CamAng or Angle() );
	net.Send( self );

end
util.AddNetworkString( "nSendMapInfo" );

local function nSetMapEditMode( len, ply )

	if( !ply:IsSuperAdmin() ) then return end
	if( GAMEMODE:MapHasTerminals() ) then return end
	if( GAMEMODE:GetState() == STATE_POSTGAME or GAMEMODE:GetState() == STATE_LOST ) then return end

	GAMEMODE.MapEditMode = net.ReadBool();

	if( GAMEMODE.MapEditMode == false ) then

		sql.Begin();

		for _, v in pairs( ents.GetAll() ) do

			if( v.MapEditID ) then
				
				sql.Query( "UPDATE nss_creations SET Pos = " .. sql.SQLStr( tostring( v:GetPos() ) ) .. ", Ang = " .. sql.SQLStr( tostring( v:GetAngles() ) ) .. " WHERE ID = " .. v.MapEditID .. ";" );

			end

		end

		sql.Commit();

	end

	GAMEMODE:ResetState();
	if( GAMEMODE.MapEditMode == false ) then
		GAMEMODE:Reset( true );
	end

	net.Start( "nMapEditMode" );
		net.WriteBool( GAMEMODE.MapEditMode );
	net.Broadcast();

end
net.Receive( "nSetMapEditMode", nSetMapEditMode );
util.AddNetworkString( "nSetMapEditMode" );

local function nMapEditorRemove( len, ply )

	if( !ply:IsSuperAdmin() ) then return end

	local trace = { };
	trace.start = ply:GetShootPos();
	trace.endpos = trace.start + ply:GetAimVector() * 16384;
	trace.filter = ply;
	local tr = util.TraceLine( trace );

	if( tr.Entity and tr.Entity:IsValid() and tr.Entity.MapEditID ) then

		local id = tr.Entity.MapEditID;
		tr.Entity:Remove();

		if( id ) then
			sql.Query( "DELETE FROM nss_creations WHERE ID = " .. id .. ";" );
		end

	end

end
net.Receive( "nMapEditorRemove", nMapEditorRemove );
util.AddNetworkString( "nMapEditorRemove" );

local function nMapEditorClear( len, ply )

	if( !ply:IsSuperAdmin() ) then return end

	for _, v in pairs( ents.GetAll() ) do

		if( v.MapEditID ) then

			v:Remove();

		end

	end

	sql.Query( "DELETE FROM nss_creations WHERE Map = " .. sql.SQLStr( game.GetMap() ) .. ";" );

end
net.Receive( "nMapEditorClear", nMapEditorClear );
util.AddNetworkString( "nMapEditorClear" );

local function nMapEditorNoclip( len, ply )

	if( !ply:IsSuperAdmin() ) then return end

	if( ply:IsEFlagSet( EFL_NOCLIP_ACTIVE ) ) then
		ply:RemoveEFlags( EFL_NOCLIP_ACTIVE );
		ply:SetMoveType( MOVETYPE_WALK );
	else
		ply:AddEFlags( EFL_NOCLIP_ACTIVE );
		ply:SetMoveType( MOVETYPE_NOCLIP );
	end

end
net.Receive( "nMapEditorNoclip", nMapEditorNoclip );
util.AddNetworkString( "nMapEditorNoclip" );

local function nMapEditorEditPos( len, ply )

	if( !ply:IsSuperAdmin() ) then return end

	local trace = { };
	trace.start = ply:GetShootPos();
	trace.endpos = trace.start + ply:GetAimVector() * 16384;
	trace.filter = ply;
	local tr = util.TraceLine( trace );

	if( tr.Entity and tr.Entity:IsValid() and tr.Entity.MapEditID ) then
		
		local rotate;
		
		if( tr.Entity.Axis and tr.Entity.Axis:IsValid() ) then
			local class = tr.Entity.Axis:GetClass();
			tr.Entity.Axis:Remove();
			
			if( tr.Entity.Axis.Rotate == 0 ) then
				rotate = 1;
			elseif( tr.Entity.Axis.Rotate == 1 ) then
				tr.Entity.Axis = nil;
				rotate = 2;
			end
		else
			rotate = 0;
		end

		if( rotate != 2 ) then
			
			tr.Entity.Axis = ents.Create( "widget_mapedit_move" );
			tr.Entity.Axis:Setup( tr.Entity, rotate == 1 );
			tr.Entity.Axis:Spawn();
			tr.Entity.Axis:SetPriority( 0.5 );
			tr.Entity.Axis.Rotate = rotate;
			tr.Entity:DeleteOnRemove( tr.Entity.Axis );

		end

	end

end
net.Receive( "nMapEditorEditPos", nMapEditorEditPos );
util.AddNetworkString( "nMapEditorEditPos" );

local function nMapEditorClearPos( len, ply )

	if( !ply:IsSuperAdmin() ) then return end

	for _, v in pairs( ents.FindByClass( "widget_mapedit_move" ) ) do

		v:Remove();

	end

end
net.Receive( "nMapEditorClearPos", nMapEditorClearPos );
util.AddNetworkString( "nMapEditorClearPos" );

local function nSetMapEditorCamera( len, ply )
	
	if( !ply:IsSuperAdmin() ) then return end

	GAMEMODE:SetMapEditorCamera( ply:EyePos(), ply:EyeAngles() );

end
net.Receive( "nSetMapEditorCamera", nSetMapEditorCamera );
util.AddNetworkString( "nSetMapEditorCamera" );

function meta:CreateMapEnt( n )

	if( !self:IsSuperAdmin() ) then return end

	local class;
	local addPos = Vector();
	if( n == 1 ) then
		class = "nss_terminal";
		addPos = Vector( 0, 0, 1 );
	elseif( n == 2 ) then
		class = "nss_workbench";
		addPos = Vector( 0, 0, 17 );
	elseif( n == 3 ) then
		class = "nss_ass";
		addPos = Vector( 0, 0, 26 );
	end

	if( class ) then

		local trace = { };
		trace.start = self:GetShootPos();
		trace.endpos = trace.start + self:GetAimVector() * 16384;
		trace.filter = self;
		local tr = util.TraceLine( trace );

		local d = self:GetPos() - tr.HitPos;

		local e = ents.Create( class );
		e:SetPos( tr.HitPos + addPos );
		e:SetAngles( Vector( d.x, d.y, 0 ):Angle() );
		e:Spawn();
		e:Activate();

		self.UndoEnt = e;

		local maxId = 1;
		for _, v in pairs( ents.GetAll() ) do

			if( v.MapEditID ) then

				maxId = math.max( maxId, v.MapEditID );

			end

		end
		e.MapEditID = maxId + 1;

		sql.Query( "INSERT INTO nss_creations (Map, ID, Class, Pos, Ang) VALUES (" .. sql.SQLStr( game.GetMap() ) .. ", " .. e.MapEditID .. ", " .. n .. ", " .. sql.SQLStr( tostring( e:GetPos() ) ) .. ", " .. sql.SQLStr( tostring( e:GetAngles() ) ) .. ");" );

	end

end

local function nMapEditorUndo( len, ply )

	if( !ply:IsSuperAdmin() ) then return end

	if( ply.UndoEnt and ply.UndoEnt:IsValid() ) then
		local id = ply.UndoEnt.MapEditID;

		ply.UndoEnt:Remove();
		ply.UndoEnt = nil;

		if( id ) then
			sql.Query( "DELETE FROM nss_creations WHERE ID = " .. id .. ";" );
		end
	end

end
net.Receive( "nMapEditorUndo", nMapEditorUndo );
util.AddNetworkString( "nMapEditorUndo" );

function GM:SetMapEditorCamera( pos, ang )

	GAMEMODE.CamPos = pos;
	GAMEMODE.CamAng = ang;

	sql.Query( "DELETE FROM nss_cameras WHERE Map = " .. sql.SQLStr( game.GetMap() ) .. ";" );
	sql.Query( "INSERT INTO nss_cameras (Map, Pos, Ang) VALUES (" .. sql.SQLStr( game.GetMap() ) .. ", " .. sql.SQLStr( tostring( pos ) ) .. ", " .. sql.SQLStr( tostring( ang ) ) .. ");" );

	net.Start( "nSendMapInfo" );
		net.WriteVector( GAMEMODE.CamPos );
		net.WriteAngle( GAMEMODE.CamAng );
	net.Broadcast();

end

function GM:InitPostEntity()

	local tab = sql.Query( "SELECT * FROM nss_creations WHERE Map = " .. sql.SQLStr( game.GetMap() ) .. ";" );
	
	if( tab ) then
		
		for _, v in pairs( tab ) do

			v.Class = tonumber( v.Class );
			v.ID = tonumber( v.ID );

			for _, v in pairs( ents.GetAll() ) do

				if( v.MapEditID and v.MapEditID == v.ID ) then

					v:Remove();
					
				end

			end

			local class;
			if( v.Class == 1 ) then
				class = "nss_terminal";
			elseif( v.Class == 2 ) then
				class = "nss_workbench";
			elseif( v.Class == 3 ) then
				class = "nss_ass";
			end

			local e = ents.Create( class );
			e:SetPos( Vector( v.Pos ) );
			e:SetAngles( Angle( v.Ang ) );
			e.MapEditID = v.ID;
			e:Spawn();
			e:Activate();

		end

	end

	local tab = sql.Query( "SELECT * FROM nss_cameras WHERE Map = " .. sql.SQLStr( game.GetMap() ) .. ";" );
	
	if( tab ) then

		GAMEMODE.CamPos = Vector( tab[1].Pos );
		GAMEMODE.CamAng = Angle( tab[1].Ang );

	end

	if( #ents.FindByClass( "nss_terminal" ) == 0 ) then

		self.MapEditMode = true;

	else

		self.MapEditMode = false;

	end

end