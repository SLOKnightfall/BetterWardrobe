local addonName, addon = ...

-- Embedded Extended Transmog Sets runtime. BetterWardrobe remains a two-folder
-- addon and continues to own the Items, Sets, and Extra interfaces.
addon.expandedID = 1000000
addon.ExpandedCallbacks = {}
addon.altAppearancesDB = {}
addon.altLabelDB = {}
addon.altLabelAppendDB = {}
addon.altNoteDB = {}
addon.altPatchID = {}
addon.addedAppearance = {}
addon.replaceAppearance = {}
addon.GetExpacWepSetNameBySetID = {}
addon.GetExpacArmorSetNameBySetID = {}
addon.GetExpacArmorSetSourcesBySetID = {}
addon.GetExpacWepSetSourcesBySetID = {}
addon.isRaidSet = {}
addon.neverObtainDB = {}
addon.GenerateSetInfo = {}
addon.holidayDB = {}
addon.WeaponCallbacks = {}
addon.setsCustomLabels = addon.setsCustomLabels or {}
addon.setsSetClassMask = addon.setsSetClassMask or {}
addon._embeddedArmorSets = {}
addon.devMode = false
addon.devModeNoisy = false
addon.devColor = false

addon.colors = {
	TRANSMOG_PINK = "cffff80ff",
	SYSTEM_YELLOW = "cffFFFC01",
	GREEN_FONT_COLOR = CreateColor(0.251, 0.753, 0.251),
	GREEN_FONT_COLOR_CODE = "|cff40c040",
	GREEN_LIST_COLOR = CreateColor(0.149, 0.580, 0.149),
	RED_FONT_COLOR = CreateColor(0.8, 0.2, 0.08),
	YELLOW_FONT_COLOR = CreateColor(0.69, 0.62, 0.23),
	BLUE_FONT_COLOR = CreateColor(0.34, 0.47, 0.84),
	BLUE_BAR_COLOR = CreateColor(0.27, 0.39, 0.75),
	GRAY_BAR_COLOR = CreateColor(0.2, 0.2, 0.2),
	PERC = {},
}
for index = 1, 10 do
	local progress = index / 10
	addon.colors.PERC[index] = CreateColor(0.8 - (0.49 * progress), 0.2 + (0.5 * progress), 0.08 + (0.15 * progress))
end

function addon.ColorString(text, red, green, blue)
	if red <= 1 and red > 0 then red, green, blue = red * 255, green * 255, blue * 255 end
	return ("|cFF%02X%02X%02X%s|r"):format(red, green, blue, text or "")
end

function addon.GetFactionColoredString(text, faction)
	if faction == "Horde" then
		return "|A:worldquest-icon-horde:12:12:0:-1|a |cFFB02626" .. text .. "|r"
	end
	return "|A:worldquest-icon-alliance:12:12:0:-1|a |cFF0E50D0" .. text .. "|r"
end

function addon.MergeColors(percent)
	if percent <= 0 then return addon.colors.GRAY_BAR_COLOR end
	if percent >= 1 then return addon.colors.BLUE_BAR_COLOR end
	return addon.colors.PERC[math.max(1, math.min(10, math.ceil(percent * 10)))]
end

addon.SetsFrame = {
	AddSetToTables = function(data)
		if data and data.setID then addon._embeddedArmorSets[data.setID] = data end
	end,
	GetSetSourceCounts = function(setID)
		local data = addon._embeddedArmorSets[setID]
		local collected, total = 0, 0
		if data and data.sources then
			for sourceID in pairs(data.sources) do
				total = total + 1
				local info = sourceID and C_TransmogCollection.GetSourceInfo(sourceID)
				if info and info.isCollected then collected = collected + 1 end
			end
		end
		return collected, total
	end,
}

-- Standalone integration points intentionally unused by the embedded build.
addon.UseSetForTransmogrify = function() end
addon.AddSetToNotUsedTable = function() end
addon.ExS_AH_Init_Wep = function() end

function addon.GetColoredClassNameString(classMask)
	local map = addon.Globals and addon.Globals.CLASS_MASK_TO_ID
	local classID = map and map[classMask]
	if not classID then return "" end
	local className, classFile = GetClassInfo(classID)
	local color = classFile and C_ClassColor.GetClassColor(classFile)
	return color and color:WrapTextInColorCode(className) or className or ""
end

ExS_Settings = ExS_Settings or {}
ExS_Settings.hideWeaponsTab = false
ExS_Settings.weaponExpansionToggles = ExS_Settings.weaponExpansionToggles or {}
for index = 1, GetClientDisplayExpansionLevel() + 1 do
	if ExS_Settings.weaponExpansionToggles[index] == nil then ExS_Settings.weaponExpansionToggles[index] = true end
end
if ExS_Settings.showDualWielding == nil then ExS_Settings.showDualWielding = false end
if ExS_Settings.stayOnWeaponType == nil then ExS_Settings.stayOnWeaponType = false end
if ExS_Settings.progressBarByFilter == nil then ExS_Settings.progressBarByFilter = true end
if ExS_Settings.hideNoLongerObtainable == nil then ExS_Settings.hideNoLongerObtainable = false end
if ExS_Settings.hideNeverObtainable == nil then ExS_Settings.hideNeverObtainable = true end
if ExS_Settings.showHiddenSets == nil then ExS_Settings.showHiddenSets = false end
if ExS_Settings.showOnlyRaidSets == nil then ExS_Settings.showOnlyRaidSets = false end
if ExS_Settings.displayOtherFaction == nil then ExS_Settings.displayOtherFaction = false end
if ExS_Settings.hideListDescription == nil then ExS_Settings.hideListDescription = false end
if ExS_Settings.flipNameAndLabel == nil then ExS_Settings.flipNameAndLabel = false end
if ExS_Settings.wepUndressModel == nil then ExS_Settings.wepUndressModel = false end
if ExS_Settings.showTooltipSetInfo == nil then ExS_Settings.showTooltipSetInfo = false end
ExS_Settings.extraButtonToggles = ExS_Settings.extraButtonToggles or { true, true, true, true }

ExS_Weapon_HiddenSets = ExS_Weapon_HiddenSets or {}
ExS_Weapon_Favorites = ExS_Weapon_Favorites or {}
