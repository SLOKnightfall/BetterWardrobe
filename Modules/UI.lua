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

local Wardrobe = WardrobeCollectionFrame.ItemsCollectionFrame

local db, active
local FileData
local SortOrder


local dropdownOrder = {LE_DEFAULT, LE_ALPHABETIC, LE_APPEARANCE, LE_COLOR, LE_EXPANSION, LE_ITEM_SOURCE}
local locationDrowpDown = addon.Globals.locationDrowpDown

--= {INVTYPE_HEAD, INVTYPE_SHOULDER, INVTYPE_CLOAK, INVTYPE_CHEST, INVTYPE_WAIST, INVTYPE_LEGS, INVTYPE_FEET, INVTYPE_WRIST, INVTYPE_HAND}
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
				--Wardrobe:OnShow()
						Wardrobe:RefreshVisualsList()
		Wardrobe:UpdateItems()
		Wardrobe:UpdateWeaponDropDown()
			elseif tabID == 2 then
				WardrobeCollectionFrame.SetsCollectionFrame:OnSearchUpdate()
				WardrobeCollectionFrame.SetsTransmogFrame:OnSearchUpdate()
			elseif tabID == 3 then
				BW_SetsCollectionFrame:OnSearchUpdate()
				BW_SetsTransmogFrame:OnSearchUpdate()
			end
		end
		
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


function BW_WardrobeFilterLocationDropDown_OnLoad(self)
	UIDropDownMenu_Initialize(self, UI.LocationDropdowns_Initialize, "MENU")
end


addon.includeLocation = {}
for i, location in pairs(locationDrowpDown) do
	addon.includeLocation[i] = true
end

function UI.LocationDropdowns_Initialize(self, level)
	local refreshLevel = 1
	local info = UIDropDownMenu_CreateInfo()
	info.keepShownOnClick = true
	
	if level == 1 then
		info.hasArrow = true
		info.isNotRadio = true
		info.notCheckable = true

		info.text = "Include:"
		info.value = 1
		UIDropDownMenu_AddButton(info, level)

		info.hasArrow = true
		info.isNotRadio = true
		info.notCheckable = true
		info.checked = false

		info.text = "Cuttoff:"
		info.value = 2
		UIDropDownMenu_AddButton(info, level)

	elseif level == 2  and UIDROPDOWNMENU_MENU_VALUE == 1 then
		info.hasArrow = false
		info.isNotRadio = true
		info.notCheckable = true
		local refreshLevel = 2

		info.text = CHECK_ALL
		info.func = function()
						for i in pairs(locationDrowpDown) do
							addon.includeLocation[i] = true
						end
						WardrobeCollectionFrame.SetsTransmogFrame:OnSearchUpdate()
						BW_SetsTransmogFrame:OnSearchUpdate()
						UIDropDownMenu_Refresh(BW_LocationFilterDropDown, 1, refreshLevel)
					end
		UIDropDownMenu_AddButton(info, level)

		info.text = UNCHECK_ALL
		info.func = function()
						for i in pairs(locationDrowpDown) do
							addon.includeLocation[i] = false
						end
						WardrobeCollectionFrame.SetsTransmogFrame:OnSearchUpdate()
						BW_SetsTransmogFrame:OnSearchUpdate()
						UIDropDownMenu_Refresh(BW_LocationFilterDropDown, 1, refreshLevel)
					end
		UIDropDownMenu_AddButton(info, level)
		
		for index, id in pairs(locationDrowpDown) do
			if index ~= 21 then --Skip "robe" type
				info.notCheckable = false
				info.text = id
				info.func = function(_, _, _, value)
							addon.includeLocation[index] = value

							if index == 6 then
								addon.includeLocation[21] = value
							end

							UIDropDownMenu_Refresh(BW_LocationFilterDropDown, 1, 1)
							WardrobeCollectionFrame.SetsTransmogFrame:OnSearchUpdate()
							BW_SetsTransmogFrame:OnSearchUpdate()
						end
				info.checked = function() return addon.includeLocation[index] end
				UIDropDownMenu_AddButton(info, level)
			end
		end

	elseif level == 2 and UIDROPDOWNMENU_MENU_VALUE == 2 then
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
					UIDropDownMenu_Refresh(BW_LocationFilterDropDown, 1, 1)
					WardrobeCollectionFrame.SetsTransmogFrame:OnSearchUpdate()
					BW_SetsTransmogFrame:OnSearchUpdate()
				end
			info.checked = 	function() return info.value == addon.Profile.PartialLimit end
			UIDropDownMenu_AddButton(info, level)
		end
	end
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

