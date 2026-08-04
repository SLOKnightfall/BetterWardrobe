local app = select(2,...);

local expansionID = 12;

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
--{14,309641},{14,309640},{14,309639},
--{8,309650},{8,309651},{8,309649},

{12073,"Midnight_Halhadar","TWW_Karesh",nil,120007,nil,nil,{{1,309055},{7,309060},{17,309066},{5,309056},{8,309057},{13,309062},{12,309065},{8,309058},{14,309067},{10,309064},{16,309059},{11,309061},{15,309063},}},

--ninja recolor
{12072,"Midnight_Artisan","TWW_WepSetName38",nil,120007,nil,nil,{{5,304800},{8,304801},{14,304802},{10,304803},{15,304804},},2},

{12071,"TWW_WepSetDesc8"--[[Azure]],"Midnight_Extravaganza",nil,120007,nil,nil,     {{13,308677},{9,308672},{13,308668},},2},
{12070,"TWW_SweatsLively","Midnight_Extravaganza",nil,120007,nil,nil,    {{13,308678},{9,308673},{13,308669},},2},
{12069,"Midnight_Suntouched","Midnight_Extravaganza",nil,120007,nil,nil,{{13,308679},{9,308674},{13,308670},},2},
{12068,"TWW_SweatsRosy","Midnight_Extravaganza",nil,120007,nil,nil,      {{13,308680},{9,308675},{13,308671},},2},

{12067,"Midnight_BadlandsLawbringer","Midnight_BadlandsJustice",nil,120007,nil,nil, {{7,308958},{5,308878},{8,308863},},2},
--[[12064]]{12076,"Midnight_BloodwatchOutlaw","Midnight_BadlandsJustice",nil,120007,nil,nil,   {{7,308902},{5,308881},{8,308866},},2},
{12066,"Midnight_DuskwatchOutlaw","Midnight_BadlandsJustice",nil,120007,nil,nil,    {{7,308956},{5,308880},{8,308865},},2},
--[[12065]]{12075,"Midnight_RighteousLawbringer","Midnight_BadlandsJustice",nil,120007,nil,nil,{{7,308957},{5,308879},{8,308864},},2},

--[[12063]]{12074,"Midnight_SunFestival","Midnight_PaintedBattle",nil,120007,nil,nil,{{1,309311},{2,309312},{14,309313},{15,309314},}},

{12050,"Midnight_Lost","Midnight_PatientTreasure",nil,120000.5,nil,nil,{{6,302288},{8,302290},{14,302293},{13,302289},{2,302291},{9,302292},{15,302287},{15,302296},}},

{12061,"Midnight_VoidTouched","Midnight_VoidAssaults",nil,120005,"e:Midnight_VoidAssaults",nil,{{14,303089},{11,303076},{13,303080},{13,303078},{8,303082},{8,303072},{6,303100},{5,303069},{5,303067},{10,303085},{12,303075},{16,303097},{16,303098},{3,303094},{7,303066},{15,303092},{14,303086},{11,308640}}},

{12060,"Midnight_Berserker","Midnight_Amani",nil,120005,nil,nil,{{10,306303},{1,306304},{13,306342},{13,306341},{11,306333},{3,306311},{12,306301},}},

{12059,"Midnight_Sunwalker", "Midnight_PaintedBattle",nil,120005,nil,nil,{{15,304716},{14,304720},{2,304724},{1,304728},},2},
{12058,"Midnight_Duskrunner","Midnight_PaintedBattle",nil,120005,nil,nil,{{15,304717},{14,304721},{2,304725},{1,304729},},2},
{12057,"Midnight_Sunbringer","Midnight_PaintedBattle",nil,120005,nil,nil,{{15,304718},{14,304722},{2,304726},{1,304730},},2},
{12056,"Midnight_Dawnchaser","Midnight_PaintedBattle",nil,120005,nil,nil,{{15,304719},{14,304723},{2,304727},{1,304731},},2},

