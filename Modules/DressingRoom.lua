local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)


local DressingRoom = {}
local After = C_Timer.After

local DressUpModel
local SLOT_BUTTON_INDEX = {}
local INVENTORY_SLOT_NAMES = addon.Globals.INVENTORY_SLOT_NAMES

local import = false
local useCharacterSources = true

local defaultWidth, defaultHeight = 450, 545
local Buttons
local Profile

local C_TransmogCollection = C_TransmogCollection
local GetTransmogItemInfo = C_TransmogCollection.GetItemInfo
local GetTransmogSourceInfo = C_TransmogCollection.GetSourceInfo
local PlayerHasTransmog = C_TransmogCollection.PlayerHasTransmog
local IsNewAppearance = C_TransmogCollection.IsNewAppearance
local GetIllusionSourceInfo = C_TransmogCollection.GetIllusionSourceInfo
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
local UseTargetModel = true;  

local TP = CreateFrame("GameTooltip", "BW_VirtualTooltip", nil, "GameTooltipTemplate")
TP:SetScript("OnLoad", GameTooltip_OnLoad)
TP:SetOwner(UIParent, 'ANCHOR_NONE')

function addon.Init:DressingRoom()
	DressingRoom:CreateDropDown()
	Buttons = BW_DressingRoomFrame.PreviewButtonFrame.Slots
	Profile = addon.Profile

	if addon.Profile.DR_OptionsEnable then 
		addon:DressingRoom_Enable()
	end
end

--Creates the Dressing Room Outfit Dropdown using the menu library
function DressingRoom:CreateDropDown()
	--local f = BW_UIDropDownMenu_Create("BW_DressingRoomOutfitDropDown", DressUpFrame)
	local f  = CreateFrame("Frame", "BW_DressingRoomOutfitDropDown", DressUpFrame, "BW_UIDropDownMenuTemplate")

	f.width = 163
	f.minMenuStringWidth = 127
	f.maxMenuStringWidth = 190

	f:SetPoint("TOP", -23, -28)
	Mixin(f, WardrobeOutfitDropDownMixin)
	Mixin(f, BW_DressingRoomMixin)
	f.SaveButton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.SaveButton:SetSize(88, 22)
	local button = _G[f:GetName().."Button"]
	f.SaveButton:SetPoint("LEFT", button, "RIGHT", 3, 0)
	f.SaveButton:SetScript("OnClick", function(self)
					PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
					local dropDown = self:GetParent();
					print("clicky")
					dropDown:CheckOutfitForSave(BW_UIDropDownMenu_GetText(dropDown));
				end)
	f.SaveButton:SetText(SAVE)
	f:SetScript("OnLoad", f.OnLoad)
	f:OnLoad()
	f:SetScript("OnEvent", f.OnEvent)
	f:SetScript("OnShow", f.OnShow)
	f:SetScript("OnHide", f.OnHide)
	DressUpFrame.BW_OutfitDropDown = f
	BW_DressingRoomOutfitDropDown = f
	f:SetFrameLevel(500)
end


function addon:DressingRoom_Enable()
	--hooksecurefunc("DressUpVisual", UpdateDressingRoom)

	addon:SecureHook("DressUpVisual", UpdateDressingRoom)
	addon:SecureHook("DressUpSources", UpdateDressingRoom)
	--addon:SecureHook("DressUpFrame_OnDressModel",function(self) DressingRoom:OnDressModel(self) end)
				
	--DressUpFrame.MaximizeMinimizeFrame:SetOnMaximizedCallback(DressingRoom.SetFrameSize)

	addon:HookScript(DressUpFrameResetButton,"OnClick", function() 
		HideArmorOnShow = addon.Profile.DR_StartUndressed
		HideWeaponOnShow = addon.Profile.DR_HideWeapons
		HideTabardOnShow = addon.Profile.DR_HideTabard
		HideShirtOnShow = addon.Profile.DR_HideShirt
		UpdateDressingRoom()
	end)

	--addon:HookScript(DressUpFrame.MaximizeMinimizeFrame.MaximizeButton,"OnClick", function()  C_Timer.After(0, function() DressingRoom:SetFrameSize() end) end)
