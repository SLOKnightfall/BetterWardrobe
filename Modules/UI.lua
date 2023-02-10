local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local UI = {}

local DEFAULT = addon.Globals.DEFAULT
local APPEARANCE = addon.Globals.APPEARANCE
local ALPHABETIC = addon.Globals.ALPHABETIC
local ITEM_SOURCE = addon.Globals.ITEM_SOURCE
local EXPANSION = addon.Globals.EXPANSION
local COLOR = addon.Globals.COLOR

local TAB_ITEMS = addon.Globals.TAB_ITEMS
local TAB_SETS = addon.Globals.TAB_SETS
local TAB_EXTRASETS = addon.Globals.TAB_EXTRASETS
local TAB_SAVED_SETS = addon.Globals.TAB_SAVED_SETS
local TABS_MAX_WIDTH = addon.Globals.TABS_MAX_WIDTH

local db, active
local FileData
local SortOrder

--= {INVTYPE_HEAD, INVTYPE_SHOULDER, INVTYPE_CLOAK, INVTYPE_CHEST, INVTYPE_WAIST, INVTYPE_LEGS, INVTYPE_FEET, INVTYPE_WRIST, INVTYPE_HAND}
local defaults = {
	sortDropdown = DEFAULT,
	reverse = false,
}

function addon.Init:BuildUI()
	UI.DefaultButtons_Update()
	BW_WardrobeCollectionFrame.BW_SetsHideSlotButton:SetScript("OnClick", function(self) UI:JournalHideSlotMenu_OnClick(BW_WardrobeCollectionFrame.BW_SetsHideSlotButton) end)
	local level = BW_SetsCollectionFrame.Model:GetFrameLevel()
	BW_WardrobeCollectionFrame.BW_SetsHideSlotButton:SetFrameLevel(level + 5)
	UI.CreateOptionsDropdown()
	UI.CreateItemAltFormButton()
	addon.Init:CreateRightClickDropDown()
end

local tabType = {"item", "set", "extraset"}
--Adds icons and added right click menu options to the various frames
function UI.DefaultButtons_Update()
end

function UI:JournalHideSlotMenu_OnClick(parent)
	local Profile = addon.Profile
	local armor = addon.Globals.EmptyArmor
	local name  = addon.QueueList[3]
	local profile = addon.setdb.profile.autoHideSlot
	local function resetModel()
			local tab = BW_WardrobeCollectionFrame.selectedCollectionTab
			if tab ==2 then
				local set = WardrobeCollectionFrame.SetsCollectionFrame:GetSelectedSetID()
				WardrobeCollectionFrame.SetsCollectionFrame:DisplaySet(set)
			else
				local set = BW_SetsCollectionFrame:GetSelectedSetID()
				BW_SetsCollectionFrame:DisplaySet(set)
			end
		end

	local contextMenuData = {
		{
			text = L["Toggle Hidden View"],
			func = function (self, arg1, arg2, value)
				addon.setdb.profile.autoHideSlot.toggle = not addon.setdb.profile.autoHideSlot.toggle
				resetModel()
			end,
			isNotRadio = true,
			notCheckable = false,
			checked = function() return addon.setdb.profile.autoHideSlot.toggle end,
			keepShownOnClick = true, 
		},
		{ 
			text = L["Select Slot to Hide"], 
			isTitle = true, 
			notCheckable = true,
		},
	}

	for i = 1, 19 do 
		if armor[i] then 
			local menu = {
				text = _G[addon.Globals.INVENTORY_SLOT_NAMES[i]],
				func = function (self, arg1, arg2, value)
					profile[i] = not profile[i]
					resetModel()
				end,
				isNotRadio = true,
				notCheckable = false,
				checked = function() return profile[i] end,
				keepShownOnClick = true, 
			}
			tinsert (contextMenuData, menu)
		end
	end
	BW_UIDropDownMenu_SetAnchor(addon.ContextMenu, 0, 0, "BOTTOMLEFT", parent, "BOTTOMLEFT")
	BW_EasyMenu(contextMenuData, addon.ContextMenu, addon.ContextMenu, 0, 0, "MENU")
end
