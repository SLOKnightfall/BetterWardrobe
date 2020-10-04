local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local DressingRoom = {}

local DressUpModel
local SLOT_BUTTON_INDEX = {}
local Buttons
local INVENTORY_SLOT_NAMES = addon.Globals.INVENTORY_SLOT_NAMES
local dressuplink
local dressupslot
local initUndress = true
local initHide = true
local import = false
local useCharacterSources = true
local Profile

function DressingRoom:SetFrameSize()

	local maxWidth, maxHeight = DressUpFrame:GetMaxResize();
	if (addon.Profile.DR_Width > maxWidth or addon.Profile.DR_Height > maxHeight) then
		DressUpFrame:SetSize(maxWidth, maxHeight);
	
		local width, height = DressUpFrame:GetSize();
		addon.Profile.DR_Width = width;
		addon.Profile.DR_Height = height;
	else
		DressUpFrame:SetSize(addon.Profile.DR_Width, addon.Profile.DR_Height);
	end

	UpdateUIPanelPositions(DressUpFrame);
		UpdateUIPanelPositions(CharacterFrame);
	if CharacterFrame:IsShown() then 
		CharacterFrame:Hide();
		UpdateUIPanelPositions();

		CharacterFrame:Show()
	end
	UpdateUIPanelPositions();

end

function addon.Init:DressingRoom()
	Buttons = BW_DressingRoomFrame.PreviewButtonFrame.Slots
	Profile = addon.Profile

	BW_DressingRoomFrame:SetScript("OnShow", function() C_Timer.After(0.25, DressingRoom.OnShow) end)
	BW_DressingRoomFrame:SetScript("OnHide", DressingRoom.OnHide)
	
	addon:SecureHook("DressUpVisual", C_Timer.After(0.25,addon.DressUpVisual))
	addon:SecureHook("DressUpSources", C_Timer.After(0.25,addon.DressUpSources))
	addon:SecureHook("DressUpFrame_OnDressModel",function(self) DressingRoom:OnDressModel(self) end)

	addon:HookScript(DressUpFrameResetButton,"OnClick", function()  C_Timer.After(0.1, function() initHide = true; initUndress = true; BW_DressingRoomItemDetailsMixin:UpdateButtons() end) end)
	addon:HookScript(DressUpFrame.MaximizeMinimizeFrame.MaximizeButton,"OnClick", function()  C_Timer.After(0.1, function() DressingRoom:SetFrameSize() end) end)

	DressUpFrame:SetClampedToScreen(true);
	DressUpFrame:SetMovable(true)
	DressUpFrame:EnableMouse(true)
	DressUpFrame:RegisterForDrag("LeftButton")
	DressUpFrame:SetScript("OnDragStart", DressUpFrame.StartMoving)
	DressUpFrame:SetScript("OnDragStop", DressUpFrame.StopMovingOrSizing)
	DressUpFrame:SetMinResize(384, 474);
	DressUpFrame:SetMaxResize(
		min(GetScreenWidth() - 50, 950),
		min(GetScreenHeight() - 50, 950)
	);
	
	

end


function DressingRoom:OnDressModel(self)
	-- only want 1 update per frame
	if ( not self.gotDressed ) then
		self.gotDressed = true
		C_Timer.After(0, function() self.gotDressed = nil; BW_DressingRoomOutfitDropDown:UpdateSaveButton() end)
	end
end


function addon:DressUpVisual(...)
	dressuplink = ...
	if not dressuplink then return end

	local playerActor = DressUpFrame.ModelScene:GetPlayerActor()
	if (not playerActor) then
		return false
	end	

	--BW_DressingRoomItemDetailsMixin:UpdateButtons(addon.Profile.DR_StartUndressed and initUndress)
	if addon.Profile.DR_StartUndressed and initUndress then
		--playerActor:Undress()
		initUndress = false
		--
		BW_DressingRoomHideArmorButton_OnClick()
		playerActor:TryOn(...)
	end

C_Timer.After(0, function() BW_DressingRoomItemDetailsMixin:UpdateButtons(false, true) end)
	DressingRoom:TryOn(...)

	

end


