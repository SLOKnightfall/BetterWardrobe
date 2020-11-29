--	///////////////////////////////////////////////////////////////////////////////////////////
--
--	Better Wardrobe and Collection
--	Author: SLOKnightfall

--	Wardrobe and Collection: Adds additional functionality and sets to the transmog and collection areas
--

--

--	///////////////////////////////////////////////////////////////////////////////////////////

local addonName, addon = ...
---addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
--_G[addonName] = {}
addon.Frame = LibStub("AceGUI-3.0")
addon.itemSourceID = {}
addon.QueueList = {}
addon.validSetCache = {}
addon.usableSourceCache = {}
addon.Init = {}
local newTransmogInfo  = {["latestSource"] = NO_TRANSMOG_SOURCE_ID} --{[99999999] = {[58138] = 10}, }
addon.TRANSMOG_SET_FILTER = {}
_G[addonName] = {}

local playerInv_DB
local Profile
local playerNme
local realmName
local playerClass, classID,_

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local BASE_SET_BUTTON_HEIGHT = addon.Globals.BASE_SET_BUTTON_HEIGHT
local VARIANT_SET_BUTTON_HEIGHT = addon.Globals.VARIANT_SET_BUTTON_HEIGHT
local SET_PROGRESS_BAR_MAX_WIDTH = addon.Globals.SET_PROGRESS_BAR_MAX_WIDTH
local IN_PROGRESS_FONT_COLOR =addon.Globals.IN_PROGRESS_FONT_COLOR
local IN_PROGRESS_FONT_COLOR_CODE = addon.Globals.IN_PROGRESS_FONT_COLOR_CODE
local COLLECTION_LIST_WIDTH = addon.Globals.COLLECTION_LIST_WIDTH

--


function addon:SetActiveSlot()
	if BW_WardrobeCollectionFrame.activeFrame ~= WardrobeCollectionFrame.ItemsCollectionFrame then
		BW_WardrobeCollectionFrame_SetTab(1)
		--PanelTemplates_ResizeTabsToFit(WardrobeCollectionFrame, TABS_MAX_WIDTH)
	end
end


function addon:UpdateItems(self)
	for i = 1, self.PAGE_SIZE do
		local model = self.Models[i]
		local setID = (model.visualInfo and model.visualInfo.visualID) or model.setID
		local isHidden = addon.HiddenAppearanceDB.profile.item[setID]
		model.CollectionListVisual.Hidden.Icon:SetShown(isHidden)
		local isInList = addon.CollectionList:IsInList(setID, "item")
		model.CollectionListVisual.Collection.Collection_Icon:SetShown(isInList)
		model.CollectionListVisual.Collection.Collected_Icon:SetShown(isInList and model.visualInfo and model.visualInfo.isCollected)
	end
	if 	#addon.GetBaseList() == 0 then 
		addon.Init:BuildDB()
	end
end


function addon.GetItemSource(itemID, itemMod)
	if addon.ArmorSetModCache[itemID] and addon.ArmorSetModCache[itemID][itemMod] then return addon.ArmorSetModCache[itemID][itemMod][1], addon.ArmorSetModCache[itemID][itemMod][2] end
		local itemSource
		local visualID, sourceID
		local f =  addon.frame
 		if itemMod then
			visualID, sourceID = C_TransmogCollection.GetItemInfo(itemID, itemMod)
		else
			visualID, sourceID = C_TransmogCollection.GetItemInfo(itemID)
		end

		if not sourceID then
			local itemlink = "item:"..itemID..":0"
			f.model:Show()
			f.model:Undress()
			f.model:TryOn(itemlink)
			for i = 1, 19 do
				local source = f.model:GetSlotTransmogSources(i)
				if source ~= 0 then
					--addon.itemSourceID[itemID] = source
					sourceID = source
					break
				end
			end
		end

		if not sourceID then 
			visualID, sourceID = C_TransmogCollection.GetItemInfo(itemID, 0)
		end

	--[[		if sourceID and itemMod then
						addon.modArmor[itemID] = addon.modArmor[itemID] or {}
						addon.modArmor[itemID][itemMod] = sourceID
					end]]
		if sourceID and itemMod then 
			addon.ArmorSetModCache[itemID] = addon.ArmorSetModCache[itemID]  or {}
			addon.ArmorSetModCache[itemID][itemMod] = {visualID, sourceID}
		end

		f.model:Hide()
	return visualID ,sourceID
end

--l--ocal SourceDB = {}
function addon.GetSetsources(setID)
	--if SourceDB[setID] then return SourceDB[setID] end

	local setInfo = addon.GetSetInfo(setID)
	local setSources = {}
	local atTransmogrifier = WardrobeFrame_IsAtTransmogrifier()
	local unavailable = false

	if BW_WardrobeCollectionFrame.selectedTransmogTab == 4 or BW_WardrobeCollectionFrame.selectedCollectionTab == 4 then
		if setInfo and setInfo.sources then
			for i, sourceID in ipairs(setInfo.sources) do	

				if sourceID then
					local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)

					local sources = sourceInfo and C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)
					if sources then
						if #sources > 1 then
							WardrobeCollectionFrame_SortSources(sources)
						end

						setSources[sourceID] = sources[1].isCollected--and sourceInfo.isCollected
					else
						setSources[sourceID] = false
					end
				end
			end
		end

	elseif setInfo and setInfo.sources then
				for itemID, visualID in pairs(setInfo.sources) do
					local sources =  C_TransmogCollection.GetAppearanceSources(visualID)
					local sourceID, _
		
					if not sources then 
						_, sourceID = addon.GetItemSource(itemID, setInfo.mod)
		
						-- Try to generate a source when the item has a
						if not sourceID then
							for i = 0, 4 , 1 do
								_, sourceID = addon.GetItemSource(itemID, i)
		
								if sourceID then 
									break
								end
							end
						end
		
						local sourceInfo = sourceID and C_TransmogCollection.GetSourceInfo(sourceID)

						if (sourceInfo and not sourceInfo.sourceType) and not setInfo.sourceType then 
							unavailable = true
						end
						sources = sourceInfo and C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)
					end
		
					if sources then
						--items[sources.itemID] = true
						if #sources > 1 then
							WardrobeCollectionFrame_SortSources(sources)
						end
						setSources[sources[1].sourceID] = sources[1].isCollected--and sourceInfo.isCollected

					elseif sourceID then 
						setSources[sourceID] = false
					end
				end
	elseif setInfo and setInfo.items then
		for i, itemID in ipairs(setInfo.items) do
			local visualID, sourceID = addon.GetItemSource(itemID, setInfo.mod or 0) --C_TransmogCollection.GetItemInfo(itemID)
			-- visualID, sourceID = addon.GetItemSource(itemID,setInfo.mod)
			--local sources = C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)

			if not visualID then
				for i = 0, 4 , 1 do
					visualID, sourceID = addon.GetItemSource(itemID, i)
		
					if visualID then 
						break
					end
				end
			end

			if 	visualID then 

				local allSources = C_TransmogCollection.GetAllAppearanceSources(visualID)
				local list = {}
				for _, sourceID in ipairs(allSources) do
	
					local info = C_TransmogCollection.GetSourceInfo(sourceID)
					if (info and not info.sourceType) and not setInfo.sourceType then 
						unavailable = true
					end

					local isCollected = select(5,C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
					info.isCollected = isCollected
					tinsert(list, info)
				end

				if #list > 1 then
					WardrobeCollectionFrame_SortSources(list)
				end
				setSources[list[1].sourceID or sourceID ] = list[1].isCollected or false
				if not list[1].sourceType and not setInfo.sourceType then 
					unavailable = true
				end





		--[[	if sourceID then
								local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
				
								local sources = sourceInfo and C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)
								if sources then
									if #sources > 1 then
										WardrobeCollectionFrame_SortSources(sources)
									end
				
									setSources[sourceID] = sources[1].isCollected--and sourceInfo.isCollected
				
								else
									setSources[sourceID] = false
								end]]
			end
		end
	end
			--setSources[sourceID] = sourceInfo and sourceInfo.isCollected
	--SourceDB[setID] = setSources
	return setSources, unavailable
end

local EmptyArmor = addon.Globals.EmptyArmor

local Sets = {}
addon.Sets = Sets

function Sets:GetEmptySlots()
	local setInfo = {}

	for i,x in pairs(EmptyArmor) do
	 	setInfo[i]=x
	end

	return setInfo
end


function Sets:EmptySlots(transmogSources)
	local EmptySet = self:GetEmptySlots()

	for i, x in pairs(transmogSources) do
			EmptySet[i] = nil
	end

	return EmptySet
end


function Sets:ClearHidden(setList, type)
	if addon.Profile.ShowHidden then return setList end
	local newSet = {}
	for i, setInfo in ipairs(setList) do
		local itemID = setInfo.setID or setInfo.visualID

		if not addon.HiddenAppearanceDB.profile[type][itemID] then
			tinsert(newSet, setInfo)
		else
			--print("setInfo.name")
		end
	end
	return newSet
end


function Sets.isMogKnown(sourceID)
	local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
	
	if not sourceInfo then return false end
	local allSources = C_TransmogCollection.GetAllAppearanceSources(sourceInfo.visualID)

	local list = {}
		for _, source_ID in ipairs(allSources) do
		
			local info = C_TransmogCollection.GetSourceInfo(source_ID)
			local isCollected = select(5,C_TransmogCollection.GetAppearanceSourceInfo(source_ID))
			info.isCollected = isCollected
			tinsert(list, info)
		end

		if #list > 1 then
			WardrobeCollectionFrame_SortSources(list)
		end
	
		return  (list[1] and list[1].isCollected and list[1].sourceID) or false
end



	--[[local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
			
			if not sourceInfo then return false end
			
			local slotSources = C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)
		
			local slotColected
			--local slotSources = C_TransmogSets.GetSourcesForSlot(setID, slot)
			if slotSources then
				WardrobeCollectionFrame_SortSources(slotSources, sourceInfo.visualID)
				for i,d in ipairs(slotSources) do
					if d.isCollected then slotColected = d.sourceID end
				end
			end
		
			return slotColected
		end]]


--
local SetsDataProvider = CreateFromMixins(WardrobeSetsDataProviderMixin)
addon.ExtraSetsDataProvider = SetsDataProvider

function SetsDataProvider:SortSets(sets, reverseUIOrder, ignorePatchID)
	addon.SortSet(sets, reverseUIOrder, ignorePatchID)
	--addon.Sort["DefaultSortSet"](self, sets, reverseUIOrder, ignorePatchID)
end


function SetsDataProvider:ClearSets()
	self.baseSets = nil
	self.baseSetsData = nil
	self.variantSets = nil
	self.usableSets = nil
	self.sourceData = nil
	self.savedSetCache = nil
	addon.DefaultUI:ClearSets()
end


local function CheckMissingLocation(setInfo)
--function addon.Sets:GetLocationBasedCount(setInfo)
	local filtered = false
	for type, value in pairs(addon.missingSelection) do
		if value then
			filtered = true
			break
		end
	end
	--no need to filter if nothing is selected
	if not filtered then return true end
	
	local invType = {}
	if not setInfo.items then
		local sources = C_TransmogSets.GetSetSources(setInfo.setID)
		for sourceID in pairs(sources) do
			local isCollected = Sets.isMogKnown(sourceID) 
			if addon.missingSelection[sourceInfo.invType] and not isCollected then		
				return true
			elseif addon.missingSelection[sourceInfo.invType] then 
				filtered = true
			end
		end
	else
		for sourceID, isCollected in pairs(setInfo.setSources) do
			local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
			if addon.missingSelection[sourceInfo.invType] and not isCollected then
				return true
			elseif addon.missingSelection[sourceInfo.invType] then 
				filtered = true 
			end
		end
	end

	for type, value in pairs(addon.missingSelection) do
		if value and invType[type] then
			filtered = true
		end
	end

	return not filtered
end


