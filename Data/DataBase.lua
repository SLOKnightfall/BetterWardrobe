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
local CHALLENGE_SETID = {1436,1437,1438,1439,1440,1441,1442,1443,1444,1445,1446}
local TRADING_POST_SETID = {2320, 2323, 2327, 2337, 2338, 2340, 2346, 2654, 2655, 2656, 2657, 2658, 2659, 2660,2669, 2676, 2677, 2678, 2679,3354,3355,3357,3358,3360,3361,3362,3444,3445,3446,3447,3448,3449,3189, 3190, 3306}
--Check to see if a set from PvP
local function isPVP(index)
	for _,i in ipairs(PVP_SETID) do
		if i == index then return true end
	end
	return false
end

local CLASS_NAMES_LOCALIZED = {}
--FillLocalizedClassList(CLASS_NAMES_LOCALIZED) --Fills a table with localized class names, callable with localization-independent class IDs

local ARMOR_MASK = Globals.ARMOR_MASK
local EmptyArmor = Globals.EmptyArmor
local subitemlist = {}
local hiddenSet ={
	["setID"] =  0 ,
	["name"] =  "Hidden",
	["items"] = { 134110, 134112, 168659, 168665, 158329, 143539, 168664, 198608 },
	
	["expansionID"] =  1,
	["filter"] =  1,
	["recolor"] =  false,
	["minLevel"] =  1,
	["uiOrder"] = 100,
	["isClass"] = true,
	--["itemTransmogInfo"] = {}  --TODO Populate
}
local ALT_SET_DATA = {}
local SET_INDEX = {}
local ArmorDB = {}
local collectedAppearances = {}


local function GetFactionID(faction)
	if faction == "Horde" then
		return  2-- 64
	elseif faction == "Alliance" then
		return 1--4
	end
end


local armorMask = {400, 3592, 68, 35}
local WowSets = {{}, {}, {}, {}, {}}
WowSets["CLOTH"] = WowSets[1]
WowSets["LEATHER"] = WowSets[2]
WowSets["MAIL"] = WowSets[3]
WowSets["PLATE"] = WowSets[4]
WowSets["COSMETIC"] = WowSets[5]

local baseList = {}
addon.BaseList = baseList
local baseListLabels = {}
addon.BaseListLabels = baseListLabels
local baseIDs = {}
addon.BaseIDs = baseIDs
local variantSets = {};
addon.VariantSets = variantSets
local variantIDs = {};
addon.VariantIDs = variantIDs

local function AddVariant(set, baseSetID)
	if not variantSets[baseSetID] then
		variantSets[baseSetID] = {};
	end
	
	set.baseSetID = baseSetID;
	tinsert(variantSets[baseSetID], set)
	variantIDs[set.setID] = baseSetID;
end

local function AddVariantToBaseSet(set, newBaseID)
	if not variantSets[newBaseID] then
		variantSets[newBaseID] = {};
	end
	
	local baseID = set.baseSetID;
	--if not baseID then baseID = set.setID; end
	
	if variantSets[baseID] then
		for i=1,#variantSets[baseID] do
			tinsert(variantSets[newBaseID], variantSets[baseID][i]);
			variantIDs[variantSets[baseID][i].setID] = newBaseID;
			variantSets[baseID][i].baseSetID = newBaseID;
		end
	end

	if variantSets[set.setID] then
		for i=1,#variantSets[set.setID] do
			tinsert(variantSets[newBaseID], variantSets[set.setID][i]);
			variantIDs[variantSets[set.setID][i].setID] = newBaseID;
			variantSets[set.setID][i].baseSetID = newBaseID;
		end
	end
	
	set.baseSetID = newBaseID;
	variantSets[baseID] = nil;
	variantSets[set.setID] = nil;
end


--TODO Still Needed?
local function SetClassIDs(armorType)
	local localizedClass, _, classInd = UnitClass('player');
	local ClassArmorType = addon.Globals.ClassArmorType
  if armorType then
    if armorType == ClassArmorType[classInd] then
      ClassName = localizedClass;
      ClassIndex = classInd;
      return;
    end
  
    for i,j in pairs(ClassArmorType) do
      if j == armorType then ClassName, _, ClassIndex = GetClassInfo(i); break; end;
    end
    
  else
    ClassName = localizedClass;
    ClassIndex = classInd;
    _,_,currentRaceID = UnitRace('player');
  end
end

