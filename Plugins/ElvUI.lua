--[[
	Elvui Plugin to reskin new/changed UI
]]

if not C_AddOns.IsAddOnLoaded("ElvUI") then return end
local addonName, addon = ...

local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

local _G = _G
local ipairs, pairs, unpack = ipairs, pairs, unpack

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc

local MyPlugin = E:NewModule('addonName', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0') --Create a plugin within ElvUI and adopt AceHook-3.0, AceEvent-3.0 and AceTimer-3.0. We can make use of these later.
local EP = LibStub("LibElvUIPlugin-1.0") --We can use this to automatically insert our GUI tables when ElvUI_Config is loaded.


function MyPlugin:Initialize()
	--Register plugin so options are properly inserted when config is loaded
	EP:RegisterPlugin(addonName, MyPlugin.InsertOptions)
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
	----S:HandleDropDownBox(_G.BW_CollectionList_Dropdown, 145)
	----S:HandleDropDownBox(_G.BW_SavedOutfitDropDown, 145)

	--S:HandleButton(_G.BW_CollectionListButton, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, 'right')

	--S:HandleButton(_G.BW_CollectionListOptionsButton, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, 'right')

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
			S:HandleNextPrevButton(paging.FirstPageButton, nil, nil, true)
			S:HandleNextPrevButton(paging.LastPageButton, "up", nil, true)
			S:HandleEditBox(paging.PageInput)
		end
	end

	local SetsCollectionFrame = BetterWardrobeCollectionFrame.SetsCollectionFrame
	SetsCollectionFrame:SetTemplate('Transparent')
	SetsCollectionFrame.RightInset:StripTextures()
	SetsCollectionFrame.LeftInset:StripTextures()
	S:HandleTrimScrollBar(SetsCollectionFrame.ListContainer.ScrollBar)

	local DetailsFrame = SetsCollectionFrame.DetailsFrame
	DetailsFrame.ModelFadeTexture:Hide()
	DetailsFrame.IconRowBackground:Hide()
	DetailsFrame.Name:FontTemplate(nil, 16)
	DetailsFrame.LongName:FontTemplate(nil, 16)
	S:HandleDropDownBox(DetailsFrame.VariantSetsDropdown)

	S:HandleButton(DetailsFrame.BW_LinkSetButton)
	S:HandleButton(DetailsFrame.BW_OpenDressingRoomButton)
	DetailsFrame.BW_LinkSetButton:SetSize(20,20)
	DetailsFrame.BW_OpenDressingRoomButton:SetSize(20,20)

	S:HandleButton(BetterWardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame.BW_SetsHideSlotButton)
	BetterWardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame.BW_SetsHideSlotButton:SetSize(20,20)

	BetterWardrobeCollectionFrame.ItemsCollectionFrame:StripTextures()
	BetterWardrobeCollectionFrame.ItemsCollectionFrame:SetTemplate('Transparent')

	local WardrobeOutfitEditFrame = _G.BetterWardrobeOutfitEditFrame
	WardrobeOutfitEditFrame:StripTextures()
	WardrobeOutfitEditFrame:SetTemplate('Transparent')
	WardrobeOutfitEditFrame.EditBox:StripTextures()
	S:HandleEditBox(WardrobeOutfitEditFrame.EditBox)
	S:HandleButton(WardrobeOutfitEditFrame.AcceptButton)
	S:HandleButton(WardrobeOutfitEditFrame.CancelButton)
	S:HandleButton(WardrobeOutfitEditFrame.DeleteButton)

	--Transmog frames

	for _, tab in next, { TransmogFrame.WardrobeCollection.TabHeaders:GetChildren() } do
		S:HandleTab(tab)
	end
	local frame = TransmogFrame.WardrobeCollection.TabContent.ItemsFrame
	if frame then
		S:HandleNextPrevButton(frame.PagedContent.PagingControls.PrevPageButton)
		S:HandleNextPrevButton(frame.PagedContent.PagingControls.NextPageButton)
		S:HandleNextPrevButton(frame.PagedContent.PagingControls.FirstPageButton)
		S:HandleNextPrevButton(frame.PagedContent.PagingControls.LastPageButton, "up")
		S:HandleEditBox(frame.PagedContent.PagingControls.PageInput)
	end
	local frame = TransmogFrame.WardrobeCollection.TabContent.BW_SetsFrame2
	if frame then
		S:HandleButton(frame.SearchBox)
		S:HandleButton(frame.FilterButton, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, 'right')

		S:HandleNextPrevButton(frame.PagedContent.PagingControls.PrevPageButton)
		S:HandleNextPrevButton(frame.PagedContent.PagingControls.NextPageButton)
		S:HandleNextPrevButton(frame.PagedContent.PagingControls.FirstPageButton)
		S:HandleNextPrevButton(frame.PagedContent.PagingControls.LastPageButton, "up")
		S:HandleEditBox(frame.PagedContent.PagingControls.PageInput)
	end

	local frame = TransmogFrame.WardrobeCollection.TabContent.BW_ExtraSetsFrame
	if frame then
		S:HandleButton(frame.SearchBox)
		S:HandleButton(frame.FilterButton, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, 'right')

		S:HandleNextPrevButton(frame.PagedContent.PagingControls.PrevPageButton)
		S:HandleNextPrevButton(frame.PagedContent.PagingControls.NextPageButton)
		S:HandleNextPrevButton(frame.PagedContent.PagingControls.FirstPageButton)
		S:HandleNextPrevButton(frame.PagedContent.PagingControls.LastPageButton, "up")
		S:HandleEditBox(frame.PagedContent.PagingControls.PageInput)
	end

	local CustomSetsFrame = TransmogFrame.WardrobeCollection.TabContent.BW_ExtraCustomSetsFrame
	if CustomSetsFrame then
		S:HandleButton(CustomSetsFrame.NewCustomSetButton, nil, nil, nil, true, nil, nil, nil, true)

		S:HandleNextPrevButton(CustomSetsFrame.PagedContent.PagingControls.PrevPageButton)
		S:HandleNextPrevButton(CustomSetsFrame.PagedContent.PagingControls.NextPageButton)
		S:HandleNextPrevButton(CustomSetsFrame.PagedContent.PagingControls.FirstPageButton)
		S:HandleNextPrevButton(CustomSetsFrame.PagedContent.PagingControls.LastPageButton, "up")
		S:HandleEditBox(CustomSetsFrame.PagedContent.PagingControls.PageInput)
	end
end

local function UpdateDressingRoom()
	local BetterWardrobeOutfitEditFrame = _G.BetterWardrobeOutfitEditFrame
	BetterWardrobeOutfitEditFrame:StripTextures()
	BetterWardrobeOutfitEditFrame:CreateBackdrop('Transparent')
	BetterWardrobeOutfitEditFrame.EditBox:StripTextures()
	S:HandleEditBox(BetterWardrobeOutfitEditFrame.EditBox)
	S:HandleButton(BetterWardrobeOutfitEditFrame.AcceptButton)
	S:HandleButton(BetterWardrobeOutfitEditFrame.CancelButton)
	S:HandleButton(BetterWardrobeOutfitEditFrame.DeleteButton)
end

local function SkinAltAppearancePopout()
	local f = _G.BW_AltAppearancePopout
	if not f or f.ElvUISkinned then return end
	f.ElvUISkinned = true

	f:StripTextures()
	f:SetTemplate('Transparent')
	S:HandleCloseButton(f.CloseButton)
	S:HandleScrollBar(f.ScrollFrame.ScrollBar)
end
hooksecurefunc(addon, 'ShowAltAppearancePopup', SkinAltAppearancePopout)

local function SkinCharacterPickerPopout(f)
	if not f or f.ElvUISkinned then return f end
	f.ElvUISkinned = true

	f:StripTextures()
	f:SetTemplate('Transparent')
	S:HandleEditBox(f.SearchBox)
	S:HandleScrollBar(f.ScrollFrame.ScrollBar)
	return f
end
local orig_CreateCharacterPickerPopout = addon.CreateCharacterPickerPopout
addon.CreateCharacterPickerPopout = function(self, owner, config)
	return SkinCharacterPickerPopout(orig_CreateCharacterPickerPopout(self, owner, config))
end

local function SkinColorFilterButtons()
	if addon.ColorFilterButton then
		S:HandleButton(addon.ColorFilterButton)
		if addon.ColorFilterButton.revert then
			S:HandleButton(addon.ColorFilterButton.revert)
		end
	end
end
hooksecurefunc(addon.Init, 'InitFilterButtons', SkinColorFilterButtons)

addon.ElvUI_init = false
local function applySkins()
	if not (E.private.skins.blizzard.enable) then return end
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