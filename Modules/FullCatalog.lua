local addonName, addon = ...

-- Restores BetterWardrobe's additive catalog layer without replacing Blizzard's
-- wardrobe frames or C_Transmog APIs. Blizzard remains authoritative for native
-- records; bundled Extra Sets, weapon sets, artifact appearances, alternate
-- sources, and hidden API set records are merged into the native data providers.

local Catalog = {
    sourceIDs = {},
    sourceRecords = {},
    sourcesByCategory = {},
    indexedCategories = {},
    categorySeen = {},
    resolutionAttempted = {},
    apiSetsByBaseID = {},
    apiSetByID = {},
    apiBaseRecords = {},
    artifactSourceIDs = {},
    artifactNames = {},
    built = false,
    apiBuilt = false,
    hooksInstalled = false,
    nativeSetsDataProvider = nil,
    rebuilding = false,
    stats = {},
}
addon.FullCatalog = Catalog

local ARMOR_TYPES = { "CLOTH", "LEATHER", "MAIL", "PLATE", "COSMETIC" }
local SLOT_TO_CATEGORY = {
    [1] = 1,   -- Head
    [3] = 3,   -- Shoulder
    [4] = 4,   -- Shirt
    [5] = 5,   -- Chest
    [6] = 7,   -- Waist
    [7] = 8,   -- Legs
    [8] = 9,   -- Feet
    [9] = 10,  -- Wrist
    [10] = 11, -- Hands
    [15] = 2,  -- Back
    [19] = 6,  -- Tabard
}

local ARMOR_INVENTORY_TYPES = {
    [1] = true,  -- Head
    [3] = true,  -- Shoulder
    [4] = true,  -- Shirt
    [5] = true,  -- Chest/Robe
    [6] = true,  -- Waist
    [7] = true,  -- Legs
    [8] = true,  -- Feet
    [9] = true,  -- Wrist
    [10] = true, -- Hands
    [15] = true, -- Back
    [19] = true, -- Tabard
}

-- ExtendedSets weaponType index -> Enum.TransmogCollectionType category ID.
local WEAPON_TYPE_TO_CATEGORY = {
    [1] = 13,  -- One-hand axe
    [2] = 20,  -- Two-hand axe
    [3] = 25,  -- Bow
    [4] = 27,  -- Crossbow
    [5] = 16,  -- Dagger
    [6] = 17,  -- Fist
    [7] = 26,  -- Gun
    [8] = 15,  -- One-hand mace
    [9] = 22,  -- Two-hand mace
    [10] = 19, -- Holdable
    [11] = 24, -- Polearm
    [12] = 18, -- Shield
    [13] = 23, -- Staff
    [14] = 14, -- One-hand sword
    [15] = 21, -- Two-hand sword
    [16] = 12, -- Wand
    [17] = 28, -- Warglaive
}

local CLASS_ARMOR_MASKS = {
    [1] = { [0] = true, [1] = true, [35] = true },
    [2] = { [0] = true, [2] = true, [35] = true },
    [3] = { [0] = true, [4] = true, [68] = true, [4164] = true },
    [4] = { [0] = true, [8] = true, [3592] = true },
    [5] = { [0] = true, [16] = true, [400] = true },
    [6] = { [0] = true, [32] = true, [35] = true },
    [7] = { [0] = true, [64] = true, [68] = true, [4164] = true },
    [8] = { [0] = true, [128] = true, [400] = true },
    [9] = { [0] = true, [256] = true, [400] = true },
    [10] = { [0] = true, [512] = true, [3592] = true },
    [11] = { [0] = true, [1024] = true, [3592] = true },
    [12] = { [0] = true, [2048] = true, [3592] = true },
    [13] = { [0] = true, [4096] = true, [68] = true, [4164] = true },
}

local function WipeTable(tbl)
    if wipe then
        wipe(tbl)
    else
        for key in pairs(tbl) do
            tbl[key] = nil
        end
    end
end

local function ShallowCopy(source)
    local copy = {}
    for key, value in pairs(source or {}) do
        copy[key] = value
    end
    return copy
end

local function ToBoolean(value, fallback)
    if value == nil then
        return fallback == true
    end
    return value == true
end

local function GetCurrentClassID()
    local selectedClassID = C_TransmogSets and C_TransmogSets.GetTransmogSetsClassFilter
        and C_TransmogSets.GetTransmogSetsClassFilter()
    if selectedClassID and selectedClassID > 0 then
        return selectedClassID
    end
    return select(3, UnitClass("player")) or 1
end

