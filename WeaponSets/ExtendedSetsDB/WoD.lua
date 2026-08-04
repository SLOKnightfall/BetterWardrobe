local app = select(2,...);

local expansionID = 5;

--Name, Description, Label, classMask, patchID, sources, requiredFact
----classMask:    (35=Plate, 68=Mail, 3592=Leather, 400=Cloth)
local db = {
--Stormwind and Orgrimmar Cosmetic Sets
{6000071,"Stormwind",nil,nil,"Guard Cosmetic (WoD)",0,60000.4,{65967,65968,65969,66538,65970,65971,65972,65973,},"Alliance"},
{6000070,"Orgrimmar",nil,nil,"Guard Cosmetic (WoD)",0,60000.4,{66531,66532,66533,66534,66535,66536,66537,},"Horde"},

--Garrison Plate
{6000069,"Heart-Lesion",nil,nil,"Garrison Salvage",32,60000.3,{67332,67333,67334,67335,67336,67337,67338,67339,}},
{6000068,"Sunsoul",nil,nil,"Garrison Salvage",2,60000.3,{67425,67426,67427,67428,67429,67430,67431,67432,}},
{6000067,"Oathsworn",nil,nil,"Garrison Salvage",1,60000.3,{67534,67535,67536,67537,67538,67539,67540,67541,}},
--Garrison Mail
{6000066,"Trailseeker",nil,nil,"Garrison Salvage",4,60000.3,{67383,67384,67385,67386,67387,67389,67390,}},
{6000065,"Streamtalker",nil,nil,"Garrison Salvage",64,60000.3,{67492,67493,67494,67495,67496,67498,67499,67500,}},
--Garrison Leather
{6000064,"Mistdancer",nil,nil,"Garrison Salvage",512,60000.3,{67405,67406,67408,67409,67411,67412,}},
{6000063,"Springrain",nil,nil,"Garrison Salvage",1024,60000.3,{67353,67354,67355,67356,67357,67358,67360,67361,}},
{6000062,"Lightdrinker",nil,nil,"Garrison Salvage",8,60000.3,{67479,67480,67481,65876,67483,65878,65879,65880,}},
--Garrison Cloth
{6000061,"Communal",nil,nil,"Garrison Salvage",16,60000.3,{67459,67460,67461,67462,67463,67464,67465,67466,}},
{6000060,"Felsoul",nil,nil,"Garrison Salvage",256,60000.3,{67522,67523,67524,67525,67526,67527,67528,67529,}},
{6000059,"Mountainsage",nil,nil,"Garrison Salvage",128,60000.3,{67393,67394,67395,67396,67397,67398,67399,67400,}},

--Crafted Plate
{6000058,"Truesteel",nil,nil,"Crafted (WoD)",35,60000.2,{62930,62931,62932,62936,62937,62933,62934,62935,}},
{6000057,"Truesteel",nil,nil,"Crafted (WoD)",35,60000.2,{65292,65291,65290,65286,65284,65289,65288,65287,}},
{6000056,"Truesteel",nil,nil,"Crafted (WoD)",35,60000.2,{65299,65298,65297,65293,65285,65296,65295,65294,}},
--Crafted Mail
{6000055,"Wayfaring",nil,nil,"Crafted (WoD)",68,60000.2,{65018,65015,65027,65030,65024,65036,65021,65033,}},
{6000054,"Wayfaring",nil,nil,"Crafted (WoD)",68,60000.2,{65019,65016,65028,65031,65025,65037,65022,65034,}},
{6000053,"Wayfaring",nil,nil,"Crafted (WoD)",68,60000.2,{65020,65017,65029,65032,65026,65038,65023,65035,}},
--Crafted Leather
{6000052,"Supple",nil,nil,"Crafted (WoD)",3592,60000.2,{64992,64989,65001,65004,64998,65010,64995,65007,}},
{6000051,"Supple",nil,nil,"Crafted (WoD)",3592,60000.2,{64993,64990,65002,65005,64999,65011,64996,65008,}},
{6000050,"Supple",nil,nil,"Crafted (WoD)",3592,60000.2,{64994,64991,65003,65006,65000,65012,64997,65009,}},
--Crafted Cloth
{6000049,"Hexweave",nil,nil,"Crafted (WoD)",400,60000.2,{63683,63682,63686,63687,63685,63689,63684,63688,}},

--Blackrock LFR Plate
{6000048,"Bouldercrush",nil,nil,"Blackrock Foundry LFR",35,60002,{66701,66700,66703,66699,66702,66698,66697,66705,}},--no longer obtainable?
{6000047,"Crazed Bomber's",nil,nil,"Blackrock Foundry LFR",35,60002,{63356,63365,63380,63392,63404,63416,63428,63440,}},
{6000046,"Iron Bomb",nil,nil,"Blackrock Foundry LFR",35,60002,{66958,66956,66957,66955,66954,66961,66960,66959,}},

--Blackrock LFR Mail
{6000045,"Ashlink",nil,nil,"Blackrock Foundry LFR",68,60002,{68055,68047,68051,68039,66917,68035,68043,}},
{6000044,"Undying",nil,nil,"Blackrock Foundry LFR",68,60002,{63353,63362,63377,63389,63401,63413,63425,63437,}},
{6000043,"Longshot",nil,nil,"Blackrock Foundry LFR",68,60002,{66726,66727,66725,66724,66728,66729,66722,66723,}},--no longer obtainable?

--Blackrock LFR Leather
{6000042,"Determined Resolve",nil,nil,"Blackrock Foundry LFR",3592,60002,{63350,63359,63374,63386,63398,63410,63422,63434,}},
{6000041,"Bladefang",nil,nil,"Blackrock Foundry LFR",3592,60002,{70296,70260,70344,70312,70360,70280,70328,}},
{6000040,"Sootfur",nil,nil,"Blackrock Foundry LFR",3592,60002,{68023,68019,68013,68031,66904,68011,68027,}},

--Blackrock LFR Cloth
{6000039,"Ebonflame",nil,nil,"Blackrock Foundry LFR",400,60002,{67988,68000,67996,67992,66925,68004,68007,}},
{6000038,"Volatile Ice",nil,nil,"Blackrock Foundry LFR",400,60002,{63347,63368,63371,63383,63395,63407,63419,63431,}},
{6000037,"Felcast",nil,nil,"Blackrock Foundry LFR",400,60002,{70272,70292,70324,70356,70276,70340,70308,70244,}},

--Dungeon Plate
{6000036,"Incardine",nil,nil,"Dungeon (WoD)",35,60000.1,{59461,59486,59505,59524,59560,59605,59627,}},
{6000035,"Goldsteel",nil,nil,"Dungeon (WoD)",35,60000.1,{61480,61482,61478,61479,61475,61481,61476,}},
{6000034,"Verdant Plate",nil,nil,"Dungeon (WoD)",35,60000.1,{59462,59487,59506,59525,59561,59606,59628,}},

--Dungeon Mail
{6000033,"Streamslither",nil,nil,"Dungeon (WoD)",68,60000.1,{61382,61402,59574,61362,61372,61332,61392,61342,}},
{6000032,"Sharpeye (Blue)",nil,nil,"Dungeon (WoD)",68,60000.1,{59623,59602,59577,59556,59521,59502,59482,59459,}},
{6000031,"Sharpeye (Red)",nil,nil,"Dungeon (WoD)",68,60000.1,{61384,61404,66773,61364,61374,61334,61394,61344,}},

--Dungeon Leather
{6000030,"Leafmender",nil,nil,"Dungeon (WoD)",3592,60000.1,{59455,59477,59497,59516,59552,59596,59617,59536,}},
{6000029,"Burning Focus",nil,nil,"Dungeon (WoD)",3592,60000.1,{61261,61265,61257,61255,61259,61251,61263,61253,}},
{6000028,"Bloodfeather",nil,nil,"Dungeon (WoD)",3592,60000.1,{61277,61281,61273,61270,61275,61267,61279,61269,}},

--Dungeon Cloth
{6000027,"Felflame",nil,nil,"Dungeon (WoD)",400,60000.1,{59465,59476,59496,59529,59571,59610,59616,59549,}},
{6000026,"Felflame",nil,nil,"Dungeon (WoD)",400,60000.1,{59465,59476,59496,59529,59571,59610,59616,59549,}},
{6000025,"Frost-Touched",nil,nil,"Dungeon (WoD)",400,60000.1,{59453,59473,59493,59513,59568,59593,59613,59533,}},

--Leveling Plate
{6000024,"Sharptusk",nil,nil,"Leveling (WoD)(Set 1)",35,60000,{57639,57640,57641,57642,57643,57644,57645,57647,}},
{6000023,"Ravenskar",nil,nil,"Leveling (WoD)(Set 1)",35,60000,{57672,57673,57674,57675,57676,57677,57678,57680,}},
{6000022,"Talon Guard",nil,nil,"Leveling (WoD)(Set 1)",35,60000,{57705,57706,57707,57708,57709,57710,57711,57713,}},

{6000021,"Gul'rok",nil,nil,"Leveling (WoD)(Set 2)",35,60000,{57573,57574,57575,57576,57577,57578,57579,57581,}},
{6000020,"Frostwolf Stalwart",nil,nil,"Leveling (WoD)(Set 2)",35,60000,{57245,57246,57247,57248,66009,57251,57253,57244,}},
{6000019,"Bladespire",nil,nil,"Leveling (WoD)(Set 2)",35,60000,{57441,57442,57443,57444,57445,57446,57447,57449,}},

--Leveling Mail
{6000018,"Frostwolf Ringmail",nil,nil,"Leveling (WoD)(Set 1)",68,60000,{57265,57266,57267,57268,57269,57271,57272,57276,}},
{6000017,"Warpscale",nil,nil,"Leveling (WoD)(Set 1)",68,60000,{57602,57598,57600,57601,57603,57604,57605,}},
{6000016,"Frostlink",nil,nil,"Leveling (WoD)(Set 1)",68,60000,{57466,57467,57468,57469,57470,57471,57472,57473,}},

{6000015,"Varashi",nil,nil,"Leveling (WoD)(Set 2)",68,60000,{57664,57665,57666,57667,57668,57669,57670,57671,}},
{6000014,"Ravenchain",nil,nil,"Leveling (WoD)(Set 2)",68,60000,{63595,63599,63604,63607,63611,63617,63620,63624,}},
{6000013,"Spirestrider",nil,nil,"Leveling (WoD)(Set 2)",68,60000,{57697,57698,57699,57700,57701,57702,57703,57704,}},

--Leveling Leather
{6000012,"Ripfang",nil,nil,"Leveling (WoD)(Set 1)",3592,60000,{57649,57650,57651,57652,57653,57654,57655,57648,}},
{6000011,"Breezestrider",nil,nil,"Leveling (WoD)(Set 1)",3592,60000,{57715,57716,57717,57718,57719,57720,57721,57714,}},
{6000010,"Shadeback",nil,nil,"Leveling (WoD)(Set 1)",3592,60000,{57682,57683,57684,57685,57686,57687,57688,57681,}},

{6000009,"Frostwolf Scout's",nil,nil,"Leveling (WoD)(Set 2)",3592,60000,{57234,57235,57236,57237,57239,57240,57241,57233,}},
{6000008,"Voidcaller",nil,nil,"Leveling (WoD)(Set 2)",3592,60000,{57483,57484,57485,57486,57487,57488,57489,57490,}},
{6000007,"Daggerjaw",nil,nil,"Leveling (WoD)(Set 2)",3592,60000,{57582,57583,57584,57585,57586,57587,57588,57589,}},

--Leveling Cloth
{6000006,"Frostwolf Wind-Talker",nil,nil,"Leveling (WoD)(Set 1)",400,60000,{58077,57256,57258,57260,57261,57262,57263,57264,}},
{6000005,"Lunarglow",nil,nil,"Leveling (WoD)(Set 1)",400,60000,{57458,57459,57460,57461,57462,57463,57464,57465,}},
{6000004,"Orunai",nil,nil,"Leveling (WoD)(Set 1)",400,60000,{57590,57591,57592,57593,57594,57595,57596,57597,}},

{6000003,"Ravendown",nil,nil,"Leveling (WoD)(Set 2)",400,60000,{57656,57657,57658,57659,57660,57661,57662,57663,}},
{6000002,"Windswept",nil,nil,"Leveling (WoD)(Set 2)",400,60000,{57722,57723,57724,57725,57726,57727,57728,57729,}},
{6000001,"Sunscryer",nil,nil,"Leveling (WoD)(Set 2)",400,60000,{57689,57690,57691,57692,57693,57694,57695,57696,}},
};

