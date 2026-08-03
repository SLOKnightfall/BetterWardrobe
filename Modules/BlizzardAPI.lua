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

function addon.C_TransmogSets.ClearLatestSource()
	C_TransmogSets.ClearLatestSource()
end

function addon.C_TransmogSets.GetSetsContainingSourceID(latestSource)
	local tab = addon.GetTab()
	if tab == 2 then
		return C_TransmogSets.GetSetsContainingSourceID(latestSource)
	else

	--todo:  extrasets	
	return 
	end
end
function addon.C_TransmogSets.SetHasNewSourcesForSlot(setID, transmogSlot)
	local tab = addon.GetTab()
	if tab == 2 then
		return C_TransmogSets.SetHasNewSourcesForSlot(setID, transmogSlot)
	else

	--todo:  extrasets	
	return false
	end
end

function addon.C_TransmogSets.GetLatestSource()
	local tab = addon.GetTab()
	if tab == 2 then
		return C_TransmogSets.GetLatestSource()
	else
	--todo:  extrasets		
	end
end

function addon.C_TransmogSets.GetCameraIDs()
	return C_TransmogSets.GetCameraIDs();
end

function addon.C_TransmogSets.GetSetNewSources(setID)

 	local tab = addon.GetTab()
	if tab == 2 then
		return C_TransmogSets.GetSetNewSources(setID)

	else
	--todo:  extrasets	
	return {}	
	end
end


function addon.C_TransmogSets.SetHasNewSources(setID)
	local SetsData = addon.GetSetInfo(setID)

	if not SetsData then return false end
	if SetsData.setType == "Blizzard" then
		return C_TransmogSets.SetHasNewSources(setID)
	else
		--TODO: extra/saved sets have no "new source" tracking table yet (this used to
		--reference an undefined global `NewVisualIDs`, which would only error once
		--the sources table below was ever populated -- left as a safe stub for now).
		return false
	end
end

function addon.C_TransmogSets.GetBaseSets()
	local tab = addon.GetTab()
	--if tab == 2 then
		--return C_TransmogSets.GetBaseSets()
	--
		return addon.BaseList
	--end


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

		local transmogLocation = TransmogUtil.GetTransmogLocation(transmogSlot, Enum.TransmogType.Appearance, false);

		local sourceInfo = data and data.tooltipPrimarySourceID and C_TransmogCollection.GetAppearanceSourceInfo(data.tooltipPrimarySourceID)
		if not sourceInfo then return {} end

		local sources = CollectionWardrobeUtil.GetSortedAppearanceSources(sourceInfo.itemAppearanceID, sourceInfo.category, transmogLocation)

		return sources or {}
	end
end


function addon.C_TransmogSets.GetUsableSets()
	return addon.fullList
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
	return TransmogUtil.GetTransmogLocation(GetItemSlot(itemLinkOrID), Enum.TransmogType.Appearance, false)
end
addon.GetTransmogLocation = GetTransmogLocation

--Returns a {appearanceID = collected} lookup table for a default Blizzard base set.
--Restored: this was deleted during the v12 refactor but is still called from
--CollectionList.lua, Tooltips.lua, and CheckMissingLocation below.
function addon.GetSetSources(setID)
	local setAppearances = C_TransmogSets.GetSetPrimaryAppearances(setID)
	if not setAppearances then
		return nil
	end

	local lookupTable = {}
	for i, appearanceInfo in ipairs(setAppearances) do
		lookupTable[appearanceInfo.appearanceID] = appearanceInfo.collected
	end
	return lookupTable
end

local SourceDB = {}
function addon.ClearSourceDB()
	wipe(SourceDB)
end

