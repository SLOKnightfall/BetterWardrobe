local app = select(2,...);

local expansionID = 11;
--start of nerubian raid -- 91493
--earthen cosmetic 92566

--Name, Note, Label, classMask, patchID, sources, requiredFact, noLongerObtainable
----classMask:    (35=Plate, 68=Mail, 3592=Leather, 400=Cloth)
local db = {
{12000042,"TWW_SweatsMidnight",nil,nil,"Midnight_Gunslinger",0,120007,{308922,308650},nil,2,nil,true,1},
{12000059,"TWW_WepSetDesc8"   ,nil,nil,"Midnight_Gunslinger",0,120007,{308923,308651},nil,2,nil,true,1},--Azure
{12000058,"TWW_SweatsSepia"   ,nil,nil,"Midnight_Gunslinger",0,120007,{308924,308652},nil,2,nil,true,1},
{12000057,"TWW_SweatsGrassy"  ,nil,nil,"Midnight_Gunslinger",0,120007,{308925,308653},nil,2,nil,true,1},
{12000056,"TWW_SweatsCloudy"  ,nil,nil,"Midnight_Gunslinger",0,120007,{308926,308654},nil,2,nil,true,1},
{12000055,"TWW_SweatsDeep"    ,nil,nil,"Midnight_Gunslinger",0,120007,{308927,308655},nil,2,nil,true,1},
{12000054,"TWW_SweatsCamo"    ,nil,nil,"Midnight_Gunslinger",0,120007,{308928,308656},nil,2,nil,true,1},
{12000053,"TWW_SweatsBrick"   ,nil,nil,"Midnight_Gunslinger",0,120007,{308929,308657},nil,2,nil,true,1},
{12000052,"TWW_SweatsLively"  ,nil,nil,"Midnight_Gunslinger",0,120007,{308930,308658},nil,2,nil,true,1},
{12000051,"TWW_SweatsFaded"   ,nil,nil,"Midnight_Gunslinger",0,120007,{308931,308659},nil,2,nil,true,1},
{12000050,"TWW_SweatsRosy"    ,nil,nil,"Midnight_Gunslinger",0,120007,{308933,308661},nil,2,nil,true,1},
{12000049,"TWW_SweatsPlum"    ,nil,nil,"Midnight_Gunslinger",0,120007,{308934,308662},nil,2,nil,true,1},
{12000048,"TWW_WepSetDesc9"   ,nil,nil,"Midnight_Gunslinger",0,120007,{308935,308663},nil,2,nil,true,1},--crimson
{12000047,"TWW_SweatsAquatic" ,nil,nil,"Midnight_Gunslinger",0,120007,{308937,308665},nil,2,nil,true,1},
{12000046,"TWW_SweatsSnowy"   ,nil,nil,"Midnight_Gunslinger",0,120007,{308938,308666},nil,2,nil,true,1},
{12000045,"TWW_SweatsSunny"   ,nil,nil,"Midnight_Gunslinger",0,120007,{308939,308667},nil,2,nil,true,1},
{12000044,"TWW_WepSetDesc12"  ,nil,nil,"Midnight_Gunslinger",0,120007,{308936,308664},nil,2,nil,true,1},--violet
{12000043,"TWW_SweatsCarrot"  ,nil,nil,"Midnight_Gunslinger",0,120007,{308932,308660},nil,2,nil,true,1},

--{12000042,"Midnight_SunFestival",nil,nil,"Midnight_PaintedBattleGarb",0,120007,{309318,309317,{309327,309316,309315}--[[back]],{309320,309319}--[[shoulders]],{309322,309321}--[[waist]],{309324,309323}--[[pants]],309325,309326,309328},nil,2,nil,nil,1},

{12000041,"Midnight_Silversun",nil,"q:90871","Midnight_SilversunCompact",0,120002,{304273,304272,304274},nil,nil,nil,true},

{12000040,"Midnight_HaratiElder",nil,"r:6:2704:17","Midnight_HaratiRegalia",0,120001.1,{300817,300818,300819},nil,nil,nil,true},
{12000039,"Midnight_HaratiSage" ,nil,"r:6:2704:17","Midnight_HaratiRegalia",0,120001.1,{304249,304251,304253},nil,nil,nil,true},
{12000038,"Midnight_HaratiSeer" ,nil,"r:6:2704:17","Midnight_HaratiRegalia",0,120001.1,{304250,304252,304254},nil,nil,nil,true},

{12000037,"Midnight_SilvermoonCourt",nil,"r:6:2710:16","Midnight_SilvermoonCourtRegalia",0,120000.6,{303959,303957,303956},nil,nil,nil,true},

{12000036,"Midnight_WellWornTwilightCultist",nil,nil,"Midnight_Prepatch",0,119999,{296238,296239,296240},},

{12000035,"TWW_WepSetName36","DF_WepSetName44",nil,"Midnight_TwilightRegalia",0,120001,{303519,303524},nil,nil,nil,true},
{12000034,"TWW_WepSetName36","Midnight_Bladed",nil,"Midnight_TwilightRegalia",0,120001,{303518,303523},nil,nil,nil,true},
{12000033,"TWW_WepSetName36","DF_WepSetName55",nil,"Midnight_TwilightRegalia",0,120001,{303517,303525},nil,nil,nil,true},

{12000032,"Midnight_LoaBlessed","Midnight_Abundance","e:Midnight_Abundance","Midnight_LoaBlessedRegalia",0,120001.2,{304225,304224,304223},nil,nil,nil,true},
{12000031,"Midnight_LoaBlessed","Midnight_Depthdiver","e:Midnight_AbyssAngler","Midnight_LoaBlessedRegalia",0,120001.2,{304220,304222,304221},nil,nil,nil,true},
{12000030,"Midnight_LoaBlessed","Midnight_LoaBlessed","r:6:2696:16","Midnight_LoaBlessedRegalia",0,120001.2,{298044,298045,298043},nil,nil,nil,true},

{12000029,"Midnight_CollapsedStar","Midnight_Darkened","r:6:2699:15","Midnight_CollapsedStarRegalia",0,120001.3,{304233,304234,304235},nil,nil,nil,true},
{12000028,"Midnight_CollapsedStar","Midnight_Nebulous","r:6:2699:15","Midnight_CollapsedStarRegalia",0,120001.3,{304238,304237,304236},nil,nil,nil,true},
{12000027,"Midnight_CollapsedStar","DF_WepSetName44","r:6:2699:15","Midnight_CollapsedStarRegalia",0,120001.3,{302942,302818,302817},nil,nil,nil,true},

{12000026,"Gladiator",nil,nil,"Midnight_Season1Attire",0,120001.7,{302180,302182},"Horde",nil,nil,true,4},
{12000025,"Gladiator",nil,nil,"Midnight_Season1Attire",0,120001.7,{303229,303228},"Alliance",nil,nil,true,4},

{12000024,"Vilebranch","Lifeseer","Shoulders are Mail only.","Amani Seer",0,120001,{298160,298174,303522},nil,nil,nil,true},
{12000023,"Vilebranch","Deathseer",nil,"Amani Seer",0,120001,{303521},nil,nil,nil,true},
{12000022,"Vilebranch","Soulseer",nil,"Amani Seer",0,120001,{303520},nil,nil,nil,true},

{12000021,"TWW_SweatsMidnight",nil,nil,"Midnight_Dunecloth",0,119999.1,{302521,302503,302539},nil,2,nil,true,1},
{12000020,"TWW_WepSetDesc8",nil,nil,"Midnight_Dunecloth",0,119999.1,{302522,302504,302540},nil,2,nil,true,1},--Azure
{12000019,"TWW_SweatsSepia",nil,"e:TrialOfStyle","Midnight_Dunecloth",0,119999.1,{302523,302505,302541},nil,nil,nil,true,nil},
{12000018,"TWW_SweatsGrassy",nil,nil,"Midnight_Dunecloth",0,119999.1,{302524,302506,302543},nil,2,nil,true,1},
{12000017,"TWW_SweatsCloudy",nil,nil,"Midnight_Dunecloth",0,119999.1,{302525,302507,302542},nil,2,nil,true,1},
{12000016,"TWW_SweatsDeep",nil,nil,"Midnight_Dunecloth",0,119999.1,{302526,302508,302544},nil,2,nil,true,1},
{12000015,"TWW_SweatsCamo",nil,nil,"Midnight_Dunecloth",0,119999.1,{302527,302509,302545},nil,2,nil,true,1},
{12000014,"TWW_SweatsBrick",nil,nil,"Midnight_Dunecloth",0,119999.1,{302528,302510,302546},nil,2,nil,true,1},
{12000013,"TWW_SweatsLively",nil,app.GetTradingPostReleaseString("Apr",2026),"Midnight_Dunecloth",0,120002,{302529,302511,302547},nil,nil,nil,true,1},
{12000012,"TWW_SweatsFaded",nil,app.GetTradingPostReleaseString("May",2026),"Midnight_Dunecloth",0,120005.1,{302530,302512,302548},nil,nil,nil,true,1},
{12000011,"TWW_SweatsRosy",nil,nil,"Midnight_Dunecloth",0,119999.1,{302532,302514,302549},nil,2,nil,true,1},
{12000010,"TWW_SweatsPlum",nil,nil,"Midnight_Dunecloth",0,119999.1,{302533,302515,302551},nil,2,nil,true,1},
{12000009,"TWW_WepSetDesc9",nil,nil,"Midnight_Dunecloth",0,119999.1,{302534,302516,302552},nil,2,nil,true,1},--crimson
{12000008,"TWW_SweatsAquatic",nil,nil,"Midnight_Dunecloth",0,119999.1,{302536,302518,302554},nil,2,nil,true,1},
{12000007,"TWW_SweatsSnowy",nil,nil,"Midnight_Dunecloth",0,119999.1,{302537,302519,302555},nil,2,nil,true,1},
{12000006,"TWW_SweatsSunny",nil,nil,"Midnight_Dunecloth",0,119999.1,{302538,302520,302556},nil,2,nil,true,1},
{12000005,"TWW_WepSetDesc12",nil,app.GetTradingPostReleaseString("Mar",2026),"Midnight_Dunecloth",0,119999.1,{302553,302535,302517},nil,nil,nil,true,1},--violet
{12000004,"TWW_SweatsCarrot",nil,nil,"Midnight_Dunecloth",0,119999.1,{302550,302531,302513},nil,2,nil,true,1},

{12000002,"Midnight_Famed",nil,  "r:6:2764:6","Midnight_PreyseekerRegalia",0,120001.4,{301394,301390,301392},nil,nil,nil,true},
{12000001,"Midnight_Skilled",nil,"r:6:2764:3","Midnight_PreyseekerRegalia",0,120001.4,{301388,301389,301387},nil,nil,nil,true},
{12000003,"Midnight_Vaunted",nil,nil,"Midnight_PreyseekerRegalia",0,120001.4,{301393,301391,301395},nil,nil,nil,true},
};

