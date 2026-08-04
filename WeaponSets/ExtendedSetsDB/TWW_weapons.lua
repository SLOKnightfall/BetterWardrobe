local app = select(2,...);

local expansionID = 11;

--Name, Label, Difficulty, patchID, desc1, desc2, sources, specialSource: (1 = pvp, 2 = trading post, 3 = isRaid), time: (1 = no longer obtainable, 2 = limited time set), requiredFact, 
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

--Start of SL: 82432(raid 2h mace), 83206, 83606
local db = {
{11129,"TWW_Seawashed","TWW_BygoneRiches",nil,110007,"li:232372","SirenIsle",{{5,231274},{10,231276},{10,231270},{8,231269},{13,231263},{13,231263},{2,231363},}},

{11041,"TWW_Sindorei","TWW_Sunfury",nil  ,110208,app.GetTradingPostReleaseString("Feb",2026),nil,{{13,302327},{3,302320},{6,302319},{16,302324}}},
{11128,"TWW_Queldorei","TWW_Sunfury",nil ,110208,app.GetTradingPostReleaseString("Feb",2026),nil,{{13,302322},{11,302323}}},

{11127,"TWW_SCRAP","TWW_SCRAPPiles",nil,110100,nil,nil,{{8,284665},{3,284653},{7,284638},{14,284656}}},

{11126,"TWW_Ethereal","TWW_Anubisath",nil,110207,nil,nil,{--[[{12,298259},]]{15,301181},{14,301307},},2},--blue
{11125,"TWW_Lifesurged","TWW_Anubisath",nil,110207,nil,nil,{ --[[{12,298260},]]{15,301178},{14,301304},},2},--green
{11124,"TWW_Sunscorched","TWW_Anubisath",nil,110207,nil,nil,{  --[[{12,298261},]]{15,301179},{14,301305},},2},--purple
{11123,"TWW_WepSetDesc13","TWW_Anubisath",nil,110207,app.GetTradingPostReleaseString("Feb",2026),nil,{   --[[{12,298262},]]{15,301180},{14,301306},},2},--yellow

{11122,"TWW_Emerald","TWW_CrusadersGemblades",nil,110207,nil,nil,{ {14,298600},{15,298604},{9,298772},{8,298776},},2},
{11121,"TWW_Amethyst","TWW_CrusadersGemblades",nil,110207,nil,nil,{{14,298601},{15,298605},{9,298773},{8,298777},},2},
{11120,"TWW_Ruby","TWW_CrusadersGemblades",nil,110207,nil,nil,{    {14,298602},{15,298606},{9,298775},{8,298778},},2},
{11119,"TWW_Citrine","TWW_CrusadersGemblades",nil,110207,nil,nil,{ {14,298603},{15,298607},{9,298774},{8,298779},},2},

{11118,"TWW_SpiritTouched","TWW_SpiritSoul",nil,110201,nil,nil,{{3,287516},{11,287444},{8,287268},{12,287100},{16,285322},{5,285320},{1,285318},{13,285315},{10,285324},{14,285240},{15,285236},},4},
{11117,"TWW_SoulTouched","TWW_SpiritSoul",nil,110201,nil,nil,  {{3,287517},{11,287445},{8,287269},{12,287101},{16,285323},{5,285321},{1,285319},{13,285316},{10,285325},{14,285239},{15,285237},},4},
{11116,"TWW_Soulweave","TWW_SpiritSoul",nil,110201,nil,nil,     {{3,287518},{12,287102},{13,285317},{15,285238},},4},

{11115,"TWW_IceQueenFrozen","TWW_IceQueen",nil,110205,nil,nil, {{17,295709},{2,295699},{16,295683},{5,295661},},2},
{11114,"TWW_IceQueenFiery","TWW_IceQueen",nil,110205,nil,nil,  {{17,295710},{2,295700},{16,295696},{5,295662},},2},
{11113,"TWW_IceQueenArcane","TWW_IceQueen",nil,110205,nil,nil, {{17,295711},{2,295701},{16,295697},{5,295663},},2},
{11112,"TWW_IceQueenGlowing","TWW_IceQueen",nil,110205,nil,nil,{{17,295712},{2,295702},{16,295698},{5,295664},},2},

{11111,"TWW_FoodFanatic","TWW_FoodFanatic","Desc_Yellow",110205,nil,nil,{{10,298419},{8,298412},{10,298387},{8,298383},{10,298326},{8,298325},{12,298039},{12,297783},{11,296289},{5,295719},{11,295707},{15,295665},{10,295657},{1,295656},},2},
{11110,"TWW_FoodFanatic","TWW_FoodFanatic","Desc_Red",110205,nil,nil,{   {10,298418},{8,298411},{10,298385},{8,298381},{10,298328},{8,298323},{12,298040},{12,297784},{11,296287},{5,295718},{11,295706},{15,295667},{10,295658},{1,295653},},2},
{11109,"TWW_FoodFanatic","TWW_FoodFanatic","Desc_Orange",110205,nil,nil,{{10,298417},{8,298410},{10,298384},{8,298380},{10,298329},{8,298322},{12,298041},{12,297785},{11,296290},{5,295720},{11,295703},{15,295666},{10,295659},{1,295654},},2},
{11108,"TWW_FoodFanatic","TWW_FoodFanatic","TWW_WepSetDesc10",110205,nil,nil,{ {10,298416},{8,298409},{10,298386},{8,298382},{10,298327},{8,298324},{12,298042},{12,297786},{11,296288},{5,295717},{11,295708},{15,295668},{10,295660},{1,295655},},2},

{11107,"TWW_PhaseLost","TWW_PhaseDiving",nil,110199,"Desc_CriteriaOf","a:61017",{{2,297802},{12,297821},{16,297822},{6,297817,"",""},{14,297792},{6,297816},{1,297797},{8,297795},{15,297799},{9,297801},{8,297794},{5,297811},{16,297823},{13,297807},{15,297798},{9,297800},{2,297803},{13,297806},{12,297820},{14,297793},{1,297796},{10,297818},{10,297819},{7,297808},{5,297810},{3,297824},{11,297804},{11,297805},}},

{11105,"TWW_DwarvenCereBronzebeard","TWW_DwarvenCere",nil,110200,nil,nil,{{4,293203},{9,293190},{10,292913},{8,292909},},2},
{11104,"TWW_DwarvenCereSpeaker","TWW_DwarvenCere",nil,110200,nil,nil,{{4,293204},{9,293191},{10,292914},{8,292910},},2},
{11103,"TWW_DwarvenCereDarkIron","TWW_DwarvenCere",nil,110200,nil,nil,{{4,293206},{9,293193},{10,292916},{8,292912},}},
{11102,"TWW_DwarvenCereWildhammer","TWW_DwarvenCere",nil,110200,nil,nil,{{4,293205},{9,293192},{10,292915},{8,292911},},2},

{11101,"TWW_WepSetName53","TWW_Horseman",nil,110200,nil,nil,{{12,295245},{15,295241},{14,295237},},2},
{11100,"TWW_HorsemanGhoulish","TWW_Horseman",nil,110206,"HallowsEnd",nil,{{12,295246},{15,295242},{14,295238},}},
{11099,"TWW_HorsemanBurning","TWW_Horseman",nil,110200,nil,nil,{ {12,295247},{15,295243},{14,295239},},2},
{11098,"TWW_HorsemanGhostly","TWW_Horseman",nil,110200,nil,nil,{ {12,295248},{15,295244},{14,295240},},2},

{11097,"TWW_FelreaverColdsnap",   "TWW_Felreaver",nil,110200,nil,nil,{{16,293249},{13,293244},{5,293198},{14,293194},},2},
{11096,"TWW_FelreaverLegion",     "TWW_Felreaver",nil,110200,nil,nil,{{16,293250},{13,293245},{5,293201},{14,293195},},nil,nil,nil,7},
{11095,"TWW_FelreaverHellfire",   "TWW_Felreaver",nil,110200,nil,nil,{{16,293251},{13,293246},{5,293199},{14,293196},},2},
{11094,"TWW_FelreaverNetherstorm","TWW_Felreaver",nil,110200,nil,nil,{{16,293252},{13,293247},{5,293200},{14,293197},},2},

{11093,"TWW_Starcrusher","TWW_ManaforgeOmega","LFR",110200,nil,nil,{{13,292977},{11,293130},{15,293148},{9,293182},{9,291869},{13,293136},{17,293154},{8,293127},{1,293170},{8,293124},{5,293139},{6,293133},{5,293160},{14,293176},{4,293164},{3,293185},{12,295951},{10,293167},{10,293151},},3},
{11092,"TWW_Starcrusher","TWW_ManaforgeOmega","Normal",110200,nil,nil,{{12,286913},{10,286932},{10,286914},{13,286916},{11,286929},{15,286927},{9,286915},{13,286920},{17,286917},{8,286921},{1,286924},{8,286926},{5,286919},{6,286928},{5,286918},{14,286925},{4,286923},{3,286922},{9,291869},},3},
{11091,"TWW_Starcrusher","TWW_ManaforgeOmega","Heroic",110200,nil,nil,{{13,293146},{11,293131},{15,293149},{9,293183},{13,293137},{17,293155},{8,293128},{1,293171},{8,293125},{5,293140},{6,293134},{5,293161},{14,293177},{4,293165},{3,293186},{9,291869},{12,293143},{10,293168},{10,293152},},3},
{11090,"TWW_Starcrusher","TWW_ManaforgeOmega","Mythic",110200,nil,nil,{{13,293147},{11,293132},{15,293150},{9,293184},{9,291869},{13,293138},{17,293156},{8,295968},{1,293172},{8,293126},{5,293141},{6,293135},{5,293162},{14,293178},{4,293166},{3,293187},{12,293144},{10,293169},{10,293153},},3},

{11089,"TWW_Starcrusher","TWW_AstralGlad","Gladiator",110200,nil,nil,{{3,295478},{9,295480},{8,293129},{8,295473},{17,295467},{4,295472},{12,295475},{6,295477},{1,295486},{11,295468},{13,295471},{13,295469},{5,295487},{5,295465},{15,295470},{10,295474},{10,295489},{14,295481},},1},
{11088,"TWW_Starcrusher","TWW_AstralGlad","Elite",110200,nil,nil,{    {3,229028},{9,229039},{8,295463},{8,229029},{17,229025},{4,229035},{12,229031},{6,229034},{1,229023},{11,229026},{13,229042},{13,229027},{5,229033},{5,229024},{15,229038},{10,295462},{10,229030},{14,229040},},1},

{11087,"TWW_AstralWarmonger","TWW_Karesh",nil,110199,nil,nil,{{13,229085},{8,229089},{5,229099},{17,229083},{7,229082},{1,229079},{12,229092},{8,229096},--[[{14,},]]{10,229084},{16,229095},{11,229093},{15,229087},}},
{11086,"TWW_KareshShadowguard","TWW_Karesh",nil,110199,nil,nil,{     {13,291771},{8,291772},{5,291816},{17,291931},{7,291922},{1,291767},{12,291769},--[[{8,},]]{14,291920},{10,291773},{16,292840},{11,291768},{15,291770},}},
{11085,"TWW_AstralAspirant","TWW_Karesh",nil,110199,nil,nil,{ {13,228027},{8,228031},{5,228024},{17,228030},{7,228033},{1,228023},{12,228032},{8,228025},--[[{14,},]]{10,228029},{16,228038},{11,228026},{15,228028},}},
{11084,"TWW_KareshEntropicShadow","TWW_Karesh",nil,110199,nil,nil,{ {13,287338},{8,287422},{5,287337},{17,287356},{7,287343},{1,287339},{12,287354},{8,287340},{14,287336},{10,287355},{16,287349},{11,287342},}},
{11106,"TWW_Reshii","TWW_Karesh",nil,110199,nil,nil,{{7,295641},{5,288728},{8,288730},{13,288735},{1,288727},{12,288737},{8,288731},{14,288732},{10,288736},{16,288733},{11,288734},{15,295646},}},

{11083,"TWW_KareshiCivArcanoCharged","TWW_KareshiCiv",nil,110198,nil,nil,{{12,293034},{13,293036},{8,293035},{14,293037},{5,292933},{10,292932},{10,292931},}},

{11081,"TWW_WepSetName53","TWW_WepSetLabel19",nil,110107,nil,nil,{{15,291527},{14,291523},{16,290224},{3,290216},{17,290202},{8,290198},},2},
{11080,"TWW_WepSetName52","TWW_WepSetLabel19",nil,110107,nil,nil,{{15,291528},{14,291524},{16,290225},{3,290217},{17,290203},{8,290199},},2},
{11079,"TWW_WepSetName51","TWW_WepSetLabel19",nil,110107,nil,nil,{{15,291529},{14,291525},{16,290226},{3,290218},{17,290204},{8,290200},},2},
{11078,"TWW_WepSetName50","TWW_WepSetLabel19",nil,110107,nil,nil,{{15,291530},{14,291526},{16,290227},{3,290219},{17,290205},{8,290201},},2},

{11077,"TWW_WepSetName49","TWW_WepSetLabel18",nil,110107,nil,nil,{{9,290284},{1,290277},{12,290212},{13,290206},},2},
{11076,"TWW_WepSetDesc11","TWW_WepSetLabel18",nil,110107,nil,nil,{{9,290285},{1,290278},{12,290213},{13,290207},},2},
{11075,"TWW_WepSetName48","TWW_WepSetLabel18",nil,110107,nil,nil,{{9,290286},{1,290279},{12,290214},{13,290208},},2},
{11074,"TWW_WepSetName47","TWW_WepSetLabel18",nil,110107,nil,nil,{{9,290287},{1,290280},{12,290215},{13,290209},},2},

{11082,"TWW_WepSetName54","TWW_WepSetLabel20",nil,110105,nil,nil,{{17,108344},{12,108332},{10,108338},{15,108329},{13,108377},{11,108353},{7,108380},{3,108347},{2,108368},{16,108335},{14,108365},{8,108326},{6,108359},{5,108323},{1,108350},}},

{11073,"TWW_WepSetName46","TWW_WepSetLabel17",nil,110105,"TWW_WepSetNote7",nil,{{14,219537,"SL_WepSetNote8"},{5,289431},{11,289428},{8,289423},{10,266805,"SirenIsle"},{8,231272,"SirenIsle"},{5,231285,"SirenIsle"},{10,231284,"SirenIsle"},{10,231277,"SirenIsle"},}},

{11072,"TWW_WepSetName45","TWW_WepSetName45",nil,110105,nil,nil,{{17,287060},{16,287061},{15,287049},{13,287054},{11,287047},{8,287051},{8,287050},{7,287057},{5,287052},{1,287046},{10,287056},{12,287048}}},
{11071,"TWW_WepSetName44","TWW_WepSetName45",nil,110105,nil,nil,{{1,287030},{17,287044},{8,287034},{10,287040},{13,287038},{5,287036},{16,287045},{7,287041},{8,287035},{11,287031},{15,287033},{12,287032}}},

{11070,"TWW_WepSetName43","TWW_WepSetLabel16",nil,110105,nil,nil,{{1,287440},{5,287835},{7,287854},},2},
{11069,"TWW_WepSetName42","TWW_WepSetLabel16",nil,110105,nil,nil,{{1,287441},{5,287836},{7,287855},},2},
{11068,"TWW_WepSetName41","TWW_WepSetLabel16",nil,110105,nil,nil,{{1,287442},{5,287837},{7,287856},},2},
{11067,"TWW_WepSetName40","TWW_WepSetLabel16",nil,110105,nil,nil,{{1,287443},{5,287838},{7,287857},},2},

{11066,"TWW_WepSetName39","TWW_WepSetLabel15","Alliance",110105,"TWW_WepSetNote4","i:242260:2:"..app.GetLocalizedString("Arsenal")..app.GetLocalizedString("TWW_WepSetNote4"),{{10,289544},{14,289545},{5,289546},{12,290172},}},
{11065,"TWW_WepSetName39","TWW_WepSetLabel15","Horde",110105,"TWW_WepSetNote4","i:242265:2:"..app.GetLocalizedString("Arsenal")..app.GetLocalizedString("TWW_WepSetNote5"),{{1,290174},{10,290173},{5,290175},{12,290176},}},

{11064,"TWW_WepSetLabel14","TWW_WepSetName38",nil,110100,nil,nil,{{5,285223},{8,285224},{14,285225},{10,287409},{15,287420},},2},

--[[green]]{11063,"TWW_WepSetName37","TWW_WepSetLabel13",nil,110100,nil,nil,{{15,287859},{10,285119},{6,285115},{14,284789},{13,284785},},2},
--[[purple]]{11062,"TWW_WepSetName36","TWW_WepSetLabel13",nil,110100,nil,nil,{{15,287860},{10,285120},{6,285116},{14,284790},{13,284786},},2},
--[[red]]{11061,"TWW_WepSetName35","TWW_WepSetLabel13",nil,110100,nil,nil,{{15,287861},{10,285121},{6,285117},{14,284791},{13,284787},},2},
--[[blue]]{11060,"TWW_WepSetName34","TWW_WepSetLabel13",nil,110100,nil,nil,{{15,287858},{10,285118},{6,285114},{14,284788},{13,284784},},2},

--Liberation of Undermine (s2 raid)
{11059,"TWW_WepSetName33","TWW_WepSetLabel12","LFR",110100,nil,nil,{{13,230493},{9,230339},{2,230496},{11,230487},{13,230517},{8,230472},{14,230502},{6,230514},{17,230523},{5,230505},{5,230490},{8,230478},{7,230475},{3,230511},{9,230297},{6,230429},{12,230466},{10,230484},{10,230508},{9,230430}},3},
{11058,"TWW_WepSetName33","TWW_WepSetLabel12","Normal",110100,nil,nil,{{12,224975},{10,224992},{10,224976},{13,224984},{9,224977},{2,224989},{11,224991},{13,224978},{8,224985},{14,224981},{6,224990},{17,224980},{5,224983},{5,224982},{8,224988},{7,224979},{3,224986},{9,230297},{6,230429},{9,230430}},3},
{11057,"TWW_WepSetName33","TWW_WepSetLabel12","Heroic",110100,nil,nil,{{13,230494},{9,230340},{2,230497},{11,230488},{13,230518},{8,230473},{14,230503},{6,230515},{17,230524},{5,230506},{5,230491},{8,230479},{7,230476},{3,230512},{9,230297},{6,230429},{12,230467},{10,230485},{10,230509},{9,230430}},3},
{11056,"TWW_WepSetName33","TWW_WepSetLabel12","Mythic",110100,nil,nil,{{12,230468},{10,230486},{10,230510},{13,230495},{9,230341},{2,230498},{11,230489},{13,230519},{8,230474},{14,230504},{6,230516},{17,230525},{5,230507},{5,230492},{8,230480},{7,230477},{3,230513},{9,230297},{6,230429},{9,230430}},3},

--S2
--[[red   ]]{11055,"TWW_WepSetName32","TWW_WepSetLabel11","Aspirant",110100,nil,nil,{{15,226656},{8,226653},{8,226659},{13,226655},{5,226652},{10,226657},{1,226651},{11,226654},{7,226661},{12,226660},{16,226666},{17,226658},},1,2},
--[[purple]]{11054,"TWW_WepSetName32","TWW_WepSetLabel11","Gladiator",110100,nil,nil,{{10,229141},{11,229134},{5,229131},{8,229139},{7,229132},{6,229143},{17,229133},{13,229137},{9,229146},{10,229140},{2,229145},{13,229135},{14,227671},{5,229138},{8,227660},{12,229142},{3,229144},},1,2},
--[[green  ]]{11053,"TWW_WepSetName32","TWW_WepSetLabel11","Elite",110100,nil,nil,{{10,230346},{11,227657},{5,227664},{8,227663},{7,227666},{6,227654},{17,227656},{13,227673},{9,227670},{10,227661},{2,227669},{13,227658},{14,229136},{5,227655},{8,229130},{12,227662},{3,227659},},1,2},

--11.1 Dungeon
{11052,"TWW_WepSetName31","LabelUndermineGear","TWW_WepSetDesc22",110100,"TWW_WepSetNote3",nil,{{15,248932},{11,248936},{5,248935},{17,248933},{7,248934},}},
{11051,"TWW_WepSetName31","LabelUndermineGear","TWW_WepSetDesc21",110100,nil,nil,{{15,227917},{8,227920},{8,227919},{13,227915},{5,227929},{10,227914},{1,227909},{11,227923},{7,227912},{12,227922},{16,227925},{17,227913},}},
{11050,"TWW_WepSetName31","LabelUndermineGear","TWW_WepSetDesc20",110100,nil,nil,{{15,231017},{8,231022},{8,231023},{13,231013},{14,231020},{5,231024},{10,231012},{1,266791},{11,231015},{7,231019},{12,231011},{16,266790},{17,231010},}},
{11049,"TWW_WepSetName31","LabelUndermineGear","TWW_WepSetDesc19",110100,nil,nil,{{15,230273},{8,230274},{8,230268},{13,230263},{14,230266},{5,230270},{10,267062},{1,230265},{11,230260},{7,230269},{12,230271},{16,230276},{17,267061},}},

--Topsy Turvy tp sets
{11048,"TWW_WepSetName27","TWW_WepSetLabel10",nil,110100,nil,nil,{{5,248999},{1,249121},{10,267048},},2},
{11047,"TWW_WepSetName29","TWW_WepSetLabel10",nil,110100,nil,nil,{{5,248996},{1,249123},{10,267046},},2},
{11046,"TWW_WepSetName28","TWW_WepSetLabel10",nil,110100,nil,nil,{{5,248997},{1,249120},{10,267047},},2},
{11045,"TWW_WepSetName26","TWW_WepSetLabel10",nil,110100,nil,nil,{{5,249001},{1,249122},{10,267049},},2},

--Monarch tp sets
{11044,"TWW_WepSetName25","TWW_WepSetLabel9","TWW_WepSetDesc18",110100,nil,nil,{{3,267053},{11,266802},{16,266771},{14,266767},{8,266760},},2},
{11043,"TWW_WepSetName25","TWW_WepSetLabel9","TWW_WepSetDesc17",110100,app.GetTradingPostReleaseString("Mar",2025),nil,{{3,267056},{11,266801},{16,266772},{14,266768},{8,266762},},2},
{11042,"TWW_WepSetName25","TWW_WepSetLabel9","TWW_WepSetDesc16",110100,app.GetLocalizedString("LoveIsInTheAir").." 2026",nil,{{3,267054},{11,266799},{16,266770},{14,266766},{8,266759},},},
--{11041,"TWW_WepSetName25","TWW_WepSetLabel9","TWW_WepSetDesc15",110100,nil,nil,{{3,267055},{11,266800},{16,266773},{14,266769},{8,266761},},2},--Removed Midnight??

{11040,"TWW_WepSetName24","Plunderstorm","TWW_WepSetDesc14",110007.3,nil,nil,{{1,230320},{13,230323},{14,230321},{15,230322},{7,230324},},nil,2},

--clockwork
{11039,"TWW_WepSetName23","TWW_WepSetName23","TWW_WepSetDesc13",110007.2,nil,nil,{{9,230844},{6,230849},{7,230862},{12,230868},},2},
{11038,"TWW_WepSetName23","TWW_WepSetName23","TWW_WepSetDesc12",110007.2,nil,nil,{{9,230845},{6,230851},{7,230860},{12,230871},},2},
{11037,"TWW_WepSetName23","TWW_WepSetName23","TWW_WepSetDesc11",110007.2,nil,nil,{{9,230846},{6,230848},{7,230861},{12,230869},},2},
{11036,"TWW_WepSetName23","TWW_WepSetName23","TWW_WepSetDesc10",110007.2,nil,nil,{{9,230847},{6,230850},{7,230863},{12,230870},},2},

--lunar weapons starting at 98809
{11035,"TWW_WepSetName22","TWW_WepSetLabel8","TWW_WepSetDesc9",110007.1,nil,nil,{{10,230823},{5,230827},{11,230831},{8,230835},},2},
{11034,"TWW_WepSetName22","TWW_WepSetLabel8","TWW_WepSetDesc8",110007.1,nil,nil,{{10,230824},{5,230829},{11,230832},{8,230836},},2},
{11033,"TWW_WepSetName22","TWW_WepSetLabel8","TWW_WepSetDesc7",110007.1,nil,nil,{{10,230825},{5,230830},{11,230833},{8,230837},},2},
{11032,"TWW_WepSetName22","TWW_WepSetLabel8","TWW_WepSetDesc12",110007.1,app.GetLocalizedString("TWW_WepSetLabel8").." 2026",nil,{{10,230826},{5,230828},{11,230834},{8,230838},},},

--Siren isle
{11031,"TWW_WepSetName21","SirenIsle","TWW_WepSetDesc6",110007,nil,"TWW_WepSetNote2",{{13,231266},{13,231265},{12,231411},{11,231423},{14,231259},{5,231281},{6,231279},{14,231258},}},
{11030,"TWW_WepSetName20","SirenIsle","TWW_WepSetDesc5",110007,nil,"TWW_WepSetNote2",{{12,231410},{3,231306},{3,231305},{15,231255},{15,231256},{8,231268},{8,231267},{16,231254},}},

--Neruba-ar Palace (S1 raid)
{11029,"TWW_WepSetName19","TWW_WepSetLabel7","LFR",110000,nil,nil,{{2,221210},{11,200655},{13,221204},{13,221213},{9,221174},{1,221216},{5,221180},{8,218463},{14,220599},{17,221195},{5,218314},{8,221183},{6,221186},{4,221201},{3,220605},{6,218454},{12,221222},{12,200654},{10,218312},},3},
{11028,"TWW_WepSetName19","TWW_WepSetLabel7","Normal",110000,nil,nil,{{2,194752},{11,194758},{13,194734},{13,194742},{9,194733},{1,194746},{5,194739},{8,194743},{14,194737},{17,194736},{5,221160},{8,194749},{6,194754},{4,194745},{3,194744},{6,218454},{12,221111},{12,194731},{10,194732},},3},
{11027,"TWW_WepSetName19","TWW_WepSetLabel7","Heroic",110000,nil,nil,{{2,221211},{11,220603},{13,221205},{13,221214},{9,221175},{1,221217},{5,221181},{8,221193},{14,220600},{17,221196},{5,221199},{8,221184},{6,221187},{4,221202},{3,220606},{6,218454},{12,221223},{12,221178},{10,221208},},3},
{11026,"TWW_WepSetName19","TWW_WepSetLabel7","Mythic",110000,nil,nil,{{2,221212},{11,220604},{13,221206},{13,221215},{9,221176},{1,221218},{5,221182},{8,221194},{14,220601},{17,221197},{5,221200},{8,221185},{6,221188},{4,221203},{3,220607},{6,218454},{12,221224},{12,221179},{10,221209},},3},

--S1 pvp --1h mace missing for glad and elite (should be at 84702 and 84703)
{11025,"TWW_WepSetName18","TWW_WepSetLabel6","Aspirant",110000,nil,nil,{{15,216902},{1,216897},{17,216904},{8,216905},{10,216903},{13,216901},{5,216898},{16,216913},{7,216907},{8,216899},{11,216900},{12,216906},},1,1},
{11024,"TWW_WepSetName18","TWW_WepSetLabel6","Gladiator",110000,nil,nil,{{1,217902},{13,217921},{8,217908},{5,217912},{2,217917},{12,217916},{6,217913},{12,217910},{10,217909},{11,217905},{3,217907},{4,217914},{13,217906},{17,217904},{5,217903},{14,217919},{9,217918},},1,1},
{11023,"TWW_WepSetName18","TWW_WepSetLabel6","Elite",110000,nil,nil,{{1,222810},{13,222817},{8,222819},{5,222812},{2,222825},{12,222822},{6,222823},{12,222821},{10,222820},{11,222814},{3,222824},{4,222818},{13,222815},{17,222813},{5,222811},{14,222828},{9,222826},},1,1},

--arathi --orange is Season 1 Aspirant's
{11022,"TWW_WepSetName17","TWW_WepSetName45",nil,110000,nil,nil,{{1,218239},{17,218228},{8,218236},{10,218230},{5,218238},{16,218235},{7,218234},{8,218237},{11,218233},{12,218229},{13,218232},{15,218231},}},--blue
{11021,"TWW_WepSetName16","TWW_WepSetName45",nil,110000,nil,nil,{{8,289440},{15,219970},{1,219985},{17,220199},{10,220198},{5,220101},{7,219969},{8,220099},{11,219967},{12,220196},{13,219968},{16,289441}}},
{11020,"TWW_WepSetName15","TWW_WepSetName45",nil,110000,nil,nil,{{1,219544},{17,219534},{10,219583},{13,219584},{5,219531},{16,220368},{7,219452},{8,219535},{11,219541},{12,219525},{15,289439}}},--black--appID:84670 should be missing 2hSword

--dungeon (all 3 difficulties use Somber Fate(red) appearances)
{11019,"TWW_WepSetName14","TWW_WepSetLabel5","TWW_WepSetDesc4",110007,nil,nil,{{13,219031},{14,219101},{5,219061},{17,219028},{13,218970},{8,218986},{1,218971},{5,218984},{10,218997},{12,219016},{11,219093},{11,219062},{11,219021},{12,218985},{15,219081},{8,219075},{4,219036},{9,218433},{9,218425},{3,218978},{14,219038},{6,219037},{7,219017},}},
{11018,"TWW_WepSetName13","TWW_WepSetLabel5","TWW_WepSetDesc3",110007,nil,nil,{{8,220545},{15,219540},{9,220549},{11,220552},{11,220551},{2,219536},{14,220547},{17,220557},{10,220555},{9,219542},{7,220548},{14,220546},{12,220556},{5,220542},{13,220554},{13,220553},{8,220544},{5,220543},}},--{4,223029}, invisible crossbow
{11017,"TWW_AscensionArrestor","TWW_WepSetLabel5","TWW_Copper",119999,"Midnight_Prepatch",nil,{{9,219559,""},{14,219557,""},{1,293111},{8,293112},{8,293113},{11,293114},{13,293115},{15,293116},{10,293117},{12,293118},{17,293119},{5,293248},{4,304839}}},
{11016,"TWW_WepSetName11","TWW_WepSetLabel5","TWW_WepSetDesc1",110007,nil,nil,{{8,225136},{5,225114},{13,225125},{15,225133},{9,225121},{11,225124},{2,225138},{1,220343},{14,225119},{17,225129},{10,225127},{11,225123},{9,225122},{7,225120},{14,225118},{12,225128},{5,225137},{13,225126},{8,225116},}},
{11015,"TWW_SetName16","TWW_WepSetLabel5","TWW_WepSetDesc0",110007,"SirenIsle",nil,{{7,225170},{4,225171},{3,225169},{15,225156},{11,225151},{2,225157},{9,225160},{11,225153},{11,225152},{13,225166},{13,225167},{17,225165},{14,225149},{14,225150},{8,225158},{8,225159},{6,225164},{5,225163},{5,225162},{1,225147},{12,225154},{12,225155},{10,225168},{9,225161},}},

--nerubian
{11014,"TWW_SetName10","TWW_WepSetLabel4",nil,110005,"TWW_WepSetNote1","TWW_WepSetNote0",{{13,222891},{10,222892},{5,222880},{8,222886},{1,222949},{14,219552},{11,222888},{14,222883},{13,222890},{11,222889},{1,222950},{8,222881},{2,222887},{12,222893},{7,222885},{4,222946},{5,222948},{5,222879},},nil,2},
{11013,"TWW_WepSetName10","TWW_WepSetLabel4",nil,110000,nil,nil,{{1,218360},{4,218287},{5,193926},{6,218289},{10,193921},{8,218361},{11,218363},{13,218286},{14,193928},{15,218285},{12,193920},{2,218288},{7,218364},{5,193927},{8,224558},{1,218290},}},
{11012,"TWW_WepSetName45","TWW_WepSetLabel4",nil,110000,nil,nil,{{15,220495},{14,223927},{13,220493},{11,220492},{8,220498},{10,220504},{5,220499},{1,220496},{12,220502},{2,220500},{7,220494},{5,224048},{11,224047},{13,193937},{14,224041},}},
{11011,"TWW_WepSetName9","TWW_WepSetLabel4",nil,110000,nil,nil,{{15,219204},{14,219192},{13,219190},{11,219206},{8,219201},{10,219189},{6,219205},{5,219193},{4,219199},{1,219200},{12,219188},{2,219203},{7,219191},{5,219554},}},
{11010,"TWW_WepSetName8","TWW_WepSetLabel4",nil,110000,nil,nil,{{13,219585},{7,221013},{11,222951},{6,219539},{1,219560},{2,219561},{10,219582},{12,219565},{13,219586},{1,221009},{5,221018},{11,221011},{8,221014},{10,221015},{15,221019},{14,221020},{1,221017},{5,221010},{8,218583},{8,218584},{12,221016}}},

--{8,218584},{8,218583}, torch unlit and lit, doesn't really match anything else

--earthen
{11009,"TWW_SetName0","TWW_SetName0",nil,110000,nil,nil,{{1,220327},{5,220328},{13,220329},{2,220332},{14,220331},{12,220330},{8,220334},{7,65599},{13,220326},}},

--farm
{11008,"TWW_WepSetName7","TWW_WepSetLabel3",nil,110000,nil,nil,{{8,222830},{10,222831},{9,222944},{9,222845},{8,222945},}},

--{"G1","misc 2",nil,110000,nil,nil,{{1,219055},{9,219005},{2,219930},{14,219533},}},

--plunderlord's recolor (trading post)
{11007,"TWW_WepSetName6","Plunderstorm",nil,110000,nil,nil,{{1,222859},{13,222855},{14,222858},{15,222857},{7,222856},},2},
--Coreway trading post
{11006,"TWW_WepSetName5","TWW_WepSetName5",nil,110000,nil,nil,{{1,224046},{8,222807},{8,222808},{1,222803},{9,222802},{13,222804},{10,222805},{9,222801},},2},
--dornogal trading post
{11005,"TWW_WepSetName4","TWW_WepSetLabel2",nil,110000,nil,nil,{{12,222798},{8,222800},{1,222799},{11,222806},},2},
--riptide trading post
{11004,"TWW_WepSetName3","TWW_WepSetName3",nil,110000,nil,nil,{{14,219712},{5,219706},{6,219703},{16,219716},{2,219715},},2},

--pre-patch event
{11003,"TWW_WepSetName2","TWW_WepSetLabel1",nil,110000,nil,nil,{{5,218264},{14,218246},{8,218260},{16,218259},{11,218257},{12,218256},{9,218253},{15,218251},{13,218249},{10,218248},{4,218244},{1,218241},}},
{11002,"TWW_WepSetName1","TWW_WepSetLabel1",nil,110000,nil,nil,{{10,222935},{4,222937},{6,222936},{12,222809},},nil,2},--this was rares on isle of dorn except shield which was fished

--winter veil
{11001,"TWW_WepSetName0","TWW_WepSetLabel0",nil,110007,nil,nil,{{15,227766},{13,227765},{5,227764},{9,227763},{14,193800},{12,229194},},2},
};

