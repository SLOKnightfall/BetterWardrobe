local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local UI = {}

local LE_DEFAULT = 1
local LE_APPEARANCE = 2
local LE_ALPHABETIC = 3
local LE_ITEM_SOURCE = 6
local LE_EXPANSION = 5
local LE_COLOR = 4

local TAB_ITEMS = 1
local TAB_SETS = 2
local TAB_EXTRASETS = 3
local TAB_SAVED_SETS = 4
local TABS_MAX_WIDTH = 245

local Wardrobe = WardrobeCollectionFrame.ItemsCollectionFrame

local db, active
local FileData
local SortOrder
		
local dropdownOrder = {LE_DEFAULT, LE_ALPHABETIC, LE_APPEARANCE, LE_COLOR, LE_EXPANSION, LE_ITEM_SOURCE}
local defaults = {
	sortDropdown = LE_DEFAULT,
	reverse = false,
}

local LegionWardrobeY = IsAddOnLoaded("LegionWardrobe") and 55 or 5

local f = CreateFrame("Frame")
function UI.SortDropdowns_Initialize()
	if not addon.sortDB then
		addon.sortDB = CopyTable(defaults)
	end

	db = addon.sortDB
	
	f:RegisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE")
	UIDropDownMenu_SetWidth(BW_SortDropDown, 140)
	UIDropDownMenu_Initialize(BW_SortDropDown, function(self)
		local info = UIDropDownMenu_CreateInfo()
		local selectedValue = UIDropDownMenu_GetSelectedValue(self)
		
		info.func = function(self)
			db.sortDropdown = self.value
			UIDropDownMenu_SetSelectedValue(BW_SortDropDown, self.value)
			UIDropDownMenu_SetText(BW_SortDropDown, COMPACT_UNIT_FRAME_PROFILE_SORTBY.." "..L[self.value])
			db.reverse = IsModifierKeyDown()
			addon.SetSortOrder(db.reverse)
			local tabID = addon.GetTab()
			if tabID == 1 then 
				Wardrobe:SortVisuals()
			elseif tabID == 2 then
				WardrobeCollectionFrame.SetsCollectionFrame:OnSearchUpdate()
				WardrobeCollectionFrame.SetsTransmogFrame:OnSearchUpdate()
			elseif tabID == 3 then
				BW_SetsCollectionFrame:OnSearchUpdate()
				BW_SetsTransmogFrame:OnSearchUpdate()
			end
		end
		
		local tabID = addon.GetTab()
		for _, id in pairs(dropdownOrder) do
			if id == LE_ITEM_SOURCE and (tabID == 2 or tabID == 3) then
			else
				info.value, info.text = id, L[id]
				info.checked = (id == selectedValue)
				UIDropDownMenu_AddButton(info)
			end
		end
	end)

	UIDropDownMenu_SetSelectedValue(BW_SortDropDown, db.sortDropdown)
	UIDropDownMenu_SetText(BW_SortDropDown, COMPACT_UNIT_FRAME_PROFILE_SORTBY.." "..L[db.sortDropdown])
end


