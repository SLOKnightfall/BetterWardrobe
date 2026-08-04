local app = select(2,...);

local expansionID = 1;

--Name, Description, Label, classMask, patchID, sources, requiredFact
----classMask:    (35=Plate, 68=Mail, 3592=Leather, 400=Cloth)
local db = {
--Classic Raid Recolors Plate
{2000086,"Purple Judgement",nil,nil,"Classic Raid Recolors (BC)",2,20000.1,{11907,11932,11967,11974,12037,12066,12137,12340,}},
{2000085,"Red Lawbringer",nil,nil,"Classic Raid Recolors (BC)",2,20000.1,{11898,11939,12044,12073,12102,12129,12136,12406,}},
{2000084,"Blue Lawbringer",nil,nil,"Classic Raid Recolors (BC)",2,20000.1,{9343,14337,14338,}},
{2000083,"Red Battlegear of Might",nil,nil,"Classic Raid Recolors (BC)",1,20000.1,{11905,11930,12064,12144,12155,12329,12398,12427,}},
{2000082,"Green Battlegear of Wrath",nil,nil,"Classic Raid Recolors (BC)",1,20000.1,{11909,11951,11957,11995,12081,12105,12360,12438,}},
--Classic Raid Recolors Mail
{2000081,"Red Dragonstalker",nil,nil,"Classic Raid Recolors (BC)",4,20000.1,{11936,11969,12034,12087,12132,12153,12338,12412,}},
{2000080,"Purple Dragonstalker",nil,nil,"Classic Raid Recolors (BC)",4,20000.1,{12604,13183,13184,13185,13882,}},
{2000079,"Orange Giantstalker",nil,nil,"Classic Raid Recolors (BC)",4,20000.1,{11901,11952,11953,12057,12309,12335,12382,}},
{2000078,"The Ten Pink Storms",nil,nil,"Classic Raid Recolors (BC)",64,20000.1,{11908,11975,12047,12080,12090,12094,12150,12316,}},
{2000077,"Dark Purple Earthfury",nil,nil,"Classic Raid Recolors (BC)",64,20000.1,{11904,12068,12103,12198,12363,12439,}},
--Classic Raid Recolors Leather
{2000076,"Blue Bloodfang",nil,nil,"Classic Raid Recolors (BC)",8,20000.1,{11946,12051,12063,12093,12114,12252,12328,12442,}},
{2000075,"Silver Bloodfang",nil,nil,"Classic Raid Recolors (BC)",8,20000.1,{12525,12544,12570,12575,12615,12739,13503,12761,}},
{2000074,"Blue Stormrage",nil,nil,"Classic Raid Recolors (BC)",1024,20000.1,{11927,11934,12062,12085,12152,12334,12339,12355,}},
{2000073,"Gold Nightslayer",nil,nil,"Classic Raid Recolors (BC)",8,20000.1,{11910,11915,11972,12089,12149,12164,12200,}},
{2000072,"Silver Nightslayer",nil,nil,"Classic Raid Recolors (BC)",8,20000.1,{12415,13101,13875,14322,}},
{2000071,"Yellow Cenarion",nil,nil,"Classic Raid Recolors (BC)",1024,20000.1,{11906,12049,12075,12091,12352,12365,12409,12444,}},
--Classic Raid Recolors Cloth
{2000070,"Orange Nemesis",nil,nil,"Classic Raid Recolors (BC)",256,20000.1,{11911,11935,12061,12070,12074,12086,12199,12407,}},
{2000069,"Purple Transcendence",nil,nil,"Classic Raid Recolors (BC)",16,20000.1,{11903,11940,11970,12113,12156,12337,12351,12380,}},
{2000068,"Red Netherwind",nil,nil,"Classic Raid Recolors (BC)",128,20000.1,{11914,11949,12053,12088,12141,12308,12393,12426,}},
{2000067,"Purple Prophecy",nil,nil,"Classic Raid Recolors (BC)",16,20000.1,{8650,8651,8652,9480,9483,}},
{2000066,"Gold Arcanist",nil,nil,"Classic Raid Recolors (BC)",128,20000.1,{9482,9485,12560,12726,13998,}},
{2000065,"Copper Arcanist",nil,nil,"Classic Raid Recolors (BC)",128,20000.1,{11931,12032,12035,12050,12083,12106,12332,12353,}},
{2000064,"Teal Arcanist",nil,nil,"Classic Raid Recolors (BC)",128,20000.1,{8647,8648,8649,11973,12515,}},

--BC Raid Recolors Plate
{2000063,"Wardancer",nil,nil,"Serpentshrine Cavern",1,20000,{13413,13438,13452,13496,13539,}},
--{"Glowing Truth",nil,"Serpentshrine Cavern",2,20000,{13493,13505,13523,13547,16221,}}, --Missing Pants
{2000062,"Protectorate",nil,nil,"Gruul's Lair",2,20000,{13407,13399,15065,}},
--BC Raid Recolors Mail
{2000061,"Void Reaver",nil,nil,"Serpentshrine Cavern",4,20000,{13440,13490,13491,13497,13524,13530,}},
{2000060,"The Wavemender's",nil,nil,"Black Temple",64,20000,{13961,14872,15007,16553,}},
{2000059,"Fire Crest",nil,nil,"Serpentshrine Cavern",64,20000,{13385,13431,13446,13489,13492,13535,}},
--BC Raid Recolors Leather
--{"Immortal Nature",nil,"Black Temple",1024,20000,{14871,14895,14909,15008,}},--Missing Chest
--BC Raid Recolors Cloth
{2000058,"Benevolence",nil,nil,"Black Temple",16,20000,{14897,14910,14919,14931,16200,}},
{2000057,"Shifting Nightmare",nil,nil,"Serpentshrine Cavern",256,20000,{13495,13499,13504,13519,}},
{2000056,"Grand Engineer",nil,nil,"Serpentshrine Cavern",128,20000,{13383,13427,13441,13442,13468,13470,13507,13544,}},

--Vendor Plate
--Vendor Mail
--Vendor Leather
--Vendor Cloth

--Crafted Plate
--Crafted Mail
--Crafted Leather
--Crafted Cloth

--Dungeon Plate
{2000055,"Lightforge",nil,nil,"Dungeon (BC)(Set 1)",35,20000,{6853,6854,6855,6856,6857,6858,6859,6860,}},
{2000054,"Azureplate",nil,nil,"Dungeon (BC)(Set 1)",35,20000,{9420,9520,9571,9572,10654,11879,11888,}},

{2000053,"Doomplate",nil,nil,"Dungeon (BC)(Set 2)",35,20000,{11938,12055,12116,12194,12343,12394,12448,}},
{2000052,"Bold",nil,nil,"Dungeon (BC)(Set 2)",35,20000,{11923,12078,12191,12327,12418,13033,13034,}},
{2000051,"Courage",nil,nil,"Dungeon (BC)(Set 2)",35,20000,{12510,12522,12571,12573,12582,12594,12695,12194,}},

--{"Righteous",nil,"Dungeon (BC)(Set 3)",35,20000,{11963,12030,12098,12325,12369,13048,13049,}},
--{"Crusader's Ornamented",nil,"Dungeon (BC)(Set 3)",35,20000,{16472,16471,16473,16474,16475,17064,}},

{2000050,"Iron Guardian",nil,nil,"Dungeon (BC)(Set 3)",35,20000,{9429,9434,9519,9528,9570,9575,10667,}},
{2000049,"Wildguard",nil,nil,"Dungeon (BC)(Set 3)",35,20000,{14333,14335,14336,}},

--Dungeon Mail
{2000048,"Shamblehide",nil,nil,"Dungeon (BC)(Set 1)",68,20000,{9421,9433,9516,9522,9565,9577,10653,11884,}},
{2000047,"Netherstrike",nil,nil,"Dungeon (BC)(Set 1)",68,20000,{13187,13188,13189,13807,}},

{2000046,"Living Lightning",nil,nil,"Dungeon (BC)(Set 2)",68,20000,{9427,9514,9529,10659,10666,11893,}},

{2000045,"Beast Lord",nil,nil,"Dungeon (BC)(Set 3)",68,20000,{11922,12076,12119,{12345,16451},12367,13054,13055,13053,}},
{2000044,"Desolation",nil,nil,"Dungeon (BC)(Set 3)",68,20000,{11926,11958,12009,12162,12314,12434,12446,}},
{2000043,"Carnage",nil,nil,"Dungeon (BC)(Set 3)",68,20000,{12523,12574,12692,21305,21313,}},

{2000042,"Mistshroud",nil,nil,"Dungeon (BC)(Set 4)",68,20000,{14481,14482,14483,14484,14485,14486,}},
{2000041,"Felstalker",nil,nil,"Dungeon (BC)(Set 4)",68,20000,{10554,10555,10556,12296,35709,}},

--{"Tidefury",nil,"Dungeon (BC)(Set 5)",68,20000,{{11944,16135},12077,12147,12348,12417,13039,13040,13038}},
--{"Seer's",nil,"Dungeon (BC)(Set 5)",68,20000,{16462,{16461,12687},{16464,18047},16463,16465,}},

--Dungeon Leather
{2000040,"Assassination",nil,nil,"Dungeon (BC)(Set 1)",3592,20000,{11943,12059,12146,12326,12458,13042,13043,}},
{2000039,"Opportunist's",nil,nil,"Dungeon (BC)(Set 1)",3592,20000,{16444,16441,16442,16443,16445,21345,12408,}},
{2000038,"Wastewalker",nil,nil,"Dungeon (BC)(Set 1)",3592,20000,{11960,12048,12096,12362,12408,}},

--{"Moonglade",nil,"Dungeon (BC)(Set 2)",3592,20000,{11916,12028,12118,12324,12416,13057,13058,}},

{2000037,"Nightwatcher",nil,nil,"Dungeon (BC)(Set 2)",3592,20000,{9531,9566,9569,11880,11886,}},

--Dungeon Cloth
{2000036,"Divine Authority",nil,nil,"Dungeon (BC)(Set 1)",400,20000,{14303,9537,11881,11882,11896,}},

--{"Mana-Etched",nil,"Dungeon (BC)(Set 2)",400,20000,{11913,12071,12101,12145,12313,12315,12451,}},
--{"Mooncloth",nil,"Dungeon (BC)(Set 2)",400,20000,{16137,16416,16417,16418,16419,16420,}},
--{"Hallowed",nil,"Dungeon (BC)(Set 2)",400,20000,{11964,12058,12120,12347,12457,13045,13046,}},

{2000035,"Arcane Rage",nil,nil,"Dungeon (BC)(Set 2)",400,20000,{9423,9515,9532,9535,9564,9579,10668,}},

--{"Oblivion",nil,"Dungeon (BC)(Set 4)",400,20000,{11965,12060,12168,12349,12459,13036,13037,}},
--{"Fel-Tinged",nil,"Dungeon (BC)(Set 4)",400,20000,{76766,21329,}},

{2000034,"Incanter's",nil,nil,"Dungeon (BC)(Set 3)",400,20000,{11942,12029,12097,12346,12368,13051,13052,}},

--Leveling Plate
{2000033,"Bloodscale",nil,nil,"Leveling (BC)(Set 1)",35,19999,{9967,9968,9969,9970,9972,9974,}},

{2000032,"Warmaul",nil,nil,"Leveling (BC)(Set 2)",35,19999,{10015,10016,10017,10018,10020,10022,}},

{2000031,"Bloodfist",nil,nil,"Leveling (BC)(Set 3)",35,19999,{10023,10024,10025,10026,10028,10030,}},

{2000030,"Conqueror's",nil,nil,"Leveling (BC)(Set 4)",35,19999,{10031,10032,10033,10034,10036,10038,}},

{2000029,"Khan'aish",nil,nil,"Leveling (BC)(Set 5)",35,19999,{9983,9984,9986,9988,9990,10041,10043,10045,}},
{2000028,"Grimscale",nil,nil,"Leveling (BC)(Set 5)",35,19999,{9943,9944,9945,9946,9948,9950,}},
{2000027,"Tarnished Plate",nil,nil,"Leveling (BC)(Set 5)",35,19999,{10381,10378,10384,10379,10380,10382,}},

{2000026,"Bogslayer",nil,nil,"Leveling (BC)(Set 6)",35,19999,{9975,9976,9977,9978,9979,9980,9981,9982,}},

{2000025,"Fel Iron",nil,nil,"Leveling (BC)(Set 7)",35,19999,{9301,9302,9303,9304,9305,}},
{2000024,"Bone-Plated",nil,nil,"Leveling (BC)(Set 7)",35,19999,{14582,18501,3026,18502,18503,4712,}},
{2000023,"Darksoul",nil,nil,"Leveling (BC)(Set 7)",35,19999,{7789,7787,14417,7788,}},
{2000022,"Flamebane",nil,nil,"Leveling (BC)(Set 7)",35,19999,{5810,9324,4717,9329,9326,9325,}},
{2000021,"Iron Tower",nil,nil,"Leveling (BC)(Set 7)",35,19999,{13514,8810,9340,}},
{2000020,"Heroic",nil,nil,"Leveling (BC)(Set 7)",35,19999,{5776,5770,5773,5775,14492,5777,5772,}},

{2000019,"Talonguard",nil,nil,"Leveling (BC)(Set 8)",35,19999,{9991,9992,9993,9994,9996,9998,}},

--Leveling Mail
{2000018,"Stormforged",nil,nil,"Leveling (BC)(Set 1)",68,19999,{10407,10436,13516,10461,10462,10484,}},

{2000017,"Talhide",nil,nil,"Leveling (BC)(Set 2)",68,19999,{9927,9928,9929,9930,9931,9932,9933,9934,}},

{2000016,"Inferno Forged",nil,nil,"Leveling (BC)(Set 3)",68,19999,{13907,14020,14025,14026,}},
{2000015,"Brigandine",nil,nil,"Leveling (BC)(Set 3)",68,19999,{789,790,791,792,793,794,}},
{2000014,"Augmented Chain",nil,nil,"Leveling (BC)(Set 3)",68,19999,{783,785,784,786,787,788,}},

{2000013,"Warder's",nil,"Vendor: Sana (Orgrimmar) or Aldric Moore (Stormwind)","Leveling (BC)(Set 4)",68,19999,{28826,8248,8249,}},

{2000012,"Scout's",nil,"Vendor: Sana (Orgrimmar) or Aldric Moore (Stormwind)","Leveling (BC)(Set 5)",68,19999,{28829,9210,9214,}},

--Leveling Leather
{2000011,"Wild Draenish",nil,nil,"Leveling (BC)(Set 1)",3592,19999,{10536,10537,10538,10539,}},
{2000010,"Muck",nil,nil,"Leveling (BC)(Set 2)",3592,19999,{10412,10423,10430,10456,10459,10470,}},

{2000009,"Expedition",nil,nil,"Leveling (BC)(Set 2)",3592,19999,{9815,9816,9817,9818,9819,9820,9821,9822,}},

{2000008,"Bonechewer",nil,nil,"Leveling (BC)(Set 3)",3592,19999,{9718,9719,9720,9721,9723,9725}},
{2000007,"Sun Cured",nil,nil,"Leveling (BC)(Set 3)",3592,19999,{8269,8264,8268,8247,8266,8267}},
{2000006,"Lookout's",nil,nil,"Leveling (BC)(Set 3)",3592,19999,{8246,8245,8247,9721,9719}},

--Leveling Cloth
{2000005,"Windchanneller's",nil,nil,"Leveling (BC)(Set 1)",400,19999,{14463,14464,14465,14466,14467,14468,14469,14470,}},

{2000004,"Vindicator",nil,nil,"Leveling (BC)(Set 2)",400,19999,{9638,9639,9640,9641,9642,9643,9644,9645,}},

{2000003,"Mistyreed",nil,nil,"Leveling (BC)(Set 3)",400,19999,{9662,9663,9664,9665,9666,9667,9668,9669,}},
{2000002,"Consortium",nil,nil,"Leveling (BC)(Set 3)",400,19999,{9678,9679,9680,9681,9682,9683,9684,9685,}},

{2000001,"Soul-Trader's",nil,nil,"Leveling (BC)(Set 4)",400,19999,{18283,8686,18280,18360,18282,18281,}},

--{"Fireheart",nil,"Leveling (BC)(Set 4)",400,19999,{9614,9615,9616,9617,9619,9621,}},
--{"Laughing Skull",nil,"Leveling (BC)(Set 4)",400,19999,{9633,9630,9631,9632,9634,9635,9637,}},
--{"Outlander's",nil,"Leveling (BC)(Set 4)",400,19999,{9609,9608,9611,9602,9607,9613,}},
--{"Feralfen",nil,"Leveling (BC)(Set 4)",400,19999,{9656,9659,9654,9655,9657,9661,}},

--{"Astralaan",nil,"Leveling (BC)(Set -)",400,19999,{9670,9671,9673,9674,9675,9676,9677,}},--Missing Chest
};

