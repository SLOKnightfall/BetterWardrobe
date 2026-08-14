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

--Journal items filter dropdown reads these; kept separate from addon.Profile.SetSortMode (sets tab) and addon.Profile.ItemSortMode (vendor items tab).
addon.ItemSortMode = {
	Default = DEFAULT,
	Appearance = APPEARANCE,
	Alphabetic = ALPHABETIC,
	Color = COLOR,
	Expansion = EXPANSION,
	ItemSource = ITEM_SOURCE,
	ILevel = ILEVEL,
	ItemID = ITEMID,
}

local TAB_ITEMS = 1
local TAB_SETS = 2
local TAB_EXTRASETS = 3
local TAB_SAVED_SETS = 4

local factionNames = { playerFaction = "", opposingFaction = "" };

local ClassIndex = nil;

local ClassNameMask = {
    [1] = "Warrior",
    [2] = "Paladin",
    [4] = "Hunter",
    [8] = "Rogue",
    [16] = "Priest",
    [32] = "Death Knight",
    [64] = "Shaman",
    [128] = "Mage",
    [256] = "Warlock",
    [512]  = "Monk",
    [1024] = "Druid",
    [2048] = "Demon Hunter",
    [4096] = "Evoker",
}
local ClassNameLookupMask = {
    [1] = "WARRIOR",
    [2] = "PALADIN",
    [4] = "HUNTER",
    [8] = "ROGUE",
    [16] = "PRIEST",
    [32] = "DEATHKNIGHT",
    [64] = "SHAMAN",
    [128] = "MAGE",
    [256] = "WARLOCK",
    [512] = "MONK",
    [1024] = "DRUID",
    [2048] = "DEMONHUNTER",
    [4096] = "EVOKER",
}
local ClassToMask = {
    [1] = 1,
    [2] = 2,
    [3] = 4,
    [4] = 8,
    [5] = 16,
    [6] = 32,
    [7] = 64,
    [8] = 128,
    [9] = 256,
    [10] = 512,
    [11] = 1024,
    [12] = 2048,
    [13] = 4096,
}
local ClassArmorType = {
    [1]  = 4, --[1]  = 1, --[1] =    
    [2]  = 4, --[2]  = 1, --[2] =    
    [3]  = 3, --[3]  = 2, --[4] =    
    [4]  = 2, --[4]  = 3, --[8] =    
    [5]  = 1, --[5]  = 4, --[16] =   
    [6]  = 4, --[6]  = 1, --[32] =   
    [7]  = 3, --[7]  = 2, --[64] =   
    [8]  = 1, --[8]  = 4, --[128] =  
    [9]  = 1, --[9]  = 4, --[256] =  
    [10] = 2, --[10] = 3, --[512] =  
    [11] = 2, --[11] = 3, --[1024] = 
    [12] = 2, --[12] = 3, --[2048] = 
    [13] = 3,
}
local ClassArmorMask = {
    [1]  = {1, 35},
    [2]  = {2, 35},
    [3]  = {4, 4164},
    [4]  = {8, 3592, 11784},
    [5]  = {16, 400},
    [6]  = {32, 35},
    [7]  = {64, 4164},
    [8]  = {128, 400},
    [9]  = {256, 400},
    [10] = {512, 3592, 11784},
    [11] = {1024, 3592, 11784},
    [12] = {2048, 3592, 11784},
    [13] = {4096, 4164},
}


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

--Wraps a table.sort comparator so the Journal items "Reverse" checkbox can flip any sort mode without touching its comparison logic.
local function ReverseComparator(comparator, reverse)
	if not reverse then return comparator end
	return function(a, b) return comparator(b, a) end
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