-- Base Transmog Sets Window Upates
function UI.ExtendTransmogView()
    WardrobeFrame:SetWidth(1170)
    WardrobeTransmogFrame:SetWidth(500)
    WardrobeTransmogFrame.ModelScene:ClearAllPoints()
    WardrobeTransmogFrame.ModelScene:SetPoint("TOP", WardrobeTransmogFrame, "TOP", 0, -4)
    WardrobeTransmogFrame.ModelScene:SetWidth(420)
    WardrobeTransmogFrame.ModelScene:SetHeight(420)
    WardrobeTransmogFrame.Inset.BG:SetWidth(494)

    WardrobeTransmogFrame.ModelScene.HeadButton:ClearAllPoints()
    WardrobeTransmogFrame.ModelScene.HeadButton:SetPoint("TOP", WardrobeTransmogFrame.ModelScene, "TOP", -208, -41)
    WardrobeTransmogFrame.ModelScene.HandsButton:ClearAllPoints()
    WardrobeTransmogFrame.ModelScene.HandsButton:SetPoint("TOP", WardrobeTransmogFrame.ModelScene, "TOP", 205, -118)

    WardrobeTransmogFrame.ModelScene.MainHandButton:ClearAllPoints()
    WardrobeTransmogFrame.ModelScene.MainHandButton:SetPoint("TOP", WardrobeTransmogFrame.ModelScene, "BOTTOM", -26, -5)
    WardrobeTransmogFrame.ModelScene.SecondaryHandButton:ClearAllPoints()
    WardrobeTransmogFrame.ModelScene.SecondaryHandButton:SetPoint("TOP", WardrobeTransmogFrame.ModelScene, "BOTTOM", 27, -5)
    WardrobeTransmogFrame.ModelScene.MainHandEnchantButton:ClearAllPoints()
    WardrobeTransmogFrame.ModelScene.MainHandEnchantButton:SetPoint("BOTTOM", WardrobeTransmogFrame.ModelScene.MainHandButton, "BOTTOM", 0, -20)
    WardrobeTransmogFrame.ModelScene.SecondaryHandEnchantButton:ClearAllPoints()
    WardrobeTransmogFrame.ModelScene.SecondaryHandEnchantButton:SetPoint("BOTTOM", WardrobeTransmogFrame.ModelScene.SecondaryHandButton, "BOTTOM", 0, -20)
    
    UIPanelWindows["WardrobeFrame"].width = 1170    
end


--- Functionality to add tabs to window
function BW_WardrobeCollectionFrame_ClickTab(tab)
	BW_WardrobeCollectionFrame_SetTab(tab:GetID())
	PanelTemplates_ResizeTabsToFit(WardrobeCollectionFrame, TABS_MAX_WIDTH)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
end


