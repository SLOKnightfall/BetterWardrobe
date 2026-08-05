local addonName, addon = ...

addon.ArmorSets = addon.ArmorSets or {}
addon.Filter = addon.Filter or {
    TRASH = 1,
    MISC = 2,
    CLASSIC = 3,
    QUEST = 4,
    DUNGEON = 5,
    RAID = 0,
    RECOLOR = 0,
    GARRISON = 6,
    ISLAND = 7,
    HOLIDAY = 10,
    TPOST = 9,
    COVENANT = 0,
    WARFRONT = 8,
}

addon.FilterNames = addon.FilterNames or {
    [0] = "Set",
    [1] = "World Drop",
    [2] = "Miscellaneous",
    [3] = "Classic",
    [4] = "Quest",
    [5] = "Dungeon",
    [6] = "Garrison",
    [7] = "Island Expedition",
    [8] = "Warfront",
    [9] = "Trading Post",
    [10] = "Holiday",
}

addon.ClassArmorType = addon.ClassArmorType or {
    [1] = "PLATE",      -- Warrior
    [2] = "PLATE",      -- Paladin
    [3] = "MAIL",       -- Hunter
    [4] = "LEATHER",    -- Rogue
    [5] = "CLOTH",      -- Priest
    [6] = "PLATE",      -- Death Knight
    [7] = "MAIL",       -- Shaman
    [8] = "CLOTH",      -- Mage
    [9] = "CLOTH",      -- Warlock
    [10] = "LEATHER",   -- Monk
    [11] = "LEATHER",   -- Druid
    [12] = "LEATHER",   -- Demon Hunter
    [13] = "MAIL",      -- Evoker
}
