local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)


local DressingRoom = {}
local DressUpModel
local SLOT_BUTTON_INDEX = {}
local INVENTORY_SLOT_NAMES = addon.Globals.INVENTORY_SLOT_NAMES

local import = false
local useCharacterSources = true

local defaultWidth, defaultHeight = 450, 545
local Buttons
local Profile
local itemhistory = {}

-------Create Mogit List-------
local newSet = {items = {}}
-------------------------------
local ItemList = {}
local EmptySlotAlpha = 0.4
local UnitInfo = {
	raceID = nil,
	genderID = nil,
	classID = nil,
}

local HideArmorOnShow = false
local HideWeaponOnShow = false
local HideTabardOnShow = false
local HideShirtOnShow = false
local useTarget = true
local forceView = true
local inspectView = false

local TP = CreateFrame("GameTooltip", "BW_VirtualTooltip", nil, "GameTooltipTemplate")
TP:SetScript("OnLoad", GameTooltip_OnLoad)
TP:SetOwner(UIParent, 'ANCHOR_NONE')
local TP = CreateFrame("GameTooltip", "BW_GameTooltip", nil, "GameTooltipTemplate")
TP:SetScript("OnLoad", GameTooltip_OnLoad)
--BW_GameTooltip.Text:SetFontObject(GameTooltipTextSmall)
local TP = GameTooltip
BW_GameTooltip = GameTooltip
function BetterWardrobe:ToggleDressingRoom()
		if DressUpFrame:IsShown() then 
			HideUIPanel(DressUpFrame)
		else
			DressUpFrame_Show(DressUpFrame)
		end
		DressingRoom:Update()
end

function addon.Init:DressingRoom()
	DressUpFrameOutfitDropdown:Hide()

	Buttons = BW_DressingRoomFrame.PreviewButtonFrame.Slots
	Profile = addon.Profile

	if addon.Profile.DR_OptionsEnable then
		addon:DressingRoom_Enable()
	else
		addon:DressingRoom_Disable()
	end
end

local reset = false
local defaultWidth, defaultHeight = 450, 545
function addon:DressingRoom_Enable()
	BW_DressingRoomFrame:Show()
	addon:HookScript(DressUpFrameResetButton,"OnClick", function()
		reset = true
		HideArmorOnShow = addon.Profile.DR_StartUndressed
		HideWeaponOnShow = addon.Profile.DR_HideWeapons
		HideTabardOnShow = addon.Profile.DR_HideTabard
		HideShirtOnShow = addon.Profile.DR_HideShirt
		DressingRoom:Update()
	end)

	if DressUpFrame.MaximizeMinimizeFrame then
		DressUpFrame.MaximizeMinimizeFrame:SetOnMaximizedCallback(function(self)
			DressUpFrameOutfitDropdown:Hide()

			if Profile.DR_ResizeWindow then
				DressUpFrame.MaximizeMinimizeFrame:GetParent():SetSize(Profile.DR_Width, Profile.DR_Height) 
			else
				DressUpFrame.MaximizeMinimizeFrame:GetParent():SetSize(defaultWidth, defaultHeight) 
			end
			UpdateUIPanelPositions(DressUpFrame.MaximizeMinimizeFrame)
		end)
			


	-----	addon:Hook(DressUpFrame.MaximizeMinimizeFrame, "minimizedCallback", function() DressUpFrameOutfitDropdown:Hide() end, true)


	end

	DressUpFrame:SetMovable(true)
	DressUpFrame:RegisterForDrag("LeftButton")
	DressUpFrame:SetScript("OnDragStart", DressUpFrame.StartMoving)
	DressUpFrame:SetScript("OnDragStop", DressUpFrame.StopMovingOrSizing)
	hooksecurefunc("DressUpVisual", DressingRoom.Update);
	hooksecurefunc("DressUpCollectionAppearance", DressingRoom.Update);
end

