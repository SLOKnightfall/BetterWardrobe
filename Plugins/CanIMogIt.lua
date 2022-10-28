
--Pulled from CanIMogIt Overlay Sets.lua
local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

function addon:UpdateCanIMogIt() 
end

if not IsAddOnLoaded("CanIMogIt") then return end
local addonName, addon = ...
--addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
addon.Frame = LibStub("AceGUI-3.0")

local function CIMI_AddToFrameSets(parentFrame)
    -- Create the Texture and set OnUpdate
    if parentFrame and not parentFrame.CanIMogItOverlay then
        local frame = CreateFrame("Frame", "CIMIOverlayFrame_"..tostring(parentFrame:GetName()), parentFrame)
        parentFrame.CanIMogItOverlay = frame
        -- Get the frame to match the shape/size of its parent
        frame:SetAllPoints()

        -- Create the font frame.
        frame.CanIMogItSetText = frame:CreateFontString("CIMIOverlayFrame_"..tostring(parentFrame:GetName()), "OVERLAY", "GameFontNormalSmall")
        frame.CanIMogItSetText:SetPoint("BOTTOMRIGHT", -2, 2)

        function frame:UpdateText()
            if CanIMogItOptions["showSetInfo"] then
                if not parentFrame.setID then frame.CanIMogItSetText:SetText(""); return end
            	local have, total = addon.GetSetSourceCounts(parentFrame.setID)
   				local ratioText = CanIMogIt:_GetRatioTextColor(have, total)
    			ratioText = ratioText ..  have .. "/" .. total
                frame.CanIMogItSetText:SetShown(BetterWardrobeCollectionFrame.selectedCollectionTab == 2 or BetterWardrobeCollectionFrame.selectedCollectionTab == 3)
    			if BetterWardrobeCollectionFrame.selectedCollectionTab == 2  then
                    frame.CanIMogItSetText:SetText(CanIMogIt:GetSetsVariantText(parentFrame.setID) or "")

                else
                  frame.CanIMogItSetText:SetText(ratioText or "")
                end
            else
                frame.CanIMogItSetText:SetText("")
            end
        end
    end
end


local function WardrobeCollectionFrame_CIMIOnValueChanged()
    -- For each button, update the text value
    for i=1,CanIMogIt.NUM_WARDROBE_COLLECTION_BUTTONS do
        local frame = _G["BetterWardrobeCollectionFrameScrollFrameButton"..i]
        if frame and frame.CanIMogItOverlay and frame.setID then
            frame.CanIMogItOverlay:UpdateText()
        end
    end
end


function addon:UpdateCanIMogIt()
    for i=1,CanIMogIt.NUM_WARDROBE_COLLECTION_BUTTONS do
        local frame = _G["BetterWardrobeCollectionFrameScrollFrameButton"..i]
        if frame then
            CIMI_AddToFrameSets(frame)
        end
    end
      -- When the scrollbar moves, update the display.
   --- _G["BetterWardrobeCollectionFrameScrollFrameScrollBar"]:HookScript("Update", WardrobeCollectionFrame_CIMIOnValueChanged)
    addon:SecureHook(WardrobeCollectionFrame.SetsCollectionFrame,"Refresh", function() C_Timer.After(.05,WardrobeCollectionFrame_CIMIOnValueChanged) end)

    _G["BetterWardrobeCollectionFrameTab2"]:HookScript("OnClick", WardrobeCollectionFrame_CIMIOnValueChanged)
    _G["BetterWardrobeCollectionFrameTab3"]:HookScript("OnClick", WardrobeCollectionFrame_CIMIOnValueChanged)

    CanIMogIt:RegisterMessage("OptionUpdate", function () C_Timer.After(.05, WardrobeCollectionFrame_CIMIOnValueChanged) end)

	addon.frame:SetScript("OnEvent",  function (self, event, addonName)
	    if event == "TRANSMOG_SEARCH_UPDATED" then
        	-- Must add a delay, as the frame updates after this is called.
       	 	C_Timer.After(.05, WardrobeCollectionFrame_CIMIOnValueChanged)
    	end
	end)
end