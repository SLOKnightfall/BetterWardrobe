local addonName, addon = ...

addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
addon.ArmorSets = addon.ArmorSets or {}
local ItemDB = {}

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local _, playerClass, classID = UnitClass("player")
--local role = GetFilteredRole()

local CLASS_INFO = {
	DEATHKNIGHT = {6,32,"PLATE"},
	DEMONHUNTER = {12, 2048, "LEATHER"},
	DRUID = {11, 1024,"LEATHER"},
	HUNTER = {3, 4, "MAIL"},
	MAGE = {8, 128, "CLOTH"},
	MONK = {10, 512, "LEATHER"},
	PALADIN = {2, 2,"PLATE"},
	PRIEST = {5, 16, "CLOTH"},
	ROGUE = {4, 8, "LEATHER"},
	SHAMAN = {7, 64, "MAIL"},
	WARLOCK = {9, 256, "CLOTH"},
	WARRIOR = {1, 1, "PLATE"},
}

local ARMOR_MASK = {
	CLOTH = 400,
	LEATHER = 3592,
	MAIL = 68,
	PLATE = 35,
}

local EmptyArmor = addon.Globals.EmptyArmor

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
}

local function GetFactionID(faction)
	if faction == "Horde" then
		return -- 64
	elseif faction == "Alliance" then
		return --4
	end
end

local RepSets ={["Horde"] = {2574,2844,2796,2820}, ["Alliance"] = {[2816] = "mail" ,[2840] = "plate ",[2750] = "cloth",}}
local AliznceRepSets = {2574,2844,2796,2820}
local function OpposingFaction(faction)
	local faction = UnitFactionGroup("player")
	if faction == "Horde" then
		return "Alliance", "Stormwind" -- "Kul Tiras",
	elseif faction == "Alliance" then
		return "Horde", "Orgrimmar" -- "Zandalar",
	end
end


do
	--local baseList = {}
	local setsInfo = {}

	local function sourceLookup(item, modID)
		C_Timer.After(0, function() 
				local _, source = C_TransmogCollection.GetItemInfo(item, modID)
					if source and modID then 
						addon.ArmorSetModCache[item] = addon.ArmorSetModCache[item] or {}
						addon.ArmorSetModCache[item][modID] = source 
					end
		end);
	end

	local function addArmor(armorSet)
	local list = addon.extraSetsCache or {}	
		for id, setData in pairs(armorSet) do
			
			local setInfo = C_TransmogSets.GetSetInfo(id)
			local classInfo = CLASS_INFO[playerClass]
			local class = (setData.classMask and setData.classMask == classInfo[1]) or not setData.classMask

			--local faction = setData[5]
			local opposingFaction , City = OpposingFaction(faction) -- BFAFaction,
			
			local factionLocked = string.find(setData.name, opposingFaction) 
				--or string.find(setData.name, BFAFaction)
				or string.find(setData.name, City)
			local heritageArmor = string.find(setData.name, "Heritage")
		
			--if not  setInfo  then 
				if  (class) 
					and not factionLocked 
					and not heritageArmor  then

					setData["name"] = L[setData["name"]]

					if not setData.note then
						local note = "NOTE_"..(setData.label or 0)
						setData.note = note

						setData.label =L[note] or ""
					end
					setData.uiOrder = id * 100

					for _, item in ipairs( setData["items"]) do
						if setData.sources and setData.sources[item] and setData.sources[item] ~= 0 then 
							local appearanceID = setData.sources[item]
							ItemDB[appearanceID] = ItemDB[appearanceID] or {}
							ItemDB[appearanceID][id] = setData
						end
					end

					setsInfo[id] = setData
					tinsert(list, setsInfo[id])	
				end
			--else --print(setInfo)
			--end
		end
		addon.extraSetsCache = list
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


	function addon.Init:BuildDB()
	--local faction = GetFactionID(UnitFactionGroup("player"))
		--AllSets()
		local armorSet = addon.ArmorSets[CLASS_INFO[playerClass][3]]
		addon.ArmorSetModCache = addon.ArmorSetModCache or {}
		addon.extraSetsCache = addon.extraSetsCache or {}
		setsInfo = setsInfo or {}

		addArmor(armorSet)
		addArmor(addon.ArmorSets["COSMETIC"])
		--BWSets = addon.modArmor
		--Add Hidden Set
		setsInfo[0] = hiddenSet
		tinsert(addon.extraSetsCache, setsInfo[0])
		--wipe(addon.ArmorSets)
	end

	function addon:ClearCache()
		--addon.ArmorSets = nil
		addon.ArmorSetModCache = nil
		addon.extraSetsCache = nil
		--setsInfo = nil
	end


	function addon.GetBaseList()
		if not addon.extraSetsCache then 
--[[			local list = {}
			for _, data in ipairs(baseList) do 
				tinsert(list, data)
			end
			addon.extraSetsCache = list]]
			addon.Init:BuildDB()
		end

		return addon.extraSetsCache
	end


	function addon.GetSavedList()
		if not addon.savedSetCache then 
			local savedOutfits = addon.GetOutfits()
			local list = {}
			setsInfo = setsInfo or {}
			for index, data in ipairs(savedOutfits) do
				local info = {}
				info.items = {}
				info.sources = {}
				info.collected = true
				info.name = data.name
				info.description = ""
				info.expansionID = 1
				info.favorite = false
				info.hiddenUtilCollected = false
				info.label = L["Saved Set"]
				info.limitedTimeSet = false
				info.patchID = ""
				info.setID = data.outfitID + 5000
				info.uiOrder = data.index * 100
				info.icon = data.icon
				info.type = "Saved"

				if data.set == "default" then 
					info.sources = C_TransmogCollection.GetOutfitSources(data.outfitID)
				else
					for i = 1, 16 do
						info.sources[i] = data[i] or 0
					end
				end

				setsInfo[info.setID] = info
				tinsert(list, setsInfo[info.setID])
			end
			
			addon.SavedSetCache = list
		end

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
		return setsInfo[setID]
	end

end