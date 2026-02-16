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
		return addon.GetSetInfo(setID)
	end
end

function addon.C_TransmogSets.GetSetPrimaryAppearances(setID)
	local SetsData = addon.GetSetInfo(setID)

	if not SetsData then return {} end

	if SetsData.setType == "Blizzard" then
		return C_TransmogSets.GetSetPrimaryAppearances(setID)
	else
		local primaryID = SetsData and SetsData.baseSetID or setID
		local setInfo  = addon.GetSetInfo(primaryID)
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


function addon.C_TransmogSets.GetVariantSets(setID)
	local SetsData = addon.GetSetInfo(setID)

	if not SetsData then return {} end
	if SetsData.setType == "Blizzard" then
		return C_TransmogSets.GetVariantSets(SetsData.baseSetID)
	else
		local primaryID = SetsData and SetsData.baseSetID or setID
		return addon.VariantSets[primaryID] or {}
	end
end

function addon.C_TransmogSets.GetFilteredBaseSetsCounts()
	local SetsData = addon.GetSetInfo(setID)

	if not SetsData then return C_TransmogSets.GetFilteredBaseSetsCounts() end
	if SetsData.setType == "Blizzard" then
		return C_TransmogSets.GetFilteredBaseSetsCounts()
	else
		local primaryID = SetsData and SetsData.baseSetID or setID
	--elseif setType == "extraset" then
		--zz = addon.GetSetInfo(primaryID)

		return C_TransmogSets.GetFilteredBaseSetsCounts()
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
