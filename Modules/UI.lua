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


function addon.ToggleHidden(model, isHidden)
	local tabID = addon.GetTab()
	if tabID == 1 then
		local visualID = model.visualInfo.visualID
		local source = WardrobeCollectionFrame_GetSortedAppearanceSources(visualID)[1]
		local name, link = GetItemInfo(source.itemID)
		addon.chardb.profile.item[visualID] = not isHidden and name
		--self:UpdateWardrobe()
		print(format("%s "..link.." from the Appearances Tab", isHidden and "Unhiding" or "Hiding"))
		WardrobeCollectionFrame.ItemsCollectionFrame:RefreshVisualsList()
		WardrobeCollectionFrame.ItemsCollectionFrame:UpdateItems()

	elseif tabID == 2 then
		local setInfo = C_TransmogSets.GetSetInfo(tonumber(model.setID))
		local name = setInfo["name"]

		local baseSetID = C_TransmogSets.GetBaseSetID(model.setID)
		addon.chardb.profile.set[baseSetID] = not isHidden and name or nil

		local sourceinfo = C_TransmogSets.GetSetSources(baseSetID)
		for i,data in pairs(sourceinfo) do
			local info = C_TransmogCollection.GetSourceInfo(i)
				addon.chardb.profile.item[info.visualID] = not isHidden and info.name or nil
		end

		local variantSets = C_TransmogSets.GetVariantSets(baseSetID)
			for i, data in ipairs(variantSets) do
				addon.chardb.profile.set[data.setID] = not isHidden and data.name or nil

				local sourceinfo = C_TransmogSets.GetSetSources(data.setID)
				for i,data in pairs(sourceinfo) do
					local info = C_TransmogCollection.GetSourceInfo(i)
						addon.chardb.profile.item[info.visualID] = not isHidden and info.name or nil
				end
		end	

		WardrobeCollectionFrame.SetsCollectionFrame:OnSearchUpdate()
		WardrobeCollectionFrame.SetsTransmogFrame:OnSearchUpdate()
		print(format("%s "..name, isHidden and "Unhiding" or "Hiding"))

	else
		local setInfo = addon.GetSetInfo(model.setID)
		local name = setInfo["name"]
		addon.chardb.profile.extraset[model.setID] = not isHidden and name or nil
		print(format("%s "..name, isHidden and "Unhiding" or "Hiding"))
		BW_SetsCollectionFrame:OnSearchUpdate()
		BW_SetsTransmogFrame:OnSearchUpdate()

	end
			--self:UpdateWardrobe()
end


local tabType = {"item", "set", "extraset"}
---==== Hide Buttons
function UI:DefaultDropdown_Update(model, button)
	if BW_WardrobeCollectionFrame.selectedTransmogTab == 4 or BW_WardrobeCollectionFrame.selectedCollectionTab == 4 then
		return
	end
	if button == "RightButton" and model:GetParent().transmogType ~= Enum.TransmogType.Illusion and not IsModifierKeyDown() then
		if not DropDownList1:IsShown() then
			 -- force show dropdown
			WardrobeModelRightClickDropDown.activeFrame = model
			ToggleDropDownMenu(1, nil, WardrobeModelRightClickDropDown, model, -6, -3)
		end

		local setID = (model.visualInfo and model.visualInfo.visualID) or model.setID
		local type = tabType[addon.GetTab()]
		local variantTarget, match, matchType
		local variantType = ""
		if type == "set" or type =="extraset" then
			UIDropDownMenu_AddSeparator()
			UIDropDownMenu_AddButton({
					notCheckable = true,
					text = L["Queue Transmog"],
					func = function()

						local setInfo = addon.GetSetInfo(setID) or C_TransmogSets.GetSetInfo(setID)
						local name = setInfo["name"]
						--addon.QueueForTransmog(type, setID, name)
						addon.QueueList = {type, setID, name}
					 end,
					})
			if type == "set" then 
				variantTarget, variantType, match, matchType = addon.Sets:SelectedVariant(setID)
			end
		end

		UIDropDownMenu_AddSeparator()
		local isHidden = addon.chardb.profile[type][setID]
		UIDropDownMenu_AddButton({
			notCheckable = true,
			text = isHidden and SHOW or HIDE,
			func = function() addon.ToggleHidden(model, isHidden) end,
		})

		local collected = (model.visualInfo and model.visualInfo.isCollected) or C_TransmogSets.IsBaseSetCollected(setID) or model.setCollected
		--Collection List Right Click options
		local collectionList = addon.CollectionList:CurrentList()
		local isInList = match or addon.CollectionList:IsInList(setID, type)

		--if  type  == "set" or ((isInList and collected) or not collected)then --(type == "item" and not (model.visualInfo and model.visualInfo.isCollected)) or type == "set" or type == "extraset" then
			local targetSet = match or variantTarget or setID
			local targetText = match and " - "..matchType or variantTarget and " - "..variantType or ""
			UIDropDownMenu_AddSeparator()
			local isInList = collectionList[type][targetSet]
			UIDropDownMenu_AddButton({
				notCheckable = true,
				text = isInList and L["Remove from Collection List"]..targetText or L["Add to Collection List"]..targetText,
				func = function()
							addon.CollectionList:UpdateList(type, targetSet, not isInList)
					end,
			})
		--end
	end
