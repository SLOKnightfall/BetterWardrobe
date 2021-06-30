local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)


local UI = {}

local LE_DEFAULT = addon.Globals.LE_DEFAULT
local LE_APPEARANCE = addon.Globals.LE_APPEARANCE
local LE_ALPHABETIC = addon.Globals.LE_ALPHABETIC
local LE_ITEM_SOURCE = addon.Globals.LE_ITEM_SOURCE
local LE_EXPANSION = addon.Globals.LE_EXPANSION
local LE_COLOR = addon.Globals.LE_COLOR

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
	sortDropdown = LE_DEFAULT,
	reverse = false,
}


function addon.Init:BuildUI()
	UI.DefaultButtons_Update()
	BW_WardrobeCollectionFrame.BW_SetsHideSlotButton:SetScript("OnClick", function(self) UI:JournalHideSlotMenu_OnClick(BW_WardrobeCollectionFrame.BW_SetsHideSlotButton) end)
	--.BW_SetsHideSlotButton:
	local level = BW_SetsCollectionFrame.Model:GetFrameLevel()
	BW_WardrobeCollectionFrame.BW_SetsHideSlotButton:SetFrameLevel(level + 5)
	UI.CreateOptionsDropdown()
	addon.Init:CreateRightClickDropDown()
	--	WardrobeFrame:HookScript("OnShow",  function() print("XXX"); UI.ExtendTransmogView() end)
--	hooksecurefunc(WardrobeCollectionFrame.ItemsCollectionFrame, "UpdateWeaponDropDown", PositionDropDown)
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
		{ text = L["Select Slot to Hide"], isTitle = true, notCheckable = true},
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


function 	UI.CreateOptionsDropdown()
--local f = BW_UIDropDownMenu_Create("BW_TransmogOptionsDropDown", BW_WardrobeCollectionFrame)
	local BW_TransmogOptionsDropDown= CreateFrame("Frame", "BW_TransmogOptionsDropDown", BW_WardrobeCollectionFrame, "BW_UIDropDownMenuTemplate")
	BW_TransmogOptionsDropDown = BW_TransmogOptionsDropDown
	BW_WardrobeCollectionFrame.OptionsDropDown = BW_TransmogOptionsDropDown
	BW_WardrobeTransmogVendorOptionsDropDown_OnLoad(BW_TransmogOptionsDropDown)
end