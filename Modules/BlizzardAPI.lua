--	///////////////////////////////////////////////////////////////////////////////////////////
--
--	Blizzard API
--	Author: SLOKnightfall

--	Functions based on the Blizzard API that return the same data structure for extra sets

--	///////////////////////////////////////////////////////////////////////////////////////////

local addonName, addon = ...
---addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)


local playerInv_DB
local Profile
local playerNme
local realmName
local playerClass, classID,_
local Sets = {}
addon.Sets = Sets

--local SetsDataProvider = addon.SetsDataProvider
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local itemSlots = {
	INVTYPE_HEAD = "HEADSLOT",
	INVTYPE_SHOULDER = "SHOULDERSLOT",
	INVTYPE_CLOAK = "BACKSLOT",
	INVTYPE_CHEST = "CHESTSLOT",
	INVTYPE_ROBE = "CHESTSLOT",
	INVTYPE_TABARD = "TABARDSLOT",
	INVTYPE_BODY = "SHIRTSLOT",
	INVTYPE_WRIST = "WRISTSLOT",
	INVTYPE_HAND = "HANDSSLOT",
	INVTYPE_WAIST = "WAISTSLOT",
	INVTYPE_LEGS = "LEGSSLOT",
	INVTYPE_FEET = "FEETSLOT",
	INVTYPE_WEAPON = "MAINHANDSLOT",
	INVTYPE_RANGED = "MAINHANDSLOT",
	INVTYPE_RANGEDRIGHT = "MAINHANDSLOT",
	INVTYPE_THROWN = "MAINHANDSLOT",
	INVTYPE_SHIELD = "SECONDARYHANDSLOT",
	INVTYPE_2HWEAPON = "MAINHANDSLOT",
	INVTYPE_WEAPONMAINHAND = "MAINHANDSLOT",
	INVTYPE_WEAPONOFFHAND = "SECONDARYHANDSLOT",
	INVTYPE_HOLDABLE = "SECONDARYHANDSLOT",
}



local function GetItemSlot(itemLinkOrID)
	local GetItemInfoInstant = C_Item and C_Item.GetItemInfoInstant
	local _, _, _, slot = GetItemInfoInstant(itemLinkOrID)
	if not slot then return end
	return itemSlots[slot]
end
addon.GetItemSlot = GetItemSlot

local function GetItemCategory(appearanceID)
	return (appearanceID and C_TransmogCollection.GetCategoryForItem(appearanceID)) or 0
end
addon.GetItemCategory = GetItemCategory
local function GetTransmogLocation(itemLinkOrID)
	return TransmogUtil.GetTransmogLocation(GetItemSlot(itemLinkOrID), Enum.TransmogType.Appearance, Enum.TransmogModification.Main)
end
addon.GetTransmogLocation = GetTransmogLocation
--Determines type of set based on setID
local function DetermineSetType(setID)

	local setType = addon.GetSetType(setID)
	--Default Blizzard Set
	if not setType or setType == "BlizzardSet"then
		return "set"

	--Extra Set
	elseif setType == "ExtraSet" then
		return "extraSet"

	else
	--Mogit set
	--Saved Set
		return "savedset"
	end
end

addon.DetermineSetType = DetermineSetType
addon.C_Transmog = {}

function addon.C_Transmog.LoadOutfit(outfitID)
	--if addon.IsDefaultSet(outfitID) then
		--C_Transmog.LoadOutfit(addon:GetBlizzID(outfitID))
	--else
		BetterWardrobeCollectionFrame.SetsTransmogFrame:LoadSet(outfitID)
	--end
end

addon.C_TransmogSets = {}
addon.C_TransmogCollection = {}	

--C_TransmogSets.GetSetPrimaryAppearances(setID)
--[[	Name = "GetSetPrimaryAppearances",
			Type = "Function",

			Arguments =
			{
				{ Name = "transmogSetID", Type = "number", Nilable = false },
			},

			Returns =
			{
				{ Name = "apppearances", Type = "table", InnerType = "TransmogSetPrimaryAppearanceInfo", Nilable = false },
			},

			Name = "TransmogSetPrimaryAppearanceInfo",
			Type = "Structure",
			Fields =
			{
				{ Name = "appearanceID", Type = "number", Nilable = false },
				{ Name = "collected", Type = "bool", Nilable = false },
			},]]

