local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

local LE_DEFAULT = 1
local LE_APPEARANCE = 2
local LE_ALPHABETIC = 3
local LE_ITEM_SOURCE = 6
local LE_EXPANSION = 5
local LE_COLOR = 4
local TAB_ITEMS = 1
local TAB_SETS = 2
local TAB_EXTRASETS = 3

local L = {
	[LE_DEFAULT] = DEFAULT,
	[LE_APPEARANCE] = APPEARANCE_LABEL,
	[LE_ALPHABETIC] = COMPACT_UNIT_FRAME_PROFILE_SORTBY_ALPHABETICAL,
	[LE_ITEM_SOURCE] = SOURCE:gsub("[:：]", ""),
	[LE_COLOR] = COLOR,
	[LE_EXPANSION] = "Expansion.."
}

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


local function OnItemUpdate()
	-- sort again when we are sure all items are cached. not the most efficient way to do this
	-- this event does not seem to fire for weapons or only when mouseovering a weapon appearance (?)
	if Wardrobe:IsVisible() and (db.sortDropdown == LE_ITEM_SOURCE) then
		--addon.Sort[db.sortDropdown](Wardrobe)
		addon.Sort[GetTab()][db.sortDropdown](Wardrobe)

		Wardrobe:UpdateItems()
	end
	
	if GameTooltip:IsShown() then
		-- when mouse scrolling the tooltip waits for uncached item info and gets refreshed
		--C_Timer.After(.01, UpdateMouseFocus)
	end
end


local f = CreateFrame("Frame")
local function InitSortDropdown()
	if not addon.sortDB or addon.sortDB.db_version < defaults.db_version then
		addon.sortDB = CopyTable(defaults)
	end

	db = addon.sortDB
	
	f:RegisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE")
	f:SetScript("OnEvent", OnItemUpdate)
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
		
		for _, id in pairs(dropdownOrder) do
			info.value, info.text = id, L[id]
			info.checked = (id == selectedValue)
			UIDropDownMenu_AddButton(info)
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

function BW_WardrobeCollectionFrame_OnLoad(self)
	WardrobeCollectionFrameTab1:Hide()
	WardrobeCollectionFrameTab2:Hide()
	PanelTemplates_SetNumTabs(self, 3);
	PanelTemplates_SetTab(self, TAB_ITEMS);
	PanelTemplates_ResizeTabsToFit(self, TABS_MAX_WIDTH);
	self.selectedCollectionTab = TAB_ITEMS;
	self.selectedTransmogTab = TAB_ITEMS;
