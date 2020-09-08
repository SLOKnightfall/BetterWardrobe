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

local Wardrobe = WardrobeCollectionFrame.ItemsCollectionFrame

local db, active
local FileData
local SortOrder
		
local dropdownOrder = {LE_DEFAULT, LE_ALPHABETIC, LE_APPEARANCE, LE_COLOR, LE_EXPANSION, LE_ITEM_SOURCE }
local defaults = {
	db_version = 2,
	sortDropdown = LE_DEFAULT,
	reverse = false,
}

local LegionWardrobeY = IsAddOnLoaded("LegionWardrobe") and 55 or 5

local function GetTab()
	local atTransmogrifier = WardrobeFrame_IsAtTransmogrifier()
	local tabID

	if ( atTransmogrifier ) then
		tabID = WardrobeCollectionFrame.selectedTransmogTab

	else
		tabID = WardrobeCollectionFrame.selectedCollectionTab
	end

	return tabID, atTransmogrifier
end


local function UpdateMouseFocus()
	local focus = GetMouseFocus()
	if focus and focus:GetObjectType() == "DressUpModel" and focus:GetParent() == Wardrobe then
		focus:GetScript("OnEnter")(focus)
	end
end

local function OnItemUpdate()
	-- sort again when we are sure all items are cached. not the most efficient way to do this
	-- this event does not seem to fire for weapons or only when mouseovering a weapon appearance (?)
	if Wardrobe:IsVisible() and (db.sortDropdown == LE_ITEM_SOURCE) then
		--addon.Sort[db.sortDropdown](Wardrobe)
		--addon.Sort[GetTab()][db.sortDropdown](Wardrobe)

		--Wardrobe:UpdateItems()
	end
	
	if GameTooltip:IsShown() then
		-- when mouse scrolling the tooltip waits for uncached item info and gets refreshed
		C_Timer.After(.01, UpdateMouseFocus)
	end
end


local f = CreateFrame("Frame")
function UI.SortDropdowns_Initialize()
	if not addon.sortDB or addon.sortDB.db_version < defaults.db_version then
		addon.sortDB = CopyTable(defaults)
	end

	db = addon.sortDB
	
	f:RegisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE")
	--f:SetScript("OnEvent", OnItemUpdate)
	--local dropdown = CreateFrame("Frame", "BW_SortDropDown", WardrobeCollectionFrame, "UIDropDownMenuTemplate")
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
			local tabID = GetTab()
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
		
		local tabID = GetTab()
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
local function ExtendTransmogView()
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


local function InitTextFrames(frame, button, name, height)
		local frame = CreateFrame("Frame", nil, frame[button] )
        frame:SetHeight(height)
        frame:SetWidth(120)
        frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightMedium")
        frame.text:SetWidth(frame:GetWidth())
        frame.text:SetHeight(frame:GetHeight())
        frame.text:SetPoint("TOP", frame, "TOP", 0, 0)        
        frame.text:SetSize(frame:GetWidth(), frame:GetHeight())
        frame.text:SetJustifyV("CENTER")
        frame.text:SetJustifyH("CENTER")
        frame.text:SetText("--")
		return frame
end


local buttons = {"ModelR1C1","ModelR1C2","ModelR1C3","ModelR1C4","ModelR2C1","ModelR2C2","ModelR2C3","ModelR2C4"}
local function AddSetDetailFrames(frame)
	local frame1, frame2
	for i, button in ipairs(buttons) do

		frame1 = InitTextFrames(frame, button,"progress", 20)
        frame1:SetPoint("TOP", frame[button], "TOP", 0, 0)  
		frame[button].progress = frame1.text

		frame2 = InitTextFrames(frame, button,"setName", 90)
        frame2:SetPoint("BOTTOM", frame[button], "BOTTOM", 0, 0)  
		frame[button].setName = frame2.text
    end
end


--- Functionality to add 3rd tab to windows
local TAB_ITEMS = 1
local TAB_SETS = 2
local TAB_EXTRASETS = 3
local TABS_MAX_WIDTH = 185


function BW_WardrobeCollectionFrame_ClickTab(tab)
	BW_WardrobeCollectionFrame_SetTab(tab:GetID())
	PanelTemplates_ResizeTabsToFit(WardrobeCollectionFrame, TABS_MAX_WIDTH)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
end

