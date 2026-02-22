--	///////////////////////////////////////////////////////////////////////////////////////////
--
--	Blizzard API
--	Author: SLOKnightfall

--	Functions based on the Blizzard API that return the same data structure for extra sets

--	///////////////////////////////////////////////////////////////////////////////////////////

local addonName, addon = ...
---addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)


local playerInv_DB
local Profile
local playerNme
local realmName
local playerClass, classID,_
local Sets = {}
addon.Sets = Sets


--local SetsDataProvider = addon.SetsDataProvider
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local itemSlots = {
	INVTYPE_HEAD = "HEADSLOT",
	INVTYPE_SHOULDER = "SHOULDERSLOT",
	INVTYPE_CLOAK = "BACKSLOT",
	INVTYPE_CHEST = "CHESTSLOT",
	INVTYPE_ROBE = "CHESTSLOT",
	INVTYPE_TABARD = "TABARDSLOT",
	INVTYPE_BODY = "SHIRTSLOT",
	INVTYPE_WRIST = "WRISTSLOT",
	INVTYPE_HAND = "HANDSSLOT",
	INVTYPE_WAIST = "WAISTSLOT",
	INVTYPE_LEGS = "LEGSSLOT",
	INVTYPE_FEET = "FEETSLOT",
	INVTYPE_WEAPON = "MAINHANDSLOT",
	INVTYPE_RANGED = "MAINHANDSLOT",
	INVTYPE_RANGEDRIGHT = "MAINHANDSLOT",
	INVTYPE_THROWN = "MAINHANDSLOT",
	INVTYPE_SHIELD = "SECONDARYHANDSLOT",
	INVTYPE_2HWEAPON = "MAINHANDSLOT",
	INVTYPE_WEAPONMAINHAND = "MAINHANDSLOT",
	INVTYPE_WEAPONOFFHAND = "SECONDARYHANDSLOT",
	INVTYPE_HOLDABLE = "SECONDARYHANDSLOT",
}


addon.C_TransmogSets = {}

function x()
xx =addon.C_TransmogSets.GetSetInfo(60374)
end
function addon.C_TransmogSets.GetSetInfo(setID)
	local SetsData = addon.GetSetInfo(setID)

	if not SetsData then return {} end

	if SetsData.setType == "Blizzard" then
		return C_TransmogSets.GetSetInfo(setID)
	else
		return addon.GetSetInfo(setID)
	end
end

function addon.C_TransmogSets.GetBaseSetID(setID)
	local SetsData = addon.GetSetInfo(setID)

	if not SetsData then return {} end

	if SetsData.setType == "Blizzard" then
		return C_TransmogSets.GetBaseSetID(setID)

	else
		return addon.GetSetInfo(setID).baseSetID
	end
end

function addon.C_TransmogSets.GetSetPrimaryAppearances(setID)
	local SetsData = addon.GetSetInfo(setID)

	if not SetsData then return {} end

	if SetsData.setType == "Blizzard" then
		return C_TransmogSets.GetSetPrimaryAppearances(setID)
	else
		local setInfo  = addon.GetSetInfo(setID)
		local sources = {}
		for id, collected in pairs(setInfo.sources) do
			local info = {}
			info.collected = collected
			info.appearanceID = id
			tinsert(sources, info)
		end

		return sources
	end
end

function addon.C_TransmogSets.SetHasNewSources(setID)
	local SetsData = addon.GetSetInfo(setID)

	if not SetsData then return {} end
	if SetsData.setType == "Blizzard" then
		return C_TransmogSets.SetHasNewSources(setID)
	else
		local primaryID = SetsData and SetsData.baseSetID or setID
	--elseif setType == "extraset" then
		--zz = addon.GetSetInfo(primaryID)

		--return addon.GetSetInfo(primaryID)
	end
end

function addon.C_TransmogSets.GetBaseSets()
	return addon.BaseList
end

function addon.C_TransmogSets.GetVariantSets(setID)
	local SetsData = addon.GetSetInfo(setID)

	if not SetsData then return {} end
	if SetsData.setType == "Blizzard" then
		--print(setID)
		return C_TransmogSets.GetVariantSets(setID)
	else
		local primaryID = SetsData and SetsData.baseSetID or setID
		return addon.VariantSets[primaryID] or {}
	end
end

function addon.C_TransmogSets.GetFilteredBaseSetsCounts()
	local tab = addon.GetTab()
	if tab == 2 then
		return C_TransmogSets.GetFilteredBaseSetsCounts()
	else
		return addon:GetCollectedExtraSetCount()
	end
end

