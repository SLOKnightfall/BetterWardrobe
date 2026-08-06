local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local IgnoredSlots = {}
local AppearanceList

--Moved from SavedOutfitsViewer.lua (now disabled) -- still needed for RandomizeOutfit below.
local function UpdateOutfit(slot, type, appearance)
	if not appearance then return end
	local info = C_TransmogCollection.GetSourceInfo(appearance)
	local categoryID = (info and info.categoryID) or 0
	local display = (info and  info.isHideVisual and 3) or (info and  not info.isHideVisual and 1) or (not info and 0)
	local option = 0

	if slot == Enum.TransmogOutfitSlot.WeaponMainHand or slot == Enum.TransmogOutfitSlot.WeaponOffHand then
		local spec = GetSpecializationInfo(GetSpecialization())

		if (categoryID >= 12 and categoryID <= 17 ) or  categoryID == 28 then
			option = Enum.TransmogOutfitSlotOption.OneHandedWeapon
		elseif categoryID == 18 then
			option = Enum.TransmogOutfitSlotOption.Shield
		elseif categoryID == 19 then
			option = Enum.TransmogOutfitSlotOption.OffHand
		elseif categoryID >= 20 and categoryID <= 24  then
			if spec == 72 then
				option = Enum.TransmogOutfitSlotOption.FuryTwoHandedWeapon
			end
			option = Enum.TransmogOutfitSlotOption.TwoHandedWeapon
		elseif categoryID >= 25 and categoryID <= 27  then
			option = Enum.TransmogOutfitSlotOption.RangedWeapon
		end
	end

	C_TransmogOutfitInfo.SetPendingTransmog(slot, type, option, appearance, display)
end

local function ApplyOutfit(index)
	local outfit = addon.OutfitDB.char.outfits[index]
	if outfit ~= nil then
		C_TransmogOutfitInfo.ClearAllPendingTransmogs()
		UpdateOutfit(Enum.TransmogOutfitSlot.Head, Enum.TransmogType.Appearance, outfit[1])
		UpdateOutfit(Enum.TransmogOutfitSlot.ShoulderRight, Enum.TransmogType.Appearance, outfit[3])
		UpdateOutfit(Enum.TransmogOutfitSlot.Body, Enum.TransmogType.Appearance, outfit[4])
		UpdateOutfit(Enum.TransmogOutfitSlot.Chest, Enum.TransmogType.Appearance, outfit[5])
		UpdateOutfit(Enum.TransmogOutfitSlot.Waist, Enum.TransmogType.Appearance, outfit[6])
		UpdateOutfit(Enum.TransmogOutfitSlot.Legs, Enum.TransmogType.Appearance, outfit[7])
		UpdateOutfit(Enum.TransmogOutfitSlot.Feet, Enum.TransmogType.Appearance, outfit[8])
		UpdateOutfit(Enum.TransmogOutfitSlot.Wrist, Enum.TransmogType.Appearance, outfit[9])
		UpdateOutfit(Enum.TransmogOutfitSlot.Hand ,Enum.TransmogType.Appearance, outfit[10])
		UpdateOutfit(Enum.TransmogOutfitSlot.Back, Enum.TransmogType.Appearance, outfit[15])
		UpdateOutfit(Enum.TransmogOutfitSlot.WeaponMainHand, Enum.TransmogType.Appearance, outfit[16])
		UpdateOutfit(Enum.TransmogOutfitSlot.WeaponOffHand, Enum.TransmogType.Appearance, outfit[17])
		UpdateOutfit(Enum.TransmogOutfitSlot.Tabard, Enum.TransmogType.Appearance, outfit[19])
		UpdateOutfit(Enum.TransmogOutfitSlot.WeaponMainHand, Enum.TransmogType.Illusion, outfit["mainHandEnchant"])
		UpdateOutfit(Enum.TransmogOutfitSlot.WeaponOffHand, Enum.TransmogType.Illusion, outfit["offHandEnchant"])
	end
end

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


--"Enabled" in GetWeaponOptionsForSlot means the class/spec CAN use that handedness, not that it matches what's equipped -- use the equipped option instead.
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
				--GetViewedOutfitSlotInfo/GetCollectionInfoForSlotAndOption key off the slot's viewed weapon option, set here.
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
		ApplyOutfit(outfit.index)
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