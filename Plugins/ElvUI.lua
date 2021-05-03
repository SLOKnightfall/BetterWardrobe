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



local function applySkins ()
	-- Appearances Tab
	local WardrobeCollectionFrame = _G.BW_WardrobeCollectionFrame
	S:HandleTab(WardrobeCollectionFrame.ItemsTab)
	S:HandleTab(WardrobeCollectionFrame.SetsTab)
	S:HandleTab(WardrobeCollectionFrame.ExtraSetsTab)
	S:HandleTab(WardrobeCollectionFrame.SavedSetsTab)

	--Items
	S:HandleDropDownBox(BW_SortDropDown)
	--S:HandleDropDownBox(BW_WardrobeFilterDropDown)


	S:HandleButton(BW_WardrobeCollectionFrame.FilterButton)

	for _, Frame in ipairs(BW_WardrobeCollectionFrame.ContentFrames) do
		if Frame.Models then
			for _, Model in pairs(Frame.Models) do
				Model:SetFrameLevel(Model:GetFrameLevel() + 1)
				Model.Border:SetAlpha(0)
				Model.TransmogStateTexture:SetAlpha(0)

				local border = CreateFrame('Frame', nil, Model, 'BackdropTemplate')
				border:SetTemplate()
				border:ClearAllPoints()
				border:SetPoint('TOPLEFT', Model, 'TOPLEFT', 0, 1) -- dont use set inside, left side needs to be 0
				border:SetPoint('BOTTOMRIGHT', Model, 'BOTTOMRIGHT', 1, -1)
				border:SetBackdropColor(0, 0, 0, 0)
				border.ignoreBackdropColor = true

				for i=1, Model:GetNumRegions() do
				local region = select(i, Model:GetRegions())
					if region:IsObjectType('Texture') and region:GetTexture() == 1116940 then
						region:SetColorTexture(1, 1, 1, 0.3)
						region:SetBlendMode('ADD')
						region:SetAllPoints(Model)
					end
				end

				hooksecurefunc(Model.Border, 'SetAtlas', function(_, texture)
					if texture == 'transmog-wardrobe-border-uncollected' then
						border:SetBackdropBorderColor(0.9, 0.9, 0.3)
					elseif texture == 'transmog-wardrobe-border-unusable' then
						border:SetBackdropBorderColor(0.9, 0.3, 0.3)
					else
						border:SetBackdropBorderColor(unpack(E.media.bordercolor))
					end
				end)
			end
		end

		if Frame.PendingTransmogFrame then
			--Frame.PendingTransmogFrame.Glowframe:SetAtlas(nil)
			Frame.PendingTransmogFrame.Glowframe:CreateBackdrop()
			Frame.PendingTransmogFrame.Glowframe.backdrop:SetOutside()
			Frame.PendingTransmogFrame.Glowframe.backdrop:SetBackdropColor(0, 0, 0, 0)
			Frame.PendingTransmogFrame.Glowframe.backdrop:SetBackdropBorderColor(1, .77, 1, 1)
			Frame.PendingTransmogFrame.Glowframe = Frame.PendingTransmogFrame.Glowframe.backdrop

			for i = 1, 12 do
				Frame.PendingTransmogFrame['Wisp'..i]:Hide()
			end
		end

		if Frame.PagingFrame then
			S:HandleNextPrevButton(Frame.PagingFrame.PrevPageButton, nil, nil, true)
			S:HandleNextPrevButton(Frame.PagingFrame.NextPageButton, nil, nil, true)
		end
	end

