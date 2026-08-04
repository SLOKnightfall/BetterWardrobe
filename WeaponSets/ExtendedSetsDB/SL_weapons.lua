local app = select(2,...);

local expansionID = 9;

--Name, Label, Difficulty, patchID, sources, requiredFact, isPvP, noLongerObtainable
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

local covColors = {
  ["Kyrian"] = "|cff5BAFD9",
  ["NightFae"] = "|cff4650DD",
  ["Venthyr"] = "|cffB12B2D",
  ["Necro"] = "|cff417547"
}

--Start of SL: 41233
local db = {
--TW
{9080,"SL_TimewalkingName","SL_Timewalking",nil,90900,nil,nil,{{13,299374},{12,299370},{14,299365},{4,299364},{10,301577},{11,299362},{2,299363},{9,299371},{14,300794},{11,300791},{17,300803},{11,299359},{8,299356},{8,299355},{9,301473},{9,301474},{14,299367},{10,299373},}},

--Zerith Mortis
{9079,"SL_EnlightenedJourney","SL_SetLabel5","TWW_WepSetDesc7"  ,90200,nil,nil,{{8,168153},{13,168203},{9,168152},{9,169551},{13,169136},{13,168204},}},
{9078,"SL_EnlightenedJourney","SL_SetLabel5","SL_Silver",90200,nil,nil,{{8,169556},{13,169554},{9,168151},{9,169552},{13,165443},{13,165441},}},
{9077,"SL_EnlightenedJourney","SL_SetLabel5","SL_Bronze",90200,nil,nil,{{8,169549},{13,169553},{9,165446},{13,168205},}},
{9076,"SL_EnlightenedJourney","SL_SetLabel5","TWW_Copper",90200,nil,nil,{{8,169550},{13,169555},}},

--Dark Iron Dwarf and Blood Elf Heritage Quest Weapons
{9075,"SL_WepSetName57","HeritageSet","SL_WepSetDesc10",90205,"q:63502",nil,{{13,169686},{1,169687},{12,169690},{9,169686},}},
{9074,"SL_WepSetName56","HeritageSet","SL_WepSetDesc9",90205,nil,nil,{{11,169677,"q:63489"},{11,10405,app.GetColoredClassNameString("Paladin")..app.GetLocalizedString("SL_WepSetNote147"),"q:63490"},}},

--9.2 Mawsworn
{9073,"SL_WepSetName55","SL_WepSetLabel17",nil,90200,"a:15392",nil,{{8,168257},{12,168258},{15,166005,"SL_WepSetNote146"},{11,168600},{9,168259},}},
{9072,"SL_WepSetName54","SL_WepSetLabel17",nil,90200,"SL_WepSetNote21",nil,{{8,168256},{12,168255},{15,166003,"SL_WepSetNote18"},{9,168599},{11,249292,app.GetLocalizedString("Vendor")..app.GetLocalizedString("LabelTWLegion")}}},
{9071,"SL_WepSetName53","SL_WepSetLabel17",nil,90200,"SL_WepSetNote20",nil,{{8,168249},{12,168596},{15,168918,app.GetLocalizedString("SL_WepSetNote49")..app.GetLocalizedString("SL_WepSetNote144")..app.GetLocalizedString("SL_WepSetNote38")},{4,168251},{9,168250},{9,165998,"SL_WepSetNote18"},
                          {13,168254,"SL_WepSetNote145","a:15392"},{11,168273},{11,166000,"SL_WepSetNote18"},}},
{9070,"SL_WepSetName52","SL_WepSetLabel17",nil,90200,"SL_WepSetNote19",nil,{{8,168252},{12,168597},{15,166004,"SL_WepSetNote18"},{4,165996,"SL_WepSetNote18"},{9,168253},
                          {13,166002,"SL_WepSetNote18"},{11,168598},{9,168167,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote143")..app.GetLocalizedString("SL_WepSetNote38")},}},
{9069,"SL_WepSetName51","SL_WepSetLabel17",nil,90200,"SL_WepSetNote18",nil,{{15,168977,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote142")..app.GetLocalizedString("SL_WepSetNote38")},{4,165994},{9,165997},{13,166001},{11,165999},
                          {11,168274,"SL_WepSetNote21"},}},

--Broker 44454
{9068,"SL_WepSetName50","SL_WepSetLabel16",nil,90200,"r:5:2478","SL_WepSetNote17",{{6,168207,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote140")..app.GetLocalizedString("SL_WepSetNote38"),""},{17,165444},{10,165434},{4,165435},{5,165436},{12,165433},{13,169133},{8,165442},
                          {14,169134,"r:5:2478"},{2,165438},{14,168165,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote141")..app.GetLocalizedString("SL_WepSetNote38"),""},}},
{9067,"SL_WepSetName49","SL_WepSetLabel16",nil,90200,nil,nil,{{2,300792},{14,168155,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote132")..app.GetLocalizedString("SL_WepSetNote38"),"SL_WepSetNote17"},{8,168156,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote133")..app.GetLocalizedString("SL_WepSetNote38")},
                          {13,168209,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote134")..app.GetLocalizedString("SL_WepSetNote38")},{12,168160,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote135")..app.GetLocalizedString("SL_WepSetNote38")},{5,168161,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote141")..app.GetLocalizedString("SL_WepSetNote38")},
                          {4,168212,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote136")..app.GetLocalizedString("SL_WepSetNote38")},{10,168214,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote136")..app.GetLocalizedString("SL_WepSetNote38")},{17,168215,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote137")..app.GetLocalizedString("SL_WepSetNote38")},{14,168164,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote138")..app.GetLocalizedString("SL_WepSetNote38")},
                          {6,116658,app.GetLocalizedString("SL_WepSetNote139")..app.GetLocalizedString("SL_WepSetNote39")},}},
{9066,"SL_WepSetName48","SL_WepSetLabel16",nil,90200,nil,nil,{{2,116690,app.GetLocalizedString("SL_WepSetNote125")..app.GetLocalizedString("SL_WepSetNote39")},{14,116705,app.GetLocalizedString("SL_WepSetNote126")..app.GetLocalizedString("SL_WepSetNote39")},
                          {8,116700,app.GetLocalizedString("SL_WepSetNote126")..app.GetLocalizedString("SL_WepSetNote39"),"SL_WepSetNote32"},{13,116699,app.GetLocalizedString("SL_WepSetNote131")..app.GetLocalizedString("SL_WepSetNote39")},{12,116691,app.GetLocalizedString("SL_WepSetNote127")..app.GetLocalizedString("SL_WepSetNote39")},
                          {5,116698,app.GetLocalizedString("SL_WepSetNote128")..app.GetLocalizedString("SL_WepSetNote39")},{4,168211,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote129")..app.GetLocalizedString("SL_WepSetNote38")},{10,168213,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote130")..app.GetLocalizedString("SL_WepSetNote38")},{17,116697,app.GetLocalizedString("SL_WepSetNote131")..app.GetLocalizedString("SL_WepSetNote39")},
                          {14,168166,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote140")..app.GetLocalizedString("SL_WepSetNote38")},{6,168208,"SL_WepSetNote145","a:15392"},}},
{9065,"SL_WepSetName47","SL_WepSetLabel16",nil,90200,nil,nil,{{17,168601,"SL_WepSetNote145","a:15392"},{10,116692,app.GetLocalizedString("SL_WepSetNote120")..app.GetLocalizedString("SL_WepSetNote39")},{4,116663,app.GetLocalizedString("SL_WepSetNote120")..app.GetLocalizedString("SL_WepSetNote39")},
                          {5,116657,app.GetLocalizedString("SL_WepSetNote128")..app.GetLocalizedString("SL_WepSetNote39")},{12,168159,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote121")..app.GetLocalizedString("SL_WepSetNote38")},{13,116659,app.GetLocalizedString("SL_WepSetNote125")..app.GetLocalizedString("SL_WepSetNote39")},
                          {8,168157,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote122")..app.GetLocalizedString("SL_WepSetNote38")},{14,169557,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote123")..app.GetLocalizedString("SL_WepSetNote38")},{2,169135,"r:5:2478"},{6,168206,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote132")..app.GetLocalizedString("SL_WepSetNote38")},
                          {14,168163,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote124")..app.GetLocalizedString("SL_WepSetNote38")},}},

--Sepulcher of the First Ones (9.2 Raid)
{9064,"SL_WepSetName46","SL_WepSetLabel15","LFR",90200,nil,nil,{{12,168848},{12,167513},{10,168041},{13,167829},{13,167950},{15,167833},{13,167796},{14,168009},
                          {9,167897},{11,168045},{5,167893},{5,168013},{8,167719},{6,168852},{1,167857},{7,168017},{9,168840},{4,167926},{14,167930},{17,167993}},3},--,{14,168009}
{9063,"SL_WepSetName46","SL_WepSetLabel15","Normal",90200,nil,nil,{{12,168845},{12,167510},{10,168040},{13,167827},{13,167948},{15,167831},{13,167794},
                          {9,167895},{11,168044},{5,167891},{5,168012},{14,168008},{8,167717},{6,168849},{1,167855},{7,168016},{9,168840},{4,146369},{14,146361},{17,167992}},3},--crossbow/sword might not be right? show 2 diff pvp ones
{9062,"SL_WepSetName46","SL_WepSetLabel15","Heroic",90200,nil,nil,{{12,168846},{12,167511},{10,168042},{13,167830},{13,167951},{15,167834},{13,167797},{8,167761},
                          {9,167898},{11,168046},{5,167894},{5,168014},{14,168010},{6,168850},{1,167858},{7,168018},{9,168840},{4,167927},{14,167931},{17,167994}},3},
{9061,"SL_WepSetName46","SL_WepSetLabel15","Mythic",90200,nil,nil,{{12,168847},{12,167512},{10,168043},{13,167828},{13,167949},{15,167832},{13,167795},
                          {9,167896},{11,168047},{5,167892},{5,168015},{14,168011},{8,167718},{6,168851},{1,167856},{7,168019},{9,168840},{4,167925},{14,167929},{17,167995}},3},
                          
--Season 3
{9060,"SL_WepSetName45","SL_WepSetLabel14","Gladiator",90200,nil,nil,{{1,146351},{14,146361},{15,167498},{8,167504},{9,146367},{12,146213},{12,167495},{5,146355},{5,146357},{14,146359},
                          {17,146365},{6,116568},{4,146369},{7,167496},{11,146371},{13,146373},{13,167502},{13,167500},{10,146211},},1},
{9059,"SL_WepSetName45","SL_WepSetLabel14","Elite",90200,nil,nil,{{1,146352},{14,146362},{15,167499},{8,167505},{9,146368},{12,146214},{12,167494},{5,146356},{5,146358},{14,146360},
                          {17,146366},{6,116567},{4,146370},{7,167497},{11,146372},{13,146374},{13,167503},{13,167501},{10,146212},},1,1},

--Sanctum of Domination (9.1 Raid)
{9058,"SL_WepSetName44","SL_WepSetLabel13","LFR",90100,nil,nil,{{13,146679},{13,146681},{5,146645},{10,146663},{2,146675},{15,146669},{11,146685},{13,146683},
                          {5,146647},{6,146667},{8,146657},{17,146655},{14,146689},{1,146673},{14,146583},{7,146671},{3,146677},{12,146651},{12,146649}},3},
{9057,"SL_WepSetName44","SL_WepSetLabel13","Normal",90100,nil,nil,{{13,145971},{2,145975},{15,145979},{11,145967},{13,145973},{13,145977},{5,145953},{6,145957},{8,145955},
                          {17,145945},{14,145947},{5,145951},{1,145949},{14,146519},{7,145983},{3,145981},{12,145989},{12,145987},{10,145993},{5,145965},{3,145985},},3},
{9056,"SL_WepSetName44","SL_WepSetLabel13","Heroic",90100,nil,nil,{{13,146680},{2,146676},{15,146670},{11,146686},{13,146682},{13,146684},{5,146648},{6,146668},
                          {17,146656},{14,146690},{8,146658},{5,146646},{1,146674},{14,146584},{7,146672},{3,146678},{12,146652},{12,146650},{10,146664},{3,145985},{5,145965},},3},
{9055,"SL_WepSetName44","SL_WepSetLabel13","Mythic",90100,nil,nil,{{13,145972},{2,145976},{15,145980},{11,145968},{13,145974},{13,145978},{5,145954},{6,145958},
                          {8,145956},{17,145946},{14,145948},{5,145952},{1,145950},{14,146585},{7,145984},{3,145982},{12,145990},{12,145988},{10,145994},{5,145965},{3,145985}},3},
                          
--Season 2
{9054,"SL_WepSetName43","SL_WepSetLabel12","Gladiator",90100,nil,nil,{{1,116107},{5,116215},{5,116352},{14,116209},{14,165933},{17,116344},{6,165939},{8,165927},{2,116338},
                          {15,165941},{3,116213},{7,165937},{11,116354},{13,165929},{13,116336},{13,165931},{10,116217},{12,116109},{12,165925}},1},
{9053,"SL_WepSetName43","SL_WepSetLabel12","Elite",90100,nil,nil,{{1,116108},{5,116216},{5,116353},{14,116210},{14,165934},{17,116345},{6,165940},{8,165928},{2,116339},
                          {15,165942},{3,116214},{7,165938},{11,116355},{13,165930},{13,116337},{13,165932},{10,146059},{12,146060},{12,165926}},1,1},
                 
--Castle Nathria (9.0 Raid)    ,"i:183889:4:Thaumaturgic Anima Bead"          
{9052,"SL_WepSetName42","SL_WepSetLabel11",covColors["Kyrian"]..app.GetLocalizedString("SL_WepSetLabel9").."("..app.GetLocalizedString("Normal")..")|r",90002,"i:183891:4:"..app.GetLocalizedString("SL_WepSetNote15")..":3","SL_WepSetNote16",{{1,108552},{5,108908},{14,110998},{14,108930},{3,109545},{9,112964},
                          {11,115499},{13,111619},{17,115526},{10,108910,"i:183889:4:"..app.GetLocalizedString("SL_WepSetNote22")..":3"},{12,108564,"i:183889:4:"..app.GetLocalizedString("SL_WepSetNote22")..":3"}},3},
{9051,"SL_WepSetName41","SL_WepSetLabel11",covColors["Kyrian"]..app.GetLocalizedString("SL_WepSetLabel9").."("..app.GetLocalizedString("Mythic")..")|r",90002,"i:183891:4:"..app.GetLocalizedString("SL_WepSetNote15")..":6","SL_WepSetNote14",{{1,115498},{5,115500},{14,115501},{14,115502},{3,115503},{9,115504},
                          {11,115505},{13,115508},{17,115527},{10,115506,"i:183889:4:"..app.GetLocalizedString("SL_WepSetNote22")..":6"},{12,115507,"i:183889:4:"..app.GetLocalizedString("SL_WepSetNote22")..":6"}},3},
{9050,"SL_WepSetName40","SL_WepSetLabel11",covColors["Necro"]..app.GetLocalizedString("SL_WepSetLabel8").."("..app.GetLocalizedString("Normal")..")|r",90002,"i:183891:4:"..app.GetLocalizedString("SL_WepSetNote15")..":3","SL_WepSetNote16",{{10,115539,"i:183889:4:"..app.GetLocalizedString("SL_WepSetNote22")..":3"},
                          {12,115538,"i:183889:4:"..app.GetLocalizedString("SL_WepSetNote22")..":3"},{2,115544},{1,115546},{5,115537},{5,115547},{7,115543},{8,115540},{11,115545},{13,115542},{17,115541}},3},
{9049,"SL_WepSetName39","SL_WepSetLabel11",covColors["Necro"]..app.GetLocalizedString("SL_WepSetLabel8").."("..app.GetLocalizedString("Mythic")..")|r",90002,"i:183891:4:"..app.GetLocalizedString("SL_WepSetNote15")..":6","SL_WepSetNote14",{{10,115567,"i:183889:4:"..app.GetLocalizedString("SL_WepSetNote22")..":6"},
                          {12,115569,"i:183889:4:"..app.GetLocalizedString("SL_WepSetNote22")..":6"},{2,115561},{1,115562},{5,115563},{5,115564},{7,115565},{8,115566},{11,115568},{13,115570},{17,115572}},3},
{9048,"SL_WepSetName38","SL_WepSetLabel11",covColors["NightFae"]..app.GetLocalizedString("SL_WepSetLabel7").."("..app.GetLocalizedString("Normal")..")|r",90002,"i:183891:4:"..app.GetLocalizedString("SL_WepSetNote15")..":3","SL_WepSetNote16",{{5,112282},{6,112361},{17,112959},{8,112341},{16,112842},
                          {3,112862},{9,112328},{13,112825},{13,112312},{10,112354,"i:183889:4:"..app.GetLocalizedString("SL_WepSetNote22")..":3"},{12,112394,"i:183889:4:"..app.GetLocalizedString("SL_WepSetNote22")..":3"}},3},
{9047,"SL_WepSetName37","SL_WepSetLabel11",covColors["NightFae"]..app.GetLocalizedString("SL_WepSetLabel7").."("..app.GetLocalizedString("Mythic")..")|r",90002,"i:183891:4:"..app.GetLocalizedString("SL_WepSetNote15")..":6","SL_WepSetNote14",{{5,115005},{6,115006},{17,115007},{8,115008},{16,115013},
                          {3,115004},{9,115003},{13,115012},{13,115011},{10,115010,"i:183889:4:"..app.GetLocalizedString("SL_WepSetNote22")..":6"},{12,115002,"i:183889:4:"..app.GetLocalizedString("SL_WepSetNote22")..":6"}},3},
{9046,"SL_WepSetName36","SL_WepSetLabel11",covColors["Venthyr"]..app.GetLocalizedString("SL_WepSetLabel6").."("..app.GetLocalizedString("Normal")..")|r",90002,"i:183891:4:"..app.GetLocalizedString("SL_WepSetNote15")..":3","SL_WepSetNote16",{{8,114133},{14,114138},{13,114134},{14,114136},{15,114131},
                          {5,114130},{6,114132},{17,114139},{4,114140},{10,114142,"i:183889:4:"..app.GetLocalizedString("SL_WepSetNote22")..":3"},{12,114141,"i:183889:4:"..app.GetLocalizedString("SL_WepSetNote22")..":3"}},3},
{9045,"SL_WepSetName35","SL_WepSetLabel11",covColors["Venthyr"]..app.GetLocalizedString("SL_WepSetLabel6").."("..app.GetLocalizedString("Mythic")..")|r",90002,"i:183891:4:"..app.GetLocalizedString("SL_WepSetNote15")..":6","SL_WepSetNote14",{{8,114860},{14,114861},{13,114862},{14,114863},{15,115056},
                          {5,114864},{6,114865},{17,114867},{4,114868},{10,114859,"i:183889:4:"..app.GetLocalizedString("SL_WepSetNote22")..":6"},{12,114869,"i:183889:4:"..app.GetLocalizedString("SL_WepSetNote22")..":6"}},3},

--Season 1
{9044,"SL_WepSetName34","SL_WepSetLabel10",covColors["Kyrian"]..app.GetLocalizedString("SL_WepSetLabel9").."|r",90002,nil,nil,{{3,111004},{5,111009},{10,111014},{1,108553},{14,110999},
                          {14,110994},{11,115703},{12,108565},{13,111617},{9,112965},{17,115528},},1},
{9043,"SL_WepSetName34","SL_WepSetLabel10",covColors["Necro"]..app.GetLocalizedString("SL_WepSetLabel8").."|r",90002,nil,nil,{{5,114609},{5,114604},{7,114611},{10,114606},{1,114607},
                          {8,114615},{11,114613},{12,114605},{13,115758},{2,114612},{17,114608},},1},
{9042,"SL_WepSetName34","SL_WepSetLabel10",covColors["NightFae"]..app.GetLocalizedString("SL_WepSetLabel7").."|r",90002,nil,nil,{{3,112870},{5,112280},{6,112362},{10,112353},
                          {8,112343},{12,112393},{13,112829},{13,112311},{9,112327},{16,112838},{17,112960},},1},
{9041,"SL_WepSetName34","SL_WepSetLabel10",covColors["Venthyr"]..app.GetLocalizedString("SL_WepSetLabel6").."|r",90002,nil,nil,{{4,114127},{5,114117},{6,114119},{10,114129},{8,114120},
                          {14,114123},{14,114125},{12,114128},{13,114121},{15,114118},{17,114126},},1},

--Covenant (Kyrian)
{9040,"SL_WepSetName33",covColors["Kyrian"]..app.GetLocalizedString("SL_WepSetLabel9").."|r",covColors["Kyrian"]..app.GetLocalizedString("SL_WepSetDesc5").."|r",90002,nil,nil,{{1,108555},{5,111011},{14,111001},{14,115692},{11,108906},
                          {12,108567},{17,115531},{3,111006},{10,111016},{13,111616},{9,112963}}},
{9039,"SL_WepSetName32",covColors["Kyrian"]..app.GetLocalizedString("SL_WepSetLabel9").."|r",covColors["Kyrian"]..app.GetLocalizedString("SL_WepSetDesc4").."|r",90002,nil,nil,{{1,115696},{5,115698},{14,110996},{11,115699},{9,112968},
                          {12,108568},{13,111620},{14,111002},{3,111007},{10,111017},{17,115532}}},
{9038,"SL_WepSetName31",covColors["Kyrian"]..app.GetLocalizedString("SL_WepSetLabel9").."|r",covColors["Kyrian"]..app.GetLocalizedString("SL_WepSetDesc8").."|r",90002,"SL_WepSetNote13","a:14862",{{1,108554},{14,111000},{14,115695},{3,111005},
                          {5,115694},{11,111019},{13,111618},{9,112966},{10,111015},{12,108566},{17,115530}}},

--Covenant (Necrolord)
{9037,"SL_WepSetName30",covColors["Necro"]..app.GetLocalizedString("SL_WepSetLabel8").."|r",covColors["Necro"]..app.GetLocalizedString("SL_WepSetDesc5").."|r",90002,nil,nil,{{2,114623},{5,114616},{7,114622},{10,114618},{12,114617},
                          {1,115043},{5,114626},{8,114619},{11,114624},{13,114621},{17,114620}}}, 
{9036,"SL_WepSetName29",covColors["Necro"]..app.GetLocalizedString("SL_WepSetLabel8").."|r",covColors["Necro"]..app.GetLocalizedString("SL_WepSetDesc4").."|r",90002,nil,nil,{{1,115350},{5,115351},{8,115344},{11,115349},{13,115346},
                          {17,115345},{2,115348},{5,115341},{7,115347},{10,115343},{12,115342}}},
{9035,"SL_WepSetName28",covColors["Necro"]..app.GetLocalizedString("SL_WepSetLabel8").."|r",covColors["Necro"]..app.GetLocalizedString("SL_WepSetDesc7").."|r",90002,"i:184303:4:"..app.GetLocalizedString("Arsenal")..app.GetLocalizedString("SL_WepSetNote12"),nil,{{5,115353},{5,115363},{8,115356},{1,115362},{17,115357},
                          {13,115358},{2,115360},{11,115361},{7,115359},{12,115354},{10,115355}}},

--Covenant (Night Fae)
{9034,"SL_WepSetName27",covColors["NightFae"]..app.GetLocalizedString("SL_WepSetLabel7").."|r",covColors["NightFae"]..app.GetLocalizedString("SL_WepSetDesc5").."|r",90002,nil,nil,{{6,112364},{8,112344},{16,112840},{9,112326},{13,112830},
                          {12,112386},{5,112278},{17,112958},{3,112868},{13,112314},{10,112351}}},
{9033,"SL_WepSetName26",covColors["NightFae"]..app.GetLocalizedString("SL_WepSetLabel7").."|r",covColors["NightFae"]..app.GetLocalizedString("SL_WepSetDesc4").."|r",90002,nil,nil,{{5,112279},{17,112956},{8,114089},{3,112866},{13,112828},
                          {13,112313},{10,112352},{6,112365},{16,112839},{9,112324},{12,112392}}},
{9032,"SL_WepSetName25",covColors["NightFae"]..app.GetLocalizedString("SL_WepSetLabel7").."|r",covColors["NightFae"]..app.GetLocalizedString("SL_WepSetDesc6").."|r",90002,"i:184118:4:"..app.GetLocalizedString("Arsenal")..app.GetLocalizedString("SL_WepSetNote11"),nil,{{5,112281},{8,112340},{6,112366},{17,112955},{9,112329},
                          {13,112826},{13,112310},{10,112355},{12,112391},{16,112837},{3,112864}}},

--Covenant (Venthyr)
{9031,"SL_WepSetName24",covColors["Venthyr"]..app.GetLocalizedString("SL_WepSetLabel6").."|r",covColors["Venthyr"]..app.GetLocalizedString("SL_WepSetDesc5").."|r",90002,nil,nil,{{10,113479},{4,113477},{8,113470},{13,113471},{14,113474},
                          {6,113469},{17,113476},{5,113467},{12,113478},{14,113475},{15,113468}}},
{9030,"SL_WepSetName33",covColors["Venthyr"]..app.GetLocalizedString("SL_WepSetLabel6").."|r",covColors["Venthyr"]..app.GetLocalizedString("SL_WepSetDesc4").."|r",90002,nil,nil,{{8,114146},{10,114155},{14,114149},{15,114144},{5,114143},
                          {13,114148},{4,114153},{14,114151},{5,115067},{6,114145},{17,114152},{12,114154}}},
{9029,"SL_WepSetName23",covColors["Venthyr"]..app.GetLocalizedString("SL_WepSetLabel6").."|r",covColors["Venthyr"]..app.GetLocalizedString("SL_WepSetDesc3").."|r",90002,"SL_WepSetNote10","SL_WepSetNote9",{{8,114094},{10,114103},{14,114097},{15,114092},{6,114093},
                          {17,114100},{12,114102},{14,114099},{13,114095},{5,114091},{4,114101},{5,115066}}},

--Oribos
{9028,"SL_WepSetName22","SL_WepSetLabel5",nil,90002,"SL_WepSetNote8",nil,{{5,105971},{5,105976},{17,105978},{1,105974},{15,105969},{2,105975,nil,"SL_WepSetNote30"},{11,105972},{14,105968,nil,"SL_WepSetNote7"},{3,106715,nil,"SL_WepSetNote30"},
                          {13,111664,nil,"SL_WepSetNote31"},{10,109356},{15,111650,"SL_WepSetNote7"},{12,111455,app.GetLocalizedString("SL_WepSetNote119")..app.GetLocalizedString("SL_WepSetNote43"),"SL_WepSetNote7"},{8,112853,"SL_WepSetNote7"},{8,111659,"SL_WepSetNote7"},}},
{9027,"SL_WepSetName21","SL_WepSetLabel5",nil,90002,nil,"SL_WepSetNote7",{{1,111554,app.GetLocalizedString("SL_WepSetNote114")..app.GetLocalizedString("SL_WepSetNote42")},{5,111550},{5,111499,app.GetLocalizedString("SL_WepSetNote115")..app.GetLocalizedString("SL_WepSetNote42")},{8,111559,"i:187187:7:"..app.GetLocalizedString("SL_WepSetNote117")},{11,111560},
                          {14,111553,"SL_WepSetNote116"},{17,111551},{10,111528,"SL_WepSetNote29"},{13,111529,"SL_WepSetNote29"},
                          {2,146090,"SL_WepSetNote29","i:187187:7:"..app.GetLocalizedString("SL_WepSetNote117")},{8,116747,"SL_WepSetNote29","i:187187:7:"..app.GetLocalizedString("SL_WepSetNote117")},{12,146085,"SL_WepSetNote29","SL_WepSetNote8"},
                          {15,116756,"SL_WepSetNote29","i:187187:7:"..app.GetLocalizedString("SL_WepSetNote117")},{3,116773,app.GetLocalizedString("SL_WepSetNote118")..app.GetLocalizedString("SL_WepSetNote100"),""},}},
{9026,"SL_WepSetName20","SL_WepSetLabel5",nil,90002,nil,"SL_WepSetNote7",{{1,112872},{3,112889,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote101")..app.GetLocalizedString("SL_WepSetNote43")},{5,111467,app.GetLocalizedString("SL_WepSetNote102")..app.GetLocalizedString("SL_WepSetNote100")},{8,111456,app.GetLocalizedString("SL_WepSetNote103")..app.GetLocalizedString("SL_WepSetNote100")},
                          {10,111549,"SL_WepSetNote104"},{11,112873,"SL_WepSetNote105"},{12,111473,app.GetLocalizedString("SL_WepSetNote106")..app.GetLocalizedString("SL_WepSetNote100")},
                          {5,116775,app.GetLocalizedString("SL_WepSetNote107")..app.GetLocalizedString("SL_WepSetNote100"),""},{13,112874,"SL_WepSetNote108"},{14,111462},{15,111497,"SL_WepSetNote33"},{2,116776,app.GetLocalizedString("SL_WepSetNote109")..app.GetLocalizedString("SL_WepSetNote100")},
                          {8,116777,app.GetLocalizedString("SL_WepSetNote111")..app.GetLocalizedString("SL_WepSetNote100"),app.GetLocalizedString("SL_WepSetNote110")..app.GetLocalizedString("SL_WepSetNote100")},{15,116745,app.GetLocalizedString("SL_WepSetNote112")..app.GetLocalizedString("SL_WepSetNote41"),""},{17,115872,app.GetLocalizedString("SL_WepSetNote113")..app.GetLocalizedString("SL_WepSetNote100"),"SL_WepSetNote33"},}},
{9025,"SL_WepSetName19","SL_WepSetLabel5",nil,90002,"SL_WepSetNote7",nil,{{1,111558},{2,111561},{10,111563,nil,app.GetLocalizedString("SL_WepSetNote97")..app.GetLocalizedString("SL_WepSetNote41")},{12,111562},{5,111583,"SL_WepSetNote29"},{5,111475,nil,"i:186196:4:"..app.GetLocalizedString("SL_WepSetNote98")},{8,111474},{11,111584},
                          {13,111454,nil,"SL_WepSetNote8"},{8,105973,"SL_WepSetNote8"},{14,111476},{15,116810,"SL_WepSetNote100",app.GetLocalizedString("SL_WepSetNote73")..app.ColorStringByClass(app.GetLocalizedString("SL_WepSetNote99"),"Paladin")..app.GetLocalizedString("SL_WepSetNote96")},
                          {17,116752,"SL_WepSetNote29"},{3,116742,"SL_WepSetNote29","i:187187:7:"..app.GetLocalizedString("SL_WepSetNote117")},}},
{9024,"SL_WepSetName18","SL_WepSetLabel5",nil,90002,"SL_WepSetNote6",nil,{{1,111371},{8,111374},{8,111384},{14,111377},{2,111378},{11,111375},{15,111379},{12,111393},
                          {5,111373},{5,114603},{17,111382},{3,111427},{13,111376},{10,111381},}},

--Ardenweald
{9023,"SL_WepSetName17",covColors["NightFae"]..app.GetLocalizedString("SL_WepSetLabel4").."|r",nil,90002,nil,nil,{{13,112301,"SL_WepSetNote4"},{13,112929,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote94")..app.GetLocalizedString("SL_WepSetNote44"),"SL_WepSetNote92"},
                          {2,112919,app.GetLocalizedString("SL_WepSetNote74")..app.GetLocalizedString("SL_WepSetNote44"),app.GetLocalizedString("SL_WepSetNote73")..app.GetColoredClassNameString("Death Knight")..", "..app.GetColoredClassNameString("Paladin")..", or "..app.GetColoredClassNameString("Warrior")},{1,112909,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote95")..app.GetLocalizedString("SL_WepSetNote44"),"SL_WepSetNote89"},{10,112347,"SL_WepSetNote4"},{11,112317,"SL_WepSetNote25","SL_WepSetNote89"},
                          {5,112285,"SL_WepSetNote25",app.GetLocalizedString("SL_WepSetNote73")..app.GetColoredClassNameString("Rogue")},{9,112321,"SL_WepSetNote25"},{14,112299,"SL_WepSetNote4"},
                          {3,112367,"q:63578"},{17,112294,"SL_WepSetNote4"},{8,112332,"SL_WepSetNote4"},{12,112389,"SL_WepSetNote4"},}},
{9022,"SL_WepSetName16",covColors["NightFae"]..app.GetLocalizedString("SL_WepSetLabel4").."|r",nil,90002,nil,nil,{{13,112928,app.GetLocalizedString("SL_WepSetNote74")..app.GetLocalizedString("SL_WepSetNote44"),"SL_WepSetNote92"},
                          {2,112918,app.GetLocalizedString("SL_WepSetNote74")..app.GetLocalizedString("SL_WepSetNote44"),app.GetLocalizedString("SL_WepSetNote73")..app.GetColoredClassNameString("Death Knight")..", "..app.GetColoredClassNameString("Paladin")..", or "..app.GetColoredClassNameString("Warrior")},{1,112908,app.GetLocalizedString("SL_WepSetNote74")..app.GetLocalizedString("SL_WepSetNote44"),app.GetLocalizedString("SL_WepSetNote73")..app.GetColoredClassNameString("Death Knight")..", "..app.GetColoredClassNameString("Paladin")..", or "..app.GetColoredClassNameString("Warrior")},{17,112296,"q:63578"},{8,112330,"q:63578"},{12,112387,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote93")..app.GetLocalizedString("SL_WepSetNote44")},
                          {10,112346,"SL_WepSetNote25"},{11,112316,"q:63578"},{5,109453,"q:60856","q:59623"},{9,112320,"q:63578"},{14,112300,"q:63578"},{3,112368,"SL_WepSetNote25"},}},
{9021,"SL_WepSetName15",covColors["NightFae"]..app.GetLocalizedString("SL_WepSetLabel4").."|r",nil,90002,nil,nil,{{13,112302,"SL_WepSetNote25"},{13,112926,app.GetLocalizedString("SL_WepSetNote74")..app.GetLocalizedString("SL_WepSetNote44"),"SL_WepSetNote92"},
                          {2,112916,app.GetLocalizedString("SL_WepSetNote74")..app.GetLocalizedString("SL_WepSetNote44"),app.GetLocalizedString("SL_WepSetNote73")..app.GetColoredClassNameString("Death Knight")..", "..app.GetColoredClassNameString("Paladin")..", or "..app.GetColoredClassNameString("Warrior")},{1,112906,app.GetLocalizedString("SL_WepSetNote74")..app.GetLocalizedString("SL_WepSetNote44"),"SL_WepSetNote89"},{10,112348,"q:63578"},{11,112318,"SL_WepSetNote4"},
                          {5,112284,"SL_WepSetNote4"},{9,112322,"SL_WepSetNote4"},{3,112369,"SL_WepSetNote4"},{17,112293,"SL_WepSetNote25"},
                          {8,112331,"SL_WepSetNote25"},{12,112388,"SL_WepSetNote25"},{14,112297,app.GetLocalizedString("SL_WepSetNote49")..app.GetLocalizedString("SL_WepSetNote91")..app.GetLocalizedString("SL_WepSetNote44"),app.GetLocalizedString("SL_WepSetNote73")..app.GetColoredClassNameString("Death Knight")..", "..app.GetColoredClassNameString("Paladin")..", or "..app.GetColoredClassNameString("Warrior")},}},
{9020,"SL_WepSetName14",covColors["NightFae"]..app.GetLocalizedString("SL_WepSetLabel4").."|r",nil,90002,nil,nil,{{13,112303,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote75")..app.GetLocalizedString("SL_WepSetNote44"),"SL_WepSetNote92"},{13,112927,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote76")..app.GetLocalizedString("SL_WepSetNote44"),"SL_WepSetNote92"},
                          {2,112917,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote77")..app.GetLocalizedString("SL_WepSetNote44"),app.GetLocalizedString("SL_WepSetNote73")..app.GetColoredClassNameString("Death Knight")..", "..app.GetColoredClassNameString("Paladin")..", or "..app.GetColoredClassNameString("Warrior")},
                          {1,112907,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote78")..app.GetLocalizedString("SL_WepSetNote44"),app.GetLocalizedString("SL_WepSetNote73")..app.GetColoredClassNameString("Death Knight")..", "..app.GetColoredClassNameString("Paladin")..", or "..app.GetColoredClassNameString("Warrior")},
                          {10,112349,app.GetLocalizedString("SL_WepSetNote49")..app.GetLocalizedString("SL_WepSetNote79")..app.GetLocalizedString("SL_WepSetNote44"),"SL_WepSetNote92"},{11,113582,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote81")..app.GetLocalizedString("SL_WepSetNote44"),app.GetLocalizedString("SL_WepSetNote73")..app.GetColoredClassNameString("Druid")..", "..app.GetColoredClassNameString("Hunter")..", or "..app.GetColoredClassNameString("Monk")},{5,112287,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote82")..app.GetLocalizedString("SL_WepSetNote44"),app.GetLocalizedString("SL_WepSetNote73")..app.GetColoredClassNameString("Rogue")},
                          {9,113581,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote83")..app.GetLocalizedString("SL_WepSetNote44"),app.GetLocalizedString("SL_WepSetNote73")..app.GetColoredClassNameString("Death Knight")..", "..app.GetColoredClassNameString("Paladin")..", or "..app.GetColoredClassNameString("Warrior")},
                          {3,112370,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote85")..app.GetLocalizedString("SL_WepSetNote44"),app.GetLocalizedString("SL_WepSetNote73")..app.GetColoredClassNameString("Hunter")},{14,112298,"SL_WepSetNote28",app.GetLocalizedString("SL_WepSetNote73")..app.GetColoredClassNameString("Death Knight")..", "..app.GetColoredClassNameString("Paladin")..", or "..app.GetColoredClassNameString("Warrior")},{17,112295,app.GetLocalizedString("SL_WepSetNote49")..app.GetLocalizedString("SL_WepSetNote86")..app.GetLocalizedString("SL_WepSetNote44")},
                          {8,112333,app.GetLocalizedString("SL_WepSetNote73")..app.GetColoredClassNameString("Monk")..", "..app.GetColoredClassNameString("Rogue")..", or "..app.GetColoredClassNameString("Shaman")},{12,113580,"SL_WepSetNote88"},}},
{9019,"SL_WepSetName13",covColors["NightFae"]..app.GetLocalizedString("SL_WepSetLabel4").."|r",nil,90002,nil,nil,{{13,109457,"q:60856"},{13,112925,app.GetLocalizedString("SL_WepSetNote74")..app.GetLocalizedString("SL_WepSetNote44"),"SL_WepSetNote92"},
                          {2,111452,"SL_WepSetNote7",app.GetLocalizedString("SL_WepSetNote73")..app.GetColoredClassNameString("Death Knight")..", "..app.GetColoredClassNameString("Paladin")..", or "..app.GetColoredClassNameString("Warrior")},
                          {1,112905,app.GetLocalizedString("SL_WepSetNote74")..app.GetLocalizedString("SL_WepSetNote44"),app.GetLocalizedString("SL_WepSetNote73")..app.GetColoredClassNameString("Paladin")..", "..app.GetColoredClassNameString("Monk")..", or "..app.GetColoredClassNameString("Shaman")},{10,111060,"q:60856"},{11,109456,"q:60856","q:59623"},{3,109452,"q:60856","q:59623"},{5,112283,"q:63578"},{14,109458,"q:60856","q:59623"},{17,109461,"q:60856","q:59623"},{8,109454,"q:60856","q:59623"},
                          {9,109455,"q:60856","q:59623"},{12,109459,"q:60856"},}},

--Bastion
{9018,"SL_WepSetName12",covColors["Kyrian"]..app.GetLocalizedString("SL_WepSetLabel3").."|r",nil,90002,"SL_WepSetNote5",nil,{{6,106717,nil,"TWW_SetDesc6"},{8,111534,nil,"SL_WepSetNote7"},{5,114852},{4,106714,nil,"TWW_SetDesc6"},{10,114850},{8,114856},{15,114853},
                          {11,114849,nil,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote71")..app.GetLocalizedString("SL_WepSetNote45")},{17,112273,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote88")..app.GetLocalizedString("SL_WepSetNote45")},{12,114848},}},
{9017,"SL_WepSetName11",covColors["Kyrian"]..app.GetLocalizedString("SL_WepSetLabel3").."|r",nil,90002,"SL_WepSetNote4",nil,{{6,113534},{8,113537},{5,113535},{4,113529},{10,113533},{8,113539},{15,113536},{11,113532},{17,113530},{12,113531},}},
{9016,"SL_WepSetName10",covColors["Kyrian"]..app.GetLocalizedString("SL_WepSetLabel3").."|r",nil,90002,"SL_WepSetNote3",nil,{{6,109794},{8,109797},{5,109795},{4,109789},{10,109793},{8,109862},{15,109796},{11,109792},{17,109790},{12,109791},}},
{9015,"Heroic",covColors["Kyrian"]..app.GetLocalizedString("SL_WepSetLabel3").."|r",nil,90002,nil,nil,{{6,112274,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote68")..app.GetLocalizedString("SL_WepSetNote45")},{8,112272,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote69")..app.GetLocalizedString("SL_WepSetNote45")},{5,112271,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote70")..app.GetLocalizedString("SL_WepSetNote45")},{4,111665,"SL_WepSetNote7"},
                          {11,115873,"SL_WepSetNote88"},{12,115876,"SL_WepSetNote88"},}},
{9014,"SL_WepSetName31",covColors["Kyrian"]..app.GetLocalizedString("SL_WepSetLabel3").."|r",nil,90002,"i:184462:3:"..app.GetLocalizedString("Arsenal")..app.GetLocalizedString("SL_WepSetNote2"),"SL_WepSetNote1",{{6,115665},{8,115668},{5,115666},{4,115661},{10,115664},{8,115670},{15,115667},{11,115663},{17,115662},}},

--Maldraxxus
{9013,"SL_WepSetName9",covColors["Necro"]..app.GetLocalizedString("SL_WepSetLabel2").."|r",nil,90002,"SL_WepSetNote0",nil,{{14,111597},{5,113246},{13,111596},{16,106711,nil,"SL_WepSetNote8"},
                          {1,113763,"SL_WepSetNote24",app.GetLocalizedString("SL_WepSetNote49")..app.GetLocalizedString("SL_WepSetNote67")..app.GetLocalizedString("SL_WepSetNote46")},{1,113764,"SL_WepSetNote24",app.GetLocalizedString("SL_WepSetNote49")..app.GetLocalizedString("SL_WepSetNote67")..app.GetLocalizedString("SL_WepSetNote46")},
                          {8,111595},{15,111600},{12,111601},{10,111602},{17,111603},{4,111598},{5,111594},}},
{9012,"SL_WepSetName8",covColors["Necro"]..app.GetLocalizedString("SL_WepSetLabel2").."|r",nil,90002,nil,nil,{{14,115601,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote62")..app.GetLocalizedString("SL_WepSetNote46")},{5,113216,"q:59011","q:60886",},{13,113571,"SL_WepSetNote4"},
                          {16,115460,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote63")..app.GetLocalizedString("SL_WepSetNote46")},{8,115870,"SL_WepSetNote88"},{15,115463,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote64")..app.GetLocalizedString("SL_WepSetNote46")},{12,113235,app.GetLocalizedString("SL_WepSetNote65")..app.GetLocalizedString("SL_WepSetNote46")},
                          {1,115467,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote66")..app.GetLocalizedString("SL_WepSetNote46")},{17,109756,"q:59011","q:57316"},{4,114552,-1},{5,114548,-1},}},
{9011,"SL_WepSetName7",covColors["Necro"]..app.GetLocalizedString("SL_WepSetLabel2").."|r",nil,90002,nil,nil,{{14,114551,-1},{5,114559,-1},{13,114550,-1},{16,114553,-1},{1,115470,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote57")..app.GetLocalizedString("SL_WepSetNote46")},{1,115469,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote57")..app.GetLocalizedString("SL_WepSetNote46")},{8,114549,-1},
                          {15,115464,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote58")..app.GetLocalizedString("SL_WepSetNote46")},{12,109754,"q:59011:57316","SL_WepSetNote24"},{10,113570,"SL_WepSetNote4"},
                          {17,115461,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote59")..app.GetLocalizedString("SL_WepSetNote46")},{4,109751,"q:57316:59011:60886",app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote60")..app.GetLocalizedString("SL_WepSetNote46")},{5,115468,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote61")..app.GetLocalizedString("SL_WepSetNote46")},}},
{9010,"SL_WepSetName6",covColors["Necro"]..app.GetLocalizedString("SL_WepSetLabel2").."|r",nil,90002,"SL_WepSetNote4",nil,{{14,113575},{5,113573},{1,115462,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote59")..app.GetLocalizedString("SL_WepSetNote46")},{8,113574},{15,113576},{12,113578},
                          {10,115606,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote56")..app.GetLocalizedString("SL_WepSetNote46")},{16,109752,"q:59011:57316","SL_WepSetNote24"},{1,115466,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote66")..app.GetLocalizedString("SL_WepSetNote46")},{17,113577},{4,113568},{5,113572},}},
{9009,"SL_WepSetName5",covColors["Necro"]..app.GetLocalizedString("SL_WepSetLabel2").."|r",nil,90002,nil,nil,{{14,109750,"q:59011:57316:60886","SL_WepSetNote24"},{5,115602,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote53")..app.GetLocalizedString("SL_WepSetNote46")},
                          {13,109749,"q:57316:59011:60886","SL_WepSetNote24"},{8,109748,"q:59011:57316:60886",app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote54")..", "..app.GetLocalizedString("SL_WepSetNote24")},
                          {15,109753,"q:59011:57316:60886","SL_WepSetNote24"},{12,115600,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote55")..app.GetLocalizedString("SL_WepSetNote46")},
                          {10,109755,"q:59011:57316","SL_WepSetNote24"},{16,113569,"SL_WepSetNote4"},{17,114557,-1},{4,115875,app.GetLocalizedString("SL_WepSetNote0")},
                          {5,109747,"q:59011:57316:60886","SL_WepSetNote24"},}},

--Revendreth
{9008,"SL_WepSetName4",covColors["Venthyr"]..app.GetLocalizedString("SL_WepSetLabel1").."|r",nil,90002,nil,nil,{{8,111075,"q:57724:59726","SL_WepSetNote26"},{5,110862,"q:57189:59726",app.GetLocalizedString("SL_WepSetNote26")..", "..app.GetLocalizedString("SL_WepSetNote158")..app.GetLocalizedString("SL_WepSetNote47")},
                          {5,113018,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote159")..app.GetLocalizedString("SL_WepSetNote47")},{9,110866,"q:57189:59726","SL_WepSetNote26"},{13,110857,"q:57724:59726","SL_WepSetNote26"},{12,110850,"q:57189","SL_WepSetNote26"},
                          {10,113312,"SL_WepSetNote4"},{17,110987,app.GetLocalizedString("SL_WepSetNote49")..app.GetLocalizedString("SL_WepSetNote160")},{14,112985,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote52")..app.GetLocalizedString("SL_WepSetNote47"),"SL_WepSetNote161"},
                          {11,113515,"q:62778","SL_WepSetNote23"},{7,110982,"SL_WepSetNote26"},}},
{9007,"SL_WepSetName3",covColors["Venthyr"]..app.GetLocalizedString("SL_WepSetLabel1").."|r",nil,90002,nil,nil,{{8,113311,"SL_WepSetNote4"},{5,115867,"SL_WepSetNote88"},{5,113310,"SL_WepSetNote4"},{5,115060,app.GetLocalizedString("SL_WepSetNote158")..app.GetLocalizedString("SL_WepSetNote47")},
                          {9,113309,"SL_WepSetNote4"},{13,299368},{12,113513,"q:62778","SL_WepSetNote23"},{10,110851,"q:57189","SL_WepSetNote26"},{17,110863,"q:59726","q:57189"},
                          {14,114304,app.GetLocalizedString("SL_WepSetNote49")..app.GetLocalizedString("SL_WepSetNote157")..app.GetLocalizedString("SL_WepSetNote47")},{11,114306,"SL_WepSetNote36"},{7,111461,"SL_WepSetNote7"},}},
{9006,"SL_WepSetName2",covColors["Venthyr"]..app.GetLocalizedString("SL_WepSetLabel1").."|r",nil,90002,nil,nil,{{8,113523,"SL_WepSetNote37"},{5,113308,"SL_WepSetNote4"},{5,110984,"SL_WepSetNote26"},
                          {5,115062,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote152")..app.GetLocalizedString("SL_WepSetNote47"),app.GetLocalizedString("SL_WepSetNote49")..app.GetLocalizedString("SL_WepSetNote151")..app.GetLocalizedString("SL_WepSetNote47")},{9,110852,"q:57724","SL_WepSetNote23"},{7,107304,"SL_WepSetNote8"},
                          {13,110983,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote154")..app.GetLocalizedString("SL_WepSetNote47"),app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote153")..app.GetLocalizedString("SL_WepSetNote47")},{12,113005,"SL_WepSetNote36"},{10,113259,"SL_WepSetNote35"},
                          {17,113008,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote155")..app.GetLocalizedString("SL_WepSetNote47")},{14,110864,"q:57189:59726",app.GetLocalizedString("SL_WepSetNote26")..app.GetLocalizedString("SL_WepSetNote158")..app.GetLocalizedString("SL_WepSetNote47")},{11,112983,app.GetLocalizedString("SL_WepSetNote49")..app.GetLocalizedString("SL_WepSetNote156"),"SL_WepSetNote47"},}},
{9005,"SL_WepSetName1",covColors["Venthyr"]..app.GetLocalizedString("SL_WepSetLabel1").."|r",nil,90002,nil,nil,{{8,115871,"SL_WepSetNote26"},{5,110859,"q:57724",app.GetLocalizedString("SL_WepSetNote50")..app.GetLocalizedString("SL_WepSetNote47")},{5,112984,app.GetLocalizedString("SL_WepSetNote49")..app.GetLocalizedString("SL_WepSetNote51"),"SL_WepSetNote92"},
                          {5,115061,app.GetLocalizedString("SL_WepSetNote148")..app.GetLocalizedString("SL_WepSetNote44")},{9,114303,app.GetLocalizedString("SL_WepSetNote49")..app.GetLocalizedString("SL_WepSetNote149")},{13,113303,"SL_WepSetNote4"},
                          {12,112986,app.GetLocalizedString("SL_WepSetNote49")..app.GetLocalizedString("SL_WepSetNote150")..app.GetLocalizedString("SL_WepSetNote47")},{10,112987,app.GetLocalizedString("SL_WepSetNote49")..app.GetLocalizedString("SL_WepSetNote150")..app.GetLocalizedString("SL_WepSetNote47")},{17,113306,"SL_WepSetNote4"},
                          {14,110856,"q:57724","SL_WepSetNote23"},{11,113304,"SL_WepSetNote4"},{7,113305,"SL_WepSetNote4"},}},
{9004,"SL_WepSetName35",covColors["Venthyr"]..app.GetLocalizedString("SL_WepSetLabel1").."|r",nil,90002,nil,nil,{{8,114301,app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote154")..app.GetLocalizedString("SL_WepSetNote47"),app.GetLocalizedString("SL_WepSetNote48")..app.GetLocalizedString("SL_WepSetNote153")..app.GetLocalizedString("SL_WepSetNote47")},{5,115868,"SL_WepSetNote88"},
                          {5,110858,"q:57724","SL_WepSetNote23"},{5,115063,"SL_WepSetNote26"},{9,105970,"SL_WepSetNote8","SL_WepSetNote34"},
                          {13,110853,"q:57724","SL_WepSetNote23"},{12,113313,"SL_WepSetNote4"},{10,113514,"SL_WepSetNote37","q:62778"},{17,110855,"q:57724"},
                          {14,113307,"SL_WepSetNote4"},{11,110981,"SL_WepSetNote26"},{7,110854,"q:57724","SL_WepSetNote23"},}},

--NPE
{9003,"SL_WepSetName0","SL_WepSetLabel0","SL_WepSetDesc2",90000,nil,nil,{{2,114252,-1},{3,114285,-1},{15,168278,-2},{15,114253,-1},{14,108836},{14,168949,-2},{14,107832},{13,108829},{13,114250,-1},{5,108838},{5,114248,-1},{9,114249,-1},{8,114278,-1},{17,114281,-1},
                                            {1,114246,-1},{1,114261,-1},{12,114254,-1},{12,114299,-1},}},
{9002,"SL_WepSetName0","SL_WepSetLabel0","SL_WepSetDesc1",90000,nil,nil,{{2,108831},{3,108828},{15,108832},{15,168938,-2},{14,168778,-2},{14,114275,-1},{14,114273,-1},{13,169069,-2},{13,169068,-2},{5,108837},{5,168321,-2},{9,169045,-2},{8,108839},{17,114255,-1},
                                                {1,108827},{1,114266,-1},{12,169080,-2},{12,168063,-2},{12,169079,-2},}},
{9001,"SL_WepSetName0","SL_WepSetLabel0","SL_WepSetDesc0",90000,nil,nil,{{2,169098,-2},{3,168320,-2},{15,114295,-1},{15,114292,-1},{14,114277,-1},{14,114274,-1},{14,169044,-2},{13,108830},{13,114291,-1},{5,114271,-1},{5,114268,-1},{9,168051,-2},{8,114279,-1},
                                                  {17,304855},{1,114267,-1},{1,114265,-1},{12,168230,-2},{12,114300,-1},}},
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