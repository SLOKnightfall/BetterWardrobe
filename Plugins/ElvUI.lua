--[[
	Elvui Plugin to reskin new/changed UI
]]

if not IsAddOnLoaded("ElvUI") then return end
local addonName, addon = ...

local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

local _G = _G
local select = select
local ipairs, pairs, unpack = ipairs, pairs, unpack

local CreateFrame = CreateFrame
local GetItemInfo = GetItemInfo
local hooksecurefunc = hooksecurefunc
local BAG_ITEM_QUALITY_COLORS = BAG_ITEM_QUALITY_COLORS
local GetItemQualityColor = GetItemQualityColor
local C_TransmogCollection_GetSourceInfo = C_TransmogCollection.GetSourceInfo

local MyPlugin = E:NewModule('addonName', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0') --Create a plugin within ElvUI and adopt AceHook-3.0, AceEvent-3.0 and AceTimer-3.0. We can make use of these later.
local EP = LibStub("LibElvUIPlugin-1.0") --We can use this to automatically insert our GUI tables when ElvUI_Config is loaded.


local function LoadSkin_ElvUI()
--DropDownMenu
	hooksecurefunc('BW_UIDropDownMenu_CreateFrames', function(level, index)
		local listFrame = _G['BW_DropDownList'..level];

		local listFrameName = listFrame:GetName();
		local expandArrow = _G[listFrameName..'Button'..index..'ExpandArrow'];
		if expandArrow then
			local normTex = expandArrow:GetNormalTexture()
			expandArrow:SetNormalTexture(E.Media.Textures.ArrowUp)
			normTex:SetVertexColor(unpack(E.media.rgbvaluecolor))
			normTex:SetRotation(S.ArrowRotation.right)
			expandArrow:Size(12, 12)
		end

		local Backdrop = _G[listFrameName..'Backdrop']
		if not Backdrop.template then Backdrop:StripTextures() end
		Backdrop:CreateBackdrop('Transparent')

		local menuBackdrop = _G[listFrameName..'MenuBackdrop']
		if not menuBackdrop.template then menuBackdrop:StripTextures() end
		menuBackdrop:CreateBackdrop('Transparent')
	end)

	hooksecurefunc('BW_UIDropDownMenu_SetIconImage', function(icon, texture)
		if texture:find('Divider') then
			local r, g, b = unpack(E.media.rgbvaluecolor)
			icon:SetColorTexture(r, g, b, 0.45)
			icon:Height(1)
		end
	end)

	hooksecurefunc('BW_ToggleDropDownMenu', function(level)
		if not level then
			level = 1;
		end

		local r, g, b = unpack(E.media.rgbvaluecolor)

		for i = 1, _G.BW_UIDROPDOWNMENU_MAXBUTTONS do
			local button = _G['BW_DropDownList'..level..'Button'..i]
			local check = _G['BW_DropDownList'..level..'Button'..i..'Check']
			local uncheck = _G['BW_DropDownList'..level..'Button'..i..'UnCheck']
			local highlight = _G['BW_DropDownList'..level..'Button'..i..'Highlight']

			highlight:SetTexture(E.Media.Textures.Highlight)
			highlight:SetBlendMode('BLEND')
			highlight:SetDrawLayer('BACKGROUND')
			highlight:SetVertexColor(r, g, b)

			if not button.backdrop then
				button:CreateBackdrop()
			end

			button.backdrop:Hide()

			if not button.notCheckable then
				uncheck:SetTexture()
				local _, co = check:GetTexCoord()
				if co == 0 then
					check:SetTexture([[Interface\Buttons\UI-CheckBox-Check]])
					check:SetVertexColor(r, g, b, 1)
					check:Size(20, 20)
					check:SetDesaturated(true)
					button.backdrop:SetInside(check, 4, 4)
				else
					check:SetTexture(E.media.normTex)
					check:SetVertexColor(r, g, b, 1)
					check:Size(10, 10)
					check:SetDesaturated(false)
					button.backdrop:SetOutside(check)
				end

				button.backdrop:Show()
				check:SetTexCoord(0, 1, 0, 1)
			else
				check:Size(16, 16)
			end
		end
	end)

end


function MyPlugin:Initialize()
	--Register plugin so options are properly inserted when config is loaded
	EP:RegisterPlugin(addonName, MyPlugin.InsertOptions)
	LoadSkin_ElvUI()
end



local function SkinTransmogFrames()

	-- Appearances Tab
	local WardrobeCollectionFrame = _G.BetterWardrobeCollectionFrame
	S:HandleTab(WardrobeCollectionFrame.ItemsTab)
	S:HandleTab(WardrobeCollectionFrame.SetsTab)
	S:HandleTab(WardrobeCollectionFrame.ExtraSetsTab)
	S:HandleTab(WardrobeCollectionFrame.SavedSetsTab)

	WardrobeCollectionFrame.progressBar:StripTextures()
	WardrobeCollectionFrame.progressBar:CreateBackdrop()
	WardrobeCollectionFrame.progressBar:SetStatusBarTexture(E.media.normTex)
	E:RegisterStatusBar(WardrobeCollectionFrame.progressBar)

	S:HandleEditBox(_G.BetterWardrobeCollectionFrameSearchBox)
	_G.BetterWardrobeCollectionFrameSearchBox:SetFrameLevel(5)

	S:HandleButton(WardrobeCollectionFrame.FilterButton)
	WardrobeCollectionFrame.FilterButton:Point('LEFT', WardrobeCollectionFrame.searchBox, 'RIGHT', 2, 0)
	S:HandleCloseButton(WardrobeCollectionFrame.FilterButton.ResetButton)
	S:HandleDropDownBox(_G.BetterWardrobeCollectionFrameWeaponDropDown)
	WardrobeCollectionFrame.ItemsCollectionFrame:StripTextures()

	for _, Frame in ipairs(BetterWardrobeCollectionFrame.ContentFrames) do
		if Frame.Models then
			for _, Model in pairs(Frame.Models) do
				Model:SetFrameLevel(Model:GetFrameLevel() + 1)
				Model.Border:SetAlpha(0)
				Model.TransmogStateTexture:SetAlpha(0)

				local border = CreateFrame('Frame', nil, Model)
				border:SetTemplate()
				border:ClearAllPoints()
				border:SetPoint('TOPLEFT', Model, 'TOPLEFT', 0, 1) -- dont use set inside, left side needs to be 0
				border:SetPoint('BOTTOMRIGHT', Model, 'BOTTOMRIGHT', 1, -1)
				border:SetBackdropColor(0, 0, 0, 0)
				border.callbackBackdropColor = clearBackdrop

				if Model.NewGlow then Model.NewGlow:SetParent(border) end
				if Model.NewString then Model.NewString:SetParent(border) end

				for _, region in next, { Model:GetRegions() } do
					if region:IsObjectType('Texture') then -- check for hover glow
						local texture = region:GetTexture()
						if texture == 1116940 or texture == 1569530 then -- transmogrify.blp (items:1116940 or sets:1569530)
							region:SetColorTexture(1, 1, 1, 0.3)
							region:SetBlendMode('ADD')
							region:SetAllPoints(Model)
						end
					end
				end

				hooksecurefunc(Model.Border, 'SetAtlas', function(_, texture)
					if texture == 'transmog-wardrobe-border-uncollected' then
						border:SetBackdropBorderColor(0.9, 0.9, 0.3)
					elseif texture == 'transmog-wardrobe-border-unusable' then
						border:SetBackdropBorderColor(0.9, 0.3, 0.3)
					elseif Model.TransmogStateTexture:IsShown() then
						border:SetBackdropBorderColor(1, 0.7, 1)
					else
						border:SetBackdropBorderColor(unpack(E.media.bordercolor))
					end
				end)
			end
		end

		local pending = Frame.PendingTransmogFrame
		if pending then
			local Glowframe = pending.Glowframe
			Glowframe:SetAtlas(nil)
			Glowframe:CreateBackdrop(nil, nil, nil, nil, nil, nil, nil, nil, pending:GetFrameLevel())

			if Glowframe.backdrop then
				Glowframe.backdrop:SetPoint('TOPLEFT', pending, 'TOPLEFT', 0, 1) -- dont use set inside, left side needs to be 0
				Glowframe.backdrop:SetPoint('BOTTOMRIGHT', pending, 'BOTTOMRIGHT', 1, -1)
				Glowframe.backdrop:SetBackdropBorderColor(1, 0.7, 1)
				Glowframe.backdrop:SetBackdropColor(0, 0, 0, 0)
			end

			for i = 1, 12 do
				if i < 5 then
					Frame.PendingTransmogFrame['Smoke'..i]:Hide()
				end

				Frame.PendingTransmogFrame['Wisp'..i]:Hide()
			end
		end

		if Frame.PagingFrame then
			S:HandleNextPrevButton(Frame.PagingFrame.PrevPageButton, nil, nil, true)
			S:HandleNextPrevButton(Frame.PagingFrame.NextPageButton, nil, nil, true)
		end
	end

	local SetsCollectionFrame = BetterWardrobeCollectionFrame.SetsCollectionFrame
	SetsCollectionFrame:SetTemplate('Transparent')
	SetsCollectionFrame.RightInset:StripTextures()
	SetsCollectionFrame.LeftInset:StripTextures()
	S:HandleTrimScrollBar(SetsCollectionFrame.ListContainer.ScrollBar)

	hooksecurefunc(SetsCollectionFrame.ListContainer.ScrollBox, 'Update', function(button)
		for _, child in next, { button.ScrollTarget:GetChildren() } do
			if not child.IsSkinned then
				child.Background:Hide()
				child.HighlightTexture:SetTexture('')
				child.Icon:SetSize(42, 42)
				S:HandleIcon(child.Icon)
				child.IconCover:SetOutside(child.Icon)

				child.SelectedTexture:SetDrawLayer('BACKGROUND')
				child.SelectedTexture:SetColorTexture(1, 1, 1, .25)
				child.SelectedTexture:ClearAllPoints()
				child.SelectedTexture:SetPoint('TOPLEFT', 4, -2)
				child.SelectedTexture:SetPoint('BOTTOMRIGHT', -1, 2)
				child.SelectedTexture:CreateBackdrop('Transparent')

				child.IsSkinned = true
			end
		end
	end)


	local DetailsFrame = SetsCollectionFrame.DetailsFrame
	DetailsFrame.ModelFadeTexture:Hide()
	DetailsFrame.IconRowBackground:Hide()
	DetailsFrame.Name:FontTemplate(nil, 16)
	DetailsFrame.LongName:FontTemplate(nil, 16)
	S:HandleButton(DetailsFrame.VariantSetsButton)
	
	hooksecurefunc(SetsCollectionFrame, 'SetItemFrameQuality', function(_, itemFrame)
		local icon = itemFrame.Icon
		if not icon.backdrop then
			icon:CreateBackdrop()
			icon:SetTexCoord(unpack(E.TexCoords))
			itemFrame.IconBorder:Hide()
		end

		if itemFrame.collected then
			local quality = C_TransmogCollection_GetSourceInfo(itemFrame.sourceID).quality
			local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
			icon.backdrop:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			icon.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
	end)

	_G.BetterWardrobeSetsCollectionVariantSetsButton.Icon:SetTexture(E.Media.Textures.ArrowUp)
	_G.BetterWardrobeSetsCollectionVariantSetsButton.Icon:SetRotation(S.ArrowRotation.down)


	--local WardrobeFrame = _G.WardrobeFrame
	--S:HandlePortraitFrame(WardrobeFrame)


	local WardrobeOutfitFrame = _G.BetterWardrobeOutfitFrame
	WardrobeOutfitFrame:StripTextures()
	WardrobeOutfitFrame:SetTemplate('Transparent')
	S:HandleButton(_G.BetterWardrobeOutfitDropDown.SaveButton)
	S:HandleDropDownBox(_G.BetterWardrobeOutfitDropDown, 221)
	_G.BetterWardrobeOutfitDropDown:Height(34)
	_G.BetterWardrobeOutfitDropDown.SaveButton:ClearAllPoints()
	_G.BetterWardrobeOutfitDropDown.SaveButton:Point('TOPLEFT', _G.BetterWardrobeOutfitDropDown, 'TOPRIGHT', -2, -2)

	local WardrobeTransmogFrame = _G.WardrobeTransmogFrame
	WardrobeTransmogFrame:StripTextures()

	for i = 1, #WardrobeTransmogFrame.SlotButtons do
		local slotButton = WardrobeTransmogFrame.SlotButtons[i]
		slotButton:SetFrameLevel(slotButton:GetFrameLevel() + 2)
		slotButton:StripTextures()
		slotButton:CreateBackdrop(nil, nil, nil, nil, nil, nil, nil, true)
		slotButton.Border:Kill()
		slotButton.Icon:SetTexCoord(unpack(E.TexCoords))
		slotButton.Icon:SetInside(slotButton.backdrop)

		local undo = slotButton.UndoButton
		if undo then undo:SetHighlightTexture(E.ClearTexture) end

		local pending = slotButton.PendingFrame
		if pending then
			if slotButton.transmogType == 1 then
				pending.Glow:Size(48)
				pending.Ants:Size(30)
			else
				pending.Glow:Size(74)
				pending.Ants:Size(48)
			end
		end
	end

	WardrobeTransmogFrame.SpecButton:ClearAllPoints()
	WardrobeTransmogFrame.SpecButton:Point('RIGHT', WardrobeTransmogFrame.ApplyButton, 'LEFT', -2, 0)
	S:HandleButton(WardrobeTransmogFrame.SpecButton)
	S:HandleButton(WardrobeTransmogFrame.ApplyButton)
	S:HandleButton(WardrobeTransmogFrame.ModelScene.ClearAllPendingButton)
	S:HandleCheckBox(WardrobeTransmogFrame.ToggleSecondaryAppearanceCheckbox)

	WardrobeCollectionFrame.ItemsCollectionFrame:StripTextures()
	WardrobeCollectionFrame.ItemsCollectionFrame:SetTemplate('Transparent')

	S:HandleButton(BetterWardrobeCollectionFrame.AlteredFormSwapButton)
	BetterWardrobeCollectionFrame.AlteredFormSwapButton:SetSize(20,20)
	BetterWardrobeCollectionFrame.AlteredFormSwapButton.Portrait:SetSize(20,20)

	WardrobeCollectionFrame.SetsTransmogFrame:StripTextures()
	WardrobeCollectionFrame.SetsTransmogFrame:SetTemplate('Transparent')
	S:HandleNextPrevButton(WardrobeCollectionFrame.SetsTransmogFrame.PagingFrame.NextPageButton)
	S:HandleNextPrevButton(WardrobeCollectionFrame.SetsTransmogFrame.PagingFrame.PrevPageButton)

	local WardrobeOutfitEditFrame = _G.WardrobeOutfitEditFrame
	WardrobeOutfitEditFrame:StripTextures()
	WardrobeOutfitEditFrame:SetTemplate('Transparent')
	WardrobeOutfitEditFrame.EditBox:StripTextures()
	S:HandleEditBox(WardrobeOutfitEditFrame.EditBox)
	S:HandleButton(WardrobeOutfitEditFrame.AcceptButton)
	S:HandleButton(WardrobeOutfitEditFrame.CancelButton)
	S:HandleButton(WardrobeOutfitEditFrame.DeleteButton)

	--Items
	S:HandleDropDownBox(BW_SortDropDown)
	S:HandleDropDownBox(BW_DBSavedSetDropdown)
	S:HandleDropDownBox(BW_ColectionListFrame.dropdownFrame)
	BW_ColectionListFrame.dropdownFrame:ClearAllPoints()
	BW_ColectionListFrame.dropdownFrame:SetPoint("BOTTOM", -25, 15)

	S:HandleButton(BW_CollectionListOptionsButton)
	BW_CollectionListOptionsButton:SetSize(25,25)

	S:HandleButton(BW_LoadQueueButton)
	BW_LoadQueueButton:ClearAllPoints()
	BW_LoadQueueButton:Point("TOPLEFT",BetterWardrobeOutfitDropDown, "TOPRIGHT", 90, -2)

	S:HandleButton(BW_RandomizeButton)
	BW_RandomizeButton:ClearAllPoints()
	BW_RandomizeButton:Point("TOPLEFT",BW_LoadQueueButton, "TOPRIGHT", 5, 0)

	S:HandleButton(BW_SlotHideButton)
	BW_SlotHideButton:ClearAllPoints()
	BW_SlotHideButton:Point("TOPLEFT",BW_RandomizeButton, "TOPRIGHT", 5, 0)

	S:HandleButton(BW_TransmogOptionsButton)
end

local function UpdateDressingRoom()
	--Dropdown Menu
	BetterWardrobeOutfitFrame:StripTextures()
	BetterWardrobeOutfitFrame:CreateBackdrop('Transparent')

	--DressingRoom
	BW_DressingRoomFrame:StripTextures()
	BW_DressingRoomFrame:CreateBackdrop('Transparent')
	S:HandleScrollBar(BetterWardrobeOutfitFrameScrollFrameScrollBar)


	BetterWardrobeDressUpFrameDropDown:StripTextures()
	BetterWardrobeDressUpFrameDropDown:CreateBackdrop()
	--BetterWardrobeOutfitDropDown:Set
	S:HandleNextPrevButton(BetterWardrobeDressUpFrameDropDownButton)
	BetterWardrobeDressUpFrameDropDownButton:ClearAllPoints()
	BetterWardrobeDressUpFrameDropDownButton:SetPoint("RIGHT")
	--BetterWardrobeOutfitDropDown.SaveButton:ClearAllPoints()
	--BetterWardrobeOutfitDropDown.SaveButton:SetPoint("LEFT",BetterWardrobeOutfitDropDown, "RIGHT", 3, 0)


	--S:HandleDropDownBox(BetterWardrobeDressUpFrameDropDown, 221)
	--BetterWardrobeDressUpFrameDropDown:SetHeight(34)

	S:HandleButton(BetterWardrobeDressUpFrameDropDown.SaveButton)
	BetterWardrobeDressUpFrameDropDown.SaveButton:ClearAllPoints()
	BetterWardrobeDressUpFrameDropDown.SaveButton:SetPoint("LEFT", BetterWardrobeDressUpFrameDropDown, "RIGHT", 3, 0)

	S:HandleButton(BW_DressingRoomFrame.BW_DressingRoomSettingsButton)
	BW_DressingRoomFrame.BW_DressingRoomSettingsButton:SetSize(25,25)
	BW_DressingRoomFrame.BW_DressingRoomSettingsButton:SetPoint("BOTTOMLEFT", 2,2)

	S:HandleButton(BW_DressingRoomFrame.BW_DressingRoomExportButton)
	BW_DressingRoomFrame.BW_DressingRoomExportButton:SetSize(25,25)
	BW_DressingRoomFrame.BW_DressingRoomExportButton:SetPoint("LEFT", BW_DressingRoomFrame.BW_DressingRoomSettingsButton, "RIGHT" )

	S:HandleButton(BW_DressingRoomFrame.BW_DressingRoomTargetButton)
	BW_DressingRoomFrame.BW_DressingRoomTargetButton:SetSize(25,25)

	BW_DressingRoomFrame.BW_DressingRoomTargetButton:SetPoint("LEFT", BW_DressingRoomFrame.BW_DressingRoomExportButton, "RIGHT" )

	S:HandleButton(BW_DressingRoomFrame.BW_DressingRoomPlayerButton)
	BW_DressingRoomFrame.BW_DressingRoomPlayerButton:SetSize(25,25)
	BW_DressingRoomFrame.BW_DressingRoomPlayerButton:SetPoint("LEFT", BW_DressingRoomFrame.BW_DressingRoomTargetButton, "RIGHT" )

	S:HandleButton(BW_DressingRoomFrame.BW_DressingRoomGearButton)
	BW_DressingRoomFrame.BW_DressingRoomGearButton:SetSize(25,25)
	BW_DressingRoomFrame.BW_DressingRoomGearButton:SetPoint("LEFT", BW_DressingRoomFrame.BW_DressingRoomPlayerButton, "RIGHT" )

	S:HandleButton(BW_DressingRoomFrame.BW_DressingRoomUndressButton)
	BW_DressingRoomFrame.BW_DressingRoomUndressButton:SetSize(25,25)
	BW_DressingRoomFrame.BW_DressingRoomUndressButton:SetPoint("LEFT", BW_DressingRoomFrame.BW_DressingRoomGearButton, "RIGHT" )

	DressUpFrame.LinkButton:ClearAllPoints()
	DressUpFrame.LinkButton:SetSize(25,25)
	DressUpFrame.LinkButton:SetPoint("LEFT", BW_DressingRoomFrame.BW_DressingRoomUndressButton, "RIGHT" , 00)

	DressUpFrameOutfitDropDown:ClearAllPoints()
	DressUpFrameOutfitDropDown:SetSize(1,1)
	DressUpFrameOutfitDropDown:SetPoint("LEFT", UIParent, "LEFT", -1000,-1000)
	DressUpFrameOutfitDropDown:Hide()
	DressUpFrameOutfitDropDownButton:Hide()
	DressUpFrameOutfitDropDown.SaveButton:Hide()
	for index, button in pairs(BW_DressingRoomFrame.PreviewButtonFrame.Slots) do
		S:HandleItemButton(button)
		--button.IconBorder:SetColorTexture(1, 1, 1, 0.1)
	end

	S:HandleButton(BW_DressingRoomFrame.BW_DressingRoomSwapFormButton)
	BW_DressingRoomFrame.BW_DressingRoomSwapFormButton:SetSize(20,20)
	BW_DressingRoomFrame.BW_DressingRoomSwapFormButton.Portrait:SetSize(20,20)

--Need to redo
	--[[hooksecurefunc(addon, 'DressingRoom_SetItemFrameQuality', function(_, itemFrame)
				local icon = itemFrame.Icon
				if not icon.backdrop then
					icon:CreateBackdrop()
					icon:SetTexCoord(unpack(E.TexCoords))
					itemFrame.IconBorder:Hide()
					local level = itemFrame:GetFrameLevel()
					if icon then
						itemFrame:SetFrameLevel(level +1)
					end
					icon.backdrop:SetFrameLevel(level + .5)
				end

				if itemFrame.itemLink then
					--local quality = C_TransmogCollection.GetSourceInfo(itemFrame.sourceID).quality
					local _, _, quality, _, _, _, _, _, _, texture = GetItemInfo(itemFrame.itemLink)
					local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
					icon.backdrop:SetBackdropBorderColor(color.r, color.g, color.b)
				else
					icon.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
				end
			end)]]--

	-- Outfit Edit Frame
	local WardrobeOutfitEditFrame = _G.BetterWardrobeOutfitEditFrame
	WardrobeOutfitEditFrame:StripTextures()
	WardrobeOutfitEditFrame:CreateBackdrop('Transparent')
	WardrobeOutfitEditFrame.EditBox:StripTextures()
	S:HandleEditBox(WardrobeOutfitEditFrame.EditBox)
	S:HandleButton(WardrobeOutfitEditFrame.AcceptButton)
	S:HandleButton(WardrobeOutfitEditFrame.CancelButton)
	S:HandleButton(WardrobeOutfitEditFrame.DeleteButton)
end

addon.ElvUI_init = false
local eventFrame
local function applySkins()
	addon.ElvUI_init = true
	if not (E.private.skins.blizzard.enable) then return end
	if not E.private.skins.blizzard.enable then return end
	if E.private.skins.blizzard.transmogrify then SkinTransmogFrames() end
	if E.private.skins.blizzard.dressingroom then UpdateDressingRoom() end
	eventFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
end



function S:BetterWardrobe()
	if not (E.private.skins.blizzard.enable) then return end

		local frame = CreateFrame("Frame");
		frame:SetScript("OnEvent", function(__, event, arg1)
		    if (event == "PLAYER_ENTERING_WORLD") then
		    	if not IsAddOnLoaded("Blizzard_Collections") then
		    		LoadAddOn("Blizzard_Collections")
		    	end

		        C_Timer.After(5, applySkins)
		    end
		end)
		frame:RegisterEvent("PLAYER_ENTERING_WORLD");
		eventFrame = frame

--We can only skin the addon after the Blizzard Collection addon is loaded.  Forcing loading
--causes elvui to not skin it properly.  We wait until it gets loaded and then set the skin

end

S:AddCallbackForAddon('BetterWardrobe')
E:RegisterModule(MyPlugin:GetName())  --Register the module with ElvUI. ElvUI will now call MyPlugin:Initialize() when ElvUI is ready to load our plugin.
--saddon:RegisterMessage("BW_ADDON_LOADED", function() C_Timer.After(5, applySkins) end)