end

function addon:DressingRoom_Disable()
	addon:Unhook("DressUpVisual")
	addon:Unhook("DressUpSources")
	addon:Unhook("DressUpFrame_OnDressModel")
	addon:Unhook(DressUpFrameResetButton,"OnClick")
	--addon:Unhook(DressUpFrame.MaximizeMinimizeFrame.MaximizeButton,"OnClick")

	BW_DressingRoomFrame:Hide()
	--DressUpFrame:SetMovable(false)
	--DressUpFrame:SetScript("OnDragStart", nil)
	--DressUpFrame:SetScript("OnDragStop", nil)
			
--	local function OnMaximize(frame)
		--DressUpFrame:SetSize(450, 545);
		--UpdateUIPanelPositions(frame);
	--end		
	--DressUpFrame.MaximizeMinimizeFrame:SetOnMaximizedCallback(OnMaximize)

	--if not GetCVarBool("miniDressupFrame") then 
		--OnMaximize(DressUpFrame)	
	--end
	--addon.Profile.DR_OptionsEnable
end

local function IsAppearanceKnown(itemLink)
	--Need to correspond with C_TransmogCollection.PlayerHasTransmog
	if not itemLink then    return end
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
	if (not playerActor) then
		return
	end
	local appliedSourceID, illusionSourceID = playerActor:GetSlotTransmogSources(slotID)
	local illusionName, isIllusionCollected, illusionHyperlink, illusionVisualID
	if illusionSourceID and illusionSourceID ~= 0 then
		local illusionSourceInfo = GetTransmogSourceInfo(illusionSourceID)
		--print("illusionSourceID: "..illusionSourceID)
		if illusionSourceInfo then
			isIllusionCollected = illusionSourceInfo.isCollected
			illusionVisualID, illusionName, illusionHyperlink = GetIllusionSourceInfo(illusionSourceID)
			--print(illusionName)
		end
	end
	if appliedSourceID < 0 then return end

	local sourceInfo = GetTransmogSourceInfo(appliedSourceID)
	if not sourceInfo then return end
	local sourceType = sourceInfo.sourceType
	local visualID = sourceInfo.sourceInfo
	local itemModID = sourceInfo.itemModID
	local itemID = sourceInfo.itemID
	local itemName = sourceInfo.name 
	local appearanceID, sourceID = GetTransmogItemInfo(itemID, itemModID)							        --appearanceID, sourceID
	local itemIcon = C_TransmogCollection.GetSourceIcon(appliedSourceID)
	local categoryID = sourceInfo.categoryID
	local itemLink = select(6, C_TransmogCollection.GetAppearanceSourceInfo(appliedSourceID))
	local hasAppearance = PlayerHasTransmog(itemID, itemModID) or IsAppearanceKnown(itemLink)
	local itemQuality = sourceInfo.quality or 12	

	if categoryID == 25 or categoryID == 26 or categoryID == 27 then 
		rangedWeapon = true
	elseif categoryID >= 12 then
		rangedWeapon = false
	end		

	return appliedSourceID, appearanceID, itemIcon, hasAppearance, itemLink, itemName, itemID
end