local setsByExpansion = {}
local setsByFilter = {}
function SetsDataProvider:FilterSearch(useBaseSet)
	local baseSets
	local filteredSets = {}
	local searchString

	if useBaseSet then
		baseSets = SetsDataProvider:GetBaseSets()
		self.baseSets = filteredSets
	else
		baseSets = SetsDataProvider:GetUsableSets()
		self.usableSets = filteredSets
		self.baseSets = baseSets
	end

	if 	BW_WardrobeCollectionFrame.selectedTransmogTab == 4 or BW_WardrobeCollectionFrame.selectedCollectionTab == 4 then
		self.baseSets = baseSets
		return
	elseif BW_WardrobeCollectionFrame.selectedCollectionTab == 3 then
		searchString = string.lower(BW_WardrobeCollectionFrameSearchBox:GetText())
	else
		searchString = string.lower(WardrobeCollectionFrameSearchBox:GetText())
	end

	for i, data in ipairs(baseSets) do
		local setData = SetsDataProvider:GetSetSourceData(data.setID)
		local count , total = setData.numCollected, setData.numTotal
		local unavailable = setData.unavailable
		local collected = count == total
		if ((addon.filterCollected[1] and collected) or
			(addon.filterCollected[2] and not collected)) and
			CheckMissingLocation(data) and
	 		addon.xpacSelection[data.expansionID] and
			addon.filterSelection[data.filter] and
			(not unavailable or (addon.Profile.HideUnavalableSets and unavailable)) and
			(searchString and string.find(string.lower(data.name), searchString)) then -- or string.find(baseSet.label, searchString) or string.find(baseSet.description, searchString)then
			tinsert(filteredSets, data)
	end

	self:SortSets(filteredSets)
	
	--else
		--self.baseSets = baseSets
	end
end


function SetsDataProvider:GetBaseSets(baseSet)
	if (baseSet or not self.baseSets) then
		if (BW_WardrobeCollectionFrame.selectedCollectionTab == 4  or BW_WardrobeCollectionFrame.selectedTransmogTab == 4) then
			self.baseSets = addon.GetSavedList()
			self:SortSets(self.baseSets)
		else
			self.baseSets = Sets:ClearHidden(addon.GetBaseList(), "extraset") --C_TransmogSets.GetBaseSets()
			--self:DetermineFavorites()
			self:SortSets(self.baseSets)
		end
	end

	return self.baseSets
end


function SetsDataProvider:GetSetSourceCounts(setID)
	local sourceData = self:GetSetSourceData(setID)
	return sourceData.numCollected, sourceData.numTotal
end


--Lets CanIMogIt plugin get extra sets count
 function addon.GetSetSourceCounts(setID)
	return SetsDataProvider:GetSetSourceCounts(setID)

end


function addon.Sets:GetLocationBasedCount(setInfo)
	local collectedCount = 0
	local totalCount = 0
	local items = {}

	if not setInfo.items then
		local sources = C_TransmogSets.GetSetSources(setInfo.setID)
		for sourceID in pairs(sources) do
			local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
			local sources = sourceInfo and C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)
			if sources then
				if #sources > 1 then
					WardrobeCollectionFrame_SortSources(sources)
				end
			
				if  addon.includeLocation[sourceInfo.invType] then
					totalCount = totalCount + 1

					if sources[1].isCollected then
						collectedCount = collectedCount + 1
					end
				end
			end
		end

	else
		for i, itemID in ipairs(setInfo.items) do
			local visualID, sourceID = addon.GetItemSource(itemID, setInfo.mod)	
			if sourceID then
				local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
				local sources = sourceInfo and C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)
				if sources then
					if #sources > 1 then
						WardrobeCollectionFrame_SortSources(sources)
					end

					if  addon.includeLocation[sourceInfo.invType] then
						totalCount = totalCount + 1

						if sources[1].isCollected then
							collectedCount = collectedCount + 1
						end
					end
				end
			end
		end
	end
	return collectedCount, totalCount
end
--SetsDataProvider:GetSetSourceCounts(data.setID)

function SetsDataProvider:GetUsableSets(incVariants)
	if (not self.usableSets) then
		local availableSets = SetsDataProvider:GetBaseSets()
		local atTransmogrifier = WardrobeFrame_IsAtTransmogrifier()
		local countData

		--Generates Useable Set
		self.usableSets = {} --SetsDataProvider:GetUsableSets()
		for i, set in ipairs(availableSets) do
			local topSourcesCollected, topSourcesTotal
			if addon.Profile.ShowIncomplete then
				topSourcesCollected, topSourcesTotal = addon.Sets:GetLocationBasedCount(set)
			else
				topSourcesCollected, topSourcesTotal = SetsDataProvider:GetSetSourceCounts(set.setID)
			end


			local cutoffLimit = (addon.Profile.ShowIncomplete and ((topSourcesTotal <= addon.Profile.PartialLimit and topSourcesTotal) or  addon.Profile.PartialLimit)) or topSourcesTotal --SetsDataProvider:GetSetSourceCounts(set.setID)
			if (BW_WardrobeToggle.viewAll and BW_WardrobeToggle.VisualMode) or (not atTransmogrifier and BW_WardrobeToggle.VisualMode) or topSourcesCollected >= cutoffLimit  and topSourcesTotal > 0 then --and not C_TransmogSets.IsSetUsable(set.setID) then
				tinsert(self.usableSets, set)
			end

			if incVariants then
				local variantSets = C_TransmogSets.GetVariantSets(set.setID)
				for i, set in ipairs(variantSets) do
					local topSourcesCollected, topSourcesTotal
					if addon.Profile.ShowIncomplete then
						topSourcesCollected, topSourcesTotal = addon.Sets:GetLocationBasedCount(set)
					else
						topSourcesCollected, topSourcesTotal = SetsDataProvider:GetSetSourceCounts(set.setID)
					end

					if topSourcesCollected == topSourcesTotal then set.collected = true end
					--local cutoffLimit = (topSourcesTotal <= addon.Profile.PartialLimit and topSourcesTotal) or addon.Profile.PartialLimit
					if (BW_WardrobeToggle.viewAll and BW_WardrobeToggle.VisualMode) or (not atTransmogrifier and BW_WardrobeToggle.VisualMode) or topSourcesCollected >= cutoffLimit and topSourcesTotal > 0   then --and not C_TransmogSets.IsSetUsable(set.setID) then
						tinsert(self.usableSets, set)
					end
				end
			end

		end
		self:SortSets(self.usableSets)	
	end

	return self.usableSets
end


function SetsDataProvider:GetSetSourceData(setID)
	if (not self.sourceData) then
		self.sourceData = {}
	end

	local sourceData = self.sourceData[setID]
	if (not sourceData) then
		local sources, unavailable = addon.GetSetsources(setID)
		local numCollected = 0
		local numTotal = 0
		if sources then
			for sourceID, collected in pairs(sources) do
				if (collected) then
					numCollected = numCollected + 1
				end
				numTotal = numTotal + 1
			end

			sourceData = {numCollected = numCollected, numTotal = numTotal, sources = sources, unavailable = unavailable }
			self.sourceData[setID] = sourceData
		end
	end
	return sourceData
end


function addon:SetHasNewSources(setID)
	if newTransmogInfo and newTransmogInfo[setID] then
		return true 
	else
		return false
	end
end


function SetsDataProvider:IsBaseSetNew(baseSetID)
	local baseSetData = self:GetBaseSetData(baseSetID)
	if ( not baseSetData.newStatus ) then
		local newStatus = addon:SetHasNewSources(baseSetID);
		baseSetData.newStatus = newStatus;
	end
	return baseSetData.newStatus;
end


function SetsDataProvider:ResetBaseSetNewStatus(baseSetID)
	local baseSetData = self:GetBaseSetData(baseSetID)
	if ( baseSetData ) then
		--newTransmogInfo[baseSetID] = nil
		baseSetData.newStatus = nil;
	end
end


function SetsDataProvider:GetSortedSetSources(setID)
	local returnTable = {}
	local sourceData = self:GetSetSourceData(setID)

	for sourceID, collected in pairs(sourceData.sources) do
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)

		if (sourceInfo) then
			local sortOrder = EJ_GetInvTypeSortOrder(sourceInfo.invType)
			tinsert(returnTable, {sourceID = sourceID, collected = collected, sortOrder = sortOrder, itemID = sourceInfo.itemID, invType = sourceInfo.invType, visualID = sourceInfo.visualID  })
		end
	end

	local comparison = function(entry1, entry2)
		if (entry1.sortOrder == entry2.sortOrder) then
			return entry1.itemID < entry2.itemID
		else
			return entry1.sortOrder < entry2.sortOrder
		end
	end

	table.sort(returnTable, comparison)
	return returnTable
end


function SetsDataProvider:GetBaseSetData(setID)
	if (not self.baseSetsData) then
		self.baseSetsData = {}
	end

	if (not self.baseSetsData[setID]) then
		local baseSetID = setID
		if (baseSetID ~= setID) then
			return
		end
		local topCollected, topTotal = self:GetSetSourceCounts(setID)
		local setInfo = {topCollected = topCollected, topTotal = topTotal, completed = (topCollected == topTotal) }
		self.baseSetsData[setID] = setInfo
	end

	return self.baseSetsData[setID]
end



--=========--
-- Extra Sets Trannsmog Collection Model
BetterWardrobeSetsTransmogModelMixin = CreateFromMixins(WardrobeSetsTransmogModelMixin)

