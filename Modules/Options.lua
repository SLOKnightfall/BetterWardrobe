local addonName, addon = ...

local settingsRegistered = false

local function AddSectionHeader(layout, name, tooltip)
    if layout and type(layout.AddInitializer) == "function"
        and type(CreateSettingsListSectionHeaderInitializer) == "function" then
        layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(name, tooltip))
    end
end

local function RegisterBoolean(category, variableName, variableKey, variableTable, label, defaultValue, tooltip, callbackKey)
    local setting = Settings.RegisterAddOnSetting(
        category,
        variableName,
        variableKey,
        variableTable,
        Settings.VarType.Boolean,
        label,
        defaultValue
    )

    setting:SetValueChangedCallback(function(_, value)
        if callbackKey == "applyOnClick" then
            addon:FireCallback("APPLY_ON_CLICK_CHANGED", value == true)
        else
            addon:FireCallback("OPTIONS_CHANGED", callbackKey or variableKey, value)
        end
    end)

    Settings.CreateCheckbox(category, setting, tooltip)
    return setting
end

local function RegisterNumber(category, variableName, variableKey, variableTable, label, defaultValue, minimum, maximum, step, tooltip, callbackKey, formatter)
    local setting = Settings.RegisterAddOnSetting(
        category,
        variableName,
        variableKey,
        variableTable,
        Settings.VarType.Number,
        label,
        defaultValue
    )

    setting:SetValueChangedCallback(function(_, value)
        addon:FireCallback("OPTIONS_CHANGED", callbackKey or variableKey, value)
    end)

    local options = Settings.CreateSliderOptions(minimum, maximum, step)
    if formatter then
        options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, formatter)
    end
    Settings.CreateSlider(category, setting, options, tooltip)
    return setting
end