local function RefreshLists()
	local tabID = addon.GetTab()

			if tabID == 2 then
				WardrobeCollectionFrame.SetsCollectionFrame:OnSearchUpdate()
				--WardrobeCollectionFrame.SetsTransmogFrame:OnSearchUpdate()
			elseif tabID == 3 then
				BW_SetsCollectionFrame:OnSearchUpdate()
			--	BW_SetsTransmogFrame:OnSearchUpdate()
			end
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
		addon:InitTables()
	end

	local tab1 = (tabID == TAB_ITEMS)
	local tab2 = (tabID == TAB_SETS)
	local tab3 = (tabID == TAB_EXTRASETS)
	local tab4 = (tabID == TAB_SAVED_SETS)

	WardrobeCollectionFrame.ItemsCollectionFrame:SetShown(tab1)
	WardrobeCollectionFrame.SetsCollectionFrame:SetShown(tab2 and not atTransmogrifier)
	WardrobeCollectionFrame.SetsTransmogFrame:SetShown(tab2 and atTransmogrifier)
	BW_WardrobeCollectionFrame.BW_SetsCollectionFrame:Hide()
	BW_WardrobeCollectionFrame.BW_SetsTransmogFrame:Hide()
	BW_WardrobeCollectionFrame.BW_SetsCollectionFrame:SetShown((tab3 or tab4) and not atTransmogrifier)
	BW_WardrobeCollectionFrame.BW_SetsTransmogFrame:SetShown((tab3 or tab4) and atTransmogrifier)

	BW_WardrobeToggle:SetShown(tab2 or tab3 or (tab4 and not atTransmogrifier))
	BW_WardrobeToggle.VisualMode = false

	local searchBox_X = ((tab1 or ((tab2 or tab3 or tab4) and atTransmogrifier)) and -107) or 19
	local searchBox_Y = ((tab1 or ((tab2 or tab3 or tab4) and atTransmogrifier)) and -35) or -69
	local searchBox_Anchor = ((tab1 or ((tab2 or tab3 or tab4) and atTransmogrifier)) and "TOPRIGHT") or "TOPLEFT"

	WardrobeCollectionFrame.searchBox:ClearAllPoints()
	WardrobeCollectionFrame.searchBox:SetEnabled(tab1 and WardrobeCollectionFrame.ItemsCollectionFrame.transmogType == LE_TRANSMOG_TYPE_APPEARANCE or tab2 or tab3)
	WardrobeCollectionFrame.searchBox:SetPoint(searchBox_Anchor, searchBox_X, searchBox_Y)
	WardrobeCollectionFrame.searchBox:SetWidth(((tab2 or tab3 or tab4) and not atTransmogrifier and 145) or 105)
	--WardrobeCollectionFrame.searchBox:SetShown(not tab4)

	WardrobeCollectionFrame.FilterButton:SetShown(tab2 and not atTransmogrifier)
	WardrobeCollectionFrame.FilterButton:SetEnabled(tab1 and WardrobeCollectionFrame.ItemsCollectionFrame.transmogType == LE_TRANSMOG_TYPE_APPEARANCE or tab2)
	--WardrobeCollectionFrame.progressBar:SetShown(not tab4)
	BW_CollectionListButton:SetShown(tab1 and not atTransmogrifier)

	BW_WardrobeCollectionFrame.FilterButton:SetShown((tab3 or tab4 ) and not atTransmogrifier)
	BW_WardrobeCollectionFrame.FilterButton:SetEnabled(tab3)

	BW_WardrobeCollectionFrame.TransmogOptionsButton:SetShown((tab2 or tab3) and atTransmogrifier and addon.Profile.ShowIncomplete)
	

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
		local savedCount = #addon.GetSavedList()
		WardrobeCollectionFrame_UpdateProgressBar(savedCount, savedCount)
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
		local aCtrlKeyIsDown = IsControlKeyDown()

		if aCtrlKeyIsDown then
				addon.Profile.ShowHidden = not addon.Profile.ShowHidden
				WardrobeCollectionFrame.SetsTransmogFrame:OnSearchUpdate()
				BW_SetsTransmogFrame:OnSearchUpdate()
				WardrobeCollectionFrame.SetsCollectionFrame:OnSearchUpdate()
				BW_SetsCollectionFrame:OnSearchUpdate()
				return
		end

		local atTransmogrifier = WardrobeFrame_IsAtTransmogrifier()
		if (atTransmogrifier) then
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

			elseif tab == 3 or tab == 4 then
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

				if tab == 4 then
					local savedCount = #addon.GetSavedList()
					WardrobeCollectionFrame_UpdateProgressBar(savedCount, savedCount)
				end
			end
		end
	end)
	
	b:SetScript("OnHide", function(self)
			--BW_WardrobeCollectionFrame.BW_SetsTransmogFrame:Hide()
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
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		if name then 	
			GameTooltip:SetText(L["Load Set: %s"]:format(name))
		else
			GameTooltip:SetText(L["Load Set: %s"]:format(L["None Selected"]))
		end
	end)