local function comp(a,b)
  if a[1] < b[1] then return true; else return false end
end
table.sort(db,comp);

--[setID] = "label"
local altLabelDB = {
--12.0.7 midnight equip
[5707] = app.GetLocalizedString("Midnight_MidnightEquipment"),--Response Team's, plate
[5708] = app.GetLocalizedString("Midnight_MidnightEquipment"),--Response Team's, mail
[5709] = app.GetLocalizedString("Midnight_MidnightEquipment"),--Response Team's, leather
[5710] = app.GetLocalizedString("Midnight_MidnightEquipment"),--Response Team's, cloth


[5376] = app.GetLocalizedString("TWW_SetLabel6"),--Ascension Arrestor's Armor, plate, dorn defender
[5549] = app.GetLocalizedString("Midnight_HaratiAttire"),--Rampant Thorn Armor, plate
[5625] = app.GetLocalizedString("Midnight_HaratiAttire"),--Harandar Plate Armor, plate
[5629] = app.GetLocalizedString("Midnight_HaratiAttire"),--Midnight Dungeon Armor, plate
[5621] = app.GetLocalizedString("Midnight_MidnightEquipment"),--Preyseeker's polished armor, plate
[5477] = app.GetLocalizedString("Midnight_MidnightEquipment"),--Galactic Warmonger armor, plate
[5617] = app.GetLocalizedString("Midnight_MidnightEquipment"),--Voidbreaker's, plate

[5375] = app.GetLocalizedString("TWW_SetLabel5"),--Ascension Arrestor's Wear, mail, algari chainmail
[5548] = app.GetLocalizedString("Midnight_HaratiAttire"),--Elder Moss Outfit, mail
[5624] = app.GetLocalizedString("Midnight_HaratiAttire"),--Harandar Mail armor, mail
[5628] = app.GetLocalizedString("Midnight_HaratiAttire"),--Midnight Dungeon Mail armor, mail
[5620] = app.GetLocalizedString("Midnight_MidnightEquipment"),--Preyseeker's Rugged armor, mail
[5476] = app.GetLocalizedString("Midnight_MidnightEquipment"),--Galactic Warmonger's, mail
[5616] = app.GetLocalizedString("Midnight_MidnightEquipment"),--Voidbreaker's, mail

[5374] = app.GetLocalizedString("TWW_SetLabel4"),--Ascension Arrestor's Garb, leather, coreway garb
[5547] = app.GetLocalizedString("Midnight_HaratiAttire"),--Osseoclad's wear, leather
[5623] = app.GetLocalizedString("Midnight_HaratiAttire"),--Harandar leather armor, leather
[5627] = app.GetLocalizedString("Midnight_HaratiAttire"),--Midnight Dungeon leather armor, leather
[5619] = app.GetLocalizedString("Midnight_MidnightEquipment"),--Preyseeker's Sleek armor, leather
[5475] = app.GetLocalizedString("Midnight_MidnightEquipment"),--Galactic Warmonger's, leather
[5615] = app.GetLocalizedString("Midnight_MidnightEquipment"),--Voidbreaker's, leather

[5373] = app.GetLocalizedString("TWW_SetLabel3"),--Ascension Arrestor's Garb, cloth, threads of awakening
[5546] = app.GetLocalizedString("Midnight_HaratiAttire"),--Sprawling's Garb, cloth
[5622] = app.GetLocalizedString("Midnight_HaratiAttire"),--Harandar cloth armor, cloth
[5626] = app.GetLocalizedString("Midnight_HaratiAttire"),--Midnight Dungeon cloth armor, cloth
[5618] = app.GetLocalizedString("Midnight_MidnightEquipment"),--Preyseeker's Refined armor, cloth
[5474] = app.GetLocalizedString("Midnight_MidnightEquipment"),--Galactic Warmonger's, cloth
[5614] = app.GetLocalizedString("Midnight_MidnightEquipment"),--Voidbreaker's, cloth
}

