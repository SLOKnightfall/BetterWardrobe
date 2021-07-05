local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
addon.ArmorSets = addon.ArmorSets or {}
local ItemDB = {}
local Globals = addon.Globals

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local _, playerClass, classID = UnitClass("player")
--local role = GetFilteredRole()
local CLASS_INFO = Globals.CLASS_INFO

local PVP_SETID = {13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 365, 366, 369, 370, 371, 372, 373, 374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384, 388, 389, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 1019, 1020, 1021, 1022, 1023, 1024, 1025, 1026, 1027, 1028, 1029, 1030, 1031, 1032, 1033, 1034, 1035, 1036, 1037, 1038, 1039, 1040, 1041, 1042, 1043, 1044, 1045, 1046, 1047, 1048, 1049, 1050, 1051, 1052, 1053, 1054, 1055, 1056, 1057, 1058, 1059, 1060, 1061, 1062, 1063, 1064, 1065, 1066, 1067, 1068, 1069, 1070, 1071, 1072, 1073, 1074, 1075, 1076, 1077, 1078, 1079, 1080, 1081, 1082, 1083, 1084, 1085, 1086, 1087, 1088, 1089, 1090, 1091, 1092, 1093, 1094, 1095, 1096, 1097, 1098, 1099, 1100, 1101, 1102, 1103, 1104, 1105, 1106, 1107, 1108, 1109, 1110, 1111, 1112, 1113, 1114, 1115, 1116, 1117, 1118, 1119, 1120, 1121, 1122, 1123, 1124, 1125, 1126, 1127, 1128, 1129, 1130, 1131, 1132, 1133, 1134, 1135, 1136, 1137, 1138, 1139, 1140, 1141, 1142, 1143, 1144, 1145, 1146, 1147, 1148, 1149, 1150, 1151, 1152, 1153, 1154, 1155, 1156, 1157, 1158, 1159, 1160, 1161, 1162, 1163, 1164, 1165, 1166, 1167, 1168, 1169, 1170, 1171, 1172, 1173, 1174, 1175, 1176, 1177, 1178, 1179, 1180, 1181, 1182, 1183, 1184, 1185, 1186, 1187, 1188, 1189, 1190, 1191, 1192, 1193, 1194, 1195, 1196, 1197, 1198, 1199, 1200, 1201, 1202, 1203, 1204, 1205, 1206, 1207, 1208, 1209, 1210, 1211, 1212, 1213, 1214, 1215, 1216, 1217, 1218, 1219, 1220, 1221, 1222, 1223, 1225, 1226, 1227, 1228, 1229, 1230, 1231, 1232, 1233, 1234, 1235, 1236, 1237, 1238, 1239, 1240, 621, 1242, 622, 1244, 623, 1246, 624, 1248, 625, 1250, 626, 1252, 627, 1254, 628, 1256, 629, 1258, 1259, 1260, 1261, 1262, 1263, 1264, 1265, 1266, 1267, 1268, 1269, 1270, 1271, 1272, 1273, 1274, 1275, 1276, 1277, 1278, 1279, 1280, 1281, 1282, 1283, 1284, 1285, 1286, 1287, 1288, 1289, 1290, 1291, 1292, 1343, 1348, 1349, 1352, 1353, 1354, 1355, 1358, 1359, 1360, 1361, 1362, 1363, 1364, 1365, 1366, 1367, 1368, 1369, 1370, 1371, 1372, 1373, 1374, 1375, 1376, 1377, 1378, 1379, 1380, 1381, 1382, 1383, 1384, 1385, 1386, 1387, 1388, 1389, 1390, 1391, 1392, 1393, 1394, 1395, 1396, 1397, 1398, 1399, 1400, 1401, 1402, 1403, 1404, 1405, 1406, 1407, 1408, 1409, 1410, 1411, 1412, 1413, 1414, 1415, 1416, 1417, 1418, 1419, 1420, 1421, 1422, 1423, 747, 748, 749, 750, 751, 752, 753, 754, 755, 756, 757, 758, 759, 760, 761, 762, 763, 764, 765, 766, 767, 768, 769, 770, 771, 772, 773, 774, 775, 776, 777, 778, 779, 780, 781, 782, 783, 784, 785, 786, 787, 788, 789, 790, 791, 2139, 792, 2143, 793, 2147, 794, 795, 796, 797, 798, 2167, 799, 2171, 800, 2175, 801, 802, 803, 2187, 804, 2191, 805, 2195, 806, 2199, 807, 808, 809, 810, 811, 812, 813, 2227, 814, 2231, 2233, 2235, 2237, 2239, 2241, 2243, 2245, 2247, 2249, 1654, 1655, 1656, 1657, 1658, 1659, 1660, 1661, 1662, 1663, 1664, 1665, 1666, 1667, 1668, 1669, 1670, 1671, 1672, 1673, 1674, 1675, 1676, 1677, 1691, 1692, 1693, 1694, 1696, 1698, 1699, 1701, 1703, 1704, 1706, 1708, 1709, 1710, 1711, 1713, 1714, 1716, 1718, 1719, 1721, 1723, 1724, 2248, 1726, 1727, 1728, 1729, 1730, 1731, 1732, 1733, 1734, 1735, 1736, 1737, 1738, 2246, 2244, 2242, 2240, 1743, 1744, 1745, 1746, 1747, 1748, 1749, 1750, 1751, 1752, 877, 1754, 878, 1756, 879, 1758, 880, 1760, 881, 1762, 882, 1764, 883, 1766, 884, 1768, 885, 1770, 886, 1772, 1773, 1774, 1775, 1776, 1777, 1778, 1779, 1780, 1781, 1782, 1783, 1784, 1785, 1786, 1787, 1788, 1789, 1790, 1791, 1792, 1793, 1794, 1795, 1796, 1797, 1798, 1799, 1800, 1801, 1802, 2238, 2236, 2234, 2232, 2230, 2229, 2228, 2226, 2225, 2224, 2198, 2197, 2196, 2194, 2193, 2192, 2190, 2189, 2188, 2186, 2185, 2184, 2177, 2176, 2174, 2173, 2172, 2170, 2169, 2168, 2166, 2149, 2148, 2146, 2145, 2144, 2142, 2141, 2140, 2138, 2137, 2136, 923, 1846, 1847, 1848, 925, 1850, 1851, 1852, 1853, 1854, 1855, 1856, 929, 1858, 930, 1860, 1861, 1862, 1863, 1864, 1865, 1866, 1867, 1868, 1869, 1870, 1871, 1872, 1873, 1874, 1875, 1876, 1877, 1878, 1879, 1880, 1881, 1882, 1883, 1884, 1885, 1886, 1887, 1888, 1889, 1890, 946, 1892, 947, 1894, 948, 1896, 949, 2013, 950, 601, 951, 2011, 952, 600, 953, 599, 954, 598, 955, 597, 956, 596, 957, 595, 958, 594, 959, 593, 960, 592, 961, 1767, 962, 1769, 963, 1771, 964, 1849, 965, 1857, 966, 1859, 967, 1891, 968, 1893, 969, 1895, 970, 1897, 971, 1945, 972, 1944, 973, 1949, 974, 1948, 975, 1950, 976, 1951, 977, 1954, 1955, 1956, 1957, 1953, 1959, 1960, 1961, 1962, 1963, 1947, 1965, 1966, 1967, 1968, 1969, 1970, 1971, 1972, 1973, 1974, 1975, 1765, 1763, 1761, 1759, 1757, 1755, 1753, 608, 610, 612, 614, 616, 618, 1241, 1243, 1245, 1247, 1249, 1251, 1253, 1255, 1257, 588, 589, 590, 591, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 1006, 2012, 1007, 602, 1008, 603, 1009, 604, 1010, 605, 1011, 606, 1012, 607, 1013, 609, 1014, 611, 1015, 613, 1016, 615, 1017, 617, 1018, 619, 620, }
--Check to see if a set from PvP
local function isPVP(index)
	for _,i in ipairs(PVP_SETID) do
		if i == index then return true end
	end
	return false
