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

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

--Determines type of set based on setID
local function DetermineSetType(setID)

	if WardrobeCollectionFrame:CheckTab(2) then --- or setID > 1000000 then 
	--Blizzard Set


		return "set"

	--Extra Set
	elseif WardrobeCollectionFrame:CheckTab(3) then 
		return "extraSet"
	elseif WardrobeCollectionFrame:CheckTab(4) then 
	--Mogit set
	--Saved Set
	return "savedset"

	end
end
addon.DetermineSetType = DetermineSetType


addon.C_TransmogSets = {}

--C_TransmogSets.GetSetPrimaryAppearances(setID);
--[[	Name = "GetSetPrimaryAppearances",
			Type = "Function",

			Arguments =
			{
				{ Name = "transmogSetID", Type = "number", Nilable = false },
			},

			Returns =
			{
				{ Name = "apppearances", Type = "table", InnerType = "TransmogSetPrimaryAppearanceInfo", Nilable = false },
			},

			Name = "TransmogSetPrimaryAppearanceInfo",
			Type = "Structure",
			Fields =
			{
				{ Name = "appearanceID", Type = "number", Nilable = false },
				{ Name = "collected", Type = "bool", Nilable = false },
			},]]

function addon.C_TransmogSets.GetSetPrimaryAppearances(setID)
	local setType = DetermineSetType(setID)

	if setType == "set" then
		return C_TransmogSets.GetSetPrimaryAppearances(setID)

	else
	--elseif setType == "extraset" then
		local setSources = addon.GetSetsources(setID)
		local primaryAppearances = {}
		for appearanceID, collected in pairs(setSources) do
		--	print(appearanceID)
			local data = {["appearanceID"] = appearanceID, ["collected"] = collected}
			tinsert(primaryAppearances, data)
		end

		return primaryAppearances
	end
end


function addon.C_TransmogSets.GetSetInfo(setID)
	local setType = DetermineSetType(setID)

	if setType == "set" then
		return C_TransmogSets.GetSetInfo(setID);

else
	--elseif setType == "extraset" then
		return addon.GetSetInfo(setID)


	end
end


function addon.C_TransmogSets.SetIsFavorite(setID, value)
end

function addon.C_TransmogSets.SetHasNewSources(setID)
	local setType = DetermineSetType(setID)

	if setType == "set" then
		return C_TransmogSets.SetHasNewSources(setID);

	elseif setType == "extraset" then
		if newTransmogInfo and newTransmogInfo[setID] then
			return true 
		else
			return false
		end
	else
	end
end


function addon:SetHasNewSources(setID)
	if newTransmogInfo and newTransmogInfo[setID] then
		return true 
	else
		return false
	end
end


function addon.C_TransmogSets.GetBaseSetID(setID)
	local setType = DetermineSetType(setID)
	if setType == "set" then
		return C_TransmogSets.GetBaseSetID(setID)

	elseif setType == "extraset" then
		return setID 
	else
		return setID 
	end
end


function addon:SetFavoriteItem(visualID, set)
	if addon.favoritesDB.profile.item[visualID] then
		addon.favoritesDB.profile.item[visualID] = nil
	else
		addon.favoritesDB.profile.item[visualID] = true
	end

	WardrobeCollectionFrame.ItemsCollectionFrame:RefreshVisualsList()
	WardrobeCollectionFrame.ItemsCollectionFrame:UpdateItems()
end


function addon:IsFavoriteItem(visualID)
	return addon.favoritesDB.profile.item[visualID]
end



function Sets:ClearHidden(setList)
if addon.Profile.ShowHidden then return setList end

	local setType = "item"
	if WardrobeCollectionFrame:CheckTab(2) then
		setType = "set"
	elseif WardrobeCollectionFrame:CheckTab(3) then
		setType = "extraset"
	elseif WardrobeCollectionFrame:CheckTab(4) then 
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
	if 	WardrobeCollectionFrame:CheckTab(2) then
	
	local invType = {}
	missingSelection = addon.Filters.Base.missingSelection
	local sources = C_TransmogSets.GetSetSources(setInfo.setID)
	if not sources then return end
		for sourceID in pairs(sources) do
			local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
			local sources = sourceInfo and C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)
			if sources then
				if #sources > 1 then
					WardrobeCollectionFrame_SortSources(sources)
				end
				if  missingSelection[sourceInfo.invType] and not sources[1].isCollected then

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
	 missingSelection = addon.Filters.Extra.missingSelection

	for type, value in pairs(missingSelection) do
		if value then
			filtered = true
			break
		end
	end
	--no need to filter if nothing is selected
	if not filtered then return true end
	
	local invType = {}
	if not setInfo.items then
		local sources = C_TransmogSets.GetSetSources(setInfo.setID)
		for sourceID in pairs(sources) do
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

addon.RefreshFilter = true
function addon:FilterSets(setList, setType)
	if 	C_Transmog.IsAtTransmogNPC() then return setList end
 
	local FilterSets = {}
	local searchString = string.lower(WardrobeCollectionFrameSearchBox:GetText())
	local filterCollected = addon.Filters.Base.filterCollected
	local missingSelection = addon.Filters.Base.missingSelection
	local filterSelection = addon.Filters.Base.filterSelection
	local xpacSelection = addon.Filters.Base.xpacSelection


	if WardrobeCollectionFrame:CheckTab(3) then
		filterCollected = addon.Filters.Extra.filterCollected
		missingSelection = addon.Filters.Extra.missingSelection
		filterSelection = addon.Filters.Extra.filterSelection
		xpacSelection = addon.Filters.Extra.xpacSelection
	end

	setList =  addon:SearchSets(setList)

	for i, data in ipairs(setList) do
		local setData = BetterWardrobeSetsDataProviderMixin:GetSetSourceData(data.setID)
		local count , total = setData.numCollected, setData.numTotal
		local expansion = data.expansionID
		local sourcefilter = (WardrobeCollectionFrame:CheckTab(3) and filterSelection[data.filter])
		local unavailableFilter = (not unavailable or (addon.Profile.HideUnavalableSets and unavailable))


		if WardrobeCollectionFrame:CheckTab(2) then
			expansion = expansion + 1
			sourcefilter = true
			unavailableFilter = true
		end
		
		local collected = count == total
		if  ((filterCollected[1] and collected) or (filterCollected[2] and not collected)) and
			CheckMissingLocation(data) and
			xpacSelection[expansion] and
			sourcefilter then
			--(not unavailable or (addon.Profile.HideUnavalableSets and unavailable)) then ----and
			tinsert(FilterSets, data)
		end
	end

	
	return FilterSets
end


function addon:SearchSets(setList)
	local searchedSets = {}
	local searchString = string.lower(WardrobeCollectionFrameSearchBox:GetText())

	setList =  Sets:ClearHidden(setList)
	if searchString == "" then return setList end

	for i, data in ipairs(setList) do
			 if (searchString and string.find(string.lower(data.name), searchString)) then -- or string.find(baseSet.label, searchString) or string.find(baseSet.description, searchString)then
			tinsert(searchedSets, data)
		end
	end
	
	return searchedSets
end


--[[

					C_TransmogSets.SetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVE, value);
				end
	info.checked = C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVE);]]