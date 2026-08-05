local addonName, addon = ...

local Audit = {
    running = false,
    batchSize = 75,
    phase = nil,
    index = 0,
    sourceEntries = nil,
    baseSetEntries = nil,
    result = nil,
}
addon.CatalogAudit = Audit

local auditFrame = CreateFrame("Frame")
auditFrame:Hide()

local function CountTable(tbl)
    local count = 0
    for _ in pairs(tbl or {}) do
        count = count + 1
    end
    return count
end

local function AppendExample(list, value, limit)
    if #list < (limit or 8) then
        list[#list + 1] = value
    end
end

local function JoinExamples(list)
    if not list or #list == 0 then
        return "none"
    end
    return table.concat(list, ", ")
end

local function GetWardrobeFrames()
    local wardrobe = _G.WardrobeCollectionFrame
    if not wardrobe then
        return nil
    end

    return wardrobe,
        wardrobe.ItemsCollectionFrame,
        wardrobe.SetsCollectionFrame,
        wardrobe.BetterWardrobeExtraSetsFrame,
        wardrobe.BetterWardrobeWeaponSetsFrame
end

local function CountPanelVariants(panel)
    local groups = panel and panel.data or {}
    local variants = 0
    local uniqueSetIDs = {}

    for _, group in ipairs(groups) do
        local entries = group.variants or { group }
        variants = variants + #entries
        for _, entry in ipairs(entries) do
            local setID = tonumber(entry.setID)
            if setID then
                uniqueSetIDs[setID] = true
            end
        end
    end

    return #groups, variants, CountTable(uniqueSetIDs)
end

local function CaptureUnderlyingCounts(catalog)
    local wardrobe, itemsFrame, setsFrame, extraPanel, weaponPanel = GetWardrobeFrames()
    local setsDataProvider = catalog and catalog.GetNativeSetsDataProvider and catalog:GetNativeSetsDataProvider()
    local extraGroups, extraVariants = CountPanelVariants(extraPanel)
    local weaponGroups, weaponVariants = CountPanelVariants(weaponPanel)

    return {
        staticSources = CountTable(catalog and catalog.sourceIDs),
        itemVisuals = type(itemsFrame and itemsFrame.visualsList) == "table" and #itemsFrame.visualsList or nil,
        setBaseRecords = type(setsDataProvider and setsDataProvider.baseSets) == "table" and #setsDataProvider.baseSets or nil,
        extraGroups = extraGroups,
        extraVariants = extraVariants,
        weaponGroups = weaponGroups,
        weaponVariants = weaponVariants,
        wardrobe = wardrobe,
        itemsFrame = itemsFrame,
        setsFrame = setsFrame,
        extraPanel = extraPanel,
        weaponPanel = weaponPanel,
        setsDataProvider = setsDataProvider,
    }
end

local function RefreshDisplayedLists(snapshot)
    local refreshed = {
        items = false,
        sets = false,
        extraSets = false,
        weapons = false,
    }

    local itemsFrame = snapshot.itemsFrame
    -- Blizzard's FilterVisuals() assumes visualsList is already initialized.
    -- Inactive tabs can legitimately have no Items provider yet, so do not
    -- call the native filter/sort path until both source and display lists exist.
    if itemsFrame and type(itemsFrame.visualsList) == "table" and itemsFrame.FilterVisuals then
        itemsFrame:FilterVisuals()
        if type(itemsFrame.filteredVisualsList) == "table" and itemsFrame.SortVisuals then
            itemsFrame:SortVisuals()
        end
        refreshed.items = true
    end

    local setsFrame = snapshot.setsFrame
    local setsInitialized = snapshot.setBaseRecords ~= nil
        or (setsFrame and setsFrame.IsShown and setsFrame:IsShown())
    if setsInitialized and setsFrame and setsFrame.ListContainer
        and setsFrame.ListContainer.UpdateDataProvider then
        setsFrame.ListContainer:UpdateDataProvider()
        refreshed.sets = true
    end

    if snapshot.extraPanel and snapshot.extraPanel.RefreshList then
        snapshot.extraPanel:RefreshList()
        refreshed.extraSets = true
    end
    if snapshot.weaponPanel and snapshot.weaponPanel.RefreshList then
        snapshot.weaponPanel:RefreshList()
        refreshed.weapons = true
    end

    return refreshed
end

local function PrepareWardrobeProviders()
    if not C_AddOns.IsAddOnLoaded("Blizzard_Collections") then
        local loaded = C_AddOns.LoadAddOn("Blizzard_Collections")
        if not loaded then
            return false, "Blizzard_Collections could not be loaded"
        end
    end

    if not _G.WardrobeCollectionFrame then
        return false, "WardrobeCollectionFrame is unavailable"
    end

    -- Do not force inactive tab frames through their OnShow/refresh paths. The
    -- audit creates an isolated native Sets provider and reads Items display
    -- state only when Blizzard has already initialized that tab.
    return true
end

local function BeginSourceScan()
    Audit.phase = "sources"
    Audit.index = 0
    print(format(
        "|cff33ff99BetterWardrobe audit:|r scanning %d bundled source IDs in small batches...",
        #Audit.sourceEntries
    ))
    auditFrame:Show()
end

local function FinishAudit()
    -- Stop the OnUpdate driver before finalizing. If a native provider is in an
    -- unexpected state, this prevents the same failure from repeating every frame.
    Audit.running = false
    Audit.phase = nil
    auditFrame:Hide()

    local result = Audit.result
    local catalog = addon.FullCatalog
    local before = result.before

    result.refreshedPanels = RefreshDisplayedLists(before)
    local after = CaptureUnderlyingCounts(catalog)

    local auditProvider = result.auditSetsProvider
    local auditBaseSets = auditProvider and auditProvider.baseSets
    local auditBaseCount = type(auditBaseSets) == "table" and #auditBaseSets or 0

    result.filterIntegrity = before.staticSources == after.staticSources
        and (before.itemVisuals == nil or after.itemVisuals == before.itemVisuals)
        and (before.setBaseRecords == nil or after.setBaseRecords == before.setBaseRecords)
        and before.extraGroups == after.extraGroups
        and before.extraVariants == after.extraVariants
        and before.weaponGroups == after.weaponGroups
        and before.weaponVariants == after.weaponVariants
        and auditBaseCount == result.providerBaseCount

    local extraGroups, extraVariants, extraUnique = CountPanelVariants(after.extraPanel)
    local weaponGroups, weaponVariants, weaponUnique = CountPanelVariants(after.weaponPanel)
    result.extraGroups = extraGroups
    result.extraVariants = extraVariants
    result.extraUnique = extraUnique
    result.weaponGroups = weaponGroups
    result.weaponVariants = weaponVariants
    result.weaponUnique = weaponUnique

    result.itemsUnderlying = type(after.itemsFrame and after.itemsFrame.visualsList) == "table"
        and #after.itemsFrame.visualsList or nil
    result.itemsDisplayed = type(after.itemsFrame and after.itemsFrame.filteredVisualsList) == "table"
        and #after.itemsFrame.filteredVisualsList or nil
    result.itemsSupplemental = nil
    if type(after.itemsFrame and after.itemsFrame.visualsList) == "table" then
        result.itemsSupplemental = 0
        for _, visualInfo in ipairs(after.itemsFrame.visualsList) do
            if visualInfo.betterWardrobeSupplemental then
                result.itemsSupplemental = result.itemsSupplemental + 1
            end
        end
    end

    result.setsUnderlying = auditBaseCount
    result.setsDisplayed = after.setsFrame and after.setsFrame.ListContainer
        and tonumber(after.setsFrame.ListContainer.betterWardrobeDisplayCount) or nil
    result.setsSupplemental = 0
    if type(auditBaseSets) == "table" then
        for _, setInfo in ipairs(auditBaseSets) do
            if setInfo.betterWardrobeSupplemental then
                result.setsSupplemental = result.setsSupplemental + 1
            end
        end
    end

    result.extraDisplayed = after.extraPanel and after.extraPanel.filteredData and #after.extraPanel.filteredData or 0
    result.weaponDisplayed = after.weaponPanel and after.weaponPanel.filteredData and #after.weaponPanel.filteredData or 0

    local sourceCoverage = result.staticSources == #Audit.sourceEntries
    local setCoverage = result.providerAvailable and result.missingArmorBaseSets == 0
    local panelCoverage = before.extraVariants == extraVariants
        and before.weaponVariants == weaponVariants
        and extraVariants > 0
        and weaponVariants > 0
    result.passed = sourceCoverage and setCoverage and panelCoverage and result.filterIntegrity

    local uniqueVisualCount = CountTable(result.visualIDs)
    local categoryCount = CountTable(result.categories)
    local status = result.passed and "|cff33ff99PASS|r" or "|cffff5555CHECK|r"
    print(format(
        "|cff33ff99BetterWardrobe audit %s:|r %d/%d bundled IDs retained; %d resolved into %d visuals across %d categories; %d pending/restricted.",
        status,
        result.staticSources,
        #Audit.sourceEntries,
        result.resolvedSources,
        uniqueVisualCount,
        categoryCount,
        result.unresolvedSources
    ))

    local itemsUnderlyingText = result.itemsUnderlying and tostring(result.itemsUnderlying) or "not initialized"
    local itemsDisplayedText = result.itemsDisplayed and tostring(result.itemsDisplayed) or "not initialized"
    local itemsSupplementalText = result.itemsSupplemental ~= nil and tostring(result.itemsSupplemental) or "not initialized"
    print(format(
        "|cff33ff99Bundled Items catalog:|r %d visuals across %d categories.  |cff33ff99Current Items view:|r %s underlying / %s displayed / %s supplemental.",
        uniqueVisualCount,
        categoryCount,
        itemsUnderlyingText,
        itemsDisplayedText,
        itemsSupplementalText
    ))

    local setsDisplayedText = result.setsDisplayed and tostring(result.setsDisplayed) or "not initialized"
    print(format(
        "|cff33ff99Native Sets provider:|r %d base records / %d supplemental.  |cff33ff99Current Sets display:|r %s.",
        result.setsUnderlying,
        result.setsSupplemental,
        setsDisplayedText
    ))
    print(format(
        "|cff33ff99Extra Sets:|r %d grouped rows / %d displayed / %d class-eligible source records.  |cff33ff99Weapons:|r %d grouped rows / %d displayed / %d source records.",
        result.extraGroups,
        result.extraDisplayed,
        result.extraVariants,
        result.weaponGroups,
        result.weaponDisplayed,
        result.weaponVariants
    ))
    print(format(
        "|cff33ff99API set coverage:|r %d/%d armor base groups present; %d missing.  |cff33ff99Filter integrity:|r %s.",
        result.coveredArmorBaseSets,
        result.expectedArmorBaseSets,
        result.missingArmorBaseSets,
        result.filterIntegrity and "PASS (underlying counts unchanged)" or "FAILED (a display refresh changed catalog counts)"
    ))

    if result.itemsUnderlying == nil then
        print("|cffffcc00Items view note:|r the Items tab was inactive, so only the complete bundled Items catalog was audited.")
    end
    if result.setsDisplayed == nil then
        print("|cffffcc00Sets view note:|r the Sets tab was inactive; coverage was verified with an isolated native Blizzard Sets provider.")
    end
    if (result.providerRepresentativeRows or 0) > 0 then
        print(format(
            "|cffffcc00Sets provider note:|r %d base groups are represented by a variant row because Blizzard returned no standalone base record. Examples: %s",
            result.providerRepresentativeRows,
            JoinExamples(result.providerRepresentativeExamples)
        ))
    end
    if result.providerError then
        print("|cffff5555Native Sets provider error:|r " .. tostring(result.providerError))
    end
    if result.unresolvedSources > 0 then
        print(format(
            "|cffffcc00Pending/restricted source examples:|r %s",
            JoinExamples(result.unresolvedExamples)
        ))
    end
    if result.missingArmorBaseSets > 0 then
        print(format(
            "|cffff5555Missing armor base-set examples:|r %s",
            JoinExamples(result.missingSetExamples)
        ))
    end

    Audit.lastResult = result
    Audit.sourceEntries = nil
    Audit.baseSetEntries = nil
    Audit.result = nil
    auditFrame:Hide()
end

local function ProcessSourceBatch()
    local result = Audit.result
    local catalog = addon.FullCatalog
    local limit = math.min(#Audit.sourceEntries, Audit.index + Audit.batchSize)

    for index = Audit.index + 1, limit do
        local entry = Audit.sourceEntries[index]
        local record = catalog:GetSourceRecord(entry.sourceID, entry.categoryID)
        if record then
            result.resolvedSources = result.resolvedSources + 1
            if record.visualID then
                result.visualIDs[record.visualID] = true
            end
            if record.categoryID then
                result.categories[record.categoryID] = (result.categories[record.categoryID] or 0) + 1
            else
                result.uncategorizedSources = result.uncategorizedSources + 1
            end
        else
            result.unresolvedSources = result.unresolvedSources + 1
            AppendExample(result.unresolvedExamples, tostring(entry.sourceID))
        end
    end

    Audit.index = limit
    if Audit.index >= #Audit.sourceEntries then
        Audit.phase = "sets"
        Audit.index = 0
    end
end

local function ProcessSetBatch()
    local result = Audit.result
    local catalog = addon.FullCatalog
    local limit = math.min(#Audit.baseSetEntries, Audit.index + Audit.batchSize)

    for index = Audit.index + 1, limit do
        local entry = Audit.baseSetEntries[index]
        if catalog:IsArmorSet(entry.record) then
            result.expectedArmorBaseSets = result.expectedArmorBaseSets + 1
            if result.providerSetIDs[entry.baseSetID] then
                result.coveredArmorBaseSets = result.coveredArmorBaseSets + 1
            else
                result.missingArmorBaseSets = result.missingArmorBaseSets + 1
                AppendExample(result.missingSetExamples, tostring(entry.baseSetID))
            end
        end
    end

    Audit.index = limit
    if Audit.index >= #Audit.baseSetEntries then
        FinishAudit()
    end
end

local function AbortAudit(errorMessage)
    Audit.running = false
    Audit.phase = nil
    Audit.sourceEntries = nil
    Audit.baseSetEntries = nil
    Audit.result = nil
    auditFrame:Hide()
    print("|cffff5555BetterWardrobe audit stopped safely:|r " .. tostring(errorMessage))
end

auditFrame:SetScript("OnUpdate", function()
    if not Audit.running then
        auditFrame:Hide()
        return
    end

    local ok, errorMessage
    if Audit.phase == "sources" then
        ok, errorMessage = pcall(ProcessSourceBatch)
    elseif Audit.phase == "sets" then
        ok, errorMessage = pcall(ProcessSetBatch)
    else
        ok = false
        errorMessage = "unknown audit phase"
    end

    if not ok then
        AbortAudit(errorMessage)
    end
end)

function addon:RunCatalogAudit()
    if Audit.running then
        print("|cffffcc00BetterWardrobe audit is already running.|r")
        return
    end

    local catalog = self.FullCatalog
    if not catalog then
        print("|cffff5555BetterWardrobe audit could not start: the full catalog module is unavailable.|r")
        return
    end

    local prepared, reason = PrepareWardrobeProviders()
    if not prepared then
        print("|cffff5555BetterWardrobe audit could not start:|r " .. tostring(reason))
        return
    end

    if not catalog.built then
        catalog:Rebuild()
    end

    local sourceEntries = {}
    for sourceID, entry in pairs(catalog.sourceIDs or {}) do
        sourceEntries[#sourceEntries + 1] = {
            sourceID = tonumber(sourceID),
            categoryID = entry and tonumber(entry.categoryID),
        }
    end
    table.sort(sourceEntries, function(left, right)
        return (left.sourceID or 0) < (right.sourceID or 0)
    end)

    local baseSetEntries = {}
    for baseSetID, record in pairs(catalog.apiBaseRecords or {}) do
        baseSetEntries[#baseSetEntries + 1] = {
            baseSetID = tonumber(baseSetID),
            record = record,
        }
    end
    table.sort(baseSetEntries, function(left, right)
        return (left.baseSetID or 0) < (right.baseSetID or 0)
    end)

    local before = CaptureUnderlyingCounts(catalog)
    local auditSetsProvider, providerError = catalog:CreateAuditSetsDataProvider()
    local providerSetIDs = {}
    local providerBaseCount = 0
    local providerRepresentativeRows = 0
    local providerRepresentativeExamples = {}
    if auditSetsProvider and type(auditSetsProvider.baseSets) == "table" then
        providerBaseCount = #auditSetsProvider.baseSets
        for _, setInfo in ipairs(auditSetsProvider.baseSets) do
            local setID = tonumber(setInfo.setID)
            local baseSetID = tonumber(setInfo.baseSetID)
            if not baseSetID or baseSetID <= 0 then
                baseSetID = setID
                if setID and C_TransmogSets and C_TransmogSets.GetBaseSetID then
                    local resolvedBaseSetID = tonumber(C_TransmogSets.GetBaseSetID(setID))
                    if resolvedBaseSetID and resolvedBaseSetID > 0 then
                        baseSetID = resolvedBaseSetID
                    end
                end
            end
            if baseSetID then
                providerSetIDs[baseSetID] = true
            end
            if setID and baseSetID and setID ~= baseSetID then
                providerRepresentativeRows = providerRepresentativeRows + 1
                AppendExample(providerRepresentativeExamples, format("%d->%d", baseSetID, setID))
            end
        end
    end

    Audit.running = true
    Audit.sourceEntries = sourceEntries
    Audit.baseSetEntries = baseSetEntries
    Audit.result = {
        before = before,
        staticSources = CountTable(catalog.sourceIDs),
        resolvedSources = 0,
        unresolvedSources = 0,
        uncategorizedSources = 0,
        visualIDs = {},
        categories = {},
        unresolvedExamples = {},
        expectedArmorBaseSets = 0,
        coveredArmorBaseSets = 0,
        missingArmorBaseSets = 0,
        missingSetExamples = {},
        providerSetIDs = providerSetIDs,
        providerAvailable = auditSetsProvider ~= nil and providerBaseCount > 0,
        providerBaseCount = providerBaseCount,
        providerError = providerError,
        auditSetsProvider = auditSetsProvider,
        providerRepresentativeRows = providerRepresentativeRows,
        providerRepresentativeExamples = providerRepresentativeExamples,
    }

    BeginSourceScan()
end
