local addonName, addon = ...

addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
addon.ArmorSets = addon.ArmorSets or {}
local ItemDB = {}
local Globals = addon.Globals

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local _, playerClass, classID = UnitClass("player")
--local role = GetFilteredRole()

local CLASS_INFO = Globals.CLASS_INFO
local CLASS_NAMES_LOCALIZED = {}

FillLocalizedClassList(CLASS_NAMES_LOCALIZED)

local ARMOR_MASK = Globals.ARMOR_MASK
local EmptyArmor = Globals.EmptyArmor
local subitemlist = {}
local hiddenSet ={
	["setID"] =  0 ,
	["name"] =  "Hidden",
	["items"] = { 134110, 134112, 168659, 168665, 158329, 143539, 168664 },
	--["expansionID"] =  9999 ,
	["expansionID"] =  1,
	["filter"] =  1,
	["recolor"] =  false,
	["minLevel"] =  1,
	["uiOrder"] = 100,
	["isClass"] = true,
}


local SET_DATA = {}
local SET_INDEX = {}
local ArmorDB = {}


local function GetFactionID(faction)
	if faction == "Horde" then
		return -- 64
	elseif faction == "Alliance" then
		return --4
	end
end

local RepSets ={["Horde"] = {2574,2844,2796,2820}, ["Alliance"] = {[2816] = "mail" ,[2840] = "plate ",[2750] = "cloth",}}
local AliznceRepSets = {2574,2844,2796,2820}

--C_TransmogCollection.GetAppearanceSourceInfo(81536)

	--appearanceID, sourceID = C_TransmogCollection.GetItemInfo(138372)
	--C_TransmogCollection.GetAppearanceSources(81536)
local function OpposingFaction(faction)
	local faction = UnitFactionGroup("player")
	if faction == "Horde" then
		return "Alliance", "Stormwind", 1 -- "Kul Tiras",
	elseif faction == "Alliance" then
		return "Horde", "Orgrimmar", 2 -- "Zandalar",
	end
end

