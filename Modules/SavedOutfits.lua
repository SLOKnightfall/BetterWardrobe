local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local MAX_DEFAULT_OUTFITS = C_TransmogCollection.GetNumMaxOutfits()


--Function to update character to reflect DB changes
function addon.Init.SavedOutfitDBUpdate(force) 
	--V9.0.1 Moves over saved set data from fixed DB vs a profile
	local character = addon.setdb:GetCurrentProfile()
	if addon.setdb.global.updates[character]["9.0.1"] and not force then return end

	local table = addon.setdb.global.outfits[character] or {}
	for i, data in ipairs(addon.chardb.profile.outfits) do
		tinsert(table, data)
	end

	addon.setdb.global.updates[character]["9.0.1"] = true

	--clean out the old DB if no other profiles ues it
	local shared = false
	local currentProfile = BetterWardrobe_CharacterData.profileKeys[character]
		for profile_character, profile in pairs(BetterWardrobe_CharacterData.profileKeys) do
			--compare characters and see if any profiles are shared
			if character ~= profile_character and currentProfile == profile then
				--See if profile character has already been upgraded
				if 	addon.setdb.global.updates[profile_character]["9.0.1"] then 
				else
					shared = true
					return false
				end
			end
		end

	--No other characters share this profile so safe to clear
	if not shared then 
		addon.chardb.profile.outfits = {}
	end
end
BW_SavedOutfitDBUpdate = addon.Init.SavedOutfitDBUpdate