{12055,"Midnight_Ambermill", "Midnight_GilneanStreet",nil,120005,nil,nil,{{8,304589},{6,304593},{4,304597},},2},
{12054,"Midnight_Pyrewood",  "Midnight_GilneanStreet",nil,120005.1,app.GetTradingPostReleaseString("May",2026),nil,{{8,304590},{6,304594},{4,304598},},2},
{12053,"Midnight_Emberstone","Midnight_GilneanStreet",nil,120005,nil,nil,{{8,304591},{6,304595},{4,304599},},2},
{12052,"Midnight_Gilneas",   "Midnight_GilneanStreet",nil,120005.1,app.GetTradingPostReleaseString("May",2026),nil,{{8,304592},{6,304596},{4,304600},},2},

--[[{10,309643},12.0.7]]--[[{10,309644},y'mera's spare beacon not showing]]--[[{14,309642},12.0.7]]
{12065,"Midnight_DaggerspineLost","Midnight_LostArmaments",nil,120005,nil,nil,{{10,306329},{5,306314},{14,306343},{3,306309},{8,306323},{11,306331},{16,306349},{6,306320},{13,306335},},},
{12064,"Midnight_SindoreiLost","Midnight_LostArmaments",nil,120005,nil,nil,{{11,307833},{8,306324},{5,306315},{6,306321},{12,306296},{3,306308},{10,306302},{8,306325},{13,306336},},},
{12063,"Midnight_AmaniLost","Midnight_LostArmaments",nil,120005,nil,nil,{{12,306297},{2,306306},{13,306337},{16,306351},{14,306344},{8,306326},{5,306317},{5,306316},},},
{12051,"Midnight_TwilightLost","Midnight_LostArmaments",nil,120005,nil,nil,{{10,306353},{11,306339},{17,306348},{16,306354},{12,306298},{14,306345},{9,306330},{5,306319},},},

--[[12050]]{12062,"Midnight_Spellbreaker","Midnight_InfusedSilvermoon",nil,120005,"e:Midnight_DecorDuel",nil,{{17,307925},{14,307939},{14,307926},{15,307940},{11,307924},{13,308378,},{12,308377}},},
{12049,"Midnight_Dawnblade","Midnight_InfusedSilvermoon",nil,120000,nil,nil,{{17,301396,"d:237415","du:1304"},},},

{12046,"Midnight_Sky","Midnight_Amani",nil,120001.5,"i:264184","q:93437",{{12,303251},{10,303979},{1,303250},{13,303978},{11,303249},{13,303248},{3,303247}}},
{12045,"Midnight_Blight","Midnight_Amani",nil,120001.5,nil,nil,{{3,298172},{13,298155},{1,298173},{12,297844}}},
{12044,"BfA_Sentinel","Midnight_Amani",nil,120001.5,nil,nil,{{3,297848,"wb:244424"}}},

{12043,"Midnight_RootDefender","Midnight_Harandar",nil,120000.7,nil,nil,{{13,302102},{11,230348},{12,230349}}},

{12042,"Midnight_Simple","Midnight_Standard",nil,120000.3,nil,nil,{{5,297825},{5,297826},{14,297827},{14,297828},{15,297829},{17,297830},{17,297831},},2},
{12041,"Midnight_Sisterhood","DF_WepSetName53",nil,120000.2,app.GetTradingPostReleaseString("Mar",2026),nil,{{14,304077},{14,304084},{14,304082},{5,304086},{5,304087},{11,304085},{17,304076},{17,304083},{10,304226}},2},

{12040,"Midnight_Tarnished"   ,"Midnight_Silvermoon",nil,120001.3,nil,nil,{{13,301775},{12,301780},{10,301779},{10,301773},{5,301766},{17,301781},{8,301768},{15,301777},{14,301770},{1,301763},{5,301767},{3,301772},{12,303526,"r:9:2712"},}},
{12039,"Midnight_Competitor"  ,"Midnight_Silvermoon",nil,120001.3,nil,nil,{{13,304181},{12,287152},{10,304183},{10,292901},{5,287154},--[[{17,},]]{8,287151},{15,287155},{14,287156},{1,287149},{5,287150},{3,292902},}},
{12038,"Midnight_Eversong"    ,"Midnight_Silvermoon",nil,120001.3,nil,nil,{{13,302757},{12,300732},{10,300733},{10,302325},{5,295588},{17,300739},{8,303333},{15,302492},{14,302754},{1,302756},{5,302746},{3,302464},{12,295403},}},
{12037,"Midnight_Spellbreaker","Midnight_Silvermoon",nil,120001.3,nil,nil,{{13,304180},{12,287080},{10,304182},{10,287096},{5,287087},{17,287089},{8,287090},{15,287095},{14,287088},{1,287093},{5,287086},{3,304188},}},
{12036,"Midnight_Voidwalker"  ,"Midnight_Silvermoon",nil,120001.3,nil,nil,{{13,303384},{12,303383},{10,297845},{10,303543},{5,303470},{17,303484},{8,297851},{15,303476,"d:250683"},{14,303464},{1,297849},{5,303467,"d:242031","d:250841"},{3,303492},{12,303460},}},

