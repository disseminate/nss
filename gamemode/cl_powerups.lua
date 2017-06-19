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
			self.ItemPanel.Slots[i].Item = self:CreateSpawnIcon( self.ItemPanel.Slots[i], FILL, 0, 0, GAMEMODE.Items[v].Model );

		end

	end

end