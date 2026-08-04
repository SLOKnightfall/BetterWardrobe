local app = select(2,...);
local WardrobeCollectionFrame = BetterWardrobeCollectionFrame

-- Keep this module independently safe if another file replaces or incompletely
-- initializes the shared color table before the weapon frame is opened.
app.colors = app.colors or {};
app.colors.GREEN_FONT_COLOR = app.colors.GREEN_FONT_COLOR or CreateColor(0.251, 0.753, 0.251);
app.colors.GREEN_FONT_COLOR_CODE = app.colors.GREEN_FONT_COLOR_CODE or "|cff40c040";
app.colors.GREEN_LIST_COLOR = app.colors.GREEN_LIST_COLOR or CreateColor(0.149, 0.580, 0.149);
app.colors.RED_FONT_COLOR = app.colors.RED_FONT_COLOR or CreateColor(0.8, 0.2, 0.08);
app.colors.YELLOW_FONT_COLOR = app.colors.YELLOW_FONT_COLOR or CreateColor(0.69, 0.62, 0.23);
app.colors.BLUE_FONT_COLOR = app.colors.BLUE_FONT_COLOR or CreateColor(0.34, 0.47, 0.84);
app.colors.BLUE_BAR_COLOR = app.colors.BLUE_BAR_COLOR or CreateColor(0.27, 0.39, 0.75);
app.colors.GRAY_BAR_COLOR = app.colors.GRAY_BAR_COLOR or CreateColor(0.2, 0.2, 0.2);

local baseListEstSize = 180;

local currToc = select(4,GetBuildInfo());
local LINK_PIPE = "\124";

--Name, (2,3,4,5)texleft, texright, textop, texbottom, (6)catID (for C_TransmogCollection.GetCategoryInfo), (7,8,9)default rotation, roll, pitch for weapon only, (10)default rotation for player,
--      (11,12)camSqDist Max(default),Min(nearer), (13,14) camDist Max,Min, (15,16) default pan y,z, (17, filled in during init) true/false if char can use weapontype
local weaponType = {
        {app.GetLocalizedString("Axe"),         0,50/256,0,50/256,               13,  3.14159,1.65332,1.17932,   --[[0.83756]]"rotMain",          9.8,3,     0,0,  0.0125,-0.0292 , nil},--, 0.83756},--
        {app.GetLocalizedString("2hAxe"),       150/256,200/256,50/256,100/256,  20,  0.02999,4.80124,1.91959,   --[[0.83756]]"rotMain",          8.3,2.5,   0,0,  -0.0125,-0.0458, nil},--, 0.83756},--
        {app.GetLocalizedString("Bow"),         50/256,100/256,0,50/256,         25,  3.19337,1.78959,1.18131,   --[[4.90207]]"rotBowOffShield",  10.75,2,   0,0,  -0.1292,-0.0583, nil},--, 4.90207},--
        {app.GetLocalizedString("Xbow"),        100/256,150/256,0,50/256,        27,  0.44089,6.27829,6.26204,   --[[0.83756]]"rotXbow",          6,1.5,     0,0,  -0.0292,-0.3500, nil},--, 0.83756},--
        {app.GetLocalizedString("Dagger"),      150/256,200/256,0,50/256,        16,  0.02999,4.80124,1.91959,   --[[0.83756]]"rotMain",          8.5,1.5,   0,0,  -0.0542,-0.0167, nil},--, 0.83756},--
        {app.GetLocalizedString("Fist"),        0,50/256,50/256,100/256,         17,  1.60859,0.49721,0,         --[[1.20734]]"rotFistGlaive",    5.5,1,     0,0,  -0.0083,-0.0333, nil},--, 1.20734},--
        {app.GetLocalizedString("Gun"),         50/256,100/256,50/256,100/256,   26,  1.51614,0.36139,0.02974,   --[[0.83756]]"rotMain",          10,2.5,    0,0,  0.0083,-0.0417 , nil},--, 0.83756},--
        {app.GetLocalizedString("Mace"),        100/256,150/256,50/256,100/256,  15,  0.03400,1.49480,1.99144,   --[[0.83756]]"rotMain",          8.5,1.5,   0,0,  0.0667,0.1458  , nil},--, 0.83756},--
        {app.GetLocalizedString("2hMace"),      100/256,150/256,150/256,200/256, 22,  PI,1.72046,1.17676,        --[[0.83756]]"rotMain",          10,2,      0,0,  -0.0542,-0.0375, nil},--, 0.83756},--
        {app.GetLocalizedString("Off-hand"),    0,50/256,150/256,200/256,        19,  1.55363,0.36428,0.03324,   --[[4.90207]]"rotBowOffShield",  3.5,1.5,   0,0,  -0.0083,-0.0042, nil},--, 4.90207},--
        {app.GetLocalizedString("Polearm"),     0,50/256,100/256,150/256,        24,  3.16159,1.56622,1.18920,   --[[0.83756]]"rotMain",          25,3,      0,0,  0.0125,-0.0875 , nil},--, 0.83756},--
        {app.GetLocalizedString("Shield"),      200/256,250/256,0,50/256,        18,  3.55800,5.08359,1.12371,   --[[4.68874]]"rotBowOffShield",  9,2,       0,0,  0.0417,-0.0708 , nil},--, 4.68874},--
        {app.GetLocalizedString("Staff"),       50/256,100/256,100/256,150/256,  23,  0,1.62987,1.99370,         --[[0.83756]]"rotMain",          19,2,      0,0,  -0.0208,0.0458 , nil},--, 0.83756},--
        {app.GetLocalizedString("Sword"),       100/256,150/256,100/256,150/256, 14,  0.02134,4.79049,1.89257,   --[[0.83756]]"rotMain",          9.2,1.5,   0,0,  -0.0167,-0.0625, nil},--, 0.83756},--
        {app.GetLocalizedString("2hSword"),     150/256,200/256,100/256,150/256, 21,  PI,4.77407,1.06717,        --[[0.83756]]"rotMain",          19,2,      0,0,  -0.0958,0.1875 , nil},--, 0.83756},--
        {app.GetLocalizedString("Wand"),        50/256,100/256,150/256,200/256,  12,  3.20711,1.68403,1.18196,   --[[0.83756]]"rotMain",          5,1,       0,0,  0.0458,-0.0458 , nil},--, 0.83756},--
        {app.GetLocalizedString("Warglaive"),   150/256,200/256,150/256,200/256, 28,  1.55045,0.49080,0.02431,   --[[1.20734]]"rotFistGlaive",    22,2,      0,0,  0.0083,0.0792  , nil},--, 1.20734},--
  }

local WeaponSetsCollectionFrame = CreateFrame("Frame", WeaponSetsCollectionFrame);
local factionNames = {}
local ExpansionCount = GetClientDisplayExpansionLevel() + 1;
app.WeaponCallbacks = {}

AllSets = nil; -- Every set gets put here, key of setID
app.wepSetsReady = false;
local setList -- Sorted sequential array of the base sets
local BaseSets -- Base Sets map with Label as the key
local VariantSets -- Variant sets map with label as the key and an array of the variant sets as the value
local TotalCounts = {}

local SET_PROGRESS_BAR_MAX_WIDTH;

local expectingTransmogInfoUpdate = false;

--------------------------------------------------
-- LOCAL CONSTANTS AND DATA ----COPIED FROM BLIZZARD CUZ THEY USED A LOCAL VARIABLE IN THE MIDDLE OF ONUPDATE WITH NOT GETTOR TO GET IT ARGHHHHH!!!
--Top of ModelFrameMixin.lua
--Pan Limits, panValue is how quickly it pans.
local ModelSettings = {
	[1] =  { panMaxLeft = -0.25,  panMaxRight = 0.25,  panMaxTop = 0.3, panMaxBottom = -0.3, panValue = 15 },--Axe
	[2] =  { panMaxLeft = -0.2,  panMaxRight = 0.2,  panMaxTop = 0.55, panMaxBottom = -0.4, panValue = 20 },--2hAxe
	[3] =  { panMaxLeft = -0.4,  panMaxRight = 0.35,  panMaxTop = 0.8, panMaxBottom = -0.8, panValue = 30 },--Bow
	[4] =  { panMaxLeft = -0.4,  panMaxRight = 0.4,  panMaxTop = 0.3, panMaxBottom = -1.0, panValue = 60 },--XBow
	[5] =  { panMaxLeft = -0.4,  panMaxRight = 0.3, panMaxTop = 0.7, panMaxBottom = -0.7, panValue = 40 },--Dagger
	[6] =  { panMaxLeft = -0.1,  panMaxRight = 0.1,  panMaxTop = 0.5, panMaxBottom = -0.6, panValue = 25 },--Fist
	[7] =  { panMaxLeft = -0.7,  panMaxRight = 0.7,  panMaxTop = 0.2, panMaxBottom = -0.8, panValue = 70 },--Gun
	[8] =  { panMaxLeft = -0.2,  panMaxRight = 0.35,  panMaxTop = 1.1, panMaxBottom = -0.5, panValue = 50 },--Mace
	[9] =  { panMaxLeft = -0.4,  panMaxRight = 0.4,  panMaxTop = 0.8, panMaxBottom = -0.8, panValue = 55 },--2hMace
	[10] = { panMaxLeft = -0.3,  panMaxRight = 0.3,  panMaxTop = 0.25, panMaxBottom = -0.4, panValue = 60 },--Off-hand
	[11] = { panMaxLeft = -0.4,  panMaxRight = 0.45,  panMaxTop = 1.5, panMaxBottom = -1.5, panValue = 80 },--Polearm
	[12] = { panMaxLeft = -0.45,  panMaxRight = 0.4,  panMaxTop = 0.6, panMaxBottom = -0.6, panValue = 70 },--Shield
	[13] = { panMaxLeft = -0.3,  panMaxRight = 0.3,  panMaxTop = 1.0, panMaxBottom = -1.1, panValue = 60 },--Staff
	[14] = { panMaxLeft = -0.3,  panMaxRight = 0.3,  panMaxTop = 0.7, panMaxBottom = -0.9, panValue = 60 },--Sword
	[15] = { panMaxLeft = -0.3,  panMaxRight = 0.3,  panMaxTop = 1.6, panMaxBottom = -0.9, panValue = 60 },--2hSword
	[16] = { panMaxLeft = -0.3,  panMaxRight = 0.3,  panMaxTop = 0.7, panMaxBottom = -0.7, panValue = 40 },--Wand
	[17] = { panMaxLeft = -1.0,  panMaxRight = 1.0,  panMaxTop = 0.7, panMaxBottom = -0.7, panValue = 50 },--Warglaive
  
	["HumanMale"] =       { panMaxLeft = -0.4, panMaxRight = 0.4, panMaxTop = 1.2, panMaxBottom = -0.3, panValue = 38, rotMain = 1.15, rotBowOffShield = 4.95, rotXbow = 0.82, rotFistGlaive = 1.32 },
	["HumanFemale"] =     { panMaxLeft = -0.3, panMaxRight = 0.3, panMaxTop = 1.2, panMaxBottom = -0.2, panValue = 45, rotMain = 1.18, rotBowOffShield = 4.84, rotXbow = 1.01, rotFistGlaive = 1.47 },
	["OrcMale"] =         { panMaxLeft = -0.7, panMaxRight = 0.8, panMaxTop = 1.2, panMaxBottom = -0.3, panValue = 30, rotMain = 0.90, rotBowOffShield = 4.72, rotXbow = 0.86, rotFistGlaive = 1.20 },
	["OrcFemale"] =       { panMaxLeft = -0.4, panMaxRight = 0.3, panMaxTop = 1.2, panMaxBottom = -0.3, panValue = 37, rotMain = 1.02, rotBowOffShield = 4.73, rotXbow = 0.83, rotFistGlaive = 1.24 },
	["DwarfMale"] =       { panMaxLeft = -0.4, panMaxRight = 0.6, panMaxTop = 0.9, panMaxBottom = -0.2, panValue = 44, rotMain = 1.10, rotBowOffShield = 4.90, rotXbow = 1.03, rotFistGlaive = 1.30 },
	["DwarfFemale"] =     { panMaxLeft = -0.3, panMaxRight = 0.3, panMaxTop = 0.9, panMaxBottom = -0.2, panValue = 47, rotMain = 1.12, rotBowOffShield = 4.80, rotXbow = 1.06, rotFistGlaive = 1.45 },
	["NightElfMale"] =    { panMaxLeft = -0.5, panMaxRight = 0.5, panMaxTop = 1.5, panMaxBottom = -0.4, panValue = 30, rotMain = 1.27, rotBowOffShield = 4.84, rotXbow = 1.12, rotFistGlaive = 1.52 },
	["NightElfFemale"] =  { panMaxLeft = -0.4, panMaxRight = 0.4, panMaxTop = 1.4, panMaxBottom = -0.4, panValue = 33, rotMain = 1.38, rotBowOffShield = 4.82, rotXbow = 1.23, rotFistGlaive = 1.53 },
	["ScourgeMale"] =     { panMaxLeft = -0.4, panMaxRight = 0.4, panMaxTop = 1.1, panMaxBottom = -0.3, panValue = 35, rotMain = 1.47, rotBowOffShield = 5.34, rotXbow = 1.33, rotFistGlaive = 1.73 },
	["ScourgeFemale"] =   { panMaxLeft = -0.3, panMaxRight = 0.4, panMaxTop = 1.1, panMaxBottom = -0.3, panValue = 36, rotMain = 1.15, rotBowOffShield = 4.92, rotXbow = 1.07, rotFistGlaive = 1.42 },
	["TaurenMale"] =      { panMaxLeft = -0.7, panMaxRight = 0.9, panMaxTop = 1.1, panMaxBottom = -0.5, panValue = 31, rotMain = 1.01, rotBowOffShield = 4.98, rotXbow = 0.98, rotFistGlaive = 1.30 },
	["TaurenFemale"] =    { panMaxLeft = -0.5, panMaxRight = 0.6, panMaxTop = 1.3, panMaxBottom = -0.4, panValue = 32, rotMain = 1.00, rotBowOffShield = 5.05, rotXbow = 0.85, rotFistGlaive = 1.31 },
	["GnomeMale"] =       { panMaxLeft = -0.3, panMaxRight = 0.3, panMaxTop = 0.5, panMaxBottom = -0.2, panValue = 52, rotMain = 1.18, rotBowOffShield = 4.82, rotXbow = 0.99, rotFistGlaive = 1.41 },
	["GnomeFemale"] =     { panMaxLeft = -0.3, panMaxRight = 0.3, panMaxTop = 0.5, panMaxBottom = -0.2, panValue = 60, rotMain = 1.02, rotBowOffShield = 4.89, rotXbow = 0.85, rotFistGlaive = 1.35 },
	["TrollMale"] =       { panMaxLeft = -0.5, panMaxRight = 0.6, panMaxTop = 1.3, panMaxBottom = -0.4, panValue = 27, rotMain = 1.05, rotBowOffShield = 4.90, rotXbow = 0.94, rotFistGlaive = 1.37 },
	["TrollFemale"] =     { panMaxLeft = -0.4, panMaxRight = 0.4, panMaxTop = 1.5, panMaxBottom = -0.4, panValue = 31, rotMain = 1.08, rotBowOffShield = 4.90, rotXbow = 0.95, rotFistGlaive = 1.38 },
	["GoblinMale"] =      { panMaxLeft = -0.3, panMaxRight = 0.4, panMaxTop = 0.7, panMaxBottom = -0.2, panValue = 43, rotMain = 1.42, rotBowOffShield = 4.80, rotXbow = 1.27, rotFistGlaive = 1.59 },
	["GoblinFemale"] =    { panMaxLeft = -0.3, panMaxRight = 0.3, panMaxTop = 0.7, panMaxBottom = -0.3, panValue = 43, rotMain = 1.15, rotBowOffShield = 5.05, rotXbow = 0.97, rotFistGlaive = 1.52 },
	["BloodElfMale"] =    { panMaxLeft = -0.5, panMaxRight = 0.4, panMaxTop = 1.3, panMaxBottom = -0.3, panValue = 36, rotMain = 1.39, rotBowOffShield = 5.05, rotXbow = 1.29, rotFistGlaive = 1.61 },
	["BloodElfFemale"] =  { panMaxLeft = -0.3, panMaxRight = 0.2, panMaxTop = 1.2, panMaxBottom = -0.3, panValue = 38, rotMain = 1.05, rotBowOffShield = 4.66, rotXbow = 0.82, rotFistGlaive = 1.30 },
	["DraeneiMale"] =     { panMaxLeft = -0.6, panMaxRight = 0.6, panMaxTop = 1.4, panMaxBottom = -0.4, panValue = 28, rotMain = 1.01, rotBowOffShield = 4.83, rotXbow = 0.97, rotFistGlaive = 1.27 },
	["DraeneiFemale"] =   { panMaxLeft = -0.3, panMaxRight = 0.3, panMaxTop = 1.4, panMaxBottom = -0.3, panValue = 31, rotMain = 1.22, rotBowOffShield = 5.03, rotXbow = 1.07, rotFistGlaive = 1.52 },
	["WorgenMale"] =      { panMaxLeft = -0.6, panMaxRight = 0.8, panMaxTop = 1.2, panMaxBottom = -0.4, panValue = 25, rotMain = 1.14, rotBowOffShield = 4.82, rotXbow = 1.10, rotFistGlaive = 1.34 },
	["WorgenMaleAlt"] =   { panMaxLeft = -0.4, panMaxRight = 0.4, panMaxTop = 1.3, panMaxBottom = -0.3, panValue = 37, rotMain = 1.10, rotBowOffShield = 4.88, rotXbow = 0.85, rotFistGlaive = 1.34 },
	["WorgenFemale"] =    { panMaxLeft = -0.4, panMaxRight = 0.6, panMaxTop = 1.4, panMaxBottom = -0.4, panValue = 25, rotMain = 1.67, rotBowOffShield = 5.00, rotXbow = 1.46, rotFistGlaive = 1.77 },
	["WorgenFemaleAlt"] = { panMaxLeft = -0.3, panMaxRight = 0.3, panMaxTop = 1.2, panMaxBottom = -0.2, panValue = 45, rotMain = 1.12, rotBowOffShield = 4.85, rotXbow = 1.14, rotFistGlaive = 1.45 },
	["PandarenMale"] =    { panMaxLeft = -0.7, panMaxRight = 0.9, panMaxTop = 1.1, panMaxBottom = -0.5, panValue = 31, rotMain = 1.03, rotBowOffShield = 4.82, rotXbow = 0.97, rotFistGlaive = 1.32 },
	["PandarenFemale"] =  { panMaxLeft = -0.5, panMaxRight = 0.6, panMaxTop = 1.3, panMaxBottom = -0.4, panValue = 32, rotMain = 1.12, rotBowOffShield = 5.18, rotXbow = 0.95, rotFistGlaive = 1.52 },	
	["NightborneMale"] =  { panMaxLeft = -0.5, panMaxRight = 0.5, panMaxTop = 1.5, panMaxBottom = -0.4, panValue = 30, rotMain = 1.18, rotBowOffShield = 4.82, rotXbow = 1.04, rotFistGlaive = 1.44 },
	["NightborneFemale"] ={ panMaxLeft = -0.4, panMaxRight = 0.4, panMaxTop = 1.4, panMaxBottom = -0.4, panValue = 33, rotMain = 1.55, rotBowOffShield = 4.80, rotXbow = 1.42, rotFistGlaive = 1.85 },
	["HighmountainTaurenMale"] =   { panMaxLeft = -0.7, panMaxRight = 0.9, panMaxTop = 1.1, panMaxBottom = -0.5, panValue = 31, rotMain = 1.05, rotBowOffShield = 4.86, rotXbow = 0.95, rotFistGlaive = 1.32 },
	["HighmountainTaurenFemale"] = { panMaxLeft = -0.5, panMaxRight = 0.6, panMaxTop = 1.3, panMaxBottom = -0.4, panValue = 32, rotMain = 1.02, rotBowOffShield = 5.00, rotXbow = 0.88, rotFistGlaive = 1.27 },
	["VoidElfMale"] =     { panMaxLeft = -0.5, panMaxRight = 0.4, panMaxTop = 1.3, panMaxBottom = -0.3, panValue = 36, rotMain = 1.42, rotBowOffShield = 5.05, rotXbow = 1.30, rotFistGlaive = 1.60 },
	["VoidElfFemale"] =   { panMaxLeft = -0.3, panMaxRight = 0.2, panMaxTop = 1.2, panMaxBottom = -0.3, panValue = 38, rotMain = 0.95, rotBowOffShield = 4.80, rotXbow = 1.07, rotFistGlaive = 1.47 },
	["LightforgedDraeneiMale"] =   { panMaxLeft = -0.6, panMaxRight = 0.6, panMaxTop = 1.4, panMaxBottom = -0.4, panValue = 28, rotMain = 1.10, rotBowOffShield = 4.78, rotXbow = 0.94, rotFistGlaive = 1.27 },
	["LightforgedDraeneiFemale"] = { panMaxLeft = -0.3, panMaxRight = 0.3, panMaxTop = 1.4, panMaxBottom = -0.3, panValue = 31, rotMain = 1.27, rotBowOffShield = 4.93, rotXbow = 1.12, rotFistGlaive = 1.49 },
	["MagharOrcMale"] =   { panMaxLeft = -0.7, panMaxRight = 0.8, panMaxTop = 1.2, panMaxBottom = -0.3, panValue = 30, rotMain = 0.97, rotBowOffShield = 4.53, rotXbow = 0.87, rotFistGlaive = 1.20 },
	["MagharOrcFemale"] = { panMaxLeft = -0.4, panMaxRight = 0.3, panMaxTop = 1.2, panMaxBottom = -0.3, panValue = 37, rotMain = 1.04, rotBowOffShield = 4.74, rotXbow = 0.80, rotFistGlaive = 1.20 },
	["DarkIronDwarfMale"] =   { panMaxLeft = -0.4, panMaxRight = 0.6, panMaxTop = 0.9, panMaxBottom = -0.2, panValue = 44, rotMain = 0.96, rotBowOffShield = 4.85, rotXbow = 0.94, rotFistGlaive = 1.28 },
	["DarkIronDwarfFemale"] = { panMaxLeft = -0.3, panMaxRight = 0.3, panMaxTop = 0.9, panMaxBottom = -0.2, panValue = 47, rotMain = 1.25, rotBowOffShield = 4.70, rotXbow = 1.01, rotFistGlaive = 1.53 },
	["KulTiranMale"] =    { panMaxLeft = -0.6, panMaxRight = 0.7, panMaxTop = 1.5, panMaxBottom = -0.6, panValue = 38, rotMain = 1.39, rotBowOffShield = 5.23, rotXbow = 1.42, rotFistGlaive = 1.62 },
	["KulTiranFemale"] =  { panMaxLeft = -0.6, panMaxRight = 0.7, panMaxTop = 1.5, panMaxBottom = -0.6, panValue = 38, rotMain = 1.15, rotBowOffShield = 4.90, rotXbow = 1.21, rotFistGlaive = 1.44 },
	["ZandalariTrollMale"] =  { panMaxLeft = -0.5, panMaxRight = 0.6, panMaxTop = 1.3, panMaxBottom = -0.4, panValue = 27, rotMain = 1.42, rotBowOffShield = 5.22, rotXbow = 1.36, rotFistGlaive = 1.67 },
	["ZandalariTrollFemale"] ={ panMaxLeft = -0.4, panMaxRight = 0.5, panMaxTop = 1.5, panMaxBottom = -0.4, panValue = 31, rotMain = 1.60, rotBowOffShield = 4.91, rotXbow = 5.11, rotFistGlaive = 1.90 },
	["VulperaMale"] =     { panMaxLeft = -0.3, panMaxRight = 0.4, panMaxTop = 0.7, panMaxBottom = -0.2, panValue = 43, rotMain = 1.21, rotBowOffShield = 5.10, rotXbow = 1.11, rotFistGlaive = 1.42 },
	["VulperaFemale"] =   { panMaxLeft = -0.3, panMaxRight = 0.3, panMaxTop = 0.7, panMaxBottom = -0.3, panValue = 43, rotMain = 1.25, rotBowOffShield = 5.02, rotXbow = 1.04, rotFistGlaive = 1.50 },
	["MechagnomeMale"] =  { panMaxLeft = -0.3, panMaxRight = 0.3, panMaxTop = 0.5, panMaxBottom = -0.2, panValue = 52, rotMain = 1.10, rotBowOffShield = 4.85, rotXbow = 0.91, rotFistGlaive = 1.42 },
	["MechagnomeFemale"] ={ panMaxLeft = -0.3, panMaxRight = 0.3, panMaxTop = 0.5, panMaxBottom = -0.2, panValue = 60, rotMain = 0.95, rotBowOffShield = 4.90, rotXbow = 0.83, rotFistGlaive = 1.42 },
	["DracthyrMale"] =    { panMaxLeft = 0, panMaxRight = 0, panMaxTop = 0, panMaxBottom = 0, panValue = 52, rotMain = 0.98, rotBowOffShield = 5.14, rotXbow = 0.78, rotFistGlaive = 1.07 },
	["DracthyrFemale"] =  { panMaxLeft = -0.3, panMaxRight = 0.3, panMaxTop = 0.5, panMaxBottom = -0.2, panValue = 60, rotMain = 0.87, rotBowOffShield = 4.96, rotXbow = 0.93, rotFistGlaive = 1.15 },
	["DracthyrMaleAlt"] = { panMaxLeft = -0.5, panMaxRight = 0.4, panMaxTop = 1.3, panMaxBottom = -0.3, panValue = 36, rotMain = 1.40, rotBowOffShield = 4.92, rotXbow = 1.43, rotFistGlaive = 1.65 },
	["DracthyrFemaleAlt"]={ panMaxLeft = -0.3, panMaxRight = 0.3, panMaxTop = 1.2, panMaxBottom = -0.2, panValue = 45, rotMain = 1.17, rotBowOffShield = 4.68, rotXbow = 1.06, rotFistGlaive = 1.47 },
	["EarthenDwarfMale"] =       { panMaxLeft = -0.4, panMaxRight = 0.6, panMaxTop = 0.9, panMaxBottom = -0.2, panValue = 44, rotMain = 1.10, rotBowOffShield = 4.90, rotXbow = 1.03, rotFistGlaive = 1.30 },
	["EarthenDwarfFemale"] =     { panMaxLeft = -0.3, panMaxRight = 0.3, panMaxTop = 0.9, panMaxBottom = -0.2, panValue = 47, rotMain = 1.12, rotBowOffShield = 4.80, rotXbow = 1.06, rotFistGlaive = 1.45 },
}
local _,playerRaceSex = UnitRace("player");
if ( UnitSex("player") == 2 ) then
  playerRaceSex = playerRaceSex.."Male";
else
  playerRaceSex = playerRaceSex.."Female";
end
--------------------------------------------------

----
-- Gettors
----
local function GetSetByID(setID)
  return AllSets[setID];
end

local function GetSetSources(setID)
  return AllSets[setID].sources;
end

local function GetSetSourceCounts(setID, givenSources)
  if not givenSources then givenSources = AllSets[setID].sources; end
  local numSourcesCollected, numSourcesTotal, allUsableCollected = 0, #givenSources, true;
  for i=1,numSourcesTotal do
    if givenSources[i][3] then
      numSourcesCollected = numSourcesCollected + 1;
    elseif weaponType[givenSources[i][1]][17] then
      allUsableCollected = false;
    end
  end
  return numSourcesCollected, numSourcesTotal, allUsableCollected;
end
app.GetWepSetCount = GetSetSourceCounts;