local function GetDressingSource(mainHandEnchant, offHandEnchant)
	local button, appliedSourceID, icon, itemLink, itemName, itemID, bonusID, sourceTextColorized, isIllusionCollected, illusionHyperlink
	local enchantID
	local sharedActor = DressUpFrame.ModelScene:GetPlayerActor()

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
			appliedSourceID, appearanceID, icon, hasMog, itemLink,  itemName, itemID = GetDressUpModelSlotSource(slotID, enchantID)

			if illusionHyperlink then
				--itemLink = illusionHyperlink
			end     
			ItemList[slotID] = {itemName, sourceTextColorized, itemID, bonusID}
			newSet.items[slotID] = itemLink
			--button = Buttons[slotID]
			button.itemLink = itemLink

			button.appearanceID = appearanceID
			if icon then
				if appliedSourceID then
					button.sourceID = appliedSourceID
				end
				button.Icon:SetTexture(icon)
				if hasMog then
					button.Icon:SetDesaturated(false)
					button.IconBorder:SetAtlas("loottoast-itemborder-gold")
					--button.Black:Hide()
					button.isHidden = false
				else
					button.IconBorder:SetAtlas("loottoast-itemborder-purple")
					--button.Icon:SetDesaturated(true)
					--button.Black:Show()
				end
				button:SetAlpha(1)
				button.Icon:Show()

				if HideArmorOnShow then 

					--sharedActor:UndressSlot(button:GetID())
					--button.Icon:SetDesaturated(true)
				end
			else
				if button.isHidden then
					button:SetAlpha(EmptySlotAlpha)
				else
					button:SetAlpha(EmptySlotAlpha)
					button.Icon:Hide()
				end
			end
		

	end
end


local ActorIDByRace = {
    [2]  = {483, 483},		-- Orc bow
    [3]  = {471, nil},		-- Dwarf
    [5]  = {472, 487},		-- UD   0.9585 seems small
    [6]  = {449, 484},		-- Tauren
    [7]  = {450, 450},		-- Gnome
    [8]  = {485, 486},		-- Troll  0.9414 too high?  
    [9]  = {476, 477},		-- Goblin
    [11] = {475, 501},		-- Goat
    [22] = {474, 500},      -- Worgen
    [24] = {473, 473},		-- Pandaren
    [28] = {490, 491},		-- Highmountain Tauren
    [30] = {488, 489},		-- Lightforged Draenei
    [31] = {492, 492},		-- Zandalari
    [32] = {494, 497},		-- Kul'Tiran
    [34] = {499, nil},		-- Dark Iron Dwarf
    [35] = {924, 923},      -- Vulpera
    [36] = {495, 498},		-- Mag'har
    [37] = {929, 931},      -- Mechagnome
}

local DEFAULT_ACTOR_INFO_ID = 438;

local PanningYOffsetByRace = {
    --[raceID] = { { male = {offsetY1 when frame maximiazed, offsetY2} }, {female = ...} }
    [0] = {     --default
        {-290, -110},
    },

    [4] = { --NE
        {-317, -117},
        {-282, -115.5},
    },

    [10] = {    --BE
        {-282, -110},
        {-290, -116}, 
    }
    --/dump DressUpFrame.ModelScene:GetActiveCamera().panningYOffset
}

PanningYOffsetByRace[29] = PanningYOffsetByRace[10];
local GetModelSceneActorInfoByID = C_ModelInfo.GetModelSceneActorInfoByID;

local function GetPanningYOffset(raceID, genderID)
    genderID = genderID -1;
    if PanningYOffsetByRace[raceID] and PanningYOffsetByRace[raceID][genderID] then
        return PanningYOffsetByRace[raceID][genderID]
    else
        return PanningYOffsetByRace[0][1]
    end
end

function GetActorInfoByUnit(unit)
    if not UnitExists(unit) or not UnitIsPlayer(unit) or not CanInspect(unit, false) then return nil, PanningYOffsetByRace[0][1]; end
    
    local _, _, raceID = UnitRace(unit);
    local genderID = UnitSex(unit);
    if raceID == 25 or raceID == 26 then --Pandaren A|H
        raceID = 24
    end

    local actorInfoID;
    if not (raceID and genderID) then
        actorInfoID = DEFAULT_ACTOR_INFO_ID;     --438
    elseif ActorIDByRace[raceID] then
        actorInfoID = ActorIDByRace[raceID][genderID - 1] or DEFAULT_ACTOR_INFO_ID;
    else
        actorInfoID = DEFAULT_ACTOR_INFO_ID;     --438
    end

    return GetModelSceneActorInfoByID(actorInfoID)
