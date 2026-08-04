local app = select(2,...);

local expansionID = 2;

--Name, Description, Label, classMask, patchID, sources, requiredFact
----classMask:    (35=Plate, 68=Mail, 3592=Leather, 400=Cloth)
local db = {
--Misc
{3000100,"Acherus Knight's",nil,nil,"Death Knight Starter Armor",32,30000,{16086,16087,16088,16089,16090,16091,16092,16093,}},
--Raid Plate
{3000099,"Saronite War",nil,nil,"General Raid (WotLK)",35,30005,{18508,18509,18737,18512,18513,18514,18515,18516,}},
{3000098,"Diminished Pride",nil,nil,"General Raid (WotLK)",35,30005,{19038,19058,19083,19245,19250,19555,19619,21276,}},
{3000097,"Unnatural Death",nil,nil,"General Raid (WotLK)",35,30005,{17685,19039,19059,19090,19272,19554,19617,}},
--Raid Mail
{3000096,"Colossal Strides",nil,nil,"General Raid (WotLK)",68,30005,{19057,19243,19274,19324,19364,19517,19620,}},
{3000095,"Lost Pack",nil,nil,"General Raid (WotLK)",68,30005,{17791,17937,18080,18744,18778,18839,17634,}},
{3000094,"Audient Earth",nil,nil,"General Raid (WotLK)",68,30005,{17903,17956,18020,18066,18762,18834,18846,21281,}},
{3000093,"Undisturbed",nil,nil,"General Raid (WotLK)",68,30005,{19051,19225,19239,19267,19313,19621,21701,}},
--Raid Leather
{3000092,"Silence",nil,nil,"General Raid (WotLK)",3592,30005,{19060,19084,19302,19321,19330,}},
{3000091,"Monstrosity",nil,nil,"General Raid (WotLK)",3592,30005,{17920,18023,18731,18738,18752,18763,19492,}},
{3000090,"Resumed Battle",nil,nil,"General Raid (WotLK)",3592,30005,{17653,18783,17921,18736,18831,18841,}},
{3000089,"Perished",nil,nil,"General Raid (WotLK)",3592,30005,{18712,19080,19091,19227,19270,19533,}},
--Raid Cloth
{3000088,"Spellweave",nil,nil,"General Raid (WotLK)",400,30005,{19053,19064,20380,19311,{20383,19383},19525,19528,19624,}},
{3000087,"Ebonweave",nil,nil,"General Raid (WotLK)",400,30005,{19052,20382,19224,20379,19279,19625,}},
{3000086,"Sheet Lightning",nil,nil,"General Raid (WotLK)",400,30005,{17690,17750,{17902,18848},17991,{18029,18771},18740,18779,22844,}},
{3000085,"Glistening Runes",nil,nil,"General Raid (WotLK)",400,30005,{17636,17792,{18065,18701},18079,18695,18838,18849,}},

--Ulduar Plate
{3000084,"Steelbreaker's",nil,nil,"Ulduar Raid",35,30100,{21647,21663,21681,21722,21749,21791,21931,22010,}},
{3000083,"Dragonsteel",nil,nil,"Ulduar Raid",35,30100,{21773,21798,22038,22108,22160,22170,22192,22194,}},
{3000082,"Tempered Will",nil,nil,"Ulduar Raid",35,30100,{21778,21792,22041,22050,22119,22123,22158,22184,}},
{3000081,"Clinging Hope",nil,nil,"Ulduar Raid",35,30100,{21669,21687,21723,21741,21899,21912,21950,}},
{3000080,"Dragonslayer's",nil,nil,"Ulduar Raid",35,30100,{21651,21668,21686,21725,21740,21752,21802,21948,}},
{3000079,"Stonewarder",nil,nil,"Ulduar Raid",35,30100,{21762,21770,21777,21782,21971,22049,22122,22193,}},
--Ulduar Mail
{3000078,"Insidious Intent",nil,nil,"Ulduar Raid",68,30100,{21649,21672,21684,21724,21735,21914,21923,21961,}},
{3000077,"Tempered Mercury",nil,nil,"Ulduar Raid",68,30100,{21774,22040,22112,22128,22164,22180,21775,}},
--Ulduar Leather
{3000076,"Death-Warmed",nil,nil,"Ulduar Raid",3592,30100,{21776,21784,21794,21982,22039,22110,22127,}},
{3000075,"Wavering Shadow",nil,nil,"Ulduar Raid",3592,30100,{21648,21670,21682,21736,21795,21913,21939,21960,}},
{3000074,"Flamewrought",nil,nil,"Ulduar Raid",3592,30100,{21675,21702,{21729,21957},21747,21902,21932,21940,21953,}},
{3000073,"Glowing Crescent",nil,nil,"Ulduar Raid",3592,30100,{21768,21845,21915,22044,22095,22157,22172,22199,}},
--Ulduar Cloth
{3000072,"Icy Breaths",nil,nil,"Ulduar Raid",400,30100,{21767,21779,21922,21993,22096,22111,22159,22175,}},
{3000071,"Soot-Covered",nil,nil,"Ulduar Raid",400,30100,{21653,21676,21703,21730,21745,21951,84532,}},
{3000070,"Luminescence",nil,nil,"Ulduar Raid",400,30100,{21655,21664,21732,21742,21757,21924,21944,}},
{3000069,"Inconceivable Horror",nil,nil,"Ulduar Raid",400,30100,{21766,21888,22047,22073,22118,22174,22189,22200,}},

--Trial of the Champion Plate
{3000068,"Stouthearted Crusader",nil,nil,"Trial of the Champion",35,30200,{20052,21431,21551,22610,22626,22799,22813,22848,}},
{3000067,"Solemn Council",nil,nil,"Trial of the Champion",35,30200,{20051,21385,21350,21355,21410,21445,22216,23965,}},
{3000066,"Brilliant Titansteel",nil,nil,"Trial of the Champion",35,30200,{20053,21325,21407,21542,22215,22627,23964,}},

--Trial of the Champion Mail
{3000065,"Dark Exile",nil,nil,"Trial of the Champion",68,30200,{20899,21327,21348,21372,21376,22845,21520,22638,}},
{3000064,"Grim Visions",nil,nil,"Trial of the Champion",68,30200,{22612,21349,21444,22217,22663,}},

--Trial of the Champion Leather
{3000063,"Argent Fanatic",nil,nil,"Trial of the Champion",3592,30200,{21322,21369,21377,21621,22222,22611,22661,22800,}},
{3000062,"Snowy Bramable",nil,nil,"Trial of the Champion",3592,30200,{21371,{22662,21381},21619,22207,22637,22802,22807,21420,}},

--Crafted Plate
--Crafted Mail
--Crafted Leather
{3000061,"Overcast",nil,nil,"Crafted (WotLK)",3592,30000.3,{20936,{20935,17699},20931,{20933,17882},20939,20938,20932,20934,}},
{3000060,"Eviscerator's",nil,nil,"Crafted (WotLK)",3592,30000.3,{20975,{20978,16571},20930,20979,20980,20977,20981,{20976,20910}}},
{3000059,"Gorestained",nil,nil,"Crafted (WotLK)",3592,30000.3,{17643,20898,84536,{16516,17897},20884,17755,20705,}},
--Crafted Cloth

--Dungeon Plate
{3000058,"Frozen Granite",nil,nil,"Dungeon (WotLK)",35,30000.2,{24374,24375,24377,24391,24403,24417,24424,24426,}},
{3000057,"Lost Reliquary",nil,nil,"Dungeon (WotLK)",35,30000.2,{24364,24371,24385,24393,24428,}},

--Dungeon Mail
{3000056,"Spirit Shock",nil,nil,"Dungeon (WotLK)",68,30000.2,{24367,24378,24624,24388,24400,24411,103143,103144,}},
{3000055,"Spurned Val'kyr",nil,nil,"Dungeon (WotLK)",68,30000.2,{24387,24394,24398,24405,24410,24634,24675,24681,}},

--Dungeon Leather
{3000054,"Black Betrayal",nil,nil,"Dungeon (WotLK)",3592,30000.2,{24671,24617,24649,24654,24678,24683,103139,103140,}},
{3000053,"Cheating Heart",nil,nil,"Dungeon (WotLK)",3592,30000.2,{24366,24404,24622,24689,}},
{3000052,"Blackened Geist",nil,nil,"Dungeon (WotLK)",3592,30000.2,{24365,24383,24392,24412,24415,}},

--Dungeon Cloth
{3000051,"Remorse",nil,nil,"Dungeon (WotLK)",400,30000.2,{24368,24609,24651,24676,24687,}},
{3000050,"Palebone",nil,nil,"Dungeon (WotLK)",400,30000.2,{24376,24396,24399,24408,}},
--{"Salt and Fire",nil,nil,"Dungeon (WotLK)",400,30000.2,{24423,24402,24648,24427,24382,}},

--Leveling Plate
{3000049,"Coldrock",nil,nil,"Leveling (WotLK)(Set 1)",35,30000,{17066,17064,17065,17067,17068,17069,17070,17071,}},
{3000048,"Baleheim",nil,nil,"Leveling (WotLK)(Set 1)",35,30000,{17077,17074,17073,17079,17072,17075,17076,17078,}},
{3000047,"Westguard",nil,nil,"Leveling (WotLK)(Set 1)",35,30000,{17060,17057,17056,17059,17062,17058,17061,17063,}},

{3000046,"Forlorn",nil,nil,"Leveling (WotLK)(Set 2)",35,30000,{16525,16529,16537,16563,17573,17951,18032,18704,}},
{3000045,"Ornamented",nil,nil,"Leveling (WotLK)(Set 2)",35,30000,{16579,16595,17645,17720,17763,17780,18474,18480,}},
{3000044,"Reanimated",nil,nil,"Leveling (WotLK)(Set 2)",35,30000,{17570,16538,16539,16543,16561,16567,17503,17904,}},
{3000043,"Bonegrinder",nil,nil,"Leveling (WotLK)(Set 2)",35,30000,{16548,16574,16576,17893,17580,17670,17906,18025,}},

{3000042,"Magnataur",nil,nil,"Leveling (WotLK)(Set 3)",35,30000,{17128,17129,17130,17131,17132,17133,17134,17135,}},
{3000041,"Frostpaw",nil,nil,"Leveling (WotLK)(Set 3)",35,30000,{17122,17120,17121,17123,17124,17125,17126,17127,}},
{3000040,"Kraken",nil,nil,"Leveling (WotLK)(Set 3)",35,30000,{17141,17142,17136,17137,17138,17139,17140,17143,}},
{3000039,"Golem",nil,nil,"Leveling (WotLK)(Set 3)",35,30000,{17149,17144,17145,17146,17147,17148,17150,17151,}},

--Leveling Mail
{3000038,"Njord",nil,nil,"Leveling (WotLK)(Set 1)",68,30000,{16953,16956,16954,16952,{16955,17797},16957,16958,16959,}},
{3000037,"Garmaul",nil,nil,"Leveling (WotLK)(Set 1)",68,30000,{16949,16944,16946,16950,16945,16947,16948,16951,}},
{3000036,"Nerubian",nil,nil,"Leveling (WotLK)(Set 1)",68,30000,{18411,18410,18409,18408,18420,18407,18412,18416,}},
{3000035,"Tundrastrider",nil,nil,"Leveling (WotLK)(Set 1)",68,30000,{16534,17486,17796,17805,18010,18182,19098,19131,}},

{3000034,"Swiftarrow",nil,nil,"Leveling (WotLK)(Set 2)",68,30000,{20984,20982,20983,20986,20987,20989,20985,20988,}},
{3000033,"Forgotten Captain",nil,nil,"Leveling (WotLK)(Set 2)",68,30000,{16517,16645,16673,17521,17527,17599,18179,19018,}},
{3000032,"Mammoth",nil,nil,"Leveling (WotLK)(Set 2)",68,30000,{17008,17009,17010,{17011,18875},17012,17013,17014,17015,}},
{3000031,"Beastsoul",nil,nil,"Leveling (WotLK)(Set 2)",68,30000,{37378,37384,37382,37380,37381,37379,37383,37385,}},
{3000030,"Magdun",nil,nil,"Leveling (WotLK)(Set 2)",68,30000,{16680,17583,17601,17673,17815,18013,18879,19158,}},

--Leveling Leather
{3000029,"Geist",nil,nil,"Leveling (WotLK)(Set 1)",3592,30000,{16941,16936,16937,16938,16939,16940,16942,16943,}},
{3000028,"Wolverine",nil,nil,"Leveling (WotLK)(Set 1)",3592,30000,{16896,16897,16898,16899,16901,16902,16903,}},
{3000027,"Pygmy",nil,nil,"Leveling (WotLK)(Set 1)",3592,30000,{16912,16913,16914,16915,16917,16918,16919,16916,}},
{3000026,"Wendigo",nil,nil,"Leveling (WotLK)(Set 1)",3592,30000,{16920,16921,{16922,18158},16923,16925,16926,16927,16924,}},

{3000025,"Assailant",nil,nil,"Leveling (WotLK)(Set 2)",3592,30000,{16518,16583,18702,18708,21452,}},
{3000024,"Cosmos",nil,nil,"Leveling (WotLK)(Set 2)",3592,30000,{{16594,17672},17995,17999,18001,18057,18486,}},
{3000023,"Dark Iceborne",nil,nil,"Leveling (WotLK)(Set 2)",3592,30000,{{21510,17595},17609,{21511,17684},17969,}},

{3000022,"Riplash",nil,nil,"Leveling (WotLK)(Set 3)",3592,30000,{16852,16850,16848,16849,16851,16853,16854,16855,}},
{3000021,"Daggercap",nil,nil,"Leveling (WotLK)(Set 3)",3592,30000,{16835,16833,16836,16837,16838,16834,16832,16839,}},
{3000020,"Wildevar",nil,nil,"Leveling (WotLK)(Set 3)",3592,30000,{16858,16856,16857,16859,16860,16861,16862,16863,}},
{3000019,"Vileprey",nil,nil,"Leveling (WotLK)(Set 3)",3592,30000,{16872,16873,16874,16875,16876,16877,16878,16879,}},
{3000018,"Taunka",nil,nil,"Leveling (WotLK)(Set 3)",3592,30000,{16880,16881,16882,16883,16884,16885,16886,16887,}},

{3000017,"Footman",nil,nil,"Leveling (WotLK)(Set 4)",3592,30000,{2241,26784,696,191,25929,}},
{3000016,"Sailor's",nil,nil,"Leveling (WotLK)(Set 4)",3592,30000,{961,25935,25934,25931,25894,25897,}},
{3000015,"Scavenger",nil,nil,"Leveling (WotLK)(Set 4)",3592,30000,{4275,644,1158,25882,26124,26128,}},
{3000014,"Dwarven",nil,nil,"Leveling (WotLK)(Set 4)",3592,30000,{25879,25876,36,2275,2274,}},

--Leveling Cloth
{3000013,"Oracle",nil,nil,"Leveling (WotLK)(Set 1)",400,30000,{16793,16792,{16794,20160},16795,16796,16797,16798,16799,}},
{3000012,"Scholar",nil,nil,"Leveling (WotLK)(Set 1)",400,30000,{17505,16598,17501,17758,17916,17930,17950,21178,}},
{3000011,"Dreadsoul",nil,nil,"Leveling (WotLK)(Set 1)",400,30000,{37214,21192,37215,37217,37219,37218,37216,37213,}},
{3000010,"Seraphic",nil,nil,"Leveling (WotLK)(Set 1)",400,30000,{37230,37232,37233,37228,37229,37231,37234,37235,}},
{3000009,"Vizier",nil,nil,"Leveling (WotLK)(Set 1)",400,30000,{16816,16817,16818,16819,16820,16821,16822,16823,}},

{3000008,"Farshire",nil,nil,"Leveling (WotLK)(Set 2)",400,30000,{16724,16723,{16722,16653},16725,16721,16720,16727,16726,}},
{3000007,"Frostwoven",nil,nil,"Leveling (WotLK)(Set 2)",400,30000,{{20059,16664},20062,20064,20061,17481,17513,21394,20057,}},
{3000006,"Bloodspore",nil,nil,"Leveling (WotLK)(Set 2)",400,30000,{{16733,17716},16734,16728,16729,{16730,18123},16731,16732,16735,}},
{3000005,"Sweltering",nil,nil,"Leveling (WotLK)(Set 2)",400,30000,{17676,17667,17675,{17678,17532},17680,17705,18095,20069,}},

--Wrath Pre-Patch
{3000004,"Undead Slaying",nil,nil,"Pre-Patch (WotLK)",35,29999,{20840,20841,20843,20842,}},
{3000003,"Undead Slaying",nil,nil,"Pre-Patch (WotLK)",68,29999,{12009,20852,20843,11958,}},
{3000002,"Undead Slaying",nil,nil,"Pre-Patch (WotLK)",3592,29999,{20849,20848,20843,20850,}},
{3000001,"Undead Cleansing",nil,nil,"Pre-Patch (WotLK)",400,29999,{12071,20844,20847,20845,}},
};

