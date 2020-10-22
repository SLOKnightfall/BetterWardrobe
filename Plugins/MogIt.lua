if not IsAddOnLoaded("MogIt") then return end

local addonName, addon = ...
--addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
addon.Frame = LibStub("AceGUI-3.0")

local  mog = _G["MogIt"]

--Hooks into the extra sets scroll frame buttons to allow ctrl-right clicking on the button to generate a mogit preview
local orig_OnMouseUp = BW_WardrobeCollectionFrame.BW_SetsCollectionFrame.ScrollFrame.buttons[1]:GetScript("OnMouseUp")
for i, button in ipairs(BW_WardrobeCollectionFrame.BW_SetsCollectionFrame.ScrollFrame.buttons) do
    button:SetScript("OnMouseUp", function(self, button)
        if IsControlKeyDown() and button == "RightButton" then
            local preview = mog:GetPreview()
            local sources = addon.GetSetsources(self.setID)
            for source in pairs(sources) do
                mog:AddToPreview(select(6, C_TransmogCollection.GetAppearanceSourceInfo(source)), preview)
            end
            return
        end
        orig_OnMouseUp(self, button)
    end)
end