local function GetCurrentFactionID()
    local faction = UnitFactionGroup("player")
    if faction == "Alliance" then
        return 1
    elseif faction == "Horde" then
        return 2
    end
    return nil
end

local function GetCurrentRaceID()
    return select(3, UnitRace("player"))
end

local function GetSearchText()
    local wardrobe = _G.WardrobeCollectionFrame
    local searchBox = wardrobe and wardrobe.SearchBox
    local text = searchBox and searchBox.GetText and searchBox:GetText() or ""
    return strtrim(string.lower(text or ""))
end

local function TextMatchesSearch(searchText, ...)
    if searchText == "" then
        return true
    end
    for index = 1, select("#", ...) do
        local value = select(index, ...)
        if type(value) == "string" and string.find(string.lower(value), searchText, 1, true) then
            return true
        end
    end
    return false
end

local function GetAppearanceSourceInfoTable(sourceID)
    if not C_TransmogCollection or not C_TransmogCollection.GetAppearanceSourceInfo then
        return nil
    end

    local first, visualID, canEnchant, icon, isCollected, itemLink, transmogLink, sourceType, itemSubclass
        = C_TransmogCollection.GetAppearanceSourceInfo(sourceID)
    if type(first) == "table" then
        return first
    end
    if first == nil and visualID == nil then
        return nil
    end

    return {
        sourceID = sourceID,
        categoryID = tonumber(first),
        itemAppearanceID = visualID,
        visualID = visualID,
        canHaveIllusion = canEnchant,
        icon = icon,
        sourceIsCollected = isCollected,
        itemLink = itemLink,
        transmogLink = transmogLink,
        sourceType = sourceType,
        itemSubclass = itemSubclass,
    }
end

local function ResolveSourceRecord(sourceID, knownCategory)
    sourceID = tonumber(sourceID)
    if not sourceID then
        return nil
    end

    local cached = Catalog.sourceRecords[sourceID]
    if cached then
        if knownCategory and not cached.categoryID then
            cached.categoryID = knownCategory
        end
        return cached
    end

    local sourceInfo = C_TransmogCollection and C_TransmogCollection.GetSourceInfo
        and C_TransmogCollection.GetSourceInfo(sourceID) or nil
    local appearanceInfo = C_TransmogCollection and C_TransmogCollection.GetAppearanceInfoBySource
        and C_TransmogCollection.GetAppearanceInfoBySource(sourceID) or nil
    local fallbackInfo = GetAppearanceSourceInfoTable(sourceID)

    local visualID = sourceInfo and sourceInfo.visualID
        or appearanceInfo and (appearanceInfo.itemAppearanceID or appearanceInfo.visualID)
        or fallbackInfo and (fallbackInfo.itemAppearanceID or fallbackInfo.visualID)
    visualID = tonumber(visualID)
    if not visualID then
        return nil
    end

    local categoryID = knownCategory
        or sourceInfo and (sourceInfo.categoryID or sourceInfo.category)
        or appearanceInfo and (appearanceInfo.categoryID or appearanceInfo.category)
        or fallbackInfo and (fallbackInfo.categoryID or fallbackInfo.category)
    categoryID = tonumber(categoryID)
    if not categoryID and C_TransmogCollection and C_TransmogCollection.GetCategoryForItem then
        local ok, resolvedCategory = pcall(C_TransmogCollection.GetCategoryForItem, sourceID)
        if ok then
            categoryID = tonumber(resolvedCategory)
        end
    end

    local collected = sourceInfo and sourceInfo.isCollected
    if collected == nil and appearanceInfo then
        collected = appearanceInfo.sourceIsCollectedPermanent
            or appearanceInfo.sourceIsCollected
            or appearanceInfo.appearanceIsCollected
    end
    if collected == nil and fallbackInfo then
        collected = fallbackInfo.sourceIsCollectedPermanent
            or fallbackInfo.sourceIsCollected
            or fallbackInfo.appearanceIsCollected
    end

    local usable = sourceInfo and sourceInfo.isUsable
    local canDisplay = sourceInfo and sourceInfo.canDisplayOnPlayer
    if usable == nil and C_TransmogCollection and C_TransmogCollection.PlayerCanCollectSource then
        local hasData, canCollect = C_TransmogCollection.PlayerCanCollectSource(sourceID)
        if hasData ~= nil then
            usable = canCollect == true
            if canDisplay == nil then
                canDisplay = canCollect == true
            end
        end
    end

    local itemID = sourceInfo and sourceInfo.itemID
        or appearanceInfo and appearanceInfo.itemID
        or fallbackInfo and fallbackInfo.itemID
    local itemLink = sourceInfo and sourceInfo.itemLink
        or appearanceInfo and appearanceInfo.itemLink
        or fallbackInfo and fallbackInfo.itemLink
    local name = sourceInfo and sourceInfo.name
        or appearanceInfo and appearanceInfo.name
        or fallbackInfo and fallbackInfo.name
    if not name and itemID and C_Item and C_Item.GetItemNameByID then
        name = C_Item.GetItemNameByID(itemID)
    end
    if not name and itemLink and C_Item and C_Item.GetItemInfo then
        name = C_Item.GetItemInfo(itemLink)
    end

    local favorite = false
    if C_TransmogCollection and C_TransmogCollection.GetIsAppearanceFavorite then
        favorite = C_TransmogCollection.GetIsAppearanceFavorite(visualID) == true
    end

    local record = {
        sourceID = sourceID,
        visualID = visualID,
        categoryID = categoryID,
        itemID = itemID,
        itemLink = itemLink,
        name = name or "",
        sourceText = sourceInfo and sourceInfo.sourceText
            or appearanceInfo and appearanceInfo.sourceText
            or fallbackInfo and fallbackInfo.sourceText
            or "",
        isCollected = ToBoolean(collected, false),
        isUsable = ToBoolean(usable, false),
        canDisplayOnPlayer = ToBoolean(canDisplay, usable == true),
        isFavorite = favorite,
        isHideVisual = ToBoolean(sourceInfo and sourceInfo.isHideVisual, false),
        hasActiveRequiredHoliday = ToBoolean(sourceInfo and sourceInfo.hasActiveRequiredHoliday, true),
        uiOrder = tonumber(sourceInfo and sourceInfo.uiOrder) or sourceID,
        sourceType = tonumber(sourceInfo and sourceInfo.sourceType
            or appearanceInfo and appearanceInfo.sourceType
            or fallbackInfo and fallbackInfo.sourceType),
        invType = tonumber(sourceInfo and sourceInfo.invType
            or appearanceInfo and appearanceInfo.invType
            or fallbackInfo and fallbackInfo.invType),
    }
    Catalog.sourceRecords[sourceID] = record
    return record
