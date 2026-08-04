local app = select(2,...);

local expansionID = 7;

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

local db = {
{7021,"Legion_Krokul","Legion_Krokul",nil,69990,nil,nil,{{11,169046},{1,168277},{1,292456},{5,168052,-1},},2},

{7020,"Legion_Fel","Legion_PrePatch",nil,69999,nil,nil,{{3,82869},{5,82868},{1,82862},{1,82870},{8,82865},{14,82863},{11,82867},{9,82871},{16,82883},{17,82872},},nil,1},

{7019,"Legion_Praetor","Legion_Argus","TWW_WepSetDesc10",70300,nil,nil,{
--green
{15,90885,"d:125824"},
{14,90838,"Legion_Invasion"},
{14,90850,"d:122911"},
{12,90891,"d:126865"},
{9,90889,"Legion_Invasion"},
{8,90782,"d:124775"},
{8,90791,"Legion_Invasion"},
{5,90904,"d:122947"},
{1,90807,"d:125497"},
{1,90808,"d:126852"},
{14,90859,"d:126899"},
}},

{7018,"Legion_Praetor","Legion_Argus","Desc_Red",70300,nil,nil,{
--red
{15,90884,"d:124440"},
{14,90844,"Legion_Invasion"},
{12,90897,"d:127090"},
{9,90888,"d:127300"},
{8,90788,"d:125498"},
{8,90800,"Legion_Invasion"},
{5,90924,"d:123689"},
{1,90806,"l:"..app.GetLocalizedString("Legion_DesperateEredar")},
{1,90868,"Legion_Invasion"},
}},

{7017,"Legion_Praetor","Legion_Argus","Desc_Orange",70300,nil,nil,{
--yellow
{15,90881,"d:127118"},
{14,90853,"Legion_Invasion"},
{13,90829,"l:"..app.GetLocalizedString("Legion_TreasureHoard")},
{12,90894,"d:126866"},
{8,90869,"l:"..app.GetLocalizedString("Legion_AncientWarCache")},
{1,90803,"d:124804"},
}},

{7016,"Legion_Praetor","Legion_Argus","TWW_WepSetDesc1",70300,nil,nil,{
--purple
{15,90882,"l:"..app.GetLocalizedString("Legion_DoomseekersTreasure")},
{14,90841,"d:122838"},
{14,90856,"Legion_Invasion"},
{13,90832,"d:126889"},
{12,90900,"l:"..app.GetLocalizedString("Legion_IllGottenGains")},
{8,90779,"Legion_Invasion"},
{8,65836,"Legion_Invasion"},
{8,90872,"d:126900"},
{5,90905,"l:"..app.GetLocalizedString("Legion_VoidTingedChest")},
{1,90804,"Legion_Invasion"},
{1,90805,"Legion_Invasion"},
{1,90867,"d:126868"},
{1,90865,"l:"..app.GetLocalizedString("Legion_KrokulEmergencyCache")},
}},


{7015,"Legion_VanguardsHorde","Legion_Vanguards",nil,70000,"q:40518",nil,{{9,78548},{3,78555},{5,78554},{11,78550},{14,78553},{8,78549},{13,78557},{1,78552},{1,78558},},nil,nil,"Horde"},
{7014,"Legion_VanguardsStormwind","Legion_Vanguards",nil,70000,"q:42740",nil,{{1,80285},{1,78558},{14,80286},{13,80287},{8,80288},{11,80290},{5,80291},{3,80292},{9,80293},},nil,nil,"Alliance"},

{7013,"Legion_DreadVanquisher","Legion_Assaults",nil,70200,nil,nil,{{12,80484},{12,80483},{15,80482},{15,80480},{13,80479},{13,80478},{9,80477},{2,80474},{1,80475},{1,80473},{8,80481},{8,80476},{8,80284},},},

{7012,"Legion_SilverHandArdent","Legion_SilverHand",nil,70200,"i:141371:4:"..app.GetLocalizedString("Arsenal")..app.GetLocalizedString("Legion_ArmamentsOfTheSilverHand"),nil,{{9,82393},{12,82395},{8,89209},},nil,nil,2},
{7011,"DF_WepSetName44","Legion_SilverHand",nil,70200,"i:141371:4:"..app.GetLocalizedString("Arsenal")..app.GetLocalizedString("Legion_ArmamentsOfTheSilverHand"),nil,{{9,82925},{8,82392},{12,82926},},nil,nil,2},

{7010,"Legion_EbonBladeBloody","Legion_EbonBlade",nil,70200,"i:141372:4:"..app.GetLocalizedString("Arsenal")..app.GetLocalizedString("Legion_ArmamentsOfTheEbonBlade"),nil,{{14,82400},{2,82390},{11,82391},{14,82402},{15,82398},},nil,nil,32},
{7009,"Legion_EbonBladeIcy"   ,"Legion_EbonBlade",nil,70200,"i:141372:4:"..app.GetLocalizedString("Arsenal")..app.GetLocalizedString("Legion_ArmamentsOfTheEbonBlade"),nil,{{14,82387},{2,82404},{14,82388},{11,82396},{15,82399},},nil,nil,32},
{7008,"Legion_EbonBladeUnholy","Legion_EbonBlade",nil,70200,"i:141372:4:"..app.GetLocalizedString("Arsenal")..app.GetLocalizedString("Legion_ArmamentsOfTheEbonBlade"),nil,{{14,82401},{2,82405},{15,82389},{14,82403},{11,82397},},nil,nil,32},

{7007,"Legion_Eventide","Legion_Lustrous",nil,70300,"a:12078","i:152396:3:"..app.GetLocalizedString("Arsenal")..app.GetLocalizedString("Legion_WeaponsOfTheLightforged"),{{13,90363},{15,90361},{12,90355},{12,90354},{14,90359},{14,90358}},},
{7006,"Legion_Daybreak","Legion_Lustrous",nil,70300,"a:12078","i:152396:3:"..app.GetLocalizedString("Arsenal")..app.GetLocalizedString("Legion_WeaponsOfTheLightforged"),{{13,90362},{15,90360},{12,90352},{12,90353},{14,90357},{14,90356}},},
{7005,"Legion_Lightforged","Legion_Argus","Legion_Remix",70906,nil,nil,{{9,298874},{14,298875},{8,298876},},nil,nil,nil,7},
{7004,"Legion_Timerunner","Legion_TimerunnerLabel",nil,70904,nil,nil,{{8,291876},{14,291875},{15,291874},{3,291873},{5,90991},{12,291871},{13,291870},},nil,nil,nil,7},
{7003,"Legion_Felscorned","Legion_FelscornedLabel",nil,70905,nil,nil,{{13,298783},{15,298716},{14,298714},{14,298712},{12,298681},{11,298651},{12,298850},{14,298851}},nil,nil,nil,7},
--Legion Timwalking
{7002,"Legion_Suramar","LabelTWLegion",nil,70900,nil,nil,{{3,71154},{8,146747},{14,146748},{12,146733},{12,146734},{12,146732},{13,146750},{14,292455},}},
{7001,"Legion_Eredath","Legion_SeeingRed",nil,70900,"a:18854",nil,{{5,189983},{13,190112},{8,189982},{8,189978},{3,189977},{14,189984},{1,193036},{15,193035},}},
--21784 dagger colors
--20380 maces
--21581 maces
--21671 maces
--21574 staves
--21667 axes
};

local function comp(a,b)
  if a[1] < b[1] then return true; else return false end
end
table.sort(db,comp);

local function AddToCollection()
  local patch = select(4,GetBuildInfo());
  for i = 1, #db do
    if not (patch < 110205 and db[i][12]) then
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