local function RegisterSettings()
    if settingsRegistered or not addon.db or not Settings or not Settings.RegisterVerticalLayoutCategory then
        return
    end

    settingsRegistered = true
    addon.settingsObjects = addon.settingsObjects or {}

    local rootCategory, rootLayout = Settings.RegisterVerticalLayoutCategory("BetterWardrobe")
    addon.settingsCategory = rootCategory

    -- Keep the restored production controls on the main BetterWardrobe page.
    -- This avoids opening an empty parent category when /bw options is used.
    local generalCategory = rootCategory
    local transmogCategory = rootCategory
    local dressingRoomCategory = rootCategory

    AddSectionHeader(rootLayout, "General Options", "General BetterWardrobe collection behavior.")

    addon.settingsObjects.ignoreClassRestrictions = RegisterBoolean(
        generalCategory,
        "BETTERWARDROBE_IGNORE_CLASS_RESTRICTIONS",
        "ignoreClassRestrictions",
        addon.db.general,
        "Ignore Class Restriction Filter",
        false,
        "Include armor appearances and Extra Sets outside the current character's normal class armor restriction.",
        "ignoreClassRestrictions"
    )

    AddSectionHeader(rootLayout, "Transmog Vendor Window", "Controls for BetterWardrobe's Extra Sets and Weapons tabs at a transmogrifier.")

    addon.settingsObjects.applyOnClick = RegisterBoolean(
        transmogCategory,
        "BETTERWARDROBE_APPLY_ON_CLICK",
        "applyOnClick",
        addon.db.transmog,
        "Apply On Click",
        false,
        "At a transmogrifier, clicking an Extra Set or weapon entry immediately places it into the pending outfit.",
        "applyOnClick"
    )

    RegisterBoolean(
        transmogCategory,
        "BETTERWARDROBE_SHOW_INCOMPLETE",
        "showIncomplete",
        addon.db.transmog,
        "Show Incomplete Sets",
        true,
        "Show partially collected sets in the Extra Sets and Weapons tabs at a transmogrifier.",
        "transmogFilters"
    )

    RegisterBoolean(
        transmogCategory,
        "BETTERWARDROBE_SHOW_HIDDEN",
        "showHidden",
        addon.db.transmog,
        "Show Items set to Hidden",
        false,
        "Include records marked hidden by their source data.",
        "transmogFilters"
    )

    RegisterBoolean(
        transmogCategory,
        "BETTERWARDROBE_HIDE_MISSING",
        "hideMissing",
        addon.db.transmog,
        "Hide Missing Set Pieces at Transmog Vendor",
        true,
        "When applying a partial set, explicitly hide slots that do not have an available set piece.",
        "transmogApply"
    )

    RegisterBoolean(
        transmogCategory,
        "BETTERWARDROBE_USE_HIDDEN_FOR_MISSING",
        "useHiddenForMissing",
        addon.db.transmog,
        "Use Hidden Transmog for Missing Set Pieces",
        true,
        "Use Blizzard's hidden-slot pending state for missing pieces instead of leaving those slots unchanged.",
        "transmogApply"
    )

    RegisterNumber(
        transmogCategory,
        "BETTERWARDROBE_REQUIRED_PIECES",
        "partialLimit",
        addon.db.transmog,
        "Required pieces",
        4,
        1,
        8,
        1,
        "Minimum number of collected pieces required before an incomplete set is listed at a transmogrifier.",
        "transmogFilters"
    )

    RegisterBoolean(
        transmogCategory,
        "BETTERWARDROBE_SHOW_SET_NAMES",
        "showNames",
        addon.db.transmog,
        "Show Set Names",
        true,
        "Show set names in BetterWardrobe's custom set lists.",
        "transmogDisplay"
    )

    RegisterBoolean(
        transmogCategory,
        "BETTERWARDROBE_SHOW_SET_COUNT",
        "showSetCount",
        addon.db.transmog,
        "Show Collected Count",
        true,
        "Show collected and total piece counts in BetterWardrobe's custom set lists.",
        "transmogDisplay"
    )

    AddSectionHeader(rootLayout, "Dressing Room Options", "Controls for Blizzard's native Dressing Room frame and model scene.")

    RegisterBoolean(
        dressingRoomCategory,
        "BETTERWARDROBE_DRESSING_ROOM_ENABLE",
        "enabled",
        addon.db.dressingRoom,
        "Enable Dressing Room options",
        true,
        "Enable BetterWardrobe's Dressing Room sizing and display options.",
        "dressingRoom"
    )

    RegisterBoolean(
        dressingRoomCategory,
        "BETTERWARDROBE_DRESSING_ROOM_DIM_BACKGROUND",
        "dimBackground",
        addon.db.dressingRoom,
        "Dim Background Image",
        false,
        "Dim the native Dressing Room background while preserving Blizzard's frame and model scene.",
        "dressingRoom"
    )

    RegisterBoolean(
        dressingRoomCategory,
        "BETTERWARDROBE_DRESSING_ROOM_HIDE_BACKGROUND",
        "hideBackground",
        addon.db.dressingRoom,
        "Hide Background Image",
        false,
        "Hide the native Dressing Room background.",
        "dressingRoom"
    )

    RegisterBoolean(
        dressingRoomCategory,
        "BETTERWARDROBE_DRESSING_ROOM_START_UNDRESSED",
        "startUndressed",
        addon.db.dressingRoom,
        "Start Undressed",
        false,
        "Undress the model when the Dressing Room first opens before previewing selected appearances.",
        "dressingRoom"
    )

    RegisterBoolean(
        dressingRoomCategory,
        "BETTERWARDROBE_DRESSING_ROOM_HIDE_WEAPONS",
        "hideWeapons",
        addon.db.dressingRoom,
        "Hide Weapons",
        false,
        "Hide equipped weapons on the Dressing Room model.",
        "dressingRoom"
    )

    RegisterBoolean(
        dressingRoomCategory,
        "BETTERWARDROBE_DRESSING_ROOM_HIDE_SHIRT",
        "hideShirt",
        addon.db.dressingRoom,
        "Hide Shirt",
        false,
        "Hide the shirt slot on the Dressing Room model.",
        "dressingRoom"
    )

    RegisterBoolean(
        dressingRoomCategory,
        "BETTERWARDROBE_DRESSING_ROOM_HIDE_TABARD",
        "hideTabard",
        addon.db.dressingRoom,
        "Hide Tabard",
        false,
        "Hide the tabard slot on the Dressing Room model.",
        "dressingRoom"
    )

    RegisterBoolean(
        dressingRoomCategory,
        "BETTERWARDROBE_DRESSING_ROOM_CUSTOM_SIZE",
        "customSize",
        addon.db.dressingRoom,
        "Resize Window",
        true,
        "Apply a custom size to Blizzard's native Dressing Room.",
        "dressingRoom"
    )

    RegisterNumber(
        dressingRoomCategory,
        "BETTERWARDROBE_DRESSING_ROOM_WIDTH",
        "width",
        addon.db.dressingRoom,
        "Dressing Room width",
        600,
        400,
        1400,
        10,
        "Width applied to Blizzard's native DressUpFrame.",
        "dressingRoom",
        function(value)
            return format("%d px", value)
        end
    )

    RegisterNumber(
        dressingRoomCategory,
        "BETTERWARDROBE_DRESSING_ROOM_HEIGHT",
        "height",
        addon.db.dressingRoom,
        "Dressing Room height",
        800,
        450,
        1100,
        10,
        "Height applied to Blizzard's native DressUpFrame.",
        "dressingRoom",
        function(value)
            return format("%d px", value)
        end
    )

    Settings.RegisterAddOnCategory(rootCategory)
end

addon:RegisterCallback("DATABASE_READY", RegisterSettings)
