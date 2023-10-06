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
	[25034] = 24955, --25man Normal ICC Mage

--cata
	--Firelands,
	[36576] = 36581, --Shaman, Pants/Kilt (Heroic)
	[36781] = 36771, --Shaman, Pants/Kilt (Heroic)

	--Bastion of Twilight
	[30012] = 47088, --Druid, Chest/Robe (Normal)
	[32758] = 27831, --Druid, Chest/Robe (Normal)

	[37761] = 45575, --Paladin, Chest/Robe (Season 11 Gladiator)

--Mists
	--Siege of Orgrimmar, 
	[52453] = 57092, --Druid, Chest/Robe (Normal)

	[52273] = 61897, --Shaman, Chest/Robe (LFR)
	[52387] = 61896, --Shaman, Chest/Robe (Normal)
	[52632] = 61898, --Shaman, Chest/Robe (Mythic)

	--Throne of Thunder,
	[50389] = 50218, --Monk, Chest/Robe (LFR)
	[50015] = 49631, --Monk, Chest/Robe (Normal)
	[51013] = 50842, --Monk, Chest/Robe (Heroic)

	[50436] = 50431, --Shaman, Chest/Robe (LFR)
	[50062] = 50057, --Shaman, Chest/Robe (Normal)
	[51060] = 51055, --Shaman, Chest/Robe (Heroic)

	--Heart of Fear
	[44527] = 44697, --Shaman, Chest/Robe (LFR)
	[43647] = 46990, --Shaman, Chest/Robe (Normal)
	[44975] = 44970, --Shaman, Chest/Robe (Heroic)

	[44556] = 46685, --Death Knight, Chest/Robe (LFR)
	[43676] = 46992, --Death Knight, Chest/Robe (Normal)
	[44780] = 46654, --Death Knight, Chest/Robe (Heroic)

	[43002] = 48776, --Paladin, Chest/Robe (Season 12 Honor)
	[43265] = 47810, --Paladin, Chest/Robe (Season 12 Gladiator)

--Warlords
	--Blackrock Foundry
	[64430] = 62671, --Druid, Chest/Robe (Normal)
	[67120] = 62673, --Druid, Chest/Robe (Heroic)
	[67121] = 67117, --Druid, Chest/Robe (Mythic)

	[64467] = 62902, --Shaman, Chest/Robe (Normal)
	[67283] = 62904, --Shaman, Chest/Robe (Heroic)
	[67284] = 67278, --Shaman, Chest/Robe (Mythic)

	--Hellfire Citadel
	[69707] = 69703, --Druid, Chest/Robe (Normal)
	[69708] = 69705, --Druid, Chest/Robe (Heroic)
	[69709] = 69706, --Druid, Chest/Robe (Mythic)

	[69710] = 69696, --Monk, Chest/Robe (Normal)
	[69711] = 69697, --Monk, Chest/Robe (Heroic)
	[69712] = 69698, --Monk, Chest/Robe (Mythic)

	[69910] = 69839, --Shaman, Chest/Robe (Normal)
	[69911] = 69841, --Shaman, Chest/Robe (Heroic)
	[69912] = 69842, --Shaman, Chest/Robe (Mythic)

	[64517] = 64620, --Druid, Chest/Robe (Season 1 Gladiator)
	[70431] = 70462, --Druid, Chest/Robe (Season 2 Gladiator)
	[70500] = 70467, --Monk, Chest/Robe (Season 2Gladiator)
	[70913] = 70864, --haman, Chest/Robe (Season 2 Gladiator)
	[71411] = 71378, --Monk, Chest/Robe (Season 3 Gladiator)
	[71342] = 71373, --Druid, Chest/Robe (Season 3 Gladiator)
	[71824] = 71775, --Shaman, Chest/Robe (Season 3 Gladiator)

--legion
	--Vault of the Incarnates
	[182774] = 181635, --Shaman, Chest/Robe (Mythic)

	--Seat of the Triumvirate
	[89366] = 89232, --Mail, Chest/Robe

	--Nighthold
	[81072] = 81901, --Shaman, Chest/Robe (LFR)
	[79880] = 81898, --Shaman, Chest/Robe (Normal)
	[79881] = 81899, --Shaman, Chest/Robe (Heroic)
	[79882] = 81900, --Shaman, Chest/Robe (Mythic)

	[79892] = 113019, --Paladin, Chest/Robe (Normal)

