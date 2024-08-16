local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)


local MAX_DEFAULT_OUTFITS = C_TransmogCollection.GetNumMaxOutfits()

--Coresponds to wardrobeOutfits



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
		BetterWardrobeOutfitManager:NameOutfit(self.editBox:GetText(), self.data)
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
	OnAccept = function (self) BetterWardrobeOutfitManager:DeleteOutfit(self.data) end,
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
		if (BetterWardrobeOutfitManager.name) then
			self.button1:SetText(SAVE)
		else
			self.button1:SetText(CONTINUE)
		end
	end,
	OnAccept = function(self)
		BetterWardrobeOutfitManager:ContinueWithSave()
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
		BetterWardrobeOutfitManager:DeleteOutfit(overwriteID)
		overwriteID = nil
		BetterWardrobeOutfitManager:NewOutfit(self.data)
		--BetterWardrobeOutfitManager:SaveOutfit(self.data)
		--if DressUpFrame:IsShown() then --todo fix
			--BW_DressingRoomOutfitFrameMixin:SaveOutfit(self.data)
		--else
			--BetterWardrobeOutfitManager:NewOutfit(self.data)
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

BetterWardrobeOutfitDropdownMixin = { }

function BetterWardrobeOutfitDropdownMixin:OnLoad()
	WowStyle1DropdownMixin.OnLoad(self);
	self:SetWidth(self.width or 200);
	self:SetDefaultText(GRAY_FONT_COLOR:WrapTextInColorCode(TRANSMOG_OUTFIT_NONE));

	self.SaveButton:SetScript("OnClick", function()	
		BetterWardrobeOutfitManager:StartOutfitSave(self, self:GetSelectedOutfitID());
	end);
end

function BetterWardrobeOutfitDropdownMixin:SetSelectedOutfitID(outfitID)
	self.selectedOutfitID = outfitID;
end

function BetterWardrobeOutfitDropdownMixin:GetSelectedOutfitID()
	return self.selectedOutfitID;
end

function BetterWardrobeOutfitDropdownMixin:OnShow()
	self:RegisterEvent("TRANSMOG_OUTFITS_CHANGED");
	self:RegisterEvent("TRANSMOGRIFY_UPDATE");

	self:SelectOutfit(self:GetLastOutfitID());
	self:InitOutfitDropdown();
end

function BetterWardrobeOutfitDropdownMixin:SelectOutfit(outfitID)
	if not outfitID then return end;
	self:SetSelectedOutfitID(outfitID);
	self:LoadOutfit(outfitID);
	self:UpdateSaveButton();

	self.selectedOutfitID = outfitID;
	if BetterWardrobeCollectionFrame then 
		BetterWardrobeCollectionFrame.SetsTransmogFrame.selectedSetID = outfitID;
	end
end

function BetterWardrobeOutfitDropdownMixin:OnHide()
	self:UnregisterEvent("TRANSMOG_OUTFITS_CHANGED");
	self:UnregisterEvent("TRANSMOGRIFY_UPDATE");
	BetterWardrobeOutfitManager:ClosePopups(self);
end

function BetterWardrobeOutfitDropdownMixin:OnEvent(event)
	if event == "TRANSMOG_OUTFITS_CHANGED" then
		-- Outfits may have been deleted, or their names changed, so we need to
		-- rebuild the menu state.
		self:GenerateMenu();
		self:UpdateSaveButton();
	elseif event == "TRANSMOGRIFY_UPDATE" then
		self:UpdateSaveButton();
	end
end

function BetterWardrobeOutfitDropdownMixin:UpdateSaveButton()
	if self:GetSelectedOutfitID() then
		self.SaveButton:SetEnabled(not self:IsOutfitDressed());
	else
		self.SaveButton:SetEnabled(false);
	end
end

function BetterWardrobeOutfitDropdownMixin:OnOutfitSaved(outfitID)
	if self:ShouldReplaceInvalidSources() then
		self:LoadOutfit(outfitID);
	end
end

function BetterWardrobeOutfitDropdownMixin:OnOutfitModified(outfitID)
	if self:ShouldReplaceInvalidSources() then
		self:LoadOutfit(outfitID);
	end
end