--ExtraSets
	local SetsCollectionFrame = BW_SetsCollectionFrame
	SetsCollectionFrame:CreateBackdrop('Transparent')
	SetsCollectionFrame.RightInset:StripTextures()
	SetsCollectionFrame.LeftInset:StripTextures()
	--JournalScrollButtons(SetsCollectionFrame.ScrollFrame)
	S:HandleScrollBar(SetsCollectionFrame.ScrollFrame.scrollBar)

	local ScrollFrame = BW_SetsCollectionFrame.ScrollFrame
	S:HandleScrollBar(ScrollFrame.scrollBar)
	for i = 1, #ScrollFrame.buttons do
		local bu = ScrollFrame.buttons[i]
		S:HandleItemButton(bu)
		bu.Favorite:SetAtlas("PetJournal-FavoritesIcon", true)
		bu.Favorite:Point("TOPLEFT", bu.Icon, "TOPLEFT", -8, 8)
		bu.SelectedTexture:SetColorTexture(1, 1, 1, 0.1)
		--bu.HideItemVisual.Icon:Point("TOPRIGHT", bu, "TOPRIGHT", -8, -8)
	end

	-- DetailsFrame
	local DetailsFrame = SetsCollectionFrame.DetailsFrame
	DetailsFrame.Name:FontTemplate(nil, 16)
	DetailsFrame.LongName:FontTemplate(nil, 16)
	--S:HandleButton(DetailsFrame.VariantSetsButton)

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

	--SavedSets
	--addon.SavedSetDropDownFrame.frame.backdrop:Hide()
	S:HandleDropDownBox(BW_DBSavedSetDropdown)
	--S:HandleButton(BW_DropDownList1)

	--BW_DBSavedSetDropdown:ClearAllPoints()
	--BW_DBSavedSetDropdown:SetPoint("TOPRIGHT", "BW_SortDropDown", "TOPRIGHT", -0 , 0)
	--BW_DBSavedSetDropdown:SetScript("OnShow", function() UIDropDownMenu_SetWidth(BW_DBSavedSetDropdown, 155) end)

	--CollectionList
	--BW_ColectionListFrame.dropdownFrame.group.frame.backdrop:Hide()
	S:HandleDropDownBox(BW_ColectionListFrame.dropdownFrame)
	BW_ColectionListFrame.dropdownFrame:ClearAllPoints()
	BW_ColectionListFrame.dropdownFrame:SetPoint("BOTTOM", -25, 15)

	S:HandleButton(BW_CollectionListOptionsButton)
	BW_CollectionListOptionsButton:SetSize(25,25)
	--BW_CollectionListOptionsButton:SetPoint("BOTTOMLEFT", 2,2)

-- Transmogrify NPC
	local WardrobeFrame = _G.WardrobeFrame

	S:HandleButton(BW_WardrobeOutfitDropDown.SaveButton)
	--S:HandleDropDownBox(_G.BW_WardrobeOutfitDropDown, 221)

	--BW_WardrobeOutfitDropDown:Show()
	--BW_WardrobeOutfitDropDown:
	--_G.BW_WardrobeOutfitDropDown:Height(34)
	--_G.BW_WardrobeOutfitDropDown.SaveButton:ClearAllPoints()
	--_G.BW_WardrobeOutfitDropDown.SaveButton:Point('TOPLEFT', _G.WardrobeOutfitDropDown, 'TOPRIGHT', -2, -2)
	--S:HandleScrollBar(BW_WardrobeOutfitFrameScrollFrameScrollBar)

	BW_WardrobeOutfitDropDown:StripTextures()
	BW_WardrobeOutfitDropDown:CreateBackdrop()
	--BW_WardrobeOutfitDropDown:Set
	BW_WardrobeOutfitDropDown:SetWidth(150)
	BW_WardrobeOutfitDropDown:ClearAllPoints()
	BW_WardrobeOutfitDropDown:SetPoint("TOPLEFT", WardrobeTransmogFrame, 20, 28)
	S:HandleNextPrevButton(BW_WardrobeOutfitDropDownButton)
	BW_WardrobeOutfitDropDownButton:ClearAllPoints()
	BW_WardrobeOutfitDropDownButton:SetPoint("RIGHT")
	BW_WardrobeOutfitDropDown.SaveButton:ClearAllPoints()
		BW_WardrobeOutfitDropDown.SaveButton:SetWidth(75)

	BW_WardrobeOutfitDropDown.SaveButton:SetPoint("LEFT",BW_WardrobeOutfitDropDown, "RIGHT", 3, 0)

	--S:HandleButton(BW_WardrobeOutfitDropDownButton)

	BW_WardrobeOutfitFrame:StripTextures()
	BW_WardrobeOutfitFrame:CreateBackdrop('Transparent')



	S:HandleButton(BW_LoadQueueButton)
	BW_LoadQueueButton:ClearAllPoints()
	BW_LoadQueueButton:Point("TOPLEFT",BW_WardrobeOutfitDropDown, "TOPRIGHT", 80, -2)

	S:HandleButton(BW_RandomizeButton)
	BW_RandomizeButton:ClearAllPoints()
	BW_RandomizeButton:Point("TOPLEFT",BW_LoadQueueButton, "TOPRIGHT", 0, 0)

	S:HandleButton(BW_SlotHideButton)
	BW_SlotHideButton:ClearAllPoints()
	BW_SlotHideButton:Point("TOPLEFT",BW_RandomizeButton, "TOPRIGHT", 0, 0)

	S:HandleButton(WardrobeCollectionFrame.BW_SetsHideSlotButton)
	--BW_SlotHideButton:ClearAllPoints()
	--:Point("TOPLEFT",BW_RandomizeButton, "TOPRIGHT", 0, 0)