function addon.C_TransmogSets.GetSetPrimaryAppearances(setID)
	local setType = DetermineSetType(setID)

	if setType == "set" then
		return C_TransmogSets.GetSetPrimaryAppearances(setID)

	else
	--elseif setType == "extraset" then
		local setSources = addon.GetSetsources(setID)
		local primaryAppearances = {}
		for appearanceID, collected in pairs(setSources) do
			local data = {["appearanceID"] = appearanceID, ["collected"] = collected}
			tinsert(primaryAppearances, data)
		end

		return primaryAppearances
	end
end


function addon.C_TransmogSets.GetSetInfo(setID)
	if not setID then return {} end
	local setType = DetermineSetType(setID)

	if setType == "set" then
		return C_TransmogSets.GetSetInfo(setID)

else
	--elseif setType == "extraset" then
		return addon.GetSetInfo(setID)
	end
end


function addon.C_TransmogSets.SetIsFavorite(setID, value)
end


function addon.C_TransmogSets.GetBaseSetsCounts()
	if BetterWardrobeCollectionFrame:CheckTab(2) then
		return C_TransmogSets.GetBaseSetsCounts()
	--elseif BetterWardrobeCollectionFrame:CheckTab(3) then
	else
		local sets = addon.GetBaseList()
		local totalSets = #sets or 0
		local collectedSets = 0
		local SetsDataProvider = addon.SetsDataProvider

		for i, data in ipairs(sets) do
			local sourceData = addon.SetsDataProvider:GetSetSourceData(data.setID)
			local topSourcesCollected, topSourcesTotal = (sourceData and sourceData.numCollected) or 0, (sourceData and sourceData.numTotal) or 0
			if topSourcesCollected == topSourcesTotal then
				collectedSets = collectedSets + 1
			end
		end
		return collectedSets, totalSets
	end
end

function addon.C_TransmogSets.GetSourcesForSlot(setID, slot)
	if BetterWardrobeCollectionFrame:CheckTab(2) then
		return C_TransmogSets.GetSourcesForSlot(setID, slot)
	else
		local categoryID, visualID, canEnchant, icon, isCollected, itemLink, transmogLink, unknown1, itemSubTypeIndex = C_TransmogCollection.GetAppearanceSourceInfo(sourceID)
	end
end


function addon.C_TransmogSets.SetHasNewSources(setID)
	local setType = DetermineSetType(setID)

	if setType == "set" then
		return C_TransmogSets.SetHasNewSources(setID)

	elseif setType == "extraset" then
		if addon.newTransmogInfo[setID] then return true end

		return false
	end
end



function addon.C_TransmogSets.SetHasNewSourcesForSlot(setID, transmogSlot)
	if (addon.newTransmogInfo[setID]) then 
		for itemID, inventoryType in pairs(addon.newTransmogInfo[setID]) do
			if inventoryType == transmogSlot then
				return true
			end

		end

		return false
	else
		return false
	end
end

function addon.C_TransmogSets.GetBaseSetID(setID)
	local setType = DetermineSetType(setID)
	if setType == "set" then
		return C_TransmogSets.GetBaseSetID(setID)

	elseif setType == "extraset" then
		return setID
	else
		return setID
	end
end

local SourceDB = {}
function addon.ClearSourceDB()
	wipe(SourceDB)
end

function addon.GetSetSources(setID)
	local setAppearances = C_TransmogSets.GetSetPrimaryAppearances(setID)
	if not setAppearances then
		return nil
	end

	local lookupTable = {}
	for i, appearanceInfo in ipairs(setAppearances) do
		lookupTable[appearanceInfo.appearanceID] = appearanceInfo.collected
	end
	return lookupTable