local function comp(a,b)
  if a[1] < b[1] then return true; else return false end
end
table.sort(db,comp);

local isRaidSet = {
[351]=true,
[353]=true,
[354]=true,
[847]=true,
[848]=true,
[849]=true,
[862]=true,
[863]=true,
[864]=true,
[870]=true,
[871]=true,
[872]=true,
[888]=true,
[889]=true,
[890]=true,
[896]=true,
[897]=true,
[898]=true,
[904]=true,
[905]=true,
[906]=true,
[912]=true,
[913]=true,
[918]=true,
[920]=true,
[921]=true,
[922]=true,
[352]=true,
[903]=true,
[932]=true,
[351]=true,
[353]=true,
[354]=true,
[847]=true,
[848]=true,
[849]=true,
[862]=true,
[863]=true,
[864]=true,
[870]=true,
[871]=true,
[872]=true,
[888]=true,
[889]=true,
[890]=true,
[896]=true,
[897]=true,
[898]=true,
[904]=true,
[905]=true,
[906]=true,
[912]=true,
[913]=true,
[918]=true,
[920]=true,
[921]=true,
[922]=true,
[887]=true,
[919]=true,
[351]=true,
[353]=true,
[354]=true,
[847]=true,
[848]=true,
[849]=true,
[862]=true,
[863]=true,
[864]=true,
[870]=true,
[871]=true,
[872]=true,
[888]=true,
[889]=true,
[890]=true,
[896]=true,
[897]=true,
[898]=true,
[904]=true,
[905]=true,
[906]=true,
[912]=true,
[913]=true,
[918]=true,
[920]=true,
[921]=true,
[922]=true,
[869]=true,
[911]=true,
[351]=true,
[353]=true,
[354]=true,
[847]=true,
[848]=true,
[849]=true,
[862]=true,
[863]=true,
[864]=true,
[870]=true,
[871]=true,
[872]=true,
[888]=true,
[889]=true,
[890]=true,
[896]=true,
[897]=true,
[898]=true,
[904]=true,
[905]=true,
[906]=true,
[912]=true,
[913]=true,
[918]=true,
[920]=true,
[921]=true,
[922]=true,
[931]=true,
[895]=true,
[2000063] = true,
[2000062] = true,
[2000061] = true,
[2000060] = true,
[2000059] = true,
[2000058] = true,
[2000057] = true,
[2000056] = true,
}

