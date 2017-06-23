local meta = FindMetaTable( "Player" );

local function nInvSend( len )

	LocalPlayer().Inventory = { };
	local n = net.ReadUInt( MaxUIntBits( 6 ) );

	for i = 1, n do

		local id = net.ReadUInt( MaxUIntBits( 6 ) );
		local class = net.ReadString();

		LocalPlayer().Inventory[id] = class;

	end

	GAMEMODE:UpdateItemHUD();

end
net.Receive( "nInvSend", nInvSend );

local function nInvAdd( len )

	LocalPlayer():CheckInventory();

	local id = net.ReadUInt( MaxUIntBits( 6 ) );
	local class = net.ReadString();

	LocalPlayer().Inventory[id] = class;

	GAMEMODE:UpdateItemHUD();

end
net.Receive( "nInvAdd", nInvAdd );

local function nInvClear( len )

	LocalPlayer().Inventory = { };

	GAMEMODE:UpdateItemHUD();

end
net.Receive( "nInvClear", nInvClear );

function GM:HideItemPanel()

	if( self.ItemPanel and self.ItemPanel:IsValid() ) then
		self.ItemPanel:SetVisible( false );
	end

end

function GM:ShowItemPanel()

	if( self.ItemPanel and self.ItemPanel:IsValid() ) then
		self.ItemPanel:SetVisible( true );
	end

end

local function nShowItemPanel( len )

	GAMEMODE:ShowItemPanel();

end
net.Receive( "nShowItemPanel", nShowItemPanel );

function GM:UpdateItemHUD()

	if( !LocalPlayer().Inventory ) then return end

	local padding = 6;
	local w = 64;
	local h = w;

	if( !self.ItemPanel or !self.ItemPanel:IsValid() ) then

		local ow = padding * 7 + w * 6;
		local oh = h + padding * 2;

		self.ItemPanel = self:CreatePanel( nil, NODOCK, ow, oh );
		self.ItemPanel:SetPos( ScrW() / 2 - ow / 2, ScrH() - oh );
		self.ItemPanel:DockPadding( padding, padding, padding, padding );
		self.ItemPanel.Slots = { };
		self.ItemPanel:SetPaintBackground( false );

		for i = 1, 6 do

			self.ItemPanel.Slots[i] = self:CreatePanel( self.ItemPanel, LEFT, w, h );
			if( i < 6 ) then
				self.ItemPanel.Slots[i]:DockMargin( 0, 0, padding, 0 );
			end

			local l = self:CreateLabel( self.ItemPanel.Slots[i], FILL, i, "NSS 12", 3 );
			l:DockMargin( 0, 0, 4, 4 );

		end

	end

	for i = 1, 6 do

		if( self.ItemPanel.Slots[i].Item and self.ItemPanel.Slots[i].Item:IsValid() ) then
			self.ItemPanel.Slots[i].Item:Remove();
		end

		if( LocalPlayer().Inventory[i] ) then
			
			local v = LocalPlayer().Inventory[i];
			self.ItemPanel.Slots[i].Item = self:CreateSpawnIcon( self.ItemPanel.Slots[i], FILL, 0, 0, GAMEMODE.Items[v].Model, GAMEMODE.Items[v].Name );

		end

	end

end