--hooks into WardrobeCollectionFrame_SetTab
function BW_WardrobeCollectionFrame_SetTab(tabID)
	PanelTemplates_SetTab(BW_WardrobeCollectionFrame, tabID)
	local atTransmogrifier = WardrobeFrame_IsAtTransmogrifier()
	if ( atTransmogrifier ) then
		WardrobeCollectionFrame.selectedTransmogTab = tabID
	BW_WardrobeCollectionFrame.selectedTransmogTab = tabID

	else
		WardrobeCollectionFrame.selectedCollectionTab = tabID
		BW_WardrobeCollectionFrame.selectedCollectionTab = tabID

	end
	--addon.setDropdown(1)
	if ( tabID == TAB_ITEMS ) then
		WardrobeCollectionFrame.activeFrame = WardrobeCollectionFrame.ItemsCollectionFrame
		BW_WardrobeCollectionFrame.activeFrame = WardrobeCollectionFrame.ItemsCollectionFrame
		WardrobeCollectionFrame.ItemsCollectionFrame:Show()
		WardrobeCollectionFrame.SetsCollectionFrame:Hide()
		WardrobeCollectionFrame.SetsTransmogFrame:Hide()
		BW_WardrobeCollectionFrame.BW_SetsTransmogFrame:Hide()
		BW_WardrobeCollectionFrame.BW_SetsCollectionFrame:Hide()
		WardrobeCollectionFrame.searchBox:ClearAllPoints()
		WardrobeCollectionFrame.searchBox:SetPoint("TOPRIGHT", -107, -35)
		WardrobeCollectionFrame.searchBox:SetWidth(115)
		WardrobeCollectionFrame.searchBox:SetEnabled(WardrobeCollectionFrame.ItemsCollectionFrame.transmogType == LE_TRANSMOG_TYPE_APPEARANCE)
		WardrobeCollectionFrame.FilterButton:Show()
		WardrobeCollectionFrame.FilterButton:SetEnabled(WardrobeCollectionFrame.ItemsCollectionFrame.transmogType == LE_TRANSMOG_TYPE_APPEARANCE)
		BW_WardrobeCollectionFrame.FilterButton:Hide()
		BW_WardrobeToggle:Hide()
		BW_SortDropDown:ClearAllPoints()

		if WardrobeFrame_IsAtTransmogrifier() then
			local _, isWeapon = C_TransmogCollection.GetCategoryInfo(WardrobeCollectionFrame.ItemsCollectionFrame:GetActiveCategory() or -1)
			BW_SortDropDown:SetPoint("TOPLEFT", WardrobeCollectionFrame.ItemsCollectionFrame.WeaponDropDown, "BOTTOMLEFT", 0, isWeapon and 55 or 32)
		else
			BW_CollectionListButton:Show()
			BW_SortDropDown:SetPoint("TOPLEFT", WardrobeCollectionFrame.ItemsCollectionFrame.WeaponDropDown, "BOTTOMLEFT", 0, LegionWardrobeY)
		end

	elseif ( tabID == TAB_SETS ) then
		WardrobeCollectionFrame.ItemsCollectionFrame:Hide()
		BW_WardrobeCollectionFrame.BW_SetsTransmogFrame:Hide()
		BW_WardrobeCollectionFrame.BW_SetsCollectionFrame:Hide()
		WardrobeCollectionFrame.searchBox:ClearAllPoints()
		WardrobeCollectionFrame.FilterButton:Show()
		BW_WardrobeCollectionFrame.FilterButton:Hide()
		BW_SortDropDown:ClearAllPoints()
		BW_WardrobeToggle.VisualMode = false
		BW_WardrobeToggle:Show()
		BW_CollectionListButton:Hide()


		if ( atTransmogrifier )  then
			WardrobeCollectionFrame.activeFrame = WardrobeCollectionFrame.SetsTransmogFrame
			BW_WardrobeCollectionFrame.activeFrame = WardrobeCollectionFrame.SetsTransmogFrame
			WardrobeCollectionFrame.searchBox:SetPoint("TOPRIGHT", -107, -35)
			WardrobeCollectionFrame.searchBox:SetWidth(115)
			WardrobeCollectionFrame.FilterButton:Hide()
			BW_SortDropDown:SetPoint("TOPRIGHT", WardrobeCollectionFrame.ItemsCollectionFrame, "TOPRIGHT", -27, -10)

		else
			WardrobeCollectionFrame.activeFrame = WardrobeCollectionFrame.SetsCollectionFrame
			BW_WardrobeCollectionFrame.activeFrame = WardrobeCollectionFrame.SetsCollectionFrame
			WardrobeCollectionFrame.searchBox:SetPoint("TOPLEFT", 19, -69)
			WardrobeCollectionFrame.searchBox:SetWidth(145)
			WardrobeCollectionFrame.FilterButton:Show()
			WardrobeCollectionFrame.FilterButton:SetEnabled(true)
			BW_WardrobeCollectionFrame.FilterButton:Hide()
			
			BW_SortDropDown:SetPoint("TOPLEFT", BW_WardrobeToggle, "TOPRIGHT")
		end

		WardrobeCollectionFrame.searchBox:SetEnabled(true)
		WardrobeCollectionFrame.SetsCollectionFrame:SetShown(not atTransmogrifier)
		WardrobeCollectionFrame.SetsTransmogFrame:SetShown(atTransmogrifier)

	elseif ( tabID == TAB_EXTRASETS ) then
		WardrobeCollectionFrame.ItemsCollectionFrame:Hide()
		WardrobeCollectionFrame.SetsCollectionFrame:Hide()
		WardrobeCollectionFrame.SetsTransmogFrame:Hide()
		WardrobeCollectionFrame.searchBox:ClearAllPoints()
		WardrobeCollectionFrame.FilterButton:Hide()
		BW_WardrobeCollectionFrame.FilterButton:Show()
		BW_SortDropDown:ClearAllPoints()
		UIDropDownMenu_EnableDropDown(BW_SortDropDown)
		BW_WardrobeToggle.VisualMode = flase
		BW_WardrobeToggle:Show()
		BW_CollectionListButton:Hide()
					
		if ( atTransmogrifier )  then
			WardrobeCollectionFrame.activeFrame = BW_WardrobeCollectionFrame.BW_SetsTransmogFrame
			BW_WardrobeCollectionFrame.activeFrame = BW_WardrobeCollectionFrame.BW_SetsTransmogFrame
			WardrobeCollectionFrame.searchBox:SetPoint("TOPRIGHT", -107, -35)
			WardrobeCollectionFrame.searchBox:SetWidth(115)
			WardrobeCollectionFrame.FilterButton:Hide()
			BW_SortDropDown:SetPoint("TOPRIGHT", WardrobeCollectionFrame.ItemsCollectionFrame, "TOPRIGHT",-27, -10)

		else
			WardrobeCollectionFrame.activeFrame = BW_WardrobeCollectionFrame.BW_SetsCollectionFrame
			BW_WardrobeCollectionFrame.activeFrame = BW_WardrobeCollectionFrame.BW_SetsCollectionFrame
			WardrobeCollectionFrame.searchBox:SetPoint("TOPLEFT", 19, -69)
			WardrobeCollectionFrame.searchBox:SetWidth(145)
			--BW_WardrobeToggle:Show()
			BW_SortDropDown:SetPoint("TOPLEFT", BW_WardrobeToggle, "TOPRIGHT")

		end
		
		WardrobeCollectionFrame.searchBox:Show()
		WardrobeCollectionFrame.searchBox:SetEnabled(true)
		BW_WardrobeCollectionFrame.BW_SetsCollectionFrame:SetShown(not atTransmogrifier)
		BW_WardrobeCollectionFrame.BW_SetsTransmogFrame:SetShown(atTransmogrifier)
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


