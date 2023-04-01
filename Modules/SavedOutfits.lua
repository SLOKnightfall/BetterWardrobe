local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)


local MAX_DEFAULT_OUTFITS = C_TransmogCollection.GetNumMaxOutfits()

--Coresponds to wardrobeOutfits

--Function to update character to reflect DB changes
function addon.Init.SavedOutfitDBUpdate(force) 
	--V9.0.1 Moves over saved set data from fixed DB vs a profile
	local character = addon.setdb:GetCurrentProfile()
	if addon.setdb.global.updates[character]["9.0.1"] and not force then return end

	local table = addon.setdb.global.outfits[character] or {}
	for i, data in ipairs(addon.OutfitDB.char.outfits) do
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
		addon.OutfitDB.char.outfits = {}
	end
end
BW_SavedOutfitDBUpdate = addon.Init.SavedOutfitDBUpdate


local function GetTableIndex(index)
	local numOutfits = #C_TransmogCollection.GetOutfits()
	return index - numOutfits + 1
end


local function IsDefaultSet(outfitID)
	return addon.IsDefaultSet(outfitID)
	--return outfitID < MAX_DEFAULT_OUTFITS  -- #C_TransmogCollection.GetOutfits()--MAX_DEFAULT_OUTFITS 
end


function LookupOutfitIDFromName(name)
	local outfits = addon.GetOutfits(true)
	for i, data in ipairs(outfits) do
		if data.name == name then
			return data.outfitID
		end
	end
	return nil
end

function LookupIndexFromID(outfitID)
	local outfits = addon.GetOutfits(true)
	for i, data in ipairs(outfits) do
		if data.outfitID == outfitID then
			return data.index
		end
	end
	return nil
end

local function GetOutfitName(outfitID)
	local savedSets = addon.GetSavedList()
	for i, data in ipairs(savedSets) do
		if data.setID == outfitID then 
			return data.name
		end
	end
end
addon.GetOutfitName = GetOutfitName

StaticPopupDialogs["BW_NAME_TRANSMOG_OUTFIT"] = {
	preferredIndex = 3,
	text = TRANSMOG_OUTFIT_NAME,
	button1 = SAVE,
	button2 = CANCEL,
	OnAccept = function(self)
		BetterWardrobeOutfitFrame:NameOutfit(self.editBox:GetText(), self.data)
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
	OnAccept = function (self) BetterWardrobeOutfitFrame:DeleteOutfit(self.data) end,
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
		if (BetterWardrobeOutfitFrame.name) then
			self.button1:SetText(SAVE)
		else
			self.button1:SetText(CONTINUE)
		end
	end,
	OnAccept = function(self)
		BetterWardrobeOutfitFrame:ContinueWithSave()
	end,
	hideOnEscape = 1,
	timeout = 0,
	whileDead = 1,
}

