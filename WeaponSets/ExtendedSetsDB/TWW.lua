local app = select(2,...);

local expansionID = 10;
--start of nerubian raid -- 91493
--earthen cosmetic 92566

--Name, Note, Label, classMask, patchID, sources, requiredFact, noLongerObtainable
----classMask:    (35=Plate, 68=Mail, 3592=Leather, 400=Cloth)
local db = {
{11000102,"TWW_ArathiKnight",nil,"SirenIsle","TWW_ArathiGuard",0,110007,{231374,{231371,231366}},nil,nil,nil,true},
{11000101,"TWW_ArathiChampion",nil,"SirenIsle","TWW_ArathiGuard",0,110007,{231373,{231370,231367}},nil,nil,nil,true},
{11000100,"TWW_ArathiFootman",nil,"SirenIsle","TWW_ArathiGuard",0,110007,{231372,{231369,231368}},nil,nil,nil,true},

{11000099,"TWW_SkymastersBlood",nil,nil,"TWW_RacingCup",0,119999.2,{302760,302759,{302758,302762},302761},nil,nil,nil,true},

{11000098,"TWW_SweatsMidnight",nil,nil,"TWW_Sorcerers",0,110207,{301308,301326},nil,2,nil,true,1},
{11000097,"TWW_WepSetDesc8",nil,nil,"TWW_Sorcerers",0,110207,   {301309,301327},nil,2,nil,true,1},--Azure
{11000096,"TWW_SweatsSepia",nil,"e:TrialOfStyle","TWW_Sorcerers",0,110207,   {301310,301328},nil,nil,nil,true,nil},
{11000095,"TWW_SweatsGrassy",nil,nil,"TWW_Sorcerers",0,110207,  {301311,301329},nil,2,nil,true,1},
{11000094,"TWW_SweatsCloudy",nil,nil,"TWW_Sorcerers",0,110207,  {301312,301330},nil,2,nil,true,1},
{11000093,"TWW_SweatsDeep",nil,nil,"TWW_Sorcerers",0,110207,    {301313,301331},nil,2,nil,true,1},
{11000092,"TWW_SweatsCamo",nil,nil,"TWW_Sorcerers",0,110207,    {301314,301332},nil,2,nil,true,1},
{11000091,"TWW_SweatsBrick",nil,app.GetTradingPostReleaseString("Jan",2026),"TWW_Sorcerers",0,110207,   {301315,301333},nil,nil,nil,true,1},
{11000090,"TWW_SweatsLively",nil,app.GetTradingPostReleaseString("Apr",2026),"TWW_Sorcerers",0,120002,  {301316,301334},nil,nil,nil,true,1},
{11000089,"TWW_SweatsFaded",nil,app.GetTradingPostReleaseString("May",2026),"TWW_Sorcerers",0,120005.1,   {301317,301335},nil,nil,nil,true,1},
{11000088,"TWW_SweatsCarrot",nil,nil,"TWW_Sorcerers",0,110207,  {301318,301336},nil,2,nil,true,1},
{11000087,"TWW_SweatsRosy",nil,app.GetTradingPostReleaseString("Feb",2026),"TWW_Sorcerers",0,110207,    {301319,301337},nil,nil,nil,true,1},
{11000086,"TWW_SweatsPlum",nil,nil,"TWW_Sorcerers",0,110207,    {301320,301338},nil,2,nil,true,1},
{11000085,"TWW_WepSetDesc9",nil,nil,"TWW_Sorcerers",0,110207,   {301321,301339},nil,2,nil,true,1},--crimson
{11000084,"TWW_WepSetDesc12",nil,app.GetTradingPostReleaseString("Mar",2026),"TWW_Sorcerers",0,110207,  {301322,301340},nil,nil,nil,true,1},--violet
{11000083,"TWW_SweatsAquatic",nil,nil,"TWW_Sorcerers",0,110207, {301323,301341},nil,2,nil,true,1},
{11000082,"TWW_SweatsSnowy",nil,nil,"TWW_Sorcerers",0,110207,   {301324,301342},nil,2,nil,true,1},
{11000081,"TWW_SweatsSunny",nil,nil,"TWW_Sorcerers",0,110207,   {301325,301343},nil,2,nil,true,1},


{11000080,"TWW_FeatheredGuardian",nil,app.GetTradingPostReleaseString("Oct",2023)..app.GetLocalizedString("TWW_FeatheredGuardianNoMantle"),"LabelWingsAndWisdom",0,110105,{168316,168332,287882},nil,nil,nil,true,1},

{11000079,"TWW_RadiantRecruit",nil,nil,"TWW_WepSetName44",0,110107,{230872,230881},nil,nil,nil,true},
{11000078,"TWW_RadiantStalwart",nil,nil,"TWW_WepSetName44",0,110107,{230873,230882},nil,nil,nil,true},
{11000077,"TWW_SacredTemplar",nil,nil,"TWW_WepSetName44",0,110107,{230874,230883},nil,nil,nil,true},

--Brewer's mini-set 3-piece
{11000044,"TWW_BrewerBasic",nil,nil,"TWW_Brewer",0,110200,{289586,289582,289543,296326},nil,nil,nil,true,nil,10},
{11000046,"TWW_BrewerBlack",nil,nil,"TWW_Brewer",0,110200,{289587,289583,289575,296328},nil,nil,nil,true,nil,10},
{11000045,"TWW_BrewerGreen",nil,nil,"TWW_Brewer",0,110200,{289589,289585,289581,296327},nil,nil,nil,true,nil,10},
{11000043,"TWW_BrewerBlue",nil,nil,"TWW_Brewer",0,110200,{289588,289584,289580,296325},nil,nil,nil,true,nil,10},

--Sweat Pants/Hoodie 2-piece sets
{11000064,"TWW_SweatsMidnight",nil,app.GetTradingPostReleaseString("Aug",2025),"TWW_Sweats",0,110106,{290269,290228},nil,nil,nil,true,1},
{11000063,"TWW_WepSetDesc8",nil,nil,"TWW_Sweats",0,110106,{290252,290229},nil,2,nil,true,1},
{11000062,"TWW_SweatsSepia",nil,"e:TrialOfStyle","TWW_Sweats",0,110106,{290253,290230},nil,nil,nil,true,nil},
{11000061,"TWW_SweatsGrassy",nil,nil,"TWW_Sweats",0,110106,{290254,290231},nil,2,nil,true,1},
{11000060,"TWW_SweatsCloudy",nil,nil,"TWW_Sweats",0,110106,{290255,290232},nil,2,nil,true,1},
{11000059,"TWW_SweatsDeep",nil,nil,"TWW_Sweats",0,110106,{290256,290233},nil,2,nil,true,1},
{11000058,"TWW_SweatsCamo",nil,app.GetTradingPostReleaseString("Apr",2026),"TWW_Sweats",0,120002,{290257,290234},nil,nil,nil,true,1},
{11000057,"TWW_SweatsBrick",nil,nil,"TWW_Sweats",0,110106,{290258,290235},nil,2,nil,true,1},
{11000056,"TWW_SweatsLively",nil,nil,"TWW_Sweats",0,110106,{290259,290236},nil,2,nil,true,1},
{11000055,"TWW_SweatsFaded",nil,nil,"TWW_Sweats",0,110106,{290260,290237},nil,2,nil,true,1},
{11000054,"TWW_SweatsCarrot",nil,nil,"TWW_Sweats",0,110106,{290261,290238},nil,2,nil,true,1},
{11000053,"TWW_SweatsRosy",nil,app.GetTradingPostReleaseString("Feb",2026),"TWW_Sweats",0,110106,{290262,290239},nil,nil,nil,true,1},
{11000052,"TWW_SweatsPlum",nil,nil,"TWW_Sweats",0,110106,{290263,290240},nil,2,nil,true,1},
{11000051,"DF_WepSetName24",nil,app.GetTradingPostReleaseString("Jan",2026),"TWW_Sweats",0,110106,{290264,290241},nil,nil,nil,true,1},
{11000050,"TWW_WepSetDesc12",nil,app.GetTwitchDropReleaseString("Nov",2025),"TWW_Sweats",0,110106,{290265,290242},nil,nil,nil,true,2},
{11000049,"TWW_SweatsAquatic",nil,nil,"TWW_Sweats",0,110106,{290266,290243},nil,2,nil,true,1},
{11000048,"TWW_SweatsSnowy",nil,app.GetTradingPostReleaseString("Aug",2025),"TWW_Sweats",0,110106,{290267,290244},nil,nil,nil,true,1},
{11000047,"TWW_SweatsSunny",nil,nil,"TWW_Sweats",0,110106,{290245,290268},nil,2,nil,true,1},

--Siren Isle set
--4454{11000046,"TWW_SetName34",nil,nil,"SirenIsle",35,110007,{231312,231314,231288,231309,231313,231310,231315,231311,231654,}},
--4449{11000045,"TWW_SetName33",nil,nil,"SirenIsle",68,110007,{231334,231336,231292,231331,231335,231332,231337,231333,231653,}},
--4440{11000044,"TWW_SetName32",nil,nil,"SirenIsle",3592,110007,{99956,231328,231291,231324,231329,231325,231330,231326,231652,}},
--4432{11000043,"TWW_SetName31",nil,nil,"SirenIsle",400,110007,{231321,{231319,231323},{231289,231290,231655},231316,{231320,231650},231317,231322,231318,}},

--Cruise
{11000042,"TWW_SetName30",nil,nil,"TWW_SetLabel9",0,110007,{231391,{231299,231300},{231389,231390},231388,}},
{11000041,"TWW_SetName29",nil,nil,"TWW_SetLabel9",0,110007,{231395,{231301,24223},{231393,231394},231392,}},
{11000040,"TWW_SetName28",nil,nil,"TWW_SetLabel9",0,110007,{231398,{231302,231303},231397,231396,}},
{11000039,"TWW_SetName27",nil,nil,"TWW_SetLabel9",0,110007,{231426,231260,231307,231403,231402,}},

--Siren Isle Pirate Garb
{11000038,"TWW_SetName26",nil,nil,"TWW_SetLabel8",0,110007,{96243,{96271,231356,231386},{231295,231296},231338,231339,231413,}},
{11000037,"TWW_SetName25",nil,nil,"TWW_SetLabel8",0,110007,{231298,{96273,231358,231384},231348,96235,{231342,231387},231347,231412,}},
{11000036,"TWW_SetName24",nil,nil,"TWW_SetLabel8",0,110007,{231297,{96274,231357,231385},231349,231345,{231343,231350},231346,231414,}},

{11000035,"TWW_SetName23",nil,nil,"TWW_SetLabel7",0,110007,{231304,231400,231401,231399,231424,231308}},

--Dorn Defender (plate)
{11000034,"TWW_SetName22",nil,"SirenIsle","TWW_SetLabel6",35,110007,{225040,225042,225037,225043,225041,225038,225044,225039,225036,}},
{11000033,"TWW_SetName21",nil,"li:228741","TWW_SetLabel6",35,110000,{225074,225079,225075,225080,225078,225076,225081,225077,}},
{11000032,"TWW_SetName20",nil,nil,"TWW_SetLabel6",35,110000,{220537,220539,220534,220540,220538,220535,220541,220536,}},
--Algari (mail)
{11000031,"TWW_SetName19",nil,"SirenIsle","TWW_SetLabel5",68,110007,{225031,225033,225028,225034,225032,225029,225035,225030,225027,}},
{11000030,"TWW_SetName18",nil,"li:228741","TWW_SetLabel5",68,110000,{225069,225071,225066,225072,225070,225067,225073,225068,}},
{11000029,"TWW_SetName17",nil,nil,"TWW_SetLabel5",68,110000,{220529,220531,220526,220532,220530,220527,220533,220528,220509,}},
--Coreway Regalia (leather)
{11000028,"TWW_SetName16",nil,"SirenIsle","TWW_SetLabel4",3592,110007,{225045,225024,225020,225025,225023,225021,225026,225022,225019,}},
{11000027,"TWW_SetName15",nil,"li:228741","TWW_SetLabel4",3592,110000,{225060,225065,225064,225062,225061,225058,225063,225059,}},
{11000026,"TWW_SetName14",nil,nil,"TWW_SetLabel4",3592,110000,{220521,220523,220518,220524,220522,220519,220525,220520,220508,}},
--Threads of Awakening (cloth)
{11000025,"TWW_SetName13",nil,"SirenIsle","TWW_SetLabel3",400,110007,{225014,225016,225011,225017,225015,225012,225018,225013,225010,}},
{11000024,"TWW_SetName12",nil,"li:228741","TWW_SetLabel3",400,110000,{225050,225056,225054,225049,225055,225052,225051,225053,225057,}},
{11000023,"TWW_SetName11",nil,nil,"TWW_SetLabel3",400,110000,{220513,220515,220510,220516,220514,220511,220517,220512,}},

--Underground Gear (Delver's
{11000022,"TWW_SetName10",nil,nil,"TWW_SetLabel2",35,110005,{222898,222900,222895,222901,222899,222896,222902,222897,222878,}},
{11000021,"TWW_SetName9",nil,nil,"TWW_SetLabel2",35,110000,{198892,198894,198889,198895,198893,198890,198896,198891,}},
{11000020,"TWW_SetName8",nil,nil,"TWW_SetLabel2",35,110000,{218521,218523,218518,218524,218522,218519,218525,218520,}},

{11000019,"TWW_SetName10",nil,nil,"TWW_SetLabel2",68,110005,{222906,222908,222903,222909,222907,222904,222910,222905,}},
{11000018,"TWW_SetName9",nil,nil,"TWW_SetLabel2",68,110000,{198883,198884,198882,198885,198886,198881,198888,198887,}},
{11000017,"TWW_SetName7",nil,nil,"TWW_SetLabel2",68,110000,{218513,218515,218510,218516,218514,218511,218517,218512,}},

{11000016,"TWW_SetName10",nil,nil,"TWW_SetLabel2",3592,110005,{222914,222916,222911,222917,222915,222912,222918,222913,}},
{11000015,"TWW_SetName6",nil,nil,"TWW_SetLabel2",3592,110000,{218505,218507,218502,218508,218506,218503,218509,218504,}},
{11000014,"TWW_SetName9",nil,nil,"TWW_SetLabel2",3592,110000,{198875,198876,198874,198877,198878,198873,198880,198879,}},

{11000013,"TWW_SetName10",nil,nil,"TWW_SetLabel2",400,110005,{222922,222924,222919,222925,222923,222920,222926,222921,222877,}},
--{"Dark Agent's",nil,"Underground Gear",400,110000,{219168,219177,{219160,219286},219180,219172,219195,219183,219166,219187,}},
{11000012,"TWW_SetName5",nil,nil,"TWW_SetLabel2",400,110000,{218497,218499,{220464,218494},218500,218498,218495,218501,218496,220491,}},
{11000011,"TWW_SetName9",nil,nil,"TWW_SetLabel2",400,110000,{198868,198865,{198870,219628},198871,198864,198866,198867,198869,198872,}},

--hallowfall crafted dark/red
{11000010,"TWW_SetName4",nil,"TWW_SetDesc6","TWW_SetLabel1",400,110000,{219609,219612,219610,219607,219611,219599,219602,219598,}},
{11000009,"TWW_SetName3",nil,"TWW_SetDesc6","TWW_SetLabel1",35,110000,{219526,219529,219523,219524,219527,219522,219528,219530}},
{11000008,"TWW_SetName2",nil,"TWW_SetDesc6","TWW_SetLabel1",68,110000,{218276,218277,218275,218278,218279,218274,218281,218280}},
{11000007,"TWW_SetName1",nil,"TWW_SetDesc6","TWW_SetLabel1",3592,110000,{219329,218269,218267,218270,218271,218266,218273,218272,218268}},

--earthen attire
--protector
{11000006,"TWW_SetDesc5","TWW_WepSetDesc11","q:81887",app.GetLocalizedString("TWW_SetLabel0").." ("..app.GetLocalizedString("TWW_SetDesc5")..")",0,110000,{220301,220306,220302,220304,220307,{220305,249115},220303},nil,nil,{[3]=true,[34]=true,[84]=true,[85]=true}},
{11000076,"TWW_SetDesc5","TWW_WepSetDesc10","q:84730",app.GetLocalizedString("TWW_SetLabel0").." ("..app.GetLocalizedString("TWW_SetDesc5")..")",0,110007,{249084,{249087,249085},249086,249089,249088,249090,249091},nil,nil,{[3]=true,[34]=true,[84]=true,[85]=true}},
{11000075,"TWW_SetDesc5","TWW_WepSetDesc23","q:86496",app.GetLocalizedString("TWW_SetLabel0").." ("..app.GetLocalizedString("TWW_SetDesc5")..")",0,110007,{249060,{249056,249053},249031,249059,249057,249058,249055},nil,nil,{[3]=true,[34]=true,[84]=true,[85]=true}},
--stoneward
{11000005,"TWW_SetDesc4","TWW_WepSetDesc11","q:81887",app.GetLocalizedString("TWW_SetLabel0").." ("..app.GetLocalizedString("TWW_SetDesc4")..")",0,110000,{220298,220295,220297,220300,{220299,249116},220296},nil,nil,{[3]=true,[34]=true,[84]=true,[85]=true}},
{11000074,"TWW_SetDesc4","TWW_WepSetDesc10","q:84730",app.GetLocalizedString("TWW_SetLabel0").." ("..app.GetLocalizedString("TWW_SetDesc4")..")",0,110007,{249083,{249081,249078},249082,249080,249111,249079},nil,nil,{[3]=true,[34]=true,[84]=true,[85]=true}},
{11000073,"TWW_SetDesc4","TWW_WepSetDesc23","q:86496",app.GetLocalizedString("TWW_SetLabel0").." ("..app.GetLocalizedString("TWW_SetDesc4")..")",0,110007,{249065,249066,249063,{249064,249061},249035,249062},nil,nil,{[3]=true,[34]=true,[84]=true,[85]=true}},
--adventurer
{11000004,"TWW_SetDesc3","TWW_WepSetDesc11","q:81887",app.GetLocalizedString("TWW_SetLabel0").." ("..app.GetLocalizedString("TWW_SetDesc3")..")",0,110000,{220289,220292,220291,220294,{220290,249113},220293},nil,nil,{[3]=true,[34]=true,[84]=true,[85]=true}},
{11000072,"TWW_SetDesc3","TWW_WepSetDesc10","q:84730",app.GetLocalizedString("TWW_SetLabel0").." ("..app.GetLocalizedString("TWW_SetDesc3")..")",0,110007,{249110,{249112,249106},249109,249107,249108,249105},nil,nil,{[3]=true,[34]=true,[84]=true,[85]=true}},
{11000071,"TWW_SetDesc3","TWW_WepSetDesc23","q:86496",app.GetLocalizedString("TWW_SetLabel0").." ("..app.GetLocalizedString("TWW_SetDesc3")..")",0,110007,{249034,{249048,249047},249049,249050,249052,249051},nil,nil,{[3]=true,[34]=true,[84]=true,[85]=true}},
--smith
{11000003,"TWW_SetDesc2","TWW_WepSetDesc11","q:81887",app.GetLocalizedString("TWW_SetLabel0").." ("..app.GetLocalizedString("TWW_SetDesc2")..")",0,110000,{220314,220316,220318,{220317,249114},220315},nil,nil,{[3]=true,[34]=true,[84]=true,[85]=true}},
{11000070,"TWW_SetDesc2","TWW_WepSetDesc10","q:84730",app.GetLocalizedString("TWW_SetLabel0").." ("..app.GetLocalizedString("TWW_SetDesc2")..")",0,110007,{249095,{249093,249094},249092,249096,249097},nil,nil,{[3]=true,[34]=true,[84]=true,[85]=true}},
{11000069,"TWW_SetDesc2","TWW_WepSetDesc23","q:86496",app.GetLocalizedString("TWW_SetLabel0").." ("..app.GetLocalizedString("TWW_SetDesc2")..")",0,110007,{249037,249036,249040,{249038,249039},249033,},nil,nil,{[3]=true,[34]=true,[84]=true,[85]=true}},
--merchant
{11000002,"TWW_SetDesc1","TWW_WepSetDesc11","q:81887",app.GetLocalizedString("TWW_SetLabel0").." ("..app.GetLocalizedString("TWW_SetDesc1")..")",0,110000,{220308,220311,220322,220313,220312,220321},nil,nil,{[3]=true,[34]=true,[84]=true,[85]=true}},
{11000068,"TWW_SetDesc1","TWW_WepSetDesc10","q:84730",app.GetLocalizedString("TWW_SetLabel0").." ("..app.GetLocalizedString("TWW_SetDesc1")..")",0,110007,{249073,249076,249072,249074,249098,249104},nil,nil,{[3]=true,[34]=true,[84]=true,[85]=true}},
{11000067,"TWW_SetDesc1","TWW_WepSetDesc23","q:86496",app.GetLocalizedString("TWW_SetLabel0").." ("..app.GetLocalizedString("TWW_SetDesc1")..")",0,110007,{249067,249070,249030,249068,249041,249045},nil,nil,{[3]=true,[34]=true,[84]=true,[85]=true}},
--gatherer
{11000001,"TWW_SetDesc0","TWW_WepSetDesc11","q:81887",app.GetLocalizedString("TWW_SetLabel0").." ("..app.GetLocalizedString("TWW_SetDesc0")..")",0,110000,{218092,220323,220319,220310,220325,220324,220309},nil,nil,{[3]=true,[34]=true,[84]=true,[85]=true}},
{11000066,"TWW_SetDesc0","TWW_WepSetDesc10","q:84730",app.GetLocalizedString("TWW_SetLabel0").." ("..app.GetLocalizedString("TWW_SetDesc0")..")",0,110007,{249077,249075,249102,249101,249099,249103,249100},nil,nil,{[3]=true,[34]=true,[84]=true,[85]=true}},
{11000065,"TWW_SetDesc0","TWW_WepSetDesc23","q:86496",app.GetLocalizedString("TWW_SetLabel0").." ("..app.GetLocalizedString("TWW_SetDesc0")..")",0,110007,{249071,249069,249046,249042,249043,249032,249044},nil,nil,{[3]=true,[34]=true,[84]=true,[85]=true}},
--{11000001,"TWW_SetDesc0","Skardyn",app.GetLocalizedString("TWW_SetLabel0").."("..app.GetLocalizedString("TWW_SetDesc0")..")",0,110000,{218096},nil,nil,{[3]=true,[34]=true,[84]=true,[85]=true}},
--{11000001,"TWW_SetDesc0","Gold",app.GetLocalizedString("TWW_SetLabel0").."("..app.GetLocalizedString("TWW_SetDesc0")..")",0,110000,{218094},nil,nil,{[3]=true,[34]=true,[84]=true,[85]=true}},
--{11000001,"TWW_SetDesc0","Dark",app.GetLocalizedString("TWW_SetLabel0").."("..app.GetLocalizedString("TWW_SetDesc0")..")",0,110000,{225008,218093},nil,nil,{[3]=true,[34]=true,[84]=true,[85]=true}},
};

local function comp(a,b)
  if a[1] < b[1] then return true; else return false end
end
table.sort(db,comp);

--"Wrath of the Lich King: PvP" 20th anniversary s6 recolors
--4144 leather 
--4145 plate (green)
--4146 Mail
--4147 plate (purple)
--4148 Cloth

--"The Burning Crusade: Dungoen" 20th anniversary recolors
--4125 leather tw blue
--4126 leather red
--4127 leather brown
--4128 leather purple
--4129 mail tw brown
--4130 mail blue
--4131 mail purple
--4132 mail red
--4133 plate tw purple
--4134 plate red
--4135 plate dungeon silver
--4136 plate silver
--4137 cloth 1 tw blue
--4138 cloth 1 purple
--4139 cloth 1 red
--4140 cloth 1 white
--4141 cloth 2 tw brown
--4142 cloth 2 green
--4143 cloth 2 red

--[setID] = "label"
local altLabelDB = {
[3877] = app.GetLocalizedString("LabelArathiAttire"),--"Arathi Attire",
[3876] = app.GetLocalizedString("LabelArathiAttire"),--"Arathi Attire",
[3518] = app.GetLocalizedString("LabelArathiAttire"),--"Arathi Attire",
[4227] = app.GetLocalizedString("LabelArathiAttire"),--"Arathi Attire",
[4228] = app.GetLocalizedString("LabelArathiAttire"),--"Arathi Attire",
[4149] = app.GetLocalizedString("LabelUndergroundGear"),--"Underground Gear",
[4150] = app.GetLocalizedString("LabelUndergroundGear"),--"Underground Gear",
[4151] = app.GetLocalizedString("LabelUndergroundGear"),--"Underground Gear",
[4152] = app.GetLocalizedString("LabelUndergroundGear"),--"Underground Gear",
[4175] = app.GetLocalizedString("Plunderstorm"),--"Plunderstorm",
[3875] = app.GetLocalizedString("Plunderstorm"),--"Plunderstorm",
[4266] = app.GetLocalizedString("LabelCosArmorVendor"),--"Cosmetic Armor Vendor",
[4265] = app.GetLocalizedString("LabelCosArmorVendor"),--"Cosmetic Armor Vendor",
[4353] = app.GetLocalizedString("LabelUndermineGear"),--"Undermine Gear",--mail
[4360] = app.GetLocalizedString("LabelUndermineGear"),--"Undermine Gear",--mail
[4361] = app.GetLocalizedString("LabelUndermineGear"),--"Undermine Gear",--plate
[4352] = app.GetLocalizedString("LabelUndermineGear"),--"Undermine Gear",--plate
[4350] = app.GetLocalizedString("LabelUndermineGear"),--"Undermine Gear",--leather
[4352] = app.GetLocalizedString("LabelUndermineGear"),--"Undermine Gear",--leather
[4359] = app.GetLocalizedString("LabelUndermineGear"),--"Undermine Gear",--leather
[4358] = app.GetLocalizedString("LabelUndermineGear"),--"Undermine Gear",--cloth
[4351] = app.GetLocalizedString("LabelUndermineGear"),--"Undermine Gear",--cloth
[4370] = app.GetLocalizedString("LabelStormstout"),--"Stormstout",
[4550] = app.GetLocalizedString("LabelWingsAndWisdom"),
[4551] = app.GetLocalizedString("LabelWingsAndWisdom"),
[5195] = app.GetLocalizedString("TWW_KareshiGear"),  --Mail
[5180] = app.GetLocalizedString("TWW_KareshiGear"),  --Mail
[5184] = app.GetLocalizedString("TWW_KareshiGear"),  --Mail
[5181] = app.GetLocalizedString("TWW_KareshiGear"),--Plate
[5185] = app.GetLocalizedString("TWW_KareshiGear"),--Plate
[5196] = app.GetLocalizedString("TWW_KareshiGear"),--Plate
[5194] = app.GetLocalizedString("TWW_KareshiGear"),--Leather
[5183] = app.GetLocalizedString("TWW_KareshiGear"),--Leather
[5179] = app.GetLocalizedString("TWW_KareshiGear"),--Leather
[5178] = app.GetLocalizedString("TWW_KareshiGear"),--Cloth
[5182] = app.GetLocalizedString("TWW_KareshiGear"),--Cloth
[5193] = app.GetLocalizedString("TWW_KareshiGear"),--Cloth
[4561] = app.GetLocalizedString("TWW_Reshii"),--Reshii mini-set
[5095] = app.GetLocalizedString("TWW_Trust"),--Trust mini-set
[4558] = app.GetLocalizedString("TWW_Stillwater"),--Swillwater Fisher mini-set
[5096] = app.GetLocalizedString("TWW_CrimsonCourt"),--Lana'thel's Crimson Couture
[5335] = app.GetLocalizedString("TWW_ScorchingConqueror"),--Scorching Conqueror
}

local altLabelAppendDB = {
[5254] = app.GetLocalizedString("TWW_VillagerMaiden"),--The Villager Collection, Red
[5253] = app.GetLocalizedString("TWW_VillagerMaiden"),--The Villager Collection, Brown
[5252] = app.GetLocalizedString("TWW_VillagerMaiden"),--The Villager Collection, Blue
[5251] = app.GetLocalizedString("TWW_VillagerMaiden"),--The Villager Collection, Green
}

local altNoteDB = {
[3877] = app.GetLocalizedString("NoteSpreadingLight"),--"Spreading the Light",
[3876] = app.GetLocalizedString("NoteHallowfalQuests"),--"Hallowfall Quests",
[3518] = app.GetLocalizedString("NoteArathiRenown"),--"Hallowfall Arathi Renown";
[4227] = app.GetLocalizedString("SirenIsle"),--["SirenIsle"),
[4228] = app.GetLocalizedString("SirenIsle"),--["SirenIsle"),
[4175] = app.GetLocalizedString("NotePlunderstorm2025"),--"Plunderstorm 2025",
[3875] = app.GetLocalizedString("TradingPost"),--"Trading Post",
[4266] = app.GetLocalizedString("NoteCartelsofUndermine"),--"The Cartels of Undermine",
[4265] = app.GetLocalizedString("NoteCartelsBestie"),--"Cartels Bestie",
[4353] = app.GetLocalizedString("NoteCartelsofUndermine"),--"The Cartels of Undermine",--mail
[4360] = app.GetLocalizedString("NoteUndermineOutdoor"),--"Undermine Outdoor Activities",--mail
[4361] = app.GetLocalizedString("NoteUndermineOutdoor"),--"Undermine Outdoor Activities",--plate
[4352] = app.GetLocalizedString("NoteCartelsofUndermine"),--"The Cartels of Undermine",--plate
[4350] = app.GetLocalizedString("NoteCartelsofUndermine"),--"The Cartels of Undermine",--leather
[4359] = app.GetLocalizedString("NoteUndermineOutdoor"),--"Undermine Outdoor Activities",--leather
[4358] = app.GetLocalizedString("NoteUndermineOutdoor"),--"Undermine Outdoor Activities",--cloth
[4351] = app.GetLocalizedString("NoteCartelsofUndermine"),--"The Cartels of Undermine",--cloth
[5160] = app.GetLocalizedString("HallowsEnd"),--Horseman's Green
[5244] = app.GetTradingPostReleaseString("Nov",2025),--Villager Collection Brown, TP release
[5253] = app.GetTradingPostReleaseString("Nov",2025),--Villager Collection Maiden Brown, TP release
[4522] = app.GetTradingPostReleaseString("Nov",2025),--Rainy Day Yellow, TP release
[5151] = app.GetTradingPostReleaseString("Oct",2025),--Felreaver, Blue, TP release
[5152] = app.GetLocalizedString("TWW_FelcycleSecret"),--Felreaver, Green
[5166] = app.GetTradingPostReleaseString("Sep",2025),--Dwarven Ceremonial Bronze, TP release
[5167] = app.GetTradingPostReleaseString("Sep",2025),--Dwarven Ceremonial White, TP release
[4521] = app.GetTradingPostReleaseString("Sep",2025),--Rainy Day Red, TP release
[4548] = app.GetTradingPostReleaseString("Aug",2025),--Grandmaster's Gold, TP release
[4544] = app.GetTradingPostReleaseString("Aug",2025),--Grandmaster's Gold, TP release
[4555] = app.GetTradingPostReleaseString("Jul",2025),--Banshee's Green, TP release
[4556] = app.GetTradingPostReleaseString("Jul",2025),--Banshee's Purple, TP release
[4375] = app.GetTradingPostReleaseString("Jun",2025),--Lavaborn Red, TP release
[4373] = app.GetTradingPostReleaseString("Jun",2025),--Lavaborn Blue, TP release
[4366] = app.GetTradingPostReleaseString("May",2025),--Woodland Brown, TP release
[4368] = app.GetTradingPostReleaseString("May",2025),--Woodland Red, TP release
[4274] = app.GetTradingPostReleaseString("Apr",2025),--Garden Dweller Blue, TP release
[4273] = app.GetTradingPostReleaseString("Apr",2025),--Garden Dweller Purple, TP release
[4261] = app.GetTradingPostReleaseString("Mar",2025),--Butterfly Pearl, TP release
[4263] = app.GetTradingPostReleaseString("Mar",2025),--Butterfly Red, TP release
[4214] = app.GetTradingPostReleaseString("Feb",2025),--Ornate Lunar Pink, TP release
[4213] = app.GetTradingPostReleaseString("Feb",2025),--Ornate Lunar Red, TP release
[4210] = app.GetTradingPostReleaseString("Jan",2025),--Clockwork Green, TP release
[4209] = app.GetTradingPostReleaseString("Jan",2025),--Clockwork Gold, TP release
[4229] = app.GetLocalizedString("SirenIsle"),--Honorary Coucilmember's, Silver
[4519] = app.GetTradingPostReleaseString("Dec",2025), --Rainy Day (Blue)
[5238] = app.GetTradingPostReleaseString("Dec",2025), --The Winter Collection (blue)
[5245] = app.GetTradingPostReleaseString("Jan",2026), --The Villager Collection (red)
[5254] = app.GetTradingPostReleaseString("Jan",2026), --The Villager Collection (Maiden, red)
[5364] = app.GetTradingPostReleaseString("Jan",2026), --Regalia of the Crusader, Red
[5378] = app.GetTradingPostReleaseString("Feb",2026), --Raiment of the South Guardian, Gold
[4262] = app.GetLocalizedString("LoveIsInTheAir").." 2026", --Pearlescent Butterfly (pink)
[4215] = app.GetLocalizedString("TWW_WepSetLabel8").." 2026", --Ornate Lunar Festival (Purple) --lunar new year
[5242] = app.GetTradingPostReleaseString("Apr",2026), --The Villager Collection (green)
[5251] = app.GetTradingPostReleaseString("Apr",2026), --The Villager Collection (Maiden, green)
[4272] = app.GetTradingPostReleaseString("Apr",2026), --The Villager Collection (Maiden, green)
[4369] = app.GetTradingPostReleaseString("May",2026), --Woodland Attire (silver)
}

local neverObtainDB = {
  [5153] = true,--Felreaver, Orange
  [5241] = true, --The Winter Collection (purple)
  --[5238] = true, --The Winter Collection (blue)
  --[5240] = true, --The Winter Collection (orange)
  [5239] = true, --The Winter Collection (teal)
  --[5242] = true, --The Villager Collection (green)
  [5243] = true, --The Villager Collection (blue)
  --[5245] = true, --The Villager Collection (red)
  --[5251] = true, --The Villager Collection (Maiden, green)
  [5252] = true, --The Villager Collection (Maiden, blue)
  --[5254] = true, --The Villager Collection (Maiden, red)
  [5377] = true, --Raiment of the South Guardian, Silver
  --[5379] = true, --Raiment of the South Guardian, Copper
  --[5378] = true, --Raiment of the South Guardian, Gold
  [5380] = true, --Raiment of the South Guardian, Black
  [5365] = true, --Regalia of the Crusader, White
  [5363] = true, --Regalia of the Crusader, Purple
  --[5364] = true, --Regalia of the Crusader, Red
  [5362] = true, --Regalia of the Crusader, Green
  [5168] = true, --Dwarven Ceremonial Collection (blue)
  [5156] = true, --The Horseman's Collection (blue)
  [5161] = true, --The Horseman's Collection (red)
  [4558] = true, --Stillwater Fisher Attire
  [4557] = true, --Banshee's (Yellow)
  [4554] = true, --Banshee's (Blue)
  [4549] = true, --Grandmaster's (White)
  [4545] = true, --Grandmaster's (Blue)
  [4520] = true, --Rainy Day (Green)
  --[4519] = true, --Rainy Day (Blue)
  [4376] = true, --Lavaborn (yellow)
  [4370] = true, --Stormstout Collection
  --[4369] = true, --Woodland Attire (silver)
  [4367] = true, --Woodland Attire (grey)
  [4271] = true, --Forest Dweller's (green)
  --[4272] = true, --Forest Dweller's (pink)
  [4264] = true, --Pearlescent Butterfly (purple)
  --[4262] = true, --Pearlescent Butterfly (pink)
  --[4215] = true, --Ornate Lunar Festival (Purple)
  [4216] = true, --Ornate Lunar Festival (Teal)
  [4208] = true, --Clockwork Attire (Blue)
  [4211] = true, --Clockwork Attire (Purple)
  [3887] = true, --Battered Harvest Golem(green)
  [3888] = true, --Battered Harvest Golem(blue)
}

local holidayDB = {
  [5241] = {1,12}, --The Winter Collection (purple)
  [5238] = {1,12}, --The Winter Collection (blue)
  [5240] = {1,12}, --The Winter Collection (orange)
  [5239] = {1,12}, --The Winter Collection (teal)
  [5156] = 10, --The Horseman's Collection (blue)
  [5161] = 10, --The Horseman's Collection (red)
  [5162] = 10, --The Horseman's Collection (white)
  [5160] = 10, --The Horseman's Collection (green)
  [4216] = {1,2}, --Ornate Lunar Festival (Teal)
  [4215] = {1,2}, --Ornate Lunar Festival (Purple) --lunar new year
  [4214] = {1,2},--Ornate Lunar Pink, TP release
  [4213] = {1,2},--Ornate Lunar Red, TP release
}

local isRaidSet = {
--Manaforge Omega
--DH
[5104] = true,--LFR
[5103] = true,--Normal
[5101] = true,--Heroic
[5102] = true,--Mythic
--DK
[5100] = true,--LFR
[5099] = true,--Normal
[5097] = true,--Heroic
[5098] = true,--Mythic
--Druid
[5108] = true,--LFR
[5107] = true,--Normal
[5105] = true,--Heroic
[5106] = true,--Mythic
--Evoker
[5112] = true,--LFR
[5111] = true,--Normal
[5109] = true,--Heroic
[5110] = true,--Mythic
--Hunter
[5116] = true,--LFR
[5115] = true,--Normal
[5113] = true,--Heroic
[5114] = true,--Mythic
--Mage
[5120] = true,--LFR
[5119] = true,--Normal
[5117] = true,--Heroic
[5118] = true,--Mythic
--Monk
[5124] = true,--LFR
[5123] = true,--Normal
[5121] = true,--Heroic
[5122] = true,--Mythic
--Paladin
[5128] = true,--LFR
[5127] = true,--Normal
[5125] = true,--Heroic
[5126] = true,--Mythic
--Priest
[5132] = true,--LFR
[5131] = true,--Normal
[5129] = true,--Heroic
[5130] = true,--Mythic
--Rogue
[5136] = true,--LFR
[5135] = true,--Normal
[5133] = true,--Heroic
[5134] = true,--Mythic
--Shaman
[5140] = true,--LFR
[5139] = true,--Normal
[5137] = true,--Heroic
[5138] = true,--Mythic
--Warlock
[5144] = true,--LFR
[5143] = true,--Normal
[5141] = true,--Heroic
[5142] = true,--Mythic
--Warrior
[5148] = true,--LFR
[5147] = true,--Normal
[5145] = true,--Heroic
[5146] = true,--Mythic

--Liberation of Undermine
--DK
[4278] = true,--RF
[4277] = true,--Normal
[4275] = true,--Heroic
[4276] = true,--mythic
--Paladin
[4306] = true,--RF
[4305] = true,--Normal
[4303] = true,--Heroic
[4304] = true,--mythic
--Warrior
[4326] = true,--RF
[4325] = true,--Normal
[4323] = true,--Heroic
[4324] = true,--mythic

--Evoker
[4290] = true,--RF
[4289] = true,--Normal
[4287] = true,--Heroic
[4288] = true,--mythic
--Hunter
[4294] = true,--RF
[4293] = true,--Normal
[4291] = true,--Heroic
[4292] = true,--mythic
--Shaman
[4318] = true,--RF
[4317] = true,--Normal
[4315] = true,--Heroic
[4316] = true,--mythic

--DH
[4282] = true,--RF
[4281] = true,--Normal
[4279] = true,--Heroic
[4280] = true,--Mythic
--Druid
[4286] = true,--RF
[4285] = true,--Normal
[4283] = true,--Heroic
[4284] = true,--mythic
--Monk
[4302] = true,--RF
[4301] = true,--Normal
[4299] = true,--Heroic
[4300] = true,--mythic
--Rogue
[4314] = true,--RF
[4313] = true,--Normal
[4311] = true,--Heroic
[4312] = true,--mythic

--Mage
[4298] = true,--RF
[4297] = true,--Normal
[4295] = true,--Heroic
[4296] = true,--mythic
--Priest
[4310] = true,--RF
[4309] = true,--Normal
[4307] = true,--Heroic
[4308] = true,--mythic
--Warlock
[4322] = true,--RF
[4321] = true,--Normal
[4319] = true,--Heroic
[4320] = true,--mythic

--nerub-ar palace
--DK
[3719] = true,--Mythic
[3711] = true,--Normal
[3720] = true,--lfr
[3718] = true,--heroic

--Druid
[3726] = true,--mythic
[3727] = true,--norm
[3725] = true,--heroic
[3728] = true,--lfr

--DH
[3722] = true,--mythic
[3723] = true,--normal
[3721] = true,--heroic
[3724] = true,--lfr

--Paladin
[3747] = true,--normal
[3746] = true,--mythic
[3745] = true,--heroic
[3748] = true,--lfr

--Evoker
[3731] = true,--normal
[3729] = true,--heroic
[3732] = true,--lfr
[3730] = true,--mythic

--Monk
[3742] = true,--mythic
[3743] = true,--normal
[3744] = true,--lfr
[3741] = true,--heroic

--Priest
[3749] = true,--heroic
[3751] = true,--normal
[3750] = true,--mythic
[3752] = true,--lfr

--Warrior
[3767] = true,--normal
[3768] = true,--lfr
[3766] = true,--mythic
[3765] = true,--heroic

--Hunter
[3735] = true,--normal
[3736] = true,--lfr
[3734] = true,--mythic
[3733] = true,--heroic

--Rogue
[3755] = true,--normal
[3753] = true,--heroic
[3756] = true,--lfr
[3754] = true,--mythic

--Shaman
[3759] = true,--normal
[3758] = true,--mythic
[3757] = true,--heroic
[3760] = true,--lfr

--Mage
[3738] = true,--mythic
[3739] = true,--normal
[3737] = true,--heroic
[3740] = true,--lfr

--Warlock
[3763] = true,--normal
[3762] = true,--mythic
[3761] = true,--heroic
[3764] = true,--lfr
}

local altPatchID = {
[3518] = 110007,
[3875] = 110007,
[3891] = 110007,--coreway Regalia
[3890] = 110007,--algari Chainmail
[3889] = 110007,--dorn defender armraments
[3892] = 110007,--threads of awakening
[3664] = 109999,--dalaran defender plate
[3665] = 109999,--dalaran defender cloth
[3666] = 109999,--dalaran defender mail
[3667] = 109999,--dalaran defender leather
[4392] = 110105,--Flame's Radiance (Hallowfall gear) (cloth)
[4391] = 110105,--Flame's Radiance (Hallowfall gear) (leather)
[4390] = 110105,--Flame's Radiance (Hallowfall gear) (mail) 
[4389] = 110105,--Flame's Radiance (Hallowfall gear) (plate)
[4567] = 110107,--11.1.7 Tier2Recolor DK
[4574] = 110107,--11.1.7 Tier2Recolor Paladin
[4564] = 110107,--11.1.7 Tier2Recolor Warrior
[4562] = 110107,--11.1.7 Tier2Recolor Evoker
[4563] = 110107,--11.1.7 Tier2Recolor Hunter
[4569] = 110107,--11.1.7 Tier2Recolor Shaman
[4566] = 110107,--11.1.7 Tier2Recolor DH
[4571] = 110107,--11.1.7 Tier2Recolor Druid
[4565] = 110107,--11.1.7 Tier2Recolor Monk
[4568] = 110107,--11.1.7 Tier2Recolor Rogue
[4570] = 110107,--11.1.7 Tier2Recolor Mage
[4572] = 110107,--11.1.7 Tier2Recolor Priest
[4573] = 110107,--11.1.7 Tier2Recolor Warlock
[4372] = 110108,--Stormstout Sha-Touched, bumping to most recent at release
[4396] = 110201,--Soulrune Attire, purple, bumping to most recent at release
[4395] = 110201,--Spiritrune Attire, blue, bumping to most recent at release
[4394] = 110201,--Soulbringer Attire, purple, bumping to most recent at release
[4393] = 110201,--Spiritbringer Attire, blue, bumping to most recent at release
[5096] = 110206.1,--Lana'thel's Crimson Couture, bumping to most recent at release
[5154] = 110206,--Felreaver's Attire (purple), bumping to most recent at release
[5160] = 110206.2,--Horseman's green, bumping to most recent at release (hallow's end 2025)
[5244] = 110206.31,--Villager Collection Brown, TP release
[5253] = 110206.32,--Villager Collection Maiden Brown, TP release
[4522] = 110206.3,--Rainy Day Yellow, TP release
[5242] = 120002, --The Villager Collection (green), TP release
[5251] = 120002, --The Villager Collection (Maiden, green), TP release
[4272] = 120002, --The Villager Collection (Maiden, green), TP release
[4369] = 120005.1, --Woodland Attire (silver), TP Release
}