function BetterWardrobeOutfitDropdownMixin:InitOutfitDropdown()
	local function IsOutfitSelected(outfitID)
		return self:GetSelectedOutfitID() == outfitID;
	end
	
	local function SetOutfitSelected(outfitID)
		self:SelectOutfit(outfitID);
	end

	self:SetupMenu(function(dropdown, rootDescription)
		rootDescription:SetTag("MENU_WARDROBE_OUTFITS");

		local extent = 20;
		local maxCharacters = 8;
		local maxScrollExtent = extent * maxCharacters;
		rootDescription:SetScrollMode(maxScrollExtent);

		local text = GREEN_FONT_COLOR:WrapTextInColorCode(TRANSMOG_OUTFIT_NEW);
		local button = rootDescription:CreateButton(text, function()
			if WardrobeTransmogFrame and HelpTip:IsShowing(WardrobeTransmogFrame, TRANSMOG_OUTFIT_DROPDOWN_TUTORIAL) then
				HelpTip:Hide(WardrobeTransmogFrame, TRANSMOG_OUTFIT_DROPDOWN_TUTORIAL);
				SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_TRANSMOG_OUTFIT_DROPDOWN, true);
			end
			BetterWardrobeOutfitManager:StartOutfitSave(self);
		end);

		button:AddInitializer(function(button, description, menu)
			local texture = button:AttachTexture();
			texture:SetSize(19,19);
			texture:SetPoint("LEFT");
			texture:SetTexture([[Interface\PaperDollInfoFrame\Character-Plus]]);

			local fontString = button.fontString;
			fontString:SetPoint("LEFT", texture, "RIGHT", 3, 0);
		end);

		local outfits = addon.GetOutfits(true)
		for i = 1, #outfits do
			local outfit = outfits[i]

			local name = NORMAL_FONT_COLOR_CODE..outfits[i].name..FONT_COLOR_CODE_CLOSE
			local icon = outfit.icon;
			local text = NORMAL_FONT_COLOR:WrapTextInColorCode(outfits[i].name);

			local radio = rootDescription:CreateButton(text, SetOutfitSelected, outfit.outfitID);
			radio:SetIsSelected(IsOutfitSelected);
			radio:AddInitializer(function(button, description, menu)
				local texture = button:AttachTexture();
				texture:SetSize(19,19);
				texture:SetPoint("LEFT");
				texture:SetTexture(icon);

				local fontString = button.fontString;
				fontString:SetPoint("LEFT", texture, "RIGHT", 3, 0);

				if outfit.outfitID == self:GetSelectedOutfitID() then
					local fontString2 = button:AttachFontString();
					fontString2:SetPoint("LEFT", button.fontString, "RIGHT");
					fontString2:SetHeight(16);

					local size = 20;
					fontString2:SetTextToFit(CreateSimpleTextureMarkup([[Interface\Buttons\UI-CheckBox-Check]], size, size));
				end

				local gearButton = MenuTemplates.AttachAutoHideGearButton(button);
				gearButton:SetPoint("RIGHT");

				MenuUtil.HookTooltipScripts(gearButton, function(tooltip)
					GameTooltip_SetTitle(tooltip, TRANSMOG_OUTFIT_EDIT);
				end);

				gearButton:SetScript("OnClick", function()
					BetterWardrobeOutfitEditFrame:ShowForOutfit(outfit.outfitID)
					menu:Close();
				end);
			end);
		end


	end);
end

function BetterWardrobeOutfitDropdownMixin:NewOutfit(outfitID)
	self:SetSelectedOutfitID(outfitID);
	self:InitOutfitDropdown();
	self:UpdateSaveButton();

	self:OnOutfitSaved(outfitID);
end

function BetterWardrobeOutfitDropdownMixin:GetLastOutfitID()
	-- Expected to return nil for the dropdown in DressUpModelFrame. See WardrobeOutfitMixin:GetLastOutfitID()
	-- for the regular implementation.
	return nil;
end

local function IsSourceArtifact(sourceID)
	local link = select(6, C_TransmogCollection.GetAppearanceSourceInfo(sourceID));
	if not link then
		return false;
	end
	local _, _, quality = GetItemInfo(link);
	return quality == Enum.ItemQuality.Artifact;