local altLabelAppendDB = {
}

local altNoteDB = {
[5657] = app.GetLocalizedString("TradingPost")..", "..app.GetLocalizedString("Midnight_PaintedBattleTotem"),--Painted Battle Garb, blue, note about big totem being Tauren/Highmountain only
[5658] = app.GetLocalizedString("TradingPost")..", "..app.GetLocalizedString("Midnight_PaintedBattleTotem"),--Painted Battle Garb, dark, note about big totem being Tauren/Highmountain only
[5659] = app.GetLocalizedString("TradingPost")..", "..app.GetLocalizedString("Midnight_PaintedBattleTotem"),--Painted Battle Garb, gold, note about big totem being Tauren/Highmountain only
[5660] = app.GetLocalizedString("TradingPost")..", "..app.GetLocalizedString("Midnight_PaintedBattleTotem"),--Painted Battle Garb, white, note about big totem being Tauren/Highmountain only
[5713] = app.GetLocalizedString("TradingPost")..", "..app.GetLocalizedString("Midnight_PaintedBattleTotem"),--Painted Battle Garb, orange, note about big totem being Tauren/Highmountain only

[5376] = app.GetLocalizedString("Midnight_Prepatch"),--Ascension Arrestor's Armor, plate, dorn defender
[5375] = app.GetLocalizedString("Midnight_Prepatch"),--Ascension Arrestor's Wear, mail, algari chainmail
[5374] = app.GetLocalizedString("Midnight_Prepatch"),--Ascension Arrestor's Garb, leather, coreway regalia
[5373] = app.GetLocalizedString("Midnight_Prepatch"),--Ascension Arrestor's Regalia, cloth, threads of awakening

[5370] = app.GetTradingPostReleaseString("Mar",2026), --Elaborate Mageweave, Purple
[5371] = app.GetTradingPostReleaseString("Mar",2026), --Elaborate Mageweave, Red

[5350] = app.GetFormattedLabel("r:6:2704:20"),--Hara'ti Renown Note
[5351] = app.GetFormattedLabel("r:6:2704:20"),--Hara'ti Renown Note
[5352] = app.GetFormattedLabel("r:6:2704:20"),--Hara'ti Renown Note
[5353] = app.GetFormattedLabel("r:6:2704:20"),--Hara'ti Renown Note

[5389] = app.GetFormattedLabel("r:8:2714"),--Pilfered Dignitary
[5394] = app.GetFormattedLabel("r:9:2714"),--Pilfered Socialite
[5387] = app.GetFormattedLabel("r:7:2714"),--Pilfered Elegant

[5391] = app.GetFormattedLabel("r:8:2711"),--Magister's Dignitary
[5396] = app.GetFormattedLabel("r:9:2711"),--Magister's Socialite
[5386] = app.GetFormattedLabel("r:7:2711"),--Magister's Elegant

[5393] = app.GetFormattedLabel("r:8:2712"),--Blood Knight's Dignitary
[5395] = app.GetFormattedLabel("r:9:2712"),--Blood Knight's Socialite
[5383] = app.GetFormattedLabel("r:7:2712"),--Blood Knight's Elegant

[5390] = app.GetFormattedLabel("r:8:2713"),--Farstrider Dignitary
[5397] = app.GetFormattedLabel("r:9:2713"),--Farstrider Socialite
[5388] = app.GetFormattedLabel("r:7:2713"),--Farstrider Elegant

[5392] = app.GetFormattedLabel("r:6:2710:14"),--Haven Dignitary
[5398] = app.GetFormattedLabel("r:6:2710:20"),--Haven Socialite
[5384] = app.GetFormattedLabel("r:6:2710:2"),--Haven Elegant

[5570] = app.GetFormattedLabel("v:259722"),--Silvermoon Augur's, Red
[5567] = app.GetFormattedLabel("v:259722"),--Silvermoon Augur's, Green
[5569] = app.GetFormattedLabel("v:259722"),--Silvermoon Augur's, Blue
[5568] = app.GetFormattedLabel("v:259722"),--Silvermoon Augur's, White
[5571] = app.GetFormattedLabel("v:259722"),--Silvermoon Augur's, Black

[5557] = app.GetFormattedLabel("v:259722"),--Silvermoon Courtier's, Red
[5560] = app.GetFormattedLabel("v:259722"),--Silvermoon Courtier's, Black
[5559] = app.GetFormattedLabel("v:259722"),--Silvermoon Courtier's, Blue
[5558] = app.GetFormattedLabel("v:259722"),--Silvermoon Courtier's, Green
[5561] = app.GetFormattedLabel("v:259722"),--Silvermoon Courtier's, White

[3651] = app.GetFormattedLabel("e:Midnight_AbyssAngler"),--Green Diver's, Depthdiver

[5653] = app.GetTradingPostReleaseString("May",2026), --Gilneas streetwear (silver)
[5655] = app.GetTradingPostReleaseString("May",2026), --Gilneas streetwear (gold)
}

