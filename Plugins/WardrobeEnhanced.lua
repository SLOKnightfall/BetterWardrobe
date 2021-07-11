local addonName, addon = ...
--addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)




function addon.Init:UpdateWardrobeEnhanced()
end

if not IsAddOnLoaded("LegionWardrobe") then return end

local setsButton_tooltip = "Sets"
local resetFilterButton_tooltip = "Reset filter"
local colorSelectButton_tooltip = "Select color"
local bigModelButton_tooltip = "Open Big Model"
local optionsButton_tooltip = "Options"

local filteredRecolors
local WE_Frames = {}
local BE_Frames = {}

local WE_HideFrames = {}
local old_FilterVisuals

	
local function FilterVisuals(self)
	if FilterInstance or filteredRecolors or FilterColor then
		WE_Frames.ResetButton:Show()
	else
		WE_Frames.ResetButton:Hide()
	end


	if not WardrobeFrame_IsAtTransmogrifier() and BetterWardrobeCollectionFrame.ItemsCollectionFrame.activeCategory and filteredRecolors then
		local filteredVisualsList = { }
		local tmp = {}
		for q,w in pairs(filteredRecolors) do tmp[w] = true end
		
		local visualsList = BetterWardrobeCollectionFrame.ItemsCollectionFrame.visualsList
		if BetterWardrobeCollectionFrame.ItemsCollectionFrame.transmogLocation:IsOffHand() then
			for categoryID=1,100 do
				local name, isWeapon, canEnchant, canMainHand, canOffHand = C_TransmogCollection.GetCategoryInfo(categoryID)
				if canMainHand then
					local toAdd = C_TransmogCollection.GetCategoryAppearances(categoryID, 1)
					if toAdd then
						for i=1,#toAdd do 
							visualsList[#visualsList+1] = toAdd[i]
						end
					end
				end
			end
		elseif BetterWardrobeCollectionFrame.ItemsCollectionFrame.transmogLocation:IsMainHand() then
			for categoryID=1,100 do
				local name, isWeapon, canEnchant, canMainHand, canOffHand = C_TransmogCollection.GetCategoryInfo(categoryID)
				if canOffHand then
					local toAdd = C_TransmogCollection.GetCategoryAppearances(categoryID, 2)
					if toAdd then
						for i=1,#toAdd do 
							visualsList[#visualsList+1] = toAdd[i]
						end
					end
				end
			end
		end
		for i = 1, #visualsList do
			if tmp[ visualsList[i].visualID ] then
				tinsert(filteredVisualsList, visualsList[i])
				tmp[ visualsList[i].visualID ] = nil
			end
		end

		BetterWardrobeCollectionFrame.ItemsCollectionFrame.filteredVisualsList = filteredVisualsList
		return
	end

	local isAtTransmogrifier = C_Transmog.IsAtTransmogNPC();
	local visualsList = self.visualsList;

	local filteredVisualsList = { };
	local slotID = self.transmogLocation.slotID;
	for i, visualInfo in ipairs(visualsList) do
		local skip = false;
		if visualInfo.restrictedSlotID then
			skip = (slotID ~= visualInfo.restrictedSlotID);
		end
		if not skip then
			if isAtTransmogrifier then
				if (visualInfo.isUsable and visualInfo.isCollected) or visualInfo.alwaysShowItem then
					table.insert(filteredVisualsList, visualInfo);
				end
			else
				if not visualInfo.isHideVisual then
					table.insert(filteredVisualsList, visualInfo);
				end
			end
		end
	end
	self.filteredVisualsList = filteredVisualsList;
end


local function ReloadCategory()
	local WE = _G.LTA
	if WardrobeCollectionFrame:IsShown() and not BetterWardrobeCollectionFrame.ItemsCollectionFrame:IsShown() then 
		BetterWardrobeCollectionFrame:SetTab(1)

	elseif not WardrobeCollectionFrame:IsShown() then 
		return
	end
	WE.IsReset = true
	addon.FilteringRecolors = BetterWardrobeCollectionFrame.ItemsCollectionFrame.activeCategory

	local transmogLocation = BetterWardrobeCollectionFrame.ItemsCollectionFrame.transmogLocation
	BetterWardrobeCollectionFrame.ItemsCollectionFrame.transmogLocation = nil
	BetterWardrobeCollectionFrame.ItemsCollectionFrame.activeCategory = nil

	BetterWardrobeCollectionFrame.ItemsCollectionFrame:SetActiveSlot(transmogLocation)

	BetterWardrobeCollectionFrame.ItemsCollectionFrame.PagingFrame:SetCurrentPage(1)

	WE.IsReset = false
end




function addon.Init:UpdateWardrobeEnhanced()
	wipe(WE_HideFrames)
	local f=CreateFrame("Frame",nil,UIParent)
	f:ClearAllPoints()
	f:SetPoint("TOPRIGHT",100, 100)
	f:SetSize(1,1)
	f:Hide()
	local completed = 0

	local function ButtonOnEnter(self)
		if not self.tooltip then return end
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:AddLine(self.tooltip)
			GameTooltip:Show()
		end

	local function ButtonOnLeave(self)
		GameTooltip_Hide()
	end


	local kids = { WardrobeCollectionFrame:GetChildren() };
	local isAtTransmogrifier = C_Transmog.IsAtTransmogNPC();
	local size = 25

	for _, child in ipairs(kids) do
		local child_x, child_y = child:GetSize()
		if child.tooltip ==  resetFilterButton_tooltip then
			WE_Frames.ResetButton = child
			WE_Frames.ResetButton:SetSize(size, size)

			--WE_Frames.ResetButton:SetParent(f)
			completed = completed + 1

		elseif child.tooltip ==  colorSelectButton_tooltip then
			WE_Frames.ColorButton = child
			WE_Frames.ColorButton:SetSize(20, 20)
			local onClick =  WE_Frames.ColorButton:GetScript("OnClick")
			local onEnter = WE_Frames.ColorButton:GetScript("OnEnter")
			local onLeave = WE_Frames.ColorButton:GetScript("OnLeave")
			WE_Frames.ColorButton:SetParent(f)

			local colorSelectButton = CreateFrame("Button", nil, WardrobeCollectionFrame)

			colorSelectButton:SetSize(20, 20)
			colorSelectButton:SetScript("OnClick",onClick)
			colorSelectButton:SetScript("OnEnter",onEnter)
			colorSelectButton:SetScript("OnLeave",onLeave)
			colorSelectButton:SetScript("OnShow",function()
					colorSelectButton:ClearAllPoints()

					if WardrobeFrame_IsAtTransmogrifier() then
						for _,but in pairs(WE_HideFrames) do
							but:Hide()
						end
						colorSelectButton:SetPoint("TOPRIGHT", BW_SortDropDown, -15, 23)
					else
						for _,but in pairs(WE_HideFrames) do
							but:Show()
						end
						colorSelectButton:SetPoint("RIGHT", WE_Frames.OptionsButton, "LEFT", -7, 0)
					end
					
				end)
			colorSelectButton.tooltip = "Select color"
			
			colorSelectButton.Texture = colorSelectButton:CreateTexture(nil,"ARTWORK")
			colorSelectButton.Texture:SetPoint("CENTER")
			colorSelectButton.Texture:SetSize(22,22)
			colorSelectButton.Texture:SetTexture([[Interface\AddOns\LegionWardrobe\wheeltexture]])

			WE_Frames.ColorButton = colorSelectButton
			tinsert(WE_HideFrames, WE_Frames.ModelsButton)
			completed = completed + 1

		elseif child.tooltip == optionsButton_tooltip then
			WE_Frames.OptionsButton = child
			WE_Frames.OptionsButton:SetSize(20, 20)

			--WE_Frames.OptionsButton:SetParent(f)
			tinsert(WE_HideFrames, WE_Frames.OptionsButton)
			completed = completed + 1


		elseif child.tooltip == bigModelButton_tooltip then
			WE_Frames.ModelsButton = child
			WE_Frames.ModelsButton:SetSize(size, size)

			--WE_Frames.ModelsButton:SetParent(f)
			tinsert(WE_HideFrames, WE_Frames.ModelsButton)
			completed = completed + 1


		elseif child.tooltip ==  setsButton_tooltip then
			WE_Frames.SetsButton = child
			WE_Frames.SetsButton:SetSize(size, size)

			--WE_Frames.SetsButton:SetParent(f)
			tinsert(WE_HideFrames, WE_Frames.SetsButton)
			completed = completed + 1


		elseif math.floor(child_x) == 1 and  math.floor(child_y) == 1 then
			WE_Frames.WatcherFrame = child
			WE_Frames.WatcherFrame:SetParent(f)
			WE_Frames.WatcherFrame:SetScript("OnShow",function(self) 
			end)
		end
	end

	WE_Frames.ResetButton:ClearAllPoints()
	WE_Frames.ResetButton:SetPoint("RIGHT", WE_Frames.ColorButton, "LEFT", -3, 0)
	--WE_Frames.ResetButton:Hide()



	WE_Frames.ColorButton:ClearAllPoints()
	if isAtTransmogrifier then
		WE_Frames.ColorButton:SetPoint("TOPRIGHT", WardrobeCollectionFrameWeaponDropDown, -190, -3)
	else  
		WE_Frames.ColorButton:SetPoint("RIGHT", WE_Frames.OptionsButton, "LEFT", -7, 0)
	end
	--WE_Frames.ColorButton:SetPoint("RIGHT", WE_Frames.OptionsButton, "LEFT", -7, 0)
	--WE_Frames.ColorButton:SetScript("OnShow", function()  end)
	--WE_Frames.ColorButton:Hide()

	WE_Frames.OptionsButton:ClearAllPoints()
	WE_Frames.OptionsButton:SetPoint("RIGHT", WE_Frames.ModelsButton, "LEFT", -3, 0)
	--WE_Frames.OptionsButton:Hide()

	WE_Frames.ModelsButton:ClearAllPoints()
	WE_Frames.ModelsButton:SetPoint("RIGHT", WE_Frames.SetsButton, "LEFT", 0, 0)
	--WE_Frames.ModelsButton:Hide()

	WE_Frames.SetsButton:ClearAllPoints()
	WE_Frames.SetsButton:SetPoint("TOPRIGHT", WardrobeCollectionFrameWeaponDropDown, -15, 23)
	--WE_Frames.SetsButton:Hide()


	BetterWardrobeCollectionFrameTab1:HookScript("OnClick",function(self)
		WE_Frames.ColorButton:Show() 
	end)
	BetterWardrobeCollectionFrameTab2:HookScript("OnClick",function(self)
		WE_Frames.ColorButton:Hide()
		WE_Frames.ResetButton:Hide()
	end)
	BetterWardrobeCollectionFrameTab3:HookScript("OnClick",function(self)
		WE_Frames.ColorButton:Hide()
		WE_Frames.ResetButton:Hide()
	end)
		BetterWardrobeCollectionFrameTab4:HookScript("OnClick",function(self)
		WE_Frames.ColorButton:Hide()
		WE_Frames.ResetButton:Hide()
	end)

if WE_Frames.WatcherFrame then 
		WE_Frames.WatcherFrame:Show()
	end


	if  completed < 5 then
		--print("missed one")
		addon.Init:UpdateWardrobeEnhanced()
		return
	end

LoadAddOn("LegionWardrobeData")

local WE = _G.LTA
local LTS = _G.LTSData
local Recolors = _G.LTSData.Recolors

local FilteringRecolors

if LegionWardrobeSourcesFrame.Recolors then 
	LegionWardrobeSourcesFrame.Recolors:SetScript( "OnClick", function()
		--addon.FilteringRecolors = true
		local self = LegionWardrobeSourcesFrame.Recolors
		local visualID = self:GetParent().modelFrom.visualID
		for i=1,#Recolors do
			local t = Recolors[i]
			for j=1,#t do
				if t[j] == visualID then
					filteredRecolors = t
					--Addon:ReloadCategory()
					ReloadCategory()
					return
				end
			end
		end
		print("<Wardrobe Enhanced>: Can't find any recolors")
	end)
end




old_FilterVisuals = BetterWardrobeCollectionFrame.ItemsCollectionFrame.FilterVisuals
BetterWardrobeCollectionFrame.ItemsCollectionFrame.FilterVisuals = FilterVisuals
--BetterWardrobeCollectionFrame.ItemsCollectionFrame.FilterVisuals
--FilterRecolorVisual()

end