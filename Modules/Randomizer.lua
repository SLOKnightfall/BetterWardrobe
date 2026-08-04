local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local IgnoredSlots = {}
local AppearanceList

BW_RandomizeButtonMixin = {}

function BW_RandomizeButtonMixin:OnEnter()
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 0)
	GameTooltip:SetOwner(self, "ANCHOR_PRESERVE")
	GameTooltip:SetText(L["Click: Randomize Items"].."\n"..L["Shift Click: Randomize Outfit"])
end


function BW_RandomizeButtonMixin:OnLeave()
	GameTooltip:Hide()
end


function BW_RandomizeButtonMixin:OnMouseDown()
	if IsModifierKeyDown() then
		self:Randomize("outfit")
	else
		self:BuildAppearanceList()
		self:Randomize()
	end
end


local finalselection = {}

local function ApplyAppearance(slot, transmogType, weaponOption, sourceID)
	local displayType = Enum.TransmogOutfitDisplayType.Assigned
	if C_TransmogCollection.IsAppearanceHiddenVisual(sourceID) then
		displayType = Enum.TransmogOutfitDisplayType.Hidden
	end
	C_TransmogOutfitInfo.SetPendingTransmog(slot, transmogType, weaponOption, sourceID, displayType)
end

--Updates the model after all items has been selected so model and pending looks match
local function finalUpdate()
	for slotID, selection in pairs(finalselection)do
		ApplyAppearance(selection.slot, selection.transmogType, selection.weaponOption, selection.sourceID)
		finalselection[slotID] = nil
	end
end


function BW_RandomizeButtonMixin:OnMouseUp()
	self.Stop = true
	
	C_Timer.After(1.8, function() finalUpdate() end)
end


local function AddSlotAppearances(slotID, categoryID, transmogLocation)

	if not categoryID or not transmogLocation then return end
	for _, appearance in ipairs(C_TransmogCollection.GetCategoryAppearances(categoryID, transmogLocation)) do
		if appearance.isUsable and appearance.isCollected then
			tinsert(AppearanceList[slotID].visuals, appearance.visualID)
		end
	end
end


--Weapon slots don't have a single fixed category like armor slots do, and transmog only allows
--appearances compatible with the handedness of whatever's actually equipped there -- "enabled" in
--GetWeaponOptionsForSlot just means the class/spec CAN use that handedness at all, not that it
--matches the equipped weapon, so picking the first enabled one can pick an incompatible option and
--silently yield zero valid appearances. Use the option matching what's actually equipped instead.
local function GetDefaultWeaponOption(slot)
	local equippedOption = C_TransmogOutfitInfo.GetEquippedSlotOptionFromTransmogSlot(slot)
	if equippedOption then return equippedOption end

	local weaponOptions, artifactOptions = C_TransmogOutfitInfo.GetWeaponOptionsForSlot(slot)
	for _, optionInfo in ipairs(weaponOptions or {}) do
		if optionInfo.enabled then return optionInfo.weaponOption end
	end
	for _, optionInfo in ipairs(artifactOptions or {}) do
		if optionInfo.enabled then return optionInfo.weaponOption end
	end
	return Enum.TransmogOutfitSlotOption.None
end


local function AddWeaponSlotAppearances(slotID, transmogLocation, slot, weaponOption)
	for weaponCategoryID = FIRST_TRANSMOG_COLLECTION_WEAPON_TYPE, LAST_TRANSMOG_COLLECTION_WEAPON_TYPE do
		local collectionInfo = C_TransmogOutfitInfo.GetCollectionInfoForSlotAndOption(slot, weaponOption, weaponCategoryID)
		if collectionInfo and collectionInfo.isWeapon then
			AddSlotAppearances(slotID, weaponCategoryID, transmogLocation)
		end
	end
end


