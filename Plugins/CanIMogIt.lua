
--Pulled from CanIMogIt Overlay Sets.lua
local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

function addon:UpdateCanIMogIt() 
end

if not C_AddOns.IsAddOnLoaded("CanIMogIt") then return end
local addonName, addon = ...
--addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
addon.Frame = LibStub("AceGUI-3.0")


local version = C_AddOns.GetAddOnMetadata("CanIMogIt", "Version")
 

local function UpdateText(parentFrame)
	local frame = parentFrame.CanIMogItOverlay
	if not frame then return end
	if CanIMogItOptions["showSetInfo"] then
		if not parentFrame.setID then frame.CanIMogItSetText:SetText(""); return end
		local have, total = addon.SetsDataProvider:GetSetSourceCounts(parentFrame.setID)
		local ratioText 
		if version == "10.1.5v1.53" then 
			ratioText = CanIMogIt:_GetRatioTextColor(have, total)
		else
			ratioText = CanIMogIt.GetRatioTextColor(have, total)
		end
		ratioText = ratioText ..  have .. "/" .. total

		if BetterWardrobeCollectionFrame.selectedCollectionTab == 2  then
			frame.CanIMogItSetText:SetText(CanIMogIt:GetSetsVariantText(parentFrame.setID) or "")

		elseif BetterWardrobeCollectionFrame.selectedCollectionTab == 3  then
		  frame.CanIMogItSetText:SetText(ratioText or "")

		else
		  	frame.CanIMogItSetText:SetText("")
		end
	else
		frame.CanIMogItSetText:SetText("")
	end
end

local function WardrobeCollectionFrame_CIMIOnValueChanged(_, elapsed)
	-- For each button, update the text value
	if _G["BetterWardrobeCollectionFrame"] == nil then return end
	if not CanIMogIt.FrameShouldUpdate("WardrobeSets", elapsed or 1) then return end
	local wardrobeSetsScrollFrame = _G["BetterWardrobeCollectionFrame"].SetsCollectionFrame.ListContainer.ScrollBox
	local setFrames = wardrobeSetsScrollFrame:GetFrames()
	for i = 1, #setFrames do
		local frame = setFrames[i]
		if frame then
			-- add to frame
			CIMI_AddToFrameSets(frame)
		end
		if frame and frame.CanIMogItOverlay then
			-- update frame
			UpdateText(frame)
		end
	end
end

function addon:UpdateCanIMogIt()
	  -- When the scrollbar moves, update the display.
	_G["BetterWardrobeCollectionFrame"].SetsCollectionFrame.ListContainer:HookScript("OnUpdate", function() C_Timer.After(.05,WardrobeCollectionFrame_CIMIOnValueChanged) end)
	_G["BetterWardrobeCollectionFrameTab2"]:HookScript("OnClick", function() C_Timer.After(.05,WardrobeCollectionFrame_CIMIOnValueChanged) end)
	_G["BetterWardrobeCollectionFrameTab3"]:HookScript("OnClick", function() C_Timer.After(.05,WardrobeCollectionFrame_CIMIOnValueChanged) end)

	CanIMogIt:RegisterMessage("OptionUpdate", function () C_Timer.After(.05, WardrobeCollectionFrame_CIMIOnValueChanged) end)

	addon.frame:SetScript("OnEvent",  function (self, event, addonName)
		if event == "TRANSMOG_SEARCH_UPDATED" then
			-- Must add a delay, as the frame updates after this is called.
			C_Timer.After(.05, WardrobeCollectionFrame_CIMIOnValueChanged)
		end
	end)
end