end

local function isHiddenAppearance(appearanceID, set_appearanceID, slotID)
	if set_appearanceID == 0 then return true end;
	local sourceInfo = C_TransmogCollection.GetSourceInfo(set_appearanceID);

	if sourceInfo then
		local isCollected = sourceInfo.isCollected;

		local isemptyslot = (appearanceID == 0);
		if not isCollected and isemptyslot then
			return true;
		end
	end
	return false;
end

function BetterWardrobeOutfitDropdownMixin:IsOutfitDressed()
	if not self.selectedOutfitID or self.selectedOutfitID == "" then
		return true
	end

	--if addon.GetSetType(self.selectedOutfitID) == "SavedBlizzard" then 
	if self.selectedOutfitID >= 5000 and self.selectedOutfitID <= 5020 then 
		local selectedOutfitID = addon:GetBlizzID(self.selectedOutfitID);
		local outfitItemTransmogInfoList = C_TransmogCollection.GetOutfitItemTransmogInfoList(selectedOutfitID);
		if not outfitItemTransmogInfoList then
			return true
		end

		local currentItemTransmogInfoList = self:GetItemTransmogInfoList();
		if not currentItemTransmogInfoList then
			return true;
		end

		for slotID, itemTransmogInfo in ipairs(currentItemTransmogInfoList) do
			if not itemTransmogInfo:IsEqual(outfitItemTransmogInfoList[slotID]) then
				if itemTransmogInfo.appearanceID ~= Constants.Transmog.NoTransmogID then
					return false;
				end
			end
		end
		return true;

	else
		local outfit = addon.GetSetInfo(self.selectedOutfitID); --addon.OutfitDB.char.outfits[LookupIndexFromID(self.selectedOutfitID)]
		if not outfit then
			return true;
		end

		local outfitItemTransmogInfoList = addon.C_TransmogCollection.GetOutfitItemTransmogInfoList(self.selectedOutfitID);
		local currentItemTransmogInfoList = self:GetItemTransmogInfoList();
		if not currentItemTransmogInfoList then
			return true;
		end

		for slotID, itemTransmogInfo in ipairs(currentItemTransmogInfoList) do
			if not itemTransmogInfo:IsEqual(outfitItemTransmogInfoList[slotID]) then
				if itemTransmogInfo.appearanceID ~= Constants.Transmog.NoTransmogID or outfitItemTransmogInfoList[slotID].appearanceID ~= Constants.Transmog.NoTransmogID then
					if not isHiddenAppearance(itemTransmogInfo.appearanceID, outfitItemTransmogInfoList[slotID].appearanceID, slotID) then
						return false;
					end
				end
				
			end
		end

		return true
	end
end

function BetterWardrobeOutfitDropdownMixin:IsDefaultSet(outfitID)
		return addon.IsDefaultSet(outfitID);
end

function BetterWardrobeOutfitDropdownMixin:ShouldReplaceInvalidSources()
	return self.replaceInvalidSources;
end

--===================================================================================================================================
BetterWardrobeOutfitManager = { }