function addon:DressingRoom_Disable()
	BW_DressingRoomFrame:Hide()
	addon:Unhook("DressUpSources")
	addon:Unhook(DressUpFrameResetButton,"OnClick")

	DressUpFrame:SetMovable(false)
	DressUpFrame:SetScript("OnDragStart", nil)
	DressUpFrame:SetScript("OnDragStop", nil)

	if DressUpFrame.MaximizeMinimizeFrame then
		DressUpFrame.MaximizeMinimizeFrame:SetOnMaximizedCallback(function(self)
			DressUpFrame.MaximizeMinimizeFrame:GetParent():SetSize(defaultWidth, defaultHeight)
			UpdateUIPanelPositions(DressUpFrame.MaximizeMinimizeFrame)
		end)

		addon:Unhook(DressUpFrame.MaximizeMinimizeFrame, "minimizedCallback")
	end
end

local function IsAppearanceKnown(itemLink)
	--Need to correspond with C_TransmogCollection.C_TransmogCollection.PlayerHasTransmog
	if not itemLink then return end
	TP:SetHyperlink(itemLink)
	local str
	local num = TP:NumLines()
	for i = num, num - 2, -1 do
		str = nil
		str = _G["BW_VirtualTooltipTextLeft"..i]
		if not str then
			return false
		else
			str = str:GetText()
		end
		if str == SOURCE_KNOWN or str == APPEARANCE_KNOWN then
			return true
		elseif str == APPEARANCE_UNKNOWN then
			return false
		end
	end
	return false
end


local rangedWeapon
local function GetDressUpModelSlotSource(slotID, enchantID)
	local playerActor = DressUpFrame.ModelScene:GetPlayerActor()
	if not playerActor then
		return
	end

	local slotname = TransmogUtil.GetSlotName(slotID)
	local transmogLocation = TransmogUtil.GetTransmogLocation(slotname, Enum.TransmogType.Appearance, Enum.TransmogModification.Main)
	local info = playerActor:GetItemTransmogInfoList()
	appliedSourceID = info[slotID].appearanceID

	if appliedSourceID < 0 then return end

	local sourceInfo = C_TransmogCollection.GetSourceInfo(appliedSourceID)

	if not sourceInfo then return end

	local sourceType = sourceInfo.sourceType
	local itemModID = sourceInfo.itemModID
	local itemID = sourceInfo.itemID
	local itemName = sourceInfo.name
	local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemID, itemModID)
	local itemIcon = C_TransmogCollection.GetSourceIcon(appliedSourceID)
	local itemLink = select(6, C_TransmogCollection.GetAppearanceSourceInfo(appliedSourceID))
	local hasAppearance = C_TransmogCollection.PlayerHasTransmog(itemID, itemModID) or IsAppearanceKnown(itemLink)

	if itemName and (slotID == 16 or slotID == 17) then 
		local GetItemInfo = C_Item and C_Item.GetItemInfo
		local _, _, _, _, _, _, _, _, _, _, _, classID, subclassID = GetItemInfo(itemName)
		if classID == LE_ITEM_CLASS_WEAPON then
			if subclassID == LE_ITEM_WEAPON_BOWS or subclassID == LE_ITEM_WEAPON_GUNS or subclassID == LE_ITEM_WEAPON_CROSSBOW then 
				rangedWeapon = true
			else
				rangedWeapon = false
			end
		end	
	end

	return appliedSourceID, appearanceID, itemIcon, hasAppearance, itemLink, itemName, itemID
end

BW_DressingRoomItemButtonMixin = {}
function BW_DressingRoomItemButtonMixin:OnLoad()
	local slot = self:GetID()
	local invslot = INVENTORY_SLOT_NAMES[slot]
	local _, slotTexture = GetInventorySlotInfo(invslot)
	self.Background:SetTexture(slotTexture)
	self:RegisterForClicks("LeftButtonDown", "RightButtonDown")
