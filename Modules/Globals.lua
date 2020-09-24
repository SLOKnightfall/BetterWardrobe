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

addon.Globals.FILTER_SOURCES = {L["Classic Set"],L["Quest Set"],L["Dunegon Set"],L["Raid Recolor"],L["Raid Lookalike"],L["Garrison"],L["Island Expidetion"], L["Warfronts"]}
addon.Globals.EXPANSIONS = {EXPANSION_NAME0 , EXPANSION_NAME1, EXPANSION_NAME2, EXPANSION_NAME3 , EXPANSION_NAME4, EXPANSION_NAME5, EXPANSION_NAME6, EXPANSION_NAME7, EXPANSION_NAME8}