--TODO Still Needed?
function addon:AddSetSource(setID, sources)
	for sourceID, _ in pairs(sources) do
		if not sourceID then 
			return;
		end;
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID);
		if not sourceInfo then 
			return;
		end
		local visualID = sourceInfo.visualID;
		if SetIDSource[visualID] then
			table.insert(SetIDSource[visualID], setID);
		else
			SetIDSource[visualID] = {setID};
		end;
	end
end

local function UseSet(data)
	local dropdownClass = C_TransmogSets.GetTransmogSetsClassFilter();
	local selectedArmorType = dropdownClass or playerClass;
	local ClassArmor = addon.Globals.ClassArmorMask[selectedArmorType];
	if data.classMask  then
		if data.classMask == 0 or data.classMask == 16383 then
			return true;
		end

		if data.setType == "Blizzard" then 
			for i = 1, #ClassArmor do
				if data.classMask == ClassArmor[i] then
					return true;
				end
			end
		else
			if data.classMask == tonumber(selectedArmorType) then 
				return true;
			end
		end

		return false;
	end

	return true;
end

-- Gets all the Blizzard sets, filters out any sets shown in the base set tab and adds them to the apropriate ArmorDB
function BuildBlizzSets()
	addon.SetsDataProvider:ClearSets();
	addon:ClearCache()

	local initSpecialSet, initTradingPostSet
	local tradingPostGlobalString = "Trading Post"; --BATTLE_PET_SOURCE_12
	local inGameShopGlobalString = "In-Game Shop"; --BATTLE_PET_SOURCE_10

	local allSets = C_TransmogSets.GetAllSets()
	for i, data in ipairs(allSets) do
		data.setType = "Blizzard"

		if not (data.name == "PH") and UseSet(data) then
			data.expansionID  = data.expansionID + 1
			data.BuildBlizzSets = true
			data.setType = "Blizzard"

			if data.classMask == 16383 then
				 data.classMask = 0
			elseif data.classMask == 4164 then
				data.classMask = 68
			elseif data.classMask == 2048 then
					data.classMask = 3592
			elseif data.classMask == 256 then
					data.classMask = 400
			elseif data.classMask == 32 then
				data.classMask = 35
			end

			if data.classMask and Globals.CLASS_MASK_TO_ID[data.classMask] then 
				data.classID = Globals.CLASS_MASK_TO_ID[data.classMask]
				data.className, data.classTag = GetClassInfo(data.classID);
			end
		
			data.tab = 2
			--PvP Sets
			if data.PvP then 
				data.filter = 7

			--Covenant Sets
			elseif data.setID <= 2221 and data.setID >= 2015 then 
				data.filter = 11
				data.tab = 3

			--Shop & Trading Post
			elseif addon.MiscSets.TRADINGPOST_SETS[data.setID]  or (data.label and string.find(data.label, inGameShopGlobalString))  or (data.label and string.find(data.label, tradingPostGlobalString))  
				or (data.description and string.find(data.description, inGameShopGlobalString))  or (data.description and string.find(data.description, tradingPostGlobalString)) then
				data.tab = 3
				data.filter = 12

			--Raid Sets
			elseif data.description then 
				data.filter = 5

			else
				data.filter = 1
				data.tab = 3
			end

				--Fix set description
				if addon.MiscSets.CustomDesc[data.setID] then
					data.description = addon.MiscSets.CustomDesc[data.setID];
				end

			--Combine special cases
			if addon.Profile.CombineSpecial and data.classMask == 0 and addon.MiscSets.SPECIAL_SETS[data.setID] then
				data.note = data.label;
				data.label = SPECIAL;

				if not initSpecialSet then
					initSpecialSet = data.setID;
					baseIDs[data.setID] = data;
					baseListLabels[data.label] = data.setID; 
					table.insert(baseList, data);
					AddVariant(data, data.setID);

				else
					data.baseSetID = initSpecialSet;
					AddVariant(data, initSpecialSet);
					if data.favorite then
						if baseSet and not baseSet.favoriteSetID then
							baseSet.favoriteSetID = data.setID;
						end
					end
				end

			elseif addon.Profile.CombineTradingPost and data.label == tradingPostGlobalString  then --or addon.MiscSets.TRADINGPOST_SETS[data.setID]  then -- or addon.MiscSets.TRADINGPOST_SETS[data.setID] then
					if not initTradingPostSet then
						initTradingPostSet = data.setID;
						baseIDs[data.setID] = data;

						baseListLabels[data.label] = data.setID;
						table.insert(baseList,data);

						AddVariant(data, data.setID);
					else
						data.baseSetID = initTradingPostSet;
						AddVariant(data, initTradingPostSet);
						if data.favorite then
							local baseSet = BetterWardrobeSetsDataProviderMixin:GetSetByID(initTradingPostSet);
							if not baseSet.favoriteSetID then
								baseSet.favoriteSetID = data.setID;
							end
						end
					end
			else
				
				if (not data.description) then
					if addon.Globals.CLASS_NAMES[data.classMask] then
						data.description = addon.Globals.CLASS_NAMES[data.classMask][1];
					else
						data.description = data.name;
					end
				end
				
				if addon.Globals.CLASS_NAMES[data.classMask] then
					--=data.description = addon:GetClassColor(data.classMask, data.description);
				end

				if addon.MiscSets.REMIX_SETS[tonumber(data.setID)] then
					data.customGroups = data.label.."-"..data.name
					data.label = "Mists of Pandaria: Remix"
				end

				if addon.MiscSets.customGroups[tonumber(data.setID)] then
					data.customGroups = addon.MiscSets.customGroups[tonumber(data.setID)]
				end				

				if data.label == tradingPostGlobalString then
					data.customGroups = data.name
				end				
			
				local subSet = false;
				local subSetBaseID;
				SET_INDEX[data.setID] = data


				if data.customGroups and baseListLabels[data.customGroups] then
					subSet = true;
					subSetBaseID = baseListLabels[data.customGroups]
				
				elseif not data.customGroups and data.label and baseListLabels[data.label] then
					subSet = true;
					subSetBaseID = baseListLabels[data.label]
				end
			
				if subSet then
					if data.favorite then
						----if not baseIDs[subSetBaseID].favoriteSetID then
						----	baseIDs[subSetBaseID].favoriteSetID = data.setID;
						----end
					end

					AddVariant(data, subSetBaseID);
					data.baseSetID = subSetBaseID;
				else
					baseIDs[data.setID] = data;

					if data.customGroups then
						baseListLabels[data.customGroups] = data.setID;

					elseif data.label then
						baseListLabels[data.label] = data.setID;
					end

					table.insert(baseList, data);
					AddVariant(data, data.setID);
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

