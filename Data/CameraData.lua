local myname, ns = ...
local addonName, addon = ...
---addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
addon.Camera = {}

local races = {
	[1] = "Human",
	[2] = "Orc",
	[3] = "Dwarf",
	[4] = "NightElf",
	[5] = "Scourge",
	[6] = "Tauren",
	[7] = "Gnome",
	[8] = "Troll",
	[9] = "Goblin",
	[10] = "BloodElf",
	[11] = "Draenei",
	[22] = "Worgen",
	[24] = "Pandaren",
	[52] = "Dracthyr",
	[70] = "Dracthyr",

	[27] = "NightElf", -- "Nightborne",
	[28] = "Tauren", -- "HighmountainTauren",
	[29] = "BloodElf", -- "VoidElf",
	[30] = "Draenei", -- "LightforgedDraenei",
	[34] = "Dwarf", -- "DarkIronDwarf",
	[35] = "Goblin", 
	[36] = "Orc", -- "MagharOrc",
	[37] = "Gnome",
}

local genders = {
	[1] = "Male",
	[3] = "Female",
}

local AltForms = {
	["Nightborne"] = "NightElf",
	["MagharOrc"] = "Orc",
	["LightforgedDraenei"] = "Draenei",
	["KulTiran"] = "Human",
	["HighmountainTauren"] = "Tauren",
	["VoidElf"] = "BloodElf",
	["Mechagnome"] = "Gnome",
	["Vulpera"] = "Goblin",
	["ZandalariTroll"] = "Troll",
	["DarkIronDwarf"] = "Dwarf",
	["Dracthyr"] = "BloodElf",
}

local slots = {
	INVTYPE_BODY = "ShirtSlot",
	INVTYPE_ChestSlot = "ChestSlot",
	INVTYPE_CLOAK = "BackSlot",
	INVTYPE_FeetSlot = "FeetSlot",
	INVTYPE_HAND = "HandsSlot",
	INVTYPE_HeadSlot = "HeadSlot",
	INVTYPE_LegsSlot = "LegsSlot",
	INVTYPE_ROBE = "Robe",
	INVTYPE_ShoulderSlot = "ShoulderSlot",
	-- INVTYPE_ShoulderSlot = "ShoulderSlot-Alt",
	INVTYPE_TABARD = "Tabard",
	INVTYPE_WaistSlot = "WaistSlot",
	INVTYPE_WristSlot = "WristSlot",
}
local item_slots = {
	INVTYPE_2HWEAPON = true,
	INVTYPE_WEAPON = true,
	INVTYPE_WEAPONMAINHAND = true,
	INVTYPE_WEAPONOFFHAND = true,
	INVTYPE_RANGED = true,
	INVTYPE_RANGEDRIGHT = true,
	INVTYPE_HOLDABLE = "Offhand",
	INVTYPE_SHIELD = "Shield",
}


	
local subclasses = {
	[Enum.ItemWeaponSubclass.Dagger] = "Dagger",
	[Enum.ItemWeaponSubclass.Unarmed] = "FistWeapon",
	[Enum.ItemWeaponSubclass.Axe1H] = "1HAxe",
	[Enum.ItemWeaponSubclass.Mace1H] = "1HMace",
	[Enum.ItemWeaponSubclass.Sword1H] = "1HSword",
	[Enum.ItemWeaponSubclass.Axe2H] = "2HAxe",
	[Enum.ItemWeaponSubclass.Mace2H] = "2HMace",
	[Enum.ItemWeaponSubclass.Sword2H] = "2HSword",
	[Enum.ItemWeaponSubclass.Polearm] = "Polearm",
	[Enum.ItemWeaponSubclass.Staff] = "Staff",
	[Enum.ItemWeaponSubclass.Warglaive] = "Glaive",
	[Enum.ItemWeaponSubclass.Bows] = "Bow",
	[Enum.ItemWeaponSubclass.Crossbow] = "Crossbow",
	[Enum.ItemWeaponSubclass.Guns] = "Gun",
	[Enum.ItemWeaponSubclass.Wand] = "Wand",
	-- FallBackSlots
	[Enum.ItemWeaponSubclass.Fishingpole] = "Staff",
	[Enum.ItemWeaponSubclass.Generic] = "1HSword",
}

local _, playerRace, playerRaceID = UnitRace("player")
local playerSex
if UnitSex("player") == 2 then
	playerSex = "Male";
else
	playerSex = "Female";
end

local slots_to_cameraids, slot_override