end

function BW_DressingRoomItemButtonMixin:OnEnter()
	local slot = INVENTORY_SLOT_NAMES[self:GetID()]

	BW_GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 0, 40)
	
	if self.itemLink then
		BW_GameTooltip:SetHyperlink(self.itemLink)
	else
		BW_GameTooltip:AddLine(_G[slot])
	end

	BW_GameTooltip:Show()
	--ShoppingTooltip1:Hide()
	--ShoppingTooltip2:Hide()
	--if ShoppingTooltip3 then ShoppingTooltip3:Hide() end
	--GameTooltip_ClearMoney()
end

function BW_DressingRoomItemButtonMixin:OnLeave()
	BW_GameTooltip:Hide()
end

function BW_DressingRoomItemButtonMixin:OnClick()
end

function BW_DressingRoomItemButtonMixin:ResetButton()
	self.Icon:Hide()
	self.IconBorder:Hide()
	self.itemSource = nil
	self.enchantID = nil
	self.sourceID = nil
	self.isHidden = false
	self.itemLink = false
	self:SetAlpha(EmptySlotAlpha)
end

function BW_DressingRoomItemButtonMixin:EnableButton()
	self.Icon:SetDesaturated(false)
	self:SetAlpha(1)
	self.Icon:Show()
	self.IconBorder:Show()
end

function BW_DressingRoomItemButtonMixin:OnMouseDown(button)
	local sharedActor = DressUpFrame.ModelScene:GetPlayerActor()
	BW_GameTooltip:Hide()

	if button == "LeftButton" then
		if not self.sourceID then return end
		self.isHidden = not self.isHidden
		if (not sharedActor) then
			return
		end

		local slot = self:GetID()
		if self.isHidden then
			if slot == 16 and rangedWeapon then
				sharedActor:UndressSlot(16)
				sharedActor:UndressSlot(17)

			end
			sharedActor:UndressSlot(self:GetID())
			self.Icon:SetDesaturated(true)
			self:SetAlpha(EmptySlotAlpha)

		elseif self.sourceID then
			sharedActor:TryOn(self.sourceID)
			self:SetAlpha(1)
			self.Icon:SetDesaturated(false)
		end

	elseif button == "RightButton" then
		local slot = self:GetID()
		if not self.sourceID then
			return
		elseif slot == 16 and rangedWeapon then
			sharedActor:UndressSlot(16)
			sharedActor:UndressSlot(17)
			rangedWeapon = false
		end

		sharedActor:UndressSlot(self:GetID())
		self:ResetButton()
	end
end

function DressingRoom:Update(...)

	local viewedLink = ...
	local frame = BW_DressingRoomFrame
	if not BW_DressingRoomFrame then return end

	if not frame.pauseUpdate or viewedLink then
		frame.pauseUpdate = true
		inspectView = false
		C_Timer.After(0, function()
			DressingRoom:GetSource(frame.mainHandEnchant, frame.offHandEnchant)
			frame.pauseUpdate = nil
			local sharedActor = DressUpFrame.ModelScene:GetPlayerActor()
			if (not sharedActor) then
				return false
			end

			if not inspectView and (HideWeaponOnShow or HideTabardOnShow or HideShirtOnShow or HideArmorOnShow)  then
				for _, button in pairs(Buttons) do
					local slot = button:GetID()
					if ((HideWeaponOnShow and (slot == INVSLOT_MAINHAND or slot == INVSLOT_OFFHAND)) or
						(HideTabardOnShow and slot == INVSLOT_TABARD) or
						(HideShirtOnShow and slot == INVSLOT_BODY) or
						HideArmorOnShow) then
							button.isHidden = true
							sharedActor:UndressSlot(slot)
							button.Icon:SetDesaturated(true)
							button:SetAlpha(EmptySlotAlpha)
					end
				end

				HideArmorOnShow = false
				HideWeaponOnShow = false
				HideTabardOnShow = false
				HideShirtOnShow = false
				reset = false
			end


			if viewedLink and viewedLink.sourceID and forceView then 
				sharedActor:TryOn(viewedLink)
				forceView = false
				DressingRoom:Update()
			end

		end)
	end