local neverObtainDB = {
[5695] = true, --Badlands Justice (White)
[5696] = true, --Badlands Justice (Red)
[5697] = true, --Badlands Justice (Purple)
[5698] = true, --Badlands Justice (Orange)
[5699] = true, --Badlands Justice (Black)
[5667] = true, --Azshara's Raiment, Red
[5667] = true, --Azshara's Raiment, White
[5691] = true, --Petalweave, White
[5692] = true, --Petalweave, Red
[5693] = true, --Petalweave, Pink
[5694] = true, --Petalweave, Blue

[5369] = true, --Elaborate Mageweave, Black
[5372] = true, --Elaborate Mageweave, Yellow

--Gilneas streetwear
[5654] = true,--Green
[5656] = true,--Purple

--Painted Battlegarb
[5657] = true,--blue
[5658] = true,--dark
[5659] = true,--gold
[5660] = true,--white
[5713] = true, --Painted Battle Garb, orange
}

local isRaidSet = {
----The Voidspire (S1)
--DK
[5417] = true,
[5418] = true,
[5419] = true,
[5420] = true,
--Paladin
[5445] = true,
[5446] = true,
[5447] = true,
[5448] = true,
--Warrior
[5465] = true,
[5466] = true,
[5467] = true,
[5468] = true,

--Evoker
[5429] = true,
[5430] = true,
[5431] = true,
[5432] = true,
--Hunter
[5433] = true,
[5434] = true,
[5435] = true,
[5436] = true,
--Shaman
[5457] = true,
[5458] = true,
[5459] = true,
[5460] = true,

--DH
[5421] = true,
[5422] = true,
[5423] = true,
[5424] = true,
--Druid
[5425] = true,
[5426] = true,
[5427] = true,
[5428] = true,
--Monk
[5441] = true,
[5442] = true,
[5443] = true,
[5444] = true,
--Rogue
[5453] = true,
[5454] = true,
[5455] = true,
[5456] = true,

--Mage
[54337] = true,
[54338] = true,
[54339] = true,
[54340] = true,
--Priest
[5449] = true,
[5450] = true,
[5451] = true,
[5452] = true,
--Warlock
[5461] = true,
[5462] = true,
[5463] = true,
[5464] = true,
}