--Shared by the Journal's Color sort and the vendor's "Sort By > Color"; returns true/false once the visuals are distinguishable, nil if the caller should fall back to its own tie-break (e.g. uiOrder).
function addon:CompareItemColor(visualID1, visualID2)
	if not C_AddOns.IsAddOnLoaded("BetterWardrobe_SourceData") then
		C_AddOns.EnableAddOn("BetterWardrobe_SourceData")
		C_AddOns.LoadAddOn("BetterWardrobe_SourceData")
	end

	local ColorTable = (_G.BetterWardrobeData and _G.BetterWardrobeData.ColorTable) or {}
	local ItemAppearance = (_G.BetterWardrobeData and _G.BetterWardrobeData.ItemAppearance) or {}
	local color1 = ColorTable[visualID1]
	local color2 = ColorTable[visualID2]
	local file1 = ItemAppearance[visualID1]
	local file2 = ItemAppearance[visualID2]

	if file1 and file2 then
		local index1 = FindColorInFile(file1)
		local index2 = FindColorInFile(file2)

		if index1 ~= index2 then
			return SortOrder(index2, index1)
		end
	end

	if color1 and color2 then
		local color1diff = GetColor2Diff(color1)
		local color2diff = GetColor2Diff(color2)

		if color1diff ~= color2diff then
			return SortOrder(color2, color1)
		end
	end

	return nil
end

local function SortColor(sets)
	local comparison = function(source1, source2)
		if not source1 or not source2 then
			return
		end

		local result = addon:CompareItemColor(source1.visualID, source2.visualID)
		if result ~= nil then
			return result
		end

		if (source1.uiOrder and source2.uiOrder) then
			return SortOrder(source2.uiOrder, source1.uiOrder)
		end
	end

	table.sort(sets, ReverseComparator(comparison, addon.Profile.JournalItemSortReverse))
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


 function addon:CacheCategory(self)
	local Wardrobe = BetterWardrobeCollectionFrame.ItemsCollectionFrame
	for _, data in pairs(self.filteredVisualsList) do
		local id = data.visualID
		local sources = CollectionWardrobeUtil.GetSortedAppearanceSources(id, self:GetActiveCategory(), self:GetTransmogLocation())
		if sources[1] then
			local itemID = sources[1].itemID
			local item = Item:CreateFromItemID(itemID)

			item:ContinueOnItemLoad(function()
				local name = item:GetItemName()
				local ilevel = item:GetCurrentItemLevel()
				local itemID = item:GetItemID()
				itemCache[id] = {["name"] = name, ["ilevel"] = ilevel, ["itemID"] = itemID}
			end)
		end
	end
	categoryCached[Wardrobe:GetActiveCategory()] = true
end


local function SortItemAlphabetic(self)

	if not categoryCached[self:GetActiveCategory()] then
		addon:CacheCategory(self)
		C_Timer.After(.5, function()SortItemAlphabetic(self) end)
			return false
	end
	if BetterWardrobeCollectionFrame.ItemsCollectionFrame:IsVisible() then
		C_Timer.After(.1, function()
				local comparison = function(source1, source2)
					local entry1 = itemCache[source1.visualID]
					local entry2 = itemCache[source2.visualID]
					local item1 = entry1 and entry1.name
					local item2 = entry2 and entry2.name
					if item1 and item2 then
						return SortOrder(item2, item1)
					else
						return SortOrder(source2.uiOrder, source1.uiOrder)
					end
				end
			table.sort(BetterWardrobeCollectionFrame.ItemsCollectionFrame:GetFilteredVisualsList(), ReverseComparator(comparison, addon.Profile.JournalItemSortReverse))

			BetterWardrobeCollectionFrame.ItemsCollectionFrame:UpdateItems()
		end)
	end
end


local function SortItemByILevel(self)
	if not categoryCached[self:GetActiveCategory()] then
		addon:CacheCategory(self)
	end

	if BetterWardrobeCollectionFrame.ItemsCollectionFrame:IsVisible() then
		C_Timer.After(.0, function()
			local comparison = function(source1, source2)
				local entry1 = itemCache[source1.visualID]
				local entry2 = itemCache[source2.visualID]
				local itemLevel1 = entry1 and entry1.ilevel
				local itemLevel2 = entry2 and entry2.ilevel

				if itemLevel1 and itemLevel2 and itemLevel1 ~= itemLevel2 then
					return SortOrder(itemLevel1, itemLevel2)
				else
					return SortOrder(source1.uiOrder, source2.uiOrder)
				end
			end
			table.sort(BetterWardrobeCollectionFrame.ItemsCollectionFrame:GetFilteredVisualsList(), ReverseComparator(comparison, addon.Profile.JournalItemSortReverse))

			BetterWardrobeCollectionFrame.ItemsCollectionFrame:UpdateItems()
		end)
	end
