local addonName, addon = ...

addon = addon or {}
_G[addonName] = addon

addon.name = addonName
addon.version = C_AddOns.GetAddOnMetadata(addonName, "Version") or "dev"
addon.callbacks = addon.callbacks or {}

local DEFAULTS = {
    general = {
        ignoreClassRestrictions = false,
    },
    transmog = {
        applyOnClick = false,
        showIncomplete = true,
        showHidden = false,
        hideMissing = true,
        useHiddenForMissing = true,
        partialLimit = 4,
        showNames = true,
        showSetCount = true,
    },
    dressingRoom = {
        enabled = true,
        dimBackground = false,
        hideBackground = false,
        startUndressed = false,
        hideWeapons = false,
        hideShirt = false,
        hideTabard = false,
        customSize = true,
        width = 600,
        height = 800,
        sizeRevision = 2,
    },
    sorting = {
        items = "default",
        sets = "default",
        extraSets = "default",
        weaponSets = "default",
        reverse = false,
    },
    filters = {
        itemExpansion = -1,
        itemColor = nil,
        setExpansion = -1,
        setColor = nil,
        extraSetsExpansion = -1,
        extraSetsColor = nil,
        extraSetsCollected = true,
        extraSetsUncollected = true,
        weaponSetsExpansion = -1,
        weaponSetsColor = nil,
        weaponSetsCollected = true,
        weaponSetsUncollected = true,
        colorTolerance = 17,
    },
}


local function GetLegacyProfile()
    local legacyDB = _G.BetterWardrobe_Options
    if type(legacyDB) ~= "table" then
        return nil
    end

    if type(legacyDB.profile) == "table" then
        return legacyDB.profile
    end

    local profiles = legacyDB.profiles
    if type(profiles) ~= "table" then
        return nil
    end

    local characterKey
    local playerName = UnitName and UnitName("player")
    local realmName = GetRealmName and GetRealmName()
    if playerName and realmName then
        characterKey = playerName .. " - " .. realmName
    end

    local profileName = characterKey and legacyDB.profileKeys and legacyDB.profileKeys[characterKey]
    if profileName and type(profiles[profileName]) == "table" then
        return profiles[profileName]
    end

    if type(profiles.Default) == "table" then
        return profiles.Default
    end

    for _, profile in pairs(profiles) do
        if type(profile) == "table" then
            return profile
        end
    end

    return nil
end

local function CopyLegacyValue(target, targetKey, source, sourceKey)
    if target[targetKey] == nil and source[sourceKey] ~= nil then
        target[targetKey] = source[sourceKey]
    end
end

local function MigrateLegacyOptions(database)
    if tonumber(database.legacyOptionsRevision) and database.legacyOptionsRevision >= 1 then
        return
    end

    local legacy = GetLegacyProfile()
    if type(legacy) == "table" then
        database.general = database.general or {}
        database.transmog = database.transmog or {}
        database.dressingRoom = database.dressingRoom or {}

        CopyLegacyValue(database.general, "ignoreClassRestrictions", legacy, "IgnoreClassRestrictions")

        CopyLegacyValue(database.transmog, "applyOnClick", legacy, "AutoApply")
        CopyLegacyValue(database.transmog, "showIncomplete", legacy, "ShowIncomplete")
        CopyLegacyValue(database.transmog, "showHidden", legacy, "ShowHidden")
        CopyLegacyValue(database.transmog, "hideMissing", legacy, "HideMissing")
        CopyLegacyValue(database.transmog, "useHiddenForMissing", legacy, "HiddenMog")
        CopyLegacyValue(database.transmog, "partialLimit", legacy, "PartialLimit")
        CopyLegacyValue(database.transmog, "showNames", legacy, "ShowNames")
        CopyLegacyValue(database.transmog, "showSetCount", legacy, "ShowSetCount")

        CopyLegacyValue(database.dressingRoom, "enabled", legacy, "DR_OptionsEnable")
        CopyLegacyValue(database.dressingRoom, "dimBackground", legacy, "DR_DimBackground")
        CopyLegacyValue(database.dressingRoom, "hideBackground", legacy, "DR_HideBackground")
        CopyLegacyValue(database.dressingRoom, "startUndressed", legacy, "DR_StartUndressed")
        CopyLegacyValue(database.dressingRoom, "hideWeapons", legacy, "DR_HideWeapons")
        CopyLegacyValue(database.dressingRoom, "hideShirt", legacy, "DR_HideShirt")
        CopyLegacyValue(database.dressingRoom, "hideTabard", legacy, "DR_HideTabard")
        CopyLegacyValue(database.dressingRoom, "customSize", legacy, "DR_ResizeWindow")
        CopyLegacyValue(database.dressingRoom, "width", legacy, "DR_Width")
        CopyLegacyValue(database.dressingRoom, "height", legacy, "DR_Height")
    end

    database.legacyOptionsRevision = 1
end

local function CopyDefaults(source, target)
    for key, value in pairs(source) do
        if type(value) == "table" then
            if type(target[key]) ~= "table" then
                target[key] = {}
            end
            CopyDefaults(value, target[key])
        elseif target[key] == nil then
            target[key] = value
        end
    end
end

