--Based off of code from WardrobeSort - https://www.curseforge.com/wow/addons/wardrobesort

local addonName, addon = ...
--addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

local f = addon.frame
local itemCache = {}
local ilevelCache = {}
local categoryCached = {}
local categoryilevelCached = {}
local DEFAULT = 1
local APPEARANCE = 2
local ALPHABETIC = 3
local COLOR = 4
local EXPANSION = 5
local ITEM_SOURCE = 6

local ILEVEL = 8
local ITEMID = 9
local ARTIFACT = 7

local TAB_ITEMS = 1
local TAB_SETS = 2
local TAB_EXTRASETS = 3
local TAB_SAVED_SETS = 4


local function GetTab(tab)
		local atTransmogrifier = C_Transmog.IsAtTransmogNPC();
	local tabID

	if ( atTransmogrifier ) then
		tabID = BetterWardrobeCollectionFrame.selectedTransmogTab
	else
		tabID = BetterWardrobeCollectionFrame.selectedCollectionTab
	end
	return tabID, atTransmogrifier

end
addon.GetTab = GetTab

local function CheckTab(tab)
	local tabID
		local atTransmogrifier = C_Transmog.IsAtTransmogNPC();

		if ( atTransmogrifier ) then
			tabID = BetterWardrobeCollectionFrame.selectedTransmogTab
		else
			tabID = BetterWardrobeCollectionFrame.selectedCollectionTab
		end
	return tabID == tab
end
addon.CheckTab = CheckTab

local function SortOrder(a, b)
	if not a or not b then return end
	if IsModifierKeyDown() then 
		return a < b
	else
		return a > b
	end
end

local labA, labB, labC = addon:ConvertRGB_to_LAB(0, 0, 0)
local function GetColor2Diff(color)
	local _, colors = addon:Deserialize(color)
	local baseColor = colors[1]
	local c = 1
	local cR = baseColor[c + 0]
	local cG = baseColor[c + 1]
	local cB = baseColor[c + 2]

	if cR and cG and cB then
		return addon:CompareLAB(labA, labB, labC, addon:ConvertRGB_to_LAB(cR, cG, cB))
	end

end

local function FindColorInFile(file)
	local colors = addon.Globals.colors
	local index = 0
	for k, data in pairs(colors) do
		index = index + 1
		if strfind(file, k) then
			return index
		end
	end	
end

local function SortColor(sets)
	local comparison = function(source1, source2)
		if not IsAddOnLoaded("BetterWardrobe_SourceData") then
			EnableAddOn("BetterWardrobe_SourceData")
			LoadAddOn("BetterWardrobe_SourceData")
		end

		if not source1 or not source2 then
			return
		end

		local colors = addon.Globals.colors
		local ColorTable = (_G.BetterWardrobeData and _G.BetterWardrobeData.ColorTable) or {}
		local color1 = ColorTable[source1.visualID]
		local color2 = ColorTable[source2.visualID]
		local file1 = addon.ItemAppearance[source1.visualID]
		local file2 = addon.ItemAppearance[source2.visualID]
		local index1, index2

		if file1 and file2 then
			index1 = FindColorInFile(file1)
			index2 = FindColorInFile(file2)

			if index1 ~= index2 then
				return SortOrder(index2, index1)
			end
		end

		if color1 and color2 then
			local index1 = #colors + 1
			local color1diff = GetColor2Diff(color1)
			local color2diff = GetColor2Diff(color2)

			if color1diff ~= color2diff then
				return SortOrder(color2, color1)
			end
		end

		if (source1.uiOrder and source2.uiOrder) then
			return SortOrder(source2.uiOrder, source1.uiOrder)
		end
	end

	table.sort(sets, comparison)
end

