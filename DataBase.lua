local addonName, addon = ...

local TextDump = LibStub("LibTextDump-1.0")
addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local Utilities = {}
addon.Utilities = Utilities

local _, playerClass, classID = UnitClass("player")
--local armorType = DB.GetClassArmorType(class)		  
local faction = UnitFactionGroup("player")
--local role = GetFilteredRole()
addon.ArmorSets = addon.ArmorSets or {}


--
local debugPriority = 100

function SetDebug(value)
debugPriority = value
end
-- ----------------------------------------------------------------------------
-- Debugger.
-- ----------------------------------------------------------------------------
local DebugPour, GetDebugger
do
	--local TextDump = LibStub("LibTextDump-1.0")

	local DEBUGGER_WIDTH = 750
	local DEBUGGER_HEIGHT = 800

	local debugger

	---
	local function ProcessTable(table)



		for k,v in pairs(table) do
		print(k, v)
		end
	end

	---------
	local function Debug(...)
	---------
		if not debugger then
			debugger = TextDump:New(("%s Output"):format(addonName), DEBUGGER_WIDTH, DEBUGGER_HEIGHT)
		end

		local t = type(...)
		if t == "string" then
			local message = string.format(...)
			debugger:AddLine(message, "%X")
		elseif t == "number" then
			local message = string.format tostring((...))
			debugger:AddLine(message, "%X")
		elseif t == "boolean" then
			local message = string.format tostring((...))
			debugger:AddLine(message, "%X")
		elseif t == "table" then
			debugger:AddLine(addon.inspect(...), "%X")

			--pour(textOrAddon, ...)
		else
			--error("Invalid argument 2 to :Pour, must be either a string or a table.")
		end

		return message
	end

	---------
	function GetDebugger()
	---------
		if debugPriority <=0 then return end
		if not debugger then
			debugger = TextDump:New(("%s Output"):format(addonName), DEBUGGER_WIDTH, DEBUGGER_HEIGHT)
		end
		if debugger:Lines() == 0 then
			debugger:AddLine("Nothing to report.")
			debugger:Display()
			debugger:Clear()
			return
		end
		debugger:Display()
		debugger:Clear()

		return debugger
	end

	---------
	function ClearDebugger()
	---------
		if not debugger then
			debugger = TextDump:New(("%s Output"):format(addonName), DEBUGGER_WIDTH, DEBUGGER_HEIGHT)
		end

		debugger:Clear()
	end

	--------
	function Export(...)
	---------
		if not debugger then
			debugger = TextDump:New(("%s Export"):format(FOLDER_NAME), DEBUGGER_WIDTH, DEBUGGER_HEIGHT)
		end

		debugger:Clear()
			local message = string.format(...)
			debugger:AddLine(message)

		 debugger:Display()
		 return debugger

	end

	Utilities.Debug = Debug
	Utilities.DebugPour = DebugPour
	Utilities.Export = Export
	Utilities.GetDebugger =  GetDebugger
	Utilities.ClearDebug = ClearDebugger

end

local Debug = Utilities.Debug

---------

local ClassArmor = {
	DEATHKNIGHT = "PLATE",
	DEMONHUNTER = "LEATHER",
	DRUID = "LEATHER",
	HUNTER = "MAIL",
	MAGE = "CLOTH",
	MONK = "LEATHER",
	PALADIN = "PLATE",
	PRIEST = "CLOTH",
	ROGUE = "LEATHER",
	SHAMAN = "MAIL",
	WARLOCK = "CLOTH",
	WARRIOR = "PLATE",
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
		return "Alliance", "Kul Tiras"
	elseif faction == "Alliance" then
		return "Horde", "Zandalar"
	end
end

do
	local baseList = {}
	local setInfo = {}
	Utilities.GetDebugger()
	local function addArmor(armorSet)
		
		for id, setData in pairs(armorSet) do
			--local id = i
			local class = setData.classMask
			--local faction = setData[5]
			local opposingFaction , BFAFaction = OpposingFaction(faction)
			local factionLocked = string.find(setData.name, opposingFaction) 
				or string.find(setData.name, BFAFaction)
			local heritageArmor = string.find(setData.name, "Heritage")

			if  (class and class == classID or not class) 
				and not factionLocked 
				and not heritageArmor then
				setData["name"] = L[setData["name"]]
				local note = "NOTE_"..(setData.label or 0)
				setData.label =(L[note] and L[note]) or ""

				setInfo[id] = setData
				tinsert(baseList, setInfo[id])	
			end
		end
	end

	function addon.buildDB()
	--local faction = GetFactionID(UnitFactionGroup("player"))
		local armorSet = addon.ArmorSets[ClassArmor[playerClass]]

		addArmor(armorSet)
		addArmor(addon.ArmorSets["COSMETIC"])

		--Add Hidden Set
		setInfo[0] = hiddenSet
		tinsert(baseList, setInfo[0])
		wipe(addon.ArmorSets)
	end


	function addon.GetBaseList()
		return baseList
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
		return setInfo[setID]
	end

end