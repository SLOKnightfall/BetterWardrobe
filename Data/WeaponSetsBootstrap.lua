local addonName, addon = ...

addon.WeaponCallbacks = addon.WeaponCallbacks or {}
addon.GetExpacWepSetNameBySetID = addon.GetExpacWepSetNameBySetID or {}
addon.GetExpacWepSetSourcesBySetID = addon.GetExpacWepSetSourcesBySetID or {}
addon.WeaponSets = addon.WeaponSets or {}
addon.localized = addon.localized or {}

local function ResolveText(value)
    if value == nil then
        return nil
    end
    if type(value) ~= "string" then
        return tostring(value)
    end
    return addon.localized[value] or value:gsub("_", " ")
end

function addon.GetLocalizedString(value)
    return ResolveText(value)
end

function addon.GetTradingPostReleaseString(month, year)
    return format("Trading Post: %s %s", tostring(month or ""), tostring(year or ""))
end

function addon.ColorStringByClass(value)
    return ResolveText(value)
end

function addon.GetColoredClassNameString(value)
    return ResolveText(value)
end

function addon.AddWepDBLineToTables(line, expansionID)
    if type(line) ~= "table" or type(line[8]) ~= "table" then
        return
    end

    local sources = {}
    for _, source in ipairs(line[8]) do
        if type(source) == "table" and tonumber(source[2]) then
            sources[#sources + 1] = {
                weaponType = tonumber(source[1]),
                sourceID = tonumber(source[2]),
                note = ResolveText(source[3]),
                secondaryNote = ResolveText(source[4]),
            }
        end
    end

    if #sources == 0 then
        return
    end

    addon.WeaponSets[#addon.WeaponSets + 1] = {
        setID = tonumber(line[1]) or 0,
        name = ResolveText(line[2]) or format("Weapon Set %s", tostring(line[1] or "")),
        label = ResolveText(line[3]) or "",
        description = ResolveText(line[4]) or "",
        patchID = tonumber(line[5]) or 0,
        note = ResolveText(line[6]),
        secondaryNote = ResolveText(line[7]),
        sources = sources,
        sourceType = tonumber(line[9]),
        availability = tonumber(line[10]),
        requiredFaction = line[11],
        expansionID = tonumber(expansionID) or 0,
    }
end

function addon:FinalizeWeaponSetData()
    wipe(self.WeaponSets)

    local expansionIDs = {}
    for expansionID in pairs(self.WeaponCallbacks) do
        expansionIDs[#expansionIDs + 1] = expansionID
    end
    table.sort(expansionIDs)

    for _, expansionID in ipairs(expansionIDs) do
        local callback = self.WeaponCallbacks[expansionID]
        if type(callback) == "function" then
            pcall(callback)
        end
    end
end
