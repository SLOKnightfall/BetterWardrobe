local app = select(2,...);

local expansionID = 8;

--Name, Note, Label, classMask, patchID, sources, requiredFact, noLongerObtainable
----classMask:    (35=Plate, 68=Mail, 3592=Leather, 400=Cloth)
local db = {
--69749

--Old Night fae mail beta set.
{9000081,"SL_ArdenCovMail","SL_WepSetName14","SL_ArdenCovMailDesc","SL_ArdenCovMail",68,89900,{112637,112635,112640,112634,112636,112639,112633,112638,112415,},nil,2},
{9000080,"SL_ArdenCovMail","SL_WepSetName15","SL_ArdenCovMailDesc","SL_ArdenCovMail",68,89900,{112619,112624,112618,112620,112623,112617,112622,112413,112612},nil,2},
{9000079,"SL_ArdenCovMail","SL_WepSetName16","SL_ArdenCovMailDesc","SL_ArdenCovMail",68,89900,{112612,112614,112609,112615,112613,112610,112616,112611,112404,},nil,2},
{9000078,"SL_ArdenCovMail","SL_WepSetName17","SL_ArdenCovMailDesc","SL_ArdenCovMail",68,89900,{112629,112627,112632,112626,112628,112631,112630,112414,112625,},nil,2},

--Zereth Mortis Sets (Plate) --57140
{9000077,"SL_SetName78",nil,nil,"SL_SetLabel5",35,90200,{168135,168139,168129,168141,168137,168131,168143,168133,168116}},
{9000076,"SL_SetName77",nil,nil,"SL_SetLabel5",35,90200,{168449,168454,168451,168456,168499,168455,168452,168450,168453}},
{9000075,"SL_SetName76",nil,nil,"SL_SetLabel5",35,90200,{165422,165427,165423,165428,165426,165424,165429,165425,165445,}},
{9000074,"SL_SetName75",nil,nil,"SL_SetLabel5",35,90200,{168444,168446,168441,168447,168445,168442,168448,168443,169129}},
----Zereth Mortis Sets (Mail) --57197
{9000073,"SL_SetName74",nil,nil,"SL_SetLabel5",68,90200,{168119,168123,168111,168125,168121,168113,168127,168117,168150,}},
{9000072,"SL_SetName77",nil,nil,"SL_SetLabel5",68,90200,{168486,168488,168483,168489,168487,168484,168490,168485,169132,}},
{9000071,"SL_SetName73",nil,nil,"SL_SetLabel5",68,90200,{165417,165419,165414,165420,165418,165415,165421,165416,}},
{9000070,"SL_SetName72",nil,nil,"SL_SetLabel5",68,90200,{168436,168438,168433,168439,168437,168434,168440,168435,168838,}},
----Zereth Mortis Sets (Leather) --56832
{9000069,"SL_SetName71",nil,nil,"SL_SetLabel5",3592,90200,{168101,168105,168095,168107,168103,168097,168109,168099,168149,}},
{9000068,"SL_SetName77",nil,nil,"SL_SetLabel5",3592,90200,{168469,168474,168473,168471,168470,168467,168472,168468,169131,}},
{9000067,"SL_SetName70",nil,nil,"SL_SetLabel5",3592,90200,{165410,165431,165430,165412,165411,165408,165413,165409,}},
{9000066,"SL_SetName69",nil,nil,"SL_SetLabel5",3592,90200,{168428,168430,168425,168431,168429,168426,168432,168427,169128,}},
----Zereth Mortis Sets (Cloth) --56674
{9000065,"SL_SetName68",nil,nil,"SL_SetLabel5",400,90200,{165404,165432,165401,165406,165405,165402,165407,165403,}},
{9000064,"SL_SetName67",nil,nil,"SL_SetLabel5",400,90200,{168085,168089,168079,168091,168087,168081,168093,168115,168083}},
{9000063,"SL_SetName77",nil,nil,"SL_SetLabel5",400,90200,{168811,168815,168808,168813,168812,168809,168814,168810,169130,}},
{9000062,"SL_SetName66",nil,nil,"SL_SetLabel5",400,90200,{168420,168422,168417,168423,168421,168418,168424,168419,169127}},

--9.1.5 New Starter (Non-Transmoggable) Sets (Plate)
{9000061,"SL_SetName65",nil,app.GetLocalizedString("SL_SetDesc0")..app.ClassNameMask[2]..app.GetLocalizedString("SL_SetDesc1"),app.GetLocalizedString("SL_SetLabel4"),35,90105,{165330,165334,165331,165335,165333,165332,},nil,true},
{9000060,"SL_SetName64",nil,app.GetLocalizedString("SL_SetDesc0")..app.ClassNameMask[1]..app.GetLocalizedString("SL_SetDesc1"),app.GetLocalizedString("SL_SetLabel4"),35,90105,{165341,165338,165337,165336,165340,165339,},nil,true},
--9.1.5 New Starter (Non-Transmoggable) Sets (Mail)
{9000059,"SL_SetName63",nil,app.GetLocalizedString("SL_SetDesc0")..app.ClassNameMask[64]..app.GetLocalizedString("SL_SetDesc1"),app.GetLocalizedString("SL_SetLabel4"),68,90105,{165324,165329,165325,165328,165327,165326,},nil,true},
{9000058,"SL_SetName62",nil,app.GetLocalizedString("SL_SetDesc0")..app.ClassNameMask[4]..app.GetLocalizedString("SL_SetDesc1"),app.GetLocalizedString("SL_SetLabel4"),68,90105,{165320,165321,165318,165319,165322,165323,},nil,true},
--9.1.5 New Starter (Non-Transmoggable) Sets (Leather)
{9000057,"SL_SetName61",nil,app.GetLocalizedString("SL_SetDesc0")..app.ClassNameMask[1024]..app.GetLocalizedString("SL_SetDesc1"),app.GetLocalizedString("SL_SetLabel4"),3592,90105,{165366,165365,165367,165369,165368,},nil,true},
{9000056,"SL_SetName60",nil,app.GetLocalizedString("SL_SetDesc0")..app.ClassNameMask[8]..app.GetLocalizedString("SL_SetDesc1"),app.GetLocalizedString("SL_SetLabel4"),3592,90105,{165363,165362,165360,165361,165364,},nil,true},
--9.1.5 New Starter (Non-Transmoggable) Sets (Cloth)
{9000055,"SL_SetName59",nil,app.GetLocalizedString("SL_SetDesc0")..app.ClassNameMask[256]..app.GetLocalizedString("SL_SetDesc1"),app.GetLocalizedString("SL_SetLabel4"),400,90105,{165342,165347,165343,165346,165345,165344,},nil,true},
{9000054,"SL_SetName58",nil,app.GetLocalizedString("SL_SetDesc0")..app.ClassNameMask[16]..app.GetLocalizedString("SL_SetDesc1"),app.GetLocalizedString("SL_SetLabel4"),400,90105,{165358,165357,165355,165356,165354,165359,},nil,true},
{9000053,"SL_SetName57",nil,app.GetLocalizedString("SL_SetDesc0")..app.ClassNameMask[128]..app.GetLocalizedString("SL_SetDesc1"),app.GetLocalizedString("SL_SetLabel4"),400,90105,{165352,165351,165349,165350,165348,165353,},nil,true},

----9.1.5 Mage Tower (Plate)(Paladin,DK,Warrior)
--{9000064,"SL_SetName56",nil,nil,"SL_SetLabel3",2,90105,{165869,165871,165865,165872,165870,165867,165873,165868,165866,}},
--{9000063,"SL_SetName55",nil,nil,"SL_SetLabel3",32,90105,{165827,165829,165823,165830,165828,165826,165943,165824,165825}},
--{9000062,"SL_SetName54",nil,nil,"SL_SetLabel3",1,90105,{165912,165914,165909,165915,165913,165910,165916,165911,165957}},
----9.1.5 Mage Tower (Mail)(Hunter,Shaman)
--{9000061,"SL_SetName53",nil,nil,"SL_SetLabel3",4,90105,{165843,165845,165839,165846,165844,165841,165847,165842,165840,}},
--{9000060,"SL_SetName52",nil,nil,"SL_SetLabel3",64,90105,{165897,165955,{165892,165893},165899,165898,165895,165900,165896,165894,}},
----9.1.5 Mage Tower (Leather)(Rogue,Druid,DH,Monk)
--{9000059,"SL_SetName51",nil,nil,"SL_SetLabel3",8,90105,{165887,165889,165883,165890,165888,165885,165891,165886,165884,}},
--{9000058,"SL_SetName50",nil,nil,"SL_SetLabel3",1024,90105,{165834,165836,{165831,165917},165837,165835,165832,165838,165833,165953}},
--{9000057,"SL_SetName49",nil,nil,"SL_SetLabel3",2048,90105,{165946,165948,165944,165950,165947,165951,165949,165945,165952,}},
--{9000056,"SL_SetName48",nil,nil,"SL_SetLabel3",512,90105,{165860,165862,165857,165863,165861,165858,165864,165859,165954,}},
----9.1.5 Mage Tower (Cloth)(Mage,Priest,Warlock)
--{9000055,"SL_SetName47",nil,nil,"SL_SetLabel3",128,90105,{165851,165854,{165853,165918},165855,165852,165849,165856,165850,165848}},
--{9000054,"SL_SetName46",nil,nil,"SL_SetLabel3",16,90105,{165877,165880,{165879,165919},165881,165878,165875,165882,165876,165874,}},
--{9000053,"SL_SetName45",nil,nil,"SL_SetLabel3",256,90105,{165903,165906,{165905,165920},165907,165904,165901,165908,165902,165956}},

--9.1 Dungeon Recolor
{9000052,"SL_SetName44",nil,nil,"SL_SetLabel2",35,90100,{116729,116734,116730,116735,116733,116731,116736,116732,116754,}},
{9000051,"SL_SetName43",nil,nil,"SL_SetLabel2",68,90100,{116724,116726,116721,116727,116725,116722,116728,116723,146644,}},
{9000050,"SL_SetName42",nil,nil,"SL_SetLabel2",3592,90100,{116717,116737,116719,116718,116715,116720,116716,146643,116738}},
{9000049,"SL_SetName41",nil,nil,"SL_SetLabel2",400,90100,{116711,116739,116708,116713,116712,116709,116714,116710,146097,}},

--Leveling Sets (Plate)
{9000048,"SL_SetName40",nil,nil,"SL_SetLabel1",35,90000,{109106,109090,109095,109119,109092,109111,109114,109100,}},
{9000047,"SL_SetName39",nil,nil,"SL_SetLabel1",35,90000,{109202,109186,109191,109215,109188,109207,109210,109196,116879}},
{9000046,"SL_SetName38",nil,nil,"SL_SetLabel1",35,90000,{115026,115027,115024,115030,115023,115028,115029,115025}},
{9000045,"SL_SetName37",nil,nil,"SL_SetLabel1",35,90000,{109074,109058,109127,109087,109060,109079,109082,109068,113014,}},
{9000044,"SL_SetName36",nil,nil,"SL_SetLabel1",35,90000,{107440,107423,107424,107429,107453,107426,107445,107448,107434,}},
--Leveling Sets (Mail)
{9000043,"SL_SetName35",nil,nil,"SL_SetLabel1",68,90000,{109204,109200,109193,109216,109189,109209,109212,109198,}},
{9000042,"SL_SetName34",nil,nil,"SL_SetLabel1",68,90000,{109108,109104,109097,109120,109093,109113,109116,109102,}},
{9000041,"SL_SetName33",nil,nil,"SL_SetLabel1",68,90000,{109076,109072,109129,109088,109061,109081,109084,109070,}},
{9000040,"SL_SetName32",nil,nil,"SL_SetLabel1",68,90000,{107442,107438,107431,107454,107427,107447,107450,107436,}},
{9000039,"SL_SetName31",nil,nil,"SL_SetLabel1",68,90000,{106657,106656,106654,106660,106653,106658,106659,106655,}},
--Leveling Sets (Leather)
{9000038,"SL_SetName30",nil,nil,"SL_SetLabel1",3592,90000,{109077,113012,115482,109089,109062,109078,109085,109067,114937}},
{9000037,"SL_SetName29",nil,nil,"SL_SetLabel1",3592,90000,{109105,109109,109098,109121,109094,109110,109117,109099,}},
{9000036,"SL_SetName28",nil,nil,"SL_SetLabel1",3592,90000,{109201,109205,109194,109217,109190,109206,109213,109195,146506}},
{9000035,"SL_SetName27",nil,nil,"SL_SetLabel1",3592,90000,{110283,110287,114242,110276,110272,110288,110295,110277,107455}},
{9000034,"SL_SetName26",nil,nil,"SL_SetLabel1",3592,90000,{106608,106609,106588,106612,106739,106610,106611,106607,}},
--Leveling Sets (Cloth)
{9000033,"SL_SetName25",nil,nil,"SL_SetLabel1",400,90000,{109107,109103,109349,109096,109118,109091,109112,109115,109101,}},
{9000032,"SL_SetName24",nil,nil,"SL_SetLabel1",400,90000,{109203,109199,109353,109296,109214,109187,109208,109211,109197,}},
{9000031,"SL_SetName23",nil,nil,"SL_SetLabel1",400,90000,{107362,107361,107358,107359,107365,107357,107363,107364,107360,}},
{9000030,"SL_SetName22",nil,nil,"SL_SetLabel1",400,90000,{109075,109071,109128,109086,{109059,112699},109080,109083,109069,110991}},
{9000029,"SL_SetName21",nil,nil,"SL_SetLabel1",400,90000,{107441,107437,107430,107452,107425,110290,107449,107435,114245}},

--Dungeon Sets (Plate)
{9000028,"SL_SetName20",nil,nil,"SL_SetLabel2",35,90000,{106010,106009,106007,106013,106006,106011,106012,106008,116661}},
{9000027,"SL_SetName19",nil,nil,"SL_SetLabel2",35,90000,{111522,111516,111536,111545,111518,111524,111542,111540,111548}},
{9000026,"SL_SetName18",nil,nil,"SL_SetLabel2",35,90000,{111464,111494,112878,112890,112876,111472,111460,112881,145595}},
{9000025,"SL_SetName17",nil,nil,"SL_SetLabel2",35,90000,{111508,111490,111491,111515,111501,111510,111586,111492,111218}},
{9000024,"SL_SetName16",nil,nil,"SL_SetLabel2",35,90000,{111449,111657,111670,111663,111448,111647,111450,116656,115854}},
--Dungeon Sets (Mail)
{9000023,"SL_SetName15",nil,nil,"SL_SetLabel2",68,90000,{106673,106672,106670,106676,106669,106674,106675,106671,111185}},
{9000022,"SL_SetName14",nil,nil,"SL_SetLabel2",68,90000,{111484,111507,111504,111488,111502,111486,106675,111506,111477}},
{9000021,"SL_SetName13",nil,nil,"SL_SetLabel2",68,90000,{111539,111520,111530,111546,111519,111525,111543,111541,115805}},
{9000020,"SL_SetName12",nil,nil,"SL_SetLabel2",68,90000,{111495,111463,111469,112891,112877,111459,112887,112882,112892}},
{9000019,"SL_SetName11",nil,nil,"SL_SetLabel2",68,90000,{111656,111662,111446,111669,111444,111445,111646,113597,146641}},
--Dungeon Sets (Leather)
{9000018,"SL_SetName10",nil,nil,"SL_SetLabel2",3592,90000,{111645,111579,111668,111582,111580,111661,111581,111655,}},
{9000017,"SL_SetName9",nil,nil,"SL_SetLabel2",3592,90000,{111523,111521,111537,111547,111535,111555,111527,111532,}},
{9000016,"SL_SetName8",nil,nil,"SL_SetLabel2",3592,90000,{106625,106624,106622,106628,106621,106626,106627,106623,}},
{9000015,"SL_SetName7",nil,nil,"SL_SetLabel2",3592,90000,{111509,111482,111505,111588,111503,111485,111513,111479,}},
{9000014,"SL_SetName6",nil,nil,"SL_SetLabel2",3592,90000,{112885,112883,111457,111466,111468,111496,112888,112880,}},
--Dungeon Sets (Cloth)
{9000013,"SL_SetName5",nil,nil,"SL_SetLabel2",400,90000,{107380,107379,107376,107377,107383,107375,107381,107382,107378,}},
{9000012,"SL_SetName4",nil,nil,"SL_SetLabel2",400,90000,{111538,111557,111531,111544,111517,111556,111526,111533,146642}},
{9000011,"SL_SetName3",nil,nil,"SL_SetLabel2",400,90000,{111667,111439,111643,111441,111654,111440,111660,111442,111666}},
{9000010,"SL_SetName2",nil,nil,"SL_SetLabel2",400,90000,{111483,111481,111478,111514,111500,111511,111512,111585,}},
{9000009,"SL_SetName1",nil,nil,"SL_SetLabel2",400,90000,{112875,113706,112879,111471,111458,112884,111465,112886,111498}},
--Pre-patch Plate
{9000008,"SL_SetName0",nil,nil,"SL_SetLabel0",35,89999,{114722,114839,114830,114824,114836,114833,114827,114842,114683,},"Horde"},
{9000007,"SL_SetName0",nil,nil,"SL_SetLabel0",35,89999,{114710,114773,114764,114758,114770,114767,114761,114776,114755,},"Alliance"},
--Pre-patch Mail
{9000006,"SL_SetName0",nil,nil,"SL_SetLabel0",68,89999,{114719,114818,114812,114806,114665,114815,114810,114821,114686,},"Horde"},
{9000005,"SL_SetName0",nil,nil,"SL_SetLabel0",68,89999,{114707,114749,114740,114737,114746,114743,114647,114752,114656,},"Alliance"},
--Pre-patch Leather
{9000004,"SL_SetName0",nil,nil,"SL_SetLabel0",3592,89999,{114716,114800,114794,114791,114668,114797,114677,114803,114689,},"Horde"},
{9000003,"SL_SetName0",nil,nil,"SL_SetLabel0",3592,89999,{114704,114731,114728,114725,114635,114641,114650,114734,114659,},"Alliance"},
--Pre-patch Cloth
{9000002,"SL_SetName0",nil,nil,"SL_SetLabel0",400,89999,{114713,114785,114674,114779,114671,114782,114662,114788,114680,},"Horde"},
{9000001,"SL_SetName0",nil,nil,"SL_SetLabel0",400,89999,{114629,114698,114644,114692,114638,114695,114632,114701,114653,},"Alliance"},
};