end

local CLASS_NAMES_LOCALIZED = {}
FillLocalizedClassList(CLASS_NAMES_LOCALIZED) --Fills a table with localized class names, callable with localization-independent class IDs

local ARMOR_MASK = Globals.ARMOR_MASK
local EmptyArmor = Globals.EmptyArmor
local subitemlist = {}
local hiddenSet ={
	["setID"] =  0 ,
	["name"] =  "Hidden",
	["items"] = { 134110, 134112, 168659, 168665, 158329, 143539, 168664 },
	["expansionID"] =  1,
	["filter"] =  1,
	["recolor"] =  false,
	["minLevel"] =  1,
	["uiOrder"] = 100,
	["isClass"] = true,
}
local SET_DATA = {}
local ALT_SET_DATA = {}
local SET_INDEX = {}
local ArmorDB = {}

local function GetFactionID(faction)
	if faction == "Horde" then
		return  2-- 64
	elseif faction == "Alliance" then
		return 1--4
	end
end

local pvpDescriptions = {
    ["Honor"] = true,
    ["Gladiator"] = true,
    ["Elite"] = true,
    ["Warfront"] = true,
    ["Aspirant"] = true,
    ["Combatant"] = true,
}

local armorMask = {400, 3592, 68, 35}
local WowSets = {{}, {}, {}, {}}
WowSets["CLOTH"] = WowSets[1]
WowSets["LEATHER"] = WowSets[2]
WowSets["MAIL"] = WowSets[3]
WowSets["PLATE"] = WowSets[4]