local function SortItemDefault(self)
	if not self then return end

	local comparison = function(source1, source2)
		if (source1.isCollected ~= source2.isCollected) then
			return source1.isCollected
		end

		if (source1.isUsable ~= source2.isUsable) then
			return source1.isUsable
		end

		if (source1.isFavorite ~= source2.isFavorite) then
			return source1.isFavorite
		end

		if (addon:IsFavoriteItem(source1.visualID) ~= addon:IsFavoriteItem(source2.visualID)) then
			return addon:IsFavoriteItem(source1.visualID)
		end

		if (source1.isHideVisual ~= source2.isHideVisual) then
			return source1.isHideVisual
		end

		if (source1.hasActiveRequiredHoliday ~= source2.hasActiveRequiredHoliday) then
			return source1.hasActiveRequiredHoliday
		end

		if (source1.uiOrder and source2.uiOrder) then
			return SortOrder(source1.uiOrder, source2.uiOrder)
		end

		return SortOrder(source1.sourceID, source2.sourceID)
	end

	table.sort(self.filteredVisualsList, comparison)
end


local function CacheCategory(self)
	local Wardrobe = BetterWardrobeCollectionFrame.ItemsCollectionFrame
	for _, data in pairs(self.filteredVisualsList) do
		local id = data.visualID
		local sources =  CollectionWardrobeUtil.GetSortedAppearanceSources(id) --C_TransmogCollection.GetAppearanceSources(id)
		local itemID = sources[1].itemID
		local item = Item:CreateFromItemID(itemID)

		item:ContinueOnItemLoad(function()
			local name = item:GetItemName() 
			local ilevel = item:GetCurrentItemLevel() 
			local itemID = item:GetItemID()
			itemCache[id] = {["name"] = name, ["ilevel"] = ilevel, ["itemID"] = itemID}
		end)
	end
	categoryCached[Wardrobe:GetActiveCategory()] = true
end


local function SortItemAlphabetic(self)
	if not categoryCached[self:GetActiveCategory()] then
		CacheCategory(self)
	end

	if BetterWardrobeCollectionFrame.ItemsCollectionFrame:IsVisible() then
		C_Timer.After(.0, function()
				local comparison = function(source1, source2)
					local item1 = itemCache[source1.visualID].name
					local item2 = itemCache[source2.visualID].name
					if item1 and item2 then
						return SortOrder(item2, item1)
					else
						return SortOrder(source2.uiOrder, source1.uiOrder)
					end
				end
			table.sort(BetterWardrobeCollectionFrame.ItemsCollectionFrame:GetFilteredVisualsList(), comparison)

			BetterWardrobeCollectionFrame.ItemsCollectionFrame:UpdateItems()
		end)
	end
end


local function SortItemByILevel(self)
	if not categoryCached[self:GetActiveCategory()] then
		CacheCategory(self)
	end

	if BetterWardrobeCollectionFrame.ItemsCollectionFrame:IsVisible() then
		C_Timer.After(.0, function()
			local comparison = function(source1, source2)
				local itemLevel1 = itemCache[source1.visualID].ilevel
				local itemLevel2 = itemCache[source2.visualID].ilevel

				if itemLevel1 ~= itemLevel2 then
					return SortOrder(itemLevel1, itemLevel2)
				else
					return SortOrder(source1.uiOrder, source2.uiOrder)
				end
			end
			table.sort(BetterWardrobeCollectionFrame.ItemsCollectionFrame:GetFilteredVisualsList(), comparison)

			BetterWardrobeCollectionFrame.ItemsCollectionFrame:UpdateItems()
		end)
	end
end

local function SortItemByItemID(self)
	if not categoryCached[self:GetActiveCategory()] then
		CacheCategory(self)
	end

	if BetterWardrobeCollectionFrame.ItemsCollectionFrame:IsVisible() then
		C_Timer.After(.1, function()
			local comparison = function(source1, source2)
				local item1 = itemCache[source1.visualID].itemID
				local item2 = itemCache[source2.visualID].itemID

				if item1 ~= item2 then
					return SortOrder(item1, item2)
				end
			end
			table.sort(BetterWardrobeCollectionFrame.ItemsCollectionFrame:GetFilteredVisualsList(), comparison)

			BetterWardrobeCollectionFrame.ItemsCollectionFrame:UpdateItems()
		end)
	end
