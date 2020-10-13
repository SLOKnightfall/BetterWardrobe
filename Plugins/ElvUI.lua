--[[
	Elvui Plugin to reskin new/changed UI
]]

if not IsAddOnLoaded("ElvUI") then return end
local addonName, addon = ...

local E, L, V, P, G = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MyPlugin = E:NewModule('addonName', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0') --Create a plugin within ElvUI and adopt AceHook-3.0, AceEvent-3.0 and AceTimer-3.0. We can make use of these later.
local EP = LibStub("LibElvUIPlugin-1.0") --We can use this to automatically insert our GUI tables when ElvUI_Config is loaded.
local S = E:GetModule('Skins')

function MyPlugin:Initialize()
	--Register plugin so options are properly inserted when config is loaded
	EP:RegisterPlugin(addonName, MyPlugin.InsertOptions)
end

function S:BetterWardrobe()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.collections) then return end

	--Collection Frame Tabs
	local BW_WardrobeCollectionFrame = _G.BW_WardrobeCollectionFrame
	local SetsCollectionFrame = _G.BW_WardrobeCollectionFrame.BW_SetsCollectionFrame
	local BW_SortDropDown = _G.BW_SortDropDown
	local BW_DBSavedSetDropdown = _G.BW_DBSavedSetDropdown

	S:HandleTab(BW_WardrobeCollectionFrame.ItemsTab)
	S:HandleTab(BW_WardrobeCollectionFrame.SetsTab)
	S:HandleTab(BW_WardrobeCollectionFrame.ExtraSetsTab)
	S:HandleTab(BW_WardrobeCollectionFrame.SavedSetsTab)

	UIDropDownMenu_SetWidth(BW_SortDropDown, 110)
	S:HandleDropDownBox(BW_SortDropDown)

	BW_SortDropDown:SetScript("OnShow", function() UIDropDownMenu_SetWidth(BW_SortDropDown, 110) end)

	S:HandleButton(DropDownList1)

--L_UIDropDownMenu_SetWidth(BW_DBSavedSetDropdown, 155)
	S:HandleDropDownBox(BW_DBSavedSetDropdown)
		BW_DBSavedSetDropdown:ClearAllPoints()
BW_DBSavedSetDropdown:SetPoint("TOPRIGHT", "BW_SortDropDown", "TOPRIGHT", -0 , 0)
	BW_DBSavedSetDropdown:SetScript("OnShow", function() UIDropDownMenu_SetWidth(BW_DBSavedSetDropdown, 155)
	BW_DBSavedSetDropdown:SetPoint("TOPRIGHT", "BW_SortDropDown", "TOPRIGHT", -0 , 0)

 end)


	--BW_DBSavedSetDropdown:SetScript("OnShow", function() L_UIDropDownMenu_SetWidth(BW_DBSavedSetDropdown, 155) end)

	S:HandleButton(BW_WardrobeCollectionFrame.FilterButton)

	BW_SetsTransmogFrame:StripTextures()
	BW_SetsTransmogFrame:SetTemplate("Transparent")

	S:HandleButton(BW_LoadQueueButton)
	BW_LoadQueueButton:ClearAllPoints()
	BW_LoadQueueButton:Point("TOPLEFT",BW_WardrobeOutfitDropDown, "TOPRIGHT", 90, -2)

	S:HandleButton(BW_RandomizeButton)
	BW_RandomizeButton:ClearAllPoints()
	BW_RandomizeButton:Point("TOPLEFT",BW_LoadQueueButton, "TOPRIGHT", 0, 0)

	BW_WardrobeOutfitFrame:StripTextures()
	BW_WardrobeOutfitFrame:SetTemplate('Transparent')
	S:HandleButton(BW_WardrobeOutfitDropDown.SaveButton)

	S:HandleDropDownBox(BW_WardrobeOutfitDropDown, 221)
	BW_WardrobeOutfitDropDown:SetHeight(34)
	BW_WardrobeOutfitDropDown.SaveButton:ClearAllPoints()
	BW_WardrobeOutfitDropDown.SaveButton:SetPoint('TOPLEFT', BW_WardrobeOutfitDropDown, 'TOPRIGHT', -2, -2)

	S:HandleScrollBar(BW_WardrobeOutfitFrameScrollFrameScrollBar)

	S:HandleButton(BW_CollectionListButton)
	S:HandleButton(BW_TransmogOptionsButton)
	--S:HandleButton(BW_WardrobeToggle)

	BW_DressingRoomFrame:SetTemplate("Transparent")
	BW_DressingRoomOutfitFrame:StripTextures()
	BW_DressingRoomOutfitFrame:SetTemplate('Transparent')





