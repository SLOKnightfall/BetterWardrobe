local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

--Stubs to for when ExtendedSets is not loaded
function addon:InitExtendedSetsSwap() 
end

function addon:ResetSetsCollectionFrame()
end
--local oldScrollToSet =  WardrobeCollectionFrame.SetsCollectionFrame.ScrollToSet
--local oldDisplaySet =  WardrobeCollectionFrame.SetsCollectionFrame.DisplaySet
--SetsDataProvider = CreateFromMixins(WardrobeSetsDataProviderMixin);

if not IsAddOnLoaded("ExtendedSets") then return end

function addon:InitExtendedSetsSwap() 
	local button = CreateFrame("Button", nil, CollectionsJournal)
	addon.ExtendedTransmogSwap = button

	button:SetSize(20, 20)
	button.tooltip = L["Swap to Extended Transmog Sets View"]
	button.Texture = button:CreateTexture(nil,"ARTWORK")
	button.Texture:SetPoint("CENTER")
	button.Texture:SetSize(22,22)
	button.Texture:SetAtlas("transmog-icon-revert-small")
	button:SetPoint("TOPLEFT", 55, -45)
	button:SetFrameLevel(700)
	button:SetScript("OnClick", 
		function()  
			if BetterWardrobeCollectionFrame:IsShown() then
				BetterWardrobeCollectionFrame:Hide()
				WardrobeCollectionFrame:Show()
				button.tooltip = L["Swap to Better Wardrobe View"]

			else
				BetterWardrobeCollectionFrame:Show()
				WardrobeCollectionFrame:Hide()
				button.tooltip = L["Swap to Extended Transmog Sets View"]
			end
		end	)

	button:SetScript("OnEnter", function(button) GameTooltip:SetOwner(button, "ANCHOR_RIGHT"); GameTooltip:SetText(button.tooltip);end)
	button:SetScript("OnLeave", function(button) GameTooltip:Hide() end)
end

--Overwrites changes to WardrobeCollectionFrame functions by ExtendedSets
function addon:ResetSetsCollectionFrame()
	Mixin(WardrobeCollectionFrame.SetsCollectionFrame, WardrobeSetsCollectionMixin);
	WardrobeCollectionFrame.SetsCollectionFrame.SetsDataProvider= CreateFromMixins(WardrobeSetsDataProviderMixin);
	WardrobeCollectionFrame.GoToSet = WardrobeCollectionFrameMixin.GoToSet
end

