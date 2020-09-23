local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

addon.ArmorSets["COSMETIC"] ={
	[1800]={
		["armorType"] =  13 ,
		["label"] =  69 ,
		["setID"] =  1800 ,
		["expansionID"] =  6 ,
		["sources"] = { [117406] = 0,[117407] = 0,[117408] = 24472,[117409] = 24473,[117410] = 24470,[117411] = 24475,[117412] = 24471, },
		["maxLevel"] =  90 ,
		["filter"] =  6 ,
		["recolor"] =  false ,
		["minLevel"] =  90 ,
		["name"] =  "Stormwind Set" ,
		["items"] = { 117406,117407,117408,117409,117410,117411,117412, },
	},
	[1801]={
		["armorType"] =  13 ,
		["label"] =  69 ,
		["setID"] =  1801 ,
		["expansionID"] =  6 ,
		["sources"] = { [118366] = 24054,[118367] = 24051,[118368] = 24052,[118369] = 24817,[118370] = 24053,[118371] = 24050, },
		["maxLevel"] =  90 ,
		["filter"] =  6 ,
		["recolor"] =  false ,
		["minLevel"] =  90 ,
		["name"] =  "Orgrimmar Set" ,
		["items"] = { 118366,118367,118368,118369,118370,118371, },
	},
}