local app = select(2,...);

local expansionID = 2;

--Name, Label, Difficulty, patchID, desc1, desc2, sources, specialSource: (1 = pvp, 2 = trading post), time: (1 = no longer obtainable, 2 = limited time set), requiredFact, 
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

local db = {
--timewalking
{2001,"Nether Vortex","Timewalking (BC)",nil,29999,nil,nil,{{14,229959},{14,229960},{13,9463},{11,229966},{12,229971},{11,229965},{9,229979},{8,229964},{7,229934},{6,229944},{5,229942},{5,229943},{5,229941},{4,229933},{3,229981},{2,229976},{1,229949},{11,230223},}},
};

local function comp(a,b)
  if a[1] < b[1] then return true; else return false end
end
table.sort(db,comp);

local function AddToCollection()  
  local patch = select(4,GetBuildInfo());
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