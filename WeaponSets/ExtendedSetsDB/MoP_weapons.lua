local app = select(2,...);

local expansionID = 5;

--Name, Label, Difficulty, patchID, notes top line, notes bottom line, sources, requiredFact, isPvP, noLongerObtainable
----sources(17):
--1) Axe
--2) 2hAxe
--3) Bow
--4) XBow
--5) Dagger
--6) Fist
--7) Gun
--8) Mace
--9) 2hMace
--10) Off-hand
--11) Polearm
--12) Shield
--13) Staff
--14) Sword
--15) 2hSword
--16) Wand
--17) Warglaive

--Item Quality Colors (for item link source)
--0 - Grey/Trash
--1 - White/Common
--2 - Green/Uncommon
--3 - Blue/Rare
--4 - Purple/Epic
--5 - Orange/Legendary
--6 - Artifact
--7 - Heirloom

--1 = Warrior
--2 = Paladin
--4 = Hunter
--8 = Rogue
--16 = Priest
--32 = Death Knight
--64 = Shaman
--128 = Mage
--256 = Warlock
--512  = Monk
--1024 = Druid
--2048 = Demon Hunter
--4096 = Evoker
local NOT_REMIX = "NOT_REMIX";
local IS_REMIX = "IS_REMIX";

local ZoneList = {
"Jade Forest",--1
"Townlong Steppes",--2
"Vale of Eternal Blossoms",--3
"Valley of the Four Winds",--4
"Dread Wastes",--5
"Krasarang Wilds",--6
"Kun-Lai Summit",--7
"'Three Isles'",--8
"Timeless Isle",--9
"Isle of Thunder",--10
"Scenarios (Normal)",--11
"Scenarios (Heroic)",--12
"Dungeons (Normal)",--13
"Dungeons (Heroic)",--14
"MsV, HoF, ToES (LFR)",--15
"MsV, HoF, ToES (Normal)",--16
"MsV, HoF, ToES (Heroic)",--17
"Throne of Thunder (LFR)",--18
"Throne of Thunder (Normal)",--19
"Throne of Thunder (Heroic)",--20
"Siege of Orgrimmar (LFR)",--21
"Siege of Orgrimmar (Normal/Heroic)",--22
"Siege of Orgrimmar (Mythic)",--23
}

local function Zone(...)
  local arg = {...};
  local out = "Zone: ";
  for i=1,#arg do
    out = out..ZoneList[arg[i]];
    if i ~= #arg then
      out = out..", ";
    end
  end
  return out;
end

