local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local UI = {}

function addon.Init:BuildTransmogVendorUI()
	UI:CreateButtons()
	UI:CreateDropDown()
	--UI.OptionsDropDown_Initialize()
	UI.ExtendTransmogView()
end


function UI:CreateDropDown()
	--Frame Mixin functionaly in SavedOutfits.lua file
	--BW_WardrobeOutfitDropDown = CreateFrame("Frame", "BW_WardrobeOutfitDropDown", WardrobeTransmogFrame, "BW_WardrobeOutfitDropDownTemplate")
	local f = L_Create_UIDropDownMenu("BW_WardrobeOutfitDropDown", WardrobeTransmogFrame)
--f:SetPoint("CENTER")
--f:SetSize(100,22)
	f.width = 163
	f.minMenuStringWidth = 127
	f.maxMenuStringWidth = 190

	f:SetPoint("TOPLEFT", -14, -28)
	Mixin(f, WardrobeOutfitDropDownMixin)
	Mixin(f, BW_WardrobeOutfitMixin)
	f.SaveButton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.SaveButton:SetSize(88, 22)
	local button = _G[f:GetName().."Button"]
	f.SaveButton:SetPoint("LEFT", button, "RIGHT", 3, 0)
	f.SaveButton:SetScript("OnClick", function(self)
					PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
					local dropDown = self:GetParent();
					dropDown:CheckOutfitForSave(L_UIDropDownMenu_GetText(dropDown));
				end)
	f.SaveButton:SetText(SAVE)
	f:SetScript("OnLoad", f.OnLoad)
	f:OnLoad()
	f:SetScript("OnEvent", f.OnEvent)
	f:SetScript("OnShow", f.OnShow)
	f:SetScript("OnHide", f.OnHide)
	BW_WardrobeOutfitDropDown = f
end


--Creates the various buttons used on the Collection Journal
function UI:CreateButtons()
	--Load Queue Button
	local BW_LoadQueueButton = CreateFrame("Button", "BW_LoadQueueButton", WardrobeTransmogFrame, "BetterWardrobeButtonTemplate")
	BW_LoadQueueButton.Icon:SetTexture("Interface\\Buttons\\UI-OptionsButton")
	BW_LoadQueueButton:SetPoint("TOPLEFT", WardrobeOutfitDropDown, "TOPRIGHT", 80 ,-5)
	BW_LoadQueueButton:SetScript("OnClick", function(self) BW_TransmogVendorExportButton_OnClick(self) end)
	BW_LoadQueueButton:SetScript("OnEnter", function(self) BW_DressingRoomButton_OnEnter(self, "Import") end)

	--Randomize Button, Mixin defined in Randomizer.lua
	local BW_RandomizeButton = CreateFrame("Button", "BW_RandomizeButton", WardrobeTransmogFrame, "BetterWardrobeButtonTemplate")
	BW_RandomizeButton.Icon:SetTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Up")
	Mixin(BW_RandomizeButton, BW_RandomizeButtonMixin)
	BW_RandomizeButton:SetPoint("TOPLEFT", BW_LoadQueueButton, "TOPRIGHT" , 0, 0)
	BW_RandomizeButton:SetScript("OnMouseUp", BW_RandomizeButton.OnMouseUp)
	BW_RandomizeButton:SetScript("OnMouseDown", BW_RandomizeButton.OnMouseDown)
	BW_RandomizeButton:SetScript("OnEnter", BW_RandomizeButton.OnEnter)

	local BW_SlotHideButton = CreateFrame("Button", "BW_SlotHideButton", WardrobeTransmogFrame, "BetterWardrobeButtonTemplate")
	BW_SlotHideButton:SetScript("OnEnter", function(self) BW_DressingRoomButton_OnEnter(self, "HideSlot") end)



	BW_SlotHideButton.Icon:SetTexture("Interface\\PvPRankBadges\\PvPRank12")
	--Mixin(BW_SlotHideButton, BW_SlotHideButtonMixin)
	BW_SlotHideButton:SetPoint("TOPLEFT", BW_RandomizeButton, "TOPRIGHT" , 0, 0)
	BW_SlotHideButton:SetScript("OnClick", function(self) UI:HideSlotMenu_OnClick(self) end)

	--BW_SlotHideButton:SetScript("OnMouseUp", BW_SlotHideButton.OnMouseUp)
	--BW_SlotHideButton:SetScript("OnMouseDown", BW_SlotHideButton.OnMouseDown)
	--BW_SlotHideButton:SetScript("OnEnter", BW_SlotHideButton.OnEnter)
