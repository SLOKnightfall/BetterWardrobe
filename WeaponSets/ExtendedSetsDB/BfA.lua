local app = select(2,...);

local expansionID = 7;

--Name, Description, Label, classMask, patchID, sources, requiredFact
----classMask:    (35=Plate, 68=Mail, 3592=Leather, 400=Cloth)

local db = {
{8000125,"BfA_Irontide",nil,nil,"BfA_PirateGarb",0,80000,{96241,96234,231341,96240},},
{8000124,"BfA_Cutwater",nil,nil,"BfA_PirateGarb",0,80000,{96232,96238,96239,96234},},

{8000123,"BfA_SinisterAspirant","BfA_HeroicAspirant",nil,"BfA_Season2Darkshore",35,80100,{101306,101304,101302,101294,101300,101298,101296,101528,101307},"Horde"},
{8000122,"BfA_SinisterAspirant","BfA_HeroicAspirant",nil,"BfA_Season2Darkshore",68,80100,{101526,101290,101288,101286,101284,101282,101280,101278,101291},"Horde"},
{8000121,"BfA_SinisterAspirant","BfA_HeroicAspirant",nil,"BfA_Season2Darkshore",3592,80100,{101532,101372,101364,101350,101348,101340,101328,101326,101318,},"Alliance"},
{8000120,"BfA_SinisterAspirant","BfA_HeroicAspirant",nil,"BfA_Season2Darkshore",68,80100,{101534,101362,101356,101338,101334,101324,101316,101345},"Alliance"},
{8000119,"BfA_SinisterAspirant","BfA_HeroicAspirant",nil,"BfA_Season2Darkshore",35,80100,{101358,101352,101342,101310,101330,101320,101535,101313,101367},"Alliance"},

--Island Plate
{8000106,"BfA_Razorfin",nil,nil,"BfA_IslandExpeditions",35,80001,{100463,100464,100465,100466,100467,100468,100469,100470,}},
{8000105,"TWW_WepSetName20",nil,nil,"BfA_IslandExpeditions",35,80001,{100559,100560,100561,100562,100563,100564,100565,100566,}},
{8000104,"BfA_RattlingBone",nil,nil,"BfA_IslandExpeditions",35,80001,{100551,100552,100553,100554,100555,100556,100557,100558,}},
{8000103,"BfA_Geocrag",nil,nil,"BfA_IslandExpeditions",35,80001,{100447,100448,100449,100450,100451,100452,100453,100454,}},

{8000102,"BfA_TwilightDragon",nil,"BfA_IslandExpWarr13","BfA_IslandExpeditions",35,80001,{100436,100438,100437,100433,100431,100432,100434,100435,}},
{8000101,"BfA_TombKeeper",nil,"BfA_IslandExpWarr15","BfA_IslandExpeditions",35,80001,{100489,100494,100493,100490,100487,100488,100491,100492,}},

--Island Mail
{8000100,"BfA_Dragonriders",nil,nil,"BfA_IslandExpeditions",68,80001,{100423,100424,100425,100426,100427,100428,100429,100430,}},
{8000099,"BfA_Mrrglurggl",nil,nil,"BfA_IslandExpeditions",68,80001,{100495,100496,100497,100498,100499,100500,100501,100502,}},
{8000096,"BfA_VoodooStalker",nil,nil,"BfA_IslandExpeditions",68,80001,{100550,100548,100545,100544,100543,100546,100547,100549,}},

{8000095,"BfA_WildMarauder",nil,"BfA_IslandExpHunt14","BfA_IslandExpeditions",68,80001,{100573,100572,100571,100569,100574,100570,100568,100567,}},
{8000094,"BfA_Headshrinkers",nil,"BfA_IslandExpSham13","BfA_IslandExpeditions",68,80001,{100519,100520,100522,100521,100523,100524,100526,100525,}},
{8000093,"BfA_SaurokScale",nil,"BfA_IslandExpHunt15","BfA_IslandExpeditions",68,80001,{100528,100530,100534,100529,100531,100532,100533,100527,}},

--Island Leather
{8000098,"BfA_Firekin",nil,nil,"BfA_IslandExpeditions",3592,80001,{100583,100584,100585,100586,100587,100588,100589,100590,}},
{8000097,"BfA_FallenRunelord",nil,nil,"BfA_IslandExpeditions",3592,80001,{103118,103119,103120,103121,103122,103123,103124,103125,}},
--4442{8000094,"Miststalker's",nil,nil,"Island Expedition",3592,80001,{100591,100592,100593,100594,100595,100596,100597,100598,}},
{8000092,"Spiritbough",nil,nil,"BfA_IslandExpeditions",3592,80001,{100471,100472,100473,100474,100475,100476,100477,100478,}},
{8000091,"BfA_WhirlingDervish",nil,nil,"BfA_IslandExpeditions",3592,80001,{100575,100576,100577,100578,100579,100580,100581,100582,}},

{8000118,"BfA_TranquilPath",nil,"BfA_IslandExpMonk14","BfA_IslandExpeditions",3592,80001,{100458,100461,100457,100459,100460,100455,100456,100462,}},
{8000117,"BfA_Feralbark",nil,"BfA_IslandExpDrui14","BfA_IslandExpeditions",3592,80001,{100421,100420,100417,100419,100418,100415,100416,100422,}},

--Island Cloth
{8000116,"BfA_DuskhavenSuit",nil,nil,"BfA_IslandExpeditions",400,80001,{103136,103137,103138,103147,}},
{8000115,"BfA_DuskhavenDress",nil,nil,"BfA_IslandExpeditions",400,80001,{103135,103136,103147,}},
{8000114,"BfA_Swarmfury",nil,nil,"BfA_IslandExpeditions",400,80001,{100479,100480,100481,100482,100483,100484,100485,100486,}},
{8000113,"BfA_Hydraxian",nil,nil,"BfA_IslandExpeditions",400,80001,{100439,100440,100441,100442,100443,100444,100445,100446,}},
{8000112,"BfA_Frostwind",nil,nil,"BfA_IslandExpeditions",400,80001,{100535,100536,100537,100538,100539,100540,100541,100542,}},
{8000111,"BfA_DarkAnimator",nil,nil,"BfA_IslandExpeditions",400,80001,{103126,103127,103128,103129,103130,103131,103132,103133,}},
{8000110,"BfA_Mindwrack",nil,nil,"BfA_IslandExpeditions",400,80001,{93159,93160,93161,93163,93165,93162,}},
{8000109,"BfA_SpiderAcolyte",nil,nil,"BfA_IslandExpeditions",400,80001,{100504,100505,100506,100507,100508,100509,100510,100511,}},
{8000108,"BfA_Deeptide",nil,nil,"BfA_IslandExpeditions",400,80001,{105104,105105,105106,105107,105108,105109,105110,105131,}},

{8000107,"BfA_FacelessFollower",nil,"BfA_IslandExpWarl13","BfA_IslandExpeditions",400,80001,{100517,100518,100516,100513,100512,100514,100515,100511,}},

--Darkshore Alliance
--1775{8000106,"Wardenguard's",nil,nil,"Darkshore Warfront",35,80101,{101672,101670,103098,101668,101675,101667,101673,101674,101669,},"Alliance"},
--5285{8000105,"Wardenguard's",nil,nil,"Darkshore Warfront",35,80101,{103005,103007,103106,103002,103009,103004,103008,103006,103003,},"Alliance"},

--1782{8000104,"Kaldorei Archer's",nil,nil,"Darkshore Warfront",68,80101,{101663,101662,103096,101660,101659,101664,101665,101661,101666},"Alliance"},
--5284{8000103,"Kaldorei Archer's",nil,nil,"Darkshore Warfront",68,80101,{102997,102999,103097,102994,102996,103000,102998,102995,},"Alliance"},

--1789{8000102,"Darkwood Sentinel's",nil,nil,"Darkshore Warfront",3592,80101,{101655,101654,103094,101652,101658,101651,101656,101657,101653,},"Alliance"},
--5283{8000101,"Darkwood Sentinel's",nil,nil,"Darkshore Warfront",3592,80101,{102989,102991,103095,102986,102993,102988,102992,102990,102987,},"Alliance"},

--1796{8000100,"Moonpriest's",nil,nil,"Darkshore Warfront",400,80101,{101644,101645,101646,101647,101648,101649,101650,{101671,102794},},"Alliance"},
--5282{8000099,"Moonpriest's",nil,nil,"Darkshore Warfront",400,80101,{102980,102982,{102985,103078},102984,102979,102983,102981,102978,103093},"Alliance"},

--Darkshore Horde
--1745{8000098,"Deathguard's",nil,nil,"Darkshore Warfront",35,80101,{101699,101700,101701,101702,101704,101705,101706,101707,},"Horde"},
--5290{8000097,"Deathguard's",nil,nil,"Darkshore Warfront",35,80101,{102973,102975,102970,102977,102972,102976,102974,102971,},"Horde"},

--1752{8000096,"Blightguard's",nil,nil,"Darkshore Warfront",68,80101,{101695,101694,103101,101692,101698,101691,101696,101697,101693,},"Horde"},
--5289{8000095,"Blightguard's",nil,nil,"Darkshore Warfront",68,80101,{102965,102967,103102,102962,102969,102964,102968,102966,102963,},"Horde"},

--1759{8000094,"Deathstalker's",nil,nil,"Darkshore Warfront",3592,80101,{101687,101686,101684,101690,101683,101688,101689,101685,103100},"Horde"},
--5288{8000093,"Deathstalker's",nil,nil,"Darkshore Warfront",3592,80101,{102957,102959,102954,102961,102956,102960,102958,102955,},"Horde"},

--5287{8000092,"Plaguebringer's",nil,nil,"Darkshore Warfront",400,80101,{101676,101677,101678,101679,101680,101681,101682,101703,103099},"Horde"},
--1766{8000091,"Plaguebringer's",nil,nil,"Darkshore Warfront",400,80101,{102948,102950,102953,102952,102947,102951,102949,102946,},"Horde"},

--Arathi Alliance
{8000090,"BfA_7thLegionnaire",nil,nil,"BfA_ArathiWarfront",35,80001,{99140,99142,99145,99146,99149,99152,99155,99156,99088,},"Alliance"},
{8000089,"BfA_7thLegionnaire",nil,nil,"BfA_ArathiWarfront",35,80001,{100720,100716,100712,100724,100714,100722,100728,100718,100726,},"Alliance"},
{8000088,"BfA_7thLegionnaire",nil,nil,"BfA_ArathiWarfront",35,80001,{100721,100717,100713,100725,100715,100723,100729,100719,100727,},"Alliance"},

{8000087,"BfA_7thLegionnaire",nil,nil,"BfA_ArathiWarfront",68,80001,{99020,99032,99129,99133,99135,99136,99137,99138,99084,},"Alliance"},
{8000086,"BfA_7thLegionnaire",nil,nil,"BfA_ArathiWarfront",68,80001,{100738,100736,100734,100742,100732,100740,100746,100730,100744},"Alliance"},
{8000085,"BfA_7thLegionnaire",nil,nil,"BfA_ArathiWarfront",68,80001,{100739,100737,100735,100743,100733,100741,100747,100731,100745},"Alliance"},

{8000084,"BfA_7thLegionnaire",nil,nil,"BfA_ArathiWarfront",3592,80001,{99006,99119,99011,99021,99033,99113,99121,99080,99108,},"Alliance"},
{8000083,"BfA_7thLegionnaire",nil,nil,"BfA_ArathiWarfront",3592,80001,{100706,100704,100702,100694,100700,100696,100710,100698,100708,},"Alliance"},
{8000082,"BfA_7thLegionnaire",nil,nil,"BfA_ArathiWarfront",3592,80001,{100707,100705,100703,100695,100701,100697,100711,100699,100709,},"Alliance"},

{8000081,"BfA_7thLegionnaire",nil,nil,"BfA_ArathiWarfront",400,80001,{99003,99008,99019,99030,99068,99071,99073,99075,99001,},"Alliance"},
{8000080,"BfA_7thLegionnaire",nil,nil,"BfA_ArathiWarfront",400,80001,{100688,100686,100676,100678,100684,100690,100692,100682,100680,},"Alliance"},
{8000079,"BfA_7thLegionnaire",nil,nil,"BfA_ArathiWarfront",400,80001,{100689,100687,100677,100679,100685,100691,100693,100683,100681,},"Alliance"},

--Arathi Horde
{8000078,"BfA_HonorboundCenturion",nil,nil,"BfA_ArathiWarfront",35,80001,{99062,99187,99189,99190,99192,99193,99194,99195,99103,},"Horde"},
{8000077,"BfA_HonorboundCenturion",nil,nil,"BfA_ArathiWarfront",35,80001,{99332,99326,99320,99338,99318,99336,99342,99330,99340,},"Horde"},
{8000076,"BfA_HonorboundCenturion",nil,nil,"BfA_ArathiWarfront",35,80001,{99333,99327,99321,99339,99319,99337,99343,99331,99341,},"Horde"},

{8000075,"BfA_HonorboundVanguard",nil,nil,"BfA_ArathiWarfront",68,80001,{99180,99037,99063,99175,99179,99182,99183,99185,99101,},"Horde"},
{8000074,"BfA_HonorboundVanguard",nil,nil,"BfA_ArathiWarfront",68,80001,{100668,100664,100662,100658,100660,100670,100674,100666,100672},"Horde"},
{8000073,"BfA_HonorboundVanguard",nil,nil,"BfA_ArathiWarfront",68,80001,{100669,100665,100663,100659,100661,100671,100675,100667,100673},"Horde"},

{8000072,"BfA_HonorboundOutrider",nil,nil,"BfA_ArathiWarfront",3592,80001,{99053,{99038,99274},99064,99166,99169,99171,99172,99173,99095,},"Horde"},
{8000071,"BfA_HonorboundOutrider",nil,nil,"BfA_ArathiWarfront",3592,80001,{100650,100648,100646,{100640,99274},100644,100652,100656,100642,100654,},"Horde"},
{8000070,"BfA_HonorboundOutrider",nil,nil,"BfA_ArathiWarfront",3592,80001,{100651,100649,100647,{100641,99274},100645,100653,100657,100643,100655,},"Horde"},

{8000069,"BfA_HonorboundArtificer",nil,nil,"BfA_ArathiWarfront",400,80001,{99160,99158,99092,99035,99061,99162,99164,99051,99040,},"Horde"},
{8000068,"BfA_HonorboundArtificer",nil,nil,"BfA_ArathiWarfront",400,80001,{100637,100636,100635,100631,100634,100638,100639,100633,100632,},"Horde"},
{8000067,"BfA_HonorboundArtificer",nil,nil,"BfA_ArathiWarfront",400,80001,{100626,100624,100622,100614,100620,100628,100630,100618,100616,},"Horde"},


--Nazjatar
{8000066,"BfA_ZanjirScaleguard",nil,nil,"BfA_Nazjatar",35,80200,{104130,104128,105152,104126,104133,104125,104131,104132,104127,}},
{8000065,"BfA_Wavecrash",nil,nil,"BfA_Nazjatar",35,80200,{105132,105130,105137,105128,105135,105127,105133,105134,105129,}},
{8000064,"BfA_Reefwalker",nil,nil,"BfA_Nazjatar",68,80200,{105123,105122,105136,105120,105126,105119,105124,105125,105121,}},
{8000063,"BfA_AzshariStormsurger",nil,nil,"BfA_Nazjatar",68,80200,{104121,104120,105153,104118,104124,104117,104122,104123,104119,}},
{8000062,"BfA_Fathomstalker",nil,nil,"BfA_Nazjatar",3592,80200,{104113,104112,105151,104110,104116,104109,104114,104115,104111,}},
{8000061,"BfA_Slithershell",nil,nil,"BfA_Nazjatar",3592,80200,{105115,105114,105138,105112,105118,105111,105116,105117,105113,}},
{8000060,"BfA_Shirakess",nil,nil,"BfA_Nazjatar",400,80200,{104105,104104,105150,104102,104108,104129,104106,104107,104103,}},
{8000059,"BfA_Deeptide",nil,nil,"BfA_Nazjatar",400,80200,{105107,105106,105139,105104,105110,105131,105108,105109,105105,}},

--Brawler's
{8000058,"BfA_Brawlers",nil,nil,"BfA_BrawlersGuild",0,80150,{104146,104147,104148,104149,104150,104151,104152,104153,},"Horde"},
{8000057,"BfA_Brawlers",nil,nil,"BfA_BrawlersGuild",0,80150,{104142,104141,104139,104145,104137,104143,104144,104140,},"Alliance"},

--Kul Tiran Dungeon Plate
{8000056,"BfA_MaritimeGuard",nil,nil,"BfA_KulTirasDungeon",35,80000.5,{92529,94316,94372,95046,95197,95215,95217,95218,95268,}},
{8000055,"BfA_Harpooner",nil,nil,"BfA_KulTirasDungeon",35,80000.5,{95656,95704,97052,95666,95659,95673,95660,95669,95671,}},
{8000054,"BfA_PetrifiedWickerplate",nil,nil,"BfA_KulTirasDungeon",35,80000.5,{95655,95703,97051,95198,94317,95672,94373,95216,95670,}},
{8000053,"BfA_ProudmooreMarine",nil,nil,"BfA_KulTirasDungeon",35,80000.5,{97599,105016,104841,97625,97642,97566,97622,97683,}},
--Zandalar Dungeon Plate
{8000052,"BfA_EmbellishedRitual",nil,nil,"BfA_ZandDungeon",35,80000.5,{95621,95639,98376,95645,95628,95619,95630,95626,95617,}},
{8000051,"BfA_EverlastingGuardian",nil,nil,"BfA_ZandDungeon",35,80000.5,{95620,95638,98375,95222,94371,95618,95202,94321,95616,}},
{8000050,"BfA_PutridPath",nil,nil,"BfA_ZandDungeon",35,80000.5,{92511,92514,92516,94320,94370,95040,95201,95208,95221,}},
{8000049,"BfA_GrandFleet",nil,nil,"BfA_ZandDungeon",35,80000.5,{96502,97533,97551,97554,97557,97572,},nil,nil,nil,true},

--Kul Tiran Dungeon Mail
{8000048,"BfA_Cannoneer",nil,nil,"BfA_KulTirasDungeon",68,80000.5,{95132,92531,94364,95128,95124,95178,95123,92536,}},
{8000047,"BfA_WitchHunter",nil,nil,"BfA_KulTirasDungeon",68,80000.5,{95878,95874,95875,95876,95835,95886,95845,96219}},
{8000046,"BfA_FlintLinked",nil,nil,"BfA_KulTirasDungeon",68,80000.5,{95877,95873,95125,95129,95834,95885,95871,94365}},
{8000045,"BfA_Seacallers",nil,nil,"BfA_KulTirasDungeon",68,80000.5,{104970,105022,97514,104830,97621,97638,97618,}},
--Zandalar Dungeon Mail
{8000044,"BfA_GlitteringGold",nil,nil,"BfA_ZandDungeon",68,80000.5,{98398,98421,94309,94313,98384,98388,98377,94311}},
{8000043,"BfA_EternalService",nil,nil,"BfA_ZandDungeon",68,80000.5,{92518,95131,94310,94312,94308,95133,94348,95130,}},
{8000042,"BfA_SanguineFervor",nil,nil,"BfA_ZandDungeon",68,80000.5,{98416,98405,98381,98383,98385,98407,98387,98382}},
{8000041,"BfA_AkundasGrounding",nil,nil,"BfA_ZandDungeon",68,80000.5,{101551,97507,97516,97512,97521,97594,},nil,nil,nil,true},

--Kul Tiran Dungeon Leather
{8000040,"BfA_Irontide",nil,nil,"BfA_KulTirasDungeon",3592,80000.5,{92512,92528,92532,95050,95052,95065,95100,95103,95083,}},
{8000039,"BfA_AzeriteArsenal",nil,nil,"BfA_KulTirasDungeon",3592,80000.5,{98439,95589,99295,98478,98453,98467,98474,98449,95576,}},
{8000038,"BfA_SeaDog",nil,nil,"BfA_KulTirasDungeon",3592,80000.5,{98438,95053,99294,98477,95066,98466,95101,98448,95575,}},
{8000037,"BfA_Mekgineer",nil,nil,"BfA_KulTirasDungeon",3592,80000.5,{104847,104967,104957,105028,105018,105027,105021,}},
--Zandalar Dungeon Leather
{8000036,"BfA_SandShinedSnakeskin",nil,nil,"BfA_ZandDungeon",3592,80000.5,{92519,94377,95092,94358,92510,94302,94306,95061,}},
{8000035,"BfA_BloodElder",nil,nil,"BfA_ZandDungeon",3592,80000.5,{95586,95579,95574,95584,95597,95580,95578,95609,}},
{8000034,"BfA_SlitheringLoa",nil,nil,"BfA_ZandDungeon",3592,80000.5,{95585,94303,95573,94359,95596,94307,95577,95608,}},
{8000033,"BfA_Swampstalker",nil,nil,"BfA_ZandDungeon",3592,80000.5,{96501,97471,97474,97482,97496,},nil,nil,nil,true},

--Kul Tiran Dungeon Cloth
{8000032,"BfA_UndyingDevotion",nil,nil,"BfA_KulTirasDungeon",400,80000.5,{94298,92530,94354,94961,{95014,94296},94975,95008,92535,}},
{8000031,"BfA_VoidTouchedWaters",nil,nil,"BfA_KulTirasDungeon",400,80000.5,{95741,95756,{95778,95744},95752,95743,95713,95745,95750,}},
{8000030,"BfA_DrownedLord",nil,nil,"BfA_KulTirasDungeon",400,80000.5,{95740,95755,{95015,94297},95751,95742,95712,94299,94355,}},
{8000029,"BfA_MaritimeSpellweaver",nil,nil,"BfA_KulTirasDungeon",400,80000.5,{104852,104964,97608,97611,105009,97462,97628,}},
--Zandalar Dungeon Cloth
{8000028,"BfA_RebornSerpent",nil,nil,"BfA_ZandDungeon",400,80000.5,{94352,94322,94300,94349,94350,94966,94960,94965,}},
{8000027,"BfA_Sandswept",nil,nil,"BfA_ZandDungeon",400,80000.5,{95543,95553,95546,95545,95551,95549,95547,95541,}},
{8000026,"BfA_EverlivingFealty",nil,nil,"BfA_ZandDungeon",400,80000.5,{95542,95552,94351,95544,95550,95548,94353,94301,}},
{8000025,"BfA_SwampMedic",nil,nil,"BfA_ZandDungeon",400,80000.5,{97420,97432,97435,97444,97581,96509,},nil,nil,nil,true},

--Leveling Plate
{8000024,"BfA_DreadCorsair",nil,nil,"BfA_KulTirasLeveling",35,80000,{92068,92064,92056,91533,91354,91458,92077,92061,}},
{8000023,"BfA_Corlain",nil,nil,"BfA_KulTirasLeveling",35,80000,{91805,91994,91807,91808,91809,91810,91989,91812,}},
{8000022,"BfA_SeaRaider",nil,nil,"BfA_KulTirasLeveling",35,80000,{91919,91922,91927,91930,91934,91940,91943,91948,}},
{8000021,"BfA_ExiledVeteran",nil,nil,"BfA_ZandLeveling",35,80000,{92254,92257,92262,92265,92269,92275,92278,92283,}},
{8000020,"BfA_MonelHardened",nil,nil,"BfA_ZandLeveling",35,80000,{91858,91859,91860,91861,91862,91863,91864,91865,}},
{8000019,"BfA_Torgashell",nil,nil,"BfA_ZandLeveling",35,80000,{91772,91773,91774,91775,91776,91777,91778,91779,}},
--Leveling Mail
{8000018,"BfA_CroneSeeker",nil,nil,"BfA_KulTirasLeveling",68,80000,{92012,92016,91996,91991,91999,92003,92009,91987,}},
{8000017,"BfA_Outrigger",nil,nil,"BfA_KulTirasLeveling",68,80000,{91920,91924,91929,91932,91936,91942,91945,91949,}},
{8000016,"BfA_Stormchaser",nil,nil,"BfA_KulTirasLeveling",68,80000,{92054,92058,92063,92066,92070,92076,92079,92083,}},
{8000015,"BfA_Zalamar",nil,nil,"BfA_ZandLeveling",68,80000,{91794,91793,91792,91790,91796,91795,91789,91791,}},
{8000014,"BfA_Resilient",nil,nil,"BfA_ZandLeveling",68,80000,{92255,92259,92264,92267,92271,92277,92280,92284,}},
{8000013,"BfA_Torcalin",nil,nil,"BfA_ZandLeveling",68,80000,{92121,92125,92130,92133,92137,92143,92146,92150,}},
--Leveling Leather
{8000012,"BfA_Banisher",nil,nil,"BfA_KulTirasLeveling",3592,80000,{92017,91992,92004,91993,91818,91819,91820,92013,}},
{8000011,"BfA_Darkwater",nil,nil,"BfA_KulTirasLeveling",3592,80000,{92055,92059,92060,92067,92071,92073,92080,92084,}},
{8000010,"BfA_Freebooter",nil,nil,"BfA_KulTirasLeveling",3592,80000,{91921,91925,91926,91933,91937,91939,91946,91950,}},
{8000009,"BfA_Festerroot",nil,nil,"BfA_ZandLeveling",3592,80000,{91783,91785,91782,91781,91786,91787,91788,91784,}},
{8000008,"BfA_ScorchingSands",nil,nil,"BfA_ZandLeveling",3592,80000,{92256,92260,92261,92268,92272,92274,92281,92285,}},
{8000007,"BfA_Jambani",nil,nil,"BfA_ZandLeveling",3592,80000,{98189,98190,98191,98192,98193,98194,98195,98196,}},
--Leveling Cloth
{8000006,"DF_WepSetName13",nil,nil,"BfA_KulTirasLeveling",400,80000,{91935,91931,91923,91947,91938,91941,91944,91928,}},
{8000005,"BfA_Tidespeaker",nil,nil,"BfA_KulTirasLeveling",400,80000,{92057,92062,92065,92069,92072,92075,92078,92081,}},
{8000004,"BfA_Wickerwoven",nil,nil,"BfA_KulTirasLeveling",400,80000,{92011,91998,91995,92002,92005,91990,92014,92008,}},
{8000003,"BfA_Zanchuli",nil,nil,"BfA_ZandLeveling",400,80000,{92136,92132,92124,92148,92139,92142,92145,92129,}},
{8000002,"BfA_LoaSpeaker",nil,nil,"BfA_ZandLeveling",400,80000,{91848,91849,91850,91851,91852,91853,91854,91855,}},
{8000001,"BfA_Lastwind",nil,nil,"BfA_ZandLeveling",400,80000,{92258,92263,92266,92270,92273,92276,92279,92282,}},
};
local function comp(a,b)
  if a[1] < b[1] then return true; else return false end