end

local function SortItemByExpansion(sets)
	local comparison = function(source1, source2)
		local _, visualID, _, _, _, itemLink = C_TransmogCollection.GetAppearanceSourceInfo(source1.visualID)	
		local item1 = (itemLink and CollectionWardrobeUtil.GetSortedAppearanceSources(source1.visualID,addon.GetItemCategory(source1.visualID), addon.GetTransmogLocation(itemLink))[1]) or {}

		local _, visualID, _, _, _, itemLink = C_TransmogCollection.GetAppearanceSourceInfo(source2.visualID)	
		local item2 = (itemLink and CollectionWardrobeUtil.GetSortedAppearanceSources(source2.visualID,addon.GetItemCategory(source2.visualID), addon.GetTransmogLocation(itemLink))[1]) or {}
		item1.itemID = item1.itemID or 0
		item2.itemID = item2.itemID or 0
		C_Item.RequestLoadItemDataByID(item1.itemID)
		C_Item.RequestLoadItemDataByID(item2.itemID)
		item1.expansionID = select(15,  GetItemInfo(item1.itemID)) 
		item2.expansionID = select(15,  GetItemInfo(item2.itemID))

		if item1.expansionID and item1.expansionID then
			if ( item1.expansionID ~= item2.expansionID ) then
				return SortOrder(item2.expansionID, item1.expansionID)
			end
		else
			return SortOrder(source1.uiOrder, source2.uiOrder)
		end

		if item1.name  and item2.name then 
			return SortOrder(item2.name, item1.name)
		end
	end

	table.sort(sets, comparison)
end

local function SortItemByAppearance(self)
	local comparison = function(source1, source2)
		if not IsAddOnLoaded("BetterWardrobe_SourceData") then
			LoadAddOn("BetterWardrobe_SourceData")
			EnableAddOn("BetterWardrobe_SourceData")
		end
		local ItemAppearance = (_G.BetterWardrobeData and _G.BetterWardrobeData.ItemAppearance) or {}

		if ItemAppearance[source1.visualID] and ItemAppearance[source2.visualID] then
			return SortOrder(ItemAppearance[source1.visualID], ItemAppearance[source2.visualID])
		else
			return SortOrder(source1.uiOrder, source2.uiOrder)
		end
	end

	table.sort(self.filteredVisualsList, comparison)
end

local function SortByItemSource(self)
	local comparison = function(source1, source2)
		local _, visualID, _, _, _, itemLink = C_TransmogCollection.GetAppearanceSourceInfo(source1.visualID)	
		local item1 = (itemLink and CollectionWardrobeUtil.GetSortedAppearanceSources(source1.visualID,addon.GetItemCategory(source1.visualID), addon.GetTransmogLocation(itemLink))[1]) or {}

		local _, visualID, _, _, _, itemLink = C_TransmogCollection.GetAppearanceSourceInfo(source2.visualID)	
		local item2 = (itemLink and CollectionWardrobeUtil.GetSortedAppearanceSources(source2.visualID,addon.GetItemCategory(source2.visualID), addon.GetTransmogLocation(itemLink))[1]) or {}
		item1.sourceType = item1.sourceType or 7
		item2.sourceType = item2.sourceType or 7
				
		if item1.sourceType == item2.sourceType then
			if item1.sourceType == TRANSMOG_SOURCE_BOSS_DROP then
				local drops1 = C_TransmogCollection.GetAppearanceSourceDrops(item1.sourceID) or {}
				local drops2 = C_TransmogCollection.GetAppearanceSourceDrops(item2.sourceID) or {}
				
				if #drops1 > 0 and #drops2 > 0 then
					local instance1, encounter1 = drops1[1].instance, drops1[1].encounter
					local instance2, encounter2 = drops2[1].instance, drops2[1].encounter
					
					if instance1 == instance2 then
						return SortOrder(encounter1, encounter2)
					else
						return SortOrder(instance1, instance2)
					end
				end
			else
				if not IsAddOnLoaded("BetterWardrobe_SourceData") then
					EnableAddOn("BetterWardrobe_SourceData")
					LoadAddOn("BetterWardrobe_SourceData")
				end
				local ItemAppearance = (_G.BetterWardrobeData and _G.BetterWardrobeData.ItemAppearance) or {}
				--local ItemAppearance = addon.ItemAppearance or {}

				if ItemAppearance[source1.visualID] and ItemAppearance[source2.visualID] then
					return SortOrder(ItemAppearance[source1.visualID], ItemAppearance[source2.visualID])
				end
			end
		else
			return SortOrder(item1.sourceType, item2.sourceType)
		end

		return SortOrder(source1.uiOrder, source2.uiOrder)
	end

	table.sort(self.filteredVisualsList, comparison)
