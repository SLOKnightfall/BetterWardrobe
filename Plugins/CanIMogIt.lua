
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

		local variantSets = addon.SetsDataProvider:GetVariantSets(parentFrame.setID) or {}
		local numVariants = #variantSets

		-- GetVariantSets returns {} when there's only one version; fall back to the set itself.
		local ratioSets = variantSets
		if numVariants == 0 then
			ratioSets = { { setID = parentFrame.setID } }
			numVariants = 1
		end

		local grid = {}
		for i, setdata in ipairs(ratioSets) do
			local have, total = addon.SetsDataProvider:GetSetSourceCounts(setdata.setID)
			local colorratioText = CanIMogIt.GetRatioTextColor(have, total)

			-- The row is 1 through 4, then 1 through 4 again.
			local row = i > 4 and i - 4 or i
			-- The column is 1 for <= 4, 2 for > 4.
			local col = i > 4 and 1 or 2
			grid[row] = grid[row] or {}
			grid[row][col] = colorratioText .. have .. "/" .. total
		end

		-- For each variant greater than 4, fold the overflow into the left column.
		local temp = numVariants > 8 and 8 or numVariants
		for i = 1, 4-(8-temp) do
			grid[i+(8-temp)][1] = grid[i][1]
			grid[i][1] = " "
		end

		local variantsTextTotal = ""
		for i = 1, #grid do
			if grid[i][2] then
				variantsTextTotal = variantsTextTotal .. (grid[i][1] or "") .. "  " .. (grid[i][2] or "") .. " \n"
			else
				variantsTextTotal = variantsTextTotal .. (grid[i][1] or "") .. " \n"
			end
		end

		if BetterWardrobeCollectionFrame.selectedCollectionTab == 2 or BetterWardrobeCollectionFrame.selectedCollectionTab == 3 then
			frame.CanIMogItSetText:SetText(variantsTextTotal)
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
	if not CanIMogIt.FrameShouldUpdate("BetterWardrobeCollectionFrame", elapsed or 1) then return end
	local wardrobeSetsScrollFrame = _G["BetterWardrobeCollectionFrame"].SetsCollectionFrame.ListContainer.ScrollBox
	local setFrames = wardrobeSetsScrollFrame:GetFrames()
	for i = 1, #setFrames do
		local frame = setFrames[i]
		if frame then
			CIMI_AddToFrameSets(frame)
		end
		if frame and frame.CanIMogItOverlay then
			UpdateText(frame)
		end
	end
end

function addon:UpdateCanIMogIt()
	  -- When the scrollbar moves, update the display.
	_G["BetterWardrobeCollectionFrame"].SetsCollectionFrame.ListContainer:HookScript("OnUpdate", WardrobeCollectionFrame_CIMIOnValueChanged)
	_G["BetterWardrobeCollectionFrameTab2"]:HookScript("OnClick", function() C_Timer.After(.05,WardrobeCollectionFrame_CIMIOnValueChanged) end)
	_G["BetterWardrobeCollectionFrameTab3"]:HookScript("OnClick", function() C_Timer.After(.05,WardrobeCollectionFrame_CIMIOnValueChanged) end)
--C_Timer.After(.05,WardrobeCollectionFrame_CIMIOnValueChanged)
	CanIMogIt:RegisterMessage("OptionUpdate", function () C_Timer.After(.05, WardrobeCollectionFrame_CIMIOnValueChanged) end)

	addon.frame:RegisterEvent("TRANSMOG_SEARCH_UPDATED")
	addon.frame:HookScript("OnEvent", function (self, event, addonName)
		if event == "TRANSMOG_SEARCH_UPDATED" then
			-- Must add a delay, as the frame updates after this is called.
			C_Timer.After(.05, WardrobeCollectionFrame_CIMIOnValueChanged)
		end
	end)
end