end
local counter = 0
function addon.C_TransmogSets.GetSetSources(setID)
	if SourceDB[setID] then return SourceDB[setID][1], SourceDB[setID][2] end
	local setInfo = addon.GetSetInfo(setID)
	local SetType = setInfo and setInfo.setType
	--Default Blizzard Set
	if not SetType or SetType == "BlizzardSet" then
		return addon.GetSetSources(setID)
	end
	
	local setSources = {}
	local atTransmogrifier = C_Transmog.IsAtTransmogNPC()
	local unavailable = false
	local SetType = setInfo.setType
	local sources = {}
	--Blizzard Saved Set
	if SetType == "SavedBlizzard" then
 		local setTransmogInfo = C_TransmogCollection.GetOutfitItemTransmogInfoList(addon:GetBlizzID(setID))
 		for slotID, data in ipairs(setTransmogInfo) do
 			local sourceInfo = data.appearanceID and C_TransmogCollection.GetSourceInfo(data.appearanceID)
			local sources = sourceInfo and C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID, GetItemCategory(sourceInfo.visualID), GetTransmogLocation(sourceInfo.itemID))
			if sources then
				--items[sources.itemID] = true
				if #sources > 1 then
					CollectionWardrobeUtil.SortSources(sources, sources[1].visualID, sourceID)
				end
				setSources[sources[1].sourceID] = sources[1].isCollected--and sourceInfo.isCollected
			end

			if slotID == 3 and data.secondaryAppearanceID then
				local sourceInfo = C_TransmogCollection.GetSourceInfo(data.secondaryAppearanceID)
				local sources = sourceInfo and C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID, GetItemCategory(sourceInfo.visualID), GetTransmogLocation(sourceInfo.itemID))
				if sources then
					--items[sources.itemID] = true
					if #sources > 1 then
						CollectionWardrobeUtil.SortSources(sources, sources[1].visualID, sourceID)
					end
					setSources[sources[1].sourceID] = sources[1].isCollected--and sourceInfo.isCollected
				end
			end
 		end

		SourceDB[setID] = {setSources, unavailable}
		return setSources, unavailable

	--Other Sets
	else
		if not setInfo.itemData then
		else
			--print("Lookup "..counter)
			counter = counter+1
			for slotID, sourceData in pairs(setInfo.itemData) do
				local sourceID = sourceData[2]
				local appearanceID = sourceData[3]
				if sourceID ~= 0 then
					local sourceInfo = sourceID and C_TransmogCollection.GetSourceInfo(sourceID)

					local sources = appearanceID and C_TransmogCollection.GetAppearanceSources(appearanceID, GetItemCategory(appearanceID), GetTransmogLocation(sourceInfo.itemID))
					if sources then
						--items[sources.itemID] = true
						if #sources > 1 then
							CollectionWardrobeUtil.SortSources(sources, sources[1].visualID, sourceID)
						end
						setSources[sources[1].sourceID] = sources[1].isCollected--and sourceInfo.isCollected
					else

						local allSources = C_TransmogCollection.GetAllAppearanceSources(appearanceID)
						local list = {}
						for _, sourceID in ipairs(allSources) do
			
							local info = C_TransmogCollection.GetSourceInfo(sourceID)
							if (info and not info.sourceType) then --and not setInfo.sourceType then
								unavailable = true
							end

							local isCollected = select(5,C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
							info.isCollected = isCollected
							tinsert(list, info)
						end

						if #list >= 1 then
							CollectionWardrobeUtil.SortSources(list, list[1].visualID, sourceID)
							setSources[list[1].sourceID or sourceID ] = list[1].isCollected or false
							if not list[1].sourceType then --and not setInfo.sourceType then
								unavailable = true
							end
						end
					end
				end
			end

			if setInfo.itemData[3] and setInfo.offShoulder then
				local sourceInfo = C_TransmogCollection.GetSourceInfo(setInfo.offShoulder)
				--local sources = sourceInfo and C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)
				local sources = sourceInfo and C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID, GetItemCategory(sourceInfo.visualID), GetTransmogLocation(sourceInfo.itemID))

				if sources then
					--items[sources.itemID] = true
					if #sources > 1 then
						CollectionWardrobeUtil.SortSources(sources, sources[1].visualID, sourceID)
					end
					setSources[sources[1].sourceID] = sources[1].isCollected--and sourceInfo.isCollected
				end
			end
		end

		SourceDB[setID] = {setSources, unavailable}

		return setSources, unavailable
	end
