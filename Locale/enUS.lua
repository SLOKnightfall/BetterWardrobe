local addonName, addon = ...
local L = _G.LibStub("AceLocale-3.0"):NewLocale("BetterWardrobe", "enUS", true, true)

if not L then return end

local DEFAULT = 1
local APPEARANCE = 2
local ALPHABETIC = 3
local ITEM_SOURCE = 6
local EXPANSION = 5
local ARTIFACT = 7
local ILEVEL = 8
local ITEMID = 9


local COLOR = 4
local TAB_ITEMS = 1
local TAB_SETS = 2
local TAB_EXTRASETS = 3

L[DEFAULT] = _G["DEFAULT"]
L[APPEARANCE] = APPEARANCE_LABEL
L[ALPHABETIC] = COMPACT_UNIT_FRAME_PROFILE_SORTBY_ALPHABETICAL
L[ITEM_SOURCE] = SOURCE:gsub("[:：]", "")
L[COLOR] = _G["COLOR"]
L[EXPANSION] = "Expansion"
L[ARTIFACT] = ITEM_QUALITY6_DESC

L[ILEVEL] = "ILevel"
L[ITEMID] = "ItemID"

L.OM_GOLD = "|c00FFD200"
L.ENDCOLOR = "|r"

--_G["BINDING_NAME_" .. name
_G["BINDING_HEADER_BETTERWARDROBE"] = addonName
_G["BINDING_NAME_BETTERWARDROBE_BINDING_PLAYERMODEL"] = "Use Player Model"
_G["BINDING_NAME_BETTERWARDROBE_BINDING_TARGETMODEL"] = "Use Target Model"
_G["BINDING_NAME_BETTERWARDROBE_BINDING_TARGETGEAR"] = "Use Target Gear"
_G["BINDING_NAME_BETTERWARDROBE_BINDING_TOGGLE_DRESSINGROOM"] = "Toggle DressingRoom"

L["CLOTH"] = "Cloth"
L["LEATHER"] = "Leather"
L["MAIL"] = "Mail"
L["PLATE"] = "Plate"

L["No Recolors Found"] = true

--------------------------------------------------------------------------
------------------------------ OPTIONS MENU ------------------------------
--------------------------------------------------------------------------

--############################-- TABS --#############################--

L["Options"] = true
L["Settings"] = true
L["Options Profiles"] = true

L["List Profiles"] = true
L["Favorite Items & Sets"] = true
L["Collection List"] = true
L["Hidden Items & Sets"] = true

L["Item Substitution"] = true
L["Items"] = true
L["Profiles"] = true

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ GENERAL ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

L["General Options"] = true
L["Ignore Class Restriction Filter"] = true
L["Only for Raid Lookalike/Recolor Sets"] = true
L["Print Set Collection alerts to chat:"] = true
L["Sets"] = true
L["Extra Sets"] = true
L["MogIt Saved Set"] = true
L["TransmogOutfits Saved Set"] = true
L["Collection List"] = true
L["TSM Source to Use"] = true
L["Profiles for sharing the various lists across characters"] = true

--~~~~~~~~~~~~~~~~~~~~~~~ TRANSMOG VENODR WINDOW ~~~~~~~~~~~~~~~~~~~~~~~--

L["Transmog Vendor Window"] = true
L["Larger Transmog Area"] = true
L["Extra Large Transmog Area"] = true
L["Max Width"] = true

L["LargeTransmogArea_Tooltip"] = "Increases the Transmog Vendor Window"
L["ExtraLargeTransmogArea_Tooltip"] = "Increase the Transmog Vendor Window to fill width of screen"
L["LargeTransmogArea_Tooltip"] = "Increases the Transmog Vendor Window"
L["ExtraLargeTransmogAreaMax_Tooltip"] = "Increase the Transmog Vendor Window to fill width of screen"
L["Show Incomplete Sets"] = true
L["Show Items set to Hidden"] = true
L["Show Hidden Items"] = true
L["Hide Missing Set Pieces at Transmog Vendor"] = true
L["Use Hidden Transmog for Missing Set Pieces"] = true
L["Required pieces"] = true
L["Show Set Names"] = true
L["Show Collected Count"] = true

L["Select Slot to Hide"] = true
L["Requires 'Show Incomplete Sets' Enabled"] = true

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TOOLTIP ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

L["Tooltip Options"] = true
L["Show Set Info in Tooltips"] = true
L["Show Set Collection Details"] = true
L["Only List Missing Pieces"] = true
L["Show Item ID"] = true
L["Show if appearance is known"] = true
L["Show if additional sources are available"] = true
L["Show Token Information"] = true

L["Class can't use item for transmog"] = true
L["Show unable to uses as transmog warning"] = true
L["Item No Longer Obtainable."] = true

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ITEM PREVIEW ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

L["Item Preview Options"] = true
L["Appearance Preview"] = true
L["Only show if modifier is pressed"] = true
L["None"] = true
L["Only transmogrification items"] = true
L["Try to preview armor tokens"] = true
L["Prevent Comparison Overlap"] = true
L["TooltipPreview_Overlap_Tooltip"] = "If the comparison tooltip is shown where the preview would want to be, show next to it"
L["Zoom:"] = true
L["On Weapons"] = true
L["On Clothes"] = true
L["Dress Preview Model"] = true
L["TooltipPreview_Dress_Tooltip"] = "Show the model wearing your current outfit, apart from the previewed item"
L["Use Dressing Dummy Model"] = true
L["TooltipPreview_DressingDummy"] = "Hide the details of your player model while you're zoomed (like the transmog wardrobe does)"
L["Auto Rotate"] = true
L["TooltipPreviewRotate_Tooltip"] = "Constantly spin the model while it's displayed"
L["Rotate with mouse wheel"] = true
L["TooltipPreview_MouseRotate_Tooltip"] = "Use the mousewheel to rotate the model in the tooltip"
L["Anchor point"] = true
L["Top/bottom"] = true
L["Left/right"] = true
L["TooltipPreview_Anchor_Tooltip"] = "Side of the tooltip to attach to, depending on where on the screen it's showing"
L["Height"] = true
L["Width"] = true
L["Reset"] = true
L["Use custom model"] = true
L["CUSTOM_MODEL_WARNING"] = "*Custom models are set to the transmog dressing model, and might not display correctly"
L["Model race"] = true
L["Model gender"] = true
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ DRESSING ROOM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

L["Dressing Room Options"] = true
L["Enable"] = true
L["Show Item Buttons"] = true
L["Show Narcissus Buttons"] = true
L["Show DressingRoom Controls"] = true
L["Dim Backround Image"] = true
L["Hide Backround Image"] = true
L["Start Undressed"] = true
L["Hide Weapons"] = true
L["Hide Shirt"] = true
L["Hide Tabard"] = true
L["Resize Window"] = true

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ITEM SUBSTITUTION ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

L["Items"] = true
L["Base Item ID"] = true
L["Not a valid itemID"] = true
L["Replacement Item ID"] = true
L["Remove"] = true
L["Add"] = true
L["Item Locations Don't Match"] = true
L["Saved Item Substitutes"] = true

L["item: %d - %s \n==>\nitem: %d - %s"] = true

--------------------------------------------------------------------------
-------------------------- ARTIFACT APPEARANCES --------------------------
--------------------------------------------------------------------------

L["Base Appearance"] = true
L["Class Hall Appearance"] = true
L["Mythic Dungeon Quests Appearance"] = true
L["PvP Appearance"] = true
L["Hidden Appearance"] = true
L["Mage Tower Appearance"] = true
L["Learned from Item"] = true

--------------------------------------------------------------------------
----------------------------- DROPDOWN MENUS -----------------------------
--------------------------------------------------------------------------

L["Visual View"] = true

L["Default"] = true
L["Expansion"] = true
L["Missing:"] = true
L["Armor Type"] = true

L["Class Sets Only"] = true
L["Hide Unavailable Sets"] = true
L["MISC"] = true
L["Classic Set"] = true
L["Quest Set"] = true
L["Dungeon Set"] = true
L["Raid Recolor"] = true
L["Raid Lookalike"] = true
L["Recolor"] = true
L["Raid Set"] = true
L["PvP"] = true
L["Garrison"] = true
L["Island Expedition"] = true
L["Warfronts"] = true
L["Covenants"] = true

L["Use Hidden Item for Unavilable Items"] = true
L["View Recolors"] = true
L["View Sources"] = true

--------------------------------------------------------------------------
---------------------------- COLLECTION LIST -----------------------------
--------------------------------------------------------------------------

L["Appearance added."] = true
L["Appearance removed."] = true

L["%s: Uncollected items added"] = true
L["No new appearces needed."] = true

L["COLLECTION_LIST_HELP"] = "Add items to the list by right clicking on an item or set,\n then select 'Add to Collection List'"

L["View All"] = true
L["Add List"] = true
L["Rename"] = true
L["Delete"] = true
L["Create Copy"] = true
L["Add by Item ID"] = true

L["Export TSM Groups"] = true
L["%sgroup:Appearance Group %s,"] = true
L["Collected"] = true
L["Not Collected"] = true

L["Type the item ID in the text box below"] = true

L["List Name"] = true

L["Click: Show Collection List"] = true
L["Shift Click: Show Detail List"] = true

--------------------------------------------------------------------------
----------------------------- DRESSING ROOM ------------------------------
--------------------------------------------------------------------------

L["Display Options"] = true
L["Character Options"] = true

L["Import/Export Options"] = true
L["Load Set: %s"] = true
L["None Selected"] = true

L["Import Item"] = true
L["Import Set"] =  true
L["Export Set"] = true
L["Create Dressing Room Command Link"] = true

L["Target Options"] = true
L["Use Player Model"] = true
L["Use Target Model"] = true
L["Use Target Gear"] = true
L["Undress"] = true
L["Hide Armor Slots"] = true

--------------------------------------------------------------------------
----------------------------- IMPORT EXPORT ------------------------------
--------------------------------------------------------------------------

L["Copy and paste a Wowhead Compare URL into the text box below to import"] = true
L["Import"] = true
L["Type the item ID or url in the text box below"] = true
L["Export"] = true

--------------------------------------------------------------------------
------------------------------- RANDOMIZER -------------------------------
--------------------------------------------------------------------------

L["Click: Randomize Items"] = true
L["Shift Click: Randomize Outfit"] = true

--------------------------------------------------------------------------
-------------------------------- TOOLTIPS --------------------------------
--------------------------------------------------------------------------

L["HEADERTEXT"] = '|cffffd100--------================--------'
L["Item ID"] = true

L["-Appearance in %d Collection List-"] = true
L["Part of Set:"] = true
L["Part of Extra Set:"] = true

L["-%s %s(%d/%d)"] = true
L["|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t %s%s"] = true
L["|TInterface\\RaidFrame\\ReadyCheck-NotReady:0|t %s%s"] = true

--------------------------------------------------------------------------
----------------------------------- UI -----------------------------------
--------------------------------------------------------------------------

L["unhiding_item"] = "Unhiding"
L["unhiding_item_end"] = "from the Appearances Tab"
L["hiding_item"] = "Hiding"
L["hiding_item_end"] = "from the Appearances Tab"

L["unhiding_set"] = "Unhiding"
L["unhiding_set_end"] = "" -- used for german
L["hiding_set"] = "Hiding"
L["hiding_set_end"] = "" -- used for german

L["Queue Transmog"] = true

L["Add to Collection List"] = true
L["Remove from Collection List"] = true

L["Toggle Hidden View"] = true

--------------------------------------------------------------------------
----------------------------- BETTERWARDROBE -----------------------------
--------------------------------------------------------------------------

L["Added missing appearances of: \124cffff7fff\124H%s:%s\124h[%s]\124h\124r"] = true
L["Added appearance in Collection List"] = true

L["Set Substitution"] = true
L["Substitute Item"] = true

L["Item No Longer Available"] = true

L["Select color"] = true
L["Reset"] = true

--------------------------------------------------------------------------
-------------------------------- DATABASE --------------------------------
--------------------------------------------------------------------------

L["Saved Set"] = true
L["Extended Saved Set"] = true
L["COLLECTIONLIST_TEXT"] = "%s - %s"
L["SHOPPINGLIST_TEXT"] = "%s - %s: %s"


L["Class can't collect or use appearance."] = true
L["Class can't use appearance. Useable appearance available."] = true

 L["Contained in"] = true
 L["Created by"] = true
 L["No Data Available"] = true
--Autogenerated below this
L["NOTE_0"] = ""
--Pvp
L["NOTE_8"] = "Level 60 PvP Epic Set"
L["NOTE_6"] = "Level 60 PvP Rare Set"
--L["NOTE_16"] = "Level 70 PvP Rare Set"
L["NOTE_21"] = "Level 70 PvP Rare Set 2"

L["NOTE_17"] = "Arena Season 1 Set"
L["NOTE_19"] = "Arena Season 2 Set"
L["NOTE_20"] = "Arena Season 3 Set"
L["NOTE_22"] = "Arena Season 4 Set"
L["NOTE_24"] = "Arena Season 5 Set"
L["NOTE_26"] = "Arena Season 6 Set"
L["NOTE_28"] = "Arena Season 7 Set"
L["NOTE_30"] = "Arena Season 8 Set"
L["NOTE_33"] = "Arena Season 9 Set"
L["NOTE_34"] = "Arena Season 10 Set"
L["NOTE_37"] = "Arena Season 11 Set"
L["NOTE_40"] = "Arena Season 12 Set"
L["NOTE_42"] = "Arena Season 13 Set"
L["NOTE_62"] = "Arena Season 14 Set"
L["NOTE_63"] = "Arena Season 15 Set"
L["NOTE_66"] = "Arena Season 16 Set"

L["NOTE_72"] = "Warlords Season 2"
L["NOTE_73"] = "Warlords Season 3"

L["NOTE_80"] = "Legion Honor Set"
L["NOTE_79"] = "Legion Season 1"
L["NOTE_83"] = "Legion Season 3"
L["NOTE_85"] = "Legion Season 5"

L["NOTE_89"] = "BFA Season 1"
L["NOTE_93"] = "BFA Season 2"
L["NOTE_95"] = "BFA Season 3"
L["NOTE_112"] = "BFA Season 4"

--Questing
L["NOTE_44"] = "Classic World Set"
L["NOTE_53"] = "Azeroth Questing Set"
L["NOTE_54"] = "WotLK Questing Set"
L["NOTE_55"] = "Cataclysm Questing Set"
L["NOTE_56"] = "Mists Questing Set"
L["NOTE_68"] = "Warlords Questing Set"
L["NOTE_75"] = "Legion Questing Set"
L["NOTE_81"] = "Broken Shore Questing Set"
L["NOTE_84"] = "Argus Questing Set"
L["NOTE_92"] = "BFA Questing Set"
L["NOTE_97"] = "Nazjatar Questing Set"
L["NOTE_101"] = "Shadowlands Questing Set"
--Dungeon Sets

L["NOTE_45"] = "Classic Dungeon Set"
L["NOTE_1"] = "Dungeon Set 1"
L["NOTE_2"] = "Dungeon Set 2"
L["NOTE_14"] = "Dungeon Set 3"
L["NOTE_46"] = "Troll Dungeon Set"
L["NOTE_47"] = "WotLK Dungeon Set 1"
L["NOTE_48"] = "WotLK Dungeon Set 2"
L["NOTE_49"] = "Hour of Twilight Dungeon Set"
L["NOTE_50"] = "Cataclysm Dungeon Set"
L["NOTE_51"] = "Mists Dungeon Set"
L["NOTE_52"] = "Challenge Mode Dungeon Set"
L["NOTE_67"] = "Warlords Dungeon Set"
L["NOTE_76"] = "Legion Dungeon Set"
L["NOTE_77"] = "Class Hall Set"
L["NOTE_87"] = "BFA Dungeon Set"
L["NOTE_102"] = "Shadowlands Dungeon Set"

--Raid


L["NOTE_3"] = "Molten Core Set"
L["NOTE_4"] = "Blackwing's Lair Set"
L["NOTE_5"] = "Naxxramas (Original) Raid Set"
L["NOTE_9"] = "Ruins of Ahn'Qiraj Set"
L["NOTE_10"] = "Temple of Ahn'Qiraj Raid Set"
L["NOTE_11"] = "Zul'Gurub Set"
L["NOTE_12"] = "Karazhan, Gruul'sLair and Magtheridon's Lair Raid Set"
L["NOTE_13"] = "Serpentshrine Cavern and Tempest Keep (The Eye) Raid Set"
L["NOTE_18"] = "Hyjal Summit, Black Temple and Sunwell Plateau Raid Set"
L["NOTE_23"] = "Naxxramas (Wrath) Raid Set"
L["NOTE_61"] = "WotLK Raid Set 1"
L["NOTE_25"] = "Ulduar Raid Set"
L["NOTE_27"] = "Trial of the Crusader Raid Set"
L["NOTE_29"] = "Icecrown Citadel Raid Set"
L["NOTE_31"] = "Bastion of Twilight and Blackwing Descent Raid Set"
L["NOTE_35"] = "Firelands Raid Set"
L["NOTE_38"] = "Dragon Soul Raid Set"
L["NOTE_39"] = "Terrace of the Endless Spring and the Heart of Fear Raid Set"
L["NOTE_43"] = "Throne of Thunde Raid Set"
L["NOTE_57"] = "Classic Resistance Set"
L["NOTE_58"] = "Sunwell Plateau Raid Set"


L["NOTE_59"] = "Mogu'shan Vaults Raid Set"
L["NOTE_64"] = "Siege of Orgrimmar Raid Set"
L["NOTE_65"] = "Blackrock Foundry Raid Set"
L["NOTE_70"] = "WarlordsLFR Set"
L["NOTE_71"] = "Hellfire Citadel Raid Set"
L["NOTE_78"] = "Nighthold Raid Set"
L["NOTE_82"] = "Tomb of Sargeras Raid Set"
L["NOTE_86"] = "Antorus, the Burning Throne. Raid Set"
L["NOTE_88"] = "Uldir Raid Set"
L["NOTE_94"] = "Dazar'alor Raid Set"
L["NOTE_96"] = "Eternal Palace Raid Set"
L["NOTE_109"] = "Castle Nathria Raid Set"

L["NOTE_90"] = "Heritage Armor"
L["NOTE_113"] = "Shadolands Legendary Armor"
--Event
L["NOTE_74"] = "Demon Invasion Event Set"
L["NOTE_91"] = "Island Expeditions Event Set"
L["NOTE_60"] = "Scourge Invasion Event Set"
L["NOTE_69"] = "Garrison Set"

L["NOTE_100"] = "Shadowlands Invasion Event Set"

--Shadowlands Covenant sets
L["NOTE_103"] = "Kyrian Covenant Set"
L["NOTE_104"] = "Venthyr Covenant Set"
L["NOTE_105"] = "Necrolord Covenant Set"
L["NOTE_106"] = "Night Fae Covenant Set"


L["NOTE_107"] = "Shadowlands Crafted Set"
L["NOTE_108"] = "Shadowlands Legendary Set"

L["NOTE_110"] = "Shadowlands PvP Set"
L["NOTE_111"] = "Shadowlands Crafted Set"
L["NOTE_115"] = "Shadowlands Callings Set"
L["NOTE_116"] = "Shadowlands Korthia Set"
L["NOTE_117"] = "Shadowlands Zereth Mortis Set"

L["Swap to Better Wardrobe View"] = true
L["Swap to Extended Transmog Sets View"] = true