end

function addon:UpdateDressingRoom(...)
	DressingRoom:Update()
end

function DressingRoom:GetSource(mainHandEnchant, offHandEnchant)
	local enchantID
	wipe(newSet.items)
	wipe(ItemList)

	for _, button in pairs(Buttons) do
		local slotID = button:GetID()
		if slotID == 16 then
			enchantID = mainHandEnchant or ""
		elseif slotID == 17 then
			enchantID = offHandEnchant or ""
		else
			enchantID = ""
		end
		local appliedSourceID, appearanceID, icon, hasMog, itemLink,  itemName, itemID = GetDressUpModelSlotSource(slotID, enchantID)
	
		ItemList[slotID] = {itemName, sourceTextColorized, itemID, bonusID}
		newSet.items[slotID] = itemLink
		button.itemLink = itemLink
		button.appearanceID = appearanceID

		if icon then
			if appliedSourceID then
				button.sourceID = appliedSourceID
			end

			button.Icon:SetTexture(icon)
			if hasMog then
				button.IconBorder:SetAtlas("loottoast-itemborder-gold")

			else
				button.IconBorder:SetAtlas("loottoast-itemborder-purple")
			end

			button.Icon:SetDesaturated(false)
			button.isHidden = false
			button:SetAlpha(1)
			button.Icon:Show()
			button.IconBorder:Show()
		else
			if button.isHidden then
				button:SetAlpha(EmptySlotAlpha)
			else
				button:ResetButton()
			end
		end
	end
end

local DefaultActorID = 1620;
local ActorIDList = {
	[4207724] = 1653, --Dracthyr
	[4395382] = 1654, --Dracthyr Male Visage
	[4220488] = 1654, --Dracthyr Female Visage
	[307454] = 1626, --Worgen Male
	[307453] = 1645, --Worgen Female
};

local isPlayer = false
function DressingRoom:UpdateModel(unit)
	local unit = unit or "player";
	if not UnitExists(unit) or not UnitIsPlayer(unit) or not CanInspect(unit, false) then
		return
	end

	SetDressUpBackground(unit);
	local actor = DressUpFrame.ModelScene:GetPlayerActor();

	if not actor then return end;
	
	local itemList;
	if actor then
		itemList = CopyTable(actor:GetItemTransmogInfoList());
	end
	
	if unit ~= "player" then
		BW_DressingRoomFrame:RegisterEvent("INSPECT_READY")
		NotifyInspect(unit);
	end

	UnitInfo.raceID = select(3, UnitRace(unit));
	UnitInfo.classID = select(3, UnitClass(unit));
	UnitInfo.genderID = UnitSex(unit);

	local model, refresh;
	local sheatheWeapons = actor:GetSheathed() or false;

	if useTarget then
		model = unit;
		isPlayer = false;
		actor:SetModelByUnit(model, sheatheWeapons, true, false, addon.useNativeForm );
		refresh = true;

	else
		model = "player";
		if not isPlayer then
			isPlayer = true;
			actor:SetModelByUnit(model, sheatheWeapons, true, false, addon.useNativeForm);
			refresh = true;
		end
	end

	if refresh then
		C_Timer.After(0.1, function() 			
			local fileID = actor:GetModelFileID();
			local infoID;
			if fileID and ActorIDList[fileID] then
				infoID = ActorIDList[fileID];
			else
				infoID = DefaultActorID;
			end
			local modelInfo = C_ModelInfo.GetModelSceneActorInfoByID(infoID);

			if modelInfo then
				actor:ApplyFromModelSceneActorInfo(modelInfo);
			end

			if itemList then
				for slotID, transmogInfo in ipairs(itemList) do
					actor:SetItemTransmogInfo(transmogInfo, slotID);
				end
			end
		 end)
	end
