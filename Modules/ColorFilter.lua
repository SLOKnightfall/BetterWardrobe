local addonName, addon = ...

-- Production BetterWardrobe used a standalone color-swatch button rather than
-- adding Color to Blizzard's Filter menu. This native adaptation keeps that
-- interaction while filtering Blizzard's live Items/Appearances providers.
local COLOR_TOLERANCE = 17
local visualLABCache = {}
local frameStates = setmetatable({}, { __mode = "k" })
local refreshGuards = setmetatable({}, { __mode = "k" })
local pickerOwner = nil
local collectionFramesHooked = setmetatable({}, { __mode = "k" })
local transmogFramesHooked = setmetatable({}, { __mode = "k" })
local colorPickerHideHooked = false

local function ButtonOnEnter(self)
    if not self.tooltip then
        return
    end

    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:AddLine(self.tooltip)
    GameTooltip:Show()
end

local function ButtonOnLeave()
    GameTooltip_Hide()
end

-- Standard RGB -> XYZ -> CIE-L*ab conversion used by production.
local function ConvertRGBToLAB(r, g, b)
    local varR = r / 255
    local varG = g / 255
    local varB = b / 255

    varR = varR > 0.04045 and math.pow((varR + 0.055) / 1.055, 2.4) or varR / 12.92
    varG = varG > 0.04045 and math.pow((varG + 0.055) / 1.055, 2.4) or varG / 12.92
    varB = varB > 0.04045 and math.pow((varB + 0.055) / 1.055, 2.4) or varB / 12.92

    varR = varR * 100
    varG = varG * 100
    varB = varB * 100

    local x = varR * 0.4124 + varG * 0.3576 + varB * 0.1805
    local y = varR * 0.2126 + varG * 0.7152 + varB * 0.0722
    local z = varR * 0.0193 + varG * 0.1192 + varB * 0.9505

    local varX = x / 95.044
    local varY = y / 100.000
    local varZ = z / 108.755

    varX = varX > 0.008856 and math.pow(varX, 1 / 3) or (7.787 * varX) + (16 / 116)
    varY = varY > 0.008856 and math.pow(varY, 1 / 3) or (7.787 * varY) + (16 / 116)
    varZ = varZ > 0.008856 and math.pow(varZ, 1 / 3) or (7.787 * varZ) + (16 / 116)

    return (116 * varY) - 16, 500 * (varX - varY), 200 * (varY - varZ)
end

-- Delta E94 comparison used by production BetterWardrobe.
local function CompareLAB(l1, a1, b1, l2, a2, b2)
    local deltaL = l1 - l2
    local deltaA = a1 - a2
    local deltaB = b1 - b2

    local chroma1 = math.sqrt((a1 * a1) + (b1 * b1))
    local chroma2 = math.sqrt((a2 * a2) + (b2 * b2))
    local deltaC = chroma1 - chroma2
    local deltaH = (deltaA * deltaA) + (deltaB * deltaB) - (deltaC * deltaC)
    deltaH = deltaH < 0 and 0 or math.sqrt(deltaH)

    local scaleC = 1 + (0.045 * chroma1)
    local scaleH = 1 + (0.015 * chroma1)
    local adjustedL = deltaL
    local adjustedC = deltaC / scaleC
    local adjustedH = deltaH / scaleH
    local value = (adjustedL * adjustedL) + (adjustedC * adjustedC) + (adjustedH * adjustedH)

    return value < 0 and 0 or math.sqrt(value)
end

-- Preserve the production helper names for any external BetterWardrobe code.
addon.ConvertRGB_to_LAB = addon.ConvertRGB_to_LAB or ConvertRGBToLAB
addon.CompareLAB = addon.CompareLAB or CompareLAB