--Used to add alternate appearances to blizzard sets
--SetID, OriginalSourceID, AlternateApperanceID
local altAppearancesDB = {
[4132]={{16456,12687},--TBC Dungeon Mail Red Chest/Robe
        {16464,18047},},--TBC Dungeon Mail Red pants/skirt
[4130]={{11944,16135},},--TBC Dungeon Mail blue gloves
[4126]={{16450,21323},},--TBC Dungeon Leather Red Chest/Robe
}

local altLabelAppendDB = {
[4137] = " (Set 1)",
[4141] = " (Set 2)",
[4142] = " (Set 2)",
[4140] = " (Set 1)",
[4138] = " (Set 1)",
[4139] = " (Set 1)",
[4143] = " (Set 2)",
}

local function AddToCollection(isTransmogrifier)
  for i = 1, #db do
    app.AddDBLineToTables(db[i], expansionID, isTransmogrifier);
  end
end

local function GetSetNameBySetID(setID)
  if not db[setID] then return end  
  
  local label = db[setID][5]
  local name;
  if db[setID][3] then name = db[setID][3] else name = db[setID][2] end
  local armorWeight = db[setID][6];
  
  return label, name, armorWeight;
end
app.GetExpacArmorSetNameBySetID[expansionID+1] = GetSetNameBySetID;

local function GetSetSourcesBySetID(setID)
  if not db[setID] then return end

  return db[setID][8];
end
app.GetExpacArmorSetSourcesBySetID[expansionID+1] = GetSetSourcesBySetID

local function GenerateSetInfo(setID)
  app.AddDBLineToTables(db[setID], expansionID);
end
app.GenerateSetInfo[expansionID+1] = GenerateSetInfo

app.ExpandedCallbacks[expansionID+1] = AddToCollection;
app.altAppearancesDB[expansionID+1] = altAppearancesDB;
app.altLabelAppendDB[expansionID+1] = altLabelAppendDB;
app.isRaidSet[expansionID+1] = isRaidSet;

--data:
----classMask:    yes (simply use 35=Plate, 68=Mail, 3592=Leather, 400=Cloth)
----collected:    no
----description:  yes
----expansionID:  no (file dependent can hardcode)
----favorite:     no
----hidden...:    no
----label:        yes (source i.e. dungeon/leveling/islands)
----limitedTime:  no
----name:         yes
----patchID:      yes (for sorting, 80300 = patch 8.3)
----requiredFact: yes
----setID:        yes (auto gened)
----uiOrder:      yes (might just always put 0, for sorting)
----sources:      myAddition, list of items in the set