local function GetOutfits(character)
		local name = UnitName("player")
		local realm = GetRealmName()
		local profile = addon.SelecteSavedList 
		local FullList = {}
		local savedOutfits
		if addon.SelecteSavedList and not character then 
			FullList = addon.setdb.global.sets[addon.SelecteSavedList]
			for i, data in ipairs(FullList) do
				data.set = "extra"
				data.index = i
			end
		else
			FullList = C_TransmogCollection.GetOutfits()
			local baseID = 0
			for i, data in ipairs(FullList) do
				data.set = "default"
				data.index = i
			end

			for i, data in ipairs(addon.chardb.profile.outfits) do
				data.outfitID = MAX_DEFAULT_OUTFITS + i
				data.set = "extra"
				data.index = i
				data.name = addon.chardb.profile.outfits[i].name
				tinsert(FullList, data)
				--FullList[#FullList].outfitID = MAX_DEFAULT_OUTFITS + i
				--data.set = "default"
			end
		end

		local mogit_Outfits = addon.MogIt.GetMogitOutfits()
		if mogit_Outfits then 
			for i, data in ipairs(mogit_Outfits) do
				--local index = #FullList
				tinsert(FullList, data)
			end
		end

		return FullList
end
addon.GetOutfits = GetOutfits


local function GetTableIndex(index)
	local numOutfits = #C_TransmogCollection.GetOutfits()
	return index - numOutfits + 1
end


local function IsDefaultSet(outfitID)
		return outfitID < MAX_DEFAULT_OUTFITS  -- #C_TransmogCollection.GetOutfits()--MAX_DEFAULT_OUTFITS 
end


function LookupOutfitIDFromName(name)
	local outfits = GetOutfits(true)
	for i, data in ipairs(outfits) do
		if data.name == name then
			return data.outfitID
		end
	end
	return nil
end


function LookupIndexFromID(outfitID)
	local outfits = GetOutfits(true)
	for i, data in ipairs(outfits) do
		if data.outfitID == outfitID then
			return data.index
		end
	end
	return nil
end


local function GetOutfitName(outfitID)
	local index = LookupIndexFromID(outfitID)
	return C_TransmogCollection.GetOutfitName(outfitID) or (index and addon.MogIt.MogitSets[index] and addon.MogIt.MogitSets[index].name) or (index and addon.chardb.profile.outfits[index].name)
end
addon.GetOutfitName = GetOutfitName

StaticPopupDialogs["BW_NAME_TRANSMOG_OUTFIT"] = {
	preferredIndex = 3,
	text = TRANSMOG_OUTFIT_NAME,
	button1 = SAVE,
	button2 = CANCEL,
	OnAccept = function(self)
		BW_WardrobeOutfitFrame:NameOutfit(self.editBox:GetText(), self.data)
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	hasEditBox = 1,
	maxLetters = 31,
	OnShow = function(self)
		self.button1:Disable()
		self.button2:Enable()
		self.editBox:SetFocus()
	end,
	OnHide = function(self)
		self.editBox:SetText("")
	end,
	EditBoxOnEnterPressed = function(self)
		if (self:GetParent().button1:IsEnabled()) then
			StaticPopup_OnClick(self:GetParent(), 1)
		end
	end,
	EditBoxOnTextChanged = function (self)
		local parent = self:GetParent()
		if (parent.editBox:GetText() ~= "") then
			parent.button1:Enable()
		else
			parent.button1:Disable()
		end
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide()
	end
}

StaticPopupDialogs["BW_CONFIRM_DELETE_TRANSMOG_OUTFIT"] = {
	preferredIndex = 3,
	text = TRANSMOG_OUTFIT_CONFIRM_DELETE,
	button1 = YES,
	button2 = NO,
	OnAccept = function (self) BW_WardrobeOutfitFrame:DeleteOutfit(self.data) end,
	OnCancel = function (self) end,
	hideOnEscape = 1,
	timeout = 0,
	whileDead = 1,
}

StaticPopupDialogs["BW_TRANSMOG_OUTFIT_SOME_INVALID_APPEARANCES"] = {
	preferredIndex = 3,
	text = TRANSMOG_OUTFIT_SOME_INVALID_APPEARANCES,
	button1 = OKAY,
	button2 = CANCEL,
	OnShow = function(self)
		if (BW_WardrobeOutfitFrame.name) then
			self.button1:SetText(SAVE)
		else
			self.button1:SetText(CONTINUE)
		end
	end,
	OnAccept = function(self)
		BW_WardrobeOutfitFrame:ContinueWithSave()
	end,
	hideOnEscape = 1,
	timeout = 0,
	whileDead = 1,
}

StaticPopupDialogs["BW_CONFIRM_OVERWRITE_TRANSMOG_OUTFIT"] = {
	preferredIndex = 3,
	text = TRANSMOG_OUTFIT_CONFIRM_OVERWRITE,
	button1 = YES,
	button2 = NO,
	OnAccept = function (self) 
		--if DressUpFrame:IsShown() then
			--BW_DressingRoomOutfitFrameMixin:SaveOutfit(self.data)
		--else
			BW_WardrobeOutfitFrame:SaveOutfit(self.data)
		--end
	end,
	OnCancel = function (self)
		local name = self.data
		self:Hide()
		local dialog = StaticPopup_Show("BW_NAME_TRANSMOG_OUTFIT")
		if (dialog) then
			self.editBox:SetText(name)
		end
	end,
	hideOnEscape = 1,
	timeout = 0,
	whileDead = 1,
	noCancelOnEscape = 1,
}

--===================================================================================================================================
BW_WardrobeOutfitMixin = CreateFromMixins(WardrobeOutfitMixin)


function BW_WardrobeOutfitMixin:OnOutfitApplied(outfitID)
	local value = outfitID or ""
	if GetCVarBool("transmogCurrentSpecOnly") then
		local specIndex = GetSpecialization()
		addon.chardb.profile.lastTransmogOutfitIDSpec[specIndex] = value
		--SetCVar("lastTransmogOutfitIDSpec"..specIndex, value)
	else
		for specIndex = 1, GetNumSpecializations() do
			--SetCVar("lastTransmogOutfitIDSpec"..specIndex, value)
			addon.chardb.profile.lastTransmogOutfitIDSpec[specIndex] = value
		end
	end
end


function BW_WardrobeOutfitMixin:LoadOutfit(outfitID)
	if (not outfitID) then
		return
	end
local MogItOutfit = false
if outfitID > 1000 then MogItOutfit = true end


	if IsDefaultSet(outfitID) then 
		C_Transmog.LoadOutfit(outfitID)
	else
		local outfit 
		if outfitID > 1000 then
			outfit = addon.MogIt.MogitSets[outfitID]
		else
			outfit = addon.chardb.profile.outfits[LookupIndexFromID(outfitID)]
		end
		--for slot , data in pairs(outfit) do
		for key, transmogSlot in pairs(TRANSMOG_SLOTS) do
			local slotID = transmogSlot.location:GetSlotID();
			local data = outfit[slotID]
			if data and data ~= NO_TRANSMOG_SOURCE_ID then 
			--if type(slot) == "number" then 
			local transmogLocation = TransmogUtil.GetTransmogLocation(slotID, Enum.TransmogType.Appearance, Enum.TransmogModification.None);
			--C_Transmog.SetPending(slot, Enum.TransmogType.Appearance, data)
			C_Transmog.SetPending(transmogLocation, data, Enum.TransmogType.Appearance);
			end
		end

	local transmogLocation = TransmogUtil.GetTransmogLocation(GetInventorySlotInfo("MAINHANDSLOT"), Enum.TransmogType.Illusion, Enum.TransmogModification.None);
	C_Transmog.SetPending(transmogLocation, outfit["mainHandEnchant"], Enum.TransmogType.Illusion);

	transmogLocation = TransmogUtil.GetTransmogLocation(GetInventorySlotInfo("SECONDARYHANDSLOT"), Enum.TransmogType.Illusion, Enum.TransmogModification.None);
	C_Transmog.SetPending(transmogLocation, outfit["offHandEnchant"], Enum.TransmogType.Illusion);

		--C_Transmog.SetPending(GetInventorySlotInfo("MAINHANDSLOT"), LE_TRANSMOG_TYPE_ILLUSION, outfit["mainHandEnchant"])
		--C_Transmog.SetPending(GetInventorySlotInfo("SECONDARYHANDSLOT"), LE_TRANSMOG_TYPE_ILLUSION, outfit["offHandEnchant"])
	end
end

--[[
function BW_WardrobeOutfitMixin:GetSlotSourceID(transmogLocation)
	local isTransmogrified, hasPending, isPendingCollected, canTransmogrify, cannotTransmogrifyReason, hasUndo = C_Transmog.GetSlotInfo(transmogLocation);

	if (not canTransmogrify and not hasUndo) then
		return NO_TRANSMOG_SOURCE_ID
	end

	local _, _, sourceID = TransmogUtil.GetInfoForEquippedSlot(transmogLocation);
	return sourceID
end


function BW_WardrobeOutfitMixin:OnOutfitSaved(outfitID)
	local cost, numChanges = C_Transmog.GetCost()
	if numChanges == 0 then
		self:OnOutfitApplied(outfitID)
	end
end
]]



function BW_WardrobeOutfitMixin:OnLoad()
	local button = _G[self:GetName().."Button"]
	button:SetScript("OnMouseDown", function(self)
						PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
						BW_WardrobeOutfitFrame:Toggle(BW_WardrobeOutfitDropDown)--self:GetParent())
						end
					)
	UIDropDownMenu_JustifyText(self, "LEFT")
	if (self.width) then
		UIDropDownMenu_SetWidth(self, self.width)
	end
	WardrobeOutfitDropDown:Hide()

	addon:SecureHook(nil, "WardrobeTransmogFrame_OnTransmogApplied", function()
	C_Timer.After(.5, function()
			if BW_WardrobeOutfitDropDown.selectedOutfitID and BW_WardrobeOutfitDropDown:IsOutfitDressed() then
				BW_WardrobeOutfitDropDown:OnOutfitApplied(BW_WardrobeOutfitDropDown.selectedOutfitID)
			end
		end)
		end, true)
