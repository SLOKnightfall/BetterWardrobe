local app = select(2,...);

local expansionID = 6;

----Legion Remix things to check
--setID 5303 (Cloth, Forgotten Conservatory Clothes), updated ClassMask
--setID 4439 (leather) the duplicate and dead Barkbinds

--289601

--Name, Description, Label, classMask, patchID, sources, requiredFact
----classMask:    (35=Plate, 68=Mail, 3592=Leather, 400=Cloth)
local db = {
{7000010,"Legion_ShatariDefense",nil,nil,"Legion_EredarArmor",35,70297,{67082,67083,67084,67085,67086,67087,67088,67089,}},

{7000011,"Legion_AugariWakener",nil,nil,"Legion_EredarArmor",400,70297,{90817,90818,90819,90820,90821,90822,90823,90824,}},

--Illidari
{7000009,"Legion_IllidariSilver",nil,nil,"Legion_DHStarter",2048,69999,{76664,76665,76667,76668,76669,76670,76671,}},
{7000008,"Legion_IllidariGold",nil,nil,"Legion_DHStarter",2048,69999,{60974,73967,60973,60970,60972,60971,60966,}},


--Crafted Plate
{7000007,"Legion_Leystone",nil,nil,"Legion_Set5",35,70000.5,{80888,80890,80885,80892,80887,80891,80889,80886,}},
--Crafted Mail
{7000006,"Legion_Battlebound",nil,nil,"Legion_Set5",68,70000.5,{80880,80882,{80877,289604},80884,80879,80883,80881,80878,}},
--Crafted Leather
{7000005,"Legion_Warhide",nil,nil,"Legion_Set5",3592,70000.5,{80872,80874,80869,80876,80871,80875,80873,80870,}},
--Crafted Cloth
{7000004,"Legion_Silkweave",nil,nil,"Legion_Set5",400,70000.5,{80864,80866,80861,80868,80863,80867,80865,80862,}},

--Leveling Plate
{7000003,"Legion_Demonsteel",nil,nil,"Legion_Set4",35,70000.4,{80856,80858,80853,83056,80855,80859,80857,80854,}},

--Leveling Mail
{7000002,"Legion_Gravenscale",nil,nil,"Legion_Set3",68,70000.3,{80848,80850,80845,80852,80847,80851,80849,80846,}},

--Leveling Leather
{7000012,"Dreadleather",nil,nil,"Legion_Set3",3592,70000.3,{{80837,289603},80842,80843,80841,80840,80838,80844,80839,{72301,72295}}},

--Leveling Cloth
{7000001,"Legion_ImbuedSilkweave",nil,nil,"Legion_Set3",400,70000.3,{80832,80834,{80829,289602},80836,80831,80835,80833,80830,}},
};

local function comp(a,b)
  if a[1] < b[1] then return true; else return false end
end
table.sort(db,comp);

--Used to add alternate appearances to blizzard sets
--SetID, OriginalSourceID, AlternateApperanceID
local altAppearancesDB = {
[321]={{81561,82860},},--Nighthold, Mythic, Warlock, cloak
[996]={{81095,81045},},--Nighthold, Mythic, Druid, cloak
[980]={{81548,80918},},--Nighthold, Mythic, paladin, cloak
[998]={{81540,86904},},--Nighthold, normal, DH, cloak
[999]={{82535,81826},--Nighthold, Heroic, DH, cloak
       {81176,85960},},--Nighthold, DH, heroic, thick shoes.

[942]={{84554,83008},},--Nighthold, Rogue, Normal, cloak

[994]={{80486,79557},},--Nighthold, Druid, Normal, cloak

[2323]={{168308,168312},},--Twisted Arcanum, Cloth, Robes/chest

[1469]={{89366,89232},}, --Seat of the Triumvirate, Mail, Chest/Robe

[936]={{81072,81901},}, --Nighthold, Mail/Shaman, Chest/Robe (LFR)
[935]={{79882,81900},}, --Nighthold, Mail/Shaman, Chest/Robe (Mythic)
[933]={{79880,81898},}, --Nighthold, Mail/Shaman, Chest/Robe (Normal)
[934]={{79881,81899},}, --Nighthold, Mail/Shaman, Chest/Robe (Heroic)

[978]={{79892,113019},}, --Nighthold, Plate/Paladin, Chest/Robe (Normal)

[1284]={{85170,168228},},--Cloth Season3/4,Combatant 1 blue shoulders
[1272]={{85266,168228},},--Cloth Season3/4,Combatant 1 blue shoulders
[1278]={{85218,168228},},--Cloth Season3/4,Combatant 1 blue shoulders

[4485]={{289204,86044},--Cloth, Legion_BrokenShore, Riven shoulders
        {289532,289205},},--Cloth, Legion_BrokenShore, Riven chest/robes --remix
[4330]={{86002,289127},--Cloth, Legion_BrokenShore, Vileweave shoulders
        {86000,289126},},--Cloth, Legion_BrokenShore, Vileweave chest/robes --remix
[4416]={{84582,288913},--Cloth, Legion_BrokenShore, Raiment of Night Eternal shoulders ---raven 288913, eye 84582
        {84590,288912},},--Cloth, Legion_BrokenShore, Raiment of Night Eternal chest/robes


[4415]={{80004,80034},},--Cloth, Sanguine Oath Vestments, chest/robe
[4414]={{79062,78949},},--Cloth, Vesture of Borrowed Souls, chest/robe
[4427]={{288458,288457},},--Cloth, Blazing Dreamscribed Robes, chest/rob ---chest 288458, robe 288457
[4491]={{168787,146751},},--Cloth, Verdant Dreamscribed Robes, chest/robe

[4432]={{231323,231319},--Cloth,Skyrune Robes, cowl/headband ---headband 231323, cowl 231319
        {231650,231320},--Cloth,Skyrune Robes, pants/skirt ---skirt 231650, pants 231320
        {231290,231289},},--Cloth,Skyrune Robes, chest/robes ---231289 chest,231290 robes, 231655 shirt
[4430]={{288631,289595},--Cloth, Nightrune Robes, cowl/headband
        {288630,288462},--Cloth, Nightrune Robes, pants/skirt
        {288633,288627},},--Cloth, Nightrune Robes, chest/robe
[4431]={{112844,289594},--Cloth, Earthrune Robes, cowl/headband
        {288619,288460},--CLoth, Earthrune Robes, pants/skirt
        {288624,288616},},--Cloth, Earthrune Robes, chest/robe

[4406]={{72286,72277},},--Leather, Set 3, Green, Cloak
[4408]={{72286,72277},},--Mail, Set 3, Green, Cloak

[4417]={{79107,78686},},--Letaher, Set 4, Dark, Cloak
[4418]={{78989,78687},},--Leather, Set 4, Red, Cloak

[4407]={{72289,72280},},--Leather, Set 3, Sky, Cloak
[4405]={{72298,72292},},--Leather, Set 3, Purple, Cloak
[4410]={{72298,72292},},--Mail, Set 3, Purple, Cloak

--mail Legion_Argus
[4459]={{288488,288482},},--Original, chest/robes
--cloth Legion_Argus
[4481]={{288351,289261},},--Doomsinger's, chest/robes --remix
[4489]={{289148,289149},},--Doomsinger's, chest/robes --remix

[4402]={{68478,289093},},--Cloth, Legion Set 3, Vestemnts of the Manasinged/Blue, robes/chest --remix
[4404]={{68425,289014},},--Cloth, Legion Set 3, Moonfall Robes/Orange, robes/chest --remix
[4403]={{83025,289023},},--Cloth, Legion Set 3, Seawitch's terrorcloth/teal, robes/chest --remix

[4405]={{77634,289004},},--Leather, Legion Set 3, Battlegear of the Dreadhide Stalker, chest/robes --remix
[4406]={{83067,288995},},--Leather, Legion Set 3, Nighthide Coat, chest/robes --remix
[4407]={{68395,81347},},--Leather, Legion Set 3, Ambervale Bonehide, chest/robe

[4465]={{288359,289293},},--Cloth, Legion Set 2, Regalia of the Hrydshal Runespeaker/blue, robes/chest --remix
[4466]={{68372,68560},},--Cloth, Legion Set 2, Crescent Vale Raiment/green, robes/chest
[4467]={{76020,289277},},--Cloth, Legion Set 2, Wine-dark Royal Robes/red, robes/chest --remix
[4468]={{68585,289269},},--Cloth, Legion Set 2, Leyline Scholar's Regalia/white, robes/chest --remix

[4473]={{76349,288355},--Mail, Legion Set 2, Dreadthorn Battlegear/black, chest/robes --remix
        {76382,289597},},--Mail, Legion Set 2, Dreadthorn Battlegear/black, pants/skirt --remix
[4474]={{80325,288354},--Mail, Legion Set 2, Scales of Remembered Eternity/gold, chest/robes --remix
        {73837,81620},},--Mail, Legion Set 2, Scales of Remembered Eternity/gold, pants/skirt
[4475]={{73848,288353},--Mail, Legion Set 2, Stormborn Laminar Armor/silver, chest/robes --remix
        {68312,289599},},--Mail, Legion Set 2, Stormborn Laminar Armor/silver, pants/skirt --remix
[4476]={{76013,288352},--Mail, Legion Set 2, Highmountain Riverscales/teal, chest/robes --remix
        {78319,289600},},--Mail, Legion Set 2, Highmountain Riverscales/teal, pants/skirt --remix

[4483]={{90950,289533},},--Mail, Legion_Argus, Oronaar Disciple's/white gold, chest/robes --remix
}

----Added appearance
local addedAppearance = {
[1505] = {100761},--Leather, Antorus, Rogue, Heroic, Shoes
[1506] = {168318},--Leather, Antorus, Rogue, Mythic, Shoes

[4416] = {84582},--Cloth, Legion_BrokenShore, Raimnet of Night Eternal/Purple, Shoulders
[4431] = {231655},--Cloth, Set 1, Skyrune Robes/Light, Shirt

[4411] = {288950},--Plate, Legion Set 4, Suramar Silver, wrists

[4473] = {289193},--Mail, Set 2, Dreadthorn Battlegear/Black, cloak
[4475] = {185419},--Mail, Set 2, Stormborn Laminar/Silver, cloak

[4407] = {72289},--Leather, Set 3, Sky, cloak
}