function BW_WardrobeCollectionFrame_SetTab(tabID)
	PanelTemplates_SetTab(BW_WardrobeCollectionFrame, tabID)
	local atTransmogrifier = WardrobeFrame_IsAtTransmogrifier()

	if atTransmogrifier then
		WardrobeCollectionFrame.selectedTransmogTab = tabID
		BW_WardrobeCollectionFrame.selectedTransmogTab = tabID

	else
		WardrobeCollectionFrame.selectedCollectionTab = tabID
		BW_WardrobeCollectionFrame.selectedCollectionTab = tabID
	end

	local tab1 = (tabID == TAB_ITEMS)
	local tab2 = (tabID == TAB_SETS)
	local tab3 = (tabID == TAB_EXTRASETS)
	local tab4 = (tabID == TAB_SAVED_SETS)

		WardrobeCollectionFrame.ItemsCollectionFrame:SetShown(tab1)
		WardrobeCollectionFrame.SetsCollectionFrame:SetShown(tab2 and not atTransmogrifier)
		WardrobeCollectionFrame.SetsTransmogFrame:SetShown(tab2 and atTransmogrifier)
		BW_WardrobeCollectionFrame.BW_SetsCollectionFrame:SetShown((tab3 or tab4) and not atTransmogrifier)
		BW_WardrobeCollectionFrame.BW_SetsTransmogFrame:SetShown((tab3 or tab4) and atTransmogrifier)

		BW_WardrobeToggle:SetShown(tab2 or tab3 or tab4)
		BW_WardrobeToggle.VisualMode = false

		local searchBox_X = ((tab1 or ((tab2 or tab3) and atTransmogrifier)) and -107) or 19
		local searchBox_Y = ((tab1 or ((tab2 or tab3) and atTransmogrifier)) and -35) or -69
		local searchBox_Anchor = ((tab1 or ((tab2 or tab3) and atTransmogrifier)) and "TOPRIGHT") or "TOPLEFT"

		WardrobeCollectionFrame.searchBox:ClearAllPoints()
		WardrobeCollectionFrame.searchBox:SetEnabled(tab1 and WardrobeCollectionFrame.ItemsCollectionFrame.transmogType == LE_TRANSMOG_TYPE_APPEARANCE or tab2 or tab3)
		WardrobeCollectionFrame.searchBox:SetPoint(searchBox_Anchor, searchBox_X, searchBox_Y )
		WardrobeCollectionFrame.searchBox:SetWidth(((tab2 or tab3) and not atTransmogrifier and 145) or 105)

		WardrobeCollectionFrame.FilterButton:SetShown(not atTransmogrifier)
		WardrobeCollectionFrame.FilterButton:SetEnabled(tab1 and WardrobeCollectionFrame.ItemsCollectionFrame.transmogType == LE_TRANSMOG_TYPE_APPEARANCE or tab2)
		WardrobeCollectionFrame.progressBar:SetShown(not tab4)
		BW_CollectionListButton:SetShown(tab1 and not atTransmogrifier)

		BW_WardrobeCollectionFrame.FilterButton:SetShown(tab3)
		
		UIDropDownMenu_EnableDropDown(BW_SortDropDown)
		BW_SortDropDown:ClearAllPoints()

	if tab1 then
		WardrobeCollectionFrame.activeFrame = WardrobeCollectionFrame.ItemsCollectionFrame
		BW_WardrobeCollectionFrame.activeFrame = WardrobeCollectionFrame.ItemsCollectionFrame

		local _, isWeapon = C_TransmogCollection.GetCategoryInfo(WardrobeCollectionFrame.ItemsCollectionFrame:GetActiveCategory() or -1)
		BW_SortDropDown:SetPoint("TOPLEFT", WardrobeCollectionFrame.ItemsCollectionFrame.WeaponDropDown, "BOTTOMLEFT", 0, (atTransmogrifier and (isWeapon and 55 or 32)) or LegionWardrobeY)

	elseif tab2 then
		if atTransmogrifier  then
			WardrobeCollectionFrame.activeFrame = WardrobeCollectionFrame.SetsTransmogFrame
			BW_WardrobeCollectionFrame.activeFrame = WardrobeCollectionFrame.SetsTransmogFrame

			BW_SortDropDown:SetPoint("TOPRIGHT", WardrobeCollectionFrame.ItemsCollectionFrame, "TOPRIGHT", -27, -10)

		else
			WardrobeCollectionFrame.activeFrame = WardrobeCollectionFrame.SetsCollectionFrame
			BW_WardrobeCollectionFrame.activeFrame = WardrobeCollectionFrame.SetsCollectionFrame

			BW_SortDropDown:SetPoint("TOPLEFT", BW_WardrobeToggle, "TOPRIGHT")
		end

	elseif tab3 then
		
		if atTransmogrifier then
			WardrobeCollectionFrame.activeFrame = BW_WardrobeCollectionFrame.BW_SetsTransmogFrame
			BW_WardrobeCollectionFrame.activeFrame = BW_WardrobeCollectionFrame.BW_SetsTransmogFrame
	
			BW_SortDropDown:SetPoint("TOPRIGHT", WardrobeCollectionFrame.ItemsCollectionFrame, "TOPRIGHT",-27, -10)

		else
			WardrobeCollectionFrame.activeFrame = BW_WardrobeCollectionFrame.BW_SetsCollectionFrame
			BW_WardrobeCollectionFrame.activeFrame = BW_WardrobeCollectionFrame.BW_SetsCollectionFrame

			BW_SortDropDown:SetPoint("TOPLEFT", BW_WardrobeToggle, "TOPRIGHT")

		end
		
		WardrobeCollectionFrame.searchBox:Show()
	elseif tab4 then
		--WardrobeCollectionFrame.searchBox:Hide()
		UIDropDownMenu_DisableDropDown(BW_SortDropDown)
		if atTransmogrifier then
			WardrobeCollectionFrame.activeFrame = BW_WardrobeCollectionFrame.BW_SetsTransmogFrame
			BW_WardrobeCollectionFrame.activeFrame = BW_WardrobeCollectionFrame.BW_SetsTransmogFrame
	
			BW_SortDropDown:SetPoint("TOPRIGHT", WardrobeCollectionFrame.ItemsCollectionFrame, "TOPRIGHT",-27, -10)

		else
			WardrobeCollectionFrame.activeFrame = BW_WardrobeCollectionFrame.BW_SetsCollectionFrame
			BW_WardrobeCollectionFrame.activeFrame = BW_WardrobeCollectionFrame.BW_SetsCollectionFrame

			BW_SortDropDown:SetPoint("TOPLEFT", BW_WardrobeToggle, "TOPRIGHT")
		end

	end
