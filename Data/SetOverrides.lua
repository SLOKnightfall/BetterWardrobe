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

--DF Hero

------ Druid
--S1 Lost Lancallers Vesture - Druid head
	[182603] = 184207, --LFR
	[182604] = 184206, --Normal
	[182605] = 184208, --Heroic
	[182606] = 184209,--Mythic
	[183669] = 184210,--Glad
	[183670] = 184211,--Elite

--S1 Lost Lancallers Vesture - Shoulder
	[182612] = 184212, --LFR
	[182611] = 184213, --Normal
	[182613] = 184214, --Heroic
	[182614] = 184215, --Mythic
	[183677] = 184216, --Glad
	[183678] = 184217, --Elite

--S2 Strands of the Autumn Blaze - Druid Helm
	[186159] = 186163, --LFR
	[184489] = 186162, --Normal
	[186148] = 186164, --Heroic
	[186149] = 186165, --Mythic
	[186929] = 186166, --Glad
	[186930] = 186167, --Elite

--S2 Strands of the Autumn Blaze - Druid Shoulders
	[186147] = 186150, --LFR
	[184487] = 186151, --Normal
	[186160] = 186152, --Heroic
	[186161] = 186153, --Mythic
	[186937] = 186154, --Glad
	[186938] = 186155, --Elite


------ Priest
	--S1 Draconic Hierophants Finery - Priest head 
	[182496] = 184260, --LFR
	[182495] = 184261,--Normal
	[182497] = 184262, --Heroic
	[182498] = 184263,--Mythic
	[183573] = 184264,--Glad
	[183574] = 184265,--Elite

--Draconic Hierophants Shoulder
	[182504] = 184266, --LFR
	[182503] = 184267, --Normal
	[182505] = 184268, --Heroic
	[182506] = 184269,--Mythic
	[183581] = 184270,--Glad
	[183582] = 184271,--Elite

--S2 Furnace Seraphs Verdict - Priest Helm
	[186244] = 186248, --LFR
	[184516] = 186247, --Normal
	[186245] = 186249, --Heroic
	[186246] = 186250, --Mythic
	[186833] = 186251, -- Glad
	[186834] = 186252, --Elite


--S3 Blessings of Lunar Communion - Priest Helm
	[190041] = 190046, --LFR
	[188820] = 190047, --Normal
	[190042] = 190048, --Heroic
	[190043] = 190049, --Mythic
	[190232] = 190050, --Glad
	[190233] = 190051, --Elite

--===Hunter
--S1 Stormwing Harriers Camo - Hunter head
	[182748] = 184230, --LFR
	[182747] = 184231, --Normal
	[182749] = 184232, --Heroic
	[182750] = 184233,--Mythic
	[183766] = 184235,--Glad
	[183765] = 184234,--Elite

--S1 Stormwing Harriers Camo - Hunter Shoulder
	[182756] = 184236, --LFR
	[182755] = 184237, --Normal
	[182757] = 184238, --Heroic
	[182758] = 184239, --Mythic
	[183773] = 184240, --Glad
	[183774] = 184241, --Elite

--S2 Ashen Predators' Scaleform - Hunter Shoulder
	[186069] = 186072, --LFR
	[184451] = 186073, --Normal
	[186070] = 186074, --Heroic
	[186071] = 186075, --Mythic
	[187033] = 186076, --Glad
	[187034] = 186077, --Elite

--S3 Blazing Dremstaker - Hunter Shoulder
	[193358] = 193361, --LFR
	[188755] = 193362, --Normal
	[193359] = 193363, --Heroic
	[193360] = 193364, --Mythic
	[190506] = 193764, --Glad
	[190507] = 193765, --Elite


