local addonName, addon = ...;
---addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0");
addon = LibStub("AceAddon-3.0"):GetAddon(addonName);
--_G[addonName] = {};
addon.ViewDelay = 3;
local newTransmogInfo  = {["latestSource"] = NO_TRANSMOG_SOURCE_ID};
addon.newTransmogInfo = newTransmogInfo
local playerInv_DB;
local Profile;
local playerNme;
local realmName;
local playerClass, classID, playerClassName;

local L = LibStub("AceLocale-3.0"):GetLocale(addonName);

function addon:AddTooltipDebugContent(sources, selectedIndex)
	local index = 1;
	if selectedIndex then
		index = selectedIndex - 1;
	end 

	local itemID = sources[index] and sources[index].itemID;
	local visualID = sources[index] and sources[index].visualID;
	local sourceID = sources[index] and sources[index].sourceID;
	
	if addon.Profile.ShowItemIDTooltips and itemID then
		GameTooltip_AddNormalLine(GameTooltip, "ItemID: " .. itemID);
		GameTooltip:Show();
	end

	if addon.Profile.ShowVisualIDTooltips and visualID then
		GameTooltip_AddNormalLine(GameTooltip, "VisualID: " .. visualID);
		GameTooltip:Show();
	end

	if addon.Profile.ShowVisualIDTooltips and sourceID then
		GameTooltip_AddNormalLine(GameTooltip, "SourceID: " .. sourceID);
		GameTooltip:Show();
	end

	if addon.Profile.ShowILevelTooltips and itemID then 
		local GetItemInfo = C_Item and C_Item.GetItemInfo
		local ilevel = select(4, GetItemInfo(itemID))
		if ilevel then 
			GameTooltip_AddNormalLine(GameTooltip, "ILevel: " .. ilevel);
			GameTooltip:Show();
		end
	end
end

function BetterWardrobeCollectionFrameMixin:ReloadTab()
		self.ItemsCollectionFrame:Hide()
		self.SetsCollectionFrame:Hide()
		self.SetsTransmogFrame:Hide()
end

function BetterWardrobeCollectionFrameMixin:CheckTab(tab)
	local atTransmogrifier = C_Transmog.IsAtTransmogNPC()
	if (atTransmogrifier and BetterWardrobeCollectionFrame.selectedTransmogTab == tab) or BetterWardrobeCollectionFrame.selectedCollectionTab == tab then
		return true;
	end
end
BW_CheckTab = BetterWardrobeCollectionFrameMixin.CheckTab




function BetterWardrobeSetsCollectionMixin:ChangeSetTab(setID)
	 setInfo = addon.getFullList(setID)
	 setInfo.oldTab = setInfo.tab
	 if setInfo.oldTab == 2 then
	 	setInfo.tab = 3
	 elseif setInfo.oldTab == 3 then
	 	setInfo.tab = 2
	 end
	 print(setInfo.name .. " moved to tab " .. setInfo.tab)

end
function addon:GetSetInfo(setID)
	return addon.getFullList(id)
	--C_TransmogSets.GetSetInfo(setID)
end

local function GetTab(tab)
	local atTransmogrifier = C_Transmog.IsAtTransmogNPC()
	local tabID;

	if ( atTransmogrifier ) then
		tabID = BetterWardrobeCollectionFrame.selectedTransmogTab;
	else
		tabID = BetterWardrobeCollectionFrame.selectedCollectionTab;
	end
	return tabID, atTransmogrifier;

end
addon.GetTab = GetTab;

function addon:AddItem(list)
local item ={
    isFavorite=true,
    visualID=		23118,
    isCollected=true,
    isUsable=true,
    canDisplayOnPlayer=true,
    hasActiveRequiredHoliday=false,
    isHideVisual=false,
    uiOrder=0,
    hasRequiredHoliday=false,
    exclusions=0
  }
