local addonName, addon = ...

if not C_AddOns.IsAddOnLoaded("ElvUI") or not _G.ElvUI then
    return
end

local E = unpack(_G.ElvUI)
local S = E and E:GetModule("Skins")
if not E or not S then
    return
end

local function CollectionsSkinEnabled()
    local blizzard = E.private and E.private.skins and E.private.skins.blizzard
    return blizzard and blizzard.enable and blizzard.collections
end

local function SkinListButton(button)
    if not button or button.BetterWardrobeElvUISkinned then
        return
    end

    button.BetterWardrobeElvUISkinned = true

    local icon = button.Icon or (button.IconFrame and button.IconFrame.Icon)
    if icon then
        S:HandleIcon(icon, true)
        icon:SetDrawLayer("ARTWORK")
    end

    if button.Background then
        button.Background:Hide()
    end

    if button.Selected then
        button.Selected:SetTexture(E.media.blankTex)
        button.Selected:SetVertexColor(1, 0.8, 0.1, 0.20)
        button.Selected:SetAllPoints(button)
    end

    if button.Highlight then
        button.Highlight:SetTexture(E.media.blankTex)
        button.Highlight:SetVertexColor(1, 1, 1, 0.12)
        button.Highlight:SetBlendMode("BLEND")
        button.Highlight:SetAllPoints(button)
    end
end

local function SkinDetailButton(button)
    if not button or button.BetterWardrobeElvUISkinned then
        return
    end

    button.BetterWardrobeElvUISkinned = true

    if button.Border then
        button.Border:SetAlpha(0)
    end

    if button.Icon then
        S:HandleIcon(button.Icon, true)
        button.Icon:SetDrawLayer("ARTWORK")
    end

    if button.Highlight then
        button.Highlight:SetTexture(E.media.blankTex)
        button.Highlight:SetVertexColor(1, 1, 1, 0.25)
        button.Highlight:SetBlendMode("BLEND")
        if button.Icon then
            button.Highlight:SetAllPoints(button.Icon)
        else
            button.Highlight:SetAllPoints(button)
        end
    end
end

local function RefreshDetailButtonBorders(panel)
    if not panel or not panel.DetailButtons then
        return
    end

    local defaultR, defaultG, defaultB = unpack(E.media.bordercolor)
    for _, button in ipairs(panel.DetailButtons) do
        local backdrop = button.Icon and button.Icon.backdrop
        if backdrop then
            if panel.panelType == "weaponSets" and button.sourceID and button.sourceID == panel.activeSourceID then
                backdrop:SetBackdropBorderColor(1, 0.8, 0.1)
            else
                backdrop:SetBackdropBorderColor(defaultR, defaultG, defaultB)
            end
        end
    end
end

local function SkinCollectionPanel(panel)
    if not panel or panel.BetterWardrobeElvUISkinned then
        return
    end

    panel.BetterWardrobeElvUISkinned = true
    panel:StripTextures()

    if panel.LeftInset then
        panel.LeftInset:StripTextures()
        panel.LeftInset:SetTemplate("Transparent")
    end

    if panel.RightInset then
        panel.RightInset:StripTextures()
        panel.RightInset:SetTemplate("Transparent")
    end

    if panel.SearchBox then
        S:HandleEditBox(panel.SearchBox)
    end

    if panel.VariantDropdown then
        S:HandleDropDownBox(panel.VariantDropdown, panel.VariantDropdown:GetWidth())
    end

    if panel.UpButton then
        S:HandleNextPrevButton(panel.UpButton, "up")
    end

    if panel.DownButton then
        S:HandleNextPrevButton(panel.DownButton, "down")
    end

    if panel.DressUpButton then
        S:HandleButton(panel.DressUpButton)
    end

    if panel.ModelFade then
        panel.ModelFade:Hide()
    end

    if panel.IconBackground then
        panel.IconBackground:Hide()
    end

    if panel.Name and panel.Name.FontTemplate then
        panel.Name:FontTemplate(nil, 18, "SHADOW")
    end

    if panel.Label and panel.Label.FontTemplate then
        panel.Label:FontTemplate(nil, 12, "SHADOW")
    end

    if panel.Progress and panel.Progress.FontTemplate then
        panel.Progress:FontTemplate(nil, 12, "SHADOW")
    end

    if panel.ListButtons then
        for _, button in ipairs(panel.ListButtons) do
            SkinListButton(button)
        end
    end

    if panel.DetailButtons then
        for _, button in ipairs(panel.DetailButtons) do
            SkinDetailButton(button)
        end
    end

    if panel.RefreshPreview then
        hooksecurefunc(panel, "RefreshPreview", function(self)
            C_Timer.After(0, function()
                if self and self:IsShown() then
                    RefreshDetailButtonBorders(self)
                end
            end)
        end)
    end

    RefreshDetailButtonBorders(panel)
end

local function ApplyElvUISkin(wardrobe, extraPanel, weaponPanel)
    if not CollectionsSkinEnabled() or not wardrobe then
        return
    end

    if wardrobe.ExtraSetsTab then
        S:HandleTab(wardrobe.ExtraSetsTab)
    end

    if wardrobe.WeaponSetsTab then
        S:HandleTab(wardrobe.WeaponSetsTab)
    end

    if addon.LayoutWardrobeTabs then
        addon:LayoutWardrobeTabs()
    end

    SkinCollectionPanel(extraPanel or wardrobe.BetterWardrobeExtraSetsFrame)
    SkinCollectionPanel(weaponPanel or wardrobe.BetterWardrobeWeaponSetsFrame)
end

addon:RegisterCallback("COLLECTION_EXTENSIONS_READY", ApplyElvUISkin)
addon:RegisterCallback("NATIVE_WARDROBE_SHOWN", function(wardrobe)
    ApplyElvUISkin(wardrobe)
end)

C_Timer.After(0, function()
    local wardrobe = _G.WardrobeCollectionFrame
    if wardrobe then
        ApplyElvUISkin(wardrobe)
    end
end)