local replaceAppearance = {
[4477] = {{289252,68222},},--Plate, Set 1, Blue Shoulders
[4478] = {{289244,68169},},--Plate, Set 1, Gold shoulders
[4423] = {{288851,79939},},--Plate, Set 2, Dark wrist
[4412] = {{288947,68381},},--Plate, Set 4, blue shoulder
[4488] = {{289212,86018},},--Plate, Broken Shore, Copper shoulder
[4490] = {{289132,89210},},--Plate, Argus, Holy, Pants

[4421] = {{288867,80118},},--Mail, Set 1, Purple, wrist
[4475] = {{289357,68313},},--Mail, Set 2, Silver, shoulder
[4476] = {{289172,289179},},--Mail, Set 2, Highmountain Riverscales/Teal, cloak
[4487] = {{289381,86036},},--Mail,Broken Shore,Yellow,shoulder
[4400] = {{289108,85988},},--Mail,Broken Shore,Normal,waist
[4483] = {{289373,90617},},--Mail,Argus,White Gold,shoulder

[4472] = {{289317,68184},},--Leather,Set 1,Light, shoulder
[4471] = {{289309,68343},},--Leather,Set 1,Green, shoulder
[4442] = {{288527,100595},},--Leather,Set 2,Teal,helm

[4465] = {{289292,68321},},--Cloth,Set 2,Blue, Shoulder
[4466] = {{289284,68374},},--Cloth,Set 2,Green,Shoulder
[4468] = {{289268,68215},},--Cloth,Set 2,White,Shoulder
[4402] = {{289092,68478},},--Cloth,Set 3,Blue,chest  -------------------Check alt appearance is working

[999] = {{81541,82535},},--Nighthold DH heroic cloak

[942] = {{83008,84554},},--Nighthold, Rogue, Normal, cloak
}

local isRaidSet = {
[171]=true,
[172]=true,
[173]=true,
[174]=true,
[175]=true,
[176]=true,
[177]=true,
[178]=true,
[179]=true,
[180]=true,
[181]=true,
[182]=true,
[183]=true,
[184]=true,
[185]=true,
[186]=true,
[308]=true,
[309]=true,
[311]=true,
[315]=true,
[316]=true,
[321]=true,
[322]=true,
[933]=true,
[934]=true,
[935]=true,
[936]=true,
[937]=true,
[938]=true,
[939]=true,
[940]=true,
[941]=true,
[942]=true,
[943]=true,
[944]=true,
[945]=true,
[978]=true,
[979]=true,
[980]=true,
[981]=true,
[982]=true,
[983]=true,
[984]=true,
[985]=true,
[986]=true,
[987]=true,
[988]=true,
[989]=true,
[990]=true,
[991]=true,
[992]=true,
[993]=true,
[994]=true,
[995]=true,
[996]=true,
[997]=true,
[998]=true,
[999]=true,
[1000]=true,
[1001]=true,
[1002]=true,
[1003]=true,
[1004]=true,
[1005]=true,
[1293]=true,
[1294]=true,
[1295]=true,
[1296]=true,
[1297]=true,
[1298]=true,
[1299]=true,
[1300]=true,
[1301]=true,
[1302]=true,
[1303]=true,
[1304]=true,
[1305]=true,
[1306]=true,
[1307]=true,
[1308]=true,
[1309]=true,
[1310]=true,
[1312]=true,
[1313]=true,
[1314]=true,
[1315]=true,
[1316]=true,
[1317]=true,
[1318]=true,
[1319]=true,
[1320]=true,
[1321]=true,
[1322]=true,
[1323]=true,
[1324]=true,
[1325]=true,
[1326]=true,
[1327]=true,
[1328]=true,
[1329]=true,
[1330]=true,
[1331]=true,
[1332]=true,
[1333]=true,
[1334]=true,
[1335]=true,
[1336]=true,
[1337]=true,
[1338]=true,
[1339]=true,
[1340]=true,
[1342]=true,
[1457]=true,
[1458]=true,
[1459]=true,
[1472]=true,
[1473]=true,
[1474]=true,
[1475]=true,
[1476]=true,
[1477]=true,
[1478]=true,
[1479]=true,
[1480]=true,
[1481]=true,
[1482]=true,
[1483]=true,
[1484]=true,
[1485]=true,
[1486]=true,
[1487]=true,
[1488]=true,
[1489]=true,
[1490]=true,
[1491]=true,
[1492]=true,
[1493]=true,
[1494]=true,
[1495]=true,
[1496]=true,
[1497]=true,
[1498]=true,
[1499]=true,
[1500]=true,
[1501]=true,
[1502]=true,
[1503]=true,
[1504]=true,
[1505]=true,
[1506]=true,
[1507]=true,
[1508]=true,
[1509]=true,
[1510]=true,
[1511]=true,
[1512]=true,
[1513]=true,
[1514]=true,
[1515]=true,
[1516]=true,
[1517]=true,
[1518]=true,
[1519]=true,

}


local altPatchID = {
--legion remix achieves
[5286] = 70400,--Kaldorei Queen's Royal Vestments (campaign) --bumping to end of legion
[5280] = 70401,--Sargerei Commander's Hellforged Regalia (m+)
[5279] = 70401,--Sargerei Commander's Lightbound Regalia (raid)
[5278] = 70401,--Sargerei Commander's Felscorned Regalia (quest)
[5281] = 70401,--Sargerei Commander's Voidscarred Regalia (heroic world)

  --mage tower
[2302] = 70200, --rogue
[2295] = 70200, --dh
[2296] = 70200, --druid
[2299] = 70200, --monk
[2301] = 70200, --priest
[2298] = 70200, --mage
[2304] = 70200, --warlock
[2303] = 70200, --shaman
[2297] = 70200, --hunter
[2305] = 70200, --warrior
[2294] = 70200, --dk
[2300] = 70200, --paladin

--plate
--set 1
[4477] = 70000.1,--Thunderpeak Boneguards
[4478] = 70000.1,--Nar'thalas Graduate's Trim
[4479] = 70000.1,--Kal'delar Battleplate
[4480] = 70000.1,--Brykul Funereal
--set 2
[4453] = 70000.2,--Storm Champion's Warharness
[4454] = 70000.2,--Bal'kyrs Warharness
[4424] = 70000.2,--Bloodforged Battleplate
[4423] = 70000.2,--Honorforged Valorplate
--set 3
[2679] = 70000.3,--Helarjar Berserker Warplate
[4248] = 70000.3,--Drekirjar Warrior's Battlegear
[5270] = 70000.3,--Tidesoaked Champion's Battlegear
--set 4
[4412] = 70000.4,--Jandvik diver's metal
[4413] = 70000.4,--Leyline Defender's Sunplate
--set 5
[2656] = 70000.5,--Dream Defender's Emerald Guardplate

[4452] = 70100,--Jarl's Battlehorns
--Legion_BrokenShore
[4425] = 70199,--Nightforged Felplate
[4488] = 70199,--Moonshatter Warplate
[4401] = 70199,--Xorothian Plate
--Legion_Argus
[4484] = 70299,
[4460] = 70299,
[4490] = 70299,
[1468] = 70299,


--mail
[4487] = 70199, --Legion_BrokenShore(mail)
[4422] = 70199, --Legion_BrokenShore(mail)
[4400] = 70199, --Legion_BrokenShore(mail)
--Legion Mail Set 5
[2658] = 70000.5, --Fel-marked Scales (mail)
--Legion Mail Set 4
[4450] = 70000.4,--Firewurm Dragonscale
[4449] = 70000.4,--Earthbreaker Dragonscale
[4448] = 70000.4,--Dreamweald Dragonscale
[4447] = 70000.4,--Highpeak Dragonscale
[2654] = 70000.4,--Glorious Dragonrider's Mail
--Legion Mail Set 3
[4408] = 70000.3,--Chains of Nightmare's Embrace
[4409] = 70000.3,--Chains of Helheim
[4410] = 70000.3,--Darkwatcher Bindings
--Legion Mail Set 2
[4473] = 70000.2,--Dreadthorn Battlegear
[4474] = 70000.2,--Scales of Remembered Eternity
[4475] = 70000.2,--Stormborn Laminar
[4476] = 70000.2,--Highmountain Riverscales
--Legion Mail Set 1
[4444] = 70000.1,--Ruby Drake Hunter's Kit
[4492] = 70000.1,--Emerald Drake Hunter's Kit
[4421] = 70000.1,--Ravensteel Mail
[4420] = 70000.1,--Armor of the Skyfather's Chosen
[4247] = 70000.1,--Drake Hunter's Kit

[4443] = 70100,--Jarl's Battlescales
--Legion_Argus
[4483] = 70299,
[4459] = 70299,

[2331] = 70100,--Battlewraps of the Honored Valarjar

--leather
--set 1
[4469] = 70000.1,--Highmountain Hides
[4470] = 70000.1,--Haustvelt Leathers
[4471] = 70000.1,--Sablehide Vestments
[4472] = 70000.1,--Llothien Prowler's Kit
--set 2
[4440] = 70000.2,--Skyborne Brigandine
[4442] = 70000.2,--Seaborne Brigandine
[2678] = 70000.2,--kvaldir scout
--set 3
[4406] = 70000.3,--Nighthide Coat
[4405] = 70000.3,--Battlegear of the Dreadhide Stalker
[4407] = 70000.3,--Ambervale Bonehide
--set 4
[4418] = 70000.4,--Thirsting hides
[4417] = 70000.4,--Bindings of Hungering Flesh
[4436] = 70000.4,--Searaider's Battlegarb
[4437] = 70000.4,--Gladeraider's Battlegarb
[2657] = 70000.4,--Sylvan Stalker's
--set 6
[4434] = 70000.6,--Slayer's Silver
[4433] = 70000.6,--Slayer's Golden
--set 7
[4435] = 70000.7,--Fel-bloodied Battlegear
--set 8
[2337] = 70000.8,--Barkbinds of the Archdruid's Nightmare
--Legion_BrokenShore
[4419] = 70200,--guise of the nightstalker
[4486] = 70200,--lunarblight leathers
[4399] = 70200,--netherfiend battlegear
--Legion_Argus
[4482] = 70299,--Arinor Keeper's Leather Armor
[4457] = 70299,--Legion_Argussian Demonsbane Armor
[4458] = 70299,--Stygian Hides

[2334] = 70100,--Battlewraps of the Honored Valarjar

--cloth
[2321] = 70100,--Trial of Valor Trading Post
--set 1
[4430] = 70000.1,--Nightrune Robes
[4431] = 70000.1,--Earthrune Robes
[4432] = 70000.1,--Skyrune Robes
[2655] = 70000.1,--Corrupted Runelord's
--set 2
[4465] = 70000.2,--Regalia of the Hrydshal Runespeaker
[4466] = 70000.2,--Crescent Vale Raiment
[4467] = 70000.2,--Wine-dark Royal Robes
[4468] = 70000.2,--Lyeline Scholar's Regalia
--set 3
[4402] = 70000.3,--Vestments of the Manasinged
[4404] = 70000.3,--Moonfall Robes
[4403] = 70000.3,--Seawitche's Terrorcloth
--set 4
[4415] = 70000.4,--Sanguine Oath Vestments
[4414] = 70000.4,--Vesture of Borrowed Souls
[4427] = 70000.4,--Blazing Dreamscribed Robes
[4491] = 70000.4,--Verdant Dreamscribed Robes
--set 5
[4428] = 70000.5,--Dreamwatcher Vestments
[4429] = 70000.5,--Dreamseeker Vestments
--Legion_BrokenShore
[4485] = 70199,--Riven Priesthood Regalia
[4416] = 70199,--Raiment of Night Eternal
[4330] = 70199,--Vileweave Vestments
--Legion_Argus
[4481] = 70299,--Doomsinger's Cloth Armor
[4489] = 70299,--Stygian Silks

[2323] = 70002,--Twisted Arcanum (Mage Nighthold TP var)
}

