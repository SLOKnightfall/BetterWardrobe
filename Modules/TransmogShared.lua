local addonName, addon = ...;
---addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0");
addon = LibStub("AceAddon-3.0"):GetAddon(addonName);

local Blizz_C_TransmogSets = C_TransmogSets
--Anything not overridden below falls through to real Blizzard C_TransmogSets via __index, instead of resolving to nil.
local C_TransmogSets = setmetatable({}, {__index = Blizz_C_TransmogSets})
C_TransmogSets.GetSetPrimaryAppearances = addon.C_TransmogSets.GetSetPrimaryAppearances
C_TransmogSets.GetBaseSetID = addon.C_TransmogSets.GetBaseSetID
C_TransmogSets.SetHasNewSources = addon.C_TransmogSets.SetHasNewSources
C_TransmogSets.GetVariantSets = addon.C_TransmogSets.GetVariantSets
C_TransmogSets.GetBaseSets = addon.C_TransmogSets.GetBaseSets
C_TransmogSets.GetUsableSets = addon.C_TransmogSets.GetUsableSets
C_TransmogSets.GetSetInfo = addon.C_TransmogSets.GetSetInfo

StaticPopupDialogs["TRANSMOG_FAVORITE_WARNING2"] = {
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

local TransmogSlotOrder = {
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
local function ReverseComparator(comparator, reverse)
	if not reverse then return comparator end
	return function(a, b) return comparator(b, a) end
end

local SETS_SORT_COMPARATORS = {
	Alphabetic = function(set1, set2)
		return (set1.name or "") < (set2.name or "");
	end,
	Expansion = function(set1, set2)
		if set1.expansionID ~= set2.expansionID then
			return set1.expansionID > set2.expansionID;
		end
		return (set1.name or "") < (set2.name or "");
	end,
};

function WardrobeSetsDataProviderMixin:SortSets(sets, reverseUIOrder, ignorePatchID, ignoreCollected, ignoreSortMode)
	--Variant lists (GetVariantSets, e.g. raid difficulty dropdowns) need a fixed LFR/Normal/Heroic/
	--Mythic-style order via uiOrder regardless of the user's chosen sort mode for the main list.
	local comparator = not ignoreSortMode and SETS_SORT_COMPARATORS[addon.Profile.SetSortMode];

	if not ignoreSortMode and addon.Profile.SetSortMode == "CollectedCount" then
		--GetSetSourceCounts recomputes from the API every call (its own cache is disabled in
		--GetSetSourceData), so snapshot it once instead of re-querying it inside table.sort's
		--comparator, which table.sort calls many times and needs a stable answer from.
		local percentCollected, totalCounts = {}, {};
		for _, set in ipairs(sets) do
			--Query the row's own setID directly first -- GetBaseSets() already normalized it to the
			--right representative (base or complete variant); resolving via GetBaseSetID here too
			--is redundant and, for some sets (e.g. Heritage Armor), resolves to the wrong entity.
			local bestCollected, bestTotal = self:GetSetSourceCounts(set.setID);
			local bestPercent = (bestTotal > 0) and (bestCollected / bestTotal) or 0;

			--Use whichever sibling variant has the best completion, not just a fully-complete one --
			--a 4/6 variant shouldn't sort with 0-collected sets just because it isn't 6/6 yet. Uses
			--the raw Blizzard API directly (not self:GetVariantSets, which calls back into SortSets
			--for its own sorting and would recurse forever from in here).
			local baseSetID = C_TransmogSets.GetBaseSetID(set.setID) or set.setID;
			local variants = Blizz_C_TransmogSets.GetVariantSets(baseSetID);
			if not variants or #variants == 0 then
				variants = addon.VariantSets[baseSetID] or {};
			end
			for _, variant in ipairs(variants) do
				if variant.setID ~= set.setID then
					local numCollected, numTotal = self:GetSetSourceCounts(variant.setID);
					local percent = (numTotal > 0) and (numCollected / numTotal) or 0;
					if percent > bestPercent then
						bestCollected, bestTotal, bestPercent = numCollected, numTotal, percent;
					end
				end
			end

			totalCounts[set.setID] = bestTotal;
			percentCollected[set.setID] = bestPercent;
		end
		comparator = function(set1, set2)
			--Percentage first so complete sets (100%) never land among incomplete ones; set size breaks ties.
			local percent1 = percentCollected[set1.setID];
			local percent2 = percentCollected[set2.setID];
			if percent1 ~= percent2 then
				return percent1 > percent2;
			end
			local total1 = totalCounts[set1.setID];
			local total2 = totalCounts[set2.setID];
			if total1 ~= total2 then
				return total1 > total2;
			end
			return (set1.name or "") < (set2.name or "");
		end
	end

	local reversibleCompare = ReverseComparator(comparator or function(set1, set2)
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
	end, not ignoreSortMode and addon.Profile.SetSortReverse);

	--Favorite-first stays outside the reversible comparator so Reverse never buries favorites.
	local function comparison(set1, set2)
		local groupFavorite1 = set1.favoriteSetID and true;
		local groupFavorite2 = set2.favoriteSetID and true;
		if ( groupFavorite1 ~= groupFavorite2 ) then
			return groupFavorite1;
		end
		if ( set1.favorite ~= set2.favorite ) then
			return set1.favorite;
		end
		return reversibleCompare(set1, set2);
	end

	table.sort(sets, comparison);
end

function WardrobeSetsDataProviderMixin:GetBaseSets()
	local filteredSets = {}

	if BetterWardrobeCollectionFrame:CheckTab(4) then
		self.baseSavedSets = addon.GetSavedList()
		addon.SortDropdown(self.baseSavedSets)

		return self.baseSavedSets;
	end

	if not self.baseSets then
		local baseSets = addon.BaseList
		self.baseSets = C_TransmogSets.GetBaseSets();
		self.baseSets = addon:FilterSets(baseSets)
		self:DetermineFavorites();

		--Blizzard's own (unmodified) C_TransmogSets.GetBaseSets() already picks the right
		--representative set per group -- e.g. a complete variant over an incomplete base --
		--so borrow that choice instead of reimplementing "which variant wins" ourselves.
		local representativeByBase = {};
		for _, nativeSet in ipairs(Blizz_C_TransmogSets.GetBaseSets()) do
			representativeByBase[Blizz_C_TransmogSets.GetBaseSetID(nativeSet.setID) or nativeSet.setID] = nativeSet.setID;
		end
		for _, data in ipairs(self.baseSets) do
			local trueBaseID = Blizz_C_TransmogSets.GetBaseSetID(data.setID) or data.setID;
			local representativeID = representativeByBase[trueBaseID];
			if representativeID and representativeID ~= data.setID then
				local representativeInfo = Blizz_C_TransmogSets.GetSetInfo(representativeID);
				if representativeInfo then
					for k, v in pairs(representativeInfo) do
						data[k] = v;
					end
					data.baseSetID = trueBaseID;
				end
			end
		end

		local tabFilter = {}
		local tab = addon.GetTab()
		for i, data in ipairs(self.baseSets) do
			if data.tab == tab then
				tinsert(tabFilter, data)
			end
		end
		self.baseSets = tabFilter

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
		if baseSet.baseSetID == baseSetID then

			return baseSet, index;
		end
	end
	return nil, nil;
end

-- Usable sets are sets that the player can use that are completed.
function WardrobeSetsDataProviderMixin:GetUsableSets()
	local setIDS = {}
	local Profile = addon.Profile;

	if BetterWardrobeCollectionFrame:CheckTab(4) then
		if ( not self.usableSavedSets ) then
			self.usableSavedSets = addon.GetSavedList()
			self:SortSets(self.usableSavedSets)
		end
		
		return self.usableSavedSets;
	end

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

	if BetterWardrobeCollectionFrame:CheckTab(2) then
		--Normalize to Blizzard's canonical base ID first -- our own label-grouped "base" isn't always the same set, and GetVariantSets needs the real one.
		baseSetID = C_TransmogSets.GetBaseSetID(baseSetID) or baseSetID;
		local variantSets = self.variantSets[baseSetID];
		if not variantSets then
			variantSets = C_TransmogSets.GetVariantSets(baseSetID) or {};

			if #variantSets > 0 then
				-- Add base to variants and sort.
				local baseSet = C_TransmogSets.GetSetInfo(baseSetID);
				if baseSet then
					tinsert(variantSets, baseSet);
				end
			else
				--Blizzard's native GetVariantSets is empty/incomplete for some sets (e.g. past-season
				--PvP Elite recolors), even when our own label-based grouping (Data/DataBase.lua) folded
				--a set in as a variant of this base. Fall back to that grouping so it stays reachable.
				local ownVariants = addon.VariantSets[baseSetID];
				if ownVariants and #ownVariants > 1 then
					for i = 1, #ownVariants do
						tinsert(variantSets, ownVariants[i]);
					end
				end
			end

			if #variantSets > 0 then
				local reverseUIOrder = true;
				local ignorePatchID = true;
				local ignoreCollected = true;
				local ignoreSortMode = true;
				self:SortSets(variantSets, reverseUIOrder, ignorePatchID, ignoreCollected, ignoreSortMode);
			end

			self.variantSets[baseSetID] = variantSets;
		end
		return variantSets or {};
	else
		local variantSets = self.variantSets[baseSetID];
		if ( not variantSets ) then

			local variantSetsAll = addon.VariantSets[addon.VariantIDs[baseSetID]];
			if not variantSetsAll then
				variantSetsAll = {};
			end

			--Must assign the outer variantSets, not shadow it with a new local -- that left the first (cache-populating) call always returning nil.
			variantSets = {};
			for i=1, #variantSetsAll do
				tinsert(variantSets, variantSetsAll[i]);
			end

			local reverseUIOrder = true;
			local ignorePatchID = true;

			addon.SortVariantSet(variantSets, reverseUIOrder, ignorePatchID);
			self.variantSets[baseSetID] = variantSets;
		end

		return variantSets or {};
	end
end

function WardrobeSetsDataProviderMixin:GetSetSourceData(setID)
	if not self.sourceData then
		self.sourceData = {};
	end

	local sourceData = self.sourceData[setID];
	--if not sourceData then
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
	--end
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
	sourceData.primaryAppearances = sourceData.primaryAppearances or sourceData.sources

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
