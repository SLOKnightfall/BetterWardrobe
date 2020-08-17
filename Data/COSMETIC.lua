local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

addon.ArmorSets["COSMETIC"] ={
	[1800]={
		["armorType"] =  13 ,
		["source"] =  16 ,
		["label"] =  69 ,
		["setID"] =  1800 ,
		["expansionID"] =  6 ,
		["maxLevel"] =  90 ,
		["filter"] =  6 ,
		["recolor"] =  false ,
		["minLevel"] =  90 ,
		["name"] =  "Stormwind Set" ,
		["items"] = { 117406,117407,117408,117409,117410,117411,117412, },
	},
	[1801]={
		["armorType"] =  13 ,
		["source"] =  16 ,
		["label"] =  69 ,
		["setID"] =  1801 ,
		["expansionID"] =  6 ,
		["maxLevel"] =  90 ,
		["filter"] =  6 ,
		["recolor"] =  false ,
		["minLevel"] =  90 ,
		["name"] =  "Orgrimmar Set" ,
		["items"] = { 118366,118367,118368,118369,118370,118371, },
	},
}