end

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
	else
		WardrobeCollectionFrame.selectedCollectionTab = tabID
	end
	--addon.setDropdown(1)
	if ( tabID == TAB_ITEMS ) then
		WardrobeCollectionFrame.activeFrame = WardrobeCollectionFrame.ItemsCollectionFrame
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
		BW_WardrobeToggle:Hide()
		BW_SortDropDown:ClearAllPoints()


		if WardrobeFrame_IsAtTransmogrifier() then
			local _, isWeapon = C_TransmogCollection.GetCategoryInfo(WardrobeCollectionFrame.ItemsCollectionFrame:GetActiveCategory() or -1)
			BW_SortDropDown:SetPoint("TOPLEFT", WardrobeCollectionFrame.ItemsCollectionFrame.WeaponDropDown, "BOTTOMLEFT", 0, isWeapon and 55 or 32)
		else
			BW_SortDropDown:SetPoint("TOPLEFT", WardrobeCollectionFrame.ItemsCollectionFrame.WeaponDropDown, "BOTTOMLEFT", 0, LegionWardrobeY)
		end

	elseif ( tabID == TAB_SETS ) then
		WardrobeCollectionFrame.ItemsCollectionFrame:Hide()
		BW_WardrobeCollectionFrame.BW_SetsTransmogFrame:Hide()
		BW_WardrobeCollectionFrame.BW_SetsCollectionFrame:Hide()
		WardrobeCollectionFrame.searchBox:ClearAllPoints()
		WardrobeCollectionFrame.FilterButton:Show()
		BW_SortDropDown:ClearAllPoints()

		if ( atTransmogrifier )  then
			WardrobeCollectionFrame.activeFrame = WardrobeCollectionFrame.SetsTransmogFrame
			WardrobeCollectionFrame.searchBox:SetPoint("TOPRIGHT", -107, -35)
			WardrobeCollectionFrame.searchBox:SetWidth(115)
			WardrobeCollectionFrame.FilterButton:Hide()
			BW_SortDropDown:SetPoint("TOPRIGHT", WardrobeCollectionFrame.ItemsCollectionFrame, "TOPRIGHT", -27, -10)

		else
			WardrobeCollectionFrame.activeFrame = WardrobeCollectionFrame.SetsCollectionFrame
			WardrobeCollectionFrame.searchBox:SetPoint("TOPLEFT", 19, -69)
			WardrobeCollectionFrame.searchBox:SetWidth(145)
			WardrobeCollectionFrame.FilterButton:Show()
			WardrobeCollectionFrame.FilterButton:SetEnabled(true)
			BW_WardrobeToggle:Show()
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
		BW_SortDropDown:ClearAllPoints()


		if ( atTransmogrifier )  then
			WardrobeCollectionFrame.activeFrame = BW_WardrobeCollectionFrame.BW_SetsTransmogFrame
			WardrobeCollectionFrame.searchBox:SetPoint("TOPRIGHT", -107, -35)
			WardrobeCollectionFrame.searchBox:SetWidth(115)
			WardrobeCollectionFrame.FilterButton:Hide()
			BW_SortDropDown:SetPoint("TOPRIGHT", WardrobeCollectionFrame.ItemsCollectionFrame, "TOPRIGHT",-27, -10)

		else
			WardrobeCollectionFrame.activeFrame = BW_WardrobeCollectionFrame.BW_SetsCollectionFrame
			WardrobeCollectionFrame.searchBox:SetPoint("TOPLEFT", 19, -69)
			WardrobeCollectionFrame.searchBox:SetWidth(145)
			--WardrobeCollectionFrame.FilterButton:Show()
			--WardrobeCollectionFrame.FilterButton:SetEnabled(true)
			BW_WardrobeToggle:Show()
			BW_SortDropDown:SetPoint("TOPLEFT", BW_WardrobeToggle, "TOPRIGHT")

		end
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

		local atTransmogrifier = WardrobeFrame_IsAtTransmogrifier()
		local tab = WardrobeCollectionFrame.selectedCollectionTab

		if ( not atTransmogrifier ) then
			self.VisualMode = true
			if tab == 2 then 
				if WardrobeCollectionFrame.SetsCollectionFrame:IsShown() then
					WardrobeCollectionFrame.SetsTransmogFrame:Show()
					WardrobeCollectionFrame.SetsCollectionFrame:Hide()
				else
					WardrobeCollectionFrame.SetsTransmogFrame:Hide()
					WardrobeCollectionFrame.SetsCollectionFrame:Show()
				end
			elseif tab == 3 then 
				if BW_WardrobeCollectionFrame.BW_SetsCollectionFrame:IsShown() then
					BW_WardrobeCollectionFrame.BW_SetsTransmogFrame:Show()
					BW_WardrobeCollectionFrame.BW_SetsCollectionFrame:Hide()
				else
					BW_WardrobeCollectionFrame.BW_SetsTransmogFrame:Hide()
					BW_WardrobeCollectionFrame.BW_SetsCollectionFrame:Show()
				end
			end

		end
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


function addon.BuildUI()
	AddSetDetailFrames(WardrobeCollectionFrame.SetsTransmogFrame)
	AddSetDetailFrames(BW_SetsTransmogFrame)
	InitSortDropdown()
	CreateVisualViewButton()
	ExtendTransmogView()

	hooksecurefunc(Wardrobe, "UpdateWeaponDropDown", PositionDropDown )
end