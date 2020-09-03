local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local MAX_DEFAULT_OUTFITS = 4 --C_TransmogCollection.GetNumMaxOutfits()
local FullList = {}

local function GetOutfits()
		FullList = C_TransmogCollection.GetOutfits()
		for i, data in ipairs(addon.chardb.profile.outfits) do
			tinsert(FullList, data)
			FullList[#FullList].outfitID = #FullList-1
		end
		return FullList
end


local function GetOutfitIndex(outfitID)
	local numOutfits = #C_TransmogCollection.GetOutfits()
	return outfitID - numOutfits + 1
end


local function IsDefaultSet(outfitID)
		return outfitID <= MAX_DEFAULT_OUTFITS 
end


function LookupIndexFromName(name)
	local outfits = GetOutfits()
	for i = 1, #outfits do
		if outfits[i]["name"] == name then
			return i-1
		end
	end
	return nil
end


local function GetOutfitName(outfitID)
	return C_TransmogCollection.GetOutfitName(outfitID) or addon.chardb.profile.outfits[GetOutfitIndex(outfitID)].name
end


StaticPopupDialogs["BW_NAME_TRANSMOG_OUTFIT"] = {
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
	text = TRANSMOG_OUTFIT_CONFIRM_OVERWRITE,
	button1 = YES,
	button2 = NO,
	OnAccept = function (self) BW_WardrobeOutfitFrame:SaveOutfit(self.data) end,
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

function BW_WardrobeOutfitMixin:OnLoad()
	local button = _G[self:GetName().."Button"]
	button:SetScript("OnMouseDown", function(self)
						PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
						BW_WardrobeOutfitFrame:Toggle(self:GetParent())
						end
					)
	UIDropDownMenu_JustifyText(self, "LEFT")
	if (self.width) then
		UIDropDownMenu_SetWidth(self, self.width)
	end
	WardrobeOutfitDropDown:Hide()

	addon:SecureHook(nil, "WardrobeTransmogFrame_OnTransmogApplied", function()
			if BW_WardrobeOutfitDropDown.selectedOutfitID and BW_WardrobeOutfitDropDown:IsOutfitDressed() then
				WardrobeTransmogFrame.BW_OutfitDropDown:OnOutfitApplied(BW_WardrobeOutfitDropDown.selectedOutfitID)
			end
		end, true)

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
	-- don't need to do anything for "TRANSMOGRIFY_UPDATE" beyond updating the save button
	self:UpdateSaveButton()
end


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

	if IsDefaultSet(outfitID) then 
		C_Transmog.LoadOutfit(outfitID)
	else
		local outfit = addon.chardb.profile.outfits[GetOutfitIndex(outfitID)]
		for slot , data in pairs(outfit) do
			if type(slot) == "number" then 
			C_Transmog.SetPending(slot, LE_TRANSMOG_TYPE_APPEARANCE, data)
			end
		end

		C_Transmog.SetPending(GetInventorySlotInfo("MAINHANDSLOT"), LE_TRANSMOG_TYPE_ILLUSION, outfit["mainHandEnchant"])
		C_Transmog.SetPending(GetInventorySlotInfo("SECONDARYHANDSLOT"), LE_TRANSMOG_TYPE_ILLUSION, outfit["offHandEnchant"])
	end
end


function BW_WardrobeOutfitMixin:GetSlotSourceID(slot, transmogType)
	local slotID = GetInventorySlotInfo(slot)
	local isTransmogrified, hasPending, isPendingCollected, canTransmogrify, cannotTransmogrifyReason, hasUndo = C_Transmog.GetSlotInfo(slotID, transmogType)
	if (not canTransmogrify and not hasUndo) then
		return NO_TRANSMOG_SOURCE_ID
	end

	local _, _, sourceID = TransmogUtil.GetInfoForEquippedSlot(slot, transmogType)
	return sourceID
end


function BW_WardrobeOutfitMixin:UpdateSaveButton()
	if (self.selectedOutfitID) then
		self.SaveButton:SetEnabled(not self:IsOutfitDressed())
	else
		self.SaveButton:SetEnabled(false)
	end
end


function BW_WardrobeOutfitMixin:OnOutfitSaved(outfitID)
	local cost, numChanges = C_Transmog.GetCost()
	if numChanges == 0 then
		self:OnOutfitApplied(outfitID)
	end
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
		if not addon.chardb.profile.lastTransmogOutfitIDSpec[specIndex] then
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
	local _, _, quality = GetItemInfo(link)
	return quality == LE_ITEM_QUALITY_ARTIFACT
end


function BW_WardrobeOutfitMixin:IsOutfitDressed()
	if (not self.selectedOutfitID) then
		return true
	end

	local appearanceSources, mainHandEnchant, offHandEnchant
	if IsDefaultSet(self.selectedOutfitID) then 
		appearanceSources, mainHandEnchant, offHandEnchant = C_TransmogCollection.GetOutfitSources(self.selectedOutfitID)
	else
		local outfit = addon.chardb.profile.outfits[GetOutfitIndex(self.selectedOutfitID)]
		appearanceSources = outfit
		mainHandEnchant = outfit["mainHandEnchant"]
		offHandEnchant = outfit["offHandEnchant"]
	end

	if (not appearanceSources) then
		return true
	end

	for i = 1, #TRANSMOG_SLOTS do
		if (TRANSMOG_SLOTS[i].transmogType == LE_TRANSMOG_TYPE_APPEARANCE) then
			local sourceID = self:GetSlotSourceID(TRANSMOG_SLOTS[i].slot, LE_TRANSMOG_TYPE_APPEARANCE)
			local slotID = GetInventorySlotInfo(TRANSMOG_SLOTS[i].slot)
			if (sourceID ~= NO_TRANSMOG_SOURCE_ID and sourceID ~= appearanceSources[slotID]) then
				-- No artifacts in outfits, their sourceID is overriden to NO_TRANSMOG_SOURCE_ID
				if (not IsSourceArtifact(sourceID) or appearanceSources[slotID] ~= NO_TRANSMOG_SOURCE_ID) then
					return false
				end
			end
		end
	end

	local mainHandSourceID = self:GetSlotSourceID("MAINHANDSLOT", LE_TRANSMOG_TYPE_ILLUSION)
	if (mainHandSourceID ~= mainHandEnchant) then
		return false
	end
	local offHandSourceID = self:GetSlotSourceID("SECONDARYHANDSLOT", LE_TRANSMOG_TYPE_ILLUSION)

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

	for i = 1, #TRANSMOG_SLOTS do
		local sourceID = self:GetSlotSourceID(TRANSMOG_SLOTS[i].slot, TRANSMOG_SLOTS[i].transmogType)
		if (sourceID ~= NO_TRANSMOG_SOURCE_ID) then
			if (TRANSMOG_SLOTS[i].transmogType == LE_TRANSMOG_TYPE_APPEARANCE) then
				local slotID = GetInventorySlotInfo(TRANSMOG_SLOTS[i].slot)
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
			elseif (TRANSMOG_SLOTS[i].transmogType == LE_TRANSMOG_TYPE_ILLUSION) then
				if (TRANSMOG_SLOTS[i].slot == "MAINHANDSLOT") then
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


function BW_WardrobeOutfitFrameMixin:Update()
	local outfits = GetOutfits()
	local buttons = self.Buttons
	local numButtons = 0
	local stringWidth = 0
	local minStringWidth = self.dropDown.minMenuStringWidth or OUTFIT_FRAME_MIN_STRING_WIDTH
	local maxStringWidth = self.dropDown.maxMenuStringWidth or OUTFIT_FRAME_MAX_STRING_WIDTH
	self:SetWidth(maxStringWidth + OUTFIT_FRAME_ADDED_PIXELS)
	for i = 1, #outfits + 1 do
		local newOutfitButton = (i == (#outfits + 1))
		if (outfits[i] or newOutfitButton) then
			local button = buttons[i]
			if (not button) then
				button = CreateFrame("BUTTON", nil, self, "BW_WardrobeOutfitButtonTemplate")
				button.EditButton:SetScript("OnClick", function(self)
					PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
					BW_WardrobeOutfitEditFrame:ShowForOutfit(self:GetParent().outfitID)
				end)

				button:SetPoint("TOPLEFT", buttons[i-1], "BOTTOMLEFT", 0, 0)
				button:SetPoint("TOPRIGHT", buttons[i-1], "BOTTOMRIGHT", 0, 0)
			end
			button:Show()

			if (newOutfitButton) then
				button:SetText(GREEN_FONT_COLOR_CODE..TRANSMOG_OUTFIT_NEW..FONT_COLOR_CODE_CLOSE)
				button.Icon:SetTexture("Interface\\PaperDollInfoFrame\\Character-Plus")
				button.outfitID = nil
				button.Check:Hide()
				button.Selection:Hide()
			else
				if (outfits[i].outfitID == self.dropDown.selectedOutfitID) then
					button.Check:Show()
					button.Selection:Show()
				else
					button.Selection:Hide()
					button.Check:Hide()
				end
				button.Text:SetWidth(0)
				button:SetText(NORMAL_FONT_COLOR_CODE..outfits[i].name..FONT_COLOR_CODE_CLOSE)
				button.Icon:SetTexture(outfits[i].icon)
				button.outfitID = outfits[i].outfitID
			end

			stringWidth = max(stringWidth, button.Text:GetStringWidth())
			if (button.Text:GetStringWidth() > maxStringWidth) then
				button.Text:SetWidth(maxStringWidth)
			end
			numButtons = numButtons + 1
		else
			if (buttons[i]) then
				buttons[i]:Hide()
			end
		end
	end

	for i = #outfits + 2 , #buttons do
		buttons[i]:Hide()
	end


	stringWidth = max(stringWidth, minStringWidth)
	stringWidth = min(stringWidth, maxStringWidth)
	self:SetWidth(stringWidth + OUTFIT_FRAME_ADDED_PIXELS)
	self:SetHeight(30 + numButtons * 20)
end


function BW_WardrobeOutfitFrameMixin:SaveOutfit(name)
	local index = LookupIndexFromName(name)
	local icon
	for i = 1, #TRANSMOG_SLOTS do
		if (TRANSMOG_SLOTS[i].transmogType == LE_TRANSMOG_TYPE_APPEARANCE) then
			local slotID = GetInventorySlotInfo(TRANSMOG_SLOTS[i].slot)
			local sourceID = self.sources[slotID]
			if (sourceID) then
				icon = select(4, C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
				if (icon) then
					break
				end
			end
		end
	end

	local outfitID
	if index and index <= MAX_DEFAULT_OUTFITS then 
		outfitID = C_TransmogCollection.SaveOutfit(name, self.sources, self.mainHandEnchant, self.offHandEnchant, icon)
	else
		local outfit
		if index then 
			addon.chardb.profile.outfits[GetOutfitIndex(index)] = self.sources
			outfit = addon.chardb.profile.outfits[GetOutfitIndex(index)]
		else
			tinsert(addon.chardb.profile.outfits, self.sources)
			outfit = addon.chardb.profile.outfits[#addon.chardb.profile.outfits]
		end

		outfit["name"] = name
		outfit["mainHandEnchant"] = self.mainHandEnchant or 0
		outfit["offHandEnchant"] = self.offHandEnchant or 0
		local icon = select(4, C_TransmogCollection.GetAppearanceSourceInfo(outfit[1]))
		outfit["icon"] = icon
		outfitID = index
	end

	if (self.popupDropDown) then
		self.popupDropDown:SelectOutfit(outfitID)
		self.popupDropDown:OnOutfitSaved(outfitID)
	end
end


function BW_WardrobeOutfitFrameMixin:DeleteOutfit(outfitID)
	if IsDefaultSet(outfitID) then
		C_TransmogCollection.DeleteOutfit(outfitID)
	else
		tremove(addon.chardb.profile.outfits, GetOutfitIndex(outfitID))
	end
end


function BW_WardrobeOutfitFrameMixin:NameOutfit(newName, outfitID)
	local outfits = GetOutfits()
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
		local index = GetOutfitIndex(outfitID)
		addon.chardb.profile.outfits[index].name = newName
	else
		-- this is a new outfit
		self:SaveOutfit(newName)
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
		BW_WardrobeOutfitFrame:SaveOutfit(self.name)
		BW_WardrobeOutfitFrame:ClosePopups()
	else
		BW_WardrobeOutfitFrame:ShowPopup("BW_NAME_TRANSMOG_OUTFIT")
	end
end

--===================================================================================================================================
BW_WardrobeOutfitButtonMixin = {} --CreateFromMixins(WardrobeOutfitButtonMixin)

function BW_WardrobeOutfitButtonMixin:OnClick()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	BW_WardrobeOutfitFrame:Hide()
	if (self.outfitID) then
		BW_WardrobeOutfitFrame.dropDown:SelectOutfit(self.outfitID, true)
	else
		--if (BW_WardrobeOutfitFrame and BW_WardrobeOutfitFrame.OutfitHelpBox:IsShown()) then
			--BW_WardrobeOutfitFrame.OutfitHelpBox:Hide()
			--SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_TRANSMOG_OUTFIT_DROPDOWN, true)
		--end
		BW_WardrobeOutfitFrame.dropDown:CheckOutfitForSave()
	end
end

--===================================================================================================================================
BW_WardrobeOutfitEditFrameMixin = CreateFromMixins(WardrobeOutfitEditFrameMixin)-- {}

function BW_WardrobeOutfitEditFrameMixin:ShowForOutfit(outfitID)
	BW_WardrobeOutfitFrame:Hide()
	BW_WardrobeOutfitFrame:ShowPopup(self)
	self.outfitID = outfitID
	local name = GetOutfitName(outfitID)

	self.EditBox:SetText(name)
end


function BW_WardrobeOutfitEditFrameMixin:OnDelete()
	BW_WardrobeOutfitFrame:Hide()
	local name = GetOutfitName(self.outfitID)
	BW_WardrobeOutfitFrame:ShowPopup("BW_CONFIRM_DELETE_TRANSMOG_OUTFIT", name, nil, self.outfitID)
end


function BW_WardrobeOutfitEditFrameMixin:OnAccept()
	if (not self.AcceptButton:IsEnabled()) then
		return
	end
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