local function GetSetData(baseSetID, forceUpdate)
  if not forceUpdate and TotalCounts[baseSetID] then
    return TotalCounts[baseSetID];
  else
    local bestCompleted = 0;
    TotalCounts[baseSetID] = {numSets = #VariantSets[AllSets[baseSetID].label]}
    local topPercent, topCollected, topTotal, numCompleted = 0, 0, 0, 0;
    for i = 1, #VariantSets[AllSets[baseSetID].label] do
      local col, tot = GetSetSourceCounts(VariantSets[AllSets[baseSetID].label][i].setID);
      TotalCounts[baseSetID][i] = col / tot;
      
      if bestCompleted < 2 then
        if col == tot then
          bestCompleted = 2;
        elseif col > 0 then
          bestCompleted = 1;
        end
      end
    end
    TotalCounts[baseSetID].bestCompleted = bestCompleted;
    --for _, set in pairs(VariantSets[AllSets[baseSetID].label]) do
    --  local col, tot = GetSetSourceCounts(set.setID);
    --  local div = col / tot;
    --  if div > topPercent then
    --    topPercent = div;
    --    topCollected = col;
    --    topTotal = tot;
    --  elseif topTotal == 0 then
    --    topTotal = tot;
    --  end
    --  if col == tot then
    --    numCompleted = numCompleted + 1;
    --  end
    --end
    --TotalCounts[baseSetID] = {topCollected = topCollected, topTotal = topTotal, topPercent = topPercent, numSets = #VariantSets[AllSets[baseSetID].label], numCompleted = numCompleted};
    return TotalCounts[baseSetID];
  end
end

local function GetBaseSetID(setID)
  if BaseSets[AllSets[setID].label] then
    return BaseSets[AllSets[setID].label].setID;
  else
    return setID;
  end
end

local function GetBaseSetByID(setID)
  if BaseSets[AllSets[setID].label] then
    return BaseSets[AllSets[setID].label];
  else
    return AllSets[setID];
  end
end

--Get icon for the set.
local function GetIconForSet(setID)
	return GetBaseSetByID(setID).icon;
end

local function IsBaseSetNew(setID)
  for _, set in pairs(VariantSets[AllSets[setID].label]) do
    for i=1,#set.sources do
      if WeaponSetsCollectionFrame.NewVisualIDs[set.sources[i][4]] then
        return true;
      end
    end
  end
  return false;
end

local function GetCurrentSet()
  return GetSetByID(WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet);
end

--1 setID, 2 setSources, 3 appID, 4 sourceID
local setsToLinkCheck = {}
local setsToLinkCheckSingleton;
----
--
----
local function CheckCompletionAndLink()
  for i=1,#setsToLinkCheck do
    local linkSet = true;
    for j=1,#setsToLinkCheck[i][2] do
      local visID;
      if app.wepSetsReady then
        visID = setsToLinkCheck[i][2][j][4]
      else
        visID = app.AppID(setsToLinkCheck[i][2][j][2])
      end
      if visID == setsToLinkCheck[i][3] then
        local appSources = C_TransmogCollection.GetAllAppearanceSources(visID);
        
        local thisSourceCollected = false;
        for k=1,#appSources do
          if appSources[k] ~= setsToLinkCheck[i][2][j][2] then
            local sourceInfo = C_TransmogCollection.GetSourceInfo(appSources[k]);
            if sourceInfo.isCollected then
              thisSourceCollected = true;
              break;
            end
          end
        end
        if thisSourceCollected then linkSet = false; break; end
      else
        local isCollected = false;
        if app.wepSetsReady then
          isCollected = setsToLinkCheck[i][2][j][3]
        else
          local appSources = C_TransmogCollection.GetAllAppearanceSources(visID);
          if appSources and #appSources > 0 then
            for k=1,#appSources do
              local sourceInfo = C_TransmogCollection.GetSourceInfo(appSources[k]);
              if sourceInfo and sourceInfo.isCollected then
                isCollected = true
                break;
              end
            end
          end
        end
        if not isCollected then
          linkSet = false;
          break;
        end
      end
    end
    if linkSet then
      local label, name = app.GetExSetInfoFromSetID(setsToLinkCheck[i][1], true);
      
      local setLink = LINK_PIPE..app.colors.TRANSMOG_PINK..LINK_PIPE.."Haddon:ExS:"..setsToLinkCheck[i][1]..LINK_PIPE.."h["..label.." => "..name.."]"..LINK_PIPE.."h"..LINK_PIPE.."r";
      print(LINK_PIPE..app.colors.SYSTEM_YELLOW..app.GetLocalizedString("SetCompleteMsg")..setLink.."."..LINK_PIPE.."r");
    end
  end
end

----
--
----
local function FindAndSetCollected(appID, isCollected, sourceID, setIDs, isArmor)
  if not setIDs then
    setIDs, isArmor = app.FindSetIDByAppID(appID);
  end
  
  if not isArmor and setIDs then
    for i=1,#setIDs do
      local setSources = GetSetSources(setIDs[i]);
      for j=1,#setSources do
        if setSources[j][4] == appID then
          setSources[j][3] = isCollected;
          
          GetSetData(GetBaseSetID(setIDs[i]), true);
          for k=1,#WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons do
            if WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[k]:IsShown() and WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[k].setID == setIDs[i] then
              WeaponSetsCollectionFrame.SetButtonData(WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[k], GetSetByID(WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[k].setID));
            end
          end
          
          if setIDs[i] == WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet then
            WeaponSetsCollectionFrame.SelectSet(setIDs[i], true);
          end
          
          break;
        end
      end
      --if the update is that it was collected, check if we need to link the completion
      if isCollected then
        local addSet = true;
        for j=1,#setsToLinkCheck do
          if setsToLinkCheck[j][1] == setIDs[i] then
            addSet = false;
            break;
          end
        end
        if addSet then
          tinsert(setsToLinkCheck, {setIDs[i], setSources, appID, sourceID});
        end
        
        --local linkSet = true;
        --for j=1,#setSources do
        --  if setSources[j][4] == appID then
        --    local appSources = C_TransmogCollection.GetAllAppearanceSources(appID);
        --    
        --    local thisSourceCollected = false;
        --    for k=1,#appSources do
        --      if appSources[k] ~= sourceID then
        --        local sourceInfo = C_TransmogCollection.GetSourceInfo(appSources[k]);
        --        if sourceInfo.isCollected then
        --          thisSourceCollected = true;
        --          break;
        --        end
        --      end
        --    end
        --    if thisSourceCollected then linkSet = false; break; end
        --  else
        --    if not setSources[j][3] then
        --      linkSet = false;
        --      break;
        --    end
        --  end
        --end
        --if linkSet then
        --  local label, name = app.GetExSetInfoFromSetID(setIDs[i], true);
        --  
        --  local setLink = LINK_PIPE..colors.TRANSMOG_PINK..LINK_PIPE.."Haddon:ExS:"..setIDs[i]..LINK_PIPE.."h["..label.." => "..name.."]"..LINK_PIPE.."h"..LINK_PIPE.."r";
        --  print(LINK_PIPE..colors.SYSTEM_YELLOW..app.GetLocalizedString("SetCompleteMsg")..setLink.."."..LINK_PIPE.."r");
        --end
      end
    end
    if not setsToLinkCheckSingleton then
      setsToLinkCheckSingleton = C_Timer.NewTimer(0, CheckCompletionAndLink);
    end
  end
end

----
--Handle Weapon Link
----
local function HandleWeaponSetLink(setID)
  ToggleCollectionsJournal(5)
  WardrobeCollectionFrame = BetterWardrobeCollectionFrame or WardrobeCollectionFrame
  if WardrobeCollectionFrame and WardrobeCollectionFrame.selectedCollectionTab ~= 5 then
    WardrobeCollectionFrame:SetTab(5)
  end
  
  WeaponSetsCollectionFrame.SelectSet(setID);
end

----
--
----
local function CheckAndLinkWhileUnloaded(appID, sourceID)
  local setIDs, isArmor = app.FindSetIDByAppID(appID);
  if isArmor or not setIDs then return; end
  
  for i=1,#setIDs do
    local addSet = true;
    for j=1,#setsToLinkCheck do
      if setsToLinkCheck[j][1] == setIDs[i] then
        addSet = false;
        break;
      end
    end
    if addSet then
      local sources = app.GetExSetSourcesFromSetID(setIDs[i], true);
    
      tinsert(setsToLinkCheck, {setIDs[i], sources, appID, sourceID})
    end
    --local linkSet = true;
    --for i=1,#sources do
    --  local listAppID = app.AppID(sources[i][2]);
    --  local appSources = C_TransmogCollection.GetAllAppearanceSources(listAppID);
    --  if appID == listAppID then
    --    local thisSourceCollected = false;
    --    for k=1,#appSources do
    --      if appSources[k] ~= sourceID then
    --        local sourceInfo = C_TransmogCollection.GetSourceInfo(appSources[k]);
    --        if sourceInfo.isCollected then
    --          thisSourceCollected = true;
    --          break;
    --        end
    --      end
    --    end
    --    if thisSourceCollected then linkSet = false; break; end
    --  else
    --    local thisSourceCollected = false;
    --    for i=1,#appSources do
    --      if C_TransmogCollection.GetSourceInfo(appSources[i]).isCollected then
    --        thisSourceCollected = true;
    --        break;
    --      end
    --    end
    --    
    --    if not thisSourceCollected then
    --      linkSet = false;
    --      break;
    --    end
    --  end
    --end
    --if linkSet then
    --  local label, name = app.GetExSetInfoFromSetID(setIDs[j], true);
    --  
    --  local setLink = LINK_PIPE..colors.TRANSMOG_PINK..LINK_PIPE.."Haddon:ExS:"..setIDs[j]..LINK_PIPE.."h["..label.." => "..name.."]"..LINK_PIPE.."h"..LINK_PIPE.."r";
    --  print(LINK_PIPE..colors.SYSTEM_YELLOW..app.GetLocalizedString("SetCompleteMsg")..setLink.."."..LINK_PIPE.."r");
    --end
  end
  if not setsToLinkCheckSingleton then
    setsToLinkCheckSingleton = C_Timer.NewTimer(0, CheckCompletionAndLink);
  end
end

----
-- Fill the maps
----
--Helper function for checking if the search value is related to the given set.
local function SearchValueFound(set, searchValue)
  local start, _ = string.find(string.lower(set.name), searchValue);
  if start ~= nil then return true; end
  
  if set.label then
    start, _ = string.find(string.lower(set.label), searchValue);
    if start ~= nil then return true; end
  end
  
  return false;
end

--Check if the Set should be used.
local function UseSet(data, isSearch)
  if ExS_Settings.showOnlyRaidSets and not data.isRaid then
    return false;
  end
  if ExS_Weapon_HiddenSets[data.setID] and not ExS_Settings.showHiddenSets then
    return false;
  end
  if data.isPvP and not C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVP) then
    return false;
  end
  if not data.isPvP and not C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVE, value) then
    return false;
  end
  if data.requiredFaction == factionNames.opposingFaction and not ExS_Settings.displayOtherFaction then
    return false;
  end
  if data.noLongerObtainable and ExS_Settings.hideNoLongerObtainable then
    return false;
  end
  
  local numCollected, numTotal = GetSetSourceCounts(data.setID, data.sources);
  if numCollected == numTotal then
    if not C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_COLLECTED) then
      return false;
    end
  elseif not C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_UNCOLLECTED) then
    return false;
  end

  if not ExS_Settings.weaponExpansionToggles[data.expansionID] then
    return false;
  end
  
  if isSearch then
    local searchText = string.lower(WeaponSetsCollectionFrame.LeftFrame.SearchBox:GetText());
    if searchText ~= "" then
      if not SearchValueFound(data, searchText) then
        return false;
      end
    end
  end
  
  return true;
end

local function SortSetList()
  local comp = function(a,b)
      if a.favoriteSetID and not b.favoriteSetID then
        return true;
      end
      if b.favoriteSetID and not a.favoriteSetID then
        return false;
      end
      if a.highestPatchID ~= b.highestPatchID then
        return a.highestPatchID > b.highestPatchID;
      end
      --if a.sortOrder and b.sortOrder and a.sortOrder ~= b.sortOrder then
      --  return a.sortOrder < b.sortOrder;
      --end
      return a.setID > b.setID;
    end
  table.sort(setList, comp);
end

local function FillWeaponSetMaps(forceFill, isSearch)
  if not AllSets then
    AllSets = table.create(baseListEstSize*3)
    for i=1,ExpansionCount do
      if app.WeaponCallbacks[i] then
        app.WeaponCallbacks[i]();
      end
    end
    app.wepSetsReady = true;
  end
  
  if not setList or forceFill then
    setList = table.create(baseListEstSize);
    BaseSets = table.create(baseListEstSize);
    VariantSets = table.create(baseListEstSize);
    RunNextFrame(function() collectgarbage() end);
    
    for _,set in pairs(AllSets) do
      if UseSet(set, isSearch) then
        set.favorite = ExS_Weapon_Favorites[set.setID];
        if set.favorite then
          set.favoriteSetID = set.setID;
        end
        if BaseSets[set.label] then
          --if BaseSets[set.label].setID < set.setID then
          --  if not set.favorite and BaseSets[set.label].favoriteSetID then
          --    set.favoriteSetID = BaseSets[set.label].favoriteSetID;
          --    BaseSets[set.label].favoriteSetID = nil;
          --  end
          --  BaseSets[set.label] = set;
          --end
          
          if set.favorite and not BaseSets[set.label].favoriteSetID then
            BaseSets[set.label].favoriteSetID = set.setID;
          end
          if set.patchID > BaseSets[set.label].highestPatchID then
            BaseSets[set.label].highestPatchID = set.patchID;
          end
        else
          BaseSets[set.label] = set;
          BaseSets[set.label].highestPatchID = BaseSets[set.label].patchID;
          VariantSets[set.label] = {}
          if set.favorite and not BaseSets[set.label].favoriteSetID then
            BaseSets[set.label].favoriteSetID = set.setID;
          end
        end
        tinsert(VariantSets[set.label], set);
      end
    end
    
    --setList = {}
    for _,set in pairs(BaseSets) do
      tinsert(setList, set);
    end
    SortSetList();
    
    WeaponSetsCollectionFrame.UpdateProgressBar();
    
    local scrollMax = max((#setList - #WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons) + 1, 1);
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:SetMinMaxValues(1, scrollMax);
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.range = scrollMax;
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.scrollUp:Disable();
    if scrollMax > 1 then
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.scrollDown:Enable();
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.thumbTexture:Show();
    else
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.scrollDown:Disable();
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.thumbTexture:Hide();
    end
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame:SetVerticalScroll(1/scrollMax);
    
    WeaponSetsCollectionFrame.ScrollToOffset(1, false, true);
    
    local hiddenCount = 0;
    for a,b in pairs(ExS_Weapon_HiddenSets) do
      hiddenCount = hiddenCount + 1;
    end
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Text:SetText(hiddenCount);
  end
  
  if app.devMode then
    print("Weapon Counts")
    local i = 0;
    for a,b in pairs(AllSets) do i = i + 1; end
    print("AllSets: ",i)
    i = 0;
    for a,b in pairs(setList) do i = i + 1; end
    print("setList: ",i)
    i = 0;
    for a,b in pairs(BaseSets) do i = i + 1; end
    print("BaseSets: ",i)
    i = 0;
    for a,b in pairs(VariantSets) do i = i + 1; end
    print("VariantSets: ",i)
  end
end

local function AddWeaponSetToTables(data)
  AllSets[data.setID] = data;
end
app.AddWeaponSetToTables = AddWeaponSetToTables;

----
-- Scroll Frame
----
--Fills in the buttons shown in the list on the left side of the sets window.
local function SetButtonData(button, set)
  if not button or not set or not set.setID then
    if button then button:Hide(); end
    return;
  end
  local setInfo = GetSetData(set.setID);
  if not setInfo then
    button:Hide();
    return;
  end
  
  button.setID = set.setID;
  button:Show();
  
  --Sets the name for the button and its color based on completion.
  local color;
  if setInfo.bestCompleted == 2 then
    color = app.colors.BLUE_FONT_COLOR or BLUE_FONT_COLOR or NORMAL_FONT_COLOR;
  elseif setInfo.bestCompleted == 1 then
    color = app.colors.GREEN_LIST_COLOR or GREEN_FONT_COLOR or NORMAL_FONT_COLOR;
  else
    color = GRAY_FONT_COLOR or NORMAL_FONT_COLOR;
  end
  button.Name:SetTextColor(color.r, color.g, color.b);
  
  if setInfo.numSets > 1 then
    button.NumSets:SetShown(true);
    button.NumSets.label:SetText(setInfo.numSets);
  else
    button.NumSets:SetShown(false);
  end
  
  local setIsShown = set.setID == GetBaseSetID(WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet);
  
  --Sets the sub-name on the button.
  if ExS_Settings.hideListDescription then
    button.Label:SetShown(false);
  elseif ExS_Settings.flipNameAndLabel then
    button.Name:SetText(set.label);
    button.Label:SetShown(true);
    button.Label:SetText(set.name);
  else
    button.Name:SetText(set.name);
    button.Label:SetShown(true);
    button.Label:SetText(set.label);
  end
  
  button.IconFrame:Show();
  button.IconFrame:SetIconTexture(GetIconForSet(set.setID));
  button.IconFrame:SetIconCoverShown(not setIsShown);
  button.IconFrame:SetIconDesaturation((setInfo.bestCompleted == 0) and 1 or 0);
  button.IconFrame:SetFavoriteIconShown(set.favoriteSetID);

  button.Remix:SetShown(set.isRemix == 5);
  button.LegionRemix:SetShown(set.isRemix == 7);
  button.TradingPost:SetShown(set.tp);
  
  --Setting if special apperance needed for newness or selectedness.
  
  button.New:SetShown(IsBaseSetNew(set.setID));
  button.SelectedTexture:SetShown(setIsShown);
  
  
  local setProgWidth = SET_PROGRESS_BAR_MAX_WIDTH / (1.1 * setInfo.numSets - 0.1);
  local setProgSpacer = setProgWidth * 0.1;
  
  for i = 1, setInfo.numSets do
    if not button.ProgressBars[i] then
      button.ProgressBars[i] = button:CreateTexture(nil, "ARTWORK");
      button.ProgressBars[i]:SetDrawLayer("ARTWORK", -1);
      button.ProgressBars[i]:SetHeight(2);
    end
    if setInfo.numSets == 1 then
      button.ProgressBars[i]:SetWidth(SET_PROGRESS_BAR_MAX_WIDTH);
    else
      button.ProgressBars[i]:SetWidth(setProgWidth);
    end
    --need to set point here as the Spacer will change from set to set.
    if i ~= 1 then
      button.ProgressBars[i]:SetPoint("LEFT", button.ProgressBars[i-1], "RIGHT", setProgSpacer, 0);
    end
    button.ProgressBars[i]:Show();
    
    --if setInfo[i] == 1 then
    --  button.ProgressBars[i]:SetColorTexture(app.colors.BLUE_BAR_COLOR.r,app.colors.BLUE_BAR_COLOR.g,app.colors.BLUE_BAR_COLOR.b);
    --  --button.ProgressBars[i]:SetColorTexture(app.colors.BLUE_FONT_COLOR.r,app.colors.BLUE_FONT_COLOR.g,app.colors.BLUE_FONT_COLOR.b);
    --else
      local color = app.MergeColors(setInfo[i] or 0);
      button.ProgressBars[i]:SetColorTexture(color.r,color.g,color.b);
    --end
  end
  
  if setInfo.numSets < #button.ProgressBars then
    for i = setInfo.numSets+1, #button.ProgressBars do
      button.ProgressBars[i]:Hide();
    end
  end
  
  ----Sets the Progress Bar and Color for set completion along bottom of the button.
  --if setInfo.topCollected == 0 then
  --  button.ProgressBar:Hide();
  --else
  --  button.ProgressBar:Show();
  --  if setInfo.numCompleted > 0 then
  --    button.ProgressBar:SetWidth(SET_PROGRESS_BAR_MAX_WIDTH * setInfo.numCompleted / setInfo.numSets);
  --    button.ProgressBar:SetColorTexture(color.r, color.g, color.b);
  --  else
  --    button.ProgressBar:SetWidth(SET_PROGRESS_BAR_MAX_WIDTH * setInfo.topCollected / setInfo.topTotal);
  --    button.ProgressBar:SetColorTexture(app.colors.YELLOW_FONT_COLOR.r, app.colors.YELLOW_FONT_COLOR.g, app.colors.YELLOW_FONT_COLOR.b);
  --  end
  --end
end
WeaponSetsCollectionFrame.SetButtonData = SetButtonData;

local function UpdateExtraButtons()
  local leftMostButton = nil;
  
  local buttons = {
      WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton,
      WeaponSetsCollectionFrame.RightFrame.HiddenSetButton,
      WeaponSetsCollectionFrame.RightFrame.AHButton
  }
  local buttonTogglesIndex = {
      3,
      4,
      1
  }
  
  for i=1,#buttons do
    local ind = buttonTogglesIndex[i];
    buttons[i]:SetShown(ExS_Settings.extraButtonToggles[ind]);
    if ExS_Settings.extraButtonToggles[ind] then
      if leftMostButton then
        buttons[i]:SetPoint("LEFT", leftMostButton, "RIGHT", 3, 0);
      else
        if WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton:IsShown() then
          buttons[i]:SetPoint("LEFT", WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton, "RIGHT", 4, -2);
        else
          buttons[i]:SetPoint("LEFT", WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton, "LEFT", 0, 0);
        end
      end
      leftMostButton = buttons[i];
    end
  end
end

local function SelectSet(setID, forceStayOnWeapon)
  WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet = setID;
  for i=1,#WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons do
    if WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i]:IsShown() then
      SetButtonData(WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i], GetSetByID(WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].setID));
    end
  end
  --defaulting everything in the right side list
  for i=1,#WeaponSetsCollectionFrame.RightFrame.weaponTypeArray do
    WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].disabled = true;
    WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].num = 0;
    WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].numCollected = 0;
    WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].sources = {};
    WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].activeSource = 1;
  end
  --Filling in the sources for the right side list
  for i=1,#AllSets[setID].sources do
    WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[AllSets[setID].sources[i][1]].disabled = false;
    WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[AllSets[setID].sources[i][1]].num = WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[AllSets[setID].sources[i][1]].num + 1;
    if AllSets[setID].sources[i][3] then
      WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[AllSets[setID].sources[i][1]].numCollected = WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[AllSets[setID].sources[i][1]].numCollected + 1;
    end 
    tinsert(WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[AllSets[setID].sources[i][1]].sources, AllSets[setID].sources[i]);
  end
  --handle multiple sources for a weapon type
  for i=1,#WeaponSetsCollectionFrame.RightFrame.weaponTypeArray do
    if not WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].disabled then
      if WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].num > 1 then
        WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].NumSets:Show();
        WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].NumSets.label:SetText(WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].numCollected.."/"..WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].num);
        --if all collected, set multiple source info to green
        if WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].num == WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].numCollected then
          WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].NumSets.label:SetTextColor(app.colors.GREEN_FONT_COLOR.r,app.colors.GREEN_FONT_COLOR.g,app.colors.GREEN_FONT_COLOR.b);
          WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].NumSets.icon:SetVertexColor(app.colors.GREEN_FONT_COLOR.r,app.colors.GREEN_FONT_COLOR.g,app.colors.GREEN_FONT_COLOR.b);
        else --else, set it to yellow
          WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].NumSets.label:SetTextColor(.8,.7,.4,.65);
          WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].NumSets.icon:SetVertexColor(.8,.7,.4,.65);
        end
      else
        WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].NumSets:Hide();
      end
    else
      WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].NumSets:Hide();
    end
  end
  --Setting the appropriate weapon in the right side list
  if (ExS_Settings.stayOnWeaponType or forceStayOnWeapon) and not WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[WeaponSetsCollectionFrame.RightFrame.preferredWeapon].disabled then
    WeaponSetsCollectionFrame.RightFrame.activeWeapon = WeaponSetsCollectionFrame.RightFrame.preferredWeapon;
    WeaponSetsCollectionFrame.SelectWeapon();
  else
    for i=1,#WeaponSetsCollectionFrame.RightFrame.weaponTypeArray do
      if not WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].disabled then
        WeaponSetsCollectionFrame.RightFrame.activeWeapon = i;
        WeaponSetsCollectionFrame.SelectWeapon();
        break;
      end
    end
  end
  --Showing/Hiding the variant drop down list
  if #VariantSets[AllSets[setID].label] == 1 then
    WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton:Hide();
    --WardrobeCollectionFrame.WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton:SetPoint("LEFT", WardrobeCollectionFrame.WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton, "LEFT", 0, 0);
  else
    WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton:Show();
    --WardrobeCollectionFrame.WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton:SetPoint("LEFT", WardrobeCollectionFrame.WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton, "RIGHT", 2, 0);
    WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton:SetText(AllSets[setID].difficulty or AllSets[setID].name);
  end
  --Then move the extra buttons into place
  UpdateExtraButtons();
  
  --Setting the appropriate shown/hidden button state
  if ExS_Weapon_HiddenSets[setID] then
    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton.backgroundTexture:SetTexCoord(0,.5,0,1);
  else
    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton.backgroundTexture:SetTexCoord(.5,1,0,1);
  end
  
  --Setting the favorite button desaturation
  WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton.backgroundTexture:SetDesaturated(not ExS_Weapon_Favorites[setID]);
  
  --Show/Hide the No Longer Obtainable message
  if AllSets[setID].noLongerObtainable then
    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable:Show();
  else
    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable:Hide();
  end
end
WeaponSetsCollectionFrame.SelectSet = SelectSet;

--Used for opening the most complete variant set when selecting a set.
local function GetPrimarySet(setID)
  local baseSet = GetBaseSetByID(setID);
  if baseSet.favoriteSetID then
    return baseSet.favoriteSetID;
  end
  local sets = VariantSets[GetSetByID(setID).label];
  if #sets > 1 then
    
    local bestPerc = 0;
    local highestPatchID = 0;
    local bestSetID = setID;
    for i=1,#sets do
      local numC, numT = GetSetSourceCounts(sets[i].setID, sets[i].sources);
      local perc = numC / numT;
      if perc > bestPerc then
        bestPerc = perc;
        highestPatchID = sets[i].patchID;
        bestSetID = sets[i].setID;
      elseif perc == bestPerc and sets[i].patchID > highestPatchID then
        bestSetID = sets[i].setID;
        highestPatchID = sets[i].patchID;
      end
    end
    return bestSetID;
  else
    return setID;
  end
end

--Only used for navigating the list via keys.
local function GetIndexInSetList(setID)
  for i=1,#setList do
    if setList[i].setID == setID then
      return i;
    end
  end
  return 0;
end

--Sets the scroll position and updates the buttons to have the data for where its scroll position is.
local function ScrollToOffset(offset, minimizeScrolling, setSet)
	local index = 0;
	local currButton = 1;
  local offsetToSet = offset;
  local buttonsShown = #WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons;
  local mutableOffset = offset - (buttonsShown - 1);
  for i = 1, buttonsShown do
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i]:Hide();
  end
  if mutableOffset < 1 then mutableOffset = 1; end
  if not minimizeScrolling then
    mutableOffset = offset;
  elseif WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.currTopIndex > mutableOffset then
    if WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.currTopIndex <= offset then
      mutableOffset = WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.currTopIndex;
    else
      mutableOffset = offset;
    end
  end
  
  local selectSetID;
  --Loop through the List, updating the buttons once we get to the offset.
	for _, baseSet in ipairs(setList) do
		if currButton > buttonsShown then
			break;
		end
		index = index + 1;
    
    --If we need to select the set, set it if we are there.
    if setSet and index == offsetToSet then
      --SelectSet(baseSet.setID);
      local setID = GetPrimarySet(baseSet.setID);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet = setID;
      selectSetID = setID;
      setSet = false;
    end
    
    --If we are past the offset (don't need to check max as currButton does that).
		if index >= mutableOffset then
      SetButtonData(WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[currButton], baseSet);
      if currButton == 1 then WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.currTopIndex = index; end
      currButton = currButton + 1;
		end
	end
  --If there are leftover buttons, hide them.
	for i = currButton, buttonsShown do 
		WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i]:Hide();
	end
  
  if selectSetID then
    SelectSet(selectSetID);
  end
  
  --local scrollMax = max((#setList - buttonsShown), 0);
  --WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:SetMinMaxValues(0, scrollMax);
	--WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.range = (#setList - buttonsShown);
  
  --Update the scroll bar visual for our current scrolled position.
  --WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:SetValue(mutableOffset);
end

--On scrolling update, scroll to offset
local function WeaponSets_ScrollFrame_Update()
  if not setList then return; end --This function gets called before everything is setup. So this check just bounces this function back when that happens.
  if #setList > 0 then
    ScrollToOffset(WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:GetValue(), false, false);
  end
end

----
-- Search
----
local ignoreFirst = true;
local function OnSearchUpdate()
  if ignoreFirst then ignoreFirst = false; return; end
  FillWeaponSetMaps(true, true);
end

----
-- Item Frame.
----
--Refreshes item frame's tooltip. Used when tabbing through sources.
local function RefreshAppearanceTooltip()
  local sourceIDs = C_TransmogCollection.GetAllAppearanceSources(WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.appID)
  local sources = {};
  for i=1, #sourceIDs do
    local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceIDs[i]);
    if sourceInfo then tinsert(sources, sourceInfo); end
  end
	if ( #sources == 0 ) then
		-- can happen if a slot only has HiddenUntilCollected sources
		local sourceInfo = C_TransmogCollection.GetSourceInfo(WardrobeCollectionFrame.WeaponSetsCollectionFrame.tooltipPrimarySourceID);
		if sourceInfo then tinsert(sources, sourceInfo); end
	end
	if #sources == 0 then return end
	CollectionWardrobeUtil.SortSources(sources, sources[1].visualID, WardrobeCollectionFrame.WeaponSetsCollectionFrame.tooltipPrimarySourceID);

  WardrobeCollectionFrame.WeaponSetsCollectionFrame.tooltipSourceIndex, WardrobeCollectionFrame.WeaponSetsCollectionFrame.tooltipCycle = CollectionWardrobeUtil.SetAppearanceTooltip(GameTooltip, 
        {["sources"] = sources,
         ["primarySourceID"] = WardrobeCollectionFrame.WeaponSetsCollectionFrame.tooltipPrimarySourceID,
         ["selectedIndex"] = WardrobeCollectionFrame.WeaponSetsCollectionFrame.tooltipSourceIndex,
         ["shouldUseError"] = true})
end

--Sets the tooltip up when hovering over the item frame.
local function SetAppearanceTooltip(self, frame)
  --local self = WardrobeCollectionFrame;
	GameTooltip:SetOwner(frame, "ANCHOR_RIGHT");
	if not frame or not frame.invType then return end
	local transmogSlot = C_Transmog.GetSlotForInventoryType(frame.invType)
	if not transmogSlot then return end
	WardrobeCollectionFrame.WeaponSetsCollectionFrame.tooltipTransmogSlot = transmogSlot;
	WardrobeCollectionFrame.WeaponSetsCollectionFrame.tooltipPrimarySourceID = frame.sourceID;
	
  RefreshAppearanceTooltip();
end

--Sets up the item frame.
local function FillItemFrame(sourceID, isCollected)
  WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.sourceID = sourceID;
  local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID);
  WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.appID = sourceInfo.visualID;
  WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.invType = sourceInfo.invType;
  
	if ( isCollected ) then
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.Icon:SetVertexColor(1,1,1,1);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.IconBorder:SetVertexColor(1,1,1,1);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.IconBorder:SetDesaturation(0);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.Icon:SetDesaturation(0);
		if ( sourceInfo.quality == Enum.ItemQuality.Uncommon ) then
			WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.IconBorder:SetAtlas("loottab-set-itemborder-green", true);
		elseif ( sourceInfo.quality == Enum.ItemQuality.Rare ) then
			WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.IconBorder:SetAtlas("loottab-set-itemborder-blue", true);
		elseif ( sourceInfo.quality == Enum.ItemQuality.Epic ) then
			WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.IconBorder:SetAtlas("loottab-set-itemborder-purple", true);
		end
  else
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.IconBorder:SetDesaturation(1);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.IconBorder:SetVertexColor(1,1,1,0.0);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.Icon:SetDesaturation(0.7);
    --local _,_,_,main,off = C_TransmogCollection.GetCategoryInfo(weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][6])
    --if main or off then
    if weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][17] then
      WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.Icon:SetVertexColor(1,1,1,0.3);
    else
      WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.Icon:SetVertexColor(1,0.5,0.5,0.3);
    end
	end
  
  WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.Icon:SetTexture(C_TransmogCollection.GetSourceIcon(sourceID));
end