{12035,"Midnight_Rootwarden" ,"Midnight_Harati",nil,120001.4,"r:6:2704:17","i:259073",{{16,301839},{4,301842},{10,301837},{1,301836},{13,301840},{13,301841},{2,301843},{15,301844},{11,301845},{5,301784},{5,301785},{6,301786},{6,301831},{8,301832},{8,301833},{17,301834},{14,301835},{12,301838},{3,301846},}},
{12034,"Aspirant"            ,"Midnight_Harati",nil,120001.4,"i:263215",nil,{{10,299574},{16,299583},{5,299581},{5,299569},{8,299570},{11,299571},{13,299572},{15,299573},{17,299575},{8,299576},{12,299577},{3,299578},{1,299582},{6,304262},{6,304265},}},
{12033,"Midnight_Lumenbloom" ,"Midnight_Harati",nil,120001.4,nil,nil,{{8,301022},{8,300999},{3,301017},{11,301016},{1,301024},{14,300998},{15,301014},{17,301018},{13,292893},{13,292894},{10,300996},{16,301945},{4,301948},{2,287172},{6,287169},{5,301949},{5,301001},{12,300995},}},
{12032,"Midnight_Elderbloom" ,"Midnight_Harati",nil,120001.4,"i:263577",nil,{{5,301995},{13,300975},{8,300972},{10,301998},{16,301996},{4,302485},{14,302484},{13,302082},{2,302081},{6,302080},{3,301997},{17,300978},{15,300976},{11,300974},{8,300973},{5,300971},{1,300969},{6,302482},{12,300977},}},
{12031,"Midnight_Bloomforged","Midnight_Harati",nil,120001.4,"SL_WepSetNote7"--[[dungeons]],nil,{{10,298099},{16,298186},{4,298185},{8,298104},{5,298115},{5,298130},{6,287094},{2,287091},{6,298162},{13,298125},{12,298109},{11,298148},{3,298100},{13,298083},{1,298094},{14,298192},{15,298084},{17,298227},{8,298089},}},

{12030,"Midnight_Oblivion"   ,"Midnight_Void",nil,120001.1,nil,nil,{{13,303636},{2,303635},{14,302099},{11,304057,"l:"..app.GetLocalizedString("Midnight_EmbeddedSpear")},}},
{12029,"Midnight_Void"       ,"Midnight_Void",nil,120001.1,nil,nil,{{13,298198},{2,298119},{14,298124},{11,298226},}},
{12028,"Midnight_Nothingness","Midnight_Void",nil,120001.1,nil,nil,{{13,297846},{2,297852},{14,303462},{11,303475},}},

{12027,"Midnight_Voidbreaker","Midnight_Thalassian",nil,120001.5,nil,nil,{{16,292009},{14,301106},{13,301096},{12,301194},{8,301090},{5,301083},{17,301123},{3,301082},{11,301093},{8,301092},{10,301085},{15,301121},{1,301079},}},
{12026,"Midnight_Preyseeker" ,"Midnight_Thalassian",nil,120001.5,nil,nil,{--[[{16,},]]{14,302055},{13,302061},{12,302065},{8,302051},{5,302049},{17,302058},{3,302059},{11,302060},{8,302052},{10,302064},{15,302063},{1,302048},}},
{12025,"DF_WepSetName39"     ,"Midnight_Thalassian",nil,120001.5,nil,nil,{{16,300656},--[[{14,},]]{13,300646},{12,300653},{8,300650},{5,300660},{17,300644},{3,300643},{11,300654},{8,300652},{10,300645},{15,300648},{1,300640},}},
{12024,"Midnight_Devourer"   ,"Midnight_Thalassian",nil,120001.5,nil,nil,{--[[{16,},]]--[[{14,},]]--[[{13,},]]--[[{12,},]]--[[{8,},]]--[[{5,},]]{17,304239},--[[{3,},]]--[[{11,},]]--[[{8,},]]--[[{10,},]]--[[{15,},]]--[[{1,},]]}},

