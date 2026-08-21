if not C_AddOns.IsAddOnLoaded("Luckys_Wardrobe") then return end
local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

function addon:SuppressLuckysWardrobeConflictWarning()
	LuckysWardrobe.AddonConflicts = {}
	local frame = LuckysWardrobeAddonConflict
    frame:SetPoint("TOPRIGHT", 120, 120)
    frame:SetSize(0,0)
    frame:Hide()
end

local DICE_ICON = "Interface\\AddOns\\Luckys_Wardrobe\\Images\\icons\\dice"

local previewDice, previewColourDice
hooksecurefunc(LuckysWardrobe.Utils, "BareIcon", function(button, icon)
	if icon ~= DICE_ICON then return end
	local preview = TransmogFrame and TransmogFrame.CharacterPreview
	if not preview or button:GetParent() ~= preview then return end

	if not previewDice then
		previewDice = button
	elseif not previewColourDice then
		previewColourDice = button
	end
end)

local function findLuckySaveSituationButton()
	local loadButton = LuckysWardrobe.SituationPresets and LuckysWardrobe.SituationPresets.loadButton
	if not loadButton then return end

	for _, child in ipairs({loadButton:GetParent():GetChildren()}) do
		if child ~= loadButton then
			local _, relativeTo = child:GetPoint()
			if relativeTo == loadButton then
				return child
			end
		end
	end
end

local function findLuckyExtraSetsTab()
	local wardrobe = TransmogFrame and TransmogFrame.WardrobeCollection
	local headers = wardrobe and wardrobe.TabHeaders
	local label = LuckysWardrobe.Strings and LuckysWardrobe.Strings.extraSets and LuckysWardrobe.Strings.extraSets.tab
	if not headers or not headers.tabs or not label then return end

	local ours = headers.extrasetsTabID and headers:GetTabButton(headers.extrasetsTabID)
	for _, tabButton in ipairs(headers.tabs) do
		if tabButton ~= ours and tabButton.Text and tabButton.Text:GetText() == label then
			return tabButton, headers
		end
	end
end

local function hideLuckyPreviewLocks()
	local preview = TransmogFrame and TransmogFrame.CharacterPreview
	local pool = preview and preview.CharacterAppearanceSlotFramePool
	if not pool then return end

	for slotFrame in pool:EnumerateActive() do
		if slotFrame.luckysWardrobeLock then
			slotFrame.luckysWardrobeLock:Hide()
		end
	end
end

if _G.paintLocks then
	hooksecurefunc("paintLocks", function()
		if addon.UseBetterWardrobeUI then
			hideLuckyPreviewLocks()
		end
	end)
end

function addon:ApplyLuckysWardrobeVendorUI(useBetter)
	local luckyStrip = LuckysWardrobe.TransmogItems and LuckysWardrobe.TransmogItems.vendorStrip
	if luckyStrip then
		luckyStrip:SetShown(not useBetter)
	end

	if useBetter then
		hideLuckyPreviewLocks()
	end

	local luckyExtraSetsTab, headers = findLuckyExtraSetsTab()
	if luckyExtraSetsTab then
		luckyExtraSetsTab:SetShown(not useBetter)
		headers:MarkDirty()
	end

	if previewDice then
		previewDice:SetShown(not useBetter)
	end
	if previewColourDice then
		local pickedColour = LuckysWardrobe.TransmogItems.PickedColour and LuckysWardrobe.TransmogItems.PickedColour()
		previewColourDice:SetShown(not useBetter and pickedColour ~= nil)
	end

	local saveButton = findLuckySaveSituationButton()
	if saveButton then
		saveButton:SetShown(not useBetter)
	end
	if LuckysWardrobe.SituationPresets and LuckysWardrobe.SituationPresets.loadButton then
		LuckysWardrobe.SituationPresets.loadButton:SetShown(not useBetter)
	end
end