end

BW_DressingRoomFrameMixin = {}
function BW_DressingRoomFrameMixin:OnLoad()
	self:RegisterEvent("ADDON_LOADED");

--[[
	DressUpFrame.LinkButton:ClearAllPoints()
	DressUpFrame.LinkButton:SetPoint("LEFT",BW_DressingRoomFrame.BW_DressingRoomUndressButton, "RIGHT",-6,0)
	DressUpFrame.LinkButton:SetText("")
	
	DressUpFrame.LinkButton.Left:Hide()
	DressUpFrame.LinkButton.Right:Hide()
	DressUpFrame.LinkButton.Middle:Hide()
	DressUpFrame.LinkButton:SetSize(32,32)
	DressUpFrame.LinkButton:SetFrameLevel(BW_DressingRoomFrame.BW_DressingRoomUndressButton:GetFrameLevel()+5)
	DressUpFrame.LinkButton:SetNormalTexture("Interface\\Buttons\\UI-SquareButton-Up")

	DressUpFrame.LinkButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight","ADD")
	DressUpFrame.LinkButton:SetHitRectInsets(0, 0, 0, 0)
	DressUpFrame.LinkButton.Icon = DressUpFrame.LinkButton:CreateTexture(nil, "OVERLAY")
	DressUpFrame.LinkButton.Icon:SetTexture("Interface\\CHATFRAME\\UI-ChatWhisperIcon")
	DressUpFrame.LinkButton.Icon:SetWidth(13)
	DressUpFrame.LinkButton.Icon:SetHeight(13)
	DressUpFrame.LinkButton.Icon:SetPoint("CENTER")
	local highlight = DressUpFrame.LinkButton:GetHighlightTexture()
	highlight:ClearAllPoints()
	highlight:SetPoint("TOPLEFT",DressUpFrame.LinkButton, "TOPLEFT",-3,-1 )
	highlight:SetPoint("BOTTOMRIGHT",DressUpFrame.LinkButton, "BOTTOMRIGHT",-8,5 )
--]]
	if C_AddOns.IsAddOnLoaded("Narcissus") then
		BW_DressingRoomFrame.BW_DressingRoomSwapFormButton:Hide();
	end
end


function BW_DressingRoomFrameMixin:OnShow()
	itemhistory = {};
	BW_DressingRoomFrame.BW_DressingRoomUndoButton:Hide();
	addon:StoreItems();
	if not Profile.DR_OptionsEnable then return end

	BW_DressingRoomFrame.PreviewButtonFrame:SetShown(addon.Profile.DR_ShowItemButtons);
	DressingRoom:UpdateBackground();
	HideArmorOnShow = addon.Profile.DR_StartUndressed;
	HideWeaponOnShow = addon.Profile.DR_HideWeapons;
	HideTabardOnShow = addon.Profile.DR_HideTabard;
	HideShirtOnShow = addon.Profile.DR_HideShirt;
	forceView = true;

	if not GetCVarBool("transmogShouldersSeparately") then 
		BW_DressingRoomFrame.PreviewButtonFrame.PreviewButtonRightShoulder:Hide();
		BW_DressingRoomFrame.PreviewButtonFrame.PreviewButtonBack:ClearAllPoints();
		BW_DressingRoomFrame.PreviewButtonFrame.PreviewButtonBack:SetPoint("TOPLEFT", BW_DressingRoomFrame.PreviewButtonFrame.PreviewButtonLeftShoulder,"BOTTOMLEFT")
	else
		BW_DressingRoomFrame.PreviewButtonFrame.PreviewButtonRightShoulder:Show();
		BW_DressingRoomFrame.PreviewButtonFrame.PreviewButtonBack:ClearAllPoints();
		BW_DressingRoomFrame.PreviewButtonFrame.PreviewButtonBack:SetPoint("TOPLEFT", BW_DressingRoomFrame.PreviewButtonFrame.PreviewButtonRightShoulder,"BOTTOMLEFT")
	end

	C_Timer.After(0, function() DressingRoom:GetSource() end);
