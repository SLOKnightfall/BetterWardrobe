local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
addon.AltItems = addon.AltItems or {}
local altitems = addon.AltItems

	--Seat of the Triumvirate
	altitems[89366] = 89232 --Mail, Chest/Robe

	--Nighthold
	altitems[81072] = 81901 --Shaman, Chest/Robe (LFR)
	altitems[79880] = 81898 --Shaman, Chest/Robe (Normal)
	altitems[79881] = 81899 --Shaman, Chest/Robe (Heroic)
	altitems[79882] = 81900 --Shaman, Chest/Robe (Mythic)

	altitems[79892] = 113019 --Paladin, Chest/Robe (Normal)

