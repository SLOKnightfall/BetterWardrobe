local addonName, addon = ...

local armorForMask = {
	[1] = "PLATE", [2] = "PLATE", [32] = "PLATE", [35] = "PLATE",
	[4] = "MAIL", [64] = "MAIL", [68] = "MAIL", [4096] = "MAIL", [4164] = "MAIL",
	[8] = "LEATHER", [512] = "LEATHER", [1024] = "LEATHER", [2048] = "LEATHER", [3592] = "LEATHER", [11784] = "LEATHER",
	[16] = "CLOTH", [128] = "CLOTH", [256] = "CLOTH", [400] = "CLOTH",
}

local function GetExplicitSourceCategory(data)
	if data.tp then return "Trading Post" end
	if data.shop then return "Blizzard Shop" end
	if data.pvp then return "PvP" end
	if data.raceID or data.heritage then return "Racial Heritage" end
	local text = ((data.label or "") .. " " .. (data.description or "") .. " " .. (data.note or "")):lower()
	if text:find("promotion", 1, true) or text:find("recruit-a-friend", 1, true) then return "Promotion" end
	if text:find("heritage", 1, true) then return "Racial Heritage" end
	return nil
end

for _, callback in pairs(addon.ExpandedCallbacks) do
	if type(callback) == "function" then callback(false) end
end

for setID, data in pairs(addon._embeddedArmorSets) do
	local armorType = armorForMask[data.classMask] or "COSMETIC"
	addon.ArmorSets[armorType] = addon.ArmorSets[armorType] or {}
	data.itemData = data.itemData or {}
	data.extendedSources = data.sources or {}
	data.extendedAltSources = data.altSources or {}
	-- BetterWardrobe uses one-based expansion filter indexes; ExtendedSets stores
	-- Blizzard's zero-based expansion IDs.
	data.expansionID = (tonumber(data.expansionID) or 0) + 1
	data.sourceCategory = GetExplicitSourceCategory(data)
	data.filter = data.filter or 2
	data.custom = data.label or data.name
	addon.ArmorSets[armorType][setID] = data
end

addon.BundledExtendedArmorSetCount = 0
addon.BundledExtendedAlternateCount = 0
for _ in pairs(addon._embeddedArmorSets) do
	addon.BundledExtendedArmorSetCount = addon.BundledExtendedArmorSetCount + 1
end
for _, data in pairs(addon._embeddedArmorSets) do
	for _, sources in pairs(data.extendedAltSources or {}) do
		addon.BundledExtendedAlternateCount = addon.BundledExtendedAlternateCount + math.max(0, #sources - 1)
	end
end