local function comp(a,b)
  if a[1] < b[1] then return true; else return false end
end
table.sort(db,comp);

local isRaidSet = {
[2150]=true,
[2151]=true,
[2152]=true,
[2153]=true,
[2154]=true,
[2155]=true,
[2156]=true,
[2157]=true,
[2158]=true,
[2159]=true,
[2160]=true,
[2161]=true,
[2162]=true,
[2163]=true,
[2164]=true,
[2165]=true,
[2250]=true,
[2251]=true,
[2252]=true,
[2253]=true,
[2254]=true,
[2255]=true,
[2256]=true,
[2257]=true,
[2258]=true,
[2259]=true,
[2260]=true,
[2261]=true,
[2262]=true,
[2263]=true,
[2264]=true,
[2265]=true,
[2348]=true,
[2349]=true,
[2350]=true,
[2351]=true,
[2354]=true,
[2355]=true,
[2356]=true,
[2357]=true,
[2360]=true,
[2361]=true,
[2362]=true,
[2363]=true,
[2366]=true,
[2367]=true,
[2368]=true,
[2369]=true,
[2372]=true,
[2373]=true,
[2374]=true,
[2375]=true,
[2378]=true,
[2379]=true,
[2380]=true,
[2381]=true,
[2384]=true,
[2385]=true,
[2386]=true,
[2387]=true,
[2390]=true,
[2391]=true,
[2392]=true,
[2393]=true,
[2396]=true,
[2397]=true,
[2398]=true,
[2399]=true,
[2402]=true,
[2403]=true,
[2404]=true,
[2405]=true,
[2408]=true,
[2409]=true,
[2410]=true,
[2411]=true,
[2414]=true,
[2415]=true,
[2416]=true,
[2417]=true,

}