local db = {
--Remix Duplicates
{5083,"Remix Duplicates","Old Looks, New IDs",nil,50500,nil,nil,{
{1,196810,nil,Zone(18)},
{6,198425,nil,Zone(18)},
{6,198422,nil,Zone(18)},
{10,198469,nil,Zone(18)},
{10,198466,nil,Zone(18)},
{15,197280,nil,Zone(17)},
{15,197279,nil,Zone(16)},
{15,197278,nil,Zone(15)},
{16,197301,nil,Zone(16)},
{16,197302,nil,Zone(17)},
{6,196945,nil,Zone(15)},{6,196942,nil,Zone(15)},
{12,198551,nil,Zone(15)},
{10,197303,nil,Zone(15)},
{16,197305,nil,Zone(4,5)},
{16,197311,nil,Zone(12)},
{8,197085,nil,Zone(8)},
{9,198454,nil,Zone(18)},
{10,198467,nil,Zone(19)},
{9,198455,nil,Zone(19)},
{5,196934,nil,Zone(20)},
{1,196807,nil,Zone(20)},
{9,198456,nil,Zone(20)},
{8,198453,nil,Zone(20)},
--{6,196938,nil,Zone(21)},
{16,193716,nil,Zone(21)},
{16,197298,nil,Zone(22)},
{6,196941,nil,Zone(23)},
{16,197299,nil,Zone(23)},
},nil,1,nil,IS_REMIX},

--Remix Class Arsenals
{5082,"Holy Avenger","Remix: Pandaria Class Sets",app.GetColoredClassNameString("Paladin"),100207,"i:217832:4:Arsenal Armaments of the Holy Avenger","Only usable by "..app.GetColoredClassNameString("Paladin"),{{12,200455},{9,200456},{8,200457},},nil,1,2,IS_REMIX},
{5081,"Webbed Soulforged","Remix: Pandaria Class Sets",app.GetColoredClassNameString("Death Knight"),100207,"i:217824:4:Arsenal Webbed Soulforged Weaponfy","Only usable by "..app.GetColoredClassNameString("Death Knight"),{{2,200480},{14,200481},{15,200482},},nil,1,32,IS_REMIX},
{5080,"Fanatical Champion's","Remix: Pandaria Class Sets",app.GetColoredClassNameString("Warrior"),100207,"i:217825:4:Arsenal Fanatical Champion's Aggression","Only usable by "..app.GetColoredClassNameString("Warrior"),{{12,200491},{14,200492},{15,200493},},nil,1,1,IS_REMIX},

{5079,"Gold Hoarder","Remix: Pandaria Class Sets",app.GetColoredClassNameString("Evoker"),100207,"i:217821:4:Arsenal Treasure of the Gold Hoarder","Only usable by "..app.GetColoredClassNameString("Evoker"),{{13,200515},{10,200516},{14,200517},},nil,1,4096,IS_REMIX},
{5078,"Dreadsquall Hunter's","Remix: Pandaria Class Sets",app.GetColoredClassNameString("Hunter"),100207,"i:217820:4:Arsenal Dreadsquall Hunter's Preference","Only usable by "..app.GetColoredClassNameString("Hunter"),{{11,200527},{3,200528},{7,200529},},nil,1,4,IS_REMIX},
{5077,"Krag'wa's Disciple","Remix: Pandaria Class Sets",app.GetColoredClassNameString("Shaman"),100207,"i:217819:4:Arsenal Tools of Krag'wa's Disciple","Only usable by "..app.GetColoredClassNameString("Shaman"),{{12,200521},{1,200522},{6,200523},},nil,1,64,IS_REMIX},

{5076,"Aldrachi Blasphemer's","Remix: Pandaria Class Sets",app.GetColoredClassNameString("Demon Hunter"),100207,"i:217828:4:Arsenal Aldrachi Blasphemer's Glaives","Only usable by "..app.GetColoredClassNameString("Demon Hunter"),{{17,200486},{17,200487},},nil,1,2048,IS_REMIX},
{5075,"Ela'lothen's Rebirth","Remix: Pandaria Class Sets",app.GetColoredClassNameString("Druid"),100207,"i:217829:4:Arsenal Ela'lothen's Blessings of Rebirth","Only usable by "..app.GetColoredClassNameString("Druid"),{{5,200473},{6,200474},{13,200475},{13,191196}},nil,1,1024,IS_REMIX},
{5074,"Shado-Pan Watcher","Remix: Pandaria Class Sets",app.GetColoredClassNameString("Monk"),100207,"i:217827:4:Arsenal Shado-Pan Watcher Arenal","Only usable by "..app.GetColoredClassNameString("Monk"),{{6,200497},{13,200498},{13,200499},},nil,1,512,IS_REMIX},
{5073,"Igneous Onyx","Remix: Pandaria Class Sets",app.GetColoredClassNameString("Rogue"),100207,"i:217830:4:Arsenal Igneous Onyx Blades","Only usable by "..app.GetColoredClassNameString("Rogue"),{{5,200461},{14,200463},{5,200462},},nil,1,8,IS_REMIX},

{5072,"Sin'dorei Magister's","Remix: Pandaria Class Sets",app.GetColoredClassNameString("Mage"),100207,"i:217823:4:Arsenal Sin'dorei Magister's Enchantment","Only usable by "..app.GetColoredClassNameString("Mage"),{{14,200509},{13,200510},{10,200511},},nil,1,128,IS_REMIX},
{5071,"Abyssal Cult","Remix: Pandaria Class Sets",app.GetColoredClassNameString("Priest"),100207,"i:217831:4:Arsenal Secrets of the Abyssal Cult","Only usable by "..app.GetColoredClassNameString("Priest"),{{10,200458},{8,200459},{13,200460},},nil,1,16,IS_REMIX},
{5070,"Temptation's Call","Remix: Pandaria Class Sets",app.GetColoredClassNameString("Warlock"),100207,"i:217826:4:Arsenal Instruments of Temptation's Call","Only usable by "..app.GetColoredClassNameString("Warlock"),{{5,200503},{10,200504},{13,200505},},nil,1,256,IS_REMIX},

--Remix Exclusive models --Didn't actually drop in remix: {5,196877},{13,198477},{13,198476},{5,196875},{13,198474},{13,198475},{14,197206},
{5069,"Fearspeaker","Remix Exclusives (MoP)","Red",50000,nil,nil,{{15,197291,nil,Zone(5)},{4,196867,nil,Zone(17)},{13,197152,nil,Zone(17)},{13,197149,NOT_REMIX},{13,197143,nil,Zone(16)},{12,198525,nil,Zone(9,10)},{12,198527,nil,Zone(2)},{10,196967,nil,Zone(2)},{8,197071,nil,Zone(5)},{8,197070,nil,Zone(8)},{6,196961,nil,Zone(3)},{5,196925,nil,Zone(12)},{3,196849,nil,Zone(3)},{1,196804,nil,Zone(3)},{2,196825,nil,Zone(8)},{8,197039,nil,Zone(15)},{9,197098,nil,Zone(20)},},nil,1,nil,IS_REMIX},
{5068,"Fearspeaker","Remix Exclusives (MoP)","Blue",50000,nil,nil,{{15,197292,nil,Zone(3)},{13,197150,nil,Zone(15)},{13,197146,nil,Zone(15)},{13,197142,nil,Zone(15)},{12,198523,nil,Zone(2,3)},{12,198529,nil,Zone(3)},{10,196968,nil,Zone(1,3)},{8,197072,nil,Zone(2)},{8,197069,nil,Zone(3)},{6,196960,nil,Zone(2)},{5,196922,nil,Zone(13)},{3,196850,nil,Zone(2)},{1,196805,nil,Zone(2)},{2,196822,nil,Zone(2)},{9,197097,nil,Zone(19)},},nil,1,nil,IS_REMIX},
{5067,"Fearspeaker","Remix Exclusives (MoP)","Purple",50000,nil,nil,{{15,197290,Zone(2)},{13,197151,nil,Zone(16)},{13,197147,nil,Zone(16)},{13,197144,nil,Zone(17)},{12,198526,nil,Zone(5)},{12,198530,nil,Zone(8)},{8,197073,nil,Zone(3)},{8,197067,nil,Zone(2)},{2,196823,nil,Zone(5)},},nil,1,nil,IS_REMIX},
{5066,"Fearspeaker","Remix Exclusives (MoP)","Yellow",50000,nil,nil,{{5,196876},{4,196866,nil,Zone(16)},{13,197153,nil,Zone(15)},{13,197148,nil,Zone(17)},{13,197145,nil,Zone(15)},{12,198524,nil,Zone(2)},{12,198528,nil,Zone(5)},{8,197068,nil,Zone(5)},{6,196959,nil,Zone(5)},{5,196924,nil,Zone(11)},{3,196851,nil,Zone(5)},{1,196806,nil,Zone(5)},{2,196824,nil,Zone(3)},{9,197096,nil,Zone(18)},},nil,1,nil,IS_REMIX},

--SoO Remix colors
{5065,"Sha-Touched","SoO Remix Colors","Mythic",50400,nil,nil,{{1,196782,nil,Zone(23)},{1,196786,nil,Zone(23)},{1,196790,nil,Zone(23)},{3,196837,nil,Zone(23)},{5,196890,nil,Zone(23)},{8,197027,nil,Zone(23)},{10,196980,nil,Zone(23)},{12,198547,nil,Zone(23)},{13,197129,nil,Zone(23)},{13,197133,nil,Zone(23)},{14,197223,nil,Zone(23)},{14,197215,nil,Zone(23)},},nil,1,nil,IS_REMIX};
{5064,"Sha-Touched","SoO Remix Colors","Normal/Heroic",50400,nil,nil,{{3,196832,nil,Zone(22)},{4,196864,nil,Zone(22)},{6,196939,nil,Zone(22)},{7,197000,nil,Zone(22)},{8,197021,nil,Zone(22)},{13,197139,nil,Zone(22)},{13,197124,nil,Zone(22)},{14,197218,nil,Zone(22)},{14,197225,nil,Zone(22)},{16,197297,nil,Zone(22)},},nil,1,nil,IS_REMIX};
{5063,"Sha-Touched","SoO Remix Colors","Raid Finder",50400,nil,nil,{{2,196811,nil,Zone(21)},{5,196882,nil,Zone(21)},{10,196973,nil,Zone(21)},{13,197134,nil,Zone(21)},{13,197138,nil,Zone(21)},{15,197274,nil,Zone(21)},{14,100384,NOT_REMIX},},nil,1,nil,IS_REMIX};
--{8,67065,NOT_REMIX},--SoO recolor (also drops from rare in WoD)

--Siege of Orgrimmar
{5062,"Pride's Fall","Siege of Orgrimmar","Raid Finder",50400,nil,nil,{{11,56612},{13,56522},{9,56569},{13,56503},{15,56507},{11,56210},{13,56628},{13,56614},{13,56447},{2,56638},{14,56564},{8,56456},{14,56589},{1,56553},{8,56641},{5,56562},{8,56556},{14,56627},{1,56621},{1,56579},{5,56484},{5,56623},{8,56527},{6,56467},{14,56492},{3,56509},{4,56466},{3,56620},{16,56600},{7,56572},{12,55820},{12,56570},{12,55842},{12,56508},{10,56610},{10,56541},{10,56478},{10,56642},},3},
{5061,"Pride's Fall","Siege of Orgrimmar","Normal",50400,"Note: Heroic drops these same appearances.",nil,{{11,55913},{13,55846},{9,55906},{13,55844},{15,55840},{13,55935},{13,55845},{13,55722},{2,55685},{14,55907},{8,55723},{14,55922},{1,55887},{8,55898},{5,55806},{8,55897},{14,55933},{1,55932},{1,55912},{5,55807},{5,55805},{5,55934},{8,55871},{6,55765},{14,55804},{3,55852},{4,55766},{3,55853},{16,55925},{7,55914},{12,55842},{12,55843},{12,55820},{12,55841},{12,55821},{10,55880},{10,55879},{10,55783},{10,55881},},3},
{5060,"Pride's Fall","Siege of Orgrimmar","Mythic",50400,nil,nil,{{11,56210},{13,56120},{9,56167},{13,56101},{15,56105},{11,56171},{13,56226},{13,56212},{13,56045},{2,56236},{14,56162},{8,56054},{14,56187},{1,56151},{8,56239},{5,55807},{8,56154},{14,56225},{1,56219},{1,56177},{5,56160},{5,56082},{5,56221},{8,56125},{6,56065},{14,56090},{3,56107},{4,56064},{3,56218},{16,56198},{7,56170},{12,56195},{12,56168},{12,56095},{12,56106},{10,56208},{10,56139},{10,56076},{10,56240},},3},

--Season 3
{5059,"Grievous","Season 14/15 (MoP 3/4)","Gladiator",50400,"i:144251:4:Arsenal Grievous Gladiator's Weapons","i:144248:4:Arsenal Prideful Gladiator's Weapons",{{16,53651},{13,53659},{8,53650},{1,53658},{2,53669},{13,53666},{8,53648},{15,53657},{3,53649},{14,53656},{11,53665},{14,53664},{6,53662},{7,53655},{5,53661},{5,54785},{10,53816},{12,53815},{12,53817},},1},
{5058,"Grievous","Season 14/15 (MoP 3/4)","Gladiator",50400,"i:144252:4:Arsenal Grievous Gladiator's Weapons","i:144250:4:Arsenal Prideful Gladiator's Weapons",{{16,53366},{13,53362},{8,53330},{1,53328},{2,53322},{13,53430},{8,53426},{15,53326},{3,53336},{14,53612},{11,53527},{14,53332},{6,53606},{7,53424},{5,53604},{5,53360},{10,53356},{12,53358},{12,53624}},1},
{5057,"Grievous","Season 14/15 (MoP 3/4)","Elite",50400,nil,nil,{{16,53367},{13,53363},{8,53331},{1,53329},{13,53431},{8,53427},{15,53327},{3,53337},{14,53613},{11,53528},{14,53333},{6,53607},{7,53425},{5,53605},{5,53361},{10,53357},{12,53359},{2,53323},{12,53625}},1,1},

--Throne of Thunder Remix Colors
{5056,"Breaker","ToT Remix Colors","Raid Finder",50000,nil,nil,{{2,196827,nil,Zone(18)},{3,196852,nil,Zone(18)},{5,198434,nil,Zone(18)},{5,196935,nil,Zone(18)},{5,196937,nil,Zone(18)},{8,198446,nil,Zone(18)},{8,197075,nil,Zone(18)},{8,197077,nil,Zone(18)},{11,197123,nil,Zone(18)},{14,197267,nil,Zone(18)},{14,197268,nil,Zone(18)},{9,198457,nil,Zone(18)},},nil,1,nil,IS_REMIX};
{5055,"Breaker","ToT Remix Colors","Normal",50000,nil,nil,{{1,196809,nil,Zone(19)},{1,197318,nil,Zone(19)},{3,196857,nil,Zone(19)},{4,196872,nil,Zone(19)},{5,198435,nil,Zone(19)},{5,196936,nil,Zone(19)},{8,197076,nil,Zone(19)},{8,197083,nil,Zone(19)},{8,197079,nil,Zone(19)},{10,196997,nil,Zone(19)},{13,197190,nil,Zone(19)},{13,198479,nil,Zone(19)},{14,197269,nil,Zone(19)},{16,197314,nil,Zone(19)},{13,198484,nil,Zone(19)},{5,198427,nil,Zone(19)},{12,198584,nil,Zone(19)},{6,196963,nil,Zone(19)},},nil,1,nil,IS_REMIX};
{5054,"Breaker","ToT Remix Colors","Heroic",50000,nil,nil,{{7,197019,nil,Zone(20)},{12,198573,nil,Zone(20)},{13,197201,nil,Zone(20)},{13,198488,nil,Zone(20)},{6,198424,nil,Zone(20)},},nil,1,nil,IS_REMIX};
{5053,"Breaker","ToT Remix Colors","Isle of Thunder",50000,nil,nil,{{3,196860,nil,Zone(8)},{12,198588,nil,Zone(9,10)},{12,198589,nil,Zone(8)},{12,198520,nil,Zone(8)},{14,197211,nil,Zone(9,10)},{15,197273,nil,Zone(9,10)},},nil,1,nil,IS_REMIX};
{5052,"Breaker","ToT Remix Colors","Tier 14 LFR",50000,nil,nil,{{11,197109,nil,Zone(17)},},nil,1,nil,IS_REMIX};
{5051,"Breaker","ToT Remix Colors","Tier 14 Heroic",50000,nil,nil,{{11,197100,nil,Zone(16)},},nil,1,nil,IS_REMIX};
--{16,100312,NOT_REMIX},--also from island expeditions

--Throne of Thunder all boss loot
{5050,"Mind's Eye","ToT Common Drops","Raid Finder",50200,nil,nil,{{8,50359},{13,50354},{5,50120},{9,50350},{14,50368},{15,50367},{11,50369},{8,50353},{6,51415},{3,50351},{12,50370},},3},
{5049,"Mind's Eye","ToT Common Drops","Normal",50200,nil,nil,{{5,50120},{8,50118},{14,50116},{6,51412},{8,50114},{3,50117},{12,50123},{13,50121},{11,50112},{9,50113},{15,50119},},3},
{5048,"Mind's Eye","ToT Common Drops","Heroic",50200,nil,nil,{{8,50983},{8,50977},{5,50120},{14,50992},{3,50975},{12,50994},{9,50974},{15,50991},{11,50993},{13,50978},{6,51413},},3},

--Throne of Thunder --20110
{5047,"The Emperor","Throne of Thunder","Raid Finder",50200,nil,nil,{{13,50188},{13,50238},{13,50179},{11,50305},{13,50300},{2,50311},{15,50202},{8,50269},{6,50197},{5,50282},{8,49765},{5,50287},{1,50194},{5,49640},{14,50296},{5,50257},{1,50210},{14,50174},{8,50315},{1,50168},{6,50297},{4,50244},{3,50203},{16,50189},{7,50288},{12,50278},{12,50299},{12,50216},{12,50312},{10,50230},{10,50316},{10,50107},},3},
{5046,"The Emperor","Throne of Thunder","Normal",50200,nil,nil,{{13,49604},{13,49653},{13,49596},{11,49791},{13,49784},{2,49790},{15,49612},{8,49748},{6,49614},{5,49766},{8,49765},{5,49781},{1,49613},{5,49640},{14,49774},{5,49739},{1,49621},{14,49587},{8,49796},{1,49580},{6,49783},{4,49662},{3,49622},{16,49609},{7,49773},{12,49756},{12,50122},{12,49630},{12,50106},{10,49645},{10,50107},{10,49775},},3},
{5045,"The Emperor","Throne of Thunder","Heroic",50200,nil,nil,{{13,50812},{13,50862},{13,50803},{11,50929},{13,50924},{2,50935},{15,50826},{8,50893},{6,50821},{5,50906},{8,49765},{5,50911},{1,50818},{5,49640},{14,50920},{5,50881},{1,50834},{14,50798},{8,50939},{1,50792},{6,50921},{4,50868},{3,50827},{16,50813},{7,50912},{12,50902},{12,50923},{12,50840},{12,50936},{10,50854},{10,49775},{10,50916},},3},

--Season 2
{5044,"Tyrannical","Season 13 (MoP 2)","Gladiator",50200,"i:144245:4:Arsenal Tyrannical Gladiator's Weapons","Using either Arsenal will unlock both Faction sets.",{{13,49293},{8,49282},{1,49292},{2,49303},{13,49300},{15,49291},{4,49306},{14,49290},{14,49298},{6,49296},{5,49295},{5,49286},{13,49287},{10,49450},{12,49449},{12,49451},},1,nil,"Horde"},
{5043,"Tyrannical","Season 13 (MoP 2)","Gladiator",50200,"i:144246:4:Arsenal Tyrannical Gladiator's Weapons","Using either Arsenal will unlock both Faction sets.",{{13,47437},{13,47505},{13,47480},{5,47679},{5,47435},{8,47405},{1,47403},{14,47687},{14,47407},{2,47397},{15,47401},{6,47681},{4,47443},{10,47431},{12,47433},{12,47699}},1,nil,"Alliance"},
{5042,"Tyrannical","Season 13 (MoP 2)","Elite",50200,nil,nil,{{13,47438},{13,47506},{13,47481},{5,47680},{5,47436},{8,47406},{1,47404},{14,47688},{14,47408},{2,47398},{15,47402},{6,47686},{4,47444},{10,47432},{12,47434},{12,47700},},1,1},

--Terrace of Endless Spring Remix Colors
{5041,"Fear incarnate","Tier 14 Remix Colors","Raid Finder",50004,nil,nil,{{13,197160,nil,Zone(15)},{6,196946,nil,Zone(15)},{5,196898,nil,Zone(15)},{11,197107,nil,Zone(15)},{12,198555,nil,Zone(15)},{5,196894,nil,Zone(15)},},nil,1,nil,IS_REMIX};
{5040,"Fear incarnate","Tier 14 Remix Colors","Normal",50004,nil,nil,{{2,196816,nil,Zone(16)},},nil,1,nil,IS_REMIX};
{5039,"Fear incarnate","Tier 14 Remix Colors","Heroic",50004,nil,nil,{{7,197004,nil,Zone(17)},{14,197236,nil,Zone(17)},{5,196899,nil,Zone(17)},{3,196840,nil,Zone(17)},},nil,1,nil,IS_REMIX};

--Terrace of Endless Spring
{5038,"The Waterspeaker","Terrace of Endless Spring","Raid Finder",50004,nil,nil,{{13,44747},{13,44757},{2,44768},{14,44769},{14,44751},{5,44734},{5,44772},{7,44754},},3},
{5037,"The Waterspeaker","Terrace of Endless Spring","Normal",50004,nil,nil,{{13,44374},{13,44384},{2,44395},{14,44396},{14,44378},{5,44350},{5,44399},{7,44381},},3},
{5036,"The Waterspeaker","Terrace of Endless Spring","Heroic",50004,nil,nil,{{13,44988},{13,44998},{2,45002},{14,45000},{14,44993},{5,44836},{5,44995},{7,44996},},3},

--Heart of Fear
{5035,"The Swarm","Heart of Fear","Raid Finder",50004,nil,nil,{{6,44736},{8,44737},{14,44735},{5,44734},{10,44706},},3},
{5034,"The Swarm","Heart of Fear","Normal",50004,nil,nil,{{6,44358},{8,44359},{14,44352},{5,44350},{10,44310},},3},
{5033,"The Swarm","Heart of Fear","Heroic",50004,nil,nil,{{6,44841},{8,44843},{14,44840},{5,44836},{10,44818},},3},

--Mogu'shan Vaults
{5032,"Sleeping Emperor","Mogu'shan Vaults","Raid Finder",50004,nil,nil,{{11,44665},{15,44683},{5,44638},{1,44676},{6,44657},{8,44688},{3,44685},{16,44680},{12,44659},{12,44666},{10,45190},},3},
{5031,"Sleeping Emperor","Mogu'shan Vaults","Normal",50004,nil,nil,{{11,44246},{15,44287},{5,44135},{1,44280},{6,44186},{8,44292},{3,44289},{16,44284},{12,44188},{12,44247},{10,46318},},3},
{5030,"Sleeping Emperor","Mogu'shan Vaults","Heroic",50004,nil,nil,{{12,44889},{12,44898},{10,40213},{11,44894},{15,44907},{5,44865},{1,44908},{6,44883},{8,44917},{3,44913},{16,44910},},3},

--Season 1
{5029,"Malevolent","Season 12 (MoP 1)","Elite",50000,nil,nil,{{9,43550},{11,43551},{13,43552},{13,43553},{13,43554},{15,43555},{2,43556},{10,43557},{10,43557},{3,43562},{7,43566},{12,43567},{12,43568},{5,43570},{6,43571},{8,43573},{1,43574},{5,43576},{8,43580},{14,43577}},1,1},
{5028,"Malevolent","Season 12 (MoP 1)","Gladiator",50000,"i:144243:4:Arsenal Malevolent Gladiator's Weapons",nil,{{13,43259},{8,43413},{9,43257},{1,43408},{2,43263},{13,43260},{8,43414},{15,43262},{1,43409},{3,43354},{11,43258},{8,43407},{14,43412},{6,43406},{7,43358},{6,43405},{5,43410},{14,43411},{5,43404},{13,43261},{10,43331},{10,43332},{12,43205},{12,43370},{12,43368},},1},

{5027,"Klaxxi'vess","Klaxxi","",50004,nil,nil,{{14,44487},{14,44490},{15,44488},{8,45197},{11,44486},{13,44489},{7,46294},{5,44019},{5,46288},}},
--{13,108406} --dup app id

--Appearance id duplicate:  (item id: ) shares appearance with  (item id: ).

--MoP Dungeon Remix Colors
{5026,"Yak-Herder's","Dungeon Remix Colors","Normal",50004,nil,nil,{{5,196919,nil,Zone(13)},{5,196914,nil,Zone(13)},{10,196992,nil,Zone(13)},{12,198569,nil,Zone(13)},{6,196955,nil,Zone(13)},{9,197092,nil,Zone(13)},},nil,1,nil,IS_REMIX};
{5025,"Yak-Herder's","Dungeon Remix Colors","Heroic",50004,nil,nil,{{10,196993,nil,Zone(14)},{13,197181,nil,Zone(14)},{6,196956,nil,Zone(14)},{15,197286,nil,Zone(14)},},nil,1,nil,IS_REMIX};
{5024,"Yak-Herder's","Scenario Remix Colors","Normal",50004,nil,nil,{{5,196920,nil,Zone(11)},{5,196917,nil,Zone(11,12)},{7,197015,nil,Zone(11)},{11,197117,nil,Zone(11)},{12,198571,nil,Zone(11)},{3,196847,nil,Zone(11)},{12,60753,NOT_REMIX},},nil,1,nil,IS_REMIX};
{5023,"Yak-Herder's","Scenario Remix Colors","Heroic",50004,nil,nil,{{5,196921,nil,Zone(12)},{5,196917,nil,Zone(11,12)},{8,197066,nil,Zone(12)},{11,197118,nil,Zone(12)},{6,196958,nil,Zone(12)},{15,197289,nil,Zone(12)},},nil,1,nil,IS_REMIX};

--Rares
{5022,"Dawnwatcher's","Rare Drops (MoP)","",50004,nil,nil,{{11,45158},{1,45231},{1,45228},{3,45200},{3,196847},{5,45199},{5,45223},{6,45224},{9,45306},{9,45156},{13,44333},{15,45161},{7,45203},{13,49672},{10,45189},}},

--MoP Dungeons
{5021,"Carapace","Dungeon (MoP)","Gate of the Setting Sun",50004,nil,nil,{{8,40767},{5,40768},{3,45246},{12,40968},{12,40766},}},
{5020,"Firescribe","Dungeon (MoP)","Mogu'shan Palace",50004,nil,nil,{{11,40980},{15,45242},{6,40978},{5,40984},}},
{5019,"Ravager","Dungeon (MoP)","Scarlet Halls",50004,nil,nil,{{9,2932},{2,2927},{5,17213},{5,42114},{4,17364},}},
{5018,"Firestorm","Dungeon (MoP)","Scarlet Monastery",50004,nil,nil,{{13,41191},{13,2155},{15,10164},{13,2922},{13,2155},}},
{5017,"Bringer of Death","Dungeon (MoP)","Scholomance",50004,nil,nil,{{2,32319},{15,5453},{16,45201},{12,42143},{15,17270},{13,14304},}},
{5016,"Blind Hate","Dungeon (MoP)","Shado-Pan Monastery",50004,nil,nil,{{13,40771},{9,40770},{1,40722},{6,45243},{12,40769},}},
{5015,"Gustwalker","Dungeon (MoP)","Siege of Niuzao Temple",50004,nil,nil,{{13,41005},{6,41003},{14,40991},{5,40768},{3,40996},}},
{5014,"Keg Tapper","Dungeon (MoP)","Stormstout Brewery",50004,nil,nil,{{13,40931},{8,40733},{1,45228},{14,40731},{7,40734},{10,40732},}},
{5013,"Firebelcher","Dungeon (MoP)","Temple of the Jade Serpent",50004,nil,nil,{{13,40887},{1,40712},{8,45244},{7,40711},}},

--Leveling
{5012,"Barbarian","Leveling (MoP)","Green",50000,nil,nil,{{16,41417},{16,197309,IS_REMIX,Zone(14)},{15,41281},{14,41277},{14,41793},{14,45198},{14,43102},{13,40670},{13,42415},{13,45157},{13,45155},{13,197168,IS_REMIX,Zone(3,6)},{13,40668},{1,41175},{4,42051},{7,197012,IS_REMIX,Zone(7,8)},{3,41173},{9,41530},{5,41744},{5,196912,IS_REMIX,Zone(3,6)},{1,42419},{8,40677},{8,41422},{8,40675},{8,45227},{11,41790},{5,43110},{2,41419},{6,41431},{6,41535},{9,41274},{1,38583},{10,40211},{10,196988,IS_REMIX,Zone(9,10)},{10,47038},{10,47021},{12,41429},{12,42797},{12,41180},}},
{5011,"Barbarian","Leveling (MoP)","Red",50000,nil,nil,{{16,41522},{16,197310,IS_REMIX,Zone(11)},{15,41178},{14,42421},{14,43107},{14,41740},{14,40731},{13,41526},{13,42903},{13,41191},{13,40887},{13,41792},{13,41791},{1,41779},{2,41426},{5,41424},{5,41953},{1,41275},{4,41421},{8,41278},{8,41683},{8,40683},{6,42893},{6,41682},{3,41780},{11,41737},{7,41534},{8,45230},{1,197328,IS_REMIX,Zone(4)},{10,38584},{10,46802},{10,47073},{10,47074},{12,41283},{12,42796},{12,40681},}},
{5010,"Barbarian","Leveling (MoP)","Blue",50000,nil,nil,{{16,41169},{16,45204},{15,40671},{14,43100},{14,40679},{14,41179},{13,40669},{13,41271},{13,45310},{13,197177,IS_REMIX,Zone(13)},{13,41739},{13,197175,IS_REMIX,Zone(3,6)},{5,40676},{5,41638},{1,41420},{2,40678},{8,42053},{7,41732},{6,41788},{5,41168},{3,41727},{1,40674},{4,40673},{11,41170},{8,41577},{8,197047,IS_REMIX,Zone(1,2)},{1,197327,IS_REMIX,Zone(1)},{10,198463,IS_REMIX,Zone(4)},{8,45311},{10,47072},{10,46801},{10,196989,IS_REMIX,Zone(1,2)},{10,47039},{12,42890},{12,40680},}},
{5009,"Barbarian","Leveling (MoP)","Purple",50000,nil,nil,{{14,43097},{14,42795},{14,45225},{14,42788},{13,41536},{13,45160},{13,41738},{8,41174},{11,41418},{5,41537},{5,42886},{5,41430},{7,41626},{6,41431},{1,40672},{9,45306},{1,197324,IS_REMIX,Zone(7)},{10,198462,IS_REMIX,Zone(1)},{10,47020},{10,196990,IS_REMIX,Zone(3)},{12,43109},}},
{5008,"Barbarian","Leveling (MoP)","Yellow",50000,nil,nil,{{16,197304,IS_REMIX,Zone(1,2)},{16,45201},{15,41171},{14,42052},{14,41427},{14,41172},{14,40991},{13,42046},{13,40771},{9,41786},{5,40682},{5,41182},{13,197174,IS_REMIX,Zone(1,2)},{8,42884},{6,196954,IS_REMIX,Zone(7,8)},{2,41541},{8,41425},{10,198465,IS_REMIX,Zone(7)},{1,42050},{1,197325,IS_REMIX,Zone(7)},{3,49674},{4,41276},{8,40733},{10,47075},{12,41428},{12,42891},}},

--Profession Weapons
{5007,"Ghost-Forged","Profession (MoP)","Common",50004,nil,nil,{{1,42240},{2,42243},{5,42244},{7,39120},{8,42242},{10,40212},{12,42238},{12,42239},{13,40217},{13,40214},{14,42241},}},
{5006,"Ghost-Forged","Profession (MoP)","Masterwork",50004,nil,nil,{{1,42247},{2,42250},{5,42251},{7,39121},{8,42249},{10,40213},{10,45190},{12,42245},{12,42246},{13,40218},{13,40215},{13,40216},{14,42248},}},
{5005,"Ghost-Forged","Profession (MoP)","Archeology",50004,nil,nil,{{10,46495},{11,46496},{14,50082},{7,50083},}},

--Trainee's
{5004,"Pandaren","The Wandering Isle","Gold",50000,nil,nil,{{15,37532},{15,198500,IS_REMIX,Zone(4)},{12,198531,IS_REMIX,Zone(6)},{12,37510},{13,37536},{14,38085},{5,37505},{10,198459,IS_REMIX,Zone(6)},{8,93247,},{4,37531},{13,197193,IS_REMIX,Zone(2)},{14,197261,IS_REMIX,Zone(5)},{13,197199,IS_REMIX,Zone(3)},{5,196930,IS_REMIX,Zone(3)},{5,196927,IS_REMIX,Zone(5)},}},
{5003,"Pandaren","The Wandering Isle","Jade",50000,nil,nil,{{15,38083},{15,198502,IS_REMIX,Zone(7)},{12,38081},{8,37504},{13,37506},{5,38084},{4,38082},{10,38585},{14,198496,IS_REMIX,Zone(4)},{13,44351},{14,197262,IS_REMIX,Zone(3)},{13,197197,IS_REMIX,Zone(2)},{5,196932,IS_REMIX,Zone(5)},{5,196928,IS_REMIX,Zone(3)},}},
{5002,"Pandaren","The Wandering Isle","Silver",50000,nil,nil,{{15,37507},{12,198532,IS_REMIX,Zone(1)},{13,38087},{4,37508},{4,198591,IS_REMIX,Zone(1)},{5,37533},{10,198458,IS_REMIX,Zone(1)},{8,198444,IS_REMIX,Zone(1)},{14,198495,IS_REMIX,Zone(1)},{13,197196,IS_REMIX,Zone(8)},{14,197260,IS_REMIX,Zone(2)},{13,197198,IS_REMIX,Zone(5)},{5,196931,IS_REMIX,Zone(2)},{5,196926,IS_REMIX,Zone(2)},}},
{5001,"Pandaren","The Wandering Isle","Red",50000,nil,nil,{{12,37530},{5,37535},{14,38582},{10,198460,IS_REMIX,Zone(7)},{4,198594,IS_REMIX,Zone(7)},{13,46421,IS_REMIX,Zone(3)},{14,197263,IS_REMIX,Zone(8)},{13,197200,IS_REMIX,Zone(8)},{5,196933,IS_REMIX,Zone(8)},{5,196929,IS_REMIX,Zone(8)},{13,198493,IS_REMIX,Zone(7)},{8,37534},{8,198442,IS_REMIX,Zone(7)},}},
};

local function comp(a,b)
  if a[1] < b[1] then return true; else return false end
end
table.sort(db,comp);


local function AddToCollection()
  for i = 1, #db do
    app.AddWepDBLineToTables(db[i], expansionID);
  end
end
app.WeaponCallbacks[expansionID] = AddToCollection;

local function GetSetNameBySetID(setID)
  if not db[setID] then return end  
  
  local label = db[setID][3]
  local name;
  if db[setID][4] then name = db[setID][4] else name = db[setID][2] end
  
  return label, name;
end
app.GetExpacWepSetNameBySetID[expansionID] = GetSetNameBySetID;

local function GetSetSourcesBySetID(setID)
  if not db[setID] then return end

  return db[setID][8];
end
app.GetExpacWepSetSourcesBySetID[expansionID] = GetSetSourcesBySetID