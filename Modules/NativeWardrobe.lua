local addonName, addon = ...

-- This module intentionally does not create or replace any wardrobe frames.
-- Blizzard_Collections owns the Appearances window, tabs, item models, set models,
-- player-form resolution, camera selection, filtering, searching, and tooltips.

local initialized = false

local function GetNativeWardrobeFrame()
    return _G.WardrobeCollectionFrame
end

function addon:GetWardrobeFrame()
    return GetNativeWardrobeFrame()
end

function addon:GetItemsCollectionFrame()
    local wardrobeFrame = GetNativeWardrobeFrame()
    return wardrobeFrame and wardrobeFrame.ItemsCollectionFrame or nil
end

function addon:GetSetsCollectionFrame()
    local wardrobeFrame = GetNativeWardrobeFrame()
    return wardrobeFrame and wardrobeFrame.SetsCollectionFrame or nil
end

local function NotifyNativeWardrobeShown()
    local wardrobeFrame = GetNativeWardrobeFrame()
    if wardrobeFrame and wardrobeFrame:IsShown() then
        addon:FireCallback("NATIVE_WARDROBE_SHOWN", wardrobeFrame)
    end
end

local function InitializeNativeWardrobeHooks()
    if initialized then
        return
    end

    local wardrobeFrame = GetNativeWardrobeFrame()
    if not wardrobeFrame then
        return
    end

    initialized = true
    wardrobeFrame:HookScript("OnShow", NotifyNativeWardrobeShown)

    if wardrobeFrame.ItemsCollectionFrame then
        wardrobeFrame.ItemsCollectionFrame:HookScript("OnShow", function(frame)
            addon:FireCallback("NATIVE_ITEMS_SHOWN", frame)
        end)
    end

    if wardrobeFrame.SetsCollectionFrame then
        wardrobeFrame.SetsCollectionFrame:HookScript("OnShow", function(frame)
            addon:FireCallback("NATIVE_SETS_SHOWN", frame)
        end)
    end
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:SetScript("OnEvent", function(_, _, loadedAddon)
    if loadedAddon == "Blizzard_Collections" then
        InitializeNativeWardrobeHooks()
    end
end)

if C_AddOns.IsAddOnLoaded("Blizzard_Collections") then
    InitializeNativeWardrobeHooks()
end