end


function UI:HideSlotMenu_OnClick(parent)
	local Profile = addon.Profile
	local armor = addon.Globals.EmptyArmor
	local name  = addon.QueueList[3]
	local contextMenuData = {{ text = L["Select Slot to Hide"], isTitle = true, notCheckable = true},}
	local profile = addon.setdb.profile.autoHideSlot
	for i = 1, 19 do 
		if armor[i] then 
			local menu = {
				text = _G[addon.Globals.INVENTORY_SLOT_NAMES[i]],
				func = function (self, arg1, arg2, value)
					profile[i] = not profile[i]
				end,
				isNotRadio = true,
				notCheckable = false,
				checked = function() return profile[i] end,
				keepShownOnClick = true, 
			}
			tinsert (contextMenuData, menu)

		end
	end

	--table.sort(contextMenuData, function(a,b) return a.index<b.index end)

	addon.ContextMenu:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
	L_EasyMenu(contextMenuData, addon.ContextMenu, "cursor", 0, 0, "MENU")
end



--[[function UI.OptionsDropDown_Initialize(self)
	local  f = addon.Frame:Create("SimpleGroup")
	--UI.SavedSetDropDownFrame = f
	f.frame:SetParent("BW_WardrobeCollectionFrame")
	f:SetWidth(87)--, 22)
	f:SetHeight(22)

	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", "BW_SortDropDown", "TOPLEFT")
	local list = {}

	for name in pairs(addon.setdb.global.sets)do
		tinsert(list, name)
	end

	local dropdown = addon.Frame:Create("Dropdown")
	dropdown:SetWidth(175)--, 22)
	--dropdown:SetHeight(22)
	f:AddChild(dropdown)
	dropdown:SetList(list)

	for i, name in ipairs(list) do
		if name == addon.setdb:GetCurrentProfile() then
			dropdown:SetValue(i)
			break
		end
	end
	
	dropdown:SetCallback("OnValueChanged", function(widget) 
		local value = widget.list[widget.value]
		local name = UnitName("player")
		local realm = GetRealmName()

		if value ~= addon.setdb:GetCurrentProfile() then 
			addon.SelecteSavedList = widget.list[widget.value]
		else
			addon.SelecteSavedList = false
		end
		BW_WardrobeCollectionFrame_SetTab(2)
		BW_WardrobeCollectionFrame_SetTab(4)
		addon.savedSetCache = nil
	end)
end]]



function BW_TransmogOptionsButton_OnEnter(self)
	if not addon.Profile.ShowIncomplete then 
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(L["Requires 'Show Incomplete Sets' Enabled"])
		GameTooltip:Show()
	end
end

function BW_WardrobeTransmogVendorOptionsDropDown_OnLoad(self)
	L_UIDropDownMenu_Initialize(self, UI.OptionsDropDown_Initialize, "MENU")
end

local dropdownOrder = {LE_DEFAULT, LE_ALPHABETIC, LE_APPEARANCE, LE_COLOR, LE_EXPANSION, LE_ITEM_SOURCE}
local locationDrowpDown = addon.Globals.locationDrowpDown

addon.includeLocation = {}
for i, location in pairs(locationDrowpDown) do
	addon.includeLocation[i] = true
end


