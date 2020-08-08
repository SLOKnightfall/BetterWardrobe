local addonName, addon = ...

local TextDump = LibStub("LibTextDump-1.0")
addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
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

local classBits = {
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

local ClassArmor = {
	DEATHKNIGHT ="PLATE",
	DEMONHUNTER="LEATHER",
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



local function GetFactionID(faction)
	if faction == "Horde" then
		return -- 64
	elseif faction == "Alliance" then
		return --4
	end

end


do
	local baseList = {}

	function addon.buildDB()
	--local faction = GetFactionID(UnitFactionGroup("player"))
		local armorSet = addon.ArmorSets[ClassArmor[playerClass]]

		for i, setData in ipairs(armorSet) do
			local id = setData[1]
			local class = setData[4]
			local faction = setData[5]

			if  class and class == classBits[playerClass] or not class then
			--if faction then  TODO: Add Faction Check
				addon.AddSet(setData)
			end

		end

		wipe(addon.ArmorSets)
	end


	function addon.GetBaseList()
		return baseList
	end

	local setInfo = {}

	function addon.AddSet(setData)
	--function addon.AddSet(id,name,items,class,faction)

		local id = setData[1]

		local info = {}
		info.classMask = setData[4] --class
		info.collected = false 	
		info.description = ""
		info.expansionID	= ""
		info.favorite = ""
		info.hiddenUtilCollected	= false
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