-- Gets all the Blizzard sets, filters out any sets shown in the base set tab and adds them to the apropriate ArmorDB
function BuildBlizzSets()
	local BlizzardBaseSets = {}
	local baseSet = C_TransmogSets.GetBaseSets()
	for i, data in ipairs(baseSet) do
		BlizzardBaseSets[data.setID] = data
	end

	local allSets = C_TransmogSets.GetAllSets()
	for i, data in ipairs(allSets) do
		data.expansionID  = data.expansionID + 1
		for armor, mask in ipairs(armorMask) do 
			if bit.band(data.classMask, mask) ~= 0 then
				local baseSet = C_TransmogSets.GetBaseSetID(data.setID)
				--Create Bizzard sets not being shown on sets tab
				if baseSet == data.setID and not BlizzardBaseSets[data.setID] then 
					if isPVP(data.setID) then data.PvP = true end
					WowSets[Globals.ARMOR_TYPE[armor]][data.setID] = data
					break

				--Create Variants List
				--elseif baseSet =~ data.setID and not BlizzardBaseSets[data.setID] then 
				end
			end
		end
	end
end

local function getClassMask(mask)

for i, d in pairs(addon.Globals.CLASS_INFO) do 

	if mask == d[2] then return d[1] end
end


end


local function OpposingFaction(faction)
	local faction = UnitFactionGroup("player")
	if faction == "Horde" then
		return "Alliance", "Stormwind", 1 -- "Kul Tiras",
	elseif faction == "Alliance" then
		return "Horde", "Orgrimmar", 2 -- "Zandalar",
	end
end

addon.ArmorSetModCache = {}
do
	local function BuildArmorDB()
		local playerFaction, _ = UnitFactionGroup('player')
		local buildID = (select(4, GetBuildInfo()))
		BuildBlizzSets()
		for armorType, data in pairs(addon.ArmorSets) do
			ArmorDB[armorType] = {}

			for id, setData in pairs(data) do
				if (setData.side and setData.side == GetFactionID(playerFaction) or setData.side == nil) and 
				 	setData.filter ~= 5 and setData.filter ~= 7 and setData.filter ~= 11 then 
					--setData.isHeritageArmor = string.find(setData.name, "Heritage")

					local classInfo = CLASS_INFO[playerClass]
					local classMask = getClassMask(setData.classMask)
					local class = (classMask and classMask == classInfo[1]) or not setData.classMask
					local className = (classMask and GetClassInfo(classMask)) or nil

					setData.isClass = class
					setData.className = className

					setData["name"] = L[setData["name"]]
					setData.oldnote = setData.label

					if not setData.note then
						local note = "NOTE_"..(setData.label or 0)
						setData.note = note

						setData.label =L[note] or ""
					end

					local baseItem = setData.items[1]