local addedAppearance = {
[5176] = {295675},--K'areshi Gear, Quest Rewards (plate) cloak
[5181] = {295716},--K'areshi Gear, Phase Diving (plate) cloak
[5174] = {295676},--K'areshi Gear, Quest Rewards (mail) cloak
[5180] = {295715},--K'areshi Gear, Phase Diving (mail) cloak
[5175] = {295677},--K'areshi Gear, Quest Rewards (leather) cloak
[5179] = {295714},--K'areshi Gear, Phase Diving (leather) cloak
[5177] = {295678},--K'areshi Gear, Quest Rewards (cloth) cloak
[5178] = {295713},--K'areshi Gear, Phase Diving (cloth) cloak

[3658] = {224577},--Hallowfall Gear,World Drops (cloth) cloak

[4392] = {289576},--Flame's Radiance (Hallowfall gear) (cloth) shirt
[4391] = {289577},--Flame's Radiance (Hallowfall gear) (leather) shirt
[4390] = {289578},--Flame's Radiance (Hallowfall gear) (mail) shirt
[4389] = {289579},--Flame's Radiance (Hallowfall gear) (plate) shirt

[3657] = {219927},--Hallowfall Gear,World Drops (leather) cloak
}

--Used to add alternate appearances to blizzard sets
--SetID, OriginalSourceID, AlternateApperanceID
local altAppearancesDB = {
--Winter Collection
[5238]={{296292,296329},},--Blue, Shoulders
[5240]={{296308,296331},},--Red, Shoulders
[5241]={{296316,296332},},--Purple, Shoulders
[5239]={{296300,296330},},--Teal, Shoulders

--Raiment of the South Guardian
[5380]={{301662,302162},--iron/black, pants without skirt/wrap
        {301664,302158},},--iron/black, hands without armor
[5379]={{301654,302163},--copper, pants without skirt/wrap
        {301656,302159},},--copper, hands without armor
[5378]={{301646,302164},--golden, pants without skirt/wrap
        {301648,302160},},--golden, hands without armor
[5377]={{301638,302165},--silver, pants without skirt/wrap
        {301640,302161},},--silver, hands without armor

--Regalia of the Crusader
[5365]={{301454,301448},},--white, Chest/robe
[5364]={{301445,301439},},--red, Chest/robe
[5363]={{301436,301430},},--purple, Chest/robe
[5362]={{301426,301420},},--green, Chest/robe

--Crimson Court
[5096]={{293015,293016},},--skirt/pants

--Soulrune (purple)
[4396]={{288037,288318},--extended gloves
        {288037,288317},--wraps without gloves
        {288037,288316},--wraps with gloves
        {288037,288039},--short gloves
        {288037,288038},--short wraps without gloves
        {288079,288192},--short cloak
        {288067,288074},--short sleeve chest
        {288067,288075},--long sleeve chest
        {288067,288073},--arm wraps chest
        {288067,288068},--short sleeve chest 2
        {288067,288069},--long sleeve chest 2
        {288055,288057},--shorts
        {288055,288056},--wraps no skirt
        {288044,288045},},--sandals, no leg warmers
--Spiritrune (blue)
[4395]={{288034,288315},--extended gloves
        {288034,288314},--wraps without gloves
        {288034,288313},--wraps with gloves
        {288034,288036},--short gloves
        {288034,288035},--short wraps without gloves
        {288078,288191},--short cloak
        {288064,288071},--short sleeve chest
        {288064,288072},--long sleeve chest
        {288064,288070},--arm wraps chest
        {288064,288065},--short sleeve chest
        {288064,288066},--long sleeve chest
        {288052,288054},--shorts
        {288052,288053},--wraps no skirt
        {288042,288043},},--sandals, no leg warmers
--Soulbringer (purple)
[4394]={{288031,288308},--extended gloves
        {288031,288309},--extended without gloves
        {288031,288311},--wraps with gloves
        {288031,288033},--short gloves
        {288031,288032},--short wraps without gloves
        {288077,288190},--short cloak
        {288061,288062},--short sleeve chest
        {288061,288063},--arm wraps chest
        {288049,288051},--leg wraps pants
        {288049,288050},},--shorts, no skirt
--Spiritbringer (blue)
[4393]={{288028,288307},--wraps with gloves
        {288028,288306},--extended without gloves
        {288028,288305},--extended with gloves
        {288028,288030},--short gloves
        {288028,288029},--short wraps without gloves
        {288076,288189},--short cloak
        {288058,288059},--short sleeve chest
        {288058,288060},--arm wraps chest
        {288046,288048},--leg wraps pants
        {288046,288047},},--shorts, no skirt



--Horseman's Collection alt helms
[5162]={{295338,297968},},--White
[5160]={{295322,297970},},--Green
[5161]={{295330,297969},},--Red
[5156]={{295290,297971},},--Blue

--Dwarven Ceremonial alt shoulders
[5166]={{295429,295513},},--Bronze
[5168]={{295445,295511},},--Blue
[5167]={{295437,295512},},--white
[5169]={{295453,295510},},--Red

--Season 3
--DH
[4100]={{228367,228369},--Glad, Helm
        {228383,228385},},--Glad, Shoulder
[4113]={{228368,228370},--Elite, Helm
        {228384,228386},},--Elite, Shoulder
--DK
[4099]={{228819,228821},--Glad, Helm
        {228835,228837},},--Glad, Shoulder
[4112]={{228820,228822},--Elite, Helm
        {228836,228838},},--Elite, Shoulder
--Druid
[4101]={{228291,228293},--Glad, Helm
        {228307,228309},--Glad, Shoulder
        {228267,228269},--Glad, Chest
        {228315,228317},},--Glad, Belt
[4114]={{228292,228294},--Elite, Helm
        {228308,228310},--Elite, Shoulder
        {228268,228270},--Elite, Chest
        {228316,228318},},--Elite, Belt
--Evoker
[4102]={{228595,228597},--Glad, Helm
        {228611,228613},},--Glad, Shoulders
[4115]={{228596,228598},--Elite, Helm
        {228612,228614},},--Elite, Shoulders
--Hunter
[4103]={{228671,228673},--Glad, Helm
        {228687,228689},},--Glad, Shoulder
[4116]={{228672,228674},--Elite, Helm
        {228688,228690},},--Elite, Shoulder
--Mage
[4104]={{228063,228065},--Glad, Helm
        {228079,228081},--Glad, Shoulder
        {228087,228089},},--Glad, Belt
[4117]={{228064,228066},--Elite, Helm
        {228080,228082},--Elite, Shoulder
        {228088,228090},},--Elite, Belt
--Monk
[4105]={{228443,228445},--Glad, Helm
        {228459,228461},--Glad, Shoulder
        {228419,228421},--Glad, Chest
        {228467,228469},--Glad, waist
        {228435,228437},--Glad, Gloves
        {228427,228429},},--Glad, boots
[4118]={{228444,228446},--Elite, Helm
        {228460,228462},--Elite, Shoulder
        {228420,228422},--Elite, Chest
        {228468,228470},--Elite, waist
        {228436,228438},--Elite, Gloves
        {228428,228430},},--Elite, boots
--Paladin
[4106]={{228895,228897},--Glad, Helm
        {228911,228913},},--Glad, Shoulders
[4119]={{228896,228898},--Elite, Helm
        {228912,228914},},--Elite, Shoulders
--Priest
[4107]={{228139,228141},--Glad, Helm
        {228155,228157},},--Glad, Shoulder
[4120]={{228140,228142},--Elite, Helm
        {228156,228158},},--Elite, Shoulder
--Rogue
[4108]={{228535,228537},},--Glad, Shoulder
[4121]={{228536,228538},},--Elite, Shoulder
--Shaman
[4109]={{228759,228761},},--Glad, Shoulder
[4122]={{228760,228762},},--Elite, Shoulder
--Warlock
[4111]={{228215,228217},--Glad, Helm
        {228231,228233},},--Glad, Shoulder
[4123]={{228216,228218},--Elite, Helm
        {228232,228234},},--Elite, Shoulder
--Warrior
[4110]={{228971,228973},--Glad, Helm
        {228987,228989},},--Glad, Shoulder
[4124]={{228972,228974},--Elite, Helm
        {228988,228990},},--Elite, Shoulder

--Manaforge Omega
--DH
[5104]={{286547,286550},--LFR, helm
        {286523,286526},},--LFR, shoulder
[5103]={{286542,286551},--Normal, helm
        {286518,286527},},--Normal, shoulder
[5101]={{286548,286552},--Heroic, helm
        {286524,286528},},--Heroic, shoulder
[5102]={{286549,286553},--Mythic, helm
        {286525,286529},},--Mythic, shoulder
--DK
[5100]={{285799,285802},--LFR, helm
        {285775,285778},},--LFR, shoulder
[5099]={{285794,285803},--Normal, helm
        {285770,285779},},--Normal, shoulder
[5097]={{285800,285804},--Heroic, helm
        {285776,285780},},--Heroic, shoulder
[5098]={{285801,285805},--Mythic, helm
        {285777,285781},},--Mythic, shoulder
--Druid
[5108]={{286439,286442},--LFR, helm
        {286415,286418},--LFR, shoulder
        {286475,286478},--LFR, chest
        {286403,286406},},--LFR, waist
[5107]={{286434,286443},--Normal, helm
        {286410,286419},--Normal, shoulder
        {286470,286479},--Normal, chest
        {286398,286407},},--Normal, waist
[5105]={{286440,286444},--Heroic, helm
        {286416,286420},--Heroic, shoulder
        {286476,286480},--Heroic, chest
        {286404,286408},},--Heroic, waist
[5106]={{286441,286445},--Mythic, helm
        {286417,286421},--Mythic, shoulder
        {286477,286481},--Mythic, chest
        {286405,286409},},--Mythic, waist
--Evoker
[5112]={{286115,286118},--LFR, helm
        {286091,286094},},--LFR, shoulder
[5111]={{286110,286119},--Normal, helm
        {286086,286095},},--Normal, shoulder
[5109]={{286116,286120},--Heroic, helm
        {286092,286096},},--Heroic, shoulder
[5110]={{286117,286121},--Mythic, helm
        {286093,286097},},--Mythic, shoulder
--Hunter
[5116]={{286007,286010},--LFR, helm
        {285983,285986},},--LFR, shoulder
[5115]={{286002,286011},--Normal, helm
        {285978,285987},},--Normal, shoulder
[5113]={{286008,286012},--Heroic, helm
        {285984,285988},},--Heroic, shoulder
[5114]={{286009,286013},--Mythic, helm
        {285985,285989},},--Mythic, shoulder
--Mage
[5120]={{286870,286873},--LFR, helm --295013
        {286846,286849},--LFR, shoulder
        {286834,286837},},--LFR, waist
[5119]={{286865,286874},--Normal, helm --295014
        {286841,286850},--Normal, shoulder
        {286829,286838},},--Normal, waist
[5117]={{286871,286875},--Heroic, helm --295015
        {286847,286851},--Heroic, shoulder
        {286835,286839},},--Heroic, waist
[5118]={{286872,286876},--Mythic, helm --295016
        {286848,286852},--Mythic, shoulder
        {286836,286840},},--Mythic, waist
--Monk
[5124]={{286331,286334},--LFR, helm --295082
        {286307,286310},--LFR, shoulder
        {286367,286370},--LFR, chest
        {286295,286298},--LFR, waist --295090
        {286343,286346},--LFR, gloves
        {286355,286358},},--LFR, boots --295094
[5123]={{286326,286335},--Normal, helm --295083
        {286302,286311},--Normal, shoulder
        {286362,286371},--Normal, chest
        {286290,286299},--Normal, waist --295091
        {286338,286347},--Normal, gloves
        {286350,286359},},--Normal, boots --295095
[5121]={{286332,286336},--Heroic, helm --295084
        {286308,286312},--Heroic, shoulder
        {286368,286372},--Heroic, chest
        {286296,286300},--Heroic, waist --295092
        {286344,286348},--Heroic, gloves
        {286356,286360},},--Heroic, boots --295096
[5122]={{286333,286337},--Mythic, helm --295085
        {286309,286313},--Mythic, shoulder
        {286369,286373},--Mythic, chest
        {286297,286301},--Mythic, waist --295093
        {286345,286349},--Mythic, gloves
        {286357,286361},},--Mythic, boots --295097
--Paladin
[5128]={{285691,285694},--LFR, helm --295178
        {285667,285670},},--LFR, shoulder --295174
[5127]={{285686,285695},--Normal, helm --295179
        {285662,285671},},--Normal, shoulder --295175
[5125]={{285692,285696},--Heroic, helm --295180
        {285668,285672},},--Heroic, shoulder --295176
[5126]={{285693,285697},--Mythic, helm --295181
        {285669,285673},},--Mythic, shoulder --295177
--Priest
[5132]={{286763,286766},--LFR, helm --295025
        {286739,286742},},--LFR, shoulder --295021
[5131]={{286758,286767},--Normal, helm --295026
        {286734,286743},},--Normal, shoulder --295022
[5129]={{286764,286768},--Heroic, helm --295027
        {286740,286744},},--Heroic, shoulder --295023
[5130]={{286765,286769},--Mythic, helm --295028
        {286741,286745},},--Mythic, shoulder --295024
--Rogue
[5136]={{286199,286202},},--LFR, shoulder --295098
[5135]={{286194,286203},},--Normal, shoulder --295099
[5133]={{286200,286204},},--Heroic, shoulder --295100
[5134]={{286201,286205},},--Mythic, shoulder --295101
--Shaman
[5140]={{285883,285886},},--LFR, shoulder --295253
[5139]={{285878,285887},},--Normal, shoulder --295254
[5137]={{285884,285888},},--Heroic, shoulder --295255
[5138]={{285885,285889},},--Mythic, shoulder
--Warlock
[5144]={{286655,286658},--LFR, helm
        {286631,286634},},--LFR, shoulder
[5143]={{286650,286659},--Normal, helm
        {286626,286635},},--Normal, shoulder
[5141]={{286656,286660},--Heroic, helm
        {286632,286636},},--Heroic, shoulder
[5142]={{286657,286661},--Mythic, helm
        {286633,286637},},--Mythic, shoulder
--Warrior
[5148]={{285583,285586},--LFR, helm --295214
        {285559,285562},},--LFR, shoulder
[5147]={{285578,285587},--Normal, helm --295215
        {285554,285563},},--Normal, shoulder
[5145]={{285584,285588},--Heroic, helm --295216
        {285560,285564},},--Heroic, shoulder
[5146]={{285585,285589},--Mythic, helm --295217
        {285561,285565},},--Mythic, shoulder



[3702]={{220653,249118},},--Earthen Heritage, Gundargaz, tights under skirt
[3701]={{220645,249119},},--Earthen Heritage, Freywold, tights under skirt
[3700]={{220630,249117},},--Earthen Heritage, Dornogal, tights under skirt

--[4318]={{225568,225571},},--Liberation of Undermine, Shaman Gloves LFR
--[4317]={{225563,225572},},--Liberation of Undermine, Shaman Gloves Normal
--[4315]={{225569,225573},},--Liberation of Undermine, Shaman Gloves Heroic
--[4316]={{225570,225570},},--Liberation of Undermine, Shaman Gloves Mythic
--[4016]={{227367,225566},},--Liberation of Undermine, Shaman Gloves Glad
--[4029]={{227368,225565},},--Liberation of Undermine, Shaman Gloves Elite

[4554]={{292028,292032},},--Banshee's Blue alt chest
[4556]={{292030,292034},},--Banshee's Purple alt chest
[4555]={{292029,292033},},--Banshee's Green alt chest
[4557]={{292031,292035},},--Banshee's Yellow alt chest

[4363]={{284932,284944},--Horrific Visions Revisited, Mail, Robe/Chest
        {284898,284912},},--Horrific Visions Revisited, Mail, Pants/Skirt

[4206]={{230527,230528},},--Shining Vestments of the Heavens, alt shoulders (blue)
[4207]={{230536,230537},},--Shining Vestments of the Heavens, alt shoulders (purple)

--Liberation of Undermine/S2 Plate
--DK
[4278]={{225454,225457},--DK RF Helm
        {225430,225433},},--DK RF Shoulders
[4277]={{225449,225458},--DK Normal Helm
        {225425,225434},},--DK Normal Shoulders
[4275]={{225455,225459},--DK Heroic Helm
        {225431,225435},},--DK Heroic Shoulders
[4276]={{225456,225460},--DK mythic Helm
        {225432,225436},},--DK mythic Shoulders
[4006]={{227449,225452},--DK Glad Helm
        {227465,225428},},--DK Glad Shoulders
[4019]={{227450,225453},--DK Elite Helm
        {227466,225429},},--DK Elite Shoulders
--Paladin
[4306]={{225346,225349},},--Paladin RF Helm
[4306]={{225322,225325},},--Paladin RF Shoulders
[4305]={{225341,225350},},--Paladin Normal Helm
[4305]={{225317,225326},},--Paladin Normal Shoulders
[4303]={{225347,225351},},--Paladin Heroic Helm
[4303]={{225323,225327},},--Paladin Heroic Shoulders
[4304]={{225348,225352},},--Paladin mythic Helm
[4304]={{225324,225328},},--Paladin mythic Shoulders
[4013]={{227525,225344},},--Paladin Glad Helm
[4013]={{227541,225320},},--Paladin Glad Shoulders
[4026]={{227526,225345},},--Paladin Elite Helm
[4026]={{227542,225321},},--Paladin Elite Shoulders
--Warrior
[4326]={{225238,225241},--Warrior RF Helm
        {225214,225217},--Warrior RF Shoulders
        {225202,225205},},--Warrior RF Belt
[4325]={{225233,225242},--Warrior Normal Helm
        {225209,225218},--Warrior Normal Shoulders
        {225197,225206},},--Warrior Normal Belt
[4323]={{225239,225243},--Warrior Heroic Helm
        {225215,225219},--Warrior Heroic Shoulders
        {225203,225207},},--Warrior Heroic Belt
[4324]={{225240,225244},--Warrior mythic Helm
        {225216,225220},--Warrior mythic Shoulders
        {225204,225208},},--Warrior mythic Belt
[4017]={{227602,225236},--Warrior Glad Helm
        {227618,225212},--Warrior Glad Shoulders
        {227626,225200},},--Warrior Glad Belt
[4031]={{227603,225237},--Warrior Elite Helm
        {227619,225213},--Warrior Elite Shoulders
        {227627,225201},},--Warrior Elite Belt

----Liberation of Undermine/S2 Mail
--Evoker
[4290]={{225766,225769},--Evoker RF Helm
        {225742,225745},},--Evoker RF Shoulders
[4289]={{225761,225770},--Evoker Normal Helm
        {225737,225746},},--Evoker Normal Shoulders
[4287]={{225767,225771},--Evoker Heroic Helm
        {225743,225747},},--Evoker Heroic Shoulders
[4288]={{225768,225772},--Evoker mythic Helm
        {225744,225748},},--Evoker mythic Shoulders
[4009]={{227223,225764},--Evoker Glad Helm
        {227239,225740},},--Evoker Glad Shoulders
[4022]={{227224,225765},--Evoker Elite Helm
        {227240,225741},},--Evoker Elite Shoulders
--Hunter
[4294]={{225658,225661},--Hunter RF Helm
        {225634,225637},},--Hunter RF Shoulders
[4293]={{225653,225662},--Hunter Normal Helm
        {225629,225638},},--Hunter Normal Shoulders
[4291]={{225659,225663},--Hunter Heroic Helm
        {225635,225639},},--Hunter Heroic Shoulders
[4292]={{225660,225664},--Hunter mythic Helm
        {225636,225640},},--Hunter mythic Shoulders
[4010]={{227299,225656},--Hunter Glad Helm
        {227315,225632},},--Hunter Glad Shoulders
[4023]={{227300,225657},--Hunter Elite Helm
        {227316,225633},},--Hunter Elite Shoulders
--Shaman
[4318]={{225556,225559},--Shaman RF Helm
        {225538,225541},--Shaman RF Shoulders
        {225526,225529},--Shaman RF Belt
        {225568,225571},},--Shaman RF Gloves
[4317]={{225551,225560},--Shaman Normal Helm
        {225533,225542},--Shaman Normal Shoulders
        {225521,225530},--Shaman Normal Belt
        {225563,225572},},--Shaman Normal Gloves
[4315]={{225557,225561},--Shaman Heroic Helm
        {225539,225543},--Shaman Heroic Shoulders
        {225527,225531},--Shaman Heroic Belt
        {225569,225573},},--Shaman Heroic gloves
[4316]={{225558,225562},--Shaman mythic Helm
        {225540,225544},--Shaman mythic Shoulders
        {225528,225532},},--Shaman mythic Belt
--[4316]={{225570,225570},},--Shaman mythic Gloves --diff appID, both flashy, both share sourceID
[4016]={{227375,225554},--Shaman Glad Helm
        {227387,225536},--Shaman Glad Shoulders
        {227351,225587},--Shaman Glad Robe
        {227395,225524},--Shaman Glad Belt
        {227367,225566},},--Shaman Glad gloves
[4029]={{227376,225555},--Shaman Elite Helm
        {227388,225537},--Shaman Elite Shoulders
        {227352,225588},--Shaman Elite Robe
        {227396,225525},},--Shaman Elite Belt
--[4029]={{227368,225565},},--Shaman Elite Gloves

--Liberation of Undermine/S2 Leather
--DH
[4282]={{226198,226201},--DH RF Helm
        {226174,226177},--DH RF Shoulders
        {226234,226237},--DH RF Chest
        {226210,226213},--DH RF Gloves
        {226186,226189},},--DH RF Pants

[4281]={{226193,226202},--DH Normal Helm
        {226169,226178},--DH Normal Shoulders
        {226229,226238},--DH Normal Chest
        {226205,226214},--DH Normal Gloves
        {226181,226190},},--DH Normal Pants

[4279]={{226199,226203},--DH Heroic Helm
        {226175,226179},--DH Heroic Shoulders
        {226235,226239},--DH Heroic Chest
        {226211,226215},--DH Heroic Gloves
        {226187,226191},},--DH Heroic Pants

[4280]={{226200,226204},--DH Mythic Helm
        {226176,226180},--DH Mythic Shoulders
        {226236,226240},--DH Mythic Chest
        {226212,226216},--DH Mythic Gloves
        {226188,226192},},--DH Mythic Pants

[4007]={{226995,226196},--DH Glad Helm
        {227011,226172},--DH Glad Shoulders
        {226971,226232},--DH Glad Chest
        {226987,226208},--DH Glad Gloves
        {227003,226184},},--DH Glad Pants

[4020]={{226996,226197},--DH Elite Helm
        {227012,226173},--DH Elite Shoulders
        {226972,226233},--DH Elite Chest
        {226988,226209},--DH Elite Gloves
        {227004,226185},},--DH Elite Pants
--Druid
[4286]={{226090,226093},--Druid RF Helm
        {226066,226069},},--Druid RF Shoulders
[4285]={{226085,226094},--Druid Normal Helm
        {226061,226070},},--Druid Normal Shoulders
[4283]={{226091,226095},--Druid Heroic Helm
        {226067,226071},},--Druid Heroic Shoulders
[4284]={{226092,226096},--Druid mythic Helm
        {226068,226072},},--Druid mythic Shoulders
[4008]={{226919,226088},--Druid Glad Helm
        {226935,226064},},--Druid Glad Shoulders
[4021]={{226920,226089},--Druid Elite Helm
        {226936,226065},},--Druid Elite Shoulders
--Monk
[4302]={{225982,225985},--Monk RF Helm
        {225958,225961},},--Monk RF Shoulders
[4301]={{225977,225986},--Monk Normal Helm
        {225953,225962},},--Monk Normal Shoulders
[4299]={{225983,225987},--Monk Heroic Helm
        {225959,225963},},--Monk Heroic Shoulders
[4300]={{225984,225988},--Monk mythic Helm
        {225960,225964},},--Monk mythic Shoulders
[4012]={{227071,225980},--Monk Glad Helm
        {227087,225956},},--Monk Glad Shoulders
[4025]={{227072,225981},--Monk Elite Helm
        {227088,225957},},--Monk Elite Shoulders
--Rogue
[4314]={{225850,225853},},--Rogue RF Shoulders
[4313]={{225845,225854},},--Rogue Normal Shoulders
[4311]={{225851,225855},},--Rogue Heroic Shoulders
[4312]={{225852,225856},},--Rogue mythic Shoulders
[4015]={{227163,225848},},--Rogue Glad Shoulders
[4028]={{227164,225849},},--Rogue Elite Shoulders

--Liberation of Undermine/S2 Cloth
--Mage
[4298]={{226520,226523},--Mage RF Helm
        {226496,226499},},--Mage RF Shoulders
[4297]={{226515,226524},--Mage Normal Helm
        {226491,226500},},--Mage Normal Shoulders
[4295]={{226521,226525},--Mage Heroic Helm
        {226497,226501},},--Mage Heroic Shoulders
[4296]={{226522,226526},--Mage mythic Helm
        {226498,226502},},--Mage mythic Shoulders
[4011]={{226691,226518},--Mage Glad Helm
        {226707,226494},},--Mage Glad Shoulders
[4024]={{226692,226519},--Mage Elite Helm
        {226708,226495},},--Mage Elite Shoulders
--Priest
[4310]={{226414,226417},--Priest RF Helm
        {226390,226393},},--Priest RF Shoulders
[4309]={{226409,226418},--Priest Normal Helm
        {226385,226394},},--Priest Normal Shoulders
[4307]={{226415,226419},--Priest Heroic Helm
        {226391,226395},},--Priest Heroic Shoulders
[4308]={{226416,226420},--Priest mythic Helm
        {226392,226396},},--Priest mythic Shoulders
[4014]={{226767,226412},--Priest Glad Helm
        {226783,226388},},--Priest Glad Shoulders
[4027]={{226768,226413},--Priest Elite Helm
        {226784,226389},},--Priest Elite Shoulders
--Warlock
[4322]={{226306,226309},--Warlock RF Helm
        {226282,226285},},--Warlock RF Shoulders
[4321]={{226301,226310},--Warlock Normal Helm
        {226277,226286},},--Warlock Normal Shoulders
[4319]={{226307,226311},--Warlock Heroic Helm
        {226283,226287},},--Warlock Heroic Shoulders
[4320]={{226308,226312},--Warlock mythic Helm
        {226284,226288},},--Warlock mythic Shoulders
[4018]={{226843,226304},--Warlock Glad Helm
        {226859,226280},},--Warlock Glad Shoulders
[4030]={{226844,226305},--Warlock Elite Helm
        {226860,226281},},--Warlock Elite Shoulders



[4351]={{285112,248938},},--Undermine Gear, Smartest in Town Cloth Chest/Robe
[4342]={{230229,266907},},--Undermine Gear, Smartest in Town Cloth Chest/Robe

[4175]={{230261,230326},},--Plunderlord's Stormridden Finery, Eyepatch

--20th Anniversary
[3870]={{220739,220756},},--Druid Chest
[3873]={{219971,230286},},--Warlock chest
[3868]={{220383,230285},},--Mage chest
[3865]={{220658,230287},},--Priest chest
[3871]={{220115,230290},},--Paladin robeless pants
[4574]={{291725,292213},},--Paladin Blood robeless pants
[3866]={{220797,230288},},--Shaman robes/pants
[3867]={{220712,285173},},--Rogue sleeveless chest
[4569]={{292169,292170},},--Shaman robes/pants, red
[4572]={{292148,292212},},--Priest robes/chest, red
[4570]={{291715,292209},},--Mage robes/chest, red
[4573]={{291739,292214},},--Warlock robes/chest, red
[4571]={{292210,291685},},--Druid robes/chest, red
--11.0 ends at 94162

--DK 91493, helms 91641
[3719]={{222558,222562},--Mythic Shoulders
        {222551,222555},--Mythic Belt
        {222572,222576},},--mythic helm
[3711]={{194510,222560},--Normal SHoulders
        {194509,222553},--Normal belt
        {194512,222574},},--normal helm
[3720]={{222556,222559},--lfr shoulders
        {222549,222552},--lfr belt
        {222570,222573},},--lfr helm
[3835]={{217715,217717},--Elite shoulders
        {217723,217725},--Elite belt
        {217699,217701},},--elite helm
[3822]={{217714,217716},--glad shoulders
        {217722,217724},--glad belt
        {217698,217700},},--glad helm
[3718]={{222557,222561},--heroic shoudlers
        {222550,222554},--heroic belt
        {222571,222575},},--heroic helm

--Druid 91556
[3726]={{222102,222106},--mythic helm
        {222088,222092},--mythic shoulders
        {222081,222085},},--mythic belt
[3727]={{194566,222104},--norm helm
        {194564,222090},--norm shoulders
        {194563,222083},},--norm belt
[3725]={{222101,222105},--heroic helm
        {222087,222091},--heroic shoulders
        {222080,222084},},--heroic belt
[3728]={{222100,222103},--lfr helm
        {222086,222089},--lfr shoulders
        {221275,222082},},--lfr belt
[3824]={{217166,217168},--glad helm
        {217182,217184},--glad shoulders
        {217190,217192},},--glad belt
[3837]={{217167,217169},--elite helm
        {217183,217185},--elite shoulders
        {217191,217193},},--elite belt

--DH 91820, gloves 91967
[3722]={{222027,222031},--mythic helm
        {222013,222017},--mythic shoulders
        {222006,222010},--mythic belt
        {222034,222038},},--mythic gloves
[3723]={{194575,222029},--normal helm
        {194573,222015},--normal shoulders
        {194572,222008},--normal belt
        {194576,222036},},--normal gloves
[3836]={{217243,217245},--elite helm
        {217259,217261},--elite shoulders
        {217267,217269},--elite belt
        {217235,217237},},--elite gloves
[3721]={{222026,222030},--heroic helm
        {222012,222016},--heroic shoulders
        {222005,222009},--heroic belt
        {222033,222037},},--heroic gloves
[3823]={{217242,217244},--glad helm
        {217258,217260},--glad shoulders
        {217266,217268},--glad belt
        {217234,217236},},--glad gloves
[3724]={{222025,222028},--lfr helm
        {222011,222014},--lfr shoulders
        {222004,222007},--lfr belt
        {222032,222035},},--lfr gloves

--Paladin 92027
[3747]={{194503,222661},--normal helm
        {194501,222647},},--normal shoulders
[3746]={{222659,222663},--mythic helm
        {222645,222649},},--mythic shoulders
[3841]={{217775,217777},--elite helm
        {217791,217793},},--elite shoulders
[3745]={{222658,222662},--heroic helm
        {222644,222648},},--heroic shoulders
[3828]={{217774,217776},--glad helm
        {217790,217792},},--glad shoulders
[3748]={{222657,222660},--lfr helm
        {222643,222646},},--lfr shoulders

--Evoker 92093
[3731]={{194539,222333},--normal helm
        {194537,222319},},--normal shoulders
--[3731]={{194536,222312},},--normal belt
[3825]={{217470,217472},--glad helm
        {217486,217488},},--glad shoulders
--[3825]={{217494,217496},},--glad belt
[3729]={{222330,222334},--heroic helm
        {222316,222320},},--heroic shoulders
--[3729]={{222309,222313},},--heroic belt
[3732]={{222329,222332},--lfr helm
        {222315,222318},},--lfr shoulders
--[3732]={{222308,222311},},--lfr belt
[3838]={{217471,217473},--elite helm
        {217487,217489},},--elite shoulders
--[3838]={{217495,217497},},--elite belt
[3730]={{222331,222335},--mythic helm
        {222317,222321},},--mythic shoulders
--[3730]={{222310,222314},},--mythic belt

--Monk 92171
[3742]={{222181,222185},--mythic helm
        {222167,222171},},--mythic shoulders
[3743]={{194557,222183},--normal helm
        {194555,222169},},--normal shoulders
[3744]={{222179,222182},--lfr helm
        {222165,222168},},--lfr shoulders
[3840]={{217319,217321},--elite helm
        {217335,217337},},--elite shoulders
[3741]={{222180,222184},--heroic helm
        {222166,222170},},--heroic shoulders
[3827]={{217318,217320},--glad helm
        {217334,217336},},--glad shoulders

--Priest 92259, gloves 92325, chest 92397, shoulders 92544 
[3749]={{221866,221870},--heroic helm
        {221852,221856},--heroic shoulders
        {221845,221849},--heroic belt
        {221873,221877},--heroic gloves
        {221887,221889},},--heroic chest
[3751]={{194593,221869},--normal helm
        {194591,221855},--normal shoulders
        {194590,221848},--normal belt
        {194594,221876},--normal gloves
        {194596,221888},},--normal chest
[3829]={{217014,217016},--glad helm
        {217030,217032},--glad shoulders
        {217038,217040},--glad belt
        {217006,217008},--glad gloves
        {216990,216992},},--glad chest
[3750]={{221867,221871},--mythic helm
        {221853,221857},--mythic shoulders
        {221846,221850},--mythic belt
        {221874,221878},--mythic gloves
        {229638,221890},},--mythic chest
[3842]={{217015,217017},--elite helm
        {217031,217033},--elite shoulders
        {217039,217041},--elite belt
        {217007,217009},--elite gloves
        {216991,216993},},--elite chest
[3752]={{221865,221868},--lfr helm
        {221851,221854},--lfr shoulders
        {221844,221847},--lfr belt
        {221872,221875},},--lfr gloves
--[3752]={{221886,},},--lfr chest --missing

--Warrior 92403
[3767]={{194494,222740},--normal helm
        {194492,222726},},--normal shoulders
[3845]={{217851,217853},--elite helm
        {217867,217869},},--elite shoulders
[3768]={{222736,222739},--lfr helm
        {222722,222725},},--lfr shoulders
[3766]={{222738,222742},--mythic helm
        {222724,222728},},--mythic shoulders
[3832]={{217850,217852},--glad helm
        {217866,217868},},--glad shoulders
[3765]={{222737,222741},--heroic helm
        {222723,222727},},--heroic shoulders

--Hunter 92475
[3735]={{194530,222412},--normal helm
        {194528,222398},},--normal shoulders
[3839]={{217547,217549},--elite helm
        {217563,217565},},--elite shoulders
[3736]={{222408,222411},--lfr helm
        {222394,222397},},--lfr shoulders
[3734]={{222410,222414},--mythic helm
        {222396,222400},},--mythic shoulders
[3826]={{217546,217548},--glad helm
        {217562,217564},},--glad shoulders
[3733]={{222409,222413},--heroic helm
        {222395,222399},},--heroic shoulders

--Rogue 92745, back 93245
[3755]={{194546,222244},},--normal shoulders
[3753]={{222241,222245},},--heroic shoulders
[3843]={{217411,217413},},--elite shoulders
[3756]={{222240,222243},},--lfr shoulders
[3754]={{222242,222246},},--mythic shoulders
[3830]={{217410,217412},},--glad shoulders

--Shaman 92802 (pvp sets have robe and chest vars)
[3759]={{194521,222495},--normal helm
        {194519,222481},},--normal shoulders
[3758]={{222493,222497},--mythic helm
        {222479,222483},},--mythic shoulders
[3844]={{217623,217625},--elite helm
        {217639,217641},--elite shoulders
        {217599,221645},--elite robe
        {217631,217633},},--elite pants
[3757]={{222492,222496},--heroic helm
        {222478,222482},},--heroic shoulders
[3760]={{222491,222494},--lfr helm
        {222477,222480},},--lfr shoulders
[3831]={{217622,217624},--glad helm
        {217638,217640},--glad shoulders
        {217598,221644},--glad robe
        {217630,217632},},--glad pants

--Mage 92965, gloves 93115, chest 93121
[3738]={{221788,221792},--mythic helm
        {221774,221778},--mythic shoulders
        {221809,221813},--mythic chest
        {221767,221771},--mythic waist
        {221795,221799},},--mythic gloves
[3739]={{194602,221790},--normal helm
        {194600,221776},--normal shoulders
        {194605,221811},--normal chest
        {194599,221769},--normal waist
        {194603,221797},},--normal gloves
[3737]={{221787,221791},--heroic helm
        {221773,221777},--heroic shoulders
        {221808,221812},--heroic chest
        {221766,221770},--heroic waist
        {221794,221798},},--heroic gloves
[3821]={{216938,216940},--glad helm
        {216954,216956},--glad shoulders
        {216914,216916},--glad chest
        {216962,216964},--glad waist
        {216930,216932},},--glad gloves
[3740]={{221786,221789},--lfr helm
        {221772,221775},--lfr shoulders
        {221807,221810},--lfr chest
        {221765,221768},--lfr waist
        {221793,221796},},--lfr gloves
[3834]={{216939,216941},--elite helm
        {216955,216957},--elite shoulders
        {216915,216917},--elite chest
        {216963,216965},--elite waist
        {216931,216933},},--elite gloves

--Warlock 93037, waists are duplicate appIDs (june 30th)
[3763]={{194584,221950},--normal helm
        {194582,221936},},--normal shoulders
--[3763]={{194581,221929},},--normal waist
[3846]={{217091,217093},--elite helm
        {217107,217109},},--elite shoulders
--[3846]={{217115,217117},},--elite waist
[3762]={{221948,221952},--mythic helm
        {221934,221938},},--mythic shoulders
--[3762]={{221927,221931},},--mythic waist
[3833]={{217090,217092},--glad helm
        {217106,217108},},--glad shoulders
--[3833]={{217114,217116},},--glad waist
[3761]={{221947,221951},--heroic helm
        {221933,221937},},--heroic shoulders
--[3761]={{221926,221930},},--heroic waist
[3764]={{221946,221949},--lfr helm
        {221932,221935},},--lfr shoulders
--[3764]={{221925,221928},},--lfr waist

--Delver's Cloth 91102
[3640]={{193881,218291},},--Robe version (underground teal)
--{,220464,218494},--Robe version (?? green)
[4152]={{220209,219286},},--Robe version (?? red)
--{,198870,219628},--Robe version (?? yellow)

--Hallowfall Cloth 85070
[3658]={{219899,219790},},--robes (world red)
[3881]={{218222,220133},},--robes (delves blue)
--{,,219610},--robes (?? dark/red) --chest only missing
[3699]={{216830,216862},},--chest only (s1 aspirant yellow)

--Educator's Knowledge cosmetic 84622
[3522]={{218091,217956},},--chest red
[3523]={{218090,217955},},--chest purple
[3524]={{218089,217954},},--chest green
[3525]={{218088,217953},},--chest blue
[3526]={{218087,217952},},--chest black
}