local UIID_Counter = {1,1150,2000,3390,4580,6200,8000,10110,11000,12000}

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
		addon.SetsDataProvider:ClearSets();
		local playerFaction, _ = UnitFactionGroup('player')
		local buildID = (select(4, GetBuildInfo()))
		BuildBlizzSets()

		--@debug@
			addon:AddTestSets()
		--@end-debug@


		local dropdownclass = C_TransmogSets.GetTransmogSetsClassFilter();
		local at = Globals.ClassArmorType[dropdownclass]
		local ty = Globals.ARMOR_TYPE[at]
			armorType = ty or addon.Globals.CLASS_INFO[playerClass][3]
					--print(armorType)

			ArmorDB[armorType] = {}
			local armorSetdata = {addon.ArmorSets[armorType], addon.ArmorSets["COSMETIC"]}
		for armorType, data in ipairs(armorSetdata) do
			ArmorDB[armorType] = {}


			for id, data in pairs(data) do
				--print(UseSet(data))
				if (data.requiredFaction and data.requiredFaction == GetFactionID(playerFaction) or data.requiredFaction == nil) and 
				 	(not data.BuildBlizzSets and (data.filter ~= 5 and data.filter ~= 7 and data.filter ~= 11)) and  UseSet(data) then 
					--data.isHeritageArmor = string.find(data.name, "Heritage")

					local classInfo = CLASS_INFO[playerClass]
					local classMask = getClassMask(data.classMask)
					local class =  (data.classMask)
					local className = (classMask and GetClassInfo(classMask)) or nil
					
					data.isClass = data.classMask == classInfo[1] or not data.classMask
					--local class = (data.classMask and data.classMask == 0) or (data.classMask and bit.band(data.classMask, classInfo[2])  == classInfo[2]) or not data.classMask
					data.className = data.classMask and GetClassInfo(data.classMask)

					data["name"] = L[data["name"]]
					data.oldnote = data.label

					if not data.note then
						local note = "NOTE_"..(data.label or 0)
						data.note = note

						data.label = L[note] or ""
					end

					--local baseItem = data.items[1]
					----local visualID, sourceID = addon.GetItemSource(baseItem)
					----data.itemAppearance = addon.ItemAppearance[visualID]
					data.armorType = armorType
					data.setType = "ExtraSet"
					data.oldID =	data.setID
					data.tab = 3

					local newID = 10000 + id

					data.setID = newID

					data.newStatus = false


					data.itemData = data.itemData or {}

					data.validForCharacter = true;


					--for slotID, itemData in pairs(data.itemData) do
					--	local appearanceID = itemData[3]
						--if appearanceID  then --and data.sources[item] and data.sources[item] ~= 0 then 
							--local appearanceID = data.sources[item]
						--	ItemDB[appearanceID] = ItemDB[appearanceID] or {}
						--	ItemDB[appearanceID][newID] = data
					--	end
					--end

					local subSet = false;
					local subSetBaseID;
					local subName = gsub(data.name, " %(Recolor%)", "")
					if data.note == data.note == "NOTE_119" or data.note == "NOTE_120" or data.note == "NOTE_121" or data.note == "NOTE_123"   then
						data.customGroups = data.label
					elseif data.note == "NOTE_44" or data.note == "NOTE_45" then
						data.customGroups =  data.label.."-"..subName--data.armorType

					elseif addon.MiscSets.customGroups[tonumber(data.setID)] then
						data.customGroups = addon.MiscSets.customGroups[tonumber(data.setID)]
					elseif data.custom then
					 	data.customGroups = data.custom --or data.label.."-"..subName--data.armorType
					end

					if data.customGroups and baseListLabels[data.customGroups]  then
						subSet = true;
						subSetBaseID = baseListLabels[data.customGroups]
					--elseif data.name ~= subName then
						--subSet = true;

						--data.tab = 2
						--subSetBaseID = baseListLabels[subName]
					elseif not data.customGroups and data.label and baseListLabels[data.label] then

					--elseif data.label and baseListLabels[data.label] then
						subSet = true;
						subSetBaseID = baseListLabels[data.label]
					end

				--print(data.name)
					
					if subSet then
						AddVariant(data, subSetBaseID);
						data.baseSetID = subSetBaseID;

					else
						baseIDs[data.setID] = data;

						data.baseSetID = data.setID;


						if data.customGroups then
							baseListLabels[data.customGroups] = data.setID;

						elseif data.name then
							baseListLabels[data.label] = data.setID;
						end

						--baseListLabels[data.label] = data.setID;

						table.insert(baseList, data);
						AddVariant(data, data.setID);
					end






					data.sources = {}

			data.newStatus = false

					for i, itemData in pairs(data.itemData) do
					--zz = itemData
					--pri(s)
						--tinsert(data.sources, itemData[3])

					if subitemlist[item] then 
						local replacementID = subitemlist[item]
						local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(replacementID)
						local sources = C_TransmogCollection.GetAppearanceSources(appearanceID)
						WardrobeCollectionFrame_SortSources(sources)
						setData["items"][index] = replacementID
						setData.sources[item] = nil
						setData.sources[replacementID] = appearanceID
					else
						data.sources[itemData[2]] = true
						end
					end
					data.uiOrder = UIID_Counter[data.expansionID] -- id * 100
					SET_INDEX[newID] = data
					ArmorDB[armorType][newID] = data
				end
			end
		end
		--addon.ArmorSets = nil


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


	function addon.HasSubItem(sourceID)

		if subitemlist[sourceID] then
			local sourceInfo = C_TransmogCollection.GetSourceInfo(subitemlist[sourceID])
			--print("found")
			return subitemlist[sourceID]
		end
	end

		function zz(sourceID)
			sourceID = 218036
		if subitemlist[sourceID] then
			local sourceInfo = C_TransmogCollection.GetSourceInfo(subitemlist[sourceID])
			print("found")
			return sourceInfo
		end
	end

	local function buildSetSubstitutions()
		wipe(subitemlist)
		subitemlist = subitemlist or {}
		if not addon.itemsubdb.profile.items then return end

		for itemID, sub_data in pairs(addon.itemsubdb.profile.items) do
			local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemID)
			--print(sourceID)
			local appearanceID2, sourceID2 = C_TransmogCollection.GetItemInfo(sub_data.subID)
			--print(sourceID)

			subitemlist[sourceID] = sourceID2
			--[[local _, visualID, _, _, _, itemLink = C_TransmogCollection.GetAppearanceSourceInfo(appearanceID)	
			local sources = (itemLink and C_TransmogCollection.GetAppearanceSources(appearanceID, addon.GetItemCategory(appearanceID), addon.GetTransmogLocation(itemLink)) )
			if sources then 
				for i, data in ipairs(sources) do
					subitemlist[data.itemID] = sub_data.subID
				end
			end
			subitemlist[itemID] = sub_data.subID
			]]--
		end
	end 