----local visualID, sourceID = addon.GetItemSource(baseItem)
----setData.itemAppearance = addon.ItemAppearance[visualID]
					setData.armorType = armorType

				--places some of the sets that didnt have correct filters
					--if setData.note == "NOTE_4" or setData.note == "NOTE_4" then
						--setData.filter = 4	
					--end

					--setData.mod = setData.bonusid
					setData.uiOrder = id * 100
						--setData.filter = setData.filter + 1 -- fix for filter startin at 0
					--setData.numCollected = 0
					--setData.numTotal = 0
					--setData.setSources = {}
					--setData.sources = setData.sources or {}

					for index, item in ipairs(setData["items"]) do
						--[[
						setData.numTotal = setData.numTotal + 1
						local mod = setData.mod or 0
						local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(item, mod)
						if not appearanceID then
							for i = 0, 10 do
								appearanceID, sourceID = C_TransmogCollection.GetItemInfo(item, i)
								if appearanceID then
									break
								end
							end
						end

						if appearanceID then 
							setData.sources[item] = appearanceID
							local sources = C_TransmogCollection.GetAppearanceSources(appearanceID) or {} --Can return nil if no longer in game
							local baseSource 
							if (#sources == 0) then
								-- can happen if a slot only has HiddenUntilCollected sources
								
								sources = {C_TransmogCollection.GetSourceInfo(sourceID)}
								if not sources[1].sourceType and not setData.sourceType then 
									setData.unavailable = true
								end

							else
								WardrobeCollectionFrame_SortSources(sources)
							end

							local _, _, canEnchant, _, isCollected  = C_TransmogCollection.GetAppearanceSourceInfo(sourceID)
							if sources[1].isCollected then 
								setData.setSources[sourceID] = true
								setData.numCollected = setData.numCollected + 1
							else
								setData.setSources[sourceID] = false
							end
						else
							--end
						end]]


						if setData.sources and setData.sources[item] and setData.sources[item] ~= 0 then 
							local appearanceID = setData.sources[item]
							ItemDB[appearanceID] = ItemDB[appearanceID] or {}
							ItemDB[appearanceID][id] = setData
						end

						--[[local setMod =  setData.mod or 0
																	local visualID, sourceID = C_TransmogCollection.GetItemInfo(item, setMod)
																	if sourceID then
																		addon.ArmorSetModCache[item] = {}
																		addon.ArmorSetModCache[item][setMod] = {visualID, sourceID}
																	end]]
					end
					SET_INDEX[id] = setData
					ArmorDB[armorType][id] = setData
				end
			end
		end
		addon.ArmorSets = nil

		for armorType, data in pairs(WowSets) do
			ArmorDB[armorType] = ArmorDB[armorType] or {}
			for id, setData in pairs(data) do

				if C_TransmogSets.GetBaseSetID(id) == id then 

					if setData.requiredFaction and setData.requiredFaction == playerFaction or setData.requiredFaction == nil then 
						--setData.name = "BL-" .. setData.name.." - "..(setData.description or "")
						if not setData.nameUpdate then 
							setData.name = setData.name.." - "..(setData.description or "")
						end
						setData.nameUpdate = true
						local classInfo = CLASS_INFO[playerClass]
						local class = (setData.classMask and setData.classMask == classInfo[1]) or not setData.classMask
						---local className = (setData.classMask and GetClassInfo(getClassMask(setData.classMask))) or nil
					if setData.classMask == 8  then 
						--print (L[setData["name"]]); 
					--	print((setData.classMask)) 
end
--print(setData.expansionID)
						--setData.expansionID = setData.expansionID -3
						setData.isClass = class
						setData.className = className
						setData.Blizzard = true
						setData.items = {}
						setData.sources = {}

						local sources = C_TransmogSets.GetSetSources(id)
						for i, collected in pairs(sources) do
							local data = C_TransmogCollection.GetSourceInfo(i)
							if data then 
--if setData.setID == 924 then print("foynd") end
								tinsert(setData.items, data.itemID)
								setData.sources[data.itemID] = data.visualID
								setData.mod = data.itemModID
								setData.sourceType = data.sourceType
							end
						end

						setData.hiddenUntilCollected = false
						setData.armorType = armorType
						setData.setID  = id*100000
						setData.armorType = Globals.ARMOR_TYPE_ID[armorType]

						if setData.PvP then 
							setData.filter = 7
						else
							setData.filter = 5
						end

					--If it was an old Rated armor set, flag it as no longer obtainable.
					if (setData.description == ELITE) and setData.patchID < buildID then
						setData.noLongerObtainable = true
						setData.limitedTimeSet = nil
					end

			
	--if data.label == "Pandaria Challenge Dungeons" then
	--  data.noLongerObtainable = true
	--end	
						--local baseItem = setData.items[1]
						---local visualID, sourceID = addon.GetItemSource(baseItem)
						--setData.itemAppearance = addon.ItemAppearance[visualID]
						SET_INDEX[setData.setID] = setData
						ArmorDB[armorType][setData.setID] = setData
					end
				end
			end
		end
	end


	local function addArmor(armorSet, set)
		local defaultSet = set or SET_DATA 
		for id, setData in pairs(armorSet) do
			if  (setData.isClass or addon.Profile.IgnoreClassRestrictions) then 
					--(addon.Profile.IgnoreClassRestrictions and ((setData.filter == 6 or setData.filter == 7) and addon.Profile.IgnoreClassLookalikeRestrictions)) or 
					--(addon.Profile.IgnoreClassRestrictions and not addon.Profile.IgnoreClassLookalikeRestrictions)) 
				--and not (setData.oldnote == 6 or setData.oldnote == 8 or setData.oldnote == 16 )
				--and not setData.isFactionLocked then 
				--and not setData.isHeritageArmor then 
				--and (not setData.unavailable or (addon.Profile.HideUnavalableSets and setData.unavailable)) then

				for index, item in ipairs( setData["items"]) do
					--if addon.setdb.global.itemSubstitute[item] then 
					--Swaps items for substitutes
					if subitemlist[item] then 
						local replacementID = subitemlist[item]
						local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(replacementID)
						local sources = C_TransmogCollection.GetAppearanceSources(appearanceID)
						WardrobeCollectionFrame_SortSources(sources)
						setData["items"][index] = replacementID
						setData.sources[item] = nil
						setData.sources[replacementID] = appearanceID
					end
				end
				tinsert(set, setData)	
			end
		end
	end


	function addon.IsSetItem(itemLink)
		if not itemLink then return end

		local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemLink)
		if not ItemDB[appearanceID] then 
			return nil 
		else
			return ItemDB[appearanceID]
		end
	end


	local function buildSetSubstitutions()
		wipe(subitemlist)
		if not addon.itemsubdb.profile.items then return end

		for itemID, sub_data in pairs(addon.itemsubdb.profile.items) do
			local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemID)
			local sources = C_TransmogCollection.GetAppearanceSources(appearanceID)
			if sources then 
				for i, data in ipairs(sources) do
					subitemlist[data.itemID] = sub_data.subID
				end
			end
			subitemlist[itemID] = sub_data.subID
		end
	end 


	function addon.Init:InitDB()
		BuildArmorDB()
		addon.Init:BuildDB()
	end


	function addon.Init:BuildDB()
		buildSetSubstitutions()
		local armorSet = ArmorDB[addon.selectedArmorType] or ArmorDB[CLASS_INFO[playerClass][3]]
		--wipe(SET_INDEX)
		wipe(SET_DATA)
		addArmor(armorSet, SET_DATA)
		addArmor(ArmorDB["COSMETIC"], SET_DATA)
		--Add Hidden Set
		SET_INDEX[0] = hiddenSet
		--tinsert(SET_DATA, hiddenSet)
		addon.BuildClassArtifactAppearanceList()
	end

	function addon.Init:BuildAltDB()
		buildSetSubstitutions()
		local armorSet = ArmorDB[addon.selectedArmorType]
		--wipe(SET_INDEX)
		wipe(ALT_SET_DATA)
		addArmor(armorSet, ALT_SET_DATA)
		addArmor(ArmorDB["COSMETIC"], ALT_SET_DATA)
		--Add Hidden Set
		--ALT_SET_INDEX[0] = hiddenSet
		--tinsert(SET_DATA, hiddenSet)
		--addon.BuildClassArtifactAppearanceList()
	end


	function addon:ClearCache()
		--addon.ArmorSets = nil
		wipe(addon.ArmorSetModCache)
		--addon.extraSetsCache = nil
		--wipe(SET_INDEX)
		wipe(SET_DATA)
		addon.ClearArtifactData()
		--wipe(addon.SavedSetCache)
		addon.SavedSetCache =  nil

		--setsInfo = nil
	end


	function addon.GetBaseList()
		if addon.refreshData then 
			addon.Init:BuildDB()
			addon.refreshData = false
		end
		return SET_DATA
	end

	function addon.GetAltList()
		addon.Init:BuildAltDB()
	return ALT_SET_DATA
	end


	function addon.GetSavedList()
		--if not addon.savedSetCache then 
			local savedOutfits = addon.GetOutfits()
			local list = {}
			SET_INDEX = SET_INDEX or {}
			for index, data in ipairs(savedOutfits) do
				local info = {}
				info.items = data.items or {}
				info.sources = data.sources or {}
				info.collected = true
				info.name = data.name
				------print(info.name)
				info.description = ""
				info.expansionID = 1
				info.favorite = false
				info.hiddenUtilCollected = false

				info.label = L["Saved Set"]
				info.limitedTimeSet = false
				info.patchID = ""
				info.setID = data.setID or (data.outfitID + 5000)
				info.uiOrder = data.uiOrder or (data.index * 100)
				info.icon = data.icon
				info.isClass = true
				info.type = "Saved"
				if data.outfitID > 20 then
					info.label = L["Extended Saved Set"]
				end

				if data.set == "default" then 
					local outfitItemTransmogInfoList = C_TransmogCollection.GetOutfitItemTransmogInfoList(data.outfitID);
					info.sources = {}
					for i, data in pairs(outfitItemTransmogInfoList) do
						info.sources[i]= data.appearanceID
					end
					----info.sources = C_TransmogCollection.GetOutfitSources(data.outfitID)
				elseif  #info.sources == 0 then 
					for i = 1, 19 do  ----was 16?
						info.sources[i] = data[i] or 0
					end
				end