end

local function SortItemByItemID(self)
	if not categoryCached[self:GetActiveCategory()] then
		addon:CacheCategory(self)
	end

	if BetterWardrobeCollectionFrame.ItemsCollectionFrame:IsVisible() then
		C_Timer.After(.1, function()
			local comparison = function(source1, source2)
				local entry1 = itemCache[source1.visualID]
				local entry2 = itemCache[source2.visualID]
				local item1 = entry1 and entry1.itemID
				local item2 = entry2 and entry2.itemID

				if item1 and item2 and item1 ~= item2 then
					return SortOrder(item1, item2)
				end
				return SortOrder(source1.uiOrder, source2.uiOrder)
			end
			table.sort(BetterWardrobeCollectionFrame.ItemsCollectionFrame:GetFilteredVisualsList(), ReverseComparator(comparison, addon.Profile.JournalItemSortReverse))

			BetterWardrobeCollectionFrame.ItemsCollectionFrame:UpdateItems()
		end)
	end
end

--GetAppearanceSourceInfo returns a single info table now, not multiple positional returns.
local function GetTopSourceForVisual(visualID)
	local sourceInfo = C_TransmogCollection.GetAppearanceSourceInfo(visualID)
	local itemLink = sourceInfo and sourceInfo.itemLink
	if not itemLink then return {} end

	return CollectionWardrobeUtil.GetSortedAppearanceSources(visualID, addon.GetItemCategory(visualID), addon.GetTransmogLocation(itemLink))[1] or {}
end

--Shared by the Journal and vendor Expansion sorts; nil until the item's data has loaded.
local function GetItemExpansionID(itemID)
	if not itemID or itemID == 0 then return nil end
	C_Item.RequestLoadItemDataByID(itemID)
	return select(15, C_Item.GetItemInfo(itemID))
end
addon.GetItemExpansionID = GetItemExpansionID

local function SortItemByExpansion(sets)
	local comparison = function(source1, source2)
		local item1 = GetTopSourceForVisual(source1.visualID)
		local item2 = GetTopSourceForVisual(source2.visualID)
		item1.itemID = item1.itemID or 0
		item2.itemID = item2.itemID or 0
		C_Item.RequestLoadItemDataByID(item1.itemID)
		C_Item.RequestLoadItemDataByID(item2.itemID)
		local GetItemInfo = C_Item and C_Item.GetItemInfo
		item1.expansionID = select(15,  C_Item.GetItemInfo(item1.itemID)) 
		item2.expansionID = select(15,  C_Item.GetItemInfo(item2.itemID))

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

	table.sort(sets, ReverseComparator(comparison, addon.Profile.JournalItemSortReverse))
end

local function SortItemByAppearance(self)
	local comparison = function(source1, source2)
		if not C_AddOns.IsAddOnLoaded("BetterWardrobe_SourceData") then
			C_AddOns.LoadAddOn("BetterWardrobe_SourceData")
			C_AddOns.EnableAddOn("BetterWardrobe_SourceData")
		end
		local ItemAppearance = (_G.BetterWardrobeData and _G.BetterWardrobeData.ItemAppearance) or {}

		if ItemAppearance[source1.visualID] and ItemAppearance[source2.visualID] then
			return SortOrder(ItemAppearance[source1.visualID], ItemAppearance[source2.visualID])
		else
			return SortOrder(source1.uiOrder, source2.uiOrder)
		end
	end

	table.sort(self.filteredVisualsList, ReverseComparator(comparison, addon.Profile.JournalItemSortReverse))
end