local update = false
function BW_RandomizeButtonMixin:BuildAppearanceList()
	if not update and AppearanceList then return end

	AppearanceList = (AppearanceList and wipe(AppearanceList)) or {}
	for _, slotInfo in pairs(TRANSMOG_SLOTS) do
		local transmogLocation = slotInfo.location

		--Illusions and secondary (offhand-shoulder) slots are toggled separately and aren't part of base randomization.
		if transmogLocation:IsAppearance() and not transmogLocation:IsSecondary() then
			local slot = transmogLocation:GetSlot()
			local slotID = transmogLocation:GetSlotID()
			local transmogType = transmogLocation:GetType()
			local isWeaponSlot = C_TransmogOutfitInfo.IsSlotWeaponSlot(slot)
			local weaponOption = isWeaponSlot and GetDefaultWeaponOption(slot) or Enum.TransmogOutfitSlotOption.None

			if isWeaponSlot then
				--GetViewedOutfitSlotInfo/GetCollectionInfoForSlotAndOption key off the slot's currently
				--viewed weapon option, not just whatever's passed in below -- the weapon-option dropdown
				--in TransmogTemplates.lua sets this via the same call before querying either of those.
				C_TransmogOutfitInfo.SetViewedWeaponOptionForSlot(slot, weaponOption)
			end

			local outfitSlotInfo = C_TransmogOutfitInfo.GetViewedOutfitSlotInfo(slot, transmogType, weaponOption)
			if outfitSlotInfo and outfitSlotInfo.canTransmogrify then
				AppearanceList[slotID] = { transmogLocation = transmogLocation, slot = slot, transmogType = transmogType, weaponOption = weaponOption, visuals = {} }

				if isWeaponSlot then
					AddWeaponSlotAppearances(slotID, transmogLocation, slot, weaponOption)
				else
					AddSlotAppearances(slotID, slotInfo.armorCategoryID, transmogLocation)
				end
			end
		end
	end
end


local function RandomizeBySlot(slotID)
	local slotData = AppearanceList[slotID]
	if not slotData or #slotData.visuals == 0 then return end

	local visualID = slotData.visuals[random(#slotData.visuals)]
	local categoryID = addon.GetItemCategory(visualID)
	local sourceList = C_TransmogCollection.GetAppearanceSources(visualID, categoryID, slotData.transmogLocation)
	if not sourceList then return end

	for _, source in pairs(sourceList) do
		if source.isCollected then
			ApplyAppearance(slotData.slot, slotData.transmogType, slotData.weaponOption, source.sourceID)
			finalselection[slotID] = { slot = slotData.slot, transmogType = slotData.transmogType, weaponOption = slotData.weaponOption, sourceID = source.sourceID }
			break
		end
	end
end


local function RandomizeAllSlots()
	for slotID, _ in pairs(AppearanceList) do
		if not IgnoredSlots[slotID] then
			RandomizeBySlot(slotID)
		end
	end
end


local function RandomizeOutfit()
	local outfits = addon.GetOutfits()
	if not outfits or #outfits == 0 then return end

	local outfit = outfits[random(#outfits)]
	if outfit.setType == "SavedBlizzard" then
		C_TransmogOutfitInfo.SetOutfitToCustomSet(addon:GetBlizzID(outfit.outfitID))
	elseif outfit.setType == "SavedExtra" then
		addon.SavedSetsFrame:ApplyOutfit(outfit.index)
	end
end


local throttleValue = 0.1
local currentThrottle = throttleValue
local totalTime = 0
local function RandomizeOnUpdate(self, elapsed)
	totalTime = totalTime + elapsed
	if totalTime >= throttleValue then
		self.RunRandom(self.Slot)
		if self.Stop then
			currentThrottle = currentThrottle * 1.5
			if currentThrottle >= 0.5 then
				self:SetScript('OnUpdate', nil)
			end
		end
		
		totalTime = 0
	end
end

function BW_RandomizeButtonMixin:Randomize(type)
	totalTime = 0
	currentThrottle = throttleValue
	self.Stop = false
	self:SetScript('OnUpdate', RandomizeOnUpdate)

	if type == "item" then
			self.Slot = slotID
			RandomizeBySlot(slotID)
			self.RunRandom = RandomizeBySlot(slotID)

	elseif type == "outfit" then
			RandomizeOutfit()
			self.RunRandom = RandomizeOutfit
	else
		RandomizeAllSlots()
		self.RunRandom = RandomizeAllSlots
	end
end