--[[
									--converts setdata to new info lists
					if not data.itemTransmogInfoList then 
						local outfitData = {}
						outfitData["outfitID"] = data.outfitID
						outfitData["name"] = data.name
						outfitData["set"] = data.set
						outfitData["icon"] = data.icon
						outfitData["index"] = data.index

						local ItemTransmogInfoList = {}
						--for dataIndex, sourceID in ipairs(data) do
						for i = 1, 19  do
							local illusionID
							if i == 16 then 
								illusionID = data["mainHandEnchant"]
							elseif i == 17 then 
								illusionID = data["offHandEnchant"]
							else
								illusionID = 0
							end
							ItemTransmogInfoList[i] = ItemUtil.CreateItemTransmogInfo(data[i] or 0, 0, illusionID);
							----outfit = outfitData

						end
						--ItemTransmogInfoList["Clear"] = nil 
						--ItemTransmogInfoList["IsEqual"] = nil 
						--ItemTransmogInfoList["Init"] = nil 
						outfitData["ItemTransmogInfoList"] = ItemTransmogInfoList

						--addon.OutfitDB.char.outfits[data.index] = outfitData
						--data = outfitData
						--outfitData["ItemTransmogInfoList"] = ItemTransmogInfoList
					end

					--info.itemTransmogInfoList = data.itemTransmogInfoList
				end]]

				SET_INDEX[info.setID] = info
				tinsert(list, info)
			end
			
			addon.SavedSetCache = list
	--	end
		return addon.SavedSetCache
	end

