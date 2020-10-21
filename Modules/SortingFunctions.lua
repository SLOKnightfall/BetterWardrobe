--Based off of code from WardrobeSort - https://www.curseforge.com/wow/addons/wardrobesort

local addonName, addon = ...
--addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

local f = addon.frame
local Wardrobe = WardrobeCollectionFrame.ItemsCollectionFrame



local nameVisuals, nameCache = {}, {}
local catCompleted, itemLevels = {}, {}
local unknown = {-1}
local LegionWardrobeY = IsAddOnLoaded("LegionWardrobe") and 55 or 5

local LE_DEFAULT = 1
local LE_APPEARANCE = 2
local LE_ALPHABETIC = 3
local LE_COLOR = 4
local LE_EXPANSION = 5
local LE_ITEM_SOURCE = 6

local TAB_ITEMS = 1
local TAB_SETS = 2
local TAB_EXTRASETS = 3
local TAB_SAVED_SETS = 4

local dropdownOrder = {LE_DEFAULT, LE_ALPHABETIC, LE_APPEARANCE, LE_COLOR, LE_EXPANSION, LE_ITEM_SOURCE}

local colors = {
	"red", -- 255, 0, 0
	"crimson", -- 255, 0, 63
	"maroon", -- 128, 0, 0
	"pink", -- 255, 192, 203
	"lavender", -- 230, 230, 250
	"purple", -- 128, 0, 128
	"indigo", -- 75, 0, 130
	
	"blue", -- 0, 0, 255
	"teal", -- 0, 128, 128
	"cyan", -- 0, 255, 255
	
	"green", -- 0, 255, 0
	"yellow", -- 255, 255, 0
	"gold", -- 255, 215, 0
	"orange", -- 255, 128, 0
	"brown", -- 128, 64, 0
	
	"black", -- 0, 0, 0
	"gray", -- 128, 128, 128
	"grey",
	"silver", -- 192, 192, 192
	"white", -- 255, 255, 255
}


local function GetTab(tab)
	local atTransmogrifier = WardrobeFrame_IsAtTransmogrifier()
	local tabID

	if ( atTransmogrifier ) then
		tabID = WardrobeCollectionFrame.selectedTransmogTab
	else
		tabID = WardrobeCollectionFrame.selectedCollectionTab
	end
	return tabID, atTransmogrifier

end
addon.GetTab = GetTab


local function CheckTab(tab)
	local tabID
	local atTransmogrifier = WardrobeFrame_IsAtTransmogrifier()

		if ( atTransmogrifier ) then
			tabID = WardrobeCollectionFrame.selectedTransmogTab
		else
			tabID = WardrobeCollectionFrame.selectedCollectionTab
		end
	return tabID == tab
end
addon.CheckTab = CheckTab


local function SortNormal(a, b)
	if not a or not b then return end
	return a > b
end


local function SortReverse(a, b)
	if not a or not b then return end
	return a < b
end


 -- takes around 5 to 30 onupdates
local function CacheHeaders()
	for k in pairs(nameCache) do
		-- oh my god so much wasted tables
		local appearances = WardrobeCollectionFrame_GetSortedAppearanceSources(k)[1] or {}
		if appearances.name then
			nameVisuals[k] = appearances.name
			nameCache[k] = nil
		end
	end
	
	if not next(nameCache) then
		catCompleted[Wardrobe:GetActiveCategory()] = true
		f:SetScript("OnUpdate", nil)
		addon.Sort.SortItemAlphabetic()
	end
end