end

local IsCurrentModelPlayer = false

local function UpdateDressingRoomModel(unit)
	unit = unit or "player"
	--local NarciBridge = NarciBridge_DressUpFrame
	if not UnitExists(unit) then
		return
	elseif not UnitIsPlayer(unit) or not CanInspect(unit, false) then
	   -- NarciBridge.OptionFrame.TryOnButton:Disable()
		return
	else
	  --  NarciBridge.OptionFrame.TryOnButton:Enable()
	end

	SetDressUpBackground(unit)
	local ModelScene = DressUpFrame.ModelScene
	local actor = ModelScene:GetPlayerActor()
	if not actor then return end
	
	--Acquire target's gears
	BW_DressingRoomFrame:RegisterEvent("INSPECT_READY")
	NotifyInspect(unit)

	local _
	_, _, UnitInfo.raceID = UnitRace(unit)
	UnitInfo.genderID = UnitSex(unit)
	_, _, UnitInfo.classID = UnitClass(unit)

	local modelUnit
	local updateScale
	local sheatheWeapons = actor:GetSheathed() or false

	if UseTargetModel then
		modelUnit = unit
		actor:SetModelByUnit(modelUnit, sheatheWeapons, true)
		updateScale = true
		IsCurrentModelPlayer = false
	else
		modelUnit = "player"
		if not IsCurrentModelPlayer then
			IsCurrentModelPlayer = true
			actor:SetModelByUnit(modelUnit, sheatheWeapons, true)
			updateScale = true
		end
	end

	if updateScale then
		print(modelUnit)
		local modelInfo = GetActorInfoByUnit(modelUnit)
		After(0.0,function()
			ModelScene:InitializeActor(actor, modelInfo)   --Re-scale
		end)
	end

	--Update Unsheathed Animation
	--SetAnimationIDByUnit(unit)
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

	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 0, 40)
	
	if self.itemLink then
		GameTooltip:SetHyperlink(self.itemLink)
	else
		GameTooltip:AddLine(_G[slot])
	end
	GameTooltip:Show()
	
	ShoppingTooltip1:Hide()
	ShoppingTooltip2:Hide()
	if ShoppingTooltip3 then ShoppingTooltip3:Hide()  end
end


function BW_DressingRoomItemButtonMixin:OnLeave()
	GameTooltip:Hide()
end

function BW_DressingRoomItemButtonMixin:OnClick()
end


function BW_DressingRoomItemButtonMixin:OnMouseDown(button)
	if button == "LeftButton" then
		GameTooltip:Hide()
		self.isHidden = not self.isHidden
		local sharedActor = DressUpFrame.ModelScene:GetPlayerActor()
		if (not sharedActor) then
			return
		end

		local slot = self:GetID()

		if self.isHidden then
			if slot == 16 and rangedWeapon then 
				sharedActor:UndressSlot(17)
			elseif slot == 17 and rangedWeapon then 
				return
			end
			sharedActor:UndressSlot(self:GetID())
			self.Icon:SetDesaturated(true)
			self:SetAlpha(EmptySlotAlpha)
		elseif self.sourceID then
			--print(self.sourceID)
			--sharedActor:TryOn(self.sourceID)
			

			if self.Artifact then
				sharedActor:TryOn(self.itemSource, nil, self.enchantID)
			else
				--sharedActor:TryOn(self.itemLink)
				sharedActor:TryOn(self.sourceID)

			end
			self:SetAlpha(1)
			self.Icon:SetDesaturated(false)
		end
	end
end


function BW_DressingRoomHideArmorButton_OnClick()
	local sharedActor = DressUpFrame.ModelScene:GetPlayerActor()
		if (not sharedActor) then
			return false
		end

	for _, button in pairs(Buttons) do
		button.isHidden = true
		local slot = button:GetID()
		sharedActor:UndressSlot(slot)
		button.Icon:SetDesaturated(true)
		button:SetAlpha(EmptySlotAlpha)
	end

end

