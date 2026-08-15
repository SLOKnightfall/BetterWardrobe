local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
addon.AltItems = addon.AltItems or {}
local altitems = addon.AltItems

	--Firelands,
	altitems[36576] = 36581 --Shaman, Pants/Kilt (Heroic)
	altitems[36781] = 36771 --Shaman, Pants/Kilt (Heroic)

	--Bastion of Twilight
	altitems[30012] = 47088 --Druid, Chest/Robe (Normal)
	altitems[32758] = 27831 --Druid, Chest/Robe (Normal)

	altitems[37761] = 45575 --Paladin, Chest/Robe (Season 11 Gladiatoriator)