--Transmogrify NPC Sets tab
	local WardrobeTransmogFrame = _G.BW_SetsTransmogFrame
	WardrobeTransmogFrame:StripTextures()
	WardrobeTransmogFrame:CreateBackdrop('Transparent')
	S:HandleNextPrevButton(WardrobeTransmogFrame.PagingFrame.NextPageButton)
	S:HandleNextPrevButton(WardrobeTransmogFrame.PagingFrame.PrevPageButton)
	S:HandleButton(BW_TransmogOptionsButton)


--DressingRoom
	BW_DressingRoomOutfitFrame:StripTextures()
	BW_DressingRoomOutfitFrame:CreateBackdrop('Transparent')
	S:HandleScrollBar(BW_DressingRoomOutfitFrameScrollFrameScrollBar)


	BW_DressingRoomOutfitDropDown:StripTextures()
	BW_DressingRoomOutfitDropDown:CreateBackdrop()
	--BW_WardrobeOutfitDropDown:Set
	S:HandleNextPrevButton(BW_DressingRoomOutfitDropDownButton)
	BW_DressingRoomOutfitDropDownButton:ClearAllPoints()
	BW_DressingRoomOutfitDropDownButton:SetPoint("RIGHT")
	--BW_WardrobeOutfitDropDown.SaveButton:ClearAllPoints()
	--BW_WardrobeOutfitDropDown.SaveButton:SetPoint("LEFT",BW_WardrobeOutfitDropDown, "RIGHT", 3, 0)


	--S:HandleDropDownBox(BW_DressingRoomOutfitDropDown, 221)
	--BW_DressingRoomOutfitDropDown:SetHeight(34)

	S:HandleButton(BW_DressingRoomOutfitDropDown.SaveButton)
	BW_DressingRoomOutfitDropDown.SaveButton:ClearAllPoints()
	BW_DressingRoomOutfitDropDown.SaveButton:SetPoint("LEFT", BW_DressingRoomOutfitDropDown, "RIGHT", 3, 0)

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

	for index, button in pairs(BW_DressingRoomFrame.PreviewButtonFrame.Slots) do
		S:HandleItemButton(button)
		--button.IconBorder:SetColorTexture(1, 1, 1, 0.1)
	end



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
	local WardrobeOutfitEditFrame = _G.BW_WardrobeOutfitEditFrame
	WardrobeOutfitEditFrame:StripTextures()
	WardrobeOutfitEditFrame:CreateBackdrop('Transparent')
	WardrobeOutfitEditFrame.EditBox:StripTextures()
	S:HandleEditBox(WardrobeOutfitEditFrame.EditBox)
	S:HandleButton(WardrobeOutfitEditFrame.AcceptButton)
	S:HandleButton(WardrobeOutfitEditFrame.CancelButton)
	S:HandleButton(WardrobeOutfitEditFrame.DeleteButton)
end

function S:BetterWardrobe()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.collections) then return end

	-- execute this on the next frame to prevent it from executing before OnEnable
	-- in Core.lua
	C_Timer.After(0, applySkins)
end

S:AddCallbackForAddon('BetterWardrobe')
E:RegisterModule(MyPlugin:GetName())  --Register the module with ElvUI. ElvUI will now call MyPlugin:Initialize() when ElvUI is ready to load our plugin.