tinsert(list,item)
--DevTools_Dump(list[#self.visualsList])
return list
end


local SortOrder;
local DEFAULT = addon.Globals.DEFAULT;
local APPEARANCE = addon.Globals.APPEARANCE;
local ALPHABETIC = addon.Globals.ALPHABETIC;
local ITEM_SOURCE = addon.Globals.ITEM_SOURCE;
local EXPANSION = addon.Globals.EXPANSION;
local COLOR = addon.Globals.COLOR;
local ILEVEL = 8;
local ITEMID = 9;
local ARTIFACT = 7;
local TAB_ITEMS = addon.Globals.TAB_ITEMS;
local TAB_SETS = addon.Globals.TAB_SETS;
local TAB_EXTRASETS = addon.Globals.TAB_EXTRASETS;
local TAB_SAVED_SETS = addon.Globals.TAB_SAVED_SETS;
--local TABS_MAX_WIDTH = addon.Globals.TABS_MAX_WIDTH;
--local dropdownOrder = {DEFAULT, ALPHABETIC, APPEARANCE, COLOR, EXPANSION, ITEM_SOURCE};
local dropdownOrder = {DEFAULT, ALPHABETIC, APPEARANCE, COLOR, EXPANSION, ITEM_SOURCE};
local dropdownSaveOrder = {DEFAULT, ALPHABETIC};

--= {INVTYPE_HEAD, INVTYPE_SHOULDER, INVTYPE_CLOAK, INVTYPE_CHEST, INVTYPE_WAIST, INVTYPE_LEGS, INVTYPE_FEET, INVTYPE_WRIST, INVTYPE_HAND}
local defaults = {
	sortDropdown = DEFAULT,
	--sortSavedDropdown = DEFAULT,
	reverse = false,
}

BetterWardrobeCollectionSortDropdownMixin = {};
local sortid =  1

function BetterWardrobeCollectionSortDropdownMixin:OnLoad()
	if not addon.sortDB then
		addon.sortDB = CopyTable(defaults)
	end

	self:SetWidth(150);
	self:SetSelectionTranslator(function(selection)
		return COMPACT_UNIT_FRAME_PROFILE_SORTBY.." "..selection.text;
	end);
end

function BetterWardrobeCollectionSortDropdownMixin:OnShow()
	self:Refresh();
	WardrobeFrame:RegisterCallback(BetterWardrobeFrameMixin.Event.OnCollectionTabChanged, self.Refresh, self);
end

function BetterWardrobeCollectionSortDropdownMixin:OnHide()
	WardrobeFrame:UnregisterCallback(BetterWardrobeFrameMixin.Event.OnCollectionTabChanged, self);
end

function BetterWardrobeCollectionSortDropdownMixin:GetSortFilter()
	return addon.sortDB.sortDropdown
end

function BetterWardrobeCollectionSortDropdownMixin:SetSortFilter(id)
	addon.sortDB.sortDropdown = id;
	BetterWardrobeCollectionFrame.ItemsCollectionFrame:RefreshVisualsList();

	self:Refresh();
end


function BetterWardrobeCollectionSortDropdownMixin:Refresh()
	self:SetupMenu(function(dropdown, rootDescription)
		rootDescription:SetTag("BW_SORT_MENU");

		local function IsSortFilterSet(id)
			return self:GetSortFilter()  == id
		end

		local function SetSortFilter(id)
			self:SetSortFilter(id);
		end

		for index, id in pairs(dropdownOrder) do
			--if id == ITEM_SOURCE and (tabID == 2 or tabID == 3) then
			--elseif (tabID == 4 and index <= 2) or tabID ~= 4 then 
				--info.value, info.text = id, L[id]
				--info.checked = (id == selectedValue)
				--BW_UIDropDownMenu_AddButton(info)
				rootDescription:CreateRadio(L[id], IsSortFilterSet, SetSortFilter, id);
			--end
		end
	end);
end




BetterWardrobeCollectionSavedSortDropdownMixin = CreateFromMixins(BetterWardrobeCollectionSortDropdownMixin)
function BetterWardrobeCollectionSavedSortDropdownMixin:OnLoad()
	self:SetWidth(150);
	self:SetSelectionTranslator(function(selection)
		return COMPACT_UNIT_FRAME_PROFILE_SORTBY.." "..selection.text;
	end);
end
function BetterWardrobeCollectionSavedSortDropdownMixin:GetSortFilter()
	--return addon.sortDB.sortSavedDropdown
	return addon.Profile.SortSavedDB
end
function BetterWardrobeCollectionSavedSortDropdownMixin:SetSortFilter(id)
	--addon.sortDB.sortSavedDropdown = id;
	addon.Profile.SortSavedDB = id;
	addon.RefreshLists();

	self:Refresh();
end

function BetterWardrobeCollectionSavedSortDropdownMixin:Refresh()
	self:SetupMenu(function(dropdown, rootDescription)
		rootDescription:SetTag("BW_SORT_MENU");

		local function IsSortFilterSet(id)
			return self:GetSortFilter()  == id
		end

		local function SetSortFilter(id)
			self:SetSortFilter(id);
		end

		for index, id in pairs(dropdownSaveOrder) do
			--if id == ITEM_SOURCE and (tabID == 2 or tabID == 3) then
			--elseif (tabID == 4 and index <= 2) or tabID ~= 4 then 
				--info.value, info.text = id, L[id]
				--info.checked = (id == selectedValue)
				--BW_UIDropDownMenu_AddButton(info)
				rootDescription:CreateRadio(L[id], IsSortFilterSet, SetSortFilter, id);
			--end
		end
	end);
end

local AceGUI = LibStub("AceGUI-3.0")
local showDebugWindow = false

--@debug@
showDebugWindow = true
--@end-debug@

function addon:DebugData(setID)
if not showDebugWindow then return end
local setinfo = addon.C_TransmogSets.GetSetInfo(setID);
-- Create a container frame
local f = AceGUI:Create("Frame")
f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
f:SetTitle("AceGUI-3.0 Example")
f:SetStatusText("Status Bar")
f:SetLayout("List")
-- Create a button
for i, data in pairs(setinfo) do
	local label = AceGUI:Create("Label")
	label:SetWidth(170)
	label:SetText(i..":"..tostring(data))
	-- Add the button to the container
	f:AddChild(label)
end


end