--{12030,"Forest","Forest Dweller","Mossy" ,120000,nil,nil,{{13,302234},},2},
--{12029,"Forest","Forest Dweller","Dawn"  ,120000,nil,nil,{{13,302235},},2},
--{12028,"Forest","Forest Dweller","Night" ,120000,nil,nil,{{13,302237},},2},
--{12027,"Forest","Forest Dweller","Rooted",120000,nil,nil,{{13,302236},},2},

{12047,"Midnight_LilNavy" ,"Midnight_ToySoldier",nil,120000.1,app.GetTradingPostReleaseString("Mar",2026),nil,{{7,302247},{6,302245},{2,302240},{14,302232},{1,301457},},2},
{12023,"Midnight_LilBlue" ,"Midnight_ToySoldier",nil,120000.1,nil,nil,{{6,302243},{2,302238},{14,302230},{1,301455},},2},
{12022,"Midnight_LilBlack","Midnight_ToySoldier",nil,120000.1,nil,nil,{{7,302248},{2,302239},{1,301456},},2},
{12021,"Midnight_LilGreen","Midnight_ToySoldier",nil,120000.1,nil,nil,{{7,302249},{6,302244},{2,302241},{14,302231},{1,301458},},2},
{12020,"Midnight_LilRed"  ,"Midnight_ToySoldier",nil,120000.1,nil,nil,{{7,302250},{6,302246},{2,302242},{14,302233},{1,301459},},2},

{12019,"Midnight_AmaniCitizen","Midnight_Abundance",nil,120000.8,"e:Midnight_Abundance",nil,{{10,302454},{5,302451},{8,302453},{5,302450},{1,302452},}},

{12018,"Midnight_Riftwalker","Midnight_TreasuresRares","Midnight_Voidstorm",120000.9,nil,nil,{{5,304080,"l:"..app.GetLocalizedString("Midnight_DiscardedEnergyPike")},{3,304078,"l:"..app.GetLocalizedString("Midnight_FaindelsQuiver")},{12,304081,"l:"..app.GetLocalizedString("Midnight_ScoutsPack")},{14,304079,"l:"..app.GetLocalizedString("Midnight_Exaliburn")}}},
{12017,"Midnight_Fungarian","Midnight_TreasuresRares","Midnight_Harandar",120000.9,nil,nil,{{3,302667,"l:"..app.GetLocalizedString("Midnight_ReliLostPaintSupplies")},{12,302666},{11,302669,"l:"..app.GetLocalizedString("Midnight_SporelordsFightPrize")},{8,303497,"d:249902"},}},
{12016,"Midnight_Eversong","Midnight_TreasuresRares","Midnight_Eversong",120000.9,nil,nil,{--[[{3,302741},]]{14,303387,"d:240129"},{12,302751},{11,303637,"r:9:2714"},}},
{12048,"Midnight_ZulAman","Midnight_TreasuresRares","Midnight_ZulAman",120000.9,nil,nil,{{15,303478,"d:242025"},{11,303474,"d:247976"},{11,303866,"Midnight_AmaniWarSpear","Midnight_AmaniWarSpear2"},}},

{12015,"Midnight_Garden","Midnight_Homestead","TWW_WepSetDesc10" ,120000,nil,nil,{{10,302497},{11,302493,nil,app.GetTradingPostReleaseString("Apr",2026)},{14,302469,nil,app.GetTradingPostReleaseString("Apr",2026)},{2,249026,nil,app.GetTradingPostReleaseString("Apr",2026)},{13,302234}},2},--green
{12014,"Midnight_Garden","Midnight_Homestead","Desc_Pink"  ,120000,nil,nil,{{10,302498},{11,302494},{14,302470},--[[{2,},]]{13,302235}},2},
{12013,"Midnight_Garden","Midnight_Homestead","TWW_WepSetDesc1",120000,nil,nil,{{10,302499},{11,302495},{14,302471},{2,249027,nil,app.GetTradingPostReleaseString("Apr",2026)},{13,302237}},2},--purple
{12012,"Midnight_Garden","Midnight_Homestead","Desc_Red"   ,120000,nil,nil,{{10,302500,nil,app.GetTradingPostReleaseString("Apr",2026)},{11,302496},{14,302472},{2,249028,nil,app.GetTradingPostReleaseString("Apr",2026)},{13,302236,nil,app.GetTradingPostReleaseString("Apr",2026)}},2},