--[[
				{
					77497, -- [1]
					nil, -- [2]
					94136, -- [3]
					84536, -- [4]
					54411, -- [5]
					4307, -- [6]
					45096, -- [7]
					10642, -- [8]
					25667, -- [9]
					53708, -- [10]
					nil, -- [11]
					nil, -- [12]
					nil, -- [13]
					nil, -- [14]
					22804, -- [15]
					0, -- [16]
					["outfitID"] = 21,
					["index"] = 1,
					["name"] = "5-554",
					["set"] = "extra",
					[19] = 35448,
					["mainHandEnchant"] = 0,
					["icon"] = 1130280,
					["offHandEnchant"] = 0,]]


	--[[function addon.AddSet(setData)
				local id = setData[1]
		
				local info = {}
				info.classMask = setData[4] --class
				info.collected = false 	
				info.description = ""
				info.expansionID	= ""
				info.favorite = ""
				info.hiddenUtilCollected = false
				info.label = ""
				info.limitedTimeSet = false
				info.name = setData[2]--name
				info.patchID = ""
				info.requiredFaction = setData[5]--faction
				info.setID = id
				info.uiOrder = ""
				info.items = setData[3]--items
		
				setInfo[id] = info
				tinsert(baseList, setInfo[id])
			end]]


	function addon.GetSetInfo(setID)
		return SET_INDEX[setID]
	end


	function addon.SetItemSubstitute(itemID, subID)
		itemID = tonumber(itemID)
		subID = tonumber(subID)

		if type(itemID) ~= "number" or type(subID) ~= "number" then 
			BW_WardrobeOutfitFrameMixin:ShowPopup("BETTER_WARDROBE_SUBITEM_INVALID_POPUP")
			return false 
		end

		local _, _, _, itemEquipLoc1 = GetItemInfoInstant(itemID) 
		local _, _, _, itemEquipLoc2 = GetItemInfoInstant(subID) 

		if itemEquipLoc1 ~= itemEquipLoc2 then 
			BW_WardrobeOutfitFrameMixin:ShowPopup("BETTER_WARDROBE_SUBITEM_WRONG_LOCATION_POPUP")
			return false 
		else

			local itemName1, link1 = GetItemInfo(tonumber(itemID))
			local itemName2, link2 = GetItemInfo(tonumber(subID))

			--local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemID|itemString [, itemModID])
			addon.itemsubdb.profile.items[itemID] = {["subID"] = subID, ["itemLink"] = link1, ["subLink"] = link2}

			local item = Item:CreateFromItemID(itemID)
			item:ContinueOnItemLoad(function()
				addon.itemsubdb.profile.items[itemID].itemLink = item:GetItemLink()
				addon.RefreshSubItemData()
			end)

			local item2 = Item:CreateFromItemID(subID)
			item2:ContinueOnItemLoad(function()
				addon.itemsubdb.profile.items[itemID].subLink = item2:GetItemLink()
				addon.RefreshSubItemData()
			end)

			addon:ClearCache()
			addon.ExtraSetsDataProvider:ClearSets()

			addon.Init:BuildDB()
			addon.GetBaseList()
			if BW_SetsCollectionFrame:IsShown() then  --0--TODO FIX
				BW_SetsCollectionFrame:Refresh()
				BW_SetsCollectionFrame:OnSearchUpdate()
			end
			addon.RefreshSubItemData()
		end
	end

	function addon:RemoveItemSubstitute(itemID)
		if not itemID  then
			return false
		end
		--local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemID|itemString [, itemModID])
		local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(tonumber(itemID))
		local sources = C_TransmogCollection.GetAllAppearanceSources(appearanceID)
		--local sources = C_TransmogCollection.GetAppearanceSources(appearanceID)

		for i, source_ID in ipairs(sources) do
			local info = C_TransmogCollection.GetSourceInfo(source_ID)
			addon.itemsubdb.profile.items[info.itemID] = nil
		end

		addon:ClearCache()
		addon.ExtraSetsDataProvider:ClearSets()
		addon.Init:BuildDB()
		addon.GetBaseList()
		addon.RefreshSubItemData()
	end