----Mage
	--S1 Bindings of the Crystal Scholar - Mage Helm
	[182460] = 183360, --LFR
	[182459] = 183359, --Normal
	[182461] = 183361, --Heroic
	[182462] = 183362, --Mythic
	[183445] = 184156, --Glad
	[183446] = 184157, --Elite

	--S1 Bindings of the Crystal Scholar - Mage Shoulder
	[182468] = 184166, --LFR
	[182467] = 184167, --Normal
	[182469] = 184168, --Heroic
	[182470] = 184169, --Mythic
	[183453] = 184171, --Glad
	[183454] = 184170, --Elite

	--S2 Underlight Conjuer's Aurora - Mage Shoulder
	[186040] = 193361, --LFR
	[184523] = 193362, --Normal
	[186341] = 193363, --Heroic
	[184362] = 193364, --Mythic
	[186723] = 193764, --Glad
	[186724] = 193765, --Elite

	--S3 Wayward Chronomancer Clockwork - Mage Helm
	[189129] = 189134, --LFR
	[188829] = 189135, --Normal
	[189130] = 189136, --Heroic
	[189131] = 189137, --Mythic
	[190192] = 189138, --Glad
	[190193] = 189139, --Elite

	--S3 Wayward Chronomancer Clockwork - Mage Shoulder
	[189107] = 189112, --LFR
	[189741] = 189113, --Normal
	[189108] = 189114, --Heroic
	[189109] = 189115, --Mythic
	[190202] = 189116, --Glad
	[190203] = 189117, --Elite

	--S3 Wayward Chronomancer Clockwork - Mage Belt
	[189096] = 189101, --LFR
	[188826] = 189102, --Normal
	[189097] = 189103, --Heroic
	[189098] = 189104, --Mythic
	[190206] = 189105, --Glad
	[190207] = 189106, --Elite

----Paladin
	--S1 Paladin Shoulder
	[182864] = 184254, --LFR
	[182863] = 184255, --Normal
	[182865] = 184256, --Heroic
	[182866] = 184257,--Mythic
	[183835] = 184258,--Glad
	[183836] = 184259,--Elite

--S2 Heartfire Sentinel's Authority - Paladin Shoulder
	[185982] = 185985, --LFR
	[184424] = 185986, --Normal
	[185983] = 185987, --Heroic
	[185984] = 185988, --Mythic
	[187095] = 185989, --Glad
	[187096] = 185990, --Elite

--S2 Heartfire Sentinel's Authority - Paladin Helm
	[185994] = 185998, --LFR
	[184426] = 185997, --Normal
	[185995] = 185999, --Heroic
	[185996] = 186000, --Mythic
	[187087] = 186001, --Glad
	[187088] = 186002, --Elite


---Shaman
	--S1 Elements of Infused Earth - shaman head 
	[182783] = 184285, --LFR
	[182784] = 184284,--Normal
	[182785] = 184286, --Heroic
	[182786] = 184287,--Mythic
	[183797] = 184288,--Glad
	[183798] = 184289,--Elite

	--  S1 Elements of Infused Earth - shaman Shoulder
	[182792] = 184290, --LFR
	[182791] = 184291, --Normal
	[182793] = 184292, --Heroic
	[182794] = 184293,--Mythic
	[183805] = 184294,--Glad
	[183806] = 184295,--Elite

	--S2 Runes of the Cinderwolf - Shaman Shoulders
	[186030] = 186033, --LFR
	[184442] = 186034, --Normal
	[186031] = 186035, --Heroic
	[186032] = 186036, --Mythic
	[187065] = 186037, --Glad
	[187066] = 186038, --Elite

	--S2 Runes of the Cinderwolf - Shaman Helm
	[186042] = 186046, --LFR
	[184444] = 186045, --Normal
	[186043] = 186047, --Heroic
	[186044] = 186048, --Mythic
	[187057] = 186049, --Glad
	[187058] = 186050, --Elite

	---Warrior


	--S1 Stones of the Walking Mountain - Warrior Head
	[182892] = 184308, --LFR
	[182891] = 184309,--Normal
	[182893] = 184310, --Heroic
	[182894] = 184311,--Mythic
	[183859] = 184312,--Glad
	[183860] = 184313, --Elite

	--  Stones of the Walking Mountain - S1 Warrior Shoulder
	[182900] = 184314, --LFR
	[182899] = 184315, --Normal
	[182901] = 184316, --Heroic
	[182902] = 184317,--Mythic
	[183867] = 184318,--Glad
	[183868] = 184319,--Elite

	--S2 Irons of the Onyx Crucible - Warrior Helm
	[185918] = 186311, --LFR
	[184417] = 186310, --Normal
	[185920] = 186312, --Heroic
	[185919] = 186313, --Mythic
	[187119] = 186314, --Glad
	[187120] = 186315, --Elite

	--S2 Irons of the Onyx Crucible - Warrior shoulder
	[186298] = 186301, --LFR
	[184415] = 186302, --Normal
	[186299] = 186303, --Heroic
	[186300] = 186304, --Mythic
	[187127] = 186305, --Glad
	[187128] = 186306, --Elite
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
	--C_TransmogCollection.GetItemInfo(202542)
end


function addon:CheckAltItem(sourceID)
	if altitems[sourceID] then
		return altitems[sourceID]
	end
end