addon.ArmorSetModCache = {}
do
	local function BuildArmorDB()
		for armorType, data in pairs(addon.ArmorSets) do
			ArmorDB[armorType] = {}

			for id, setData in pairs(data) do

							--local faction = setData[5]
				local opposingFaction , City, side = OpposingFaction(faction) -- BFAFaction,
				
				setData.isFactionLocked = string.find(setData.name, opposingFaction) 
					--or string.find(setData.name, BFAFaction)
					or string.find(setData.name, City)
					--or setData.side and setData.side == side
				setData.isHeritageArmor = string.find(setData.name, "Heritage")


				local classInfo = CLASS_INFO[playerClass]
				local class = (setData.classMask and setData.classMask == classInfo[1]) or not setData.classMask
				local className = (setData.classMask and GetClassInfo(setData.classMask)) or nil

				setData.isClass = class
				setData.className = className


				setData["name"] = L[setData["name"]]
				setData.oldnote = setData.label

				if not setData.note then
					local note = "NOTE_"..(setData.label or 0)
					setData.note = note

					setData.label =L[note] or ""
				end

				local baseItem = setData.items[1]
				local visualID, sourceID = addon.GetItemSource(baseItem)
				setData.itemAppearance = addon.ItemAppearance[visualID]


			--places some of the sets that didnt have correct filters
				if setData.note == "NOTE_4" or setData.note == "NOTE_4" then
					setData.filter = 4 
				elseif setData.note == "NOTE_95" then
					setData.filter = 7	
				elseif setData.note == "NOTE_96" then 
					setData.filter = 5
				elseif setData.note == "NOTE_97" then 
					setData.filter = 3

				end

						--setData.mod = setData.bonusid
				setData.uiOrder = id * 100
						--setData.filter = setData.filter + 1 -- fix for filter startin at 0
				--setData.numCollected = 0
				--setData.numTotal = 0
				--setData.setSources = {}
				--setData.sources = setData.sources or {}

				for index, item in ipairs( setData["items"]) do
					--[[
					setData.numTotal = setData.numTotal + 1
					local mod = setData.mod or 0
					local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(item, mod)
					if not appearanceID then
						for i = 0, 10 do
							appearanceID, sourceID = C_TransmogCollection.GetItemInfo(item, i)
							if appearanceID then
								break
							end
						end
					end

					if appearanceID then 
						setData.sources[item] = appearanceID
						local sources = C_TransmogCollection.GetAppearanceSources(appearanceID) or {} --Can return nil if no longer in game
						local baseSource 
						if (#sources == 0) then
							-- can happen if a slot only has HiddenUntilCollected sources
							
							sources = {C_TransmogCollection.GetSourceInfo(sourceID)}
							if not sources[1].sourceType and not setData.sourceType then 
								setData.unavailable = true
							end

						else
							WardrobeCollectionFrame_SortSources(sources)
						end

						local _, _, canEnchant, _, isCollected  = C_TransmogCollection.GetAppearanceSourceInfo(sourceID)
						if sources[1].isCollected then 
							setData.setSources[sourceID] = true
							setData.numCollected = setData.numCollected + 1
						else
							setData.setSources[sourceID] = false
						end
					else
						--end
					end]]

					if setData.sources and setData.sources[item] and setData.sources[item] ~= 0 then 
						local appearanceID = setData.sources[item]
						ItemDB[appearanceID] = ItemDB[appearanceID] or {}
						ItemDB[appearanceID][id] = setData
					end

					--[[local setMod =  setData.mod or 0
																local visualID, sourceID = C_TransmogCollection.GetItemInfo(item, setMod)
																if sourceID then
																	addon.ArmorSetModCache[item] = {}
																	addon.ArmorSetModCache[item][setMod] = {visualID, sourceID}
																end]]

					
			
				end

				ArmorDB[armorType][id] = setData
			end
		end
		addon.ArmorSets = nil
	end


	local function addArmor(armorSet)
		for id, setData in pairs(armorSet) do
			if  (setData.isClass or 
					(addon.Profile.IgnoreClassRestrictions and ((setData.filter == 6 or setData.filter == 7) and addon.Profile.IgnoreClassLookalikeRestrictions)) or 
					(addon.Profile.IgnoreClassRestrictions and not addon.Profile.IgnoreClassLookalikeRestrictions)) 
				and not (setData.oldnote == 6 or setData.oldnote == 8 or setData.oldnote == 16 or setData.oldnote == 21)
				and not setData.isFactionLocked 
				and not setData.isHeritageArmor then 
				--and (not setData.unavailable or (addon.Profile.HideUnavalableSets and setData.unavailable)) then

				for index, item in ipairs( setData["items"]) do
					--if addon.setdb.global.itemSubstitute[item] then 
					--Swaps items for substitutes
					if subitemlist[item] then 
						local replacementID = subitemlist[item]
						local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(replacementID)
						local sources = C_TransmogCollection.GetAppearanceSources(appearanceID)
						WardrobeCollectionFrame_SortSources(sources)
						setData["items"][index] = replacementID
						setData.sources[item] = nil
						setData.sources[replacementID] = appearanceID
					end
				end

				SET_INDEX[id] = setData
				tinsert(SET_DATA, setData)	
			end
			--else --print(setInfo)
			--end
		end

	end

function addon.IsSetItem(itemLink)
	if not itemLink then return end

	local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemLink)
	if not ItemDB[appearanceID] then 
		return nil 
	else
		return ItemDB[appearanceID]
	end
end



	--local function AllSets()
		--if not addon.allSetCache then 
			--local faction = UnitFactionGroup("player")
			--local classInfo = CLASS_INFO[playerClass]
			--local armorTypeMask = ARMOR_MASK[classInfo[3]]

		--[[	local allSets = C_TransmogSets.GetAllSets()
							local filteredList = {}
							local baseSets = {}
				
							for index, data in ipairs(allSets) do
								if (data.requiredFaction == nil or data.requiredFaction == faction )  and
								(data.classMask == nil or data.classMask == 0 or data.classMask == classInfo[2] or data.classMask == armorTypeMask) then
									if data.baseSetID == nil then 
								baseSets[data.setID] = data
							end
								end
							end
				
							for setID, data in pairs(baseSets) do
								--print(setID)
								 	tinsert(filteredList, data)
				
							end
				
							addon.allSetCache = filteredList
						end
					end]]