end

function addon:SetFavoriteItem(visualID, set)
	if addon.favoritesDB.profile.item[visualID] then
		addon.favoritesDB.profile.item[visualID] = nil
	else
		addon.favoritesDB.profile.item[visualID] = true
	end

	BetterWardrobeCollectionFrame.ItemsCollectionFrame:RefreshVisualsList()
	BetterWardrobeCollectionFrame.ItemsCollectionFrame:UpdateItems()
end

function addon:IsFavoriteItem(visualID)
	return addon.favoritesDB.profile.item[visualID]
end

function Sets:ClearHidden(setList)
if addon.Profile.ShowHidden then return setList end

	local setType = "item"
	if BetterWardrobeCollectionFrame:CheckTab(2) then
		setType = "set"
	elseif BetterWardrobeCollectionFrame:CheckTab(3) then
		setType = "extraset"
	elseif BetterWardrobeCollectionFrame:CheckTab(4) then
		return setList
	end

	local newSet = {}
	for i, setInfo in pairs(setList) do
		local itemID = setInfo.setID or setInfo.visualID
		if not addon.HiddenAppearanceDB.profile[setType][itemID] then
			tinsert(newSet, setInfo)
		end
	end
	return newSet
end

local function CheckMissingLocation(setInfo)
	local filtered = false
	local missingSelection
	if 	BetterWardrobeCollectionFrame:CheckTab(2) then
	
	local invType = {}
	missingSelection = addon.Filters.Base.missingSelection
	local sources = addon.GetSetSources(setInfo.setID)
	if not sources then return end
		for sourceID in pairs(sources) do
			local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
			--local sources = sourceInfo and C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)
			local sources = sourceInfo and C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID, GetItemCategory(sourceInfo.visualID), GetTransmogLocation(sourceInfo.itemID))

			if sources then
				if #sources > 1 then
				CollectionWardrobeUtil.SortSources(sources, sources[1].visualID, sourceID)

				end
				if missingSelection[sourceInfo.invType] and not sources[1].isCollected then

					return true
				elseif missingSelection[sourceInfo.invType] then
					filtered = true
				end
			end
		end

		for type, value in pairs(missingSelection) do
			if value and invType[type] then
				filtered = true
			end
		end
	else
		local missingSelection = addon.Filters.Extra.missingSelection

		for type, value in pairs(missingSelection) do
			if value then
				filtered = true
				break
			end
		end
		--no need to filter if nothing is selected
		if not filtered then return true end
		
		local invType = {}
		if not setInfo.itemData then
			local sources = addon.GetSetSources(setInfo.setID)
			for sourceID in pairs(sources) do
				local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)

				local isCollected = Sets.isMogKnown(sourceID)
				if missingSelection[sourceInfo.invType] and not isCollected then		
					return true
				elseif missingSelection[sourceInfo.invType] then
					filtered = true
				end
			end

		else
			local setSources = addon.GetSetsources(setInfo.setID)
			for sourceID, isCollected in pairs(setSources) do
				local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
				if missingSelection[sourceInfo.invType] and not isCollected then
					return true
				elseif missingSelection[sourceInfo.invType] then
					filtered = true
				end
			end
		end

		for type, value in pairs(missingSelection) do
			if value and invType[type] then
				filtered = true
			end
		end
	end

	return not filtered
end


local function OpposingFaction(faction)
	local faction = UnitFactionGroup("player")
	if faction == "Horde" then
		return "Alliance", "Stormwind", 1 -- "Kul Tiras",
	elseif faction == "Alliance" then
		return "Horde", "Orgrimmar", 2 -- "Zandalar",
	end
end