function UpdateDressingRoom(...)
	local frame = BW_DressingRoomFrame
	local viewedLink = ...

	local appearanceID = ((viewedLink and type(viewedLink) == "string") and C_TransmogCollection.GetItemInfo(viewedLink))

	if not frame.pauseUpdate then
		frame.pauseUpdate = true
		After(0, function()
			GetDressingSource(frame.mainHandEnchant, frame.offHandEnchant)
			frame.pauseUpdate = nil
			local sharedActor = DressUpFrame.ModelScene:GetPlayerActor()
			if (not sharedActor) then
				return false
			end

			for _, button in pairs(Buttons) do
				local slot = button:GetID()
				if ((HideWeaponOnShow and (slot == INVSLOT_MAINHAND or slot == INVSLOT_OFFHAND)) or 
					(HideTabardOnShow and slot == INVSLOT_TABARD) or
					(HideShirtOnShow and slot == INVSLOT_BODY) or
					HideArmorOnShow ) 
						and button.appearanceID ~= appearanceID then 
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
		end)
	end
end


BW_DressingRoomFrameMixin = {}
function BW_DressingRoomFrameMixin:OnLoad()
	hooksecurefunc("DressUpVisual", UpdateDressingRoom)
end


function BW_DressingRoomFrameMixin:OnShow()
	BW_DressingRoomFrame.PreviewButtonFrame:SetShown(addon.Profile.DR_ShowItemButtons)
	DressingRoom:UpdateBackground()	
	HideArmorOnShow = addon.Profile.DR_StartUndressed
	HideWeaponOnShow = addon.Profile.DR_HideWeapons
	HideTabardOnShow = addon.Profile.DR_HideTabard
	HideShirtOnShow = addon.Profile.DR_HideShirt

	After(0, function()
		GetDressingSource()
	end)
end


function BW_DressingRoomFrameMixin:OnHide()
	self:UnregisterEvent("INSPECT_READY")
	self.isActorHooked = false
end


function BW_DressingRoomFrameMixin:OnEvent(event, ...)
	if event == "INSPECT_READY" then
		self:UnregisterEvent("INSPECT_READY")
		After(0,function()
			self.mainHandEnchant, self.offHandEnchant = DressUpSources(C_TransmogCollection.GetInspectSources())
			GetDressingSource(self.mainHandEnchant, self.offHandEnchant)
			ClearInspectPlayer()
		end)
	end
end





--local ContextMenu = CreateFrame("Frame", addonName .. "ContextMenuFrame", UIParent, "UIDropDownMenuTemplate")
local ContextMenu = CreateFrame("Frame", addonName .. "ContextMenuFrame", UIParent, "BW_UIDropDownMenuTemplate")

--local ContextMenu = BW_UIDropDownMenu_Create(addonName .. "ContextMenuFrame", UIParent)
addon.ContextMenu = ContextMenu

