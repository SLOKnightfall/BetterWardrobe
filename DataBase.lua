local addonName, addon = ...

--local TextDump = LibStub("LibTextDump-1.0")
addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local _, playerClass, classID = UnitClass("player")
--local armorType = DB.GetClassArmorType(class)		  

--local role = GetFilteredRole()
addon.ArmorSets = addon.ArmorSets or {}

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

local classMask = {
	DEATHKNIGHT = 32,
	DRUID = 1024,
	HUNTER = 4,
	MAGE = 128,
	PALADIN = 2,
	PRIEST = 16,
	ROGUE = 8,
	SHAMAN = 64,
	WARLOCK = 256,
	WARRIOR = 1,
	MONK = 512,
	DEMONHUNTER = 2048,
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
		["name"] =  "Hidden" ,
		["items"] = { 134110, 134112, 168659, 168665, 158329, 143539, 168664 },
		["expansionID"] =  9999 ,
	}

--cloak 134111

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
	local defaultSets = {}


	local function BuildDefaultList()
		local baseSets = C_TransmogSets.GetAllSets()

		for id, setData in ipairs(baseSets) do
					defaultSets[id] = setData
		end
	end


local coreSetList = {}

local function GetCoreSets(incVariants)
		local sets = C_TransmogSets.GetBaseSets()
 	local fullSetList = {}
		--Generates Useable Set
		for i, set in ipairs(sets) do
			--if string.find(set.name, "Brawl") then print (set.setID)end
			--tinsert(self.usableSets, set)
			coreSetList[set.setID] = true
			if incVariants then 
				local variantSets = C_TransmogSets.GetVariantSets(set.setID);
				for i, set in ipairs(variantSets) do
					coreSetList[set.setID] = true

				end
			end

		end
end


	local function addArmor(armorSet)
		--local baseSets = C_TransmogSets.GetAllSets()

		--BuildDefaultList()
		--GetCoreSets(true)
	--local addon:GetUsableSets(incVariants)
		
		for id, setData in pairs(armorSet) do
			-- if not  defaultSets[id] then
			
			local setInfo = C_TransmogSets.GetSetInfo(id)
			local classInfo = CLASS_INFO[playerClass]
			--if not setInfo then
			--local class = (setInfo and setInfo.classMask == classInfo[2]) or (setData.classMask and setData.classMask == classInfo[1]) or not setData.classMask
			local class = (setData.classMask and setData.classMask == classInfo[1]) or not setData.classMask

			--local faction = setData[5]
			local opposingFaction , City = OpposingFaction(faction) -- BFAFaction,
			
			local factionLocked =  string.find(setData.name, opposingFaction) 
				--or string.find(setData.name, BFAFaction)
				or string.find(setData.name, City)
			local heritageArmor = string.find(setData.name, "Heritage")

				for i, item in ipairs( setData["items"]) do
					--print(item)
					local _, _ = addon.GetItemSource(item)
				end

--print(coreSetList[2953])
				if not  setInfo  or not coreSetList[id] then 
					if  (class) 
						and not factionLocked 
						and not heritageArmor  then

						--setsByExpansion[setData.expansionID] = setByExpansion[setData.expansionID] or {}
						--setsByExpansion[setData.expansionID][id] = true

						--setsByFilter[setData.label] = setsByFilter[setData.label] or {}
						--setsByFilter[setData.label][id] = true

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

		addArmor(armorSet)
		addArmor(addon.ArmorSets["COSMETIC"])

		--Add Hidden Set
		--setsInfo[0] = hiddenSet
		--ztinsert(baseList, setsInfo[0])
		wipe(addon.ArmorSets)
	end


	function addon.GetBaseList()
		local list = {}

		for i, data in ipairs(baseList) do 

					tinsert(list, data)
			--end
		end

		return list
	end

	

	function addon.AddSet(setData)
	--function addon.AddSet(id,name,items,class,faction)

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
	end


	function addon.GetSetInfo(setID)
		return setsInfo[setID]
	end

end
