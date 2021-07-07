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


local Sets = {}

function Sets:ClearHidden(setList, type)
print("clear")	
if addon.Profile.ShowHidden then return setList end
	local newSet = {}
	for i, setInfo in pairs(setList) do
		local itemID = setInfo.setID or setInfo.visualID
		if not addon.HiddenAppearanceDB.profile[type][itemID] then
			tinsert(newSet, setInfo)
			--print(itemID)

		else
			--print("setInfo.name")
			--print(itemID)

		end
	end
	--print(#newSet)
	return newSet
end

addon.RefreshFilter = true
function addon:FilterSets(setData, setType)
	if not addon.RefreshFilter then return setData end

	local FilterSets = {}
	local searchString = string.lower(WardrobeCollectionFrameSearchBox:GetText())



	FilterSets =  Sets:ClearHidden(setData, setType)

	addon.RefreshFilter = false
	return FilterSets
end