local function DressupSettingsButton_OnClick(self)
	local Profile = addon.Profile
	local contextMenuData = {
		{
			text = L["Display Options"], isTitle = true, notCheckable = true,
		},
		{
			text = L["Show Item Buttons"],
			func = function()
				Profile.DR_ShowItemButtons = not Profile.DR_ShowItemButtons
				BW_DressingRoomFrame.PreviewButtonFrame:SetShown(addon.Profile.DR_ShowItemButtons)
			end,
			isNotRadio = true,
			checked = function() return Profile.DR_ShowItemButtons end,
		},
		{
			text = L["Show DressingRoom Controls"],
			func = function()
				Profile.DR_ShowControls = not Profile.DR_ShowControls
				DressingRoom:ToggleControlPanel(Profile.DR_ShowControls)
			end,
			isNotRadio = true,
			checked = function() return Profile.DR_ShowControls end,
		},
		{
			text = L["Dim Backround Image"],
			func = function()
				Profile.DR_DimBackground = not Profile.DR_DimBackground
				DressingRoom:UpdateBackground()
			end,
			checked = function() return Profile.DR_DimBackground end,
			isNotRadio = true,
		},
		{
			text = L["Hide Backround Image"],
			func = function()
				Profile.DR_HideBackground = not Profile.DR_HideBackground
				DressingRoom:UpdateBackground()
			end,
			checked = function() return Profile.DR_HideBackground end,
			isNotRadio = true,
		},
		{
			text = L["Character Options"], isTitle = true, notCheckable = true,
		},
		{
			text = L["Start Undressed"],
			func = function() Profile.DR_StartUndressed = not Profile.DR_StartUndressed end,
			checked = function() return Profile.DR_StartUndressed end,
			isNotRadio = true,
		},
		{
			text =  L["Hide Tabard"],
			func = function() Profile.DR_HideTabard = not Profile.DR_HideTabard end,
			checked = function() return Profile.DR_HideTabard end,
			isNotRadio = true,
		},
		{
			text = L["Hide Weapons"],
			func = function() Profile.DR_HideWeapons = not Profile.DR_HideWeapons end,
			checked = function() return Profile.DR_HideWeapons end,
			isNotRadio = true,
		},
		{
			text = L["Hide Shirt"],
			func = function() Profile.DR_HideShirt = not Profile.DR_HideShirt end,
			checked = function() return Profile.DR_HideShirt end,
			isNotRadio = true,
		},
	}
	
	BW_UIDropDownMenu_SetAnchor(ContextMenu, 0, 0, "BOTTOMLEFT", self, "BOTTOMLEFT")

	--ContextMenu:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
	BW_EasyMenu(contextMenuData, ContextMenu, ContextMenu, 0, 0, "MENU",5)

	--DropDownList1:ClearAllPoints()
	--DropDownList1:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
	--DropDownList1:SetClampedToScreen(true)
end


local function BW_DressingRoomImportButton_OnClick(self)
	local Profile = addon.Profile
	local name  = addon.QueueList[3]
	local contextMenuData = {
		{
			text = L["Import/Export Options"], isTitle = true, notCheckable = true,
		},
		{
			text = L["Load Set: %s"]:format( name or L["None Selected"]),
			func = function()
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
					sources = addon.GetSetsources(setID)
				end

				if not sources then return end

				playerActor:Undress()
				for i, d in pairs(sources)do
					playerActor:TryOn(i)
				end

				import = true
				DressUpSources(sources)
				import = false
				--C_Timer.After(0.2, function() BW_DressingRoomItemDetailsMixin:UpdateButtons("loadSet") end)
				UpdateDressingRoom()
			end,
			isNotRadio = true,
			notCheckable = true,
		},
		{
			text = L["Import Item"],
			func = function()
				BW_WardrobeOutfitFrameMixin:ShowPopup("BETTER_WARDROBE_IMPORT_ITEM_POPUP")
			end,
			isNotRadio = true,
			notCheckable = true,
		},
		{
			text = L["Import Set"],
			func = function()
				BW_WardrobeOutfitFrameMixin:ShowPopup("BETTER_WARDROBE_IMPORT_SET_POPUP")
			end,
			isNotRadio = true,
			notCheckable = true,
		},
		{
			text = L["Export Set"],
			func = function()
				addon:ExportSet()

			end,
			notCheckable = true,
			isNotRadio = true,
		},
				{
			text = L["Create Dressing Room Command Link"],
			func = function()
				addon:CreateChatLink()
			end,
			notCheckable = true,
			isNotRadio = true,
		},
	}
	BW_UIDropDownMenu_SetAnchor(ContextMenu, 0, 0, "BOTTOMLEFT", self, "BOTTOMLEFT")
	BW_EasyMenu(contextMenuData, ContextMenu, self, 0, 0, "MENU")
end