end


local function CreateVisualViewButton()
	local b = CreateFrame("Button", "BW_WardrobeToggle", WardrobeCollectionFrame, "EyeTemplate")
	b:SetSize(30 ,30) -- width, height
	b:Hide()
	b.texture:SetTexCoord(0.125, 0.25, 0.25, 0.5)
	b:SetPoint("CENTER")
	b:SetPoint("LEFT", WardrobeCollectionFrame.progressBar, "RIGHT")
	b:SetScript("OnClick", function(self)
		local baseFrame
		self.viewAll = false

		local atTransmogrifier = WardrobeFrame_IsAtTransmogrifier()
		
		--self.VisualMode = not self.VisualMode
		if ( atTransmogrifier ) then
			local tab = WardrobeCollectionFrame.selectedTransmogTab
			if tab == 2  or tab == 3 then
				self.VisualMode = not self.VisualMode
				WardrobeCollectionFrame.SetsTransmogFrame:OnSearchUpdate()
				BW_SetsTransmogFrame:OnSearchUpdate()
			end

		else
			local tab = WardrobeCollectionFrame.selectedCollectionTab
			
			if tab == 2 then 
				if WardrobeCollectionFrame.SetsCollectionFrame:IsShown() then
					self.VisualMode = true
					self.viewAll = true
					WardrobeCollectionFrame.SetsTransmogFrame:Show()
					WardrobeCollectionFrame.SetsCollectionFrame:Hide()
					WardrobeCollectionFrame.activeFrame = WardrobeCollectionFrame.SetsTransmogFrame
					BW_WardrobeCollectionFrame.activeFrame = WardrobeCollectionFrame.SetsTransmogFrame
					WardrobeCollectionFrame.SetsTransmogFrame:OnSearchUpdate()
					WardrobeCollectionFrame.FilterButton:Hide()

				else
					self.VisualMode = false
					self.viewAll = false
					WardrobeCollectionFrame.SetsTransmogFrame:Hide()
					WardrobeCollectionFrame.SetsCollectionFrame:Show()
					WardrobeCollectionFrame.FilterButton:Show()
					WardrobeCollectionFrame.activeFrame = WardrobeCollectionFrame.SetsCollectionFrame
					BW_WardrobeCollectionFrame.activeFrame = WardrobeCollectionFrame.SetsCollectionFrame

				end

			elseif tab == 3 then 
				if BW_WardrobeCollectionFrame.BW_SetsCollectionFrame:IsShown() then
					self.VisualMode = true
					self.viewAll = true
					BW_WardrobeCollectionFrame.BW_SetsTransmogFrame:Show()
					BW_WardrobeCollectionFrame.BW_SetsCollectionFrame:Hide()
					WardrobeCollectionFrame.activeFrame = BW_WardrobeCollectionFrame.BW_SetsTransmogFrame
					BW_WardrobeCollectionFrame.activeFrame = BW_WardrobeCollectionFrame.BW_SetsTransmogFrame
					BW_SetsTransmogFrame:OnSearchUpdate()
				else
					self.VisualMode = false
					self.viewAll = false
					BW_WardrobeCollectionFrame.BW_SetsTransmogFrame:Hide()
					BW_WardrobeCollectionFrame.BW_SetsCollectionFrame:Show()
					WardrobeCollectionFrame.activeFrame = BW_WardrobeCollectionFrame.BW_SetsCollectionFrame
					BW_WardrobeCollectionFrame.activeFrame = BW_WardrobeCollectionFrame.BW_SetsCollectionFrame
				end
			end
		end
	end)
	
	b:SetScript("OnHide", function(self) 
			BW_WardrobeCollectionFrame.BW_SetsTransmogFrame:Hide()
			self.VisualMode = false
		end)

	b:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText("Visual View")
			GameTooltip:Show()
		end)

	b:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