--[setID] = "label"
--local altLabelDB = {
--  --mage tower
--  [2302] = app.GetLocalizedString("SL_SetLabel3"), --rogue
--  [2295] = app.GetLocalizedString("SL_SetLabel3"), --dh
--  [2296] = app.GetLocalizedString("SL_SetLabel3"), --druid
--  [2299] = app.GetLocalizedString("SL_SetLabel3"), --monk
--  [2301] = app.GetLocalizedString("SL_SetLabel3"), --priest
--  [2298] = app.GetLocalizedString("SL_SetLabel3"), --mage
--  [2304] = app.GetLocalizedString("SL_SetLabel3"), --warlock
--  [2303] = app.GetLocalizedString("SL_SetLabel3"), --shaman
--  [2297] = app.GetLocalizedString("SL_SetLabel3"), --hunter
--  [2305] = app.GetLocalizedString("SL_SetLabel3"), --warrior
--  [2294] = app.GetLocalizedString("SL_SetLabel3"), --dk
--  [2300] = app.GetLocalizedString("SL_SetLabel3"), --paladin
--}
--
--local altDescriptionDB = {
--  [2302] = app.GetLocalizedString("SL_SetName51"), --rogue
--  [2295] = app.GetLocalizedString("SL_SetName49"), --dh
--  [2296] = app.GetLocalizedString("SL_SetName50"), --druid
--  [2299] = app.GetLocalizedString("SL_SetName48"), --monk
--  [2301] = app.GetLocalizedString("SL_SetName46"), --priest
--  [2298] = app.GetLocalizedString("SL_SetName47"), --mage
--  [2304] = app.GetLocalizedString("SL_SetName45"), --warlock
--  [2303] = app.GetLocalizedString("SL_SetName52"), --shaman
--  [2297] = app.GetLocalizedString("SL_SetName53"), --hunter
--  [2305] = app.GetLocalizedString("SL_SetName54"), --warrior
--  [2294] = app.GetLocalizedString("SL_SetName55"), --dk
--  [2300] = app.GetLocalizedString("SL_SetName56"), --paladin
--}