end
table.sort(db,comp);

local altLabelDB = {
[1903] = app.GetLocalizedString("BfA_Blizzcon2019"), --wendigo woolies
}

local altNoteDB = {
[1637]= {app.GetFormattedLabel("i:162598:4:"..app.GetLocalizedString("Ensemble")..app.GetLocalizedString("BfA_VestmentTidesageNote"))},
[4553] = app.GetLocalizedString("BfA_TW"),--Smuggler's Attire (Red)
[4552] = app.GetLocalizedString("BfA_TW"),--Smuggler's Attire (Black)
[4559] = app.GetLocalizedString("BfA_TW"),--Zuldazar Civilian, Golden Fleet
[4560] = app.GetLocalizedString("BfA_TW"),--Zuldazar Civilian, Zocalo Merchant
}

local addedAppearance = {
[1637] = {291942},--Vestments of the Tidesages, Cloth, Cloak
}

local replaceAppearance = {
[1737] = {{99455,105489},},--Leather, S1, Elite, Alliance, gloves
}

local holidayDB = {
  [1903] = {1,12}, -- wendigo woolies
}

local isRaidSet = {
[1638]=true,
[1639]=true,
[1640]=true,
[1641]=true,
[1642]=true,
[1643]=true,
[1644]=true,
[1645]=true,
[1646]=true,
[1647]=true,
[1648]=true,
[1649]=true,
[1650]=true,
[1651]=true,
[1652]=true,
[1653]=true,
[1806]=true,
[1807]=true,
[1808]=true,
[1809]=true,
[1810]=true,
[1811]=true,
[1812]=true,
[1813]=true,
[1814]=true,
[1815]=true,
[1816]=true,
[1817]=true,
[1818]=true,
[1819]=true,
[1820]=true,
[1821]=true,
[1830]=true,
[1831]=true,
[1832]=true,
[1833]=true,
[1834]=true,
[1835]=true,
[1836]=true,
[1837]=true,
[1838]=true,
[1839]=true,
[1840]=true,
[1841]=true,
[1842]=true,
[1843]=true,
[1844]=true,
[1845]=true,
[1982]=true,
[1983]=true,
[1984]=true,
[1985]=true,
[1986]=true,
[1987]=true,
[1988]=true,
[1989]=true,
[1990]=true,
[1991]=true,
[1992]=true,
[1993]=true,
[1994]=true,
[1995]=true,
[1996]=true,
[1997]=true,

}