end


function BW_DressingRoomFrameMixin:OnHide()
	self:UnregisterEvent("INSPECT_READY")
	self.isActorHooked = false
end

function BW_DressingRoomFrameMixin:OnEvent(event, ...)
	local arg1 = ...
	if event == "INSPECT_READY" then
		self:UnregisterEvent("INSPECT_READY")
		C_Timer.After(0, function()
			DressUpItemTransmogInfoList(C_TransmogCollection.GetInspectItemTransmogInfoList())
			ClearInspectPlayer()
		end)

	elseif event == "ADDON_LOADED" and arg1 == "Blizzard_InspectUI" then 
		addon:HookScript(InspectPaperDollFrame.ViewButton, "OnClick", function() inspectView = true end)
		self:UnregisterEvent("ADDON_LOADED")

	elseif event == "ADDON_LOADED" and arg1 == "Narcissus" then
		BW_DressingRoomFrame.BW_DressingRoomSwapFormButton:Hide()
	end
end


local function DressupSettingsButton_OnClick(self)
	local function GeneratorFunction(owner, rootDescription)
		local Profile = addon.Profile

		rootDescription:CreateTitle(L["Display Options"]);
		rootDescription:CreateCheckbox(L["Show Item Buttons"], function() return Profile.DR_ShowItemButtons end, function()
				Profile.DR_ShowItemButtons = not Profile.DR_ShowItemButtons
				BW_DressingRoomFrame.PreviewButtonFrame:SetShown(addon.Profile.DR_ShowItemButtons)
			end);
		rootDescription:CreateCheckbox(L["Show DressingRoom Controls"], function() return Profile.DR_ShowControls end, function()
				Profile.DR_ShowControls = not Profile.DR_ShowControls
				--DressingRoom:ToggleControlPanel(Profile.DR_ShowControls)
			end);
		rootDescription:CreateCheckbox(L["Dim Backround Image"], function() return Profile.DR_DimBackground end, function()
				Profile.DR_DimBackground = not Profile.DR_DimBackground
				DressingRoom:UpdateBackground()
			end);
		rootDescription:CreateCheckbox(L["Hide Backround Image"], function() return Profile.DR_HideBackground end, function()
				Profile.DR_HideBackground = not Profile.DR_HideBackground
				DressingRoom:UpdateBackground()
			end);
		rootDescription:CreateTitle(L["Character Options"]);
		rootDescription:CreateCheckbox(L["Start Undressed"], function() return Profile.DR_StartUndressed end, function() Profile.DR_StartUndressed = not Profile.DR_StartUndressed end);
		rootDescription:CreateCheckbox(L["Hide Tabard"], function() return Profile.DR_HideTabard end, function() Profile.DR_HideTabard = not Profile.DR_HideTabard end);
		rootDescription:CreateCheckbox(L["Hide Weapons"], function() return Profile.DR_HideWeapons end, function() Profile.DR_HideWeapons = not Profile.DR_HideWeapons end);
		rootDescription:CreateCheckbox(L["Hide Shirt"], function() return Profile.DR_HideShirt end, function() Profile.DR_HideShirt = not Profile.DR_HideShirt end);
	end
	
	MenuUtil.CreateContextMenu(parent, GeneratorFunction);
end