function BetterWardrobeSetsTransmogModelMixin:LoadSet(setID)
	local waitingOnData = false
	local transmogSources = {}
	local sources = addon.GetSetsources(setID)
	for sourceID in pairs(sources) do
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
		local allSources = C_TransmogCollection.GetAllAppearanceSources(visualID)
		local list = {}
		for _, sourceID in ipairs(allSources) do

			local info = C_TransmogCollection.GetSourceInfo(sourceID)
			local isCollected = select(5,C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
			info.isCollected = isCollected
			tinsert(list, info)
		end

		if #list > 1 then
			WardrobeCollectionFrame_SortSources(list)
		end


		--local slot = C_Transmog.GetSlotForInventoryType(sourceInfo.invType)
		--local slotSources = C_TransmogSets.GetSourcesForSlot(setID, slot)
		--WardrobeCollectionFrame_SortSources(slotSources, sourceInfo.visualID)
		--local index = WardrobeCollectionFrame_GetDefaultSourceIndex(slotSources, sourceID)
		--transmogSources[slot] = (slotSources[index] and slotSources[index].sourceID) or sourceID
		transmogSources[slot] = list[1].sourceID


		for i, slotSourceInfo in ipairs(slotSources) do
			if (not slotSourceInfo.name) then
				waitingOnData = true
			end
		end
	end

	if (waitingOnData) then
		self.loadingSetID = setID
	else
		self.loadingSetID = nil
		-- if we don't ignore the event, clearing will momentarily set the page to the one with the set the user currently has transmogged
		-- if that's a different page from the current one then the models will flicker as we swap the gear to different sets and back
		self.ignoreTransmogrifyUpdateEvent = true
		C_Transmog.ClearAllPending();
		self.ignoreTransmogrifyUpdateEvent = false
		C_Transmog.LoadSources(transmogSources, -1, -1)
	end
end

function BetterWardrobeSetsTransmogModelMixin:RefreshTooltip()
	if BW_WardrobeCollectionFrame.selectedTransmogTab == 4 or BW_WardrobeCollectionFrame.selectedCollectionTab == 4 then
		return
	end

	local totalQuality = 0
	local numTotalSlots = 0
	local waitingOnQuality = false
	local sourceQualityTable = self:GetParent().sourceQualityTable
	local sources = addon.GetSetsources(self.setID)
	for sourceID in pairs(sources) do
		numTotalSlots = numTotalSlots + 1
		if (sourceQualityTable[sourceID]) then
			totalQuality = totalQuality + sourceQualityTable[sourceID]
		else
			local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
			if (sourceInfo and sourceInfo.quality) then
				sourceQualityTable[sourceID] = sourceInfo.quality
				totalQuality = totalQuality + sourceInfo.quality
			else
				waitingOnQuality = true
			end
		end
	end

	if (waitingOnQuality) then
		GameTooltip:SetText(RETRIEVING_ITEM_INFO, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		local setQuality = (numTotalSlots > 0 and totalQuality > 0) and Round(totalQuality / numTotalSlots) or Enum.ItemQuality.Common
		local color = ITEM_QUALITY_COLORS[setQuality]
		local setInfo = addon.GetSetInfo(self.setID)
		GameTooltip:SetText(setInfo.name, color.r, color.g, color.b)
		if (setInfo.label) then
			GameTooltip:AddLine(setInfo.label)
			GameTooltip:Show()
		end
		if not setInfo.isClass then
			GameTooltip:AddLine(setInfo.className)
			GameTooltip:Show()
		end

	end
end


function BetterWardrobeSetsTransmogModelMixin:OnMouseDown(button)
	if ( button == "LeftButton" ) then
		self:GetParent():SelectSet(self.setID);
		PlaySound(SOUNDKIT.UI_TRANSMOG_ITEM_CLICK);
	elseif ( button == "RightButton" ) then
		local dropDown = self:GetParent().RightClickDropDown;
		if ( dropDown.activeFrame ~= self ) then
			BW_CloseDropDownMenus();
		end
		dropDown.activeFrame = self;
		BW_ToggleDropDownMenu(1, nil, dropDown, self, -6, -3);
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
	end
end

--==

--=======--
-- Extra Sets Collection List
BetterWardrobeSetsCollectionMixin = CreateFromMixins(WardrobeSetsCollectionMixin)

function BetterWardrobeSetsCollectionMixin:OnLoad()
	self.RightInset.BGCornerTopLeft:Hide()
	self.RightInset.BGCornerTopRight:Hide()

	self.DetailsFrame.Name:SetFontObjectsToTry(Fancy24Font, Fancy20Font, Fancy16Font)
	self.DetailsFrame.itemFramesPool = CreateFramePool("FRAME", self.DetailsFrame, "BW_WardrobeSetsDetailsItemFrameTemplate")

	self.selectedVariantSets = {}


end




function addon:BW_TRANSMOG_COLLECTION_UPDATED()
		SetsDataProvider:ClearSets()
		BW_SetsCollectionFrameScrollFrame:Refresh()
		BW_SetsCollectionFrameScrollFrame:UpdateProgressBar()
		BW_SetsCollectionFrameScrollFrame:ClearLatestSource()
end

function BetterWardrobeSetsCollectionMixin:OnShow()
	self:RegisterEvent("GET_ITEM_INFO_RECEIVED")
	self:RegisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE")
	--self:RegisterEvent("TRANSMOG_COLLECTION_UPDATED")
	addon:RegisterMessage("BW_TRANSMOG_COLLECTION_UPDATED")
	-- select the first set if not init

	local baseSets = SetsDataProvider:GetBaseSets()
	if (not self.init) then
		self.init = true
		if (baseSets and baseSets[1]) then
			--self:SelectSet(self:GetDefaultSetIDForBaseSet(baseSets[1].setID))
			self:SelectSet(baseSets[1].setID)
		end
	else
		self:Refresh()
	end

	local latestSource = newTransmogInfo["latestSource"]

	if (latestSource ~= NO_TRANSMOG_SOURCE_ID) then
		self:SelectSet(latestSource)
		self:ScrollToSet(latestSource)
		self:ClearLatestSource()
	end

	WardrobeCollectionFrame.progressBar:Show()
	self:UpdateProgressBar()
	self:RefreshCameras()

	--if (self:GetParent().SetsTabHelpBox:IsShown()) then
		--self:GetParent().SetsTabHelpBox:Hide()
		--SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_TRANSMOG_SETS_TAB, true)
	--end
end


function BetterWardrobeSetsCollectionMixin:OnHide()
	self:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
	self:UnregisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE")
	--self:UnregisterEvent("TRANSMOG_COLLECTION_UPDATED")
	addon:UnregisterMessage("BW_TRANSMOG_COLLECTION_UPDATED")

	SetsDataProvider:ClearSets()
	WardrobeCollectionFrame_ClearSearch(LE_TRANSMOG_SEARCH_TYPE_BASE_SETS)

end


local inventoryTypes = {
	["INVTYPE_AMMO"] = INVSLOT_AMMO;
	["INVTYPE_HEAD"] = INVSLOT_HEAD;
	["INVTYPE_NECK"] = INVSLOT_NECK;
	["INVTYPE_SHOULDER"] = INVSLOT_SHOULDER;
	["INVTYPE_BODY"] = INVSLOT_BODY;
	["INVTYPE_CHEST"] = INVSLOT_CHEST;
	["INVTYPE_ROBE"] = INVSLOT_CHEST;
	["INVTYPE_WAIST"] = INVSLOT_WAIST;
	["INVTYPE_LEGS"] = INVSLOT_LEGS;
	["INVTYPE_FEET"] = INVSLOT_FEET;
	["INVTYPE_WRIST"] = INVSLOT_WRIST;
	["INVTYPE_HAND"] = INVSLOT_HAND;
	["INVTYPE_FINGER"] = INVSLOT_FINGER1;
	["INVTYPE_TRINKET"] = INVSLOT_TRINKET1;
	["INVTYPE_CLOAK"] = INVSLOT_BACK;
	["INVTYPE_WEAPON"] = INVSLOT_MAINHAND;
	["INVTYPE_SHIELD"] = INVSLOT_OFFHAND;
	["INVTYPE_2HWEAPON"] = INVSLOT_MAINHAND;
	["INVTYPE_WEAPONMAINHAND"] = INVSLOT_MAINHAND;
	["INVTYPE_WEAPONOFFHAND"] = INVSLOT_OFFHAND;
	["INVTYPE_HOLDABLE"] = INVSLOT_OFFHAND;
	["INVTYPE_RANGED"] = INVSLOT_RANGED;
	["INVTYPE_THROWN"] = INVSLOT_RANGED;
	["INVTYPE_RANGEDRIGHT"] = INVSLOT_RANGED;
	["INVTYPE_RELIC"] = INVSLOT_RANGED;
	["INVTYPE_TABARD"] = INVSLOT_TABARD;
	["INVTYPE_BAG"] = CONTAINER_BAG_OFFSET;
	["INVTYPE_QUIVER"] = CONTAINER_BAG_OFFSET;
}

function BetterWardrobeSetsCollectionMixin:OnEvent(event, ...)
	if (event == "GET_ITEM_INFO_RECEIVED") then
		local itemID = ...
		for itemFrame in self.DetailsFrame.itemFramesPool:EnumerateActive() do
			if (itemFrame.itemID == itemID) then
				self:SetItemFrameQuality(itemFrame)
				break
			end
		end

	elseif (event == "TRANSMOG_COLLECTION_SOURCE_ADDED") then
		if not addon.Profile.ShowCollectionUpdates then return end
		local sourceID = ...
		local categoryID, visualID, canEnchant, icon, isCollected, itemLink, transmogLink, _ = C_TransmogCollection.GetAppearanceSourceInfo(sourceID)
		local itemID, _, _, itemEquipLoc = GetItemInfoInstant(itemLink)
		--print(ExtractHyperlinkString(transmogLink))
		local setIDs = C_TransmogSets.GetSetsContainingSourceID(sourceID)
		if setIDs and  addon.Profile.ShowSetCollectionUpdates then 
			for i, setID in pairs(setIDs) do 
				local setInfo = C_TransmogSets.GetSetInfo(setID)
				print((YELLOW_FONT_COLOR_CODE..L["Added missing appearances of: \124cffff7fff\124H%s:%s\124h[%s]\124h\124r"]):format("transmogset", setID, setInfo.name))
				return
			end
		end

		local isInList = addon.CollectionList:IsInList(visualID, "item")
		if addon.Profile.ShowCollectionListCollectionUpdates and isInList then  
			print((YELLOW_FONT_COLOR_CODE..L["Added appearance in Collection List"]))
		end

		local setItem = addon.IsSetItem(itemLink)
		
		if setItem and addon.Profile.ShowExtraSetsCollectionUpdates then 
			--local item = tonumber(itemLink:match("item:(%d+)"))
			
			newTransmogInfo = newTransmogInfo or {}

			for setID, setInfo in pairs(setItem) do 
			--local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
				--local setInfo = C_TransmogSets.GetSetInfo(setID)
				--local setInfo = addon.GetSetInfo(setID)
				if setInfo then 
					newTransmogInfo["latestSource"] = setID
					newTransmogInfo[setID] = newTransmogInfo[setID] or {}
					newTransmogInfo[setID][itemID] = inventoryTypes[itemEquipLoc]

					print((YELLOW_FONT_COLOR_CODE..L["Added missing appearances of: \124cffff7fff\124H%s:%s\124h[%s]\124h\124r"]):format("transmogset-extra", setID, setInfo.name))
				end
				return
			end
		end
		SetsDataProvider:ClearSets()
		addon:SendMessage("BW_TRANSMOG_COLLECTION_UPDATED")

	elseif (event == "TRANSMOG_COLLECTION_SOURCE_REMOVED") then
		local sourceID = ...
		local categoryID, visualID, canEnchant, icon, isCollected, itemLink, transmogLink, _ = C_TransmogCollection.GetAppearanceSourceInfo(sourceID)
		local setItem = addon.IsSetItem(itemLink)
		if setItem then 
			--local item = tonumber(itemLink:match("item:(%d+)"))
			local itemID, _, _, itemEquipLoc = GetItemInfoInstant(itemLink)
			newTransmogInfo = newTransmogInfo or {}

			for setID, setInfo in pairs(setItem) do 
				addon.ClearSetNewSourcesForSlot(setID, inventoryTypes[itemEquipLoc])
				SetsDataProvider:ResetBaseSetNewStatus(setID)
				if 	newTransmogInfo["latestSource"] == setID then 
					self:ClearLatestSource()
				end
			end
		end
		SetsDataProvider:ClearSets()
		addon:SendMessage("BW_TRANSMOG_COLLECTION_UPDATED")

	elseif (event == "TRANSMOG_COLLECTION_ITEM_UPDATE") then
		for itemFrame in self.DetailsFrame.itemFramesPool:EnumerateActive() do
			self:SetItemFrameQuality(itemFrame)
		end

	elseif (event == "TRANSMOG_COLLECTION_UPDATED") then
		SetsDataProvider:ClearSets()
		self:Refresh()

	end
end


function addon.SetHasNewSourcesForSlot(setID, transmogSlot)
	if not  newTransmogInfo[setID] then return false end
	for itemID, location in pairs(newTransmogInfo[setID]) do
		if location  == transmogSlot then 
			return true
		end	
	end
	return false
end 


function addon.ClearSetNewSourcesForSlot(setID, transmogSlot)
	if not  newTransmogInfo[setID] then return end

	local count = 0
	for itemID, location in pairs(newTransmogInfo[setID]) do
		count = count + 1
		if location  == transmogSlot then 
			newTransmogInfo[setID][itemID] = nil
			count = count - 1
		end
	end

	if count <= 0 then 
		newTransmogInfo[setID] = nil
		SetsDataProvider:ResetBaseSetNewStatus(setID)
	end
end


function addon.GetSetNewSources(setID)
	local sources = {}
	if not  newTransmogInfo[setID] then return sources end

	for itemID in pairs(newTransmogInfo[setID]) do
		local _, soucre = C_TransmogCollection.GetItemInfo(itemID)
		tinsert(sources, source)
	end
	return sources
end


function BetterWardrobeSetsCollectionMixin:Refresh()
	self.ScrollFrame:Update()
	if BW_WardrobeCollectionFrame.selectedCollectionTab == 4 then
		self:DisplaySavedSet(self:GetSelectedSavedSetID())
	else
		self:DisplaySet(self:GetSelectedSetID())
	end
end


local function GetSetCounts()
	local sets = addon.GetBaseList()
	local totalSets = #sets
	local collectedSets = 0

	for i, data in ipairs(sets) do
		local sourceData = SetsDataProvider:GetSetSourceData(data.setID)
		local topSourcesCollected, topSourcesTotal = sourceData.numCollected,sourceData.numTotal
		if topSourcesCollected == topSourcesTotal then
			collectedSets = collectedSets + 1
		end
	end
	return collectedSets, totalSets
end


function BetterWardrobeSetsCollectionMixin:UpdateProgressBar()
	WardrobeCollectionFrame_UpdateProgressBar(GetSetCounts())
end


function BetterWardrobeSetsCollectionMixin:ClearLatestSource()
	newTransmogInfo["latestSource"] = NO_TRANSMOG_SOURCE_ID
	BW_WardrobeCollectionFrame_UpdateTabButtons();
end


function isAvailableItem(sourceID,setID)
	local _, visualID = C_TransmogCollection.GetAppearanceSourceInfo(sourceID)		
	local sources = C_TransmogCollection.GetAppearanceSources(visualID) or {} --Can return nil if no longer in game

	if (#sources == 0) then
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
		local setInfo = addon.GetSetInfo(setID)
		if not sourceInfo.sourceType and not setInfo.sourceType then 
			return false
		end
	end
	return true
end


function BetterWardrobeSetsCollectionMixin:DisplaySet(setID)
	local setInfo = (setID and addon.GetSetInfo(setID)) or nil
	if (not setInfo) then
		self.DetailsFrame:Hide()
		self.Model:Hide()
		return
	else
		self.DetailsFrame:Show()
		self.Model:Show()
	end

	self.DetailsFrame.Name:SetText(setInfo.name)
	if (self.DetailsFrame.Name:IsTruncated()) then
		self.DetailsFrame.Name:Hide()
		self.DetailsFrame.LongName:SetText(setInfo.name)
		self.DetailsFrame.LongName:Show()
	else
		self.DetailsFrame.Name:Show()
		self.DetailsFrame.LongName:Hide()
	end

	self.DetailsFrame.Label:SetText((setInfo.label or "")..((not setInfo.isClass and setInfo.className) and " -"..setInfo.className.."-" or "") )


	local newSourceIDs = addon.GetSetNewSources(setID)

	self.DetailsFrame.itemFramesPool:ReleaseAll()
	self.Model:Undress()
	local BUTTON_SPACE = 37	-- button width + spacing between 2 buttons
	local sortedSources = SetsDataProvider:GetSortedSetSources(setID)
	local xOffset = -floor((#setInfo.items - 1) * BUTTON_SPACE / 2)

	for i = 1, #sortedSources do
		local itemFrame = self.DetailsFrame.itemFramesPool:Acquire()
		itemFrame.sourceID = sortedSources[i].sourceID
		itemFrame.itemID = sortedSources[i].itemID
		itemFrame.collected = sortedSources[i].collected
		itemFrame.invType = sortedSources[i].invType
		itemFrame.visualID = sortedSources[i].visualID
		local texture = C_TransmogCollection.GetSourceIcon(sortedSources[i].sourceID)
		if not itemFrame.unavailable then 
			--itemFrame.unavailable = CreateFrame("Frame", nil, itemFrame, "BackdropTemplate")
			--itemFrame.unavailable:SetAllPoints()
			itemFrame.unavailable = itemFrame:CreateTexture(nil, "ARTWORK")
			itemFrame.unavailable:SetAllPoints()
			itemFrame.unavailable:SetColorTexture(1,0,0,.1)
		end

		itemFrame.Icon:SetTexture(texture)
		if (sortedSources[i].collected) then
			itemFrame.Icon:SetDesaturated(false)
			itemFrame.Icon:SetAlpha(1)
			itemFrame.IconBorder:SetDesaturation(0)
			itemFrame.IconBorder:SetAlpha(1)

			local transmogSlot = C_Transmog.GetSlotForInventoryType(itemFrame.invType)
			if (addon.SetHasNewSourcesForSlot(setID, transmogSlot)) then
				itemFrame.New:Show()
				itemFrame.New.Anim:Play()
			else
				itemFrame.New:Hide()
				itemFrame.New.Anim:Stop()
			end
		else
			itemFrame.Icon:SetDesaturated(true)
			itemFrame.Icon:SetAlpha(0.3)
			itemFrame.IconBorder:SetDesaturation(1)
			itemFrame.IconBorder:SetAlpha(0.3)
			itemFrame.New:Hide()
		end
		if isAvailableItem(itemFrame.sourceID, setInfo.setID) then  
			itemFrame.unavailable:Hide()
			--itemFrame.Icon:SetColorTexture(1,0,0,.5)
		else 
		itemFrame.unavailable:Show()

			--itemFrame.Icon:SetColorTexture(0,0,0,.5)
		end

		self:SetItemFrameQuality(itemFrame)
		itemFrame:SetPoint("TOP", self.DetailsFrame, "TOP", xOffset + (i - 1) * BUTTON_SPACE, -94)
		itemFrame:Show()
		if not addon.setdb.profile.autoHideSlot.toggle or( addon.setdb.profile.autoHideSlot.toggle and not addon.setdb.profile.autoHideSlot[sortedSources[i].invType -1]) then
			self.Model:TryOn(sortedSources[i].sourceID)
		end
	end
end


function BetterWardrobeSetsCollectionMixin:DisplaySavedSet(setID)
	local setInfo = (setID and addon.GetSetInfo(setID)) or nil
	if (not setInfo) then
		self.DetailsFrame:Hide()
		self.Model:Hide()
		return
	else
		self.DetailsFrame:Show()
		self.Model:Show()
	end

	self.DetailsFrame.Name:SetText(setInfo.name)
	if (self.DetailsFrame.Name:IsTruncated()) then
		self.DetailsFrame.Name:Hide()
		self.DetailsFrame.LongName:SetText(setInfo.name)
		self.DetailsFrame.LongName:Show()
	else
		self.DetailsFrame.Name:Show()
		self.DetailsFrame.LongName:Hide()
	end

	self.DetailsFrame.Label:SetText(setInfo.label)

	self.DetailsFrame.itemFramesPool:ReleaseAll()
	self.Model:Undress()
	local row1 = 0
	local row2 = 0
	local yOffset1 = -94

	if setInfo then
		for i = 1, #setInfo.sources do
			local sourceInfo = setInfo.sources[i] and C_TransmogCollection.GetSourceInfo(setInfo.sources[i])
			if sourceInfo then
				row1 = row1 + 1
			end
		end

		if row1 > 10 then
			row2 = row1 - 10
			row1 = 10
			yOffset1 = -74
		end
	end

	local BUTTON_SPACE = 37	-- button width + spacing between 2 buttons
	local sortedSources = setInfo.sources --SetsDataProvider:GetSortedSetSources(setID)
	local xOffset = -floor((row1 - 1) * BUTTON_SPACE / 2)
	local xOffset2 = -floor((row2 - 1) * BUTTON_SPACE / 2)
	local yOffset2 = yOffset1 - 40
	local itemCount = 0

	for i = 1, #sortedSources do
		if sortedSources[i] then
	
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sortedSources[i])
		if sourceInfo then
		itemCount = itemCount + 1
			local itemFrame = self.DetailsFrame.itemFramesPool:Acquire()
			itemFrame.sourceID = sourceInfo.sourceID
			--itemFrame.itemID = sourceInfo.itemID
			itemFrame.collected = sourceInfo.isCollected
			itemFrame.invType = sourceInfo.invType
			local texture = C_TransmogCollection.GetSourceIcon(sourceInfo.sourceID)
			itemFrame.Icon:SetTexture(texture)
			if (sourceInfo.isCollected) then
				itemFrame.Icon:SetDesaturated(false)
				itemFrame.Icon:SetAlpha(1)
				itemFrame.IconBorder:SetDesaturation(0)
				itemFrame.IconBorder:SetAlpha(1)
			else
				itemFrame.Icon:SetDesaturated(true)
				itemFrame.Icon:SetAlpha(0.3)
				itemFrame.IconBorder:SetDesaturation(1)
				itemFrame.IconBorder:SetAlpha(0.3)
				itemFrame.New:Hide()
			end

			self:SetItemFrameQuality(itemFrame)
			local move = (itemCount > 10)

			if itemCount <= 10 then
				itemFrame:SetPoint("TOP", self.DetailsFrame, "TOP", xOffset + (itemCount - 1) * BUTTON_SPACE, yOffset1)

			else
				itemFrame:SetPoint("TOP", self.DetailsFrame, "TOP", xOffset2 + (itemCount - 11) * BUTTON_SPACE, yOffset2)


			end

				self.DetailsFrame.IconRowBackground:ClearAllPoints()
				self.DetailsFrame.IconRowBackground:SetPoint("TOP", 0, move and -50 or -78)
				self.DetailsFrame.IconRowBackground:SetHeight(move and 120 or 64)
				self.DetailsFrame.Name:ClearAllPoints()
				self.DetailsFrame.Name:SetPoint("TOP", 0,  move and -17 or -37)
				self.DetailsFrame.LongName:ClearAllPoints()
				self.DetailsFrame.LongName:SetPoint("TOP", 0, move and -10 or -30)
				self.DetailsFrame.Label:ClearAllPoints()
				self.DetailsFrame.Label:SetPoint("TOP", 0, move and -43 or -63)

			itemFrame:Show()
			self.Model:TryOn(sourceInfo.sourceID)
			end
		end
	end
end


function BetterWardrobeSetsCollectionMixin:OnSearchUpdate()
	if (self.init) then
		SetsDataProvider:ClearBaseSets()
		SetsDataProvider:ClearVariantSets()
		SetsDataProvider:ClearUsableSets()
		SetsDataProvider:FilterSearch(true)
		self:Refresh()
	end
end

function BetterWardrobeSetsCollectionMixin:RefreshScrollList()
		SetsDataProvider:ClearBaseSets()
		SetsDataProvider:ClearVariantSets()
		SetsDataProvider:ClearUsableSets()
		SetsDataProvider:FilterSearch(true)
		self:Refresh()

end


function BetterWardrobeSetsCollectionMixin:SelectSetFromButton(setID)
	BW_CloseDropDownMenus()
	--self:SelectSet(self:GetDefaultSetIDForBaseSet(setID))
	self:SelectSet(setID)
end


function BetterWardrobeSetsCollectionMixin:GetSelectedSavedSetID()
	if not self.selectedSavedSetID then
		local savedSets = addon.GetSavedList()
		if savedSets then 
			self.selectedSavedSetID = savedSets[1].setID
		end
	end

	return self.selectedSavedSetID
end


function BetterWardrobeSetsCollectionMixin:GetSelectedSetID()
	if not self.selectedSetID then
		local savedSets = SetsDataProvider:GetBaseSets(true)
		self.selectedSetID = savedSets[1].setID
	end
	return self.selectedSetID
end


function BetterWardrobeSetsCollectionMixin:SelectSet(setID)
	if BW_WardrobeCollectionFrame.selectedCollectionTab == 4 then
		self:SelectSavedSet(setID)
		self.selectedSavedSetID = setID
	else
		self.selectedSetID = setID
	end

	self:Refresh()
end


function BetterWardrobeSetsCollectionMixin:SelectSavedSet(setID)
		self.selectedSavedSetID = setID
end


function BetterWardrobeSetsCollectionMixin:SetAppearanceTooltip(frame)
	GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
	self.tooltipTransmogSlot = C_Transmog.GetSlotForInventoryType(frame.invType)
	self.tooltipPrimarySourceID = frame.sourceID
	self:RefreshAppearanceTooltip()
end


local function GetDropDifficulties(drop)
	local text = drop.difficulties[1]
	if (text) then
		for i = 2, #drop.difficulties do
			text = text..", "..drop.difficulties[i]
		end
	end
	return text
end


local needsRefresh = false
function BW_WardrobeCollectionFrame_SetAppearanceTooltip(contentFrame, sources, primarySourceID)
	BW_WardrobeCollectionFrame.tooltipContentFrame = contentFrame

	for i = 1, #sources do
		if (sources[i].isHideVisual) then
			GameTooltip:SetText(sources[i].name)
			return
		end
	end

	local firstVisualID = sources[1].visualID
	local passedFirstVisualID = false

	local headerIndex
	if (not BW_WardrobeCollectionFrame.tooltipSourceIndex) then
		headerIndex = WardrobeCollectionFrame_GetDefaultSourceIndex(sources, primarySourceID)
	else
		headerIndex = WardrobeUtils_GetValidIndexForNumSources(BW_WardrobeCollectionFrame.tooltipSourceIndex, #sources)
	end
	BW_WardrobeCollectionFrame.tooltipSourceIndex = headerIndex
	local setInfo = addon.GetSetInfo(contentFrame.selectedSetID)
	headerSourceID = sources[headerIndex].sourceID

	local name, nameColor, sourceText, sourceColor = WardrobeCollectionFrameModel_GetSourceTooltipInfo(sources[headerIndex])
	if name == RETRIEVING_ITEM_INFO then needsRefresh = true end

	GameTooltip:SetText(name, nameColor.r, nameColor.g, nameColor.b)

	if (sources[headerIndex].sourceType == TRANSMOG_SOURCE_BOSS_DROP and not sources[headerIndex].isCollected) then
		local drops = C_TransmogCollection.GetAppearanceSourceDrops(headerSourceID)
		if (drops and #drops > 0) then
			local showDifficulty = false
			if (#drops == 1) then
				sourceText = _G["TRANSMOG_SOURCE_"..TRANSMOG_SOURCE_BOSS_DROP]..": "..string.format(WARDROBE_TOOLTIP_ENCOUNTER_SOURCE, drops[1].encounter, drops[1].instance)
				showDifficulty = true
			else
				-- check if the drops are the same instance
				local sameInstance = true
				local firstInstance = drops[1].instance
				for i = 2, #drops do
					if (drops[i].instance ~= firstInstance) then
						sameInstance = false
						break
					end
				end
				-- ok, if multiple instances check if it's the same tier if the drops have a single tier
				local sameTier = true
				local firstTier = drops[1].tiers[1]
				if (not sameInstance and #drops[1].tiers == 1) then
					for i = 2, #drops do
						if (#drops[i].tiers > 1 or drops[i].tiers[1] ~= firstTier) then
							sameTier = false
							break
						end
					end
				end
				-- if same instance or tier, check if we have same difficulties and same instanceType
				local sameDifficulty = false
				local sameInstanceType = false
				if (sameInstance or sameTier) then
					sameDifficulty = true
					sameInstanceType = true
					for i = 2, #drops do
						if (drops[1].instanceType ~= drops[i].instanceType) then
							sameInstanceType = false
						end

						if (#drops[1].difficulties ~= #drops[i].difficulties) then
							sameDifficulty = false
						else
							for j = 1, #drops[1].difficulties do
								if (drops[1].difficulties[j] ~= drops[i].difficulties[j]) then
									sameDifficulty = false
									break
								end
							end
						end
					end
				end
				-- override sourceText if sameInstance or sameTier
				if (sameInstance) then
					sourceText = _G["TRANSMOG_SOURCE_"..TRANSMOG_SOURCE_BOSS_DROP]..": "..firstInstance
					showDifficulty = sameDifficulty
				elseif (sameTier) then
					local location = firstTier
					if (sameInstanceType) then
						if (drops[1].instanceType == INSTANCE_TYPE_DUNGEON) then
							location = string.format(WARDROBE_TOOLTIP_DUNGEONS, location)
						elseif (drops[1].instanceType == INSTANCE_TYPE_RAID) then
							location = string.format(WARDROBE_TOOLTIP_RAIDS, location)
						end
					end
					sourceText = _G["TRANSMOG_SOURCE_"..TRANSMOG_SOURCE_BOSS_DROP]..": "..location
				end
			end

			if (showDifficulty) then
				local diffText = GetDropDifficulties(drops[1])
				if (diffText) then
					sourceText = sourceText.." "..string.format(PARENS_TEMPLATE, diffText)
				end
			end
		end
	end

	if (not sources[headerIndex].isCollected) then
		if sourceText then 
			GameTooltip:AddLine(sourceText, sourceColor.r, sourceColor.g, sourceColor.b, 1, 1)
		elseif setInfo.sourceType  then
			GameTooltip:AddLine(_G["TRANSMOG_SOURCE_"..setInfo.sourceType], 1,1,1)
		else
			GameTooltip:AddLine(L["Item No Longer Available"],RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)

		end
	end

	local useError
	local appearanceCollected = sources[headerIndex].isCollected

	if (#sources > 1 and not appearanceCollected) then
		-- only add "Other items using this appearance" if we're continuing to the same visualID
		if (firstVisualID == sources[2].visualID) then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(WARDROBE_OTHER_ITEMS, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
		end

		for i = 1, #sources do
			-- first time we transition to a different visualID, add "Other items that unlock this slot"
			if (not passedFirstVisualID and firstVisualID ~= sources[i].visualID) then
				passedFirstVisualID = true
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(WARDROBE_ALTERNATE_ITEMS)
			end

			local name, nameColor, sourceText, sourceColor = WardrobeCollectionFrameModel_GetSourceTooltipInfo(sources[i])
			if name == RETRIEVING_ITEM_INFO then needsRefresh = true end

			if (i == headerIndex) then
				name = WARDROBE_TOOLTIP_CYCLE_ARROW_ICON..name
				useError = sources[i].useError
			else
				name = WARDROBE_TOOLTIP_CYCLE_SPACER_ICON..name
			end
			GameTooltip:AddDoubleLine(name, sourceText, nameColor.r, nameColor.g, nameColor.b, sourceColor.r, sourceColor.g, sourceColor.b)
		end
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(WARDROBE_TOOLTIP_CYCLE, GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b, true)
		BW_WardrobeCollectionFrame.tooltipCycle = true
	else
		useError = sources[headerIndex].useError
		BW_WardrobeCollectionFrame.tooltipCycle = nil
	end

	if (appearanceCollected) then
		if (useError) then
			GameTooltip:AddLine(useError, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, true)
		elseif (not WardrobeFrame_IsAtTransmogrifier()) then
			GameTooltip:AddLine(WARDROBE_TOOLTIP_TRANSMOGRIFIER, GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b, 1, 1)
		end

		if (not useError) then
			local holidayName = C_TransmogCollection.GetSourceRequiredHoliday(headerSourceID)
			if (holidayName) then
				GameTooltip:AddLine(TRANSMOG_APPEARANCE_USABLE_HOLIDAY:format(holidayName), LIGHTBLUE_FONT_COLOR.r, LIGHTBLUE_FONT_COLOR.g, LIGHTBLUE_FONT_COLOR.b, true)
			end
		end
	end

	GameTooltip:Show()
end

function BetterWardrobeSetsCollectionMixin:RefreshAppearanceTooltip()
	if (not self.tooltipTransmogSlot) then
		return
	end

	local sourceInfo = C_TransmogCollection.GetSourceInfo(self.tooltipPrimarySourceID)
	local visualID = sourceInfo.visualID
	local sources = C_TransmogCollection.GetAppearanceSources(visualID) or {} --Can return nil if no longer in game
	
	if (#sources == 0) then
		-- can happen if a slot only has HiddenUntilCollected sources
		local sourceInfo = C_TransmogCollection.GetSourceInfo(self.tooltipPrimarySourceID)
		tinsert(sources, sourceInfo)
	end

	WardrobeCollectionFrame_SortSources(sources, sources[1].visualID, self.tooltipPrimarySourceID)
	BW_WardrobeCollectionFrame_SetAppearanceTooltip(self, sources, self.tooltipPrimarySourceID)

	C_Timer.After(.05, function() if needsRefresh then self:RefreshAppearanceTooltip(); needsRefresh = false; end; end) --Fix for items that returned retreaving info
end

BetterWardrobeSetsCollectionScrollFrameMixin = CreateFromMixins(WardrobeSetsCollectionScrollFrameMixin)
local tabType = {"item", "set", "extraset"}

local function BW_WardrobeSetsCollectionScrollFrame_FavoriteDropDownInit(self)
	if (not self.baseSetID) then
		return
	end

	local baseSet = SetsDataProvider:GetBaseSetByID(self.baseSetID)
	local type = tabType[addon.GetTab()]
	--local variantSets = SetsDataProvider:GetVariantSets(self.baseSetID)
	local useDescription = false

	local info = BW_UIDropDownMenu_CreateInfo()
	info.notCheckable = true
	info.disabled = nil
	local isFavorite = (type == "set" and C_TransmogSets.GetIsFavorite(self.baseSetID)) or addon.favoritesDB.profile.extraset[self.baseSetID]
	if (isFavorite) then
		info.text = BATTLE_PET_UNFAVORITE;

		if type == "set"  then
			info.func = function() WardrobeCollectionFrame.SetsTransmogFrame:SetFavorite(self.baseSetID, false); end

		elseif type == "extraset"  then
			info.func = function()
				addon.favoritesDB.profile.extraset[self.baseSetID] = nil
				BW_SetsCollectionFrame:Refresh()
				BW_SetsCollectionFrame:OnSearchUpdate()
			end
		end
	else
		info.text = BATTLE_PET_FAVORITE
		if type == "set"  then
			info.func = function() WardrobeCollectionFrame.SetsTransmogFrame:SetFavorite(self.baseSetID, true); end

		elseif type == "extraset"  then
			--local targetSetID = WardrobeCollectionFrame.SetsCollectionFrame:GetDefaultSetIDForBaseSet(self.baseSetID)
			info.func = function()
				addon.favoritesDB.profile.extraset[self.baseSetID] = true
				BW_SetsCollectionFrame:Refresh()
				BW_SetsCollectionFrame:OnSearchUpdate()
			end
		end
	end

	BW_UIDropDownMenu_AddButton(info, level)
	info.disabled = nil

	info.text = CANCEL
	info.func = nil
	BW_UIDropDownMenu_AddButton(info, level)

local tab = addon.GetTab()
if tab ~=4 then 
	--new
		local variantTarget, match, matchType
		local variantType = ""
		if type == "set" or type =="extraset" then
			BW_UIDropDownMenu_AddSeparator()
			BW_UIDropDownMenu_AddButton({
					notCheckable = true,
					text = L["Queue Transmog"],
					func = function()

						local setInfo = addon.GetSetInfo(self.baseSetID) or C_TransmogSets.GetSetInfo(self.baseSetID)
						local name = setInfo["name"]
						--addon.QueueForTransmog(type, setID, name)
						addon.QueueList = {type, self.baseSetID, name}
					 end,
					})
						if type == "set" then 
				variantTarget, variantType, match, matchType = addon.Sets:SelectedVariant(self.baseSetID)
			end
		end

		BW_UIDropDownMenu_AddSeparator()
		local isHidden = addon.HiddenAppearanceDB.profile[type][self.baseSetID]
		
		BW_UIDropDownMenu_AddButton({
			notCheckable = true,
			text = isHidden and SHOW or HIDE,
			func = function() self.setID = self.baseSetID; addon.ToggleHidden(self, isHidden) end,
		})

		local collected = self.setCollected
		--Collection List Right Click options
		local collectionList = addon.CollectionList:CurrentList()
		local isInList = match or addon.CollectionList:IsInList(self.baseSetID, type)

		--if  type  == "set" or ((isInList and collected) or not collected)then --(type == "item" and not (model.visualInfo and model.visualInfo.isCollected)) or type == "set" or type == "extraset" then
			local targetSet = match or variantTarget or self.baseSetID
			local targetText = match and " - "..matchType or variantTarget and " - "..variantType or ""
			BW_UIDropDownMenu_AddSeparator()
			local isInList = collectionList[type][targetSet]
			BW_UIDropDownMenu_AddButton({
				notCheckable = true,
				text = isInList and L["Remove from Collection List"]..targetText or L["Add to Collection List"]..targetText,
				func = function()
							addon.CollectionList:UpdateList(type, targetSet, not isInList)
					end,
			})
		end
end


function BetterWardrobeSetsCollectionScrollFrameMixin:OnLoad()
	self.scrollBar.trackBG:Show()
	self.scrollBar.trackBG:SetVertexColor(0, 0, 0, 0.75)
	self.scrollBar.doNotHide = true
	self.update = self.Update
	HybridScrollFrame_CreateButtons(self, "WardrobeSetsScrollFrameButtonTemplate", 44, 0)


	BW_WardrobeSetsFavoriteDropDown = CreateFrame("Frame", "BW_WardrobeSetsFavoriteDropDown", self, "BW_UIDropDownMenuTemplate")
	--BW_WardrobeSetsFavoriteDropDown = BW_UIDropDownMenu_Create("BW_WardrobeSetsFavoriteDropDown", self)
	self.FavoriteDropDown = BW_WardrobeSetsFavoriteDropDown
	WardrobeCollectionFrameScrollFrame.FavoriteDropDown = BW_WardrobeSetsFavoriteDropDown
	BW_UIDropDownMenu_Initialize(self.FavoriteDropDown, BW_WardrobeSetsCollectionScrollFrame_FavoriteDropDownInit, "MENU")
end

local function CheckSetAvailability(setID)
	local setData = SetsDataProvider:GetSetSourceData(setID)
	return setData.unavailable
end

function BetterWardrobeSetsCollectionScrollFrameMixin:Update()
	local offset = HybridScrollFrame_GetOffset(self)
	local buttons = self.buttons
	local baseSets = SetsDataProvider:GetBaseSets() --addon.GetBaseList()
	local selectedBaseSetID
	-- show the base set as selected

	if BW_WardrobeCollectionFrame.selectedCollectionTab == 4 then
		selectedBaseSetID = self:GetParent():GetSelectedSavedSetID()
	else

		selectedBaseSetID = self:GetParent():GetSelectedSetID()
	end

	for i = 1, #buttons do
		local button = buttons[i]
		local setIndex = i + offset

		if (setIndex <= #baseSets) then
			local baseSet = baseSets[setIndex]

			local isFavorite = addon.favoritesDB.profile.extraset[baseSet.setID]
			local isHidden = addon.HiddenAppearanceDB.profile.extraset[baseSet.setID]

			--local count, complete = addon.GetSetCompletion(baseSet)
			button:Show()
			button.Name:SetText(baseSet.name..((not baseSet.isClass and baseSet.className) and "-"..baseSet.className.."-" or "") )
			local topSourcesCollected, topSourcesTotal = SetsDataProvider:GetSetSourceTopCounts(baseSet.setID)

			local setCollected = topSourcesCollected == topSourcesTotal --baseSet.collected -- C_TransmogSets.IsBaseSetCollected(baseSet.setID)
			local color = IN_PROGRESS_FONT_COLOR

			if (setCollected) then
				color = NORMAL_FONT_COLOR
			elseif (topSourcesCollected == 0) then
				color = GRAY_FONT_COLOR
			end


			button.setCollected = setCollected
			button.Name:SetTextColor(color.r, color.g, color.b)
			button.Label:SetText(baseSet.label) --(L["NOTE_"..(baseSet.label or 0)] and L["NOTE_"..(baseSet.label or 0)]) or "")--((L["NOTE_"..baseSet.label] or "X"))
			button.Icon:SetTexture(baseSet.icon or SetsDataProvider:GetIconForSet(baseSet.setID))
			button.Icon:SetDesaturation((baseSet.collected and 0) or ((topSourcesCollected == 0) and 1) or 0)
			button.SelectedTexture:SetShown(baseSet.setID == selectedBaseSetID)
			button.Favorite:SetShown(isFavorite)
			button.CollectionListVisual.Hidden.Icon:SetShown(isHidden)
			button.CollectionListVisual.Unavailable.Icon:SetShown(CheckSetAvailability(baseSet.setID))

			button.CollectionListVisual.InvalidTexture:SetShown(not baseSet.isClass)
			local isInList = addon.CollectionList:IsInList(baseSet.setID, "extraset")
			button.CollectionListVisual.Collection.Collection_Icon:SetShown(isInList)
			button.CollectionListVisual.Collection.Collected_Icon:SetShown(isInList and setCollected)
			--button.CollectionListVisual.Collection.Collected_Icon:SetShown(false
			button.New:SetShown(SetsDataProvider:IsBaseSetNew(baseSet.setID))
			button.setID = baseSet.setID

			if (topSourcesCollected == 0 or setCollected) then
				button.ProgressBar:Hide()
			else
				button.ProgressBar:Show()
				button.ProgressBar:SetWidth(SET_PROGRESS_BAR_MAX_WIDTH * topSourcesCollected / topSourcesTotal)
			end
			button.IconCover:SetShown(not setCollected)
		else
			button:Hide()
		end
	end

	local extraHeight = (self.largeButtonHeight and self.largeButtonHeight - BASE_SET_BUTTON_HEIGHT) or 0
	local totalHeight = #baseSets * BASE_SET_BUTTON_HEIGHT + extraHeight
	HybridScrollFrame_Update(self, totalHeight, self:GetHeight())
end

BW_WardrobeSetsDetailsItemMixin = CreateFromMixins(WardrobeSetsDetailsItemMixin)
function BW_WardrobeSetsDetailsItemMixin:OnEnter()
	self:GetParent():GetParent():SetAppearanceTooltip(self)

	self:SetScript("OnUpdate",
		function()
			if IsModifiedClick("DRESSUP") then
				ShowInspectCursor()
			else
				ResetCursor()
			end
		end
	)

	if (self.New:IsShown()) then
		local transmogSlot = C_Transmog.GetSlotForInventoryType(self.invType)
		local setID = BW_WardrobeCollectionFrame.BW_SetsCollectionFrame:GetSelectedSetID()
		addon.ClearSetNewSourcesForSlot(setID, transmogSlot)
		local baseSetID = C_TransmogSets.GetBaseSetID(setID)
		SetsDataProvider:ResetBaseSetNewStatus(setID)
		BW_WardrobeCollectionFrame.BW_SetsCollectionFrame:Refresh()
	end
end


local BW_ItemSubDropDownMenu = CreateFrame("Frame", "BW_ItemSubDropDownMenu", UIParent, "BW_UIDropDownMenuTemplate")
--local BW_ItemSubDropDownMenu = BW_UIDropDownMenu_Create("BW_ItemSubDropDownMenu", UIParent)

BW_ItemSubDropDownMenu:SetFrameLevel(500)
local clickedItemID = nil
local BW_ItemSubDropDownMenu_Table = {
    {
        text = L["Substitue Item"],
        func = function(self)    		
          	BW_WardrobeOutfitFrameMixin:ShowPopup("BETTER_WARDROBE_SUBITEM_POPUP")
        end,
        notCheckable = 1,
    },
    {
        text = CLOSE,
        func = function() BW_CloseDropDownMenus() end,
        notCheckable = 1,
    },
 
}

StaticPopupDialogs["BETTER_WARDROBE_SUBITEM_INVALID_POPUP"] = {
	text = L["Not a valid itemID"],
	preferredIndex = 3,
	button1 = "OK",
	button2 = CANCEL,
	editBoxWidth = 260,
	EditBoxOnEnterPressed = function(self)
		if (self:GetParent().button1:IsEnabled()) then
			StaticPopup_OnClick(self:GetParent(), 1)
		end
	end,
	OnAccept = function(self)
		--ImportSet(self.editBox:GetText());
		 BW_WardrobeOutfitFrameMixin:ShowPopup("BETTER_WARDROBE_SUBITEM_POPUP")
	end,
	EditBoxOnEscapePressed = function()BW_WardrobeOutfitFrameMixin:ShowPopup("BETTER_WARDROBE_SUBITEM_POPUP") end,
	exclusive = true,
	whileDead = true,
};

StaticPopupDialogs["BETTER_WARDROBE_SUBITEM_WRONG_LOCATION_POPUP"] = {
	text = L["Item Locations Don't Match"],
	preferredIndex = 3,
	button1 = "OK",
	button2 = CANCEL,
	editBoxWidth = 260,
	EditBoxOnEnterPressed = function(self)
		if (self:GetParent().button1:IsEnabled()) then
			StaticPopup_OnClick(self:GetParent(), 1)
		end
	end,
	OnAccept = function(self)
		--ImportSet(self.editBox:GetText());
		 BW_WardrobeOutfitFrameMixin:ShowPopup("BETTER_WARDROBE_SUBITEM_POPUP")
	end,
	EditBoxOnEscapePressed = function()BW_WardrobeOutfitFrameMixin:ShowPopup("BETTER_WARDROBE_SUBITEM_POPUP") end,
	exclusive = true,
	whileDead = true,
};

StaticPopupDialogs["BETTER_WARDROBE_SUBITEM_POPUP"] = {
	text = L["Item ID"],
	preferredIndex = 3,
	button1 = L["Set Substitution"],
	button2 = CANCEL,
	hasEditBox = true,
	maxLetters = 512,
	editBoxWidth = 260,
	OnShow = function(self)
		if LISTWINDOW then LISTWINDOW:Hide() end
		self.editBox:SetText("")
	end,
	EditBoxOnEnterPressed = function(self)
		if (self:GetParent().button1:IsEnabled()) then
			StaticPopup_OnClick(self:GetParent(), 1)
		end
	end,
	OnAccept = function(self)
		local value = self.editBox:GetText()
		local id = tonumber(value)

		if id == nil then BW_WardrobeOutfitFrameMixin:ShowPopup("BETTER_WARDROBE_SUBITEM_INVALID_POPUP")  return false end

		local itemEquipLoc1 = GetItemInfoInstant(tonumber(value)) 
		if not itemEquipLoc1 == nil then BW_WardrobeOutfitFrameMixin:ShowPopup("BETTER_WARDROBE_SUBITEM_INVALID_POPUP") return false end

		addon.SetItemSubstitute(clickedItemID, value)
		--ImportSet(self.editBox:GetText());
		clickedItemID = nil
	end,
	EditBoxOnEscapePressed = HideParentPanel,
	exclusive = true,
	whileDead = true,
};

function BW_WardrobeSetsDetailsItemMixin:OnMouseDown(button)
	if (IsModifiedClick("CHATLINK")) then
		local sourceInfo = C_TransmogCollection.GetSourceInfo(self.sourceID)
		local slot = C_Transmog.GetSlotForInventoryType(sourceInfo.invType)
		local sources = C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)
		if (not sources or #sources == 0) then
			-- can happen if a slot only has HiddenUntilCollected sources or if no longer in game
			sources = sources or {}
			tinsert(sources, sourceInfo)
		end

		WardrobeCollectionFrame_SortSources(sources, sourceInfo.visualID, self.sourceID)
		if (BW_WardrobeCollectionFrame.tooltipSourceIndex) then
			local index = WardrobeUtils_GetValidIndexForNumSources(BW_WardrobeCollectionFrame.tooltipSourceIndex, #sources)
			local link = select(6, C_TransmogCollection.GetAppearanceSourceInfo(sources[index].sourceID))
			if (link) then
				HandleModifiedItemClick(link)
			end
		end
	elseif (IsModifiedClick("DRESSUP")) then
		DressUpVisual(self.sourceID)
	elseif button == "RightButton"  and BW_WardrobeCollectionFrame.selectedCollectionTab == 3 then 
			clickedItemID = self.itemID
			BW_EasyMenu(BW_ItemSubDropDownMenu_Table, BW_ItemSubDropDownMenu, self, 0, 0, "MENU", 10)
	end
end

--========--
-----Extra Sets Transmog Vendor Window

BetterWardrobeSetsTransmogMixin = CreateFromMixins(WardrobeSetsTransmogMixin)

function BetterWardrobeSetsTransmogMixin:LoadSet(setID)
	if BW_WardrobeCollectionFrame.selectedTransmogTab == 4 or BW_WardrobeCollectionFrame.selectedCollectionTab == 4 then
		if addon.SelecteSavedList then 
			BW_WardrobeOutfitDropDown:SelectDBOutfit(setID, true)
		else
			BW_WardrobeOutfitDropDown:SelectOutfit(setID - 5000, true)
		end
		return
	end

	local waitingOnData = false
	local transmogSources = {}
	local sources = addon.GetSetsources(setID)
	local combineSources = IsShiftKeyDown()
	local selectedItems = {}
	local SourceList = {}

	for sourceID in pairs(sources) do
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
		if sourceInfo then
			local slot = C_Transmog.GetSlotForInventoryType(sourceInfo.invType)
			local slotSources = C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)
			if slotSources then
				WardrobeCollectionFrame_SortSources(slotSources, sourceInfo.visualID)
				local knownID = Sets.isMogKnown(sourceID)
				if knownID then transmogSources[slot] = knownID end

				local index = WardrobeCollectionFrame_GetDefaultSourceIndex(slotSources, sourceID)
				--WardrobeCollectionFrame_SortSources(slotSources, sourceInfo.visualID)

				if combineSources then
					local transmogLocation = TransmogUtil.GetTransmogLocation(slot, Enum.TransmogType.Appearance, Enum.TransmogModification.None)
					local _, hasPending = C_Transmog.GetSlotInfo(transmogLocation)
					if hasPending then
						local  baseSourceID, baseVisualID, appliedSourceID, appliedVisualID, appliedCategoryID, pendingSourceID, pendingVisualID  = C_Transmog.GetSlotVisualInfo(transmogLocation)
						--local _,_,_,_, pendingVisualID, pendingSourceID = C_Transmog.GetSlotVisualInfo(transmogLocation)
						local emptyappearanceID, emptySourceID = EmptyArmor[slot] and C_TransmogCollection.GetItemInfo(EmptyArmor[slot])
						if pendingVisualID == emptyappearanceID then
							C_Transmog.ClearPending(transmogLocation)
							transmogSources[slot] = slotSources[index].sourceID
						else				
							transmogSources[slot] = pendingSourceID
						end
					end
				end
			end

			for i, slotSourceInfo in ipairs(sourceInfo) do
				if (not slotSourceInfo.name) then
					waitingOnData = true
				end
			end
		end
	end

	if (waitingOnData) then
		self.loadingSetID = setID
	else
		self.loadingSetID = nil
		-- if we don't ignore the event, clearing will momentarily set the page to the one with the set the user currently has transmogged
		-- if that's a different page from the current one then the models will flicker as we swap the gear to different sets and back
		self.ignoreTransmogrifyUpdateEvent = true
		C_Transmog.ClearAllPending();
		self.ignoreTransmogrifyUpdateEvent = false
		C_Transmog.LoadSources(transmogSources, -1, -1)

		if addon.Profile.HiddenMog then	
			local clearSlots = Sets:EmptySlots(transmogSources)
			for i, x in pairs(clearSlots) do
				local _, source = addon.GetItemSource(x) --C_TransmogCollection.GetItemInfo(x)
				--C_Transmog.SetPending(i, Enum.TransmogType.Appearance,source)
				local transmogLocation = TransmogUtil.GetTransmogLocation(i, Enum.TransmogType.Appearance, Enum.TransmogModification.None);
				C_Transmog.SetPending(transmogLocation, source, Enum.TransmogType.Appearance)
			end

			local emptySlotData = Sets:GetEmptySlots()
			for i, x in pairs(transmogSources) do
				if not C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(x) and (i ~= 7 or i ~= 4 or i ~= 19) and emptySlotData[i] then
					local _, source = addon.GetItemSource(emptySlotData[i]) --C_TransmogCollection.GetItemInfo(emptySlotData[i])
					--C_Transmog.SetPending(i, Enum.TransmogType.Appearance, source)		
				local transmogLocation = TransmogUtil.GetTransmogLocation(i, Enum.TransmogType.Appearance, Enum.TransmogModification.None);
				C_Transmog.SetPending(transmogLocation, source, Enum.TransmogType.Appearance)
				end
			end

			--hide any slots marked as alwayws hide
			local alwaysHideSlots = addon.setdb.profile.autoHideSlot
			for key, transmogSlot in pairs(TRANSMOG_SLOTS) do
				local slotID = transmogSlot.location:GetSlotID();
				if alwaysHideSlots[slotID] then 
					local transmogLocation = TransmogUtil.GetTransmogLocation(slotID, Enum.TransmogType.Appearance, Enum.TransmogModification.None);
					local _, source = addon.GetItemSource(emptySlotData[slotID]) -- C_TransmogCollection.GetItemInfo(emptySlotData[i])
					C_Transmog.SetPending(transmogLocation, source, Enum.TransmogType.Appearance)	
				end
			end
		end
	end
end


function BetterWardrobeSetsTransmogMixin:OnShow()
	self:RegisterEvent("TRANSMOGRIFY_UPDATE")
	self:RegisterEvent("TRANSMOGRIFY_SUCCESS")
	self:RegisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE")
	self:RegisterEvent("TRANSMOG_COLLECTION_UPDATED")
	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	self:RegisterEvent("TRANSMOG_SETS_UPDATE_FAVORITE")
	self:RefreshCameras()
	local RESET_SELECTION = true
	self:Refresh(RESET_SELECTION)
	WardrobeCollectionFrame.progressBar:Show()
	self:UpdateProgressBar()
	self.sourceQualityTable = {}

	if HelpTip:IsShowing(WardrobeCollectionFrame, TRANSMOG_SETS_VENDOR_TUTORIAL) then
		HelpTip:Hide(WardrobeCollectionFrame, TRANSMOG_SETS_VENDOR_TUTORIAL);
		SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_TRANSMOG_SETS_VENDOR_TAB, true)
	end
end


function BetterWardrobeSetsTransmogMixin:OnHide()
	self:UnregisterEvent("TRANSMOGRIFY_UPDATE")
	self:UnregisterEvent("TRANSMOGRIFY_SUCCESS")
	self:UnregisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE")
	self:UnregisterEvent("TRANSMOG_COLLECTION_UPDATED")
	self:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED")
	self:UnregisterEvent("TRANSMOG_SETS_UPDATE_FAVORITE")
	self.loadingSetID = nil
	SetsDataProvider:ClearSets()
	WardrobeCollectionFrame_ClearSearch(LE_TRANSMOG_SEARCH_TYPE_USABLE_SETS)
	self.sourceQualityTable = nil
end


function BetterWardrobeSetsTransmogMixin:UpdateProgressBar()
	WardrobeCollectionFrame_UpdateProgressBar(GetSetCounts())
end


function BetterWardrobeSetsTransmogMixin:UpdateSets()
	local usableSets

	if BW_WardrobeCollectionFrame.selectedTransmogTab == 4 or BW_WardrobeCollectionFrame.selectedCollectionTab == 4 then
			usableSets = addon.GetSavedList()
	else 
		usableSets = SetsDataProvider:GetUsableSets()
	end

	self.PagingFrame:SetMaxPages(ceil(#usableSets / self.PAGE_SIZE))
	local pendingTransmogModelFrame = nil
	local indexOffset = (self.PagingFrame:GetCurrentPage() - 1) * self.PAGE_SIZE

	for i = 1, self.PAGE_SIZE do
		local model = self.Models[i]
		local index = i + indexOffset
		local set = usableSets[index]

		if (set) then
			model:Show()

			--if (model.setID ~= set.setID) then
				model:Undress()
				local sourceData =  SetsDataProvider:GetSetSourceData(set.setID)
				local tab = WardrobeCollectionFrame.selectedTransmogTab
				for sourceID in pairs(sourceData.sources) do
					if (tab == 4 and not BW_WardrobeToggle.VisualMode) or
						(CollectionsJournal:IsShown()) or
						(not addon.Profile.HideMissing and (not BW_WardrobeToggle.VisualMode or (Sets.isMogKnown(sourceID) and BW_WardrobeToggle.VisualMode))) or
						(addon.Profile.HideMissing and (BW_WardrobeToggle.VisualMode or Sets.isMogKnown(sourceID))) then
						model:TryOn(sourceID)
					else
					end
				end
			--end

			local transmogStateAtlas

			if (set.setID == self.appliedSetID and set.setID == self.selectedSetID) then
				transmogStateAtlas = "transmog-set-border-current-transmogged"
			elseif (set.setID == self.selectedSetID) then
				transmogStateAtlas = "transmog-set-border-selected"
				pendingTransmogModelFrame = model
			elseif not set.isClass then 
				transmogStateAtlas = "transmog-set-border-unusable"
				model.TransmogStateTexture:SetPoint("CENTER",0,-2)
			end

			if (transmogStateAtlas) then
				model.TransmogStateTexture:SetAtlas(transmogStateAtlas, true)
				model.TransmogStateTexture:Show()
			else
				model.TransmogStateTexture:Hide()
			end

			local topSourcesCollected, topSourcesTotal
			if addon.Profile.ShowIncomplete then
				topSourcesCollected, topSourcesTotal = addon.Sets:GetLocationBasedCount(set)
			else
				topSourcesCollected, topSourcesTotal = SetsDataProvider:GetSetSourceCounts(set.setID)
			end

			local setInfo = addon.GetSetInfo(set.setID)
			local isFavorite = addon.favoritesDB.profile.extraset[set.setID]
			local isHidden = addon.HiddenAppearanceDB.profile.extraset[set.setID]
			model.setCollected = topSourcesCollected == topSourcesTotal
			model.Favorite.Icon:SetShown(isFavorite)
			model.CollectionListVisual.Hidden.Icon:SetShown(isHidden)
			
			local isInList = addon.CollectionList:IsInList(set.setID, "extraset")
			model.CollectionListVisual.Collection.Collection_Icon:SetShown(isInList)
			model.CollectionListVisual.Collection.Collected_Icon:SetShown(isInList and model.setCollected)
			--model.CollectionListVisual.Collection.Collected_Icon:SetShown(false)
			model.setID = set.setID
			local name = setInfo["name"]
			local description = (setInfo["description"] and "\n"..setInfo["description"]) or ""
			local class = (not setInfo.isClass and setInfo.className and "\n-"..setInfo.className.."-") or ""
			model.SetInfo.setName:SetText(("%s%s%s"):format(name, description,class))
			if BW_WardrobeCollectionFrame.selectedTransmogTab == 4 or BW_WardrobeCollectionFrame.selectedCollectionTab == 4 then
				model.SetInfo.progress:Hide()
			else
				model.SetInfo.progress:Show()
				model.SetInfo.progress:SetText(topSourcesCollected.."/".. topSourcesTotal)
			end
		else
			model:Hide()
		end
	end

	if (pendingTransmogModelFrame) then
		self.PendingTransmogFrame:SetParent(pendingTransmogModelFrame)
		self.PendingTransmogFrame:SetPoint("CENTER")
		self.PendingTransmogFrame:Show()

		if (self.PendingTransmogFrame.setID ~= pendingTransmogModelFrame.setID) then
			self.PendingTransmogFrame.TransmogSelectedAnim:Stop()
			self.PendingTransmogFrame.TransmogSelectedAnim:Play()
			self.PendingTransmogFrame.TransmogSelectedAnim2:Stop()
			self.PendingTransmogFrame.TransmogSelectedAnim2:Play()
			self.PendingTransmogFrame.TransmogSelectedAnim3:Stop()
			self.PendingTransmogFrame.TransmogSelectedAnim3:Play()
			self.PendingTransmogFrame.TransmogSelectedAnim4:Stop()
			self.PendingTransmogFrame.TransmogSelectedAnim4:Play()
			self.PendingTransmogFrame.TransmogSelectedAnim5:Stop()
			self.PendingTransmogFrame.TransmogSelectedAnim5:Play()
		end

		self.PendingTransmogFrame.setID = pendingTransmogModelFrame.setID
	else
		self.PendingTransmogFrame:Hide()
	end

	self.NoValidSetsLabel:SetShown(not C_TransmogSets.HasUsableSets())
end


function BetterWardrobeSetsTransmogMixin:OnSearchUpdate()
	SetsDataProvider:ClearUsableSets()
	SetsDataProvider:FilterSearch()
	self:UpdateSets()
end


function BetterWardrobeSetsTransmogMixin:RefreshSets()

	SetsDataProvider:ClearUsableSets()
	self:UpdateSets()

end
local function GetPage(entryIndex, pageSize)
	return floor((entryIndex-1) / pageSize) + 1
end


function BetterWardrobeSetsTransmogMixin:ResetPage()
	local page = 1

	if (self.selectedSetID) then
		local usableSets = SetsDataProvider:GetUsableSets()
		self.PagingFrame:SetMaxPages(ceil(#usableSets / self.PAGE_SIZE))
		for i, set in ipairs(usableSets) do
			if (set.setID == self.selectedSetID) then
				page = GetPage(i, self.PAGE_SIZE)
				break
			end
		end
	end

	self.PagingFrame:SetCurrentPage(page)
	self:UpdateSets()
end

function BetterWardrobeSetsTransmogMixin:OpenRightClickDropDown()
	if (not self.RightClickDropDown.activeFrame) then
		return
	end
	local tab = addon.GetTab()
	local type = tabType[addon.GetTab()]
	local setID = self.RightClickDropDown.activeFrame.setID
	local info = BW_UIDropDownMenu_CreateInfo()

	if tab == 2 then
		if ( C_TransmogSets.GetIsFavorite(setID) ) then
			info.text = BATTLE_PET_UNFAVORITE;
			info.func = function() self:SetFavorite(setID, false); end
		else
			info.text = BATTLE_PET_FAVORITE;
			info.func = function() self:SetFavorite(setID, true); end
		end
		info.notCheckable = true;
		BW_UIDropDownMenu_AddButton(info);
		-- Cancel
		info = BW_UIDropDownMenu_CreateInfo();
		info.notCheckable = true;
		info.text = CANCEL;
		BW_UIDropDownMenu_AddButton(info);
	else

		local isFavorite = addon.favoritesDB.profile.extraset[setID]
		if (isFavorite) then
			info.text = BATTLE_PET_UNFAVORITE
			info.func = function()
				addon.favoritesDB.profile.extraset[setID] = nil
				BW_SetsTransmogFrame:Refresh()
				BW_SetsTransmogFrame:OnSearchUpdate()
			 end
		else
			info.text = BATTLE_PET_FAVORITE
			info.func = function()
				addon.favoritesDB.profile.extraset[setID] = true
				BW_SetsTransmogFrame:Refresh()
				BW_SetsTransmogFrame:OnSearchUpdate()
			end
		end
		info.notCheckable = true
		BW_UIDropDownMenu_AddButton(info)
		-- Cancel
		info = BW_UIDropDownMenu_CreateInfo()
		info.notCheckable = true
		info.text = CANCEL
		BW_UIDropDownMenu_AddButton(info)
	end


	if tab ~= 4 then 
		local variantTarget, match, matchType
		local variantType = ""
		if type == "set" or type =="extraset" then
			BW_UIDropDownMenu_AddSeparator()
			BW_UIDropDownMenu_AddButton({
					notCheckable = true,
					text = L["Queue Transmog"],
					func = function()

						local setInfo = addon.GetSetInfo(setID) or C_TransmogSets.GetSetInfo(setID)
						local name = setInfo["name"]
						--addon.QueueForTransmog(type, setID, name)
						addon.QueueList = {type, setID, name}
					 end,
					})
			if type == "set" then 
				variantTarget, variantType, match, matchType = addon.Sets:SelectedVariant(setID)
			end
		end

		BW_UIDropDownMenu_AddSeparator()
		local isHidden = addon.HiddenAppearanceDB.profile[type][setID]
		BW_UIDropDownMenu_AddButton({
			notCheckable = true,
			text = isHidden and SHOW or HIDE,
			func = function()self.setID = setID; addon.ToggleHidden(self, isHidden) end,
		})

		local collected = (self.visualInfo and self.visualInfo.isCollected)
		--Collection List Right Click options
		local collectionList = addon.CollectionList:CurrentList()
		local isInList = match or addon.CollectionList:IsInList(setID, type)

		--if  type  == "set" or ((isInList and collected) or not collected)then --(type == "item" and not (model.visualInfo and model.visualInfo.isCollected)) or type == "set" or type == "extraset" then
			local targetSet = match or variantTarget or setID
			local targetText = match and " - "..matchType or variantTarget and " - "..variantType or ""
			BW_UIDropDownMenu_AddSeparator()
			local isInList = collectionList[type][targetSet]
			BW_UIDropDownMenu_AddButton({
				notCheckable = true,
				text = isInList and L["Remove from Collection List"]..targetText or L["Add to Collection List"]..targetText,
				func = function()
							addon.CollectionList:UpdateList(type, targetSet, not isInList)
					end,
			})
			--end
	end
end


do
	local function OpenRightClickDropDown(self)
		self:GetParent():OpenRightClickDropDown()
	end



function addon.Init:CreateRightClickDropDown()
	BW_WardrobeSetsTransmogModelRightClickDropDown = CreateFrame("Frame", "BW_WardrobeSetsTransmogModelRightClickDropDown", BW_SetsTransmogFrame, "BW_UIDropDownMenuTemplate")

	--BW_WardrobeSetsTransmogModelRightClickDropDown = BW_UIDropDownMenu_Create("BW_WardrobeSetsTransmogModelRightClickDropDown", BW_SetsTransmogFrame)
	BW_SetsTransmogFrame.RightClickDropDown = BW_WardrobeSetsTransmogModelRightClickDropDown
	WardrobeCollectionFrame.SetsTransmogFrame.RightClickDropDown = BW_WardrobeSetsTransmogModelRightClickDropDown
	WardrobeCollectionFrame.SetsTransmogFrame.OpenRightClickDropDown = BetterWardrobeSetsTransmogMixin.OpenRightClickDropDown
	BW_UIDropDownMenu_Initialize(BW_WardrobeSetsTransmogModelRightClickDropDown, OpenRightClickDropDown, "MENU")
end


end

local TAB_ITEMS = addon.Globals.TAB_ITEMS
local TAB_SETS = addon.Globals.TAB_SETS
local TAB_EXTRASETS = addon.Globals.TAB_EXTRASETS
local TAB_SAVED_SETS = addon.Globals.TAB_SAVED_SETS
local TABS_MAX_WIDTH = addon.Globals.TABS_MAX_WIDTH

function BW_WardrobeCollectionFrame_OnLoad(self)
	WardrobeCollectionFrameTab1:Hide()
	WardrobeCollectionFrameTab2:Hide()
	BW_WardrobeCollectionFrameTab1:Show()
	BW_WardrobeCollectionFrameTab2:Show()
	BW_WardrobeCollectionFrameTab3:Show()
	BW_WardrobeCollectionFrameTab4:Hide()
	--local level = CollectionsJournal:GetFrameLevel()
	local level = BW_WardrobeCollectionFrame:GetFrameLevel()
	CollectionsJournal:SetFrameLevel(level - 1)

	PanelTemplates_SetNumTabs(self, 4)
	PanelTemplates_SetTab(self, TAB_ITEMS)
	PanelTemplates_ResizeTabsToFit(self, TABS_MAX_WIDTH)
	self.selectedCollectionTab = TAB_ITEMS
	self.selectedTransmogTab = TAB_ITEMS

end


function BW_WardrobeCollectionFrame_OnEvent(self, event, ...)
	if (event == "UNIT_MODEL_CHANGED") then
		local hasAlternateForm, inAlternateForm = HasAlternateForm()
		if ((self.inAlternateForm ~= inAlternateForm or self.updateOnModelChanged)) then
			if (self.activeFrame:OnUnitModelChangedEvent()) then
				self.inAlternateForm = inAlternateForm
				self.updateOnModelChanged = nil
			end
		end
	elseif (event == "TRANSMOG_SEARCH_UPDATED") then
		local searchType, arg1 = ...
		if (searchType == self.activeFrame.searchType) then
			self.activeFrame:OnSearchUpdate(arg1)
		end
	end
end


function BW_WardrobeCollectionFrame_UpdateTabButtons()
	-- sets tab
	BW_WardrobeCollectionFrame.SetsTab.FlashFrame:SetShown(C_TransmogSets.GetLatestSource() ~= NO_TRANSMOG_SOURCE_ID and not WardrobeFrame_IsAtTransmogrifier());
	BW_WardrobeCollectionFrame.ExtraSetsTab.FlashFrame:SetShown(newTransmogInfo["latestSource"] ~= NO_TRANSMOG_SOURCE_ID and not WardrobeFrame_IsAtTransmogrifier())
end


addon.TRANSMOG_SET_FILTER[LE_TRANSMOG_SET_FILTER_COLLECTED] = C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_COLLECTED)
addon.TRANSMOG_SET_FILTER[LE_TRANSMOG_SET_FILTER_UNCOLLECTED] = C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_UNCOLLECTED)
addon.TRANSMOG_SET_FILTER[LE_TRANSMOG_SET_FILTER_PVP] = C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVP)
addon.TRANSMOG_SET_FILTER[LE_TRANSMOG_SET_FILTER_PVE] = C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVE)

function BW_WardrobeCollectionFrame_OnShow(self)
	_,playerClass, classID = UnitClass("player")
	CollectionsJournal:SetPortraitToAsset("Interface\\Icons\\inv_chest_cloth_17")
	local level = CollectionsJournal:GetFrameLevel()
	BW_WardrobeCollectionFrame:SetFrameLevel(level+10)

	self:RegisterUnitEvent("UNIT_MODEL_CHANGED", "player")
	self:RegisterEvent("TRANSMOG_SEARCH_UPDATED")

	local hasAlternateForm, inAlternateForm = HasAlternateForm()
	self.inAlternateForm = inAlternateForm

	if (WardrobeFrame_IsAtTransmogrifier()) then
		BW_WardrobeCollectionFrame_SetTab(TAB_ITEMS)
		C_TransmogSets.SetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_COLLECTED, true);
		C_TransmogSets.SetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_UNCOLLECTED, true);
		C_TransmogSets.SetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVP, true);
		C_TransmogSets.SetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVE, true);

	else
		BW_WardrobeCollectionFrame_SetTab(TAB_ITEMS)
		C_TransmogSets.SetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_COLLECTED, addon.TRANSMOG_SET_FILTER[LE_TRANSMOG_SET_FILTER_COLLECTED] );
		C_TransmogSets.SetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_UNCOLLECTED, addon.TRANSMOG_SET_FILTER[LE_TRANSMOG_SET_FILTER_UNCOLLECTED] );
		C_TransmogSets.SetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVP, addon.TRANSMOG_SET_FILTER[LE_TRANSMOG_SET_FILTER_PVP] );
		C_TransmogSets.SetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVE, addon.TRANSMOG_SET_FILTER[LE_TRANSMOG_SET_FILTER_PVE] );
	end
	BW_WardrobeCollectionFrame_UpdateTabButtons()

	if #addon.GetSavedList() > 0 then 
		WardrobeCollectionFrame.progressBar:SetWidth(130)
		WardrobeCollectionFrame.progressBar.border:SetWidth(139)
		WardrobeCollectionFrame.progressBar:ClearAllPoints()
		WardrobeCollectionFrame.progressBar:SetPoint("TOPLEFT", WardrobeCollectionFrame.ItemsTab, "TOPLEFT", 280, -11)

		--WardrobeCollectionFrame.searchBox:ClearAllPoints()

		--WardrobeCollectionFrame.searchBox:SetPoint("TOPLEFT", 59, -69)

		WardrobeCollectionFrame.searchBox:SetWidth(90)
		BW_WardrobeCollectionFrameTab4:Show()
		WardrobeCollectionFrame.FilterButton:SetWidth(83)
	end

	addon.setdb.global.sets[addon.setdb:GetCurrentProfile()] = addon.GetSavedList()
	addon.selectedArmorType = addon.Globals.CLASS_INFO[playerClass][3]
--SetsDataProvider:GetBaseSets()
	addon.BuildClassArtifactAppearanceList()
end


function BW_WardrobeCollectionFrame_OnHide(self)
	self:UnregisterEvent("UNIT_MODEL_CHANGED")
	self:UnregisterEvent("TRANSMOG_SEARCH_UPDATED")

	--C_TransmogCollection.EndSearch()
	self.jumpToVisualID = nil
	for i, frame in ipairs(BW_WardrobeCollectionFrame.ContentFrames) do
		frame:Hide()
	end

	WardrobeCollectionFrame.selectedTransmogTab = TAB_ITEMS
	BW_WardrobeCollectionFrame.selectedTransmogTab = TAB_ITEMS

	WardrobeCollectionFrame.selectedCollectionTab = TAB_ITEMS
	BW_WardrobeCollectionFrame.selectedCollectionTab = TAB_ITEMS

	addon:InitTables()
	SetsDataProvider:ClearSets()
	addon:ClearCache()
	addon.selectedArmorType = addon.Globals.CLASS_INFO[playerClass][3]

		addon.sortDB.sortDropdown = 1
		BW_UIDropDownMenu_SetSelectedValue(BW_SortDropDown, 1)
 		BW_UIDropDownMenu_SetText(BW_SortDropDown, COMPACT_UNIT_FRAME_PROFILE_SORTBY.." "..L[1])
end


function BetterWardrobeSetsCollectionMixin:HandleKey(key)
	if BW_WardrobeCollectionFrame.selectedCollectionTab == 4 then
		if (not self:GetSelectedSavedSetID()) then
			return false
		end
	else
		if (not self:GetSelectedSetID()) then
			return false
		end
	end

	local selectedSetID

	if BW_WardrobeCollectionFrame.selectedCollectionTab == 4 then
		selectedSetID = self:GetSelectedSavedSetID()
	else
		selectedSetID = self:GetSelectedSetID()
	end


	local _, index = SetsDataProvider:GetBaseSetByID(selectedSetID)
	if (not index) then
		return
	end

	if (key == WARDROBE_DOWN_VISUAL_KEY) then
		index = index + 1
	elseif (key == WARDROBE_UP_VISUAL_KEY) then
		index = index - 1
	end

	local sets = SetsDataProvider:GetBaseSets()
	index = Clamp(index, 1, #sets)
	self:SelectSet(sets[index].setID)
	self:ScrollToSet(sets[index].setID)
end


function BetterWardrobeSetsCollectionMixin:ScrollToSet(setID)
	local totalHeight = 0
	local scrollFrameHeight = self.ScrollFrame:GetHeight()
	local buttonHeight = self.ScrollFrame.buttonHeight
	for i, set in ipairs(SetsDataProvider:GetBaseSets()) do
		if (set.setID == setID) then
			local offset = self.ScrollFrame.scrollBar:GetValue()
			if (totalHeight + buttonHeight > offset + scrollFrameHeight) then
				offset = totalHeight + buttonHeight - scrollFrameHeight
			elseif (totalHeight < offset) then
				offset = totalHeight
			end
			self.ScrollFrame.scrollBar:SetValue(offset, true)
			break
		end
		totalHeight = totalHeight + buttonHeight
	end
end


function BW_WardrobeCollectionFrame_OnKeyDown(self, key)
	if (self.tooltipCycle and key == WARDROBE_CYCLE_KEY) then
		self:SetPropagateKeyboardInput(false)
		if (IsShiftKeyDown()) then
			self.tooltipSourceIndex = self.tooltipSourceIndex - 1
		else
			self.tooltipSourceIndex = self.tooltipSourceIndex + 1
		end
		self.tooltipContentFrame:RefreshAppearanceTooltip()
	elseif (key == WARDROBE_PREV_VISUAL_KEY or key == WARDROBE_NEXT_VISUAL_KEY or key == WARDROBE_UP_VISUAL_KEY or key == WARDROBE_DOWN_VISUAL_KEY) then
		if (self.activeFrame:CanHandleKey(key)) then
			self:SetPropagateKeyboardInput(false)
			self.activeFrame:HandleKey(key)
		else
			self:SetPropagateKeyboardInput(true)
		end
	else
		self:SetPropagateKeyboardInput(true)
	end
end


function addon.Sets:SelectedVariant(setID)
	local baseSetID = C_TransmogSets.GetBaseSetID(setID) --or setID
	if not baseSetID then return end

	local variantSets = SetsDataProvider:GetVariantSets(baseSetID)
	if not variantSets then return end
	
	local useDescription = (#variantSets > 0)
	local targetSetID = WardrobeCollectionFrame.SetsCollectionFrame:GetDefaultSetIDForBaseSet(baseSetID)
	local match = false

	for i, data in ipairs(variantSets) do
		if addon.CollectionList:IsInList (data.setID, "set") then
			match = data.setID
		end
	end

	if useDescription then
		local setInfo = C_TransmogSets.GetSetInfo(targetSetID)
		local matchInfo = match and C_TransmogSets.GetSetInfo(match).description or nil

		return targetSetID, setInfo.description, match, matchInfo
	end
end