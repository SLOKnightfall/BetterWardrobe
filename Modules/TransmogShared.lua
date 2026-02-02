local addonName, addon = ...;
---addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0");
addon = LibStub("AceAddon-3.0"):GetAddon(addonName);

StaticPopupDialogs["TRANSMOG_FAVORITE_WARNING"] = {
	text = TRANSMOG_FAVORITE_LOSE_REFUND_AND_TRADE,
	button1 = OKAY,
	button2 = CANCEL,
	OnAccept = function(_dialog, data)
		local setFavorite = true;
		local confirmed = true;
		TransmogUtil.ToggleFavorite(data.visualID, setFavorite, data.itemsCollectionFrame, confirmed);
	end,
	timeout = 0,
	hideOnEscape = 1
};

TransmogSlotOrder = {
	INVSLOT_HEAD,
	INVSLOT_SHOULDER,
	INVSLOT_BACK,
	INVSLOT_CHEST,
	INVSLOT_BODY,
	INVSLOT_TABARD,
	INVSLOT_WRIST,
	INVSLOT_HAND,
	INVSLOT_WAIST,
	INVSLOT_LEGS,
	INVSLOT_FEET,
	INVSLOT_MAINHAND,
	INVSLOT_OFFHAND,
};

local WARDROBE_MODEL_SETUP = {
	["HEADSLOT"] 		= { useTransmogSkin = false, useTransmogChoices = false, obeyHideInTransmogFlag = false, slots = { CHESTSLOT = true,  HANDSSLOT = false, LEGSSLOT = false, FEETSLOT = false, HEADSLOT = false } },
	["SHOULDERSLOT"]	= { useTransmogSkin = true,  useTransmogChoices = true,  obeyHideInTransmogFlag = true,  slots = { CHESTSLOT = false, HANDSSLOT = false, LEGSSLOT = false, FEETSLOT = false, HEADSLOT = true  } },
	["BACKSLOT"]		= { useTransmogSkin = true,  useTransmogChoices = true,  obeyHideInTransmogFlag = true,  slots = { CHESTSLOT = false, HANDSSLOT = false, LEGSSLOT = false, FEETSLOT = false, HEADSLOT = true  } },
	["CHESTSLOT"]		= { useTransmogSkin = true,  useTransmogChoices = true,  obeyHideInTransmogFlag = true,  slots = { CHESTSLOT = false, HANDSSLOT = false, LEGSSLOT = false, FEETSLOT = false, HEADSLOT = true  } },
	["TABARDSLOT"]		= { useTransmogSkin = true,  useTransmogChoices = true,  obeyHideInTransmogFlag = true,  slots = { CHESTSLOT = false, HANDSSLOT = false, LEGSSLOT = false, FEETSLOT = false, HEADSLOT = true  } },
	["SHIRTSLOT"]		= { useTransmogSkin = true,  useTransmogChoices = true,  obeyHideInTransmogFlag = true,  slots = { CHESTSLOT = false, HANDSSLOT = false, LEGSSLOT = false, FEETSLOT = false, HEADSLOT = true  } },
	["WRISTSLOT"]		= { useTransmogSkin = true,  useTransmogChoices = true,  obeyHideInTransmogFlag = true,  slots = { CHESTSLOT = false, HANDSSLOT = false, LEGSSLOT = false, FEETSLOT = false, HEADSLOT = true  } },
	["HANDSSLOT"]		= { useTransmogSkin = false, useTransmogChoices = true,  obeyHideInTransmogFlag = true,  slots = { CHESTSLOT = true,  HANDSSLOT = false, LEGSSLOT = true,  FEETSLOT = true,  HEADSLOT = true  } },
	["WAISTSLOT"]		= { useTransmogSkin = true,  useTransmogChoices = true,  obeyHideInTransmogFlag = true,  slots = { CHESTSLOT = false, HANDSSLOT = false, LEGSSLOT = false, FEETSLOT = false, HEADSLOT = true  } },
	["LEGSSLOT"]		= { useTransmogSkin = true,  useTransmogChoices = true,  obeyHideInTransmogFlag = true,  slots = { CHESTSLOT = false, HANDSSLOT = false, LEGSSLOT = false, FEETSLOT = false, HEADSLOT = true  } },
	["FEETSLOT"]		= { useTransmogSkin = false, useTransmogChoices = true,  obeyHideInTransmogFlag = true,  slots = { CHESTSLOT = true,  HANDSSLOT = true,  LEGSSLOT = true,  FEETSLOT = false, HEADSLOT = true  } }
}

