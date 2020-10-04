local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

addon.Globals = {}

addon.Globals.locationDrowpDown = {
  [2] = INVTYPE_HEAD,
  --[2] = 134112, neck
  [4] = INVTYPE_SHOULDER,
  --[4] = 168659, shirt
  [16] = INVTYPE_CLOAK,
  [6] = INVTYPE_CHEST,
  [7] = INVTYPE_WAIST,
  [8] = INVTYPE_LEGS,-- pants
  [9] = INVTYPE_FEET,
  [10] = INVTYPE_WRIST,  --wrist
  [11] = INVTYPE_HAND,
  [21] = INVTYPE_ROBE,--handr
}

 addon.Globals.INVENTORY_SLOT_NAMES = {
  [1]  = "HEADSLOT",
  [3]  = "SHOULDERSLOT",
  [4]  = "SHIRTSLOT",
  [5]  = "CHESTSLOT",
  [6]  = "WAISTSLOT",
  [7]  = "LEGSSLOT",
  [8]  = "FEETSLOT",
  [9]  = "WRISTSLOT",
  [10] = "HANDSSLOT",
  [15] = "BACKSLOT",
  [16] = "MAINHANDSLOT",
  [17] = "SECONDARYHANDSLOT",
  [19] = "TABARDSLOT",
  
  ["HEADSLOT"]          = 1,
  ["SHOULDERSLOT"]      = 3,
  ["SHIRTSLOT"]         = 4,
  ["CHESTSLOT"]         = 5,
  ["WAISTSLOT"]         = 6,
  ["LEGSSLOT"]          = 7,
  ["FEETSLOT"]          = 8,
  ["WRISTSLOT"]         = 9,
  ["HANDSSLOT"]         = 10,
  ["BACKSLOT"]          = 15,
  ["MAINHANDSLOT"]      = 16,
  ["SECONDARYHANDSLOT"] = 17,
  ["TABARDSLOT"]        = 19,

  ["INVTYPE_HEAD"] =            1,
  ["INVTYPE_NECK"] =            2,
  ["INVTYPE_SHOULDER"] =        3,
  ["INVTYPE_BODY"] =            4,
  ["INVTYPE_CHEST"] =           5,
  ["INVTYPE_ROBE"] =            5,
  ["INVTYPE_WAIST"] =          6,
  ["INVTYPE_LEGS"] =           7,
  ["INVTYPE_FEET"] =            8,
  ["INVTYPE_WRIST"] =           9,
  ["INVTYPE_HAND"] =            10,
  ["INVTYPE_CLOAK"] =           15,
  ["INVTYPE_WEAPON"] =          16,
  ["INVTYPE_SHIELD"] =          17,
  ["INVTYPE_2HWEAPON"] =        16,
  ["INVTYPE_WEAPONMAINHAND"] =  16,
  ["INVTYPE_WEAPONOFFHAND"] =   17,
  ["INVTYPE_HOLDABLE"] =        17,
  ["INVTYPE_RANGED"] =          16,
  ["INVTYPE_THROWN"] =          16,
  ["INVTYPE_RANGEDRIGHT"] =     17,
  ["INVTYPE_RELIC"] =           17,
  ["INVTYPE_TABARD"] =          19,
}


addon.Globals.slots = {
  "HeadSlot",
  "ShoulderSlot",
  "BackSlot",
  "ChestSlot",
  "ShirtSlot",
  "TabardSlot",
  "WristSlot",
  "HandsSlot",
  "WaistSlot",
  "LegsSlot",
  "FeetSlot",
  "MainHandSlot",
  "SecondaryHandSlot",
};



addon.Globals.tooltip_slots = {
  INVTYPE_HEAD = 0,
  INVTYPE_SHOULDER = 0,
  INVTYPE_CLOAK = 3.4,
  INVTYPE_CHEST = 0,
  INVTYPE_BODY = 0,
  INVTYPE_ROBE = 0,
  INVTYPE_SHIRT = 0,
  INVTYPE_TABARD = 0,
  INVTYPE_WRIST = 0,
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
  INVTYPE_WAIST = 0,
  INVTYPE_LEGS = 0,
  INVTYPE_FEET = 0,
};

addon.Globals.mods = {
  Shift = IsShiftKeyDown,
  Ctrl = IsControlKeyDown,
  Alt = IsAltKeyDown,
};



addon.Globals.BASE_SET_BUTTON_HEIGHT = 46
addon.Globals.VARIANT_SET_BUTTON_HEIGHT = 20
addon.Globals.SET_PROGRESS_BAR_MAX_WIDTH = 204
addon.Globals.IN_PROGRESS_FONT_COLOR = CreateColor(0.251, 0.753, 0.251)
addon.Globals.IN_PROGRESS_FONT_COLOR_CODE = "|cff40c040"
addon.Globals.COLLECTION_LIST_WIDTH = 260

addon.Globals.EmptyArmor = {
  [1] = 134110,
  --[2] = 134112, neck
  [3] = 134112,
  --[4] = 168659, shirt
  [5] = 168659,
  [6] = 143539,
  --[7] = 158329, pants
  [8] = 168664,
  [9] = 168665, --wrist
  [10] = 158329, --handr
}

addon.Globals.LE_DEFAULT = 1
addon.Globals.LE_APPEARANCE = 2
addon.Globals.LE_ALPHABETIC = 3
addon.Globals.LE_ITEM_SOURCE = 6
addon.Globals.LE_EXPANSION = 5
addon.Globals.LE_COLOR = 4

addon.Globals.TAB_ITEMS = 1
addon.Globals.TAB_SETS = 2
addon.Globals.TAB_EXTRASETS = 3
addon.Globals.TAB_SAVED_SETS = 4
addon.Globals.TABS_MAX_WIDTH = 245

addon.Globals.FILTER_SOURCES = {L["MISC"], L["Classic Set"],L["Quest Set"],L["Dunegon Set"],L["Raid Recolor"],L["Raid Lookalike"],L["Garrison"],L["Island Expidetion"], L["Warfronts"]}
addon.Globals.EXPANSIONS = {EXPANSION_NAME0 , EXPANSION_NAME1, EXPANSION_NAME2, EXPANSION_NAME3 , EXPANSION_NAME4, EXPANSION_NAME5, EXPANSION_NAME6, EXPANSION_NAME7, EXPANSION_NAME8}