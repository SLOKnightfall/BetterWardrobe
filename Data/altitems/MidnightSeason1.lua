local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
addon.AltItems = addon.AltItems or {}
local altitems = addon.AltItems

--Midnight Season 1 -- VFX/DNT sourceIDs only; keys are negative placeholders (never match a real sourceID) so this stays loadable while you fill in the correct real tier sourceID by hand.
	altitems[296421] = 296425 --[Mythic] VFX variant (Warrior, Rage of the Night Ender / Night Ender's Pauldrons) real: Mythic=296421, Heroic=296420, Normal=296414, LFR=296419
	altitems[296420] = 296424 --[Heroic] VFX variant (Warrior, Rage of the Night Ender / Night Ender's Pauldrons) real: Mythic=296421, Heroic=296420, Normal=296414, LFR=296419
	altitems[296414] = 296423 --[Normal] VFX variant (Warrior, Rage of the Night Ender / Night Ender's Pauldrons) real: Mythic=296421, Heroic=296420, Normal=296414, LFR=296419
	altitems[296419] = 296422 --[LFR] VFX variant (Warrior, Rage of the Night Ender / Night Ender's Pauldrons) real: Mythic=296421, Heroic=296420, Normal=296414, LFR=296419
	altitems[296445] = 296449 --[Mythic] VFX variant (Warrior, Rage of the Night Ender / Night Ender's Tusks) real: Mythic=296445, Heroic=296444, Normal=296438, LFR=296443
	altitems[296444] = 296448 --[Heroic] VFX variant (Warrior, Rage of the Night Ender / Night Ender's Tusks) real: Mythic=296445, Heroic=296444, Normal=296438, LFR=296443
	altitems[296438] = 296447 --[Normal] VFX variant (Warrior, Rage of the Night Ender / Night Ender's Tusks) real: Mythic=296445, Heroic=296444, Normal=296438, LFR=296443
	altitems[296443] = 296446 --[LFR] VFX variant (Warrior, Rage of the Night Ender / Night Ender's Tusks) real: Mythic=296445, Heroic=296444, Normal=296438, LFR=296443
	altitems[296529] = 296533 --[Mythic] VFX variant (Paladin, Luminant Verdict's Vestments / Luminant Verdict's Providence Watch) real: Mythic=296529, Heroic=296528, Normal=296522, LFR=296527
	altitems[296528] = 296532 --[Heroic] VFX variant (Paladin, Luminant Verdict's Vestments / Luminant Verdict's Providence Watch) real: Mythic=296529, Heroic=296528, Normal=296522, LFR=296527
	altitems[296522] = 296531 --[Normal] VFX variant (Paladin, Luminant Verdict's Vestments / Luminant Verdict's Providence Watch) real: Mythic=296529, Heroic=296528, Normal=296522, LFR=296527
	altitems[296527] = 296530 --[LFR] VFX variant (Paladin, Luminant Verdict's Vestments / Luminant Verdict's Providence Watch) real: Mythic=296529, Heroic=296528, Normal=296522, LFR=296527
	altitems[296091] = 296533 --[Mythic] VFX variant (Paladin, Luminant Verdict's Vestments / Light-Judged Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[309849] = 296533 --[Mythic] VFX variant (Paladin, Luminant Verdict's Vestments / ?) sibling appearance, same alt as its DNT'd twin
	altitems[296090] = 296532 --[Heroic] VFX variant (Paladin, Luminant Verdict's Vestments / Light-Judged Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[309848] = 296532 --[Heroic] VFX variant (Paladin, Luminant Verdict's Vestments / ?) sibling appearance, same alt as its DNT'd twin
	altitems[296088] = 296531 --[Normal] VFX variant (Paladin, Luminant Verdict's Vestments / Light-Judged Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[309846] = 296531 --[Normal] VFX variant (Paladin, Luminant Verdict's Vestments / ?) sibling appearance, same alt as its DNT'd twin
	altitems[296089] = 296530 --[LFR] VFX variant (Paladin, Luminant Verdict's Vestments / Light-Judged Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[309847] = 296530 --[LFR] VFX variant (Paladin, Luminant Verdict's Vestments / ?) sibling appearance, same alt as its DNT'd twin
	altitems[296553] = 296557 --[Mythic] VFX variant (Paladin, Luminant Verdict's Vestments / Luminant Verdict's Unwavering Gaze) real: Mythic=296553, Heroic=296552, Normal=296546, LFR=296551
	altitems[296552] = 296556 --[Heroic] VFX variant (Paladin, Luminant Verdict's Vestments / Luminant Verdict's Unwavering Gaze) real: Mythic=296553, Heroic=296552, Normal=296546, LFR=296551
	altitems[296546] = 296555 --[Normal] VFX variant (Paladin, Luminant Verdict's Vestments / Luminant Verdict's Unwavering Gaze) real: Mythic=296553, Heroic=296552, Normal=296546, LFR=296551
	altitems[296551] = 296554 --[LFR] VFX variant (Paladin, Luminant Verdict's Vestments / Luminant Verdict's Unwavering Gaze) real: Mythic=296553, Heroic=296552, Normal=296546, LFR=296551
	altitems[296625] = 296629 --[Mythic] VFX variant (Death Knight, Relentless Rider's Lament / Relentless Rider's Chain) real: Normal=296618, Heroic=296624, Mythic=296625, LFR=296623
	altitems[296624] = 296628 --[Heroic] VFX variant (Death Knight, Relentless Rider's Lament / Relentless Rider's Chain) real: Normal=296618, Heroic=296624, Mythic=296625, LFR=296623
	altitems[296618] = 296627 --[Normal] VFX variant (Death Knight, Relentless Rider's Lament / Relentless Rider's Chain) real: Normal=296618, Heroic=296624, Mythic=296625, LFR=296623
	altitems[296623] = 296626 --[LFR] VFX variant (Death Knight, Relentless Rider's Lament / Relentless Rider's Chain) real: Normal=296618, Heroic=296624, Mythic=296625, LFR=296623
	altitems[296223] = 296629 --[Mythic] VFX variant (Death Knight, Relentless Rider's Lament / Hate-Tied Waistchain) sibling appearance, same alt as its DNT'd twin
	altitems[296222] = 296628 --[Heroic] VFX variant (Death Knight, Relentless Rider's Lament / Hate-Tied Waistchain) sibling appearance, same alt as its DNT'd twin
	altitems[296220] = 296627 --[Normal] VFX variant (Death Knight, Relentless Rider's Lament / Hate-Tied Waistchain) sibling appearance, same alt as its DNT'd twin
	altitems[296221] = 296626 --[LFR] VFX variant (Death Knight, Relentless Rider's Lament / Hate-Tied Waistchain) sibling appearance, same alt as its DNT'd twin
	altitems[296637] = 296641 --[Mythic] VFX variant (Death Knight, Relentless Rider's Lament / Relentless Rider's Dreadthorns) real: Normal=296630, Heroic=296636, Mythic=296637, LFR=296635
	altitems[296636] = 296640 --[Heroic] VFX variant (Death Knight, Relentless Rider's Lament / Relentless Rider's Dreadthorns) real: Normal=296630, Heroic=296636, Mythic=296637, LFR=296635
	altitems[296630] = 296639 --[Normal] VFX variant (Death Knight, Relentless Rider's Lament / Relentless Rider's Dreadthorns) real: Normal=296630, Heroic=296636, Mythic=296637, LFR=296635
	altitems[296635] = 296638 --[LFR] VFX variant (Death Knight, Relentless Rider's Lament / Relentless Rider's Dreadthorns) real: Normal=296630, Heroic=296636, Mythic=296637, LFR=296635
	altitems[296661] = 296665 --[Mythic] VFX variant (Death Knight, Relentless Rider's Lament / Relentless Rider's Crown) real: Normal=296654, Heroic=296660, Mythic=296661, LFR=296659
	altitems[296660] = 296664 --[Heroic] VFX variant (Death Knight, Relentless Rider's Lament / Relentless Rider's Crown) real: Normal=296654, Heroic=296660, Mythic=296661, LFR=296659
	altitems[296654] = 296663 --[Normal] VFX variant (Death Knight, Relentless Rider's Lament / Relentless Rider's Crown) real: Normal=296654, Heroic=296660, Mythic=296661, LFR=296659
	altitems[296659] = 296662 --[LFR] VFX variant (Death Knight, Relentless Rider's Lament / Relentless Rider's Crown) real: Normal=296654, Heroic=296660, Mythic=296661, LFR=296659
	altitems[296103] = 296665 --[Mythic] VFX variant (Death Knight, Relentless Rider's Lament / Crown of the Fractured Tyrant) sibling appearance, same alt as its DNT'd twin
	altitems[296102] = 296664 --[Heroic] VFX variant (Death Knight, Relentless Rider's Lament / Crown of the Fractured Tyrant) sibling appearance, same alt as its DNT'd twin
	altitems[296100] = 296663 --[Normal] VFX variant (Death Knight, Relentless Rider's Lament / Crown of the Fractured Tyrant) sibling appearance, same alt as its DNT'd twin
	altitems[297862] = 296663 --[Normal] VFX variant (Death Knight, Relentless Rider's Lament / Host Commander's Casque) sibling appearance, same alt as its DNT'd twin
	altitems[296101] = 296662 --[LFR] VFX variant (Death Knight, Relentless Rider's Lament / Crown of the Fractured Tyrant) sibling appearance, same alt as its DNT'd twin
	altitems[296745] = 296749 --[Mythic] VFX variant (Shaman, Mantle of the Primal Core / Tempests of the Primal Core) real: Mythic=296745, Heroic=296744, Normal=296738, LFR=296743
	altitems[296744] = 296748 --[Heroic] VFX variant (Shaman, Mantle of the Primal Core / Tempests of the Primal Core) real: Mythic=296745, Heroic=296744, Normal=296738, LFR=296743
	altitems[296738] = 296747 --[Normal] VFX variant (Shaman, Mantle of the Primal Core / Tempests of the Primal Core) real: Mythic=296745, Heroic=296744, Normal=296738, LFR=296743
	altitems[296743] = 296746 --[LFR] VFX variant (Shaman, Mantle of the Primal Core / Tempests of the Primal Core) real: Mythic=296745, Heroic=296744, Normal=296738, LFR=296743
	altitems[302125] = 296749 --[Mythic] VFX variant (Shaman, Mantle of the Primal Core / Primal Spark Pauldrons) sibling appearance, same alt as its DNT'd twin
	altitems[302124] = 296748 --[Heroic] VFX variant (Shaman, Mantle of the Primal Core / Primal Spark Pauldrons) sibling appearance, same alt as its DNT'd twin
	altitems[302122] = 296747 --[Normal] VFX variant (Shaman, Mantle of the Primal Core / Primal Spark Pauldrons) sibling appearance, same alt as its DNT'd twin
	altitems[302123] = 296746 --[LFR] VFX variant (Shaman, Mantle of the Primal Core / Primal Spark Pauldrons) sibling appearance, same alt as its DNT'd twin
	altitems[296769] = 296773 --[Mythic] VFX variant (Shaman, Mantle of the Primal Core / Locus of the Primal Core) real: Mythic=296769, Heroic=296768, Normal=296762, LFR=296767
	altitems[296768] = 296772 --[Heroic] VFX variant (Shaman, Mantle of the Primal Core / Locus of the Primal Core) real: Mythic=296769, Heroic=296768, Normal=296762, LFR=296767
	altitems[296762] = 296771 --[Normal] VFX variant (Shaman, Mantle of the Primal Core / Locus of the Primal Core) real: Mythic=296769, Heroic=296768, Normal=296762, LFR=296767
	altitems[296767] = 296770 --[LFR] VFX variant (Shaman, Mantle of the Primal Core / Locus of the Primal Core) real: Mythic=296769, Heroic=296768, Normal=296762, LFR=296767
	altitems[296351] = 296773 --[Mythic] VFX variant (Shaman, Mantle of the Primal Core / Oblivion Guise) sibling appearance, same alt as its DNT'd twin
	altitems[296350] = 296772 --[Heroic] VFX variant (Shaman, Mantle of the Primal Core / Oblivion Guise) sibling appearance, same alt as its DNT'd twin
	altitems[296348] = 296771 --[Normal] VFX variant (Shaman, Mantle of the Primal Core / Oblivion Guise) sibling appearance, same alt as its DNT'd twin
	altitems[296349] = 296770 --[LFR] VFX variant (Shaman, Mantle of the Primal Core / Oblivion Guise) sibling appearance, same alt as its DNT'd twin
	altitems[296841] = 296845 --[Mythic] VFX variant (Hunter, Primal Sentry's Camouflage / Primal Sentry's Cinch) real: Mythic=296841, Heroic=296840, Normal=296834, LFR=296839
	altitems[296840] = 296844 --[Heroic] VFX variant (Hunter, Primal Sentry's Camouflage / Primal Sentry's Cinch) real: Mythic=296841, Heroic=296840, Normal=296834, LFR=296839
	altitems[296834] = 296843 --[Normal] VFX variant (Hunter, Primal Sentry's Camouflage / Primal Sentry's Cinch) real: Mythic=296841, Heroic=296840, Normal=296834, LFR=296839
	altitems[296839] = 296842 --[LFR] VFX variant (Hunter, Primal Sentry's Camouflage / Primal Sentry's Cinch) real: Mythic=296841, Heroic=296840, Normal=296834, LFR=296839
	altitems[296187] = 296845 --[Mythic] VFX variant (Hunter, Primal Sentry's Camouflage / Scornbane Waistguard) sibling appearance, same alt as its DNT'd twin
	altitems[309833] = 296845 --[Mythic] VFX variant (Hunter, Primal Sentry's Camouflage / Longshot's Fletched Girdle) sibling appearance, same alt as its DNT'd twin
	altitems[296186] = 296844 --[Heroic] VFX variant (Hunter, Primal Sentry's Camouflage / Scornbane Waistguard) sibling appearance, same alt as its DNT'd twin
	altitems[309832] = 296844 --[Heroic] VFX variant (Hunter, Primal Sentry's Camouflage / Longshot's Fletched Girdle) sibling appearance, same alt as its DNT'd twin
	altitems[296184] = 296843 --[Normal] VFX variant (Hunter, Primal Sentry's Camouflage / Scornbane Waistguard) sibling appearance, same alt as its DNT'd twin
	altitems[309830] = 296843 --[Normal] VFX variant (Hunter, Primal Sentry's Camouflage / Longshot's Fletched Girdle) sibling appearance, same alt as its DNT'd twin
	altitems[296185] = 296842 --[LFR] VFX variant (Hunter, Primal Sentry's Camouflage / Scornbane Waistguard) sibling appearance, same alt as its DNT'd twin
	altitems[309831] = 296842 --[LFR] VFX variant (Hunter, Primal Sentry's Camouflage / Longshot's Fletched Girdle) sibling appearance, same alt as its DNT'd twin
	altitems[296853] = 296857 --[Mythic] VFX variant (Hunter, Primal Sentry's Camouflage / Primal Sentry's Trophies) real: Mythic=296853, Heroic=296852, Normal=296846, LFR=296851
	altitems[296852] = 296856 --[Heroic] VFX variant (Hunter, Primal Sentry's Camouflage / Primal Sentry's Trophies) real: Mythic=296853, Heroic=296852, Normal=296846, LFR=296851
	altitems[296846] = 296855 --[Normal] VFX variant (Hunter, Primal Sentry's Camouflage / Primal Sentry's Trophies) real: Mythic=296853, Heroic=296852, Normal=296846, LFR=296851
	altitems[296851] = 296854 --[LFR] VFX variant (Hunter, Primal Sentry's Camouflage / Primal Sentry's Trophies) real: Mythic=296853, Heroic=296852, Normal=296846, LFR=296851
	altitems[296877] = 296881 --[Mythic] VFX variant (Hunter, Primal Sentry's Camouflage / Primal Sentry's Maw) real: Mythic=296877, Heroic=296876, Normal=296870, LFR=296875
	altitems[296876] = 296880 --[Heroic] VFX variant (Hunter, Primal Sentry's Camouflage / Primal Sentry's Maw) real: Mythic=296877, Heroic=296876, Normal=296870, LFR=296875
	altitems[296870] = 296879 --[Normal] VFX variant (Hunter, Primal Sentry's Camouflage / Primal Sentry's Maw) real: Mythic=296877, Heroic=296876, Normal=296870, LFR=296875
	altitems[296875] = 296878 --[LFR] VFX variant (Hunter, Primal Sentry's Camouflage / Primal Sentry's Maw) real: Mythic=296877, Heroic=296876, Normal=296870, LFR=296875
	altitems[297866] = 296879 --[Normal] VFX variant (Hunter, Primal Sentry's Camouflage / Bramblestalker's Feathered Cowl) sibling appearance, same alt as its DNT'd twin
	altitems[296889] = 296893 --[Mythic] VFX variant (Hunter, Primal Sentry's Camouflage / Primal Sentry's Talonguards) real: Mythic=296889, Heroic=296888, Normal=296882, LFR=296887
	altitems[296888] = 296892 --[Heroic] VFX variant (Hunter, Primal Sentry's Camouflage / Primal Sentry's Talonguards) real: Mythic=296889, Heroic=296888, Normal=296882, LFR=296887
	altitems[296882] = 296891 --[Normal] VFX variant (Hunter, Primal Sentry's Camouflage / Primal Sentry's Talonguards) real: Mythic=296889, Heroic=296888, Normal=296882, LFR=296887
	altitems[296887] = 296890 --[LFR] VFX variant (Hunter, Primal Sentry's Camouflage / Primal Sentry's Talonguards) real: Mythic=296889, Heroic=296888, Normal=296882, LFR=296887
	altitems[296139] = 296893 --[Mythic] VFX variant (Hunter, Primal Sentry's Camouflage / Untethered Berserker's Grips) sibling appearance, same alt as its DNT'd twin
	altitems[296138] = 296892 --[Heroic] VFX variant (Hunter, Primal Sentry's Camouflage / Untethered Berserker's Grips) sibling appearance, same alt as its DNT'd twin
	altitems[296136] = 296891 --[Normal] VFX variant (Hunter, Primal Sentry's Camouflage / Untethered Berserker's Grips) sibling appearance, same alt as its DNT'd twin
	altitems[296137] = 296890 --[LFR] VFX variant (Hunter, Primal Sentry's Camouflage / Untethered Berserker's Grips) sibling appearance, same alt as its DNT'd twin
	altitems[296961] = 296965 --[Mythic] VFX variant (Evoker, Livery of the Black Talon / Beacons of the Black Talon) real: Mythic=296961, Heroic=296960, Normal=296954, LFR=296959
	altitems[296960] = 296964 --[Heroic] VFX variant (Evoker, Livery of the Black Talon / Beacons of the Black Talon) real: Mythic=296961, Heroic=296960, Normal=296954, LFR=296959
	altitems[296954] = 296963 --[Normal] VFX variant (Evoker, Livery of the Black Talon / Beacons of the Black Talon) real: Mythic=296961, Heroic=296960, Normal=296954, LFR=296959
	altitems[296959] = 296962 --[LFR] VFX variant (Evoker, Livery of the Black Talon / Beacons of the Black Talon) real: Mythic=296961, Heroic=296960, Normal=296954, LFR=296959
	altitems[296111] = 296965 --[Mythic] VFX variant (Evoker, Livery of the Black Talon / Nullwalker's Dread Epaulettes) sibling appearance, same alt as its DNT'd twin
	altitems[309857] = 296965 --[Mythic] VFX variant (Evoker, Livery of the Black Talon / ?) sibling appearance, same alt as its DNT'd twin
	altitems[296110] = 296964 --[Heroic] VFX variant (Evoker, Livery of the Black Talon / Nullwalker's Dread Epaulettes) sibling appearance, same alt as its DNT'd twin
	altitems[309856] = 296964 --[Heroic] VFX variant (Evoker, Livery of the Black Talon / ?) sibling appearance, same alt as its DNT'd twin
	altitems[296108] = 296963 --[Normal] VFX variant (Evoker, Livery of the Black Talon / Nullwalker's Dread Epaulettes) sibling appearance, same alt as its DNT'd twin
	altitems[309854] = 296963 --[Normal] VFX variant (Evoker, Livery of the Black Talon / ?) sibling appearance, same alt as its DNT'd twin
	altitems[296109] = 296962 --[LFR] VFX variant (Evoker, Livery of the Black Talon / Nullwalker's Dread Epaulettes) sibling appearance, same alt as its DNT'd twin
	altitems[309855] = 296962 --[LFR] VFX variant (Evoker, Livery of the Black Talon / ?) sibling appearance, same alt as its DNT'd twin
	altitems[297069] = 297073 --[Mythic] VFX variant (Rogue, Motley of the Grim Jest / Venom Casks of the Grim Jest) real: Mythic=297069, Heroic=297068, Normal=297062, LFR=297067
	altitems[297068] = 297072 --[Heroic] VFX variant (Rogue, Motley of the Grim Jest / Venom Casks of the Grim Jest) real: Mythic=297069, Heroic=297068, Normal=297062, LFR=297067
	altitems[297062] = 297071 --[Normal] VFX variant (Rogue, Motley of the Grim Jest / Venom Casks of the Grim Jest) real: Mythic=297069, Heroic=297068, Normal=297062, LFR=297067
	altitems[297067] = 297070 --[LFR] VFX variant (Rogue, Motley of the Grim Jest / Venom Casks of the Grim Jest) real: Mythic=297069, Heroic=297068, Normal=297062, LFR=297067
	altitems[309232] = 297073 --[Mythic] VFX variant (Rogue, Motley of the Grim Jest / Toxic Voidscythe Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[309231] = 297072 --[Heroic] VFX variant (Rogue, Motley of the Grim Jest / Toxic Voidscythe Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[309229] = 297071 --[Normal] VFX variant (Rogue, Motley of the Grim Jest / Toxic Voidscythe Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[309230] = 297070 --[LFR] VFX variant (Rogue, Motley of the Grim Jest / Toxic Voidscythe Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[297093] = 297097 --[Mythic] VFX variant (Rogue, Motley of the Grim Jest / Masquerade of the Grim Jest) real: Mythic=297093, Heroic=297092, Normal=297086, LFR=297091
	altitems[297092] = 297096 --[Heroic] VFX variant (Rogue, Motley of the Grim Jest / Masquerade of the Grim Jest) real: Mythic=297093, Heroic=297092, Normal=297086, LFR=297091
	altitems[297086] = 297095 --[Normal] VFX variant (Rogue, Motley of the Grim Jest / Masquerade of the Grim Jest) real: Mythic=297093, Heroic=297092, Normal=297086, LFR=297091
	altitems[297091] = 297094 --[LFR] VFX variant (Rogue, Motley of the Grim Jest / Masquerade of the Grim Jest) real: Mythic=297093, Heroic=297092, Normal=297086, LFR=297091
	altitems[296347] = 297097 --[Mythic] VFX variant (Rogue, Motley of the Grim Jest / Mask of Darkest Intent) sibling appearance, same alt as its DNT'd twin
	altitems[296346] = 297096 --[Heroic] VFX variant (Rogue, Motley of the Grim Jest / Mask of Darkest Intent) sibling appearance, same alt as its DNT'd twin
	altitems[296344] = 297095 --[Normal] VFX variant (Rogue, Motley of the Grim Jest / Mask of Darkest Intent) sibling appearance, same alt as its DNT'd twin
	altitems[296345] = 297094 --[LFR] VFX variant (Rogue, Motley of the Grim Jest / Mask of Darkest Intent) sibling appearance, same alt as its DNT'd twin
	altitems[297165] = 297169 --[Mythic] VFX variant (Monk, Way of Ra-den's Chosen / Stormsigil of Ra-den's Chosen) real: Normal=297158, LFR=297163, Mythic=297165, Heroic=297164
	altitems[297164] = 297168 --[Heroic] VFX variant (Monk, Way of Ra-den's Chosen / Stormsigil of Ra-den's Chosen) real: Normal=297158, LFR=297163, Mythic=297165, Heroic=297164
	altitems[297158] = 297167 --[Normal] VFX variant (Monk, Way of Ra-den's Chosen / Stormsigil of Ra-den's Chosen) real: Normal=297158, LFR=297163, Mythic=297165, Heroic=297164
	altitems[297163] = 297166 --[LFR] VFX variant (Monk, Way of Ra-den's Chosen / Stormsigil of Ra-den's Chosen) real: Normal=297158, LFR=297163, Mythic=297165, Heroic=297164
	altitems[296199] = 297169 --[Mythic] VFX variant (Monk, Way of Ra-den's Chosen / Scorn-Scarred Shul'ka's Belt) sibling appearance, same alt as its DNT'd twin
	altitems[296198] = 297168 --[Heroic] VFX variant (Monk, Way of Ra-den's Chosen / Scorn-Scarred Shul'ka's Belt) sibling appearance, same alt as its DNT'd twin
	altitems[296196] = 297167 --[Normal] VFX variant (Monk, Way of Ra-den's Chosen / Scorn-Scarred Shul'ka's Belt) sibling appearance, same alt as its DNT'd twin
	altitems[296197] = 297166 --[LFR] VFX variant (Monk, Way of Ra-den's Chosen / Scorn-Scarred Shul'ka's Belt) sibling appearance, same alt as its DNT'd twin
	altitems[297177] = 297181 --[Mythic] VFX variant (Monk, Way of Ra-den's Chosen / Aurastones of Ra-den's Chosen) real: Normal=297170, LFR=297175, Mythic=297177, Heroic=297176
	altitems[297176] = 297180 --[Heroic] VFX variant (Monk, Way of Ra-den's Chosen / Aurastones of Ra-den's Chosen) real: Normal=297170, LFR=297175, Mythic=297177, Heroic=297176
	altitems[297170] = 297179 --[Normal] VFX variant (Monk, Way of Ra-den's Chosen / Aurastones of Ra-den's Chosen) real: Normal=297170, LFR=297175, Mythic=297177, Heroic=297176
	altitems[297175] = 297178 --[LFR] VFX variant (Monk, Way of Ra-den's Chosen / Aurastones of Ra-den's Chosen) real: Normal=297170, LFR=297175, Mythic=297177, Heroic=297176
	altitems[297201] = 297205 --[Mythic] VFX variant (Monk, Way of Ra-den's Chosen / Fearsome Visage of Ra-den's Chosen) real: Normal=297194, LFR=297199, Mythic=297201, Heroic=297200
	altitems[297200] = 297204 --[Heroic] VFX variant (Monk, Way of Ra-den's Chosen / Fearsome Visage of Ra-den's Chosen) real: Normal=297194, LFR=297199, Mythic=297201, Heroic=297200
	altitems[297194] = 297203 --[Normal] VFX variant (Monk, Way of Ra-den's Chosen / Fearsome Visage of Ra-den's Chosen) real: Normal=297194, LFR=297199, Mythic=297201, Heroic=297200
	altitems[297199] = 297202 --[LFR] VFX variant (Monk, Way of Ra-den's Chosen / Fearsome Visage of Ra-den's Chosen) real: Normal=297194, LFR=297199, Mythic=297201, Heroic=297200
	altitems[297285] = 297289 --[Mythic] VFX variant (Druid, Sprouts of the Luminous Bloom / Seedpods of the Luminous Bloom) real: Mythic=297285, Heroic=297284, Normal=297278, LFR=297283
	altitems[297284] = 297288 --[Heroic] VFX variant (Druid, Sprouts of the Luminous Bloom / Seedpods of the Luminous Bloom) real: Mythic=297285, Heroic=297284, Normal=297278, LFR=297283
	altitems[297278] = 297287 --[Normal] VFX variant (Druid, Sprouts of the Luminous Bloom / Seedpods of the Luminous Bloom) real: Mythic=297285, Heroic=297284, Normal=297278, LFR=297283
	altitems[297283] = 297286 --[LFR] VFX variant (Druid, Sprouts of the Luminous Bloom / Seedpods of the Luminous Bloom) real: Mythic=297285, Heroic=297284, Normal=297278, LFR=297283
	altitems[296171] = 297289 --[Mythic] VFX variant (Druid, Sprouts of the Luminous Bloom / Blooming Barklight Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[309873] = 297289 --[Mythic] VFX variant (Druid, Sprouts of the Luminous Bloom / ?) sibling appearance, same alt as its DNT'd twin
	altitems[296170] = 297288 --[Heroic] VFX variant (Druid, Sprouts of the Luminous Bloom / Blooming Barklight Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[309872] = 297288 --[Heroic] VFX variant (Druid, Sprouts of the Luminous Bloom / ?) sibling appearance, same alt as its DNT'd twin
	altitems[296168] = 297287 --[Normal] VFX variant (Druid, Sprouts of the Luminous Bloom / Blooming Barklight Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[309870] = 297287 --[Normal] VFX variant (Druid, Sprouts of the Luminous Bloom / ?) sibling appearance, same alt as its DNT'd twin
	altitems[296169] = 297286 --[LFR] VFX variant (Druid, Sprouts of the Luminous Bloom / Blooming Barklight Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[309871] = 297286 --[LFR] VFX variant (Druid, Sprouts of the Luminous Bloom / ?) sibling appearance, same alt as its DNT'd twin
	altitems[297309] = 297313 --[Mythic] VFX variant (Druid, Sprouts of the Luminous Bloom / Branches of the Luminous Bloom) real: Mythic=297309, Heroic=297308, Normal=297302, LFR=297307
	altitems[297308] = 297312 --[Heroic] VFX variant (Druid, Sprouts of the Luminous Bloom / Branches of the Luminous Bloom) real: Mythic=297309, Heroic=297308, Normal=297302, LFR=297307
	altitems[297302] = 297311 --[Normal] VFX variant (Druid, Sprouts of the Luminous Bloom / Branches of the Luminous Bloom) real: Mythic=297309, Heroic=297308, Normal=297302, LFR=297307
	altitems[297307] = 297310 --[LFR] VFX variant (Druid, Sprouts of the Luminous Bloom / Branches of the Luminous Bloom) real: Mythic=297309, Heroic=297308, Normal=297302, LFR=297307
	altitems[304529] = 297313 --[Mythic] VFX variant (Druid, Sprouts of the Luminous Bloom / Festerbloom Crown) sibling appearance, same alt as its DNT'd twin
	altitems[304528] = 297312 --[Heroic] VFX variant (Druid, Sprouts of the Luminous Bloom / Festerbloom Crown) sibling appearance, same alt as its DNT'd twin
	altitems[304526] = 297311 --[Normal] VFX variant (Druid, Sprouts of the Luminous Bloom / Festerbloom Crown) sibling appearance, same alt as its DNT'd twin
	altitems[304527] = 297310 --[LFR] VFX variant (Druid, Sprouts of the Luminous Bloom / Festerbloom Crown) sibling appearance, same alt as its DNT'd twin
	altitems[297381] = 297385 --[Mythic] VFX variant (Demon Hunter, Devouring Reaver's Sheathe / Devouring Reaver's Emblem) real: LFR=297379, Mythic=297381, Heroic=297380, Normal=297374
	altitems[297380] = 297384 --[Heroic] VFX variant (Demon Hunter, Devouring Reaver's Sheathe / Devouring Reaver's Emblem) real: LFR=297379, Mythic=297381, Heroic=297380, Normal=297374
	altitems[297374] = 297383 --[Normal] VFX variant (Demon Hunter, Devouring Reaver's Sheathe / Devouring Reaver's Emblem) real: LFR=297379, Mythic=297381, Heroic=297380, Normal=297374
	altitems[297379] = 297382 --[LFR] VFX variant (Demon Hunter, Devouring Reaver's Sheathe / Devouring Reaver's Emblem) real: LFR=297379, Mythic=297381, Heroic=297380, Normal=297374
	altitems[296095] = 297385 --[Mythic] VFX variant (Demon Hunter, Devouring Reaver's Sheathe / Twisted Twilight Sash) sibling appearance, same alt as its DNT'd twin
	altitems[296094] = 297384 --[Heroic] VFX variant (Demon Hunter, Devouring Reaver's Sheathe / Twisted Twilight Sash) sibling appearance, same alt as its DNT'd twin
	altitems[296092] = 297383 --[Normal] VFX variant (Demon Hunter, Devouring Reaver's Sheathe / Twisted Twilight Sash) sibling appearance, same alt as its DNT'd twin
	altitems[296093] = 297382 --[LFR] VFX variant (Demon Hunter, Devouring Reaver's Sheathe / Twisted Twilight Sash) sibling appearance, same alt as its DNT'd twin
	altitems[297393] = 297397 --[Mythic] VFX variant (Demon Hunter, Devouring Reaver's Sheathe / Devouring Reaver's Exhaustplates) real: LFR=297391, Mythic=297393, Heroic=297392, Normal=297386
	altitems[297392] = 297396 --[Heroic] VFX variant (Demon Hunter, Devouring Reaver's Sheathe / Devouring Reaver's Exhaustplates) real: LFR=297391, Mythic=297393, Heroic=297392, Normal=297386
	altitems[297386] = 297395 --[Normal] VFX variant (Demon Hunter, Devouring Reaver's Sheathe / Devouring Reaver's Exhaustplates) real: LFR=297391, Mythic=297393, Heroic=297392, Normal=297386
	altitems[297391] = 297394 --[LFR] VFX variant (Demon Hunter, Devouring Reaver's Sheathe / Devouring Reaver's Exhaustplates) real: LFR=297391, Mythic=297393, Heroic=297392, Normal=297386
	altitems[297417] = 297421 --[Mythic] VFX variant (Demon Hunter, Devouring Reaver's Sheathe / Devouring Reaver's Intake) real: LFR=297415, Mythic=297417, Heroic=297416, Normal=297410
	altitems[297416] = 297420 --[Heroic] VFX variant (Demon Hunter, Devouring Reaver's Sheathe / Devouring Reaver's Intake) real: LFR=297415, Mythic=297417, Heroic=297416, Normal=297410
	altitems[297410] = 297419 --[Normal] VFX variant (Demon Hunter, Devouring Reaver's Sheathe / Devouring Reaver's Intake) real: LFR=297415, Mythic=297417, Heroic=297416, Normal=297410
	altitems[297415] = 297418 --[LFR] VFX variant (Demon Hunter, Devouring Reaver's Sheathe / Devouring Reaver's Intake) real: LFR=297415, Mythic=297417, Heroic=297416, Normal=297410
	altitems[296063] = 297421 --[Mythic] VFX variant (Demon Hunter, Devouring Reaver's Sheathe / Devouring Night's Visage) sibling appearance, same alt as its DNT'd twin
	altitems[296062] = 297420 --[Heroic] VFX variant (Demon Hunter, Devouring Reaver's Sheathe / Devouring Night's Visage) sibling appearance, same alt as its DNT'd twin
	altitems[296060] = 297419 --[Normal] VFX variant (Demon Hunter, Devouring Reaver's Sheathe / Devouring Night's Visage) sibling appearance, same alt as its DNT'd twin
	altitems[296061] = 297418 --[LFR] VFX variant (Demon Hunter, Devouring Reaver's Sheathe / Devouring Night's Visage) sibling appearance, same alt as its DNT'd twin
	altitems[297501] = 297505 --[Mythic] VFX variant (Warlock, Reign of the Abyssal Immolator / Abyssal Immolator's Fury) real: Mythic=297501, Heroic=297500, Normal=297494, LFR=297499
	altitems[297500] = 297504 --[Heroic] VFX variant (Warlock, Reign of the Abyssal Immolator / Abyssal Immolator's Fury) real: Mythic=297501, Heroic=297500, Normal=297494, LFR=297499
	altitems[297494] = 297503 --[Normal] VFX variant (Warlock, Reign of the Abyssal Immolator / Abyssal Immolator's Fury) real: Mythic=297501, Heroic=297500, Normal=297494, LFR=297499
	altitems[297499] = 297502 --[LFR] VFX variant (Warlock, Reign of the Abyssal Immolator / Abyssal Immolator's Fury) real: Mythic=297501, Heroic=297500, Normal=297494, LFR=297499
	altitems[297525] = 297529 --[Mythic] VFX variant (Warlock, Reign of the Abyssal Immolator / Abyssal Immolator's Smoldering Flames) real: Mythic=297525, Heroic=297524, Normal=297518, LFR=297523
	altitems[297524] = 297528 --[Heroic] VFX variant (Warlock, Reign of the Abyssal Immolator / Abyssal Immolator's Smoldering Flames) real: Mythic=297525, Heroic=297524, Normal=297518, LFR=297523
	altitems[297518] = 297527 --[Normal] VFX variant (Warlock, Reign of the Abyssal Immolator / Abyssal Immolator's Smoldering Flames) real: Mythic=297525, Heroic=297524, Normal=297518, LFR=297523
	altitems[297523] = 297526 --[LFR] VFX variant (Warlock, Reign of the Abyssal Immolator / Abyssal Immolator's Smoldering Flames) real: Mythic=297525, Heroic=297524, Normal=297518, LFR=297523
	altitems[296155] = 297529 --[Mythic] VFX variant (Warlock, Reign of the Abyssal Immolator / Gaze of the Unrestrained) sibling appearance, same alt as its DNT'd twin
	altitems[296154] = 297528 --[Heroic] VFX variant (Warlock, Reign of the Abyssal Immolator / Gaze of the Unrestrained) sibling appearance, same alt as its DNT'd twin
	altitems[296152] = 297527 --[Normal] VFX variant (Warlock, Reign of the Abyssal Immolator / Gaze of the Unrestrained) sibling appearance, same alt as its DNT'd twin
	altitems[296153] = 297526 --[LFR] VFX variant (Warlock, Reign of the Abyssal Immolator / Gaze of the Unrestrained) sibling appearance, same alt as its DNT'd twin
	altitems[297609] = 297613 --[Mythic] VFX variant (Priest, Blind Oath's Burden / Blind Oath's Seraphguards) real: Mythic=297609, Heroic=297608, Normal=297602, LFR=297607
	altitems[297608] = 297612 --[Heroic] VFX variant (Priest, Blind Oath's Burden / Blind Oath's Seraphguards) real: Mythic=297609, Heroic=297608, Normal=297602, LFR=297607
	altitems[297602] = 297611 --[Normal] VFX variant (Priest, Blind Oath's Burden / Blind Oath's Seraphguards) real: Mythic=297609, Heroic=297608, Normal=297602, LFR=297607
	altitems[297607] = 297610 --[LFR] VFX variant (Priest, Blind Oath's Burden / Blind Oath's Seraphguards) real: Mythic=297609, Heroic=297608, Normal=297602, LFR=297607
	altitems[297633] = 297637 --[Mythic] VFX variant (Priest, Blind Oath's Burden / Blind Oath's Winged Crest) real: Mythic=297633, Heroic=297632, Normal=297626, LFR=297631
	altitems[297632] = 297636 --[Heroic] VFX variant (Priest, Blind Oath's Burden / Blind Oath's Winged Crest) real: Mythic=297633, Heroic=297632, Normal=297626, LFR=297631
	altitems[297626] = 297635 --[Normal] VFX variant (Priest, Blind Oath's Burden / Blind Oath's Winged Crest) real: Mythic=297633, Heroic=297632, Normal=297626, LFR=297631
	altitems[297631] = 297634 --[LFR] VFX variant (Priest, Blind Oath's Burden / Blind Oath's Winged Crest) real: Mythic=297633, Heroic=297632, Normal=297626, LFR=297631
	altitems[302109] = 297637 --[Mythic] VFX variant (Priest, Blind Oath's Burden / Visage of Unseen Truths) sibling appearance, same alt as its DNT'd twin
	altitems[302108] = 297636 --[Heroic] VFX variant (Priest, Blind Oath's Burden / Visage of Unseen Truths) sibling appearance, same alt as its DNT'd twin
	altitems[302106] = 297635 --[Normal] VFX variant (Priest, Blind Oath's Burden / Visage of Unseen Truths) sibling appearance, same alt as its DNT'd twin
	altitems[302107] = 297634 --[LFR] VFX variant (Priest, Blind Oath's Burden / Visage of Unseen Truths) sibling appearance, same alt as its DNT'd twin
	altitems[297717] = 297721 --[Mythic] VFX variant (Mage, Voidbreaker's Accordance / Voidbreaker's Leyline Nexi) real: Mythic=297717, Heroic=297716, Normal=297710, LFR=297715
	altitems[297716] = 297720 --[Heroic] VFX variant (Mage, Voidbreaker's Accordance / Voidbreaker's Leyline Nexi) real: Mythic=297717, Heroic=297716, Normal=297710, LFR=297715
	altitems[297710] = 297719 --[Normal] VFX variant (Mage, Voidbreaker's Accordance / Voidbreaker's Leyline Nexi) real: Mythic=297717, Heroic=297716, Normal=297710, LFR=297715
	altitems[297715] = 297718 --[LFR] VFX variant (Mage, Voidbreaker's Accordance / Voidbreaker's Leyline Nexi) real: Mythic=297717, Heroic=297716, Normal=297710, LFR=297715
	altitems[296151] = 297721 --[Mythic] VFX variant (Mage, Voidbreaker's Accordance / Echoing Void Mantle) sibling appearance, same alt as its DNT'd twin
	altitems[309865] = 297721 --[Mythic] VFX variant (Mage, Voidbreaker's Accordance / ?) sibling appearance, same alt as its DNT'd twin
	altitems[296150] = 297720 --[Heroic] VFX variant (Mage, Voidbreaker's Accordance / Echoing Void Mantle) sibling appearance, same alt as its DNT'd twin
	altitems[309864] = 297720 --[Heroic] VFX variant (Mage, Voidbreaker's Accordance / ?) sibling appearance, same alt as its DNT'd twin
	altitems[296148] = 297719 --[Normal] VFX variant (Mage, Voidbreaker's Accordance / Echoing Void Mantle) sibling appearance, same alt as its DNT'd twin
	altitems[309862] = 297719 --[Normal] VFX variant (Mage, Voidbreaker's Accordance / ?) sibling appearance, same alt as its DNT'd twin
	altitems[296149] = 297718 --[LFR] VFX variant (Mage, Voidbreaker's Accordance / Echoing Void Mantle) sibling appearance, same alt as its DNT'd twin
	altitems[309863] = 297718 --[LFR] VFX variant (Mage, Voidbreaker's Accordance / ?) sibling appearance, same alt as its DNT'd twin
	altitems[297741] = 297745 --[Mythic] VFX variant (Mage, Voidbreaker's Accordance / Voidbreaker's Veil) real: Mythic=297741, Heroic=297740, Normal=297734, LFR=297739
	altitems[297740] = 297744 --[Heroic] VFX variant (Mage, Voidbreaker's Accordance / Voidbreaker's Veil) real: Mythic=297741, Heroic=297740, Normal=297734, LFR=297739
	altitems[297734] = 297743 --[Normal] VFX variant (Mage, Voidbreaker's Accordance / Voidbreaker's Veil) real: Mythic=297741, Heroic=297740, Normal=297734, LFR=297739
	altitems[297739] = 297742 --[LFR] VFX variant (Mage, Voidbreaker's Accordance / Voidbreaker's Veil) real: Mythic=297741, Heroic=297740, Normal=297734, LFR=297739
	altitems[299609] = 299611 --[Elite] VFX variant (Mage, Galactic Gladiator's Silk Armor / Galactic Gladiator's Silk Hat) real: Elite=299609, Gladiator=299608, Elite=299609
	altitems[299608] = 299610 --[Gladiator] VFX variant (Mage, Galactic Gladiator's Silk Armor / Galactic Gladiator's Silk Hat) real: Elite=299609, Gladiator=299608, Elite=299609
	altitems[299613] = 299611 --[Elite] VFX variant (Mage, Galactic Gladiator's Silk Armor / Galactic Gladiator's Silk Cap) sibling appearance, same alt as its DNT'd twin
	altitems[299612] = 299610 --[Gladiator] VFX variant (Mage, Galactic Gladiator's Silk Armor / Galactic Gladiator's Silk Cap) sibling appearance, same alt as its DNT'd twin
	altitems[299625] = 299627 --[Elite] VFX variant (Mage, Galactic Gladiator's Silk Armor / Galactic Gladiator's Silk Mantle) real: Elite=299625, Gladiator=299624, Elite=299625
	altitems[299624] = 299626 --[Gladiator] VFX variant (Mage, Galactic Gladiator's Silk Armor / Galactic Gladiator's Silk Mantle) real: Elite=299625, Gladiator=299624, Elite=299625
	altitems[299629] = 299627 --[Elite] VFX variant (Mage, Galactic Gladiator's Silk Armor / Galactic Gladiator's Silk Amice) sibling appearance, same alt as its DNT'd twin
	altitems[299628] = 299626 --[Gladiator] VFX variant (Mage, Galactic Gladiator's Silk Armor / Galactic Gladiator's Silk Amice) sibling appearance, same alt as its DNT'd twin
	altitems[299689] = 299691 --[Elite] VFX variant (Priest, Galactic Gladiator's Silk Armor / Galactic Gladiator's Silk Guise) real: Elite=299689, Gladiator=299688, Elite=299689
	altitems[299688] = 299690 --[Gladiator] VFX variant (Priest, Galactic Gladiator's Silk Armor / Galactic Gladiator's Silk Guise) real: Elite=299689, Gladiator=299688, Elite=299689
	altitems[299685] = 299691 --[Elite] VFX variant (Priest, Galactic Gladiator's Silk Armor / Galactic Gladiator's Silk Hood) sibling appearance, same alt as its DNT'd twin
	altitems[299684] = 299690 --[Gladiator] VFX variant (Priest, Galactic Gladiator's Silk Armor / Galactic Gladiator's Silk Hood) sibling appearance, same alt as its DNT'd twin
	altitems[299701] = 299703 --[Elite] VFX variant (Priest, Galactic Gladiator's Silk Armor / Galactic Gladiator's Silk Mantle) real: Elite=299701, Gladiator=299700, Elite=299701
	altitems[299700] = 299702 --[Gladiator] VFX variant (Priest, Galactic Gladiator's Silk Armor / Galactic Gladiator's Silk Mantle) real: Elite=299701, Gladiator=299700, Elite=299701
	altitems[299705] = 299703 --[Elite] VFX variant (Priest, Galactic Gladiator's Silk Armor / Galactic Gladiator's Silk Amice) sibling appearance, same alt as its DNT'd twin
	altitems[299704] = 299702 --[Gladiator] VFX variant (Priest, Galactic Gladiator's Silk Armor / Galactic Gladiator's Silk Amice) sibling appearance, same alt as its DNT'd twin
	altitems[299765] = 299767 --[Elite] VFX variant (Warlock, Galactic Gladiator's Silk Armor / Galactic Gladiator's Silk Guise) real: Elite=299765, Gladiator=299764, Elite=299765
	altitems[299764] = 299766 --[Gladiator] VFX variant (Warlock, Galactic Gladiator's Silk Armor / Galactic Gladiator's Silk Guise) real: Elite=299765, Gladiator=299764, Elite=299765
	altitems[299761] = 299767 --[Elite] VFX variant (Warlock, Galactic Gladiator's Silk Armor / Galactic Gladiator's Silk Hood) sibling appearance, same alt as its DNT'd twin
	altitems[299760] = 299766 --[Gladiator] VFX variant (Warlock, Galactic Gladiator's Silk Armor / Galactic Gladiator's Silk Hood) sibling appearance, same alt as its DNT'd twin
	altitems[299777] = 299779 --[Elite] VFX variant (Warlock, Galactic Gladiator's Silk Armor / Galactic Gladiator's Silk Mantle) real: Elite=299777, Gladiator=299776, Elite=299777
	altitems[299776] = 299778 --[Gladiator] VFX variant (Warlock, Galactic Gladiator's Silk Armor / Galactic Gladiator's Silk Mantle) real: Elite=299777, Gladiator=299776, Elite=299777
	altitems[299781] = 299779 --[Elite] VFX variant (Warlock, Galactic Gladiator's Silk Armor / Galactic Gladiator's Silk Amice) sibling appearance, same alt as its DNT'd twin
	altitems[299780] = 299778 --[Gladiator] VFX variant (Warlock, Galactic Gladiator's Silk Armor / Galactic Gladiator's Silk Amice) sibling appearance, same alt as its DNT'd twin
	altitems[299837] = 299839 --[Elite] VFX variant (Druid, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Helm) real: Elite=299837, Gladiator=299836, Elite=299837
	altitems[299836] = 299838 --[Gladiator] VFX variant (Druid, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Helm) real: Elite=299837, Gladiator=299836, Elite=299837
	altitems[299841] = 299839 --[Elite] VFX variant (Druid, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Mask) sibling appearance, same alt as its DNT'd twin
	altitems[299840] = 299838 --[Gladiator] VFX variant (Druid, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Mask) sibling appearance, same alt as its DNT'd twin
	altitems[299857] = 299859 --[Elite] VFX variant (Druid, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Shoulderpads) real: Elite=299857, Gladiator=299856, Elite=299857
	altitems[299856] = 299858 --[Gladiator] VFX variant (Druid, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Shoulderpads) real: Elite=299857, Gladiator=299856, Elite=299857
	altitems[299853] = 299859 --[Elite] VFX variant (Druid, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[299852] = 299858 --[Gladiator] VFX variant (Druid, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[299913] = 299915 --[Elite] VFX variant (Demon Hunter, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Helm) real: Elite=299913, Gladiator=299912, Elite=299913
	altitems[299912] = 299914 --[Gladiator] VFX variant (Demon Hunter, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Helm) real: Elite=299913, Gladiator=299912, Elite=299913
	altitems[299917] = 299915 --[Elite] VFX variant (Demon Hunter, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Mask) sibling appearance, same alt as its DNT'd twin
	altitems[299916] = 299914 --[Gladiator] VFX variant (Demon Hunter, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Mask) sibling appearance, same alt as its DNT'd twin
	altitems[299933] = 299935 --[Elite] VFX variant (Demon Hunter, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Shoulderpads) real: Elite=299933, Gladiator=299932, Elite=299933
	altitems[299932] = 299934 --[Gladiator] VFX variant (Demon Hunter, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Shoulderpads) real: Elite=299933, Gladiator=299932, Elite=299933
	altitems[299929] = 299935 --[Elite] VFX variant (Demon Hunter, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[299928] = 299934 --[Gladiator] VFX variant (Demon Hunter, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[299937] = 299939 --[Elite] VFX variant (Demon Hunter, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Belt) real: Elite=299937, Gladiator=299936, Elite=299937
	altitems[299936] = 299938 --[Gladiator] VFX variant (Demon Hunter, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Belt) real: Elite=299937, Gladiator=299936, Elite=299937
	altitems[299941] = 299939 --[Elite] VFX variant (Demon Hunter, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Strap) sibling appearance, same alt as its DNT'd twin
	altitems[299940] = 299938 --[Gladiator] VFX variant (Demon Hunter, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Strap) sibling appearance, same alt as its DNT'd twin
	altitems[299993] = 299995 --[Elite] VFX variant (Monk, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Mask) real: Elite=299993, Gladiator=299992, Elite=299993
	altitems[299992] = 299994 --[Gladiator] VFX variant (Monk, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Mask) real: Elite=299993, Gladiator=299992, Elite=299993
	altitems[299989] = 299995 --[Elite] VFX variant (Monk, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Helm) sibling appearance, same alt as its DNT'd twin
	altitems[299988] = 299994 --[Gladiator] VFX variant (Monk, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Helm) sibling appearance, same alt as its DNT'd twin
	altitems[300009] = 300011 --[Elite] VFX variant (Monk, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Shoulderpads) real: Elite=300009, Gladiator=300008, Elite=300009
	altitems[300008] = 300010 --[Gladiator] VFX variant (Monk, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Shoulderpads) real: Elite=300009, Gladiator=300008, Elite=300009
	altitems[300005] = 300011 --[Elite] VFX variant (Monk, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[300004] = 300010 --[Gladiator] VFX variant (Monk, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[300013] = 300015 --[Elite] VFX variant (Monk, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Belt) real: Elite=300013, Gladiator=300012, Elite=300013
	altitems[300012] = 300014 --[Gladiator] VFX variant (Monk, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Belt) real: Elite=300013, Gladiator=300012, Elite=300013
	altitems[300017] = 300015 --[Elite] VFX variant (Monk, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Strap) sibling appearance, same alt as its DNT'd twin
	altitems[300016] = 300014 --[Gladiator] VFX variant (Monk, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Strap) sibling appearance, same alt as its DNT'd twin
	altitems[300069] = 300071 --[Elite] VFX variant (Rogue, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Mask) real: Elite=300069, Gladiator=300068, Elite=300069
	altitems[300068] = 300070 --[Gladiator] VFX variant (Rogue, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Mask) real: Elite=300069, Gladiator=300068, Elite=300069
	altitems[300065] = 300071 --[Elite] VFX variant (Rogue, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Helm) sibling appearance, same alt as its DNT'd twin
	altitems[300064] = 300070 --[Gladiator] VFX variant (Rogue, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Helm) sibling appearance, same alt as its DNT'd twin
	altitems[300085] = 300087 --[Elite] VFX variant (Rogue, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Shoulderpads) real: Elite=300085, Gladiator=300084, Elite=300085
	altitems[300084] = 300086 --[Gladiator] VFX variant (Rogue, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Shoulderpads) real: Elite=300085, Gladiator=300084, Elite=300085
	altitems[300081] = 300087 --[Elite] VFX variant (Rogue, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[300080] = 300086 --[Gladiator] VFX variant (Rogue, Galactic Gladiator's Leather Armor / Galactic Gladiator's Leather Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[300161] = 300163 --[Elite] VFX variant (Evoker, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Shoulderguard) real: Gladiator=300160, Elite=300161, Elite=300161
	altitems[300160] = 300162 --[Gladiator] VFX variant (Evoker, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Shoulderguard) real: Gladiator=300160, Elite=300161, Elite=300161
	altitems[300157] = 300163 --[Elite] VFX variant (Evoker, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Monnion) sibling appearance, same alt as its DNT'd twin
	altitems[300156] = 300162 --[Gladiator] VFX variant (Evoker, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Monnion) sibling appearance, same alt as its DNT'd twin
	altitems[300209] = 300211 --[Elite] VFX variant (Hunter, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Gauntlets) real: Elite=300209, Gladiator=300208, Elite=300209
	altitems[300208] = 300210 --[Gladiator] VFX variant (Hunter, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Gauntlets) real: Elite=300209, Gladiator=300208, Elite=300209
	altitems[300213] = 300211 --[Elite] VFX variant (Hunter, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Handguards) sibling appearance, same alt as its DNT'd twin
	altitems[300212] = 300210 --[Gladiator] VFX variant (Hunter, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Handguards) sibling appearance, same alt as its DNT'd twin
	altitems[300217] = 300219 --[Elite] VFX variant (Hunter, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Helm) real: Elite=300217, Gladiator=300216, Elite=300217
	altitems[300216] = 300218 --[Gladiator] VFX variant (Hunter, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Helm) real: Elite=300217, Gladiator=300216, Elite=300217
	altitems[300221] = 300219 --[Elite] VFX variant (Hunter, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Faceguard) sibling appearance, same alt as its DNT'd twin
	altitems[300220] = 300218 --[Gladiator] VFX variant (Hunter, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Faceguard) sibling appearance, same alt as its DNT'd twin
	altitems[300237] = 300239 --[Elite] VFX variant (Hunter, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Shoulderguard) real: Elite=300237, Gladiator=300236, Elite=300237
	altitems[300236] = 300238 --[Gladiator] VFX variant (Hunter, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Shoulderguard) real: Elite=300237, Gladiator=300236, Elite=300237
	altitems[300233] = 300239 --[Elite] VFX variant (Hunter, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Monnion) sibling appearance, same alt as its DNT'd twin
	altitems[300232] = 300238 --[Gladiator] VFX variant (Hunter, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Monnion) sibling appearance, same alt as its DNT'd twin
	altitems[300245] = 300247 --[Elite] VFX variant (Hunter, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Girdle) real: Elite=300245, Gladiator=300244, Elite=300245
	altitems[300244] = 300246 --[Gladiator] VFX variant (Hunter, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Girdle) real: Elite=300245, Gladiator=300244, Elite=300245
	altitems[300241] = 300247 --[Elite] VFX variant (Hunter, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Belt) sibling appearance, same alt as its DNT'd twin
	altitems[300240] = 300246 --[Gladiator] VFX variant (Hunter, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Belt) sibling appearance, same alt as its DNT'd twin
	altitems[300293] = 300295 --[Elite] VFX variant (Shaman, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Helm) real: Elite=300293, Gladiator=300292, Elite=300293
	altitems[300292] = 300294 --[Gladiator] VFX variant (Shaman, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Helm) real: Elite=300293, Gladiator=300292, Elite=300293
	altitems[300297] = 300295 --[Elite] VFX variant (Shaman, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Faceguard) sibling appearance, same alt as its DNT'd twin
	altitems[300296] = 300294 --[Gladiator] VFX variant (Shaman, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Faceguard) sibling appearance, same alt as its DNT'd twin
	altitems[300313] = 300315 --[Elite] VFX variant (Shaman, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Shoulderguard) real: Elite=300313, Gladiator=300312, Elite=300313
	altitems[300312] = 300314 --[Gladiator] VFX variant (Shaman, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Shoulderguard) real: Elite=300313, Gladiator=300312, Elite=300313
	altitems[300309] = 300315 --[Elite] VFX variant (Shaman, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Monnion) sibling appearance, same alt as its DNT'd twin
	altitems[300308] = 300314 --[Gladiator] VFX variant (Shaman, Galactic Gladiator's Chain Armor / Galactic Gladiator's Chain Monnion) sibling appearance, same alt as its DNT'd twin
	altitems[300373] = 300375 --[Elite] VFX variant (Death Knight, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Helmet) real: Elite=300373, Gladiator=300372, Elite=300373
	altitems[300372] = 300374 --[Gladiator] VFX variant (Death Knight, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Helmet) real: Elite=300373, Gladiator=300372, Elite=300373
	altitems[300369] = 300375 --[Elite] VFX variant (Death Knight, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Helm) sibling appearance, same alt as its DNT'd twin
	altitems[300368] = 300374 --[Gladiator] VFX variant (Death Knight, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Helm) sibling appearance, same alt as its DNT'd twin
	altitems[300389] = 300391 --[Elite] VFX variant (Death Knight, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Pauldrons) real: Elite=300389, Gladiator=300388, Elite=300389
	altitems[300388] = 300390 --[Gladiator] VFX variant (Death Knight, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Pauldrons) real: Elite=300389, Gladiator=300388, Elite=300389
	altitems[300385] = 300391 --[Elite] VFX variant (Death Knight, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Shoulders) sibling appearance, same alt as its DNT'd twin
	altitems[300384] = 300390 --[Gladiator] VFX variant (Death Knight, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Shoulders) sibling appearance, same alt as its DNT'd twin
	altitems[300397] = 300399 --[Elite] VFX variant (Death Knight, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Greatbelt) real: Elite=300397, Gladiator=300396, Elite=300397
	altitems[300396] = 300398 --[Gladiator] VFX variant (Death Knight, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Greatbelt) real: Elite=300397, Gladiator=300396, Elite=300397
	altitems[300393] = 300399 --[Elite] VFX variant (Death Knight, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Girdle) sibling appearance, same alt as its DNT'd twin
	altitems[300392] = 300398 --[Gladiator] VFX variant (Death Knight, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Girdle) sibling appearance, same alt as its DNT'd twin
	altitems[300445] = 300447 --[Elite] VFX variant (Paladin, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Helm) real: Elite=300445, Gladiator=300444, Elite=300445
	altitems[300444] = 300446 --[Gladiator] VFX variant (Paladin, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Helm) real: Elite=300445, Gladiator=300444, Elite=300445
	altitems[300449] = 300447 --[Elite] VFX variant (Paladin, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Helmet) sibling appearance, same alt as its DNT'd twin
	altitems[300448] = 300446 --[Gladiator] VFX variant (Paladin, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Helmet) sibling appearance, same alt as its DNT'd twin
	altitems[300465] = 300467 --[Elite] VFX variant (Paladin, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Pauldrons) real: Elite=300465, Gladiator=300464, Elite=300465
	altitems[300464] = 300466 --[Gladiator] VFX variant (Paladin, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Pauldrons) real: Elite=300465, Gladiator=300464, Elite=300465
	altitems[300461] = 300467 --[Elite] VFX variant (Paladin, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Shoulders) sibling appearance, same alt as its DNT'd twin
	altitems[300460] = 300466 --[Gladiator] VFX variant (Paladin, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Shoulders) sibling appearance, same alt as its DNT'd twin
	altitems[300521] = 300523 --[Elite] VFX variant (Warrior, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Helm) real: Elite=300521, Gladiator=300520, Elite=300521
	altitems[300520] = 300522 --[Gladiator] VFX variant (Warrior, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Helm) real: Elite=300521, Gladiator=300520, Elite=300521
	altitems[300525] = 300523 --[Elite] VFX variant (Warrior, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Helmet) sibling appearance, same alt as its DNT'd twin
	altitems[300524] = 300522 --[Gladiator] VFX variant (Warrior, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Helmet) sibling appearance, same alt as its DNT'd twin
	altitems[300541] = 300543 --[Elite] VFX variant (Warrior, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Pauldrons) real: Elite=300541, Gladiator=300540, Elite=300541
	altitems[300540] = 300542 --[Gladiator] VFX variant (Warrior, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Pauldrons) real: Elite=300541, Gladiator=300540, Elite=300541
	altitems[300537] = 300543 --[Elite] VFX variant (Warrior, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Shoulders) sibling appearance, same alt as its DNT'd twin
	altitems[300536] = 300542 --[Gladiator] VFX variant (Warrior, Galactic Gladiator's Plate Armor / Galactic Gladiator's Plate Shoulders) sibling appearance, same alt as its DNT'd twin
