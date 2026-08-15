local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local expansionID = 0;

--These are missing set items from the trial of style event
local SetAdditions = {
--[blizzard set ID] = {Item ID}    
	[298] = {190064}, --sanctified-ymirjar-lords-battlegear-25-Heroic-recolor
	[700] = {190673}, --battleplate-of-immolation-Heroic-recolor
	[835] = {190858}, --elementium-deathplate-battlearmor-Heroic-recolor
	[634] = {190544},--volcanic-regalia-Heroic-recolor
	[741] = {190167},--conquerors-scourgestalker-battlegear-25-recolor
	[643] = {190697},--conquerors-worldbreaker-regalia-25-recolor
	[1482] = {190429},--bearmantle-battlegear-Mythic-recolor
	[1507] = {190202},--regalia-of-the-dashing-scoundrel-Mythic-recolor
	[1506] = {190202},--regalia-of-the-dashing-scoundrel-Mythic-recolor
	[693] = {190830},--conquerors-terrorblade-battlegear-25-recolor
	[348] = {190803},--sanctified-crimson-acolyte-regalia-25-Heroic
	[664] = {190888},--vestments-of-the-faceless-shroud-Heroic-recolor
	[716] = {189870},--firehawk-robes-of-conflagration-Heroic-recolor
}

--altitems now lives in Data/altitems/*.lua, split by expansion/season and merged into addon.AltItems.
addon.AltItems = addon.AltItems or {}
local altitems = addon.AltItems


--This will check to see if a set has items to add and then adds them
function addon:CheckForExtraItems(setID, data)
	if SetAdditions[setID]  then
		--print(C_TransmogCollection.GetItemInfo(setID))
		for _, itemID in ipairs(SetAdditions[setID]) do
			local itemAppearanceID, itemModifiedAppearanceID = C_TransmogCollection.GetItemInfo(itemID)
			--GetAppearanceSourceInfo returns a single info table now, not positional values.
			local sourceInfo = C_TransmogCollection.GetAppearanceSourceInfo(itemModifiedAppearanceID)
			local isCollected = sourceInfo and sourceInfo.isCollected
			if itemAppearanceID then
				tinsert(data,{["collected"] = isCollected, ["appearanceID"] = itemModifiedAppearanceID})
			end
		end
	end
	return data
	--C_TransmogCollection.GetItemInfo(202542)
end


--altitems is mostly one-directional (e.g. [36576] = 36581, no reverse entry); build a
--symmetric index so any member of a group finds every other member.
local altItemGroups

local function BuildAltItemGroups()
	altItemGroups = {}
	for baseID, alt in pairs(altitems) do
		local members = { baseID }
		if type(alt) == "table" then
			for _, id in ipairs(alt) do
				tinsert(members, id)
			end
		else
			tinsert(members, alt)
		end

		for _, memberID in ipairs(members) do
			local others = altItemGroups[memberID]
			if not others then
				others = {}
				altItemGroups[memberID] = others
			end
			for _, otherID in ipairs(members) do
				if otherID ~= memberID and not tContains(others, otherID) then
					tinsert(others, otherID)
				end
			end
		end
	end
end

function addon:CheckAltItem(sourceID)
	if not altItemGroups then
		BuildAltItemGroups()
	end
	return altItemGroups[sourceID]
end