end


function addon.Init:BuildUI()
	UI.SortDropdowns_Initialize()
	UI.LocationDropdowns_Initialize()
	CreateVisualViewButton()
	UI.ExtendTransmogView()
--BW_WardrobeCollectionFrame:GetFrameLevel()
	WardrobeCollectionFrame.searchBox:SetFrameLevel(BW_WardrobeCollectionFrame:GetFrameLevel()+10)
	WardrobeCollectionFrame.FilterButton:SetFrameLevel(BW_WardrobeCollectionFrame:GetFrameLevel()+10)
	BW_WardrobeCollectionFrame.FilterButton:SetFrameLevel(BW_WardrobeCollectionFrame:GetFrameLevel()+10)
	BW_WardrobeCollectionFrame.FilterButton:SetPoint("TOPLEFT", WardrobeCollectionFrame.FilterButton, "TOPLEFT")

 	UI.BuildLoadQueueButton()
	UI.DefaultButtons_Update()

	hooksecurefunc(Wardrobe, "UpdateWeaponDropDown", PositionDropDown)
end


-- ***** FILTER

function BW_WardrobeFilterDropDown_OnLoad(self)
	UIDropDownMenu_Initialize(self, UI.FilterDropDown_InitializeItems, "MENU")
end



local FILTER_SOURCES = addon.Globals.FILTER_SOURCES
local EXPANSIONS = addon.Globals.EXPANSIONS


local filterCollected = {}
local missingSelection = {}
local filterSelection = {}
local xpacSelection = {}
addon.filterCollected = filterCollected
addon.xpacSelection = xpacSelection
addon.filterSelection = filterSelection
addon.missingSelection = missingSelection

function addon:InitTables()
	filterCollected = {true, true}

	for i = 1, 8 do
		filterSelection[i] = true
	end

	for i = 1, 8 do
		xpacSelection[i] = true
	end
end

addon:InitTables()

