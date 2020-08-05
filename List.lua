local BPCM = select(2, ...)

BPCM.List = {
	Table = {},
	Title = "Generic List",
	TitleColor = "FFFFFFFF"
};

local List = BPCM.List
local Table = {};


function List:new (o)
	o = o or { Table = {} };
	local obj = setmetatable(o, List);
	self.__index = self;
	self:SetTable(o.Table);
	return o;
end


function List:TableCount(theTable)
	local count = 0;
	for index, value in pairs(theTable) do
		count = count + 1;
	end
	return count;
end


function List:GetTitle()
	return "|c"..tostring(self.TitleColor)..tostring(self.Title).."|r";
end


function List:Print(text)
	print(self:GetTitle()..tostring(text));
end


function List:Count()
	return List:TableCount(self:GetTable());
end


function List:Set(item, value)
	local table = self:GetTable();
	table[item] = value;
	self:SetTable(table);
end


function List:Clear()
	self:SetTable({});
end


function List:FindIndex(indexToFind)
	if not indexToFind then
		return;
	end
	for index, value in pairs(self:GetTable()) do
		indexLowered = index:gsub("%*", "%.%*"):lower();
		indexToFindLowered = indexToFind:lower();
   		if indexLowered == indexToFindLowered or indexToFindLowered:find("^"..indexLowered.."$") then
			return index;
		end
	end
end


function List:FindIndexByValue(valueToFind)
   	for index, value in pairs(self:GetTable()) do
		if value == valueToFind then
			return index;
		end
	end
end


function List:Contains(item)
	return self:FindIndex(item) ~= nil;
end


function List:Populate(items)
	local table = {};
	for index, item in pairs(items) do
		if item ~= "" then
			table[item] = List:TableCount(table) + 1;
		end
	end
	self:SetTable(table);
	self:Print(" updated.");
end


function List:ToString()
	local list = "";
	for index = 0, self:Count() do
		local item = self:FindIndexByValue(index);
		if item ~= nil then
			list = list..item.."\n";
		end
	end
	return list;
end


function List:GetTable()
	return Table;
end


function List:SetTable(value)
	Table = value;
end


BPCM.PetBlacklist = List:new {
	Title = "Pet Blacklist",
	TitleColor = "FFA9A9A9";
}
local PetBlacklist = BPCM.PetBlacklist 


function PetBlacklist:new (o)
	o = o or {};
	setmetatable(o, PetBlacklist);
	self.__index = self;
	return o;
end


function PetBlacklist:GetTable()
	return BPCM.Profile.Pet_Blacklist;
end


function PetBlacklist:SetTable(value)
	BPCM.Profile.Pet_Blacklist = value;
end


BPCM.PetWhitelist = List:new {
	Title = "Pet Whitelist",
	TitleColor = "FFA9A9A9";
}
local PetWhitelist = BPCM.PetWhitelist


function PetWhitelist:new (o)
	o = o or {};
	setmetatable(o, PetWhitelist);
	self.__index = self;
	return o;
end


function PetWhitelist:GetTable()
	return BPCM.Profile.Pet_Whitelist;
end


function PetWhitelist:SetTable(value)
	BPCM.Profile.Pet_Whitelist = value;
end