-- Hide the current set if it is set to hidden (and show hidden sets option isn't checked)
local function HideSet(setID)
  if ExS_Settings.showHiddenSets then
    --if show sets, update the hide button to show its current show/hide state
    --note: not is because we are updating the button before updating the save show/hide state of the set
    if not ExS_Weapon_HiddenSets[setID] then
      WeaponSetsCollectionFrame.RightFrame.HiddenSetButton.backgroundTexture:SetTexCoord(0,.5,0,1);
      GameTooltip_SetTitle(GameTooltip, app.GetLocalizedString("ShowSet"), NORMAL_FONT_COLOR, true);
    else
      WeaponSetsCollectionFrame.RightFrame.HiddenSetButton.backgroundTexture:SetTexCoord(.5,1,0,1);
      GameTooltip_SetTitle(GameTooltip, app.GetLocalizedString("HideSet"), NORMAL_FONT_COLOR, true);
    end
  else
    ExS_Settings.showHiddenSets = true;
    --else we are hiding sets, find the next best set to show
    local variants = VariantSets[AllSets[WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet].label]
    local nextInBaseList = false;
    --if there is another variant, 
    if #variants > 1 then
      for i = 1, #variants do
        if variants[i].setID == setID then
          --after the variant is found, look down the list for a new variant to show
          local foundSet = false;
          if i < #variants then 
            for j = i + 1, #variants do
              if not ExS_Weapon_HiddenSets[variants[j].setID] then
                foundSet = true;
                SelectSet(variants[j].setID);
                break;
              end
            end
          end
          --if still not found then look up the list for a new variant to show
          if not foundSet and i > 1 then
            for j = i - 1, 1, -1 do
              if not ExS_Weapon_HiddenSets[variants[j].setID] then
                foundSet = true;
                SelectSet(variants[j].setID);
                break;
              end
            end
          end
          
          --if still no variant is found, then we need to move to a different set
          if not foundSet then
            nextInBaseList = true;
          end
          break;
        end
      end
    else
      nextInBaseList = true;
    end
    
    --get the next best set from the baselist
    if nextInBaseList and #setList > 1 then
      local baseSetID = GetBaseSetID(setID);
      for i = 1, #setList do
        if setList[i].setID == baseSetID then
          --once found, if we are not at the end of the list, use next set, otherwise the previous set.
          if i < #setList then
            SelectSet(setList[i+1].setID);
          else
            SelectSet(setList[i-1].setID);
          end
          table.remove(setList, i);
          WeaponSets_ScrollFrame_Update();
          break;
        end
      end
    end
    ExS_Settings.showHiddenSets = false;
  end
end

--function to handle show/hide hidden sets toggle
local function ShowHideSetsToggle()
  local currSet = WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet;
  ExS_Settings.showHiddenSets = not ExS_Settings.showHiddenSets;
  
  --Call function to redo the weapon sets list
  local scrollVal = WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:GetValue();
  FillWeaponSetMaps(true);
  WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:SetValue(scrollVal);
  WeaponSets_ScrollFrame_Update();
  
  if not ExS_Weapon_HiddenSets[currSet] then
    SelectSet(currSet);
  end
  if ExS_Settings.showHiddenSets then
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Icon:SetTexCoord(.5,1,0,1);
  else
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Icon:SetTexCoord(0,.5,0,1);
  end
end

----
-- Drop Downs
----
--Variants Drop Down
local function OpenVariantSetsDropDown(owner, root)
  if not (WeaponSetsCollectionFrame:IsShown() and AllSets) then return; end
  
	local variantSets = VariantSets[AllSets[WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet].label];
  local comp = function(a,b) if a.setID > b.setID then return true; else return false; end end
  table.sort(variantSets, comp);
  
	for i = 1, #variantSets do
		local numSourcesCollected, numSourcesTotal, allUsableCollected = GetSetSourceCounts(variantSets[i].setID);
		local colorCode = app.colors.YELLOW_FONT_COLOR:GenerateHexColorMarkup();
		if ( numSourcesCollected == numSourcesTotal ) then
			colorCode = app.colors.GREEN_FONT_COLOR_CODE;
		elseif ( numSourcesCollected == 0 ) then
			colorCode = GRAY_FONT_COLOR_CODE;
    elseif ( allUsableCollected ) then
      colorCode = app.colors.BLUE_FONT_COLOR:GenerateHexColorMarkup();
		end
    local setName = variantSets[i].difficulty;
    if not setName then setName = variantSets[i].name; end
    if variantSets[i].requiredFaction then
      setName = app.GetFactionColoredString(setName, variantSets[i].requiredFaction);
    end
    
    
		root:CreateRadio(setName.."  "..colorCode.."("..numSourcesCollected.."/"..numSourcesTotal..")",
        function() return variantSets[i].setID == WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet end,
        function()
          --get which variant of a weapon type is the current, if stay on weapon type is active
          local activeSource;
          if ExS_Settings.stayOnWeaponType then
            activeSource = WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[WeaponSetsCollectionFrame.RightFrame.activeWeapon].activeSource;
          end
          --set the new variant set.
          SelectSet(variantSets[i].setID);
          --if stay on weapon type, keep the same weapon variant active when swapping to a variant set.
          if ExS_Settings.stayOnWeaponType then
            WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[WeaponSetsCollectionFrame.RightFrame.activeWeapon].activeSource = activeSource;
            WeaponSetsCollectionFrame.SelectWeapon();
          end
        end,
        setName
      )
	end
end

--Filters Drop Down
local function OpenWeaponSetsFilterDropDown(owner, root)
  --Collected
  local button = root:CreateCheckbox(COLLECTED,
      function() return C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_COLLECTED) end,
      function()
          C_TransmogSets.SetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_COLLECTED, not C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_COLLECTED));
          --Call function to redo the weapon sets list
          FillWeaponSetMaps(true);
        end
    )
  button:SetResponse(MenuResponse.Refresh)

  --Not Collected
  button = root:CreateCheckbox(NOT_COLLECTED,
      function() return C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_UNCOLLECTED) end,
      function()
          C_TransmogSets.SetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_UNCOLLECTED, not C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_UNCOLLECTED));
          --Call function to redo the weapon sets list
          FillWeaponSetMaps(true);
        end
    )
  button:SetResponse(MenuResponse.Refresh)
  
  root:CreateSpacer();

  --PvE
  button = root:CreateCheckbox(TRANSMOG_SET_PVE,
      function() return C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVE) end,
      function()
          C_TransmogSets.SetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVE, not C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVE));
          --Call function to redo the weapon sets list
          FillWeaponSetMaps(true);
        end
    )
  button:SetResponse(MenuResponse.Refresh)
  
  --PvP
  button = root:CreateCheckbox(TRANSMOG_SET_PVP,
      function() return C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVP) end,
      function()
          C_TransmogSets.SetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVP, not C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVP));
          --Call function to redo the weapon sets list
          FillWeaponSetMaps(true);
        end
    )
  button:SetResponse(MenuResponse.Refresh)
  
  --Show/Hide other faction sets
  button = root:CreateCheckbox(factionNames.opposingFaction,
      function() return ExS_Settings.displayOtherFaction end,
      function()
          ExS_Settings.displayOtherFaction = not ExS_Settings.displayOtherFaction;
          --Call function to redo the weapon sets list
          FillWeaponSetMaps(true);
        end
    )
  button:SetResponse(MenuResponse.Refresh)
  
  root:CreateSpacer();
  
  --Show/Hide only raid sets
  button = root:CreateCheckbox(app.GetLocalizedString("ShowOnlyRaidSets"),
      function() return ExS_Settings.showOnlyRaidSets end,
      function()
          ExS_Settings.showOnlyRaidSets = not ExS_Settings.showOnlyRaidSets;
          --Call function to redo the weapon sets list
          FillWeaponSetMaps(true);
        end
    )
  button:SetResponse(MenuResponse.Refresh)
  
  --Show/Hide no longer obtainable sets
  button = root:CreateCheckbox(app.GetLocalizedString("HideNoLongerObtain"),
      function() return ExS_Settings.hideNoLongerObtainable end,
      function()
          ExS_Settings.hideNoLongerObtainable = not ExS_Settings.hideNoLongerObtainable;
          --Call function to redo the weapon sets list
          FillWeaponSetMaps(true);
        end
    )
  button:SetResponse(MenuResponse.Refresh)
  
  --Show/Hide never obtainable weapons
  button = root:CreateCheckbox(app.GetLocalizedString("HideNeverObtain"),
      function() return ExS_Settings.hideNeverObtainable end,
      function()
          ExS_Settings.hideNeverObtainable = not ExS_Settings.hideNeverObtainable;
          --Call function to redo the weapon sets list
          --FillWeaponSetMaps(true);
        end
    )
  button:SetResponse(MenuResponse.Refresh)
  
  --Show/Hide hidden sets
  button = root:CreateCheckbox(app.GetLocalizedString("ShowHiddenSets"),
      function() return ExS_Settings.showHiddenSets end,
      function() ShowHideSetsToggle(); end
    )
  button:SetResponse(MenuResponse.Refresh)
  
  --
  -- Expansion Select opener
  --
  root:CreateSpacer();
  button = root:CreateButton(EXPANSION_FILTER_TEXT,nil)
  
  for i = ExpansionCount,1,-1 do
    local subButton = button:CreateCheckbox(_G["EXPANSION_NAME"..(i-1)],
        function() return ExS_Settings.weaponExpansionToggles[i] end,
        function()
            ExS_Settings.weaponExpansionToggles[i] = not ExS_Settings.weaponExpansionToggles[i];
            --Call function to redo the weapon sets list
            FillWeaponSetMaps(true);
          end
      )
    subButton:SetResponse(MenuResponse.Refresh)
  end
  
  button:CreateSpacer();
  
  local subButton = button:CreateButton(app.GetLocalizedString("EnableAll"),
      function() 
          for i = 1,ExpansionCount do
            ExS_Settings.weaponExpansionToggles[i] = true;
          end
          FillWeaponSetMaps(true);
        end
    )
  subButton:SetResponse(MenuResponse.CloseAll)
  
  subButton = button:CreateButton(app.GetLocalizedString("DisableAll"),
      function() 
          for i = 1,ExpansionCount do
            ExS_Settings.weaponExpansionToggles[i] = false;
          end
          FillWeaponSetMaps(true);
        end
    )
  subButton:SetResponse(MenuResponse.Refresh)
  
  root:CreateDivider();
  
  ----
  --  Settings
  ----  
  --Enable/Disable keeping on the same weapon type across sets
  button = root:CreateCheckbox(app.GetLocalizedString("StayOnWepType"),
      function() return ExS_Settings.stayOnWeaponType end,
      function() ExS_Settings.stayOnWeaponType = not ExS_Settings.stayOnWeaponType; end
    )
  button:SetResponse(MenuResponse.Refresh)
  
  --Dress player up in their clothes or not.
  button = root:CreateCheckbox(app.GetLocalizedString("wepUndressModel"),
      function() return ExS_Settings.wepUndressModel end,
      function()
          ExS_Settings.wepUndressModel = not ExS_Settings.wepUndressModel;
          
          if ExS_Settings.wepUndressModel then
            WeaponSetsCollectionFrame.RightFrame.Model:Undress();
          else
            WeaponSetsCollectionFrame.RightFrame.Model:Dress();
          end
          WeaponSetsCollectionFrame.initUndress = true;
            
          WeaponSetsCollectionFrame.SelectWeapon()
        end
    )
  button:SetResponse(MenuResponse.Close)
  
  root:CreateSpacer();
  
  --ProgressBar at top stays as all sets data or changes based on filter settings
  button = root:CreateCheckbox(app.GetLocalizedString("ProgressBarByFilter"),
      function() return ExS_Settings.progressBarByFilter end,
      function() ExS_Settings.progressBarByFilter = not ExS_Settings.progressBarByFilter; end
    )
  button:SetResponse(MenuResponse.Refresh)
  
    --Hide Description on left list
  button = root:CreateCheckbox(app.GetLocalizedString("ShowListLabel"),
      function() return not ExS_Settings.hideListDescription end,
      function()
          ExS_Settings.hideListDescription = not ExS_Settings.hideListDescription;
          SelectSet(WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet);
        end
    )
  button:SetResponse(MenuResponse.Refresh)
  
    --Flip Name and Description on left list
  button = root:CreateCheckbox(app.GetLocalizedString("FlipListNameAndLabel"),
      function() return ExS_Settings.flipNameAndLabel end,
      function()
          ExS_Settings.flipNameAndLabel = not ExS_Settings.flipNameAndLabel;
          SelectSet(WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet);
        end
    )
  button:SetResponse(MenuResponse.Refresh)
  
  root:CreateSpacer();
  
    --Show Favorite Button
  button = root:CreateCheckbox(app.GetLocalizedString("ShowFavButton"),
      function() return ExS_Settings.extraButtonToggles[3] end,
      function()
          ExS_Settings.extraButtonToggles[3] = not ExS_Settings.extraButtonToggles[3];
          UpdateExtraButtons();
        end
    )
  button:SetResponse(MenuResponse.Refresh)
  
    --Show Hide Sets Button
  button = root:CreateCheckbox(app.GetLocalizedString("ShowHideSetButton"),
      function() return ExS_Settings.extraButtonToggles[4] end,
      function()
          ExS_Settings.extraButtonToggles[4] = not ExS_Settings.extraButtonToggles[4];
          UpdateExtraButtons();
        end
    )
  button:SetResponse(MenuResponse.Refresh)
  
  --Disable hide set button
  button = root:CreateCheckbox(app.GetLocalizedString("DisableHideSetButton"),
      function() return ExS_Settings.disableHideSetButton end,
      function()
          ExS_Settings.disableHideSetButton = not ExS_Settings.disableHideSetButton;
          WeaponSetsCollectionFrame.RightFrame.HiddenSetButton.backgroundTexture:SetDesaturated(ExS_Settings.disableHideSetButton);
        end
    )
  button:SetResponse(MenuResponse.Refresh)
  
    --Show Auction House Button
  button = root:CreateCheckbox(app.GetLocalizedString("ShowAHButton"),
      function() return ExS_Settings.extraButtonToggles[1] end,
      function()
          ExS_Settings.extraButtonToggles[1] = not ExS_Settings.extraButtonToggles[1];
          UpdateExtraButtons();
        end
    )
  button:SetResponse(MenuResponse.Refresh)
  
    --Show Tooltip Set Info
  button = root:CreateCheckbox(app.GetLocalizedString("ShowTooltipSetInfo"),
      function() return ExS_Settings.showTooltipSetInfo end,
      function() ExS_Settings.showTooltipSetInfo = not ExS_Settings.showTooltipSetInfo; end
    )
  button:SetResponse(MenuResponse.Refresh)
  
  root:CreateSpacer();
    --Show Hide Weapons Tab Button
  button = root:CreateCheckbox(app.GetLocalizedString("EnableWepSets"),
      function() return not ExS_Settings.hideWeaponsTab end,
      function() ExS_Settings.hideWeaponsTab = not ExS_Settings.hideWeaponsTab; end
    )
  button:SetResponse(MenuResponse.Close)
end

----
-- Model
----
--Adjusting the appearance/position of the Weapon Types buttons for Selected/Non-Selected/Disabled.
local function RefreshWeaponTypeButtons()
  for i=1,#WeaponSetsCollectionFrame.RightFrame.weaponTypeArray do
    WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].background:SetShown(false);
    if i == WeaponSetsCollectionFrame.RightFrame.activeWeapon then
      WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].background:SetShown(true);
      WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i]:SetHeight(WeaponSetsCollectionFrame.RightFrame.buttonHeight * 2);
      WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].Text:SetFontObject("GameFontHighlightLarge");
      WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].WeaponIcon:SetSize(WeaponSetsCollectionFrame.RightFrame.buttonHeight*1.5,WeaponSetsCollectionFrame.RightFrame.buttonHeight*1.5);
      --WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].WeaponIcon:SetVertexColor(1,1,1,1);
    elseif WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].disabled then
      WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i]:SetHeight(WeaponSetsCollectionFrame.RightFrame.buttonHeight);
      WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].Text:SetFontObject("GameFontDisable");
      WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].WeaponIcon:SetSize(WeaponSetsCollectionFrame.RightFrame.buttonHeight*0.9,WeaponSetsCollectionFrame.RightFrame.buttonHeight*0.9);
      WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].WeaponIcon:SetVertexColor(1,1,1,0.25);
    else
      WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i]:SetHeight(WeaponSetsCollectionFrame.RightFrame.buttonHeight);
      WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].Text:SetFontObject("GameFontNormal");
      WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].WeaponIcon:SetSize(WeaponSetsCollectionFrame.RightFrame.buttonHeight*0.9,WeaponSetsCollectionFrame.RightFrame.buttonHeight*0.9);
      --WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].WeaponIcon:SetVertexColor(1,1,1,1);
    end
    if i > 1 then
      WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i]:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i-1], "BOTTOMLEFT", 0, WeaponSetsCollectionFrame.RightFrame.buttonOffset);
    else
      WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i]:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.RightFrame, "TOPLEFT", 0, -WeaponSetsCollectionFrame.RightFrame.buttonTopSpacer);
    end
    if not WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].disabled then
      local weaponTypeButton = WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i];
      local sources = weaponTypeButton.sources;
      local aSource = weaponTypeButton.activeSource or 1;
      local source = sources and (sources[aSource] or sources[1]);
      if source and source[3] == true then
        WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].Text:SetTextColor(app.colors.GREEN_FONT_COLOR.r, app.colors.GREEN_FONT_COLOR.g, app.colors.GREEN_FONT_COLOR.b);
        
        WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].background:SetVertexColor(0.2,1,.6,0.6);
        --WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].WeaponIcon:SetVertexColor(.4,1,.6,1);
        WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].WeaponIcon:SetVertexColor(.7,1,.8,1);
      elseif source then
        
        --local _,_,_,main,off = C_TransmogCollection.GetCategoryInfo(weaponType[i][6])
        --if main or off then
        if weaponType[i][17] then
          WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].Text:SetTextColor(app.colors.YELLOW_FONT_COLOR.r, app.colors.YELLOW_FONT_COLOR.g, app.colors.YELLOW_FONT_COLOR.b);
          WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].background:SetVertexColor(0.6,1,1,0.4);
          --WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].WeaponIcon:SetVertexColor(.95,1,.4,1);
          WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].WeaponIcon:SetVertexColor(.98,1,.7,1);
        else
          WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].Text:SetTextColor(app.colors.RED_FONT_COLOR.r, app.colors.RED_FONT_COLOR.g, app.colors.RED_FONT_COLOR.b);
          WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].background:SetVertexColor(1,.3,.6,0.3);
          --WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].WeaponIcon:SetVertexColor(1,.4,.35,1);
          WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].WeaponIcon:SetVertexColor(1,.7,.7,1);
        end
      else
        -- Source data may still be initializing when the frame first appears.
        weaponTypeButton.Text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
        weaponTypeButton.WeaponIcon:SetVertexColor(1, 1, 1, 0.25);
      end
    else
      WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].Text:SetTextColor(GRAY_FONT_COLOR.r,GRAY_FONT_COLOR.g,GRAY_FONT_COLOR.b);
    end
  end
end

local function SetPose()
  if WeaponSetsCollectionFrame.RightFrame.SwapPose.inPose then
    local actWep = WeaponSetsCollectionFrame.RightFrame.activeWeapon;
    if actWep == 3 then --bow
      WeaponSetsCollectionFrame.RightFrame.Model:FreezeAnimation(105, 0, 0);
    elseif actWep == 4 then --xbow
      WeaponSetsCollectionFrame.RightFrame.Model:SetAnimation(48);
    elseif actWep == 7 then --gun
      WeaponSetsCollectionFrame.RightFrame.Model:FreezeAnimation(49, 0, 0);
    elseif actWep == 2 or actWep == 9 then --2h mace and axe
      WeaponSetsCollectionFrame.RightFrame.Model:FreezeAnimation(656,0,650);
    elseif actWep == 6 then --fist
      WeaponSetsCollectionFrame.RightFrame.Model:FreezeAnimation(118,0,0);
    elseif actWep == 11 then --polearm
      WeaponSetsCollectionFrame.RightFrame.Model:FreezeAnimation(86,2,390);
    else
      WeaponSetsCollectionFrame.RightFrame.Model:FreezeAnimation(120, 0, 0);
    end
  else
    WeaponSetsCollectionFrame.RightFrame.Model:SetAnimation(0);
  end
end

local mainHandSlotID = GetInventorySlotInfo("MAINHANDSLOT");
local offHandSlotID = GetInventorySlotInfo("SECONDARYHANDSLOT");
local function RemoveWeapons()
  WeaponSetsCollectionFrame.RightFrame.Model:UndressSlot(mainHandSlotID);
  WeaponSetsCollectionFrame.RightFrame.Model:UndressSlot(offHandSlotID);
end

--Resets the player's rotation, pitch and roll
local function ResetPlayerRotations(resetAll)
  local pRS = playerRaceSex;
  local hasAlt, inAlt = C_PlayerInfo.GetAlternateFormInfo();
  if hasAlt and inAlt then pRS = pRS.."Alt"; end
  local settings = ModelSettings[pRS];
  if not settings then settings = ModelSettings["HumanMale"] end
  local rotationAmt = settings[weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][10]];
  --if not rotationAmt then
  --  rotationAmt = weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][18];
  --end
  WeaponSetsCollectionFrame.RightFrame.Model:SetRotation(rotationAmt);
  WeaponSetsCollectionFrame.RightFrame.Model.rotation = rotationAmt;
  WeaponSetsCollectionFrame.RightFrame.Model:SetPosition(0,0,0);
  
  WeaponSetsCollectionFrame.RightFrame.Model:SetPortraitZoom(MODELFRAME_MIN_ZOOM);
  WeaponSetsCollectionFrame.RightFrame.Model.zoomLevel = MODELFRAME_MIN_ZOOM;
  if resetAll then
    WeaponSetsCollectionFrame.RightFrame.Model:SetPitch(0);
    WeaponSetsCollectionFrame.RightFrame.Model:SetRoll(0);
    WeaponSetsCollectionFrame.RightFrame.Model.roll = 0;
    WeaponSetsCollectionFrame.RightFrame.Model.pitch = 0;
  end
end

local classInd = select(3,UnitClass('player'));
local function CanDualWield()
  if WeaponSetsCollectionFrame.RightFrame.activeWeapon == 1 or
     WeaponSetsCollectionFrame.RightFrame.activeWeapon == 5 or
     WeaponSetsCollectionFrame.RightFrame.activeWeapon == 6 or
     WeaponSetsCollectionFrame.RightFrame.activeWeapon == 8 or
     WeaponSetsCollectionFrame.RightFrame.activeWeapon == 14 or
     WeaponSetsCollectionFrame.RightFrame.activeWeapon == 17 then
    return true;
  end
  if classInd == 1 then
    if WeaponSetsCollectionFrame.RightFrame.activeWeapon == 2 or
       WeaponSetsCollectionFrame.RightFrame.activeWeapon == 9 or
       WeaponSetsCollectionFrame.RightFrame.activeWeapon == 15 then
      return true;
    end
  end
  return false;
end

--Fills in the item icon/name/labels on the right side.
local function FillDetails(weaponSourceID, aSource)
  FillItemFrame(weaponSourceID, WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[WeaponSetsCollectionFrame.RightFrame.activeWeapon].sources[aSource][3]);
  local sourceInfo = C_TransmogCollection.GetSourceInfo(weaponSourceID);
  if sourceInfo.name == nil then 
    expectingTransmogInfoUpdate = true;
  else
    expectingTransmogInfoUpdate = false;
  end
  WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Name:SetText(sourceInfo.name);
  local label = WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[WeaponSetsCollectionFrame.RightFrame.activeWeapon].sources[aSource][5];
  if type(label) == "table" then
    label = app.GetFormattedLabel(label[2]);
    if type(label) == "table" then label = "" end
  elseif label == -1 then
    label = app.GetLocalizedString("NeverObtainable");
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Label:SetTextColor(app.colors.RED_FONT_COLOR.r, app.colors.RED_FONT_COLOR.g, app.colors.RED_FONT_COLOR.b);
  elseif label == -2 then
    label = app.GetLocalizedString("TradingPost");
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Label:SetTextColor(.55,.55,.7);
  elseif label then
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Label:SetTextColor(.55,.55,.7);
  end
  WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Label:SetText(label);
  local label2 = WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[WeaponSetsCollectionFrame.RightFrame.activeWeapon].sources[aSource][6]
  if type(label2) == "table" then
    label = app.GetFormattedLabel(label2[2]);
    if type(label2) == "table" then label2 = "" end
  end
  WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Label2:SetText(label2);
  
  --remix
  local set = GetSetByID(WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet)
  local isMoPRemix = WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[WeaponSetsCollectionFrame.RightFrame.activeWeapon].sources[aSource][5] == app.GetLocalizedString("MoPRemixExclusive") or
                     WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[WeaponSetsCollectionFrame.RightFrame.activeWeapon].sources[aSource][6] == app.GetLocalizedString("MoPRemixExclusive") or
                     (set.isAllRemix and set.isRemix == 5);
  local isLegionRemix = WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[WeaponSetsCollectionFrame.RightFrame.activeWeapon].sources[aSource][5] == app.GetLocalizedString("LegRemixExclusive") or
                     WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[WeaponSetsCollectionFrame.RightFrame.activeWeapon].sources[aSource][6] == app.GetLocalizedString("LegRemixExclusive") or
                     (set.isAllRemix and set.isRemix == 7);
                     
  WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.RemixIcon:SetShown(isMoPRemix);
  WeaponSetsCollectionFrame.RightFrame.RemixIcon:SetShown(isMoPRemix);
  WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.LegionRemixIcon:SetShown(isLegionRemix);
  WeaponSetsCollectionFrame.RightFrame.LegionRemixIcon:SetShown(isLegionRemix);
end

--Equip a weapon, if the current model is the player
local function EquipWeapon()
    --Get the active weapon's source ID
  local aSource = WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[WeaponSetsCollectionFrame.RightFrame.activeWeapon].activeSource;
  if not WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[WeaponSetsCollectionFrame.RightFrame.activeWeapon].sources[aSource] then
    aSource = 1;
  end
  local weaponSourceID = WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[WeaponSetsCollectionFrame.RightFrame.activeWeapon].sources[aSource][2];
  
  if WeaponSetsCollectionFrame.initUndress then
     WeaponSetsCollectionFrame.initUndress = false;
     C_Timer.After(1, function()
        if ExS_Settings.wepUndressModel then
          WeaponSetsCollectionFrame.RightFrame.Model:Undress();
        else
          WeaponSetsCollectionFrame.RightFrame.Model:UndressSlot(16);
          WeaponSetsCollectionFrame.RightFrame.Model:UndressSlot(17);
        end
        WeaponSetsCollectionFrame.RightFrame.Model:TryOn(weaponSourceID);
        if ExS_Settings.showDualWielding and CanDualWield() then
          WeaponSetsCollectionFrame.RightFrame.Model:TryOn(weaponSourceID, "SECONDARYHANDSLOT");
        end
      end)
  else
    WeaponSetsCollectionFrame.RightFrame.Model:TryOn(weaponSourceID);
    if ExS_Settings.showDualWielding and CanDualWield() then
      WeaponSetsCollectionFrame.RightFrame.Model:TryOn(weaponSourceID, "SECONDARYHANDSLOT");
    end
  end
  FillDetails(weaponSourceID, aSource);
  
  ResetPlayerRotations();
  SetPose();
end

--Weapon Zooming
--isZoomIn, boolean used by mousewheel
--setSqDist, optional, used to set the default zoom level
function WeaponZoom(isZoomIn, isDefault)
  if not WeaponSetsCollectionFrame.RightFrame.Model:HasCustomCamera() then
    WeaponSetsCollectionFrame.RightFrame.Model:MakeCurrentCameraCustom();
  end
  local cx,cy,cz = WeaponSetsCollectionFrame.RightFrame.Model:GetCameraPosition();
  local tx,ty,tz = WeaponSetsCollectionFrame.RightFrame.Model:GetCameraTarget();
  
    
  local vecDist = sqrt((cx-tx)*(cx-tx) + (cy-ty)*(cy-ty) + (cz-tz)*(cz-tz));
  if vecDist ~= 0 then
    local nx = 0;
    local ny = 0;
    local nz = 0;
  
    nx = (cx - tx) / vecDist
    ny = (cy - ty) / vecDist
    nz = (cz - tz) / vecDist
    
    if not isDefault then
      if isZoomIn then
        cx = cx - nx * MODELFRAME_ZOOM_STEP;
        cy = cy - ny * MODELFRAME_ZOOM_STEP;
        cz = cz - nz * MODELFRAME_ZOOM_STEP;
      else
        cx = cx + nx * MODELFRAME_ZOOM_STEP;
        cy = cy + ny * MODELFRAME_ZOOM_STEP;
        cz = cz + nz * MODELFRAME_ZOOM_STEP;
      end
      
      local vecSqDist = (cx-tx)*(cx-tx) + (cy-ty)*(cy-ty) + (cz-tz)*(cz-tz);
      if vecSqDist > weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][11] then
        local sqrtMax = sqrt(weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][11])--weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][13];
        cx = tx + nx * sqrtMax;
        cy = ty + ny * sqrtMax;
        cz = tz + nz * sqrtMax;
      elseif vecSqDist < weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][12] then
        local sqrtMin = sqrt(weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][12])--weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][14];
        cx = tx + nx * sqrtMin;
        cy = ty + ny * sqrtMin;
        cz = tz + nz * sqrtMin;
      end
    else
      local dist = sqrt(weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][11])
      cx = tx + nx * dist;
      cy = ty + ny * dist;
      cz = tz + nz * dist;
    end
    
    WeaponSetsCollectionFrame.RightFrame.Model:SetCameraPosition(cx,cy,cz)
  end
end

local callbackCount = 0;
local function WeaponZoomCallback()
  WeaponZoom(nil, true);
  callbackCount = callbackCount + 1;
  if callbackCount < 5 then
    C_Timer.After(0, WeaponZoomCallback);
  end
end

--Resets the default Rotation, Roll and Pitch of the weapon (only for the weapon only model)
local function ResetWeapon()
  WeaponSetsCollectionFrame.RightFrame.Model:SetRotation(weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][7]);
  WeaponSetsCollectionFrame.RightFrame.Model:SetRoll(-weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][8]);
  WeaponSetsCollectionFrame.RightFrame.Model:SetPitch(-weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][9]);
  WeaponSetsCollectionFrame.RightFrame.Model.rotation = weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][7];
  WeaponSetsCollectionFrame.RightFrame.Model.roll = weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][8];
  WeaponSetsCollectionFrame.RightFrame.Model.pitch = weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][9];
  
  WeaponZoom(nil, true);
  
  local x = WeaponSetsCollectionFrame.RightFrame.Model:GetPosition()
  WeaponSetsCollectionFrame.RightFrame.Model:SetPosition(x, weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][15], weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][16])
end

--Set a weapon, if the current model is just the weapon
local function SetWeapon()
    --Get the active weapon's source ID
  local aSource = WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[WeaponSetsCollectionFrame.RightFrame.activeWeapon].activeSource;
  if not WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[WeaponSetsCollectionFrame.RightFrame.activeWeapon].sources[aSource] then
    aSource = 1;
  end
  local weaponSourceID = WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[WeaponSetsCollectionFrame.RightFrame.activeWeapon].sources[aSource][2];
  local sourceInfo = C_TransmogCollection.GetSourceInfo(weaponSourceID);
  WeaponSetsCollectionFrame.RightFrame.Model:SetItem(sourceInfo.itemID,sourceInfo.itemModID,sourceInfo.visualID);
  FillDetails(weaponSourceID, aSource);
  
  ResetWeapon();
end
WeaponSetsCollectionFrame.SetWeapon = SetWeapon;

local function SelectWeapon()
  RefreshWeaponTypeButtons();
  --test white item box
  if app.devMode then
    WeaponSetsCollectionFrame.RightFrame.indexText:SetText(WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[WeaponSetsCollectionFrame.RightFrame.activeWeapon].activeSource);
  end
  RemoveWeapons();
  if WeaponSetsCollectionFrame.RightFrame.Model.isPlayer then
    EquipWeapon();
  else
    SetWeapon();
    callbackCount = 0;
    C_Timer.After(0, WeaponZoomCallback);
  end
end


local function SwapPlayerItem()
  --Get item here
  if WeaponSetsCollectionFrame.RightFrame.Model.isPlayer then
    --If player set the model to the item
    SetWeapon();
    WeaponSetsCollectionFrame.RightFrame.Model.isPlayer = false;
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem.tex:SetTexCoord(50/256,100/256,200/256,250/256);
  else
    --If not player, set up the player
    WeaponSetsCollectionFrame.RightFrame.Model:SetUnit("player", false, not select(2,C_PlayerInfo.GetAlternateFormInfo()));
    if ExS_Settings.wepUndressModel then
      WeaponSetsCollectionFrame.RightFrame.Model:Undress();
    else
      WeaponSetsCollectionFrame.RightFrame.Model:Dress();
    end
    WeaponSetsCollectionFrame.initUndress = true;
    
    --C_Timer.After(.2, function()
    --    WeaponSetsCollectionFrame.RightFrame.Model:UndressSlot(16);
    --    WeaponSetsCollectionFrame.RightFrame.Model:UndressSlot(17);
    --  end)
    ResetPlayerRotations(true);
    WeaponSetsCollectionFrame.RightFrame.Model:RefreshUnit();
    WeaponSetsCollectionFrame.RightFrame.Model:SetUnit("player", false, not select(2,C_PlayerInfo.GetAlternateFormInfo()));
    RemoveWeapons();
    EquipWeapon();
    WeaponSetsCollectionFrame.RightFrame.Model.isPlayer = true;
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem.tex:SetTexCoord(100/256,150/256,200/256,250/256);
  end
end

local function ModelPostMouseDown(self, button)
  if ( button == "LeftButton" ) then
    _,self.pitchCursorStart = GetCursorPosition();
  end
end

--local function ModelPostMouseUp(self, button)
--  if ( button == "LeftButton" ) then
--    print("Rotation: "..WeaponSetsCollectionFrame.RightFrame.Model:GetFacing())
--    print("Roll: "..WeaponSetsCollectionFrame.RightFrame.Model:GetRoll())
--    print("Pitch: "..WeaponSetsCollectionFrame.RightFrame.Model:GetPitch())
--  end
--end

