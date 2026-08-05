local addonName, addon = ...

local DEFAULT_WIDTH = 450
local DEFAULT_HEIGHT = 545
local MIN_WIDTH = 400
local MAX_WIDTH = 1400
local MIN_HEIGHT = 450
local MAX_HEIGHT = 1100

local dressUpHooked = false
local applyingSettings = false

local function ClampConfiguredSize()
    local config = addon.db and addon.db.dressingRoom
    if not config then
        return DEFAULT_WIDTH, DEFAULT_HEIGHT
    end

    config.width = Clamp(tonumber(config.width) or 600, MIN_WIDTH, MAX_WIDTH)
    config.height = Clamp(tonumber(config.height) or 800, MIN_HEIGHT, MAX_HEIGHT)
    return config.width, config.height
end

local function GetPlayerActor(frame)
    local modelScene = frame and frame.ModelScene
    return modelScene and modelScene.GetPlayerActor and modelScene:GetPlayerActor() or nil
end

local function ApplyBackground(frame, config)
    local background = frame and frame.ModelBackground
    if not background or type(background.SetVertexColor) ~= "function" then
        return
    end

    if not config.enabled then
        background:SetVertexColor(1, 1, 1)
    elseif config.hideBackground then
        background:SetVertexColor(0, 0, 0)
    elseif config.dimBackground then
        background:SetVertexColor(0.52, 0.52, 0.52)
    else
        background:SetVertexColor(1, 1, 1)
    end
end

local function ApplyHiddenSlots(frame, config)
    if not config.enabled then
        return
    end

    local actor = GetPlayerActor(frame)
    if not actor then
        return
    end

    if config.startUndressed and type(actor.Undress) == "function" then
        actor:Undress()
        return
    end

    if type(actor.UndressSlot) ~= "function" then
        return
    end

    if config.hideWeapons then
        actor:UndressSlot(INVSLOT_MAINHAND)
        actor:UndressSlot(INVSLOT_OFFHAND)
    end
    if config.hideShirt then
        actor:UndressSlot(INVSLOT_BODY)
    end
    if config.hideTabard then
        actor:UndressSlot(INVSLOT_TABARD)
    end
end

function addon:ApplyDressingRoomSettings(applyHiddenSlots)
    local config = self.db and self.db.dressingRoom
    local frame = _G.DressUpFrame
    if not config or not frame or applyingSettings then
        return
    end

    local width, height
    if config.enabled and config.customSize then
        width, height = ClampConfiguredSize()
    else
        width, height = DEFAULT_WIDTH, DEFAULT_HEIGHT
    end

    applyingSettings = true
    ApplyBackground(frame, config)
    if frame:GetWidth() ~= width or frame:GetHeight() ~= height then
        frame:SetSize(width, height)
        if frame:IsShown() and type(UpdateUIPanelPositions) == "function" then
            UpdateUIPanelPositions(frame)
        end
    end
    applyingSettings = false

    if applyHiddenSlots then
        ApplyHiddenSlots(frame, config)
    end
end

function addon:ApplyDressingRoomSize()
    self:ApplyDressingRoomSettings(false)
end

local function QueueSettingsUpdate(applyHiddenSlots)
    C_Timer.After(0, function()
        addon:ApplyDressingRoomSettings(applyHiddenSlots)
    end)

    if applyHiddenSlots then
        C_Timer.After(0.05, function()
            addon:ApplyDressingRoomSettings(true)
        end)
    end
end

local function HookNativeDressingRoom()
    if dressUpHooked or not _G.DressUpFrame then
        return
    end

    dressUpHooked = true
    DressUpFrame:HookScript("OnShow", function()
        QueueSettingsUpdate(true)
    end)

    if DressUpFrame.MaximizeMinimizeFrame then
        local control = DressUpFrame.MaximizeMinimizeFrame
        if type(control.Maximize) == "function" then
            hooksecurefunc(control, "Maximize", function()
                QueueSettingsUpdate(false)
            end)
        end
    end

    if type(_G.DressUpFrame_Show) == "function" then
        hooksecurefunc("DressUpFrame_Show", function()
            QueueSettingsUpdate(true)
        end)
    end

    QueueSettingsUpdate(DressUpFrame:IsShown())
end

local function Initialize()
    if C_AddOns.IsAddOnLoaded("Blizzard_UIPanels_Game") then
        HookNativeDressingRoom()
    end

    local loader = CreateFrame("Frame")
    loader:RegisterEvent("ADDON_LOADED")
    loader:SetScript("OnEvent", function(self, _, loadedAddon)
        if loadedAddon == "Blizzard_UIPanels_Game" then
            HookNativeDressingRoom()
            self:UnregisterEvent("ADDON_LOADED")
        end
    end)
end

addon:RegisterCallback("DATABASE_READY", Initialize)
addon:RegisterCallback("OPTIONS_CHANGED", function(callbackKey)
    if callbackKey == "dressingRoom" then
        QueueSettingsUpdate(_G.DressUpFrame and _G.DressUpFrame:IsShown())
    end
end)