--{12014,"Sin'dorei","Sin'dorei","Red"  ,120000,nil,nil,{{17,298110},{17,301396},}},

{12011,"TWW_WepSetName36","Midnight_WeatheredTwilight",nil,119999,"i:248218",nil,{{14,295411},{1,295412},{2,295413},{3,295414},{5,295415},{7,295416},{8,295417},{9,295418},},},

{12010,"Midnight_Thornblade","Midnight_BloomingThorns","Desc_Pink"  ,120001,"v:251259",C_CurrencyInfo.GetCurrencyLink(3385),{{11,297853},{5,297847},{12,303461},{14,297850},{13,302664},{15,302665},{5,302663},}},
{12009,"Midnight_Thornblade","Midnight_BloomingThorns","Desc_Yellow",120001,nil,nil,{{11,298179},{5,298178},{12,298193},--[[{14,301522}]]}},

{12008,"TWW_WepSetName36","Midnight_TwilightCultists","TWW_WepSetDesc11",120000.2,nil,nil,{{5,303845},{1,303844},{14,303846},}},--blue
{12007,"TWW_WepSetName36","Midnight_TwilightCultists","TWW_WepSetDesc1",120000.2,"i:265362",nil,{{5,303843},{1,303841},{14,303842},}},--purple

{12006,"Midnight_Dawnguard","Midnight_TheVoidspire","LFR",120002.1,nil,nil,   {{5,303893},{17,303944},{14,303932},{6,303929},{12,303902},{9,303950},{8,303938},{8,303914},{5,303899},{13,303911},{13,302557},{11,303923},{10,303908},{7,303917},{3,303953},{2,303905},{17,302166},},3},
{12005,"Midnight_Dawnguard","Midnight_TheVoidspire","Normal",120002.1,nil,nil,{{5,296028},{17,296025},{14,296026},{6,296043},{12,296020},{9,296022},{8,296032},{8,296038},{5,296029},{13,296023},{13,296031},{11,296047},{10,296021},{7,296024},{3,296033},{2,296041},{17,302166},},3},
{12004,"Midnight_Dawnguard","Midnight_TheVoidspire","Heroic",120002.1,nil,nil,{{5,303894},{17,303945},{14,303933},{6,303930},{12,303903},{9,303951},{8,303939},{8,303915},{5,303900},{13,303912},{13,302558},{11,303924},{10,303909},{7,303918},{3,303954},{2,303906},{17,302166},},3},
{12003,"Midnight_Dawnguard","Midnight_TheVoidspire","Mythic",120002.1,nil,nil,{{5,303895},{17,303946},{14,303934},{6,303931},{12,303904},{9,303952},{8,303940},{8,303916},{5,303901},{13,303913},{13,302559},{11,303925},{10,303910},{7,303919},{3,303955},{2,303907},{17,302166},},3},
{12002,"Midnight_Galactic","Midnight_Season1","Elite",120002,nil,nil,    {{5,303884},{17,303877},{14,303889},{6,303885},{15,303887},{12,303883},{9,303888},{8,303891},{8,303881},{5,303876},{13,303890},{13,303879},{11,303878},{10,303882},{7,303886},{3,303880},{2,303892},},1},
{12001,"Midnight_Galactic","Midnight_Season1","Gladiator",120002,nil,nil,{{5,300582},{17,300574},{14,300589},{6,300583},{15,300587},{12,300580},{9,300588},{8,300581},{8,300578},{5,300573},{13,300591},{13,300576},{11,300575},{10,300579},{7,300584},{3,300577},{2,303875},},1},
};

local function comp(a,b)
  if a[1] < b[1] then return true; else return false end
end
table.sort(db,comp);

local function AddToCollection()
  local patch = select(4,GetBuildInfo()) + 1.9;
  for i = 1, #db do
    if (db[i][5] <= patch) then
      app.AddWepDBLineToTables(db[i], expansionID);
    end
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