end


local function PositionDropDown()
	if WardrobeFrame_IsAtTransmogrifier() then
		local _, isWeapon = C_TransmogCollection.GetCategoryInfo(Wardrobe:GetActiveCategory() or -1)
		BW_SortDropDown:SetPoint("TOPLEFT", Wardrobe.WeaponDropDown, "BOTTOMLEFT", 0, isWeapon and 55 or 32)
	else
		BW_SortDropDown:SetPoint("TOPLEFT", Wardrobe.WeaponDropDown, "BOTTOMLEFT", 0, LegionWardrobeY)
	end
end


function UI.BuildLoadQueueButton()
	BW_LoadQueueButton:SetScript("OnClick", function(self)
		local setType = addon.QueueList[1]
		local setID = addon.QueueList[2]
		if setType == "set" then
			WardrobeCollectionFrame.SetsTransmogFrame:LoadSet(setID)
		elseif setType == "extraset" then 
			BW_SetsTransmogFrame:LoadSet(setID)
		end
	end)

	BW_LoadQueueButton:SetScript("OnEnter", function(self)	
		local name  = addon.QueueList[3]
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		if name then 	
			GameTooltip:SetText(L["Load Set: %s"]:format(name))
		else
			GameTooltip:SetText(L["Load Set: %s"]:format(L["None Selected"]))
		end
	end)
end


function addon.BuildUI()
	UI.SortDropdowns_Initialize()
	CreateVisualViewButton()
	UI.ExtendTransmogView()
--BW_WardrobeCollectionFrame:GetFrameLevel()
	WardrobeCollectionFrame.searchBox:SetFrameLevel(BW_WardrobeCollectionFrame:GetFrameLevel()+10)
	WardrobeCollectionFrame.FilterButton:SetFrameLevel(BW_WardrobeCollectionFrame:GetFrameLevel()+10)
	BW_WardrobeCollectionFrame.FilterButton:SetFrameLevel(BW_WardrobeCollectionFrame:GetFrameLevel()+10)
	BW_WardrobeCollectionFrame.FilterButton:SetPoint("TOPLEFT", WardrobeCollectionFrame.FilterButton, "TOPLEFT")

 	UI.BuildLoadQueueButton()
	UI.DefaultButtons_Update()

	hooksecurefunc(Wardrobe, "UpdateWeaponDropDown", PositionDropDown )
end


-- ***** FILTER

function BW_WardrobeFilterDropDown_OnLoad(self)
	UIDropDownMenu_Initialize(self, UI.FilterDropDown_InitializeItems, "MENU")
end


local FILTER_SOURCES = {L["Classic Set"],L["Quest Set"],L["Dunegon Set"],L["Raid Recolor"],L["Raid Lookalike"],L["Garrison"],L["Island Expidetion"], L["Warfronts"]}
local EXPANSIONS = {EXPANSION_NAME0 , EXPANSION_NAME1, EXPANSION_NAME2, EXPANSION_NAME3 , EXPANSION_NAME4, EXPANSION_NAME5, EXPANSION_NAME6, EXPANSION_NAME7, EXPANSION_NAME8 }

local filterSelection = {} 
for i = 1, 8 do
	filterSelection[i] = true
end

local xpacSelection = {}
for i = 1, 8 do
	xpacSelection[i] = true
end

local filterCollected = {true, true}
addon.filterCollected = filterCollected
addon.xpacSelection = xpacSelection
addon.filterSelection = filterSelection