local function SortByItemSource(self)
	local comparison = function(source1, source2)
		local item1 = GetTopSourceForVisual(source1.visualID)
		local item2 = GetTopSourceForVisual(source2.visualID)
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
				if not C_AddOns.IsAddOnLoaded("BetterWardrobe_SourceData") then
					C_AddOns.EnableAddOn("BetterWardrobe_SourceData")
					C_AddOns.LoadAddOn("BetterWardrobe_SourceData")
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

	table.sort(self.filteredVisualsList, ReverseComparator(comparison, addon.Profile.JournalItemSortReverse))
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
		local groupFavorite1 = (addon.favoritesDB.profile.extraset[set1.setID] or set1.favoriteSetID or set1.favorite ) and true
		local groupFavorite2 = (addon.favoritesDB.profile.extraset[set2.setID] or set2.favoriteSetID or set2.favorite) and true
		if ( groupFavorite1 ~= groupFavorite2 ) then
			return groupFavorite1
		end

		if set1.label ~= set2.label then
			if set1.label == "Special" then return true; end
			if set2.label == "Special" then return false; end
			if set1.label == "Trading Post" then return true; end
			if set2.label == "Trading Post" then return false; end
			if set1.label == "Holiday" then return true; end
			if set2.label == "Holiday" then return false; end
		end
		if ( set1.expansionID ~= set2.expansionID ) then
			return SortOrder(set1.expansionID, set2.expansionID)
		end
		
		if not ignorePatchID and set1.patchID and set2.patchID then
			if ( set1.patchID ~= set2.patchID ) then
				return set1.patchID > set2.patchID;
			end
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
		if not C_AddOns.IsAddOnLoaded("BetterWardrobe_SourceData") then
			C_AddOns.EnableAddOn("BetterWardrobe_SourceData")
			C_AddOns.LoadAddOn("BetterWardrobe_SourceData")
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
				
		if not ignorePatchID and set1.patchID and set2.patchID then
			if ( set1.patchID ~= set2.patchID ) then
				return set1.patchID > set2.patchID;
			end
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

function addon.SortVariantSet(sets, reverseUIOrder, ignorePatchID)
 	if not sets  then return end

	local comparison = function(set1, set2)
		local groupFavorite1 = set1.favoriteSetID and true;
		local groupFavorite2 = set2.favoriteSetID and true;
		if ( groupFavorite1 ~= groupFavorite2 ) then
--return groupFavorite1;
		end
		if ( set1.favorite ~= set2.favorite ) then
			--return set1.favorite;
		end

			----if ( set1.requiredFaction and set1.requiredFaction ~= set2.requiredFaction) then
			----	if (set1.requiredFaction == factionNames.playerFaction) then
				----	return true;
				----elseif (set2.requiredFaction == factionNames.playerFaction) then
				-----	return false;
				----elseif (set1.requiredFaction == nil) then
				----	return true;
				----else
				----	return false;
				----end
			----end

			--[[
			if ( set1.classMask and set1.classMask ~= set2.classMask ) then
				if ClassNameMask[set1.classMask] == nil and ClassNameMask[set2.classMask] ~= nil then return true;  end
				if ClassNameMask[set2.classMask] == nil and ClassNameMask[set1.classMask] ~= nil then return false; end
				if set1.classMask == ClassToMask[ClassIndex] then return true; end
				if set2.classMask == ClassToMask[ClassIndex] then return false; end
				return set1.classMask < set2.classMask;
			end
]]--

		if ( set1.expansionID ~= set2.expansionID ) then
			return set1.expansionID > set2.expansionID;
		end
		if not ignorePatchID then
			if ( set1.patchID ~= set2.patchID ) then
				return set1.patchID > set2.patchID;
			end
		end
		if ( set1.uiOrder and set2.uiOrder and set1.uiOrder ~= set2.uiOrder ) then
			if ( reverseUIOrder ) then
				return set1.uiOrder < set2.uiOrder;
			else
				return set1.uiOrder > set2.uiOrder;
			end
		end
		if reverseUIOrder then
			return set1.setID < set2.setID;
		else
			return set1.setID > set2.setID;
		end
	end

	table.sort(sets, comparison);

end

function addon.SortDropdown(sets)
 	if not sets  then return end
	SortSavedSets(self, sets, false, true)
end