end


--Adds icons and added right click menu options to the various frames
function UI.DefaultButtons_Update()
		local Wardrobe = {WardrobeCollectionFrame.ItemsCollectionFrame, WardrobeCollectionFrame.SetsTransmogFrame, BW_SetsTransmogFrame}
		local ScrollFrames = {WardrobeCollectionFrameScrollFrame.buttons, BW_SetsCollectionFrameScrollFrame.buttons}
		-- hook all models
		for index , frame in ipairs(Wardrobe) do
			for _, model in pairs(frame.Models) do
				if index ~=3 then 

				model:HookScript("OnMouseDown", function(...) UI:DefaultDropdown_Update(...) end)
			end

				local f = CreateFrame("frame", nil, model, "BetterWardrobeIconsTemplate")
				f = CreateFrame("frame", nil, model, "BetterWardrobeSetInfoTemplate")

			end
		end

		for index, buttons in ipairs(ScrollFrames) do
			for i = 1, #buttons do
				local button = buttons[i]
					--button:HookScript("OnMouseUp", function(...) UI:DefaultDropdown_Update(...) end)
					button:SetScript("OnMouseUp", function(...) 
						local self, button = ...
						if ( button == "LeftButton" ) then
							PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
							self:GetParent():GetParent():GetParent():SelectSetFromButton(self.setID);
						elseif ( button == "RightButton" ) then
							local dropDown = self:GetParent():GetParent().FavoriteDropDown;
							dropDown.baseSetID = self.setID;
							L_ToggleDropDownMenu(1, nil, dropDown, self, 0, 0);
							PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
						end
					end)

				local f = CreateFrame("frame", nil, button, "BetterWardrobeIconsTemplate")
				f.Hidden:ClearAllPoints()
				f.Hidden:SetPoint("CENTER", button.Icon, "CENTER", 0, 0)
				f.Collection:ClearAllPoints()
				f.Collection:SetPoint("BOTTOMRIGHT", button.Icon, "BOTTOMRIGHT", 2, -3)
			end
		end

		--WardrobeCollectionFrame.FilterButton:HookScript("OnMouseDown", function(...) UI:DefaultFilterDropdown_Update(...) end)
	UIDropDownMenu_Initialize(WardrobeCollectionFrame.ItemsCollectionFrame.RightClickDropDown, nil, "MENU");
	WardrobeCollectionFrame.ItemsCollectionFrame.RightClickDropDown.initialize = aWardrobeCollectionFrameRightClickDropDown_Init
end


function addon:SetFavoriteItem(visualID, set)
	if addon.chardb.profile.favorite_items[visualID] then
		addon.chardb.profile.favorite_items[visualID] = nil
	else
		addon.chardb.profile.favorite_items[visualID] = true
	end

	WardrobeCollectionFrame.ItemsCollectionFrame:RefreshVisualsList()
	WardrobeCollectionFrame.ItemsCollectionFrame:UpdateItems()
end


function addon:IsFavoriteItem(visualID)
	return addon.chardb.profile.favorite_items[visualID]
end