end

function Catalog:AddSource(sourceID, origin, categoryID)
    sourceID = tonumber(sourceID)
    if not sourceID or sourceID <= 0 then
        return
    end

    local entry = self.sourceIDs[sourceID]
    if not entry then
        entry = { sourceID = sourceID, origins = {}, categoryID = tonumber(categoryID) }
        self.sourceIDs[sourceID] = entry
    elseif categoryID and not entry.categoryID then
        entry.categoryID = tonumber(categoryID)
    end
    if origin then
        entry.origins[origin] = true
    end
end

local function AddAlternateSources(sourceID, origin, categoryID)
    if not addon.CheckAltItem then
        return
    end
    local alternate = addon:CheckAltItem(sourceID)
    if type(alternate) == "table" then
        for _, alternateSourceID in pairs(alternate) do
            Catalog:AddSource(alternateSourceID, origin .. ":alternate", categoryID)
        end
    elseif alternate then
        Catalog:AddSource(alternate, origin .. ":alternate", categoryID)
    end
end

local function ScanExtraSet(setInfo, armorType)
    Catalog.stats.extraSetRecords = Catalog.stats.extraSetRecords + 1

    local function ScanItemData(slot, itemData, isAlternate)
        if type(itemData) ~= "table" then
            return
        end
        local sourceID = tonumber(itemData[2])
        if not sourceID then
            return
        end
        local categoryID = SLOT_TO_CATEGORY[tonumber(slot)]
        local origin = isAlternate and "extraSetExplicitAlternate" or "extraSet"
        Catalog:AddSource(sourceID, origin .. ":" .. tostring(armorType), categoryID)
        if not isAlternate then
            AddAlternateSources(sourceID, "setOverride", categoryID)
        end
    end

    for slot, itemData in pairs(setInfo.itemData or {}) do
        ScanItemData(slot, itemData, false)
    end
    for slot, alternatives in pairs(setInfo.alternateItemData or {}) do
        for _, itemData in ipairs(alternatives or {}) do
            ScanItemData(slot, itemData, true)
        end
    end
end