BW_DressingRoomButtonMixin = {}
function BW_DressingRoomButtonMixin:OnMouseDown()
	GameTooltip:Hide()
	local button = self.buttonID
	if not button then return end
	if button == "Settings" then 
		DressupSettingsButton_OnClick(self)
	elseif button == "Import" then 
		BW_DressingRoomImportButton_OnClick(self)
	elseif button == "Player" then 
		--DressingRoom.showTarget = false
		--DressingRoom:SetTargetGear(true)
		UseTargetModel = false
		UpdateDressingRoomModel("target")
	elseif button == "Target" then 
		--DressingRoom.showTarget = true
		--DressingRoom:SetTarget()
		--UpdateDressingRoomModel("target")
		UseTargetModel = true
		UpdateDressingRoomModel("target")
	elseif button == "Gear" then 
		--DressingRoom:SetTargetGear()
		UseTargetModel = false
		UpdateDressingRoomModel("target")
	elseif button == "Reset" then 
		text =  RESET
	elseif button == "Undress" then 
		BW_DressingRoomHideArmorButton_OnClick(self)
	end
end


local function SetTooltip(frame, text)
	GameTooltip:SetOwner(frame, "ANCHOR_RIGHT");
	GameTooltip:SetText(text)
	GameTooltip:Show()
end


function BW_DressingRoomButtonMixin:OnEnter()
	local button = self.buttonID
	local text
	if not button then return end
	if button == "Settings" then 
	text =  L["General Options"]
	elseif button == "Import" then 
		text =  L["Import/Export Options"]
	elseif button == "Player" then 
		text =  L["Use Player Model"]
	elseif button == "Target" then 
		text =  L["Use Target Model"]
	elseif button == "Gear" then 
		text =  L["Use Target Gear"]
	elseif button == "Reset" then 
		text =  RESET
	elseif button == "Undress" then 
		text = L["Undress"]
	elseif button == "HideSlot" then 
		text = L["Hide Armor Slots"]
	end

	SetTooltip(self, text)
end



function BW_DressingRoomButtonMixin:OnLeave()
	GameTooltip:Hide()
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



BW_DressingRoomMixin = CreateFromMixins(BW_WardrobeOutfitMixin)