local WARDROBE_MODEL_SETUP_GEAR = {
	["CHESTSLOT"] = 78420,
	["LEGSSLOT"] = 78425,
	["FEETSLOT"] = 78427,
	["HANDSSLOT"] = 78426,
	["HEADSLOT"] = 78416
}



local NUM_CUSTOM_SET_SLASH_COMMAND_VALUES = 17;

-- Custom set slash command sample:
-- /customset v1 7019,7017,0,0,7022,0,0,7015,7020,7016,7018,7021,70216,0,0,0,0
-- "v1" is the version so future formats won't break older slash commands
-- The comma-separated values are as follows:
-- 		Head		- appearanceID
--		Shoulder	- appearanceID
--		Shoulder	- secondaryAppearanceID (0 if shoulders aren't split)
-- 		Back		- appearanceID
--		Chest		- appearanceID
--		Body		- appearanceID
--		Tabard		- appearanceID
--		Wrist		- appearanceID
--		Hand		- appearanceID
--		Waist		- appearanceID
--		Legs		- appearanceID
--		Feet		- appearanceID
--		MainHand	- appearanceID
--		MainHand	- secondaryAppearanceID (0 if the weapon is from Legion Artifacts category, -1 otherwise)
--		MainHand	- illusionID
--		OffHand		- appearanceID
--		OffHand		- illusionID


local WardrobeSetsDataProviderMixin = {};
BetterWardrobeSetsDataProviderMixin = WardrobeSetsDataProviderMixin
addon.SetsDataProvider = BetterWardrobeSetsDataProviderMixin
function WardrobeSetsDataProviderMixin:SortSets(sets, reverseUIOrder, ignorePatchID)
	local comparison = function(set1, set2)
		local groupFavorite1 = set1.favoriteSetID and true;
		local groupFavorite2 = set2.favoriteSetID and true;
		if ( groupFavorite1 ~= groupFavorite2 ) then
			return groupFavorite1;
		end
		if ( set1.favorite ~= set2.favorite ) then
			return set1.favorite;
		end
		if ( set1.expansionID ~= set2.expansionID ) then
			return set1.expansionID > set2.expansionID;
		end
		if not ignorePatchID then
			if ( set1.patchID ~= set2.patchID ) then
				return set1.patchID > set2.patchID;
			end
		end
		if ( set1.uiOrder ~= set2.uiOrder ) then
			if ( reverseUIOrder ) then
				return set1.uiOrder < set2.uiOrder;
			else
				return set1.uiOrder > set2.uiOrder;
			end
		end
		if reverseUIOrder then
			return set1.setID < set2.setID;
		else
			return set1.setID > set2.setID;
		end
	end

	table.sort(sets, comparison);
end

function WardrobeSetsDataProviderMixin:GetBaseSets()
	if not self.baseSets then
		local baseSets = addon.BaseList
		self.baseSets = baseSets --C_TransmogSets.GetBaseSets();
		self:DetermineFavorites();

		local reverseUIOrder = false;
		local ignorePatchID = false;
		local ignoreCollected = true;
		self:SortSets(self.baseSets, reverseUIOrder, ignorePatchID, ignoreCollected);
	end
	return self.baseSets;
end

function WardrobeSetsDataProviderMixin:GetBaseSetByID(baseSetID)
	local baseSets = self:GetBaseSets();
	for index, baseSet in ipairs(baseSets) do
		if baseSet.setID == baseSetID then
			return baseSet, index;
		end
	end
	return nil, nil;
end

-- Usable sets are sets that the player can use that are completed.
function WardrobeSetsDataProviderMixin:GetUsableSets()
	if not self.usableSets then
		self.usableSets = C_TransmogSets.GetUsableSets();

		local reverseUIOrder = false;
		local ignorePatchID = false;
		local ignoreCollected = true;
		self:SortSets(self.usableSets, reverseUIOrder, ignorePatchID, ignoreCollected);

		-- Group sets by baseSetID, except for favorited sets since those are to remain bucketed to the front.
		for index, usableSet in ipairs(self.usableSets) do
			if not usableSet.favorite then
				local baseSetID = usableSet.baseSetID or usableSet.setID;
				local numRelatedSets = 0;
				for indexSecondary = index + 1, #self.usableSets do
					if self.usableSets[indexSecondary].baseSetID == baseSetID or self.usableSets[indexSecondary].setID == baseSetID then
						numRelatedSets = numRelatedSets + 1;
						-- No need to do anything if already contiguous
						if indexSecondary ~= index + numRelatedSets then
							local relatedSet = self.usableSets[indexSecondary];
							tremove(self.usableSets, indexSecondary);
							tinsert(self.usableSets, index + numRelatedSets, relatedSet);
						end
					end
				end
			end
		end
	end
	return self.usableSets;
end

-- Available sets are sets that the player can use that have at least 1 slot unlocked.
function WardrobeSetsDataProviderMixin:GetAvailableSets()
	if not self.availableSets then
		self.availableSets = C_TransmogSets.GetAvailableSets();

		local reverseUIOrder = false;
		local ignorePatchID = false;
		local ignoreCollected = false;
		self:SortSets(self.availableSets, reverseUIOrder, ignorePatchID, ignoreCollected);
	end
	return self.availableSets;
end

-- Variant sets are all of the different versions (recolors, etc.) of a base set.
function WardrobeSetsDataProviderMixin:GetVariantSets(baseSetID)
	if not self.variantSets then
		self.variantSets = {};
	end

	local variantSets = self.variantSets[baseSetID];
	if not variantSets then
		variantSets = C_TransmogSets.GetVariantSets(baseSetID) or {};
		self.variantSets[baseSetID] = variantSets;
		if #variantSets > 0 then
			-- Add base to variants and sort.
			local baseSet = self:GetBaseSetByID(baseSetID);
			if baseSet then
				tinsert(variantSets, baseSet);
			end
			local reverseUIOrder = true;
			local ignorePatchID = true;
			local ignoreCollected = true;
			self:SortSets(variantSets, reverseUIOrder, ignorePatchID, ignoreCollected);
		end
	end
	return variantSets;
end

function WardrobeSetsDataProviderMixin:GetSetSourceData(setID)
	if not self.sourceData then
		self.sourceData = {};
	end

	local sourceData = self.sourceData[setID];
	if not sourceData then
		local primaryAppearances = C_TransmogSets.GetSetPrimaryAppearances(setID) or {};
		local numCollected = 0;
		local numTotal = 0;
		for _index, primaryAppearance in ipairs(primaryAppearances) do
			if primaryAppearance.collected then
				numCollected = numCollected + 1;
			end
			numTotal = numTotal + 1;
		end
		sourceData = { numCollected = numCollected, numTotal = numTotal, primaryAppearances = primaryAppearances };
		self.sourceData[setID] = sourceData;
	end
	return sourceData;
end

function WardrobeSetsDataProviderMixin:GetSetSourceCounts(setID)
	local sourceData = self:GetSetSourceData(setID);
	return sourceData.numCollected, sourceData.numTotal;
end

function WardrobeSetsDataProviderMixin:GetBaseSetData(setID)
	if not self.baseSetsData then
		self.baseSetsData = {};
	end

	if not self.baseSetsData[setID] then
		local baseSetID = C_TransmogSets.GetBaseSetID(setID);
		if baseSetID ~= setID then
			return;
		end

		local topCollected, topTotal = self:GetSetSourceCounts(setID);
		local variantSets = self:GetVariantSets(setID);
		for _index, varientSet in ipairs(variantSets) do
			local numCollected, numTotal = self:GetSetSourceCounts(varientSet.setID);
			if numCollected > topCollected then
				topCollected = numCollected;
				topTotal = numTotal;
			end
		end
		local setInfo = { topCollected = topCollected, topTotal = topTotal, completed = (topCollected == topTotal) };
		self.baseSetsData[setID] = setInfo;
	end
	return self.baseSetsData[setID];
end

function WardrobeSetsDataProviderMixin:GetSetSourceTopCounts(setID)
	local baseSetData = self:GetBaseSetData(setID);
	if baseSetData then
		return baseSetData.topCollected, baseSetData.topTotal;
	else
		return self:GetSetSourceCounts(setID);
	end
end

function WardrobeSetsDataProviderMixin:IsBaseSetNew(baseSetID)
	local baseSetData = self:GetBaseSetData(baseSetID)
	if not baseSetData then
		return false;
	end

	if not baseSetData.newStatus then
		local newStatus = C_TransmogSets.SetHasNewSources(baseSetID);
		if not newStatus then
			-- Check variants
			local variantSets = self:GetVariantSets(baseSetID);
			for _index, variantSet in ipairs(variantSets) do
				if C_TransmogSets.SetHasNewSources(variantSet.setID) then
					newStatus = true;
					break;
				end
			end
		end
		baseSetData.newStatus = newStatus;
	end
	return baseSetData.newStatus;
end

function WardrobeSetsDataProviderMixin:ResetBaseSetNewStatus(baseSetID)
	local baseSetData = self:GetBaseSetData(baseSetID)
	if baseSetData then
		baseSetData.newStatus = nil;
	end
end

function WardrobeSetsDataProviderMixin:GetSortedSetSources(setID)
	local returnTable = {};
	local sourceData = self:GetSetSourceData(setID);
	for _index, primaryAppearance in ipairs(sourceData.primaryAppearances) do
		local sourceID = primaryAppearance.appearanceID;
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID);
		if sourceInfo then
			local sortOrder = EJ_GetInvTypeSortOrder(sourceInfo.invType);
			tinsert(returnTable, { sourceID = sourceID, collected = primaryAppearance.collected, sortOrder = sortOrder, itemID = sourceInfo.itemID, invType = sourceInfo.invType });
		end
	end

	local comparison = function(entry1, entry2)
		if entry1.sortOrder == entry2.sortOrder then
			return entry1.itemID < entry2.itemID;
		else
			return entry1.sortOrder < entry2.sortOrder;
		end
	end
	table.sort(returnTable, comparison);
	return returnTable;