local function ModelOnUpdate(self, elapsedTime)
  --used for returning pitch/roll back to 0
  --default was 0.5
	local rotationsPerSecond = 0.65;
	
	-- Mouse drag rotation
	if (self.mouseDown) then
		if ( self.rotationCursorStart ) then
			local x, y = GetCursorPosition();
			local diff = (x - self.rotationCursorStart) * MODELFRAME_DRAG_ROTATION_CONSTANT;
      local oldRotation = self.rotation;
      
			self.rotation = self.rotation + diff;
			if ( self.rotation < 0 ) then
				self.rotation = self.rotation + (2 * PI);
			end
			if ( self.rotation > (2 * PI) ) then
				self.rotation = self.rotation - (2 * PI);
			end
      
      --only do pitch/roll for the weapon only
      if not self.isPlayer then
        --setting the rotation for the item version to allow for the default rotation
        self:SetRotation(self.rotation)-- + weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][7]);
        
        local diffPitch = (y - self.pitchCursorStart) * MODELFRAME_DRAG_ROTATION_CONSTANT;
        
        local pitchCoef = math.cos(oldRotation);
        self.pitch = self.pitch + (diffPitch * pitchCoef);
        if ( self.pitch < 0 ) then
          self.pitch = self.pitch + (2 * PI);
        end
        if ( self.pitch > (2 * PI) ) then
          self.pitch = self.pitch - (2 * PI);
        end
        self:SetPitch(-self.pitch)-- - weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][9]);
        
        local rollCoef = math.sin(oldRotation);
        self.roll = self.roll + (diffPitch * rollCoef);
        if ( self.roll < 0 ) then
          self.roll = self.roll + (2 * PI);
        end
        if ( self.roll > (2 * PI) ) then
          self.roll = self.roll - (2 * PI);
        end
        self:SetRoll(-self.roll)-- - weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][8]);
        
        --local x,y,z = WeaponSetsCollectionFrame.RightFrame.Model:GetPosition()
        --WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Label:SetText("Y: "..y.."   Z: "..z);
        --WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Label:SetText("Rotation: "..self.rotation.."  Roll: "..self.roll.."  Pitch: "..self.pitch);
      else
        --setting the rotation for the player version
        self:SetRotation(self.rotation);
      end
      
			self.rotationCursorStart, self.pitchCursorStart = GetCursorPosition();
		end
	elseif ( self.panning ) then
		local modelScale = self:GetModelScale();
		local cursorX, cursorY = GetCursorPosition();
		local scale = UIParent:GetEffectiveScale();
		if self.panningFrame then 
			self.panningFrame:SetPoint("BOTTOMLEFT", cursorX / scale - 16, cursorY / scale - 16);	-- half the texture size to center it on the cursor
		end
		-- settings
		local settings;
		local hasAlternateForm, inAlternateForm = C_PlayerInfo.GetAlternateFormInfo();
    if WeaponSetsCollectionFrame.RightFrame.Model.isPlayer then
      if ( hasAlternateForm and inAlternateForm ) then
        settings = ModelSettings[playerRaceSex.."Alt"];
      else
        settings = ModelSettings[playerRaceSex];
      end
      if not settings then
        settings = ModelSettings["HumanMale"];
      end
    else
      
      settings = ModelSettings[WeaponSetsCollectionFrame.RightFrame.activeWeapon];
    end
		
		local zoom = self.zoomLevel or self.minZoom;
		zoom = 1 + zoom - self.minZoom;	-- want 1 at minimum zoom
		-- Panning should require roughly the same mouse movement regardless of zoom level so the model moves at the same rate as the cursor
		-- This formula more or less works for all zoom levels, found via trial and error
		local transformationRatio = settings.panValue * 2 ^ (zoom * 2) * scale / modelScale;
		local dx = (cursorX - self.cursorX) / transformationRatio;
		local dy = (cursorY - self.cursorY) / transformationRatio;
		local cameraY = self.cameraY + dx;
		local cameraZ = self.cameraZ + dy;
		-- bounds
		scale = scale * modelScale;
		local maxCameraY = settings.panMaxRight * scale;
		cameraY = min(cameraY, maxCameraY);
		local minCameraY = settings.panMaxLeft * scale;
		cameraY = max(cameraY, minCameraY);
		local maxCameraZ = settings.panMaxTop * scale;
		cameraZ = min(cameraZ, maxCameraZ);
		local minCameraZ = settings.panMaxBottom * scale;
		cameraZ = max(cameraZ, minCameraZ);
		self:SetPosition(self.cameraX, cameraY, cameraZ);	
  elseif not self.isPlayer and (self.roll ~= weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][8] or self.pitch ~= weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][9]
                                  or self.rotation ~= weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][7]) then
    if self.rotation ~= weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][7] then
      local dir = 1;
      local offset = (PI - weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][7]) + self.rotation;
      if offset > 2*PI then offset = offset - 2*PI; elseif offset < 0 then offset = offset + 2*PI; end
      if offset > PI then dir = -1 end
      self.rotation = self.rotation + (elapsedTime * 2 * PI * rotationsPerSecond * dir);
      offset = offset + (elapsedTime * 2 * PI * rotationsPerSecond * dir);
      if dir > 0 and offset > PI then self.rotation = weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][7];
      elseif dir < 0 and offset < PI then self.rotation = weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][7]; end
      self:SetRotation(self.rotation);
    end
    if self.roll ~= weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][8] then
      local dir = 1;
      local offset = (PI - weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][8]) + self.roll;
      if offset > 2*PI then offset = offset - 2*PI; elseif offset < 0 then offset = 2*PI + offset; end
      if offset > PI then dir = -1 end
      self.roll = self.roll + (elapsedTime * 2 * PI * rotationsPerSecond * dir);
      offset = offset + (elapsedTime * 2 * PI * rotationsPerSecond * dir);
      if dir > 0 and offset > PI then self.roll = weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][8];
      elseif dir < 0 and offset < PI then self.roll = weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][8]; end
      self:SetRoll(-self.roll);
    end
    if self.pitch ~= weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][9] then
      local dir = 1;
      local offset = (PI - weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][9]) + self.pitch;
      if offset > 2*PI then offset = offset - 2*PI; elseif offset < 0 then offset = 2*PI + offset; end
      if offset > PI then dir = -1 end
      self.pitch = self.pitch + (elapsedTime * 2 * PI * rotationsPerSecond * dir);
      offset = offset + (elapsedTime * 2 * PI * rotationsPerSecond * dir);
      if dir > 0 and offset > PI then self.pitch = weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][9];
      elseif dir < 0 and offset < PI then self.pitch = weaponType[WeaponSetsCollectionFrame.RightFrame.activeWeapon][9]; end
      self:SetPitch(-self.pitch);
    end
	end
end



-- Removed the standalone addon's unused SetTab/ClickTab replacements. The
-- embedded frame is owned exclusively by BetterWardrobe's normal tab mixin.

--Yay to copying entire functions because someone made a local variable with no way to update it \o/
--local function ExW_OnLoad()
--  local self = WardrobeCollectionFrame; --oh and this is new, but not interesting
--  print("onload")
--  if not C_Transmog.IsAtTransmogNPC() then
--  print("not at transmogrifier")
--    PanelTemplates_SetNumTabs(self, 3);
--    WardrobeCollectionFrame.Tabs[3] = WardrobeCollectionFrame.WeaponsTab;
--    PanelTemplates_SetNumTabs(WardrobeCollectionFrame, 3)
--    PanelTemplates_TabResize(WardrobeCollectionFrame.WeaponsTab, 0)
--  else
--  print("at transmogrifier")
--    PanelTemplates_SetNumTabs(self, 2);
--    WardrobeCollectionFrame.Tabs[3] = nil;
--    PanelTemplates_SetNumTabs(WardrobeCollectionFrame, 2)
--  end
--	PanelTemplates_SetTab(self, TAB_ITEMS);
--	PanelTemplates_ResizeTabsToFit(self, TABS_MAX_WIDTH);
--	self.selectedCollectionTab = TAB_ITEMS;
--	self.selectedTransmogTab = TAB_ITEMS;
--	CollectionsJournal:SetPortraitToAsset("Interface\\Icons\\inv_misc_enggizmos_19");
--	-- TODO: Remove this at the next deprecation reset
--	self.searchBox = self.SearchBox;
--end
----
-- End Tab Width Copy/Pasta.
----

----
-- Progress Bar
----
--Sets the Progress Bar at the top of the sets window.
local function UpdateProgressBar()
  local numSets, numCompleted = 0,0;
  if not ExS_Settings.progressBarByFilter then
    for setID,setData in pairs(AllSets) do
      local col, tot = GetSetSourceCounts(setID, setData.sources);
      numSets = numSets + 1;
      if col == tot then
        numCompleted = numCompleted + 1;
      end
    end
  else
    for label,_ in pairs(BaseSets) do
      for _,setData in pairs(VariantSets[label]) do
        local col, tot = GetSetSourceCounts(setID, setData.sources);
        numSets = numSets + 1;
        if col == tot then
          numCompleted = numCompleted + 1;
        end
      end
    end
  end
	
	WardrobeCollectionFrame.progressBar:SetMinMaxValues(0, numSets);
  WardrobeCollectionFrame.progressBar:SetValue(numCompleted);
	WardrobeCollectionFrame.progressBar.text:SetFormattedText(HEIRLOOMS_PROGRESS_FORMAT, numCompleted, numSets);
  local percent 
  if numSets ~= 0 then
    percent = numCompleted / numSets;
  else
    percent = 0;
  end
  
  local color = app.MergeColors(percent);
  WardrobeCollectionFrame.progressBar:SetStatusBarColor(color.r, color.g, color.b);
end

----
-- Favorites
----

local function MarkSetAsFavorite(setID, markAsFav)
  local scrollFrame = WeaponSetsCollectionFrame.LeftFrame.ScrollFrame;
  local baseSet = GetSetByID(GetBaseSetID(setID));
  local favSet = GetSetByID(setID);
  
  favSet.favorite = markAsFav;
  ExS_Weapon_Favorites[setID] = markAsFav or nil;
  
  --if setting it as fav, make it the base favorite set if there wasn't one already
  if markAsFav then
    if not baseSet.favoriteSetID then
      baseSet.favoriteSetID = setID;
    end
  else
    --else clear the favorite set ids
    favSet.favoriteSetID = nil;
    baseSet.favoriteSetID = nil;
    --and check if there is a different favorite to set as the favorite set
    local varSets = VariantSets[baseSet.label];
    for i=1,#varSets do
      if varSets[i].favorite then
        varSets[i].favoriteSetID = varSets[i].setID;
        baseSet.favoriteSetID = varSets[i].setID;
        break;
      end
    end
  end
  SortSetList();
  WeaponSets_ScrollFrame_Update();
  if setID == scrollFrame.selectedSet then
    WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton.backgroundTexture:SetDesaturated(not ExS_Weapon_Favorites[setID]);
  end
end