function addon.C_TransmogSets.GetSourcesForSlot(setID, transmogSlot, data)
	local SetsData = addon.GetSetInfo(setID)
	if not SetsData then return {} end

	if SetsData.setType == "Blizzard" then
		return C_TransmogSets.GetSourcesForSlot(setID, transmogSlot)
	else
		local primaryID = SetsData and SetsData.baseSetID or setID

		local category = C_TransmogCollection.GetCategoryForItem(data.tooltipPrimarySourceID)
		local slot = CollectionWardrobeUtil.GetSlotFromCategoryID(category);
		local transmogLocation = TransmogUtil.GetTransmogLocation(slot, Enum.TransmogType.Appearance, false);

		local sourceInfo = C_TransmogCollection.GetAppearanceSourceInfo(data.tooltipPrimarySourceID)
		local sources = CollectionWardrobeUtil.GetSortedAppearanceSources(sourceInfo.itemAppearanceID, category, transmogLocation)
		
		return sources or {}
	end
end


local function GetItemSlot(itemLinkOrID)
	local GetItemInfoInstant = C_Item and C_Item.GetItemInfoInstant
	local _, _, _, slot = GetItemInfoInstant(itemLinkOrID)
	if not slot then return end
	return itemSlots[slot]
end
addon.GetItemSlot = GetItemSlot

local function GetItemCategory(appearanceID)
	return (appearanceID and C_TransmogCollection.GetCategoryForItem(appearanceID)) or 0
end
addon.GetItemCategory = GetItemCategory

local function GetTransmogLocation(itemLinkOrID)
	return TransmogUtil.GetTransmogLocation(GetItemSlot(itemLinkOrID), Enum.TransmogType.Appearance, Enum.TransmogModification.Main)
end
addon.GetTransmogLocation = GetTransmogLocation

--CollectionWardrobeUtil.GetSortedAppearanceSources(216842)



----
function addon:SetFavoriteItem(visualID, set)
	if addon.favoritesDB.profile.item[visualID] then
		addon.favoritesDB.profile.item[visualID] = nil
	else
		addon.favoritesDB.profile.item[visualID] = true
	end

	BetterWardrobeCollectionFrame.ItemsCollectionFrame:RefreshVisualsList()
	BetterWardrobeCollectionFrame.ItemsCollectionFrame:UpdateItems()
end

function addon:IsFavoriteItem(visualID)
	return addon.favoritesDB.profile.item[visualID]
end

function Sets:ClearHidden(setList)
if addon.Profile.ShowHidden then return setList end

	local setType = "item"
	if BetterWardrobeCollectionFrame:CheckTab(2) then
		setType = "set"
	elseif BetterWardrobeCollectionFrame:CheckTab(3) then
		setType = "extraset"
	elseif BetterWardrobeCollectionFrame:CheckTab(4) then
		return setList
	end

	local newSet = {}
	for i, setInfo in pairs(setList) do
		local itemID = setInfo.setID or setInfo.visualID
		if not addon.HiddenAppearanceDB.profile[setType][itemID] then
			tinsert(newSet, setInfo)
		end
	end
	return newSet
end

local function CheckMissingLocation(setInfo)
	local filtered = false
	local missingSelection
	if 	BetterWardrobeCollectionFrame:CheckTab(2) then
	
	local invType = {}
	missingSelection = addon.Filters.Base.missingSelection
	local sources = addon.GetSetSources(setInfo.setID)
	if not sources then return end
		for sourceID in pairs(sources) do
			local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
			--local sources = sourceInfo and C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)
			local sources = sourceInfo and C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID, GetItemCategory(sourceInfo.visualID), GetTransmogLocation(sourceInfo.itemID))

			if sources then
				if #sources > 1 then
				CollectionWardrobeUtil.SortSources(sources, sources[1].visualID, sourceID)

				end
				if missingSelection[sourceInfo.invType] and not sources[1].isCollected then

					return true
				elseif missingSelection[sourceInfo.invType] then
					filtered = true
				end
			end
		end

		for type, value in pairs(missingSelection) do
			if value and invType[type] then
				filtered = true
			end
		end
	else
		local missingSelection = addon.Filters.Extra.missingSelection

		for type, value in pairs(missingSelection) do
			if value then
				filtered = true
				break
			end
		end
		--no need to filter if nothing is selected
		if not filtered then return true end
		
		local invType = {}
		if not setInfo.itemData then
			local sources = addon.GetSetSources(setInfo.setID)
			for sourceID in pairs(sources) do
				local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)

				local isCollected = Sets.isMogKnown(sourceID)
				if missingSelection[sourceInfo.invType] and not isCollected then		
					return true
				elseif missingSelection[sourceInfo.invType] then
					filtered = true
				end
			end

		else
			local setSources = addon.GetSetsources(setInfo.setID)
			for sourceID, isCollected in pairs(setSources) do
				local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
				if missingSelection[sourceInfo.invType] and not isCollected then
					return true
				elseif missingSelection[sourceInfo.invType] then
					filtered = true
				end
			end
		end

		for type, value in pairs(missingSelection) do
			if value and invType[type] then
				filtered = true
			end
		end
	end

	return not filtered