function UI:OptionsDropDown_Initialize(level)
	local refreshLevel = 1
	local info = L_UIDropDownMenu_CreateInfo()
	info.keepShownOnClick = true
	
	if level == 1 then
		info.hasArrow = true
		info.isNotRadio = true
		info.notCheckable = true

		info.text = "Include:"
		info.value = 1
		L_UIDropDownMenu_AddButton(info, level)

		info.hasArrow = true
		info.isNotRadio = true
		info.notCheckable = true
		info.checked = false

		info.text = "Cuttoff:"
		info.value = 2
		L_UIDropDownMenu_AddButton(info, level)

	elseif level == 2  and L_UIDROPDOWNMENU_MENU_VALUE == 1 then
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
						L_UIDropDownMenu_Refresh(BW_LocationFilterDropDown, 1, refreshLevel)
					end
		L_UIDropDownMenu_AddButton(info, level)

		info.text = UNCHECK_ALL
		info.func = function()
						for i in pairs(locationDrowpDown) do
							addon.includeLocation[i] = false
						end
						WardrobeCollectionFrame.SetsTransmogFrame:OnSearchUpdate()
						BW_SetsTransmogFrame:OnSearchUpdate()
						L_UIDropDownMenu_Refresh(BW_LocationFilterDropDown, 1, refreshLevel)
					end
		L_UIDropDownMenu_AddButton(info, level)
		
		for index, id in pairs(locationDrowpDown) do
			if index ~= 21 then --Skip "robe" type
				info.notCheckable = false
				info.text = id
				info.func = function(_, _, _, value)
							addon.includeLocation[index] = value

							if index == 6 then
								addon.includeLocation[21] = value
							end

							L_UIDropDownMenu_Refresh(BW_LocationFilterDropDown, 1, 1)
							WardrobeCollectionFrame.SetsTransmogFrame:OnSearchUpdate()
							BW_SetsTransmogFrame:OnSearchUpdate()
						end
				info.checked = function() return addon.includeLocation[index] end
				L_UIDropDownMenu_AddButton(info, level)
			end
		end

	elseif level == 2 and L_UIDROPDOWNMENU_MENU_VALUE == 2 then
		local refreshLevel = 2
		info.notCheckable = false
		info.keepShownOnClick = false
		for i = 1, 7 do
			local info =L_UIDropDownMenu_CreateInfo()
			--tinsert(xpacSelection,true)
			info.text = i
			info.value = i
				info.func = function(a, b, c, value)
					addon.Profile.PartialLimit = info.value
					L_UIDropDownMenu_Refresh(BW_LocationFilterDropDown, 1, 1)
					WardrobeCollectionFrame.SetsTransmogFrame:OnSearchUpdate()
					BW_SetsTransmogFrame:OnSearchUpdate()
				end
			info.checked = 	function() return info.value == addon.Profile.PartialLimit end
			L_UIDropDownMenu_AddButton(info, level)
		end
	end
end