local function comp(a,b)
  if a[1] < b[1] then return true; else return false end
end
table.sort(db,comp);

local function AddToCollection()
  --local names = "";
  --local labels = "";
  --local descs = "";
  --local notes = "";
  --local nameArray = {};
  --local labelsArray = {};
  --local descArray = {};
  --local notesArray = {};
  
  local patch = select(4,GetBuildInfo()) + 1;
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
    --  local insertLabel = true;
    --  for a = 1, #labelsArray do
    --    if labelsArray[a] == db[i][3] then
    --      insertLabel = false;
    --      break;
    --    end
    --  end
    --  if insertLabel then
    --    tinsert(labelsArray, db[i][3])
    --  end
    --end
    --if db[i][4] then
    --  local insertDesc = true;
    --  for a = 1, #descArray do
    --    if descArray[a] == db[i][4] then
    --      insertDesc = false;
    --      break;
    --    end
    --  end
    --  if insertDesc then
    --    tinsert(descArray, db[i][4])
    --  end
    --end
    --if db[i][6] then
    --  local insertNote = true;
    --  for a = 1, #notesArray do
    --    if notesArray[a] == db[i][6] then
    --      insertNote = false;
    --      break;
    --    end
    --  end
    --  if insertNote then
    --    tinsert(notesArray, db[i][6])
    --  end
    --end
    --if db[i][7] then
    --  local insertNote = true;
    --  for a = 1, #notesArray do
    --    if notesArray[a] == db[i][7] then
    --      insertNote = false;
    --      break;
    --    end
    --  end
    --  if insertNote then
    --    tinsert(notesArray, db[i][7])
    --  end
    --end
    
    if (db[i][5] <= patch) then
      app.AddWepDBLineToTables(db[i], expansionID);
    end
  end
  
  --local text = ExS_Localizing_Printer:GetText();
  --
  --for a = 1, #nameArray do
  --  names = names.."[\"TWW_WepSetName"..#nameArray-a.."\"] = \""..nameArray[a].."\",--"..nameArray[a].."\n"
  --end
  --for a = 1, #labelsArray do
  --  labels = labels.."[\"TWW_WepSetLabel"..#labelsArray-a.."\"] = \""..labelsArray[a].."\",--"..labelsArray[a].."\n"
  --end
  --for a = 1, #descArray do
  --  descs = descs.."[\"TWW_WepSetDesc"..#descArray-a.."\"] = \""..descArray[a].."\",--"..descArray[a].."\n"
  --end
  --for a = 1, #notesArray do
  --  notes = notes.."[\"TWW_WepSetNote"..#notesArray-a.."\"] = \""..notesArray[a].."\",--"..notesArray[a].."\n"
  --end
  --text = text..names..descs..labels..notes;
  --ExS_Localizing_Printer:SetText(text);
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