function addon.Camera:GetCameraID(itemLinkOrID, race, gender)
	local key, itemcamera
	local itemid, _, _, slot, _, class, subclass = GetItemInfoInstant(itemLinkOrID)
	if item_slots[slot] then
		itemcamera = true
		if item_slots[slot] then
			key = "Weapon-" .. subclasses[subclass]
		else
			key = "Weapon-" .. item_slots[slot]
		end
	else
		race = races[race]
		race = race or playerRace
		if race == 'Worgen' and not select(2, C_PlayerInfo.GetAlternateFormInfo()) then
			race = 'Human'
		end
		if race == 'Dracthyr' and not select(2, C_PlayerInfo.GetAlternateFormInfo()) then
			gender = 'Male'
			race = 'BloodElf'
		end
		

		gender = gender or playerSex
		race = race or race[race]
		
		key = ("%s-%s-%s"):format(race, gender, slot_override[itemid] or slots[slot] or "Default")
	end
	return slots_to_cameraids[key], itemcamera
end

function addon.Camera:GetCameraIDBySlot(slotID, race, gender)
	local key, itemcamera
	race = race or playerRace
	gender = gender or playerSex

	if  not addon.useNativeForm then
		if race == 'Worgen' then
			race = 'Human'
		end
		
		if race == 'Dracthyr'  then
			gender = 'Male'
			race = 'BloodElf'
		end
	end

	if addon.useNativeForm and race == 'Dracthyr' then
		gender = 'Male'
	end

	key = ("%s-%s-%s"):format(race, gender, addon.Globals.slots[slotID] or "Default")
	return slots_to_cameraids[key], itemcamera
end

addon.Globals.CAMERAS = {[2]={243,251,252,244,245,247,238,239,624,246,248,241,253,253,240,253,247,253,240,818,[0] = 242}, [4] = {[0] = 250, [6]=249}}

addon.Camera.slot_facings = {
	INVTYPE_HeadSlot = 0,
	INVTYPE_ShoulderSlot = 0,
	INVTYPE_CLOAK = 3.4,
	INVTYPE_ChestSlot = 0,
	INVTYPE_ROBE = 0,
	INVTYPE_WristSlot = 0,
	INVTYPE_2HWEAPON = 1.6,
	INVTYPE_WEAPON = 1.6,
	INVTYPE_WEAPONMAINHAND = 1.6,
	INVTYPE_WEAPONOFFHAND = -0.7,
	INVTYPE_SHIELD = -0.7,
	INVTYPE_HOLDABLE = -0.7,
	INVTYPE_RANGED = 1.6,
	INVTYPE_RANGEDRIGHT = 1.6,
	INVTYPE_THROWN = 1.6,
	INVTYPE_HAND = 0,
	INVTYPE_WaistSlot = 0,
	INVTYPE_LegsSlot = 0,
	INVTYPE_FeetSlot = 0,
	INVTYPE_TABARD = 0,
	INVTYPE_BODY = 0,
}