--Modified to allow favoriteing unlearned items
function aWardrobeCollectionFrameRightClickDropDown_Init(self)
	local appearanceID = self.activeFrame.visualInfo.visualID;
	local info = UIDropDownMenu_CreateInfo();
	local favItem = addon:IsFavoriteItem(appearanceID)

	-- Set Favorite
	if ( favItem or C_TransmogCollection.GetIsAppearanceFavorite(appearanceID) ) then
		info.text = BATTLE_PET_UNFAVORITE;
		info.arg1 = appearanceID;
		info.arg2 = 0;
	else
		info.text = BATTLE_PET_FAVORITE;
		info.arg1 = appearanceID;
		info.arg2 = 1;
		if ( not C_TransmogCollection.CanSetFavoriteInCategory(WardrobeCollectionFrame.ItemsCollectionFrame:GetActiveCategory()) ) then
			info.tooltipWhileDisabled = 1
			info.tooltipTitle = BATTLE_PET_FAVORITE;
			info.tooltipText = TRANSMOG_CATEGORY_FAVORITE_LIMIT;
			info.tooltipOnButton = 1;
			info.disabled = 1;
		end
	end
	info.notCheckable = true;
	info.func = function(_, visualID, value) WardrobeCollectionFrameModelDropDown_SetFavorite(visualID, value); end;
	UIDropDownMenu_AddButton(info);
	-- Cancel
	info = UIDropDownMenu_CreateInfo();
	info.notCheckable = true;
	info.text = CANCEL;
	UIDropDownMenu_AddButton(info);

	local headerInserted = false;
	local sources = WardrobeCollectionFrame_GetSortedAppearanceSources(appearanceID);
	local chosenSourceID = WardrobeCollectionFrame.ItemsCollectionFrame:GetChosenVisualSource(appearanceID);
	info.func = WardrobeCollectionFrameModelDropDown_SetSource;
	for i = 1, #sources do
		if ( sources[i].isCollected and not sources[i].useError ) then
			if ( not headerInserted ) then
				headerInserted = true;
				-- space
				info.text = " ";
				info.disabled = true;
				UIDropDownMenu_AddButton(info);
				info.disabled = nil;
				-- header
				info.text = WARDROBE_TRANSMOGRIFY_AS;
				info.isTitle = true;
				info.colorCode = NORMAL_FONT_COLOR_CODE;
				UIDropDownMenu_AddButton(info);
				info.isTitle = nil;
				-- turn off notCheckable
				info.notCheckable = nil;
			end
			if ( sources[i].name ) then
				info.text = sources[i].name;
				info.colorCode = ITEM_QUALITY_COLORS[sources[i].quality].hex;
			else
				info.text = RETRIEVING_ITEM_INFO;
				info.colorCode = RED_FONT_COLOR_CODE;
			end
			info.disabled = nil;
			info.arg1 = appearanceID;
			info.arg2 = sources[i].sourceID;
			-- choose the 1st valid source if one isn't explicitly chosen
			if ( chosenSourceID == NO_TRANSMOG_SOURCE_ID ) then
				chosenSourceID = sources[i].sourceID;
			end
			info.checked = (chosenSourceID == sources[i].sourceID);
			UIDropDownMenu_AddButton(info);
		end
	end
end


function WardrobeCollectionFrameModelDropDown_SetFavorite(visualID, value, confirmed)
	local set = (value == 1);
	if ( set and not confirmed ) then
		local allSourcesConditional = true;
		local collected = false
		local sources = C_TransmogCollection.GetAppearanceSources(visualID);
		for i, sourceInfo in ipairs(sources) do
			local info = C_TransmogCollection.GetAppearanceInfoBySource(sourceInfo.sourceID);

			if ( info.sourceIsCollectedPermanent ) then
				allSourcesConditional = false;
				collected = info.appearanceIsCollected
				break;
			end
		end
		if ( allSourcesConditional and collected ) then
			StaticPopup_Show("TRANSMOG_FAVORITE_WARNING", nil, nil, visualID);
			return;
		elseif ( allSourcesConditional and not collected ) then 
			addon:SetFavoriteItem(visualID, set)
			return 
		end
	end
	if addon:IsFavoriteItem(visualID) then 
		addon:SetFavoriteItem(visualID, set)
	else
		C_TransmogCollection.SetIsAppearanceFavorite(visualID, set);
		SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_TRANSMOG_MODEL_CLICK, true);
		HelpTip:Hide(WardrobeCollectionFrame.ItemsCollectionFrame, TRANSMOG_MOUSE_CLICK_TUTORIAL);
	end
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
	L_UIDropDownMenu_SetAnchor(addon.ContextMenu, 0, 0, "BOTTOMLEFT", parent, "BOTTOMLEFT")
	L_EasyMenu(contextMenuData, addon.ContextMenu, addon.ContextMenu, 0, 0, "MENU")
end


function 	UI.CreateOptionsDropdown()
local f = L_Create_UIDropDownMenu("BW_TransmogOptionsDropDown", BW_WardrobeCollectionFrame)
BW_TransmogOptionsDropDown = f


BW_WardrobeCollectionFrame.OptionsDropDown = f
BW_WardrobeTransmogVendorOptionsDropDown_OnLoad(f)
end