local PvPSets = {
	["Honor"] = true,
	["Combatant"] = true,
	["Combatant I"] = true,
	["Warfront"] = true,
	["Aspirant"] = true,
	["Gladiator"] = true,
	["Elite"] = true,
}

addon.RefreshFilter = true
function addon:FilterSets(setList, setType)
	local FilterSets = {}
	local searchValue = BetterWardrobeCollectionFrameSearchBox:GetText()
	local filterList = setList
	if searchValue ~= ""  then
		filterList = addon.searchSet
	end
	local faction = UnitFactionGroup("player")
	local opFaction = OpposingFaction(faction)
	local requiredFaction = true

	if C_Transmog.IsAtTransmogNPC() then 
		for i, data in pairs(setList) do
				 setData = BetterWardrobeSetsDataProviderMixin:GetSetSourceData(data.setID)
			local holidayName 
			--for sourceID,_ in pairs(setData.sources) do
				--holidayName = C_TransmogCollection.GetSourceRequiredHoliday(sourceID);
				--if holidayName then break end
			--end

			if data.requiredFaction == 1  then
				data.requiredFaction = "Alliance"
			elseif data.requiredFaction == 2 then
				data.requiredFaction = "Horde"
			end
			
			if data.requiredFaction and data.requiredFaction ~= faction then
				requiredFaction = false
			elseif not data.requiredFaction or data.requiredFaction and data.requiredFaction == faction then
				requiredFaction = true
			end
		
			local tab = (BetterWardrobeCollectionFrame.selectedTransmogTab == 2 and data.tab == 2) or (BetterWardrobeCollectionFrame.selectedTransmogTab == 3 and data.tab == 3)
			if tab and not holidayName and requiredFaction then
				tinsert(FilterSets, data)
			end
		end
		return FilterSets
	end


	local searchString = string.lower(WardrobeCollectionFrameSearchBox:GetText())
	local filterCollected = C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_COLLECTED)
	local filterUncollected = C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_UNCOLLECTED)
	local filterPVE = C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVE)
	local filterPVP = C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVP)

	local missingSelection = addon.Filters.Base.missingSelection
	local filterSelection = addon.Filters.Base.filterSelection
	local xpacSelection = addon.Filters.Base.xpacSelection

	--if BetterWardrobeCollectionFrame:CheckTab(3) then
		--filterCollected = addon.Filters.Extra.filterCollected
		--missingSelection = addon.Filters.Extra.missingSelection
		--filterSelection = addon.Filters.Extra.filterSelection
		--xpacSelection = addon.Filters.Extra.xpacSelection
	--end
		--local PvPSets = false


	for i, data in ipairs(filterList) do
		local setData = BetterWardrobeSetsDataProviderMixin:GetSetSourceData(data.setID)
		local isPvP = data.description and PvPSets[data.description];
		local count , total = setData.numCollected, setData.numTotal
		local expansion = data.expansionID
		local sourcefilter = (BetterWardrobeCollectionFrame:CheckTab(3) and filterSelection[data.filter])
		local unavailableFilter = (not unavailable or (addon.Profile.HideUnavalableSets and unavailable))
		local tab = (BetterWardrobeCollectionFrame:CheckTab(2) and data.tab == 2) or (BetterWardrobeCollectionFrame:CheckTab(3) and data.tab == 3)
		if BetterWardrobeCollectionFrame:CheckTab(2) then
			--expansion = expansion + 1
			sourcefilter = true
			unavailableFilter = true
		end

		local collected = count == total
		if ((filterCollected and collected) or (filterUncollected and not collected)) and
			((filterPVE and not isPvP) or (filterPVP and isPvP)) and
			--CheckMissingLocation(data) and
			xpacSelection[expansion] and
			sourcefilter and
			tab then
			--(not unavailable or (addon.Profile.HideUnavalableSets and unavailable)) then ----and
			tinsert(FilterSets, data)
		end
	end

	return FilterSets
end