local altLabelDB = {
[4240]="Crafted (WoD)",
[4242]="Crafted (WoD)",
[4243]="Crafted (WoD)",
[4244]="Crafted (WoD)",
[2320]=app.GetLocalizedString("WoD_BlackrockTP"),--Fel Automaton (plate)
}

local altPatchID = {
[2320] = 60001.1,--Fel Automaton, Blackrock tp recolor
}

local altNoteDB = {
[2320]=app.GetTradingPostReleaseString("Mar",2023),--Fel Automaton (plate), TP release
}

local isRaidSet = {
[323]=true,
[324]=true,
[325]=true,
[327]=true,
[328]=true,
[329]=true,
[415]=true,
[416]=true,
[417]=true,
[418]=true,
[419]=true,
[420]=true,
[432]=true,
[433]=true,
[434]=true,
[435]=true,
[436]=true,
[437]=true,
[449]=true,
[450]=true,
[451]=true,
[452]=true,
[453]=true,
[454]=true,
[465]=true,
[466]=true,
[467]=true,
[468]=true,
[469]=true,
[470]=true,
[480]=true,
[481]=true,
[482]=true,
[483]=true,
[484]=true,
[485]=true,
[498]=true,
[500]=true,
[501]=true,
[502]=true,
[503]=true,
[505]=true,
[517]=true,
[518]=true,
[519]=true,
[520]=true,
[521]=true,
[522]=true,
[533]=true,
[534]=true,
[535]=true,
[536]=true,
[537]=true,
[538]=true,
[551]=true,
[552]=true,
[553]=true,
[554]=true,
[555]=true,
[556]=true,
[566]=true,
[567]=true,
[568]=true,
[569]=true,
[570]=true,
[571]=true,
[581]=true,
[582]=true,
[583]=true,
[584]=true,

}