function BW_DressingRoomMixin:OnLoad()
DressUpFrameOutfitDropDown:Hide()
		local button = _G[self:GetName().."Button"]
	button:SetScript("OnMouseDown", function(self)
						PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
						BW_DressingRoomOutfitFrame:Toggle(self:GetParent())
						end
					)
	BW_UIDropDownMenu_JustifyText(self, "LEFT")
	if self.width then
		BW_UIDropDownMenu_SetWidth(self, self.width)
	end
	WardrobeOutfitDropDown:Hide()

	--addon:SecureHook(nil, "WardrobeTransmogFrame_OnTransmogApplied", function()
			--if BW_WardrobeOutfitDropDown.selectedOutfitID and BW_WardrobeOutfitDropDown:IsOutfitDressed( then
				--WardrobeTransmogFrame.BW_OutfitDropDown:OnOutfitApplied(BW_WardrobeOutfitDropDown.selectedOutfitID)
			--end
		--end, true)
end


function BW_DressingRoomMixin:OnShow()
	self:RegisterEvent("TRANSMOG_OUTFITS_CHANGED")
	self:RegisterEvent("TRANSMOGRIFY_UPDATE")
	self:SelectOutfit(BW_WardrobeOutfitDropDown:GetLastOutfitID(), true)
end


function BW_DressingRoomMixin:OnHide()
	self:UnregisterEvent("TRANSMOG_OUTFITS_CHANGED")
	self:UnregisterEvent("TRANSMOGRIFY_UPDATE")
	BW_DressingRoomOutfitFrame:ClosePopups(self)
	if ( BW_DressingRoomOutfitFrame.dropDown == self ) then
		BW_DressingRoomOutfitFrame:Hide()
	end
end

function WardrobeOutfitDropDownMixin:OnEvent(event)
	if ( event == "TRANSMOG_OUTFITS_CHANGED" ) then
		-- try to reselect the same outfit to update the name
		-- if it changed or clear the name if it got deleted
		self:SelectOutfit(self.selectedOutfitID)
		if ( BW_DressingRoomOutfitFrame:IsShown() ) then
			BW_DressingRoomOutfitFrame:Update()
		end
	end
	-- don't need to do anything for "TRANSMOGRIFY_UPDATE" beyond updating the save button
	self:UpdateSaveButton()
end


function BW_DressingRoomMixin:LoadOutfit(outfitID)
	if not outfitID then
		return false
	end
	--if 	initUndress  then return end
	dressuplink = nil
	local playerActor = DressUpFrame.ModelScene:GetPlayerActor()
		if (not playerActor) then
		return false
	end

	local MogItOutfit = false
	if outfitID > 1000 then MogItOutfit = true end

	playerActor:Undress()
	--DressingRoom:ResetItemButtons(DressingRoom:ResetItemButtons(not addon.Profile.DR_StartUndressed) , true)
	--
	import = true
	if self:IsDefaultSet(outfitID) then
		DressUpSources(C_TransmogCollection.GetOutfitSources(outfitID))
	else
		local outfit 
		if outfitID > 1000 then
			outfit = addon.MogIt.MogitSets[outfitID]
		else
			outfit = addon.OutfitDB.char.outfits[LookupIndexFromID(outfitID)]
		end

		local outfit_sources = {}
		--need to itterate a full table as the DressUpSources uses the table size 
		for i=1, 19  do
			outfit_sources[i] = outfit[i] or NO_TRANSMOG_SOURCE_ID
		end
		DressUpSources(outfit_sources, outfit["mainHandEnchant"], outfit["offHandEnchant"])
	end
	import = false
	--DressingRoom:ResetItemButtons(false , true)
	--BW_DressingRoomOutfitDropDown:OnOutfitApplied(outfitID)BW_DressingRoomItemDetailsMixin:UpdateButtons()
	UpdateDressingRoom()
	--C_Timer.After(0.2, function() BW_DressingRoomItemDetailsMixin:UpdateButtons("loadSet") end)
	--
end


BW_DressingRoomOutfitFrameMixin = CreateFromMixins(BW_WardrobeOutfitFrameMixin)

function BW_DressingRoomOutfitFrameMixin:Toggle(dropDown)
	if self.dropDown == dropDown and self:IsShown() then
		self:Hide()
	else
		CloseDropDownMenus()
		BW_CloseDropDownMenus()
		self.dropDown = dropDown
		self:Show()
		self:SetPoint("TOPLEFT", self.dropDown, "BOTTOMLEFT", 8, -3)
		self:Update()
	end
end


function BW_DressingRoomOutfitFrameMixin:GetSlotSourceID(transmogLocation)
	local playerActor = DressUpFrame.ModelScene:GetPlayerActor();
	if (not playerActor) then
		return;
	end

	-- TODO: GetSlotTransmogSources needs to use modification
	local appearanceSourceID, illusionSourceID = playerActor:GetSlotTransmogSources(transmogLocation:GetSlotID());
	if ( transmogLocation:IsAppearance() ) then
		return appearanceSourceID;
	elseif ( transmogLocation:IsIllusion() ) then
		return illusionSourceID;
	end
end

BW_DressingRoomOutfitButtonMixin = CreateFromMixins(BW_WardrobeOutfitButtonMixin)

function BW_DressingRoomOutfitButtonMixin:OnClick()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	BW_DressingRoomOutfitFrame:Hide()
	if self.outfitID then
		BW_DressingRoomOutfitFrame.dropDown:SelectOutfit(self.outfitID, true)
	else
		BW_DressingRoomOutfitFrame.dropDown:CheckOutfitForSave()
	end
end


function BW_DressingRoomHideArmorButton_OnClick()
	dressuplink = nil
	local playerActor = DressUpFrame.ModelScene:GetPlayerActor()
		if (not playerActor) then
		return false
	end
	playerActor:Undress()
	UpdateDressingRoom()

	--BW_DressingRoomItemDetailsMixin:UpdateButtons("undress")
end