end


function BW_WardrobeOutfitMixin:OnShow()
	self:RegisterEvent("TRANSMOG_OUTFITS_CHANGED");
	self:RegisterEvent("TRANSMOGRIFY_UPDATE");
	self:SelectOutfit(self:GetLastOutfitID(), true);
end


function BW_WardrobeOutfitMixin:OnHide()
	self:UnregisterEvent("TRANSMOG_OUTFITS_CHANGED")
	self:UnregisterEvent("TRANSMOGRIFY_UPDATE")
	BW_WardrobeOutfitFrame:ClosePopups(self)
	if (BW_WardrobeOutfitFrame.dropDown == self) then
		BW_WardrobeOutfitFrame:Hide()
	end
end


function BW_WardrobeOutfitMixin:OnEvent(event)
	if (event == "TRANSMOG_OUTFITS_CHANGED") then
		-- try to reselect the same outfit to update the name
		-- if it changed or clear the name if it got deleted
		self:SelectOutfit(self.selectedOutfitID)
		if (BW_WardrobeOutfitFrame:IsShown()) then
			BW_WardrobeOutfitFrame:Update()
		end
	end
	if not addon.SelecteSavedList then 
	-- don't need to do anything for "TRANSMOGRIFY_UPDATE" beyond updating the save button
	self:UpdateSaveButton()
	end
end


function BW_WardrobeOutfitMixin:LoadDBOutfit(outfitID)
	if (not outfitID) then
		return
	end

	local outfits = addon.GetSavedList()
	local outfitdata
	for i, data in ipairs(outfits) do
		if data.setID == outfitID then 
			outfitdata = data
			break
		end
	end

	if not outfitdata then return end

		local emptySlotData = addon.Sets:GetEmptySlots()
		for i, x in pairs(outfitdata.sources) do
			if  i ~= 7 and emptySlotData[i] then
				local transmogLocation = TransmogUtil.GetTransmogLocation(i, Enum.TransmogType.Appearance, Enum.TransmogModification.None);

				local _, source = addon.GetItemSource(emptySlotData[i]) --C_TransmogCollection.GetItemInfo(emptySlotData[i])
				C_Transmog.SetPending(transmogLocation, source, Enum.TransmogType.Appearance)
			end
		end
		
		for slot , data in pairs(outfitdata.sources) do
			if data ~= 0 then 
				local transmogLocation = TransmogUtil.GetTransmogLocation(slot, Enum.TransmogType.Appearance, Enum.TransmogModification.None);

				C_Transmog.SetPending(transmogLocation, data, Enum.TransmogType.Appearance )						
			end
		end
	--C_Transmog.SetPending(GetInventorySlotInfo("MAINHANDSLOT"), LE_TRANSMOG_TYPE_ILLUSION, outfit["mainHandEnchant"])
		--C_Transmog.SetPending(GetInventorySlotInfo("SECONDARYHANDSLOT"), LE_TRANSMOG_TYPE_ILLUSION, outfit["offHandEnchant"])
end


function BW_WardrobeOutfitMixin:UpdateSaveButton()
	if (self.selectedOutfitID) then
		self.SaveButton:SetEnabled(not self:IsOutfitDressed())
	else
		self.SaveButton:SetEnabled(false)
	end
end


function BW_WardrobeOutfitMixin:SelectDBOutfit(outfitID, loadOutfit)
	local name
	--self.selectedOutfitID = outfitID
	if (loadOutfit) then
		self:LoadDBOutfit(outfitID)
	end
	--self:UpdateSaveButton()
	--self:OnSelectOutfit(outfitID)