end

function WardrobeSetsDataProviderMixin:ClearSets()
	self.baseSets = nil;
	self.baseSetsData = nil;
	self.variantSets = nil;
	self.usableSets = nil;
	self.availableSets = nil;
	self.sourceData = nil;
end

function WardrobeSetsDataProviderMixin:ClearBaseSets()
	self.baseSets = nil;
end

function WardrobeSetsDataProviderMixin:ClearVariantSets()
	self.variantSets = nil;
end

function WardrobeSetsDataProviderMixin:ClearUsableSets()
	self.usableSets = nil;
end

function WardrobeSetsDataProviderMixin:ClearAvailableSets()
	self.availableSets = nil;
end

function WardrobeSetsDataProviderMixin:GetIconForSet(setID)
	local sourceData = self:GetSetSourceData(setID);
	if not sourceData.icon then
		local sortedSources = self:GetSortedSetSources(setID);
		if sortedSources[1] then
			local _itemID, _itemType, _itemSubType, _itemEquipLoc, icon = C_Item.GetItemInfoInstant(sortedSources[1].itemID);
			sourceData.icon = icon;
		else
			sourceData.icon = QUESTION_MARK_ICON;
		end
	end
	return sourceData.icon;
end

function WardrobeSetsDataProviderMixin:DetermineFavorites()
	-- If a variant is favorited, so is the base set.
	-- Keep track of which set is favorited.
	local baseSets = self:GetBaseSets();
	for _indexBaseSet, baseSet in ipairs(baseSets) do
		baseSet.favoriteSetID = nil;
		if baseSet.favorite then
			baseSet.favoriteSetID = baseSet.setID;
		else
			local variantSets = self:GetVariantSets(baseSet.setID);
			for _indexVariantSet, variantSet in ipairs(variantSets) do
				if variantSet.favorite then
					baseSet.favoriteSetID = variantSet.setID;
					break;
				end
			end
		end
	end
end

function WardrobeSetsDataProviderMixin:RefreshFavorites()
	self.baseSets = nil;
	self.variantSets = nil;
	self:DetermineFavorites();
end