function addon.GetItemSource(itemID, itemMod)
	if addon.ArmorSetModCache[itemID] and addon.ArmorSetModCache[itemID][itemMod] then return addon.ArmorSetModCache[itemID][itemMod][1], addon.ArmorSetModCache[itemID][itemMod][2] end
		local itemSource
		local visualID, sourceID
		local f =  addon.frame
 		if itemMod then
			visualID, sourceID = C_TransmogCollection.GetItemInfo(itemID, itemMod)
		else
			visualID, sourceID = C_TransmogCollection.GetItemInfo(itemID)
		end

		if not sourceID then
			local itemlink = "item:"..itemID..":0"
			f.model:Show()
			f.model:Undress()
			f.model:TryOn(itemlink)
			local  TransmogInfoList = DressUpOutfitMixin:GetItemTransmogInfoList()
			for i = 1, 19 do
				local source = 0---- f.model:GetSlotTransmogSources(i)
				if source ~= 0 then
					--addon.itemSourceID[itemID] = source
					sourceID = source
					break
				end
			end
		end

		if not sourceID then 
			visualID, sourceID = C_TransmogCollection.GetItemInfo(itemID, 0)
		end

	--[[		if sourceID and itemMod then
						addon.modArmor[itemID] = addon.modArmor[itemID] or {}
						addon.modArmor[itemID][itemMod] = sourceID
					end]]
		if sourceID and itemMod then 
			addon.ArmorSetModCache[itemID] = addon.ArmorSetModCache[itemID]  or {}
			addon.ArmorSetModCache[itemID][itemMod] = {visualID, sourceID}
		end

		f.model:Hide()
	return visualID ,sourceID