local function BuildLoadQueueButton()
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
	AddSetDetailFrames(WardrobeCollectionFrame.SetsTransmogFrame.ModelR1C1)
	AddSetDetailFrames(BW_SetsTransmogFrame)
	UI.SortDropdowns_Initialize()
	CreateVisualViewButton()
	ExtendTransmogView()
--BW_WardrobeCollectionFrame:GetFrameLevel()
	WardrobeCollectionFrame.searchBox:SetFrameLevel(BW_WardrobeCollectionFrame:GetFrameLevel()+10)
	WardrobeCollectionFrame.FilterButton:SetFrameLevel(BW_WardrobeCollectionFrame:GetFrameLevel()+10)
	BW_WardrobeCollectionFrame.FilterButton:SetFrameLevel(BW_WardrobeCollectionFrame:GetFrameLevel()+10)
	BW_WardrobeCollectionFrame.FilterButton:SetPoint("TOPLEFT", WardrobeCollectionFrame.FilterButton, "TOPLEFT")

 	BuildLoadQueueButton()
	UI.Buttons_Initialize()

	hooksecurefunc(Wardrobe, "UpdateWeaponDropDown", PositionDropDown )
end


-- ***** FILTER

function BW_WardrobeFilterDropDown_OnLoad(self)
	UIDropDownMenu_Initialize(self, BW_WardrobeFilterDropDown_Initialize, "MENU")
end

function BW_WardrobeFilterDropDown_Initialize(self, level)
	if ( not WardrobeCollectionFrame.activeFrame ) then
		return
	end

	BW_WardrobeFilterDropDown_InitializeItems(self, level)
end


local FILTER_SOURCES = {"Classic Set","Quest Set","Dunegon Set","Raid Recolor","Raid Lookalike","Garrison","Island Expidetion", "Warfronts"}
local EXPANSIONS = {"Classic", "Burning Crusade", "Wrath of the Litch Kink", "Cataclysm", "Mists", "WOD", "Legion", "BFA" }

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


function BW_WardrobeFilterDropDown_InitializeItems(self, level)
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

		info.text = "Xpac"
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