function addon.Init:UpdateCollectedAppearances()
	for i = FIRST_TRANSMOG_COLLECTION_WEAPON_TYPE, LAST_TRANSMOG_COLLECTION_WEAPON_TYPE - 1 do
		local location = TransmogUtil.GetTransmogLocation(addon.Globals.CATEGORYID_TO_NAME[i], Enum.TransmogType.Appearance, Enum.TransmogModification.Main)
		local appearances = C_TransmogCollection.GetCategoryAppearances(i, location)
		for _, appearance in pairs(appearances) do
			local sources = C_TransmogCollection.GetAppearanceSources(appearance.visualID, i, location)
			for _, source in pairs(sources) do
				if source.isCollected then
					collectedAppearances[appearance.visualID] = true
					break
				end
			end
		end
	end
end
	function addon.Init:InitDB()
		addon:ClearCache()
		buildSetSubstitutions()

		BuildArmorDB()
		--addon.Init:BuildDB()
		addon.BuildClassArtifactAppearanceList()
		addon.GetSavedList()
	end


	function addon.Init:BuildDB()
		addon.SetsDataProvider:ClearSets();
		--buildSetSubstitutions()
		local armorSet = ArmorDB[addon.selectedArmorType] or ArmorDB[CLASS_INFO[playerClass][3]]
		--wipe(SET_INDEX)
		--Add Hidden Set
		------SET_INDEX[0] = hiddenSet
		BuildArmorDB()
		addon.BuildClassArtifactAppearanceList()
		addon.GetSavedList()
	end

	function addon.Init:BuildAltDB()
		addon.ClearSourceDB()
		buildSetSubstitutions()
		local armorSet = ArmorDB[addon.selectedArmorType]
		--wipe(SET_INDEX)
		addArmor(armorSet, SET_DATA)
		addArmor(ArmorDB["COSMETIC"], SET_DATA)
		--Add Hidden Set
		--ALT_SET_INDEX[0] = hiddenSet
		--tinsert(SET_DATA, hiddenSet)
		--addon.BuildClassArtifactAppearanceList()
	end

	--function x()
	--	for id, setData in pairs(SET_INDEX) do
		--	if setData["items"] then
			--	print(setData.name)
				--for index, item in pairs( setData["items"]) do
				--	print(item)
				--end
			--end
		--end
	--end


	function addon:ClearCache()
		--addon.ArmorSets = nil
		wipe(addon.ArmorSetModCache)
		--addon.extraSetsCache = nil
		wipe(SET_INDEX)
		addon.ClearArtifactData()
		--wipe(subitemlist)
		--wipe(addon.SavedSetCache)
		addon.SavedSetCache =  nil

		wipe(baseListLabels)
		wipe(baseList)
		wipe(baseIDs)
		wipe(variantSets)
		wipe(variantIDs)
		--wipe(subitemlist)
	end

	function addon.GetBaseList()
		if addon.refreshData then 
			addon.Init:BuildDB()
			addon.refreshData = false
		end
		return baseIDs
	end

	local MAX_DEFAULT_OUTFITS = C_TransmogCollection.GetNumMaxOutfits()

	function addon:GetBlizzID(outfitID)
		return outfitID - 5000
	end

	local profileCache = {}
	local savedSetID = 50000

	local function loadAltsSavedSets(profile)
		if not addon.setdb.global.sets[profile] then return {} end

		if not profileCache[profile] then 
			local FullList = CopyTable(addon.setdb.global.sets[profile])

			--FullList = addon.setdb.global.sets[addon.SelecteSavedList]
			for i, data in ipairs(FullList) do
				data.setType = "SavedExtra"
				savedSetID = savedSetID + 1
				data.outfitID = savedSetID
				data.label = L["Saved Set"]

				if data.sources  then
					for index, sourceID in pairs(data.sources) do 
						local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)

						if sourceInfo and sourceInfo.invType then  
							local appearanceID = sourceInfo.visualID
							local itemID = sourceInfo.itemID
							local itemMod = sourceInfo.itemModID
							local sourceID = sourceInfo.sourceID
							data.itemData = data.itemData or {} 
							data.itemData[index] = {"'"..itemID..":"..itemMod.."'", sourceID, appearanceID}
						end
					end
				end
			end


			if addon.OutfitDB.sv.char[profile] and addon.OutfitDB.sv.char[profile].outfits  then 
				local extendeSets = CopyTable(addon.OutfitDB.sv.char[profile].outfits)

				if extendeSets then 
					for i, data in ipairs(extendeSets) do
						tinsert(FullList, data)
					end
				end
			end

			profileCache[profile] =  FullList
		end

		return profileCache[profile]

	end

	function addon.GetOutfits(character)
		local name = UnitName("player")
		local realm = GetRealmName()
		local profile = addon.SelecteSavedList 
		local FullList = {}
		local savedOutfits
		if addon.SelecteSavedList and not character then 
			FullList = loadAltsSavedSets(profile)
		else
			--Blizzard Sets
			local outfits = C_TransmogCollection.GetOutfits();
			local baseID = 0
			for i, outfitID in ipairs(outfits) do
				local data = {}
				local name, icon = C_TransmogCollection.GetOutfitInfo(outfitID);
				data.setType = "SavedBlizzard"
				data.index = i
				data.outfitID = outfitID + 5000
				data.name = name
				data.icon = icon
				data.label = L["Saved Set"]
				FullList[i] = data
				data.validForCharacter = true
			end

		--Extended Sets
			if addon.OutfitDB.char.outfits then 
				for i, data in ipairs(addon.OutfitDB.char.outfits) do
					data.outfitID = MAX_DEFAULT_OUTFITS + i + 5000
					data.index = i
					data.name = addon.OutfitDB.char.outfits[i].name
					local sourceInfo
					data.setType = "SavedExtra"
					data.label= L["Extended Saved Set"]
				data.validForCharacter = true

					--data.itemData should hold the most current set data
					if data.itemData and #data.itemData ~= 0 then
						for i=1, 19 do
							local source
							local setInfo = data.itemData[i]
							if setInfo then
								data[i] = setInfo[2]
							else 
								data[i] = 0
							end
						end

					elseif (not data.itemData or #data.itemData == 0) then
						if data.itemTransmogInfoList then
							for i=1, 19 do
								local source = (data.itemTransmogInfoList[i] and data.itemTransmogInfoList[i].appearanceID) or 0
								local illusionID = (data.itemTransmogInfoList[i] and data.itemTransmogInfoList[i].illusionID) or 0
								local offShoulder = (data.itemTransmogInfoList[i] and data.itemTransmogInfoList[i].secondaryAppearanceID) or 0
								data[i] = source

								if i == 3 then
									data.offShoulder = offShoulder
								elseif i == 16 then
									data.mainHandEnchant  = illusionID
								elseif i == 17 then
									data.offHandEnchant  = illusionID
								end
							end
							data.sources = nil
							data.itemTransmogInfoList = nil
							data.items = nil
							data.validForCharacter = true
				data.icon = icon

						elseif data.sources and  #data.sources ~= 0 then
							for item_data, source_data in pairs(data.sources) do 
								--print(source_data)
								--itemlink, appearance pairs
								if string.find(item_data, "item:") then 
									local _, sourceID = C_TransmogCollection.GetItemInfo(item_data)
									sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)

								--itemID, appearance/source pairs.  Checking for both to catch all possible saved types
								else
									local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(item_data)
									if appearanceID and appearanceID == source_data then 
									elseif appearanceID then 
										for itemMod = 1, 10 do
											appearanceID, sourceID = C_TransmogCollection.GetItemInfo(item_data, itemMod)
											if appearanceID == source_data then 
												break
											end
										end
									end

									sourceInfo = sourceID and C_TransmogCollection.GetSourceInfo(sourceID)
									--value returned info and the itemID matches, so its was an appearanceID
									if sourceInfo and sourceInfo.itemID == item_data then 

									else
									--value returned info and the itemID matches, so its was an sourceID
										sourceInfo = C_TransmogCollection.GetSourceInfo(source_data)
										if sourceInfo and sourceInfo.itemID == item_data then 
										else
											sourceInfo = nil
										end
									end
								end

								if sourceInfo and sourceInfo.invType then  
									local slot = C_Transmog.GetSlotForInventoryType(sourceInfo.invType);
									local sourceID = sourceInfo.sourceID
									data[slot] = sourceID
								end
							end
						end
					end

					--Clear older junk
					data.sources = nil
					data.itemTransmogInfoList = nil
					data.items = nil
					data.itemData = nil
			
					tinsert(FullList, data)
				end
			end
		
			--MogIt Sets
			local mogit_Outfits = addon.MogIt.GetMogitOutfits()
			if mogit_Outfits then 
				for i, data in ipairs(mogit_Outfits) do
					data.validForCharacter = true

					tinsert(FullList, data)
				end
			end

			--TransmogOutfits Sets
			local transmogOutfits_Sets = addon.TransmogOutfits.GetOutfits()
			if transmogOutfits_Sets then 
				for i, data in ipairs(transmogOutfits_Sets) do
								data.validForCharacter = true

					tinsert(FullList, data)
				end
			end

		end

		return FullList
	end



	function addon.IsDefaultSet(outfitID)
		local savedSets = addon.GetSavedList()
		for i, data in ipairs(savedSets) do
			if data.setID == outfitID and data.setType == "SavedBlizzard" then 
				return true
			end
		end
		return false
		--local MAX_DEFAULT_OUTFITS = C_TransmogCollection.GetNumMaxOutfits()
		----return outfitID < MAX_DEFAULT_OUTFITS  -- #C_TransmogCollection.GetOutfits()--MAX_DEFAULT_OUTFITS 
	end

	function addon.GetSetType(outfitID)
		  setData = addon.GetSetInfo(outfitID)
		return setData and setData.setType or "Unknown"
	end


	function addon.StoreBlizzardSets()
		local BlizzardSavedSets = {}
		local outfits = C_TransmogCollection.GetOutfits();
		for i, outfitID in ipairs(outfits) do
			local data = {}
			local name, icon = C_TransmogCollection.GetOutfitInfo(outfitID);
			data.index = i
			data.outfitID = outfitID
			data.name = name
			data.icon = icon

			local outfitItemTransmogInfoList = C_TransmogCollection.GetOutfitItemTransmogInfoList(outfitID);
			data.sources = {}
			for i, list_data in pairs(outfitItemTransmogInfoList) do
				data.sources[i] = list_data.appearanceID or 0
			end
			tinsert(BlizzardSavedSets, data)
		end

		addon.setdb.global.sets[addon.setdb:GetCurrentProfile()] = BlizzardSavedSets
		return BlizzardSavedSets
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
				info.setType = data.setType
				info.label = data.label
				info.description = ""
				info.expansionID = 1
				info.favorite = false
				info.hiddenUntilCollected = false
				info.limitedTimeSet = false
				info.patchID = 0
				info.setID = data.setID or (data.outfitID)
				info.uiOrder = data.uiOrder or (data.index * 100)
				info.icon = data.icon
				info.isClass = true
				info.mainShoulder = data[3] or 0
				info.offShoulder = data.offShoulder or 0
				info.itemTransmogInfoList = data.itemTransmogInfoList
				info.validForCharacter = true

				info.mainHandEnchant = data.mainHandEnchant
				info.offHandEnchant = data.offHandEnchant

				info.itemData = data.itemData
				info.baseSetID = info.setID;
				info.savedSet = true

				if data.setType == "SavedBlizzard" then 
					local outfitItemTransmogInfoList = C_TransmogCollection.GetOutfitItemTransmogInfoList(data.outfitID - 5000);
					info.sources = {}
					for i, data in pairs(outfitItemTransmogInfoList) do
						info.sources[i] = data.appearanceID
					end

				elseif data.setType == "SavedExtra" then
					local ItemTransmogInfoList = {}
					info.sources = {}
					for slotID = 1, 19 do
						local sourceID = data[slotID]
						info.sources[slotID] = 0
						if sourceID  and sourceID ~= NO_TRANSMOG_SOURCE_ID and sourceID ~= 0 then 
							 sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
									
							if sourceInfo and sourceInfo.invType then 
								local slot = C_Transmog.GetSlotForInventoryType(sourceInfo.invType);
								local appearanceID = sourceInfo.visualID
								local itemID = sourceInfo.itemID
								local itemMod = sourceInfo.itemModID
								info.itemData = info.itemData or {}
								info.itemData[slot] = {"'"..itemID..":"..itemMod.."'", sourceID, appearanceID}
														info.sources[slotID] = sourceInfo.sourceID

							end
						end
						--end

							--[[local illusionID
																					if slotID == 16 then 
																						illusionID = data["mainHandEnchant"] or 0
																					elseif slotID == 17 then 
																						illusionID = data["offHandEnchant"] or 0
																					else
																						illusionID = 0
																					end
																					ItemTransmogInfoList[slotID] = ItemUtil.CreateItemTransmogInfo(data[slotID] or 0, 0, illusionID);]]
					end







					----info.sources = C_TransmogCollection.GetOutfitSources(data.outfitID)
				--elseif  #info.sources == 0 then 
					--for i = 1, 19 do  ----was 16?
						--info.sources[i] = data[i] or 0
					--end
				--end



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
					end]]

					--info.itemTransmogInfoList = data.itemTransmogInfoList
				end

				baseIDs[info.setID] =  info;
				table.insert(baseList, info);

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
				info.hiddenUntilCollected = false
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

	function addon.GetSets()
		return SET_INDEX
	end 
	function addon.SetItemSubstitute(itemID, subID)
		itemID = tonumber(itemID)
		subID = tonumber(subID)

		if type(itemID) ~= "number" or type(subID) ~= "number" then 
			BetterWardrobeOutfitManager:ShowPopup("BETTER_WARDROBE_SUBITEM_INVALID_POPUP")
			return false 
		end

		local _, _, _, itemEquipLoc1 = GetItemInfoInstant(itemID) 
		local _, _, _, itemEquipLoc2 = GetItemInfoInstant(subID) 

		if itemEquipLoc1 ~= itemEquipLoc2 then 
			BetterWardrobeOutfitManager:ShowPopup("BETTER_WARDROBE_SUBITEM_WRONG_LOCATION_POPUP")
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
			addon.SetsDataProvider:ClearSets()

			addon.Init:BuildDB()

			if BetterWardrobeCollectionFrame.SetsCollectionFrame:IsShown() then  --0--TODO FIX
				BetterWardrobeCollectionFrame.SetsCollectionFrame:Refresh()
				BetterWardrobeCollectionFrame.SetsCollectionFrame:OnSearchUpdate()
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
			addon.SetsDataProvider:ClearSets()

			addon.Init:BuildDB()
			addon.GetBaseList()
			if BetterWardrobeCollectionFrame.SetsCollectionFrame:IsShown() then  --0--TODO FIX
				BetterWardrobeCollectionFrame.SetsCollectionFrame:Refresh()
				BetterWardrobeCollectionFrame.SetsCollectionFrame:OnSearchUpdate()
			end
			addon.RefreshSubItemData()



		addon:ClearCache()

		addon.Init:BuildDB()
		addon.GetBaseList()
		addon.RefreshSubItemData()
		addon.RefreshLists()
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
		--return C_TransmogSets.GetSetPrimaryAppearances(setID)
		return addon.C_TransmogSets.GetSetSources(setID)
	end

	function addon:IsCollected(visualID)
		return collectedAppearances[visualID]
	end
end

StaticPopupDialogs["BETTER_WARDROBE_SUBITEM_WRONG_LOCATION_POPUP"] = {
	preferredIndex = 3,
	text = "Item Locations Do Not Match",
	button1 = OKAY,
	button2 = CANCEL,
	OnShow = function(self)

	end,
	OnAccept = function(self)
	end,
	hideOnEscape = 1,
	timeout = 0,
	whileDead = 1,
}

StaticPopupDialogs["BETTER_WARDROBE_SUBITEM_INVALID_POPUP"] = {
	preferredIndex = 3,
	text = "Sub Item is",
	button1 = OKAY,
	button2 = CANCEL,
	OnShow = function(self)

	end,
	OnAccept = function(self)
	end,
	hideOnEscape = 1,
	timeout = 0,
	whileDead = 1,
}

	local SetSwaps = {}
	function addon.HasSubItem(setID)
				return SetSwaps[setID]
	end --SetSwaps[setID][itemFrame.sourceID] then

	function addon.GetSubItem(sourceID, setID)
		local newSource = subitemlist[sourceID]
		if newSource then
			SetSwaps[setID] = SetSwaps[setID] or {}
			SetSwaps[setID][newSource] = true
			return subitemlist[sourceID]
		end
	end