end


function BW_WardrobeOutfitMixin:SelectOutfit(outfitID, loadOutfit)
	local name

	if (outfitID) then
		name = GetOutfitName(outfitID)
	end

	if (name) then
		UIDropDownMenu_SetText(self, name)
	else
		outfitID = nil
		UIDropDownMenu_SetText(self, GRAY_FONT_COLOR_CODE..TRANSMOG_OUTFIT_NONE..FONT_COLOR_CODE_CLOSE)
	end

	self.selectedOutfitID = outfitID
	if (loadOutfit) then
		self:LoadOutfit(outfitID)
	end
	self:UpdateSaveButton()
	self:OnSelectOutfit(outfitID)
end


function BW_WardrobeOutfitMixin:OnSelectOutfit(outfitID)
	-- outfitID can be 0, so use empty string for none
	local value = outfitID or ""
	for specIndex = 1, GetNumSpecializations() do
		if addon.chardb.profile.lastTransmogOutfitIDSpec[specIndex] == "" then
			--SetCVar("lastTransmogOutfitIDSpec"..specIndex, value)
			addon.chardb.profile.lastTransmogOutfitIDSpec[specIndex] = value
		end
	end
end


function BW_WardrobeOutfitMixin:GetLastOutfitID()
	local specIndex = GetSpecialization()
	addon.chardb.profile.lastTransmogOutfitIDSpec[specIndex] = addon.chardb.profile.lastTransmogOutfitIDSpec[specIndex] or GetCVar("lastTransmogOutfitIDSpec"..specIndex)
	return tonumber(addon.chardb.profile.lastTransmogOutfitIDSpec[specIndex])
end


