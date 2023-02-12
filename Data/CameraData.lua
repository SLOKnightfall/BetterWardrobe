local addonName, addon = ...
---addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local Camera = {}
addon.Camera = Camera
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local _, playerRace, playerRaceID = UnitRace("player")
local genders = {
	[2] = "Male",
	[3] = "Female",
}
local gender = genders[UnitSex("player")]

function Camera:GetCameraID(item, force)
	local cameraType, isWeapon, cameraID
	local itemid, _, _, slot, _, class, subclass = GetItemInfoInstant(item)
	slot = addon.Globals.INVENTORY_SLOT_NAMES[slot]
	slot = addon.Globals.INVENTORY_SLOT_NAMES[slot]

	if addon.Globals.CAMERAS[class][subclass] and not Camera.lookupItems[slot] then
		isWeapon = true
		cameraID = addon.Globals.CAMERAS[class][subclass]
		
	else
		local race = playerRace
		local force =  addon.Profile.TooltipPreview_SwapModifier ~= L["None"] and addon.Globals.mods[addon.Profile.TooltipPreview_SwapModifier]()

		local inAltForm = select(2, C_PlayerInfo.GetAlternateFormInfo())

		if race == 'Worgen' and addon.Profile.TooltipPreview_SwapDefault or (force and  not inAltForm) or (not force and inAltForm) then
			race = 'WorgenAlt'
		end

		if race == 'Dracthyr' and addon.Profile.TooltipPreview_SwapDefault or (force and  not inAltForm) or (not force and inAltForm) then
			race = 'DracthyrAlt'
		end

		local cameraItem = Camera.lookupItems[slot]
		local itemAppearanceID, itemModifiedAppearanceID = C_TransmogCollection.GetItemInfo(cameraItem)
		cameraID = C_TransmogCollection.GetAppearanceCameraID(itemAppearanceID)

		cameraType = ("%s-%s-%s"):format(race, gender, slot)
	end

	return Camera.raceCameraIDs[cameraType] or cameraID, isWeapon
end

function Camera:GetCameraIDBySlot(slotID, force)
	local slot = addon.Globals.CATEGORYID_TO_NAME[slotID]
	local cameraType
	local race = playerRace

	if not addon.useNativeForm or force then
		if race == 'Worgen' then
			race = 'WorgenAlt'
		end

		if race == 'Dracthyr'  then
			race = 'DracthyrAlt'
		end
	end

	cameraType = ("%s-%s-%s"):format(race, gender, slot)

	local cameraItem = Camera.lookupItems[slot]
	local itemAppearanceID, itemModifiedAppearanceID = C_TransmogCollection.GetItemInfo(cameraItem)
	local cameraID = C_TransmogCollection.GetAppearanceCameraID(itemAppearanceID)
	return Camera.raceCameraIDs[cameraType] or cameraID, false
end

addon.Globals.CAMERAS = {[2]={243,251,252,244,245,247,238,239,624,246,248,241,253,253,241,253,247,253,240,818,[0] = 242}, [4] = { [0] = 250, [6]=249}} --

Camera.lookupItems={
	["HEADSLOT"] = 191616,
	["SHOULDERSLOT"] = 191620,
	["BACKSLOT"] = 200763,
	["CHESTSLOT"] = 191617,
	["SHIRTSLOT"] = 6833,
	["TABARDSLOT"] = 142504,
	["WRISTSLOT"] = 200687,
	["HANDSSLOT"] = 191774,
	["WAISTSLOT"] = 191621,
	["LEGSSLOT"] = 191618,
	["FEETSLOT"] = 191622,
}