addon.filterCollected = filterCollected
addon.xpacSelection = xpacSelection
addon.filterSelection = filterSelection
addon.missingSelection = missingSelection
function UI:FilterDropDown_InitializeItems(level)
	if (not WardrobeCollectionFrame.activeFrame) then
		return
	end

	local info = UIDropDownMenu_CreateInfo()
	info.keepShownOnClick = true
	local atTransmogrifier = WardrobeFrame_IsAtTransmogrifier()

	if level == 1 then
		local refreshLevel = 1
		info.text = COLLECTED
		info.func = function(_, _, _, value)
						filterCollected[1] = value
						RefreshLists()
						UIDropDownMenu_Refresh(BW_WardrobeFilterDropDown, 1, refreshLevel)
					end
		info.checked = 	function() return filterCollected[1] end
		info.isNotRadio = true
		UIDropDownMenu_AddButton(info, level)

		info.text = NOT_COLLECTED
		info.func = function(_, _, _, value)
						filterCollected[2] =  value
						RefreshLists()
						UIDropDownMenu_Refresh(BW_WardrobeFilterDropDown, 1, refreshLevel)
					end
		info.checked = 	function() return filterCollected[2] end
		info.isNotRadio = true

		UIDropDownMenu_AddButton(info, level)
		UIDropDownMenu_AddSeparator()

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

		info.text = "Missing:"
		info.value = 3
		UIDropDownMenu_AddButton(info, level)

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
						RefreshLists()
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
						RefreshLists()
						UIDropDownMenu_Refresh(BW_WardrobeFilterDropDown, 1, refreshLevel)
					end
		UIDropDownMenu_AddButton(info, level)
		UIDropDownMenu_AddSeparator(level)

		info.notCheckable = false

		local numSources = #FILTER_SOURCES --C_TransmogCollection.GetNumTransmogSources()
		for i = 1, numSources do
			--tinsert(filterSelection,true)
			info.text = FILTER_SOURCES[i]
				info.func = function(_, _, _, value)
					filterSelection[i] = value
					RefreshLists()
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
						RefreshLists()
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
						RefreshLists()
						UIDropDownMenu_Refresh(BW_WardrobeFilterDropDown, 1, refreshLevel)
					end
		UIDropDownMenu_AddButton(info, level)
		UIDropDownMenu_AddSeparator(level)

		info.notCheckable = false
		for i = 1, #EXPANSIONS do
			info.text = EXPANSIONS[i]
				info.func = function(_, _, _, value)
					xpacSelection[i] = value
					RefreshLists()
				end
				info.checked = 	function() return xpacSelection[i] end
			UIDropDownMenu_AddButton(info, level)
		end

	elseif level == 2  and UIDROPDOWNMENU_MENU_VALUE == 3 then
		info.hasArrow = false
		info.isNotRadio = true
		info.notCheckable = true
		local refreshLevel = 2

		info.text = CHECK_ALL
		info.func = function()
						for i in pairs(locationDrowpDown) do
							missingSelection[i] = true
						end
						RefreshLists()
						UIDropDownMenu_Refresh(BW_WardrobeFilterDropDown, 1, refreshLevel)
					end
		UIDropDownMenu_AddButton(info, level)

		info.text = UNCHECK_ALL
		info.func = function()
						for i in pairs(locationDrowpDown) do
							missingSelection[i] = false
						end
						RefreshLists()
						UIDropDownMenu_Refresh(BW_WardrobeFilterDropDown, 1, refreshLevel)
					end
		UIDropDownMenu_AddButton(info, level)
		UIDropDownMenu_AddSeparator(level)

		for index, id in pairs(locationDrowpDown) do
			if index ~= 21 then --Skip "robe" type
				info.text = id
				info.notCheckable = false
				info.func = function(_, _, _, value)
							missingSelection[index] = value

							if index == 6 then
								missingSelection[21] = value
							end

							UIDropDownMenu_Refresh(BW_WardrobeFilterDropDown, 1, refreshLevel)
							RefreshLists()
						end
				info.checked = function() return missingSelection[index] end
				UIDropDownMenu_AddButton(info, level)
			end
		end
	end
--end
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

	if button == "RightButton" and model:GetParent().transmogType ~= LE_TRANSMOG_TYPE_ILLUSION then
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

			variantTarget, variantType, match, matchType = addon.Sets:SelectedVariant(setID)
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


function UI:DefaultFilterDropdown_Update(model, button)
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