local function BW_DressingRoomImportButton_OnClick(self)

	local function GeneratorFunction(owner, rootDescription)
		local Profile = addon.Profile

		rootDescription:CreateTitle(L["Import/Export Options"]);
		rootDescription:CreateButton(L["Load Set: %s"]:format( name or L["None Selected"]), function()
				local sources
				local setType = addon.QueueList[1]
				local setID = addon.QueueList[2]
				local playerActor = DressUpFrame.ModelScene:GetPlayerActor()

				if not playerActor or not setID then
					return false
				end

				if setType == "set" then
					sources = C_TransmogSets.GetSetSources(setID)
				elseif setType == "extraset" then
					sources = addon.SetsDataProvider:GetSetSources(setID) --addon.GetSetsources(setID)
				end

				if not sources then return end

				playerActor:Undress()
				for i, d in pairs(sources)do
					playerActor:TryOn(i)
				end

				import = true
				--DressUpSources(sources)
				import = false
				DressingRoom:Update()
			end);

	
		if  C_Transmog.IsAtTransmogNPC() then
			rootDescription:CreateButton(L["Import Set"], function() addon.importFrom = "tmog"; BetterWardrobeOutfitManager:ShowPopup("BETTER_WARDROBE_IMPORT_SET_POPUP") end);
			rootDescription:CreateButton(L["Export Set"], function() addon:ExportTransmogVendorSet() end);


		else
			rootDescription:CreateButton(L["Import Item"], function() BetterWardrobeOutfitManager:ShowPopup("BETTER_WARDROBE_IMPORT_ITEM_POPUP") end);
			rootDescription:CreateButton(L["Import Set"], function() BetterWardrobeOutfitManager:ShowPopup("BETTER_WARDROBE_IMPORT_SET_POPUP") end);
			rootDescription:CreateButton(L["Export Set"], function() addon:ExportSet() end);

		--rootDescription:CreateButton(L["Create Dressing Room Command Link"], function() addon:CreateChatLink() end);
		end

		end
	
	MenuUtil.CreateContextMenu(parent, GeneratorFunction);
end


BW_DressingRoomButtonMixin = {}
function BW_DressingRoomButtonMixin:OnMouseDown()
	BW_GameTooltip:Hide()
	local button = self.buttonID
	if not button then return end
	if button == "Settings" then
		DressupSettingsButton_OnClick(self)

	elseif button == "Import" then
		BW_DressingRoomImportButton_OnClick(self)
	elseif button == "Player" then
		useTarget = false
		DressingRoom:UpdateModel("player")

	elseif button == "Target" then
		useTarget = true
		DressingRoom:UpdateModel("target")

	elseif button == "Gear" then
		--DressingRoom:SetTargetGear()
		useTarget = false
		DressingRoom:UpdateModel("target")

	elseif button == "Reset" then
		text = RESET

	elseif button == "Undress" then
		BW_DressingRoomHideArmorButton_OnClick(self)

	elseif button == "Undo" then
		DressingRoom:Undo()

	--elseif button == "Link" then
		--DressUpModelFrameLinkButtonMixin:OnClick()
	end
end

function BW_DressingRoomButtonMixin.OnEnter(self)
	local button = self.buttonID
	local text
	if not button then return end
	if button == "Settings" then
	text = L["General Options"]
	elseif button == "Import" then
		text = L["Import/Export Options"]

	elseif button == "Player" then
		text = L["Use Player Model"]

	elseif button == "Target" then
		text = L["Use Target Model"]

	elseif button == "Gear" then
		text = L["Use Target Gear"]

	elseif button == "Reset" then
		text = RESET

	elseif button == "Undress" then
		text = L["Undress"]
	elseif button == "Undo" then
		text = L["Undo"]
	elseif button == "HideSlot" then
		text = L["Hide Armor Slots"]

	elseif button == "Link" then
		text = LINK_TRANSMOG_OUTFIT_HELPTIP
	end

	BW_GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	BW_GameTooltip:SetText(text)
	BW_GameTooltip:Show()
end

function BW_DressingRoomButtonMixin.OnLeave()
	BW_GameTooltip:Hide()
end