end


local ITEM_SORTING = {
	[DEFAULT] = function(self)
		SortItemDefault(self)
	end,
	
	[APPEARANCE] = function(self)
		SortItemByAppearance(self)
	end,
	
	[ALPHABETIC] = function(self)
		SortItemAlphabetic(self)
	end,
	
	[ITEM_SOURCE] = function(self)
		SortByItemSource(self)
	end,
	
	-- sort by the color in filename
	[COLOR] = function(self)
		SortColor(self.filteredVisualsList)
	end,

	[EXPANSION] = function(self,sets)
		SortItemByExpansion(self.filteredVisualsList)
	end,

	[ILEVEL] = function(self)
		SortItemByILevel(self) 
	end,

	[ITEMID] = function(self)
		SortItemByItemID(self)
	end,

	[ARTIFACT] = function(self)
		if not self then return end

		local artifactList = {}
		for i, data in ipairs(self.filteredVisualsList) do
			local sourceID = BetterWardrobeCollectionFrame.ItemsCollectionFrame:GetAnAppearanceSourceFromVisual(data.visualID)
			local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
			if sourceInfo and sourceInfo.quality == 6 then
				tinsert(artifactList,data)
			end
		end
		self.filteredVisualsList =  artifactList
	end,
}

local function SortSavedSets(self, sets)
	local comparison = function(set1, set2)
		local groupFavorite1 = (addon.favoritesDB.profile.extraset[set1.setID] or set1.favoriteSetID) and true
		local groupFavorite2 = (addon.favoritesDB.profile.extraset[set2.setID] or set2.favoriteSetID) and true
		if ( groupFavorite1 ~= groupFavorite2 ) then
			return groupFavorite1
		end

		return SortOrder(set2.uiOrder, set1.uiOrder)
	end

	table.sort(sets, comparison)
end

local function SortSavedSetsAlphabetical(self, sets)
	local comparison = function(set1, set2)
		local groupFavorite1 = (addon.favoritesDB.profile.extraset[set1.setID] or set1.favoriteSetID) and true
		local groupFavorite2 = (addon.favoritesDB.profile.extraset[set2.setID] or set2.favoriteSetID) and true
		if ( groupFavorite1 ~= groupFavorite2 ) then
			return groupFavorite1
		end

		return SortOrder(string.lower(set1.name), string.lower(set2.name))
	end

	table.sort(sets, comparison)
end

local function SortDefault(sets)
	local comparison = function(set1, set2)	
		local groupFavorite1 = (addon.favoritesDB.profile.extraset[set1.setID] or set1.favoriteSetID) and true
		local groupFavorite2 = (addon.favoritesDB.profile.extraset[set2.setID] or set2.favoriteSetID) and true
		if ( groupFavorite1 ~= groupFavorite2 ) then
			return groupFavorite1
		end

		if ( set1.expansionID ~= set2.expansionID ) then
			return SortOrder(set1.expansionID, set2.expansionID)
		end
		
		if ( set1.expansionID ~= set2.expansionID ) then
			return SortOrder(set1.expansionID, set2.expansionID)
		end

		if ( set1.uiOrder ~= set2.uiOrder ) then
			return SortOrder(set1.uiOrder, set2.uiOrder)
		end

		return SortOrder(set1.name, set2.name)
	end

	table.sort(sets, comparison)
