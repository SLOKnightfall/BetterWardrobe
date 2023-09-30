local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local expansionID = 0;

--These are missing set items from the trial of style event
local SetAdditions = {
--[blizzard set ID] = {Item ID}    
[298] = {190064}, --sanctified-ymirjar-lords-battlegear-25-heroic-recolor
[700] = {190673}, --battleplate-of-immolation-heroic-recolor
[835] = {190858}, --elementium-deathplate-battlearmor-heroic-recolor

[634] = {190544},--volcanic-regalia-heroic-recolor
[741] = {190167},--conquerors-scourgestalker-battlegear-25-recolor
[643] = {190697},--conquerors-worldbreaker-regalia-25-recolor

[1482] = {190429},--bearmantle-battlegear-mythic-recolor
[1507] = {190202},--regalia-of-the-dashing-scoundrel-mythic-recolor
[1506] = {190202},--regalia-of-the-dashing-scoundrel-mythic-recolor
[693] = {190830},--conquerors-terrorblade-battlegear-25-recolor


[348] = {190803},--sanctified-crimson-acolyte-regalia-25-heroic
[664] = {190888},--vestments-of-the-faceless-shroud-heroic-recolor

[716] = {189870},--firehawk-robes-of-conflagration-heroic-recolor

}



local altitems = { 
--Wrath
    [25034] = 24955, --25man Normal ICC Mage alt robe texture

--cata
    [37761] = 45575, --Cataclysmic Gladiator's Scaled Armor (season 11), Plate/Paladin, Chest/Robe (Gladiator)

    [30012] = 47088, --Bastion of Twilight, Leather/Druid, Chest/Robe (Normal)
    [32758] = 27831, --Bastion of Twilight, Leather/Druid, Chest/Robe (Normal)

    [36781] = 36771, --Firelands, Mail/Shaman, Pants/Kilt (Heroic)
    [36576] = 36581, --Firelands, Mail/Shaman, Pants/Kilt (Heroic)

--Mists
    [52273] = 61897, --Siege of Orgrimmar, Mail/Shaman, Chest/Robe (LFR)
    [52387] = 61896, --Siege of Orgrimmar, Mail/Shaman, Chest/Robe (Normal)
    [52632] = 61898, --Siege of Orgrimmar, Mail/Shaman, Chest/Robe (Mythic)

    [52453] = 57092, --Siege of Orgrimmar, Leather/Druid, Chest/Robe (Normal)

    [51060] = 51055, --Throne of Thunder, Mail/Shaman, Chest/Robe (Heroic)
    [50062] = 50057, --Throne of Thunder, Mail/Shaman, Chest/Robe (Normal)
    [50436] = 50431, --Throne of Thunder, Mail/Shaman, Chest/Robe (LFR)

    [50015] = 49631, --Throne of Thunder, Leather/Monk, Chest/Robe (Normal)
    [50389] = 50218, --Throne of Thunder, Leather/Monk, Chest/Robe (LFR)
    [51013] = 50842, --Throne of Thunder, Leather/Monk, Chest/Robe (Heroic)

    [44975] = 44970, --Heart of Fear, Mail/Shaman, Chest/Robe (Heroic)
    [43647] = 46990, --Heart of Fear, Mail/Shaman, Chest/Robe (Normal)
    [44527] = 44697, --Heart of Fear, Mail/Shaman, Chest/Robe (LFR)

    [44556] = 46685, --Heart of Fear, Plate/DK, Chest/Robe (LFR)
    [43676] = 46992, --Heart of Fear, Plate/DK, Chest/Robe (Normal)
    [44780] = 46654, --Heart of Fear, Plate/DK, Chest/Robe (Heroic)

    [43265] = 47810, --Season 12, Plate/Paladin, Chest/Robe (Gladiator)
    [43002] = 48776, --Season 12, Plate/Paladin, Chest/Robe (Honor)

--Warlords
    --Hellfire Citadel
    [69708] = 69705, --Leather/Druid, Chest/Robe (Heroic)
    [69709] = 69706, --Leather/Druid, Chest/Robe (Mythic)
    [69707] = 69703, --Leather/Druid, Chest/Robe (Normal)

    [69710] = 69696, --Leather/Monk, Chest/Robe (Normal)
    [69711] = 69697, --Leather/Monk, Chest/Robe (Heroic)
    [69712] = 69698, --Leather/Monk, Chest/Robe (Mythic)

    [69911] = 69841, --Mail/Shaman, Chest/Robe (Heroic)
    [69910] = 69839, --Mail/Shaman, Chest/Robe (Normal)
    [69912] = 69842, --Mail/Shaman, Chest/Robe (Mythic)


    --Blackrock Foundry
    [64430] = 62671, --Leather/Druid, Chest/Robe (Normal)
    [67120] = 62673, --Leather/Druid, Chest/Robe (Heroic)
    [67121] = 67117, --Leather/Druid, Chest/Robe (Mythic)

    [64467] = 62902, --Mail/Shaman, Chest/Robe (Normal)
    [67283] = 62904, --Mail/Shaman, Chest/Robe (Heroic)
    [67284] = 67278, --Mail/Shaman, Chest/Robe (Mythic)

    [64517] = 64620, --Warlords Season 1, Leather/Druid, Chest/Robe (Gladiator)
    [70431] = 70462, --Warlords Season 2, Leather/Druid, Chest/Robe (Gladiator)
    [70500] = 70467, --Warlords Season 2, Leather/Monk, Chest/Robe (Gladiator)
    [70913] = 70864, --Warlords Season 2, Mail/Shaman, Chest/Robe (Gladiator)
    [71411] = 71378, --Warlords Season 3, Leather/Monk, Chest/Robe (Gladiator)
    [71342] = 71373, --Warlords Season 3, Leather/Druid, Chest/Robe (Gladiator)
    [71824] = 71775, --Warlords Season 3, Mail/Shaman, Chest/Robe (Gladiator)
--legion
    [182774] = 181635, --Shaman, Vault of the Incarnates, Mythic Vest
    [89366] = 89232, --Seat of the Triumvirate, Mail, Chest/Robe

    [81072] = 81901, --Nighthold, Mail-Shaman, Chest/Robe (LFR)
    [79882] = 81900, --Nighthold, Mail-Shaman, Chest/Robe (Mythic)
    [79880] = 81898, --Nighthold, Mail-Shaman, Chest/Robe (Normal)
    [79881] = 81899, --Nighthold, Mail-Shaman, Chest/Robe (Heroic)

    [79892] = 113019, --Nighthold, Plate-Paladin, Chest/Robe (Normal)
    --bfa
    [106773] = 106901, --Season 4 BfA, Mail, Corrupted Gladiator's Chain Chest/Robe (Elite)
    [106772] = 107212, --Season 4 BfA, Mail, Corrupted Gladiator's Chain Chest/Robe
    --Ny'alotha
    [108190] = 107475, --Mail, Chest/Robe (LFR)
    [108189] = 108177, --Mail, Chest/Robe (Normal)
    [108191] = 108179, --Mail, Chest/Robe (Heroic)
    [108192] = 108180, --Mail, Chest/Robe (Mythic)
    --Eternal Palace
    [104431] = 104443, --Mail, Chest/Robe (LFR)
    [104432] = 104444, --Mail, Chest/Robe (Heroic)
    [104430] = 104442, --Mail, Chest/Robe (Normal)
    [104433] = 104445, --Mail, Chest/Robe (Mythic)

    [101880] = 102238, --BoD, Mail, Chest/Robe (Normal)
    [101882] = 102240, --BoD, Mail, Chest/Robe (Heroic)
    [101881] = 102239, --BoD, Mail, Chest/Robe (LFR)
    [101883] = 102241, --BoD, Mail, Chest/Robe (Mythic)

    [102237] = 102249, --BoD, Leather, Chest/Robe (Mythic)
    [102236] = 102248, --BoD, Leather, Chest/Robe (Heroic)
    [102235] = 102247, --BoD, Leather, Chest/Robe (LFR)
    [102234] = 102246, --BoD, Leather, Chest/Robe (Normal)

    [101671] = 102794, --Season 1 BfA, Cloth, Chest/Robe (Warfront)(Alliance)
    [100640] = 99274, --Season 1 BfA, Leather, Chest/Robe (Warfront)(Horde)
    --Heritage Armor
    [102667] = 102661, --Blood Elf, Chest/Robe
    [107808] = 108030, --Goblin, Goggles Up/Down
    [107820] = 107821, --Worgen, Chest/Robe

--Shadowlands
    --Kyrian
    [115998] = 115990, --Devoted Aspirant's Chest/Robe
    [115999] = 115982, --Aspiring Aspirant's Chest/Robe
    [116000] = 115974, --Forsworn Aspirant's Chest/Robe
    [115966] = 116001, --attlefield Aspirant's Chest/Robe

    --Castle Nathria
    [115105] = 115109, --Depraved Beguiler's Chest/Robe (RF)
    [114499] = 114511, --Depraved Beguiler's Chest/Robe (Normal)
    [115106] = 115110, --Depraved Beguiler's Chest/Robe (Heroic)
    [115131] = 115133, --Depraved Beguiler's Chest/Robe (Mythic)

    --Night Fae Mail
    [113820] = 113839, --Winterborn Chest/Robe
    [113828] = 113837, --Night Courtier's Chest/Robe
    [113836] = 113840, --Conservator's Chest/Robe
    [113805] = 113841, --Runewarden's Chest/Robe
    --Night Fae Cloth
    [112438] = 112442, --Winterborn Chest/Robe
    [112436] = 112440, --Night Courtier's Chest/Robe
    [112437] = 112441, --Conservator's Chest/Robe
    [109219] = 112439, --Faewoven Chest/Robe
    --Night Fae Leather
    [112575] = 112557, --Winterborn Chest/Robe
    [112574] = 112556, --Night Courtier's Chest/Robe
    [112573] = 112555, --Conservator's Chest/Robe
    [112554] = 112545, --Oakheart Chest/Robe
    --Sepulcher of the First Ones
    [166170] = 167953, --Priest Chest/Robe (LFR)
    [166169] = 167952, --Priest Chest/Robe (Normal)
    [166171] = 167954, --Priest Chest/Robe (Heroic) --Heroic chest missing :(
    [166172] = 167955, --Priest Chest/Robe (Mythic)
    --Fireplume cosmetic
    [169680] = {169689,169778,169779}, --Fireplume legs
    [169679] = {169688, 169782}, --Fireplume Chest
    [169777] = 169681, --Fireplume Gloves

--DF
    -- [182594] = 181650,--Druid, Vault of the Incarnates, Mythic Vest, 
    [182774] = 181635,--Shaman, Vault of the Incarnates, Mail-Shaman, Mythic Vest, 
    [182771] = 181146,--Shaman, Vault of the Incarnates, Mail-Shaman, Normal Vest
    [182772] = 181636,--Shaman, Vault of the Incarnates, Mail-Shaman,LFR Vest
    [182773] = 181634,--Shaman, Vault of the Incarnates, Mail-Shaman, Heroic Vest

    -- [180804] = 180831,--Cloth Titan Keeper's Vestments, Dungeon (red)
    [179945] = 182935,--Cloth Titan Keeper's Vestments, WQ (blue)
}

--This will check to see if a set has items to add and then adds them
function addon:CheckForExtraItems(setID, data)
    if SetAdditions[setID]  then
        --print(C_TransmogCollection.GetItemInfo(setID))
        for _, itemID in ipairs(SetAdditions[setID]) do
            local itemAppearanceID, itemModifiedAppearanceID = C_TransmogCollection.GetItemInfo(itemID)
            local categoryID, visualID, canEnchant, icon, isCollected, itemLink, transmogLink, unknown1, itemSubTypeIndex = C_TransmogCollection.GetAppearanceSourceInfo(itemModifiedAppearanceID)
           -- print(isCollected)
            if itemAppearanceID then 
                tinsert(data,{["collected"] = isCollected, ["appearanceID"] = itemModifiedAppearanceID})
            end
        end
    end
    return data
    --C_TransmogCollection.GetItemInfo(190064)
end


function addon:CheckAltItem(sourceID)
    if altitems[sourceID] then
        return altitems[sourceID]
    end
end