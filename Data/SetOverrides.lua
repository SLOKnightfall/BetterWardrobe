local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local expansionID = 0;

--These are missing set items from the trial of style event
local SetAdditions = {
--[blizzard set ID] = {Item ID}    
	[298] = {190064}, --sanctified-ymirjar-lords-battlegear-25-Heroic-recolor
	[700] = {190673}, --battleplate-of-immolation-Heroic-recolor
	[835] = {190858}, --elementium-deathplate-battlearmor-Heroic-recolor
	[634] = {190544},--volcanic-regalia-Heroic-recolor
	[741] = {190167},--conquerors-scourgestalker-battlegear-25-recolor
	[643] = {190697},--conquerors-worldbreaker-regalia-25-recolor
	[1482] = {190429},--bearmantle-battlegear-Mythic-recolor
	[1507] = {190202},--regalia-of-the-dashing-scoundrel-Mythic-recolor
	[1506] = {190202},--regalia-of-the-dashing-scoundrel-Mythic-recolor
	[693] = {190830},--conquerors-terrorblade-battlegear-25-recolor
	[348] = {190803},--sanctified-crimson-acolyte-regalia-25-Heroic
	[664] = {190888},--vestments-of-the-faceless-shroud-Heroic-recolor
	[716] = {189870},--firehawk-robes-of-conflagration-Heroic-recolor
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

	[37761] = 45575, --Paladin, Chest/Robe (Season 11 Gladiatoriator)

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
	[43265] = 47810, --Paladin, Chest/Robe (Season 12 Gladiatoriator)

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

	[64517] = 64620, --Druid, Chest/Robe (Season 1 Gladiatoriator)
	[70431] = 70462, --Druid, Chest/Robe (Season 2 Gladiatoriator)
	[70500] = 70467, --Monk, Chest/Robe (Season 2Gladiatoriator)
	[70913] = 70864, --haman, Chest/Robe (Season 2 Gladiatoriator)
	[71411] = 71378, --Monk, Chest/Robe (Season 3 Gladiatoriator)
	[71342] = 71373, --Druid, Chest/Robe (Season 3 Gladiatoriator)
	[71824] = 71775, --Shaman, Chest/Robe (Season 3 Gladiatoriator)

--legion


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
	[106772] = 107212, --Mail, Corrupted Gladiatoriator's Chain Chest/Robe
	[106773] = 106901, --Mail, Corrupted Gladiatoriator's Chain Chest/Robe (Elite)

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
	[183669] = 184210,--Gladiator
	[183670] = 184211,--Elite

--S1 Lost Lancallers Vesture - Shoulder
	[182612] = 184212, --LFR
	[182611] = 184213, --Normal
	[182613] = 184214, --Heroic
	[182614] = 184215, --Mythic
	[183677] = 184216, --Gladiator
	[183678] = 184217, --Elite

--S2 Strands of the Autumn Blaze - Druid Helm
	[186159] = 186163, --LFR
	[184489] = 186162, --Normal
	[186148] = 186164, --Heroic
	[186149] = 186165, --Mythic
	[186929] = 186166, --Gladiator
	[186930] = 186167, --Elite

--S2 Strands of the Autumn Blaze - Druid Shoulders
	[186147] = 186150, --LFR
	[184487] = 186151, --Normal
	[186160] = 186152, --Heroic
	[186161] = 186153, --Mythic
	[186937] = 186154, --Gladiator
	[186938] = 186155, --Elite

--S2 Strands of the Autumn Blaze - Druid Belt
	[186138] = 186141, --LFR
	[184486] = 186142, --Normal
	[186139] = 186143, --Heroic
	[186140] = 186144, --Mythic
	[186941] = 186145, --Gladiator
	[186942] = 186146, --Elite

--s3
	[192484] = 192423, --LFR Shoulders
	[188791] = 192424, --Normal Shoulders
	[192485] = 192425, --Heroic Shoulders
	[192486] = 192426, --Mythic Shoulders
	[190316] = 192125, --Gladiator Shoulders
	[190317] = 192126, --Elite Shoulders

------ Priest
	--S1 Draconic Hierophants Finery - Priest head 
	[182496] = 184260, --LFR
	[182495] = 184261,--Normal
	[182497] = 184262, --Heroic
	[182498] = 184263,--Mythic
	[183573] = 184264,--Gladiator
	[183574] = 184265,--Elite

--Draconic Hierophants Shoulder
	[182504] = 184266, --LFR
	[182503] = 184267, --Normal
	[182505] = 184268, --Heroic
	[182506] = 184269,--Mythic
	[183581] = 184270,--Gladiator
	[183582] = 184271,--Elite

--S2 Furnace Seraphs Verdict - Priest Helm
	[186244] = 186248, --LFR
	[184516] = 186247, --Normal
	[186245] = 186249, --Heroic
	[186246] = 186250, --Mythic
	[186833] = 186251, -- Gladiator
	[186834] = 186252, --Elite

--S3 Blessings of Lunar Communion - Priest Helm
	[190041] = 190046, --LFR
	[188820] = 190047, --Normal
	[190042] = 190048, --Heroic
	[190043] = 190049, --Mythic
	[190232] = 190050, --Gladiator
	[190233] = 190051, --Elite

--===Hunter
	--S1 Stormwing Harriers Camo - Hunter head
	[182748] = 184230, --LFR
	[182747] = 184231, --Normal
	[182749] = 184232, --Heroic
	[182750] = 184233,--Mythic
	[183766] = 184235,--Gladiator
	[183765] = 184234,--Elite

	--S1 Stormwing Harriers Camo - Hunter Shoulder
	[182756] = 184236, --LFR
	[182755] = 184237, --Normal
	[182757] = 184238, --Heroic
	[182758] = 184239, --Mythic
	[183773] = 184240, --Gladiator
	[183774] = 184241, --Elite

	--S2 Ashen Predators' Scaleform - Hunter Shoulder
	[186069] = 186072, --LFR
	[184451] = 186073, --Normal
	[186070] = 186074, --Heroic
	[186071] = 186075, --Mythic
	[187033] = 186076, --Gladiator
	[187034] = 186077, --Elite

	--S2 Ashen Predators' Scaleform - Hunter head
	[186081] = 186085, --LFR
	[184453] = 186084, --Normal
	[186082] = 186086, --Heroic
	[186083] = 186087,--Mythic
	[187025] = 186088,--Gladiator
	[187026] = 186089,--Elite

--S3 Blazing Dremstaker - Hunter Shoulder
	[193358] = 193361, --LFR
	[188755] = 193362, --Normal
	[193359] = 193363, --Heroic
	[193360] = 193364, --Mythic
	[190506] = 193764, --Gladiator
	[190507] = 193765, --Elite

----Mage
	--S1 Bindings of the Crystal Scholar - Mage Helm
	[182460] = 183360, --LFR
	[182459] = 183359, --Normal
	[182461] = 183361, --Heroic
	[182462] = 183362, --Mythic
	[183445] = 184156, --Gladiator
	[183446] = 184157, --Elite

	--S1 Bindings of the Crystal Scholar - Mage Shoulder
	[182468] = 184166, --LFR
	[182467] = 184167, --Normal
	[182469] = 184168, --Heroic
	[182470] = 184169, --Mythic
	[183453] = 184171, --Gladiator
	[183454] = 184170, --Elite

	--S2 Underlight Conjuer's Aurora - Mage Shoulder
	[186040] = 193361, --LFR
	[184523] = 193362, --Normal
	[186341] = 193363, --Heroic
	[184362] = 193364, --Mythic
	[186723] = 193764, --Gladiator
	[186724] = 193765, --Elite

	--S3 Wayward Chronomancer Clockwork - Mage Helm
	[189129] = 189134, --LFR
	[188829] = 189135, --Normal
	[189130] = 189136, --Heroic
	[189131] = 189137, --Mythic
	[190192] = 189138, --Gladiator
	[190193] = 189139, --Elite

	--S3 Wayward Chronomancer Clockwork - Mage Shoulder
	[189107] = 189112, --LFR
	[189741] = 189113, --Normal
	[189108] = 189114, --Heroic
	[189109] = 189115, --Mythic
	[190202] = 189116, --Gladiator
	[190203] = 189117, --Elite

	--S3 Wayward Chronomancer Clockwork - Mage Belt
	[189096] = 189101, --LFR
	[188826] = 189102, --Normal
	[189097] = 189103, --Heroic
	[189098] = 189104, --Mythic
	[190206] = 189105, --Gladiator
	[190207] = 189106, --Elite

----Paladin
	--S1 Virtuous Silver Cataphract - Paladin Shoulder
	[182864] = 184254, --LFR
	[182863] = 184255, --Normal
	[182865] = 184256, --Heroic
	[182866] = 184257,--Mythic
	[183835] = 184258,--Gladiator
	[183836] = 184259,--Elite

	--S1 Virtuous Silver Cataphract - Paladin Chest
	[182844] = 184248, --LFR
	[182843] = 184249, --Normal
	[182845] = 184250, --Heroic
	[182846] = 184251,--Mythic
	[183815] = 184252,--Gladiator
	[183816] = 184253,--Elite


	--S2 Heartfire Sentinel's Authority - Paladin Shoulder
	[185982] = 185985, --LFR
	[184424] = 185986, --Normal
	[185983] = 185987, --Heroic
	[185984] = 185988, --Mythic
	[187095] = 185989, --Gladiator
	[187096] = 185990, --Elite

	--S2 Heartfire Sentinel's Authority - Paladin Helm
	[185994] = 185998, --LFR
	[184426] = 185997, --Normal
	[185995] = 185999, --Heroic
	[185996] = 186000, --Mythic
	[187087] = 186001, --Gladiator
	[187088] = 186002, --Elite

	--S3 
	[189316] = 189321, --LFR Shoulders
	[188728] = 189322, --Normal Shoulders
	[189317] = 189323, --Heroic Shoulders
	[189318] = 189324, --Mythic Shoulders
	[190620] = 189325, --Gladiator Shoulders
	[190621] = 189326, --Elite Shoulders


---Shaman
	--S1 Elements of Infused Earth - shaman head 
	[182783] = 184285, --LFR
	[182784] = 184284,--Normal
	[182785] = 184286, --Heroic
	[182786] = 184287,--Mythic
	[183797] = 184288,--Gladiator
	[183798] = 184289,--Elite

	--  S1 Elements of Infused Earth - shaman Shoulder
	[182792] = 184290, --LFR
	[182791] = 184291, --Normal
	[182793] = 184292, --Heroic
	[182794] = 184293,--Mythic
	[183805] = 184294,--Gladiator
	[183806] = 184295,--Elite

	--S2 Runes of the Cinderwolf - Shaman Shoulders
	[186030] = 186033, --LFR
	[184442] = 186034, --Normal
	[186031] = 186035, --Heroic
	[186032] = 186036, --Mythic
	[187065] = 186037, --Gladiator
	[187066] = 186038, --Elite

	--S2 Runes of the Cinderwolf - Shaman Helm
	[186042] = 186046, --LFR
	[184444] = 186045, --Normal
	[186043] = 186047, --Heroic
	[186044] = 186048, --Mythic
	[187057] = 186049, --Gladiator
	[187058] = 186050, --Elite

	--S3.
	[190536] = 189446, --Gladiator Helm
	[190544] = 189424, --Gladiator Shoulders
	[190537] = 189447, --Elite Helm
	[190545] = 189425, --Elite Shoulders
	[189437] = 189442, --LFR Helm
	[189415] = 189420, --LFR Shoulders
	[188748] = 189443, --Normal Helm
	[188746] = 189421, --Normal Shoulders
	[189438] = 189444, --Heroic Helm
	[189416] = 189422, --Heroic Shoulders
	[189439] = 189445, --Mythic Helm
	[189417] = 189423, --Mythic Shoulders

---Warrior
	--S1 Stones of the Walking Mountain - Warrior Head
	[182892] = 184308, --LFR
	[182891] = 184309,--Normal
	[182893] = 184310, --Heroic
	[182894] = 184311,--Mythic
	[183859] = 184312,--Gladiator
	[183860] = 184313, --Elite

	--  Stones of the Walking Mountain - S1 Warrior Shoulder
	[182900] = 184314, --LFR
	[182899] = 184315, --Normal
	[182901] = 184316, --Heroic
	[182902] = 184317,--Mythic
	[183867] = 184318,--Gladiator
	[183868] = 184319,--Elite

	--S2 Irons of the Onyx Crucible - Warrior Helm
	[185918] = 186311, --LFR
	[184417] = 186310, --Normal
	[185920] = 186312, --Heroic
	[185919] = 186313, --Mythic
	[187119] = 186314, --Gladiator
	[187120] = 186315, --Elite

	--S2 Irons of the Onyx Crucible - Warrior Shoulder
	[186298] = 186301, --LFR
	[184415] = 186302, --Normal
	[186299] = 186303, --Heroic
	[186300] = 186304, --Mythic
	[187127] = 186305, --Gladiator
	[187128] = 186306, --Elite

	--S3
	[193129] = 193134, --LFR Helm
	[193096] = 193101, --LFR Belt
	[193162] = 193167, --LFR Chest
	[193107] = 193112, --LFR Shoulder
	[188721] = 193135, --Normal Helm
	[188718] = 193102, --Normal Belt
	[188724] = 193168, --Normal Chest
	[188719] = 193113, --Normal Shoulder
	[193130] = 193136, --Heroic Helm
	[193097] = 193103, --Heroic Belt
	[193163] = 193169, --Heroic Chest
	[193108] = 193114, --Heroic Shoulder
	[193131] = 193137, --Mythic Helm
	[193098] = 193104, --Mythic Belt
	[193164] = 193170, --Mythic Chest
	[193109] = 193115, --Mythic Shoulder
	[190650] = 192875, --Gladiator Helm
	[190662] = 192883, --Gladiator Belt
	[190638] = 192863, --Gladiator Chest
	[190658] = 193070, --Gladiator Shoulder
	[190651] = 192876, --Elite Helm
	[190663] = 192884, --Elite Belt
	[190639] = 192864, --Elite Chest
	[190659] = 193071, --Elite Shoulder

---voker
	--S1 Scales of the Awakened -  Evoker head
	[182712] = 184218, --LFR
	[182711] = 184219, --Normal
	[182713] = 184220, --Heroic
	[182714] = 184221,--Mythic
	--[183445] = 184222,--Gladiator
	--[183446] = 184223,--Elite

	--s1 Scales of the Awakened -  Evoker Shoulder
	[182720] = 184224, --LFR
	[182719] = 184225, --Normal
	[182721] = 184226, --Heroic
	[182722] = 184227, --Mythic
	--[183453] = 184228, --Gladiator
	--[183454] = 184229, --Elite

	--S2 -  Evoker head
	[186388] = 186392, --LFR
	[184462] = 186391, --Normal
	[186389] = 186393, --Heroic
	[186390] = 186394,--Mythic
	--[183445] = 186395,--Gladiator
	--[183446] = 186396,--Elite

	--s2 -  Evoker Shoulder
	[186376] = 186379, --LFR
	[184460] = 186380, --Normal
	[186377] = 186381, --Heroic
	[186378] = 186382, --Mythic
	--[183453] = 186383, --Gladiator
	--[183454] = 186384, --Elite

	--s2 -  Evoker Belt
	[186367] = 186370, --LFR
	[184459] = 186371, --Normal
	[186368] = 186372, --Heroic
	[186369] = 186373, --Mythic
	--[183453] = 186374, --Gladiator
	--[183454] = 186375, --Elite

--S3
	[192021] = 192026, --LFR Helm
	[192054] = 193418, --LFR Chest
	[188766] = 192027, --Normal Helm
	[188769] = 188697, --Normal Chest
	[192022] = 192028, --Heroic Helm
	[192055] = 193419, --Heroic Chest
	[192023] = 192029, --Mythic Helm
	[192056] = 193420, --Mythic Chest
	[190460] = 192030, --Gladiator Helm
	[190448] = 193421, --Gladiator Chest
	[190461] = 192031, --Elite Helm
	[190449] = 193422, --Elite Chest

--- Warlock
	--S1 Scalesworn Cultists Habit - Warlock Head
	[182532] = 184296, --LFR
	[182531] = 184297,--Normal
	[182533] = 184298, --Heroic
	[182534] = 184299,--Mythic
	[183605] = 184300,--Gladiator
	[183606] = 184301, --Elite

	--S1 Scalesworn Cultists Habit - Warlock Shoulder
	[182540] = 184302, --LFR - 
	[182539] = 184303, --Normal
	[182541] = 184304, --Heroic
	[182542] = 184305,--Mythic
	[183613] = 184306,--Gladiator
	[183614] = 184307,--Elite


	[182540] = 186192, --LFR - 
	[182539] = 186193, --Normal
	[186190] = 186194, --Heroic
	[186191] = 186195,--Mythic
	[183613] = 186196,--Gladiator
	[183614] = 186197,--Elite


	--S2 Sinister Savants Cursethreads - Warlock Head
	[186204] = 186208, --LFR
	[184507] = 186207,--Normal
	[186205] = 186209, --Heroic
	[186206] = 186210,--Mythic
	[186865] = 186211,--Gladiator
	[186866] = 186212, --Elite


	--S2 Sinister Savants Cursethreads - Warlock Shoulder
	[186189] = 186192, --LFR - 
	[184505] = 186193, --Normal
	[182541] = 186194, --Heroic
	[182542] = 186195,--Mythic
	[186873] = 186196,--Gladiator
	[186874] = 186197,--Elite


--S3
	[189239] = 189244, --LFR Helm
	[189217] = 189222, --LFR Shoulders
	[188811] = 189245, --Normal Helm
	[188809] = 189223, --Normal Shoulders
	[189240] = 189246, --Heroic Helm
	[189218] = 189224, --Heroic Shoulders
	[189241] = 189247, --Mythic Helm
	[189219] = 189225, --Mythic Shoulders
	[190270] = 189248, --Gladiator Helm
	[190278] = 189226, --Gladiator Shoulders
	[190271] = 189249, --Elite Helm
	[190279] = 189227, --Elite Shoulders

---Rogue
	--S1 Vault Delvers Toolkit - Rogue head 
	[182676] = 184272, --LFR
	[182675] = 184273,--Normal
	[182677] = 184274, --Heroic
	[182678] = 184275,--Mythic
	[183733] = 184276,--Gladiator
	[183734] = 184277,--Elite

	--S1 Vault Delvers Toolkit - Rogue  Shoulder
	[182684] = 184278, --LFR
	[182683] = 184279, --Normal
	[182685] = 184280, --Heroic
	[182686] = 184281,--Mythic
	[183741] = 184282,--Gladiator
	[183742] = 184283,--Elite

	--S2 lurking Specters shadeweave - Rogue  Shoulder
	[186108] = 186111, --LFR
	[184469] = 186112, --Normal
	[186109] = 186113, --Heroic
	[186110] = 186114,--Mythic
	[187001] = 186115,--Gladiator
	[187002] = 186116,--Elite

--S3
	[191236] = 191550, --LFR Helm
	[191226] = 191538, --LFR Shoulders
	[188775] = 191551, --Normal Helm
	[188773] = 191539, --Normal Shoulders	
	[191237] = 191552, --Heroic Helm
	[191227] = 191540, --Heroic Shoulders
	[191238] = 191553, --Mythic Helm
	[191228] = 191541, --Mythic Shoulders
	[190422] = 191554, --Gladiator Helm
	[190430] = 191542, --Gladiator Shoulders
	[190423] = 191555, --Elite Helm
	[190431] = 191543, --Elite Shoulders

---Monk
	--S1 Wrappings of the Waking Fist - monk Shoulder
	[182648] = 184242, --LFR
	[182647] = 184243, --Normal
	[182649] = 184244, --Heroic
	[182650] = 184245,--Mythic
	[183710] = 184247,--Gladiator
	[183709] = 184246,--Elite

	--S1 Fangs of the Vermillion Forge - monk Head
	[185777] = 187679, --LFR
	[184480] = 187678, --Normal
	[185778] = 187680, --Heroic
	[185779] = 187681,--Mythic
	[186961] = 187682,--Gladiator
	[186962] = 187683,--Elite

	--S2 Fangs of the Vermillion Forge - monk Shoulder
	[185771] = 187690, --LFR
	[184478] = 187691, --Normal
	[185772] = 187692, --Heroic
	[185773] = 187693,--Mythic
	[186969] = 187694,--Gladiator
	[186970] = 187695,--Elite

	--S3
	[189514] = 189519, --LFR Shoulders
	[188782] = 189520, --Normal Shoulders
	[189515] = 189521, --Heroic Shoulders
	[189516] = 189522, --Mythic Shoulders
	[190392] = 189523, --Gladiator Shoulders
	[190393] = 189524, --Elite Shoulders


--Death Knight
	--S1 Haunted Frostbrood Remains - DK head
	[182820] = 184188, --LFR
	[182819] = 184189, --Normal
	[182821] = 184190, --Heroic
	[182822] = 184191, --Mythic
	[183541] = 184192, --Gladiator
	[183542] = 184193, --Elite

	--S1 Haunted Frostbrood Remainsd -DK Shoulder
	[182828] = 183363, --LFR
	[182827] = 184183, --Normal
	[182829] = 184184, --Heroic
	[182830] = 184185, --Mythic
	[183549] = 184186, --Gladiator
	[183550] = 184187, --Elite

	--S2 Lingering Phantoms Encasement - DK head
	[186279] = 187673, --LFR
	[184435] = 187672, --Normal
	[186277] = 187674, --Heroic
	[186278] = 187675, --Mythic
	[186802] = 187677, --Gladiator
	[186801] = 187676, --Elite

	--S2 Lingering Phantoms Encasement -DK Shoulder
	[186285] = 187685, --LFR
	[184433] = 187684, --Normal
	[186283] = 187686, --Heroic
	[186284] = 187687, --Mythic
	[186810] = 187689, --Gladiator
	[186809] = 187688, --Elite

	--S3 Amirdrassil
	[192275] = 192280, --LFR Helm
	[192253] = 192258, --LFR Shoulders
	[188739] = 192281, --Normal Helm
	[188737] = 192259, --Normal Shoulders
	[192276] = 192282, --Heroic Helm
	[192254] = 192260, --Heroic Shoulders
	[192277] = 192283, --Mythic Helm
	[192255] = 192261, --Mythic Shoulders
	[190574] = 192284, --Gladiator Helm
	[190582] = 192262, --Gladiator Shoulders
	[190575] = 192285, --Elite Helm
	[190583] = 192263, --Elite Shoulders


--DH
	--S1 Skybound Avangers Flightware -  DH Shoulder
	[182576] = 184200, --LFR
	[182575] = 184201, --Normal
	[182577] = 184202, --Heroic
	[182578] = 184203, --Mythic
	[183645] = 184204, --Gladiator
	[183646] = 184205, --Elite

	--S1 Skybound Avangers Flightware -  DH head
	[182568] = 184194, --LFR
	[182567] = 184195, --Normal
	[182569] = 184196, --Heroic
	[182570] = 184197, --Mythic
	[183637] = 184198, --Gladiator
	[183638] = 184199, --Elite

	--S2  Kinslayers Burdens -  DH head
	[186427] = 186431, --LFR
	[184498] = 186430, --Normal
	[186428] = 186432, --Heroic
	[186429] = 186433, --Mythic
	[186897] = 186434, --Gladiator
	[186898] = 186435, --Elite

	--S2 Kinslayers Burdens-  DH Shoulder
	[186415] = 186418, --LFR
	[184496] = 186419, --Normal
	[186416] = 186420, --Heroic
	[186417] = 186421, --Mythic
	[186905] = 186422, --Gladiator
	[186906] = 186423, --Elite

	--S3
	[192352] = 192357, --LFR Shoulders
	[188800] = 192358, --Normal Shoulders
	[192353] = 192359, --Heroic Shoulders
	[192354] = 192360, --Mythic Shoulders
	[190354] = 192163, --Gladiator Shoulders
	[190355] = 192164, --Elite Shoulders

--Cavern Delver
	--Cloth
	[185660] = 189905, --Endowed Garb - Shoulders
	[185658] = 189899, --Endowed Garb - Helm
	[185862] = 189898, --Moonless Vestiture - Helm
	[185864] = 189904, --Moonless Vestiture - Shoulders
	[188848] = 189897, --Anachronistic Vestments - Helm
	[188850] = 189903, --Anachronistic Vestments - Shoulders
	[185928] = 189896, --Zaralek Surveyor - Helm
	[185956] = 189902, --Zaralek Surveyor - Shoulders
	[185794] = 189895, --Suffused Attire - Helm
	[185790] = 189901, --Suffused Attire - Shoulders
	[189788] = 189894, --Infinite Zealot - Helm
	[189790] = 189900, --Infinite Zealot - Shoulders

	--Leather
	[185666] = 189887, --Inherited - Helm
	[185870] = 189886, --Sunless - Helm
	[188856] = 189885, --Discontinuity - Helm
	[185934] = 189884, --Zaralek - Helm
	[185803] = 189883, --Suffused - Helm
	[189825] = 189882, --Infinite - Helm

	--Mail
	[185674] = 189893, --Bequeathed - Helm
	[185676] = 189911, --Bequeathed - Shoulders
	[185878] = 189892, --Skyless - Helm
	[185880] = 189910, --Skyless - Shoulders
	[188864] = 189891, --Paradoxical - Helm
	[188866] = 189909, --Paradoxical - Shoulders
	[185941] = 189890, --Zaralek - Helm
	[185943] = 189908, --Zaralek - Shoulders
	[185810] = 189889, --Suffused - Helm
	[185808] = 189907, --Suffused - Shoulders
	[189808] = 189888, --Infinite - Helm
	[189810] = 189906, --Infinite - Shoulders
	
	--Plate
	[185682] = 189881, --Bestowed - Helm
	[185684] = 189917, --Bestowed - Shoulders
	[185886] = 189880, --Starless - Helm
	[185888] = 189916, --Starless - Shoulders
	[188872] = 189879, --Anomalous - Helm
	[188874] = 189915, --Anomalous - Shoulders
	[185946] = 189878, --Zaralek - Helm
	[185951] = 189914, --Zaralek - Shoulders
	[185821] = 189877, --Suffused - Helm
	[185816] = 189913, --Suffused - Shoulders
	[189816] = 189876, --Infinite - Helm
	[189818] = 189912, --Infinite - Shoulders

--Draeni Heratage 
	[194095] = 194107, --Helm - Purple
	[194102] = 194106, --Helm - Orange

--Plunderlord
	[198627] = 218283, --eyepatch with out hat
	[222868] = 218283, --eyepatch with out hat
	[198786] = {184346,184347,184348,222847}, --beanies
	[198785] = {96286,96285,184350,184349}, --tricorns

--WW
	--Educator's Knowledge
	[218087] = 217952, --Chest black
	[218088] = 217953, --Chest blue
	[218089] = 217954, --Chest green
	[218090] = 217955, --Chest purple
	[218091] = 217956, --Chest red

	--Hallowfall Cloth
	[216830] = 216862, --Robes yellow
	[218222] = 220133, --Robes blue
	[219899] = 219790, --Robes red

	--Delver's Cloth
	[193881] = 218291, --Robes blue
	[198870] = 219628, --Robes yellow
	[219160] = 219843, --Robes red
	[220464] = 218494, --Robes green

--S1 Mythic Unlocks
--DK - Exhumed Centurion Relics
	--LFR
	[222549] = 222552, --Belt
	[222556] = 222559, --Shoulders
	[222570] = 222573, --Helm
	--Normal
	[194509] = 222553, --Belt
	[194510] = 222560, --Shoulders
	[194512] = 222574, --Helm
	--Heroic
	[222550] = 222554, --Belt
	[222557] = 222561, --Shoulders
	[222571] = 222575, --Helm
	--Mythic
	[222551] = 222555, --Belt
	[222558] = 222562, --Shoulders
	[222572] = 222576, --Helm
	--Gladiator
	[217722] = 217724, --Belt
	[217714] = 217716, --Shoulders
	[217698] = 217700, --Helm
	--Elite
	[217723] = 217725, --Belt
	[217715] = 217717, --Shoulders
	[217699] = 217701, --Helm

--Druid - Mane of the Greatlynx
	--LFR
	[222100] = 222103, --LFR helm
	[222086] = 222089, --LFR Shoulders
	[221275] = 222082, --LFR Belt
	--Normal
	[194566] = 222104, --norm helm
	[194564] = 222090, --norm Shoulders
	[194563] = 222083, --norm Belt
	--Heroic
	[222101] = 222105, --Heroic helm
	[222087] = 222091, --Heroic Shoulders
	[222080] = 222084, --Heroic Belt
	--Mythic
	[222102] = 222106, --Mythic helm
	[222088] = 222092, --Mythic Shoulders
	[222081] = 222085, --Mythic Belt
	--Gladiator
	[217166] = 217168, --Gladiator helm
	[217182] = 217184, --Gladiator Shoulders
	[217190] = 217192, --Gladiator Belt
	--Elite
	[217167] = 217169, --Elite helm
	[217183] = 217185, --Elite Shoulders
	[217191] = 217193, --Elite Belt

--DH - Husk of the Hypogeal Nemesis
	[222025] = 222028, --LFR helm
	[222011] = 222014, --LFR Shoulders
	[222004] = 222007, --LFR Belt
	[222032] = 222035, --LFR gloves

	[194575] = 222029, --Normal helm
	[194573] = 222015, --Normal Shoulders
	[194572] = 222008, --Normal Belt
	[194576] = 222036, --Normal gloves

	[222026] = 222030, --Heroic helm
	[222012] = 222016, --Heroic Shoulders
	[222005] = 222009, --Heroic Belt
	[222033] = 222037, --Heroic gloves

	[222027] = 222031, --Mythic helm
	[222013] = 222017, --Mythic Shoulders
	[222006] = 222010, --Mythic Belt
	[222034] = 222038, --Mythic gloves

	[217242] = 217244, --Gladiator helm
	[217258] = 217260, --Gladiator Shoulders
	[217266] = 217268, --Gladiator Belt
	[217234] = 217236, --Gladiator gloves

	[217243] = 217245, --Elite helm
	[217259] = 217261, --Elite Shoulders
	[217267] = 217269, --Elite Belt
	[217235] = 217237, --Elite gloves

--Evoker - Destroyers Scarred Wards

	[222329] = 222332, --LFR helm
	[222315] = 222318, --LFR Shoulders

	[194539] = 222333, --Normal helm
	[194537] = 222319, --Normal Shoulders

	[222330] = 222334, --Heroic helm
	[222316] = 222320, --Heroic 

	[222331] = 222335, --Mythic helm
	[222317] = 222321, --Mythic Shoulders

	[217470] = 217472, --Gladiator helm
	[217486] = 217488, --Gladiator Shoulders

	[217471] = 217473, --Elite helm
	[217487] = 217489, --Elite Shoulders


--Hunter - Lightless Scavengers Necessities
	[222408] = 222411, --LFR helm
	[222394] = 222397, --LFR Shoulders

	[194530] = 222412, --Normal helm
	[194528] = 222398, --Normal Shoulders

	[222409] = 222413, --Heroic helm
	[222395] = 222399, --Heroic Shoulders

	[222410] = 222414, --Mythic helm
	[222396] = 222400, --Mythic Shoulders

	[217546] = 217548, --Gladiator helm
	[217562] = 217564, --Gladiator Shoulders

	[217547] = 217549, --Elite helm
	[217563] = 217565, --Elite Shoulders

--Mage - Sparks of Violet Rebirth
	[221786] = 221789, --LFR helm
	[221772] = 221775, --LFR Shoulders
	[221807] = 221810, --LFR Chest
	[221765] = 221768, --LFR waist
	[221793] = 221796, --LFR gloves
	[194602] = 221790, --Normal helm
	[194600] = 221776, --Normal Shoulders
	[194605] = 221811, --Normal Chest
	[194599] = 221769, --Normal waist
	[194603] = 221797, --Normal gloves
	[221787] = 221791, --Heroic helm
	[221773] = 221777, --Heroic Shoulders
	[221808] = 221812, --Heroic Chest
	[221766] = 221770, --Heroic waist
	[221794] = 221798, --Heroic gloves
	[221788] = 221792, --Mythic helm
	[221774] = 221778, --Mythic Shoulders
	[221809] = 221813, --Mythic Chest
	[221767] = 221771, --Mythic waist
	[221795] = 221799, --Mythic gloves
	[216938] = 216940, --Gladiator helm
	[216954] = 216956, --Gladiator Shoulders
	[216914] = 216916, --Gladiator Chest
	[216962] = 216964, --Gladiator waist
	[216930] = 216932, --Gladiator gloves
	[216939] = 216941, --Elite helm
	[216955] = 216957, --Elite Shoulders
	[216915] = 216917, --Elite Chest
	[216963] = 216965, --Elite waist
	[216931] = 216933, --Elite gloves

--Monk - Gatecrasher's Fortitude
	[222179] = 222182, --LFR helm
	[222165] = 222168, --LFR Shoulders

	[194557] = 222183, --Normal helm
	[194555] = 222169, --Normal Shoulders

	[222180] = 222184, --Heroic helm
	[222166] = 222170, --Heroic Shoulders

	[222181] = 222185, --Mythic helm
	[222167] = 222171, --Mythic Shoulders

	[217319] = 217321, --Elite helm
	[217335] = 217337, --Elite Shoulders

	[217318] = 217320, --Gladiator helm
	[217334] = 217336, --Gladiator Shoulders

--Paladin - Entombed Seraph's Radiance
	[222657] = 222660, --LFR helm
	[222643] = 222646, --LFR Shoulders

	[194503] = 222661, --Normal helm
	[194501] = 222647, --Normal Shoulders

	[222658] = 222662, --Heroic helm
	[222644] = 222648, --Heroic Shoulders

	[222659] = 222663, --Mythic helm
	[222645] = 222649, --Mythic Shoulders

	[217774] = 217776, --Gladiator helm
	[217790] = 217792, --Gladiator Shoulders

	[217775] = 217777, --Elite helm
	[217791] = 217793, --Elite Shoulders


--Priest - Shards of Living Luster
	[221865] = 221868, --LFR helm
	[221851] = 221854, --LFR Shoulders
	[221844] = 221847, --LFR Belt
	[221872] = 221875, --LFR gloves

	[194593] = 221869, --Normal helm
	[194591] = 221855, --Normal Shoulders
	[194590] = 221848, --Normal Belt
	[194594] = 221876, --Normal gloves
	[194596] = 221888, --Normal Chest

	[221866] = 221870, --Heroic helm
	[221852] = 221856, --Heroic Shoulders
	[221845] = 221849, --Heroic Belt
	[221873] = 221877, --Heroic gloves
	[221887] = 221889, --Heroic Chest

	[221867] = 221871, --Mythic helm
	[221853] = 221857, --Mythic Shoulders
	[221846] = 221850, --Mythic Belt
	[221874] = 221878, --Mythic gloves
	[229638] = 221890, --Mythic Chest

	[217014] = 217016, --Gladiator helm
	[217030] = 217032, --Gladiator Shoulders
	[217038] = 217040, --Gladiator Belt
	[217006] = 217008, --Gladiator gloves
	[216990] = 216992, --Gladiator Chest

	[217015] = 217017, --Elite helm
	[217031] = 217033, --Elite Shoulders
	[217039] = 217041, --Elite Belt
	[217007] = 217009, --Elite gloves
	[216991] = 216993, --Elite Chest

--Rogue - Kareshi Phantoms Binding
	[222240] = 222243, --LFR Shoulders
	[194546] = 222244, --Normal Shoulders
	[222241] = 222245, --Heroic Shoulders
	[222242] = 222246, --Mythic Shoulders
	[217410] = 217412, --Gladiator Shoulders
	[217411] = 217413, --Elite Shoulders

--Shaman - Waves of the Forgotten Reservior
	[222491] = 222494, --LFR helm
	[222477] = 222480, --LFR Shoulders
	[194521] = 222495, --Normal helm
	[194519] = 222481, --Normal Shoulders
	[222492] = 222496, --Heroic helm
	[222478] = 222482, --Heroic Shoulders
	[222493] = 222497, --Mythic helm
	[222479] = 222483, --Mythic Shoulders
	[217622] = 217624, --Gladiator helm
	[217638] = 217640, --Gladiator Shoulders
	[217623] = 217625, --Elite helm
	[217639] = 217641, --Elite Shoulders

--Warlock - Rites of the Hexflame Coven
	[221946] = 221949, --LFR helm
	[221932] = 221935, --LFR Shoulders
	[194584] = 221950, --Normal helm
	[194582] = 221936, --Normal Shoulders
	[221947] = 221951, --Heroic helm
	[221933] = 221937, --Heroic Shoulders

	[221948] = 221952, --Mythic helm
	[221934] = 221938, --Mythic Shoulders
	[217090] = 217092, --Gladiator helm
	[217106] = 217108, --Gladiator Shoulders

	[217091] = 217093, --Elite helm
	[217107] = 217109, --Elite Shoulders


--Warrior - Warsculptors Masterwork
	[222736] = 222739, --LFR helm
	[222722] = 222725, --LFR Shoulders

	[194494] = 222740, --Normal helm
	[194492] = 222726, --Normal Shoulders

	[222737] = 222741, --Heroic helm
	[222723] = 222727, --Heroic Shoulders

	[222738] = 222742, --Mythic helm
	[222724] = 222728, --Mythic Shoulders

	[217850] = 217852, --Gladiator helm
	[217866] = 217868, --Gladiator Shoulders

	[217851] = 217853, --Elite helm
	[217867] = 217869, --Elite Shoulders
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