function addon:InitializeDatabase()
    BetterWardrobe_NativeDB = BetterWardrobe_NativeDB or {}
    MigrateLegacyOptions(BetterWardrobe_NativeDB)

    local existingDressingRoom = BetterWardrobe_NativeDB.dressingRoom
    local previousSizeRevision = existingDressingRoom and tonumber(existingDressingRoom.sizeRevision) or 0

    CopyDefaults(DEFAULTS, BetterWardrobe_NativeDB)

    local dressingRoom = BetterWardrobe_NativeDB.dressingRoom
    if previousSizeRevision < 2 then
        -- Migrate the original native-dev 700 x 700 default without overwriting
        -- users who already selected a different custom size.
        if tonumber(dressingRoom.width) == 700 and tonumber(dressingRoom.height) == 700 then
            dressingRoom.width = 600
            dressingRoom.height = 800
        end
        dressingRoom.sizeRevision = 2
    end

    -- Builds .24-.29 added saved Expansion/Color selectors to the native
    -- Items/Appearances Filter menu. The production color wheel is transient,
    -- so clear those retired saved values once when returning to that behavior.
    if (tonumber(BetterWardrobe_NativeDB.appearanceFilterRevision) or 0) < 1 then
        BetterWardrobe_NativeDB.filters.itemExpansion = -1
        BetterWardrobe_NativeDB.filters.itemColor = nil
        BetterWardrobe_NativeDB.appearanceFilterRevision = 1
    end

    self.db = BetterWardrobe_NativeDB
end

function addon:RegisterCallback(eventName, callback)
    if type(callback) ~= "function" then
        return
    end

    self.callbacks[eventName] = self.callbacks[eventName] or {}
    table.insert(self.callbacks[eventName], callback)
end

function addon:FireCallback(eventName, ...)
    local callbacks = self.callbacks[eventName]
    if not callbacks then
        return
    end

    for _, callback in ipairs(callbacks) do
        callback(...)
    end
end

function addon:IsApplyOnClickEnabled()
    return self.db and self.db.transmog and self.db.transmog.applyOnClick == true
end

function addon:SetApplyOnClickEnabled(enabled)
    if not self.db or not self.db.transmog then
        return
    end

    enabled = enabled == true
    if self.db.transmog.applyOnClick == enabled then
        return
    end

    self.db.transmog.applyOnClick = enabled
    self:FireCallback("APPLY_ON_CLICK_CHANGED", enabled)
end

function addon:OpenAppearances()
    if not C_AddOns.IsAddOnLoaded("Blizzard_Collections") then
        local loaded = C_AddOns.LoadAddOn("Blizzard_Collections")
        if not loaded then
            return false
        end
    end

    if ToggleCollectionsJournal then
        ToggleCollectionsJournal(5)
        return true
    end

    return false
end

function addon:OpenSettings()
    if self.settingsCategory and Settings and Settings.OpenToCategory then
        Settings.OpenToCategory(self.settingsCategory:GetID())
        return true
    end

    return false
end

function addon:ToggleDressingRoom()
    if not C_AddOns.IsAddOnLoaded("Blizzard_UIPanels_Game") then
        local loaded = C_AddOns.LoadAddOn("Blizzard_UIPanels_Game")
        if not loaded then
            return false
        end
    end

    local frame = _G.DressUpFrame
    if not frame then
        return false
    end

    if frame:IsShown() then
        HideUIPanel(frame)
    elseif type(_G.DressUpFrame_Show) == "function" then
        DressUpFrame_Show(frame)
    else
        ShowUIPanel(frame)
    end

    return true
end

function BetterWardrobe_OpenAppearances()
    return addon:OpenAppearances()
end

function BetterWardrobe_ToggleDressingRoom()
    return addon:ToggleDressingRoom()
end

_G.BINDING_HEADER_BETTERWARDROBE = "BetterWardrobe"
_G.BINDING_NAME_BETTERWARDROBE_OPEN_APPEARANCES = "Open Appearances"
_G.BINDING_NAME_BETTERWARDROBE_TOGGLE_DRESSINGROOM = "Toggle Dressing Room"

function BetterWardrobe_OnAddonCompartmentClick(_, buttonName)
    if buttonName == "RightButton" then
        addon:OpenSettings()
    else
        addon:OpenAppearances()
    end
end

SLASH_BETTERWARDROBE1 = "/betterwardrobe"
SLASH_BETTERWARDROBE2 = "/bw"
SlashCmdList.BETTERWARDROBE = function(message)
    local command = strtrim(message or ""):lower()
    if command == "settings" or command == "options" then
        addon:OpenSettings()
    elseif command == "catalog" then
        if addon.PrintCatalogSummary then
            addon:PrintCatalogSummary()
        end
    elseif command == "audit" then
        if addon.RunCatalogAudit then
            addon:RunCatalogAudit()
        elseif addon.PrintCatalogSummary then
            addon:PrintCatalogSummary()
        end
    else
        addon:OpenAppearances()
    end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(_, event, loadedAddon)
    if event ~= "ADDON_LOADED" or loadedAddon ~= addonName then
        return
    end

    addon:InitializeDatabase()
    addon:FireCallback("DATABASE_READY")
end)