local function IsSourceArtifact(sourceID)
	local link = select(6, C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
	if not link then
		return false;
	end
	local _, _, quality = GetItemInfo(link);

	return quality == Enum.ItemQuality.Artifact;
end


function BW_WardrobeOutfitMixin:IsOutfitDressed()
	if (not self.selectedOutfitID) then
		return true
	end

	local appearanceSources, mainHandEnchant, offHandEnchant
	if IsDefaultSet(self.selectedOutfitID) then 
		appearanceSources, mainHandEnchant, offHandEnchant = C_TransmogCollection.GetOutfitSources(self.selectedOutfitID);
	else
		local outfit
		if self.selectedOutfitID > 5000 then
			return true
		else
			 outfit = addon.chardb.profile.outfits[LookupIndexFromID(self.selectedOutfitID)]
		end
		appearanceSources = outfit
		mainHandEnchant = outfit["mainHandEnchant"]
		offHandEnchant = outfit["offHandEnchant"]
	end

	if (not appearanceSources) then
		return true
	end

	for key, transmogSlot in pairs(TRANSMOG_SLOTS) do
		if transmogSlot.location:IsAppearance() then
			local sourceID = self:GetSlotSourceID(transmogSlot.location);
			local slotID = transmogSlot.location:GetSlotID();
			if (sourceID ~= NO_TRANSMOG_SOURCE_ID and sourceID ~= appearanceSources[slotID]) then
				-- No artifacts in outfits, their sourceID is overriden to NO_TRANSMOG_SOURCE_ID
				if (not IsSourceArtifact(sourceID) or appearanceSources[slotID] ~= NO_TRANSMOG_SOURCE_ID) then
					return false
				end
			end
		end
	end

	local mainHandIllusionTransmogLocation = TransmogUtil.GetTransmogLocation("MAINHANDSLOT", Enum.TransmogType.Illusion, Enum.TransmogModification.None);
	local mainHandSourceID = self:GetSlotSourceID(mainHandIllusionTransmogLocation);
	if (mainHandSourceID ~= mainHandEnchant) then
		return false
	end
	local offHandIllusionTransmogLocation = TransmogUtil.GetTransmogLocation("SECONDARYHANDSLOT", Enum.TransmogType.Illusion, Enum.TransmogModification.None);
	local offHandSourceID = self:GetSlotSourceID(offHandIllusionTransmogLocation);

	if (offHandSourceID ~= offHandEnchant) then
		return false
	end

	return true
end


function BW_WardrobeOutfitMixin:CheckOutfitForSave(name)
	local sources = {}
	local mainHandEnchant, offHandEnchant
	local pendingSources = {}
	local hadInvalidSources = false

	for key, transmogSlot in pairs(TRANSMOG_SLOTS) do
		local sourceID = self:GetSlotSourceID(transmogSlot.location);
		if (sourceID ~= NO_TRANSMOG_SOURCE_ID) then
			if ( transmogSlot.location:IsAppearance() ) then
				local slotID = transmogSlot.location:GetSlotID();
				local isValidSource = C_TransmogCollection.PlayerKnowsSource(sourceID)
				if (not isValidSource) then
					local isInfoReady, canCollect = C_TransmogCollection.PlayerCanCollectSource(sourceID)
					if (isInfoReady) then
						if (canCollect) then
							isValidSource = true
						else
							-- hack: ignore artifacts
							if (not IsSourceArtifact(sourceID)) then
								hadInvalidSources = true
							end
						end
					else
						-- saving the "slot" for the sourceID
						pendingSources[sourceID] = slotID
					end
				end

				if (isValidSource) then
					-- No artifacts in outfits, their sourceID is overriden to NO_TRANSMOG_SOURCE_ID
					if (IsSourceArtifact(sourceID)) then
						sources[slotID] = NO_TRANSMOG_SOURCE_ID
					else
						sources[slotID] = sourceID
					end
				end
			elseif ( transmogSlot.location:IsIllusion() ) then
				if ( transmogSlot.location:IsMainHand() ) then
					mainHandEnchant = sourceID
				else
					offHandEnchant = sourceID
				end
			end
		end
		
	end
	-- store the state for this save
	BW_WardrobeOutfitFrame.sources = sources
	BW_WardrobeOutfitFrame.mainHandEnchant = mainHandEnchant
	BW_WardrobeOutfitFrame.offHandEnchant = offHandEnchant
	BW_WardrobeOutfitFrame.pendingSources = pendingSources
	BW_WardrobeOutfitFrame.hadInvalidSources = hadInvalidSources
	BW_WardrobeOutfitFrame.name = name
	-- save the dropdown
	BW_WardrobeOutfitFrame.popupDropDown = self

	BW_WardrobeOutfitFrame:EvaluateSaveState()
end

function BW_WardrobeOutfitMixin:IsDefaultSet(outfitID)
		return IsDefaultSet(outfitID)
end

--===================================================================================================================================
BW_WardrobeOutfitFrameMixin = CreateFromMixins(WardrobeOutfitFrameMixin)

BW_WardrobeOutfitFrameMixin.popups = {
	"BW_NAME_TRANSMOG_OUTFIT",
	"BW_CONFIRM_DELETE_TRANSMOG_OUTFIT",
	"CONFIRM_SAVE_TRANSMOG_OUTFIT",
	"BW_CONFIRM_OVERWRITE_TRANSMOG_OUTFIT",
	"TRANSMOG_OUTFIT_CHECKING_APPEARANCES",
	"BW_TRANSMOG_OUTFIT_SOME_INVALID_APPEARANCES",
	"TRANSMOG_OUTFIT_ALL_INVALID_APPEARANCES",
	"BETTER_WARDROBE_IMPORT_ITEM_POPUP",
	"BETTER_WARDROBE_IMPORT_SET_POPUP"
}

local OUTFIT_FRAME_MIN_STRING_WIDTH = 152
local OUTFIT_FRAME_MAX_STRING_WIDTH = 216
local OUTFIT_FRAME_ADDED_PIXELS = 90	-- pixels added to string width

function BW_WardrobeOutfitFrameMixin:Toggle(dropDown)
	if (self.dropDown == dropDown and self:IsShown()) then

		BW_WardrobeOutfitFrame:Hide()
	else
		CloseDropDownMenus()
		self.dropDown = dropDown

		self:Show()
		self:SetPoint("TOPLEFT", self.dropDown, "BOTTOMLEFT", 8, -3)
		self:Update()
	end
end

local function GetButton(self, index)
	local buttons = self.Buttons
	local button = buttons[index]
			if (not button) then
				button = CreateFrame("BUTTON", nil, self.Content, self:GetName().."ButtonTemplate")
				button.EditButton:SetScript("OnClick", function(self)
					PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
					BW_WardrobeOutfitEditFrame:ShowForOutfit(self:GetParent().outfitID)
				end)

				button:SetPoint("TOPLEFT", buttons[index-1], "BOTTOMLEFT", 0, 0)
				button:SetPoint("TOPRIGHT", buttons[index-1], "BOTTOMRIGHT", 0, 0)
			end
		return button 


end

function BW_WardrobeOutfitFrameMixin:Update()
	local outfits = GetOutfits(true)
	--local mogit_Outfits = addon.GetMogitOutfits()
	local buttons = self.Buttons
	local numButtons = 0
	local stringWidth = 0
	local minStringWidth = self.dropDown.minMenuStringWidth or OUTFIT_FRAME_MIN_STRING_WIDTH
	local maxStringWidth = self.dropDown.maxMenuStringWidth or OUTFIT_FRAME_MAX_STRING_WIDTH
	self:SetWidth(maxStringWidth + OUTFIT_FRAME_ADDED_PIXELS)
	for i = 1, #outfits do
		local outfit = outfits[i]
		if outfit then
			local button = GetButton(self, i + 1)
			button:Show()
			if (outfit.outfitID == self.dropDown.selectedOutfitID) then
				button.Check:Show()
				button.Selection:Show()
			else
				button.Selection:Hide()
				button.Check:Hide()
			end
			button.Text:SetWidth(0)
			button:SetText(NORMAL_FONT_COLOR_CODE..outfits[i].name..FONT_COLOR_CODE_CLOSE)
			button.Icon:SetTexture(outfit.icon)
			button.outfitID = outfit.outfitID

			if outfit.set == "mogit" then 
				button.EditButton:Disable()
				button.EditButton.texture:Hide()
			else
				button.EditButton:Enable()
				button.EditButton.texture:Show()
			end

			stringWidth = max(stringWidth, button.Text:GetStringWidth())
			if (button.Text:GetStringWidth() > maxStringWidth) then
				button.Text:SetWidth(maxStringWidth)
			end
			numButtons = numButtons + 1
		else
			if (buttons[i + 1]) then
				buttons[i + 1]:Hide()
			end
		end
	end

	for i = #outfits  + 2 , #buttons do
		buttons[i]:Hide()
	end

	stringWidth = max(stringWidth, minStringWidth)
	stringWidth = min(stringWidth, maxStringWidth)
	self:SetWidth(stringWidth + OUTFIT_FRAME_ADDED_PIXELS)
	self:SetHeight(30 + 7 * 20)
end


local function GetDressingRoomSources()
	local icon
	local sources = {}
	local Buttons = BW_DressingRoomFrame.PreviewButtonFrame.Slots
	for index, button in pairs(Buttons) do
		local itemlink = nil
		local slot = button:GetID()

		itemlink = button.itemLink --GetInventoryItemLink("player", slot)
		if itemlink then
			local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemlink)
			sources[slot] =  sourceID
			if sourceID and not icon then
				icon = select(4, C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
			end
		end
	end
	return sources, icon
end


function BW_WardrobeOutfitFrameMixin:SaveOutfit(name)
	local outfitID = LookupOutfitIDFromName(name) --or  ((#C_TransmogCollection.GetOutfits() <= MAX_DEFAULT_OUTFITS) and #C_TransmogCollection.GetOutfits() -1 ) -- or #GetOutfits()-1
	local icon
	local sources = {}--self.sources or GetDressingRoomSources()
	local mainHandEnchant = self.mainHandEnchant or 0
	local offHandEnchant = self.offHandEnchant or 0
	local outfit

	if DressUpFrame:IsShown() then
		sources, icon  = GetDressingRoomSources()
	else
		sources = self.sources
		for key, transmogSlot in pairs(TRANSMOG_SLOTS) do
			if ( transmogSlot.location:IsAppearance() ) then
				local slotID = transmogSlot.location:GetSlotID();
				local sourceID = self.sources[slotID];
				if ( sourceID ) then
					icon = select(4, C_TransmogCollection.GetAppearanceSourceInfo(sourceID));
					if ( icon ) then
						break;
					end
				end
			end
		end
	end

	if (outfitID and IsDefaultSet(outfitID)) or (#C_TransmogCollection.GetOutfits() < MAX_DEFAULT_OUTFITS)  then 
		outfitID = C_TransmogCollection.SaveOutfit(name, sources, mainHandEnchant, offHandEnchant, icon)
	else
		if outfitID then 
			addon.chardb.profile.outfits[LookupIndexFromID(outfitID)] = sources
			outfit = addon.chardb.profile.outfits[LookupIndexFromID(outfitID)]
		else
			tinsert(addon.chardb.profile.outfits, sources)
			outfit = addon.chardb.profile.outfits[#addon.chardb.profile.outfits]
		end

		outfit["name"] = name
		outfit["mainHandEnchant"] = mainHandEnchant
		outfit["offHandEnchant"] = offHandEnchant
		local icon = select(4, C_TransmogCollection.GetAppearanceSourceInfo(outfit[1]))
		outfit["icon"] = icon
		--outfitID = index
	end

	if (self.popupDropDown) then
		self.popupDropDown:SelectOutfit(outfitID)
		self.popupDropDown:OnOutfitSaved(outfitID)
	end

	addon.setdb.global.sets[addon.setdb:GetCurrentProfile()] = addon.GetSavedList()
end


function BW_WardrobeOutfitFrameMixin:DeleteOutfit(outfitID)
	if IsDefaultSet(outfitID) then
		C_TransmogCollection.DeleteOutfit(outfitID)
	else
		tremove(addon.chardb.profile.outfits, LookupIndexFromID(outfitID))
	end

	if GetCVarBool("transmogCurrentSpecOnly") then
		local specIndex = GetSpecialization()
		local value = addon.chardb.profile.lastTransmogOutfitIDSpec[specIndex]
		if type(value) == number and value > 0 then  addon.chardb.profile.lastTransmogOutfitIDSpec[specIndex] = value - 1 end

		--SetCVar("lastTransmogOutfitIDSpec"..specIndex, value)
	else
		for specIndex = 1, GetNumSpecializations() do
			--SetCVar("lastTransmogOutfitIDSpec"..specIndex, value)
		local value = addon.chardb.profile.lastTransmogOutfitIDSpec[specIndex]
		if type(value) == number and value > 0  then  addon.chardb.profile.lastTransmogOutfitIDSpec[specIndex] = value - 1 end
		end
	end
	addon.setdb.global.sets[addon.setdb:GetCurrentProfile()] = addon.GetSavedList()
end


function BW_WardrobeOutfitFrameMixin:NameOutfit(newName, outfitID)
	local outfits = GetOutfits(true)
	for i = 1, #outfits do
		if (outfits[i].name == newName) then
			if (outfitID) then
				UIErrorsFrame:AddMessage(TRANSMOG_OUTFIT_ALREADY_EXISTS, 1.0, 0.1, 0.1, 1.0)
			else
				BW_WardrobeOutfitFrame:ShowPopup("BW_CONFIRM_OVERWRITE_TRANSMOG_OUTFIT", newName, nil, newName)
			end
			return
		end
	end

	if outfitID and IsDefaultSet(outfitID) then
			-- this is a rename
		C_TransmogCollection.ModifyOutfit(outfitID, newName)
	elseif outfitID then 
		local index = LookupIndexFromID(outfitID)
		addon.chardb.profile.outfits[index].name = newName
	else
		-- this is a new outfit
		--self:SaveOutfit(newName)
		--if DressUpFrame:IsShown() then
			--BW_DressingRoomOutfitFrameMixin:SaveOutfit(newName)
		--else

			self:SaveOutfit(newName)
		--end
	end
end


function BW_WardrobeOutfitFrameMixin:ShowPopup(popup, ...)
	-- close all other popups
	for _, listPopup in pairs(self.popups) do
		if (listPopup ~= popup) then
			StaticPopup_Hide(listPopup)
		end
	end

	if (popup ~= BW_WardrobeOutfitEditFrame) then
		StaticPopupSpecial_Hide(BW_WardrobeOutfitEditFrame)
	end

	self.popupDropDown = self.dropDown
	if (popup == BW_WardrobeOutfitEditFrame) then
		StaticPopupSpecial_Show(BW_WardrobeOutfitEditFrame)
	else
		StaticPopup_Show(popup, ...)
	end
end


function BW_WardrobeOutfitFrameMixin:ClosePopups(requestingDropDown)
	if (requestingDropDown and requestingDropDown ~= self.popupDropDown) then
		return
	end

	for _, popup in pairs(self.popups) do
		StaticPopup_Hide(popup)
	end
	StaticPopupSpecial_Hide(BW_WardrobeOutfitEditFrame)

	-- clean up
	self.sources = nil
	self.mainHandEnchant = nil
	self.offHandEnchant = nil
	self.pendingSources = nil
	self.hadInvalidSources = nil
	self.name = nil
	self.popupDropDown = nil
end


function BW_WardrobeOutfitFrameMixin:EvaluateSaveState()
	if (next(self.pendingSources)) then
		-- wait
		if (not StaticPopup_Visible("TRANSMOG_OUTFIT_CHECKING_APPEARANCES")) then
			BW_WardrobeOutfitFrame:ShowPopup("TRANSMOG_OUTFIT_CHECKING_APPEARANCES", nil, nil, nil, BW_WardrobeOutfitCheckAppearancesFrame)
		end
	elseif (self.hadInvalidSources) then
		if (next(self.sources)) then
			-- warn
			BW_WardrobeOutfitFrame:ShowPopup("BW_TRANSMOG_OUTFIT_SOME_INVALID_APPEARANCES")
		else
			-- stop
			BW_WardrobeOutfitFrame:ShowPopup("TRANSMOG_OUTFIT_ALL_INVALID_APPEARANCES")
		end
	else
		BW_WardrobeOutfitFrame:ContinueWithSave()
	end
end


function BW_WardrobeOutfitFrameMixin:ContinueWithSave()
	if (self.name) then
		--if DressUpFrame:IsShown() then
			--BW_DressingRoomOutfitFrameMixin:SaveOutfit(self.name)
		--else
			BW_WardrobeOutfitFrame:SaveOutfit(self.name)
		--end
		BW_WardrobeOutfitFrame:ClosePopups()
	else
		BW_WardrobeOutfitFrame:ShowPopup("BW_NAME_TRANSMOG_OUTFIT")
	end
end


function BW_WardrobeOutfitFrameMixin:CreateScrollFrame()
	self:SetFrameLevel(5000)
	self.scrollframe = self.scrollframe or CreateFrame("ScrollFrame", self:GetName().."ScrollFrame", self, "UIPanelScrollFrameTemplate")
	self.scrollchild = self.scrollchild or CreateFrame("Frame") -- not sure what happens if you do, but to be safe, don't parent this yet (or do anything with it)
	 
	local scrollbarName = self.scrollframe:GetName()
	self.scrollbar = _G[scrollbarName.."ScrollBar"]
	self.scrollupbutton = _G[scrollbarName.."ScrollBarScrollUpButton"]
	self.scrolldownbutton = _G[scrollbarName.."ScrollBarScrollDownButton"]
	 
	self.scrollupbutton:ClearAllPoints()
	self.scrollupbutton:SetPoint("TOPRIGHT", self.scrollframe, "TOPRIGHT", -2, -2)
	 
	self.scrolldownbutton:ClearAllPoints()
	self.scrolldownbutton:SetPoint("BOTTOMRIGHT", self.scrollframe, "BOTTOMRIGHT", -2, 2)
	 
	self.scrollbar:ClearAllPoints()
	self.scrollbar:SetPoint("TOP", self.scrollupbutton, "BOTTOM", 0, -2)
	self.scrollbar:SetPoint("BOTTOM", self.scrolldownbutton, "TOP", 0, 2)
	 
	self.scrollframe:SetScrollChild(self.scrollchild)
	self.scrollframe:SetAllPoints(self)
	self.scrollframe:ClearAllPoints()
	self.scrollframe:SetPoint("TOPLEFT", self, "TOPLEFT", 11, -15)
	self.scrollframe:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -11, 15)
	self.scrollchild:SetSize(self.scrollframe:GetWidth(), ( self.scrollframe:GetHeight() * 2 ))

	self.moduleoptions = self.moduleoptions or CreateFrame("Frame", nil, self.scrollchild)
	self.moduleoptions:SetAllPoints(self.scrollchild)

	self.Content = self.moduleoptions

	local button = CreateFrame("BUTTON", nil, self.Content, self:GetName().."ButtonTemplate")
	button.EditButton:SetScript("OnClick", function(self)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		BW_WardrobeOutfitEditFrame:ShowForOutfit(self:GetParent().outfitID)
	end)
	button.EditButton:Hide()

	button:SetPoint("TOPLEFT", self.Content, "TOPLEFT")
	button:SetPoint("TOPRIGHT", self.Content, "TOPRIGHT", -20, 0)

	button:SetText(GREEN_FONT_COLOR_CODE..TRANSMOG_OUTFIT_NEW..FONT_COLOR_CODE_CLOSE)
	button.Icon:SetTexture("Interface\\PaperDollInfoFrame\\Character-Plus")
	button.outfitID = nil
	button.Check:Hide()
	button.Selection:Hide()

	function self.moduleoptions:StartHideCountDown()
		return BW_WardrobeOutfitFrame:StartHideCountDown()
	end

	function self.moduleoptions:StopHideCountDown()
		return BW_WardrobeOutfitFrame:StopHideCountDown()
	end

	self.Buttons = self.moduleoptions.Buttons
end

--===================================================================================================================================
BW_WardrobeOutfitButtonMixin = {} --CreateFromMixins(WardrobeOutfitButtonMixin)

function BW_WardrobeOutfitButtonMixin:OnClick()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	BW_WardrobeOutfitFrame:Hide()
	if (self.outfitID) then
		BW_WardrobeOutfitFrame.dropDown:SelectOutfit(self.outfitID, true)
	else
		--if ( WardrobeTransmogFrame and HelpTip:IsShowing(WardrobeTransmogFrame, TRANSMOG_OUTFIT_DROPDOWN_TUTORIAL) ) then
			--HelpTip:Hide(WardrobeTransmogFrame, TRANSMOG_OUTFIT_DROPDOWN_TUTORIAL);
			--SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_TRANSMOG_OUTFIT_DROPDOWN, true)
		--end
		BW_WardrobeOutfitFrame.dropDown:CheckOutfitForSave()
	end
end

--===================================================================================================================================
BW_WardrobeOutfitEditFrameMixin = CreateFromMixins(WardrobeOutfitEditFrameMixin)-- {}

function BW_WardrobeOutfitEditFrameMixin:ShowForOutfit(outfitID)
	BW_WardrobeOutfitFrame:Hide()
	BW_DressingRoomOutfitFrame:Hide()
	BW_WardrobeOutfitFrame:ShowPopup(self)
	self.outfitID = outfitID
	local name = GetOutfitName(outfitID)

	self.EditBox:SetText(name)
end


function BW_WardrobeOutfitEditFrameMixin:OnDelete()
	BW_WardrobeOutfitFrame:Hide()
	BW_DressingRoomOutfitFrame:Hide()
	local name = GetOutfitName(self.outfitID)
	BW_WardrobeOutfitFrame:ShowPopup("BW_CONFIRM_DELETE_TRANSMOG_OUTFIT", name, nil, self.outfitID)
end


function BW_WardrobeOutfitEditFrameMixin:OnAccept()
	if (not self.AcceptButton:IsEnabled()) then
		return
	end
	BW_WardrobeOutfitFrame:Hide()
	BW_DressingRoomOutfitFrame:Hide()
	
	StaticPopupSpecial_Hide(self)
	BW_WardrobeOutfitFrame:NameOutfit(self.EditBox:GetText(), self.outfitID)
end

--===================================================================================================================================
BW_WardrobeOutfitCheckAppearancesMixin = CreateFromMixins(WardrobeOutfitCheckAppearancesMixin)

function WardrobeOutfitCheckAppearancesMixin:OnEvent(event, sourceID, canCollect)
	if (BW_WardrobeOutfitFrame.pendingSources[sourceID]) then
		if (canCollect) then
			local slotID = BW_WardrobeOutfitFrame.pendingSources[sourceID]
			BW_WardrobeOutfitFrame.sources[slotID] = sourceID
		else
			BW_WardrobeOutfitFrame.hadInvalidSources = true
		end

		BW_WardrobeOutfitFrame.pendingSources[sourceID] = nil
		BW_WardrobeOutfitFrame:EvaluateSaveState()
	end
end