function GM:OpenWorkbench( ent )

	LocalPlayer().Workbench = true;
	LocalPlayer().WorkbenchEnt = ent;

	self.WorkbenchPanel = self:CreateFrame( I18( "workbench" ), 600, 300 );
	self.WorkbenchPanel.OnClose = function() self:ClearWorkbench( LocalPlayer() ); end

	local list = self:CreateScrollPanel( self.WorkbenchPanel, LEFT, 200, 0 );
	list:DockMargin( 10, 10, 10, 10 );

	local SelectedPowerup = "";
	local Ingredients = { };

	local d = self:CreatePanel( self.WorkbenchPanel, FILL );
	d:DockPadding( 10, 10, 10, 10 );
		local title = self:CreateLabel( d, TOP, "Name", "NSS Title 32", 8 );
		local desc = self:CreateLabel( d, TOP, "Desc", "NSS 16", 8 );
		desc:SetWrap( true );
		desc:SetTall( 4 * 16 );
		desc:DockMargin( 0, 0, 0, 30 );

		local ih = 64;
		local padding = 6;

		local reqLabel = self:CreateLabel( d, TOP, I18( "required_items" ), "NSS 16", 7 );
		reqLabel:DockMargin( 0, 0, 0, 10 );

		local reqPanel = self:CreatePanel( d, TOP, 0, ih );
		reqPanel:SetPaintBackground( false );

		local bCraft = self:CreateButton( d, BOTTOM, 0, 30, I18( "create" ), "NSS 24", function()

			if( SelectedPowerup and SelectedPowerup != "" ) then

				if( self:GetState() == STATE_GAME ) then
					
					for k, _ in pairs( Ingredients ) do
						LocalPlayer().Inventory[k] = nil;
					end

					GAMEMODE:UpdateItemHUD();

					net.Start( "nCreatePowerup" );
						net.WriteString( SelectedPowerup );
						net.WriteEntity( LocalPlayer().WorkbenchEnt );
					net.SendToServer();

					self.WorkbenchPanel:FadeOut();
					self:ClearWorkbench( LocalPlayer() );

					if( GAMEMODE.Powerups[SelectedPowerup].OnCreate ) then
						GAMEMODE.Powerups[SelectedPowerup].OnCreate( LocalPlayer() );
					end

					chat.AddText( Color( 255, 255, 255 ), I18( "you_created" ) .. " ", Color( 255, 0, 0 ), GAMEMODE.Powerups[SelectedPowerup].Name, Color( 255, 255, 255 ), "." );

				end

			end

		end );
		bCraft:SetBackgroundColor( team.GetColor( LocalPlayer():Team() ) );

	d:SetVisible( false );

	for k, v in SortedPairsByMemberValue( self.Powerups, "Name" ) do

		local b = self:CreateButton( list, TOP, 0, 30, v.Name, "NSS 18", function()
			SelectedPowerup = k;

			d:SetVisible( true );

			title:SetText( v.Name );
			desc:SetText( v.Desc );

			reqPanel:Clear();

			local hasIng = true;
			local used = { };

			for _, v in pairs( v.Ingredients ) do

				local s = self:CreateSpawnIcon( reqPanel, LEFT, ih, 0, self.Items[v].Model, self.Items[v].Name );
				s:DockMargin( 0, 0, padding, 0 );

				local k = LocalPlayer():HasItem( v, used );
				if( k ) then
					used[k] = true;
				else
					hasIng = false;
					s:SetDisabled( true );
				end

			end

			if( hasIng ) then
				bCraft:SetDisabled( false );
				Ingredients = used;
			else
				bCraft:SetDisabled( true );
			end
		end );
		b:DockMargin( 0, 0, 0, 6 );

	end

end

function GM:ClearWorkbench( ply )

	ply.Workbench = false;
	ply.WorkbenchEnt = nil;

	if( ply == LocalPlayer() ) then

		if( self.WorkbenchPanel and self.WorkbenchPanel:IsValid() ) then
			self.WorkbenchPanel:FadeOut();
		end
		self.WorkbenchPanel = nil;

	end

end

function GM:WorkbenchThink()

	for _, v in pairs( player.GetAll() ) do
		
		if( v.Workbench ) then

			if( !v.WorkbenchEnt or !v.WorkbenchEnt:IsValid() ) then
				self:ClearWorkbench( v );
			elseif( v.WorkbenchEnt:GetPos():Distance( v:GetPos() ) > 100 ) then
				self:ClearWorkbench( v );
			end

		end

	end

end

local function nOpenWorkbench( len )

	local ent = net.ReadEntity();
	GAMEMODE:OpenWorkbench( ent );

end
net.Receive( "nOpenWorkbench", nOpenWorkbench );

local function nSetPowerup( len )

	local ply = net.ReadEntity();
	local powerup = net.ReadString();

	ply.Powerup = powerup;

end
net.Receive( "nSetPowerup", nSetPowerup );

local function nClearPowerup( len )

	local ply = net.ReadEntity();

	ply.Powerup = nil;

end
net.Receive( "nClearPowerup", nClearPowerup );