--Returns (setSources, unavailable) for extra/saved sets. setSources is a
--{sourceID = collected} lookup table. Restored and adapted to the current
--setType taxonomy ("Blizzard", "ExtraSet", "SavedExtra", "SavedBlizzard") and
--to the current single-struct return value of C_TransmogCollection.GetAppearanceSourceInfo
--(it used to be treated as multiple positional returns in older code).
function addon.C_TransmogSets.GetSetSources(setID)
	if SourceDB[setID] then return SourceDB[setID][1], SourceDB[setID][2] end

	local setInfo = addon.GetSetInfo(setID)
	local SetType = setInfo and setInfo.setType

	--Default Blizzard Set
	if not SetType or SetType == "Blizzard" then
		return addon.GetSetSources(setID)
	end

	local setSources = {}
	local unavailable = false

	--Custom outfit saved through Blizzard's own UI
	if SetType == "SavedBlizzard" then
		local setTransmogInfo = C_TransmogCollection.GetCustomSetItemTransmogInfoList(addon:GetBlizzID(setID))
		for slotID, data in ipairs(setTransmogInfo) do
			if data.appearanceID and data.appearanceID ~= 0 then
				local sourceInfo = C_TransmogCollection.GetSourceInfo(data.appearanceID)
				if sourceInfo then
					local sources = C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID, GetItemCategory(sourceInfo.visualID), GetTransmogLocation(sourceInfo.itemID))
					if sources and sources[1] then
						if #sources > 1 then
							CollectionWardrobeUtil.SortSources(sources, sources[1].visualID, data.appearanceID)
						end
						setSources[sources[1].sourceID] = sources[1].isCollected
					end
				end
			end

			if slotID == 3 and data.secondaryAppearanceID and data.secondaryAppearanceID ~= 0 then
				local sourceInfo = C_TransmogCollection.GetSourceInfo(data.secondaryAppearanceID)
				if sourceInfo then
					local sources = C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID, GetItemCategory(sourceInfo.visualID), GetTransmogLocation(sourceInfo.itemID))
					if sources and sources[1] then
						if #sources > 1 then
							CollectionWardrobeUtil.SortSources(sources, sources[1].visualID, data.secondaryAppearanceID)
						end
						setSources[sources[1].sourceID] = sources[1].isCollected
					end
				end
			end
		end

		SourceDB[setID] = {setSources, unavailable}
		return setSources, unavailable

	--ExtraSet / SavedExtra sets built from stored itemData
	else
		if setInfo.itemData then
			for slotID, sourceData in pairs(setInfo.itemData) do
				local sourceID = sourceData[2]
				local appearanceID = sourceData[3]
				if sourceID and sourceID ~= 0 then
					local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
					local sources = (appearanceID and sourceInfo) and C_TransmogCollection.GetAppearanceSources(appearanceID, GetItemCategory(appearanceID), GetTransmogLocation(sourceInfo.itemID))

					if sources and sources[1] then
						if #sources > 1 then
							CollectionWardrobeUtil.SortSources(sources, sources[1].visualID, sourceID)
						end
						setSources[sources[1].sourceID] = sources[1].isCollected
					elseif appearanceID then
						local allSources = C_TransmogCollection.GetAllAppearanceSources(appearanceID)
						local list = {}
						for _, altSourceID in ipairs(allSources) do
							local info = C_TransmogCollection.GetSourceInfo(altSourceID)
							if info then
								if not info.sourceType then
									unavailable = true
								end
								local sourceInfoData = C_TransmogCollection.GetAppearanceSourceInfo(altSourceID)
								info.isCollected = sourceInfoData and sourceInfoData.isCollected
								tinsert(list, info)
							end
						end

						if #list >= 1 then
							CollectionWardrobeUtil.SortSources(list, list[1].visualID, sourceID)
							setSources[list[1].sourceID or sourceID] = list[1].isCollected or false
							if not list[1].sourceType then
								unavailable = true
							end
						end
					end
				end
			end

			if setInfo.itemData[3] and setInfo.offShoulder then
				local sourceInfo = C_TransmogCollection.GetSourceInfo(setInfo.offShoulder)
				if sourceInfo then
					local sources = C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID, GetItemCategory(sourceInfo.visualID), GetTransmogLocation(sourceInfo.itemID))
					if sources and sources[1] then
						if #sources > 1 then
							CollectionWardrobeUtil.SortSources(sources, sources[1].visualID, setInfo.offShoulder)
						end
						setSources[sources[1].sourceID] = sources[1].isCollected
					end
				end
			end
		end

		SourceDB[setID] = {setSources, unavailable}
		return setSources, unavailable
	end
end

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

--NOTE: PvP detection used to re-check status client-side by matching
--data.description against a hardcoded 7-entry list of tier names (Honor,
--Combatant, Gladiator, etc.) -- which goes stale every PvP season as new tier
--names are introduced, silently filtering out current-season PvP sets whose
--description didn't happen to match. Now uses data.isPvP, stamped onto each
--set in BuildBlizzSets() (Data/DataBase.lua) via the isPVP() ID-lookup against
--the curated PVP_SETID list -- an ID check, not a description-string guess.

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
	local isHidden = false

	if not filterList then
		return FilterSets
	end

	for i, data in ipairs(filterList) do
		local setData = addon.SetsDataProvider:GetSetSourceData(data.setID)
		local isPvP = data.isPvP;
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

		local setType
		if data.setType == "Blizzard" then
			setType = "set"
		elseif data.setType == "ExtraSet" then
			setType = "extraset"
		end

		local isHidden = false

		if setType then 

			isHidden = (addon.Profile.ShowHidden and false) or ( not addon.Profile.ShowHidden and addon.HiddenAppearanceDB.profile[setType][data.setID])
		end

		local collected = count == total
		if ((filterCollected and collected) or (filterUncollected and not collected)) and
			((filterPVE and not isPvP) or (filterPVP and isPvP)) and
			--CheckMissingLocation(data) and
			xpacSelection[expansion] and
			sourcefilter and
			searchSet and
			not isHidden and
			tab then
			--(not unavailable or (addon.Profile.HideUnavalableSets and unavailable)) then ----and
			tinsert(FilterSets, data)
		end
	end

	return FilterSets
end

--NOTE: addon:SearchSets used to be defined here too, but it was dead code --
--every real call site uses addon:SearchSets(data), a boolean search predicate
--defined in Modules/TransmogTemplates.lua (which loads after this file and was
--therefore always the version actually in effect). Removed to avoid two
--same-named functions with different signatures/behavior living in the codebase.
