local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
addon.AltItems = addon.AltItems or {}
local altitems = addon.AltItems

	--Blackrock Foundry
	altitems[64430] = 62671 --Druid, Chest/Robe (Normal)
	altitems[67120] = 62673 --Druid, Chest/Robe (Heroic)
	altitems[67121] = 67117 --Druid, Chest/Robe (Mythic)

	altitems[64467] = 62902 --Shaman, Chest/Robe (Normal)
	altitems[67283] = 62904 --Shaman, Chest/Robe (Heroic)
	altitems[67284] = 67278 --Shaman, Chest/Robe (Mythic)

	--Hellfire Citadel
	altitems[69707] = 69703 --Druid, Chest/Robe (Normal)
	altitems[69708] = 69705 --Druid, Chest/Robe (Heroic)
	altitems[69709] = 69706 --Druid, Chest/Robe (Mythic)

	altitems[69710] = 69696 --Monk, Chest/Robe (Normal)
	altitems[69711] = 69697 --Monk, Chest/Robe (Heroic)
	altitems[69712] = 69698 --Monk, Chest/Robe (Mythic)

	altitems[69910] = 69839 --Shaman, Chest/Robe (Normal)
	altitems[69911] = 69841 --Shaman, Chest/Robe (Heroic)
	altitems[69912] = 69842 --Shaman, Chest/Robe (Mythic)

	altitems[64517] = 64620 --Druid, Chest/Robe (Season 1 Gladiatoriator)
	altitems[70431] = 70462 --Druid, Chest/Robe (Season 2 Gladiatoriator)
	altitems[70500] = 70467 --Monk, Chest/Robe (Season 2Gladiatoriator)
	altitems[70913] = 70864 --haman, Chest/Robe (Season 2 Gladiatoriator)
	altitems[71411] = 71378 --Monk, Chest/Robe (Season 3 Gladiatoriator)
	altitems[71342] = 71373 --Druid, Chest/Robe (Season 3 Gladiatoriator)
	altitems[71824] = 71775 --Shaman, Chest/Robe (Season 3 Gladiatoriator)