local function SearchValueFound(set, searchValue)
	local start, _ = string.find(string.lower(set.name), searchValue);
	if start ~= nil then return true; end
	
	if set.label then
		start, _ = string.find(string.lower(set.label), searchValue);
		if start ~= nil then return true; end
	end
	
	local varSets = addon.SetsDataProvider:GetVariantSets(set.baseSet);
	
	for id,varSet in pairs(varSets) do
		start, _ = string.find(string.lower(varSet.name), searchValue);
		if start ~= nil then return true; end
	end
	
	return false;
end


function addon:SearchSets(setList)
	local searchedSets = {}
	local searchString = string.lower(BetterWardrobeCollectionFrameSearchBox:GetText())
 	local atTransmogrifier = C_Transmog.IsAtTransmogNPC()

	if searchString == "" then return setList end

	if atTransmogrifier then
		setList = Sets:ClearHidden(setList)
		for i, data in ipairs(setList) do
			if (searchString and string.find(string.lower(data.name), searchString)) or (data.label and string.find(string.lower(data.label), searchString)) or (data.description and string.find(string.lower(data.description), searchString)) or (data.className and string.find(string.lower(data.className), searchString)) then
				tinsert(searchedSets, data)
			end
		end
		return searchedSets

	else
		for _, baseSet in ipairs(setList) do
			if SearchValueFound(baseSet, searchValue) then
				table.insert(addon.searchSet, baseSet);
			end
		end
		return searchedSets
	end
end


--[[

					C_TransmogSets.SetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVE, value)
				end
	info.checked = C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVE)]]


function addon.C_TransmogCollection.GetOutfitItemTransmogInfoList(setID)
	local setData = addon.GetSetInfo(setID)
	local itemTransmogInfoList = {}
	local offShoulder = setData.offShoulder or 0
	local mainHandEnchant = setData.mainHandEnchant or 0
	local offHandEnchant = setData.offHandEnchant or 0
	local itemData = setData.itemData or {}


	for i = 1, 19 do
	--for slotID, data in pairs(setData.itemData) do
		local itemTransmogInfo
		local data = itemData[i]
		if i == 3 then
			itemTransmogInfo = ItemUtil.CreateItemTransmogInfo((data and data[2]) or 0, offShoulder, 0)

		elseif i == 16 then
			itemTransmogInfo = ItemUtil.CreateItemTransmogInfo((data and data[2]) or 0, 0, mainHandEnchant)

		elseif i == 17 then
			itemTransmogInfo = ItemUtil.CreateItemTransmogInfo((data and data[2]) or 0, 0, offHandEnchant)

		else
			itemTransmogInfo = ItemUtil.CreateItemTransmogInfo((data and data[2]) or 0, 0, 0)
		end

		itemTransmogInfoList[i] = itemTransmogInfo
	end

	return itemTransmogInfoList
end
--[[  TODO: Remove
function addon:GetSetCounts(setID)
		if ( not self.sourceData ) then
		self.sourceData = { }
	end
	local sourceData = self.sourceData[setID]

	if ( not self.sourceExtraData ) then
		self.sourceExtraData = { }
	end
	local sourceExtraData = self.sourceExtraData[setID]

	if (BetterWardrobeCollectionFrame:CheckTab(2)) then
		if ( not sourceData ) then
			local primaryAppearances = C_TransmogSets.GetSetPrimaryAppearances(setID)
			local numCollected = 0
			local numTotal = 0
			local sources = {}
			for i, primaryAppearance in ipairs(primaryAppearances) do
				sources[primaryAppearance.appearanceID] = true
				if primaryAppearance.collected then
					numCollected = numCollected + 1
				end
				numTotal = numTotal + 1
			end
			sourceData = { numCollected = numCollected, numTotal = numTotal, sources = sources, primaryAppearances = primaryAppearances }
			self.sourceData[setID] = sourceData
		end

		return sourceData
	else
		if not sourceExtraData then

		--elseif BetterWardrobeCollectionFrame:CheckTab(3) then
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
				sourceExtraData = {numCollected = numCollected, numTotal = numTotal, sources = sources, unavailable = unavailable }
				self.sourceExtraData[setID] = sourceData
			end
		end

		return sourceExtraData
	end
end
]]
--[[function BetterWardrobeSetsDataProviderMixin:GetSetSourceCounts(setID)
	local sourceData = self:GetSetSourceData(setID)
	return sourceData.numCollected, sourceData.numTotal
end]]


