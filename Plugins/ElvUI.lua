--[[
	Elvui Plugin to reskin new/changed UI
]]

if not IsAddOnLoaded("ElvUI") then return end
local addonName, addon = ...

local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MyPlugin = E:NewModule('addonName', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0'); --Create a plugin within ElvUI and adopt AceHook-3.0, AceEvent-3.0 and AceTimer-3.0. We can make use of these later.
local EP = LibStub("LibElvUIPlugin-1.0") --We can use this to automatically insert our GUI tables when ElvUI_Config is loaded.
local S = E:GetModule('Skins')

function MyPlugin:Initialize()
	--Register plugin so options are properly inserted when config is loaded
	EP:RegisterPlugin(addonName, MyPlugin.InsertOptions)

	--Collection Frame Tabs
	local BW_WardrobeCollectionFrame = _G.BW_WardrobeCollectionFrame
	local BW_SortDropDown = _G.BW_SortDropDown
	S:HandleTab(BW_WardrobeCollectionFrame.ItemsTab)
	S:HandleTab(BW_WardrobeCollectionFrame.SetsTab)
	S:HandleTab(BW_WardrobeCollectionFrame.ExtraSetsTab)

	UIDropDownMenu_SetWidth(BW_SortDropDown, 100)
	S:HandleDropDownBox(BW_SortDropDown)
	

	--BW_SetsTransmogFrame

	S:HandleButton(BW_WardrobeCollectionFrame.FilterButton)

	BW_SetsTransmogFrame:StripTextures()
	BW_SetsTransmogFrame:SetTemplate("Transparent")
	S:HandleNextPrevButton(BW_SetsTransmogFrame.PagingFrame.NextPageButton)
	S:HandleNextPrevButton(BW_SetsTransmogFrame.PagingFrame.PrevPageButton)

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
end

	--Sets
	local SetsCollectionFrame = BW_WardrobeCollectionFrame.BW_SetsCollectionFrame
	SetsCollectionFrame.RightInset:StripTextures()
	SetsCollectionFrame:SetTemplate("Transparent")
	SetsCollectionFrame.LeftInset:StripTextures()

	local ScrollFrame = BW_SetsCollectionFrame.ScrollFrame
	S:HandleScrollBar(ScrollFrame.scrollBar)
	for i = 1, #ScrollFrame.buttons do
		local bu = ScrollFrame.buttons[i]
		S:HandleItemButton(bu)
		bu.Favorite:SetAtlas("PetJournal-FavoritesIcon", true)
		bu.Favorite:Point("TOPLEFT", bu.Icon, "TOPLEFT", -8, 8)
		bu.SelectedTexture:SetColorTexture(1, 1, 1, 0.1)
	end

E:RegisterModule(MyPlugin:GetName()) --Register the module with ElvUI. ElvUI will now call MyPlugin:Initialize() when ElvUI is ready to load our plugin.