function DressingRoom:UpdateBackground()
	if (addon.Profile.DR_DimBackground) then
		DressUpFrame.ModelBackground:SetVertexColor(0.52, 0.52, 0.52)
	else
		DressUpFrame.ModelBackground:SetVertexColor(1.0, 1.0, 1.0)
	end

	if (addon.Profile.DR_HideBackground) then
		DressUpFrame.ModelBackground:SetVertexColor(0, 0, 0)
	end
end

function BW_DressingRoomHideArmorButton_OnClick()
	local playerActor = DressUpFrame.ModelScene:GetPlayerActor()
		if (not playerActor) then
		return false
	end
	playerActor:Undress()
	DressingRoom:Update()
end




function addon:StoreItems()
	local playerActor = DressUpFrame.ModelScene:GetPlayerActor();
	local itemTransmogInfoList = playerActor and playerActor:GetItemTransmogInfoList();
	local slashCommand = itemTransmogInfoList and TransmogUtil.CreateOutfitSlashCommand(itemTransmogInfoList) or "";
	slashCommand = string.gsub(slashCommand, "/outfit ", "")
	tinsert(itemhistory, slashCommand)

	if  #itemhistory > 1 then
		BW_DressingRoomFrame.BW_DressingRoomUndoButton:Show()
	end

end

function DressingRoom:Undo()
	local msg = itemhistory[#itemhistory]
	tremove(itemhistory, #itemhistory)
	local itemTransmogInfoList = TransmogUtil.ParseOutfitSlashCommand(msg);
	if itemTransmogInfoList then
		local showOutfitDetails = true;
		DressUpItemTransmogInfoList(itemTransmogInfoList, showOutfitDetails);
	end
	if  #itemhistory == 1 then
		BW_DressingRoomFrame.BW_DressingRoomUndoButton:Hide()
	end
end


--======
BetterDressUpOutfitMixin = { }

function BetterDressUpOutfitMixin:GetItemTransmogInfoList()
	local playerActor = DressUpFrame.ModelScene:GetPlayerActor()
	if playerActor then
		return playerActor:GetItemTransmogInfoList()
	end
	return nil
end

function BetterDressUpOutfitMixin:LoadOutfit(outfitID)
	if not outfitID then
		return false
	end
	local playerActor = DressUpFrame.ModelScene:GetPlayerActor()
		if (not playerActor) then
		return false
	end

	local MogItOutfit = false
	if outfitID > 1000 then MogItOutfit = true end

	playerActor:Undress()
	DressingRoom:Update()
	import = true
	local setType = addon.GetSetType(outfitID)
	if setType == "SavedBlizzard"  or (outfitID >= 5000 and outfitID <= 5020) then
		local outfitID = addon:GetBlizzID(outfitID)
		DressUpItemTransmogInfoList(C_TransmogCollection.GetOutfitItemTransmogInfoList(outfitID))
	else
		local outfit = addon.GetSetInfo(outfitID)
		local itemTransmogInfoList = {}


			local itemData = outfit.itemData
			--itemData[i] = {"'"..itemID..":"..itemMod.."'", sourceID, appearanceID}
			local items = outfit.items
			local itemTransmogInfo

			--for index, data in ipairs(itemData) do
			for i = 1, 19 do

				local secondary = (i == 3 and outfit.offShoulder) or 0
				local sourceID = itemData[i] and itemData[i][2]

				if sourceID then 
					itemTransmogInfo = ItemUtil.CreateItemTransmogInfo(sourceID or 0, secondary, 0)
				else
					itemTransmogInfo = ItemUtil.CreateItemTransmogInfo( 0, 0, 0)
				end
				itemTransmogInfoList[i] = itemTransmogInfo
				
			end
		
		DressUpItemTransmogInfoList(itemTransmogInfoList)
	end

	import = false
	DressingRoom:Update()
end


function addon:DressinRoomFormSwap()
	DressingRoom:UpdateModel("player")
end