--function a()
--local link = gsub(C_TradeSkillUI.GetTradeSkillListLink(), "\124", "\124\124")
--local _,_,current, max,_ = strsplit(":", link, 5)
--DEFAULT_CHAT_FRAME:AddMessage(current..":"..max)
--end

function addon.Model_ApplyUICamera(self, uiCameraID)
	--print(uiCameraID)
	local posX, posY, posZ, yaw, pitch, roll, animId, animVariation, animFrame, centerModel = GetUICameraInfo(uiCameraID)
	if posX and posY and posZ and yaw and pitch and roll then
		self:MakeCurrentCameraCustom()
		if uiCameraID == 200 then
			self:SetPosition(-8.5, 0, -2.677635)
		else
			self:SetPosition(posX, posY, posZ)
		end

		self:SetFacing(yaw)
		self:SetPitch(pitch)
		self:SetRoll(roll)
		self:UseModelCenterToTransform(centerModel)

		local cameraX, cameraY, cameraZ = self:TransformCameraSpaceToModelSpace(MODELFRAME_UI_CAMERA_POSITION):GetXYZ()
		local targetX, targetY, targetZ = self:TransformCameraSpaceToModelSpace(MODELFRAME_UI_CAMERA_TARGET):GetXYZ()

		self:SetCameraPosition(cameraX, cameraY, cameraZ)
		self:SetCameraTarget(targetX, targetY, targetZ)
	end

	if( animId and animFrame ~= -1 and animId ~= -1 ) then
		self:FreezeAnimation(animId, animVariation, animFrame)
	else
		self:SetAnimation(0, 0)
	end
end



local function ChatEdit_ActivateChat(editBox)
	if ( editBox.disableActivate ) then
		return;
	end

	ChatFrame_ClearChatFocusOverride();
	if ( ACTIVE_CHAT_EDIT_BOX and ACTIVE_CHAT_EDIT_BOX ~= editBox ) then
		ChatEdit_DeactivateChat(ACTIVE_CHAT_EDIT_BOX);
	end
	ACTIVE_CHAT_EDIT_BOX = editBox;

	ChatEdit_SetLastActiveWindow(editBox);

	--Stop any sort of fading
	UIFrameFadeRemoveFrame(editBox);

	editBox:Show();
	editBox:SetFocus();
	editBox:SetFrameStrata("DIALOG");
	editBox:Raise();

	editBox.header:Show();
	ChatEdit_UpdateNewcomerEditBoxHint(editBox);
	editBox.focusLeft:Show();
	editBox.focusRight:Show();
	editBox.focusMid:Show();
	editBox:SetAlpha(1.0);

	ChatEdit_UpdateHeader(editBox);

	if ( CHAT_SHOW_IME ) then
		_G[editBox:GetName().."Language"]:Show();
	end
end

function addon.ChatFrame_OpenChat(text, chatFrame, desiredCursorPosition)

	local editBox = ChatEdit_ChooseBoxForSend(chatFrame);

	ChatEdit_ActivateChat(editBox);
	editBox.desiredCursorPosition = desiredCursorPosition;

	if text then
		editBox.text = text;
		editBox.setText = 1;
	end

	if ( editBox:GetAttribute("chatType") == editBox:GetAttribute("stickyType") ) then
		if ( (editBox:GetAttribute("stickyType") == "PARTY") and (not IsInGroup(LE_PARTY_CATEGORY_HOME)) or
		(editBox:GetAttribute("stickyType") == "RAID") and (not IsInRaid(LE_PARTY_CATEGORY_HOME)) or
		(editBox:GetAttribute("stickyType") == "INSTANCE_CHAT") and (not IsInGroup(LE_PARTY_CATEGORY_INSTANCE))) then
			editBox:SetAttribute("chatType", "SAY");
		end
	end

	ChatEdit_UpdateHeader(editBox);
	return editBox;
end