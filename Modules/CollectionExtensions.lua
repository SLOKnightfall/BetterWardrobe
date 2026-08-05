local addonName, addon = ...

local TAB_ITEMS = 1
local TAB_SETS = 2
local TAB_EXTRA_SETS = 3
local TAB_WEAPON_SETS = 4
local TAB_START_X = 4
local TAB_START_Y = -28
local TAB_PADDING = 4
local TAB_GAP = 3
local PROGRESS_BAR_GAP = 8
local PROGRESS_BAR_RIGHT_GAP = 6
local LIST_WIDTH = 260
local LIST_ROW_HEIGHT = 46
local LIST_ROWS = 10
local MAX_DETAIL_ICONS = 18

local initialized = false
local transmogInitialized = false
local transmogFrameHooked = false
local itemNameCache = {}
local sourceInfoCache = {}
local itemExpansionCache = {}
local visualColorLABCache = {}
local pendingItemLoads = {}
local nativeItemsRefreshScheduled = false
local liveCollectionItemSortHooks = setmetatable({}, { __mode = "k" })
local liveTransmogItemSortHooks = setmetatable({}, { __mode = "k" })
local transmogItemSortGuards = setmetatable({}, { __mode = "k" })

local SORT_LABELS = {
    default = "Default",
    name = "Name",
    expansion = "Expansion",
    appearance = "Appearance ID",
    collected = "Collection status",
}

local NATIVE_ITEM_SORTS = { "default", "name", "expansion", "appearance", "collected" }
local NATIVE_SET_SORTS = { "default", "name", "expansion", "collected" }
local EXTRA_SET_SORTS = { "default", "name", "expansion", "collected" }
local WEAPON_SET_SORTS = { "default", "name", "expansion", "collected" }

local function GetSourceInfo(sourceID)
    sourceID = tonumber(sourceID)
    if not sourceID then
        return nil
    end

    local cached = sourceInfoCache[sourceID]
    if cached ~= nil then
        return cached or nil
    end

    local info = C_TransmogCollection.GetSourceInfo(sourceID)
    if not info and addon.FullCatalog and addon.FullCatalog.GetSourceRecord then
        info = addon.FullCatalog:GetSourceRecord(sourceID)
    end
    sourceInfoCache[sourceID] = info or false
    return info
end


local function IsTransmogVendorOpen()
    return _G.TransmogFrame
        and _G.TransmogFrame:IsShown()
        and C_TransmogOutfitInfo
        and C_TransmogOutfitInfo.SetPendingTransmog
end

local function GetTransmogOptions()
    return addon.db and addon.db.transmog or {}
end

local function IsApplyOnClickEnabled()
    return addon.IsApplyOnClickEnabled and addon:IsApplyOnClickEnabled() or false
end

local function GetWeaponOptionForCategory(categoryID)
    categoryID = tonumber(categoryID) or 0

    if (categoryID >= 12 and categoryID <= 17) or categoryID == 28 then
        return Enum.TransmogOutfitSlotOption.OneHandedWeapon
    elseif categoryID == 18 then
        return Enum.TransmogOutfitSlotOption.Shield
    elseif categoryID == 19 then
        return Enum.TransmogOutfitSlotOption.OffHand
    elseif categoryID >= 20 and categoryID <= 24 then
        local specializationIndex = GetSpecialization and GetSpecialization() or nil
        local specializationID = specializationIndex and GetSpecializationInfo(specializationIndex) or nil
        if specializationID == 72 then
            return Enum.TransmogOutfitSlotOption.FuryTwoHandedWeapon
        end
        return Enum.TransmogOutfitSlotOption.TwoHandedWeapon
    elseif categoryID >= 25 and categoryID <= 27 then
        return Enum.TransmogOutfitSlotOption.RangedWeapon
    end

    return 0
end

local function SetPendingOutfitSource(slot, transmogType, sourceID, weaponOption)
    sourceID = tonumber(sourceID)
    if not sourceID or not IsTransmogVendorOpen() then
        return false
    end

    local info = GetSourceInfo(sourceID)
    local categoryID = info and (info.categoryID or info.category) or 0
    local displayType = Enum.TransmogOutfitDisplayType.Assigned
    if C_TransmogCollection.IsAppearanceHiddenVisual
        and C_TransmogCollection.IsAppearanceHiddenVisual(sourceID) then
        displayType = Enum.TransmogOutfitDisplayType.Hidden
    end

    C_TransmogOutfitInfo.SetPendingTransmog(
        slot,
        transmogType or Enum.TransmogType.Appearance,
        weaponOption ~= nil and weaponOption or GetWeaponOptionForCategory(categoryID),
        sourceID,
        displayType
    )
    return true
end

local function SetPendingHiddenSlot(slot)
    if not IsTransmogVendorOpen() then
        return false
    end

    local noTransmogID = Constants and Constants.Transmog and Constants.Transmog.NoTransmogID or 0
    C_TransmogOutfitInfo.SetPendingTransmog(
        slot,
        Enum.TransmogType.Appearance,
        0,
        noTransmogID,
        Enum.TransmogOutfitDisplayType.Hidden
    )
    return true
end

-- Ported from the production BetterWardrobe click-to-apply path. Extra Sets
-- are converted from their primary source list into the outfit-slot table used
-- by the transmogrifier, then committed as pending changes in one click.
local function ApplyArmorSourcesToTransmog(sourceIDs)
    if not IsTransmogVendorOpen() or type(sourceIDs) ~= "table" then
        return false
    end

    local outfit = {}
    for _, sourceID in ipairs(sourceIDs) do
        local info = GetSourceInfo(sourceID)
        local invType = info and tonumber(info.invType) or nil
        if invType then
            outfit[invType - 1] = sourceID
        end
    end

    local options = GetTransmogOptions()
    local hideMissing = options.hideMissing == true
    local useHiddenForMissing = options.useHiddenForMissing == true

    local slots = {
        { Enum.TransmogOutfitSlot.Head, outfit[1] },
        { Enum.TransmogOutfitSlot.ShoulderRight, outfit[3] },
        { Enum.TransmogOutfitSlot.Body, outfit[4] },
        { Enum.TransmogOutfitSlot.Chest, outfit[5] or outfit[20] },
        { Enum.TransmogOutfitSlot.Waist, outfit[6] },
        { Enum.TransmogOutfitSlot.Legs, outfit[7] },
        { Enum.TransmogOutfitSlot.Feet, outfit[8] },
        { Enum.TransmogOutfitSlot.Wrist, outfit[9] },
        { Enum.TransmogOutfitSlot.Hand, outfit[10] },
        { Enum.TransmogOutfitSlot.Back, outfit[15] },
        { Enum.TransmogOutfitSlot.Tabard, outfit[19] },
    }

    C_TransmogOutfitInfo.ClearAllPendingTransmogs()
    for _, slotData in ipairs(slots) do
        local slot, sourceID = slotData[1], slotData[2]
        if sourceID then
            SetPendingOutfitSource(slot, Enum.TransmogType.Appearance, sourceID, 0)
        elseif hideMissing and useHiddenForMissing then
            SetPendingHiddenSlot(slot)
        end
    end

    PlaySound(SOUNDKIT.UI_TRANSMOG_ITEM_CLICK)
    return true
end

local function ApplyWeaponSourceToTransmog(sourceID)
    sourceID = tonumber(sourceID)
    if not sourceID or not IsTransmogVendorOpen() then
        return false
    end

    local info = GetSourceInfo(sourceID)
    local categoryID = info and (info.categoryID or info.category) or 0
    local slot = nil
    local weaponOption = nil
    local characterPreview = _G.TransmogFrame.CharacterPreview
    local selectedSlotData = characterPreview and characterPreview.GetSelectedSlotData and characterPreview:GetSelectedSlotData() or nil
    local transmogLocation = selectedSlotData and selectedSlotData.transmogLocation or nil

    if transmogLocation and transmogLocation:IsAppearance()
        and (transmogLocation:IsEitherHand() or transmogLocation:IsRangedSlot()) then
        slot = transmogLocation:GetSlot()
        weaponOption = selectedSlotData.currentWeaponOptionInfo
            and selectedSlotData.currentWeaponOptionInfo.weaponOption or nil
    end

    if not slot then
        if categoryID == 18 or categoryID == 19 then
            slot = Enum.TransmogOutfitSlot.WeaponOffHand
        else
            slot = Enum.TransmogOutfitSlot.WeaponMainHand
        end
    end

    local applied = SetPendingOutfitSource(
        slot,
        Enum.TransmogType.Appearance,
        sourceID,
        weaponOption ~= nil and weaponOption or GetWeaponOptionForCategory(categoryID)
    )
    if applied then
        PlaySound(SOUNDKIT.UI_TRANSMOG_ITEM_CLICK)
    end
    return applied
end

local function GetSourceName(sourceID)
    local info = GetSourceInfo(sourceID)
    if not info then
        return ""
    end

    local itemID = info.itemID
    if not itemID then
        return info.name or ""
    end

    local cached = itemNameCache[itemID]
    if cached then
        return cached
    end

    local name = C_Item.GetItemNameByID and C_Item.GetItemNameByID(itemID) or nil
    if not name and C_Item.GetItemInfo then
        name = C_Item.GetItemInfo(itemID)
    end

    if name then
        itemNameCache[itemID] = name
        pendingItemLoads[itemID] = nil
        return name
    end

    if not pendingItemLoads[itemID] and C_Item and C_Item.RequestLoadItemDataByID then
        pendingItemLoads[itemID] = true
        C_Item.RequestLoadItemDataByID(itemID)
    end

    return info.name or tostring(itemID)
end

local function IsSourceCollected(sourceID)
    local info = GetSourceInfo(sourceID)
    return info and info.isCollected == true or false
end

local function GetExpansionName(expansionID)
    expansionID = tonumber(expansionID) or 0
    local zeroBased = math.max(0, expansionID - 1)
    return _G["EXPANSION_NAME" .. zeroBased] or format("Expansion %d", expansionID)
end

local function CompareValues(left, right, reverse)
    if left == right then
        return nil
    end
    if reverse then
        return left > right
    end
    return left < right
end

local function StableCompare(primaryLeft, primaryRight, tieLeft, tieRight, reverse)
    local result = CompareValues(primaryLeft, primaryRight, reverse)
    if result ~= nil then
        return result
    end
    return CompareValues(tieLeft or 0, tieRight or 0, reverse) == true
end

local function ConvertRGBToLAB(r, g, b)
    local varR = r / 255
    local varG = g / 255
    local varB = b / 255

    varR = varR > 0.04045 and math.pow((varR + 0.055) / 1.055, 2.4) or varR / 12.92
    varG = varG > 0.04045 and math.pow((varG + 0.055) / 1.055, 2.4) or varG / 12.92
    varB = varB > 0.04045 and math.pow((varB + 0.055) / 1.055, 2.4) or varB / 12.92

    local x = (varR * 0.4124 + varG * 0.3576 + varB * 0.1805) * 100
    local y = (varR * 0.2126 + varG * 0.7152 + varB * 0.0722) * 100
    local z = (varR * 0.0193 + varG * 0.1192 + varB * 0.9505) * 100

    local varX = x / 95.044
    local varY = y / 100.000
    local varZ = z / 108.755

    varX = varX > 0.008856 and math.pow(varX, 1 / 3) or (7.787 * varX) + (16 / 116)
    varY = varY > 0.008856 and math.pow(varY, 1 / 3) or (7.787 * varY) + (16 / 116)
    varZ = varZ > 0.008856 and math.pow(varZ, 1 / 3) or (7.787 * varZ) + (16 / 116)

    return (116 * varY) - 16, 500 * (varX - varY), 200 * (varY - varZ)
end

local function CompareLAB(l1, a1, b1, l2, a2, b2)
    local deltaL = l1 - l2
    local deltaA = a1 - a2
    local deltaB = b1 - b2
    local chroma1 = math.sqrt((a1 * a1) + (b1 * b1))
    local chroma2 = math.sqrt((a2 * a2) + (b2 * b2))
    local deltaC = chroma1 - chroma2
    local deltaH = (deltaA * deltaA) + (deltaB * deltaB) - (deltaC * deltaC)
    deltaH = deltaH > 0 and math.sqrt(deltaH) or 0

    local scaleC = 1 + (0.045 * chroma1)
    local scaleH = 1 + (0.015 * chroma1)
    local value = (deltaL * deltaL) + ((deltaC / scaleC) * (deltaC / scaleC)) + ((deltaH / scaleH) * (deltaH / scaleH))
    return value > 0 and math.sqrt(value) or 0
