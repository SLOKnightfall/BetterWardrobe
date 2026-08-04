local app = select(2,...);

local expansionID = 100;

--Name, Note, Label, classMask, patchID, sources, xpac (only for Misc.lua), requiredFact, noLongerObtainable, tradingpost, incomplete set
----classMask:    (35=Plate, 68=Mail, 3592=Leather, 400=Cloth)
local db = {
--Explorer's
{100000013,"Misc_Excavators",nil,nil,"Misc_Explorers",0,100205,{194953,194955,194956,194957,194954,},9},
{100000012,"Misc_RenownedExplorer",nil,"Misc_RecruitAFriend","Misc_Explorers",0,80370,{105946,105944,105945,105951,105949,105950,105959,{105953,105952}},7,nil,nil,1},
{100000011,"Misc_Historian",nil,nil,"Misc_Explorers",0,100205,{194948,194950,194951,194952,194949,},9},

--Holidays
--Midsummer Fire Festival
{100000010,"Misc_GrandFire",nil,nil,"Misc_MidsummerFireFestival",0,110107,{291559,291560,291561,218796},10,nil,nil,true,nil,{6,7}},
{100000009,"Misc_VestmentsofSummer",nil,nil,"Misc_MidsummerFireFestival",0,20400,{9207,16111,16110,38054},1,nil,nil,nil,nil,{6,7}},
--Noblegarden
{100000008,"Misc_Tuxedo",nil,nil,"Noblegarden",0,70205,{2633,2634,2635,2636,},6,nil,nil,nil,nil,{3,4}},
--Brewfest
{100000007,"Misc_BrewfestDress",nil,nil,"Brewfest",0,20200,{15663,15711,},1,nil,nil,nil,nil,10},
{100000006,"Misc_BrewfestRegalia",nil,nil,"Brewfest",0,20200,{15662,15665,{15664,15712,15713,15714}},1,nil,nil,nil,nil,10},
--Winter Veil
{100000015,"Misc_FineWinterVeil","Desc_Red",nil,"Misc_FineWinterVeil",0,110007,{80593,{231642,249017},231641,{231646,231644},231648,{249018,249021}},7,nil,nil,nil,nil,12},
{100000014,"Misc_FineWinterVeil","TWW_WepSetDesc10",nil,"Misc_FineWinterVeil",0,110007,{80594,{231643,249016},231640,{231647,231645},231649,{249019,249020}},7,nil,nil,nil,nil,12},
{100000005,"TWW_WepSetLabel0","TWW_WepSetDesc10",nil,"TWW_WepSetLabel0",0,70205,{8510,15751,},6,nil,nil,nil,nil,12},
{100000004,"TWW_WepSetLabel0","Desc_Red",nil,"TWW_WepSetLabel0",0,70205,{8509,15749,},6,nil,nil,nil,nil,12},
--Pilgrim's Bounty
{100000003,"Misc_PilgrimSuit",nil,nil,"PilgrimsBounty",0,60000,{22458,22464,21595,},5,nil,nil,nil,nil,11},
{100000002,"Misc_PilgrimDress",nil,nil,"PilgrimsBounty",0,60000,{21595,21594,},5,nil,nil,nil,nil,11},

--Mariachi themed outfit
{100000001,"Misc_Haliscan",nil,nil,"Misc_Mariachi",0,19999,{18356,18357,18358,2636,},1,nil,nil,nil,nil,{10,11}},
};


--/script a={80593,80587,249017,80597,80589,80595,80594,80588,249016,80598,80592,80590,80596,};for i=1,#a do print("---",a[i],"----");printTable(C_TransmogCollection.GetAllAppearanceSources(C_TransmogCollection.GetSourceInfo(a[i]).visualID)) end
--/script DressUpVisual(186436)

local function comp(a,b)
  if a[1] < b[1] then return true; else return false end
end
table.sort(db,comp);

local altAppearancesDB = {
[3634]={{218961,218962},}, --happy green murloc helm
[3635]={{218967,218968},}, --happy purple murloc helm
}

local function AddToCollection(isTransmogrifier)
  --local patch = select(4,GetBuildInfo());
  for i = 1, #db do
    --if db[i][7] <= patch then
      app.AddDBLineToTables(db[i], expansionID, isTransmogrifier);
    --end
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
app.GetExpacArmorSetNameBySetID[expansionID] = GetSetNameBySetID;

local function GetSetSourcesBySetID(setID)
  if not db[setID] then return end

  return db[setID][8];
end
app.GetExpacArmorSetSourcesBySetID[expansionID] = GetSetSourcesBySetID

local function GenerateSetInfo(setID)
  app.AddDBLineToTables(db[setID], expansionID);
end
app.GenerateSetInfo[expansionID] = GenerateSetInfo

app.ExpandedCallbacks[expansionID] = AddToCollection;
app.altAppearancesDB[expansionID] = altAppearancesDB;

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