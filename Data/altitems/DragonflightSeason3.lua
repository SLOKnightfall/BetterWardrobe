local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
addon.AltItems = addon.AltItems or {}
local altitems = addon.AltItems

	--s3
	altitems[192484] = 192423 --LFR Shoulders
	altitems[188791] = 192424 --Normal Shoulders
	altitems[192485] = 192425 --Heroic Shoulders
	altitems[192486] = 192426 --Mythic Shoulders
	altitems[190316] = 192125 --Gladiator Shoulders
	altitems[190317] = 192126 --Elite Shoulders

	------ Priest
	--S3 Blessings of Lunar Communion - Priest Helm
	altitems[190041] = 190046 --LFR
	altitems[188820] = 190047 --Normal
	altitems[190042] = 190048 --Heroic
	altitems[190043] = 190049 --Mythic
	altitems[190232] = 190050 --Gladiator
	altitems[190233] = 190051 --Elite

	--===Hunter
	--S3 Blazing Dremstaker - Hunter Shoulder
	altitems[193358] = 193361 --LFR
	altitems[188755] = 193362 --Normal
	altitems[193359] = 193363 --Heroic
	altitems[193360] = 193364 --Mythic
	altitems[190506] = 193764 --Gladiator
	altitems[190507] = 193765 --Elite

	----Mage
	--S3 Wayward Chronomancer Clockwork - Mage Helm
	altitems[189129] = 189134 --LFR
	altitems[188829] = 189135 --Normal
	altitems[189130] = 189136 --Heroic
	altitems[189131] = 189137 --Mythic
	altitems[190192] = 189138 --Gladiator
	altitems[190193] = 189139 --Elite

	--S3 Wayward Chronomancer Clockwork - Mage Shoulder
	altitems[189107] = 189112 --LFR
	altitems[189741] = 189113 --Normal
	altitems[189108] = 189114 --Heroic
	altitems[189109] = 189115 --Mythic
	altitems[190202] = 189116 --Gladiator
	altitems[190203] = 189117 --Elite

	--S3 Wayward Chronomancer Clockwork - Mage Belt
	altitems[189096] = 189101 --LFR
	altitems[188826] = 189102 --Normal
	altitems[189097] = 189103 --Heroic
	altitems[189098] = 189104 --Mythic
	altitems[190206] = 189105 --Gladiator
	altitems[190207] = 189106 --Elite

	----Paladin
	--S3
	altitems[189316] = 189321 --LFR Shoulders
	altitems[188728] = 189322 --Normal Shoulders
	altitems[189317] = 189323 --Heroic Shoulders
	altitems[189318] = 189324 --Mythic Shoulders
	altitems[190620] = 189325 --Gladiator Shoulders
	altitems[190621] = 189326 --Elite Shoulders


	---Shaman
	--S3.
	altitems[190536] = 189446 --Gladiator Helm
	altitems[190544] = 189424 --Gladiator Shoulders
	altitems[190537] = 189447 --Elite Helm
	altitems[190545] = 189425 --Elite Shoulders
	altitems[189437] = 189442 --LFR Helm
	altitems[189415] = 189420 --LFR Shoulders
	altitems[188748] = 189443 --Normal Helm
	altitems[188746] = 189421 --Normal Shoulders
	altitems[189438] = 189444 --Heroic Helm
	altitems[189416] = 189422 --Heroic Shoulders
	altitems[189439] = 189445 --Mythic Helm
	altitems[189417] = 189423 --Mythic Shoulders

	---Warrior
	--S3
	altitems[193129] = 193134 --LFR Helm
	altitems[193096] = 193101 --LFR Belt
	altitems[193162] = 193167 --LFR Chest
	altitems[193107] = 193112 --LFR Shoulder
	altitems[188721] = 193135 --Normal Helm
	altitems[188718] = 193102 --Normal Belt
	altitems[188724] = 193168 --Normal Chest
	altitems[188719] = 193113 --Normal Shoulder
	altitems[193130] = 193136 --Heroic Helm
	altitems[193097] = 193103 --Heroic Belt
	altitems[193163] = 193169 --Heroic Chest
	altitems[193108] = 193114 --Heroic Shoulder
	altitems[193131] = 193137 --Mythic Helm
	altitems[193098] = 193104 --Mythic Belt
	altitems[193164] = 193170 --Mythic Chest
	altitems[193109] = 193115 --Mythic Shoulder
	altitems[190650] = 192875 --Gladiator Helm
	altitems[190662] = 192883 --Gladiator Belt
	altitems[190638] = 192863 --Gladiator Chest
	altitems[190658] = 193070 --Gladiator Shoulder
	altitems[190651] = 192876 --Elite Helm
	altitems[190663] = 192884 --Elite Belt
	altitems[190639] = 192864 --Elite Chest
	altitems[190659] = 193071 --Elite Shoulder

	---voker
	--S3
	altitems[192021] = 192026 --LFR Helm
	altitems[192054] = 193418 --LFR Chest
	altitems[188766] = 192027 --Normal Helm
	altitems[188769] = 188697 --Normal Chest
	altitems[192022] = 192028 --Heroic Helm
	altitems[192055] = 193419 --Heroic Chest
	altitems[192023] = 192029 --Mythic Helm
	altitems[192056] = 193420 --Mythic Chest
	altitems[190460] = 192030 --Gladiator Helm
	altitems[190448] = 193421 --Gladiator Chest
	altitems[190461] = 192031 --Elite Helm
	altitems[190449] = 193422 --Elite Chest

	--- Warlock
	--S3
	altitems[189239] = 189244 --LFR Helm
	altitems[189217] = 189222 --LFR Shoulders
	altitems[188811] = 189245 --Normal Helm
	altitems[188809] = 189223 --Normal Shoulders
	altitems[189240] = 189246 --Heroic Helm
	altitems[189218] = 189224 --Heroic Shoulders
	altitems[189241] = 189247 --Mythic Helm
	altitems[189219] = 189225 --Mythic Shoulders
	altitems[190270] = 189248 --Gladiator Helm
	altitems[190278] = 189226 --Gladiator Shoulders
	altitems[190271] = 189249 --Elite Helm
	altitems[190279] = 189227 --Elite Shoulders

	---Rogue
	--S3
	altitems[191236] = 191550 --LFR Helm
	altitems[191226] = 191538 --LFR Shoulders
	altitems[188775] = 191551 --Normal Helm
	altitems[188773] = 191539 --Normal Shoulders
	altitems[191237] = 191552 --Heroic Helm
	altitems[191227] = 191540 --Heroic Shoulders
	altitems[191238] = 191553 --Mythic Helm
	altitems[191228] = 191541 --Mythic Shoulders
	altitems[190422] = 191554 --Gladiator Helm
	altitems[190430] = 191542 --Gladiator Shoulders
	altitems[190423] = 191555 --Elite Helm
	altitems[190431] = 191543 --Elite Shoulders

	---Monk
	--S3
	altitems[189514] = 189519 --LFR Shoulders
	altitems[188782] = 189520 --Normal Shoulders
	altitems[189515] = 189521 --Heroic Shoulders
	altitems[189516] = 189522 --Mythic Shoulders
	altitems[190392] = 189523 --Gladiator Shoulders
	altitems[190393] = 189524 --Elite Shoulders


	--Death Knight
	--S3 Amirdrassil
	altitems[192275] = 192280 --LFR Helm
	altitems[192253] = 192258 --LFR Shoulders
	altitems[188739] = 192281 --Normal Helm
	altitems[188737] = 192259 --Normal Shoulders
	altitems[192276] = 192282 --Heroic Helm
	altitems[192254] = 192260 --Heroic Shoulders
	altitems[192277] = 192283 --Mythic Helm
	altitems[192255] = 192261 --Mythic Shoulders
	altitems[190574] = 192284 --Gladiator Helm
	altitems[190582] = 192262 --Gladiator Shoulders
	altitems[190575] = 192285 --Elite Helm
	altitems[190583] = 192263 --Elite Shoulders


	--DH
	--S3
	altitems[192352] = 192357 --LFR Shoulders
	altitems[188800] = 192358 --Normal Shoulders
	altitems[192353] = 192359 --Heroic Shoulders
	altitems[192354] = 192360 --Mythic Shoulders
	altitems[190354] = 192163 --Gladiator Shoulders
	altitems[190355] = 192164 --Elite Shoulders