end

local function GetVisualColorLABs(visualID)
    visualID = tonumber(visualID)
    if not visualID then
        return nil
    end

    local cached = visualColorLABCache[visualID]
    if cached ~= nil then
        return cached or nil
    end

    local serialized = addon.ColorTable and addon.ColorTable[visualID]
    if type(serialized) ~= "string" then
        visualColorLABCache[visualID] = false
        return nil
    end

    local values = {}
    for value in serialized:gmatch("%^N%d+%^N([%d%.%-]+)") do
        values[#values + 1] = tonumber(value)
    end

    local colors = {}
    for index = 1, #values - 2, 3 do
        local red, green, blue = values[index], values[index + 1], values[index + 2]
        if red and green and blue then
            local labL, labA, labB = ConvertRGBToLAB(red, green, blue)
            colors[#colors + 1] = { labL, labA, labB }
        end
    end

    visualColorLABCache[visualID] = #colors > 0 and colors or false
    return #colors > 0 and colors or nil
end

local function VisualMatchesColor(visualID, filterL, filterA, filterB, tolerance)
    local colors = GetVisualColorLABs(visualID)
    if not colors then
        return false
    end

    for _, color in ipairs(colors) do
        if CompareLAB(filterL, filterA, filterB, color[1], color[2], color[3]) <= tolerance then
            return true
        end
    end

    return false
end

local function GetItemExpansionName(expansionID)
    expansionID = tonumber(expansionID) or 0
    return _G["EXPANSION_NAME" .. expansionID] or format("Expansion %d", expansionID)
end

local function GetVisualSourceID(itemsFrame, visualInfo)
    if not itemsFrame or not visualInfo then
        return nil
    end

    if visualInfo.sourceID then
        return visualInfo.sourceID
    end

    local visualID = tonumber(visualInfo.visualID or visualInfo.itemAppearanceID)
    if not visualID then
        return nil
    end

    if itemsFrame.GetChosenVisualSource then
        local ok, chosenSourceID = pcall(itemsFrame.GetChosenVisualSource, itemsFrame, visualID)
        local noTransmogID = Constants and Constants.Transmog and Constants.Transmog.NoTransmogID or 0
        if ok and chosenSourceID and chosenSourceID ~= noTransmogID then
            return chosenSourceID
        end
    end

    -- Query the API directly instead of calling Blizzard's sorted-source helper.
    -- The helper emits an assert warning when a supplemental visual has no native
    -- source list, even when the call is protected with pcall.
    local categoryID = itemsFrame.GetActiveCategory and itemsFrame:GetActiveCategory()
        or itemsFrame.activeCategory
        or itemsFrame.activeCategoryID
    local sources = C_TransmogCollection.GetAppearanceSources
        and C_TransmogCollection.GetAppearanceSources(visualID, categoryID, itemsFrame.transmogLocation)
        or nil
    if type(sources) == "table" then
        local selectedSourceID
        for _, source in ipairs(sources) do
            local sourceID = tonumber(source and source.sourceID)
            if sourceID and (not selectedSourceID or sourceID < selectedSourceID) then
                selectedSourceID = sourceID
            end
        end
        return selectedSourceID
    end

    return nil
end


local function GetItemExpansionID(itemID)
    itemID = tonumber(itemID)
    if not itemID then
        return nil
    end

    local cached = itemExpansionCache[itemID]
    if cached ~= nil then
        return cached >= 0 and cached or nil
    end

    local getItemInfo = C_Item and C_Item.GetItemInfo or _G.GetItemInfo
    local expansionID = getItemInfo and select(15, getItemInfo(itemID)) or nil
    if expansionID ~= nil then
        itemExpansionCache[itemID] = expansionID
        pendingItemLoads[itemID] = nil
        return expansionID
    end

    itemExpansionCache[itemID] = -1
    if not pendingItemLoads[itemID] and C_Item and C_Item.RequestLoadItemDataByID then
        pendingItemLoads[itemID] = true
        C_Item.RequestLoadItemDataByID(itemID)
    end
    return nil
end

local function GetVisualExpansionID(itemsFrame, visualInfo)
    local sourceID = GetVisualSourceID(itemsFrame, visualInfo)
    local sourceInfo = GetSourceInfo(sourceID)
    return sourceInfo and GetItemExpansionID(sourceInfo.itemID) or nil
end

local FILTER_KEYS = {
    items = { expansion = "itemExpansion", color = "itemColor" },
    sets = { expansion = "setExpansion", color = "setColor" },
    extraSets = { expansion = "extraSetsExpansion", color = "extraSetsColor" },
    weaponSets = { expansion = "weaponSetsExpansion", color = "weaponSetsColor" },
}

local function GetFilterKeys(context)
    return FILTER_KEYS[context] or FILTER_KEYS.items
end

local function GetSelectedExpansion(context)
    local keys = GetFilterKeys(context)
    return tonumber(addon.db.filters[keys.expansion]) or -1
end

local function SetSelectedExpansion(context, value)
    local keys = GetFilterKeys(context)
    addon.db.filters[keys.expansion] = tonumber(value) or -1
end

local function GetSelectedColor(context)
    local keys = GetFilterKeys(context)
    return addon.db.filters[keys.color]
end

local function SetSelectedColor(context, value)
    local keys = GetFilterKeys(context)
    addon.db.filters[keys.color] = value
end

local function SourceListMatchesFilters(sourceIDs, context)
    local selectedExpansion = GetSelectedExpansion(context)
    local selectedColor = GetSelectedColor(context)
    if selectedExpansion < 0 and not selectedColor then
        return true
    end

    local tolerance = tonumber(addon.db.filters.colorTolerance) or 17
    local filterL, filterA, filterB
    if selectedColor then
        filterL, filterA, filterB = ConvertRGBToLAB(
            (selectedColor.r or 0) * 255,
            (selectedColor.g or 0) * 255,
            (selectedColor.b or 0) * 255
        )
    end

    local expansionMatched = selectedExpansion < 0
    local expansionKnown = selectedExpansion < 0
    local colorMatched = not selectedColor

    for _, sourceID in ipairs(sourceIDs or {}) do
        local sourceInfo = GetSourceInfo(sourceID)
        if sourceInfo then
            if selectedExpansion >= 0 then
                local expansionID = GetItemExpansionID(sourceInfo.itemID)
                if expansionID ~= nil then
                    expansionKnown = true
                    if expansionID == selectedExpansion then
                        expansionMatched = true
                    end
                end
            end

            if selectedColor and sourceInfo.visualID and VisualMatchesColor(sourceInfo.visualID, filterL, filterA, filterB, tolerance) then
                colorMatched = true
            end
        end

        if expansionMatched and colorMatched then
            return true
        end
    end

    -- Do not hide a set solely because item metadata is still loading. The
    -- GET_ITEM_INFO_RECEIVED refresh will re-evaluate it once the expansion is known.
    if selectedExpansion >= 0 and not expansionKnown then
        expansionMatched = true
    end

    return expansionMatched and colorMatched
end

local function ApplyNativeItemFilters(itemsFrame)
    if not addon.db or not itemsFrame.filteredVisualsList then
        return
    end

    -- Items/Appearances use Blizzard's native API filters. The separate
    -- production-style color swatch is applied later by ColorFilter.lua.
    local catalog = addon.FullCatalog
    for index = #itemsFrame.filteredVisualsList, 1, -1 do
        local visualInfo = itemsFrame.filteredVisualsList[index]
        local keep = true

        if visualInfo.betterWardrobeSupplemental and catalog and catalog.ItemPassesDisplayFilters then
            local record = catalog:GetSourceRecord(visualInfo.sourceID)
            keep = record and catalog:ItemPassesDisplayFilters(record) or false
        end

        if not keep then
            table.remove(itemsFrame.filteredVisualsList, index)
        end
    end
end

local function RefreshNativeItems()
    local wardrobe = _G.WardrobeCollectionFrame
    local itemsFrame = wardrobe and wardrobe.ItemsCollectionFrame
    if not itemsFrame then
        return
    end

    if itemsFrame.RefreshVisualsList then
        itemsFrame:RefreshVisualsList()
    else
        if itemsFrame.FilterVisuals then
            itemsFrame:FilterVisuals()
        end
        if itemsFrame.SortVisuals then
            itemsFrame:SortVisuals()
        end
    end

    if itemsFrame.ResetPage then
        itemsFrame:ResetPage()
    end
    if itemsFrame.UpdateItems then
        itemsFrame:UpdateItems()
    end
end

local function RefreshTransmogItems()
    local wardrobe = _G.TransmogFrame and _G.TransmogFrame.WardrobeCollection
    local itemsFrame = wardrobe and wardrobe.TabContent and wardrobe.TabContent.ItemsFrame
    if not itemsFrame then
        return
    end

    if itemsFrame.RefreshCollectionEntries then
        itemsFrame:RefreshCollectionEntries()
    end
    if itemsFrame.RefreshPagedEntry then
        itemsFrame:RefreshPagedEntry()
    end
end

local function RefreshAllNativeItems()
    RefreshNativeItems()
    RefreshTransmogItems()
end

local function ScheduleNativeItemsRefresh()
    if nativeItemsRefreshScheduled then
        return
    end

    nativeItemsRefreshScheduled = true
    C_Timer.After(0.1, function()
        nativeItemsRefreshScheduled = false
        RefreshAllNativeItems()
    end)
end

local function SortAppearanceEntries(itemsFrame, entries)
    local sorting = addon.db and addon.db.sorting
    local mode = sorting and sorting.items or "default"
    if mode == "default" or type(entries) ~= "table" then
        return
    end

    local reverse = sorting.reverse == true
    table.sort(entries, function(left, right)
        local leftID = tonumber(left and (left.visualID or left.itemAppearanceID)) or 0
        local rightID = tonumber(right and (right.visualID or right.itemAppearanceID)) or 0

        if mode == "appearance" then
            return StableCompare(leftID, rightID, leftID, rightID, reverse)
        elseif mode == "collected" then
            local leftCollected = left and left.isCollected and 1 or 0
            local rightCollected = right and right.isCollected and 1 or 0
            return StableCompare(leftCollected, rightCollected, leftID, rightID, not reverse)
        elseif mode == "name" then
            local leftSource = GetVisualSourceID(itemsFrame, left)
            local rightSource = GetVisualSourceID(itemsFrame, right)
            local leftName = string.lower(GetSourceName(leftSource) or "")
            local rightName = string.lower(GetSourceName(rightSource) or "")
            return StableCompare(leftName, rightName, leftID, rightID, reverse)
        elseif mode == "expansion" then
            local leftExpansion = GetVisualExpansionID(itemsFrame, left)
            local rightExpansion = GetVisualExpansionID(itemsFrame, right)
            return StableCompare(leftExpansion or -1, rightExpansion or -1, leftID, rightID, not reverse)
        end

        return StableCompare(leftID, rightID, leftID, rightID, reverse)
    end)
end

local function ApplyNativeItemSort(itemsFrame)
    if itemsFrame and itemsFrame.filteredVisualsList then
        SortAppearanceEntries(itemsFrame, itemsFrame.filteredVisualsList)
    end
end

local function ApplyTransmogItemSort(itemsFrame, entries, retainCurrentPage)
    if transmogItemSortGuards[itemsFrame] or type(entries) ~= "table" then
        return
    end

    local sorting = addon.db and addon.db.sorting
    if not sorting or (sorting.items or "default") == "default" then
        return
    end

    local sortedEntries = {}
    for _, itemEntry in ipairs(entries) do
        if (itemEntry.isUsable and itemEntry.isCollected) or itemEntry.alwaysShowItem then
            sortedEntries[#sortedEntries + 1] = itemEntry
        end
    end
    SortAppearanceEntries(itemsFrame, sortedEntries)

    local collectionElements = {}
    for _, itemEntry in ipairs(sortedEntries) do
        collectionElements[#collectionElements + 1] = {
            templateKey = "COLLECTION_ITEM",
            appearanceInfo = itemEntry,
            collectionFrame = itemsFrame,
        }
    end

    transmogItemSortGuards[itemsFrame] = true
    local dataProvider = CreateDataProvider({ { elements = collectionElements } })
    itemsFrame.PagedContent:SetDataProvider(dataProvider, retainCurrentPage)
    transmogItemSortGuards[itemsFrame] = nil
end

local function HookLiveCollectionItemSort(itemsFrame)
    if not itemsFrame or not itemsFrame.SortVisuals or liveCollectionItemSortHooks[itemsFrame] then
        return
    end

    liveCollectionItemSortHooks[itemsFrame] = true
    hooksecurefunc(itemsFrame, "SortVisuals", ApplyNativeItemSort)
end

local function HookLiveTransmogItemSort(itemsFrame)
    if not itemsFrame or not itemsFrame.SetCollectionEntries or liveTransmogItemSortHooks[itemsFrame] then
        return
    end

    liveTransmogItemSortHooks[itemsFrame] = true
    hooksecurefunc(itemsFrame, "SetCollectionEntries", ApplyTransmogItemSort)
end

local function GetSetCompletion(setInfo)
    if not setInfo then
        return 0
    end

    if setInfo.collected then
        return 1
    end

    local setID = setInfo.setID
    if setID and C_TransmogSets.GetSetPrimaryAppearances then
        local sources = C_TransmogSets.GetSetPrimaryAppearances(setID)
        if sources and #sources > 0 then
            local collected = 0
            for _, source in ipairs(sources) do
                if source.collected then
                    collected = collected + 1
                end
            end
            return collected / #sources
        end
    end

    return 0
end

local function GetNativeSetSourceIDs(setID)
    local sourceIDs = {}
    if not setID or not C_TransmogSets.GetSetPrimaryAppearances then
        return sourceIDs
    end

    for _, appearance in ipairs(C_TransmogSets.GetSetPrimaryAppearances(setID) or {}) do
        local sourceID = tonumber(appearance.appearanceID)
        if sourceID then
            sourceIDs[#sourceIDs + 1] = sourceID
        end
    end
    return sourceIDs
end

local function GetNativeSetFilterSourceIDs(setInfo)
    local sourceIDs = {}
    local setID = setInfo and tonumber(setInfo.setID)
    if not setID then
        return sourceIDs
    end

    local function AppendSetSources(candidateSetID)
        for _, sourceID in ipairs(GetNativeSetSourceIDs(candidateSetID)) do
            sourceIDs[#sourceIDs + 1] = sourceID
        end
    end

    AppendSetSources(setID)

    local baseSetID = C_TransmogSets.GetBaseSetID and C_TransmogSets.GetBaseSetID(setID) or setID
    if not baseSetID or baseSetID == setID then
        for _, variant in ipairs(C_TransmogSets.GetVariantSets and C_TransmogSets.GetVariantSets(setID) or {}) do
            if variant.setID and variant.setID ~= setID then
                AppendSetSources(variant.setID)
            end
        end
    end

    return sourceIDs
end

local function ApplyNativeSetFilters(sets)
    if type(sets) ~= "table" then
        return
    end

    if GetSelectedExpansion("sets") < 0 and not GetSelectedColor("sets") then
        return
    end

    for index = #sets, 1, -1 do
        if not SourceListMatchesFilters(GetNativeSetFilterSourceIDs(sets[index]), "sets") then
            table.remove(sets, index)
        end
    end
end

local function ApplyNativeSetSort(sets)
    local sorting = addon.db and addon.db.sorting
    local mode = sorting and sorting.sets or "default"
    if mode == "default" or type(sets) ~= "table" then
        return
    end

    local reverse = sorting.reverse == true
    table.sort(sets, function(left, right)
        local leftID = tonumber(left.setID) or 0
        local rightID = tonumber(right.setID) or 0

        if mode == "name" then
            return StableCompare(string.lower(left.name or ""), string.lower(right.name or ""), leftID, rightID, reverse)
        elseif mode == "expansion" then
            return StableCompare(tonumber(left.expansionID) or 0, tonumber(right.expansionID) or 0, leftID, rightID, not reverse)
        elseif mode == "collected" then
            return StableCompare(GetSetCompletion(left), GetSetCompletion(right), leftID, rightID, not reverse)
        end

        return false
    end)
end

local nativeSetDisplayGuard = false

local function BuildNativeSetDisplayList()
    local catalog = addon.FullCatalog
    local dataProvider = catalog and catalog.GetNativeSetsDataProvider and catalog:GetNativeSetsDataProvider()
    local sourceSets = dataProvider and dataProvider.baseSets
    if type(sourceSets) ~= "table" then
        return nil
    end

    local displaySets = {}
    for _, setInfo in ipairs(sourceSets) do
        if not catalog.SetPassesDisplayFilters or catalog:SetPassesDisplayFilters(setInfo) then
            displaySets[#displaySets + 1] = setInfo
        end
    end

    ApplyNativeSetFilters(displaySets)
    ApplyNativeSetSort(displaySets)
    return displaySets
end

local function ApplyNativeSetDisplayProvider(container)
    if nativeSetDisplayGuard or not container or not container.ScrollBox or not CreateDataProvider then
        return
    end

    local displaySets = BuildNativeSetDisplayList()
    if not displaySets then
        return
    end

    nativeSetDisplayGuard = true
    container.ScrollBox:SetDataProvider(CreateDataProvider(displaySets), ScrollBoxConstants.RetainScrollPosition)
    container.betterWardrobeDisplayCount = #displaySets
    if container.UpdateListSelection then
        container:UpdateListSelection()
    end
    nativeSetDisplayGuard = false
end

local function RefreshNativeSort(context)
    local wardrobe = _G.WardrobeCollectionFrame
    if not wardrobe then
        return
    end

    if context == "items" then
        local itemsFrame = wardrobe.ItemsCollectionFrame
        if itemsFrame and itemsFrame.filteredVisualsList then
            itemsFrame:SortVisuals()
            itemsFrame:UpdateItems()
        end
    elseif context == "sets" then
        local setsFrame = wardrobe.SetsCollectionFrame
        if setsFrame then
            if setsFrame.OnSearchUpdate then
                setsFrame:OnSearchUpdate()
            elseif setsFrame.Refresh then
                setsFrame:Refresh()
            end
        end
    end
end

local function AddSortMenu(rootDescription, context, modes, refreshCallback)
    local submenu = rootDescription:CreateButton("Sort")

    local function GetMode()
        return addon.db.sorting[context] or "default"
    end

    for _, mode in ipairs(modes) do
        submenu:CreateRadio(
            SORT_LABELS[mode],
            function(value)
                return GetMode() == value
            end,
            function(value)
                addon.db.sorting[context] = value
                refreshCallback()
                return MenuResponse.Refresh
            end,
            mode
        )
    end

    submenu:CreateDivider()
    submenu:CreateCheckbox(
        "Reverse order",
        function()
            return addon.db.sorting.reverse == true
        end,
        function()
            addon.db.sorting.reverse = not addon.db.sorting.reverse
            refreshCallback()
            return MenuResponse.Refresh
        end
    )
end

local function AddExpansionFilterMenu(rootDescription, context, refreshCallback)
    local submenu = rootDescription:CreateButton("Expansion")

    submenu:CreateRadio(
        "All expansions",
        function(value)
            return GetSelectedExpansion(context) == value
        end,
        function(value)
            SetSelectedExpansion(context, value)
            refreshCallback()
            return MenuResponse.Refresh
        end,
        -1
    )

    local currentExpansion = (GetExpansionLevel and GetExpansionLevel()) or _G.LE_EXPANSION_LEVEL_CURRENT or 11
    for expansionID = currentExpansion, 0, -1 do
        local name = _G["EXPANSION_NAME" .. expansionID]
        if name then
            submenu:CreateRadio(
                name,
                function(value)
                    return GetSelectedExpansion(context) == value
                end,
                function(value)
                    SetSelectedExpansion(context, value)
                    refreshCallback()
                    return MenuResponse.Refresh
                end,
                expansionID
            )
        end
    end
end

local function ResetColorFilter(context, refreshCallback)
    SetSelectedColor(context, nil)
    refreshCallback()
end

local function ShowColorPicker(context, refreshCallback)
    if not ColorPickerFrame then
        return
    end

    local activeColor = GetSelectedColor(context)
    local previous = activeColor and {
        r = activeColor.r,
        g = activeColor.g,
        b = activeColor.b,
    } or nil
    local current = previous or { r = 1, g = 1, b = 1 }

    local function ApplyColor()
        local red, green, blue = ColorPickerFrame:GetColorRGB()
        SetSelectedColor(context, { r = red, g = green, b = blue })
        refreshCallback()
    end

    local function CancelColor()
        SetSelectedColor(context, previous)
        refreshCallback()
    end

    if ColorPickerFrame.SetupColorPickerAndShow then
        ColorPickerFrame:SetupColorPickerAndShow({
            r = current.r,
            g = current.g,
            b = current.b,
            hasOpacity = false,
            swatchFunc = ApplyColor,
            cancelFunc = CancelColor,
        })
    else
        ColorPickerFrame.hasOpacity = false
        ColorPickerFrame.previousValues = previous and { previous.r, previous.g, previous.b } or nil
        ColorPickerFrame.swatchFunc = ApplyColor
        ColorPickerFrame.cancelFunc = CancelColor
        ColorPickerFrame:SetColorRGB(current.r, current.g, current.b)
        ColorPickerFrame:Show()
    end
end

local function GetColorMenuLabel(context)
    local color = GetSelectedColor(context)
    if not color then
        return "Color"
    end

    local red = math.floor(Clamp(color.r or 1, 0, 1) * 255 + 0.5)
    local green = math.floor(Clamp(color.g or 1, 0, 1) * 255 + 0.5)
    local blue = math.floor(Clamp(color.b or 1, 0, 1) * 255 + 0.5)
    return format("Color  |cff%02x%02x%02x■|r", red, green, blue)
end

local function AddColorFilterMenu(rootDescription, context, refreshCallback)
    local submenu = rootDescription:CreateButton(GetColorMenuLabel(context))
    submenu:CreateButton("Choose color…", function()
        ShowColorPicker(context, refreshCallback)
    end)

    local clearButton = submenu:CreateButton("Clear color filter", function()
        ResetColorFilter(context, refreshCallback)
        return MenuResponse.Refresh
    end)
    clearButton:SetEnabled(GetSelectedColor(context) ~= nil)
end

local menuModifiersRegistered = false
local function RegisterWardrobeMenuModifiers()
    if menuModifiersRegistered or not Menu or not Menu.ModifyMenu then
        return
    end

    menuModifiersRegistered = true

    Menu.ModifyMenu("MENU_WARDROBE_FILTER", function(_, rootDescription)
        -- Production kept color selection outside the Filter menu. Retain the
        -- native Blizzard API filters and expose only BetterWardrobe sorting.
        rootDescription:CreateDivider()
        rootDescription:CreateTitle("BetterWardrobe")
        AddSortMenu(rootDescription, "items", NATIVE_ITEM_SORTS, RefreshAllNativeItems)
    end)

    Menu.ModifyMenu("MENU_TRANSMOG_ITEMS_FILTER", function(_, rootDescription)
        rootDescription:CreateDivider()
        rootDescription:CreateTitle("BetterWardrobe")
        AddSortMenu(rootDescription, "items", NATIVE_ITEM_SORTS, RefreshAllNativeItems)
    end)

    Menu.ModifyMenu("MENU_WARDROBE_BASE_SETS_FILTER", function(_, rootDescription)
        rootDescription:CreateDivider()
        rootDescription:CreateTitle("BetterWardrobe")
        local refreshSets = function()
            RefreshNativeSort("sets")
        end
        AddExpansionFilterMenu(rootDescription, "sets", refreshSets)
        AddColorFilterMenu(rootDescription, "sets", refreshSets)
        AddSortMenu(rootDescription, "sets", NATIVE_SET_SORTS, refreshSets)
    end)
end

local function IsItemExtensionStateDefault()
    return (addon.db.sorting.items or "default") == "default"
end

local function IsSetExtensionStateDefault()
    return GetSelectedExpansion("sets") < 0
        and GetSelectedColor("sets") == nil
        and (addon.db.sorting.sets or "default") == "default"
end

local function ConfigureNativeFilterDefaults(wardrobe, context)
    local filterButton = wardrobe.FilterButton
    if not filterButton then
        return
    end

    if context == "items" then
        filterButton:SetIsDefaultCallback(function()
            return C_TransmogCollection.IsUsingDefaultFilters() and IsItemExtensionStateDefault()
        end)
        filterButton:SetDefaultCallback(function()
            C_TransmogCollection.SetDefaultFilters()
            addon.db.sorting.items = "default"
            RefreshAllNativeItems()
        end)
    else
        filterButton:SetIsDefaultCallback(function()
            return C_TransmogSets.IsUsingDefaultBaseSetsFilters() and IsSetExtensionStateDefault()
        end)
        filterButton:SetDefaultCallback(function()
            C_TransmogSets.SetDefaultBaseSetsFilters()
            SetSelectedExpansion("sets", -1)
            SetSelectedColor("sets", nil)
            addon.db.sorting.sets = "default"
            RefreshNativeSort("sets")
        end)
    end
end

local function ConfigureTransmogItemFilterDefaults(itemsFrame)
    local filterButton = itemsFrame and itemsFrame.FilterButton
    if not filterButton then
        return
    end

    filterButton:SetIsDefaultCallback(function()
        return C_TransmogCollection.IsUsingDefaultFilters() and IsItemExtensionStateDefault()
    end)
    filterButton:SetDefaultCallback(function()
        C_TransmogCollection.SetDefaultFilters()
        addon.db.sorting.items = "default"
        RefreshAllNativeItems()
    end)
end

local function ConfigureCustomFilterButton(wardrobe, panel, context, modes)
    local filterButton = wardrobe.FilterButton
    if not filterButton then
        return
    end

    local collectedKey = context .. "Collected"
    local uncollectedKey = context .. "Uncollected"
    local function RefreshPanel()
        panel:RefreshList()
    end

    filterButton:SetIsDefaultCallback(function()
        return addon.db.filters[collectedKey] ~= false
            and addon.db.filters[uncollectedKey] ~= false
            and GetSelectedExpansion(context) < 0
            and GetSelectedColor(context) == nil
            and (addon.db.sorting[context] or "default") == "default"
    end)
    filterButton:SetDefaultCallback(function()
        addon.db.filters[collectedKey] = true
        addon.db.filters[uncollectedKey] = true
        SetSelectedExpansion(context, -1)
        SetSelectedColor(context, nil)
        addon.db.sorting[context] = "default"
        RefreshPanel()
    end)
    filterButton:SetupMenu(function(_, rootDescription)
        rootDescription:SetTag("MENU_BETTERWARDROBE_" .. string.upper(context) .. "_FILTER")
        rootDescription:CreateCheckbox(COLLECTED, function()
            return addon.db.filters[collectedKey] ~= false
        end, function()
            addon.db.filters[collectedKey] = addon.db.filters[collectedKey] == false
            RefreshPanel()
        end)
        rootDescription:CreateCheckbox(NOT_COLLECTED, function()
            return addon.db.filters[uncollectedKey] ~= false
        end, function()
            addon.db.filters[uncollectedKey] = addon.db.filters[uncollectedKey] == false
            RefreshPanel()
        end)
        rootDescription:CreateDivider()
        rootDescription:CreateTitle("BetterWardrobe")
        AddExpansionFilterMenu(rootDescription, context, RefreshPanel)
        AddColorFilterMenu(rootDescription, context, RefreshPanel)
        AddSortMenu(rootDescription, context, modes, RefreshPanel)
    end)
end

local function CreateNativeModel(parent)
    local model = CreateFrame("DressUpModel", nil, parent)
    Mixin(model, WardrobeSetsDetailsModelMixin)
    model:EnableMouse(true)
    model:EnableMouseWheel(true)
    model:OnLoad()
    model:SetScript("OnShow", function(self)
        WardrobeSetsDetailsModelMixin.OnShow(self)
    end)
    model:SetScript("OnUpdate", WardrobeSetsDetailsModelMixin.OnUpdate)
    model:SetScript("OnMouseDown", WardrobeSetsDetailsModelMixin.OnMouseDown)
    model:SetScript("OnMouseUp", WardrobeSetsDetailsModelMixin.OnMouseUp)
    model:SetScript("OnMouseWheel", WardrobeSetsDetailsModelMixin.OnMouseWheel)
    model:SetScript("OnModelLoaded", WardrobeSetsDetailsModelMixin.OnModelLoaded)
    return model
end

local function RefreshPanelCamera(panel)
    if not panel:IsShown() or not panel.Model then
        return
    end

    local detailsCameraID = C_TransmogSets.GetCameraIDs()
    if not detailsCameraID then
        return
    end

    panel.Model:RefreshCamera()
    Model_ApplyUICamera(panel.Model, detailsCameraID)
    panel.Model.cameraID = detailsCameraID
    panel.Model.defaultPosX, panel.Model.defaultPosY, panel.Model.defaultPosZ, panel.Model.yaw = GetUICameraInfo(detailsCameraID)
end

local COLOR_SUFFIXES = {
    black = true,
    blue = true,
    bronze = true,
    brown = true,
    crimson = true,
    dark = true,
    gold = true,
    golden = true,
    gray = true,
    green = true,
    grey = true,
    light = true,
    orange = true,
    pink = true,
    purple = true,
    red = true,
    silver = true,
    teal = true,
    violet = true,
    white = true,
    yellow = true,
}

local function CleanGroupText(value)
    if type(value) ~= "string" then
        return ""
    end
    return strtrim(value:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""))
end

local function NormalizeVariantName(name)
    name = CleanGroupText(name)
    local suffix = name:match("%s*%((.-)%)%s*$")
    if suffix then
        local normalizedSuffix = string.lower(strtrim(suffix))
        if normalizedSuffix == "recolor" or COLOR_SUFFIXES[normalizedSuffix] then
            name = strtrim(name:gsub("%s*%([^%)]+%)%s*$", ""))
        end
    end
    return name ~= "" and name or "Set", suffix
end

local function GetWeaponTypeSignature(setInfo)
    local types = {}
    for _, source in ipairs(setInfo.sources or {}) do
        types[#types + 1] = tonumber(source.weaponType) or 0
    end
    table.sort(types)
    return table.concat(types, ",")
end

local function GetVariantGroupKey(setInfo, panelType)
    local expansionID = tonumber(setInfo.expansionID) or 0
    if panelType == "extraSets" then
        local customGroup = CleanGroupText(setInfo.customGroups or setInfo.custom)
        if customGroup ~= "" then
            return format("extra:%d:custom:%s", expansionID, string.lower(customGroup))
        end

        local baseName = NormalizeVariantName(setInfo.name)
        return format(
            "extra:%d:%s:%s",
            expansionID,
            string.lower(tostring(setInfo.armorType or "")),
            string.lower(baseName)
        )
    end

    local label = CleanGroupText(setInfo.label)
    local description = CleanGroupText(setInfo.description)
    if label ~= "" then
        if description ~= "" then
            local baseName = NormalizeVariantName(setInfo.name)
            return format(
                "weapon:%d:%s:name:%s",
                expansionID,
                string.lower(label),
                string.lower(baseName)
            )
        end
        return format("weapon:%d:%s", expansionID, string.lower(label))
    end

    local baseName = NormalizeVariantName(setInfo.name)
    return format("weapon:%d:name:%s", expansionID, string.lower(baseName))
end

local function ChooseGroupName(variants, panelType)
    if panelType == "weaponSets" then
        local label = CleanGroupText(variants[1] and variants[1].label)
        if label ~= "" then
            return label
        end
    end

    local counts = {}
    local displayNames = {}
    local bestKey, bestCount
    for _, variant in ipairs(variants) do
        local baseName = NormalizeVariantName(variant.name)
        local key = string.lower(baseName)
        counts[key] = (counts[key] or 0) + 1
        displayNames[key] = displayNames[key] or baseName
        if not bestCount or counts[key] > bestCount then
            bestKey, bestCount = key, counts[key]
        end
    end

    if bestKey and (bestCount or 0) > 1 then
        return displayNames[bestKey]
    end

    local customGroup = CleanGroupText(variants[1] and (variants[1].customGroups or variants[1].custom))
    if customGroup ~= "" then
        return customGroup
    end

    return displayNames[bestKey] or CleanGroupText(variants[1] and variants[1].name) or "Set"
end

local function BuildVariantGroups(rawData, panelType)
    local sortedData = {}
    for _, setInfo in pairs(rawData or {}) do
        if type(setInfo) == "table" then
            sortedData[#sortedData + 1] = setInfo
        end
    end
    table.sort(sortedData, function(left, right)
        return (tonumber(left.uiOrder) or tonumber(left.setID) or 0) < (tonumber(right.uiOrder) or tonumber(right.setID) or 0)
    end)

    local groupsByKey = {}
    local groups = {}
    for _, setInfo in ipairs(sortedData) do
        local groupKey = GetVariantGroupKey(setInfo, panelType)
        local group = groupsByKey[groupKey]
        if not group then
            group = {
                groupKey = groupKey,
                variants = {},
            }
            groupsByKey[groupKey] = group
            groups[#groups + 1] = group
        end
        group.variants[#group.variants + 1] = setInfo
    end

    for _, group in ipairs(groups) do
        table.sort(group.variants, function(left, right)
            return (tonumber(left.uiOrder) or tonumber(left.setID) or 0) < (tonumber(right.uiOrder) or tonumber(right.setID) or 0)
        end)

        local base = group.variants[1]
        group.setID = tonumber(base.setID) or 0
        group.baseSetID = group.setID
        group.expansionID = tonumber(base.expansionID) or 0
        group.uiOrder = tonumber(base.uiOrder) or group.setID
        group.name = ChooseGroupName(group.variants, panelType)
        group.label = base.label
        group.description = base.description
        group.filter = base.filter
        group.armorType = base.armorType

        local searchParts = { group.name or "", CleanGroupText(group.label), CleanGroupText(group.description) }
        for _, variant in ipairs(group.variants) do
            searchParts[#searchParts + 1] = CleanGroupText(variant.name)
            searchParts[#searchParts + 1] = CleanGroupText(variant.description)
            searchParts[#searchParts + 1] = CleanGroupText(variant.label)
        end
        group.searchText = table.concat(searchParts, " ")
    end

    return groups
end

local function GetSetSources(setInfo, panelType, includeAlternates)
    if setInfo and setInfo.variants then
        setInfo = setInfo.variants[1]
    end

    local sources = {}
    local seen = {}
    local primarySources = {}

    local function AppendSource(sourceID, isPrimary)
        sourceID = tonumber(sourceID)
        if not sourceID or seen[sourceID] or not GetSourceInfo(sourceID) then
            return
        end
        seen[sourceID] = true
        sources[#sources + 1] = sourceID
        if isPrimary then
            primarySources[#primarySources + 1] = sourceID
        end
    end

    if panelType == "extraSets" then
        for _, itemData in pairs(setInfo.itemData or {}) do
            AppendSource(type(itemData) == "table" and itemData[2], true)
        end

        if includeAlternates then
            for _, alternatives in pairs(setInfo.alternateItemData or {}) do
                for _, itemData in ipairs(alternatives or {}) do
                    AppendSource(type(itemData) == "table" and itemData[2], false)
                end
            end

            if addon.CheckAltItem then
                for _, sourceID in ipairs(primarySources) do
                    local alternate = addon:CheckAltItem(sourceID)
                    if type(alternate) == "table" then
                        for _, alternateSourceID in pairs(alternate) do
                            AppendSource(alternateSourceID, false)
                        end
                    else
                        AppendSource(alternate, false)
                    end
                end
            end
        end
    else
        for _, source in ipairs(setInfo.sources or {}) do
            AppendSource(source.sourceID, true)
        end
    end
    table.sort(sources)
    return sources
end

local function GetCustomSetCompletion(setInfo, panelType)
    if setInfo._completion ~= nil then
        return setInfo._completion
    end

    if setInfo.variants then
        local bestCompletion = 0
        for _, variant in ipairs(setInfo.variants) do
            bestCompletion = math.max(bestCompletion, GetCustomSetCompletion(variant, panelType))
        end
        setInfo._completion = bestCompletion
        return bestCompletion
    end

    local sources = GetSetSources(setInfo, panelType)
    local collected = 0
    for _, sourceID in ipairs(sources) do
        if IsSourceCollected(sourceID) then
            collected = collected + 1
        end
    end

    setInfo._collected = collected
    setInfo._total = #sources
    setInfo._completion = #sources > 0 and collected / #sources or 0
    return setInfo._completion
end

local BASIC_VARIANT_COLORS = {
    { "Black", 24, 24, 24 },
    { "Gray", 110, 110, 110 },
    { "White", 232, 232, 232 },
    { "Brown", 112, 69, 42 },
    { "Red", 196, 42, 42 },
    { "Orange", 224, 112, 30 },
    { "Yellow", 222, 196, 50 },
    { "Green", 55, 150, 62 },
    { "Teal", 40, 155, 150 },
    { "Blue", 54, 104, 205 },
    { "Purple", 126, 70, 180 },
    { "Pink", 218, 105, 160 },
    { "Gold", 196, 150, 42 },
    { "Silver", 174, 184, 194 },
}
local variantColorCache = {}

local function GetVariantColorInfo(setInfo, panelType)
    local cacheKey = format("%s:%s", panelType, tostring(setInfo.setID or setInfo))
    local cached = variantColorCache[cacheKey]
    if cached ~= nil then
        return cached or nil
    end

    local sources = GetSetSources(setInfo, panelType)
    local sourceInfo = sources[1] and GetSourceInfo(sources[1]) or nil
    local visualID = sourceInfo and sourceInfo.visualID
    local serialized = visualID and addon.ColorTable and addon.ColorTable[visualID]
    if type(serialized) ~= "string" then
        variantColorCache[cacheKey] = false
        return nil
    end

    local values = {}
    for value in serialized:gmatch("%^N%d+%^N([%d%.%-]+)") do
        values[#values + 1] = tonumber(value)
        if #values >= 3 then
            break
        end
    end
    local red, green, blue = values[1], values[2], values[3]
    if not red or not green or not blue then
        variantColorCache[cacheKey] = false
        return nil
    end

    local nearestName, nearestDistance
    for _, color in ipairs(BASIC_VARIANT_COLORS) do
        local deltaRed = red - color[2]
        local deltaGreen = green - color[3]
        local deltaBlue = blue - color[4]
        local distance = (deltaRed * deltaRed) + (deltaGreen * deltaGreen) + (deltaBlue * deltaBlue)
        if not nearestDistance or distance < nearestDistance then
            nearestName = color[1]
            nearestDistance = distance
        end
    end

    local info = {
        name = nearestName or "Color",
        hex = format("%02x%02x%02x", Clamp(math.floor(red + 0.5), 0, 255), Clamp(math.floor(green + 0.5), 0, 255), Clamp(math.floor(blue + 0.5), 0, 255)),
    }
    variantColorCache[cacheKey] = info
    return info
end

local function GetVariantDisplayLabel(group, variant, panelType, variantIndex)
    local description = CleanGroupText(variant.description)
    local name = CleanGroupText(variant.name)
    local parentName = CleanGroupText(group.name)
    local suffix = name:match("%s*%((.-)%)%s*$")

    local label
    if description ~= "" and string.lower(description) ~= string.lower(parentName) then
        label = description
    elseif suffix and string.lower(strtrim(suffix)) ~= "recolor" then
        label = strtrim(suffix)
    elseif name ~= "" and string.lower(NormalizeVariantName(name)) ~= string.lower(NormalizeVariantName(parentName)) then
        label = name
    elseif panelType == "weaponSets" and name ~= "" and string.lower(name) ~= string.lower(parentName) then
        label = name
    end

    local colorInfo = GetVariantColorInfo(variant, panelType)
    if not label or label == "" or string.lower(label) == "recolor" then
        if colorInfo then
            label = colorInfo.name
        elseif not name:find("(Recolor)", 1, true) and variantIndex == 1 then
            label = "Original"
        else
            label = format("Recolor %d", variantIndex)
        end
    end

    if colorInfo then
        return format("|cff%s■|r %s", colorInfo.hex, label)
    end
    return label
end

local function ClearCustomCompletionCache(setInfo)
    if not setInfo then
        return
    end
    setInfo._completion = nil
    setInfo._collected = nil
    setInfo._total = nil
    for _, variant in ipairs(setInfo.variants or {}) do
        ClearCustomCompletionCache(variant)
    end
end

local function SortCustomData(data, context, panelType)
    local sorting = addon.db.sorting
    local mode = sorting[context] or "default"
    local reverse = sorting.reverse == true

    table.sort(data, function(left, right)
        local leftID = tonumber(left.setID) or 0
        local rightID = tonumber(right.setID) or 0

        if mode == "name" then
            return StableCompare(string.lower(left.name or ""), string.lower(right.name or ""), leftID, rightID, reverse)
        elseif mode == "expansion" then
            return StableCompare(tonumber(left.expansionID) or 0, tonumber(right.expansionID) or 0, leftID, rightID, not reverse)
        elseif mode == "collected" then
            return StableCompare(GetCustomSetCompletion(left, panelType), GetCustomSetCompletion(right, panelType), leftID, rightID, not reverse)
        end

        local leftOrder = tonumber(left.uiOrder) or leftID
        local rightOrder = tonumber(right.uiOrder) or rightID
        return StableCompare(leftOrder, rightOrder, leftID, rightID, not reverse)
    end)
end

local function CustomGroupMatchesFilters(setInfo, context, panelType, isTransmogVendor)
    local completion = GetCustomSetCompletion(setInfo, panelType)
    local isCollected = completion >= 1
    local collectedShown = addon.db.filters[context .. "Collected"] ~= false
    local uncollectedShown = addon.db.filters[context .. "Uncollected"] ~= false

    if (isCollected and not collectedShown) or (not isCollected and not uncollectedShown) then
        return false
    end

    if isTransmogVendor then
        local options = GetTransmogOptions()
        local isHidden = setInfo.hidden == true or setInfo.isHidden == true or setInfo.hiddenUntilCollected == true
        if not isHidden then
            for _, variant in ipairs(setInfo.variants or {}) do
                if variant.hidden == true or variant.isHidden == true or variant.hiddenUntilCollected == true then
                    isHidden = true
                    break
                end
            end
        end
        if isHidden and options.showHidden ~= true then
            return false
        end

        if not isCollected and options.showIncomplete == false then
            return false
        end

        if panelType == "extraSets" and not isCollected and options.showIncomplete ~= false then
            local requiredPieces = Clamp(tonumber(options.partialLimit) or 4, 1, 8)
            local meetsRequiredPieces = false
            for _, variant in ipairs(setInfo.variants or { setInfo }) do
                GetCustomSetCompletion(variant, panelType)
                if (variant._collected or 0) >= requiredPieces then
                    meetsRequiredPieces = true
                    break
                end
            end
            if not meetsRequiredPieces then
                return false
            end
        end
    end

    local sourceIDs = {}
    for _, variant in ipairs(setInfo.variants or { setInfo }) do
        for _, sourceID in ipairs(GetSetSources(variant, panelType, true)) do
            sourceIDs[#sourceIDs + 1] = sourceID
        end
    end

    return SourceListMatchesFilters(sourceIDs, context)
end

local function SetItemTooltip(button)
    local sourceID = button.sourceID
    local info = sourceID and GetSourceInfo(sourceID)
    if not info then
        return
    end

    GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
    if info.itemLink then
        GameTooltip:SetHyperlink(info.itemLink)
    elseif info.itemID then
        GameTooltip:SetItemByID(info.itemID)
    else
        GameTooltip:SetText(GetSourceName(sourceID))
    end
    GameTooltip:Show()
end

local function CreateCollectionPanel(parent, panelType, context, modes, isTransmogVendor)
    local panel = CreateFrame("Frame", nil, parent)
    panel.panelType = panelType
    panel.context = context
    panel.searchType = Enum.TransmogSearchType.BaseSets
    panel.isTransmogVendor = isTransmogVendor == true
    panel:SetPoint("TOPLEFT", parent, "TOPLEFT", 4, -60)
    panel:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -6, 5)
    panel:Hide()

    panel.LeftInset = CreateFrame("Frame", nil, panel, "InsetFrameTemplate")
    panel.LeftInset:SetPoint("TOPLEFT", 0, 0)
    panel.LeftInset:SetPoint("BOTTOMLEFT", 0, 0)
    panel.LeftInset:SetWidth(LIST_WIDTH)

    panel.RightInset = CreateFrame("Frame", nil, panel, "CollectionsBackgroundTemplate")
    panel.RightInset:SetPoint("TOPLEFT", panel.LeftInset, "TOPRIGHT", 22, 0)
    panel.RightInset:SetPoint("BOTTOMRIGHT", 0, 0)

    panel.SearchBox = CreateFrame("EditBox", nil, panel.LeftInset, "SearchBoxTemplate")
    panel.SearchBox:SetSize(145, 20)
    panel.SearchBox:SetPoint("TOPLEFT", 19, -9)

    panel.UpButton = CreateFrame("Button", nil, panel.LeftInset, "UIPanelScrollUpButtonTemplate")
    panel.UpButton:SetSize(18, 18)
    panel.UpButton:SetPoint("TOPRIGHT", -5, -39)
    panel.DownButton = CreateFrame("Button", nil, panel.LeftInset, "UIPanelScrollDownButtonTemplate")
    panel.DownButton:SetSize(18, 18)
    panel.DownButton:SetPoint("BOTTOMRIGHT", -5, 5)

    panel.ScrollTrack = panel.LeftInset:CreateTexture(nil, "BACKGROUND")
    panel.ScrollTrack:SetAtlas("minimal-scrollbar-track-middle")
    panel.ScrollTrack:SetPoint("TOP", panel.UpButton, "BOTTOM", 0, -2)
    panel.ScrollTrack:SetPoint("BOTTOM", panel.DownButton, "TOP", 0, 2)
    panel.ScrollTrack:SetWidth(8)
    panel.ScrollTrack:SetAlpha(0.55)

    panel.ListButtons = {}
    for index = 1, LIST_ROWS do
        local button = CreateFrame("Button", nil, panel.LeftInset, "WardrobeSetsScrollFrameButtonTemplate")
        button:SetSize(208, LIST_ROW_HEIGHT)
        button:SetPoint("TOPLEFT", 46, -39 - ((index - 1) * LIST_ROW_HEIGHT))
        button:RegisterForClicks("LeftButtonUp")

        button.Icon = button.IconFrame and button.IconFrame.Icon
        button.Progress = button.Label
        button.Selected = button.SelectedTexture
        button.Highlight = button.HighlightTexture

        if button.IconFrame then
            if button.IconFrame.Cover then
                button.IconFrame.Cover:Hide()
            end
            if button.IconFrame.Favorite then
                button.IconFrame.Favorite:Hide()
            end
            button.IconFrame:SetScript("OnEnter", nil)
            button.IconFrame:SetScript("OnLeave", nil)
        end

        button.Name:SetWidth(190)
        button.Name:SetMaxLines(1)
        button.Label:SetWidth(190)
        button.Label:SetMaxLines(1)
        button.ProgressBar:SetWidth(0)

        button:SetScript("OnClick", function(self)
            if self.dataIndex then
                panel:SelectDataIndex(self.dataIndex)
                if panel.isTransmogVendor and IsApplyOnClickEnabled() then
                    panel:ApplySelectedToTransmog()
                end
            end
        end)

        panel.ListButtons[index] = button
    end

    panel.Model = CreateNativeModel(panel.RightInset)
    panel.Model:SetPoint("TOPLEFT", 3, -3)
    panel.Model:SetPoint("BOTTOMRIGHT", -4, 3)

    panel.ModelFade = panel.RightInset:CreateTexture(nil, "BACKGROUND")
    panel.ModelFade:SetAtlas("transmog-set-model-cutoff-fade")
    panel.ModelFade:SetPoint("TOPLEFT", 2, 0)
    panel.ModelFade:SetPoint("TOPRIGHT", 0, 0)
    panel.ModelFade:SetHeight(178)

    panel.Name = panel.RightInset:CreateFontString(nil, "OVERLAY", "Fancy24Font")
    panel.Name:SetPoint("TOP", 0, -37)
    panel.Name:SetWidth(390)
    panel.Name:SetMaxLines(1)
    panel.Name:SetTextColor(1, 0.82, 0)

    panel.Label = panel.RightInset:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    panel.Label:SetPoint("TOP", 0, -66)
    panel.Label:SetWidth(390)
    panel.Label:SetMaxLines(2)

    panel.VariantDropdown = CreateFrame("DropdownButton", nil, panel.RightInset, "WowStyle1DropdownTemplate")
    panel.VariantDropdown:SetSize(170, 22)
    panel.VariantDropdown:SetPoint("TOPRIGHT", -6, -6)
    panel.VariantDropdown:SetDefaultText("Variant")
    panel.VariantDropdown:Hide()

    panel.Progress = panel.RightInset:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    panel.Progress:SetPoint("TOP", 0, -82)
    panel.Progress:Hide()

    panel.IconBackground = panel.RightInset:CreateTexture(nil, "BORDER")
    panel.IconBackground:SetAtlas("transmog-set-iconrow-background", true)
    panel.IconBackground:SetPoint("TOP", 0, -78)

    panel.DetailButtons = {}
    for index = 1, MAX_DETAIL_ICONS do
        local button = CreateFrame("Button", nil, panel.RightInset)
        button:SetSize(32, 32)
        button.Icon = button:CreateTexture(nil, "ARTWORK")
        button.Icon:SetSize(28, 28)
        button.Icon:SetPoint("CENTER")
        button.Border = button:CreateTexture(nil, "OVERLAY")
        button.Border:SetPoint("CENTER")
        button.Border:SetAtlas("loottab-set-itemborder-white", true)
        button.Highlight = button:CreateTexture(nil, "HIGHLIGHT")
        button.Highlight:SetAllPoints()
        button.Highlight:SetAtlas("bags-roundhighlight")
        button.Highlight:SetBlendMode("ADD")
        button:SetScript("OnEnter", SetItemTooltip)
        button:SetScript("OnLeave", GameTooltip_Hide)
        button:SetScript("OnClick", function(self)
            if not self.sourceID then
                return
            end
            if panel.panelType == "weaponSets" then
                panel.activeSourceID = self.sourceID
                panel:RefreshPreview()
                if panel.isTransmogVendor and IsApplyOnClickEnabled() then
                    panel:ApplySelectedToTransmog(self.sourceID)
                end
            elseif IsModifiedClick("DRESSUP") then
                DressUpVisual(self.sourceID)
            end
        end)
        button:Hide()
        panel.DetailButtons[index] = button
    end

    panel.DressUpButton = CreateFrame("Button", nil, panel.RightInset, "UIPanelButtonTemplate")
    panel.DressUpButton:SetSize(145, 22)
    panel.DressUpButton:SetText("View in Dressing Room")

    if panel.isTransmogVendor then
        panel.ApplyButton = CreateFrame("Button", nil, panel.RightInset, "UIPanelButtonTemplate")
        panel.ApplyButton:SetSize(118, 22)
        panel.ApplyButton:SetPoint("BOTTOM", -67, 12)
        panel.ApplyButton:SetText(panelType == "weaponSets" and "Apply Weapon" or "Apply Set")
        panel.ApplyButton:SetScript("OnClick", function()
            panel:ApplySelectedToTransmog()
        end)
        panel.DressUpButton:SetSize(138, 22)
        panel.DressUpButton:SetPoint("BOTTOM", 69, 12)
    else
        panel.DressUpButton:SetPoint("BOTTOM", 0, 12)
    end
    panel.DressUpButton:SetScript("OnClick", function()
        local selected = panel.filteredData and panel.filteredData[panel.selectedDataIndex or 0]
        if not selected then
            return
        end
        local activeVariant = panel:GetActiveVariant(selected)
        local sources = GetSetSources(activeVariant, panel.panelType)
        if panel.panelType == "weaponSets" and panel.activeSourceID then
            DressUpVisual(panel.activeSourceID)
        else
            for _, sourceID in ipairs(sources) do
                DressUpVisual(sourceID)
            end
        end
    end)

    panel.selectedVariantIDs = {}

    function panel:GetActiveVariant(group)
        if not group then
            return nil
        end
        local variants = group.variants or { group }
        local selectedID = self.selectedVariantIDs[group.groupKey or group.setID]
        if selectedID then
            for _, variant in ipairs(variants) do
                if variant.setID == selectedID then
                    return variant
                end
            end
        end
        return variants[1]
    end

    function panel:ApplySelectedToTransmog(sourceID)
        if not self.isTransmogVendor then
            return false
        end

        local group = self.filteredData and self.filteredData[self.selectedDataIndex or 0]
        local activeVariant = self:GetActiveVariant(group)
        if not activeVariant then
            return false
        end

        if self.panelType == "weaponSets" then
            local selectedSourceID = sourceID or self.activeSourceID
            if not selectedSourceID then
                local sources = GetSetSources(activeVariant, self.panelType)
                selectedSourceID = sources[1]
            end
            return ApplyWeaponSourceToTransmog(selectedSourceID)
        end

        return ApplyArmorSourcesToTransmog(GetSetSources(activeVariant, self.panelType))
    end

    function panel:SetActiveVariant(group, variant)
        if not group or not variant then
            return
        end
        self.selectedVariantIDs[group.groupKey or group.setID] = variant.setID
        self.activeSourceID = nil
        self:RefreshButtons()
        self:RefreshPreview()
        if self.isTransmogVendor and IsApplyOnClickEnabled() then
            self:ApplySelectedToTransmog()
        end
    end

    function panel:GetSourceIcon(setInfo)
        local activeVariant = self:GetActiveVariant(setInfo)
        local sources = GetSetSources(activeVariant, self.panelType)
        if sources[1] then
            return C_TransmogCollection.GetSourceIcon(sources[1]) or QUESTION_MARK_ICON
        end
        return QUESTION_MARK_ICON
    end

    panel.VariantDropdown:SetupMenu(function(_, rootDescription)
        local group = panel.filteredData and panel.filteredData[panel.selectedDataIndex or 0]
        if not group then
            return
        end

        local variants = group.variants or { group }
        for variantIndex, variant in ipairs(variants) do
            local shortLabel = GetVariantDisplayLabel(group, variant, panel.panelType, variantIndex)
            GetCustomSetCompletion(variant, panel.panelType)
            local menuLabel = format("%s  |cffaaaaaa%d/%d|r", shortLabel, variant._collected or 0, variant._total or 0)
            local data = {
                group = group,
                variant = variant,
                shortLabel = shortLabel,
            }
            rootDescription:CreateRadio(
                menuLabel,
                function(entry)
                    return panel:GetActiveVariant(entry.group) == entry.variant
                end,
                function(entry)
                    panel:SetActiveVariant(entry.group, entry.variant)
                    return MenuResponse.Close
                end,
                data
            )
        end
    end)

    function panel:RefreshList()
        local query = string.lower(strtrim(self.SearchBox:GetText() or ""))
        self.filteredData = {}
        for _, setInfo in ipairs(self.data or {}) do
            local haystack = string.lower(setInfo.searchText or format("%s %s %s", setInfo.name or "", setInfo.label or "", setInfo.description or ""))
            if (query == "" or string.find(haystack, query, 1, true))
                and CustomGroupMatchesFilters(setInfo, self.context, self.panelType, self.isTransmogVendor) then
                self.filteredData[#self.filteredData + 1] = setInfo
            end
        end

        SortCustomData(self.filteredData, self.context, self.panelType)
        self.offset = Clamp(self.offset or 0, 0, math.max(0, #self.filteredData - LIST_ROWS))

        if self.selectedSetID then
            for dataIndex, setInfo in ipairs(self.filteredData) do
                if setInfo.setID == self.selectedSetID then
                    self.selectedDataIndex = dataIndex
                    break
                end
            end
        end

        if not self.selectedDataIndex or not self.filteredData[self.selectedDataIndex] then
            self.selectedDataIndex = self.filteredData[1] and 1 or nil
            self.selectedSetID = self.filteredData[1] and self.filteredData[1].setID or nil
        end

        self:RefreshButtons()
        self:RefreshPreview()
    end

    function panel:RefreshButtons()
        local total = #self.filteredData
        local first = (self.offset or 0) + 1
        for row, button in ipairs(self.ListButtons) do
            local dataIndex = first + row - 1
            local setInfo = self.filteredData[dataIndex]
            if setInfo then
                local activeVariant = self:GetActiveVariant(setInfo)
                local completion = GetCustomSetCompletion(activeVariant, self.panelType)
                button.dataIndex = dataIndex
                button.Icon:SetTexture(self:GetSourceIcon(setInfo))
                local displayOptions = GetTransmogOptions()
                local showNames = not self.isTransmogVendor or displayOptions.showNames ~= false
                local showSetCount = not self.isTransmogVendor or displayOptions.showSetCount ~= false
                button.Name:SetShown(showNames)
                button.Name:SetText(showNames and (setInfo.name or format("Set %d", setInfo.setID or 0)) or "")
                local variantCount = #(setInfo.variants or { setInfo })
                local progressParts = {}
                if showSetCount then
                    progressParts[#progressParts + 1] = format("%d/%d", activeVariant._collected or 0, activeVariant._total or 0)
                end
                if variantCount > 1 then
                    progressParts[#progressParts + 1] = format("%d colors", variantCount)
                end
                progressParts[#progressParts + 1] = GetExpansionName(setInfo.expansionID)
                button.Progress:SetText(table.concat(progressParts, "  •  "))
                button.Selected:SetShown(dataIndex == self.selectedDataIndex)
                if button.ProgressBar then
                    button.ProgressBar:SetWidth(204 * Clamp(completion, 0, 1))
                    button.ProgressBar:SetShown(completion > 0)
                end
                button:Show()
                if completion >= 1 then
                    button.Name:SetTextColor(0.3, 1, 0.3)
                elseif completion <= 0 then
                    button.Name:SetTextColor(0.55, 0.55, 0.55)
                else
                    button.Name:SetTextColor(1, 0.82, 0)
                end
            else
                button.dataIndex = nil
                button:Hide()
            end
        end

        local maxOffset = math.max(0, total - LIST_ROWS)
        local showScrollControls = total > LIST_ROWS
        self.UpButton:SetShown(showScrollControls)
        self.DownButton:SetShown(showScrollControls)
        self.UpButton:SetEnabled(showScrollControls and (self.offset or 0) > 0)
        self.DownButton:SetEnabled(showScrollControls and (self.offset or 0) < maxOffset)
        if self.ScrollTrack then
            self.ScrollTrack:SetShown(showScrollControls)
        end
    end

    function panel:Scroll(delta)
        local maxOffset = math.max(0, #self.filteredData - LIST_ROWS)
        self.offset = Clamp((self.offset or 0) + delta, 0, maxOffset)
        self:RefreshButtons()
    end

    function panel:SelectDataIndex(dataIndex)
        local setInfo = self.filteredData[dataIndex]
        if not setInfo then
            return
        end
        self.selectedDataIndex = dataIndex
        self.selectedSetID = setInfo.setID
        self.activeSourceID = nil
        self:RefreshButtons()
        self:RefreshPreview()
    end

    function panel:RefreshPreview()
        local group = self.filteredData and self.filteredData[self.selectedDataIndex or 0]
        if not group then
            self.Name:SetText("")
            self.Label:SetText("")
            self.Progress:SetText("")
            self.VariantDropdown:Hide()
            self.Model:Undress()
            for _, button in ipairs(self.DetailButtons) do
                button:Hide()
            end
            return
        end

        local setInfo = self:GetActiveVariant(group)
        local variants = group.variants or { group }
        local displayOptions = GetTransmogOptions()
        local showNames = not self.isTransmogVendor or displayOptions.showNames ~= false
        self.Name:SetShown(showNames)
        self.Name:SetText(showNames and (group.name or setInfo.name or format("Set %d", group.setID or 0)) or "")

        local variantIndex = 1
        for index, variant in ipairs(variants) do
            if variant == setInfo then
                variantIndex = index
                break
            end
        end
        local variantLabel = GetVariantDisplayLabel(group, setInfo, self.panelType, variantIndex)
        self.VariantDropdown:SetShown(#variants > 1)
        if #variants > 1 then
            self.VariantDropdown:OverrideText(variantLabel)
        end

        local label
        if self.panelType == "weaponSets" then
            label = CleanGroupText(setInfo.description)
            if label == "" then
                label = CleanGroupText(setInfo.name)
            end
        else
            label = setInfo.label
            if type(label) ~= "string" or label == "" then
                label = addon.FilterNames[setInfo.filter] or setInfo.description or GetExpansionName(setInfo.expansionID)
            end
        end
        self.Label:SetText(label)

        GetCustomSetCompletion(setInfo, self.panelType)
        self.Progress:SetText(format("Collected: %d of %d", setInfo._collected or 0, setInfo._total or 0))
        self.Progress:SetShown(self.isTransmogVendor and displayOptions.showSetCount ~= false)

        local sources = GetSetSources(setInfo, self.panelType)
        self.Model:SetUnit("player", false, PlayerUtil.ShouldUseNativeFormInModelScene())
        self.Model:Undress()

        if self.panelType == "weaponSets" then
            local selectedSource = self.activeSourceID
            if not selectedSource or not GetSourceInfo(selectedSource) then
                selectedSource = sources[1]
            end
            self.activeSourceID = selectedSource
            if selectedSource then
                self.Model:TryOn(selectedSource)
            end
        else
            for _, sourceID in ipairs(sources) do
                self.Model:TryOn(sourceID)
            end
        end

        local iconCount = math.min(#sources, MAX_DETAIL_ICONS)
        local columns = math.min(iconCount, 9)
        for index, button in ipairs(self.DetailButtons) do
            local sourceID = sources[index]
            if sourceID then
                local row = math.floor((index - 1) / 9)
                local column = (index - 1) % 9
                local rowCount = math.min(columns, iconCount - (row * 9))
                local rowWidth = (rowCount * 32) + ((rowCount - 1) * 4)
                button:ClearAllPoints()
                button:SetPoint("TOPLEFT", self.RightInset, "TOP", -(rowWidth / 2) + (column * 36), -84 - (row * 36))
                button.sourceID = sourceID
                button.Icon:SetTexture(C_TransmogCollection.GetSourceIcon(sourceID) or QUESTION_MARK_ICON)
                button.Icon:SetDesaturated(not IsSourceCollected(sourceID))
                button:SetAlpha(IsSourceCollected(sourceID) and 1 or 0.55)
                button.Border:SetVertexColor(self.panelType == "weaponSets" and sourceID == self.activeSourceID and 1 or 0.8, 0.8, 0.8)
                button:Show()
            else
                button.sourceID = nil
                button:Hide()
            end
        end

        C_Timer.After(0, function()
            if self:IsShown() then
                RefreshPanelCamera(self)
            end
        end)
    end

    function panel:OnSearchUpdate()
        self:RefreshList()
    end

    function panel:OnUnitModelChangedEvent()
        if not IsUnitModelReadyForUI("player") then
            return false
        end
        self.Model:SetUnit("player", false, PlayerUtil.ShouldUseNativeFormInModelScene())
        self.Model.cameraID = nil
        self.Model:UpdatePanAndZoomModelType()
        self:RefreshPreview()
        return true
    end

    function panel:RefreshCameras()
        RefreshPanelCamera(self)
    end

    function panel:HandleKey(key)
        if key == WARDROBE_DOWN_VISUAL_KEY then
            self:SelectDataIndex(math.min(#self.filteredData, (self.selectedDataIndex or 1) + 1))
            return true
        elseif key == WARDROBE_UP_VISUAL_KEY then
            self:SelectDataIndex(math.max(1, (self.selectedDataIndex or 1) - 1))
            return true
        end
        return false
    end

    panel.SearchBox:HookScript("OnTextChanged", function()
        panel.offset = 0
        panel:RefreshList()
    end)
    panel.UpButton:SetScript("OnClick", function()
        panel:Scroll(-LIST_ROWS)
    end)
    panel.DownButton:SetScript("OnClick", function()
        panel:Scroll(LIST_ROWS)
    end)
    panel:EnableMouseWheel(true)
    panel:SetScript("OnMouseWheel", function(_, delta)
        panel:Scroll(delta > 0 and -3 or 3)
    end)
    panel:SetScript("OnShow", function()
        panel:RefreshList()
        RefreshPanelCamera(panel)
    end)

    return panel
end

local function BuildExtraSetData()
    local _, _, classID = UnitClass("player")
    local armorType = addon.ClassArmorType[classID] or "CLOTH"
    local data = {}
    local seen = {}
    local setTypes

    if addon.db and addon.db.general and addon.db.general.ignoreClassRestrictions then
        setTypes = { "CLOTH", "LEATHER", "MAIL", "PLATE", "COSMETIC" }
    else
        setTypes = { armorType, "COSMETIC" }
    end

    for _, setType in ipairs(setTypes) do
        for _, setInfo in pairs(addon.ArmorSets[setType] or {}) do
            if type(setInfo) == "table" and setInfo.itemData and not seen[setInfo.setID] then
                seen[setInfo.setID] = true
                data[#data + 1] = setInfo
            end
        end
    end

    return BuildVariantGroups(data, "extraSets")
end

local function BuildWeaponSetData()
    addon:FinalizeWeaponSetData()
    return BuildVariantGroups(addon.WeaponSets, "weaponSets")
end

local function LayoutExtensionTabs(wardrobe)
    local tabs = {
        wardrobe.ItemsTab,
        wardrobe.SetsTab,
        wardrobe.ExtraSetsTab,
        wardrobe.WeaponSetsTab,
    }

    -- Register all four tabs first. Blizzard's helper reanchors tabs 2-4, so our
    -- content-sized layout must be applied after this call.
    PanelTemplates_SetNumTabs(wardrobe, 4)

    local previousTab
    for tabID, tab in ipairs(tabs) do
        if tab then
            tab:ClearAllPoints()
            tab.minWidth = nil
            tab.maxWidth = nil
            PanelTemplates_TabResize(tab, TAB_PADDING)

            if previousTab then
                tab:SetPoint("LEFT", previousTab, "RIGHT", TAB_GAP, 0)
            else
                tab:SetPoint("TOPLEFT", wardrobe, "TOPLEFT", TAB_START_X, TAB_START_Y)
            end

            previousTab = tab
        end
    end

    -- Blizzard normally anchors this relative to the Items tab, which places it
    -- behind a four-tab row. Keep the native progress bar and move it into the
    -- free space immediately after the final tab.
    if wardrobe.progressBar and previousTab then
        wardrobe.progressBar:EnableMouse(false)
        wardrobe.progressBar:SetFrameLevel(math.max(0, wardrobe:GetFrameLevel() + 1))
        local selectedTab = wardrobe.selectedCollectionTab or wardrobe.selectedTab or TAB_ITEMS
        local rightAnchor = wardrobe
        local rightPoint = "RIGHT"
        local rightOffset = -16

        -- On the Items tab, use every pixel between the final tab and the
        -- native search field. The Sets search field moves to the left column,
        -- so that tab instead uses the remaining header width to the frame edge.
        if selectedTab == TAB_ITEMS and wardrobe.SearchBox and wardrobe.SearchBox:IsShown() then
            rightAnchor = wardrobe.SearchBox
            rightPoint = "LEFT"
            rightOffset = -PROGRESS_BAR_RIGHT_GAP
        end

        wardrobe.progressBar:ClearAllPoints()
        wardrobe.progressBar:SetPoint("LEFT", previousTab, "RIGHT", PROGRESS_BAR_GAP, -1)
        wardrobe.progressBar:SetPoint("RIGHT", rightAnchor, rightPoint, rightOffset, -1)
    end
end

function addon:LayoutWardrobeTabs()
    local wardrobe = _G.WardrobeCollectionFrame
    if wardrobe then
        LayoutExtensionTabs(wardrobe)
    end
end

local function ConfigureWardrobeTabClick(wardrobe, tab)
    if not tab then
        return
    end

    tab:RegisterForClicks("LeftButtonUp")
    tab:EnableMouse(true)
    tab:SetHitRectInsets(0, 0, 0, 0)
    tab:SetFrameLevel(math.max(tab:GetFrameLevel(), wardrobe:GetFrameLevel() + 5))
    tab:SetScript("OnClick", function(clickedTab)
        local tabID = clickedTab:GetID()
        if wardrobe.selectedCollectionTab ~= tabID then
            wardrobe:SetTab(tabID)
            PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        end
        LayoutExtensionTabs(wardrobe)
    end)
end

local function ConfigureAllWardrobeTabClicks(wardrobe)
    ConfigureWardrobeTabClick(wardrobe, wardrobe.ItemsTab)
    ConfigureWardrobeTabClick(wardrobe, wardrobe.SetsTab)
    ConfigureWardrobeTabClick(wardrobe, wardrobe.ExtraSetsTab)
    ConfigureWardrobeTabClick(wardrobe, wardrobe.WeaponSetsTab)
end

local function CreateExtensionTabs(wardrobe)
    local extraTab = CreateFrame("Button", "WardrobeCollectionFrameTab3", wardrobe, "PanelTopTabButtonTemplate")
    extraTab:SetID(TAB_EXTRA_SETS)
    extraTab:SetText("Extra Sets")
    wardrobe.ExtraSetsTab = extraTab

    local weaponTab = CreateFrame("Button", "WardrobeCollectionFrameTab4", wardrobe, "PanelTopTabButtonTemplate")
    weaponTab:SetID(TAB_WEAPON_SETS)
    weaponTab:SetText("Weapons")
    wardrobe.WeaponSetsTab = weaponTab

    ConfigureAllWardrobeTabClicks(wardrobe)
    LayoutExtensionTabs(wardrobe)
end

local function ApplyTabState(wardrobe, tabID)
    local extraPanel = wardrobe.BetterWardrobeExtraSetsFrame
    local weaponPanel = wardrobe.BetterWardrobeWeaponSetsFrame

    if tabID == TAB_EXTRA_SETS or tabID == TAB_WEAPON_SETS then
        wardrobe.ItemsCollectionFrame:Hide()
        wardrobe.SetsCollectionFrame:Hide()
        wardrobe.SearchBox:Hide()
        wardrobe.ClassDropdown:Hide()
        wardrobe.FilterButton:ClearAllPoints()
        wardrobe.FilterButton:SetPoint("TOPRIGHT", extraPanel.LeftInset, "TOPRIGHT", -6, -9)
        wardrobe.FilterButton:SetWidth(90)
        wardrobe.FilterButton:Show()
        wardrobe.FilterButton:SetEnabled(true)
        if wardrobe.progressBar then
            wardrobe.progressBar:Hide()
        end

        if tabID == TAB_EXTRA_SETS then
            weaponPanel:Hide()
            extraPanel:Show()
            wardrobe.activeFrame = extraPanel
            ConfigureCustomFilterButton(wardrobe, extraPanel, "extraSets", EXTRA_SET_SORTS)
        else
            extraPanel:Hide()
            weaponPanel:Show()
            wardrobe.activeFrame = weaponPanel
            ConfigureCustomFilterButton(wardrobe, weaponPanel, "weaponSets", WEAPON_SET_SORTS)
        end
    else
        extraPanel:Hide()
        weaponPanel:Hide()
        wardrobe.SearchBox:Show()
        wardrobe.ClassDropdown:Show()
        wardrobe.FilterButton:ClearAllPoints()
        wardrobe.FilterButton:SetPoint("LEFT", wardrobe.SearchBox, "RIGHT", 5, 0)
        wardrobe.FilterButton:SetWidth(90)
        wardrobe.FilterButton:Show()
        if wardrobe.progressBar then
            wardrobe.progressBar:Show()
        end

        ConfigureNativeFilterDefaults(wardrobe, tabID == TAB_SETS and "sets" or "items")
    end

    LayoutExtensionTabs(wardrobe)
end

local function InitializeCollectionExtensions()
    if initialized or not _G.WardrobeCollectionFrame then
        return
    end
    initialized = true

    local wardrobe = _G.WardrobeCollectionFrame
    local extraPanel = CreateCollectionPanel(wardrobe, "extraSets", "extraSets", EXTRA_SET_SORTS)
    local weaponPanel = CreateCollectionPanel(wardrobe, "weaponSets", "weaponSets", WEAPON_SET_SORTS)
    extraPanel.data = BuildExtraSetData()
    weaponPanel.data = BuildWeaponSetData()

    wardrobe.BetterWardrobeExtraSetsFrame = extraPanel
    wardrobe.BetterWardrobeWeaponSetsFrame = weaponPanel

    RegisterWardrobeMenuModifiers()
    CreateExtensionTabs(wardrobe)

    hooksecurefunc(wardrobe, "InitItemsFilterButton", function(self)
        ConfigureNativeFilterDefaults(self, "items")
    end)
    hooksecurefunc(wardrobe, "InitBaseSetsFilterButton", function(self)
        ConfigureNativeFilterDefaults(self, "sets")
    end)
    hooksecurefunc(wardrobe, "SetTab", function(self, tabID)
        ApplyTabState(self, tabID)
    end)
    hooksecurefunc(wardrobe, "ClickTab", function(self)
        LayoutExtensionTabs(self)
    end)

    wardrobe:HookScript("OnShow", function(self)
        ConfigureAllWardrobeTabClicks(self)
        LayoutExtensionTabs(self)
        ApplyTabState(self, self.selectedCollectionTab or TAB_ITEMS)
    end)
    wardrobe:HookScript("OnHide", function()
        extraPanel:Hide()
        weaponPanel:Hide()
    end)

    if WardrobeItemsCollectionMixin and WardrobeItemsCollectionMixin.FilterVisuals then
        hooksecurefunc(WardrobeItemsCollectionMixin, "FilterVisuals", ApplyNativeItemFilters)
    end
    if WardrobeItemsCollectionMixin and WardrobeItemsCollectionMixin.SortVisuals then
        hooksecurefunc(WardrobeItemsCollectionMixin, "SortVisuals", ApplyNativeItemSort)
    end
    HookLiveCollectionItemSort(wardrobe.ItemsCollectionFrame)
    if WardrobeSetsCollectionContainerMixin and WardrobeSetsCollectionContainerMixin.UpdateDataProvider then
        hooksecurefunc(WardrobeSetsCollectionContainerMixin, "UpdateDataProvider", ApplyNativeSetDisplayProvider)
    end

    ApplyTabState(wardrobe, wardrobe.selectedCollectionTab or TAB_ITEMS)
    addon:FireCallback("COLLECTION_EXTENSIONS_READY", wardrobe, extraPanel, weaponPanel)
end


local function SetApplyOnClickValue(enabled)
    enabled = enabled == true
    local setting = addon.settingsObjects and addon.settingsObjects.applyOnClick
    if setting and type(setting.SetValue) == "function" then
        setting:SetValue(enabled)
    elseif addon.SetApplyOnClickEnabled then
        addon:SetApplyOnClickEnabled(enabled)
    elseif addon.db and addon.db.transmog then
        addon.db.transmog.applyOnClick = enabled
    end
end

local function SyncApplyOnClickCheckbox(wardrobe)
    local checkbox = wardrobe and wardrobe.BetterWardrobeApplyOnClickCheckbox
    if checkbox then
        checkbox:SetChecked(IsApplyOnClickEnabled())
    end
end

local function CreateApplyOnClickCheckbox(wardrobe, tabContent)
    if wardrobe.BetterWardrobeApplyOnClickCheckbox then
        SyncApplyOnClickCheckbox(wardrobe)
        return wardrobe.BetterWardrobeApplyOnClickCheckbox
    end

    local checkbox = CreateFrame("CheckButton", nil, wardrobe, "UICheckButtonTemplate")
    checkbox:SetSize(30, 30)
    checkbox:SetPoint("BOTTOMLEFT", tabContent, "BOTTOMLEFT", 50, 15)
    checkbox:SetFrameLevel(math.max(checkbox:GetFrameLevel(), tabContent:GetFrameLevel() + 200))
    checkbox:RegisterForClicks("LeftButtonUp")

    checkbox.Label = checkbox:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    checkbox.Label:SetPoint("LEFT", checkbox, "RIGHT", 2, 1)
    checkbox.Label:SetText("Apply On Click")

    checkbox:SetScript("OnClick", function(self)
        SetApplyOnClickValue(self:GetChecked())
    end)
    checkbox:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Apply On Click")
        GameTooltip:AddLine("Clicking an Extra Set or weapon entry immediately places it into the pending outfit.", 1, 1, 1, true)
        GameTooltip:Show()
    end)
    checkbox:SetScript("OnLeave", GameTooltip_Hide)

    wardrobe.BetterWardrobeApplyOnClickCheckbox = checkbox
    SyncApplyOnClickCheckbox(wardrobe)
    return checkbox
end

local function RefreshOneExtensionFrame(wardrobe, rebuildExtraSets)
    if not wardrobe then
        return
    end

    local extraPanel = wardrobe.BetterWardrobeExtraSetsFrame
    local weaponPanel = wardrobe.BetterWardrobeWeaponSetsFrame

    if extraPanel then
        if rebuildExtraSets then
            extraPanel.data = BuildExtraSetData()
            extraPanel.selectedDataIndex = nil
            extraPanel.selectedSetID = nil
            extraPanel.offset = 0
        end
        for _, setInfo in ipairs(extraPanel.data or {}) do
            ClearCustomCompletionCache(setInfo)
        end
        extraPanel:RefreshList()
    end

    if weaponPanel then
        for _, setInfo in ipairs(weaponPanel.data or {}) do
            ClearCustomCompletionCache(setInfo)
        end
        weaponPanel:RefreshList()
    end

    SyncApplyOnClickCheckbox(wardrobe)
end

local function RefreshExtensionPanels(rebuildExtraSets)
    RefreshOneExtensionFrame(_G.WardrobeCollectionFrame, rebuildExtraSets)
    RefreshOneExtensionFrame(_G.TransmogFrame and _G.TransmogFrame.WardrobeCollection or nil, rebuildExtraSets)
end


local function InitializeTransmogExtensions()
    if transmogInitialized or not addon.db or not C_AddOns.IsAddOnLoaded("Blizzard_Transmog") then
        return
    end

    if not C_AddOns.IsAddOnLoaded("Blizzard_Collections") then
        local loaded = C_AddOns.LoadAddOn("Blizzard_Collections")
        if not loaded then
            return
        end
    end

    local transmogFrame = _G.TransmogFrame
    local wardrobe = transmogFrame and transmogFrame.WardrobeCollection
    local tabContent = wardrobe and wardrobe.TabContent
    if not wardrobe or not tabContent or type(wardrobe.AddNamedTab) ~= "function" then
        return
    end

    transmogInitialized = true

    RegisterWardrobeMenuModifiers()
    local itemsFrame = tabContent.ItemsFrame
    HookLiveTransmogItemSort(itemsFrame)
    ConfigureTransmogItemFilterDefaults(itemsFrame)

    local extraPanel = CreateCollectionPanel(tabContent, "extraSets", "extraSets", EXTRA_SET_SORTS, true)
    local weaponPanel = CreateCollectionPanel(tabContent, "weaponSets", "weaponSets", WEAPON_SET_SORTS, true)
    extraPanel:ClearAllPoints()
    extraPanel:SetAllPoints(tabContent)
    weaponPanel:ClearAllPoints()
    weaponPanel:SetAllPoints(tabContent)
    extraPanel.data = BuildExtraSetData()
    weaponPanel.data = BuildWeaponSetData()
    extraPanel.DressUpButton:SetText("View in Dressing Room")
    weaponPanel.DressUpButton:SetText("View in Dressing Room")

    tabContent.BetterWardrobeExtraSetsFrame = extraPanel
    tabContent.BetterWardrobeWeaponSetsFrame = weaponPanel
    wardrobe.BetterWardrobeExtraSetsFrame = extraPanel
    wardrobe.BetterWardrobeWeaponSetsFrame = weaponPanel
    wardrobe.BetterWardrobeExtraSetsTabID = wardrobe:AddNamedTab("Extra Sets", extraPanel)
    wardrobe.BetterWardrobeWeaponSetsTabID = wardrobe:AddNamedTab("Weapons", weaponPanel)
    CreateApplyOnClickCheckbox(wardrobe, tabContent)

    addon:FireCallback("TRANSMOG_EXTENSIONS_READY", wardrobe, extraPanel, weaponPanel)
end

local function HookTransmogFrameInitialization()
    local transmogFrame = _G.TransmogFrame
    if transmogFrameHooked or not transmogFrame then
        return
    end

    transmogFrameHooked = true
    transmogFrame:HookScript("OnShow", function()
        if not transmogInitialized then
            C_Timer.After(0, InitializeTransmogExtensions)
        else
            local wardrobe = _G.TransmogFrame and _G.TransmogFrame.WardrobeCollection
            SyncApplyOnClickCheckbox(wardrobe)
        end
    end)
end

local function TryInitializeTransmogExtensions()
    if addon.db and C_AddOns.IsAddOnLoaded("Blizzard_Transmog") then
        HookTransmogFrameInitialization()
        InitializeTransmogExtensions()
    end
end

local function TryInitializeCollectionExtensions()
    if addon.db and C_AddOns.IsAddOnLoaded("Blizzard_Collections") then
        InitializeCollectionExtensions()
    end
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:RegisterEvent("TRANSMOG_COLLECTION_UPDATED")
loader:RegisterEvent("GET_ITEM_INFO_RECEIVED")
loader:SetScript("OnEvent", function(_, event, loadedAddon, eventArg2)
    if event == "ADDON_LOADED" and loadedAddon == "Blizzard_Collections" then
        TryInitializeCollectionExtensions()
        TryInitializeTransmogExtensions()
    elseif event == "ADDON_LOADED" and loadedAddon == "Blizzard_Transmog" then
        TryInitializeCollectionExtensions()
        TryInitializeTransmogExtensions()
    elseif event == "TRANSMOG_COLLECTION_UPDATED" and initialized then
        wipe(sourceInfoCache)
        wipe(variantColorCache)
        local wardrobe = _G.WardrobeCollectionFrame
        if wardrobe then
            local extraPanel = wardrobe.BetterWardrobeExtraSetsFrame
            local weaponPanel = wardrobe.BetterWardrobeWeaponSetsFrame
            if extraPanel then
                for _, setInfo in ipairs(extraPanel.data or {}) do
                    ClearCustomCompletionCache(setInfo)
                end
                extraPanel:RefreshList()
            end
            if weaponPanel then
                for _, setInfo in ipairs(weaponPanel.data or {}) do
                    ClearCustomCompletionCache(setInfo)
                end
                weaponPanel:RefreshList()
            end
        end

        local transmogWardrobe = _G.TransmogFrame and _G.TransmogFrame.WardrobeCollection
        if transmogWardrobe then
            local extraPanel = transmogWardrobe.BetterWardrobeExtraSetsFrame
            local weaponPanel = transmogWardrobe.BetterWardrobeWeaponSetsFrame
            if extraPanel then
                for _, setInfo in ipairs(extraPanel.data or {}) do
                    ClearCustomCompletionCache(setInfo)
                end
                extraPanel:RefreshList()
            end
            if weaponPanel then
                for _, setInfo in ipairs(weaponPanel.data or {}) do
                    ClearCustomCompletionCache(setInfo)
                end
                weaponPanel:RefreshList()
            end
        end
    elseif event == "GET_ITEM_INFO_RECEIVED" and initialized then
        local itemID, success = loadedAddon, eventArg2
        if itemID and success and pendingItemLoads[itemID] then
            pendingItemLoads[itemID] = nil
            itemNameCache[itemID] = nil
            itemExpansionCache[itemID] = nil
            local filters = addon.db and addon.db.filters
            local sorting = addon.db and addon.db.sorting
            if sorting and (sorting.items == "expansion" or sorting.items == "name") then
                ScheduleNativeItemsRefresh()
            end

            local wardrobe = _G.WardrobeCollectionFrame
            if wardrobe then
                if (filters and tonumber(filters.setExpansion) and tonumber(filters.setExpansion) >= 0)
                    or (sorting and sorting.sets == "expansion") then
                    C_Timer.After(0, function()
                        RefreshNativeSort("sets")
                    end)
                end

                local extraPanel = wardrobe.BetterWardrobeExtraSetsFrame
                if extraPanel and ((filters and tonumber(filters.extraSetsExpansion) and tonumber(filters.extraSetsExpansion) >= 0)
                    or (sorting and sorting.extraSets == "expansion")) then
                    C_Timer.After(0, function()
                        extraPanel:RefreshList()
                    end)
                end

                local weaponPanel = wardrobe.BetterWardrobeWeaponSetsFrame
                if weaponPanel and ((filters and tonumber(filters.weaponSetsExpansion) and tonumber(filters.weaponSetsExpansion) >= 0)
                    or (sorting and sorting.weaponSets == "expansion")) then
                    C_Timer.After(0, function()
                        weaponPanel:RefreshList()
                    end)
                end
            end
        end
    end
end)

addon:RegisterCallback("DATABASE_READY", TryInitializeCollectionExtensions)
addon:RegisterCallback("DATABASE_READY", TryInitializeTransmogExtensions)
addon:RegisterCallback("APPLY_ON_CLICK_CHANGED", function()
    local wardrobe = _G.TransmogFrame and _G.TransmogFrame.WardrobeCollection
    SyncApplyOnClickCheckbox(wardrobe)
end)
addon:RegisterCallback("OPTIONS_CHANGED", function(callbackKey)
    if callbackKey == "ignoreClassRestrictions" then
        RefreshExtensionPanels(true)
    elseif callbackKey == "transmogFilters" or callbackKey == "transmogDisplay" or callbackKey == "transmogApply" then
        RefreshExtensionPanels(false)
    end
end)
TryInitializeCollectionExtensions()
TryInitializeTransmogExtensions()