local function buildSetSubstitutions()
	wipe(subitemlist)
	if not addon.itemsubdb.profile.items then return end
		for itemID, sub_data in pairs(addon.itemsubdb.profile.items) do
			local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemID)
			local sources = C_TransmogCollection.GetAppearanceSources(appearanceID)
			if sources then 
				for i, data in ipairs(sources) do
					subitemlist[data.itemID] = sub_data.subID
				end
			end
			subitemlist[itemID] = sub_data.subID
		end
	end 

	function addon.Init:InitDB()
		BuildArmorDB()
		addon.Init:BuildDB()
	end

	function addon.Init:BuildDB()
		buildSetSubstitutions()
		local armorSet = ArmorDB[addon.selectedArmorType] or ArmorDB[CLASS_INFO[playerClass][3]]
		wipe(SET_INDEX)
		wipe(SET_DATA)
		addArmor(armorSet)
		addArmor(ArmorDB["COSMETIC"])

		--Add Hidden Set
		SET_INDEX[0] = hiddenSet
		--tinsert(SET_DATA, hiddenSet)
	end


	function addon:ClearCache()
		--addon.ArmorSets = nil
		wipe(addon.ArmorSetModCache)
		--addon.extraSetsCache = nil
		wipe(SET_INDEX)
		wipe(SET_DATA)
		addon.ClearArtifactData()
		--wipe(addon.SavedSetCache)
		addon.SavedSetCache =  nil

		--setsInfo = nil
	end


	function addon.GetBaseList()
		return SET_DATA
	end


	function addon.GetSavedList()
		--if not addon.savedSetCache then 
			local savedOutfits = addon.GetOutfits()
			local list = {}
			SET_INDEX = SET_INDEX or {}
			for index, data in ipairs(savedOutfits) do
				local info = {}
				info.items = data.items or {}
				info.sources = data.sources or {}
				info.collected = true
				info.name = data.name
				info.description = ""
				info.expansionID = 1
				info.favorite = false
				info.hiddenUtilCollected = false
				info.label = L["Saved Set"]
				info.limitedTimeSet = false
				info.patchID = ""
				info.setID = data.setID or (data.outfitID + 5000)
				info.uiOrder = data.uiOrder or (data.index * 100)
				info.icon = data.icon
				info.isClass = true
				info.type = "Saved"

				if data.set == "default" then 
					info.sources = C_TransmogCollection.GetOutfitSources(data.outfitID)
				elseif  #info.sources == 0 then 
					for i = 1, 16 do
						info.sources[i] = data[i] or 0
					end
				end

				SET_INDEX[info.setID] = info
				tinsert(list, info)
			end
			
			addon.SavedSetCache = list
	--	end

		return addon.SavedSetCache
	end