local function ScanStaticCatalog()
    WipeTable(Catalog.artifactSourceIDs)
    WipeTable(Catalog.artifactNames)
    Catalog.stats = {
        extraSetRecords = 0,
        weaponSetRecords = 0,
        artifactRecords = 0,
        overrideMappings = 0,
        apiSetRecords = 0,
        apiBaseGroups = 0,
        staticSources = 0,
        resolvedSources = 0,
        unresolvedSources = 0,
        supplementalVisualsAdded = 0,
        supplementalBaseSetsAdded = 0,
        supplementalVariantsAdded = 0,
    }

    for _, armorType in ipairs(ARMOR_TYPES) do
        for _, setInfo in pairs(addon.ArmorSets and addon.ArmorSets[armorType] or {}) do
            if type(setInfo) == "table" then
                ScanExtraSet(setInfo, armorType)
            end
        end
    end

    if addon.FinalizeWeaponSetData then
        addon:FinalizeWeaponSetData()
    end
    for _, setInfo in ipairs(addon.WeaponSets or {}) do
        Catalog.stats.weaponSetRecords = Catalog.stats.weaponSetRecords + 1
        for _, source in ipairs(setInfo.sources or {}) do
            local categoryID = WEAPON_TYPE_TO_CATEGORY[tonumber(source.weaponType)]
            Catalog:AddSource(source.sourceID, "weaponSet", categoryID)
        end
    end

    for sourceID, alternate in pairs(addon.AlternateSourceMap or {}) do
        Catalog.stats.overrideMappings = Catalog.stats.overrideMappings + 1
        Catalog:AddSource(sourceID, "setOverridePrimary", nil)
        if type(alternate) == "table" then
            for _, alternateSourceID in pairs(alternate) do
                Catalog:AddSource(alternateSourceID, "setOverrideAlternate", nil)
            end
        else
            Catalog:AddSource(alternate, "setOverrideAlternate", nil)
        end
    end

    local artifactData = addon.Globals and addon.Globals.ARTIFACT_DATA or {}
    for _, artifact in pairs(artifactData) do
        Catalog.stats.artifactRecords = Catalog.stats.artifactRecords + 1
        if type(artifact.name) == "string" then
            Catalog.artifactNames[string.lower(artifact.name)] = true
        end
        for _, appearance in pairs(artifact.sets or {}) do
            local sourceID = tonumber(appearance.source)
            if sourceID then
                Catalog.artifactSourceIDs[sourceID] = true
                Catalog:AddSource(sourceID, "artifact", nil)
            end
            if type(appearance.name) == "string" then
                Catalog.artifactNames[string.lower(appearance.name)] = true
            end
        end
    end

    for _ in pairs(Catalog.sourceIDs) do
        Catalog.stats.staticSources = Catalog.stats.staticSources + 1
    end
end

local function NormalizeAPISetRecord(record)
    local copy = ShallowCopy(record)
    copy.setID = tonumber(copy.setID) or 0
    copy.baseSetID = tonumber(copy.baseSetID) or copy.setID
    copy.expansionID = tonumber(copy.expansionID) or 0
    copy.patchID = tonumber(copy.patchID) or 0
    copy.uiOrder = tonumber(copy.uiOrder) or copy.setID
    copy.classMask = tonumber(copy.classMask) or 0
    copy.favorite = copy.favorite == true
    copy.collected = copy.collected == true
    copy.hiddenUntilCollected = false
    if addon.MiscSets and addon.MiscSets.CustomDesc and addon.MiscSets.CustomDesc[copy.setID] then
        copy.description = addon.MiscSets.CustomDesc[copy.setID]
    end
    if addon.MiscSets and addon.MiscSets.customGroups then
        copy.customGroups = addon.MiscSets.customGroups[copy.setID]
    end
    local restrictedSets = addon.MiscSets and addon.MiscSets.REGION_RESTRICTED_SETS or nil
    copy.requiredRegion = restrictedSets and tonumber(restrictedSets[copy.setID]) or nil
    if copy.requiredRegion and type(GetCurrentRegion) == "function" then
        copy.regionRestricted = GetCurrentRegion() ~= copy.requiredRegion
    end
    return copy
end