local altLabelDB = {
[5286] = app.GetLocalizedString("Legion_KaldoreiQueen"),--Kaldorei Queen's Royal Vestments (campaign)

--plate
[4477] = app.GetLocalizedString("Legion_Set1"),--Thunderpeak Boneguards
[4478] = app.GetLocalizedString("Legion_Set1"),--Nar'thalas Graduate's Trim
[4479] = app.GetLocalizedString("Legion_Set1"),--Kal'delar Battleplate
[4480] = app.GetLocalizedString("Legion_Set1"),--Brykul Funereal
[4453] = app.GetLocalizedString("Legion_Set2"),--Storm Champion's Warharness
[4454] = app.GetLocalizedString("Legion_Set2"),--Bal'kyrs Warharness
[4424] = app.GetLocalizedString("Legion_Set2"),--Bloodforged Battleplate
[4423] = app.GetLocalizedString("Legion_Set2"),--Honorforged Valorplate
[2679] = app.GetLocalizedString("Legion_Set3"),--Helarjar Berserker Warplate
[4248] = app.GetLocalizedString("Legion_Set3"),--Drekirjar Warrior's Battlegear
[5270] = app.GetLocalizedString("Legion_Set3"),--Tidesoaked Champion's Battlegear
[4412] = app.GetLocalizedString("Legion_Set4"),--Jandvik diver's metal
[4413] = app.GetLocalizedString("Legion_Set4"),--Leyline Defender's Sunplate
[4411] = app.GetLocalizedString("Legion_Set4"),--Suramar Silver Plating
[2656] = app.GetLocalizedString("Legion_Set5"),--Dream Defender's Emerald Guardplate
[4452] = app.GetLocalizedString("Legion_Valhallas"),--Jarl's Battlehorns
[4401] = app.GetLocalizedString("Legion_BrokenShore"),--Xorothian Plate Armor
[4425] = app.GetLocalizedString("Legion_BrokenShore"),--Nightforged Felplate
[4488] = app.GetLocalizedString("Legion_BrokenShore"),--Moonshatter Warplate
[4460] = app.GetLocalizedString("Legion_Argus"),--Antoran Guard's Golden Battleplate
[4484] = app.GetLocalizedString("Legion_Argus"),--Praetorium Guard's Plate Armor
[4490] = app.GetLocalizedString("Legion_Argus"),--Garothi Battleplate
[1468] = app.GetLocalizedString("Legion_Argus"),--Venerated Triumvirate Battleplate
[5304] = app.GetLocalizedString("Legion_EredarArmor"),--Triumvirate High Guard's
[5302] = app.GetLocalizedString("Legion_EredarArmor"),--Eredath Lightseeker's

--mail
[4444] = app.GetLocalizedString("Legion_Set1"),--Ruby Drake Hunter's Kit
[4492] = app.GetLocalizedString("Legion_Set1"),--Emerald Drake Hunter's Kit
[4421] = app.GetLocalizedString("Legion_Set1"),--Ravensteel Mail
[4420] = app.GetLocalizedString("Legion_Set1"),--Armor of the Skyfather's Chosen
[4247] = app.GetLocalizedString("Legion_Set1"),--Drake Hunter's Kit
[4473] = app.GetLocalizedString("Legion_Set2"),--Dreadthorn Battlegear5
[4474] = app.GetLocalizedString("Legion_Set2"),--Scales of Remembered Eternity5
[4475] = app.GetLocalizedString("Legion_Set2"),--Stormborn Laminar5
[4476] = app.GetLocalizedString("Legion_Set2"),--Highmountain Riverscales5
[4408] = app.GetLocalizedString("Legion_Set3"),--Chains of Nightmare's Embrace4
[4409] = app.GetLocalizedString("Legion_Set3"),--Chains of Helheim4
[4410] = app.GetLocalizedString("Legion_Set3"),--Darkwatcher Bindings4
[4450] = app.GetLocalizedString("Legion_Set4"),--Firewurm Dragonscale2
[4449] = app.GetLocalizedString("Legion_Set4"),--Earthbreaker Dragonscale2
[4448] = app.GetLocalizedString("Legion_Set4"),--Dreamweald Dragonscale2
[4447] = app.GetLocalizedString("Legion_Set4"),--Highpeak Dragonscale2
[2654] = app.GetLocalizedString("Legion_Set4"),--Glorious Dragonrider's Mail
[2658] = app.GetLocalizedString("Legion_Set5"),--Fel-marked Scales3
[4443] = app.GetLocalizedString("Legion_Valhallas"),--Jarl's Battlescales
[4400] = app.GetLocalizedString("Legion_BrokenShore"),--Ered'ruin Scalemail
[4422] = app.GetLocalizedString("Legion_BrokenShore"),--Scalemail of Devouring Night
[4487] = app.GetLocalizedString("Legion_BrokenShore"),--Shinebreaker
[4459] = app.GetLocalizedString("Legion_Argus"),--Vestments of Eredathian Sacrifice
[4483] = app.GetLocalizedString("Legion_Argus"),--Oronaar Disciple's Mail Armor
[1469] = app.GetLocalizedString("Legion_Argus"),--Sterling Triumvirate Chainmail

[4327] = app.GetLocalizedString("Legion_KarazhanScavenged"),--Scavenged Chains of Karazhan

--leather
[4469] = app.GetLocalizedString("Legion_Set1"),--Highmountain Hides
[4470] = app.GetLocalizedString("Legion_Set1"),--Haustvelt Leathers
[4471] = app.GetLocalizedString("Legion_Set1"),--Sablehide Vestments
[4472] = app.GetLocalizedString("Legion_Set1"),--Llothien Prowler's Kit
[4440] = app.GetLocalizedString("Legion_Set2"),--Skyborne Brigandine
[4442] = app.GetLocalizedString("Legion_Set2"),--Seaborne Brigandine
[2678] = app.GetLocalizedString("Legion_Set2"),--kvaldir scout
[4406] = app.GetLocalizedString("Legion_Set3"),--Nighthide Coat
[4405] = app.GetLocalizedString("Legion_Set3"),--Battlegear of the Dreadhide Stalker
[4407] = app.GetLocalizedString("Legion_Set3"),--Ambervale Bonehide
[4418] = app.GetLocalizedString("Legion_Set4"),--Thirsting hides
[4417] = app.GetLocalizedString("Legion_Set4"),--Bindings of Hungering Flesh
[4436] = app.GetLocalizedString("Legion_Set4"),--Searaider's Battlegarb
[4437] = app.GetLocalizedString("Legion_Set4"),--Gladeraider's Battlegarb
[2657] = app.GetLocalizedString("Legion_Set5"),--Sylvan Stalker's
[4434] = app.GetLocalizedString("Legion_Set6"),--Slayer's Silver
[4433] = app.GetLocalizedString("Legion_Set6"),--Slayer's Golden
[4435] = app.GetLocalizedString("Legion_Set7"),--Fel-bloodied Battlegear
[2337] = app.GetLocalizedString("Legion_Set8"),--Barkbinds of the Archdruid's Nightmare
[4419] = app.GetLocalizedString("Legion_BrokenShore"),--Guise of the Nightstalker
[4486] = app.GetLocalizedString("Legion_BrokenShore"),--Lunarblight Leathers
[4399] = app.GetLocalizedString("Legion_BrokenShore"),--Netherfiend Battlegear
[4457] = app.GetLocalizedString("Legion_Argus"),--Legion_Argussian Demonsban
[4482] = app.GetLocalizedString("Legion_Argus"),--Arinor Keeper's Leather Armor
[4458] = app.GetLocalizedString("Legion_Argus"),--Stygian Hides
[1470] = app.GetLocalizedString("Legion_Argus"),--Burnished Triumvirate Armor

--cloth
[4430] = app.GetLocalizedString("Legion_Set1"),--Nightrune Robes
[4431] = app.GetLocalizedString("Legion_Set1"),--Earthrune Robes
[4432] = app.GetLocalizedString("Legion_Set1"),--Skyrune Robes
[2655] = app.GetLocalizedString("Legion_Set1"),--Corrupted Runelord's
[4465] = app.GetLocalizedString("Legion_Set2"),--Regalia of the Hrydshal Runespeaker
[4466] = app.GetLocalizedString("Legion_Set2"),--Crescent Vale Raiment
[4467] = app.GetLocalizedString("Legion_Set2"),--Wine-dark Royal Robes
[4468] = app.GetLocalizedString("Legion_Set2"),--Lyeline Scholar's Regalia
[4402] = app.GetLocalizedString("Legion_Set3"),--Vestments of the Manasinged
[4404] = app.GetLocalizedString("Legion_Set3"),--Moonfall Robes
[4403] = app.GetLocalizedString("Legion_Set3"),--Seawitche's Terrorcloth
[4415] = app.GetLocalizedString("Legion_Set4"),--Sanguine Oath Vestments
[4414] = app.GetLocalizedString("Legion_Set4"),--Vesture of Borrowed Souls
[4427] = app.GetLocalizedString("Legion_Set4"),--Blazing Dreamscribed Robes
[4491] = app.GetLocalizedString("Legion_Set4"),--Verdant Dreamscribed Robes
[4428] = app.GetLocalizedString("Legion_Set5"),--Dreamwatcher Vestments
[4429] = app.GetLocalizedString("Legion_Set5"),--Dreamseeker Vestments
[4485] = app.GetLocalizedString("Legion_BrokenShore"),--Riven Priesthood Regalia
[4416] = app.GetLocalizedString("Legion_BrokenShore"),--Raiment of Night Eternal
[4330] = app.GetLocalizedString("Legion_BrokenShore"),--Vileweave Vestments
[4481] = app.GetLocalizedString("Legion_Argus"),--Doomsinger's Cloth Armor
[1471] = app.GetLocalizedString("Legion_Argus"),--Light-woven Triumvirate
[4489] = app.GetLocalizedString("Legion_Argus"),--Stygian Silks
[5303] = app.GetLocalizedString("Legion_EredarArmor"),--Forgotten Conservatory Clothes
[5301] = app.GetLocalizedString("Legion_FelLord"),--Zealous Felslingers Battle Armor
[2323] = app.GetLocalizedString("Legion_NightholdTP"),--Twisted Arcanum Regalia
}