function UI:FilterDropDown_InitializeItems(level)
	if ( not WardrobeCollectionFrame.activeFrame ) then
		return
	end

	local info = UIDropDownMenu_CreateInfo()
	info.keepShownOnClick = true
	local atTransmogrifier = WardrobeFrame_IsAtTransmogrifier()

	if level == 1 then
		info.text = COLLECTED
		info.func = function(_, _, _, value)
						filterCollected[1] = value
						BW_SetsCollectionFrame:OnSearchUpdate()
						BW_SetsTransmogFrame:OnSearchUpdate()
					end
		info.checked = 	function() return filterCollected[1] end
		info.isNotRadio = true
		UIDropDownMenu_AddButton(info, level)

		info.text = NOT_COLLECTED
		info.func = function(_, _, _, value)
						filterCollected[2] =  value
						BW_SetsCollectionFrame:OnSearchUpdate()
						BW_SetsTransmogFrame:OnSearchUpdate()
					end
		info.checked = 	function() return filterCollected[2] end
		info.isNotRadio = true

		UIDropDownMenu_AddButton(info, level)

		info.checked = 	nil
		info.isNotRadio = nil
		info.func =  nil
		info.hasArrow = true
		info.notCheckable = true

		info.text = SOURCES
			info.value = 1
		UIDropDownMenu_AddButton(info, level)

		info.text = L["Expansion"]
		info.value = 2
		UIDropDownMenu_AddButton(info, level)

		if  WardrobeFrame_IsAtTransmogrifier() then
			info.text = "cutoff"
			info.value = 3
			UIDropDownMenu_AddButton(info, level)
		end

	elseif level == 2  and UIDROPDOWNMENU_MENU_VALUE == 1 then
			local refreshLevel = 2
			info.hasArrow = false
			info.isNotRadio = true
			info.notCheckable = true
			--tinsert(filterSelection,true)
			info.text = CHECK_ALL
			info.func = function()
							for i = 1, #filterSelection do
									filterSelection[i] = true
							end

							BW_SetsCollectionFrame:OnSearchUpdate()
							BW_SetsTransmogFrame:OnSearchUpdate()
							UIDropDownMenu_Refresh(BW_WardrobeFilterDropDown, 1, refreshLevel)
						end
			UIDropDownMenu_AddButton(info, level)

			local refreshLevel = 2
			info.hasArrow = false
			info.isNotRadio = true
			info.notCheckable = true
			--tinsert(filterSelection,true)

			info.text = UNCHECK_ALL
			info.func = function()
							for i = 1, #filterSelection do
									filterSelection[i] = false
							end

							BW_SetsCollectionFrame:OnSearchUpdate()
							BW_SetsTransmogFrame:OnSearchUpdate()
							UIDropDownMenu_Refresh(BW_WardrobeFilterDropDown, 1, refreshLevel)
						end
			UIDropDownMenu_AddButton(info, level)
			info.notCheckable = false

			local numSources = #FILTER_SOURCES --C_TransmogCollection.GetNumTransmogSources()
			for i = 1, numSources do
				--tinsert(filterSelection,true)
				info.text = FILTER_SOURCES[i]
					info.func = function(_, _, _, value)
						filterSelection[i] = value
						BW_SetsCollectionFrame:OnSearchUpdate()
						BW_SetsTransmogFrame:OnSearchUpdate()
					end
					info.checked = 	function() return filterSelection[i] end 
				UIDropDownMenu_AddButton(info, level)
			end

		elseif level == 2  and UIDROPDOWNMENU_MENU_VALUE == 2 then
			local refreshLevel = 2
			info.hasArrow = false
			info.isNotRadio = true
			info.notCheckable = true
			info.text = CHECK_ALL
			info.func = function()
							for i = 1, #xpacSelection do
									xpacSelection[i] = true
							end
							BW_SetsCollectionFrame:OnSearchUpdate()
							BW_SetsTransmogFrame:OnSearchUpdate()
							UIDropDownMenu_Refresh(BW_WardrobeFilterDropDown, 1, refreshLevel)
						end
			UIDropDownMenu_AddButton(info, level)

			local refreshLevel = 2
			info.hasArrow = false
			info.isNotRadio = true
			info.notCheckable = true

			info.text = UNCHECK_ALL
			info.func = function()
							for i = 1, #xpacSelection do
									xpacSelection[i] = false
							end
								BW_SetsCollectionFrame:OnSearchUpdate()
								BW_SetsTransmogFrame:OnSearchUpdate()
							UIDropDownMenu_Refresh(BW_WardrobeFilterDropDown, 1, refreshLevel)
						end
			UIDropDownMenu_AddButton(info, level)

			info.notCheckable = false
			for i = 1, #EXPANSIONS do
				info.text = EXPANSIONS[i]
					info.func = function(_, _, _, value)
						xpacSelection[i] = value
						BW_SetsCollectionFrame:OnSearchUpdate()
						BW_SetsTransmogFrame:OnSearchUpdate()
					end
					info.checked = 	function() return xpacSelection[i] end
				UIDropDownMenu_AddButton(info, level)
			end

	elseif level == 2 and UIDROPDOWNMENU_MENU_VALUE == 3 and WardrobeFrame_IsAtTransmogrifier() then
			local refreshLevel = 2
			info.notCheckable = false
			info.keepShownOnClick = false
			for i = 1, 7 do
				local info = UIDropDownMenu_CreateInfo()
				--tinsert(xpacSelection,true)
				info.text = i
				info.value = i
					info.func = function(a, b, c, value)
						addon.Profile.PartialLimit = info.value
						UIDropDownMenu_Refresh(BW_WardrobeFilterDropDown, 1, 1)
						BW_SetsCollectionFrame:OnSearchUpdate()
						BW_SetsTransmogFrame:OnSearchUpdate()
					end
				info.checked = 	function() return info.value == addon.Profile.PartialLimit end
				UIDropDownMenu_AddButton(info, level)
			end
	end
	--end