local function GetVisualLABColors(visualID)
    visualID = tonumber(visualID)
    if not visualID then
        return nil
    end

    local cached = visualLABCache[visualID]
    if cached ~= nil then
        return cached or nil
    end

    local serialized = addon.ColorTable and addon.ColorTable[visualID]
    if type(serialized) ~= "string" then
        visualLABCache[visualID] = false
        return nil
    end

    -- AceSerializer stored the production sampled palette in the second table.
    -- Parse only that table, matching production's colors[2] behavior.
    local startIndex = serialized:find("^N2^T", 1, true)
    if not startIndex then
        visualLABCache[visualID] = false
        return nil
    end

    local payload = serialized:sub(startIndex + 5)
    local endIndex = payload:find("^t^t^^", 1, true)
    if endIndex then
        payload = payload:sub(1, endIndex - 1)
    end

    local values = {}
    local maxIndex = 0
    for key, value in payload:gmatch("%^N(%d+)%^N([%-]?[%d%.]+)") do
        key = tonumber(key)
        value = tonumber(value)
        if key and value then
            values[key] = value
            maxIndex = math.max(maxIndex, key)
        end
    end

    local colors = {}
    for index = 1, maxIndex - 2, 3 do
        local red, green, blue = values[index], values[index + 1], values[index + 2]
        if red and green and blue then
            colors[#colors + 1] = { ConvertRGBToLAB(red, green, blue) }
        end
    end

    visualLABCache[visualID] = #colors > 0 and colors or false
    return #colors > 0 and colors or nil
end

local function VisualMatchesColor(visualID, filterL, filterA, filterB)
    local colors = GetVisualLABColors(visualID)
    if not colors then
        return false
    end

    for _, color in ipairs(colors) do
        if CompareLAB(filterL, filterA, filterB, color[1], color[2], color[3]) <= COLOR_TOLERANCE then
            return true
        end
    end

    return false
end

local function GetState(itemsFrame)
    local state = frameStates[itemsFrame]
    if not state then
        state = {
            active = false,
            r = 1,
            g = 1,
            b = 1,
        }
        frameStates[itemsFrame] = state
    end
    return state
end

local function GetVisualID(entry)
    if type(entry) ~= "table" then
        return nil
    end

    return tonumber(entry.visualID)
        or tonumber(entry.itemAppearanceID)
        or (entry.appearanceInfo and tonumber(entry.appearanceInfo.visualID))
end

local function FilterEntries(entries, state, copyEntries)
    if type(entries) ~= "table" or not state or not state.active then
        return entries
    end

    local filterL, filterA, filterB = ConvertRGBToLAB(state.r * 255, state.g * 255, state.b * 255)

    if copyEntries then
        local filtered = {}
        for _, entry in ipairs(entries) do
            local visualID = GetVisualID(entry)
            if visualID and VisualMatchesColor(visualID, filterL, filterA, filterB) then
                filtered[#filtered + 1] = entry
            end
        end
        return filtered
    end

    for index = #entries, 1, -1 do
        local visualID = GetVisualID(entries[index])
        if not visualID or not VisualMatchesColor(visualID, filterL, filterA, filterB) then
            table.remove(entries, index)
        end
    end

    return entries
end

local function RefreshItemsFrame(itemsFrame, frameType)
    if not itemsFrame then
        return
    end

    if frameType == "collection" then
        if itemsFrame.RefreshVisualsList then
            itemsFrame:RefreshVisualsList()
        elseif itemsFrame.FilterVisuals then
            itemsFrame:FilterVisuals()
            if itemsFrame.SortVisuals then
                itemsFrame:SortVisuals()
            end
        end

        if itemsFrame.ResetPage then
            itemsFrame:ResetPage()
        elseif itemsFrame.UpdateItems then
            itemsFrame:UpdateItems()
        end
    elseif frameType == "transmog" then
        if itemsFrame.RefreshCollectionEntries then
            itemsFrame:RefreshCollectionEntries()
        end
        if itemsFrame.RefreshPagedEntry then
            itemsFrame:RefreshPagedEntry()
        end
    end
end

local function SetPickerOriginalSwatchShown(shown)
    local content = ColorPickerFrame and ColorPickerFrame.Content
    local original = content and content.ColorSwatchOriginal
    if original then
        original:SetShown(shown)
    end
end

local function UpdateControl(control)
    local state = GetState(control.itemsFrame)
    control.colorSwatch:SetShown(state.active)
    control.revert:SetShown(state.active)
    if state.active then
        control.colorSwatch:SetVertexColor(state.r, state.g, state.b, 1)
    end
end

local function ResetFilter(control, refresh)
    if not control or not control.itemsFrame then
        return
    end

    if pickerOwner == control and ColorPickerFrame then
        ColorPickerFrame:Hide()
    end

    local state = GetState(control.itemsFrame)
    state.active = false
    state.category = nil
    UpdateControl(control)

    if refresh then
        RefreshItemsFrame(control.itemsFrame, control.frameType)
    end
end

local function ShowColorPicker(control)
    if not control or not control.itemsFrame or not ColorPickerFrame then
        return
    end

    local state = GetState(control.itemsFrame)
    local currentR = state.active and state.r or 1
    local currentG = state.active and state.g or 1
    local currentB = state.active and state.b or 1

    local function ApplyColor()
        if not ColorPickerFrame then
            return
        end

        local red, green, blue = ColorPickerFrame:GetColorRGB()
        local category = control.itemsFrame.GetActiveCategory and control.itemsFrame:GetActiveCategory()
            or control.itemsFrame.activeCategory
            or control.itemsFrame.activeCategoryID

        if state.active
            and state.r == red
            and state.g == green
            and state.b == blue
            and state.category == category then
            return
        end

        state.active = true
        state.r = red
        state.g = green
        state.b = blue
        state.category = category
        UpdateControl(control)
        RefreshItemsFrame(control.itemsFrame, control.frameType)
    end

    local function CancelColor()
        ResetFilter(control, true)
    end

    if not colorPickerHideHooked then
        colorPickerHideHooked = true
        ColorPickerFrame:HookScript("OnHide", function()
            SetPickerOriginalSwatchShown(true)
            pickerOwner = nil
        end)
    end

    if ColorPickerFrame.SetupColorPickerAndShow then
        ColorPickerFrame:SetupColorPickerAndShow({
            r = currentR,
            g = currentG,
            b = currentB,
            hasOpacity = false,
            swatchFunc = ApplyColor,
            cancelFunc = CancelColor,
        })
    else
        ColorPickerFrame.hasOpacity = false
        ColorPickerFrame.previousValues = { currentR, currentG, currentB, 1 }
        ColorPickerFrame.swatchFunc = ApplyColor
        ColorPickerFrame.cancelFunc = CancelColor
        ColorPickerFrame:SetColorRGB(currentR, currentG, currentB)
        ColorPickerFrame:Show()
    end

    pickerOwner = control
    SetPickerOriginalSwatchShown(false)
end

local function CreateColorFilterControl(itemsFrame, frameType)
    if not itemsFrame then
        return nil
    end

    if itemsFrame.BetterWardrobeColorFilter then
        UpdateControl(itemsFrame.BetterWardrobeColorFilter)
        return itemsFrame.BetterWardrobeColorFilter
    end

    local frame = CreateFrame("Button", nil, itemsFrame)
    frame:SetSize(25, 25)
    frame:SetFrameLevel(itemsFrame:GetFrameLevel() + 50)
    frame.itemsFrame = itemsFrame
    frame.frameType = frameType

    if frameType == "collection" and itemsFrame.SlotsFrame then
        -- Same placement used by the production color-wheel implementation.
        frame:SetPoint("TOPRIGHT", itemsFrame.SlotsFrame, "BOTTOMLEFT", 30, -30)
    elseif frameType == "transmog" and itemsFrame.WeaponDropdown then
        frame:SetPoint("RIGHT", itemsFrame.WeaponDropdown, "LEFT", -10, 0)
    else
        frame:SetPoint("TOPRIGHT", itemsFrame, "TOPRIGHT", -185, -105)
    end

    local button = CreateFrame("Button", nil, frame)
    button:SetSize(13, 13)
    button:SetPoint("CENTER")
    button.tooltip = "Select color"
    button:SetScript("OnClick", function()
        ShowColorPicker(frame)
    end)
    button:SetScript("OnEnter", ButtonOnEnter)
    button:SetScript("OnLeave", ButtonOnLeave)

    local colorSwatch = button:CreateTexture(nil, "OVERLAY")
    colorSwatch:SetSize(13, 13)
    colorSwatch:SetTexture(130939)
    colorSwatch:SetPoint("CENTER")
    colorSwatch:Hide()
    frame.colorSwatch = colorSwatch

    local checkers = button:CreateTexture(nil, "BACKGROUND")
    checkers:SetSize(13, 13)
    checkers:SetTexture(188523)
    checkers:SetTexCoord(0.25, 0, 0.5, 0.25)
    checkers:SetDesaturated(true)
    checkers:SetVertexColor(1, 1, 1, 0.75)
    checkers:SetPoint("CENTER", colorSwatch)

    local border = frame:CreateTexture(nil, "OVERLAY")
    border:SetTexture([[Interface\CastingBar\UI-CastingBar-Arena-Shield]])
    border:SetSize(43, 43)
    border:SetPoint("LEFT", -1, -1)

    local revert = CreateFrame("Button", nil, frame)
    revert:SetPoint("CENTER", 16, 15)
    revert:SetSize(20, 20)
    revert:Hide()
    revert.tooltip = "Reset"
    revert:SetScript("OnClick", function()
        ResetFilter(frame, true)
    end)
    revert:SetScript("OnEnter", ButtonOnEnter)
    revert:SetScript("OnLeave", ButtonOnLeave)

    local revertTexture = revert:CreateTexture(nil, "OVERLAY")
    revertTexture:SetAtlas("transmog-icon-revert-small")
    revertTexture:SetAllPoints()
    frame.revert = revert

    frame:SetScript("OnHide", function()
        ResetFilter(frame, true)
    end)

    itemsFrame.BetterWardrobeColorFilter = frame
    UpdateControl(frame)
    return frame
end

local function ApplyCollectionColorFilter(itemsFrame)
    if refreshGuards[itemsFrame] then
        return
    end

    local state = GetState(itemsFrame)
    if not state.active or type(itemsFrame.filteredVisualsList) ~= "table" then
        return
    end

    FilterEntries(itemsFrame.filteredVisualsList, state, false)
    if itemsFrame.PagingFrame and itemsFrame.PagingFrame.SetMaxPages then
        local pageSize = tonumber(itemsFrame.PAGE_SIZE) or 18
        itemsFrame.PagingFrame:SetMaxPages(math.max(1, math.ceil(#itemsFrame.filteredVisualsList / pageSize)))
    end
end

local function ApplyTransmogColorFilter(itemsFrame)
    if refreshGuards[itemsFrame] then
        return
    end

    local state = GetState(itemsFrame)
    if not state.active or type(itemsFrame.itemCollectionEntries) ~= "table" or not itemsFrame.SetCollectionEntries then
        return
    end

    local filtered = FilterEntries(itemsFrame.itemCollectionEntries, state, true)
    itemsFrame.itemCollectionEntries = filtered

    refreshGuards[itemsFrame] = true
    itemsFrame:SetCollectionEntries(filtered, true)
    refreshGuards[itemsFrame] = nil
end

local function InitializeCollectionColorFilter()
    if not C_AddOns.IsAddOnLoaded("Blizzard_Collections") then
        return
    end

    local wardrobe = _G.WardrobeCollectionFrame
    local itemsFrame = wardrobe and wardrobe.ItemsCollectionFrame
    if not itemsFrame then
        return
    end

    CreateColorFilterControl(itemsFrame, "collection")

    -- Blizzard copies mixin methods onto the live frame during XML creation. Hooking
    -- WardrobeItemsCollectionMixin here is too late and does not affect that copy, so
    -- keep the production color predicate attached to the actual displayed frame.
    if itemsFrame.FilterVisuals and not collectionFramesHooked[itemsFrame] then
        collectionFramesHooked[itemsFrame] = true
        hooksecurefunc(itemsFrame, "FilterVisuals", ApplyCollectionColorFilter)
    end
end

local function InitializeTransmogColorFilter()
    if not C_AddOns.IsAddOnLoaded("Blizzard_Transmog") then
        return
    end

    local wardrobe = _G.TransmogFrame and _G.TransmogFrame.WardrobeCollection
    local itemsFrame = wardrobe and wardrobe.TabContent and wardrobe.TabContent.ItemsFrame
    if not itemsFrame then
        return
    end

    CreateColorFilterControl(itemsFrame, "transmog")

    -- The transmogrifier also owns a live copy of the mixin methods. Filter the
    -- itemCollectionEntries after Blizzard rebuilds them, then republish the limited
    -- list through the native PagedContent provider.
    if itemsFrame.RefreshCollectionEntries and not transmogFramesHooked[itemsFrame] then
        transmogFramesHooked[itemsFrame] = true
        hooksecurefunc(itemsFrame, "RefreshCollectionEntries", ApplyTransmogColorFilter)
    end
end

local function TryInitialize()
    InitializeCollectionColorFilter()
    InitializeTransmogColorFilter()
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:SetScript("OnEvent", function(_, _, loadedAddon)
    if loadedAddon == "Blizzard_Collections" or loadedAddon == "Blizzard_Transmog" then
        C_Timer.After(0, TryInitialize)
    end
end)

addon:RegisterCallback("DATABASE_READY", TryInitialize)
addon:RegisterCallback("COLLECTION_EXTENSIONS_READY", function()
    C_Timer.After(0, InitializeCollectionColorFilter)
end)
addon:RegisterCallback("TRANSMOG_EXTENSIONS_READY", function()
    C_Timer.After(0, InitializeTransmogColorFilter)
end)

TryInitialize()
