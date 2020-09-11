local addonName, addon = ...

--local TextDump = LibStub("LibTextDump-1.0")
addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local _, playerClass, classID = UnitClass("player")
--local armorType = DB.GetClassArmorType(class)		  
--local role = GetFilteredRole()
addon.ArmorSets = addon.ArmorSets or {}
addon.ArmorSetMods = addon.ArmorSetMods or {}
addon.modArmor = addon.modArmor or {}



local CLASS_INFO = {
	DEATHKNIGHT = {6,32,"PLATE"},
	DEMONHUNTER = {12, 2048, "LEATHER"},
	DRUID = {11, 1024,"LEATHER"},
	HUNTER = {3, 4, "MAIL"},
	MAGE = {8,128,"CLOTH"},
	MONK = {10, 512, "LEATHER"},
	PALADIN = {2, 2,"PLATE"},
	PRIEST = {5, 16, "CLOTH"},
	ROGUE = {4, 8, "LEATHER"},
	SHAMAN = {7, 64, "MAIL"},
	WARLOCK = {9, 256, "CLOTH"},
	WARRIOR = {1,1,"PLATE"},
}


local EmptyArmor = {
	[1] = 134110,
	--[2] = 134112, neck
	[3] = 134112,
	--[4] = 168659, shirt
	[5] = 168659,
	[6] = 143539,
	--[7] = 158329, pants
	[8] = 168664,
	[9] = 168665,  --wrist
	[10] = 158329, --handr
}

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


local function OpposingFaction(faction)
	local faction = UnitFactionGroup("player")
	if faction == "Horde" then
		return "Alliance", "Stormwind" -- "Kul Tiras",
	elseif faction == "Alliance" then
		return "Horde", "Orgrimmar" -- "Zandalar",
	end
end


do
	local baseList = {}
	local setsInfo = {}


	local coreSetList = {}
	local function GetCoreSets(incVariants)
		local sets = C_TransmogSets.GetBaseSets()
 		local fullSetList = {}
		--Generates Useable Set
		for _, set in ipairs(sets) do
			coreSetList[set.setID] = true
			if incVariants then 
				local variantSets = C_TransmogSets.GetVariantSets(set.setID);
				for _, set in ipairs(variantSets) do
					coreSetList[set.setID] = true

				end
			end

		end
	end



--[[local function sourceLookup(item, modID)
	C_Timer.After(0, function() 
			local _, source = C_TransmogCollection.GetItemInfo(item, modID)
				if source and modID then 
					addon.modArmor[item] = addon.modArmor[item] or {}
					addon.modArmor[item][modID] = source 
					--print ("SavedA")
				end
	end);
end]]

	local function addArmor(armorSet)	
		for id, setData in pairs(armorSet) do
			
			local setInfo = C_TransmogSets.GetSetInfo(id)
			local classInfo = CLASS_INFO[playerClass]
			local class = (setData.classMask and setData.classMask == classInfo[1]) or not setData.classMask

			--local faction = setData[5]
			local opposingFaction , City = OpposingFaction(faction) -- BFAFaction,
			
			local factionLocked = string.find(setData.name, opposingFaction) 
				--or string.find(setData.name, BFAFaction)
				--or string.find(setData.name, City)
			local heritageArmor = string.find(setData.name, "Heritage")
		
			for _, item in ipairs( setData["items"]) do
--[[				if setData.mod then 
					for i= 1, 150 do
						--sourceLookup(item, setData.mod or nil ) --addon.GetItemSource(item, setData.mod or nil )
						if 	addon.modArmor[item] and addon.modArmor[item][modID] then 
							break
						end
					end
				end]]

			end
	
			if not  setInfo  or not coreSetList[id] then 
				if  (class) 
					and not factionLocked 
					and not heritageArmor  then

					setData["name"] = L[setData["name"]]
					local note = "NOTE_"..(setData.label or 0)
					setData.label =(L[note] and L[note]) or ""
					setData.uiOrder = id*100


					setsInfo[id] = setData
					tinsert(baseList, setsInfo[id])	
				end
			else --print(setInfo)
			end
		end
	end


	function addon.BuildDB()
	--local faction = GetFactionID(UnitFactionGroup("player"))
		local armorSet = addon.ArmorSets[CLASS_INFO[playerClass][3]]
		addon.modArmor = addon.ArmorSetMods[CLASS_INFO[playerClass][3]]

		addArmor(armorSet)
		addArmor(addon.ArmorSets["COSMETIC"])
		--BWSets = addon.modArmor
		--Add Hidden Set
		setsInfo[0] = hiddenSet
		tinsert(baseList, setsInfo[0])
		wipe(addon.ArmorSets)
	end


	function addon.GetBaseList()
		local list = {}
		for _, data in ipairs(baseList) do 
			tinsert(list, data)
		end

		return list
	end


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