function addon:DressUpSources(appearanceSources, mainHandEnchant, offHandEnchant)
	if not appearanceSources then return end
	local playerActor = DressUpFrame.ModelScene:GetPlayerActor()
	if (not playerActor) then
		return false
	end	

	initUndress = false
--BW_DressingRoomItemDetailsMixin:UpdateButtons(true)
	for i = 1, #appearanceSources do
		if ( i ~= mainHandSlotID and i ~= secondaryHandSlotID ) then
			if ( appearanceSources[i] and appearanceSources[i] ~= NO_TRANSMOG_SOURCE_ID ) then
				DressingRoom:TryOn(appearanceSources[i])
			end
		end
	end

	DressingRoom:TryOn(appearanceSources[mainHandSlotID], "MAINHANDSLOT", mainHandEnchant)
	DressingRoom:TryOn(appearanceSources[secondaryHandSlotID], "SECONDARYHANDSLOT", offHandEnchant)

	--BW_DressingRoomItemDetailsMixin:UpdateButtons(nil, import)
	--C_Timer.After(0.1, function() BW_DressingRoomItemDetailsMixin:UpdateButtons(false, import) end)
end


local itemlinkbase = [["item:%d::::::::::::9:%d]]
function DressingRoom:TryOn(itemSource, previewSlot, enchantID)
	--if not itemSource or itemSource == 0 then return end
	local itemLink
	if type(itemSource) == "number" then
		itemLink = select(6, C_TransmogCollection.GetAppearanceSourceInfo(itemSource))

			if not itemLink then
				local sourceInfo = C_TransmogCollection.GetSourceInfo(itemSource)
				itemLink = itemlinkbase:format(sourceInfo.itemID, sourceInfo.itemModID or 0)
			end
	else
		itemLink = itemSource
	end
	
	if itemLink then
		local targetSlotID
		local _, _, _, _, _, itemType, itemSubType, _, itemEquipLoc = GetItemInfo(itemLink)
		itemEquipLoc = INVENTORY_SLOT_NAMES[itemEquipLoc]

		targetSlotID = previewSlot and GetInventorySlotInfo(previewSlot) or nil
		if not targetSlotID then
			targetSlotID = itemEquipLoc
		end
		dressuplink = itemLink
dressupslot = targetSlotID
		if not targetSlotID then return end
		local button = DressingRoom:GetInvSlotButton(targetSlotID)

		if (itemSource == 0 and previewSlot) then
			C_Timer.After(0, function() button:Update( nil) end)
		--elseif 	(targetSlotID == INVSLOT_TABARD and Profile.DR_HideTabard) or
				--(targetSlotID == INVSLOT_BODY and Profile.DR_HideShirt) or
				--((targetSlotID == INVSLOT_MAINHAND or targetSlotID == INVSLOT_OFFHAND) and Profile.DR_HideWeapons ) then
					--C_Timer.After(0.2, function() button:Update(nil) end)	
		--else
			C_Timer.After(0.2, function() button:Update(itemLink) end)
		end
	end
	
	if targetSlotID == INVSLOT_MAINHAND or targetSlotID == INVSLOT_OFFHAND then
		C_Timer.After(0.2, function() button:Update(itemLink) end)
	end
end


local function togglewindows()
	DressUpFrame:Hide()
DressUpFrame_Show(DressUpFrame)


	end


function DressingRoom:IsSlotHidden(slot_id)
	local _, _, _, _, _, _, isHideVisual = C_Transmog.GetSlotInfo(slot_id, LE_TRANSMOG_TYPE_APPEARANCE)
	return isHideVisual
end


function DressingRoom:OnShow()
	--DressUpModel = DressUpFrame.ModelScene:GetPlayerActor()
	--if DressUpModel and not  addon:IsHooked(DressUpModel, "TryOn") then
		--addon:SecureHook(DressUpModel, "TryOn", function(self,...) local itemSource, previewSlot, enchantID = ...; C_Timer.After(0.2, function(...) DressingRoom:TryOn(itemSource, previewSlot, enchantID)  end) end)
	--end
	BW_DressingRoomFrame.PreviewButtonFrame:SetShown(addon.Profile.DR_ShowItemButtons)
	DressingRoom:ToggleControlPanel(addon.Profile.DR_ShowControls)
	DressingRoom:UpdateBackground()	
	--DressUpFrame:SetSize(addon.Profile.DR_Width,addon.Profile.DR_Height)
	if DressUpFrame.MaximizeMinimizeFrame.MinimizeButton:IsShown() then 
		DressingRoom:SetFrameSize()
	end
end


function DressingRoom:OnHide()
	initUndress = addon.Profile.DR_StartUndressed
	initHide = true
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

function DressingRoom:GetInvSlotButton(slotID)
	return SLOT_BUTTON_INDEX[slotID]
end


function addon:DressingRoom_SetItemFrameQuality(itemFrame)
	if not itemFrame.itemLink then return end
	local _, _, quality, _, _, _, _, _, _, texture = GetItemInfo(itemFrame.itemLink)
		--local quality = C_TransmogCollection.GetSourceInfo(itemFrame.sourceID).quality
		if ( quality == LE_ITEM_QUALITY_UNCOMMON ) then
			itemFrame.IconBorder:SetAtlas("loottab-set-itemborder-green", true)
		elseif ( quality == LE_ITEM_QUALITY_RARE ) then
			itemFrame.IconBorder:SetAtlas("loottab-set-itemborder-blue", true)
		elseif ( quality == LE_ITEM_QUALITY_EPIC ) then
			itemFrame.IconBorder:SetAtlas("loottab-set-itemborder-purple", true)
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
	UIDropDownMenu_JustifyText(self, "LEFT")
	if self.width then
		UIDropDownMenu_SetWidth(self, self.width)
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
	--self:SelectOutfit(self:GetLastOutfitID(), true)
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
	playerActor:Undress()
	--DressingRoom:ResetItemButtons(DressingRoom:ResetItemButtons(not addon.Profile.DR_StartUndressed) , true)
	--
	import = true
	if self:IsDefaultSet(outfitID) then
		DressUpSources(C_TransmogCollection.GetOutfitSources(outfitID))
	else
		local outfit = addon.chardb.profile.outfits[LookupIndexFromID(outfitID)]
		DressUpSources(outfit, outfit["mainHandEnchant"], outfit["offHandEnchant"])
	end
	import = false
	--DressingRoom:ResetItemButtons(false , true)

	--BW_DressingRoomOutfitDropDown:OnOutfitApplied(outfitID)BW_DressingRoomItemDetailsMixin:UpdateButtons()
	C_Timer.After(0.2, function() BW_DressingRoomItemDetailsMixin:UpdateButtons(false, true) end)
	--
end


BW_DressingRoomOutfitFrameMixin = CreateFromMixins(BW_WardrobeOutfitFrameMixin)

function BW_DressingRoomOutfitFrameMixin:Toggle(dropDown)
	if self.dropDown == dropDown and self:IsShown() then
		self:Hide()
	else
		CloseDropDownMenus()
		self.dropDown = dropDown
		self:Show()
		self:SetPoint("TOPLEFT", self.dropDown, "BOTTOMLEFT", 8, -3)
		self:Update()
	end
end


local MAX_DEFAULT_OUTFITS = C_TransmogCollection.GetNumMaxOutfits()
function BW_DressingRoomOutfitFrameMixin:SaveOutfit(name)
	local outfitID = LookupOutfitIDFromName(name) --or  ((#C_TransmogCollection.GetOutfits() <= MAX_DEFAULT_OUTFITS) and #C_TransmogCollection.GetOutfits() -1 ) -- or #GetOutfits()-1
	local icon
	local sources = {}
	local Buttons = BW_DressingRoomFrame.PreviewButtonFrame.Slots
	for index, button in pairs(Buttons) do
		local itemlink = nil
		local slot = button:GetID()

		itemlink = button.itemLink --GetInventoryItemLink("player", slot)
		if itemlink then
			local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemlink)
			
			tinsert(sources, sourceID)
			if sourceID and not icon then
				icon = select(4, C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
			end
		end
	end

	if outfitID and BW_WardrobeOutfitMixin:IsDefaultSet(outfitID) or (#C_TransmogCollection.GetOutfits() < MAX_DEFAULT_OUTFITS)  then
		outfitID = C_TransmogCollection.SaveOutfit(name, sources, 0, 0, icon)
	else
		if outfitID then
			addon.chardb.profile.outfits[LookupIndexFromID(outfitID)] = sources
			outfit = addon.chardb.profile.outfits[LookupIndexFromID(outfitID)]
		else
			tinsert(addon.chardb.profile.outfits, sources)
			outfit = addon.chardb.profile.outfits[#addon.chardb.profile.outfits]
		end

		outfit["name"] = name
		outfit["mainHandEnchant"] = 0
		outfit["offHandEnchant"] =  0
		--local icon = select(4, C_TransmogCollection.GetAppearanceSourceInfo(outfit[1]))
		outfit["icon"] = icon
		--outfitID = index
	end

	if self.popupDropDown then
		self.popupDropDown:SelectOutfit(outfitID)
		self.popupDropDown:OnOutfitSaved(outfitID)
	end
end

--BW_DressingRoomOutfitFrame:GetLastOutfitID()
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
	BW_DressingRoomItemDetailsMixin:UpdateButtons(true)
end


BW_DressingRoomItemDetailsMixin = {}

function BW_DressingRoomItemDetailsMixin:OnLoad()
	local slot = self:GetID()
	local invslot = INVENTORY_SLOT_NAMES[slot]
	SLOT_BUTTON_INDEX[slot] = self
	local _, slotTexture = GetInventorySlotInfo(invslot)
	
	self.Background:SetTexture(slotTexture)
	self:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	
	self.Icon:Hide()
end


function BW_DressingRoomItemDetailsMixin:UpdateButtons(clear, loadSet)
	for index, button in pairs(Buttons) do
		local itemlink
		local slot = button:GetID()
		if clear then
			button:Update(nil)
		else
			if loadSet then
				local playerActor = DressUpFrame.ModelScene:GetPlayerActor()
				if (not playerActor) then
					return false
				end

				local appearanceSourceID, illusionSourceID = playerActor:GetSlotTransmogSources(slot)
				itemlink = select(6, C_TransmogCollection.GetAppearanceSourceInfo(appearanceSourceID))

			else

				itemlink = GetInventoryItemLink("player", slot)
			
				if itemlink then
					local isTransmogrified, hasPending, _, _, _, hasUndo, isHideVisual = C_Transmog.GetSlotInfo(slot, LE_TRANSMOG_TYPE_APPEARANCE)
							--local appliedSourceID, appliedVisualID, selectedSourceID, selectedVisualID = Addon:GetInfoForSlot(slot, LE_TRANSMOG_TYPE_APPEARANCE)
					local baseSourceID, baseVisualID, appliedSourceID, appliedVisualID, pendingSourceID, pendingVisualID, hasPendingUndo = C_Transmog.GetSlotVisualInfo(slot, LE_TRANSMOG_TYPE_APPEARANCE)

					if isTransmogrified and not isHideVisual then
						itemlink = select(6, C_TransmogCollection.GetAppearanceSourceInfo(appliedSourceID))
					elseif isHideVisual then
						itemlink = nil
					end
				end
			end

			button:Update(itemlink)
		end
	end

	DressingRoom:SetHidden()
end


function DressingRoom:Undress(slotID)
	local playerActor = DressUpFrame.ModelScene:GetPlayerActor()
	if (not playerActor) then
		return false
	end

	playerActor:UndressSlot(slotID)
end


local HIDDEN_SLOTS = {INVSLOT_TABARD, INVSLOT_BODY, INVSLOT_MAINHAND, INVSLOT_OFFHAND}
function DressingRoom:SetHidden()
	if not initHide then return end
	 for _, slot in ipairs(HIDDEN_SLOTS) do
			button = DressingRoom:GetInvSlotButton(slot)

		if ((slot == INVSLOT_TABARD and Profile.DR_HideTabard) or
					(slot == INVSLOT_BODY and Profile.DR_HideShirt) or
					((slot == INVSLOT_MAINHAND or slot == INVSLOT_OFFHAND) and Profile.DR_HideWeapons )) and slot ~= dressupslot then
				DressingRoom:Undress(slot)
				button:Update(nil)
		end
	end
	initHide = false
end


function BW_DressingRoomItemDetailsMixin:Update(itemLink)
	local Profile = addon.Profile
	local slot = self:GetID()
	local rarity, texture, _ = 0, nil
	if itemLink then
		_, _, rarity, _, _, _, _, _, _, texture = GetItemInfo(itemLink)
	end

	self.itemLink = itemLink or nil

	local skip = false
	if (slot == INVSLOT_TABARD and Profile.DR_HideTabard) or
		(slot == INVSLOT_BODY and Profile.DR_HideShirt) or
		((slot == INVSLOT_MAINHAND or slot == INVSLOT_OFFHAND) and Profile.DR_HideWeapons ) then
			--skip = true 
	end

	if dressuplink == itemLink then skip = false end

	if (texture and not skip) and 
		(not addon.Profile.DR_StartUndressed or
		  	(addon.Profile.DR_StartUndressed and not initUndress ))  then

		self.Icon:SetTexture(texture)
		self.Icon:Show()
		addon:DressingRoom_SetItemFrameQuality(self)
		self.IconBorder:SetDesaturation(0)
		self.IconBorder:SetAlpha(1)
	else
		self.Icon:Hide()
		self.IconBorder:SetDesaturation(1)
		self.IconBorder:SetAlpha(0.3)
		--DressingRoom:Undress(slot)
		self.itemLink = nil
	end
end



function BW_DressingRoomItemDetailsMixin:OnMouseDown(button)
	local slot = self:GetID()
	local playerActor = DressUpFrame.ModelScene:GetPlayerActor()
		if (not playerActor) then
		return false
	end
	
	if button == "LeftButton" and IsShiftKeyDown() then
		if self.itemLink then
			ChatEdit_InsertLink(self.itemLink)
		end
	elseif button == "RightButton" then
		DressingRoom:Undress(slot)
		self:Update(nil)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(_G[INVENTORY_SLOT_NAMES[self:GetID()]])
		GameTooltip:Show()
	end
end


function BW_DressingRoomItemDetailsMixin:OnEnter()
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


function DressupPreviewItemButton_OnLeave(self)
	GameTooltip:Hide()
end


--Have to swap frames due to the show/hide on mouseover of the model
do
	local controlFrame
	local new_ControlFrame = CreateFrame("Frame")
	function DressingRoom:ToggleControlPanel(show)
		if not controlFrame then
			controlFrame = DressUpFrame.ModelScene.ControlFrame
		end

		if show then
			DressUpFrame.ModelScene.ControlFrame = controlFrame
			DressUpFrame.ModelScene.ControlFrame:Show()
		else
			DressUpFrame.ModelScene.ControlFrame = new_ControlFrame
			controlFrame:Hide()
		end
	end
end


local ContextMenu = CreateFrame("Frame", addonName .. "ContextMenuFrame", UIParent, "UIDropDownMenuTemplate")
function DressupSettingsButton_OnClick(self)
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
			text = L["Hide  Backround Image"],
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
	
	ContextMenu:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
	EasyMenu(contextMenuData, ContextMenu, "cursor", 0, 0, "MENU")

	DropDownList1:ClearAllPoints()
	DropDownList1:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
	DropDownList1:SetClampedToScreen(true)
end



function BW_DressingRoomImportButton_OnClick(self)
	local Profile = addon.Profile
	local name  = addon.QueueList[3]
	local contextMenuData = {
		{
			text = L["Display Options"], isTitle = true, notCheckable = true,
		},
		{
			text = L["Load Set: %s"]:format( name or L["None Selected"]),
			func = function()
				local sources
				local setType = addon.QueueList[1]
				local setID = addon.QueueList[2]
				local playerActor = DressUpFrame.ModelScene:GetPlayerActor()
					if (not playerActor) then
		return false
	end

				if not setID then return end
				
				if setType == "set" then
					sources = C_TransmogSets.GetSetSources(setID)
				elseif setType == "extraset" then
					sources = addon.GetSetsources(setID)
				end

				for i, d in pairs(sources)do
					playerActor:TryOn(i)
				end
				import = true
				DressUpSources(sources)
				import = false
				C_Timer.After(0.2, function() BW_DressingRoomItemDetailsMixin:UpdateButtons(false, true) end)

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
	
	ContextMenu:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
	EasyMenu(contextMenuData, ContextMenu, "cursor", 0, 0, "MENU")
	
	DropDownList1:ClearAllPoints()
	DropDownList1:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
	DropDownList1:SetClampedToScreen(true)
end