-- Base Transmog Sets Window Upates
function UI.ExtendTransmogView(reset)
	if WardrobeFrame and WardrobeFrame.extended then return end

	--if not addon.Profile.LargeTransmogArea or not addon.Profile.ExtraLargeTransmogArea then return end
	local scale = 1
	BW_LoadQueueButton:ClearAllPoints()
	BW_LoadQueueButton:SetPoint("TOPLEFT", BW_WardrobeOutfitDropDown.SaveButton, "TOPRIGHT", 5, 0)

	if addon.Profile.ExtraLargeTransmogArea then
		scale = 1.25
		WardrobeFrame:SetWidth(1650)
		WardrobeFrame:SetClampedToScreen(true)
		WardrobeFrame:SetHeight(UIParent:GetHeight() -25);

		WardrobeTransmogFrame:SetWidth(950);
		WardrobeTransmogFrame:SetHeight(WardrobeFrame:GetHeight() -90);
		WardrobeTransmogFrame:SetPoint("TOPLEFT", WardrobeFrame, 4, -60)

		WardrobeTransmogFrame.ModelScene:ClearAllPoints()
		WardrobeTransmogFrame.ModelScene:SetPoint("TOPLEFT", WardrobeTransmogFrame, 25, -20)
		WardrobeTransmogFrame.ModelScene:SetPoint("BOTTOMRIGHT", WardrobeTransmogFrame, -25, 20)
		WardrobeTransmogFrame.Inset.BG:SetAllPoints()

		WardrobeTransmogFrame.ModelScene.HeadButton:ClearAllPoints()
		WardrobeTransmogFrame.ModelScene.HeadButton:SetPoint("TOP", WardrobeTransmogFrame.ModelScene, "TOP", -348, -41)
		WardrobeTransmogFrame.ModelScene.HandsButton:ClearAllPoints()
		WardrobeTransmogFrame.ModelScene.HandsButton:SetPoint("TOP", WardrobeTransmogFrame.ModelScene, "TOP", 345, -118)

		WardrobeTransmogFrame.ModelScene.MainHandButton:ClearAllPoints()
		WardrobeTransmogFrame.ModelScene.MainHandButton:SetPoint("BOTTOM", WardrobeTransmogFrame.ModelScene, "BOTTOM", -26, 15)
		WardrobeTransmogFrame.ModelScene.SecondaryHandButton:ClearAllPoints()
		WardrobeTransmogFrame.ModelScene.SecondaryHandButton:SetPoint("BOTTOM", WardrobeTransmogFrame.ModelScene, "BOTTOM", 27, 15)
		WardrobeTransmogFrame.ModelScene.MainHandEnchantButton:ClearAllPoints()
		WardrobeTransmogFrame.ModelScene.MainHandEnchantButton:SetPoint("BOTTOM", WardrobeTransmogFrame.ModelScene.MainHandButton, "BOTTOM", 0, -20)
		WardrobeTransmogFrame.ModelScene.SecondaryHandEnchantButton:ClearAllPoints()
		WardrobeTransmogFrame.ModelScene.SecondaryHandEnchantButton:SetPoint("BOTTOM", WardrobeTransmogFrame.ModelScene.SecondaryHandButton, "BOTTOM", 0, -20)

		WardrobeTransmogFrame.ModelScene.ClearAllPendingButton:SetPoint("TOPRIGHT", WardrobeTransmogFrame, -20, -20)
		WardrobeTransmogFrame.ModelScene.ControlFrame:SetPoint("TOP", WardrobeTransmogFrame, "TOP", 0, -4)
		BW_WardrobeOutfitDropDown:ClearAllPoints()
		BW_WardrobeOutfitDropDown:SetPoint("TOPLEFT", WardrobeTransmogFrame, 35, 28)
		BW_LoadQueueButton:ClearAllPoints()
		BW_LoadQueueButton:SetPoint("TOPLEFT", BW_WardrobeOutfitDropDown, "TOPRIGHT", 85, -5)

		if UIPanelWindows["WardrobeFrame"] then 
		UIPanelWindows["WardrobeFrame"].width = 1280
		else 
			UIPanelWindows["WardrobeFrame"] ={ area = "left", pushable = 0,	width = 1280 };
		end
	elseif addon.Profile.LargeTransmogArea then 
		WardrobeFrame:SetWidth(1170)
		WardrobeFrame:SetHeight(606)
		WardrobeTransmogFrame:SetWidth(500)
		WardrobeTransmogFrame:SetHeight(495)
		WardrobeTransmogFrame:ClearAllPoints()
		WardrobeTransmogFrame:SetPoint("TOPLEFT", WardrobeFrame, 4, -60)

		WardrobeTransmogFrame.ModelScene:ClearAllPoints()
		WardrobeTransmogFrame.ModelScene:SetWidth(420)
		WardrobeTransmogFrame.ModelScene:SetHeight(420)
		WardrobeTransmogFrame.ModelScene:SetPoint("TOP", WardrobeTransmogFrame, "TOP", 0, -4)

		WardrobeTransmogFrame.Inset:SetWidth(494)
		WardrobeTransmogFrame.Inset:SetHeight(495)
		WardrobeTransmogFrame.Inset:ClearAllPoints()
		WardrobeTransmogFrame.Inset:SetAllPoints()
		WardrobeTransmogFrame.Inset.BG:ClearAllPoints()
		WardrobeTransmogFrame.Inset.BG:SetAllPoints()

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
		
		BW_WardrobeOutfitDropDown:ClearAllPoints()
		BW_WardrobeOutfitDropDown:SetPoint("TOPLEFT", WardrobeTransmogFrame, 35, 28)
		if UIPanelWindows["WardrobeFrame"] then 
			UIPanelWindows["WardrobeFrame"].width = 1170
		else 
			UIPanelWindows["WardrobeFrame"] ={ area = "left", pushable = 0,	width = 1170 };
		end
	else 		
		WardrobeFrame:SetWidth(965)
		WardrobeFrame:SetHeight(606)
		WardrobeTransmogFrame:SetWidth(300)
		WardrobeTransmogFrame:SetHeight(495)
		WardrobeTransmogFrame:ClearAllPoints()
		WardrobeTransmogFrame:SetPoint("TOPLEFT", WardrobeFrame, 4, -86)

		WardrobeTransmogFrame.ModelScene:ClearAllPoints()
		WardrobeTransmogFrame.ModelScene:SetWidth(294)
		WardrobeTransmogFrame.ModelScene:SetHeight(488)
		WardrobeTransmogFrame.ModelScene:SetPoint("TOPLEFT", WardrobeTransmogFrame, "TOPLEFT", 2, -4)

		WardrobeTransmogFrame.Inset:SetWidth(294)
		WardrobeTransmogFrame.Inset:SetHeight(494)
		WardrobeTransmogFrame.Inset:ClearAllPoints()
		WardrobeTransmogFrame.Inset:SetAllPoints()
		WardrobeTransmogFrame.Inset.BG:ClearAllPoints()
		WardrobeTransmogFrame.Inset.BG:SetAllPoints()

		WardrobeTransmogFrame.ModelScene.ClearAllPendingButton:ClearAllPoints()
		WardrobeTransmogFrame.ModelScene.ClearAllPendingButton:SetPoint("TOPRIGHT", WardrobeTransmogFrame.ModelScene, "TOPRIGHT", -5, -10)
		
		WardrobeTransmogFrame.ModelScene.HeadButton:ClearAllPoints()
		WardrobeTransmogFrame.ModelScene.HeadButton:SetPoint("TOP", WardrobeTransmogFrame.ModelScene, "TOP", -121, -41)
		WardrobeTransmogFrame.ModelScene.HandsButton:ClearAllPoints()
		WardrobeTransmogFrame.ModelScene.HandsButton:SetPoint("TOP", WardrobeTransmogFrame.ModelScene, "TOP", 123, -118)

		WardrobeTransmogFrame.ModelScene.MainHandButton:ClearAllPoints()
		WardrobeTransmogFrame.ModelScene.MainHandButton:SetPoint("BOTTOM", WardrobeTransmogFrame.ModelScene, "BOTTOM", -26, 45)
		WardrobeTransmogFrame.ModelScene.SecondaryHandButton:ClearAllPoints()
		WardrobeTransmogFrame.ModelScene.SecondaryHandButton:SetPoint("BOTTOM", WardrobeTransmogFrame.ModelScene, "BOTTOM", 27, 45)
		WardrobeTransmogFrame.ModelScene.MainHandEnchantButton:ClearAllPoints()
		WardrobeTransmogFrame.ModelScene.MainHandEnchantButton:SetPoint("BOTTOM", WardrobeTransmogFrame.ModelScene.MainHandButton, "BOTTOM", 0, -20)
		WardrobeTransmogFrame.ModelScene.SecondaryHandEnchantButton:ClearAllPoints()
		WardrobeTransmogFrame.ModelScene.SecondaryHandEnchantButton:SetPoint("BOTTOM", WardrobeTransmogFrame.ModelScene.SecondaryHandButton, "BOTTOM", 0, -20)

		BW_WardrobeOutfitDropDown:ClearAllPoints()
		BW_WardrobeOutfitDropDown:SetPoint("TOPLEFT", WardrobeTransmogFrame, -14, 28)

		BW_LoadQueueButton:ClearAllPoints()
		BW_LoadQueueButton:SetPoint("BOTTOMLEFT", BW_WardrobeOutfitDropDown.SaveButton, "TOPLEFT", 0, 5)

		if UIPanelWindows["WardrobeFrame"] then 
			UIPanelWindows["WardrobeFrame"].width = 965
		else 
			UIPanelWindows["WardrobeFrame"] ={ area = "left", pushable = 0,	width = 965 };
		end
	end

	for i, button in pairs(	WardrobeTransmogFrame.ModelScene.SlotButtons) do
		button:SetScale(scale);

	end
	WardrobeTransmogFrame.ModelScene.ControlFrame:SetScale(scale)
	WardrobeTransmogFrame.ModelScene.ClearAllPendingButton:SetScale(scale)

	UpdateUIPanelPositions()
	WardrobeFrame.extended = true
end
addon.ExtendTransmogView = UI.ExtendTransmogView