end


local function OpposingFaction(faction)
	local faction = UnitFactionGroup("player")
	if faction == "Horde" then
		return "Alliance", "Stormwind", 1 -- "Kul Tiras",
	elseif faction == "Alliance" then
		return "Horde", "Orgrimmar", 2 -- "Zandalar",
	end
end

local PvPSets = {
	["Honor"] = true,
	["Combatant"] = true,
	["Combatant I"] = true,
	["Warfront"] = true,
	["Aspirant"] = true,
	["Gladiator"] = true,
	["Elite"] = true,
}

addon.RefreshFilter = true
function addon:FilterSets(setList, setType)
	local FilterSets = {}
	local filterList = setList

	local faction = UnitFactionGroup("player")
	local opFaction = OpposingFaction(faction)
	local requiredFaction = true

	local searchString = string.lower(BetterWardrobeCollectionFrameSearchBox:GetText())
	local filterCollected = C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_COLLECTED)
	local filterUncollected = C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_UNCOLLECTED)
	local filterPVE = C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVE)
	local filterPVP = C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVP)

	local missingSelection = addon.Filters.Base.missingSelection
	local filterSelection = addon.Filters.Base.filterSelection
	local xpacSelection = addon.Filters.Base.xpacSelection

	if not filterList then
		return FilterSets
	end

	for i, data in ipairs(filterList) do
		local setData = BetterWardrobeSetsDataProviderMixin:GetSetSourceData(data.setID)
		local isPvP = data.description and PvPSets[data.description];
		local count , total = setData.numCollected, setData.numTotal
		local expansion = data.expansionID
		local sourcefilter = (BetterWardrobeCollectionFrame:CheckTab(3) and filterSelection[data.filter])
		local unavailableFilter = (not unavailable or (addon.Profile.HideUnavalableSets and unavailable))
		local tab = (BetterWardrobeCollectionFrame:CheckTab(2) and data.tab == 2) or (BetterWardrobeCollectionFrame:CheckTab(3) and data.tab == 3)
		if BetterWardrobeCollectionFrame:CheckTab(2) then
			--expansion = expansion + 1
			sourcefilter = true
			unavailableFilter = true
		end

		local searchSet = addon:SearchSets(data)

		local collected = count == total
		if ((filterCollected and collected) or (filterUncollected and not collected)) and
			((filterPVE and not isPvP) or (filterPVP and isPvP)) and
			--CheckMissingLocation(data) and
			xpacSelection[expansion] and
			sourcefilter and
			searchSet and
			tab then
			--(not unavailable or (addon.Profile.HideUnavalableSets and unavailable)) then ----and
			tinsert(FilterSets, data)
		end
	end

	return FilterSets
end


local function SearchValueFound(set, searchValue)
	local start, _ = string.find(string.lower(set.name), searchValue);
	if start ~= nil then return true; end
	
	if set.label then
		start, _ = string.find(string.lower(set.label), searchValue);
		if start ~= nil then return true; end
	end
	
	local varSets = addon.SetsDataProvider:GetVariantSets(set.baseSet);
	
	for id,varSet in pairs(varSets) do
		start, _ = string.find(string.lower(varSet.name), searchValue);
		if start ~= nil then return true; end
	end
	
	return false;
end


function addon:SearchSets(setList)
	local searchedSets = {}
	local searchString = string.lower(BetterWardrobeCollectionFrameSearchBox:GetText())
 	local atTransmogrifier = C_Transmog.IsAtTransmogNPC()

	if searchString == "" then return setList end

	if atTransmogrifier then
		setList = Sets:ClearHidden(setList)
		for i, data in ipairs(setList) do
			if (searchString and string.find(string.lower(data.name), searchString)) or (data.label and string.find(string.lower(data.label), searchString)) or (data.description and string.find(string.lower(data.description), searchString)) or (data.className and string.find(string.lower(data.className), searchString)) then
				tinsert(searchedSets, data)
			end
		end
		return searchedSets

	else
		for _, baseSet in ipairs(setList) do
			if SearchValueFound(baseSet, searchValue) then
				table.insert(addon.searchSet, baseSet);
			end
		end
		return searchedSets
	end
end