local function FavoriteDropDown_Init(button)
  if not AllSets then return; end
  
  local scrollFrame = WeaponSetsCollectionFrame.LeftFrame.ScrollFrame;
  local baseButtonSetID = GetBaseSetID(button.setID);
  local baseButtonSet = GetSetByID(baseButtonSetID);
  
	local baseSelectedSetID = GetBaseSetID(scrollFrame.selectedSet);
  local setID = baseButtonSetID;
  if (baseButtonSet.favoriteSetID ~= nil) then
    setID = baseButtonSet.favoriteSetID
  elseif (baseButtonSetID == baseSelectedSetID) then
    setID = scrollFrame.selectedSet;
  end
  
	local variantSets = VariantSets[GetSetByID(setID).label];
  local set = GetSetByID(setID);
	local useDescription = (#variantSets > 1);
  local desc = set.difficulty;
  if desc == nil then desc = set.name; end

  MenuUtil.CreateContextMenu(button, function(owner, root)
    --Favorite button
    if baseButtonSet.favoriteSetID then
      local text;
      if useDescription then
        text = format(TRANSMOG_SETS_UNFAVORITE_WITH_DESCRIPTION, desc);
      else
        text = BATTLE_PET_UNFAVORITE;
      end
      root:CreateButton(text,
          function()
            MarkSetAsFavorite(baseButtonSet.favoriteSetID, false);
          end
        )
    else
      local targetSetID = GetPrimarySet(button.setID);
      local text;
      if useDescription then
        text = format(TRANSMOG_SETS_FAVORITE_WITH_DESCRIPTION, desc);
      else
        text = BATTLE_PET_FAVORITE;
      end
      root:CreateButton(text,
          function()
            MarkSetAsFavorite(setID, true);
          end
        )
    end
    
    -- Hide All Variants of Set
    if ExS_Settings.disableHideSetButton then
        local disHSb = root:CreateButton(app.GetLocalizedString("HideSetsButtonDisabled"), nil)
        disHSb:SetEnabled(false);
    else
      local hiddenCount = 0;
      for i=1,#variantSets do
        if ExS_Weapon_HiddenSets[variantSets[i].setID] then
          hiddenCount = hiddenCount + 1;
        end
      end
      --No sets hidden, so hiding all sets.
      if hiddenCount == 0 then
        root:CreateButton(app.GetLocalizedString("HideAllVersions"),
            function()
              local baseSetID = GetBaseSetID(button.setID);
              local varSets = VariantSets[GetSetByID(setID).label];
              local hiddenLabel = tonumber(WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Text:GetText());
              for i=1, #varSets do
                if not ExS_Weapon_HiddenSets[varSets[i].setID] then
                  ExS_Weapon_HiddenSets[varSets[i].setID] = true;
                  hiddenLabel = hiddenLabel + 1;
                end
              end
              WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Text:SetText(hiddenLabel);
              
              if GetBaseSetID(scrollFrame.selectedSet) == baseSetID then
                ExS_Weapon_HiddenSets[scrollFrame.selectedSet] = nil;
                HideSet(scrollFrame.selectedSet);
                ExS_Weapon_HiddenSets[scrollFrame.selectedSet] = true;
              elseif not ExS_Settings.showHiddenSets then
                --local scrollVal = WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:GetValue();
                FillWeaponSetMaps(true);
                --WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:SetValue(scrollVal);
                WeaponSets_ScrollFrame_Update();
              end
            end
          )
      else --at least one set is hidden, so show all sets.
        root:CreateButton(app.GetLocalizedString("ShowAllVersions"),
            function()
              local baseSetID = GetBaseSetID(button.setID);
              local varSets = VariantSets[GetSetByID(baseSetID).label];
              local hiddenLabel = tonumber(WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Text:GetText());
              for i=1, #varSets do
                if ExS_Weapon_HiddenSets[varSets[i].setID] then
                  ExS_Weapon_HiddenSets[varSets[i].setID] = nil;
                  hiddenLabel = hiddenLabel - 1;
                end
              end
              WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Text:SetText(hiddenLabel);
              if GetBaseSetID(scrollFrame.selectedSet) == baseSetID then
                WeaponSetsCollectionFrame.RightFrame.HiddenSetButton.backgroundTexture:SetTexCoord(.5,1,0,1);
              end
            end
          )
      end
    end
    
    -- Cancel
    root:CreateSpacer();
    local cancel = root:CreateButton(CANCEL,function() end);
    cancel:SetResponse(MenuResponse.CloseAll);
  end)
end

----
--
----

WeaponSetsCollectionFrame.InitWeaponFrame = function()
  if WeaponSetsCollectionFrame.isInit then return; end
  
    WeaponSetsCollectionFrame.isInit = true;
    _, factionNames.playerFaction = UnitFactionGroup('player');
    if factionNames.playerFaction == app.GetLocalizedString("Alliance") then
      factionNames.opposingFaction = app.GetLocalizedString("Horde");
    else
      factionNames.opposingFaction = app.GetLocalizedString("Alliance");
    end
    
    WardrobeCollectionFrame.WeaponSetsCollectionFrame = WeaponSetsCollectionFrame;
    WeaponSetsCollectionFrame:SetParent(WardrobeCollectionFrame);
    WeaponSetsCollectionFrame:SetPoint("BOTTOM", WardrobeCollectionFrame,"BOTTOM",0,5);
    local width,height = WardrobeCollectionFrame.ItemsCollectionFrame:GetSize();
    WeaponSetsCollectionFrame:SetSize(width,height);
    WeaponSetsCollectionFrame.SetAppearanceTooltip = SetAppearanceTooltip;
    WeaponSetsCollectionFrame.RefreshAppearanceTooltip = RefreshAppearanceTooltip;
    WeaponSetsCollectionFrame.SelectWeapon = SelectWeapon;
    WeaponSetsCollectionFrame.ScrollToOffset = ScrollToOffset;
    WeaponSetsCollectionFrame.UpdateProgressBar = UpdateProgressBar
    WeaponSetsCollectionFrame.GetCurrentSet = GetCurrentSet;
    WeaponSetsCollectionFrame.NewVisualIDs = {};
    WeaponSetsCollectionFrame:Hide();
    WeaponSetsCollectionFrame:SetScript("OnShow", function()
          FillWeaponSetMaps(false);
          WeaponSetsCollectionFrame.UpdateProgressBar();
          WeaponSetsCollectionFrame:RegisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE");
          WeaponSetsCollectionFrame:RegisterEvent("UNIT_FORM_CHANGED");
          --WeaponSetsCollectionFrame:RegisterEvent("TRANSMOG_COLLECTION_SOURCE_ADDED");
          WeaponSetsCollectionFrame:RegisterEvent("TRANSMOG_COLLECTION_SOURCE_REMOVED");
          if ExS_Settings.showHiddenSets then
            WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Icon:SetTexCoord(.5,1,0,1);
          else
            WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Icon:SetTexCoord(0,.5,0,1);
          end
      end)
    WeaponSetsCollectionFrame:SetScript("OnHide", function()
          WeaponSetsCollectionFrame:UnregisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE");
          WeaponSetsCollectionFrame:UnregisterEvent("UNIT_FORM_CHANGED");
      end)
    WardrobeCollectionFrame.WeaponSetsCollectionFrame.CanHandleKey = function(self,key)
              if key == WARDROBE_UP_VISUAL_KEY or key == WARDROBE_DOWN_VISUAL_KEY or key == WARDROBE_PREV_VISUAL_KEY or key == WARDROBE_NEXT_VISUAL_KEY then
                return true;
              end
              return false;
        end;
    WeaponSetsCollectionFrame.OnUnitModelChangedEvent = function()
          return;
      end
    
    --WardrobeCollectionFrame.WeaponsTab = CreateFrame("Button", "WardrobeCollectionFrameTab3", WardrobeCollectionFrame, "PanelTopTabButtonTemplate");
    --WardrobeCollectionFrame.WeaponsTab:SetText(app.GetLocalizedString("WepSets"));
    --WardrobeCollectionFrame.WeaponsTab:SetPoint("LEFT", WardrobeCollectionFrameTab2, "RIGHT",0,0)
    --WardrobeCollectionFrame.WeaponsTab:SetID(3)
    --WardrobeCollectionFrame.WeaponsTab:SetAttribute("frameLevel",4)
    --WardrobeCollectionFrame.WeaponsTab.minWidth = 57;
    --WardrobeCollectionFrame.WeaponsTab:SetScript("OnClick", function()
    --        WardrobeCollectionFrame:ClickTab(WardrobeCollectionFrame.WeaponsTab);
    --  end)
    --WardrobeCollectionFrame.Tabs[3] = WardrobeCollectionFrame.WeaponsTab;
    --PanelTemplates_SetNumTabs(WardrobeCollectionFrame, 3)
    --PanelTemplates_TabResize(WardrobeCollectionFrame.WeaponsTab, 0)
    --
    --WardrobeCollectionFrame.progressBar:SetWidth(WardrobeCollectionFrame.progressBar:GetWidth() * 0.6);
    --WardrobeCollectionFrame.progressBar.border:SetWidth(WardrobeCollectionFrame.progressBar.border:GetWidth() * 0.6);
    --WardrobeCollectionFrame.progressBar:ClearAllPoints()
    --WardrobeCollectionFrame.progressBar:SetPoint("LEFT", "WardrobeCollectionFrameTab3", "RIGHT",15,-2)

    --Left (Scroll) frame
    WeaponSetsCollectionFrame.LeftFrame = CreateFrame("Frame", nil, WeaponSetsCollectionFrame, "InsetFrameTemplate");
    WeaponSetsCollectionFrame.LeftFrame:SetPoint("TOPLEFT", WeaponSetsCollectionFrame, "TOPLEFT");
    -- Wider list prevents set names, labels and source counts from colliding.
    WeaponSetsCollectionFrame.LeftFrame:SetSize(240, WeaponSetsCollectionFrame:GetHeight());
    
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, WeaponSetsCollectionFrame.LeftFrame, "HybridScrollFrameTemplate");
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.LeftFrame, "TOPLEFT", 3, -36);
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame:SetSize(WeaponSetsCollectionFrame.LeftFrame:GetWidth() - 5, 499);
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet = 0;
    
    local scrollBarScalar = 0.65;
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar = CreateFrame("Slider", nil, WeaponSetsCollectionFrame.LeftFrame.ScrollFrame, "HybridScrollBarTrimTemplate");
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:SetValueStep(1);
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:SetObeyStepOnDrag(true);
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.stepSize = 1;
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:SetWidth(20 * scrollBarScalar)
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.Top:SetSize(24 * scrollBarScalar, 48 * scrollBarScalar)
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.Top:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar, "TOPLEFT", -4 * scrollBarScalar, 17 * scrollBarScalar)
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.Bottom:SetSize(24 * scrollBarScalar, 64 * scrollBarScalar)
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.Bottom:SetPoint("BOTTOMLEFT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar, "BOTTOMLEFT", -4 * scrollBarScalar, -15 * scrollBarScalar)
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.UpButton:SetSize(18 * scrollBarScalar, 16 * scrollBarScalar)
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.DownButton:SetSize(18 * scrollBarScalar, 16 * scrollBarScalar)
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.thumbTexture:SetWidth(18 * scrollBarScalar);
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.thumbTexture:SetPoint("TOP",WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.trackBG,"TOP");
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.thumbTexture:Show();
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:SetPoint("TOPRIGHT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame, "TOPRIGHT", 0, -18 * scrollBarScalar);
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:SetPoint("BOTTOMRIGHT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame, "BOTTOMRIGHT", 0, 15 * scrollBarScalar);
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.trackBG:Show();
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.trackBG:SetVertexColor(0, 0, 0, 0.75);
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.doNotHide = true;
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.scrollValue = 1;
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:SetScript("OnValueChanged", function(self, val)
                self.scrollValue = val;
                
                self:GetParent():SetVerticalScroll(val/select(2,self:GetMinMaxValues()));
                local min,max = self:GetMinMaxValues()
                if val >= max then
                  self:GetParent().scrollDown:Disable();
                else
                  self:GetParent().scrollDown:Enable();
                end
                if val <= min then
                  self:GetParent().scrollUp:Disable();
                else
                  self:GetParent().scrollUp:Enable();
                end
                WeaponSets_ScrollFrame_Update();
              end);
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:SetValue(1);
    local mouseWheel = function(self, delta)
              if delta > 0 then
                if WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.scrollValue > 1 then
                  WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:SetValue(WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.scrollValue - 1);
                end
              else
                if WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.scrollValue < select(2,WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:GetMinMaxValues()) then
                  WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:SetValue(WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.scrollValue + 1);
                end
              end
        end
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:SetScript("OnMouseWheel", mouseWheel);
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame:SetScript("OnMouseWheel", mouseWheel);
    local buttonOnUpdate = function(self, elapsed) 
                self.timeSinceLast = self.timeSinceLast + elapsed;
                if ( self.timeSinceLast >= ( self.updateInterval or 0.08 ) ) then
                  if ( not IsMouseButtonDown("LeftButton") ) then
                    self:SetScript("OnUpdate", nil);
                  elseif ( self:IsMouseOver() ) then
                    mouseWheel(nil, self.direction);
                    self.timeSinceLast = 0;
                  end
                end
        end
    local buttonOnClick = function(self,button,down)
              if ( down ) then
                self.timeSinceLast = (self.timeToStart or -0.2);
                self:SetScript("OnUpdate", buttonOnUpdate);
                mouseWheel(nil, self.direction);
                PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON);
              else
                self:SetScript("OnUpdate", nil);
              end
        end
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.UpButton:SetScript("OnClick", buttonOnClick)
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.DownButton:SetScript("OnClick", buttonOnClick)
    --function to handle the up/down arrow keys to traverse the left list
    --                   the left/right arrow keys to traverse the weapon type list
    WardrobeCollectionFrame.WeaponSetsCollectionFrame.HandleKey = function(self,key)
              local index = GetIndexInSetList(WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet);
              
              if key == WARDROBE_UP_VISUAL_KEY then
                if index > 1 then ScrollToOffset(index - 1, true, true) end
              elseif key == WARDROBE_DOWN_VISUAL_KEY then
                if index < #setList then ScrollToOffset(index + 1, true, true) end
              elseif key == WARDROBE_PREV_VISUAL_KEY then
                local i = WeaponSetsCollectionFrame.RightFrame.activeWeapon;
                while i > 1 do
                  i = i - 1;
                  if not WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].disabled then
                    WeaponSetsCollectionFrame.RightFrame.activeWeapon = i;
                    SelectWeapon();
                    return;
                  end
                end
              elseif key == WARDROBE_NEXT_VISUAL_KEY then
                local i = WeaponSetsCollectionFrame.RightFrame.activeWeapon;
                while i < 17 do
                  i = i + 1;
                  if not WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].disabled then
                    WeaponSetsCollectionFrame.RightFrame.activeWeapon = i;
                    SelectWeapon();
                    return;
                  end
                end
              end
        end;

    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons = {}
    for i = 1, 12 do
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i] = CreateFrame("BUTTON", "WeaponSetsScroll_button"..i, WeaponSetsCollectionFrame.LeftFrame.ScrollFrame, "WardrobeSetsScrollFrameButtonTemplate")
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i]:SetScript("OnClick", nil); --gets rid of an unwanted Blizzard interaction
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i]:SetSize(WeaponSetsCollectionFrame.LeftFrame.ScrollFrame:GetWidth() - 40 - (22 * scrollBarScalar), WeaponSetsCollectionFrame.LeftFrame.ScrollFrame:GetHeight() / 12);
	  WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].Name:SetFontObject(GameFontNormal)
	  WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].Label:SetFontObject(GameFontHighlightSmall)
      if i == 1 then
        WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i]:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame, "TOPLEFT", 40, 0);
      else
        WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i]:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i-1], "BOTTOMLEFT", 0, 0);
      end
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].IconFrame:SetPoint("LEFT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i], "LEFT", -38, 0);

      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].ProgressBars = { WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].ProgressBar };
      SET_PROGRESS_BAR_MAX_WIDTH = WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i]:GetWidth() - 5;
      
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].SelectedTexture:SetAtlas("GarrMission_ListGlow-Select");
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].SelectedTexture:SetVertexColor(1,1,1,0.6)
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].SelectedTexture:ClearAllPoints();
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].SelectedTexture:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i], "TOPLEFT", -13, -1)
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].SelectedTexture:SetPoint("TOPRIGHT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i], "TOPRIGHT", 13, -1)
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].SelectedTexture:SetPoint("BOTTOMLEFT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i], "LEFT", -13, -2)
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].SelectedTexture:SetPoint("BOTTOMRIGHT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i], "RIGHT", 13, -2)
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].HighlightTexture:SetAtlas("GarrMission_ListGlow-Highlight");
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].HighlightTexture:SetVertexColor(1,1,1,0.8)
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].HighlightTexture:ClearAllPoints();
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].HighlightTexture:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i], "TOPLEFT", -10, -1)
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].HighlightTexture:SetPoint("TOPRIGHT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i], "TOPRIGHT", 10, -1)
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].HighlightTexture:SetPoint("BOTTOMLEFT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i], "LEFT", -10, -2)
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].HighlightTexture:SetPoint("BOTTOMRIGHT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i], "RIGHT", 10, -2)
      
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets = CreateFrame("Frame", nil, WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i]);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets:SetAllPoints();
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets.icon = WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets:CreateTexture(nil, "BACKGROUND");
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets.icon:SetPoint("TOPRIGHT",WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets, "TOPRIGHT", -8,-8);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets.icon:SetSize(10,10);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets.icon:SetTexture([[Interface\Addons\BetterWardrobe\WeaponSets\textures\multipleSymbol.tga]]);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets.icon:SetVertexColor(.8,.7,.4,.65);
      
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets.label = WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets:CreateFontString(nil, "OVERLAY", "GameTooltipText")
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets.label:SetPoint("RIGHT",WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets.icon,"LEFT",-1,0);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets.label:SetText("1");
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets.label:SetTextColor(.8,.7,.4,.65);
      
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].Remix = CreateFrame("Frame", nil, WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i]);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].Remix:SetAllPoints();
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].Remix.icon = WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].Remix:CreateTexture(nil, "BACKGROUND");
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].Remix.icon:SetPoint("BOTTOMRIGHT",WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].Remix, "BOTTOMRIGHT", -1,1);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].Remix.icon:SetSize(20,20);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].Remix.icon:SetTexture([[Interface\Addons\BetterWardrobe\WeaponSets\textures\Remix_icon.tga]]);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].Remix.icon:SetVertexColor(1,1,1,.3);
      
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].LegionRemix = CreateFrame("Frame", nil, WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i]);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].LegionRemix:SetAllPoints();
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].LegionRemix.icon = WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].LegionRemix:CreateTexture(nil, "BACKGROUND");
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].LegionRemix.icon:SetPoint("BOTTOMRIGHT",WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].LegionRemix, "BOTTOMRIGHT", -1,1);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].LegionRemix.icon:SetSize(20,20);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].LegionRemix.icon:SetTexture([[Interface\Addons\BetterWardrobe\WeaponSets\textures\Remix_legion_icon.tga]]);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].LegionRemix.icon:SetVertexColor(1,1,1,.3);
      
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].TradingPost = CreateFrame("Frame", nil, WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i]);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].TradingPost:SetAllPoints();
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].TradingPost.icon = WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].TradingPost:CreateTexture(nil, "BACKGROUND");
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].TradingPost.icon:SetPoint("BOTTOMRIGHT",WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].TradingPost, "BOTTOMRIGHT", -1,1);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].TradingPost.icon:SetSize(12,12);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].TradingPost.icon:SetTexture(4696085);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].TradingPost.icon:SetDesaturation(.4);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].TradingPost.icon:SetVertexColor(.9,.85,.1,.45);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].TradingPost.icon:SetTexCoord(.2,.95,.1,.9);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].TradingPost.icon:SetRotation(math.pi);
    
      -- Keep unused rows hidden until SetButtonData assigns valid set data.
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i]:Hide();
      
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i]:SetScript("OnMouseUp", function(self, button)
              if ( button == "LeftButton" ) then
                PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
                local setID = GetPrimarySet(self.setID);
                SelectSet(setID);
              elseif ( button == "RightButton" ) then
                FavoriteDropDown_Init(self);
                PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
              end
        end)
    end
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.currTopIndex = 1;
    
    WeaponSetsCollectionFrame.LeftFrame.SearchBox = CreateFrame("EditBox", nil, WeaponSetsCollectionFrame.LeftFrame, "SearchBoxTemplate");
    WeaponSetsCollectionFrame.LeftFrame.SearchBox:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.LeftFrame, "TOPLEFT", 13, -9);
    WeaponSetsCollectionFrame.LeftFrame.SearchBox:SetSize(152, 20);
    WeaponSetsCollectionFrame.LeftFrame.SearchBox:SetScript("OnTextChanged", function(self)
                  if ( not self:HasFocus() and self:GetText() == "" ) then
                    self.searchIcon:SetVertexColor(0.6, 0.6, 0.6);
                    self.clearButton:Hide();
                  else
                    self.searchIcon:SetVertexColor(1.0, 1.0, 1.0);
                    self.clearButton:Show();
                  end
                  InputBoxInstructions_OnTextChanged(self);
                  OnSearchUpdate();
      end)
    
    --Filter dropdown
    WeaponSetsCollectionFrame.LeftFrame.FilterButton = CreateFrame("DropdownButton", nil, WeaponSetsCollectionFrame.LeftFrame, "WowStyle1FilterDropdownTemplate");
    WeaponSetsCollectionFrame.LeftFrame.FilterButton:SetPoint("LEFT", WeaponSetsCollectionFrame.LeftFrame.SearchBox, "RIGHT", 2, -1);
    WeaponSetsCollectionFrame.LeftFrame.FilterButton:SetPoint("RIGHT", WeaponSetsCollectionFrame.LeftFrame.SearchBox, "RIGHT", 70, -1);
    WeaponSetsCollectionFrame.LeftFrame.FilterButton:SetMenuAnchor(AnchorUtil.CreateAnchor("TOPLEFT", WeaponSetsCollectionFrame.LeftFrame.FilterButton, "TOPRIGHT", 4, 3))
    WeaponSetsCollectionFrame.LeftFrame.FilterButton:SetText(FILTER)
    WeaponSetsCollectionFrame.LeftFrame.FilterButton:SetupMenu(OpenWeaponSetsFilterDropDown)   
    
    WeaponSetsCollectionFrame.RightFrame = CreateFrame("Frame", nil, WeaponSetsCollectionFrame, "CollectionsBackgroundTemplate");
    WeaponSetsCollectionFrame.RightFrame.BGCornerTopLeft:Hide();
    WeaponSetsCollectionFrame.RightFrame.BGCornerBottomLeft:Hide();
    WeaponSetsCollectionFrame.RightFrame:ClearAllPoints();
    WeaponSetsCollectionFrame.RightFrame:SetPoint("RIGHT", WeaponSetsCollectionFrame, "RIGHT",2,0);
    WeaponSetsCollectionFrame.RightFrame:SetSize(WeaponSetsCollectionFrame:GetWidth() - WeaponSetsCollectionFrame.LeftFrame:GetWidth(), WeaponSetsCollectionFrame:GetHeight());

    WeaponSetsCollectionFrame.RightFrame:Show();
    WardrobeCollectionFrame.WeaponSetsCollectionFrame.RightFrame.SetAppearanceTooltip = SetAppearanceTooltip;
    WardrobeCollectionFrame.WeaponSetsCollectionFrame.RightFrame.RefreshAppearanceTooltip = RefreshAppearanceTooltip;
    
    WeaponSetsCollectionFrame.RightFrame.weaponTypeArray = {}
    WeaponSetsCollectionFrame.RightFrame.activeWeapon = 1;
    WeaponSetsCollectionFrame.RightFrame.preferredWeapon = 1;
    
    WeaponSetsCollectionFrame.RightFrame.buttonTopSpacer = 35;
    WeaponSetsCollectionFrame.RightFrame.buttonHeight = (WeaponSetsCollectionFrame.RightFrame:GetHeight() - (10 + WeaponSetsCollectionFrame.RightFrame.buttonTopSpacer)) / (#weaponType + 2);
    WeaponSetsCollectionFrame.RightFrame.buttonOffset = -WeaponSetsCollectionFrame.RightFrame.buttonHeight / #weaponType;
    local buttonWidth = 175;
    for i=1,#weaponType do
      local button = CreateFrame("Button", nil, WeaponSetsCollectionFrame.RightFrame);
      button:SetWidth(buttonWidth);
      button:RegisterForMouse("LeftButtonDown", "RightButtonDown");
      button.WeaponIcon = button:CreateTexture(nil, "ARTWORK");
      button.WeaponIcon:SetPoint("CENTER", button, "LEFT", 5 + (WeaponSetsCollectionFrame.RightFrame.buttonHeight * .75), 0);
      button.WeaponIcon:SetTexture([[Interface\Addons\BetterWardrobe\WeaponSets\textures\weapon_icons.tga]]);
      button.WeaponIcon:SetTexCoord(weaponType[i][2],weaponType[i][3],weaponType[i][4],weaponType[i][5]);
      button.Text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	  button.Text:SetFontObject(GameFontNormalSmall)
      button.Text:SetPoint("LEFT",button.WeaponIcon,"RIGHT",5,0);
      button.Text:SetText(weaponType[i][1]);
      button.index = i;
      button:SetScript("OnMouseDown", function(self,button)
          if self.disabled == true then return; end
          WeaponSetsCollectionFrame.RightFrame.preferredWeapon = self.index;
          if WeaponSetsCollectionFrame.RightFrame.activeWeapon ~= self.index then
            WeaponSetsCollectionFrame.RightFrame.activeWeapon = self.index;
            SelectWeapon();
          else
            if WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].activeSource > WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].num then
              WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].activeSource = WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].num;
            end
            if (button == "LeftButton") then
              WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].activeSource = WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].activeSource + 1;
              if WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].activeSource > WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].num then
                WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].activeSource = 1;
              end
            else
              WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].activeSource = WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].activeSource - 1;
              if WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].activeSource < 1 then
                WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].activeSource = WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].num;
              end
            end
            SelectWeapon();
          end
        end)
      button.NumSets = CreateFrame("Frame", nil, button);
      button.NumSets:SetAllPoints();
      button.NumSets.label = button.NumSets:CreateFontString(nil, "OVERLAY", "GameTooltipTextSmall")
      button.NumSets.label:SetPoint("LEFT",button.Text,"RIGHT",5,-1);
      button.NumSets.label:SetText("1");
      button.NumSets.label:SetTextColor(.8,.7,.4,.65);
      
      button.NumSets.icon = button.NumSets:CreateTexture(nil, "BACKGROUND");
      button.NumSets.icon:SetPoint("LEFT",button.NumSets.label, "RIGHT", 2,0);
      button.NumSets.icon:SetSize(8,8);
      button.NumSets.icon:SetTexture([[Interface\Addons\BetterWardrobe\WeaponSets\textures\multipleSymbol.tga]]);
      button.NumSets.icon:SetVertexColor(.8,.7,.4,.65);
      
      button.background = button:CreateTexture(nil, "BACKGROUND");
      button.background:SetAtlas("BonusChest-OrangeSmoke-Wide");
      button.background:SetPoint("TOPLEFT", button, "TOPLEFT", -5,-8);
      button.background:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", -5,8);
      button.background:SetPoint("TOPRIGHT", button.Text, "TOPRIGHT", 25,-8);
      button.background:SetPoint("BOTTOMRIGHT", button.Text, "BOTTOMRIGHT", 25,8);
      button.background:SetVertexColor(0.6,1,1,0.4);
      
      button:Show();
      
      WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i] = button;
    end
    
    ----Variant Drop Down
    WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton = CreateFrame("DropdownButton", nil, WeaponSetsCollectionFrame.RightFrame, "WowStyle2DropdownTemplate")
    WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.RightFrame, "TOPLEFT", 10, -9);
    WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton:SetSize(108,22);
    WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton:SetMenuAnchor(AnchorUtil.CreateAnchor("TOPLEFT", WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton, "BOTTOMLEFT", -3, -1))
    WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton:SetupMenu(OpenVariantSetsDropDown)
    WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton:SetSelectionText(function(selection)
        if selection[1] then
          return selection[1].data;
        end
      end)
    
    -- Favorite Set Button --
    WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton = CreateFrame("Frame", "ExS_Weapon_FavoriteSetButton", WeaponSetsCollectionFrame.RightFrame);
    WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton:SetSize(16,20);
    WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton:SetPoint("LEFT", WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton, "RIGHT", 2, 0);

    WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton.backgroundTexture = WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton:CreateTexture(nil, "BACKGROUND");
    WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton.backgroundTexture:SetPoint("CENTER");
    WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton.backgroundTexture:SetSize(22,22);
    WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton.backgroundTexture:SetAtlas("PetJournal-FavoritesIcon");
    --WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton.backgroundTexture:SetDesaturated(ExS_Settings.disableHideSetButton);

    WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_LEFT");
      if ExS_Weapon_Favorites[WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet] then
        GameTooltip_SetTitle(GameTooltip, app.GetLocalizedString("MarkSetFav"), NORMAL_FONT_COLOR, true);
      else
        GameTooltip_SetTitle(GameTooltip, app.GetLocalizedString("MarkSetNotFav"), NORMAL_FONT_COLOR, true);
      end
      GameTooltip:Show();
    end);
    WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton:SetScript("OnLeave", function(self)
      GameTooltip:Hide();
    end);
    
    WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton:SetScript("OnMouseUp", function(pSelf, pButton, pDown)
      if pButton == "LeftButton" then
        local setID = WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet;
        MarkSetAsFavorite(setID, not ExS_Weapon_Favorites[setID]);
      end
    end);
    WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton:SetShown(ExS_Settings.extraButtonToggles[3]);
    
    -- Hidden Set Button --
    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton = CreateFrame("Frame", "ExS_Weapon_HiddenSetButton", WeaponSetsCollectionFrame.RightFrame);
    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton:SetSize(16,20);
    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton:SetPoint("LEFT", WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton, "RIGHT", 2, 0);

    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton.backgroundTexture = WeaponSetsCollectionFrame.RightFrame.HiddenSetButton:CreateTexture(nil, "BACKGROUND");
    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton.backgroundTexture:SetAllPoints();
    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton.backgroundTexture:SetTexture([[Interface\Addons\BetterWardrobe\WeaponSets\textures\ShowHideIcons.tga]]);
    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton.backgroundTexture:SetTexCoord(0,.5,0,1);
    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton.backgroundTexture:SetDesaturated(ExS_Settings.disableHideSetButton);

    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_LEFT");
      if ExS_Weapon_HiddenSets[WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet] then
        GameTooltip_SetTitle(GameTooltip, app.GetLocalizedString("ShowSet"), NORMAL_FONT_COLOR, true);
      else
        GameTooltip_SetTitle(GameTooltip, app.GetLocalizedString("HideSet"), NORMAL_FONT_COLOR, true);
      end
      if ExS_Settings.disableHideSetButton then
        GameTooltip_AddErrorLine(GameTooltip, ADDON_DISABLED);
      end
      GameTooltip:Show();
    end);
    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton:SetScript("OnLeave", function(self)
      GameTooltip:Hide();
    end);
    
    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton:SetScript("OnMouseUp", function(pSelf, pButton, pDown)
      if pButton == "LeftButton" and not ExS_Settings.disableHideSetButton then
        local setID = WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet;
        HideSet(setID);
        ExS_Weapon_HiddenSets[setID] = not ExS_Weapon_HiddenSets[setID] or nil;
        local count = tonumber(WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Text:GetText());
        if ExS_Weapon_HiddenSets[setID] then count = count + 1; else
        count = count - 1; end
        WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Text:SetText(count);
      end
    end);
    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton:SetShown(ExS_Settings.extraButtonToggles[4]);
    
    -- No Longer Obtainable warning --
    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable = CreateFrame("Frame", "ExS_Weapon_NoLongerObtainable", WeaponSetsCollectionFrame.RightFrame);
    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable:SetSize(70,14);
    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable:SetPoint("LEFT", WeaponSetsCollectionFrame.RightFrame.HiddenSetButton, "RIGHT", 35, 0);

    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable.Icon = WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable:CreateTexture(nil, "BACKGROUND");
    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable.Icon:SetSize(14,14);
    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable.Icon:SetPoint("LEFT");
    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable.Icon:SetAtlas("transmog-icon-remove");
    
    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable.Text = WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable:CreateFontString(nil, "OVERLAY", "GameFontRedSmall");
    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable.Text:SetPoint("LEFT", WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable.Icon, "RIGHT", -2, 0);
    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable.Text:SetWidth(60);
    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable.Text:SetText(app.GetLocalizedString("NoLongerObtainable"));

    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_LEFT");
      GameTooltip_SetTitle(GameTooltip, app.GetLocalizedString("NoLongerObtainable"), NORMAL_FONT_COLOR, true);
      GameTooltip:Show();
    end);
    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable:SetScript("OnLeave", function(self)
      GameTooltip:Hide();
    end);
    
    -- Hidden Set Count --
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount = CreateFrame("Frame", nil, WeaponSetsCollectionFrame.RightFrame);
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount:SetSize(40,20);
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount:SetPoint("BOTTOMRIGHT", WeaponSetsCollectionFrame.RightFrame, "TOPRIGHT", 0, 6);

    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Icon = WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount:CreateTexture(nil, "BACKGROUND");
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Icon:SetPoint("RIGHT");
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Icon:SetSize(16,16);
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Icon:SetTexture([[Interface\Addons\BetterWardrobe\WeaponSets\textures\ShowHideIcons.tga]]);
    if ExS_Settings.showHiddenSets then
      WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Icon:SetTexCoord(.5,1,0,1);
    else
      WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Icon:SetTexCoord(0,.5,0,1);
    end
    
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Text = WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount:CreateFontString(nil, "OVERLAY", "GameTooltipText");
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Text:SetPoint("RIGHT", WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Icon, "LEFT", -2,0);
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Text:SetJustifyH("RIGHT");
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Text:SetText("1");
    
    local function SetHiddenSetsTooltip()
      local str = WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Text:GetText()..app.GetLocalizedString("CountSetsHidden")
      GameTooltip_SetTitle(GameTooltip, str, NORMAL_FONT_COLOR, true);
      if ExS_Settings.showHiddenSets then
        str = app.GetLocalizedString("HideHiddenSetsTT")
      else
        str = app.GetLocalizedString("ShowHiddenSetsTT")
      end
      GameTooltip:AddLine(str,.55,.55,.7);
      GameTooltip:Show();
    end
    
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_LEFT");
      SetHiddenSetsTooltip();
    end);
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount:SetScript("OnLeave", function(self)
      GameTooltip:Hide();
    end);
    
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount:SetScript("OnMouseUp", function(pSelf, pButton, pDown)
      ShowHideSetsToggle();
      SetHiddenSetsTooltip();
    end);

    
    ----Details Frame (Icon, Name, Label)
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame = CreateFrame("Frame", nil, WeaponSetsCollectionFrame.RightFrame);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame:SetSize(WeaponSetsCollectionFrame.RightFrame:GetWidth() - buttonWidth - 20, 100);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame:SetPoint("TOPRIGHT", WeaponSetsCollectionFrame.RightFrame, "TOPRIGHT", -20, -15);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame = CreateFrame("Frame", nil, WeaponSetsCollectionFrame.RightFrame.DetailsFrame, "WardrobeSetsDetailsItemFrameTemplate");
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame:SetPoint("TOP", WeaponSetsCollectionFrame.RightFrame.DetailsFrame, "TOP", -25, 0);
          WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame:SetScript("OnMouseDown", function(self)
                  if ( IsModifiedClick("CHATLINK") ) then
                    local link = C_TransmogCollection.GetAppearanceSourceInfo(self.sourceID).itemLink;
                    if not ChatEdit_InsertLink(link) then
                      ChatFrame_OpenChat(link);
                    end
                  elseif ( IsModifiedClick("DRESSUP") ) then
                    DressUpVisual(self.sourceID);
                  end
                  --help for filling in weapon db test
                  if app.devMode then
                    --print(self.sourceID);
                    TmogItemSource(self.sourceID);
                  end
        end)
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame:SetHyperlinksEnabled(true);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame:SetScript("OnHyperlinkClick", function(self, link, text, button)
                SetItemRef(link, text, button, self)
              end)
    --WeaponSetsCollectionFrame.RightFrame.DetailsFrame:SetScript("OnHyperlinkEnter", function(self, link, text)
    --            GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
    --            GameTooltip:SetHyperlink(link);
    --            GameTooltip:Show();
    --          end)
    --WeaponSetsCollectionFrame.RightFrame.DetailsFrame:SetScript("OnHyperlinkLeave", function(self, link, text)
    --            GameTooltip:Hide();
    --          end)
    
    --remix icon below the item icon
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.RemixIcon = CreateFrame("frame", nil, WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.RemixIcon:SetPoint("LEFT",WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame,"RIGHT",2,0);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.RemixIcon:SetSize(25,25);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.RemixIcon.Icon = WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.RemixIcon:CreateTexture(nil, "OVERLAY");
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.RemixIcon.Icon:SetAllPoints();
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.RemixIcon.Icon:SetDrawLayer("OVERLAY", 2);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.RemixIcon.Icon:SetTexture([[Interface\Addons\BetterWardrobe\WeaponSets\textures\Remix_icon_vert.tga]]);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.RemixIcon.Icon:SetAlpha(0.5);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.RemixIcon.Text = app.GetLocalizedString("MoPRemixExclusive");
    
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.RemixIcon:SetScript("OnEnter", function(self)
              GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
              GameTooltip_SetTitle(GameTooltip, self.Text, NORMAL_FONT_COLOR, true);
              GameTooltip:Show();
        end);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.RemixIcon:SetScript("OnLeave", function(self)
              GameTooltip:Hide();
        end);
        
    --legion remix icon below the item icon
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.LegionRemixIcon = CreateFrame("frame", nil, WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.LegionRemixIcon:SetPoint("LEFT",WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame,"RIGHT",2,0);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.LegionRemixIcon:SetSize(25,25);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.LegionRemixIcon.Icon = WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.LegionRemixIcon:CreateTexture(nil, "OVERLAY");
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.LegionRemixIcon.Icon:SetAllPoints();
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.LegionRemixIcon.Icon:SetDrawLayer("OVERLAY", 2);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.LegionRemixIcon.Icon:SetTexture([[Interface\Addons\BetterWardrobe\WeaponSets\textures\Remix_legion_icon_vert.tga]]);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.LegionRemixIcon.Icon:SetAlpha(0.5);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.LegionRemixIcon.Text = app.GetLocalizedString("LegRemixExclusive");
    
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.LegionRemixIcon:SetScript("OnEnter", function(self)
              GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
              GameTooltip_SetTitle(GameTooltip, self.Text, NORMAL_FONT_COLOR, true);
              GameTooltip:Show();
        end);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.LegionRemixIcon:SetScript("OnLeave", function(self)
              GameTooltip:Hide();
        end);
    
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Name = WeaponSetsCollectionFrame.RightFrame.DetailsFrame:CreateFontString(nil, "OVERLAY", "Fancy24Font");
    Mixin(WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Name,ShrinkUntilTruncateFontStringMixin);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Name:SetFontObjectsToTry("Fancy24Font","Fancy16Font");
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Name:SetPoint("TOP", WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame, "BOTTOM", 0, -5);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Name:SetWidth(WeaponSetsCollectionFrame.RightFrame.DetailsFrame:GetWidth());
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Label = WeaponSetsCollectionFrame.RightFrame.DetailsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLeftGrey");
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Label:SetPoint("TOP", WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Name, "BOTTOM", 0, -5);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Label2 = WeaponSetsCollectionFrame.RightFrame.DetailsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLeftGrey");
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Label2:SetPoint("TOP", WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Label, "BOTTOM", 0, -5);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Label2:SetTextColor(.55,.55,.7);
    
    --large remix icon in bottom right corner of frame
    WeaponSetsCollectionFrame.RightFrame.RemixIcon = CreateFrame("frame", nil, WeaponSetsCollectionFrame.RightFrame);
    WeaponSetsCollectionFrame.RightFrame.RemixIcon:SetPoint("BOTTOMRIGHT",WeaponSetsCollectionFrame.RightFrame,"BOTTOMRIGHT",-2,1);
    WeaponSetsCollectionFrame.RightFrame.RemixIcon:SetSize(200,200);
    WeaponSetsCollectionFrame.RightFrame.RemixIcon.Icon = WeaponSetsCollectionFrame.RightFrame.RemixIcon:CreateTexture(nil, "OVERLAY");
    WeaponSetsCollectionFrame.RightFrame.RemixIcon.Icon:SetAllPoints();
    WeaponSetsCollectionFrame.RightFrame.RemixIcon.Icon:SetDrawLayer("BACKGROUND", 2);
    WeaponSetsCollectionFrame.RightFrame.RemixIcon.Icon:SetTexture([[Interface\Addons\BetterWardrobe\WeaponSets\textures\Remix_icon_large.tga]]);
    WeaponSetsCollectionFrame.RightFrame.RemixIcon.Icon:SetAlpha(0.2);
    
    --large remix icon in bottom right corner of frame
    WeaponSetsCollectionFrame.RightFrame.LegionRemixIcon = CreateFrame("frame", nil, WeaponSetsCollectionFrame.RightFrame);
    WeaponSetsCollectionFrame.RightFrame.LegionRemixIcon:SetPoint("BOTTOMRIGHT",WeaponSetsCollectionFrame.RightFrame,"BOTTOMRIGHT",-2,1);
    WeaponSetsCollectionFrame.RightFrame.LegionRemixIcon:SetSize(200,200);
    WeaponSetsCollectionFrame.RightFrame.LegionRemixIcon.Icon = WeaponSetsCollectionFrame.RightFrame.LegionRemixIcon:CreateTexture(nil, "OVERLAY");
    WeaponSetsCollectionFrame.RightFrame.LegionRemixIcon.Icon:SetAllPoints();
    WeaponSetsCollectionFrame.RightFrame.LegionRemixIcon.Icon:SetDrawLayer("BACKGROUND", 2);
    WeaponSetsCollectionFrame.RightFrame.LegionRemixIcon.Icon:SetTexture([[Interface\Addons\BetterWardrobe\WeaponSets\textures\Remix_legion_icon_large.tga]]);
    WeaponSetsCollectionFrame.RightFrame.LegionRemixIcon.Icon:SetAlpha(0.2);

  --test temp
  if app.devMode then
      WeaponSetsCollectionFrame.RightFrame.indexText = WeaponSetsCollectionFrame.RightFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
      WeaponSetsCollectionFrame.RightFrame.indexText:SetPoint("RIGHT",WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame,"LEFT",-15,0);
      WeaponSetsCollectionFrame.RightFrame.indexText:SetSize(75, 10);
      WeaponSetsCollectionFrame.RightFrame.indexText:SetJustifyH("LEFT");
      WeaponSetsCollectionFrame.RightFrame.indexText:SetText("Hi");
      WeaponSetsCollectionFrame.RightFrame.itemTooltipTest = CreateFrame("Button", nil, WeaponSetsCollectionFrame.RightFrame);
      WeaponSetsCollectionFrame.RightFrame.itemTooltipTest:SetPoint("BOTTOMRIGHT", WeaponSetsCollectionFrame.RightFrame, "BOTTOMRIGHT", -5, 50);
      WeaponSetsCollectionFrame.RightFrame.itemTooltipTest:SetSize(26, 26);
      WeaponSetsCollectionFrame.RightFrame.itemTooltipTest:SetScript("OnEnter", function(self)
                  GameTooltip:SetOwner(self, "ANCHOR_LEFT");
                  
      local aSource = WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[WeaponSetsCollectionFrame.RightFrame.activeWeapon].activeSource;
      if not WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[WeaponSetsCollectionFrame.RightFrame.activeWeapon].sources[aSource] then
        GameTooltip:SetText("Nope.");
      else
      local weaponSourceID = WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[WeaponSetsCollectionFrame.RightFrame.activeWeapon].sources[aSource][2];
      
                    local appSource = C_TransmogCollection.GetAllAppearanceSources(app.AppID(weaponSourceID))[1]
                    local appInfo = C_TransmogCollection.GetAppearanceSourceInfo(appSource);
                    GameTooltip:SetHyperlink(appInfo.itemLink);
                  end
                  GameTooltip:Show();
          end)
        WeaponSetsCollectionFrame.RightFrame.itemTooltipTest:SetScript("OnLeave", function(self)
                  GameTooltip:Hide();
          end)
        WeaponSetsCollectionFrame.RightFrame.itemTooltipTest.tex = WeaponSetsCollectionFrame.RightFrame.itemTooltipTest:CreateTexture();
        WeaponSetsCollectionFrame.RightFrame.itemTooltipTest.tex:SetAllPoints(WeaponSetsCollectionFrame.RightFrame.itemTooltipTest);
        WeaponSetsCollectionFrame.RightFrame.itemTooltipTest.tex:SetColorTexture(1,1,1,1);
  end
  --test
    
    
    WeaponSetsCollectionFrame.RightFrame.ResetRotation = CreateFrame("Button", nil, WeaponSetsCollectionFrame.RightFrame);
    WeaponSetsCollectionFrame.RightFrame.ResetRotation.inPose = false;
    WeaponSetsCollectionFrame.RightFrame.ResetRotation:SetPoint("TOPRIGHT", WeaponSetsCollectionFrame.RightFrame, "TOPRIGHT", -5, -50);
    WeaponSetsCollectionFrame.RightFrame.ResetRotation:SetSize(26, 26);
    WeaponSetsCollectionFrame.RightFrame.ResetRotation:SetScript("OnMouseDown", function(self)
              PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
              if WeaponSetsCollectionFrame.RightFrame.Model.isPlayer then
                ResetPlayerRotations();
              else
                ResetWeapon();
              end
      end)
    WeaponSetsCollectionFrame.RightFrame.ResetRotation:SetScript("OnEnter", function(self)
              GameTooltip:SetOwner(self, "ANCHOR_LEFT");
              GameTooltip:SetText(app.GetLocalizedString("ResetPosAndRot"));
              GameTooltip:Show();
      end)
    WeaponSetsCollectionFrame.RightFrame.ResetRotation:SetScript("OnLeave", function(self)
              GameTooltip:Hide();
      end)
    WeaponSetsCollectionFrame.RightFrame.ResetRotation.tex = WeaponSetsCollectionFrame.RightFrame.ResetRotation:CreateTexture();
    WeaponSetsCollectionFrame.RightFrame.ResetRotation.tex:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.RightFrame.ResetRotation, "TOPLEFT", 3,-3);
    WeaponSetsCollectionFrame.RightFrame.ResetRotation.tex:SetPoint("BOTTOMRIGHT", WeaponSetsCollectionFrame.RightFrame.ResetRotation, "BOTTOMRIGHT", -1,1);
    
    WeaponSetsCollectionFrame.RightFrame.ResetRotation.tex:SetTexture([[Interface\Addons\BetterWardrobe\WeaponSets\textures\weapon_icons.tga]]);
    WeaponSetsCollectionFrame.RightFrame.ResetRotation.tex:SetTexCoord(200/256,250/256,200/256,250/256);
    WeaponSetsCollectionFrame.RightFrame.ResetRotation.backTex = WeaponSetsCollectionFrame.RightFrame.ResetRotation:CreateTexture(nil, "BACKGROUND");
    WeaponSetsCollectionFrame.RightFrame.ResetRotation.backTex:SetAllPoints(WeaponSetsCollectionFrame.RightFrame.ResetRotation);
    WeaponSetsCollectionFrame.RightFrame.ResetRotation.backTex:SetTexture([[Interface\Addons\BetterWardrobe\WeaponSets\textures\weapon_icons.tga]]);
    WeaponSetsCollectionFrame.RightFrame.ResetRotation.backTex:SetTexCoord(.78125,.9765625,.5859375,.78125);
    WeaponSetsCollectionFrame.RightFrame.ResetRotation.backTex:SetVertexColor(0.80,0.78,0.35,0.45);
    
    
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem = CreateFrame("Button", nil, WeaponSetsCollectionFrame.RightFrame);
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem:SetPoint("TOP", WeaponSetsCollectionFrame.RightFrame.ResetRotation, "BOTTOM", 0, -3);
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem:SetSize(26, 26);
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem:SetScript("OnMouseDown", function(self)
              PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
              SwapPlayerItem();
              if WeaponSetsCollectionFrame.RightFrame.Model.isPlayer then
                GameTooltip:SetText(app.GetLocalizedString("SwapToOnlyWep"));
                
                if not ElvUI then
                  WeaponSetsCollectionFrame.RightFrame.SwapPose.tex:SetVertexColor(1,1,1,1);
                  WeaponSetsCollectionFrame.RightFrame.SwapPose.backTex:SetVertexColor(0.80,0.78,0.35,0.45);
                  
                  WeaponSetsCollectionFrame.RightFrame.dualWield.tex:SetVertexColor(1,1,1,1);
                  WeaponSetsCollectionFrame.RightFrame.dualWield.backTex:SetVertexColor(0.80,0.78,0.35,0.45);
                else
                  WeaponSetsCollectionFrame.RightFrame.SwapPose.tex:SetVertexColor(1,1,1,1);
                  WeaponSetsCollectionFrame.RightFrame.SwapPose.backTex:SetVertexColor(0.60,0.6,0.6,0.45);
                  
                  WeaponSetsCollectionFrame.RightFrame.dualWield.tex:SetVertexColor(1,1,1,1);
                  WeaponSetsCollectionFrame.RightFrame.dualWield.backTex:SetVertexColor(0.6,0.6,0.6,0.45);
                end
              else
                GameTooltip:SetText(app.GetLocalizedString("SwapToPlayerWithWep"));
                
                if not ElvUI then
                  WeaponSetsCollectionFrame.RightFrame.SwapPose.tex:SetVertexColor(1,.9,.9,0.4);
                  WeaponSetsCollectionFrame.RightFrame.SwapPose.backTex:SetVertexColor(0.80,0.68,0.25,0.20);
                  
                  WeaponSetsCollectionFrame.RightFrame.dualWield.tex:SetVertexColor(1,.9,.9,0.4);
                  WeaponSetsCollectionFrame.RightFrame.dualWield.backTex:SetVertexColor(0.80,0.68,0.25,0.20);
                else
                  WeaponSetsCollectionFrame.RightFrame.SwapPose.tex:SetVertexColor(1,.9,.9,0.4);
                  WeaponSetsCollectionFrame.RightFrame.SwapPose.backTex:SetVertexColor(0.6,0.6,0.6,0.20);
                  
                  WeaponSetsCollectionFrame.RightFrame.dualWield.tex:SetVertexColor(1,.9,.9,0.4);
                  WeaponSetsCollectionFrame.RightFrame.dualWield.backTex:SetVertexColor(0.6,0.6,0.6,0.20);
                end
              end
      end)
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem:SetScript("OnEnter", function(self)
              GameTooltip:SetOwner(self, "ANCHOR_LEFT");
              if WeaponSetsCollectionFrame.RightFrame.Model.isPlayer then
                GameTooltip:SetText(app.GetLocalizedString("SwapToOnlyWep"));
              else
                GameTooltip:SetText(app.GetLocalizedString("SwapToPlayerWithWep"));
              end
              GameTooltip:Show();
      end)
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem:SetScript("OnLeave", function(self)
              GameTooltip:Hide();
      end)
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem.tex = WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem:CreateTexture();
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem.tex:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem, "TOPLEFT", 4,-3);
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem.tex:SetPoint("BOTTOMRIGHT", WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem, "BOTTOMRIGHT", -1,2);
    
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem.tex:SetTexture([[Interface\Addons\BetterWardrobe\WeaponSets\textures\weapon_icons.tga]]);
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem.tex:SetTexCoord(100/256,150/256,200/256,250/256);
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem.backTex = WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem:CreateTexture(nil, "BACKGROUND");
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem.backTex:SetAllPoints(WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem);
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem.backTex:SetTexture([[Interface\Addons\BetterWardrobe\WeaponSets\textures\weapon_icons.tga]]);
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem.backTex:SetTexCoord(.78125,.9765625,.5859375,.78125);
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem.backTex:SetVertexColor(0.80,0.78,0.35,0.45);
    
      
      
    WeaponSetsCollectionFrame.RightFrame.SwapPose = CreateFrame("Button", nil, WeaponSetsCollectionFrame.RightFrame);
    WeaponSetsCollectionFrame.RightFrame.SwapPose.inPose = false;
    WeaponSetsCollectionFrame.RightFrame.SwapPose:SetPoint("TOP", WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem, "BOTTOM", 0, -3);
    WeaponSetsCollectionFrame.RightFrame.SwapPose:SetSize(26, 26);
    WeaponSetsCollectionFrame.RightFrame.SwapPose:SetScript("OnMouseDown", function(self)
              if not WeaponSetsCollectionFrame.RightFrame.Model.isPlayer then return; end
              PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
              WeaponSetsCollectionFrame.RightFrame.SwapPose.inPose = not WeaponSetsCollectionFrame.RightFrame.SwapPose.inPose;
              SetPose();
              if WeaponSetsCollectionFrame.RightFrame.SwapPose.inPose then
                GameTooltip:SetText(app.GetLocalizedString("SetIdlePose"));
              else
                GameTooltip:SetText(app.GetLocalizedString("SetActionPose"));
              end
      end)
    WeaponSetsCollectionFrame.RightFrame.SwapPose:SetScript("OnEnter", function(self)
              if not WeaponSetsCollectionFrame.RightFrame.Model.isPlayer then return; end
              GameTooltip:SetOwner(self, "ANCHOR_LEFT");
              if WeaponSetsCollectionFrame.RightFrame.SwapPose.inPose then
                GameTooltip:SetText(app.GetLocalizedString("SetIdlePose"));
              else
                GameTooltip:SetText(app.GetLocalizedString("SetActionPose"));
              end
              GameTooltip:Show();
      end)
    WeaponSetsCollectionFrame.RightFrame.SwapPose:SetScript("OnLeave", function(self)
              GameTooltip:Hide();
      end)
    WeaponSetsCollectionFrame.RightFrame.SwapPose.tex = WeaponSetsCollectionFrame.RightFrame.SwapPose:CreateTexture();
    --WeaponSetsCollectionFrame.RightFrame.SwapPose.tex:SetAllPoints(WeaponSetsCollectionFrame.RightFrame.SwapPose);
    WeaponSetsCollectionFrame.RightFrame.SwapPose.tex:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.RightFrame.SwapPose, "TOPLEFT", 3,-3);
    WeaponSetsCollectionFrame.RightFrame.SwapPose.tex:SetPoint("BOTTOMRIGHT", WeaponSetsCollectionFrame.RightFrame.SwapPose, "BOTTOMRIGHT", -2,2);
    
    WeaponSetsCollectionFrame.RightFrame.SwapPose.tex:SetTexture([[Interface\Addons\BetterWardrobe\WeaponSets\textures\weapon_icons.tga]]);
    WeaponSetsCollectionFrame.RightFrame.SwapPose.tex:SetTexCoord(150/256,200/256,200/256,250/256);
    WeaponSetsCollectionFrame.RightFrame.SwapPose.backTex = WeaponSetsCollectionFrame.RightFrame.SwapPose:CreateTexture(nil, "BACKGROUND");
    WeaponSetsCollectionFrame.RightFrame.SwapPose.backTex:SetAllPoints(WeaponSetsCollectionFrame.RightFrame.SwapPose);
    WeaponSetsCollectionFrame.RightFrame.SwapPose.backTex:SetTexture([[Interface\Addons\BetterWardrobe\WeaponSets\textures\weapon_icons.tga]]);
    WeaponSetsCollectionFrame.RightFrame.SwapPose.backTex:SetTexCoord(.78125,.9765625,.5859375,.78125);
    WeaponSetsCollectionFrame.RightFrame.SwapPose.backTex:SetVertexColor(0.80,0.78,0.35,0.45);
    
    
    WeaponSetsCollectionFrame.RightFrame.dualWield = CreateFrame("Button", nil, WeaponSetsCollectionFrame.RightFrame);
    WeaponSetsCollectionFrame.RightFrame.dualWield.inPose = false;
    WeaponSetsCollectionFrame.RightFrame.dualWield:SetPoint("TOP", WeaponSetsCollectionFrame.RightFrame.SwapPose, "BOTTOM", 0, -3);
    WeaponSetsCollectionFrame.RightFrame.dualWield:SetSize(26, 26);
    WeaponSetsCollectionFrame.RightFrame.dualWield:SetScript("OnMouseDown", function(self)
              if not WeaponSetsCollectionFrame.RightFrame.Model.isPlayer then return; end
              PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
              ExS_Settings.showDualWielding = not ExS_Settings.showDualWielding;
              if WeaponSetsCollectionFrame.RightFrame.Model.isPlayer then
                EquipWeapon();
              end
              if ExS_Settings.showDualWielding then
                GameTooltip:SetText(app.GetLocalizedString("WepOnlyMainHand"));
                WeaponSetsCollectionFrame.RightFrame.dualWield.tex:SetTexCoord(0,50/256,200/256,250/256);
              else
                GameTooltip:SetText(app.GetLocalizedString("WepInBothHands"));
                WeaponSetsCollectionFrame.RightFrame.dualWield.tex:SetTexCoord(200/256,250/256,100/256,150/256);
              end
      end)
    WeaponSetsCollectionFrame.RightFrame.dualWield:SetScript("OnEnter", function(self)
              if not WeaponSetsCollectionFrame.RightFrame.Model.isPlayer then return; end
              GameTooltip:SetOwner(self, "ANCHOR_LEFT");
              if ExS_Settings.showDualWielding then
                GameTooltip:SetText(app.GetLocalizedString("WepOnlyMainHand"));
              else
                GameTooltip:SetText(app.GetLocalizedString("WepInBothHands"));
              end
              GameTooltip:Show();
      end)
    WeaponSetsCollectionFrame.RightFrame.dualWield:SetScript("OnLeave", function(self)
              GameTooltip:Hide();
      end)
      
    WeaponSetsCollectionFrame.RightFrame.dualWield.tex = WeaponSetsCollectionFrame.RightFrame.dualWield:CreateTexture();
    --WeaponSetsCollectionFrame.RightFrame.dualWield.tex:SetAllPoints(WeaponSetsCollectionFrame.RightFrame.dualWield);
    WeaponSetsCollectionFrame.RightFrame.dualWield.tex:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.RightFrame.dualWield, "TOPLEFT", 3,-3);
    WeaponSetsCollectionFrame.RightFrame.dualWield.tex:SetPoint("BOTTOMRIGHT", WeaponSetsCollectionFrame.RightFrame.dualWield, "BOTTOMRIGHT", -2,2);
    
    WeaponSetsCollectionFrame.RightFrame.dualWield.tex:SetTexture([[Interface\Addons\BetterWardrobe\WeaponSets\textures\weapon_icons.tga]]);
    if ExS_Settings.showDualWielding then
      WeaponSetsCollectionFrame.RightFrame.dualWield.tex:SetTexCoord(0,50/256,200/256,250/256);
    else
      WeaponSetsCollectionFrame.RightFrame.dualWield.tex:SetTexCoord(200/256,250/256,100/256,150/256);
    end
    WeaponSetsCollectionFrame.RightFrame.dualWield.backTex = WeaponSetsCollectionFrame.RightFrame.dualWield:CreateTexture(nil, "BACKGROUND");
    WeaponSetsCollectionFrame.RightFrame.dualWield.backTex:SetAllPoints(WeaponSetsCollectionFrame.RightFrame.dualWield);
    WeaponSetsCollectionFrame.RightFrame.dualWield.backTex:SetTexture([[Interface\Addons\BetterWardrobe\WeaponSets\textures\weapon_icons.tga]]);
    WeaponSetsCollectionFrame.RightFrame.dualWield.backTex:SetTexCoord(.78125,.9765625,.5859375,.78125);
    WeaponSetsCollectionFrame.RightFrame.dualWield.backTex:SetVertexColor(0.80,0.78,0.35,0.45);
    
    
    ----Model
    WeaponSetsCollectionFrame.RightFrame.Model = CreateFrame("DressUpModel", nil, WeaponSetsCollectionFrame.RightFrame, "ModelTemplate");
    WeaponSetsCollectionFrame.RightFrame.Model:SetSize(WeaponSetsCollectionFrame.RightFrame.DetailsFrame:GetWidth() + 75, WeaponSetsCollectionFrame.RightFrame:GetHeight() - 50);
    WeaponSetsCollectionFrame.RightFrame.Model:SetPoint("CENTER", WeaponSetsCollectionFrame.RightFrame.DetailsFrame, "CENTER", -25, -WeaponSetsCollectionFrame.RightFrame.Model:GetHeight() * 0.5 + 15);
    WeaponSetsCollectionFrame.RightFrame.Model:SetScript("OnUpdate", ModelOnUpdate);
    WeaponSetsCollectionFrame.RightFrame.Model.PostMouseDown = ModelPostMouseDown;
    --WeaponSetsCollectionFrame.RightFrame.Model.PostMouseUp = ModelPostMouseUp;
    WeaponSetsCollectionFrame.RightFrame.Model.pitch = 0;
    WeaponSetsCollectionFrame.RightFrame.Model.roll = 0;
    WeaponSetsCollectionFrame.RightFrame.Model.isPlayer = true;
    --WeaponSetsCollectionFrame.RightFrame.Model:SetUnit("player");
    WeaponSetsCollectionFrame.RightFrame.Model:SetUnit("player", false, not select(2,C_PlayerInfo.GetAlternateFormInfo()));
    if ExS_Settings.wepUndressModel then
      WeaponSetsCollectionFrame.RightFrame.Model:Undress();
    else
      WeaponSetsCollectionFrame.RightFrame.Model:Dress();
    end
    WeaponSetsCollectionFrame.initUndress = true;
    
    --C_Timer.After(0, function() WeaponSetsCollectionFrame.RightFrame.Model:Dress(); end)
    
    RemoveWeapons();
    WeaponSetsCollectionFrame.RightFrame.Model:SetScript("OnMouseWheel", function(self, delta, maxZoom, minZoom)
        if not WeaponSetsCollectionFrame.RightFrame.Model.isPlayer then
          WeaponZoom(delta > 0);
        else
          maxZoom = maxZoom or WeaponSetsCollectionFrame.RightFrame.Model.maxZoom;
          minZoom = minZoom or WeaponSetsCollectionFrame.RightFrame.Model.minZoom;
          local zoomLevel = WeaponSetsCollectionFrame.RightFrame.Model.zoomLevel or minZoom;
          zoomLevel = zoomLevel + delta * MODELFRAME_ZOOM_STEP;
          zoomLevel = min(zoomLevel, maxZoom);
          zoomLevel = max(zoomLevel, minZoom);
          WeaponSetsCollectionFrame.RightFrame.Model:SetPortraitZoom(zoomLevel);
          WeaponSetsCollectionFrame.RightFrame.Model.zoomLevel = zoomLevel;
        end
      end)
    
    WeaponSetsCollectionFrame.RightFrame.Model:SetScript("OnShow", function()
          C_Timer.After(0, function()
            if WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet and WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet ~= 0 then
              WeaponSetsCollectionFrame.RightFrame.Model:SetUnit("player", false, not select(2,C_PlayerInfo.GetAlternateFormInfo()));
              if ExS_Settings.wepUndressModel then
                WeaponSetsCollectionFrame.RightFrame.Model:Undress();
              else
                WeaponSetsCollectionFrame.RightFrame.Model:Dress();
              end
              WeaponSetsCollectionFrame.initUndress = true;
    
              SelectWeapon();
            end
          end)
      end)  
    
    app.ExS_AH_Init_Wep();
    -- BetterWardrobe owns tab navigation in the embedded build.
    --WardrobeCollectionFrame.OnLoad = ExW_OnLoad;
    
    
    
    --WeaponSetsCollectionFrame.RightFrame.Model.animation = 1;
    --WeaponSetsCollectionFrame.RightFrame.Model.frame = 1;
    --WeaponSetsCollectionFrame.RightFrame.Model.playerText = WeaponSetsCollectionFrame.RightFrame.Model:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    --WeaponSetsCollectionFrame.RightFrame.Model.playerText:SetPoint("BOTTOM", WeaponSetsCollectionFrame.RightFrame, "BOTTOM", 150, -30)
    --WeaponSetsCollectionFrame.RightFrame.Model.playerFrameText = WeaponSetsCollectionFrame.RightFrame.Model:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    --WeaponSetsCollectionFrame.RightFrame.Model.playerFrameText:SetPoint("BOTTOM", WeaponSetsCollectionFrame.RightFrame, "BOTTOM", 150, -50)
    --
    --WeaponSetsCollectionFrame.RightFrame.Model.play = CreateFrame("Button", nil, WeaponSetsCollectionFrame.RightFrame);
    --WeaponSetsCollectionFrame.RightFrame.Model.play:SetPoint("BOTTOM", WeaponSetsCollectionFrame.RightFrame, "BOTTOM", -10, -40);
    --WeaponSetsCollectionFrame.RightFrame.Model.play:SetSize(35, 35);
    --WeaponSetsCollectionFrame.RightFrame.Model.play.tex = WeaponSetsCollectionFrame.RightFrame.Model.play:CreateTexture();
    --WeaponSetsCollectionFrame.RightFrame.Model.play.tex:SetAllPoints(WeaponSetsCollectionFrame.RightFrame.Model.play);
    --WeaponSetsCollectionFrame.RightFrame.Model.play.tex:SetColorTexture(.1,1,.1,.5);
    --WeaponSetsCollectionFrame.RightFrame.Model.play:SetScript("OnMouseDown", function(self)
    --        if WeaponSetsCollectionFrame.RightFrame.Model:HasAnimation(WeaponSetsCollectionFrame.RightFrame.Model.animation) then
    --          WeaponSetsCollectionFrame.RightFrame.Model:SetAnimation(WeaponSetsCollectionFrame.RightFrame.Model.animation);
    --        end
    --        WeaponSetsCollectionFrame.RightFrame.Model.playerText:SetText(WeaponSetsCollectionFrame.RightFrame.Model.animation);
    --        WeaponSetsCollectionFrame.RightFrame.Model.frame = 1;
    --  end) 
    --  
    --  
    --WeaponSetsCollectionFrame.RightFrame.Model.next = CreateFrame("Button", nil, WeaponSetsCollectionFrame.RightFrame);
    --WeaponSetsCollectionFrame.RightFrame.Model.next:SetPoint("BOTTOM", WeaponSetsCollectionFrame.RightFrame, "BOTTOM", 30, -40);
    --WeaponSetsCollectionFrame.RightFrame.Model.next:SetSize(35, 35);
    --WeaponSetsCollectionFrame.RightFrame.Model.next.tex = WeaponSetsCollectionFrame.RightFrame.Model.next:CreateTexture();
    --WeaponSetsCollectionFrame.RightFrame.Model.next.tex:SetAllPoints(WeaponSetsCollectionFrame.RightFrame.Model.next);
    --WeaponSetsCollectionFrame.RightFrame.Model.next.tex:SetColorTexture(.1,.1,1,.5);
    --WeaponSetsCollectionFrame.RightFrame.Model.next:SetScript("OnMouseDown", function(self, button)
    --        if button == "LeftButton" then
    --          WeaponSetsCollectionFrame.RightFrame.Model.animation = WeaponSetsCollectionFrame.RightFrame.Model.animation + 1;
    --        else
    --          WeaponSetsCollectionFrame.RightFrame.Model.animation = WeaponSetsCollectionFrame.RightFrame.Model.animation - 1;
    --        end
    --        local test = 0;
    --        while not WeaponSetsCollectionFrame.RightFrame.Model:HasAnimation(WeaponSetsCollectionFrame.RightFrame.Model.animation) and test < 100 do
    --          
    --          if button == "LeftButton" then
    --            WeaponSetsCollectionFrame.RightFrame.Model.animation = WeaponSetsCollectionFrame.RightFrame.Model.animation + 1;
    --          else
    --            WeaponSetsCollectionFrame.RightFrame.Model.animation = WeaponSetsCollectionFrame.RightFrame.Model.animation - 1;
    --          end
    --          test = test + 1;
    --        end
    --        if WeaponSetsCollectionFrame.RightFrame.Model:HasAnimation(WeaponSetsCollectionFrame.RightFrame.Model.animation) then
    --          WeaponSetsCollectionFrame.RightFrame.Model:SetAnimation(WeaponSetsCollectionFrame.RightFrame.Model.animation);
    --        end
    --        WeaponSetsCollectionFrame.RightFrame.Model.playerText:SetText(WeaponSetsCollectionFrame.RightFrame.Model.animation);
    --        WeaponSetsCollectionFrame.RightFrame.Model.frame = 1;
    --  end) 
    --
    --  
    --WeaponSetsCollectionFrame.RightFrame.Model.prevStep = CreateFrame("Button", nil, WeaponSetsCollectionFrame.RightFrame);
    --WeaponSetsCollectionFrame.RightFrame.Model.prevStep:SetPoint("BOTTOM", WeaponSetsCollectionFrame.RightFrame, "BOTTOM", 70, -40);
    --WeaponSetsCollectionFrame.RightFrame.Model.prevStep:SetSize(35, 35);
    --WeaponSetsCollectionFrame.RightFrame.Model.prevStep.tex = WeaponSetsCollectionFrame.RightFrame.Model.prevStep:CreateTexture();
    --WeaponSetsCollectionFrame.RightFrame.Model.prevStep.tex:SetAllPoints(WeaponSetsCollectionFrame.RightFrame.Model.prevStep);
    --WeaponSetsCollectionFrame.RightFrame.Model.prevStep.tex:SetColorTexture(1,.1,.1,.5);
    --WeaponSetsCollectionFrame.RightFrame.Model.prevStep:SetScript("OnMouseDown", function(self, button)
    --        if WeaponSetsCollectionFrame.RightFrame.Model:HasAnimation(WeaponSetsCollectionFrame.RightFrame.Model.animation) then
    --          if button == "LeftButton" then
    --            WeaponSetsCollectionFrame.RightFrame.Model.frame = WeaponSetsCollectionFrame.RightFrame.Model.frame + 1;
    --          else
    --            WeaponSetsCollectionFrame.RightFrame.Model.frame = WeaponSetsCollectionFrame.RightFrame.Model.frame - 1;
    --          end
    --          if WeaponSetsCollectionFrame.RightFrame.Model.frame == -2 then
    --            WeaponSetsCollectionFrame.RightFrame.Model.frame = 0;
    --          end
    --          WeaponSetsCollectionFrame.RightFrame.Model:FreezeAnimation(WeaponSetsCollectionFrame.RightFrame.Model.animation, 0, WeaponSetsCollectionFrame.RightFrame.Model.frame);
    --          WeaponSetsCollectionFrame.RightFrame.Model.playerText:SetText(WeaponSetsCollectionFrame.RightFrame.Model.animation);
    --          WeaponSetsCollectionFrame.RightFrame.Model.playerFrameText:SetText(WeaponSetsCollectionFrame.RightFrame.Model.frame);
    --        end
    --  end) 
    
    if ElvUI then
      local E = unpack(ElvUI);
      local S = E:GetModule('Skins')
      if WardrobeCollectionFrame.WeaponSetsTab then S:HandleTab(WardrobeCollectionFrame.WeaponSetsTab) end
      S:HandleButton(WeaponSetsCollectionFrame.LeftFrame.FilterButton)
      S:HandleButton(WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton)
      WeaponSetsCollectionFrame:SetTemplate('Transparent')
      WeaponSetsCollectionFrame.RightFrame:StripTextures()
      WeaponSetsCollectionFrame.LeftFrame:StripTextures()
      WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Name:FontTemplate(nil, 16)
      
      S:HandleEditBox(WeaponSetsCollectionFrame.LeftFrame.SearchBox)
      
      WeaponSetsCollectionFrame.RightFrame.SwapPose.backTex:SetVertexColor(0.60,0.6,0.6,0.45);
      WeaponSetsCollectionFrame.RightFrame.ResetRotation.backTex:SetVertexColor(0.60,0.6,0.6,0.45);
      WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem.backTex:SetVertexColor(0.60,0.6,0.6,0.45);
      WeaponSetsCollectionFrame.RightFrame.dualWield.backTex:SetVertexColor(0.60,0.6,0.6,0.45);
      
      --WeaponSetsCollectionFrame.RightFrame.ResetRotation:SetPoint("TOPRIGHT", WeaponSetsCollectionFrame.RightFrame, "TOPRIGHT", -5, -5);
    end