--bfa
	--Battle of Dazar'alor
	[102235] = 102247, --Leather, Chest/Robe (LFR)
	[102234] = 102246, --Leather, Chest/Robe (Normal)
	[102236] = 102248, --Leather, Chest/Robe (Heroic)
	[102237] = 102249, --Leather, Chest/Robe (Mythic)

	[101881] = 102239, --Mail, Chest/Robe (LFR)
	[101880] = 102238, --Mail, Chest/Robe (Normal)
	[101882] = 102240, --Mail, Chest/Robe (Heroic)
	[101883] = 102241, --Mail, Chest/Robe (Mythic)

	--Eternal Palace
	[104431] = 104443, --Mail, Chest/Robe (LFR)
	[104432] = 104444, --Mail, Chest/Robe (Heroic)
	[104430] = 104442, --Mail, Chest/Robe (Normal)
	[104433] = 104445, --Mail, Chest/Robe (Mythic)

	--Ny'alotha
	[108190] = 107475, --Mail, Chest/Robe (LFR)
	[108189] = 108177, --Mail, Chest/Robe (Normal)
	[108191] = 108179, --Mail, Chest/Robe (Heroic)
	[108192] = 108180, --Mail, Chest/Robe (Mythic)

	--Season 1 Warfront
	[101671] = 102794, --Cloth, Chest/Robe (Alliance)
	[100640] = 99274, --Leather, Chest/Robe (Horde)

	--Season 4
	[106772] = 107212, --Mail, Corrupted Gladiator's Chain Chest/Robe
	[106773] = 106901, --Mail, Corrupted Gladiator's Chain Chest/Robe (Elite)

--Shadowlands
	--Kyrian
	[115998] = 115990, --Devoted Aspirant's Chest/Robe
	[115999] = 115982, --Aspiring Aspirant's Chest/Robe
	[116000] = 115974, --Forsworn Aspirant's Chest/Robe
	[115966] = 116001, --attlefield Aspirant's Chest/Robe


	--Night Fae Cloth
	[109219] = 112439, --Faewoven Chest/Robe
	[112436] = 112440, --Night Courtier's Chest/Robe
	[112437] = 112441, --Conservator's Chest/Robe
	[112438] = 112442, --Winterborn Chest/Robe

	--Night Fae Leather
	[112554] = 112545, --Oakheart Chest/Robe
	[112573] = 112555, --Conservator's Chest/Robe
	[112574] = 112556, --Night Courtier's Chest/Robe
	[112575] = 112557, --Winterborn Chest/Robe

	--Night Fae Mail
	[113805] = 113841, --Runewarden's Chest/Robe
	[113820] = 113839, --Winterborn Chest/Robe
	[113828] = 113837, --Night Courtier's Chest/Robe
	[113836] = 113840, --Conservator's Chest/Robe

	--Castle Nathria
	[115105] = 115109, --Depraved Beguiler's Chest/Robe (LFR)
	[114499] = 114511, --Depraved Beguiler's Chest/Robe (Normal)
	[115106] = 115110, --Depraved Beguiler's Chest/Robe (Heroic)
	[115131] = 115133, --Depraved Beguiler's Chest/Robe (Mythic)

	--Sepulcher of the First Ones
	[166170] = 167953, --Priest Chest/Robe (LFR)
	[166169] = 167952, --Priest Chest/Robe (Normal)
	[166171] = 167954, --Priest Chest/Robe (Heroic)
	[166172] = 167955, --Priest Chest/Robe (Mythic)

--DF
	--Vault of the Incarnates
	[182772] = 181636, --Shaman,LFR
	[182771] = 181146, --Shaman, (Normal) 
	[182773] = 181634, --Shaman, (Heroic) 
	[182774] = 181635, --Shaman, (Mythic)

	-- [180804] = 180831,--Cloth Titan Keeper's Vestments, Dungeon (red)
	[179945] = 182935,--Cloth Titan Keeper's Vestments, WQ (blue)

	[183080] = 183073 , --Sabellian Set

	--Heritage Armor
	[102667] = 102661, --Blood Elf, Chest/Robe
	[107808] = 108030, --Goblin, Goggles
	[107820] = 107821, --Worgen, Chest/Robe

		--Fireplume cosmetic
	[169680] = {169689,169778,169779}, --Fireplume legs
	[169679] = {169688, 169782}, --Fireplume Chest
	[169777] = 169681, --Fireplume Gloves

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