BetterWardrobeOutfitManager.popups = {
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

local OUTFIT_FRAME_MIN_STRING_WIDTH = 152;
local OUTFIT_FRAME_MAX_STRING_WIDTH = 216;
local OUTFIT_FRAME_ADDED_PIXELS = 90;	-- pixels added to string width

function BetterWardrobeOutfitManager:NewOutfit(name)
	local outfitID = LookupOutfitIDFromName(name); --or  ((#C_TransmogCollection.GetOutfits() <= MAX_DEFAULT_OUTFITS) and #C_TransmogCollection.GetOutfits() -1 ) -- or #GetOutfits()-1
	local icon = QUESTION_MARK_ICON;
	local outfit;

	for slotID, itemTransmogInfo in ipairs(self.itemTransmogInfoList) do
		local appearanceID = itemTransmogInfo.appearanceID;
		if appearanceID ~= Constants.Transmog.NoTransmogID then
			icon = select(4, C_TransmogCollection.GetAppearanceSourceInfo(appearanceID));
			if icon then
				break;
			end
		end
	end

	--[[local sources = {}
			for i, data in pairs(self.itemTransmogInfoList) do
				sources[i] = data.appearanceID
			end]]

	if (outfitID and IsDefaultSet(outfitID)) or (#C_TransmogCollection.GetOutfits() < MAX_DEFAULT_OUTFITS)  then 
		outfitID = C_TransmogCollection.NewOutfit(name, icon, self.itemTransmogInfoList);
	else
		if outfitID then 
			addon.OutfitDB.char.outfits[LookupIndexFromID(outfitID)]  = addon.OutfitDB.char.outfits[LookupIndexFromID(outfitID)] or {};
			outfit = addon.OutfitDB.char.outfits[LookupIndexFromID(outfitID)];
		else
			tinsert(addon.OutfitDB.char.outfits, {});
			outfit = addon.OutfitDB.char.outfits[#addon.OutfitDB.char.outfits];
		end
		outfit["name"] = name;
		----local icon = select(4, C_TransmogCollection.GetAppearanceSourceInfo(outfit[1]))
		outfit["icon"] = icon;
		--outfit.itemData = itemData

		local itemData = {};
		for i, data in pairs(self.itemTransmogInfoList) do
			outfit[i] = data.appearanceID;
			if i == 3 then
				outfit["offShoulder"] = data.secondaryAppearanceID or 0;
			elseif i == 16 then 
				outfit["mainHandEnchant"] = data.illusionID or 0;
			elseif i == 17 then 
				outfit["offHandEnchant"] = data.illusionID or 0;
			end
		end

		--outfit.sources = sources
		--outfit.itemTransmogInfoList =  self.itemTransmogInfoList or {}
		--outfitID = index
	end
	if outfitID then
		self:SaveLastOutfit(outfitID);
	end
	if ( self.dropdown ) then
		self.dropdown:NewOutfit(outfitID);
	end

	--addon.setdb.global.sets[addon.setdb:GetCurrentProfile()] = addon.GetSavedList()
	addon.setdb.global.sets[addon.setdb:GetCurrentProfile()] = addon.StoreBlizzardSets();
	addon.GetSavedList()
end

function BetterWardrobeOutfitManager:DeleteOutfit(outfitID)
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
	addon.setdb.global.sets[addon.setdb:GetCurrentProfile()] = addon.StoreBlizzardSets();

	addon:SendMessage("BW_TRANSMOG_COLLECTION_UPDATED");
end

function BetterWardrobeOutfitManager:NameOutfit(newName, outfitID)
	local outfits = addon.GetOutfits(true);
	for i = 1, #outfits do
		if (outfits[i].name == newName) then
			if (outfitID) then
				UIErrorsFrame:AddMessage(TRANSMOG_OUTFIT_ALREADY_EXISTS, 1.0, 0.1, 0.1, 1.0);
			else
				overwriteID = outfits[i].outfitID;
				BetterWardrobeOutfitManager:ShowPopup("BW_CONFIRM_OVERWRITE_TRANSMOG_OUTFIT", newName, nil, newName);
			end
			return
		end
	end

	if outfitID and IsDefaultSet(outfitID) then
		local blizzardID = addon:GetBlizzID(outfitID);
	-- this is a rename
		C_TransmogCollection.RenameOutfit(blizzardID, newName);
	elseif outfitID then 
		local index = LookupIndexFromID(outfitID);
		addon.OutfitDB.char.outfits[index].name = newName;
	else
		-- this is a new outfit
		self:NewOutfit(newName);
	end
end

function BetterWardrobeOutfitManager:ShowPopup(popup, ...)
	-- close all other popups
	for _, listPopup in pairs(self.popups) do
		if ( listPopup ~= popup ) then
			StaticPopup_Hide(listPopup);
		end
	end
	if ( popup ~= BetterWardrobeOutfitEditFrame ) then
		StaticPopupSpecial_Hide(BetterWardrobeOutfitEditFrame);
	end

	if ( popup == BetterWardrobeOutfitEditFrame ) then
		StaticPopupSpecial_Show(BetterWardrobeOutfitEditFrame);
	else
		StaticPopup_Show(popup, ...);
	end
end

function BetterWardrobeOutfitManager:ClosePopups(requestingDropDown)
	if ( requestingDropDown and requestingDropDown ~= self.popupDropdown ) then
		return;
	end
	for _, popup in pairs(self.popups) do
		StaticPopup_Hide(popup);
	end
	StaticPopupSpecial_Hide(BetterWardrobeOutfitEditFrame)

	-- clean up
	self.itemTransmogInfoList = nil;
	self.hasAnyPendingAppearances = nil;
	self.hasAnyValidAppearances = nil;
	self.hasAnyInvalidAppearances = nil;
	self.outfitID = nil;
	self.dropdown = nil;
	self.name = nil;
	self.sources = nil;
end


function BetterWardrobeOutfitManager:StartOutfitSave(popupDropDown, outfitID)
	self.dropdown = popupDropDown;
	self.outfitID = outfitID;
	self:EvaluateAppearances();
end


function BetterWardrobeOutfitManager:EvaluateAppearance(appearanceID, category, transmogLocation)
	local preferredAppearanceID, hasAllData, canCollect;
	if self.dropdown:ShouldReplaceInvalidSources() then
		preferredAppearanceID, hasAllData, canCollect = CollectionWardrobeUtil.GetPreferredSourceID(appearanceID, nil, category, transmogLocation);
	else
		preferredAppearanceID = appearanceID;
		hasAllData, canCollect = C_TransmogCollection.PlayerCanCollectSource(appearanceID);
	end

	if canCollect then
		self.hasAnyValidAppearances = true;
	else
		if hasAllData then
			self.hasAnyInvalidAppearances = true;
		else
			self.hasAnyPendingAppearances = true;
		end
	end
	local isInvalidAppearance = hasAllData and not canCollect;
	return preferredAppearanceID, isInvalidAppearance;
end

function BetterWardrobeOutfitManager:EvaluateAppearances()
	self.hasAnyInvalidAppearances = false;
	self.hasAnyValidAppearances = false;
	self.hasAnyPendingAppearances = false;
	self.itemTransmogInfoList = self.dropdown:GetItemTransmogInfoList();
	-- all illusions are collectible
	for slotID, itemTransmogInfo in ipairs(self.itemTransmogInfoList) do
		local isValidAppearance = false;
		if TransmogUtil.IsValidTransmogSlotID(slotID) then
			local appearanceID = itemTransmogInfo.appearanceID;
			isValidAppearance = appearanceID ~= Constants.Transmog.NoTransmogID;
			-- skip offhand if mainhand is an appeance from Legion Artifacts category and the offhand matches the paired appearance
			if isValidAppearance and slotID == INVSLOT_OFFHAND then
				local mhInfo = self.itemTransmogInfoList[INVSLOT_MAINHAND];
				if mhInfo:IsMainHandPairedWeapon() then
					isValidAppearance = appearanceID ~= C_TransmogCollection.GetPairedArtifactAppearance(mhInfo.appearanceID);
				end
			end
			if isValidAppearance then
				local transmogLocation = TransmogUtil.CreateTransmogLocation(slotID, Enum.TransmogType.Appearance, Enum.TransmogModification.Main);
				local category = C_TransmogCollection.GetCategoryForItem(appearanceID);
				local preferredAppearanceID, isInvalidAppearance = self:EvaluateAppearance(appearanceID, category, transmogLocation);
				if isInvalidAppearance then
					isValidAppearance = false;
				else
					itemTransmogInfo.appearanceID = preferredAppearanceID;
				end
				-- secondary check
				if itemTransmogInfo.secondaryAppearanceID ~= Constants.Transmog.NoTransmogID and C_Transmog.CanHaveSecondaryAppearanceForSlotID(slotID) then
					local secondaryTransmogLocation = TransmogUtil.CreateTransmogLocation(slotID, Enum.TransmogType.Appearance, Enum.TransmogModification.Secondary);
					local secondaryCategory = C_TransmogCollection.GetCategoryForItem(itemTransmogInfo.secondaryAppearanceID);
					local secondaryPreferredAppearanceID, secondaryIsInvalidAppearance = self:EvaluateAppearance(itemTransmogInfo.secondaryAppearanceID, secondaryCategory, secondaryTransmogLocation);
					if secondaryIsInvalidAppearance then
						-- secondary is invalid, clear it
						itemTransmogInfo.secondaryAppearanceID = Constants.Transmog.NoTransmogID;
					else
						if isInvalidAppearance then
							-- secondary is valid but primary is invalid, make the secondary the primary
							isValidAppearance = true;
							itemTransmogInfo.appearanceID = secondaryPreferredAppearanceID;
							itemTransmogInfo.secondaryAppearanceID = Constants.Transmog.NoTransmogID;
						else
							-- both primary and secondary are valid
							itemTransmogInfo.secondaryAppearanceID = secondaryPreferredAppearanceID;
						end
					end
				end
			end
		end
		if not isValidAppearance then
			itemTransmogInfo:Clear();
		end
	end
	
	self:EvaluateSaveState();
end

function BetterWardrobeOutfitManager:EvaluateSaveState()
	--if self.hasAnyPendingAppearances then
		-- wait
		--if ( not StaticPopup_Visible("TRANSMOG_OUTFIT_CHECKING_APPEARANCES") ) then
			--BetterWardrobeOutfitManager:ShowPopup("TRANSMOG_OUTFIT_CHECKING_APPEARANCES", nil, nil, nil, WardrobeOutfitCheckAppearancesFrame);
			--print(1)
		--end
	--else
		StaticPopup_Hide("TRANSMOG_OUTFIT_CHECKING_APPEARANCES");
		if not self.hasAnyValidAppearances then
			-- stop
			BetterWardrobeOutfitManager:ShowPopup("TRANSMOG_OUTFIT_ALL_INVALID_APPEARANCES");
		elseif self.hasAnyInvalidAppearances then
			-- warn
			BetterWardrobeOutfitManager:ShowPopup("TRANSMOG_OUTFIT_SOME_INVALID_APPEARANCES");
		else
			BetterWardrobeOutfitManager:ContinueWithSave();
		end
	--end
end

function BetterWardrobeOutfitManager:ContinueWithSave()
	if self.outfitID and IsDefaultSet(self.outfitID) then
	-- this is a rename
		C_TransmogCollection.ModifyOutfit(addon:GetBlizzID(self.outfitID), self.itemTransmogInfoList)
		self:SaveLastOutfit(self.outfitID);
		if ( self.dropdown ) then
			self.dropdown:OnOutfitModified(self.outfitID);
		end
		BetterWardrobeOutfitManager:ClosePopups()
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
			BetterWardrobeOutfitManager:ClosePopups()
			addon.GetSavedList()

	else
		-- this is a new outfit
		BetterWardrobeOutfitFrame:ShowPopup("BW_NAME_TRANSMOG_OUTFIT")
	end
end

function BetterWardrobeOutfitManager:SaveLastOutfit(outfitID)
	local value = outfitID or "";
	local currentSpecIndex = GetCVarBool("transmogCurrentSpecOnly") and GetSpecialization() or nil;
	for specIndex = 1, GetNumSpecializations() do
		if not currentSpecIndex or specIndex == currentSpecIndex then
			SetCVar("lastTransmogOutfitIDSpec"..specIndex, value);
		end
	end
end

function BetterWardrobeOutfitManager:OverwriteOutfit(outfitID)
	self.outfitID = outfitID;
	self:ContinueWithSave();
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

function BetterWardrobeOutfitCheckAppearancesMixin:OnShow()
	LoadingSpinnerMixin.OnShow(self);
	self:RegisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE");
	self:RegisterEvent("TRANSMOG_SOURCE_COLLECTABILITY_UPDATE")
end

function BetterWardrobeOutfitCheckAppearancesMixin:OnHide()
	self:UnregisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE");
	self:UnregisterEvent("TRANSMOG_SOURCE_COLLECTABILITY_UPDATE")
	self.reevaluate = nil;
end

function BetterWardrobeOutfitCheckAppearancesMixin:OnEvent(event, appearanceID, canCollect)
	self.reevaluate = true;
end

function BetterWardrobeOutfitCheckAppearancesMixin:OnUpdate()
	if self.reevaluate then
		self.reevaluate = nil;
		BetterWardrobeOutfitManager:EvaluateAppearances();
	end
end

