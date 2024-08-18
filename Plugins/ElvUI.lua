--[[
	Elvui Plugin to reskin new/changed UI
]]

if not C_AddOns.IsAddOnLoaded("ElvUI") then return end
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
	

end


function MyPlugin:Initialize()
	--Register plugin so options are properly inserted when config is loaded
	EP:RegisterPlugin(addonName, MyPlugin.InsertOptions)
	LoadSkin_ElvUI()
end



local function SkinTransmogFrames()

	local BetterWardrobeCollectionFrame = _G.BetterWardrobeCollectionFrame
	S:HandleTab(BetterWardrobeCollectionFrame.ItemsTab)
	S:HandleTab(BetterWardrobeCollectionFrame.SetsTab)
	S:HandleTab(BetterWardrobeCollectionFrame.ExtraSetsTab)
	S:HandleTab(BetterWardrobeCollectionFrame.SavedSetsTab)

	BetterWardrobeCollectionFrame.progressBar:StripTextures()
	BetterWardrobeCollectionFrame.progressBar:CreateBackdrop()
	BetterWardrobeCollectionFrame.progressBar:SetStatusBarTexture(E.media.normTex)
	E:RegisterStatusBar(BetterWardrobeCollectionFrame.progressBar)

	S:HandleEditBox(_G.BetterWardrobeCollectionFrameSearchBox)
	_G.BetterWardrobeCollectionFrameSearchBox:SetFrameLevel(5)
	S:HandleDropDownBox(_G.BetterWardrobeCollectionFrame.ClassDropdown, 145)
	S:HandleDropDownBox(_G.BW_SortDropDown, 145)
	S:HandleDropDownBox(_G.BW_CollectionList_Dropdown, 145)
	S:HandleDropDownBox(_G.BW_SavedOutfitDropDown, 145)
	S:HandleDropDownBox(_G.BW_TransmogOptionsButton, 145)
	S:HandleDropDownBox(_G.BetterWardrobeTMOutfitDropDown, 145)
	S:HandleButton(_G.BetterWardrobeTMOutfitDropDown.SaveButton, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, 'right')

	S:HandleButton(_G.BW_CollectionListButton, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, 'right')

	S:HandleButton(_G.BW_CollectionListOptionsButton, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, 'right')

	S:HandleButton(BetterWardrobeCollectionFrame.FilterButton, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, 'right')
	BetterWardrobeCollectionFrame.FilterButton:Point('LEFT', BetterWardrobeCollectionFrame.searchBox, 'RIGHT', 2, 0)
	S:HandleCloseButton(BetterWardrobeCollectionFrame.FilterButton.ResetButton)
	BetterWardrobeCollectionFrame.FilterButton.ResetButton:ClearAllPoints()
	BetterWardrobeCollectionFrame.FilterButton.ResetButton:Point('CENTER', BetterWardrobeCollectionFrame.FilterButton, 'TOPRIGHT', 0, 0)
	S:HandleDropDownBox(_G.BetterWardrobeCollectionFrame.ItemsCollectionFrame.WeaponDropdown)
	BetterWardrobeCollectionFrame.ItemsCollectionFrame:StripTextures()

	for _, Frame in ipairs(BetterWardrobeCollectionFrame.ContentFrames) do
		if Frame.Models then
			for _, Model in pairs(Frame.Models) do
				Model.Border:SetAlpha(0)
				Model.TransmogStateTexture:SetAlpha(0)

				local border = CreateFrame('Frame', nil, Model)
				border:SetTemplate()
				border:ClearAllPoints()
				border:Point('TOPLEFT', Model, 'TOPLEFT', 0, 1) -- dont use set inside, left side needs to be 0
				border:Point('BOTTOMRIGHT', Model, 'BOTTOMRIGHT', 1, -1)
				border:SetBackdropColor(0, 0, 0, 0)
				border.callbackBackdropColor = clearBackdrop

				if Model.NewGlow then Model.NewGlow:SetParent(border) end
				if Model.NewString then Model.NewString:SetParent(border) end

				for _, region in next, { Model:GetRegions() } do
					if region:IsObjectType('Texture') then -- check for hover glow
						local texture, regionName = region:GetTexture(), region:GetDebugName() -- find transmogrify.blp (sets:1569530 or items:1116940)
						if texture == 1569530 or (texture == 1116940 and not strfind(regionName, 'SlotInvalidTexture') and not strfind(regionName, 'DisabledOverlay')) then
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
				Glowframe.backdrop:Point('TOPLEFT', pending, 'TOPLEFT', 0, 1) -- dont use set inside, left side needs to be 0
				Glowframe.backdrop:Point('BOTTOMRIGHT', pending, 'BOTTOMRIGHT', 1, -1)
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

		local paging = Frame.PagingFrame
		if paging then
			S:HandleNextPrevButton(paging.PrevPageButton, nil, nil, true)
			S:HandleNextPrevButton(paging.NextPageButton, nil, nil, true)
		end
	end

	local SetsCollectionFrame = BetterWardrobeCollectionFrame.SetsCollectionFrame
	SetsCollectionFrame:SetTemplate('Transparent')
	SetsCollectionFrame.RightInset:StripTextures()
	SetsCollectionFrame.LeftInset:StripTextures()
	S:HandleTrimScrollBar(SetsCollectionFrame.ListContainer.ScrollBar)

	----hooksecurefunc(SetsCollectionFrame.ListContainer.ScrollBox, 'Update', SetsFrame_ScrollBoxUpdate)

	local DetailsFrame = SetsCollectionFrame.DetailsFrame
	DetailsFrame.ModelFadeTexture:Hide()
	DetailsFrame.IconRowBackground:Hide()
	DetailsFrame.Name:FontTemplate(nil, 16)
	DetailsFrame.LongName:FontTemplate(nil, 16)
	S:HandleDropDownBox(DetailsFrame.VariantSetsDropdown)
	----hooksecurefunc(SetsCollectionFrame, 'SetItemFrameQuality', SetsFrame_SetItemFrameQuality)

	--local WardrobeFrame = _G.BetterWardrobeFrame
	--S:HandlePortraitFrame(WardrobeFrame)


	S:HandleButton(DetailsFrame.BW_LinkSetButton)
	S:HandleButton(DetailsFrame.BW_OpenDressingRoomButton)
	DetailsFrame.BW_LinkSetButton:SetSize(20,20)
	DetailsFrame.BW_OpenDressingRoomButton:SetSize(20,20)

	S:HandleButton(BetterWardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame.BW_SetsHideSlotButton)
	BetterWardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame.BW_SetsHideSlotButton:SetSize(20,20)

	BetterWardrobeCollectionFrame.ItemsCollectionFrame:StripTextures()
	BetterWardrobeCollectionFrame.ItemsCollectionFrame:SetTemplate('Transparent')

	BetterWardrobeCollectionFrame.SetsTransmogFrame:StripTextures()
	BetterWardrobeCollectionFrame.SetsTransmogFrame:SetTemplate('Transparent')
	S:HandleNextPrevButton(BetterWardrobeCollectionFrame.SetsTransmogFrame.PagingFrame.NextPageButton)
	S:HandleNextPrevButton(BetterWardrobeCollectionFrame.SetsTransmogFrame.PagingFrame.PrevPageButton)

	local WardrobeOutfitEditFrame = _G.BetterWardrobeOutfitEditFrame
	WardrobeOutfitEditFrame:StripTextures()
	WardrobeOutfitEditFrame:SetTemplate('Transparent')
	WardrobeOutfitEditFrame.EditBox:StripTextures()
	S:HandleEditBox(WardrobeOutfitEditFrame.EditBox)
	S:HandleButton(WardrobeOutfitEditFrame.AcceptButton)
	S:HandleButton(WardrobeOutfitEditFrame.CancelButton)
	S:HandleButton(WardrobeOutfitEditFrame.DeleteButton)

	--Items


	S:HandleButton(_G.BW_CollectionListOptionsButton)
	BW_CollectionListOptionsButton:SetSize(25,25)

	S:HandleButton(_G.BW_LoadQueueButton)
	BW_LoadQueueButton:ClearAllPoints()
	BW_LoadQueueButton:Point("TOPLEFT",BetterWardrobeTMOutfitDropDown, "TOPRIGHT", 95, -2)

	S:HandleButton(_G.BW_RandomizeButton)
	BW_RandomizeButton:ClearAllPoints()
	BW_RandomizeButton:Point("TOPLEFT",BW_LoadQueueButton, "TOPRIGHT", 5, 0)

	S:HandleButton(_G.BW_SlotHideButton)
	BW_SlotHideButton:ClearAllPoints()
	BW_SlotHideButton:Point("TOPLEFT",BW_RandomizeButton, "TOPRIGHT", 5, 0)