--Used to add alternate appearances to blizzard sets
--SetID, OriginalSourceID, AlternateApperanceID
local altAppearancesDB = {
[1817]={{101866,101613},  --BoD, Mail, Mythic, Pants
        {101886,101637},},--BoD, Mail, Mythic, boots

[4559]={{292116,292117},--Zuldazar Civilian, Golden Fleet, chest
        {292119,292120},},--Zuldazar Civilian, Golden Fleet, pants/skirt
[4560]={{292128,292127},--Zuldazar Civilian, Zocalo Merchant, chest
        {292131,292130},},--Zuldazar Civilian, Zocalo Merchant, pants/skirt

[4553]={{292124,292123},--Smuggler's Attire (Red) trenchcoat
        {292122,292125},},--Smuggler's Attire (Red) pants
[4552]={{291949,291948},--Smuggler's Attire (Black) trenchcoat
        {291947,291950},--Smuggler's Attire (Black) pants
        {291951,292004},},--Smuggler's Attire (Black) waist

[1956]={{106811,106901},}, --Season 4 BfA, Mail, Corrupted Gladiator's Chain Chest/Robe (Elite)(ally)
[1973]={{106773,106901},}, --Season 4 BfA, Mail, Corrupted Gladiator's Chain Chest/Robe (Elite)(horde)
[1957]={{106772,107212},}, --Season 4 BfA, Mail, Corrupted Gladiator's Chain Chest/Robe
[1986]={{108189,108177},}, --Ny'alotha, Mail, Chest/Robe (Normal)
[1988]={{108191,108179},}, --Ny'alotha, Mail, Chest/Robe (Heroic)
[1987]={{108190,107475},}, --Ny'alotha, Mail, Chest/Robe (LFR)
[1989]={{108192,108180},}, --Ny'alotha, Mail, Chest/Robe (Mythic)

[1835]={{104432,104444},}, --Eternal Palace, Mail, Chest/Robe (Heroic)
[1843]={{104431,104443},}, --Eternal Palace, Mail, Chest/Robe (LFR)
[1831]={{104430,104442},}, --Eternal Palace, Mail, Chest/Robe (Normal)
[1839]={{104433,104445},}, --Eternal Palace, Mail, Chest/Robe (Mythic)

[1814]={{101880,102238},}, --BoD, Mail, Chest/Robe (Normal)
[1816]={{101882,102240},}, --BoD, Mail, Chest/Robe (Heroic)
[1815]={{101881,102239},}, --BoD, Mail, Chest/Robe (LFR)
[1817]={{101883,102241},}, --BoD, Mail, Chest/Robe (Mythic)

[1813]={{102237,102249},}, --BoD, Leather, Chest/Robe (Mythic)
[1812]={{102236,102248},}, --BoD, Leather, Chest/Robe (Heroic)
[1811]={{102235,102247},}, --BoD, Leather, Chest/Robe (LFR)
[1810]={{102234,102246},}, --BoD, Leather, Chest/Robe (Normal)

[1767]={{101251,101252},--Season 2,Cloth,Helm (Aspirant)(Horde)
        {101249,101250},--Season 2,Cloth,Glove (Aspirant)(Horde)
        {101255,101256},--Season 2,Cloth,Shoulder (Aspirant)(Horde)
        {101259,101260},},--Season 2,Cloth,Waist (Aspirant)(Horde)

[1760]={{101267,101268},--Season 2,Leather,Helm (Aspirant)(Horde)
        {101265,101266},--Season 2,Leather,Glove (Aspirant)(Horde)
        {101271,101272},--Season 2,Leather,Shoulder (Aspirant)(Horde)
        {101273,101274},},--Season 2,Leather,Waist (Aspirant)(Horde)

[1797]={{101353,101354},--Season 2,Cloth,Shoulder (Aspirant)(Alliance)
        {101335,101336},--Season 2,Cloth,Helm (Aspirant)(Alliance)
        {101311,101312},},--Season 2,Cloth,Robe (Aspirant)(Alliance)

[1796]={{101671,102794},}, --Season 2 BfA, Cloth, Chest/Robe (Warfront)(Alliance)
[5282]={{102985,103078},}, --Season 2 BfA, Cloth, Chest/Robe (Warfront, Heroic)(Alliance)
[1671]={{100640,99274},}, --Season 1 BfA, Leather, Chest/Robe (Warfront)(Horde)
[1670]={{98771,188558},}, --Season 1 BfA, Leather, Chest/Robe (Aspirant)(Horde)

[1804]={{102667,102661},}, --Blood Elf Heritage Armor, Chest/Robe
[1977]={{107808,108030},}, --Goblin Heritage Armor, Goggles Up/Down
[1976]={{107820,107821},}, --Worgen Heritage Armor, Chest/Robe
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
app.altLabelDB[expansionID+1] = altLabelDB;
app.altNoteDB[expansionID+1] = altNoteDB;
app.addedAppearance[expansionID+1] = addedAppearance;
app.isRaidSet[expansionID+1] = isRaidSet;
app.holidayDB[expansionID+1] = holidayDB;
app.replaceAppearance[expansionID+1] = replaceAppearance;


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