local altPatchID = {
[5667] = 120007, --Azshara's Raiment, Red
[5667] = 120007, --Azshara's Raiment, White
[5707] = 120007,--Response Team's, plate
[5708] = 120007,--Response Team's, mail
[5709] = 120007,--Response Team's, leather
[5710] = 120007,--Response Team's, cloth

[5653] = 120005.1, --Gilneas streetwear (silver)
[5655] = 120005.1, --Gilneas streetwear (gold)

[3651] = 120005,--Green Diver's, Depthdiver

--Elegant garb
[5383] = 120000.3,--Black
[5384] = 120000.3,--Red
[5386] = 120000.3,--Blue
[5387] = 120000.3,--White
[5388] = 120000.3,--Green

--Dignitary
[5389] = 120000.2,--White
[5390] = 120000.2,--Green
[5391] = 120000.2,--Blue
[5392] = 120000.2,--Red
[5393] = 120000.2,--Black

--Socialite
[5394] = 120000.1,--White
[5395] = 120000.1,--Black
[5396] = 120000.1,--Blue
[5397] = 120000.1,--Green
[5398] = 120000.1,--Red

--Augur
[5567] = 120000.5,--Green
[5568] = 120000.5,--White
[5569] = 120000.5,--Blue
[5570] = 120000.5,--Red
[5571] = 120000.5,--Black

--Courtier
[5557] = 120000.4,--Red
[5558] = 120000.4,--Green
[5559] = 120000.4,--Blue
[5560] = 120000.4,--Black
[5561] = 120000.4,--White

--Pre-patch
[5373] = 119999,--cloth
[5374] = 119999,--leather
[5375] = 119999,--mail
[5376] = 119999,--plate

--Dragonhawk Rider
[5165] = 119998,--Lightstrider's Raiment
[5164] = 119998,--Voidstrider's Raiment

----The Voidspire (S1)
--DK
[5417] = 120001.9,
[5418] = 120001.9,
[5419] = 120001.9,
[5420] = 120001.9,
--Paladin
[5445] = 120001.9,
[5446] = 120001.9,
[5447] = 120001.9,
[5448] = 120001.9,
--Warrior
[5465] = 120001.9,
[5466] = 120001.9,
[5467] = 120001.9,
[5468] = 120001.9,

--Evoker
[5429] = 120001.9,
[5430] = 120001.9,
[5431] = 120001.9,
[5432] = 120001.9,
--Hunter
[5433] = 120001.9,
[5434] = 120001.9,
[5435] = 120001.9,
[5436] = 120001.9,
--Shaman
[5457] = 120001.9,
[5458] = 120001.9,
[5459] = 120001.9,
[5460] = 120001.9,

--DH
[5421] = 120001.9,
[5422] = 120001.9,
[5423] = 120001.9,
[5424] = 120001.9,
--Druid
[5425] = 120001.9,
[5426] = 120001.9,
[5427] = 120001.9,
[5428] = 120001.9,
--Monk
[5441] = 120001.9,
[5442] = 120001.9,
[5443] = 120001.9,
[5444] = 120001.9,
--Rogue
[5453] = 120001.9,
[5454] = 120001.9,
[5455] = 120001.9,
[5456] = 120001.9,

--Mage
[54337] = 120001.9,
[54338] = 120001.9,
[54339] = 120001.9,
[54340] = 120001.9,
--Priest
[5449] = 120001.9,
[5450] = 120001.9,
[5451] = 120001.9,
[5452] = 120001.9,
--Warlock
[5461] = 120001.9,
[5462] = 120001.9,
[5463] = 120001.9,
[5464] = 120001.9,

--S1
--plate
[5472] = 120001.8,
--war
[5584] = 120001.8,
[5597] = 120001.8,
--dk
[5572] = 120001.8,
[5585] = 120001.8,
--paladin
[5579] = 120001.8,
[5592] = 120001.8,

--mail
[5471] = 120001.8,
--evoker
[5575] = 120001.8,
[5588] = 120001.8,
--hunter
[5576] = 120001.8,
[5589] = 120001.8,
--shaman
[5582] = 120001.8,
[5595] = 120001.8,

--leather
[5470] = 120001.8,
--dh
[5573] = 120001.8,
[5586] = 120001.8,
--druid
[5574] = 120001.8,
[5587] = 120001.8,
--monk
[5578] = 120001.8,
[5591] = 120001.8,
--rogue
[5581] = 120001.8,
[5594] = 120001.8,

--cloth
[5469] = 120001.8,
--mage
[5577] = 120001.8,
[5590] = 120001.8,
--priest
[5580] = 120001.8,
[5593] = 120001.8,
--warlock
[5583] = 120001.8,
[5596] = 120001.8,
}