function AddToCollection(isTransmogrifier)
  --local names = "";
  --local descs = "";
  --local labels = "";
  --local nameArray = {};
  --local descArray = {};
  --local labelsArray = {};
  
  for i = 1, #db do
    --if not ExS_Localizing_Printer then
    --  ExS_Localizing_Printer = CreateFrame("EditBox", nil, WardrobeCollectionFrame);
    --  ExS_Localizing_Printer:SetPoint("LEFT", WardrobeCollectionFrame, "RIGHT", 50, 0);
    --  ExS_Localizing_Printer:SetSize(400,25);
    --  ExS_Localizing_Printer.tex = ExS_Localizing_Printer:CreateTexture(nil, "BACKGROUND");
    --  ExS_Localizing_Printer.tex:SetAllPoints(ExS_Localizing_Printer);
    --  ExS_Localizing_Printer.tex:SetColorTexture(.1,.1,.1,.75);
    --
    --  ExS_Localizing_Printer:SetText("");
    --  ExS_Localizing_Printer:SetAutoFocus(false);
    --  ExS_Localizing_Printer:SetFontObject("GameFontNormal");
    --  ExS_Localizing_Printer:SetJustifyH("LEFT");
    --end
    --if db[i][2] then
    --  local insertName = true;
    --  for a = 1, #nameArray do
    --    if nameArray[a] == db[i][2] then
    --      insertName = false;
    --      break;
    --    end
    --  end
    --  if insertName then
    --    tinsert(nameArray, db[i][2])
    --  end
    --end
    --if db[i][3] then
    --  local insertDesc = true;
    --  for a = 1, #descArray do
    --    if descArray[a] == db[i][3] then
    --      insertDesc = false;
    --      break;
    --    end
    --  end
    --  if insertDesc then
    --    tinsert(descArray, db[i][3])
    --  end
    --end
    --if db[i][4] then
    --  local insertLabel = true;
    --  for a = 1, #labelsArray do
    --    if labelsArray[a] == db[i][4] then
    --      insertLabel = false;
    --      break;
    --    end
    --  end
    --  if insertLabel then
    --    tinsert(labelsArray, db[i][4])
    --  end
    --end
    app.AddDBLineToTables(db[i], expansionID, isTransmogrifier);
  end
  
  --local text = ExS_Localizing_Printer:GetText();
  --
  --for a = 1, #nameArray do
  --  names = names.."[\"TWW_SetName"..#nameArray-a.."\"] = \""..nameArray[a].."\",--"..nameArray[a].."\n"
  --end
  --for a = 1, #descArray do
  --  descs = descs.."[\"TWW_SetDesc"..#descArray-a.."\"] = \""..descArray[a].."\",--"..descArray[a].."\n"
  --end
  --for a = 1, #labelsArray do
  --  labels = labels.."[\"TWW_SetLabel"..#labelsArray-a.."\"] = \""..labelsArray[a].."\",--"..labelsArray[a].."\n"
  --end
  --text = text..names..descs..labels;
  --ExS_Localizing_Printer:SetText(text);
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
app.altPatchID[expansionID+1] = altPatchID;
app.addedAppearance[expansionID+1] = addedAppearance;
app.isRaidSet[expansionID+1] = isRaidSet;
app.altLabelAppendDB[expansionID+1] = altLabelAppendDB;
app.neverObtainDB[expansionID+1] = neverObtainDB;
app.holidayDB[expansionID+1] = holidayDB;

--do
--  for i = 1, #altAppearancesDB do
--    app.ExpandedAltAppearances[altAppearancesDB[i][1]] = {altAppearancesDB[i][2],altAppearancesDB[i][3]};
--  end
--end

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