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

local LegionWardrobeY = IsAddOnLoaded("LegionWardrobe") and 55 or 5

function addon.Init:BuildUI()
	UI.DefaultButtons_Update()
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
	if button == "RightButton" and model:GetParent().transmogType ~= Enum.TransmogType.Illusion then
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
		local isInList = match or addon.chardb.profile.collectionList[type][setID]

		if  type  == "set" or ((isInList and collected) or not collected)then --(type == "item" and not (model.visualInfo and model.visualInfo.isCollected)) or type == "set" or type == "extraset" then
			local targetSet = match or variantTarget or setID
			local targetText = match and " - "..matchType or variantTarget and " - "..variantType or ""
			UIDropDownMenu_AddSeparator()
			local isInList = addon.chardb.profile.collectionList[type][targetSet]
			UIDropDownMenu_AddButton({
				notCheckable = true,
				text = isInList and L["Remove to Collection List"]..targetText or L["Add to Collection List"]..targetText,
				func = function()
							addon.CollectionList:UpdateList(type, targetSet, not isInList)
					end,
			})
		end
	end
end


--Adds icons and added right click menu options to the various frames
function UI.DefaultButtons_Update()
		local Wardrobe = {WardrobeCollectionFrame.ItemsCollectionFrame, WardrobeCollectionFrame.SetsTransmogFrame, BW_SetsTransmogFrame}
		local ScrollFrames = {WardrobeCollectionFrameScrollFrame.buttons, BW_SetsCollectionFrameScrollFrame.buttons}
		-- hook all models
		for _, frame in ipairs(Wardrobe) do
			for _, model in pairs(frame.Models) do
				model:HookScript("OnMouseDown", function(...) UI:DefaultDropdown_Update(...) end)

				local f = CreateFrame("frame", nil, model, "BetterWardrobeIconsTemplate")
				f = CreateFrame("frame", nil, model, "BetterWardrobeSetInfoTemplate")

			end
		end

		for _, buttons in ipairs(ScrollFrames) do
			for i = 1, #buttons do
				local button = buttons[i]
				button:HookScript("OnMouseUp", function(...) UI:DefaultDropdown_Update(...) end)

				local f = CreateFrame("frame", nil, button, "BetterWardrobeIconsTemplate")
				f.Hidden:ClearAllPoints()
				f.Hidden:SetPoint("CENTER", button.Icon, "CENTER", 0, 0)
				f.Collection:ClearAllPoints()
				f.Collection:SetPoint("BOTTOMRIGHT", button.Icon, "BOTTOMRIGHT", 2, -3)
			end
		end

		--WardrobeCollectionFrame.FilterButton:HookScript("OnMouseDown", function(...) UI:DefaultFilterDropdown_Update(...) end)
end