end

--  C_TransmogCollection.GetSourceInfo(sourceID)  .itemID


--sources = C_TransmogSets.GetSetSources(baseSetID)


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

		local baseSetID = C_TransmogSets.GetBaseSetID(model.setID);
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
	if button == "RightButton" and model:GetParent().transmogType ~= LE_TRANSMOG_TYPE_ILLUSION then
		if not DropDownList1:IsShown() then
			 -- force show dropdown
			WardrobeModelRightClickDropDown.activeFrame = model
			ToggleDropDownMenu(1, nil, WardrobeModelRightClickDropDown, model, -6, -3)
		end

		local setID = (model.visualInfo and model.visualInfo.visualID ) or model.setID
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
						addon.QueueForTransmog(type, setID, name)
					 end,
				})

			variantTarget, variantType, match, matchType = addon.SelectedVariant(setID)
		end

		UIDropDownMenu_AddSeparator()
		local isHidden = addon.chardb.profile[type][setID] 
		UIDropDownMenu_AddButton({
			notCheckable = true,
			text = isHidden and SHOW or HIDE,
			func = function() addon.ToggleHidden(model, isHidden) end,
		})


		local collected = (model.visualInfo and model.visualInfo.isCollected ) or C_TransmogSets.IsBaseSetCollected(setID) or model.setCollected
		--Collection List Right Click options
		local isInList = match or addon.chardb.profile.collectionList[type][setID] 


		if  type  == "set" or ((isInList and collected ) or not collected )then --(type == "item" and not (model.visualInfo and model.visualInfo.isCollected )) or type == "set" or type == "extraset" then 
			local targetSet = match or variantTarget or setID
			local targetText = match and " - "..matchType or variantTarget and " - "..variantType or ""
			UIDropDownMenu_AddSeparator()
			local isInList = addon.chardb.profile.collectionList[type][targetSet] 
			UIDropDownMenu_AddButton({
				notCheckable = true,
				text = isInList and L["Remove to Collection List"]..targetText or L["Add to Collection List"]..targetText,
				func = function() 
							addon.CollectionList:UpdateList(type, targetSet, not isInList )
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
				local button = buttons[i];
				button:HookScript("OnMouseUp", function(...) UI:DefaultDropdown_Update(...) end)

				f = CreateFrame("frame", nil, button, "BetterWardrobeIconsTemplate")
				f.Hidden:ClearAllPoints()
				f.Hidden:SetPoint("CENTER", button.Icon, "CENTER", 0, 0)
				f.Collection:ClearAllPoints()
				f.Collection:SetPoint("BOTTOMRIGHT", button.Icon, "BOTTOMRIGHT", 2, -3)
			end
		end
end