local SortOrder = SortNormal
local Sort = {
	["SortDefault"] = function(sets,  ignorePatchID)
		local comparison = function(set1, set2)	
			local groupFavorite1 = (addon.chardb.profile.favorite[set1.setID] or set1.favoriteSetID) and true
			local groupFavorite2 = (addon.chardb.profile.favorite[set2.setID] or set2.favoriteSetID) and true
			if ( groupFavorite1 ~= groupFavorite2 ) then
				return groupFavorite1
			end

			if ( set1.favorite ~= set2.favorite ) then
				return set1.favorite
			end

			if ( set1.expansionID ~= set2.expansionID ) then
				return SortOrder(set1.expansionID, set2.expansionID)
			end

			if not ignorePatchID then
				if ( set1.patchID ~= set2.patchID ) then
					return SortOrder(set1.patchID, set2.patchID)
				end
			end

			if ( set1.uiOrder ~= set2.uiOrder ) then
				return SortOrder(set1.uiOrder, set2.uiOrder)
			end

			return SortOrder(set1.setID, set2.setID)
		end

		table.sort(sets, comparison)
	end,

	["SortItemAlphabetic"] = function()
		if Wardrobe:IsVisible() then -- check if wardrobe is still open after caching is finished
			sort(Wardrobe:GetFilteredVisualsList(), function(source1, source2)
				if nameVisuals[source1.visualID] and nameVisuals[source2.visualID] then
					return SortOrder(nameVisuals[source1.visualID], nameVisuals[source2.visualID])
				else
					return SortOrder(source1.uiOrder, source2.uiOrder)
				end
			end)
			Wardrobe:UpdateItems()
		end
	end,

	["SortSetAlphabetic"] = function(sets, reverseUIOrder, ignorePatchID)
		local comparison = function(set1, set2)

			if ( set1.favorite ~= set2.favorite ) then
				return set1.favorite
			end

			return SortOrder(set1.name, set2.name)
		end

		table.sort(sets, comparison)
	end,

	["SortColor"] = function(sets, reverseUIOrder)
		local comparison = function(source1, source2)
			local file1 = source1.itemAppearance or addon.ItemAppearance[source1.visualID]
			local file2 = source2.itemAppearance or addon.ItemAppearance[source2.visualID]
			
			if file1 and file2 then
				local index1 = #colors+1
				for k, v in pairs(colors) do
					if strfind(file1, v) then
						index1 = k
						break
					end
				end
				
				local index2 = #colors+1
				for k, v in pairs(colors) do
					if strfind(file2, v) then
						index2 = k
						break
					end
				end
				
				if index1 == index2 then
					return SortOrder(file1, file2)
				else
					return SortOrder(index1, index2)
				end

			else
				return SortOrder(source1.uiOrder, source2.uiOrder)
			end
		end

		table.sort(sets, comparison)
	end,

	["SortItemByExpansion"] = function(source1, source2)
		local item1 = WardrobeCollectionFrame_GetSortedAppearanceSources(source1.visualID)[1] or {}
		local item2 = WardrobeCollectionFrame_GetSortedAppearanceSources(source2.visualID)[1] or {}
		item1.itemID = item1.itemID or 0
		item2.itemID = item2.itemID or 0
		item1.expansionID = select(15,  GetItemInfo(item1.itemID)) or -1
		item2.expansionID = select(15,  GetItemInfo(item2.itemID)) or -1

		if ( item1.expansionID ~= item2.expansionID ) then
			return SortOrder(item1.expansionID, item2.expansionID)
		end

		if item1.name  and item2.name then 
			return SortOrder(item1.name, item2.name)
		end
	end,

	["SortSetByExpansion"] = function(sets, reverseUIOrder, ignorePatchID) 
		local comparison = function(set1, set2)
			local groupFavorite1 = set1.favoriteSetID and true
			local groupFavorite2 = set2.favoriteSetID and true

			if ( set1.expansionID ~= set2.expansionID ) then
				return SortOrder(set1.expansionID, set2.expansionID)
			end

			if not ignorePatchID then
				if ( set1.patchID ~= set2.patchID ) then
					return SortOrder(set1.patchID, set2.patchID)
				end
			end

			if ( set1.uiOrder ~= set2.uiOrder ) then
				return SortOrder(set1.uiOrder, set2.uiOrder)
			end

			--if ( set1.setID ~= set2.setID ) then
				--return SortOrder(set1.setID, set2.setID)
			--end

			return SortOrder(set1.name, set2.name)
		end

		table.sort(sets, comparison)
	end,

	[TAB_ITEMS] = {
		[LE_DEFAULT] = function(self)
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
		end,
		
		[LE_APPEARANCE] = function(self)
			sort(self.filteredVisualsList, function(source1, source2)
				if addon.ItemAppearance[source1.visualID] and addon.ItemAppearance[source2.visualID] then
					return SortOrder(addon.ItemAppearance[source1.visualID], addon.ItemAppearance[source2.visualID])
				else
					return SortOrder(source1.uiOrder, source2.uiOrder)
				end
			end)
		end,
		
		[LE_ALPHABETIC] = function(self)
			if catCompleted[self:GetActiveCategory()] then
				addon.Sort.SortItemAlphabetic()
			else
				for _, v in pairs(self.filteredVisualsList) do
					nameCache[v.visualID] = true -- queue data to be cached	
				end
				f:SetScript("OnUpdate", CacheHeaders)
			end
		end,
		
		[LE_ITEM_SOURCE] = function(self)
			sort(self.filteredVisualsList, function(source1, source2)
			local item1 = WardrobeCollectionFrame_GetSortedAppearanceSources(source1.visualID)[1] or {}
			local item2 = WardrobeCollectionFrame_GetSortedAppearanceSources(source2.visualID)[1] or {}
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
					if addon.ItemAppearance[source1.visualID] and addon.ItemAppearance[source2.visualID] then
						return SortOrder(addon.ItemAppearance[source1.visualID], addon.ItemAppearance[source2.visualID])
					end
				end
			else
				return SortOrder(item1.sourceType, item2.sourceType)
			end
			return SortOrder(source1.uiOrder, source2.uiOrder)
		end)

		end,
		
		-- sort by the color in filename
		[LE_COLOR] = function(self)
			addon.Sort.SortColor(self.filteredVisualsList)
		end,

		[LE_EXPANSION] = function(self)
			--C_Timer.After(0, function()	sort(Wardrobe:GetFilteredVisualsList(), addon.Sort.SortItemByExpansion) end )
			sort(self.filteredVisualsList, addon.Sort.SortItemByExpansion) -- Runs twice because some times the first run does not return item info
		end,
	},

	[TAB_SETS] = {
		[LE_DEFAULT] = function(self, sets, reverseUIOrder, ignorePatchID)
			addon.Sort.SortDefault(sets, reverseUIOrder, ignorePatchID)
		end,

		[LE_ALPHABETIC] = function(self, sets, reverseUIOrder, ignorePatchID)
			addon.Sort.SortSetAlphabetic(sets, reverseUIOrder, ignorePatchID)
		end,

		[LE_APPEARANCE] = function(self, sets, reverseUIOrder, ignorePatchID)
			for i, data in ipairs(sets) do
				local setID = data.setID
				local sources = C_TransmogSets.GetSetSources(setID)  --[{sourceID =collected}]
				local sourceID

				for i,d in pairs(sources) do
				 	sourceID = i
					 break
				end
			
				local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
				data.visualID = sourceInfo.visualID
			end

			sort(sets, function(source1, source2)
					if addon.ItemAppearance[source1.visualID] and addon.ItemAppearance[source2.visualID] then
						return SortOrder(addon.ItemAppearance[source1.visualID], addon.ItemAppearance[source2.visualID])
					else
						return SortOrder(source1.uiOrder, source2.uiOrder)
					end
				end)
		end,

		-- sort by the color in filename
		[LE_COLOR] = function(self, sets, reverseUIOrder, ignorePatchID)
			for i, data in ipairs(sets) do
				local setID = data.setID
				local sources = C_TransmogSets.GetSetSources(setID)  --[{sourceID =collected}]
				local sourceID

				for i,d in pairs(sources) do
				 	sourceID = i
					 break
				end
			
				local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
				data.visualID = sourceInfo.visualID
			end

			addon.Sort.SortColor(sets)
		end,

		[LE_ITEM_SOURCE] = function(self, sets, reverseUIOrder, ignorePatchID)
		end,
		
		[LE_EXPANSION] = function(self, sets, reverseUIOrder, ignorePatchID)
			addon.Sort.SortSetByExpansion(sets, reverseUIOrder, ignorePatchID)
		end,
	},

	[TAB_EXTRASETS] = {
		[LE_DEFAULT]  = function(self, sets, reverseUIOrder, ignorePatchID)
			addon.Sort.SortDefault(sets, reverseUIOrder, ignorePatchID)
		end,

		[LE_ALPHABETIC] = function(self, sets, reverseUIOrder, ignorePatchID)
			addon.Sort.SortSetAlphabetic(sets, reverseUIOrder, ignorePatchID)
		end,

		[LE_APPEARANCE] = function(self, sets, reverseUIOrder, ignorePatchID)
--[[			for i, data in ipairs(sets) do
				local baseItem = data.items[1]
				local visualID, sourceID = addon.GetItemSource(baseItem)
				if sourceID then 
				local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
				data.visualID = sourceInfo.visualID
				end
			end]]

		sort(sets, function(source1, source2)
				if source1.itemAppearance and source2.itemAppearance then
					return SortOrder(source1.itemAppearance, source2.itemAppearance)
				else
					return SortOrder(source1.uiOrder, source2.uiOrder)
				end
			end)
		end,
		
		-- sort by the color in filename
		[LE_COLOR] = function(self, sets, reverseUIOrder, ignorePatchID)
			--[[for i, data in ipairs(sets) do
			-							local baseItem = data.items[1]
										local _, sourceID = addon.GetItemSource(baseItem)
										local sourceInfo = sourceID and C_TransmogCollection.GetSourceInfo(sourceID)
										data.visualID = sourceInfo and sourceInfo.visualID
									end]]

			addon.Sort.SortColor(sets)
		end,

		[LE_ITEM_SOURCE] = function(self, sets, reverseUIOrder, ignorePatchID)
			
		end,

		[LE_EXPANSION] = function(self, sets, reverseUIOrder, ignorePatchID)
			addon.Sort.SortSetByExpansion(sets, reverseUIOrder, ignorePatchID)
		end,
	},

	[TAB_SAVED_SETS] = {
		[LE_DEFAULT] = function(self, sets, reverseUIOrder, ignorePatchID)
			local comparison = function(set1, set2)

				local groupFavorite1 = (addon.chardb.profile.favorite[set1.setID] or set1.favoriteSetID) and true
				local groupFavorite2 = (addon.chardb.profile.favorite[set2.setID] or set2.favoriteSetID) and true
				if ( groupFavorite1 ~= groupFavorite2 ) then
					return groupFavorite1
				end

				return SortOrder(set1.uiOrder, set2.uiOrder)
			end

			table.sort(sets, comparison)
		end,
	},
}
addon.Sort = Sort


function addon.SetSortOrder()
	SortOrder = addon.sortDB.reverse and SortReverse or SortNormal
end


function addon.SortCollection(frame)
	if CheckTab(1) then 
		addon.Sort[1][addon.sortDB.sortDropdown](Wardrobe)
		Wardrobe:UpdateItems()
	end
end


function addon.SortSet(sets, reverseUIOrder, ignorePatchID)
 	if not sets  then return end
 --	if DropDownList1:IsShown() then return end
 	if not CheckTab(4) then 
		addon.sortDB.reverse = IsModifierKeyDown()
		addon.SetSortOrder()
		addon.Sort[GetTab()][addon.sortDB.sortDropdown](self, sets, reverseUIOrder or IsModifierKeyDown(), ignorePatchID)
	else
		addon.sortDB.reverse = false
		addon.SetSortOrder()
		addon.Sort[TAB_SAVED_SETS][LE_DEFAULT](self, sets, reverseUIOrder or IsModifierKeyDown(), ignorePatchID)

	end
end