end

local function UpdateDressingRoom()
	--Dropdown Menu
	--BetterWardrobeOutfitFrame:StripTextures()
	--BetterWardrobeOutfitFrame:CreateBackdrop('Transparent')

	--DressingRoom
	--BW_DressingRoomFrame:StripTextures()
	--BW_DressingRoomFrame:CreateBackdrop('Transparent')
--	--S:HandleScrollBar(BetterWardrobeOutfitFrameScrollFrameScrollBar)


--	BetterWardrobeDressUpFrameDropDown:StripTextures()
	--BetterWardrobeDressUpFrameDropDown:CreateBackdrop()
	--BetterWardrobeOutfitDropDown:Set
--	S:HandleNextPrevButton(BetterWardrobeDressUpFrameDropDownButton)
	--BetterWardrobeDressUpFrameDropDownButton:ClearAllPoints()
	--BetterWardrobeDressUpFrameDropDownButton:SetPoint("RIGHT")
	--BetterWardrobeOutfitDropDown.SaveButton:ClearAllPoints()
	--BetterWardrobeOutfitDropDown.SaveButton:SetPoint("LEFT",BetterWardrobeOutfitDropDown, "RIGHT", 3, 0)


	--S:HandleDropDownBox(BetterWardrobeDressUpFrameDropDown, 221)
	--BetterWardrobeDressUpFrameDropDown:SetHeight(34)

	--S:HandleButton(BetterWardrobeDressUpFrameDropDown.SaveButton)
	--BetterWardrobeDressUpFrameDropDown.SaveButton:ClearAllPoints()
	--BetterWardrobeDressUpFrameDropDown.SaveButton:SetPoint("LEFT", BetterWardrobeDressUpFrameDropDown, "RIGHT", 3, 0)

	S:HandleButton(BW_DressingRoomFrame.BW_DressingRoomSettingsButton)
	BW_DressingRoomFrame.BW_DressingRoomSettingsButton:SetSize(25,25)
	BW_DressingRoomFrame.BW_DressingRoomSettingsButton:SetPoint("BOTTOMLEFT", 8, 31)

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

	S:HandleButton(BW_DressingRoomFrame.BW_DressingRoomUndoButton)
	BW_DressingRoomFrame.BW_DressingRoomUndoButton:SetSize(25,25)
	BW_DressingRoomFrame.BW_DressingRoomUndoButton:SetPoint("LEFT", BW_DressingRoomFrame.BW_DressingRoomUndressButton, "RIGHT" )

	--DressUpFrame.LinkButton:ClearAllPoints()
	--DressUpFrame.LinkButton:SetSize(25,25)
	--DressUpFrame.LinkButton:SetPoint("LEFT", BW_DressingRoomFrame.BW_DressingRoomUndressButton, "RIGHT" , 00)

	--DressUpFrameOutfitDropDown:ClearAllPoints()
	--DressUpFrameOutfitDropDown:SetSize(1,1)
	--DressUpFrameOutfitDropDown:SetPoint("LEFT", UIParent, "LEFT", -1000,-1000)
	--DressUpFrameOutfitDropDown:Hide()
	--DressUpFrameOutfitDropDownButton:Hide()
	--DressUpFrameOutfitDropDown.SaveButton:Hide()
	--for index, button in pairs(BW_DressingRoomFrame.PreviewButtonFrame.Slots) do
		--S:HandleItemButton(button)
		--button.IconBorder:SetColorTexture(1, 1, 1, 0.1)
	--end

	S:HandleDropDownBox(_G.BW_DressingRoomFrameOutfitDropdown, 145)
	S:HandleButton(_G.BW_DressingRoomFrameOutfitDropdown.SaveButton, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, 'right')

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
	local BetterWardrobeOutfitEditFrame = _G.BetterWardrobeOutfitEditFrame
	BetterWardrobeOutfitEditFrame:StripTextures()
	BetterWardrobeOutfitEditFrame:CreateBackdrop('Transparent')
	BetterWardrobeOutfitEditFrame.EditBox:StripTextures()
	S:HandleEditBox(BetterWardrobeOutfitEditFrame.EditBox)
	S:HandleButton(BetterWardrobeOutfitEditFrame.AcceptButton)
	S:HandleButton(BetterWardrobeOutfitEditFrame.CancelButton)
	S:HandleButton(BetterWardrobeOutfitEditFrame.DeleteButton)
end

addon.ElvUI_init = false
local eventFrame
local function applySkins()
	if not (E.private.skins.blizzard.enable) then return end
	if not E.private.skins.blizzard.enable then return end
	if E.private.skins.blizzard.transmogrify then SkinTransmogFrames() end
	if E.private.skins.blizzard.dressingroom then UpdateDressingRoom() end
end

addon.ApplyElvUISkin = applySkins


function S:BetterWardrobe()
	if not (E.private.skins.blizzard.enable) then return end
	addon.ElvUI_init = true


--We can only skin the addon after the Blizzard Collection addon is loaded.  Forcing loading
--causes elvui to not skin it properly.  We wait until it gets loaded and then set the skin

end

S:AddCallbackForAddon('BetterWardrobe')
E:RegisterModule(MyPlugin:GetName())  --Register the module with ElvUI. ElvUI will now call MyPlugin:Initialize() when ElvUI is ready to load our plugin.
--saddon:RegisterMessage("BW_ADDON_LOADED", function() C_Timer.After(5, applySkins) end)