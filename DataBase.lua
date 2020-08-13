local addonName, addon = ...

--local TextDump = LibStub("LibTextDump-1.0")
addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local _, playerClass, classID = UnitClass("player")
--local armorType = DB.GetClassArmorType(class)		  
local faction = UnitFactionGroup("player")
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
	if faction == "Horde" then
		return "Alliance", "Kul Tiras", "Stormwind"
	elseif faction == "Alliance" then
		return "Horde", "Zandalar", "Orgrimmar"
	end
end

do
	local baseList = {}
	local setsInfo = {}
	
	local function addArmor(armorSet)
		
		for id, setData in pairs(armorSet) do
			
			local setInfo = C_TransmogSets.GetSetInfo(id)
			local classInfo = CLASS_INFO[playerClass]
			--if not setInfo then
			local class = (setInfo and setInfo.classMask == classInfo[2]) or (setData.classMask and setData.classMask == classInfo[1]) or not setData.classMask
			--local faction = setData[5]
			local opposingFaction , BFAFaction, City = OpposingFaction(faction)
			
			local factionLocked =  string.find(setData.name, opposingFaction) 
				or string.find(setData.name, BFAFaction)
				or string.find(setData.name, City)
			local heritageArmor = string.find(setData.name, "Heritage")

					for i, item in ipairs( setData["items"]) do
					--print(item)
					local _, _ = addon.GetItemSource(item)
				end

			if  (class) 
				and not factionLocked 
				and not heritageArmor then
				setData["name"] = L[setData["name"]]
				local note = "NOTE_"..(setData.label or 0)
				setData.label =(L[note] and L[note]) or ""

		


				setsInfo[id] = setData
				tinsert(baseList, setsInfo[id])	
			end
		end
	end

	function addon.BuildDB()
		print("BDB")
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