--Used to add alternate appearances to blizzard sets
--SetID, OriginalSourceID, AlternateApperanceID
local altAppearancesDB = {
[4240] = {{249216,249224},},--Crafted(WoD), Cloth, Chest/Robe (Timewalking)
[4242] = {{249232,249233},},--Crafted(WoD), Leather, Chest/Robe (Timewalking)

[416]={{69911,69841},}, --Hellfire Citadel, Mail/Shaman, Chest/Robe (Heroic)
[415]={{69910,69839},}, --Hellfire Citadel, Mail/Shaman, Chest/Robe (Normal)
[82]={{70913,70864},}, --Warlords Season 2, Mail/Shaman, Chest/Robe (Gladiator)
[103]={{71824,71775},}, --Warlords Season 3, Mail/Shaman, Chest/Robe (Gladiator)
[417]={{69912,69842}, --Hellfire Citadel, Mail/Shaman, Chest/Robe (Mythic)
       {69909,69898},}, --Hellfire Citadel, Mail/Shaman, pants/skirt (Mythic)

[112]={{71411,71378},}, --Warlords Season 3, Leather/Monk, Chest/Robe (Gladiator)
[88]={{70500,70467},}, --Warlords Season 2, Leather/Monk, Chest/Robe (Gladiator)
[503]={{69711,69697},}, --Hellfire Citadel, Leather/Monk, Chest/Robe (Heroic)
[505]={{69712,69698},}, --Hellfire Citadel, Leather/Monk, Chest/Robe (Mythic)
[502]={{69710,69696},}, --Hellfire Citadel, Leather/Monk, Chest/Robe (Normal)

[106]={{71342,71373},}, --Warlords Season 3, Leather/Druid, Chest/Robe (Gladiator)
[84]={{70431,70462},}, --Warlords Season 2, Leather/Druid, Chest/Robe (Gladiator)
[552]={{69708,69705}, --Hellfire Citadel, Leather/Druid, Chest/Robe (Heroic)
       {69784,69780},}, --Hellfire Citadel, Leather/Druid, pants/skirt (Heroic)
[553]={{69709,69706}, --Hellfire Citadel, Leather/Druid, Chest/Robe (Mythic)
       {69783,69779},}, --Hellfire Citadel, Leather/Druid, pants/skirt (Mythic)
[551]={{69707,69703}, --Hellfire Citadel, Leather/Druid, Chest/Robe (Normal)
       {69782,69778},}, --Hellfire Citadel, Leather/Druid, pants/skirt (Normal)

[418]={{64467,62902},}, --Blackrock Foundry, Mail/Shaman, Chest/Robe (Normal)
[328]={{67283,62904},}, --Blackrock Foundry, Mail/Shaman, Chest/Robe (Heroic)
[420]={{67284,67278},}, --Blackrock Foundry, Mail/Shaman, Chest/Robe (Mythic)

[554]={{64430,62671},}, --Blackrock Foundry, Leather/Druid, Chest/Robe (Normal)
[555]={{67120,62673},}, --Blackrock Foundry, Leather/Druid, Chest/Robe (Heroic)
[556]={{67121,67117},}, --Blackrock Foundry, Leather/Druid, Chest/Robe (Mythic)

[126]={{64517,64620},}, --Warlords Season 1, Leather/Druid, Chest/Robe (Gladiator)
}

local function comp(a,b)
  if a[1] < b[1] then return true; else return false end
end
table.sort(db,comp);

--Legion alt appearances at 35559

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
app.altLabelDB[expansionID+1] = altLabelDB;
app.isRaidSet[expansionID+1] = isRaidSet;
app.altPatchID[expansionID+1] = altPatchID;
app.altNoteDB[expansionID+1] = altNoteDB;

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