end

----
-- The frame setup.
----
WeaponSetsCollectionFrame:RegisterEvent("PLAYER_LOGIN");
WeaponSetsCollectionFrame:SetScript("OnEvent", function(pSelf, pEvent, pUnit, arg2, arg3, arg4)
  if pEvent == "PLAYER_LOGIN" then
    WardrobeCollectionFrame = BetterWardrobeCollectionFrame or WardrobeCollectionFrame
    if not WardrobeCollectionFrame then return end
    -- BetterWardrobe owns tab navigation in the embedded build.
    if ExS_Settings.hideWeaponsTab then return; end
    
    if not ExS_Settings.weaponExpansionToggles then
      ExS_Settings.weaponExpansionToggles = {}
      for i = 1,ExpansionCount do ExS_Settings.weaponExpansionToggles[i] = true; end
    end
    if ExS_Settings.weaponExpansionToggles[ExpansionCount] == nil then ExS_Settings.weaponExpansionToggles[ExpansionCount] = true; end
    if ExS_Settings.showDualWielding == nil then
      ExS_Settings.showDualWielding = false;
    end
    if ExS_Settings.stayOnWeaponType == nil then
      ExS_Settings.stayOnWeaponType = false;
    end
    if not ExS_Weapon_Favorites then
      ExS_Weapon_Favorites = {}
    end
    if not ExS_Settings.progressBarByFilter then
      ExS_Settings.progressBarByFilter = true;
    end
    if not ExS_Weapon_HiddenSets then
      ExS_Weapon_HiddenSets = {}
    end
    
    for i=1,#weaponType do
        local _,_,_,main,off = C_TransmogCollection.GetCategoryInfo(weaponType[i][6])
        weaponType[i][17] = main or off;
    end
    
    EventRegistry:RegisterCallback("SetItemRef", function(_, link, text, button, chatFrame)
        local linkType, addonName, linkData = strsplit(":", link)
        if linkType == "addon" and addonName == "ExS" then
            HandleWeaponSetLink(tonumber(linkData))
        end
    end)
    WeaponSetsCollectionFrame:RegisterEvent("TRANSMOG_COLLECTION_SOURCE_ADDED");
    
    --if not C_AddOns.IsAddOnLoaded("Blizzard_Collections") then
    --  C_AddOns.LoadAddOn("Blizzard_Collections")
    --end
    
    --_, factionNames.playerFaction = UnitFactionGroup('player');
    --if factionNames.playerFaction == app.GetLocalizedString("Alliance") then
    --  factionNames.opposingFaction = app.GetLocalizedString("Horde");
    --else
    --  factionNames.opposingFaction = app.GetLocalizedString("Alliance");
    --end
  
   --[[ 
    WardrobeCollectionFrame.WeaponSetsCollectionFrame = WeaponSetsCollectionFrame;
    WeaponSetsCollectionFrame:SetParent(WardrobeCollectionFrame);
    WeaponSetsCollectionFrame:SetPoint("BOTTOM", WardrobeCollectionFrame,"BOTTOM",0,5);
    local width,height = WardrobeCollectionFrame.ItemsCollectionFrame:GetSize();
    WeaponSetsCollectionFrame:SetSize(width,height);
    WeaponSetsCollectionFrame.SetAppearanceTooltip = SetAppearanceTooltip;
    WeaponSetsCollectionFrame.RefreshAppearanceTooltip = RefreshAppearanceTooltip;
    WeaponSetsCollectionFrame.SelectWeapon = SelectWeapon;
    WeaponSetsCollectionFrame.ScrollToOffset = ScrollToOffset;
    WeaponSetsCollectionFrame.UpdateProgressBar = UpdateProgressBar
    WeaponSetsCollectionFrame.GetCurrentSet = GetCurrentSet;
    WeaponSetsCollectionFrame.NewVisualIDs = {};
    WeaponSetsCollectionFrame:Hide();
    WeaponSetsCollectionFrame:SetScript("OnShow", function()
          FillWeaponSetMaps(false);
          WeaponSetsCollectionFrame.UpdateProgressBar();
          WeaponSetsCollectionFrame:RegisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE");
          WeaponSetsCollectionFrame:RegisterEvent("UNIT_FORM_CHANGED");
          --WeaponSetsCollectionFrame:RegisterEvent("TRANSMOG_COLLECTION_SOURCE_ADDED");
          WeaponSetsCollectionFrame:RegisterEvent("TRANSMOG_COLLECTION_SOURCE_REMOVED");
          if ExS_Settings.showHiddenSets then
            WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Icon:SetTexCoord(.5,1,0,1);
          else
            WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Icon:SetTexCoord(0,.5,0,1);
          end
      end)
    WeaponSetsCollectionFrame:SetScript("OnHide", function()
          WeaponSetsCollectionFrame:UnregisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE");
          WeaponSetsCollectionFrame:UnregisterEvent("UNIT_FORM_CHANGED");
      end)
    WardrobeCollectionFrame.WeaponSetsCollectionFrame.CanHandleKey = function(self,key)
              if key == WARDROBE_UP_VISUAL_KEY or key == WARDROBE_DOWN_VISUAL_KEY or key == WARDROBE_PREV_VISUAL_KEY or key == WARDROBE_NEXT_VISUAL_KEY then
                return true;
              end
              return false;
        end;
    WeaponSetsCollectionFrame.OnUnitModelChangedEvent = function()
          return;
      end
    
    WardrobeCollectionFrame.WeaponsTab = CreateFrame("Button", "WardrobeCollectionFrameTab3", WardrobeCollectionFrame, "PanelTopTabButtonTemplate");
    WardrobeCollectionFrame.WeaponsTab:SetText(app.GetLocalizedString("WepSets"));
    WardrobeCollectionFrame.WeaponsTab:SetPoint("LEFT", WardrobeCollectionFrameTab2, "RIGHT",0,0)
    WardrobeCollectionFrame.WeaponsTab:SetID(3)
    WardrobeCollectionFrame.WeaponsTab:SetAttribute("frameLevel",4)
    WardrobeCollectionFrame.WeaponsTab.minWidth = 57;
    WardrobeCollectionFrame.WeaponsTab:SetScript("OnClick", function()
            WardrobeCollectionFrame:ClickTab(WardrobeCollectionFrame.WeaponsTab);
      end)
    WardrobeCollectionFrame.Tabs[3] = WardrobeCollectionFrame.WeaponsTab;
    PanelTemplates_SetNumTabs(WardrobeCollectionFrame, 3)
    PanelTemplates_TabResize(WardrobeCollectionFrame.WeaponsTab, 0)
    
    WardrobeCollectionFrame.progressBar:SetWidth(WardrobeCollectionFrame.progressBar:GetWidth() * 0.6);
    WardrobeCollectionFrame.progressBar.border:SetWidth(WardrobeCollectionFrame.progressBar.border:GetWidth() * 0.6);
    WardrobeCollectionFrame.progressBar:ClearAllPoints()
    WardrobeCollectionFrame.progressBar:SetPoint("LEFT", "WardrobeCollectionFrameTab3", "RIGHT",15,-2)

    --Left (Scroll) frame
    WeaponSetsCollectionFrame.LeftFrame = CreateFrame("Frame", nil, WeaponSetsCollectionFrame, "InsetFrameTemplate");
    WeaponSetsCollectionFrame.LeftFrame:SetPoint("TOPLEFT", WeaponSetsCollectionFrame, "TOPLEFT");
    WeaponSetsCollectionFrame.LeftFrame:SetSize(200,  WeaponSetsCollectionFrame:GetHeight());
    
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, WeaponSetsCollectionFrame.LeftFrame, "HybridScrollFrameTemplate");
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.LeftFrame, "TOPLEFT", 3, -36);
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame:SetSize(WeaponSetsCollectionFrame.LeftFrame:GetWidth() - 5, 499);
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet = 0;
    
    local scrollBarScalar = 0.65;
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar = CreateFrame("Slider", nil, WeaponSetsCollectionFrame.LeftFrame.ScrollFrame, "HybridScrollBarTrimTemplate");
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:SetValueStep(1);
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:SetObeyStepOnDrag(true);
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.stepSize = 1;
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:SetWidth(20 * scrollBarScalar)
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.Top:SetSize(24 * scrollBarScalar, 48 * scrollBarScalar)
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.Top:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar, "TOPLEFT", -4 * scrollBarScalar, 17 * scrollBarScalar)
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.Bottom:SetSize(24 * scrollBarScalar, 64 * scrollBarScalar)
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.Bottom:SetPoint("BOTTOMLEFT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar, "BOTTOMLEFT", -4 * scrollBarScalar, -15 * scrollBarScalar)
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.UpButton:SetSize(18 * scrollBarScalar, 16 * scrollBarScalar)
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.DownButton:SetSize(18 * scrollBarScalar, 16 * scrollBarScalar)
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.thumbTexture:SetWidth(18 * scrollBarScalar);
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.thumbTexture:SetPoint("TOP",WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.trackBG,"TOP");
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.thumbTexture:Show();
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:SetPoint("TOPRIGHT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame, "TOPRIGHT", 0, -18 * scrollBarScalar);
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:SetPoint("BOTTOMRIGHT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame, "BOTTOMRIGHT", 0, 15 * scrollBarScalar);
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.trackBG:Show();
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.trackBG:SetVertexColor(0, 0, 0, 0.75);
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.doNotHide = true;
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.scrollValue = 1;
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:SetScript("OnValueChanged", function(self, val)
                self.scrollValue = val;
                
                self:GetParent():SetVerticalScroll(val/select(2,self:GetMinMaxValues()));
                local min,max = self:GetMinMaxValues()
                if val >= max then
                  self:GetParent().scrollDown:Disable();
                else
                  self:GetParent().scrollDown:Enable();
                end
                if val <= min then
                  self:GetParent().scrollUp:Disable();
                else
                  self:GetParent().scrollUp:Enable();
                end
                WeaponSets_ScrollFrame_Update();
              end);
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:SetValue(1);
    local mouseWheel = function(self, delta)
              if delta > 0 then
                if WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.scrollValue > 1 then
                  WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:SetValue(WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.scrollValue - 1);
                end
              else
                if WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.scrollValue < select(2,WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:GetMinMaxValues()) then
                  WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:SetValue(WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.scrollValue + 1);
                end
              end
        end
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar:SetScript("OnMouseWheel", mouseWheel);
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame:SetScript("OnMouseWheel", mouseWheel);
    local buttonOnUpdate = function(self, elapsed) 
                self.timeSinceLast = self.timeSinceLast + elapsed;
                if ( self.timeSinceLast >= ( self.updateInterval or 0.08 ) ) then
                  if ( not IsMouseButtonDown("LeftButton") ) then
                    self:SetScript("OnUpdate", nil);
                  elseif ( self:IsMouseOver() ) then
                    mouseWheel(nil, self.direction);
                    self.timeSinceLast = 0;
                  end
                end
        end
    local buttonOnClick = function(self,button,down)
              if ( down ) then
                self.timeSinceLast = (self.timeToStart or -0.2);
                self:SetScript("OnUpdate", buttonOnUpdate);
                mouseWheel(nil, self.direction);
                PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON);
              else
                self:SetScript("OnUpdate", nil);
              end
        end
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.UpButton:SetScript("OnClick", buttonOnClick)
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.Scrollbar.DownButton:SetScript("OnClick", buttonOnClick)
    --function to handle the up/down arrow keys to traverse the left list
    --                   the left/right arrow keys to traverse the weapon type list
    WardrobeCollectionFrame.WeaponSetsCollectionFrame.HandleKey = function(self,key)
              local index = GetIndexInSetList(WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet);
              
              if key == WARDROBE_UP_VISUAL_KEY then
                if index > 1 then ScrollToOffset(index - 1, true, true) end
              elseif key == WARDROBE_DOWN_VISUAL_KEY then
                if index < #setList then ScrollToOffset(index + 1, true, true) end
              elseif key == WARDROBE_PREV_VISUAL_KEY then
                local i = WeaponSetsCollectionFrame.RightFrame.activeWeapon;
                while i > 1 do
                  i = i - 1;
                  if not WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].disabled then
                    WeaponSetsCollectionFrame.RightFrame.activeWeapon = i;
                    SelectWeapon();
                    return;
                  end
                end
              elseif key == WARDROBE_NEXT_VISUAL_KEY then
                local i = WeaponSetsCollectionFrame.RightFrame.activeWeapon;
                while i < 17 do
                  i = i + 1;
                  if not WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i].disabled then
                    WeaponSetsCollectionFrame.RightFrame.activeWeapon = i;
                    SelectWeapon();
                    return;
                  end
                end
              end
        end;

    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons = {}
    for i = 1, 12 do
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i] = CreateFrame("BUTTON", "WeaponSetsScroll_button"..i, WeaponSetsCollectionFrame.LeftFrame.ScrollFrame, "WardrobeSetsScrollFrameButtonTemplate")
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i]:SetScript("OnClick", nil); --gets rid of an unwanted Blizzard interaction
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i]:SetSize(WeaponSetsCollectionFrame.LeftFrame.ScrollFrame:GetWidth() - 40 - (22 * scrollBarScalar), WeaponSetsCollectionFrame.LeftFrame.ScrollFrame:GetHeight() / 12);
      if i == 1 then
        WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i]:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame, "TOPLEFT", 40, 0);
      else
        WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i]:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i-1], "BOTTOMLEFT", 0, 0);
      end
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].IconFrame:SetPoint("LEFT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i], "LEFT", -38, 0);

      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].ProgressBars = { WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].ProgressBar };
      SET_PROGRESS_BAR_MAX_WIDTH = WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i]:GetWidth() - 5;
      
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].SelectedTexture:SetAtlas("GarrMission_ListGlow-Select");
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].SelectedTexture:SetVertexColor(1,1,1,0.6)
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].SelectedTexture:ClearAllPoints();
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].SelectedTexture:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i], "TOPLEFT", -13, -1)
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].SelectedTexture:SetPoint("TOPRIGHT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i], "TOPRIGHT", 13, -1)
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].SelectedTexture:SetPoint("BOTTOMLEFT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i], "LEFT", -13, -2)
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].SelectedTexture:SetPoint("BOTTOMRIGHT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i], "RIGHT", 13, -2)
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].HighlightTexture:SetAtlas("GarrMission_ListGlow-Highlight");
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].HighlightTexture:SetVertexColor(1,1,1,0.8)
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].HighlightTexture:ClearAllPoints();
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].HighlightTexture:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i], "TOPLEFT", -10, -1)
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].HighlightTexture:SetPoint("TOPRIGHT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i], "TOPRIGHT", 10, -1)
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].HighlightTexture:SetPoint("BOTTOMLEFT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i], "LEFT", -10, -2)
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].HighlightTexture:SetPoint("BOTTOMRIGHT", WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i], "RIGHT", 10, -2)
      
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets = CreateFrame("Frame", nil, WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i]);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets:SetAllPoints();
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets.icon = WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets:CreateTexture(nil, "BACKGROUND");
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets.icon:SetPoint("TOPRIGHT",WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets, "TOPRIGHT", -8,-8);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets.icon:SetSize(10,10);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets.icon:SetTexture([ [Interface\Addons\BetterWardrobe\WeaponSets\textures\multipleSymbol.tga] ]);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets.icon:SetVertexColor(.8,.7,.4,.65);
      
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets.label = WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets:CreateFontString(nil, "OVERLAY", "GameTooltipText")
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets.label:SetPoint("RIGHT",WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets.icon,"LEFT",-1,0);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets.label:SetText("1");
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].NumSets.label:SetTextColor(.8,.7,.4,.65);
      
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].Remix = CreateFrame("Frame", nil, WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i]);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].Remix:SetAllPoints();
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].Remix.icon = WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].Remix:CreateTexture(nil, "BACKGROUND");
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].Remix.icon:SetPoint("BOTTOMRIGHT",WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].Remix, "BOTTOMRIGHT", -1,1);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].Remix.icon:SetSize(20,20);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].Remix.icon:SetTexture([ [Interface\Addons\BetterWardrobe\WeaponSets\textures\Remix_icon.tga] ]);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].Remix.icon:SetVertexColor(1,1,1,.3);
      
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].LegionRemix = CreateFrame("Frame", nil, WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i]);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].LegionRemix:SetAllPoints();
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].LegionRemix.icon = WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].LegionRemix:CreateTexture(nil, "BACKGROUND");
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].LegionRemix.icon:SetPoint("BOTTOMRIGHT",WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].LegionRemix, "BOTTOMRIGHT", -1,1);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].LegionRemix.icon:SetSize(20,20);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].LegionRemix.icon:SetTexture([ [Interface\Addons\BetterWardrobe\WeaponSets\textures\Remix_legion_icon.tga] ]);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].LegionRemix.icon:SetVertexColor(1,1,1,.3);
      
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].TradingPost = CreateFrame("Frame", nil, WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i]);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].TradingPost:SetAllPoints();
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].TradingPost.icon = WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].TradingPost:CreateTexture(nil, "BACKGROUND");
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].TradingPost.icon:SetPoint("BOTTOMRIGHT",WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].TradingPost, "BOTTOMRIGHT", -1,1);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].TradingPost.icon:SetSize(12,12);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].TradingPost.icon:SetTexture(4696085);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].TradingPost.icon:SetDesaturation(.4);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].TradingPost.icon:SetVertexColor(.9,.85,.1,.45);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].TradingPost.icon:SetTexCoord(.2,.95,.1,.9);
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i].TradingPost.icon:SetRotation(math.pi);
    
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i]:Show();
      
      WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.buttons[i]:SetScript("OnMouseUp", function(self, button)
              if ( button == "LeftButton" ) then
                PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
                local setID = GetPrimarySet(self.setID);
                SelectSet(setID);
              elseif ( button == "RightButton" ) then
                FavoriteDropDown_Init(self);
                PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
              end
        end)
    end
    WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.currTopIndex = 1;
    
    WeaponSetsCollectionFrame.LeftFrame.SearchBox = CreateFrame("EditBox", nil, WeaponSetsCollectionFrame.LeftFrame, "SearchBoxTemplate");
    WeaponSetsCollectionFrame.LeftFrame.SearchBox:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.LeftFrame, "TOPLEFT", 13, -9);
    WeaponSetsCollectionFrame.LeftFrame.SearchBox:SetSize(112, 20);
    WeaponSetsCollectionFrame.LeftFrame.SearchBox:SetScript("OnTextChanged", function(self)
                  if ( not self:HasFocus() and self:GetText() == "" ) then
                    self.searchIcon:SetVertexColor(0.6, 0.6, 0.6);
                    self.clearButton:Hide();
                  else
                    self.searchIcon:SetVertexColor(1.0, 1.0, 1.0);
                    self.clearButton:Show();
                  end
                  InputBoxInstructions_OnTextChanged(self);
                  OnSearchUpdate();
      end)
    
    --Filter dropdown
    WeaponSetsCollectionFrame.LeftFrame.FilterButton = CreateFrame("DropdownButton", nil, WeaponSetsCollectionFrame.LeftFrame, "WowStyle1FilterDropdownTemplate");
    WeaponSetsCollectionFrame.LeftFrame.FilterButton:SetPoint("LEFT", WeaponSetsCollectionFrame.LeftFrame.SearchBox, "RIGHT", 2, -1);
    WeaponSetsCollectionFrame.LeftFrame.FilterButton:SetPoint("RIGHT", WeaponSetsCollectionFrame.LeftFrame.SearchBox, "RIGHT", 70, -1);
    WeaponSetsCollectionFrame.LeftFrame.FilterButton:SetMenuAnchor(AnchorUtil.CreateAnchor("TOPLEFT", WeaponSetsCollectionFrame.LeftFrame.FilterButton, "TOPRIGHT", 4, 3))
    WeaponSetsCollectionFrame.LeftFrame.FilterButton:SetText(FILTER)
    WeaponSetsCollectionFrame.LeftFrame.FilterButton:SetupMenu(OpenWeaponSetsFilterDropDown)   
    
    WeaponSetsCollectionFrame.RightFrame = CreateFrame("Frame", nil, WeaponSetsCollectionFrame, "CollectionsBackgroundTemplate");
    WeaponSetsCollectionFrame.RightFrame.BGCornerTopLeft:Hide();
    WeaponSetsCollectionFrame.RightFrame.BGCornerBottomLeft:Hide();
    WeaponSetsCollectionFrame.RightFrame:ClearAllPoints();
    WeaponSetsCollectionFrame.RightFrame:SetPoint("RIGHT", WeaponSetsCollectionFrame, "RIGHT",2,0);
    WeaponSetsCollectionFrame.RightFrame:SetSize(WeaponSetsCollectionFrame:GetWidth() - WeaponSetsCollectionFrame.LeftFrame:GetWidth(), WeaponSetsCollectionFrame:GetHeight());

    WeaponSetsCollectionFrame.RightFrame:Show();
    WardrobeCollectionFrame.WeaponSetsCollectionFrame.RightFrame.SetAppearanceTooltip = SetAppearanceTooltip;
    WardrobeCollectionFrame.WeaponSetsCollectionFrame.RightFrame.RefreshAppearanceTooltip = RefreshAppearanceTooltip;
    
    WeaponSetsCollectionFrame.RightFrame.weaponTypeArray = {}
    WeaponSetsCollectionFrame.RightFrame.activeWeapon = 1;
    WeaponSetsCollectionFrame.RightFrame.preferredWeapon = 1;
    
    WeaponSetsCollectionFrame.RightFrame.buttonTopSpacer = 35;
    WeaponSetsCollectionFrame.RightFrame.buttonHeight = (WeaponSetsCollectionFrame.RightFrame:GetHeight() - (10 + WeaponSetsCollectionFrame.RightFrame.buttonTopSpacer)) / (#weaponType + 2);
    WeaponSetsCollectionFrame.RightFrame.buttonOffset = -WeaponSetsCollectionFrame.RightFrame.buttonHeight / #weaponType;
    local buttonWidth = 175;
    for i=1,#weaponType do
      local button = CreateFrame("Button", nil, WeaponSetsCollectionFrame.RightFrame);
      button:SetWidth(buttonWidth);
      button:RegisterForMouse("LeftButtonDown", "RightButtonDown");
      button.WeaponIcon = button:CreateTexture(nil, "ARTWORK");
      button.WeaponIcon:SetPoint("CENTER", button, "LEFT", 5 + (WeaponSetsCollectionFrame.RightFrame.buttonHeight * .75), 0);
      button.WeaponIcon:SetTexture([ [Interface\Addons\BetterWardrobe\WeaponSets\textures\weapon_icons.tga] ]);
      button.WeaponIcon:SetTexCoord(weaponType[i][2],weaponType[i][3],weaponType[i][4],weaponType[i][5]);
      button.Text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal");
      button.Text:SetPoint("LEFT",button.WeaponIcon,"RIGHT",5,0);
      button.Text:SetText(weaponType[i][1]);
      button.index = i;
      button:SetScript("OnMouseDown", function(self,button)
          if self.disabled == true then return; end
          WeaponSetsCollectionFrame.RightFrame.preferredWeapon = self.index;
          if WeaponSetsCollectionFrame.RightFrame.activeWeapon ~= self.index then
            WeaponSetsCollectionFrame.RightFrame.activeWeapon = self.index;
            SelectWeapon();
          else
            if WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].activeSource > WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].num then
              WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].activeSource = WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].num;
            end
            if (button == "LeftButton") then
              WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].activeSource = WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].activeSource + 1;
              if WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].activeSource > WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].num then
                WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].activeSource = 1;
              end
            else
              WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].activeSource = WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].activeSource - 1;
              if WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].activeSource < 1 then
                WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].activeSource = WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[self.index].num;
              end
            end
            SelectWeapon();
          end
        end)
      button.NumSets = CreateFrame("Frame", nil, button);
      button.NumSets:SetAllPoints();
      button.NumSets.label = button.NumSets:CreateFontString(nil, "OVERLAY", "GameTooltipTextSmall")
      button.NumSets.label:SetPoint("LEFT",button.Text,"RIGHT",5,-1);
      button.NumSets.label:SetText("1");
      button.NumSets.label:SetTextColor(.8,.7,.4,.65);
      
      button.NumSets.icon = button.NumSets:CreateTexture(nil, "BACKGROUND");
      button.NumSets.icon:SetPoint("LEFT",button.NumSets.label, "RIGHT", 2,0);
      button.NumSets.icon:SetSize(8,8);
      button.NumSets.icon:SetTexture([ [Interface\Addons\BetterWardrobe\WeaponSets\textures\multipleSymbol.tga] ]);
      button.NumSets.icon:SetVertexColor(.8,.7,.4,.65);
      
      button.background = button:CreateTexture(nil, "BACKGROUND");
      button.background:SetAtlas("BonusChest-OrangeSmoke-Wide");
      button.background:SetPoint("TOPLEFT", button, "TOPLEFT", -5,-8);
      button.background:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", -5,8);
      button.background:SetPoint("TOPRIGHT", button.Text, "TOPRIGHT", 25,-8);
      button.background:SetPoint("BOTTOMRIGHT", button.Text, "BOTTOMRIGHT", 25,8);
      button.background:SetVertexColor(0.6,1,1,0.4);
      
      button:Show();
      
      WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[i] = button;
    end
    
    ----Variant Drop Down
    WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton = CreateFrame("DropdownButton", nil, WeaponSetsCollectionFrame.RightFrame, "WowStyle2DropdownTemplate")
    WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.RightFrame, "TOPLEFT", 10, -9);
    WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton:SetSize(108,22);
    WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton:SetMenuAnchor(AnchorUtil.CreateAnchor("TOPLEFT", WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton, "BOTTOMLEFT", -3, -1))
    WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton:SetupMenu(OpenVariantSetsDropDown)
    WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton:SetSelectionText(function(selection)
        if selection[1] then
          return selection[1].data;
        end
      end)
    
    -- Favorite Set Button --
    WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton = CreateFrame("Frame", "ExS_Weapon_FavoriteSetButton", WeaponSetsCollectionFrame.RightFrame);
    WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton:SetSize(16,20);
    WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton:SetPoint("LEFT", WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton, "RIGHT", 2, 0);

    WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton.backgroundTexture = WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton:CreateTexture(nil, "BACKGROUND");
    WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton.backgroundTexture:SetPoint("CENTER");
    WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton.backgroundTexture:SetSize(22,22);
    WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton.backgroundTexture:SetAtlas("PetJournal-FavoritesIcon");
    --WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton.backgroundTexture:SetDesaturated(ExS_Settings.disableHideSetButton);

    WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_LEFT");
      if ExS_Weapon_Favorites[WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet] then
        GameTooltip_SetTitle(GameTooltip, app.GetLocalizedString("MarkSetFav"), NORMAL_FONT_COLOR, true);
      else
        GameTooltip_SetTitle(GameTooltip, app.GetLocalizedString("MarkSetNotFav"), NORMAL_FONT_COLOR, true);
      end
      GameTooltip:Show();
    end);
    WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton:SetScript("OnLeave", function(self)
      GameTooltip:Hide();
    end);
    
    WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton:SetScript("OnMouseUp", function(pSelf, pButton, pDown)
      if pButton == "LeftButton" then
        local setID = WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet;
        MarkSetAsFavorite(setID, not ExS_Weapon_Favorites[setID]);
      end
    end);
    WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton:SetShown(ExS_Settings.extraButtonToggles[3]);
    
    -- Hidden Set Button --
    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton = CreateFrame("Frame", "ExS_Weapon_HiddenSetButton", WeaponSetsCollectionFrame.RightFrame);
    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton:SetSize(16,20);
    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton:SetPoint("LEFT", WeaponSetsCollectionFrame.RightFrame.FavoriteSetButton, "RIGHT", 2, 0);

    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton.backgroundTexture = WeaponSetsCollectionFrame.RightFrame.HiddenSetButton:CreateTexture(nil, "BACKGROUND");
    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton.backgroundTexture:SetAllPoints();
    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton.backgroundTexture:SetTexture([ [Interface\Addons\BetterWardrobe\WeaponSets\textures\ShowHideIcons.tga] ]);
    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton.backgroundTexture:SetTexCoord(0,.5,0,1);
    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton.backgroundTexture:SetDesaturated(ExS_Settings.disableHideSetButton);

    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_LEFT");
      if ExS_Weapon_HiddenSets[WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet] then
        GameTooltip_SetTitle(GameTooltip, app.GetLocalizedString("ShowSet"), NORMAL_FONT_COLOR, true);
      else
        GameTooltip_SetTitle(GameTooltip, app.GetLocalizedString("HideSet"), NORMAL_FONT_COLOR, true);
      end
      GameTooltip:Show();
    end);
    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton:SetScript("OnLeave", function(self)
      GameTooltip:Hide();
    end);
    
    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton:SetScript("OnMouseUp", function(pSelf, pButton, pDown)
      if pButton == "LeftButton" and not ExS_Settings.disableHideSetButton then
        local setID = WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet;
        HideSet(setID);
        ExS_Weapon_HiddenSets[setID] = not ExS_Weapon_HiddenSets[setID] or nil;
        local count = tonumber(WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Text:GetText());
        if ExS_Weapon_HiddenSets[setID] then count = count + 1; else
        count = count - 1; end
        WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Text:SetText(count);
      end
    end);
    WeaponSetsCollectionFrame.RightFrame.HiddenSetButton:SetShown(ExS_Settings.extraButtonToggles[4]);
    
    -- No Longer Obtainable warning --
    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable = CreateFrame("Frame", "ExS_Weapon_NoLongerObtainable", WeaponSetsCollectionFrame.RightFrame);
    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable:SetSize(70,14);
    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable:SetPoint("LEFT", WeaponSetsCollectionFrame.RightFrame.HiddenSetButton, "RIGHT", 35, 0);

    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable.Icon = WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable:CreateTexture(nil, "BACKGROUND");
    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable.Icon:SetSize(14,14);
    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable.Icon:SetPoint("LEFT");
    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable.Icon:SetAtlas("transmog-icon-remove");
    
    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable.Text = WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable:CreateFontString(nil, "OVERLAY", "GameFontRedSmall");
    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable.Text:SetPoint("LEFT", WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable.Icon, "RIGHT", -2, 0);
    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable.Text:SetWidth(60);
    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable.Text:SetText(app.GetLocalizedString("NoLongerObtainable"));

    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_LEFT");
      GameTooltip_SetTitle(GameTooltip, app.GetLocalizedString("NoLongerObtainable"), NORMAL_FONT_COLOR, true);
      GameTooltip:Show();
    end);
    WeaponSetsCollectionFrame.RightFrame.NoLongerObtainable:SetScript("OnLeave", function(self)
      GameTooltip:Hide();
    end);
    
    -- Hidden Set Count --
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount = CreateFrame("Frame", nil, WeaponSetsCollectionFrame.RightFrame);
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount:SetSize(40,20);
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount:SetPoint("BOTTOMRIGHT", WeaponSetsCollectionFrame.RightFrame, "TOPRIGHT", 0, 6);

    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Icon = WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount:CreateTexture(nil, "BACKGROUND");
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Icon:SetPoint("RIGHT");
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Icon:SetSize(16,16);
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Icon:SetTexture([ [Interface\Addons\BetterWardrobe\WeaponSets\textures\ShowHideIcons.tga] ]);
    if ExS_Settings.showHiddenSets then
      WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Icon:SetTexCoord(.5,1,0,1);
    else
      WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Icon:SetTexCoord(0,.5,0,1);
    end
    
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Text = WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount:CreateFontString(nil, "OVERLAY", "GameTooltipText");
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Text:SetPoint("RIGHT", WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Icon, "LEFT", -2,0);
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Text:SetJustifyH("RIGHT");
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Text:SetText("1");
    
    local function SetHiddenSetsTooltip()
      local str = WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount.Text:GetText()..app.GetLocalizedString("CountSetsHidden")
      GameTooltip_SetTitle(GameTooltip, str, NORMAL_FONT_COLOR, true);
      if ExS_Settings.showHiddenSets then
        str = app.GetLocalizedString("HideHiddenSetsTT")
      else
        str = app.GetLocalizedString("ShowHiddenSetsTT")
      end
      GameTooltip:AddLine(str,.55,.55,.7);
      GameTooltip:Show();
    end
    
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_LEFT");
      SetHiddenSetsTooltip();
    end);
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount:SetScript("OnLeave", function(self)
      GameTooltip:Hide();
    end);
    
    WeaponSetsCollectionFrame.RightFrame.HiddenSetsCount:SetScript("OnMouseUp", function(pSelf, pButton, pDown)
      ShowHideSetsToggle();
      SetHiddenSetsTooltip();
    end);

    
    ----Details Frame (Icon, Name, Label)
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame = CreateFrame("Frame", nil, WeaponSetsCollectionFrame.RightFrame);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame:SetSize(WeaponSetsCollectionFrame.RightFrame:GetWidth() - buttonWidth - 20, 100);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame:SetPoint("TOPRIGHT", WeaponSetsCollectionFrame.RightFrame, "TOPRIGHT", -20, -15);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame = CreateFrame("Frame", nil, WeaponSetsCollectionFrame.RightFrame.DetailsFrame, "WardrobeSetsDetailsItemFrameTemplate");
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame:SetPoint("TOP", WeaponSetsCollectionFrame.RightFrame.DetailsFrame, "TOP", -25, 0);
          WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame:SetScript("OnMouseDown", function(self)
                  if ( IsModifiedClick("CHATLINK") ) then
                    local link = C_TransmogCollection.GetAppearanceSourceInfo(self.sourceID).itemLink;
                    if not ChatEdit_InsertLink(link) then
                      ChatFrame_OpenChat(link);
                    end
                  elseif ( IsModifiedClick("DRESSUP") ) then
                    DressUpVisual(self.sourceID);
                  end
                  --help for filling in weapon db test
                  if app.devMode then
                    --print(self.sourceID);
                    TmogItemSource(self.sourceID);
                  end
        end)
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame:SetHyperlinksEnabled(true);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame:SetScript("OnHyperlinkClick", function(self, link, text, button)
                SetItemRef(link, text, button, self)
              end)
    --WeaponSetsCollectionFrame.RightFrame.DetailsFrame:SetScript("OnHyperlinkEnter", function(self, link, text)
    --            GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
    --            GameTooltip:SetHyperlink(link);
    --            GameTooltip:Show();
    --          end)
    --WeaponSetsCollectionFrame.RightFrame.DetailsFrame:SetScript("OnHyperlinkLeave", function(self, link, text)
    --            GameTooltip:Hide();
    --          end)
    
    --remix icon below the item icon
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.RemixIcon = CreateFrame("frame", nil, WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.RemixIcon:SetPoint("LEFT",WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame,"RIGHT",2,0);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.RemixIcon:SetSize(25,25);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.RemixIcon.Icon = WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.RemixIcon:CreateTexture(nil, "OVERLAY");
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.RemixIcon.Icon:SetAllPoints();
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.RemixIcon.Icon:SetDrawLayer("OVERLAY", 2);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.RemixIcon.Icon:SetTexture([ [Interface\Addons\BetterWardrobe\WeaponSets\textures\Remix_icon_vert.tga] ]);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.RemixIcon.Icon:SetAlpha(0.5);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.RemixIcon.Text = app.GetLocalizedString("MoPRemixExclusive");
    
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.RemixIcon:SetScript("OnEnter", function(self)
              GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
              GameTooltip_SetTitle(GameTooltip, self.Text, NORMAL_FONT_COLOR, true);
              GameTooltip:Show();
        end);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.RemixIcon:SetScript("OnLeave", function(self)
              GameTooltip:Hide();
        end);
        
    --legion remix icon below the item icon
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.LegionRemixIcon = CreateFrame("frame", nil, WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.LegionRemixIcon:SetPoint("LEFT",WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame,"RIGHT",2,0);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.LegionRemixIcon:SetSize(25,25);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.LegionRemixIcon.Icon = WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.LegionRemixIcon:CreateTexture(nil, "OVERLAY");
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.LegionRemixIcon.Icon:SetAllPoints();
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.LegionRemixIcon.Icon:SetDrawLayer("OVERLAY", 2);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.LegionRemixIcon.Icon:SetTexture([ [Interface\Addons\BetterWardrobe\WeaponSets\textures\Remix_legion_icon_vert.tga] ]);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.LegionRemixIcon.Icon:SetAlpha(0.5);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.LegionRemixIcon.Text = app.GetLocalizedString("LegRemixExclusive");
    
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.LegionRemixIcon:SetScript("OnEnter", function(self)
              GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
              GameTooltip_SetTitle(GameTooltip, self.Text, NORMAL_FONT_COLOR, true);
              GameTooltip:Show();
        end);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame.LegionRemixIcon:SetScript("OnLeave", function(self)
              GameTooltip:Hide();
        end);
    
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Name = WeaponSetsCollectionFrame.RightFrame.DetailsFrame:CreateFontString(nil, "OVERLAY", "Fancy24Font");
    Mixin(WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Name,ShrinkUntilTruncateFontStringMixin);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Name:SetFontObjectsToTry("Fancy24Font","Fancy16Font");
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Name:SetPoint("TOP", WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame, "BOTTOM", 0, -5);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Name:SetWidth(WeaponSetsCollectionFrame.RightFrame.DetailsFrame:GetWidth());
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Label = WeaponSetsCollectionFrame.RightFrame.DetailsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLeftGrey");
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Label:SetPoint("TOP", WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Name, "BOTTOM", 0, -5);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Label2 = WeaponSetsCollectionFrame.RightFrame.DetailsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLeftGrey");
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Label2:SetPoint("TOP", WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Label, "BOTTOM", 0, -5);
    WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Label2:SetTextColor(.55,.55,.7);
    
    --large remix icon in bottom right corner of frame
    WeaponSetsCollectionFrame.RightFrame.RemixIcon = CreateFrame("frame", nil, WeaponSetsCollectionFrame.RightFrame);
    WeaponSetsCollectionFrame.RightFrame.RemixIcon:SetPoint("BOTTOMRIGHT",WeaponSetsCollectionFrame.RightFrame,"BOTTOMRIGHT",-2,1);
    WeaponSetsCollectionFrame.RightFrame.RemixIcon:SetSize(200,200);
    WeaponSetsCollectionFrame.RightFrame.RemixIcon.Icon = WeaponSetsCollectionFrame.RightFrame.RemixIcon:CreateTexture(nil, "OVERLAY");
    WeaponSetsCollectionFrame.RightFrame.RemixIcon.Icon:SetAllPoints();
    WeaponSetsCollectionFrame.RightFrame.RemixIcon.Icon:SetDrawLayer("BACKGROUND", 2);
    WeaponSetsCollectionFrame.RightFrame.RemixIcon.Icon:SetTexture([ [Interface\Addons\BetterWardrobe\WeaponSets\textures\Remix_icon_large.tga] ]);
    WeaponSetsCollectionFrame.RightFrame.RemixIcon.Icon:SetAlpha(0.2);
    
    --large remix icon in bottom right corner of frame
    WeaponSetsCollectionFrame.RightFrame.LegionRemixIcon = CreateFrame("frame", nil, WeaponSetsCollectionFrame.RightFrame);
    WeaponSetsCollectionFrame.RightFrame.LegionRemixIcon:SetPoint("BOTTOMRIGHT",WeaponSetsCollectionFrame.RightFrame,"BOTTOMRIGHT",-2,1);
    WeaponSetsCollectionFrame.RightFrame.LegionRemixIcon:SetSize(200,200);
    WeaponSetsCollectionFrame.RightFrame.LegionRemixIcon.Icon = WeaponSetsCollectionFrame.RightFrame.LegionRemixIcon:CreateTexture(nil, "OVERLAY");
    WeaponSetsCollectionFrame.RightFrame.LegionRemixIcon.Icon:SetAllPoints();
    WeaponSetsCollectionFrame.RightFrame.LegionRemixIcon.Icon:SetDrawLayer("BACKGROUND", 2);
    WeaponSetsCollectionFrame.RightFrame.LegionRemixIcon.Icon:SetTexture([ [Interface\Addons\BetterWardrobe\WeaponSets\textures\Remix_legion_icon_large.tga] ]);
    WeaponSetsCollectionFrame.RightFrame.LegionRemixIcon.Icon:SetAlpha(0.2);

  --test temp
  if app.devMode then
      WeaponSetsCollectionFrame.RightFrame.indexText = WeaponSetsCollectionFrame.RightFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
      WeaponSetsCollectionFrame.RightFrame.indexText:SetPoint("RIGHT",WeaponSetsCollectionFrame.RightFrame.DetailsFrame.ItemFrame,"LEFT",-15,0);
      WeaponSetsCollectionFrame.RightFrame.indexText:SetSize(75, 10);
      WeaponSetsCollectionFrame.RightFrame.indexText:SetJustifyH("LEFT");
      WeaponSetsCollectionFrame.RightFrame.indexText:SetText("Hi");
      WeaponSetsCollectionFrame.RightFrame.itemTooltipTest = CreateFrame("Button", nil, WeaponSetsCollectionFrame.RightFrame);
      WeaponSetsCollectionFrame.RightFrame.itemTooltipTest:SetPoint("BOTTOMRIGHT", WeaponSetsCollectionFrame.RightFrame, "BOTTOMRIGHT", -5, 50);
      WeaponSetsCollectionFrame.RightFrame.itemTooltipTest:SetSize(26, 26);
      WeaponSetsCollectionFrame.RightFrame.itemTooltipTest:SetScript("OnEnter", function(self)
                  GameTooltip:SetOwner(self, "ANCHOR_LEFT");
                  
      local aSource = WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[WeaponSetsCollectionFrame.RightFrame.activeWeapon].activeSource;
      if not WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[WeaponSetsCollectionFrame.RightFrame.activeWeapon].sources[aSource] then
        GameTooltip:SetText("Nope.");
      else
      local weaponSourceID = WeaponSetsCollectionFrame.RightFrame.weaponTypeArray[WeaponSetsCollectionFrame.RightFrame.activeWeapon].sources[aSource][2];
      
                    local appSource = C_TransmogCollection.GetAllAppearanceSources(app.AppID(weaponSourceID))[1]
                    local appInfo = C_TransmogCollection.GetAppearanceSourceInfo(appSource);
                    GameTooltip:SetHyperlink(appInfo.itemLink);
                  end
                  GameTooltip:Show();
          end)
        WeaponSetsCollectionFrame.RightFrame.itemTooltipTest:SetScript("OnLeave", function(self)
                  GameTooltip:Hide();
          end)
        WeaponSetsCollectionFrame.RightFrame.itemTooltipTest.tex = WeaponSetsCollectionFrame.RightFrame.itemTooltipTest:CreateTexture();
        WeaponSetsCollectionFrame.RightFrame.itemTooltipTest.tex:SetAllPoints(WeaponSetsCollectionFrame.RightFrame.itemTooltipTest);
        WeaponSetsCollectionFrame.RightFrame.itemTooltipTest.tex:SetColorTexture(1,1,1,1);
  end
  --test
    
    
    WeaponSetsCollectionFrame.RightFrame.ResetRotation = CreateFrame("Button", nil, WeaponSetsCollectionFrame.RightFrame);
    WeaponSetsCollectionFrame.RightFrame.ResetRotation.inPose = false;
    WeaponSetsCollectionFrame.RightFrame.ResetRotation:SetPoint("TOPRIGHT", WeaponSetsCollectionFrame.RightFrame, "TOPRIGHT", -5, -50);
    WeaponSetsCollectionFrame.RightFrame.ResetRotation:SetSize(26, 26);
    WeaponSetsCollectionFrame.RightFrame.ResetRotation:SetScript("OnMouseDown", function(self)
              PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
              if WeaponSetsCollectionFrame.RightFrame.Model.isPlayer then
                ResetPlayerRotations();
              else
                ResetWeapon();
              end
      end)
    WeaponSetsCollectionFrame.RightFrame.ResetRotation:SetScript("OnEnter", function(self)
              GameTooltip:SetOwner(self, "ANCHOR_LEFT");
              GameTooltip:SetText(app.GetLocalizedString("ResetPosAndRot"));
              GameTooltip:Show();
      end)
    WeaponSetsCollectionFrame.RightFrame.ResetRotation:SetScript("OnLeave", function(self)
              GameTooltip:Hide();
      end)
    WeaponSetsCollectionFrame.RightFrame.ResetRotation.tex = WeaponSetsCollectionFrame.RightFrame.ResetRotation:CreateTexture();
    WeaponSetsCollectionFrame.RightFrame.ResetRotation.tex:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.RightFrame.ResetRotation, "TOPLEFT", 3,-3);
    WeaponSetsCollectionFrame.RightFrame.ResetRotation.tex:SetPoint("BOTTOMRIGHT", WeaponSetsCollectionFrame.RightFrame.ResetRotation, "BOTTOMRIGHT", -1,1);
    
    WeaponSetsCollectionFrame.RightFrame.ResetRotation.tex:SetTexture([ [Interface\Addons\BetterWardrobe\WeaponSets\textures\weapon_icons.tga] ]);
    WeaponSetsCollectionFrame.RightFrame.ResetRotation.tex:SetTexCoord(200/256,250/256,200/256,250/256);
    WeaponSetsCollectionFrame.RightFrame.ResetRotation.backTex = WeaponSetsCollectionFrame.RightFrame.ResetRotation:CreateTexture(nil, "BACKGROUND");
    WeaponSetsCollectionFrame.RightFrame.ResetRotation.backTex:SetAllPoints(WeaponSetsCollectionFrame.RightFrame.ResetRotation);
    WeaponSetsCollectionFrame.RightFrame.ResetRotation.backTex:SetTexture([ [Interface\Addons\BetterWardrobe\WeaponSets\textures\weapon_icons.tga] ]);
    WeaponSetsCollectionFrame.RightFrame.ResetRotation.backTex:SetTexCoord(.78125,.9765625,.5859375,.78125);
    WeaponSetsCollectionFrame.RightFrame.ResetRotation.backTex:SetVertexColor(0.80,0.78,0.35,0.45);
    
    
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem = CreateFrame("Button", nil, WeaponSetsCollectionFrame.RightFrame);
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem:SetPoint("TOP", WeaponSetsCollectionFrame.RightFrame.ResetRotation, "BOTTOM", 0, -3);
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem:SetSize(26, 26);
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem:SetScript("OnMouseDown", function(self)
              PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
              SwapPlayerItem();
              if WeaponSetsCollectionFrame.RightFrame.Model.isPlayer then
                GameTooltip:SetText(app.GetLocalizedString("SwapToOnlyWep"));
                
                if not ElvUI then
                  WeaponSetsCollectionFrame.RightFrame.SwapPose.tex:SetVertexColor(1,1,1,1);
                  WeaponSetsCollectionFrame.RightFrame.SwapPose.backTex:SetVertexColor(0.80,0.78,0.35,0.45);
                  
                  WeaponSetsCollectionFrame.RightFrame.dualWield.tex:SetVertexColor(1,1,1,1);
                  WeaponSetsCollectionFrame.RightFrame.dualWield.backTex:SetVertexColor(0.80,0.78,0.35,0.45);
                else
                  WeaponSetsCollectionFrame.RightFrame.SwapPose.tex:SetVertexColor(1,1,1,1);
                  WeaponSetsCollectionFrame.RightFrame.SwapPose.backTex:SetVertexColor(0.60,0.6,0.6,0.45);
                  
                  WeaponSetsCollectionFrame.RightFrame.dualWield.tex:SetVertexColor(1,1,1,1);
                  WeaponSetsCollectionFrame.RightFrame.dualWield.backTex:SetVertexColor(0.6,0.6,0.6,0.45);
                end
              else
                GameTooltip:SetText(app.GetLocalizedString("SwapToPlayerWithWep"));
                
                if not ElvUI then
                  WeaponSetsCollectionFrame.RightFrame.SwapPose.tex:SetVertexColor(1,.9,.9,0.4);
                  WeaponSetsCollectionFrame.RightFrame.SwapPose.backTex:SetVertexColor(0.80,0.68,0.25,0.20);
                  
                  WeaponSetsCollectionFrame.RightFrame.dualWield.tex:SetVertexColor(1,.9,.9,0.4);
                  WeaponSetsCollectionFrame.RightFrame.dualWield.backTex:SetVertexColor(0.80,0.68,0.25,0.20);
                else
                  WeaponSetsCollectionFrame.RightFrame.SwapPose.tex:SetVertexColor(1,.9,.9,0.4);
                  WeaponSetsCollectionFrame.RightFrame.SwapPose.backTex:SetVertexColor(0.6,0.6,0.6,0.20);
                  
                  WeaponSetsCollectionFrame.RightFrame.dualWield.tex:SetVertexColor(1,.9,.9,0.4);
                  WeaponSetsCollectionFrame.RightFrame.dualWield.backTex:SetVertexColor(0.6,0.6,0.6,0.20);
                end
              end
      end)
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem:SetScript("OnEnter", function(self)
              GameTooltip:SetOwner(self, "ANCHOR_LEFT");
              if WeaponSetsCollectionFrame.RightFrame.Model.isPlayer then
                GameTooltip:SetText(app.GetLocalizedString("SwapToOnlyWep"));
              else
                GameTooltip:SetText(app.GetLocalizedString("SwapToPlayerWithWep"));
              end
              GameTooltip:Show();
      end)
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem:SetScript("OnLeave", function(self)
              GameTooltip:Hide();
      end)
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem.tex = WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem:CreateTexture();
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem.tex:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem, "TOPLEFT", 4,-3);
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem.tex:SetPoint("BOTTOMRIGHT", WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem, "BOTTOMRIGHT", -1,2);
    
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem.tex:SetTexture([ [Interface\Addons\BetterWardrobe\WeaponSets\textures\weapon_icons.tga] ]);
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem.tex:SetTexCoord(100/256,150/256,200/256,250/256);
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem.backTex = WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem:CreateTexture(nil, "BACKGROUND");
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem.backTex:SetAllPoints(WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem);
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem.backTex:SetTexture([ [Interface\Addons\BetterWardrobe\WeaponSets\textures\weapon_icons.tga] ]);
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem.backTex:SetTexCoord(.78125,.9765625,.5859375,.78125);
    WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem.backTex:SetVertexColor(0.80,0.78,0.35,0.45);
    
      
      
    WeaponSetsCollectionFrame.RightFrame.SwapPose = CreateFrame("Button", nil, WeaponSetsCollectionFrame.RightFrame);
    WeaponSetsCollectionFrame.RightFrame.SwapPose.inPose = false;
    WeaponSetsCollectionFrame.RightFrame.SwapPose:SetPoint("TOP", WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem, "BOTTOM", 0, -3);
    WeaponSetsCollectionFrame.RightFrame.SwapPose:SetSize(26, 26);
    WeaponSetsCollectionFrame.RightFrame.SwapPose:SetScript("OnMouseDown", function(self)
              if not WeaponSetsCollectionFrame.RightFrame.Model.isPlayer then return; end
              PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
              WeaponSetsCollectionFrame.RightFrame.SwapPose.inPose = not WeaponSetsCollectionFrame.RightFrame.SwapPose.inPose;
              SetPose();
              if WeaponSetsCollectionFrame.RightFrame.SwapPose.inPose then
                GameTooltip:SetText(app.GetLocalizedString("SetIdlePose"));
              else
                GameTooltip:SetText(app.GetLocalizedString("SetActionPose"));
              end
      end)
    WeaponSetsCollectionFrame.RightFrame.SwapPose:SetScript("OnEnter", function(self)
              if not WeaponSetsCollectionFrame.RightFrame.Model.isPlayer then return; end
              GameTooltip:SetOwner(self, "ANCHOR_LEFT");
              if WeaponSetsCollectionFrame.RightFrame.SwapPose.inPose then
                GameTooltip:SetText(app.GetLocalizedString("SetIdlePose"));
              else
                GameTooltip:SetText(app.GetLocalizedString("SetActionPose"));
              end
              GameTooltip:Show();
      end)
    WeaponSetsCollectionFrame.RightFrame.SwapPose:SetScript("OnLeave", function(self)
              GameTooltip:Hide();
      end)
    WeaponSetsCollectionFrame.RightFrame.SwapPose.tex = WeaponSetsCollectionFrame.RightFrame.SwapPose:CreateTexture();
    --WeaponSetsCollectionFrame.RightFrame.SwapPose.tex:SetAllPoints(WeaponSetsCollectionFrame.RightFrame.SwapPose);
    WeaponSetsCollectionFrame.RightFrame.SwapPose.tex:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.RightFrame.SwapPose, "TOPLEFT", 3,-3);
    WeaponSetsCollectionFrame.RightFrame.SwapPose.tex:SetPoint("BOTTOMRIGHT", WeaponSetsCollectionFrame.RightFrame.SwapPose, "BOTTOMRIGHT", -2,2);
    
    WeaponSetsCollectionFrame.RightFrame.SwapPose.tex:SetTexture([ [Interface\Addons\BetterWardrobe\WeaponSets\textures\weapon_icons.tga] ]);
    WeaponSetsCollectionFrame.RightFrame.SwapPose.tex:SetTexCoord(150/256,200/256,200/256,250/256);
    WeaponSetsCollectionFrame.RightFrame.SwapPose.backTex = WeaponSetsCollectionFrame.RightFrame.SwapPose:CreateTexture(nil, "BACKGROUND");
    WeaponSetsCollectionFrame.RightFrame.SwapPose.backTex:SetAllPoints(WeaponSetsCollectionFrame.RightFrame.SwapPose);
    WeaponSetsCollectionFrame.RightFrame.SwapPose.backTex:SetTexture([ [Interface\Addons\BetterWardrobe\WeaponSets\textures\weapon_icons.tga] ]);
    WeaponSetsCollectionFrame.RightFrame.SwapPose.backTex:SetTexCoord(.78125,.9765625,.5859375,.78125);
    WeaponSetsCollectionFrame.RightFrame.SwapPose.backTex:SetVertexColor(0.80,0.78,0.35,0.45);
    
    
    WeaponSetsCollectionFrame.RightFrame.dualWield = CreateFrame("Button", nil, WeaponSetsCollectionFrame.RightFrame);
    WeaponSetsCollectionFrame.RightFrame.dualWield.inPose = false;
    WeaponSetsCollectionFrame.RightFrame.dualWield:SetPoint("TOP", WeaponSetsCollectionFrame.RightFrame.SwapPose, "BOTTOM", 0, -3);
    WeaponSetsCollectionFrame.RightFrame.dualWield:SetSize(26, 26);
    WeaponSetsCollectionFrame.RightFrame.dualWield:SetScript("OnMouseDown", function(self)
              if not WeaponSetsCollectionFrame.RightFrame.Model.isPlayer then return; end
              PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
              ExS_Settings.showDualWielding = not ExS_Settings.showDualWielding;
              if WeaponSetsCollectionFrame.RightFrame.Model.isPlayer then
                EquipWeapon();
              end
              if ExS_Settings.showDualWielding then
                GameTooltip:SetText(app.GetLocalizedString("WepOnlyMainHand"));
                WeaponSetsCollectionFrame.RightFrame.dualWield.tex:SetTexCoord(0,50/256,200/256,250/256);
              else
                GameTooltip:SetText(app.GetLocalizedString("WepInBothHands"));
                WeaponSetsCollectionFrame.RightFrame.dualWield.tex:SetTexCoord(200/256,250/256,100/256,150/256);
              end
      end)
    WeaponSetsCollectionFrame.RightFrame.dualWield:SetScript("OnEnter", function(self)
              if not WeaponSetsCollectionFrame.RightFrame.Model.isPlayer then return; end
              GameTooltip:SetOwner(self, "ANCHOR_LEFT");
              if ExS_Settings.showDualWielding then
                GameTooltip:SetText(app.GetLocalizedString("WepOnlyMainHand"));
              else
                GameTooltip:SetText(app.GetLocalizedString("WepInBothHands"));
              end
              GameTooltip:Show();
      end)
    WeaponSetsCollectionFrame.RightFrame.dualWield:SetScript("OnLeave", function(self)
              GameTooltip:Hide();
      end)
      
    WeaponSetsCollectionFrame.RightFrame.dualWield.tex = WeaponSetsCollectionFrame.RightFrame.dualWield:CreateTexture();
    --WeaponSetsCollectionFrame.RightFrame.dualWield.tex:SetAllPoints(WeaponSetsCollectionFrame.RightFrame.dualWield);
    WeaponSetsCollectionFrame.RightFrame.dualWield.tex:SetPoint("TOPLEFT", WeaponSetsCollectionFrame.RightFrame.dualWield, "TOPLEFT", 3,-3);
    WeaponSetsCollectionFrame.RightFrame.dualWield.tex:SetPoint("BOTTOMRIGHT", WeaponSetsCollectionFrame.RightFrame.dualWield, "BOTTOMRIGHT", -2,2);
    
    WeaponSetsCollectionFrame.RightFrame.dualWield.tex:SetTexture([ [Interface\Addons\BetterWardrobe\WeaponSets\textures\weapon_icons.tga] ]);
    if ExS_Settings.showDualWielding then
      WeaponSetsCollectionFrame.RightFrame.dualWield.tex:SetTexCoord(0,50/256,200/256,250/256);
    else
      WeaponSetsCollectionFrame.RightFrame.dualWield.tex:SetTexCoord(200/256,250/256,100/256,150/256);
    end
    WeaponSetsCollectionFrame.RightFrame.dualWield.backTex = WeaponSetsCollectionFrame.RightFrame.dualWield:CreateTexture(nil, "BACKGROUND");
    WeaponSetsCollectionFrame.RightFrame.dualWield.backTex:SetAllPoints(WeaponSetsCollectionFrame.RightFrame.dualWield);
    WeaponSetsCollectionFrame.RightFrame.dualWield.backTex:SetTexture([ [Interface\Addons\BetterWardrobe\WeaponSets\textures\weapon_icons.tga] ]);
    WeaponSetsCollectionFrame.RightFrame.dualWield.backTex:SetTexCoord(.78125,.9765625,.5859375,.78125);
    WeaponSetsCollectionFrame.RightFrame.dualWield.backTex:SetVertexColor(0.80,0.78,0.35,0.45);
    
    
    ----Model
    WeaponSetsCollectionFrame.RightFrame.Model = CreateFrame("DressUpModel", nil, WeaponSetsCollectionFrame.RightFrame, "ModelTemplate");
    WeaponSetsCollectionFrame.RightFrame.Model:SetSize(WeaponSetsCollectionFrame.RightFrame.DetailsFrame:GetWidth() + 75, WeaponSetsCollectionFrame.RightFrame:GetHeight() - 50);
    WeaponSetsCollectionFrame.RightFrame.Model:SetPoint("CENTER", WeaponSetsCollectionFrame.RightFrame.DetailsFrame, "CENTER", -25, -WeaponSetsCollectionFrame.RightFrame.Model:GetHeight() * 0.5 + 15);
    WeaponSetsCollectionFrame.RightFrame.Model:SetScript("OnUpdate", ModelOnUpdate);
    WeaponSetsCollectionFrame.RightFrame.Model.PostMouseDown = ModelPostMouseDown;
    --WeaponSetsCollectionFrame.RightFrame.Model.PostMouseUp = ModelPostMouseUp;
    WeaponSetsCollectionFrame.RightFrame.Model.pitch = 0;
    WeaponSetsCollectionFrame.RightFrame.Model.roll = 0;
    WeaponSetsCollectionFrame.RightFrame.Model.isPlayer = true;
    --WeaponSetsCollectionFrame.RightFrame.Model:SetUnit("player");
    WeaponSetsCollectionFrame.RightFrame.Model:SetUnit("player", false, not select(2,C_PlayerInfo.GetAlternateFormInfo()));
    WeaponSetsCollectionFrame.RightFrame.Model:Dress();
    
    RemoveWeapons();
    WeaponSetsCollectionFrame.RightFrame.Model:SetScript("OnMouseWheel", function(self, delta, maxZoom, minZoom)
        if not WeaponSetsCollectionFrame.RightFrame.Model.isPlayer then
          WeaponZoom(delta > 0);
        else
          maxZoom = maxZoom or WeaponSetsCollectionFrame.RightFrame.Model.maxZoom;
          minZoom = minZoom or WeaponSetsCollectionFrame.RightFrame.Model.minZoom;
          local zoomLevel = WeaponSetsCollectionFrame.RightFrame.Model.zoomLevel or minZoom;
          zoomLevel = zoomLevel + delta * MODELFRAME_ZOOM_STEP;
          zoomLevel = min(zoomLevel, maxZoom);
          zoomLevel = max(zoomLevel, minZoom);
          WeaponSetsCollectionFrame.RightFrame.Model:SetPortraitZoom(zoomLevel);
          WeaponSetsCollectionFrame.RightFrame.Model.zoomLevel = zoomLevel;
        end
      end)
    
    WeaponSetsCollectionFrame.RightFrame.Model:SetScript("OnShow", function()
          C_Timer.After(0, function()
            if WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet and WeaponSetsCollectionFrame.LeftFrame.ScrollFrame.selectedSet ~= 0 then
              WeaponSetsCollectionFrame.RightFrame.Model:SetUnit("player", false, not select(2,C_PlayerInfo.GetAlternateFormInfo()));
              SelectWeapon();
            end
          end)
      end)  
    
    app.ExS_AH_Init_Wep();
    WardrobeCollectionFrame.SetTab = ExW_SetTab;
    WardrobeCollectionFrame.ClickTab = ExW_ClickTab;
    --WardrobeCollectionFrame.OnLoad = ExW_OnLoad;
    
    
    
    --WeaponSetsCollectionFrame.RightFrame.Model.animation = 1;
    --WeaponSetsCollectionFrame.RightFrame.Model.frame = 1;
    --WeaponSetsCollectionFrame.RightFrame.Model.playerText = WeaponSetsCollectionFrame.RightFrame.Model:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    --WeaponSetsCollectionFrame.RightFrame.Model.playerText:SetPoint("BOTTOM", WeaponSetsCollectionFrame.RightFrame, "BOTTOM", 150, -30)
    --WeaponSetsCollectionFrame.RightFrame.Model.playerFrameText = WeaponSetsCollectionFrame.RightFrame.Model:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    --WeaponSetsCollectionFrame.RightFrame.Model.playerFrameText:SetPoint("BOTTOM", WeaponSetsCollectionFrame.RightFrame, "BOTTOM", 150, -50)
    --
    --WeaponSetsCollectionFrame.RightFrame.Model.play = CreateFrame("Button", nil, WeaponSetsCollectionFrame.RightFrame);
    --WeaponSetsCollectionFrame.RightFrame.Model.play:SetPoint("BOTTOM", WeaponSetsCollectionFrame.RightFrame, "BOTTOM", -10, -40);
    --WeaponSetsCollectionFrame.RightFrame.Model.play:SetSize(35, 35);
    --WeaponSetsCollectionFrame.RightFrame.Model.play.tex = WeaponSetsCollectionFrame.RightFrame.Model.play:CreateTexture();
    --WeaponSetsCollectionFrame.RightFrame.Model.play.tex:SetAllPoints(WeaponSetsCollectionFrame.RightFrame.Model.play);
    --WeaponSetsCollectionFrame.RightFrame.Model.play.tex:SetColorTexture(.1,1,.1,.5);
    --WeaponSetsCollectionFrame.RightFrame.Model.play:SetScript("OnMouseDown", function(self)
    --        if WeaponSetsCollectionFrame.RightFrame.Model:HasAnimation(WeaponSetsCollectionFrame.RightFrame.Model.animation) then
    --          WeaponSetsCollectionFrame.RightFrame.Model:SetAnimation(WeaponSetsCollectionFrame.RightFrame.Model.animation);
    --        end
    --        WeaponSetsCollectionFrame.RightFrame.Model.playerText:SetText(WeaponSetsCollectionFrame.RightFrame.Model.animation);
    --        WeaponSetsCollectionFrame.RightFrame.Model.frame = 1;
    --  end) 
    --  
    --  
    --WeaponSetsCollectionFrame.RightFrame.Model.next = CreateFrame("Button", nil, WeaponSetsCollectionFrame.RightFrame);
    --WeaponSetsCollectionFrame.RightFrame.Model.next:SetPoint("BOTTOM", WeaponSetsCollectionFrame.RightFrame, "BOTTOM", 30, -40);
    --WeaponSetsCollectionFrame.RightFrame.Model.next:SetSize(35, 35);
    --WeaponSetsCollectionFrame.RightFrame.Model.next.tex = WeaponSetsCollectionFrame.RightFrame.Model.next:CreateTexture();
    --WeaponSetsCollectionFrame.RightFrame.Model.next.tex:SetAllPoints(WeaponSetsCollectionFrame.RightFrame.Model.next);
    --WeaponSetsCollectionFrame.RightFrame.Model.next.tex:SetColorTexture(.1,.1,1,.5);
    --WeaponSetsCollectionFrame.RightFrame.Model.next:SetScript("OnMouseDown", function(self, button)
    --        if button == "LeftButton" then
    --          WeaponSetsCollectionFrame.RightFrame.Model.animation = WeaponSetsCollectionFrame.RightFrame.Model.animation + 1;
    --        else
    --          WeaponSetsCollectionFrame.RightFrame.Model.animation = WeaponSetsCollectionFrame.RightFrame.Model.animation - 1;
    --        end
    --        local test = 0;
    --        while not WeaponSetsCollectionFrame.RightFrame.Model:HasAnimation(WeaponSetsCollectionFrame.RightFrame.Model.animation) and test < 100 do
    --          
    --          if button == "LeftButton" then
    --            WeaponSetsCollectionFrame.RightFrame.Model.animation = WeaponSetsCollectionFrame.RightFrame.Model.animation + 1;
    --          else
    --            WeaponSetsCollectionFrame.RightFrame.Model.animation = WeaponSetsCollectionFrame.RightFrame.Model.animation - 1;
    --          end
    --          test = test + 1;
    --        end
    --        if WeaponSetsCollectionFrame.RightFrame.Model:HasAnimation(WeaponSetsCollectionFrame.RightFrame.Model.animation) then
    --          WeaponSetsCollectionFrame.RightFrame.Model:SetAnimation(WeaponSetsCollectionFrame.RightFrame.Model.animation);
    --        end
    --        WeaponSetsCollectionFrame.RightFrame.Model.playerText:SetText(WeaponSetsCollectionFrame.RightFrame.Model.animation);
    --        WeaponSetsCollectionFrame.RightFrame.Model.frame = 1;
    --  end) 
    --
    --  
    --WeaponSetsCollectionFrame.RightFrame.Model.prevStep = CreateFrame("Button", nil, WeaponSetsCollectionFrame.RightFrame);
    --WeaponSetsCollectionFrame.RightFrame.Model.prevStep:SetPoint("BOTTOM", WeaponSetsCollectionFrame.RightFrame, "BOTTOM", 70, -40);
    --WeaponSetsCollectionFrame.RightFrame.Model.prevStep:SetSize(35, 35);
    --WeaponSetsCollectionFrame.RightFrame.Model.prevStep.tex = WeaponSetsCollectionFrame.RightFrame.Model.prevStep:CreateTexture();
    --WeaponSetsCollectionFrame.RightFrame.Model.prevStep.tex:SetAllPoints(WeaponSetsCollectionFrame.RightFrame.Model.prevStep);
    --WeaponSetsCollectionFrame.RightFrame.Model.prevStep.tex:SetColorTexture(1,.1,.1,.5);
    --WeaponSetsCollectionFrame.RightFrame.Model.prevStep:SetScript("OnMouseDown", function(self, button)
    --        if WeaponSetsCollectionFrame.RightFrame.Model:HasAnimation(WeaponSetsCollectionFrame.RightFrame.Model.animation) then
    --          if button == "LeftButton" then
    --            WeaponSetsCollectionFrame.RightFrame.Model.frame = WeaponSetsCollectionFrame.RightFrame.Model.frame + 1;
    --          else
    --            WeaponSetsCollectionFrame.RightFrame.Model.frame = WeaponSetsCollectionFrame.RightFrame.Model.frame - 1;
    --          end
    --          if WeaponSetsCollectionFrame.RightFrame.Model.frame == -2 then
    --            WeaponSetsCollectionFrame.RightFrame.Model.frame = 0;
    --          end
    --          WeaponSetsCollectionFrame.RightFrame.Model:FreezeAnimation(WeaponSetsCollectionFrame.RightFrame.Model.animation, 0, WeaponSetsCollectionFrame.RightFrame.Model.frame);
    --          WeaponSetsCollectionFrame.RightFrame.Model.playerText:SetText(WeaponSetsCollectionFrame.RightFrame.Model.animation);
    --          WeaponSetsCollectionFrame.RightFrame.Model.playerFrameText:SetText(WeaponSetsCollectionFrame.RightFrame.Model.frame);
    --        end
    --  end) 
    
    if ElvUI then
      local E = unpack(ElvUI);
      local S = E:GetModule('Skins')
      S:HandleTab(WardrobeCollectionFrame.WeaponsTab)
      S:HandleButton(WeaponSetsCollectionFrame.LeftFrame.FilterButton)
      S:HandleButton(WeaponSetsCollectionFrame.RightFrame.VariantDropDownButton)
      WeaponSetsCollectionFrame:SetTemplate('Transparent')
      WeaponSetsCollectionFrame.RightFrame:StripTextures()
      WeaponSetsCollectionFrame.LeftFrame:StripTextures()
      WeaponSetsCollectionFrame.RightFrame.DetailsFrame.Name:FontTemplate(nil, 16)
      
      S:HandleEditBox(WeaponSetsCollectionFrame.LeftFrame.SearchBox)
      
      WeaponSetsCollectionFrame.RightFrame.SwapPose.backTex:SetVertexColor(0.60,0.6,0.6,0.45);
      WeaponSetsCollectionFrame.RightFrame.ResetRotation.backTex:SetVertexColor(0.60,0.6,0.6,0.45);
      WeaponSetsCollectionFrame.RightFrame.SwapPlayerItem.backTex:SetVertexColor(0.60,0.6,0.6,0.45);
      WeaponSetsCollectionFrame.RightFrame.dualWield.backTex:SetVertexColor(0.60,0.6,0.6,0.45);
      
      --WeaponSetsCollectionFrame.RightFrame.ResetRotation:SetPoint("TOPRIGHT", WeaponSetsCollectionFrame.RightFrame, "TOPRIGHT", -5, -5);
    end
    ]]
  elseif pEvent == "TRANSMOG_COLLECTION_ITEM_UPDATE" then
    if not expectingTransmogInfoUpdate then return; end
    SelectWeapon();
  elseif ( pEvent == "UNIT_FORM_CHANGED" and pUnit == "player" ) then
    WeaponSetsCollectionFrame.RightFrame.Model:SetUnit("player", false, not select(2,C_PlayerInfo.GetAlternateFormInfo()));
    SelectWeapon();
  elseif pEvent == "TRANSMOG_COLLECTION_SOURCE_ADDED" then
    local itemID = C_TransmogCollection.GetSourceItemID(pUnit)
    local appID, notInTable = app.AppID(pUnit)
    
    if notInTable then return; end
    local setIDs, isArmor = app.FindSetIDByAppID(appID);
    if isArmor then return end
    
    if AllSets then
      local updateCollection = true;
      local sourceIDs = C_TransmogCollection.GetAllAppearanceSources(appID);
      for i=1,#sourceIDs do
        if sourceIDs[i] ~= pUnit then
          if C_TransmogCollection.GetSourceInfo(sourceIDs[i]).isCollected then
            updateCollection = false;
            break;
          end
        end
      end
      
      if updateCollection then
        for i=1,#setIDs do
          if AllSets[setIDs[i]] and AllSets[setIDs[i]].sources then
            for j=1,#AllSets[setIDs[i]].sources do
              if AllSets[setIDs[i]].sources[j][4] == appID then
                AllSets[setIDs[i]].sources[j][3] = C_TransmogCollection.GetSourceInfo(pUnit).isCollected;
                GetSetData(GetBaseSetID(setIDs[i]), true)
                break;
              end
            end
          end
        end
      end
    else
      CheckAndLinkWhileUnloaded(appID, pUnit)
    end
    
    --if app.wepSetsReady then
    --  FindAndSetCollected(appID, true, pUnit, setIDs, isArmor)
    --else
    --  CheckAndLinkWhileUnloaded(appID, pUnit)
    --end
  elseif pEvent == "TRANSMOG_COLLECTION_SOURCE_REMOVED" then
    local itemID = C_TransmogCollection.GetSourceItemID(pUnit)
    local appID, notInTable = app.AppID(pUnit)
    if notInTable then return; end
    
    local item = Item:CreateFromItemID(itemID)
    item.sourceID = pUnit;
    item.appID = appID;
    item:ContinueOnItemLoad(function()
        local sources = C_TransmogCollection.GetAllAppearanceSources(item.appID);
        local unlocked = false;
        for i=1,#sources do
          if C_TransmogCollection.GetSourceInfo(sources[i]).isCollected then
            unlocked = true;
            break;
          end
        end
        
        if not unlocked then 
          FindAndSetCollected(item.appID, false)
        end
    end)
  end
end)
-- Standalone ExtendedSets created and rewired a Blizzard tab here. The embedded
-- build deliberately exposes the frame through BetterWardrobe's fourth tab.
function app.ShowWeaponSetsFrame(parent)
  WardrobeCollectionFrame = parent or BetterWardrobeCollectionFrame or WardrobeCollectionFrame
  if not WardrobeCollectionFrame then return end
  WeaponSetsCollectionFrame:InitWeaponFrame()
  WeaponSetsCollectionFrame:Show()
  WardrobeCollectionFrame.activeFrame = WeaponSetsCollectionFrame
end

function app.HideWeaponSetsFrame()
  if WeaponSetsCollectionFrame and WeaponSetsCollectionFrame:IsShown() then
    WeaponSetsCollectionFrame:Hide()
  end
end