Camera.raceCameraIDs = {
	["Dracthyr-Female-HEADSLOT"] = 1702,
	["Dracthyr-Female-SHOULDERSLOT"] = 1704,
	["Dracthyr-Female-BACKSLOT"] = 1706,
	["Dracthyr-Female-CHESTSLOT"] = 1698,
	["Dracthyr-Female-SHIRTSLOT"] = 1709,
	["Dracthyr-Female-TABARDSLOT"] = 1707,
	["Dracthyr-Female-WRISTSLOT"] = 1711,
	["Dracthyr-Female-HANDSSLOT"] = 1708,
	["Dracthyr-Female-WAISTSLOT"] = 1700,
	["Dracthyr-Female-LEGSSLOT"] = 1701,
	["Dracthyr-Female-FEETSLOT"] = 1705,

	["DracthyrAlt-Female-HEADSLOT"] = 274,
	["DracthyrAlt-Female-SHOULDERSLOT"] = 275,
	["DracthyrAlt-Female-BACKSLOT"] = 276,
	["DracthyrAlt-Female-CHESTSLOT"] = 278,
	["DracthyrAlt-Female-SHIRTSLOT"] = 278,
	["DracthyrAlt-Female-TABARDSLOT"] = 279,
	["DracthyrAlt-Female-WRISTSLOT"] = 280,
	["DracthyrAlt-Female-HANDSSLOT"] = 281,
	["DracthyrAlt-Female-WAISTSLOT"] = 282,
	["DracthyrAlt-Female-LEGSSLOT"] = 283,
	["DracthyrAlt-Female-FEETSLOT"] = 284,

	["Dracthyr-Male-HEADSLOT"] = 1702,
	["Dracthyr-Male-SHOULDERSLOT"] = 1704,
	["Dracthyr-Male-BACKSLOT"] = 1706,
	["Dracthyr-Male-CHESTSLOT"] = 1698,
	["Dracthyr-Male-SHIRTSLOT"] = 1709,
	["Dracthyr-Male-TABARDSLOT"] = 1707,
	["Dracthyr-Male-WRISTSLOT"] = 1711,
	["Dracthyr-Male-HANDSSLOT"] = 1708,
	["Dracthyr-Male-WAISTSLOT"] = 1700,
	["Dracthyr-Male-LEGSSLOT"] = 1701,
	["Dracthyr-Male-FEETSLOT"] = 1705,

	["DracthyrAlt-Male-HEADSLOT"] = 1713,
	["DracthyrAlt-Male-SHOULDERSLOT"] = 455,
	["DracthyrAlt-Male-BACKSLOT"] = 1714,
	["DracthyrAlt-Male-CHESTSLOT"] = 457,
	["DracthyrAlt-Male-SHIRTSLOT"] = 458,
	["DracthyrAlt-Male-TABARDSLOT"] = 1715,
	["DracthyrAlt-Male-WRISTSLOT"] = 460,
	["DracthyrAlt-Male-HANDSSLOT"] = 461,
	["DracthyrAlt-Male-WAISTSLOT"] = 462,
	["DracthyrAlt-Male-LEGSSLOT"] = 463,
	["DracthyrAlt-Male-FEETSLOT"] = 464,

	["Worgen-Male-HEADSLOT"] = 309,
	["Worgen-Male-SHOULDERSLOT"] = 310,
	["Worgen-Male-BACKSLOT"] = 311,
	["Worgen-Male-CHESTSLOT"] = 312,
	["Worgen-Male-SHIRTSLOT"] = 313,
	["Worgen-Male-TABARDSLOT"] = 314,
	["Worgen-Male-WRISTSLOT"] = 315,
	["Worgen-Male-HANDSSLOT"] = 316,
	["Worgen-Male-WAISTSLOT"] = 317,
	["Worgen-Male-LEGSSLOT"] = 318,
	["Worgen-Male-FEETSLOT"] = 319,

	["WorgenAlt-Male-HEADSLOT"] = 236,
	["WorgenAlt-Male-SHOULDERSLOT"] = 221,
	["WorgenAlt-Male-BACKSLOT"] = 235,
	["WorgenAlt-Male-CHESTSLOT"] = 674,
	["WorgenAlt-Male-SHIRTSLOT"] = 229,
	["WorgenAlt-Male-TABARDSLOT"] = 230,
	["WorgenAlt-Male-WRISTSLOT"] = 237,
	["WorgenAlt-Male-HANDSSLOT"] = 226,
	["WorgenAlt-Male-WAISTSLOT"] = 234,
	["WorgenAlt-Male-LEGSSLOT"] = 228,
	["WorgenAlt-Male-FEETSLOT"] = 227,

	["Worgen-Female-HEADSLOT"] = 320,
	["Worgen-Female-SHOULDERSLOT"] = 321,
	["Worgen-Female-BACKSLOT"] = 322,
	["Worgen-Female-CHESTSLOT"] = 324,
	["Worgen-Female-SHIRTSLOT"] = 324,
	["Worgen-Female-TABARDSLOT"] = 325,
	["Worgen-Female-WRISTSLOT"] = 326,
	["Worgen-Female-HANDSSLOT"] = 327,
	["Worgen-Female-WAISTSLOT"] = 328,
	["Worgen-Female-LEGSSLOT"] = 329,
	["Worgen-Female-FEETSLOT"] = 330,

	["WorgenAlt-Female-HEADSLOT"] = 274,
	["WorgenAlt-Female-SHOULDERSLOT"] = 275,
	["WorgenAlt-Female-BACKSLOT"] = 276,
	["WorgenAlt-Female-CHESTSLOT"] = 278,
	["WorgenAlt-Female-SHIRTSLOT"] = 278,
	["WorgenAlt-Female-TABARDSLOT"] = 279,
	["WorgenAlt-Female-WRISTSLOT"] = 280,
	["WorgenAlt-Female-HANDSSLOT"] = 281,
	["WorgenAlt-Female-WAISTSLOT"] = 282,
	["WorgenAlt-Female-LEGSSLOT"] = 283,
	["WorgenAlt-Female-FEETSLOT"] = 284,

}