function Catalog:BuildAPISetCatalog()
    WipeTable(self.apiSetsByBaseID)
    WipeTable(self.apiSetByID)
    WipeTable(self.apiBaseRecords)
    self.stats.apiSetRecords = 0
    self.stats.apiBaseGroups = 0

    local allSets = C_TransmogSets and C_TransmogSets.GetAllSets and C_TransmogSets.GetAllSets() or {}
    for _, apiRecord in ipairs(allSets) do
        local record = NormalizeAPISetRecord(apiRecord)
        if record.setID > 0 then
            self.apiSetByID[record.setID] = record
            local baseSetID = record.baseSetID > 0 and record.baseSetID or record.setID
            local group = self.apiSetsByBaseID[baseSetID]
            if not group then
                group = {}
                self.apiSetsByBaseID[baseSetID] = group
            end
            group[#group + 1] = record
            if record.setID == baseSetID then
                self.apiBaseRecords[baseSetID] = record
            end
            self.stats.apiSetRecords = self.stats.apiSetRecords + 1
        end
    end

    for baseSetID, group in pairs(self.apiSetsByBaseID) do
        table.sort(group, function(left, right)
            if left.uiOrder == right.uiOrder then
                return left.setID < right.setID
            end
            return left.uiOrder < right.uiOrder
        end)
        if not self.apiBaseRecords[baseSetID] then
            self.apiBaseRecords[baseSetID] = group[1]
        end
        self.stats.apiBaseGroups = self.stats.apiBaseGroups + 1
    end
    self.apiBuilt = true
end

function Catalog:Rebuild()
    if self.rebuilding then
        return
    end
    self.rebuilding = true

    WipeTable(self.sourceIDs)
    WipeTable(self.sourceRecords)
    WipeTable(self.sourcesByCategory)
    WipeTable(self.indexedCategories)
    WipeTable(self.categorySeen)
    WipeTable(self.resolutionAttempted)
    self.apiBuilt = false

    ScanStaticCatalog()
    self:BuildAPISetCatalog()
    self.built = true
    self.rebuilding = false
    addon:FireCallback("FULL_CATALOG_REBUILT", self)
end

local function EnsureCatalog()
    if not Catalog.built then
        Catalog:Rebuild()
    elseif not Catalog.apiBuilt then
        Catalog:BuildAPISetCatalog()
    end
end

local function AddRecordToCategory(record)
    local categoryID = record and tonumber(record.categoryID)
    if not categoryID then
        return
    end

    local category = Catalog.sourcesByCategory[categoryID]
    if not category then
        category = {}
        Catalog.sourcesByCategory[categoryID] = category
    end
    local seen = Catalog.categorySeen[categoryID]
    if not seen then
        seen = {}
        Catalog.categorySeen[categoryID] = seen
    end
    if not seen[record.sourceID] then
        seen[record.sourceID] = true
        category[#category + 1] = record
    end
end

local function IndexCategory(categoryID)
    EnsureCatalog()
    categoryID = tonumber(categoryID)
    if not categoryID or Catalog.indexedCategories[categoryID] then
        return
    end

    for sourceID, entry in pairs(Catalog.sourceIDs) do
        if not entry.categoryID or tonumber(entry.categoryID) == categoryID then
            local firstAttempt = not Catalog.resolutionAttempted[sourceID]
            local record = ResolveSourceRecord(sourceID, entry.categoryID)
            Catalog.resolutionAttempted[sourceID] = true
            if record and record.categoryID then
                entry.categoryID = tonumber(record.categoryID)
                AddRecordToCategory(record)
                if firstAttempt then
                    Catalog.stats.resolvedSources = Catalog.stats.resolvedSources + 1
                end
            elseif firstAttempt then
                Catalog.stats.unresolvedSources = Catalog.stats.unresolvedSources + 1
            end
        end
    end

    local category = Catalog.sourcesByCategory[categoryID]
    if category then
        table.sort(category, function(left, right)
            if left.uiOrder == right.uiOrder then
                return left.sourceID < right.sourceID
            end
            return left.uiOrder > right.uiOrder
        end)
    end
    Catalog.indexedCategories[categoryID] = true
end

local function GetCategoryRecords(categoryID)
    categoryID = tonumber(categoryID)
    IndexCategory(categoryID)
    return Catalog.sourcesByCategory[categoryID] or {}
end

local function ItemPassesNativeVisibility(record)
    if record.isCollected then
        if C_TransmogCollection.GetCollectedShown and not C_TransmogCollection.GetCollectedShown() then
            return false
        end
    elseif C_TransmogCollection.GetUncollectedShown and not C_TransmogCollection.GetUncollectedShown() then
        return false
    end

    local searchText = GetSearchText()
    if not TextMatchesSearch(searchText, record.name, record.itemLink, record.sourceText, tostring(record.sourceID), tostring(record.visualID)) then
        return false
    end
    return true
end

function Catalog:GetSourceRecord(sourceID, knownCategory)
    EnsureCatalog()
    return ResolveSourceRecord(sourceID, knownCategory)
end

function Catalog:AugmentNativeItemVisuals(itemsFrame)
    if not itemsFrame or not itemsFrame.visualsList or not itemsFrame.GetActiveCategory then
        return 0
    end
    if itemsFrame.transmogLocation and itemsFrame.transmogLocation.IsIllusion and itemsFrame.transmogLocation:IsIllusion() then
        return 0
    end

    local activeCategory = tonumber(itemsFrame:GetActiveCategory())
    if not activeCategory then
        return 0
    end

    local seenVisuals = {}
    for _, visualInfo in ipairs(itemsFrame.visualsList) do
        local visualID = tonumber(visualInfo.visualID)
        if visualID then
            seenVisuals[visualID] = true
        end
    end

    local added = 0
    for _, record in ipairs(GetCategoryRecords(activeCategory)) do
        if not seenVisuals[record.visualID] then
            itemsFrame.visualsList[#itemsFrame.visualsList + 1] = {
                visualID = record.visualID,
                sourceID = record.sourceID,
                isCollected = record.isCollected,
                isUsable = record.isUsable,
                isFavorite = record.isFavorite,
                canDisplayOnPlayer = record.canDisplayOnPlayer,
                isHideVisual = record.isHideVisual,
                hasActiveRequiredHoliday = record.hasActiveRequiredHoliday,
                uiOrder = record.uiOrder,
                betterWardrobeSupplemental = true,
            }
            seenVisuals[record.visualID] = true
            added = added + 1
        end
    end

    self.stats.supplementalVisualsAdded = added
    return added
end

local function SetContainsArmorAppearance(setInfo)
    if not setInfo then
        return false
    end

    if type(setInfo.name) == "string" and Catalog.artifactNames[string.lower(setInfo.name)] then
        return false
    end

    local sourceIDs = C_TransmogSets and C_TransmogSets.GetAllSourceIDs
        and C_TransmogSets.GetAllSourceIDs(setInfo.setID) or {}
    local foundClassifiedSource = false
    local allSourcesAreArtifactWeapons = #sourceIDs > 0

    for _, sourceID in ipairs(sourceIDs) do
        sourceID = tonumber(sourceID)
        if not Catalog.artifactSourceIDs[sourceID] then
            allSourcesAreArtifactWeapons = false
        end

        local sourceInfo = C_TransmogCollection and C_TransmogCollection.GetSourceInfo
            and C_TransmogCollection.GetSourceInfo(sourceID) or nil
        local inventoryType = sourceInfo and tonumber(sourceInfo.invType)
        if inventoryType then
            foundClassifiedSource = true
            if ARMOR_INVENTORY_TYPES[inventoryType] then
                return true
            end
        end
    end

    if allSourcesAreArtifactWeapons then
        return false
    end

    -- Keep API sets whose item records are not cached yet. Known weapon-only
    -- artifact groups are rejected above without waiting for item data.
    return not foundClassifiedSource
end

local function IsSetCollected(setInfo)
    if setInfo.collected ~= nil then
        return setInfo.collected == true
    end
    local appearances = C_TransmogSets and C_TransmogSets.GetSetPrimaryAppearances
        and C_TransmogSets.GetSetPrimaryAppearances(setInfo.setID) or {}
    if #appearances == 0 then
        return false
    end
    for _, appearance in ipairs(appearances) do
        if not appearance.collected then
            return false
        end
    end
    return true
end

local function IsPvPSet(setInfo)
    if setInfo.PvP or setInfo.isPvPSource then
        return true
    end
    local text = string.lower(table.concat({
        tostring(setInfo.name or ""),
        tostring(setInfo.label or ""),
        tostring(setInfo.description or ""),
    }, " "))
    return text:find("gladiator", 1, true)
        or text:find("aspirant", 1, true)
        or text:find("combatant", 1, true)
        or text:find("pvp", 1, true)
        or text:find("elite", 1, true)
        or false
end

local function GetBaseSetFilter(filterID)
    if not filterID or not C_TransmogSets or not C_TransmogSets.GetBaseSetsFilter then
        return true
    end
    return C_TransmogSets.GetBaseSetsFilter(filterID) ~= false
end

local function SetPassesNativeFilters(setInfo)
    local classID = GetCurrentClassID()
    local classMask = tonumber(setInfo.classMask) or 0
    local allowedMasks = CLASS_ARMOR_MASKS[classID]
    if classMask ~= 0 and classMask ~= 16383 and allowedMasks and not allowedMasks[classMask] then
        if setInfo.validForCharacter ~= true then
            return false
        end
    end

    local requiredFaction = tonumber(setInfo.requiredFaction)
    local factionID = GetCurrentFactionID()
    if requiredFaction and factionID and requiredFaction ~= factionID then
        return false
    end

    local heritageSets = addon.MiscSets and addon.MiscSets.HeritageSets or nil
    local requiredRace = heritageSets and tonumber(heritageSets[setInfo.setID])
    if requiredRace and requiredRace ~= GetCurrentRaceID() then
        return false
    end

    local collected = IsSetCollected(setInfo)
    if collected then
        if not GetBaseSetFilter(_G.LE_TRANSMOG_SET_FILTER_COLLECTED) then
            return false
        end
    elseif not GetBaseSetFilter(_G.LE_TRANSMOG_SET_FILTER_UNCOLLECTED) then
        return false
    end

    local pvp = IsPvPSet(setInfo)
    if pvp then
        if not GetBaseSetFilter(_G.LE_TRANSMOG_SET_FILTER_PVP) then
            return false
        end
    elseif not GetBaseSetFilter(_G.LE_TRANSMOG_SET_FILTER_PVE) then
        return false
    end

    local searchText = GetSearchText()
    return TextMatchesSearch(searchText, setInfo.name, setInfo.label, setInfo.description, tostring(setInfo.setID))
end

function Catalog:ItemPassesDisplayFilters(record)
    return ItemPassesNativeVisibility(record)
end

function Catalog:SetPassesDisplayFilters(setInfo)
    return SetPassesNativeFilters(setInfo)
end

function Catalog:IsArmorSet(setInfo)
    return SetContainsArmorAppearance(setInfo)
end

function Catalog:GetNativeSetsDataProvider()
    return self.nativeSetsDataProvider
end

function Catalog:CreateAuditSetsDataProvider()
    EnsureCatalog()

    if type(CreateFromMixins) ~= "function" or type(WardrobeSetsDataProviderMixin) ~= "table" then
        return nil, "Blizzard's wardrobe set data provider is unavailable"
    end

    local provider = CreateFromMixins(WardrobeSetsDataProviderMixin)
    provider.betterWardrobeAuditProvider = true

    local ok, baseSets = pcall(provider.GetBaseSets, provider)
    if not ok then
        return nil, baseSets
    end
    if type(baseSets) ~= "table" then
        return nil, "Blizzard's wardrobe set provider returned no base-set table"
    end

    -- The secure hook normally performs this merge. Calling it directly keeps
    -- the audit deterministic if another addon delays or replaces a hook.
    self:AugmentNativeBaseSets(provider)
    return provider
end

function Catalog:GetStaticSourceCount()
    EnsureCatalog()
    return self.stats.staticSources or 0
end

function Catalog:AugmentNativeBaseSets(dataProvider)
    EnsureCatalog()
    local baseSets = dataProvider and dataProvider.baseSets
    if type(baseSets) ~= "table" then
        return 0
    end

    local seen = {}
    for _, setInfo in ipairs(baseSets) do
        seen[tonumber(setInfo.setID)] = true
    end

    local added = 0
    for _, setInfo in pairs(self.apiBaseRecords) do
        if setInfo and not seen[setInfo.setID]
            and SetContainsArmorAppearance(setInfo) then
            local supplemental = NormalizeAPISetRecord(setInfo)
            supplemental.betterWardrobeSupplemental = true
            baseSets[#baseSets + 1] = supplemental
            seen[setInfo.setID] = true
            added = added + 1
        end
    end

    if added > 0 and dataProvider.SortSets then
        dataProvider:SortSets(baseSets, false, false, true)
    end
    self.stats.supplementalBaseSetsAdded = added
    return added
end

function Catalog:AugmentNativeVariantSets(dataProvider, baseSetID)
    EnsureCatalog()
    baseSetID = tonumber(baseSetID)
    local variants = dataProvider and dataProvider.variantSets and dataProvider.variantSets[baseSetID]
    local catalogGroup = baseSetID and self.apiSetsByBaseID[baseSetID]
    if type(variants) ~= "table" or type(catalogGroup) ~= "table" then
        return 0
    end

    local seen = {}
    for _, setInfo in ipairs(variants) do
        seen[tonumber(setInfo.setID)] = true
    end

    local added = 0
    for _, setInfo in ipairs(catalogGroup) do
        if not seen[setInfo.setID] then
            local supplemental = NormalizeAPISetRecord(setInfo)
            supplemental.betterWardrobeSupplemental = true
            variants[#variants + 1] = supplemental
            seen[setInfo.setID] = true
            added = added + 1
        end
    end

    if added > 0 and dataProvider.SortSets then
        dataProvider:SortSets(variants, true, true, true)
    end
    self.stats.supplementalVariantsAdded = added
    return added
end

local itemRefreshGuard = false
local function InstallNativeHooks()
    if Catalog.hooksInstalled or not C_AddOns.IsAddOnLoaded("Blizzard_Collections") then
        return
    end
    if not WardrobeItemsCollectionMixin or not WardrobeSetsDataProviderMixin then
        return
    end

    Catalog.hooksInstalled = true

    hooksecurefunc(WardrobeItemsCollectionMixin, "RefreshVisualsList", function(itemsFrame)
        if itemRefreshGuard then
            return
        end
        local added = Catalog:AugmentNativeItemVisuals(itemsFrame)
        if added > 0 then
            itemRefreshGuard = true
            itemsFrame:FilterVisuals()
            itemsFrame:SortVisuals()
            if itemsFrame.PagingFrame and itemsFrame.PagingFrame.SetMaxPages then
                local pageSize = tonumber(itemsFrame.PAGE_SIZE) or 18
                itemsFrame.PagingFrame:SetMaxPages(math.max(1, math.ceil(#itemsFrame.filteredVisualsList / pageSize)))
            end
            itemRefreshGuard = false
        end
    end)

    if WardrobeItemsCollectionMixin.UpdateProgressBar then
        hooksecurefunc(WardrobeItemsCollectionMixin, "UpdateProgressBar", function(itemsFrame)
            if not itemsFrame.filteredVisualsList or not itemsFrame.GetParent then
                return
            end
            local total, collected = #itemsFrame.filteredVisualsList, 0
            for _, visualInfo in ipairs(itemsFrame.filteredVisualsList) do
                if visualInfo.isCollected then
                    collected = collected + 1
                end
            end
            local parent = itemsFrame:GetParent()
            if parent and parent.UpdateProgressBar then
                parent:UpdateProgressBar(collected, total)
            end
        end)
    end

    hooksecurefunc(WardrobeSetsDataProviderMixin, "GetBaseSets", function(dataProvider)
        if not dataProvider.betterWardrobeAuditProvider then
            Catalog.nativeSetsDataProvider = dataProvider
        end
        Catalog:AugmentNativeBaseSets(dataProvider)
    end)

    hooksecurefunc(WardrobeSetsDataProviderMixin, "GetVariantSets", function(dataProvider, baseSetID)
        if not dataProvider.betterWardrobeAuditProvider then
            Catalog.nativeSetsDataProvider = dataProvider
        end
        Catalog:AugmentNativeVariantSets(dataProvider, baseSetID)
    end)
end

function Catalog:GetSummary()
    EnsureCatalog()
    return {
        extraSetRecords = self.stats.extraSetRecords or 0,
        weaponSetRecords = self.stats.weaponSetRecords or 0,
        artifactRecords = self.stats.artifactRecords or 0,
        overrideMappings = self.stats.overrideMappings or 0,
        staticSources = self.stats.staticSources or 0,
        resolvedSources = self.stats.resolvedSources or 0,
        unresolvedSources = self.stats.unresolvedSources or 0,
        apiSetRecords = self.stats.apiSetRecords or 0,
        apiBaseGroups = self.stats.apiBaseGroups or 0,
    }
end

function addon:PrintCatalogSummary()
    local stats = Catalog:GetSummary()
    print(format(
        "|cff33ff99BetterWardrobe catalog:|r %d Extra Sets, %d weapon sets, %d artifact groups, %d override mappings, %d bundled sources; %d API sets in %d base groups.",
        stats.extraSetRecords,
        stats.weaponSetRecords,
        stats.artifactRecords,
        stats.overrideMappings,
        stats.staticSources,
        stats.apiSetRecords,
        stats.apiBaseGroups
    ))
    if stats.resolvedSources > 0 or stats.unresolvedSources > 0 then
        print(format(
            "|cff33ff99BetterWardrobe catalog index:|r %d resolved sources, %d pending or character-restricted sources.",
            stats.resolvedSources,
            stats.unresolvedSources
        ))
    end
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:RegisterEvent("PLAYER_LOGIN")
loader:RegisterEvent("TRANSMOG_COLLECTION_UPDATED")
loader:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "Blizzard_Collections" then
        InstallNativeHooks()
    elseif event == "PLAYER_LOGIN" then
        Catalog:Rebuild()
        InstallNativeHooks()
    elseif event == "TRANSMOG_COLLECTION_UPDATED" then
        WipeTable(Catalog.sourceRecords)
        WipeTable(Catalog.sourcesByCategory)
        WipeTable(Catalog.indexedCategories)
        WipeTable(Catalog.categorySeen)
        WipeTable(Catalog.resolutionAttempted)
        Catalog.stats.resolvedSources = 0
        Catalog.stats.unresolvedSources = 0
        Catalog.apiBuilt = false
    end
end)

addon:RegisterCallback("DATABASE_READY", function()
    Catalog:Rebuild()
    InstallNativeHooks()
end)

if addon.db then
    Catalog:Rebuild()
    InstallNativeHooks()
end
