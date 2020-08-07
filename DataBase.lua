--local BPCM = select(2, ...)
local addonName, addon = ...

local TextDump = LibStub("LibTextDump-1.0")
addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")

--addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

--local L = LibStub("AceLocale-3.0"):GetLocale("MountBuddy")
--local AceGUI = LibStub("AceGUI-3.0")

local Utilities = {}
local DB = {}
addon.Utilities = Utilities
local _, class, classID = UnitClass("player")
--local armorType = DB.GetClassArmorType(class)
				  
local faction = UnitFactionGroup("player")
--local role = GetFilteredRole()
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

	--Utilities.Debug = Debug
	Utilities.DebugPour = DebugPour
	Utilities.Export = Export
	Utilities.GetDebugger =  GetDebugger
	Utilities.ClearDebug = ClearDebugger

	function Utilities.Debug(message, prioirity)
		if not prioirity or prioirity > debugPriority then return end

		Debug(message)
	end
end

local Debug = Utilities.Debug

---------
--print(TextDump)

--[[
function DB.GetClassArmorType(class)
	if		class == "DEATHKNIGHT"	then return PLATE.Description
	elseif	class == "DEMONHUNTER"	then return LEATHER.Description
	elseif	class == "DRUID"		then return LEATHER.Description
	elseif	class == "HUNTER"		then return MAIL.Description
	elseif	class == "MAGE"			then return CLOTH.Description
	elseif	class == "MONK"			then return LEATHER.Description
	elseif	class == "PALADIN"		then return PLATE.Description
	elseif	class == "PRIEST"		then return CLOTH.Description
	elseif	class == "ROGUE"		then return LEATHER.Description
	elseif	class == "SHAMAN"		then return MAIL.Description
	elseif	class == "WARLOCK"		then return CLOTH.Description
	elseif	class == "WARRIOR"		then return PLATE.Description
	else return ANY.Description
	end
end
]]




AltSetMixin = {}
function AltSetMixin:GetSets()



end










--local module = mog:GetModule("MogIt_Wardrobe") or mog:RegisterModule("MogIt_Wardrobe",{});
local sets = {
	Cloth = {},
	Leather = {},
	Mail = {},
	Plate = {},
};

local armor = {
	"Cloth",
	"Leather",
	"Mail",
	"Plate",
};

local list = {};
local data = {
	name = {},
	items = {},
	class = {},
	faction = {},
};
local newmail = {}

addon.sets = sets

addon.setList = {}
addon.baseList = {}


local function AddData(id,name,items,class,faction)
	data.name[id] = name;
	data.items[id] = items;
	data.class[id] = class;
	data.faction[id] = faction;
end



local function GetData(id)
	return data.name[id],data.items[id],data.class[id],data.faction[id]
end

function addon.AddCloth(id,...)
	tinsert(sets.Cloth,id);
	AddData(id,...);
end

function addon.AddLeather(id,...)
	tinsert(sets.Leather,id);
	AddData(id,...);
end

function addon.AddMail(id,...)

	--local _, class = UnitClass("player")
	--print(class)
--local armorType = DB.GetClassArmorType(class)
				  
--local faction = UnitFactionGroup("player")
	local id = id
	local name,items,class,faction = ...
if faction then

end
if  class and class ~= classID then
	--Utilities.Debug("Skiped: "..id, 100)
	return false
end

	tinsert(sets.Mail,id);
	AddData(id,...);
	addon.AddSet(id, ...)
end

function addon.AddPlate(id,...)
	tinsert(sets.Plate,id)
	AddData(id,...)
	--addon.AddSet(id, ...)
end


function addon.AddSet(id,name,items,class,faction)
	local setInfo = {}
	setInfo.classMask = class;
	setInfo.collected = false; 	
	setInfo.description = "";
	setInfo.expansionID	= "";
	setInfo.favorite = "";
	setInfo.hiddenUtilCollected	= false;
	setInfo.label = "";
	setInfo.limitedTimeSet = false;
	setInfo.name = name;
	setInfo.patchID = "";
	setInfo.requiredFaction = faction;
	setInfo.setID = id;
	setInfo.uiOrder = "";
	setInfo.items = items;
	tinsert(addon.baseList, setInfo)
	addon.setList[id] = setInfo
end

function addon.GetSetInfo(setID)
	return addon.setList[setID]
end

function addon.GetSets( setType )
	return sets[setType]
end

function addon.GetSetData( setID)
	return GetData(setID)
end

function addon.GetSetIcon(setID)
	local items = data.items[setID]
	local setIcon
	for i, item in ipairs(items) do
		local  _, _, _, category, itemIcon  = GetItemInfoInstant(item)
		if category == "INVTYPE_HEAD" then
			return itemIcon
		end

		if category == "INVTYPE_CHEST" then
			setIcon = itemIcon
		end
	end
	return setIcon
end

function addon.GetSetCsompletion(setID)
	SetsDataProvider:GetSetSourceData(setID)

	--local sLink = select(2, GetItemInfo(appearances[i].itemID))
	--local itemID, itemType, itemSubType, itemEquipLoc, icon, itemClassID, itemSubClassID  = GetItemInfoInstant(itemID)

--[[
	--print(count)
	local complete = 0
	local items = data.items[setID]
	local count = #items

	for i, item in ipairs(items) do

        local sLink = select(2, GetItemInfo(item))
       local  _, sourceID, _ = SetCollector:GetAppearanceInfo(sLink)
      
      if sourceID then
        isCollected = select(5, C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
		--Utilities.GetDebugger()
		--Utilities.Debug(addon.inspect(sets.Mail),100)

		--local id, sourceID = C_TransmogCollection.GetItemInfo(item)
		--print(id)
	
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
		if sourceInfo.isCollected then 
			complete = complete +1
		end
	
	end




--print(setID)
local collectedCount = 0
  local isCollected
	--local complete = 0
	local items = data.items[setID]
	--local count = #items

	for i, item in ipairs(items) do
		--for i=1, #appearances do
     -- local sourceID = appearances[i].sourceID
      --if not sourceID or sourceID == 0 then
      	--print(type(item))
        local sLink
        --print(select(2, GetItemInfo(98188)))
        local tempItem = Item:CreateFromItemID(item)
		tempItem:ContinueOnItemLoad(function()
			sLink = tempItem:GetItemLink()
			--print(sLink)
		end)
		--print(sLink)
        _, sourceID, _ = SetCollector:GetAppearanceInfo(sLink)
    
     	if sourceID then
      --	Utilities.Debug(sLink,100)
        isCollected = select(5, C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
      	end
      if isCollected then collectedCount = collectedCount + 1 end
    end

  return collectedCount, #items
	--return complete, count
	]]
	return 0,0

end


function bob()
--print(string.format tostring(sets))
--Utilities.Debug(sets.Mail,100)
--Utilities.Debug(C_TransmogSets.GetSetSources(1907),100)
print("	Basb")
local app, _ = C_TransmogCollection.GetItemInfo(6591)
print(C_TransmogCollection.GetItemInfo(6591))
print(C_TransmogCollection.GetItemInfo(24869))
Utilities.GetDebugger()
Utilities.Debug("te")
Utilities.Debug(C_TransmogCollection.GetItemInfo(6591))
Utilities.Debug(C_TransmogCollection.GetAllAppearanceSources(2179))
local all = C_TransmogCollection.GetAllAppearanceSources(2179)
for i, set in ipairs(all) do
	print(set)
end
	end