local overwriteID
StaticPopupDialogs["BW_CONFIRM_OVERWRITE_TRANSMOG_OUTFIT"] = {
	preferredIndex = 3,
	text = TRANSMOG_OUTFIT_CONFIRM_OVERWRITE,
	button1 = YES,
	button2 = NO,
	OnAccept = function (self) 
		local name = self.data
		BetterWardrobeOutfitFrame:DeleteOutfit(overwriteID)
		overwriteID = nil
		BetterWardrobeOutfitFrame:NewOutfit(self.data)
		--BetterWardrobeOutfitFrame:SaveOutfit(self.data)
		--if DressUpFrame:IsShown() then --todo fix
			--BW_DressingRoomOutfitFrameMixin:SaveOutfit(self.data)
		--else
			--BetterWardrobeOutfitFrame:NewOutfit(self.data)
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

BetterWardrobeOutfitDropDownMixin = { }

function BetterWardrobeOutfitDropDownMixin:OnLoad()
	local button = _G[self:GetName().."Button"]
	button:SetScript("OnMouseDown", function(self)
						PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
						BetterWardrobeOutfitFrame:Toggle(self:GetParent())
						end
					)
	BW_UIDropDownMenu_JustifyText(self, "LEFT")
	if self.width then
		BW_UIDropDownMenu_SetWidth(self, self.width)
	end
end

function BetterWardrobeOutfitDropDownMixin:OnShow()
	self:RegisterEvent("TRANSMOG_OUTFITS_CHANGED")
	self:RegisterEvent("TRANSMOGRIFY_UPDATE")
	self:SelectOutfit(self:GetLastOutfitID(), true)
end

function BetterWardrobeOutfitDropDownMixin:OnHide()
	self:UnregisterEvent("TRANSMOG_OUTFITS_CHANGED")
	self:UnregisterEvent("TRANSMOGRIFY_UPDATE")
	BetterWardrobeOutfitFrame:ClosePopups(self)
	if BetterWardrobeOutfitFrame.dropDown == self then
		BetterWardrobeOutfitFrame:Hide()
	end
end

function BetterWardrobeOutfitDropDownMixin:OnEvent(event)
	if event == "TRANSMOG_OUTFITS_CHANGED" then
		self:SelectOutfit(self.selectedOutfitID)
		if ( BetterWardrobeOutfitFrame:IsShown() ) then
			BetterWardrobeOutfitFrame:Update()
		end
	end

	self:UpdateSaveButton()
end

function BetterWardrobeOutfitDropDownMixin:UpdateSaveButton()
	if  self.selectedOutfitID then
	local dressed = self:IsOutfitDressed()
		self.SaveButton:SetEnabled(DressUpFrame:IsShown() or not dressed)
	else
		self.SaveButton:SetEnabled(false)
	end
end

function BetterWardrobeOutfitDropDownMixin:OnOutfitSaved(outfitID)
end

function BetterWardrobeOutfitDropDownMixin:SelectOutfit(outfitID, loadOutfit)
	local name
	if outfitID then
		name = GetOutfitName(outfitID)
	end
	if name then
		BW_UIDropDownMenu_SetText(self, name)
	else
		outfitID = nil
		BW_UIDropDownMenu_SetText(self, GRAY_FONT_COLOR_CODE..TRANSMOG_OUTFIT_NONE..FONT_COLOR_CODE_CLOSE)
	end

	self.selectedOutfitID = outfitID
	if BetterWardrobeCollectionFrame then 
		BetterWardrobeCollectionFrame.SetsTransmogFrame.selectedSetID = outfitID
	end

	if loadOutfit then
		self:LoadOutfit(outfitID)
	end
	self:UpdateSaveButton()
	self:OnSelectOutfit(outfitID)
end

function BetterWardrobeOutfitDropDownMixin:LoadOutfit(outfitID)
end

function BetterWardrobeOutfitDropDownMixin:OnSelectOutfit(outfitID)
end

function BetterWardrobeOutfitDropDownMixin:GetLastOutfitID()
	return
end

local function IsSourceArtifact(sourceID)
	local link = select(6, C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
	if not link then
		return false
	end
	local _, _, quality = GetItemInfo(link)
	return quality == Enum.ItemQuality.Artifact
end

local function isHiddenAppearance(appearanceID, set_appearanceID, slotID)
	if set_appearanceID == 0 then return true end
	local sourceInfo = C_TransmogCollection.GetSourceInfo(set_appearanceID)

	if sourceInfo then
		local isCollected = sourceInfo.isCollected

		local isemptyslot = (appearanceID == 0)
		if not isCollected and isemptyslot then
			return true
		end
	end
	return false
end

function BetterWardrobeOutfitDropDownMixin:IsOutfitDressed()
	if not self.selectedOutfitID then
		return true
	end

	if addon.GetSetType(self.selectedOutfitID) == "SavedBlizzard" then 
		local selectedOutfitID = addon:GetBlizzID(self.selectedOutfitID)
		local outfitItemTransmogInfoList = C_TransmogCollection.GetOutfitItemTransmogInfoList(selectedOutfitID)
		if not outfitItemTransmogInfoList then
			return true
		end

		local currentItemTransmogInfoList = self:GetItemTransmogInfoList()
		if not currentItemTransmogInfoList then
			return true
		end

		for slotID, itemTransmogInfo in ipairs(currentItemTransmogInfoList) do
			if not itemTransmogInfo:IsEqual(outfitItemTransmogInfoList[slotID]) then
				if itemTransmogInfo.appearanceID ~= Constants.Transmog.NoTransmogID then
					return false
				end
			end
		end
		return true

	else
		local outfit = addon.GetSetInfo(self.selectedOutfitID) --addon.OutfitDB.char.outfits[LookupIndexFromID(self.selectedOutfitID)]
		if not outfit then
			return true
		end

		local outfitItemTransmogInfoList = addon.C_TransmogCollection.GetOutfitItemTransmogInfoList(self.selectedOutfitID)
		local currentItemTransmogInfoList = self:GetItemTransmogInfoList()
		if not currentItemTransmogInfoList then
			return true
		end

		for slotID, itemTransmogInfo in ipairs(currentItemTransmogInfoList) do
			if not itemTransmogInfo:IsEqual(outfitItemTransmogInfoList[slotID]) then
				if itemTransmogInfo.appearanceID ~= Constants.Transmog.NoTransmogID or outfitItemTransmogInfoList[slotID].appearanceID ~= Constants.Transmog.NoTransmogID then
					if not isHiddenAppearance(itemTransmogInfo.appearanceID, outfitItemTransmogInfoList[slotID].appearanceID, slotID) then
						return false
					end
				end
				
			end
		end

		return true
	end
end

function BetterWardrobeOutfitDropDownMixin:CheckOutfitForSave(outfitID)
	local pendingAppearances = { }
	local hasInvalidAppearances = false
	local hasValidAppearances = false
	local itemTransmogInfoList = self:GetItemTransmogInfoList()

	for slotID, itemTransmogInfo in ipairs(itemTransmogInfoList) do
		local isValidAppearance = false
		if TransmogUtil.IsValidTransmogSlotID(slotID) then
			local appearanceID = itemTransmogInfo.appearanceID
			if appearanceID ~= Constants.Transmog.NoTransmogID then
				isValidAppearance = C_TransmogCollection.PlayerKnowsSource(appearanceID)
				if not isValidAppearance then
					local isInfoReady, canCollect = C_TransmogCollection.PlayerCanCollectSource(itemTransmogInfo.appearanceID)
					if isInfoReady then
						isValidAppearance = canCollect
					else
						pendingAppearances[appearanceID] = slotID
					end
				end

				if isValidAppearance then
					hasValidAppearances = true
				else
					hasInvalidAppearances = true
				end
			end
		end
		if not isValidAppearance then
			itemTransmogInfo:Clear()
		end
	end

	-- store the state for this save
	BetterWardrobeOutfitFrame.pendingAppearances = pendingAppearances
	BetterWardrobeOutfitFrame.itemTransmogInfoList = itemTransmogInfoList
	BetterWardrobeOutfitFrame.hasValidAppearances = hasValidAppearances
	BetterWardrobeOutfitFrame.hasInvalidAppearances = hasInvalidAppearances
	BetterWardrobeOutfitFrame.outfitID = outfitID
	-- save the dropdown
	BetterWardrobeOutfitFrame.popupDropDown = self

	BetterWardrobeOutfitFrame:EvaluateSaveState()
end

function BetterWardrobeOutfitDropDownMixin:IsDefaultSet(outfitID)
		return addon.IsDefaultSet(outfitID)
end

--===================================================================================================================================
BetterWardrobeOutfitFrameMixin = { }

BetterWardrobeOutfitFrameMixin.popups = {
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

function BetterWardrobeOutfitFrameMixin:OnHide()
	self.timer = nil
end

function BetterWardrobeOutfitFrameMixin:Toggle(dropDown)
	if ( self.dropDown == dropDown and self:IsShown() ) then
		BetterWardrobeOutfitFrame:Hide()
	else
		CloseDropDownMenus()
		self.dropDown = dropDown
		self:Show()
		self:SetPoint("TOPLEFT", self.dropDown, "BOTTOMLEFT", 8, -3)
		--if((self:GetTop() - self:GetBottom() + 5) >= UIParent:GetHeight() - self:GetTop() )  then
		 --  self:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 5)
		--end
		self:Update()
	end
end

function BetterWardrobeOutfitFrameMixin:OnUpdate(elapsed)
	local mouseFocus = GetMouseFocus()
	for i = 1, #self.Buttons do
		local button = self.Buttons[i]
		if ( button == mouseFocus or button:IsMouseOver() ) then
			if ( button.outfitID ) then
				button.EditButton:Show()
			else
				button.EditButton:Hide()
			end
			button.Highlight:Show()
		else
			button.EditButton:Hide()
			button.Highlight:Hide()
		end
	end
	if ( BW_UIDROPDOWNMENU_OPEN_MENU ) then
		self:Hide()
	end
	if ( self.timer ) then
		self.timer = self.timer - elapsed
		if ( self.timer < 0 ) then
			self:Hide()
		end
	end
end

function BetterWardrobeOutfitFrameMixin:StartHideCountDown()
	self.timer = BW_UIDROPDOWNMENU_SHOW_TIME
end

function BetterWardrobeOutfitFrameMixin:StopHideCountDown()
	self.timer = nil
end


local function GetButton(self, index)
	local buttons = self.Buttons
	local button = buttons[index]
			if (not button) then
				button = CreateFrame("BUTTON", nil, self.Content, "BetterWardrobeOutfitButtonTemplate")
				button.EditButton:SetScript("OnClick", function(self)
					PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
					BetterWardrobeOutfitEditFrame:ShowForOutfit(self:GetParent().outfitID)
				end)

				button:SetPoint("TOPLEFT", buttons[index-1], "BOTTOMLEFT", 0, 0)
				button:SetPoint("TOPRIGHT", buttons[index-1], "BOTTOMRIGHT", 0, 0)
			end
		return button 
end

function BetterWardrobeOutfitFrameMixin:Update()
	local outfits = addon.GetOutfits(true)
		--local sets = addon.GetSavedList()--addon.setdb.global.sets
	addon.SortDropdown(outfits)
	----local mogit_Outfits = addon.GetMogitOutfits()
	local buttons = self.Buttons
	local numButtons = 1
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

			if outfit.set == "mogit" or outfit.set == "transmog_outfits" then 
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
	if numButtons > 32 then 
		self:SetHeight(30 + 32 * 20)

	else
		self:SetHeight(30 + numButtons * 20)

	end
	--self:SetHeight(30 + numButtons * 20)
end

function BetterWardrobeOutfitFrameMixin:NewOutfit(name)
	local outfitID = LookupOutfitIDFromName(name) --or  ((#C_TransmogCollection.GetOutfits() <= MAX_DEFAULT_OUTFITS) and #C_TransmogCollection.GetOutfits() -1 ) -- or #GetOutfits()-1
	local icon = QUESTION_MARK_ICON
	local outfit

	for slotID, itemTransmogInfo in ipairs(self.itemTransmogInfoList) do
		local appearanceID = itemTransmogInfo.appearanceID
		if appearanceID ~= Constants.Transmog.NoTransmogID then
			icon = select(4, C_TransmogCollection.GetAppearanceSourceInfo(appearanceID))
			if icon then
				break
			end
		end
	end

	--[[local sources = {}
			for i, data in pairs(self.itemTransmogInfoList) do
				sources[i] = data.appearanceID
			end]]

	if (outfitID and IsDefaultSet(outfitID)) or (#C_TransmogCollection.GetOutfits() < MAX_DEFAULT_OUTFITS)  then 
		outfitID = C_TransmogCollection.NewOutfit(name, icon, self.itemTransmogInfoList)
	else
		if outfitID then 
			addon.OutfitDB.char.outfits[LookupIndexFromID(outfitID)]  = addon.OutfitDB.char.outfits[LookupIndexFromID(outfitID)] or {}
			outfit = addon.OutfitDB.char.outfits[LookupIndexFromID(outfitID)]
		else
			tinsert(addon.OutfitDB.char.outfits, {})
			outfit = addon.OutfitDB.char.outfits[#addon.OutfitDB.char.outfits]
		end
		outfit["name"] = name
		----local icon = select(4, C_TransmogCollection.GetAppearanceSourceInfo(outfit[1]))
		outfit["icon"] = icon
		--outfit.itemData = itemData

		local itemData = {}
		for i, data in pairs(self.itemTransmogInfoList) do
			outfit[i] = data.appearanceID
			if i == 3 then
				outfit["offShoulder"] = data.secondaryAppearanceID or 0
			elseif i == 16 then 
				outfit["mainHandEnchant"] = data.illusionID or 0
			elseif i == 17 then 
				outfit["offHandEnchant"] = data.illusionID or 0
			end
		end

		--outfit.sources = sources
		--outfit.itemTransmogInfoList =  self.itemTransmogInfoList or {}
		--outfitID = index
	end

	if ( self.popupDropDown ) then
		self.popupDropDown:SelectOutfit(outfitID)
		self.popupDropDown:OnOutfitSaved(outfitID)
	end

	--addon.setdb.global.sets[addon.setdb:GetCurrentProfile()] = addon.GetSavedList()
	addon.setdb.global.sets[addon.setdb:GetCurrentProfile()] = addon.StoreBlizzardSets()


end

function BetterWardrobeOutfitFrameMixin:DeleteOutfit(outfitID)
	if IsDefaultSet(outfitID) then
		C_TransmogCollection.DeleteOutfit(addon:GetBlizzID(outfitID))
	else
		tremove(addon.OutfitDB.char.outfits, LookupIndexFromID(outfitID))
	end


--[[---TODO:CHeck
	if GetCVarBool("transmogCurrentSpecOnly") then
		local specIndex = GetSpecialization()

		if addon.IsDefaultSet(outfitID) then
			SetCVar("lastTransmogOutfitIDSpec"..specIndex, value)


		local value = addon.OutfitDB.char.lastTransmogOutfitIDSpec[specIndex]
		if type(value) == number and value > 0 then  addon.OutfitDB.char.lastTransmogOutfitIDSpec[specIndex] = value - 1 end

		--SetCVar("lastTransmogOutfitIDSpec"..specIndex, value)
	else
		for specIndex = 1, GetNumSpecializations() do
			--SetCVar("lastTransmogOutfitIDSpec"..specIndex, value)
		local value = addon.OutfitDB.char.lastTransmogOutfitIDSpec[specIndex]
		if type(value) == number and value > 0  then  addon.OutfitDB.char.lastTransmogOutfitIDSpec[specIndex] = value - 1 end
		end
	end]]

	--addon.setdb.global.sets[addon.setdb:GetCurrentProfile()] = addon.GetSavedList()
	addon.setdb.global.sets[addon.setdb:GetCurrentProfile()] = addon.StoreBlizzardSets()

	addon:SendMessage("BW_TRANSMOG_COLLECTION_UPDATED")
end

function BetterWardrobeOutfitFrameMixin:NameOutfit(newName, outfitID)
	local outfits = addon.GetOutfits(true)
	for i = 1, #outfits do
		if (outfits[i].name == newName) then
			if (outfitID) then
				UIErrorsFrame:AddMessage(TRANSMOG_OUTFIT_ALREADY_EXISTS, 1.0, 0.1, 0.1, 1.0)
			else
				overwriteID = outfits[i].outfitID
				BetterWardrobeOutfitFrame:ShowPopup("BW_CONFIRM_OVERWRITE_TRANSMOG_OUTFIT", newName, nil, newName)
			end
			return
		end
	end

	if outfitID and IsDefaultSet(outfitID) then
		local blizzardID = addon:GetBlizzID(outfitID)
	-- this is a rename
		C_TransmogCollection.RenameOutfit(blizzardID, newName)
	elseif outfitID then 
		local index = LookupIndexFromID(outfitID)
		addon.OutfitDB.char.outfits[index].name = newName
	else
		-- this is a new outfit
		self:NewOutfit(newName)
	end
end

function BetterWardrobeOutfitFrameMixin:ShowPopup(popup, ...)
	-- close all other popups
	for _, listPopup in pairs(self.popups) do
		if ( listPopup ~= popup ) then
			StaticPopup_Hide(listPopup)
		end
	end
	if ( popup ~= BetterWardrobeOutfitEditFrame ) then
		StaticPopupSpecial_Hide(BetterWardrobeOutfitEditFrame)
	end

	self.popupDropDown = self.dropDown
	if ( popup == BetterWardrobeOutfitEditFrame ) then
		StaticPopupSpecial_Show(BetterWardrobeOutfitEditFrame)
	else
		StaticPopup_Show(popup, ...)
	end
end

function BetterWardrobeOutfitFrameMixin:ClosePopups(requestingDropDown)
	if ( requestingDropDown and requestingDropDown ~= self.popupDropDown ) then
		return
	end
	for _, popup in pairs(self.popups) do
		StaticPopup_Hide(popup)
	end
	StaticPopupSpecial_Hide(BetterWardrobeOutfitEditFrame)

	-- clean up
	self.itemTransmogInfoList = nil
	self.pendingAppearances = nil
	self.hasValidAppearances = nil
	self.hasInvalidAppearances = nil
	self.outfitID = nil
	self.popupDropDown = nil
	self.name = nil
	self.sources = nil
end

function BetterWardrobeOutfitFrameMixin:EvaluateSaveState()
	if next(self.pendingAppearances) then
		-- wait
		if ( not StaticPopup_Visible("TRANSMOG_OUTFIT_CHECKING_APPEARANCES") ) then
			BetterWardrobeOutfitFrame:ShowPopup("TRANSMOG_OUTFIT_CHECKING_APPEARANCES", nil, nil, nil, WardrobeOutfitCheckAppearancesFrame)
		end
	elseif not self.hasValidAppearances then
		-- stop
		BetterWardrobeOutfitFrame:ShowPopup("TRANSMOG_OUTFIT_ALL_INVALID_APPEARANCES")
	elseif self.hasInvalidAppearances then
		-- warn
		BetterWardrobeOutfitFrame:ShowPopup("BW_TRANSMOG_OUTFIT_SOME_INVALID_APPEARANCES")
	else
		BetterWardrobeOutfitFrame:ContinueWithSave()
	end
end

function BetterWardrobeOutfitFrameMixin:ContinueWithSave()
	if self.outfitID and IsDefaultSet(self.outfitID) then
	-- this is a rename
		C_TransmogCollection.ModifyOutfit(addon:GetBlizzID(self.outfitID), self.itemTransmogInfoList)
		BetterWardrobeOutfitFrame:ClosePopups()
	elseif self.outfitID then
			addon.OutfitDB.char.outfits[LookupIndexFromID(self.outfitID)]  = addon.OutfitDB.char.outfits[LookupIndexFromID(self.outfitID)] or {}
			outfit = addon.OutfitDB.char.outfits[LookupIndexFromID(self.outfitID)]
			--outfit.itemTransmogInfoList =  self.itemTransmogInfoList or {}

			local itemData = {}
			for i, data in pairs(self.itemTransmogInfoList) do
				local sourceInfo = C_TransmogCollection.GetSourceInfo(data.appearanceID)
				if sourceInfo then
					local appearanceID = sourceInfo.visualID
					local itemID = sourceInfo.itemID
					local itemMod = sourceInfo.itemModID
					local sourceID = sourceInfo.sourceID
					itemData[i] = {"'"..itemID..":"..itemMod.."'", sourceID, appearanceID}
				end
			end

			outfit.itemData = itemData
			BetterWardrobeOutfitFrame:ClosePopups()
	else
		-- this is a new outfit
		WardrobeOutfitFrame:ShowPopup("BW_NAME_TRANSMOG_OUTFIT")
	end
end


function BetterWardrobeOutfitFrameMixin:CreateScrollFrame()
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

	local button = CreateFrame("BUTTON", nil, self.Content, "BetterWardrobeOutfitButtonTemplate")
	button.EditButton:SetScript("OnClick", function(self)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		BetterWardrobeOutfitEditFrame:ShowForOutfit(self:GetParent().outfitID)
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
		return BetterWardrobeOutfitFrame:StartHideCountDown()
	end

	function self.moduleoptions:StopHideCountDown()
		return BetterWardrobeOutfitFrame:StopHideCountDown()
	end

	self.Buttons = self.moduleoptions.Buttons
end

--===================================================================================================================================
BetterWardrobeOutfitButtonMixin = { }

function BetterWardrobeOutfitButtonMixin:OnClick()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	BetterWardrobeOutfitFrame:Hide()

	if ( self.outfitID ) then
		BetterWardrobeOutfitFrame.dropDown:SelectOutfit(self.outfitID, true)
	else
		--if ( WardrobeTransmogFrame and HelpTip:IsShowing(WardrobeTransmogFrame, TRANSMOG_OUTFIT_DROPDOWN_TUTORIAL) ) then
			--HelpTip:Hide(WardrobeTransmogFrame, TRANSMOG_OUTFIT_DROPDOWN_TUTORIAL)
			--SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_TRANSMOG_OUTFIT_DROPDOWN, true)
		--end
		BetterWardrobeOutfitFrame.dropDown:CheckOutfitForSave()
	end
end

--===================================================================================================================================
BetterWardrobeOutfitEditFrameMixin = { }

function BetterWardrobeOutfitEditFrameMixin:ShowForOutfit(outfitID)
	BetterWardrobeOutfitFrame:Hide()
	BetterWardrobeOutfitFrame:ShowPopup(self)
	self.outfitID = outfitID
	local name = GetOutfitName(outfitID)
	self.EditBox:SetText(name)
end

function BetterWardrobeOutfitEditFrameMixin:OnDelete()
	BetterWardrobeOutfitFrame:Hide()
	local name = C_TransmogCollection.GetOutfitInfo(addon:GetBlizzID(self.outfitID)) or self.name or ""
	BetterWardrobeOutfitFrame:ShowPopup("BW_CONFIRM_DELETE_TRANSMOG_OUTFIT", name, nil,  self.outfitID)
end

function BetterWardrobeOutfitEditFrameMixin:OnAccept()
	if ( not self.AcceptButton:IsEnabled() ) then
		return
	end
	StaticPopupSpecial_Hide(self)
	BetterWardrobeOutfitFrame:NameOutfit(self.EditBox:GetText(), self.outfitID)
	addon:SendMessage("BW_TRANSMOG_COLLECTION_UPDATED")
end

--===================================================================================================================================
BetterWardrobeOutfitCheckAppearancesMixin = { }

function BetterWardrobeOutfitCheckAppearancesMixin:OnLoad()
	self.Anim:Play()
end

function BetterWardrobeOutfitCheckAppearancesMixin:OnShow()
	self:RegisterEvent("TRANSMOG_SOURCE_COLLECTABILITY_UPDATE")
end

function BetterWardrobeOutfitCheckAppearancesMixin:OnHide()
	self:UnregisterEvent("TRANSMOG_SOURCE_COLLECTABILITY_UPDATE")
end

function BetterWardrobeOutfitCheckAppearancesMixin:OnEvent(event, appearanceID, canCollect)
	local slotID = BetterWardrobeOutfitFrame.pendingAppearances[appearanceID]
	if slotID then
		if not canCollect then
			BetterWardrobeOutfitFrame.hasInvalidAppearances = true
			for i, itemTransmogInfo in ipairs(BetterWardrobeOutfitFrame.itemTransmogInfoList) do
				if itemTransmogInfo.appearanceID == appearanceID then
					itemTransmogInfo:Clear()
				end
			end
		end
		BetterWardrobeOutfitFrame.pendingAppearances[appearanceID] = nil
		BetterWardrobeOutfitFrame:EvaluateSaveState()
	end
end

local outfitDropdown
function addon.RefreshSaveOutfitDropdown()
	local list = {}

	for name in pairs(addon.setdb.global.sets)do
		tinsert(list, name)
	end
	outfitDropdown:SetList(list)

	for i, name in ipairs(list) do
		if name == addon.setdb:GetCurrentProfile() then
			outfitDropdown:SetValue(i)
			break
		end
	end
end


local function SavedOutfitDB_Dropdown_OnClick(self, arg1, arg2, checked)
		local value = arg1
		local name = UnitName("player")
		local realm = GetRealmName()

		if arg1 ~= addon.setdb:GetCurrentProfile() then 
		addon.SelecteSavedList = arg1
		else
			addon.SelecteSavedList = false
		end
		BetterWardrobeCollectionFrame.SetsCollectionFrame:OnSearchUpdate()
		BetterWardrobeCollectionFrame.SetsTransmogFrame:OnSearchUpdate()

		BW_UIDropDownMenu_SetSelectedValue(BW_DBSavedSetDropdown, arg1)
		--BW_UIDropDownMenu_SetText(BW_DBSavedSetDropdown, arg1)

		addon.savedSetCache = nil
end

function SavedOutfitDB_Dropdown_Menu(frame, level, menuList)
	local count = 1
	for name in pairs(addon.setdb.global.sets)do
		 local info = BW_UIDropDownMenu_CreateInfo()
		 info.func = SavedOutfitDB_Dropdown_OnClick
		 info.text, info.arg1 = name, name
		  BW_UIDropDownMenu_AddButton(info)
		if name == addon.setdb:GetCurrentProfile() then
			BW_UIDropDownMenu_SetSelectedValue(BW_DBSavedSetDropdown, name)
		end
		  count = count +1
	end
end

--Dropdownmenu for the selection of other character's saved sets
function addon.Init.SavedSetsDropDown_Initialize(self)
	--local f = BW_UIDropDownMenu_Create("BW_DBSavedSetDropdown", BW_WardrobeCollectionFrame)
	BW_DBSavedSetDropdown = CreateFrame("Frame", "BW_DBSavedSetDropdown", BetterWardrobeCollectionFrame, "BW_UIDropDownMenuTemplate")
	--BW_DBSavedSetDropdown:SetPoint("TOPRIGHT", "BW_SortDropDown", "TOPRIGHT")
	BW_DBSavedSetDropdown:SetPoint("TOPLEFT", BetterWardrobeVisualToggle, "TOPRIGHT", -15, 0)

	BW_UIDropDownMenu_SetWidth(BW_DBSavedSetDropdown, 165) -- Use in place of dropDown:SetWidth

	BW_UIDropDownMenu_Initialize(BW_DBSavedSetDropdown, SavedOutfitDB_Dropdown_Menu)
	BW_UIDropDownMenu_SetSelectedValue(BW_DBSavedSetDropdown, addon.setdb:GetCurrentProfile())
end


local MogItSetName
local MogItSetID
local plugin
local plugin_index
local function BW_DressingRoomImportButton_OnClicks(outfitID, name, parent)
	MogItSetName = name
	MogItSetID = outfitID

	if outfitID >= 7000 then
		plugin = addon.TransmogOutfits
		plugin_index = outfitID
	else
		plugin = addon.MogIt
		plugin_index = MogItSetName
	end

	local contextMenuData = {
		{
			text = L["Create Copy"],
			func = function()
				plugin:CopySet(MogItSetID, MogItSetName)
				MogItSetName = nil
				MogItSetID = nil
				plugin = nil

			end,
			isNotRadio = true,
			notCheckable = true,
		},
		{
			text = L["Rename"],
			func = function()
				plugin:RenameSet(plugin_index)
				MogItSetName = nil
				MogItSetID = nil
				plugin = nil
				plugin_index = nil

			end,

			isNotRadio = true,
			notCheckable = true,
		},
		{
			text = L["Delete"],
			func = function()
				plugin:DeleteSet(plugin_index)
				MogItSetName = nil
				MogItSetID = nil
				plugin = nil
				plugin_index = nil


			end,
			isNotRadio = true,
			notCheckable = true,
		},
		
	}
	BW_UIDropDownMenu_SetAnchor(addon.ContextMenu, 0, 0, "BOTTOMLEFT", parent, "BOTTOMLEFT")
	BW_EasyMenu(contextMenuData, addon.ContextMenu, parent, 0, 0, "MENU")
end

function BetterWardrobeOutfitEditFrameMixin:ShowForOutfit_CollectionJournal(outfitID, name, parent)
	BetterWardrobeOutfitFrame:Hide()
	--Other Addon Sets
	if outfitID >=6000 then
		BW_DressingRoomImportButton_OnClicks(outfitID, name, parent)
		
	--Saved Sets
	else
		BetterWardrobeOutfitFrame:ShowPopup(self)
		self.outfitID = outfitID
		self.name = name
		self.EditBox:SetText(name)
	end
end