local altNoteDB = {
[4248]=app.GetLocalizedString("Timewalking"),--Drekirjar Warrior's (plate)
[2334] = app.GetTradingPostReleaseString("Feb",2024),--Honored Valajar (leather), TP release
[2657] = app.GetTradingPostReleaseString("Jul",2023),--Sylvan Stalker's (leather), TP release
[2679] = app.GetTradingPostReleaseString("Jun",2023),--Helarjar (Plate), TP release
[2321] = app.GetTradingPostReleaseString("May",2023),--Valarjar (Cloth), TP release
[2655] = app.GetTradingPostReleaseString("Apr",2023),--Corrupted Runelord's, TP release
[2654] = app.GetTradingPostReleaseString("Mar",2023),--Glorious Dragonrider's (mail), TP release
}

local neverObtainDB = {
[2331] = true, --Chains of the Honored Valarjar, mail, blue
[2343] = true, --Battleplate of the Honored Valarjar, plate, puke-green
}

local setsFlagRemix = {
--Nighthold, DK
[1005] = 32,
[1002] = 32,
[1003] = 32,
[1004] = 32,
--Nighthold, Paladin
[981] = 2,
[978] = 2,
[979] = 2,
[980] = 2,
--Nighthold, Warrior
[940] = 1,
[937] = 1,
[938] = 1,
[939] = 1,
--Nighthold, Hunter
[993] = 4,
[990] = 4,
[991] = 4,
[992] = 4,
--Nighthold, Shaman
[936] = 64,
[933] = 64,
[934] = 64,
[935] = 64,
--Nighthold, DH
[1001] = 2048,
[998] = 2048,
[999] = 2048,
[1000] = 2048,
--Nighthold, Druid
[997] = 1024,
--994, was generic
[995] = 1024,
[996] = 1024,
--Nighthold, Monk
[985] = 512,
[982] = 512,
[983] = 512,
[984] = 512,
--Nighthold, Rogue
[945] = 8,
--942, was generic
[943] = 8,
[944] = 8,
--Nighthold, Mage
[989] = 128,
[986] = 128,
[987] = 128,
[988] = 128,
--Nighthold, Priest
--322, was generic
[308] = 16,
[309] = 16,
[311] = 16,
--Nighthold, Warlock
[941] = 256,
[315] = 256,
[316] = 256,
[321] = 256,

--Tomb of Sargeras, DK
[1339]=32,
[1337]=32,
[1340]=32,
[1338]=32,
--Tomb of Sargeras, Paldin
[1315]=2,
[1313]=2,
[1316]=2,
[1314]=2,
--Tomb of Sargeras, Warrior
[1296]=1,
[1293]=1,
[1294]=1,
[1295]=1,
--Tomb of Sargeras, Hunter
[1327]=4,
[1325]=4,
[1328]=4,
[1326]=4,
--Tomb of Sargeras, Shaman
[1302]=64,
[1301]=64,
[1303]=64,
[1304]=64,
--Tomb of Sargeras, DH
[1335]=2048,
[1333]=2048,
[1336]=2048,
[1334]=2048,
--Tomb of Sargeras, Druid
[1331]=1024,
[1329]=1024,
[1332]=1024,
[1330]=1024,
--Tomb of Sargeras, Monk
[1319]=512,
[1317]=512,
[1320]=512,
[1318]=512,
--Tomb of Sargeras, Rogue
[1306]=8,
[1305]=8,
[1307]=8,
[1308]=8,
--Tomb of Sargeras, Mage
[1323]=128,
[1321]=128,
[1324]=128,
[1322]=128,
--Tomb of Sargeras, Priest
[1342]=16,
[1309]=16,
[1312]=16,
[1310]=16,
--Tomb of Sargeras, Warlock
[1300]=256,
[1297]=256,
[1298]=256,
[1299]=256,

--Antorus, DK
[1475]=32,
[1472]=32,
[1473]=32,
[1474]=32,
--Antorus, Paldin
[1499]=2,
[1496]=2,
[1497]=2,
[1498]=2,
--Antorus, Warrior
[1519]=1,
[1516]=1,
[1517]=1,
[1518]=1,
--Antorus, Hunter
[1487]=4,
[1484]=4,
[1485]=4,
[1486]=4,
--Antorus, Shaman
[1511]=64,
[1508]=64,
[1509]=64,
[1510]=64,
--Antorus, DH
[1479]=2048,
[1476]=2048,
[1477]=2048,
[1478]=2048,
--Antorus, Druid
[1483]=1024,
[1480]=1024,
[1481]=1024,
[1482]=1024,
--Antorus, Monk
[1495]=512,
[1492]=512,
[1493]=512,
[1494]=512,
--Antorus, Rogue
[1507]=8,
[1504]=8,
[1505]=8,
[1506]=8,
--Antorus, Mage
[1491]=128,
[1488]=128,
[1489]=128,
[1490]=128,
--Antorus, Priest
[1503]=16,
[1500]=16,
[1501]=16,
[1502]=16,
--Antorus, Warlock
[1515]=256,
[1512]=256,
[1513]=256,
[1514]=256,


--plate
[4454] = true,--Val'kyr's Warharness
[4460] = true,--Antoran Guard's Golden
[4453] = true,--Storm Champion's
[5270] = true,--tidesoaked champion's
[4452] = true,--jarl's battlehorns
[4456] = true,--winged plate of the valhalas champion
[2656] = true,--dream defender's emerald guardplate
--mail
[4450] = true,--Firewurm Dragonscale
[4449] = true,--Earthbreaker Dragonscale
[4448] = true,--Dreamweald Dragonscale
[4447] = true,--Highpeak Dragonscale
[4443] = true,--Jarl's Battlescales
[2658] = true,--Fel-marked scales
[4459] = true,--Vestments of Eredathian Sacrifice
[4444] = true,--Ruby Drake Hunter's Kit
--leather
[4434] = 2048,--Slayer's Silver (old set, was DH only, Remix gives a leather wide)
[4433] = 2048,--Slayer's Golden Scarguards (old set, was DH only, Remix gives a leather wide)
[4440] = true,--Skyborne Brigandine
[4435] = true,--Fel-Bloodied Battlegear
[2337] = true,--Barkbinds of the Archdruid's Nightmare
--[4442] = true,--Seaborne Brigandine
[4457] = true,--Legion_Argussian Demonsbane
[4436] = true,--Searaider's Battlegarb
[4437] = true,--Gladeraider's battlegarb
--[4439] are MoP druid recolors???

--cloth
[4431] = true,--Earthrune Robes
[4428] = true,--Dreamwatcher vestments
[4430] = true,--Nightrune Robes
[4429] = true,--Dreamseeker Vestments
[4432] = true,--Skyrune Robes
[4489] = true,--Stygian Silks
[4427] = true,--Blazing Dreamscribed Robes
[4491] = true,--Verdant Dreamscribed Robes
--achieves
[5280] = true,--Sargerei Commander's Hellforged Regalia (m+)
[5279] = true,--Sargerei Commander's Lightbound Regalia (raid)
[5278] = true,--Sargerei Commander's Felscorned Regalia (quest)
[5281] = true,--Sargerei Commander's Voidscarred Regalia (heroic world)
[5286] = true,--Kaldorei Queen's Royal Vestments (campaign)
--heritage
[4331] = true,--Lightforged Draenei
[4463] = true,--Lightforged Draenei
[4462] = true,--Lightforged Draenei
[4464] = true,--Nightborne
--Valhalla
}