local addedAppearance = {
--Badlands, shirts
[5695] = {308632}, --(White)
[5696] = {308629}, --(Red)
[5697] = {308638}, --(Purple)
[5698] = {308626}, --(Orange)
[5699] = {308635}, --(Black)
[5713] = {309317}, --(Orange)

--Painted Battlegarb
[5657] = {304616},--blue, shirt
[5658] = {304638},--dark, shirt
[5659] = {304650},--gold, shirt
[5660] = {304669},--white, shirt

[5642] = {304271},--Plate, Thalassian Equipment, Epic Crafted, Cloak
[5644] = {304270},--Plate, Thalassian Equipment, Rare Crafted, Cloak

[5638] = {304269},--Mail, Thalassian Equipment, Epic Crafted, Cloak
[5640] = {304268},--Mail, Thalassian Equipment, Rare Crafted, Cloak

[5634] = {304267},--Leather, Thalassian Equipment, Epic Crafted, Cloak
[5636] = {304266},--Leather, Thalassian Equipment, Rare Crafted, Cloak
}

--Used to add alternate appearances to blizzard sets
--SetID, OriginalSourceID, AlternateApperanceID
local altAppearancesDB = {
----
--DK
--Paladin
--Warrior

--Evoker
--Hunter
--Shaman

--DH
--Druid
--Monk
--Rogue

--Mage
--Priest
--Warlock

--Azshara's Raiment
[5667] = {--Red
          {304810,304811},--gloves
          {304813,304814},--pants
          {304808,304809},--chest
         },
[5668] = {--White
          {304821,304822},--gloves
          {304824,304825},--pants
          {304819,304820},--chest
         },

--Badlands Justice
[5695] = {{306640,308631},--boots
          {306631,308630},--pants
          {306616,307636},--hat only
          {306616,307637}--bandana only
         }, --(White)
[5696] = {{307584,308628},--boots
          {307583,308627},--pants
          {307580,307638},--hat only
          {307580,307639}--bandana only
         }, --(Red)
[5697] = {{307592,308637},--boots
          {307591,308636},--pants
          {307588,307640},--hat only
          {307588,307641}--bandana only
         }, --(Purple)
[5698] = {{307600,308624},--boots
          {307599,308625},--pants
          {307596,307634},--hat only
          {307596,307635}--bandana only
         }, --(Orange)
[5699] = {{307608,308634},--boots
          {307607,308633},--pants
          {307604,307632},--hat only
          {307604,307633}--bandana only
         }, --(Black)

--20th Anniversary, Void Assaults
[5552] = {{302961,302846}},--Druid, Robe/Chest
[3850] = {{303012,302893}},--Paladin, Skirt/Pants
[3855] = {{303041,302922}},--Shaman, Skirt/Pants
[5556] = {{303018,302903}},--Priest, Robe/Chest
[3853] = {{302989,302874}},--Mage, Robe/Chest
[3848] = {{303047,302932}},--Warlock, Robe/Chest

--Painted Battlegarb
--orange
[5713] = {{309327,309316},--[[back]]
          {309327,309315},--[[back]]
          {309320,309319},--[[shoulders]]
          {309322,309321},--[[waist]]
          {309324,309323},--[[pants]]
         },
--blue
[5657] = {{304606,304708},--little totem
          {304606,304709},--big totem
          {304609,304610},--pants without gubbin
          {304613,304614},--shoulders
          {304611,304612},--waist without gubbin
          },
--dark
[5658] = {{304628,304710},--little totem
          {304628,304711},--big totem
          {304631,304632},--pants without gubbin
          {304635,304636},--shoulders
          {304633,304634},--waist without gubbin
          },
--gold
[5659] = {{304640,304712},--little totem
          {304640,304713},--big totem
          {304643,304644},--pants without gubbin
          {304647,304648},--shoulders
          {304645,304646},--waist without gubbin
          },
--white
[5660] = {{304659,304714},--little totem
          {304659,304715},--big totem
          {304662,304663},--pants without gubbin
          {304666,304667},--shoulders
          {304664,304665},--waist without gubbin
          },

--Gilneas streetwear, pants w/o buttcape
[5653]={{304564,304654},},--Silver
[5654]={{304570,304653},},--Green
[5655]={{304576,304652},},--Gold
[5656]={{304582,304651},},--Purple

----S1 PvP
--DK
[5572]={{300384,300386},--Glad, shoulders
        {300368,300370},--Glad, helm
        {300392,300394},},--Glad, waist
[5585]={{300385,300387},--Elite, shoulders
        {300369,300371},--Elite, helm
        {300393,300395},},--Elite, waist
--Paladin
[5579]={{300460,300462},--Glad, shoulders
        {300444,300446},},--Glad, helm
[5592]={{300461,300463},--Elite, shoulders
        {300445,300447},},--Elite, helm
--Warrior
[5584]={{300536,300538},--Glad, shoulders
        {300520,300522},},--Glad, helm
[5597]={{300537,300539},--Elite, shoulders
        {300521,300523},},--Elite, helm

--Evoker
[5575]={{300156,300158},},--Glad, shoulders
[5588]={{300157,300159},},--Elite, shoulders
--Hunter
[5576]={{300232,300234},--Glad, shoulders
        {300216,300218},--Glad, helm
        {300240,300242},--Glad, waist
        {300208,300210},},--Glad, gloves
[5589]={{300233,300235},--Elite, shoulders
        {300217,300219},--Elite, helm
        {300241,300243},--Elite, waist
        {300209,300211},},--Elite, gloves
--Shaman
[5582]={{300308,300310},--Glad, shoulders
        {300292,300294},--Glad, helm
        {300309,300311},--Elite, shoulders
        {300293,300295},},--Elite, helm

--DH
[5573]={{299928,299930},--Glad, shoulders
        {299912,299914},--Glad, helm
        {299936,299938},},--Glad, waist
[5586]={{299929,299931},--Elite, shoulders
        {299913,299915},--Elite, helm
        {299937,299939},},--Elite, waist
--Druid
[5574]={{299852,299854},--Glad, shoulders
        {299836,299838},},--Glad, helm
[5587]={{299853,299855},--Elite, shoulders
        {299837,299839},},--Elite, helm
--Monk
[5578]={{300004,300006},--Glad, shoulders
        {299988,299990},--Glad, helm
        {300012,300014},},--Glad, waist
[5591]={{299989,299991},--Elite, shoulders
        {300005,300007},--Elite, helm
        {300013,300015},},--Elite, waist
--Rogue
[5581]={{300080,300086},--Glad, shoulders
        {300064,300066},},--Glad, helm
[5594]={{300081,300083},--Elite, shoulders
        {300065,300067},},--Elite, helm

--Mage
[5577]={{299624,299626},--Glad, shoulders
        {299608,299610},},--Glad, helm
[5590]={{299625,299627},--Elite, shoulders
        {299609,299611},},--Elite, helm
--Priest
[5580]={{299700,299702},--Glad, shoulders
        {299684,299686},},--Glad, helm
[5593]={{299701,299703},--Elite, shoulders
        {299685,299687},},--Elite, helm
--Warlock
[5583]={{299776,299778},--Glad, shoulders
        {299760,299762},},--Glad, helm
[5596]={{299777,299779},--Elite, shoulders
        {299761,299763},},--Elite, helm

----The Voidspire
--DK
[5417]={{296635,296638},--LFR, shoulders
        {296659,296662},--LFR, helm
        {296623,296626},},--LFR, waist
[5418]={{296630,296639},--Normal, shoulders
        {296654,296663},--Normal, helm
        {296618,296627},},--Normal, waist
[5419]={{296636,296640},--Heroic, shoulders
        {296660,296664},--Heroic, helm
        {296624,296628},},--Heroic, waist
[5420]={{296637,296641},--Mythic, shoulders
        {296661,296665},--Mythic, helm
        {296625,296629},},--Mythic, waist
--Paladin
[5445]={{296527,296530},--LFR, shoulders
        {296551,296554},},--LFR, helm
[5446]={{296522,296531},--Normal, shoulders
        {296546,296555},},--Normal, helm
[5447]={{296528,296532},--Heroic, shoulders
        {296552,296556},},--Heroic, helm
[5448]={{296529,296533},--Mythic, shoulders
        {296553,296557},},--Mythic, helm
--Warrior
[5465]={{296419,296422},--LFR, shoulders
        {296443,296446},},--LFR, helm
[5466]={{296414,296423},--Normal, shoulders
        {296438,296447},},--Normal, helm
[5467]={{296420,296424},--Heroic, shoulders
        {296444,296448},},--Heroic, helm
[5468]={{296421,296425},--Mythic, shoulders
        {296445,296449},},--Mythic, helm

--Evoker
[5429]={{296959,296962},},--LFR, shoulders
[5430]={{296954,296963},},--Normal, shoulders
[5431]={{296960,296964},},--Heroic, shoulders
[5432]={{296961,296965},},--Mythic, shoulders
--Hunter
[5433]={{296851,296854},--LFR, shoulders
        {296875,296878},--LFR, helm
        {296887,296890},--LFR, gloves
        {296839,296842},},--LFR, waist
[5434]={{296846,296855},--Normal, shoulders
        {296870,296879},--Normal, helm
        {296882,296891},--Normal, gloves
        {296834,296843},},--Normal, waist
[5435]={{296852,296856},--Heroic, shoulders
        {296876,296880},--Heroic, helm
        {296888,296892},--Heroic, gloves
        {296840,296844},},--Heroic, waist
[5436]={{296853,296857},--Mythic, shoulders
        {296877,296881},--Mythic, helm
        {296889,296893},--Mythic, gloves
        {296841,296845},},--Mythic, waist
--Shaman
[5457]={{296743,296746},--LFR, shoulders
        {296767,296770},},--LFR, helm
[5458]={{296738,296747},--Normal, shoulders
        {296762,296771},},--Normal, helm
[5459]={{296744,296748},--Heroic, shoulders
        {296768,296772},},--Heroic, helm
[5460]={{296745,296749},--Mythic, shoulders
        {296769,296773},},--Mythic, helm

--DH
[5421]={{297391,297394},--LFR, shoulders
        {297415,297418},--LFR, helm
        {297379,297382},},--LFR, waist
[5422]={{297386,297395},--Normal, shoulders
        {297410,297419},--Normal, helm
        {297374,297383},},--Normal, waist
[5423]={{297392,297396},--Heroic, shoulders
        {297416,297420},--Heroic, helm
        {297380,297384},},--Heroic, waist
[5424]={{297393,297397},--Mythic, shoulders
        {297417,297421},--Mythic, helm
        {297381,297385},},--Mythic, waist
--Druid
[5425]={{297283,297286},--LFR, shoulders
        {297307,297310},},--LFR, helm
[5426]={{297278,297287},--Normal, shoulders
        {297302,297311},},--Normal, helm
[5427]={{297284,297288},--Heroic, shoulders
        {297308,297312},},--Heroic, helm
[5428]={{297285,297289},--Mythic, shoulders
        {297309,297313},},--Mythic, helm
--Monk
[5441]={{297175,297178},--LFR, shoulders
        {297199,297202},--LFR, helm
        {297163,297166},},--LFR, waist
[5442]={{297194,297203},--Normal, shoulders
        {297170,297179},--Normal, helm
        {297158,297167},},--Normal, waist
[5443]={{297176,297180},--Heroic, shoulders
        {297200,297204},--Heroic, helm
        {297164,297168},},--Heroic, waist
[5444]={{297177,297181},--Mythic, shoulders
        {297201,297205},--Mythic, helm
        {297165,297169},},--Mythic, waist
--Rogue
[5453]={{297067,297070},--LFR, shoulders
        {297091,297094},},--LFR, helm
[5454]={{297062,297071},--Normal, shoulders
        {297086,297095},},--Normal, helm
[5455]={{297068,297072},--Heroic, shoulders
        {297092,297096},},--Heroic, helm
[5456]={{297069,297073},--Mythic, shoulders
        {297093,297097},},--Mythic, helm

--Mage
[5437]={{297715,297718},--LFR, shoulders
        {297739,297742},},--LFR, helm
[5438]={{297710,297719},--Normal, shoulders
        {297734,297743},},--Normal, helm
[5439]={{297716,297720},--Heroic, shoulders
        {297740,297744},},--Heroic, helm
[5440]={{297717,297721},--Mythic, shoulders
        {297741,297745},},--Mythic, helm
--Priest
[5449]={{297607,297610},--LFR, shoulders
        {297631,297634},},--LFR, helm
[5450]={{297602,297611},--Normal, shoulders
        {297626,297635},},--Normal, helm
[5451]={{297608,297612},--Heroic, shoulders
        {297632,297636},},--Heroic, helm
[5452]={{297609,297613},--Mythic, shoulders
        {297633,297637},},--Mythic, helm
--Warlock
[5461]={{297499,297502},--LFR, shoulders
        {297523,297526},},--LFR, helm
[5462]={{297494,297503},--Normal, shoulders
        {297518,297527},},--Normal, helm
[5463]={{297500,297504},--Heroic, shoulders
        {297524,297528},},--Heroic, helm
[5464]={{297501,297505},--Mythic, shoulders
        {297525,297529},},--Mythic, helm


--TransmogSets: setID 5448 (Voidspire, Paladin, Mythic) C_TransmogSet.GetSetPrimaryAppearances does not return the boots (sourceID: 296167).


[5372]={{301586,301582},--Elaborate Golden mageweave, chest
        {301586,301590},--Elaborate Golden mageweave, chest
        {301586,301594},--Elaborate Golden mageweave, chest
        {301607,301613},},--Elaborate Golden mageweave, pants

[5369]={{301585,301589},--Elaborate Black mageweave, chest
        {301585,301593},--Elaborate Black mageweave, chest
        {301585,301597},--Elaborate Black mageweave, chest
        {301606,301610},},--Elaborate Black mageweave, pants

[5370]={{301584,301588},--Elaborate Lavender mageweave, chest
        {301584,301592},--Elaborate Lavender mageweave, chest
        {301584,301596},--Elaborate Lavender mageweave, chest
        {301607,301611},},--Elaborate Lavender mageweave, pants

[5371]={{301583,301587},--Elaborate Ruby mageweave, chest
        {301583,301591},--Elaborate Ruby mageweave, chest
        {301583,301595},--Elaborate Ruby mageweave, chest
        {301608,301612},},--Elaborate Ruby mageweave, pants

[5165]={{295505,295506},},--Lightstrider's Raiment, chest/robe
[5164]={{295495,295496},},--Voidstrider's Raiment, chest/robe
}

function AddToCollection(isTransmogrifier)
  for i = 1, #db do
    if (C_TransmogCollection.GetSourceInfo(db[i][8][1])) then --checks if this is an actual set. Only needed for checking sets that are only viewable on the ptr but not yet live.
      app.AddDBLineToTables(db[i], expansionID, isTransmogrifier);
    end
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
app.altPatchID[expansionID+1] = altPatchID;
app.addedAppearance[expansionID+1] = addedAppearance;
app.isRaidSet[expansionID+1] = isRaidSet;
app.altLabelAppendDB[expansionID+1] = altLabelAppendDB;
app.neverObtainDB[expansionID+1] = neverObtainDB;

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