--[[
				{
					77497, -- [1]
					nil, -- [2]
					94136, -- [3]
					84536, -- [4]
					54411, -- [5]
					4307, -- [6]
					45096, -- [7]
					10642, -- [8]
					25667, -- [9]
					53708, -- [10]
					nil, -- [11]
					nil, -- [12]
					nil, -- [13]
					nil, -- [14]
					22804, -- [15]
					0, -- [16]
					["outfitID"] = 21,
					["index"] = 1,
					["name"] = "5-554",
					["set"] = "extra",
					[19] = 35448,
					["mainHandEnchant"] = 0,
					["icon"] = 1130280,
					["offHandEnchant"] = 0,]]


	--[[function addon.AddSet(setData)
				local id = setData[1]
		
				local info = {}
				info.classMask = setData[4] --class
				info.collected = false 	
				info.description = ""
				info.expansionID	= ""
				info.favorite = ""
				info.hiddenUtilCollected = false
				info.label = ""
				info.limitedTimeSet = false
				info.name = setData[2]--name
				info.patchID = ""
				info.requiredFaction = setData[5]--faction
				info.setID = id
				info.uiOrder = ""
				info.items = setData[3]--items
		
				setInfo[id] = info
				tinsert(baseList, setInfo[id])
			end]]


	function addon.GetSetInfo(setID)
		return SET_INDEX[setID]
	end

	function addon.SetItemSubstitute(itemID, subID)
		itemID = tonumber(itemID)
		subID = tonumber(subID)

		if type(itemID) ~= "number" or type(subID) ~= "number" then 
			BW_WardrobeOutfitFrameMixin:ShowPopup("BETTER_WARDROBE_SUBITEM_INVALID_POPUP")
			return false 
		end

		local _, _, _, itemEquipLoc1 = GetItemInfoInstant(itemID) 
		local _, _, _, itemEquipLoc2 = GetItemInfoInstant(subID) 

		if itemEquipLoc1 ~= itemEquipLoc2 then 
			BW_WardrobeOutfitFrameMixin:ShowPopup("BETTER_WARDROBE_SUBITEM_WRONG_LOCATION_POPUP")
			return false 
		else

		local itemName1, link1 = GetItemInfo(tonumber(itemID))
		local itemName2, link2 = GetItemInfo(tonumber(subID))

		--local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemID|itemString [, itemModID])

		addon.itemsubdb.profile.items[itemID] = {["subID"] = subID, ["itemLink"]  =link1, ["subLink"] = link2}

		local item = Item:CreateFromItemID(itemID)
		item:ContinueOnItemLoad(function()
			addon.itemsubdb.profile.items[itemID].itemLink = item:GetItemLink()
			addon.RefreshSubItemData()
		end)

		local item2 = Item:CreateFromItemID(subID)
		item2:ContinueOnItemLoad(function()
			addon.itemsubdb.profile.items[itemID].subLink = item2:GetItemLink()
			addon.RefreshSubItemData()
		end)


		addon:ClearCache()
		addon.ExtraSetsDataProvider:ClearSets()

		addon.Init:BuildDB()
		addon.GetBaseList()
		if BW_SetsCollectionFrame:IsShown() then 
			BW_SetsCollectionFrame:Refresh()
			BW_SetsCollectionFrame:OnSearchUpdate()
		end
		addon.RefreshSubItemData()
	end



--[[
local full={}
function getallsets()

			local sets = C_TransmogSets.GetAllSets()
		for i, data in ipairs(sets)do
				for i,d in pairs(data)do
					--print(i)
					if string.find(i, "hidden") then 
					--print(i)
					--print(d)
					end
				
				end]]

	function addon.GetAllSets()
		local baseSets = {} --C_TransmogSets.GetBaseSets()
					local classInfo = CLASS_INFO[playerClass]


		local sets = C_TransmogSets.GetAllSets()
			for i, data in ipairs(sets)do
					for i,d in pairs(data)do
						--print(i)
						setData[data.classMask] = setData.classMask or {}
						if string.find(i, "hidden") then 
							if data[i] == true then 
								if (data.classMask and data.classMask == classInfo[2]) or not data.classMask or data.classMask == 0 then 
									data.filter = 1
									data.setID = data.setID *100
									setsInfo[data.setID] = data
									--tinsert(addon.extraSetsCache, data)
								end
							end
						end
						--setData[data.classMask][data.setID] = data
						--print(d).
					--else 
						--tinsert(setData[3592], data)

						--end
					
					end
					--print(data.limitedTimeSet)
					--print(data["hiddenUtilCollected"])

				--end
				--print(data.hiddenUtilCollected)

			--	sourceInfo = C_TransmogSets.GetSetInfo(1903)
				--print(sourceInfo["hiddenUtilCollected"])
				--if data.hiddenUtilCollected then
					--print(data.name)
				--	data.filter = 1
					--data.type = "Blizzard"
					--local setinfo = 
				--tinsert(addon.extraSetsCache, data)

				--end
			end
		return baseSets --setData[3592]
	end

end

	function addon:RemoveItemSubstitute(itemID)
 
		if not itemID  then
			return false
		end
		--local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemID|itemString [, itemModID])
		local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(tonumber(itemID))
		local sources = C_TransmogCollection.GetAllAppearanceSources(appearanceID)
		--local sources = C_TransmogCollection.GetAppearanceSources(appearanceID)

		for i, source_ID in ipairs(sources) do
			local info = C_TransmogCollection.GetSourceInfo(source_ID)
			addon.itemsubdb.profile.items[info.itemID] = nil
		end

		addon:ClearCache()
		addon.ExtraSetsDataProvider:ClearSets()
		addon.Init:BuildDB()
		addon.GetBaseList()
		addon.RefreshSubItemData()
	end

end