end

local function SortSetAlphabetic(sets)
	local comparison = function(set1, set2)

		if ( set1.favorite ~= set2.favorite ) then
			return set1.favorite
		end

		return SortOrder(set2.name, set1.name)
	end

	table.sort(sets, comparison)
end

local function SortSetByAppearance(sets) 
	local comparison = function(source1, source2)
		if not IsAddOnLoaded("BetterWardrobe_SourceData") then
			EnableAddOn("BetterWardrobe_SourceData")
			LoadAddOn("BetterWardrobe_SourceData")
		end
		local ItemAppearance = (_G.BetterWardrobeData and _G.BetterWardrobeData.ItemAppearance) or {}
		--local ItemAppearance = addon.ItemAppearance or {}

		if ItemAppearance[source1.visualID] and ItemAppearance[source2.visualID] then
			return SortOrder(ItemAppearance[source1.visualID], ItemAppearance[source2.visualID])
		else
			return SortOrder(source1.uiOrder, source2.uiOrder)
		end
	end

	table.sort(sets, comparison)
end

local function SortSetByExpansion(sets) 
	local comparison = function(set1, set2)
		local groupFavorite1 = (addon.favoritesDB.profile.extraset[set1.setID] or set1.favoriteSetID) and true
		local groupFavorite2 = (addon.favoritesDB.profile.extraset[set2.setID] or set2.favoriteSetID) and true
		if ( groupFavorite1 ~= groupFavorite2 ) then
			return groupFavorite1
		end

		if ( set1.expansionID ~= set2.expansionID ) then
			return SortOrder(set1.expansionID, set2.expansionID)
		end

		return SortOrder(set2.name, set1.name)
	end

	table.sort(sets, comparison)
end

local SET_SORTING = {
	[DEFAULT] = function( data)
		SortDefault(data)
	end,

	[ALPHABETIC] = function( data)
		SortSetAlphabetic(data)
	end,

	[APPEARANCE] = function( data)
		SortSetByAppearance(data)
	end,

	[COLOR] = function( data)
		SortColor(data)
	end,

	[ITEM_SOURCE] = function( data)
	end,
	
	[EXPANSION] = function( data)
		SortSetByExpansion(data)
	end,
}

local SAVED_SET_SORTING = {
	[DEFAULT] = function( data)
		SortSavedSets(self, data)
	end,

	[ALPHABETIC] = function( data)
		SortSavedSetsAlphabetical(self, data)
	end,
}

function addon.SortCollection(frame)
	local Wardrobe = BetterWardrobeCollectionFrame.ItemsCollectionFrame

	if CheckTab(1) then 
		Sort[1][addon.sortDB.sortDropdown](Wardrobe)
		Wardrobe:UpdateItems()
	end
end

function addon.SortItems(sortType, sets)
 	if not sets  then return end
	ITEM_SORTING[sortType](sets)
end

function addon.SortSet(sets)
 	if not sets  then return end
 --	if DropDownList1:IsShown() then return end
 	if CheckTab(TAB_ITEMS) then
 		if not ITEM_SORTING[addon.sortDB.sortDropdown] then
 			addon.sortDB.sortDropdown = 1
 		end

		ITEM_SORTING[addon.sortDB.sortDropdown](sets)

 	elseif CheckTab(TAB_SETS) or CheckTab(TAB_EXTRASETS) then 
 		if not SET_SORTING[addon.sortDB.sortDropdown] then
 			addon.sortDB.sortDropdown = 1
 		end
		SET_SORTING[addon.sortDB.sortDropdown](sets)

	elseif CheckTab(TAB_SAVED_SETS) then
		SAVED_SET_SORTING[addon.setdb.profile.sorting](sets)
	end
end

function addon.SortDropdown(sets)
 	if not sets  then return end
	SortSavedSets(self, sets, false, true)
end