function addon.ToggleHidden(model, isHidden)
	local tabID = GetTab()
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
		local setInfo = C_TransmogSets.GetSetInfo(model.setID)
		local name = setInfo["name"]

		addon.chardb.profile.set[model.setID] = not isHidden and name
		--self:UpdateWardrobe()
		print(format("%s "..name, isHidden and "Unhiding" or "Hiding"))

	else
		local setInfo = addon.GetSetInfo(model.setID)
		local name = setInfo["name"]
		addon.chardb.profile.extraset[model.setID] = not isHidden and name
		print(format("%s "..name, isHidden and "Unhiding" or "Hiding"))
		BW_SetsCollectionFrame:OnSearchUpdate()
		BW_SetsTransmogFrame:OnSearchUpdate()

	end
			--self:UpdateWardrobe()
end



local tabType = {"item", "set", "extraset"}
---==== Hide Buttons

local function AddHideButton(model, button)
	if button == "RightButton" then
		if not DropDownList1:IsShown() then -- force show dropdown
			WardrobeModelRightClickDropDown.activeFrame = model
			ToggleDropDownMenu(1, nil, WardrobeModelRightClickDropDown, model, -6, -3)
		end

		local setID = (model.visualInfo and model.visualInfo.visualID ) or model.setID
		local type = tabType[GetTab()]
		if type == "set" then 
		UIDropDownMenu_AddSeparator()
		UIDropDownMenu_AddButton({
				notCheckable = true,
				text = L["Queue Transmog"],
				func = function() 
					local setInfo = C_TransmogSets.GetSetInfo(setID)
					local name = setInfo["name"]
					addon.QueueForTransmog(type, setID, name)
				 end,
			})
		end

		UIDropDownMenu_AddSeparator()
		local isHidden = addon.chardb.profile[type][setID] 
		UIDropDownMenu_AddButton({
			notCheckable = true,
			text = isHidden and SHOW or HIDE,
			func = function() addon.ToggleHidden(model, isHidden) end,
		})

		--Collection List Right Click options
		if (type == "item" and not (model.visualInfo and model.visualInfo.isCollected )) or type == "set" or type == "extraset" then 
			UIDropDownMenu_AddSeparator()
			local isInList = addon.chardb.profile.collectionList[type][setID] 
			UIDropDownMenu_AddButton({
				notCheckable = true,
				text = isInList and L["Remove to Collection List"] or L["Add to Collection List"],
				func = function() 
							addon.CollectionList:UpdateList(type, setID, not isInList )
					end,
			})
		end
	end
end

function UI.Buttons_Initialize()
		local Wardrobe = {WardrobeCollectionFrame.ItemsCollectionFrame, WardrobeCollectionFrame.SetsTransmogFrame}

		-- hook all models
		for _, frame in ipairs(Wardrobe) do
			for _, model in pairs(frame.Models) do
				model:HookScript("OnMouseDown", AddHideButton)
				local f = CreateFrame("frame", nil, model, "HideVisualTemplate")
				f = CreateFrame("frame", nil, model, "CollectionListTemplate")
			end
		end

		local buttons = WardrobeCollectionFrameScrollFrame.buttons
		for i = 1, #buttons do
			local button = buttons[i];
			local f = CreateFrame("frame", nil, button, "HideVisualTemplate")
			f.Icon:ClearAllPoints()
			f.Icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 5)
			button:HookScript("OnMouseUp", AddHideButton)

			f = CreateFrame("frame", nil, button, "CollectionListTemplate")
			f:ClearAllPoints()
			f:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT", -3, 0)
		end

		local buttons = BW_SetsCollectionFrameScrollFrame.buttons
		for i = 1, #buttons do
			local button = buttons[i];
			local f = CreateFrame("frame", nil, button, "HideVisualTemplate")
			f.Icon:ClearAllPoints()
			f.Icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)

			f = CreateFrame("frame", nil, button, "CollectionListTemplate")
			--f.Icon:SetSize(17,17)
			f:ClearAllPoints()
			f:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT", -3, 0)
		end
		   -- for i=1,CanIMogIt.NUM_WARDROBE_COLLECTION_BUTTONS do
       -- local frame = _G["BW_SetsCollectionFrameScrollFrameButton"..i]
      --  if frame and frame.CanIMogItOverlay and frame.setID then
          --  frame.CanIMogItOverlay:UpdateText()
       --end
   -- end
--end
		-- toggle for showing only hidden Appearances
		--local cb = CreateFrame("CheckButton", nil, Wardrobe, "UICheckButtonTemplate")
		--cb:SetPoint("TOPLEFT", Wardrobe.WeaponDropDown, "BOTTOMLEFT", 14, 5)
		--cb.text:SetText("Show hidden")
		--cb:SetScript("OnClick", function(btn)
			--showHidden = btn:GetChecked()
			--f:UpdateWardrobe()
		--end)



end




--INV_Artifact_tome01
