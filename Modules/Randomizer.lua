local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local IgnoredSlots = {}
local AppearanceList


function BW_RandomizeButton:OnEnter()
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 0)
	GameTooltip:SetOwner(self, "ANCHOR_PRESERVE")
	GameTooltip:SetText(L["Click: Randomize Items"].."\n"..L["Shift Click:Randomize Outfit"])
end


local function AddSlotAppearances(slotID, categoryID)
	for _, appearance in ipairs(C_TransmogCollection.GetCategoryAppearances(categoryID)) do
		if appearance.isUsable and appearance.isCollected then
			tinsert(AppearanceList[slotID], appearance.visualID)
		end
	end
end


local update = false
function BW_RandomizeButton:BuildAppearanceList()
	if not update and AppearanceList then return end

	AppearanceList = (AppearanceList and wipe(AppearanceList)) or {}
	for i, slotInfo in pairs(TRANSMOG_SLOTS) do
		local slot = slotInfo.slotID
		local slotID = slotInfo.location:GetSlotID()

		local transmogLocation = TransmogUtil.GetTransmogLocation(slotID, Enum.TransmogType.Appearance, Enum.TransmogModification.None);

		AppearanceList[slotID] = AppearanceList[slotID] or {}

		local _, _, _, canTransmogrify, cannotTransmogrifyReason, _ = C_Transmog.GetSlotInfo(transmogLocation)
		if canTransmogrify or cannotTransmogrifyReason == 0 then
			local sourceID = C_Transmog.GetSlotVisualInfo(transmogLocation)
			local categoryID = slotInfo.armorCategoryID or C_TransmogCollection.GetAppearanceSourceInfo(sourceID)
			AddSlotAppearances(slotID, categoryID)

			for weaponCategoryID = FIRST_TRANSMOG_COLLECTION_WEAPON_TYPE, LAST_TRANSMOG_COLLECTION_WEAPON_TYPE do
				local name, isWeapon, _, canMainHand, canOffHand = C_TransmogCollection.GetCategoryInfo(weaponCategoryID)
				if name and isWeapon and weaponCategoryID ~= categoryID then
					if (slotInfo.location:IsMainHand() and canMainHand) or (slotInfo.location:IsOffHand() and canOffHand) then  --todo either hand
						local equippedItemID = GetInventoryItemID('player', GetInventorySlotInfo(slotInfo.location:GetSlotName()))
						if C_TransmogCollection.IsCategoryValidForItem(weaponCategoryID, equippedItemID) then
							AddSlotAppearances(slotID, weaponCategoryID)
						end
					end
				end
			end
		end
	end
end


local function RandomizeBySlot(slotID)
	local slotVisualList = AppearanceList[slotID]
	if not slotVisualList then return end

	local visualCount = #slotVisualList
	if visualCount > 0 then
		local appearanceID = slotVisualList[random(visualCount)]
		local sourceList = appearanceID and C_TransmogCollection.GetAppearanceSources(appearanceID)
		if sourceList then
			for _, source in pairs(sourceList) do
				if source.isCollected then

					local transmogLocation = TransmogUtil.GetTransmogLocation(slotID, Enum.TransmogType.Appearance, Enum.TransmogModification.None);
					C_Transmog.SetPending(transmogLocation, source.sourceID, Enum.TransmogType.Appearance)
					break
				end
			end
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
	local outfits, currentOutfit = addon.GetOutfits() --C_TransmogCollection.GetOutfits()
	local numOutfits = #outfits
	local randomOutfitID = outfits[random(numOutfits)].outfitID

	BW_WardrobeOutfitDropDown:SelectOutfit(randomOutfitID, true)
	--WardrobeOutfitDropDown:SelectOutfit(randomOutfitID, true)
end


local DEFAULT_THROTTLE = 0.1
local SpinThrottle = DEFAULT_THROTTLE
local totalTime = 0
local function RandomizeOnUpdate(self, elapsed)
	totalTime = totalTime + elapsed
	if totalTime >= SpinThrottle then
		self.RunRandom(self.Slot)
		if self.Stop then
			SpinThrottle = SpinThrottle * 1.3
			if SpinThrottle >= 0.3 then
				self:SetScript('OnUpdate', nil)
			end
		end
		
		totalTime = 0
	end
end


function BW_RandomizeButton:Randomize(type)
	totalTime = 0
	SpinThrottle = DEFAULT_THROTTLE
	self.Stop = false
	if type == "outfit" then
			RandomizeOutfit()
			self.RunRandom = RandomizeOutfit
	elseif type == "item" then
			self.Slot = slotID
			RandomizeBySlot(slotID)
			self.RunRandom = RandomizeBySlot(slotID)
	else
		RandomizeAllSlots()
		self.RunRandom = RandomizeAllSlots
	end

	self:SetScript('OnUpdate', RandomizeOnUpdate)
end