slots_to_cameraids = {
	["Weapon-1HSword"] = 238,
	["Weapon-2HSword"] = 239,
	["Weapon-Wand"] = 240,
	["Weapon-Dagger"] = 241,
	["Weapon-1HAxe"] = 242,
	["Weapon-2HAxe"] = 243,
	["Weapon-1HMace"] = 244,
	["Weapon-2HMace"] = 245,
	["Weapon-Staff"] = 246,
	["Weapon-Polearm"] = 247,
	["Weapon-Glaive"] = 624,
	["Weapon-FistWeapon"] = 248,
	["Weapon-Shield"] = 249,
	["Weapon-Offhand"] = 250,
	["Weapon-Bow"] = 251,
	["Weapon-Gun"] = 252,
	["Weapon-Crossbow"] = 253,
	--
	["BloodElf-Female-HeadSlot"] = 465,
	["BloodElf-Female-ShoulderSlot"] = 466,
	["BloodElf-Female-ShoulderSlot-Alt"] = 739,
	["BloodElf-Female-BackSlot"] = 467,
	["BloodElf-Female-Robe"] = 468,
	["BloodElf-Female-ChestSlot"] = 469,
	["BloodElf-Female-ShirtSlot"] = 469,
	["BloodElf-Female-Tabard"] = 470,
	["BloodElf-Female-WristSlot"] = 471,
	["BloodElf-Female-HandsSlot"] = 472,
	["BloodElf-Female-WaistSlotSlot"] = 473,
	["BloodElf-Female-LegsSlotSlot"] = 474,
	["BloodElf-Female-FeetSlot"] = 475,



	["BloodElf-Male-BackSlot"] = 456,
	["BloodElf-Male-FeetSlot"] = 464,
	["BloodElf-Male-HandsSlot"] = 461,
	["BloodElf-Male-HeadSlot"] = 454,
	["BloodElf-Male-LegsSlot"] = 463,
	["BloodElf-Male-Robe"] = 457,
	["BloodElf-Male-ChestSlot"] = 458,
	["BloodElf-Male-ShirtSlot"] = 458,
	["BloodElf-Male-ShoulderSlot"] = 455,
	["BloodElf-Male-ShoulderSlot-Alt"] = 738,
	["BloodElf-Male-TabardSlot"] = 459,
	["BloodElf-Male-WaistSlot"] = 462,
	["BloodElf-Male-WristSlot"] = 460,

	["Dracthyr-Male-BackSlot"] = 1706,
	["Dracthyr-Male-BackSlot-BackSlotpack"] = 1699,
	["Dracthyr-Male-FeetSlot"] = 1705,
	["Dracthyr-Male-HandsSlot"] = 1708,
	["Dracthyr-Male-HeadSlot"] = 1702,
	["Dracthyr-Male-LegsSlot"] = 1701,
	["Dracthyr-Male-Robe"] = 1698,
	["Dracthyr-Male-ShirtSlot"] = 1709,
	["Dracthyr-Male-ShoulderSlot"] = 1704,
	["Dracthyr-Male-ShoulderSlot-Alt"] = 1703,
	["Dracthyr-Male-Tabard"] = 1707,
	["Dracthyr-Male-WaistSlot"] = 1700,
	["Dracthyr-Male-WristSlot"] = 1711,

	["Draenei-Female-BackSlot"] = 345,
	["Draenei-Female-FeetSlot"] = 358,
	["Draenei-Female-HandsSlot"] = 352,
	["Draenei-Female-HeadSlot"] = 342,
	["Draenei-Female-LegsSlot"] = 356,
	["Draenei-Female-Robe"] = 347,
	["Draenei-Female-ChestSlot"] = 348,
	["Draenei-Female-ShirtSlot"] = 348,
	["Draenei-Female-ShoulderSlot"] = 343,
	["Draenei-Female-ShoulderSlot-Alt"] = 730,
	["Draenei-Female-Tabard"] = 349,
	["Draenei-Female-WaistSlot"] = 355,
	["Draenei-Female-WristSlot"] = 350,
	["Draenei-Male-BackSlot"] = 333,
	["Draenei-Male-FeetSlot"] = 341,
	["Draenei-Male-HandsSlot"] = 338,
	["Draenei-Male-HeadSlot"] = 331,
	["Draenei-Male-LegsSlot"] = 340,
	["Draenei-Male-Robe"] = 334,
	["Draenei-Male-ChestSlot"] = 335,
	["Draenei-Male-ShirtSlot"] = 335,
	["Draenei-Male-ShoulderSlot"] = 332,
	["Draenei-Male-ShoulderSlot-Alt"] = 729,
	["Draenei-Male-Tabard"] = 336,
	["Draenei-Male-WaistSlot"] = 339,
	["Draenei-Male-WristSlot"] = 337,
	["Dwarf-Female-BackSlot"] = 376,
	["Dwarf-Female-FeetSlot"] = 384,
	["Dwarf-Female-HandsSlot"] = 381,
	["Dwarf-Female-HeadSlot"] = 374,
	["Dwarf-Female-LegsSlot"] = 383,
	["Dwarf-Female-Robe"] = 377,
	["Dwarf-Female-ChestSlot"] = 378,
	["Dwarf-Female-ShirtSlot"] = 378,
	["Dwarf-Female-ShoulderSlot"] = 375,
	["Dwarf-Female-ShoulderSlot-Alt"] = 809,
	["Dwarf-Female-Tabard"] = 379,
	["Dwarf-Female-WaistSlot"] = 382,
	["Dwarf-Female-WristSlot"] = 380,
	["Dwarf-Male-BackSlot"] = 365,
	["Dwarf-Male-FeetSlot"] = 373,
	["Dwarf-Male-HandsSlot"] = 370,
	["Dwarf-Male-HeadSlot"] = 363,
	["Dwarf-Male-LegsSlot"] = 372,
	["Dwarf-Male-Robe"] = 366,
	["Dwarf-Male-ChestSlot"] = 367,
	["Dwarf-Male-ShirtSlot"] = 367,
	["Dwarf-Male-ShoulderSlot"] = 364,
	["Dwarf-Male-ShoulderSlot-Alt"] = 731,
	["Dwarf-Male-Tabard"] = 368,
	["Dwarf-Male-WaistSlot"] = 371,
	["Dwarf-Male-WristSlot"] = 369,
	["Gnome-Female-BackSlot"] = 401,
	["Gnome-Female-FeetSlot"] = 409,
	["Gnome-Female-HandsSlot"] = 406,
	["Gnome-Female-HeadSlot"] = 399,
	["Gnome-Female-LegsSlot"] = 408,
	["Gnome-Female-Robe"] = 402,
	["Gnome-Female-ChestSlot"] = 403,
	["Gnome-Female-ShirtSlot"] = 403,
	["Gnome-Female-ShoulderSlot"] = 400,
	["Gnome-Female-ShoulderSlot-Alt"] = 733,
	["Gnome-Female-Tabard"] = 404,
	["Gnome-Female-WaistSlot"] = 407,
	["Gnome-Female-WristSlot"] = 405,
	["Gnome-Male-BackSlot"] = 387,
	["Gnome-Male-FeetSlot"] = 398,
	["Gnome-Male-HandsSlot"] = 395,
	["Gnome-Male-HeadSlot"] = 385,
	["Gnome-Male-LegsSlot"] = 397,
	["Gnome-Male-Robe"] = 389,
	["Gnome-Male-ChestSlot"] = 390,
	["Gnome-Male-ShirtSlot"] = 390,
	["Gnome-Male-ShoulderSlot"] = 386,
	["Gnome-Male-ShoulderSlot-Alt"] = 732,
	["Gnome-Male-Tabard"] = 393,
	["Gnome-Male-WaistSlot"] = 396,
	["Gnome-Male-WristSlot"] = 394,
	["Goblin-Female-BackSlot"] = 445,
	["Goblin-Female-FeetSlot"] = 453,
	["Goblin-Female-HandsSlot"] = 450,
	["Goblin-Female-HeadSlot"] = 443,
	["Goblin-Female-LegsSlot"] = 452,
	["Goblin-Female-Robe"] = 446,
	["Goblin-Female-ChestSlot"] = 447,
	["Goblin-Female-ShirtSlot"] = 447,
	["Goblin-Female-ShoulderSlot"] = 444,
	["Goblin-Female-ShoulderSlot-Alt"] = 737,
	["Goblin-Female-Tabard"] = 448,
	["Goblin-Female-WaistSlot"] = 451,
	["Goblin-Female-WristSlot"] = 449,
	["Goblin-Male-BackSlot"] = 434,
	["Goblin-Male-FeetSlot"] = 442,
	["Goblin-Male-HandsSlot"] = 439,
	["Goblin-Male-HeadSlot"] = 432,
	["Goblin-Male-LegsSlot"] = 441,
	["Goblin-Male-Robe"] = 435,
	["Goblin-Male-ChestSlot"] = 436,
	["Goblin-Male-ShirtSlot"] = 436,
	["Goblin-Male-ShoulderSlot"] = 433,
	["Goblin-Male-ShoulderSlot-Alt"] = 736,
	["Goblin-Male-Tabard"] = 437,
	["Goblin-Male-WaistSlot"] = 440,
	["Goblin-Male-WristSlot"] = 438,
	["Human-Female-BackSlot"] = 276,
	["Human-Female-FeetSlot"] = 284,
	["Human-Female-HandsSlot"] = 281,
	["Human-Female-HeadSlot"] = 274,
	["Human-Female-LegsSlot"] = 283,
	["Human-Female-Robe"] = 277,
	["Human-Female-ChestSlot"] = 278,
	["Human-Female-ShirtSlot"] = 278,
	["Human-Female-ShoulderSlot"] = 275,
	["Human-Female-ShoulderSlot-Alt"] = 724,
	["Human-Female-Tabard"] = 279,
	["Human-Female-WaistSlot"] = 282,
	["Human-Female-WristSlot"] = 280,
	["Human-Male-BackSlot"] = 235,
	["Human-Male-ChestSlot"] = 674,
	["Human-Male-FeetSlot"] = 227,
	["Human-Male-HandsSlot"] = 226,
	["Human-Male-HeadSlot"] = 236,
	["Human-Male-LegsSlot"] = 228,
	["Human-Male-Robe"] = 225,
	["Human-Male-ShirtSlot"] = 229,
	["Human-Male-ShoulderSlot"] = 221,
	["Human-Male-ShoulderSlot-Alt"] = 723,
	["Human-Male-Tabard"] = 230,
	["Human-Male-WaistSlot"] = 234,
	["Human-Male-WristSlot"] = 237,
	["Nightborne-Female-BackSlot"] = 1099,
	["Nightborne-Female-FeetSlot"] = 1106,
	["Nightborne-Female-HandsSlot"] = 1103,
	["Nightborne-Female-HeadSlot"] = 1096,
	["Nightborne-Female-LegsSlot"] = 1105,
	["Nightborne-Female-Robe"] = 1107,
	["Nightborne-Female-ChestSlot"] = 1100,
	["Nightborne-Female-ShirtSlot"] = 1100,
	["Nightborne-Female-ShoulderSlot"] = 1097,
	["Nightborne-Female-ShoulderSlot-Alt"] = 1098,
	["Nightborne-Female-Tabard"] = 1101,
	["Nightborne-Female-WaistSlot"] = 1104,
	["Nightborne-Female-WristSlot"] = 1102,
	["Nightborne-Male-BackSlot"] = 412,
	["Nightborne-Male-FeetSlot"] = 1095,
	["Nightborne-Male-HandsSlot"] = 417,
	["Nightborne-Male-HeadSlot"] = 1090,
	["Nightborne-Male-LegsSlot"] = 419,
	["Nightborne-Male-Robe"] = 1091,
	["Nightborne-Male-ChestSlot"] = 1092,
	["Nightborne-Male-ShirtSlot"] = 1092,
	["Nightborne-Male-ShoulderSlot"] = 411,
	["Nightborne-Male-ShoulderSlot-Alt"] = 734,
	["Nightborne-Male-Tabard"] = 415,
	["Nightborne-Male-WaistSlot"] = 418,
	["Nightborne-Male-WristSlot"] = 416,
	["NightElf-Female-BackSlot"] = 423,
	["NightElf-Female-FeetSlot"] = 431,
	["NightElf-Female-HandsSlot"] = 428,
	["NightElf-Female-HeadSlot"] = 421,
	["NightElf-Female-LegsSlot"] = 430,
	["NightElf-Female-Robe"] = 424,
	["NightElf-Female-ShirtSlot"] = 425,
	["NightElf-Female-ChestSlot"] = 425,
	["NightElf-Female-ShoulderSlot"] = 422,
	["NightElf-Female-ShoulderSlot-Alt"] = 735,
	["NightElf-Female-Tabard"] = 426,
	["NightElf-Female-WaistSlot"] = 429,
	["NightElf-Female-WristSlot"] = 427,
	["NightElf-Male-BackSlot"] = 412,
	["NightElf-Male-FeetSlot"] = 420,
	["NightElf-Male-HandsSlot"] = 417,
	["NightElf-Male-HeadSlot"] = 410,
	["NightElf-Male-LegsSlot"] = 419,
	["NightElf-Male-Robe"] = 413,
	["NightElf-Male-ChestSlot"] = 414,
	["NightElf-Male-ShirtSlot"] = 414,
	["NightElf-Male-ShoulderSlot"] = 411,
	["NightElf-Male-ShoulderSlot-Alt"] = 734,
	["NightElf-Male-Tabard"] = 415,
	["NightElf-Male-WaistSlot"] = 418,
	["NightElf-Male-WristSlot"] = 416,
	["Orc-Female-BackSlot"] = 489,
	["Orc-Female-FeetSlot"] = 497,
	["Orc-Female-HandsSlot"] = 494,
	["Orc-Female-HeadSlot"] = 487,
	["Orc-Female-LegsSlot"] = 496,
	["Orc-Female-Robe"] = 490,
	["Orc-Female-ChestSlot"] = 491,
	["Orc-Female-ShirtSlot"] = 491,
	["Orc-Female-ShoulderSlot"] = 488,
	["Orc-Female-ShoulderSlot-Alt"] = 741,
	["Orc-Female-Tabard"] = 492,
	["Orc-Female-WaistSlot"] = 495,
	["Orc-Female-WristSlot"] = 493,
	["Orc-Male-BackSlot"] = 478,
	["Orc-Male-FeetSlot"] = 486,
	["Orc-Male-HandsSlot"] = 483,
	["Orc-Male-HeadSlot"] = 476,
	["Orc-Male-LegsSlot"] = 485,
	["Orc-Male-Robe"] = 479,
	["Orc-Male-ChestSlot"] = 480,
	["Orc-Male-ShirtSlot"] = 480,
	["Orc-Male-ShoulderSlot"] = 477,
	["Orc-Male-ShoulderSlot-Alt"] = 740,
	["Orc-Male-Tabard"] = 481,
	["Orc-Male-WaistSlot"] = 484,
	["Orc-Male-WristSlot"] = 482,
	["Pandaren-Female-BackSlot"] = 300,
	["Pandaren-Female-ChestSlot"] = 676,
	["Pandaren-Female-FeetSlot"] = 308,
	["Pandaren-Female-HandsSlot"] = 305,
	["Pandaren-Female-HeadSlot"] = 298,
	["Pandaren-Female-LegsSlot"] = 307,
	["Pandaren-Female-Robe"] = 301,
	["Pandaren-Female-ShirtSlot"] = 302,
	["Pandaren-Female-ShoulderSlot"] = 299,
	["Pandaren-Female-ShoulderSlot-Alt"] = 726,
	["Pandaren-Female-Tabard"] = 303,
	["Pandaren-Female-WaistSlot"] = 306,
	["Pandaren-Female-WristSlot"] = 304,
	["Pandaren-Male-BackSlot"] = 287,
	["Pandaren-Male-ChestSlot"] = 675,
	["Pandaren-Male-FeetSlot"] = 295,
	["Pandaren-Male-HandsSlot"] = 292,
	["Pandaren-Male-HeadSlot"] = 285,
	["Pandaren-Male-LegsSlot"] = 294,
	["Pandaren-Male-Robe"] = 288,
	["Pandaren-Male-ShirtSlot"] = 289,
	["Pandaren-Male-ShoulderSlot"] = 286,
	["Pandaren-Male-ShoulderSlot-Alt"] = 725,
	["Pandaren-Male-Tabard"] = 290,
	["Pandaren-Male-WaistSlot"] = 293,
	["Pandaren-Male-WristSlot"] = 291,
	["Tauren-Female-BackSlot"] = 511,
	["Tauren-Female-FeetSlot"] = 519,
	["Tauren-Female-HandsSlot"] = 516,
	["Tauren-Female-HeadSlot"] = 509,
	["Tauren-Female-LegsSlot"] = 518,
	["Tauren-Female-Robe"] = 512,
	["Tauren-Female-ChestSlot"] = 513,
	["Tauren-Female-ShirtSlot"] = 513,
	["Tauren-Female-ShoulderSlot"] = 510,
	["Tauren-Female-ShoulderSlot-Alt"] = 743,
	["Tauren-Female-Tabard"] = 514,
	["Tauren-Female-WaistSlot"] = 517,
	["Tauren-Female-WristSlot"] = 515,
	["Tauren-Male-BackSlot"] = 500,
	["Tauren-Male-FeetSlot"] = 508,
	["Tauren-Male-HandsSlot"] = 505,
	["Tauren-Male-HeadSlot"] = 498,
	["Tauren-Male-LegsSlot"] = 507,
	["Tauren-Male-Robe"] = 501,
	["Tauren-Male-ChestSlot"] = 502,
	["Tauren-Male-ShirtSlot"] = 502,
	["Tauren-Male-ShoulderSlot"] = 499,
	["Tauren-Male-ShoulderSlot-Alt"] = 742,
	["Tauren-Male-Tabard"] = 503,
	["Tauren-Male-WaistSlot"] = 506,
	["Tauren-Male-WristSlot"] = 504,
	["Troll-Female-BackSlot"] = 533,
	["Troll-Female-FeetSlot"] = 541,
	["Troll-Female-HandsSlot"] = 538,
	["Troll-Female-HeadSlot"] = 531,
	["Troll-Female-LegsSlot"] = 540,
	["Troll-Female-Robe"] = 534,
	["Troll-Female-ChestSlot"] = 535,
	["Troll-Female-ShirtSlot"] = 535,
	["Troll-Female-ShoulderSlot"] = 532,
	["Troll-Female-ShoulderSlot-Alt"] = 745,
	["Troll-Female-Tabard"] = 536,
	["Troll-Female-WaistSlot"] = 539,
	["Troll-Female-WristSlot"] = 537,
	["Troll-Male-BackSlot"] = 522,
	["Troll-Male-FeetSlot"] = 530,
	["Troll-Male-HandsSlot"] = 527,
	["Troll-Male-HeadSlot"] = 520,
	["Troll-Male-LegsSlot"] = 529,
	["Troll-Male-Robe"] = 523,
	["Troll-Male-ChestSlot"] = 524,
	["Troll-Male-ShoulderSlot"] = 521,
	["Troll-Male-ShoulderSlot-Alt"] = 744,
	["Troll-Male-Tabard"] = 525,
	["Troll-Male-WaistSlot"] = 528,
	["Troll-Male-WristSlot"] = 526,
	["Scourge-Female-BackSlot"] = 555,
	["Scourge-Female-FeetSlot"] = 563,
	["Scourge-Female-HandsSlot"] = 560,
	["Scourge-Female-HeadSlot"] = 553,
	["Scourge-Female-LegsSlot"] = 562,
	["Scourge-Female-Robe"] = 556,
	["Scourge-Female-ChestSlot"] = 557,
	["Scourge-Female-ShirtSlot"] = 557,
	["Scourge-Female-ShoulderSlot"] = 554,
	["Scourge-Female-ShoulderSlot-Alt"] = 747,
	["Scourge-Female-Tabard"] = 558,
	["Scourge-Female-WaistSlot"] = 561,
	["Scourge-Female-WristSlot"] = 559,
	["Scourge-Male-BackSlot"] = 544,
	["Scourge-Male-ChestSlot"] = 690,
	["Scourge-Male-FeetSlot"] = 552,
	["Scourge-Male-HandsSlot"] = 549,
	["Scourge-Male-HeadSlot"] = 542,
	["Scourge-Male-LegsSlot"] = 551,
	["Scourge-Male-Robe"] = 545,
	["Scourge-Male-ShirtSlot"] = 546,
	["Scourge-Male-ShoulderSlot"] = 543,
	["Scourge-Male-ShoulderSlot-Alt"] = 746,
	["Scourge-Male-Tabard"] = 547,
	["Scourge-Male-WaistSlot"] = 550,
	["Scourge-Male-WristSlot"] = 548,
	["Worgen-Female-BackSlot"] = 322,
	["Worgen-Female-FeetSlot"] = 330,
	["Worgen-Female-HandsSlot"] = 327,
	["Worgen-Female-HeadSlot"] = 320,
	["Worgen-Female-LegsSlot"] = 329,
	["Worgen-Female-Robe"] = 323,
	["Worgen-Female-ChestSlot"] = 324,
	["Worgen-Female-ShirtSlot"] = 324,
	["Worgen-Female-ShoulderSlot"] = 321,
	["Worgen-Female-ShoulderSlot-Alt"] = 728,
	["Worgen-Female-Tabard"] = 325,
	["Worgen-Female-WaistSlot"] = 328,
	["Worgen-Female-WristSlot"] = 326,
	["Worgen-Male-BackSlot"] = 311,
	["Worgen-Male-FeetSlot"] = 319,
	["Worgen-Male-HandsSlot"] = 316,
	["Worgen-Male-HeadSlot"] = 309,
	["Worgen-Male-LegsSlot"] = 318,
	["Worgen-Male-Robe"] = 312,
	["Worgen-Male-ChestSlot"] = 313,
	["Worgen-Male-ShirtSlot"] = 313,
	["Worgen-Male-ShoulderSlot"] = 310,
	["Worgen-Male-ShoulderSlot-Alt"] = 727,
	["Worgen-Male-Tabard"] = 314,
	["Worgen-Male-WaistSlot"] = 317,
	["Worgen-Male-WristSlot"] = 315,
}