end


	function addon.GetSetsources(setID)
	--if SourceDB[setID] then return SourceDB[setID] end

	if setID  > 50000 then
		--return  C_TransmogCollection.GetSourceInfo(setID)
	end

	local setInfo = addon.GetSetInfo(setID)
	local setSources = {}
	local atTransmogrifier = WardrobeFrame_IsAtTransmogrifier()
	local unavailable = false

	if BetterWardrobeCollectionFrame and (BetterWardrobeCollectionFrame.selectedTransmogTab == 4 or BetterWardrobeCollectionFrame.selectedCollectionTab == 4) then
		if setInfo and setInfo.sources then
			for i, sourceID in ipairs(setInfo.sources) do	

				if sourceID then
					local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)

					local sources = sourceInfo and C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)
					if sources then
						if #sources > 1 then
							WardrobeCollectionFrame_SortSources(sources)
						end

						setSources[sourceID] = sources[1].isCollected--and sourceInfo.isCollected
					else
						setSources[sourceID] = false
					end
				end
			end
		end

	elseif setInfo and setInfo.sources then
				for itemID, visualID in pairs(setInfo.sources) do
					local sources =  C_TransmogCollection.GetAppearanceSources(visualID)
					local sourceID, _
		
					if not sources then 
						_, sourceID = addon.GetItemSource(itemID, setInfo.mod)
		
						-- Try to generate a source when the item has a
						if not sourceID then
							for i = 0, 4 , 1 do
								_, sourceID = addon.GetItemSource(itemID, i)
		
								if sourceID then 
									break
								end
							end
						end
		
						local sourceInfo = sourceID and C_TransmogCollection.GetSourceInfo(sourceID)

						if (sourceInfo and not sourceInfo.sourceType) and not setInfo.sourceType then 
							unavailable = true
						end
						sources = sourceInfo and C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)
					end
		
					if sources then
						--items[sources.itemID] = true
						if #sources > 1 then
							WardrobeCollectionFrame_SortSources(sources)
						end
						setSources[sources[1].sourceID] = sources[1].isCollected--and sourceInfo.isCollected

					elseif sourceID then 
						setSources[sourceID] = false
					end
				end
	elseif setInfo and setInfo.items then
		for i, itemID in ipairs(setInfo.items) do
			local visualID, sourceID = addon.GetItemSource(itemID, setInfo.mod or 0) --C_TransmogCollection.GetItemInfo(itemID)
			-- visualID, sourceID = addon.GetItemSource(itemID,setInfo.mod)
			--local sources = C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)

			if not visualID then
				for i = 0, 4 , 1 do
					visualID, sourceID = addon.GetItemSource(itemID, i)
		
					if visualID then 
						break
					end
				end
			end

			if 	visualID then 

				local allSources = C_TransmogCollection.GetAllAppearanceSources(visualID)
				local list = {}
				for _, sourceID in ipairs(allSources) do
	
					local info = C_TransmogCollection.GetSourceInfo(sourceID)
					if (info and not info.sourceType) and not setInfo.sourceType then 
						unavailable = true
					end

					local isCollected = select(5,C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
					info.isCollected = isCollected
					tinsert(list, info)
				end

				if #list > 1 then
					WardrobeCollectionFrame_SortSources(list)
				end
				setSources[list[1].sourceID or sourceID ] = list[1].isCollected or false
				if not list[1].sourceType and not setInfo.sourceType then 
					unavailable = true
				end





		--[[	if sourceID then
								local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
				
								local sources = sourceInfo and C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)
								if sources then
									if #sources > 1 then
										WardrobeCollectionFrame_SortSources(sources)
									end
				
									setSources[sourceID] = sources[1].isCollected--and sourceInfo.isCollected
				
								else
									setSources[sourceID] = false
								end]]
			end
		end
	end
			--setSources[sourceID] = sourceInfo and sourceInfo.isCollected
	--SourceDB[setID] = setSources
	return setSources, unavailable
end

end