local itemsFlagRemix = {
--Nighthold, DK
[1005]={[293416]=true,[294411]=true,[293428]=true,[293440]=true,[294591]=true,[293452]=true,[294595]=true,[293464]=true,[294603]=true,[294263]=true,[294291]=true,[294343]=true,[294583]=true,[293474]=true,[294307]=true,[294615]=true,},--The Nighthold, , Raid Finder
[1002]={[293413]=true,[294408]=true,[293437]=true,[294588]=true,[294260]=true,[294288]=true,[294340]=true,[294580]=true,[293425]=true,[294304]=true,[294612]=true,[289936]=true,[293475]=true,[293449]=true,[294592]=true,[293461]=true,[294600]=true,},--The Nighthold, , Normal
[1003]={[293450]=true,[294593]=true,[293414]=true,[294409]=true,[293438]=true,[294589]=true,[294261]=true,[294289]=true,[294341]=true,[294581]=true,[293426]=true,[293462]=true,[294601]=true,[293476]=true,[294305]=true,[294613]=true,},--The Nighthold, , Heroic
[1004]={[293451]=true,[294594]=true,[294306]=true,[294614]=true,[293439]=true,[294590]=true,[294262]=true,[294290]=true,[294342]=true,[294582]=true,[293473]=true,[293427]=true,[293415]=true,[294410]=true,[293463]=true,[294602]=true,},--The Nighthold, , Mythic
--Nighthold, Paladin
[981]={[293432]=true,[294239]=true,[293456]=true,[293468]=true,[294607]=true,[294247]=true,[294391]=true,[293496]=true,[294315]=true,[293420]=true,[294571]=true,[293444]=true,[294599]=true,},--The Nighthold, , Raid Finder
[978]={[293453]=true,[293417]=true,[294568]=true,[294244]=true,[294388]=true,[293441]=true,[294596]=true,[294312]=true,[293465]=true,[294604]=true,[294236]=true,[293429]=true,[293494]=true,},--The Nighthold, , Normal
[979]={[293430]=true,[293454]=true,[293493]=true,[293418]=true,[294569]=true,[294245]=true,[294389]=true,[293442]=true,[294597]=true,[294313]=true,[293466]=true,[294605]=true,[294237]=true,},--The Nighthold, , Heroic
[980]={[294238]=true,[293431]=true,[293455]=true,[293419]=true,[294570]=true,[294246]=true,[294390]=true,[293443]=true,[294598]=true,[293495]=true,[294314]=true,[293467]=true,[294606]=true,},--The Nighthold, , Mythic
--Nighthold, Warrior
[940]={[294299]=true,[294419]=true,[293424]=true,[293436]=true,[294575]=true,[294579]=true,[294637]=true,[293448]=true,[293460]=true,[293472]=true,[294611]=true,[294295]=true,[294587]=true,[293513]=true,},--The Nighthold, , Raid Finder
[937]={[294608]=true,[293457]=true,[293514]=true,[293421]=true,[293445]=true,[294292]=true,[294584]=true,[294296]=true,[294416]=true,[293469]=true,[293433]=true,[294572]=true,[294576]=true,[294634]=true,},--The Nighthold, , Normal
[938]={[293470]=true,[293434]=true,[294573]=true,[294577]=true,[294635]=true,[293458]=true,[293515]=true,[293422]=true,[294609]=true,[293446]=true,[294297]=true,[294417]=true,[294293]=true,[294585]=true,},--The Nighthold, , Heroic
[939]={[294298]=true,[294418]=true,[293471]=true,[293435]=true,[294574]=true,[294578]=true,[294636]=true,[293459]=true,[293516]=true,[293423]=true,[294610]=true,[294294]=true,[294586]=true,[293447]=true,},--The Nighthold, , Mythic
--Nighthold, Hunter
[993]={[293376]=true,[294563]=true,[293380]=true,[294531]=true,[293388]=true,[293396]=true,[294543]=true,[294199]=true,[294387]=true,[294523]=true,[293489]=true,[294223]=true,[294231]=true,[294219]=true,[294395]=true,[293408]=true,[294547]=true,},--The Nighthold, , Raid Finder
[990]={[293490]=true,[293393]=true,[294540]=true,[294196]=true,[294384]=true,[294520]=true,[294220]=true,[294228]=true,[294216]=true,[294392]=true,[293405]=true,[294544]=true,[293373]=true,[294560]=true,[293377]=true,[294528]=true,[293385]=true,},--The Nighthold, , Normal
[991]={[293491]=true,[293394]=true,[294541]=true,[294197]=true,[294385]=true,[294521]=true,[293378]=true,[294529]=true,[294217]=true,[294393]=true,[293386]=true,[294221]=true,[294229]=true,[293406]=true,[294545]=true,[293374]=true,[294561]=true,},--The Nighthold, , Heroic
[992]={[293492]=true,[293395]=true,[294542]=true,[294198]=true,[294386]=true,[294522]=true,[294222]=true,[294230]=true,[294218]=true,[294394]=true,[293379]=true,[294530]=true,[293407]=true,[294546]=true,[293387]=true,[293375]=true,[294562]=true,},--The Nighthold, , Mythic
--Nighthold, Shaman
[936]={[293404]=true,[293412]=true,[294551]=true,[293508]=true,[294287]=true,[294527]=true,[294567]=true,[293384]=true,[294403]=true,[294633]=true,[293392]=true,[294207]=true,[294195]=true,[294555]=true,[294559]=true,[293400]=true,[294539]=true,},--The Nighthold, , Raid Finder
[933]={[294284]=true,[294524]=true,[294192]=true,[294552]=true,[294556]=true,[293397]=true,[294536]=true,[294564]=true,[293381]=true,[294400]=true,[294630]=true,[293505]=true,[293401]=true,[293409]=true,[294548]=true,[293389]=true,[294204]=true,},--The Nighthold, , Normal
[934]={[294285]=true,[293506]=true,[293402]=true,[293398]=true,[293382]=true,[293390]=true,[294205]=true,[294193]=true,[293410]=true,},--The Nighthold, , Heroic
[935]={[293411]=true,[294550]=true,[294286]=true,[294526]=true,[294566]=true,[293399]=true,[294538]=true,[293383]=true,[294402]=true,[294632]=true,[293507]=true,[294194]=true,[294554]=true,[294558]=true,[293391]=true,[294206]=true,[293403]=true,},--The Nighthold, , Mythic
--Nighthold, DH
[1001]={[294483]=true,[293520]=true,[293524]=true,[294519]=true,[293532]=true,[294503]=true,[293536]=true,[294495]=true,[293540]=true,[294359]=true,[293528]=true,},--The Nighthold, , Raid Finder
[998]={[293537]=true,[293521]=true,[293525]=true,[294516]=true,[294356]=true,[293533]=true,[294492]=true,[293517]=true,[294480]=true,[293529]=true,[294500]=true,},--The Nighthold, , Normal
[999]={[293538]=true,[293522]=true,[293526]=true,[294517]=true,[294357]=true,[293518]=true,[293534]=true,[294493]=true,[294481]=true,[293530]=true,[294501]=true,},--The Nighthold, , Heroic
[1000]={[294482]=true,[293539]=true,[293523]=true,[293527]=true,[294518]=true,[294358]=true,[293519]=true,[293535]=true,[294494]=true,[293531]=true,[294502]=true,},--The Nighthold, , Mythic
--Nighthold, Druid
[997]={[293316]=true,[294511]=true,[293328]=true,[294491]=true,[293340]=true,[293352]=true,[293364]=true,[294171]=true,[294159]=true,[294475]=true,[293484]=true,[294427]=true,[294423]=true,},--The Nighthold, Druid, Raid Finder
[994]={[293313]=true,[294508]=true,[293337]=true,[294168]=true,[293361]=true,[294156]=true,[294472]=true,[293325]=true,[294488]=true,[293481]=true,[294364]=true,[294365]=true,[293349]=true,[294420]=true,},--The Nighthold, Druid, Normal
[995]={[293350]=true,[293314]=true,[294510]=true,[293483]=true,[294425]=true,[293338]=true,[294169]=true,[293362]=true,[294421]=true,[293326]=true,[294489]=true,[294157]=true,[294473]=true,},--The Nighthold, Druid, Heroic
[996]={[293351]=true,[293315]=true,[294509]=true,[293339]=true,[293482]=true,[294170]=true,[293363]=true,[294422]=true,[293327]=true,[294490]=true,[294158]=true,[294474]=true,},--The Nighthold, Druid, Mythic
--Nighthold, Monk
[985]={[293356]=true,[293368]=true,[293485]=true,[293320]=true,[294515]=true,[294383]=true,[294471]=true,[294155]=true,[293332]=true,[294627]=true,[293344]=true,[294167]=true,},--The Nighthold, , Raid Finder
[982]={[293353]=true,[294164]=true,[293317]=true,[294512]=true,[294152]=true,[293486]=true,[293341]=true,[294380]=true,[294468]=true,[293329]=true,[294624]=true,[293365]=true,},--The Nighthold, , Normal
[983]={[293330]=true,[294625]=true,[293354]=true,[294165]=true,[294381]=true,[294469]=true,[294153]=true,[293487]=true,[293342]=true,[293366]=true,[293318]=true,[294513]=true,},--The Nighthold, , Heroic
[984]={[293331]=true,[294626]=true,[293355]=true,[294166]=true,[294382]=true,[294470]=true,[294154]=true,[293343]=true,[293367]=true,[293488]=true,[293319]=true,[294514]=true,},--The Nighthold, , Mythic
--Nighthold, Rogue
[945]={[294283]=true,[294163]=true,[293501]=true,[293324]=true,[293336]=true,[293348]=true,[294499]=true,[293360]=true,[294487]=true,[293372]=true,[294507]=true,[294479]=true,},--The Nighthold, , Raid Finder
[942]={[293502]=true,[294369]=true,[293333]=true,[293357]=true,[294484]=true,[293321]=true,[293345]=true,[294496]=true,[294280]=true,[294476]=true,[294160]=true,[293369]=true,[294504]=true,},--The Nighthold, , Normal
[943]={[294161]=true,[293503]=true,[293334]=true,[293358]=true,[294485]=true,[293322]=true,[293346]=true,[294497]=true,[294281]=true,[294477]=true,[293370]=true,[294505]=true,},--The Nighthold, , Heroic
[944]={[294162]=true,[293504]=true,[293335]=true,[293359]=true,[294486]=true,[293323]=true,[293371]=true,[294506]=true,[293347]=true,[294498]=true,[294282]=true,[294478]=true,},--The Nighthold, , Mythic
--Nighthold, Mage
[989]={[294131]=true,[293280]=true,[293292]=true,[293304]=true,[294447]=true,[293479]=true,[294379]=true,[294415]=true,[294267]=true,[294463]=true,[293256]=true,[293268]=true,},--The Nighthold, Mage, Raid Finder
[986]={[293253]=true,[293277]=true,[293301]=true,[294444]=true,[294264]=true,[294460]=true,[293265]=true,[294128]=true,[293478]=true,[293289]=true,[294376]=true,[294412]=true,},--The Nighthold, Mage, Normal
[987]={[293290]=true,[293480]=true,[293254]=true,[293278]=true,[293302]=true,[294445]=true,[294265]=true,[294461]=true,[293266]=true,[294129]=true,[294377]=true,[294413]=true,},--The Nighthold, Mage, Heroic
[988]={[293291]=true,[293477]=true,[293255]=true,[293279]=true,[294378]=true,[294414]=true,[294266]=true,[294462]=true,[293267]=true,[294130]=true,[293303]=true,[294446]=true,},--The Nighthold, Mage, Mythic
--Nighthold, Priest
[322]={[293272]=true,[294435]=true,[293284]=true,[293296]=true,[294407]=true,[293308]=true,[294451]=true,[293497]=true,[294372]=true,[294459]=true,[294127]=true,[293260]=true,[294623]=true,[294467]=true,},--The Nighthold, Priest, Raid Finder
[308]={[293293]=true,[294404]=true,[293257]=true,[294620]=true,[294456]=true,[294464]=true,[293305]=true,[294448]=true,[293498]=true,[293281]=true,[293269]=true,[294432]=true,[294124]=true,},--The Nighthold, Priest, Normal
[309]={[293270]=true,[294433]=true,[293294]=true,[294405]=true,[293258]=true,[294621]=true,[294457]=true,[294125]=true,[293306]=true,[294449]=true,[293499]=true,[294465]=true,[293282]=true,},--The Nighthold, Priest, Heroic
[311]={[294466]=true,[293271]=true,[294434]=true,[293295]=true,[294406]=true,[293259]=true,[294622]=true,[294458]=true,[293283]=true,[293307]=true,[294450]=true,[293500]=true,[294126]=true,},--The Nighthold, Priest, Mythic
--Nighthold, Warlock
[941]={[294147]=true,[294351]=true,[294271]=true,[294431]=true,[293264]=true,[294399]=true,[293276]=true,[294439]=true,[293288]=true,[294443]=true,[293300]=true,[294455]=true,[293312]=true,[293512]=true,[294275]=true,},--The Nighthold, Warlock, Raid Finder
[315]={[294268]=true,[294428]=true,[294144]=true,[294348]=true,[293273]=true,[294436]=true,[294272]=true,[293297]=true,[294452]=true,[293509]=true,[293261]=true,[294396]=true,[293285]=true,[294440]=true,[293309]=true,},--The Nighthold, Warlock, Normal
[316]={[293310]=true,[294269]=true,[294429]=true,[294145]=true,[294349]=true,[293274]=true,[294437]=true,[294273]=true,[293298]=true,[294453]=true,[293510]=true,[293262]=true,[294397]=true,[293286]=true,[294441]=true,},--The Nighthold, Warlock, Heroic
[321]={[293311]=true,[294270]=true,[294430]=true,[294146]=true,[294350]=true,[293275]=true,[294438]=true,[294274]=true,[293299]=true,[294454]=true,[293511]=true,[293263]=true,[294398]=true,[293287]=true,[294442]=true,},--Nighthold, Warlock, Mythic

--Tomb of Sargeras, DK
[1339]={[293549]=true,[294826]=true,[293541]=true,[294830]=true,[293553]=true,[293545]=true,[294862]=true,[293557]=true,[293561]=true,},--Tomb of Sargeras, , Raid Finder
[1337]={[293550]=true,[294827]=true,[293542]=true,[294831]=true,[293554]=true,[294863]=true,[293546]=true,[293562]=true,[293558]=true,},--Tomb of Sargeras, , Normal
[1340]={[293563]=true,[293551]=true,[293555]=true,[293543]=true,[294832]=true,[294864]=true,[294828]=true,[293547]=true,[293559]=true,},--Tomb of Sargeras, , Heroic
[1338]={[293548]=true,[294865]=true,[293552]=true,[293556]=true,[293544]=true,[294833]=true,[293560]=true,[293564]=true,[294829]=true,},--Tomb of Sargeras, , Mythic
--Tomb of Sargeras, Paldin
[1315]={[293693]=true,[294822]=true,[293689]=true,[294818]=true,[293697]=true,[293701]=true,[293705]=true,[293685]=true,},--Tomb of Sargeras, , Raid Finder
[1313]={[293702]=true,[293706]=true,[293694]=true,[293686]=true,[293690]=true,[294819]=true,[293698]=true,[294823]=true,},--Tomb of Sargeras, , Normal
[1316]={[294820]=true,[293699]=true,[293703]=true,[293707]=true,[293695]=true,[293687]=true,[293691]=true,[294824]=true,},--Tomb of Sargeras, , Heroic
[1314]={[293688]=true,[293692]=true,[294821]=true,[293700]=true,[293704]=true,[293708]=true,[293696]=true,[294825]=true,},--Tomb of Sargeras, , Mythic
--Tomb of Sargeras, Warrior
[1296]={[293821]=true,[293825]=true,[294866]=true,[293805]=true,[293809]=true,[294814]=true,[293817]=true,[293813]=true,},--Tomb of Sargeras, , Raid Finder
[1293]={[294815]=true,[293818]=true,[293822]=true,[293826]=true,[294867]=true,[293806]=true,[293810]=true,[293814]=true,},--Tomb of Sargeras, , Normal
[1294]={[293807]=true,[293811]=true,[294816]=true,[293819]=true,[293823]=true,[293827]=true,[294868]=true,[293815]=true,},--Tomb of Sargeras, , Heroic
[1295]={[293828]=true,[294869]=true,[293808]=true,[293812]=true,[294817]=true,[293820]=true,[293824]=true,[293816]=true,},--Tomb of Sargeras, , Mythic
--Tomb of Sargeras, Hunter
[1327]={[293625]=true,[293629]=true,[293613]=true,[293633]=true,[294802]=true,[293621]=true,[294810]=true,[293617]=true,[294798]=true,[294854]=true,},--Tomb of Sargeras, , Raid Finder
[1325]={[293626]=true,[293619]=true,[293630]=true,[293614]=true,[293634]=true,[294803]=true,[293622]=true,[294811]=true,[294799]=true,[294855]=true,},--Tomb of Sargeras, , Normal
[1328]={[294812]=true,[293627]=true,[293620]=true,[293631]=true,[293615]=true,[293635]=true,[294804]=true,[293623]=true,[294800]=true,[294856]=true,},--Tomb of Sargeras, , Heroic
[1326]={[294813]=true,[293628]=true,[293632]=true,[293616]=true,[293618]=true,[293636]=true,[294805]=true,[293624]=true,[294801]=true,[294857]=true,},--Tomb of Sargeras, , Mythic
--Tomb of Sargeras, Shaman
[1302]={[293765]=true,[293769]=true,[294806]=true,[294858]=true,[293777]=true,[294794]=true,[293757]=true,[293761]=true,[293773]=true,},--Tomb of Sargeras, , Raid Finder
[1301]={[293758]=true,[293762]=true,[293766]=true,[293770]=true,[294807]=true,[294859]=true,[293778]=true,[294795]=true,[293774]=true,},--Tomb of Sargeras, , Normal
[1303]={[293779]=true,[294796]=true,[293759]=true,[293763]=true,[293767]=true,[293771]=true,[294808]=true,[294860]=true,[293775]=true,},--Tomb of Sargeras, , Heroic
[1304]={[293772]=true,[294809]=true,[294861]=true,[293780]=true,[294797]=true,[293760]=true,[293764]=true,[293768]=true,[293776]=true,},--Tomb of Sargeras, , Mythic
--Tomb of Sargeras, DH
[1335]={[293581]=true,[293585]=true,[294770]=true,[293565]=true,[293569]=true,[293573]=true,[293577]=true,[294834]=true,},--Tomb of Sargeras, , Raid Finder
[1333]={[293574]=true,[293578]=true,[293582]=true,[293586]=true,[294771]=true,[293566]=true,[293570]=true,[294835]=true,},--Tomb of Sargeras, , Normal
[1336]={[293567]=true,[293571]=true,[293575]=true,[293579]=true,[293583]=true,[294836]=true,[294772]=true,[293587]=true,},--Tomb of Sargeras, , Heroic
[1334]={[293588]=true,[294773]=true,[293568]=true,[293572]=true,[293576]=true,[293580]=true,[293584]=true,[294837]=true,},--Tomb of Sargeras, , Mythic
--Tomb of Sargeras, Druid
[1331]={[293609]=true,[294790]=true,[293589]=true,[293593]=true,[294782]=true,[293601]=true,[293605]=true,[293597]=true,},--Tomb of Sargeras, , Raid Finder
[1329]={[293594]=true,[293610]=true,[293598]=true,[294783]=true,[293602]=true,[294791]=true,[293606]=true,[293590]=true,},--Tomb of Sargeras, , Normal
[1332]={[293595]=true,[294784]=true,[293603]=true,[293607]=true,[293611]=true,[293599]=true,[293591]=true,[294792]=true,},--Tomb of Sargeras, , Heroic
[1330]={[293600]=true,[293592]=true,[293596]=true,[294785]=true,[293604]=true,[293608]=true,[293612]=true,[294793]=true,},--Tomb of Sargeras, , Mythic
--Tomb of Sargeras, Monk
[1319]={[293681]=true,[294846]=true,[293661]=true,[293665]=true,[293669]=true,[293673]=true,[293677]=true,[294850]=true,},--Tomb of Sargeras, , Raid Finder
[1317]={[293674]=true,[293678]=true,[293682]=true,[294847]=true,[293662]=true,[293666]=true,[293670]=true,[294851]=true,},--Tomb of Sargeras, , Normal
[1320]={[293667]=true,[293671]=true,[293675]=true,[293679]=true,[293683]=true,[294848]=true,[293663]=true,[294852]=true,},--Tomb of Sargeras, , Heroic
[1318]={[294849]=true,[293664]=true,[293668]=true,[293672]=true,[293676]=true,[293680]=true,[293684]=true,[294853]=true,},--Tomb of Sargeras, , Mythic
--Tomb of Sargeras, Rogue
[1306]={[293745]=true,[294786]=true,[293733]=true,[293749]=true,[293737]=true,[293753]=true,[293741]=true,[294774]=true,[294778]=true,},--Tomb of Sargeras, , Raid Finder
[1305]={[293746]=true,[294787]=true,[293734]=true,[293750]=true,[293738]=true,[293754]=true,[293742]=true,[294775]=true,[294779]=true,},--Tomb of Sargeras, , Normal
[1307]={[294780]=true,[293747]=true,[294788]=true,[293735]=true,[293751]=true,[293739]=true,[293755]=true,[293743]=true,[294776]=true,},--Tomb of Sargeras, , Heroic
[1308]={[294777]=true,[294781]=true,[293748]=true,[294789]=true,[293736]=true,[293752]=true,[293740]=true,[293756]=true,[293744]=true,},--Tomb of Sargeras, , Mythic
--Tomb of Sargeras, Mage
[1323]={[293653]=true,[293657]=true,[293637]=true,[294754]=true,[294838]=true,[293645]=true,[293649]=true,[293641]=true,},--Tomb of Sargeras, , Raid Finder
[1321]={[294755]=true,[293642]=true,[293658]=true,[294839]=true,[293646]=true,[293650]=true,[293638]=true,[293654]=true,},--Tomb of Sargeras, , Normal
[1324]={[294756]=true,[294840]=true,[293647]=true,[293651]=true,[293655]=true,[293659]=true,[293639]=true,[293643]=true,},--Tomb of Sargeras, , Heroic
[1322]={[293660]=true,[293640]=true,[294757]=true,[294841]=true,[293648]=true,[293652]=true,[293656]=true,[293644]=true,},--Tomb of Sargeras, , Mythic
--Tomb of Sargeras, Priest
[1342]={[294766]=true,[293717]=true,[294842]=true,[293721]=true,[293709]=true,[294750]=true,[293713]=true,[293729]=true,[293725]=true,},--Tomb of Sargeras, , Raid Finder
[1309]={[293730]=true,[294767]=true,[294843]=true,[293718]=true,[293722]=true,[293710]=true,[293726]=true,[293714]=true,[294751]=true,},--Tomb of Sargeras, , Normal
[1312]={[293715]=true,[293731]=true,[294768]=true,[293719]=true,[294844]=true,[293723]=true,[293711]=true,[294752]=true,[293727]=true,},--Tomb of Sargeras, , Heroic
[1310]={[293716]=true,[293732]=true,[294769]=true,[293720]=true,[294845]=true,[293724]=true,[293712]=true,[294753]=true,[293728]=true,},--Tomb of Sargeras, , Mythic
--Tomb of Sargeras, Warlock
[1300]={[294758]=true,[293793]=true,[294762]=true,[293797]=true,[293785]=true,[293801]=true,[294746]=true,[293789]=true,[293781]=true,},--Tomb of Sargeras, , Raid Finder
[1297]={[293790]=true,[294759]=true,[293794]=true,[294763]=true,[293798]=true,[293786]=true,[293802]=true,[294747]=true,[293782]=true,},--Tomb of Sargeras, , Normal
[1298]={[293791]=true,[294760]=true,[293795]=true,[294764]=true,[293799]=true,[293787]=true,[293803]=true,[294748]=true,[293783]=true,},--Tomb of Sargeras, , Heroic
[1299]={[294749]=true,[293792]=true,[294761]=true,[293796]=true,[294765]=true,[293800]=true,[293788]=true,[293804]=true,[293784]=true,},--Tomb of Sargeras, , Mythic

--Antorus, DK
[1475]={[293849]=true,[294947]=true,[293837]=true,[293841]=true,[293829]=true,[293845]=true,[293833]=true,[294963]=true,},--Antorus, the Burning Throne, , Raid Finder
[1472]={[293834]=true,[293850]=true,[294948]=true,[293838]=true,[294964]=true,[293842]=true,[293830]=true,[293846]=true,},--Antorus, the Burning Throne, , Normal
[1473]={[293835]=true,[293851]=true,[294949]=true,[293839]=true,[294965]=true,[293843]=true,[293831]=true,[293847]=true,},--Antorus, the Burning Throne, , Heroic
[1474]={[293836]=true,[293852]=true,[294950]=true,[293840]=true,[293844]=true,[293832]=true,[293848]=true,[294966]=true,},--Antorus, the Burning Throne, , Mythic
--Antorus, Paldin
[1499]={[293985]=true,[293973]=true,[293989]=true,[293977]=true,[293993]=true,[294955]=true,[293981]=true,[294971]=true,[294959]=true,},--Antorus, the Burning Throne, , Raid Finder
[1496]={[294960]=true,[293974]=true,[293990]=true,[293978]=true,[293994]=true,[294956]=true,[293982]=true,[294972]=true,[293986]=true,},--Antorus, the Burning Throne, , Normal
[1497]={[294973]=true,[293987]=true,[293975]=true,[293991]=true,[293979]=true,[293995]=true,[294957]=true,[293983]=true,[294961]=true,},--Antorus, the Burning Throne, , Heroic
[1498]={[293984]=true,[294974]=true,[293988]=true,[293976]=true,[293992]=true,[293980]=true,[293996]=true,[294958]=true,[294962]=true,},--Antorus, the Burning Throne, , Mythic
--Antorus, Warrior
[1519]={[294105]=true,[294093]=true,[294109]=true,[294951]=true,[294097]=true,[294113]=true,[294101]=true,[294979]=true,[294967]=true,},--Antorus, the Burning Throne, , Raid Finder
[1516]={[294106]=true,[294094]=true,[294110]=true,[294952]=true,[294098]=true,[294968]=true,[294102]=true,[294980]=true,[294114]=true,},--Antorus, the Burning Throne, , Normal
[1517]={[294107]=true,[294095]=true,[294111]=true,[294953]=true,[294099]=true,[294969]=true,[294115]=true,[294103]=true,[294981]=true,},--Antorus, the Burning Throne, , Heroic
[1518]={[294104]=true,[294108]=true,[294096]=true,[294112]=true,[294954]=true,[294100]=true,[294116]=true,[294970]=true,[294982]=true,},--Antorus, the Burning Throne, , Mythic
--Antorus, Hunter
[1487]={[293909]=true,[293913]=true,[293901]=true,[293917]=true,[294939]=true,[294927]=true,[293905]=true,[293921]=true,[294975]=true,},--Antorus, the Burning Throne, , Raid Finder
[1484]={[293910]=true,[293914]=true,[293902]=true,[293918]=true,[294940]=true,[294928]=true,[294976]=true,[293907]=true,[293922]=true,},--Antorus, the Burning Throne, , Normal
[1485]={[293911]=true,[293915]=true,[293903]=true,[293919]=true,[294941]=true,[294929]=true,[293908]=true,[294977]=true,[293923]=true,},--Antorus, the Burning Throne, , Heroic
[1486]={[293924]=true,[293912]=true,[293916]=true,[293904]=true,[293920]=true,[294942]=true,[294930]=true,[293906]=true,[294978]=true,},--Antorus, the Burning Throne, , Mythic
--Antorus, Shaman
[1511]={[294045]=true,[294061]=true,[294935]=true,[294991]=true,[294065]=true,[294053]=true,[294049]=true,[294931]=true,[294995]=true,[294943]=true,[294057]=true,},--Antorus, the Burning Throne, , Raid Finder
[1508]={[294046]=true,[294062]=true,[294936]=true,[294992]=true,[294066]=true,[294054]=true,[294050]=true,[294944]=true,[294932]=true,[294996]=true,[294058]=true,},--Antorus, the Burning Throne, , Normal
[1509]={[294933]=true,[294997]=true,[294047]=true,[294063]=true,[294937]=true,[294993]=true,[294067]=true,[294055]=true,[294051]=true,[294059]=true,[294945]=true,},--Antorus, the Burning Throne, , Heroic
[1510]={[294934]=true,[294998]=true,[294048]=true,[294064]=true,[294938]=true,[294994]=true,[294068]=true,[294056]=true,[294052]=true,[294946]=true,[294060]=true,},--Antorus, the Burning Throne, , Mythic
--Antorus, DH
[1479]={[294911]=true,[293865]=true,[293853]=true,[293869]=true,[293857]=true,[294923]=true,[293861]=true,[293873]=true,[294983]=true,},--Antorus, the Burning Throne, , Raid Finder
[1476]={[294912]=true,[293866]=true,[293854]=true,[293870]=true,[293858]=true,[294924]=true,[293862]=true,[293874]=true,[294984]=true,},--Antorus, the Burning Throne, , Normal
[1477]={[294913]=true,[293867]=true,[293855]=true,[293871]=true,[293859]=true,[294925]=true,[294985]=true,[293863]=true,[293875]=true,},--Antorus, the Burning Throne, , Heroic
[1478]={[293864]=true,[294914]=true,[293868]=true,[293856]=true,[293872]=true,[293860]=true,[294926]=true,[294986]=true,[293876]=true,},--Antorus, the Burning Throne, , Mythic
--Antorus, Druid
[1483]={[293885]=true,[293877]=true,[293881]=true,[293889]=true,[293893]=true,[293897]=true,[294907]=true,},--Antorus, the Burning Throne, , Raid Finder
[1480]={[293894]=true,[293882]=true,[294908]=true,[293886]=true,[293890]=true,[293898]=true,[293878]=true,},--Antorus, the Burning Throne, , Normal
[1481]={[293891]=true,[293895]=true,[293899]=true,[293887]=true,[293879]=true,[293883]=true,[294909]=true,},--Antorus, the Burning Throne, , Heroic
[1482]={[293880]=true,[293884]=true,[293892]=true,[293896]=true,[293900]=true,[293888]=true,[294910]=true,},--Antorus, the Burning Throne, , Mythic
--Antorus, Monk
[1495]={[293957]=true,[293961]=true,[293965]=true,[293969]=true,[293953]=true,[293949]=true,[294919]=true,[294903]=true,},--Antorus, the Burning Throne, , Raid Finder
[1492]={[293954]=true,[293970]=true,[293958]=true,[294920]=true,[294904]=true,[293966]=true,[293950]=true,[293962]=true,},--Antorus, the Burning Throne, , Normal
[1493]={[293971]=true,[293955]=true,[293951]=true,[294921]=true,[293959]=true,[293963]=true,[293967]=true,[294905]=true,},--Antorus, the Burning Throne, , Heroic
[1494]={[293964]=true,[293968]=true,[293972]=true,[293956]=true,[293952]=true,[294922]=true,[293960]=true,[294906]=true,},--Antorus, the Burning Throne, , Mythic
--Antorus, Rogue
[1507]={[294041]=true,[294987]=true,[294021]=true,[294025]=true,[294029]=true,[294915]=true,[294037]=true,[294033]=true,},--Antorus, the Burning Throne, , Raid Finder
[1504]={[294030]=true,[294916]=true,[294034]=true,[294022]=true,[294988]=true,[294026]=true,[294042]=true,[294038]=true,},--Antorus, the Burning Throne, , Normal
[1505]={[294031]=true,[294917]=true,[294035]=true,[294023]=true,[294989]=true,[294027]=true,[294043]=true,[294039]=true,},--Antorus, the Burning Throne, , Heroic
[1506]={[294044]=true,[294032]=true,[294918]=true,[294036]=true,[294024]=true,[294040]=true,[294028]=true,[294990]=true,},--Antorus, the Burning Throne, , Mythic
--Antorus, Mage
[1491]={[294887]=true,[293941]=true,[293929]=true,[293945]=true,[294895]=true,[293925]=true,[294871]=true,[293933]=true,[293937]=true,},--Antorus, the Burning Throne, , Raid Finder
[1488]={[294888]=true,[293942]=true,[293930]=true,[293946]=true,[293934]=true,[293926]=true,[294896]=true,[293938]=true,[294872]=true,},--Antorus, the Burning Throne, , Normal
[1489]={[293939]=true,[294889]=true,[293943]=true,[293931]=true,[293947]=true,[293935]=true,[293927]=true,[294897]=true,[294873]=true,},--Antorus, the Burning Throne, , Heroic
[1490]={[294874]=true,[294890]=true,[293944]=true,[293932]=true,[293948]=true,[294898]=true,[293928]=true,[293936]=true,[293940]=true,},--Antorus, the Burning Throne, , Mythic
--Antorus, Priest
[1503]={[294013]=true,[294017]=true,[294875]=true,[293997]=true,[294001]=true,[294005]=true,[294009]=true,[294891]=true,},--Antorus, the Burning Throne, , Raid Finder
[1500]={[294014]=true,[294002]=true,[294018]=true,[294892]=true,[294006]=true,[294010]=true,[294876]=true,[293998]=true,},--Antorus, the Burning Throne, , Normal
[1501]={[293999]=true,[294003]=true,[294007]=true,[294011]=true,[294015]=true,[294019]=true,[294877]=true,[294893]=true,},--Antorus, the Burning Throne, , Heroic
[1502]={[294020]=true,[294878]=true,[294000]=true,[294004]=true,[294008]=true,[294012]=true,[294016]=true,[294894]=true,},--Antorus, the Burning Throne, , Mythic
--Antorus, Warlock
[1515]={[294089]=true,[294077]=true,[294883]=true,[294879]=true,[294085]=true,[294069]=true,[294899]=true,[294073]=true,[294081]=true,},--Antorus, the Burning Throne, , Raid Finder
[1512]={[294074]=true,[294090]=true,[294078]=true,[294082]=true,[294880]=true,[294086]=true,[294070]=true,[294900]=true,[294884]=true,},--Antorus, the Burning Throne, , Normal
[1513]={[294901]=true,[294075]=true,[294091]=true,[294079]=true,[294885]=true,[294881]=true,[294087]=true,[294071]=true,[294083]=true,},--Antorus, the Burning Throne, , Heroic
[1514]={[294902]=true,[294076]=true,[294092]=true,[294080]=true,[294886]=true,[294072]=true,[294882]=true,[294088]=true,[294084]=true,},--Antorus, the Burning Throne, , Mythic

--[setID] = { [sourceID] = true, },
[983]={[289867]=true,},
[1271]={[289991]=true,},
[1272]={[290038]=true,},
[1277]={[289991]=true,},
[1278]={[290038]=true,},
[1283]={[289991]=true,},
[1284]={[290038]=true,},

[1470]={[289324]=true,[289329]=true,[289327]=true,},

[2337]={[288506]=true,},
[2656]={[288583]=true,},

[3071]={[288410]=true,[288411]=true,[288413]=true,[288407]=true,},
[3072]={[288379]=true,[288384]=true,},

[4330]={[289120]=true,[289121]=true,[289122]=true,[289124]=true,[289126]=true,[289127]=true,},
[4331]={[284433]=true,},

[4399]={[289114]=true,[289118]=true,},
[4400]={[289107]=true,[289106]=true,[289108]=true,},
[4401]={[289098]=true,[289102]=true,[289097]=true,[289099]=true,},
[4402]={[289027]=true,[289028]=true,[289092]=true,[289026]=true,[289091]=true,[289093]=true},
[4403]={[289021]=true,[289023]=true,[289025]=true,},
[4404]={[289012]=true,[289014]=true},
[4405]={[289003]=true,[289001]=true,[289002]=true,[289006]=true,[289004]=true},
[4406]={[288990]=true,[288994]=true,[288995]=true},
[4407]={[288981]=true,[288986]=true,[288989]=true,[288982]=true,[288985]=true,},
[4408]={[288973]=true,[288974]=true,[288980]=true,[288975]=true,[288978]=true,},
[4409]={[288967]=true,[288972]=true,[288969]=true,[288968]=true,},
[4410]={[288958]=true,[288960]=true,[288961]=true,[288962]=true,},
[4411]={[288952]=true,[288954]=true,[288956]=true,[288950]=true},
[4412]={[288941]=true,[288943]=true,[288947]=true,[288948]=true,},
[4413]={[288933]=true,[288938]=true,[288937]=true,},
[4414]={[288927]=true,[288932]=true,[288931]=true,},
[4415]={[288917]=true,[288919]=true,[288920]=true,},
[4416]={[288907]=true,[288908]=true,[288910]=true,[288913]=true,[288912]=true},
[4417]={[288903]=true,[288901]=true,[288904]=true,},
[4418]={[288896]=true,[288897]=true,},
[4419]={[288882]=true,[288884]=true,[288889]=true,[288888]=true,},
[4420]={[288876]=true,[288881]=true,},
[4421]={[288870]=true,[288867]=true,},
[4422]={[288859]=true,[288862]=true,[288864]=true,[288858]=true,},
[4423]={[288850]=true,[288855]=true,[288851]=true,[288852]=true,[288853]=true,[288854]=true,},
[4424]={[288849]=true,[288848]=true,[288844]=true,},
[4425]={[288836]=true,[288838]=true,},
[4427]={[288452]=true,[288454]=true,[288457]=true,},
[4428]={[288519]=true,[288520]=true,},
[4429]={[288513]=true,},
[4430]={[288627]=true,[288629]=true,[288634]=true,[289595]=true,[288462]=true},
[4431]={[288620]=true,[288624]=true,[288626]=true,[288616]=true,[288619]=true,[231655]=true,[289594]=true,[288460]=true},
[4432]={[288461]=true,[288611]=true,[288612]=true,[288615]=true,[288614]=true,[231319]=true,[231320]=true,[231289]=true,[231289]=true},
[4433]={[288544]=true,[288543]=true,},
[4434]={[288533]=true,[288536]=true,[288538]=true,},
[4435]={[288449]=true,[288450]=true,[288448]=true,[288445]=true,[288447]=true,},
[4436]={[288801]=true,[288804]=true,},
[4437]={[288503]=true,[288781]=true,[288782]=true,[288793]=true,[288791]=true,},

[4440]={[288595]=true,},
[4442]={[288531]=true,[288526]=true,[288528]=true,},
[4443]={[288419]=true,[288423]=true,},
[4444]={[288556]=true,[288557]=true,[288558]=true,[288561]=true,[288563]=true,},
[4447]={[288788]=true,[288789]=true,[288794]=true,[288796]=true,[288790]=true,},
[4448]={[288622]=true,[288623]=true,[288778]=true,[288610]=true,},
[4449]={[288599]=true,[288607]=true,[288813]=true,},
[4450]={[288810]=true,[288812]=true,[288809]=true,},
[4452]={[288387]=true,[288388]=true,[288390]=true,},
[4453]={[288566]=true,[288570]=true,[288567]=true,[288569]=true,},
[4454]={[288548]=true,[288550]=true,[288547]=true,},
[4457]={[288471]=true,[288463]=true,[288466]=true,[288467]=true,},
[4458]={[288496]=true,[288499]=true,[288501]=true,[288497]=true,[288493]=true,},
[4459]={[288483]=true,[288482]=true},
[4460]={[288480]=true,[288481]=true,},
[4465]={[289292]=true,[289295]=true,[289298]=true,[289293]=true},
[4466]={[289283]=true,[289284]=true,[289285]=true,[289287]=true,},
[4467]={[289275]=true,[289281]=true,[289280]=true,[289282]=true,[289277]=true},
[4468]={[289268]=true,[289273]=true,[289267]=true,[289269]=true},
[4469]={[289202]=true,[289199]=true,[289198]=true,[289200]=true,},
[4470]={[289303]=true,[289305]=true,[289306]=true,},
[4471]={[289308]=true,[289309]=true,[289310]=true,[289311]=true,[289312]=true,[289315]=true,},
[4472]={[289317]=true,[289321]=true,[289319]=true,},
[4473]={[289342]=true,[289340]=true,[289193]=true,[288355]=true,[289597]=true},
[4474]={[289598]=true,[289354]=true,[289355]=true,[288354]=true},
[4475]={[288353]=true,[289357]=true,[289360]=true,[289599]=true,[289358]=true,},
[4476]={[289172]=true,[289364]=true,[289366]=true,[289368]=true,[289370]=true,[289369]=true,[289371]=true,[289179]=true,[289179]=true,[288352]=true,[289600]=true},
[4477]={[289256]=true,},
[4478]={[289247]=true,[289250]=true,[289243]=true,[289248]=true,},
[4479]={[289235]=true,[289237]=true,[289238]=true,[289239]=true,},
[4480]={[289233]=true,},
[4481]={[289263]=true,[289264]=true,[289265]=true,[289261]=true,[289266]=true,},
[4483]={[289373]=true,[289375]=true,[289156]=true,[289376]=true,[289533]=true},
[4484]={[289222]=true,[289226]=true,[289225]=true,[289221]=true,},
[4485]={[289206]=true,[289210]=true,[289205]=true,[289208]=true,},
[4486]={[289334]=true,},
[4487]={[289188]=true,[289380]=true,[289381]=true,[289383]=true,[289386]=true,},
[4488]={[289211]=true,[289212]=true,[289215]=true,[289217]=true,},
[4489]={[289143]=true,[289147]=true,[289149]=true,[289150]=true,[288831]=true,[289144]=true,[289146]=true,},
[4490]={[289131]=true,[289132]=true,[289135]=true,[289136]=true,[289130]=true,[289133]=true,[289134]=true,},

[5270]={[298242]=true,[298245]=true,[298243]=true,[298247]=true,},

[7000001]={[289602]=true,},
--[7000012]={[289603]=true,},--trading post exclusive item
}

local function shouldUseLegionRemix(data)
  --data.isRemix = nil;
  if not setsFlagRemix[data.setID] then return true; end
  
  if type(setsFlagRemix[data.setID]) == 'number' and data.classMask == setsFlagRemix[data.setID] then
    return true;
  end
  
  local sources = C_TransmogSets.GetSetPrimaryAppearances(data.setID);
  for i=1,#sources do
    if not sources[i].collected then
      return false;
    end
  end
  return true;
end
app.shouldUseLegionRemix = shouldUseLegionRemix;

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
app.altPatchID[expansionID+1] = altPatchID;
app.isRaidSet[expansionID+1] = isRaidSet;
app.legionRemixFlag = setsFlagRemix;
app.legionItemRemixFlag = itemsFlagRemix;
app.altLabelDB[expansionID+1] = altLabelDB;
app.altNoteDB[expansionID+1] = altNoteDB;
app.addedAppearance[expansionID+1] = addedAppearance;
app.replaceAppearance[expansionID+1] = replaceAppearance;
app.neverObtainDB[expansionID+1] = neverObtainDB;

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