local function comp(a,b)
  if a[1] < b[1] then return true; else return false end
end
table.sort(db,comp);

local isRaidSet = {
[298]=true,
[346]=true,
[347]=true,
[348]=true,
[349]=true,
[350]=true,
[361]=true,
[362]=true,
[363]=true,
[364]=true,
[637]=true,
[638]=true,
[639]=true,
[640]=true,
[641]=true,
[642]=true,
[643]=true,
[644]=true,
[645]=true,
[655]=true,
[656]=true,
[657]=true,
[658]=true,
[659]=true,
[660]=true,
[661]=true,
[662]=true,
[671]=true,
[672]=true,
[673]=true,
[674]=true,
[675]=true,
[676]=true,
[677]=true,
[678]=true,
[679]=true,
[687]=true,
[688]=true,
[689]=true,
[690]=true,
[691]=true,
[692]=true,
[693]=true,
[694]=true,
[695]=true,
[703]=true,
[704]=true,
[705]=true,
[706]=true,
[707]=true,
[708]=true,
[709]=true,
[710]=true,
[711]=true,
[719]=true,
[720]=true,
[721]=true,
[722]=true,
[723]=true,
[724]=true,
[725]=true,
[726]=true,
[727]=true,
[735]=true,
[736]=true,
[737]=true,
[738]=true,
[739]=true,
[740]=true,
[741]=true,
[742]=true,
[743]=true,
[822]=true,
[823]=true,
[824]=true,
[825]=true,
[826]=true,
[827]=true,
[828]=true,
[829]=true,
[830]=true,
[838]=true,
[839]=true,
[840]=true,
[841]=true,
[842]=true,
[843]=true,
[844]=true,
[845]=true,
[846]=true,
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
[3000099] = true,
[3000098] = true,
[3000097] = true,
[3000096] = true,
[3000095] = true,
[3000094] = true,
[3000093] = true,
[3000092] = true,
[3000091] = true,
[3000090] = true,
[3000089] = true,
[3000088] = true,
[3000087] = true,
[3000086] = true,
[3000085] = true,
[3000084] = true,
[3000083] = true,
[3000082] = true,
[3000081] = true,
[3000080] = true,
[3000079] = true,
[3000078] = true,
[3000077] = true,
[3000076] = true,
[3000075] = true,
[3000074] = true,
[3000073] = true,
[3000072] = true,
[3000071] = true,
[3000070] = true,
[3000069] = true,
}

--Used to add alternate appearances to blizzard sets
--SetID, OriginalSourceID, AlternateApperanceID
local altAppearancesDB = {
[720]={{25034,24955},}, --25man Normal ICC Mage alt robe texture
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