--Used to add alternate appearances to blizzard sets
--SetID, OriginalSourceID, AlternateApperanceID
local altAppearancesDB = {
[2391]={{166170,167953},}, --Sepulcher of the First Ones, Priest, Chest/Robe (LFR)
[2390]={{166169,167952},}, --Sepulcher of the First Ones, Priest, Chest/Robe (Normal)
[2392]={{166171,167954},}, --Sepulcher of the First Ones, Priest, Chest/Robe (Heroic) --Heroic chest missing :(
[2393]={{166172,167955},}, --Sepulcher of the First Ones, Priest, Chest/Robe (Mythic)

--44268
[2209]={{115998,115990},}, --Kyrian, Devoted Aspirant's Chest/Robe
[2208]={{115999,115982},}, --Kyrian, Aspiring Aspirant's Chest/Robe
[2207]={{116000,115974},}, --Kyrian, Forsworn Aspirant's Chest/Robe
[2206]={{115966,116001},}, --Kyrian, Battlefield Aspirant's Chest/Robe

[2159]={{115105,115109},}, --Castle Nathria, Cloth, Depraved Beguiler's Chest/Robe (RF)
[2158]={{114499,114511},}, --Castle Nathria, Cloth, Depraved Beguiler's Chest/Robe (Normal)
[2160]={{115106,115110},}, --Castle Nathria, Cloth, Depraved Beguiler's Chest/Robe (Heroic)
[2161]={{115131,115133},}, --Castle Nathria, Cloth, Depraved Beguiler's Chest/Robe (Mythic)

[2058]={{113820,113839},}, --Night Fae, Mail, Winterborn Chest/Robe
[2057]={{113828,113837},}, --Night Fae, Mail, Night Courtier's Chest/Robe
[2056]={{113836,113840},}, --Night Fae, Mail, Conservator's Chest/Robe
[2055]={{113805,113841},}, --Night Fae, Mail, Runewarden's Chest/Robe

[2050]={{112438,112442},}, --Night Fae, Cloth, Winterborn Chest/Robe
[2048]={{112436,112440},}, --Night Fae, Cloth, Night Courtier's Chest/Robe
[2049]={{112437,112441},}, --Night Fae, Cloth, Conservator's Chest/Robe
[2047]={{109219,112439},}, --Night Fae, Cloth, Faewoven Chest/Robe

[2053]={{112575,112557},}, --Night Fae, Leather, Winterborn Chest/Robe
[2054]={{112574,112556},}, --Night Fae, Leather, Night Courtier's Chest/Robe
[2052]={{112573,112555},}, --Night Fae, Leather, Conservator's Chest/Robe
[2051]={{112554,112545},}, --Night Fae, Leather, Oakheart Chest/Robe

[2482]={{ 169680, 169689},--Fireplume legs
        { 169680, 169778},--Fireplume legs
        { 169680, 169779},--Fireplume legs
        { 169679, 169688},--Fireplume Chest
        { 169679, 169782},--Fireplume Chest
        { 169681, 169777},},--Fireplume Gloves
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
--app.altLabelDB[expansionID] = altLabelDB;
--app.altDescriptionDB[expansionID] = altDescriptionDB;
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