slot_override = {
	-- Cloth
	-- appearance 21971
	[106545] = "ShoulderSlot-Alt", -- Orunai ShoulderSlotpads
	[106578] = "ShoulderSlot-Alt", -- Gordunni ShoulderSlotpads
	[112610] = "ShoulderSlot-Alt", -- Steamburst Mantle
	[114271] = "ShoulderSlot-Alt", -- Firefly mantle
	-- appearance 21620
	[106479] = "ShoulderSlot-Alt", -- Iyun ShoulderSlotpads
	[106512] = "ShoulderSlot-Alt", -- Mandragoran ShoulderSlotpads
	[107317] = "ShoulderSlot-Alt", -- Karabor Sage Mantle
	[112086] = "ShoulderSlot-Alt", -- Windburnt Pauldrons
	[106162] = "ShoulderSlot-Alt", -- Frostwolf Wind-Talker Mantle
	-- appearance 21962
	[106413] = "ShoulderSlot-Alt", -- Lunarglow ShoulderSlotpads
	[106446] = "ShoulderSlot-Alt", -- Anchorite ShoulderSlotpads
	[112531] = "ShoulderSlot-Alt", -- Auchenai Keeper Mantle
	-- Leather
	-- [] = "ShoulderSlot-Alt", --
	-- Mail
	[7718] = "ShoulderSlot-Alt", -- Herod's ShoulderSlot
	[122356] = "ShoulderSlot-Alt", -- Champion Herod's ShoulderSlot
	[88271] = "ShoulderSlot-Alt", -- Harlan's ShoulderSlots
	-- Plate
	[140617] = "ShoulderSlot-Alt", -- Rakeesh's Pauldron
	-- BackSlotpacks:
	[174361] = "BackSlot-BackSlotpack", -- Black Dragonscale BackSlotpack
	[180939] = "BackSlot-BackSlotpack", -- Mantle of the Forgemaster's Dark Blades
	[180940] = "BackSlot-BackSlotpack", -- Ebony Crypt Keeper's Mantle
	[180941] = "BackSlot-BackSlotpack", -- Kael's Dark Sinstone Chain
	[181286] = "BackSlot-BackSlotpack", -- Halo of the Selfless
	[181287] = "BackSlot-BackSlotpack", -- Halo of the Reverent
	[181288] = "BackSlot-BackSlotpack", -- Halo of the Harmonious
	[181289] = "BackSlot-BackSlotpack", -- Halo of the Discordant
	[181290] = "BackSlot-BackSlotpack", -- Harmonious Sigil of the Archon
	[181291] = "BackSlot-BackSlotpack", -- Selfless Sigil of the Archon
	[181292] = "BackSlot-BackSlotpack", -- Discordant Sigil of the Archon
	[181293] = "BackSlot-BackSlotpack", -- Reverent Sigil of the Archon
	[181294] = "BackSlot-BackSlotpack", -- Harmonious Wings of the Ascended
	[181295] = "BackSlot-BackSlotpack", -- Selfless Wings of the Ascended
	[181296] = "BackSlot-BackSlotpack", -- Discordant Wings of the Ascended
	[181297] = "BackSlot-BackSlotpack", -- Reverent Wings of the Ascended
	[181301] = "BackSlot-BackSlotpack", -- Faewoven Branches
	[181302] = "BackSlot-BackSlotpack", -- Spirit Tender's Branches
	[181303] = "BackSlot-BackSlotpack", -- Night Courtier's Branches
	[181304] = "BackSlot-BackSlotpack", -- Winterwoven Branches
	[181305] = "BackSlot-BackSlotpack", -- Faewoven Bulb
	[181306] = "BackSlot-BackSlotpack", -- Spirit Tender's Bulb
	[181308] = "BackSlot-BackSlotpack", -- Winterwoven Bulb
	[181309] = "BackSlot-BackSlotpack", -- Faewoven Pack
	[181310] = "BackSlot-BackSlotpack", -- Spirit Tender's Pack
	[181312] = "BackSlot-BackSlotpack", -- Winterwoven Pack
	[181800] = "BackSlot-BackSlotpack", -- Standard of the Blackhound Warband
	[181801] = "BackSlot-BackSlotpack", -- Standard of the Necrolords
	[181802] = "BackSlot-BackSlotpack", -- Standard of Death's Chosen
	[181803] = "BackSlot-BackSlotpack", -- Bladesworn Battle Standard
	[181804] = "BackSlot-BackSlotpack", -- Trophy of the Reborn Bonelord
	[181805] = "BackSlot-BackSlotpack", -- Osteowings of the Necrolords
	[181806] = "BackSlot-BackSlotpack", -- Regrown Osteowings
	[181807] = "BackSlot-BackSlotpack", -- Barbarous Osteowings
	[181808] = "BackSlot-BackSlotpack", -- Death Fetish
	[181809] = "BackSlot-BackSlotpack", -- Tomalin's Seasoning Crystal
	[181810] = "BackSlot-BackSlotpack", -- Phylactery of the Dead Conniver
	[181811] = "BackSlot-BackSlotpack", -- Beckoner's Shadowy Crystal
	[183705] = "BackSlot-BackSlotpack", -- Mantle of Crimson Blades
	[183706] = "BackSlot-BackSlotpack", -- Mantle of Court Blades
	[183707] = "BackSlot-BackSlotpack", -- Mantle of Burnished Blades
	[183708] = "BackSlot-BackSlotpack", -- Glittering Gold Sinstone Chain
	[183709] = "BackSlot-BackSlotpack", -- Bronze-Bound Sinstone
	[183710] = "BackSlot-BackSlotpack", -- Burnished Sinstone Chain
	[183711] = "BackSlot-BackSlotpack", -- Burnished Crypt Keeper's Mantle
	[183712] = "BackSlot-BackSlotpack", -- Gleaming Crypt Keeper's Mantle
	[183713] = "BackSlot-BackSlotpack", -- Kassir's Crypt Mantle
	[184154] = "BackSlot-BackSlotpack", -- Grungy Containment Pack
	[184156] = "BackSlot-BackSlotpack", -- Pristine Containment Pack
}