S:HandleScrollBar(BW_DressingRoomOutfitFrameScrollFrameScrollBar)
	S:HandleDropDownBox(BW_DressingRoomOutfitDropDown, 221)
	S:HandleButton(BW_DressingRoomOutfitDropDown.SaveButton)
	BW_DressingRoomOutfitDropDown:SetHeight(34)
	BW_DressingRoomOutfitDropDown.SaveButton:ClearAllPoints()
	BW_DressingRoomOutfitDropDown.SaveButton:SetPoint('TOPLEFT', BW_DressingRoomOutfitDropDown, 'TOPRIGHT', -2, -2)
	S:HandleButton(BW_DressingRoomFrame.BW_DressingRoomSettingsButton)
	S:HandleButton(BW_DressingRoomFrame.BW_DressingRoomHideArmorButton)
	S:HandleButton(BW_DressingRoomFrame.BW_DressingRoomExportButton)
	S:HandleButton(BW_DressingRoomFrame.BW_DressingRoomTargettButton)  --TODO:  Fix the spelling of the frame

for index, button in pairs(BW_DressingRoomFrame.PreviewButtonFrame.Slots) do
S:HandleItemButton(button)
	--button.IconBorder:SetColorTexture(1, 1, 1, 0.1)
end




	S:HandleIcon(BW_CollectionListButton.Icon)

	for _, Frame in ipairs(BW_WardrobeCollectionFrame.ContentFrames) do
		if Frame.Models then
			for _, Model in pairs(Frame.Models) do
				Model:SetFrameLevel(Model:GetFrameLevel() + 1)
				Model.Border:SetAlpha(0)
				Model.TransmogStateTexture:SetAlpha(0)

				local bg = CreateFrame("Frame", nil, Model)
				bg:SetAllPoints()
				bg:CreateBackdrop()
				bg.backdrop:SetOutside(Model, 2, 2)

				hooksecurefunc(Model.Border, 'SetAtlas', function(_, texture)
					local r, g, b
					if texture == "transmog-wardrobe-border-uncollected" then
						r, g, b = 1, 1, 0
					elseif texture == "transmog-wardrobe-border-unusable" then
						r, g, b =  1, 0, 0
					else
						r, g, b = unpack(E.media.bordercolor)
					end
					bg.backdrop:SetBackdropBorderColor(r, g, b)
				end)
			end
		end

		if Frame.PendingTransmogFrame then
			Frame.PendingTransmogFrame.Glowframe:SetAtlas(nil)
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

	--Sets
	SetsCollectionFrame.RightInset:StripTextures()
	SetsCollectionFrame:SetTemplate("Transparent")
	SetsCollectionFrame.LeftInset:StripTextures()

	hooksecurefunc(BW_WardrobeCollectionFrame.BW_SetsCollectionFrame, 'SetItemFrameQuality', function(_, itemFrame)
		local icon = itemFrame.Icon
		if not icon.backdrop then
			icon:CreateBackdrop()
			icon:SetTexCoord(unpack(E.TexCoords))
			itemFrame.IconBorder:Hide()
		end

		if itemFrame.collected then
			local quality = C_TransmogCollection.GetSourceInfo(itemFrame.sourceID).quality
			local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
			icon.backdrop:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			icon.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
	end)


	hooksecurefunc(addon, 'DressingRoom_SetItemFrameQuality', function(_, itemFrame)
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
	end)

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
	local DetailsFrame = BW_SetsCollectionFrame.DetailsFrame
	DetailsFrame.Name:FontTemplate(nil, 16)
	DetailsFrame.LongName:FontTemplate(nil, 16)
end

S:AddCallbackForAddon('BetterWardrobe')
E:RegisterModule(MyPlugin:GetName()) --Register the module with ElvUI. ElvUI will now call MyPlugin:Initialize() when ElvUI is ready to load our plugin.