local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
addon.AltItems = addon.AltItems or {}
local altitems = addon.AltItems

--War Within Season 3 -- VFX/DNT sourceIDs only; keys are negative placeholders (never match a real sourceID) so this stays loadable while you fill in the correct real tier sourceID by hand.
	altitems[285559] = 285558 --[LFR] VFX variant (Warrior, Chains of the Living Weapon / Living Weapon's Ramparts) real: LFR=285559, Normal=285554, Mythic=285561, Heroic=285560, Gladiator=285555, Elite=285556
	altitems[285554] = 285557 --[Normal] VFX variant (Warrior, Chains of the Living Weapon / Living Weapon's Ramparts) real: LFR=285559, Normal=285554, Mythic=285561, Heroic=285560, Gladiator=285555, Elite=285556
	altitems[285561] = 285565 --[Mythic] VFX variant (Warrior, Chains of the Living Weapon / Living Weapon's Ramparts) real: LFR=285559, Normal=285554, Mythic=285561, Heroic=285560, Gladiator=285555, Elite=285556
	altitems[285560] = 285564 --[Heroic] VFX variant (Warrior, Chains of the Living Weapon / Living Weapon's Ramparts) real: LFR=285559, Normal=285554, Mythic=285561, Heroic=285560, Gladiator=285555, Elite=285556
	altitems[228988] = 285563 --[?] VFX variant (Warrior, Chains of the Living Weapon / Living Weapon's Ramparts) real: LFR=285559, Normal=285554, Mythic=285561, Heroic=285560, Gladiator=285555, Elite=285556
	altitems[228987] = 285562 --[?] VFX variant (Warrior, Chains of the Living Weapon / Living Weapon's Ramparts) real: LFR=285559, Normal=285554, Mythic=285561, Heroic=285560, Gladiator=285555, Elite=285556
	altitems[228992] = 285563 --[?] VFX variant (Warrior, Chains of the Living Weapon / Astral Gladiator's Plate Pauldrons) sibling appearance, same alt as its DNT'd twin
	altitems[228991] = 285562 --[?] VFX variant (Warrior, Chains of the Living Weapon / Astral Gladiator's Plate Pauldrons) sibling appearance, same alt as its DNT'd twin
	altitems[287301] = 285582 --[?] VFX variant (Warrior, Chains of the Living Weapon / Living Weapon's Faceshield) real: LFR=285583, Normal=285578, Mythic=285585, Heroic=285584, Gladiator=285579, Elite=285580
	altitems[287300] = 285581 --[?] VFX variant (Warrior, Chains of the Living Weapon / Living Weapon's Faceshield) real: LFR=285583, Normal=285578, Mythic=285585, Heroic=285584, Gladiator=285579, Elite=285580
	altitems[287303] = 285589 --[?] VFX variant (Warrior, Chains of the Living Weapon / Living Weapon's Faceshield) real: LFR=285583, Normal=285578, Mythic=285585, Heroic=285584, Gladiator=285579, Elite=285580
	altitems[287302] = 285588 --[?] VFX variant (Warrior, Chains of the Living Weapon / Living Weapon's Faceshield) real: LFR=285583, Normal=285578, Mythic=285585, Heroic=285584, Gladiator=285579, Elite=285580
	altitems[228972] = 285587 --[?] VFX variant (Warrior, Chains of the Living Weapon / Living Weapon's Faceshield) real: LFR=285583, Normal=285578, Mythic=285585, Heroic=285584, Gladiator=285579, Elite=285580
	altitems[228971] = 285586 --[?] VFX variant (Warrior, Chains of the Living Weapon / Living Weapon's Faceshield) real: LFR=285583, Normal=285578, Mythic=285585, Heroic=285584, Gladiator=285579, Elite=285580
	altitems[228976] = 285587 --[?] VFX variant (Warrior, Chains of the Living Weapon / Astral Gladiator's Plate Helmet) sibling appearance, same alt as its DNT'd twin
	altitems[228975] = 285586 --[?] VFX variant (Warrior, Chains of the Living Weapon / Astral Gladiator's Plate Helmet) sibling appearance, same alt as its DNT'd twin
	altitems[285374] = 285666 --[?] VFX variant (Paladin, Vows of the Lucent Battalion / Chargers of the Lucent Battalion) real: LFR=285667, Normal=285662, Mythic=285669, Heroic=285668, Gladiator=285663, Elite=285664
	altitems[285373] = 285665 --[?] VFX variant (Paladin, Vows of the Lucent Battalion / Chargers of the Lucent Battalion) real: LFR=285667, Normal=285662, Mythic=285669, Heroic=285668, Gladiator=285663, Elite=285664
	altitems[285376] = 285673 --[?] VFX variant (Paladin, Vows of the Lucent Battalion / Chargers of the Lucent Battalion) real: LFR=285667, Normal=285662, Mythic=285669, Heroic=285668, Gladiator=285663, Elite=285664
	altitems[285375] = 285672 --[?] VFX variant (Paladin, Vows of the Lucent Battalion / Chargers of the Lucent Battalion) real: LFR=285667, Normal=285662, Mythic=285669, Heroic=285668, Gladiator=285663, Elite=285664
	altitems[228912] = 285671 --[?] VFX variant (Paladin, Vows of the Lucent Battalion / Chargers of the Lucent Battalion) real: LFR=285667, Normal=285662, Mythic=285669, Heroic=285668, Gladiator=285663, Elite=285664
	altitems[228911] = 285670 --[?] VFX variant (Paladin, Vows of the Lucent Battalion / Chargers of the Lucent Battalion) real: LFR=285667, Normal=285662, Mythic=285669, Heroic=285668, Gladiator=285663, Elite=285664
	altitems[228916] = 285671 --[?] VFX variant (Paladin, Vows of the Lucent Battalion / Astral Gladiator's Plate Pauldrons) sibling appearance, same alt as its DNT'd twin
	altitems[228915] = 285670 --[?] VFX variant (Paladin, Vows of the Lucent Battalion / Astral Gladiator's Plate Pauldrons) sibling appearance, same alt as its DNT'd twin
	altitems[285386] = 285690 --[?] VFX variant (Paladin, Vows of the Lucent Battalion / Lightmane of the Lucent Battalion) real: LFR=285691, Normal=285686, Mythic=285693, Heroic=285692, Gladiator=285687, Elite=285688
	altitems[285385] = 285689 --[?] VFX variant (Paladin, Vows of the Lucent Battalion / Lightmane of the Lucent Battalion) real: LFR=285691, Normal=285686, Mythic=285693, Heroic=285692, Gladiator=285687, Elite=285688
	altitems[285388] = 285697 --[?] VFX variant (Paladin, Vows of the Lucent Battalion / Lightmane of the Lucent Battalion) real: LFR=285691, Normal=285686, Mythic=285693, Heroic=285692, Gladiator=285687, Elite=285688
	altitems[285387] = 285696 --[?] VFX variant (Paladin, Vows of the Lucent Battalion / Lightmane of the Lucent Battalion) real: LFR=285691, Normal=285686, Mythic=285693, Heroic=285692, Gladiator=285687, Elite=285688
	altitems[228896] = 285695 --[?] VFX variant (Paladin, Vows of the Lucent Battalion / Lightmane of the Lucent Battalion) real: LFR=285691, Normal=285686, Mythic=285693, Heroic=285692, Gladiator=285687, Elite=285688
	altitems[228895] = 285694 --[?] VFX variant (Paladin, Vows of the Lucent Battalion / Lightmane of the Lucent Battalion) real: LFR=285691, Normal=285686, Mythic=285693, Heroic=285692, Gladiator=285687, Elite=285688
	altitems[228900] = 285695 --[?] VFX variant (Paladin, Vows of the Lucent Battalion / Astral Gladiator's Plate Helmet) sibling appearance, same alt as its DNT'd twin
	altitems[228899] = 285694 --[?] VFX variant (Paladin, Vows of the Lucent Battalion / Astral Gladiator's Plate Helmet) sibling appearance, same alt as its DNT'd twin
	altitems[285775] = 285774 --[LFR] VFX variant (Death Knight, Hollow Sentinel's Vigil / Hollow Sentinel's Perches) real: LFR=285775, Mythic=285777, Heroic=285776, Normal=285770, Gladiator=285771, Elite=285772
	altitems[285777] = 285773 --[Mythic] VFX variant (Death Knight, Hollow Sentinel's Vigil / Hollow Sentinel's Perches) real: LFR=285775, Mythic=285777, Heroic=285776, Normal=285770, Gladiator=285771, Elite=285772
	altitems[285776] = 285781 --[Heroic] VFX variant (Death Knight, Hollow Sentinel's Vigil / Hollow Sentinel's Perches) real: LFR=285775, Mythic=285777, Heroic=285776, Normal=285770, Gladiator=285771, Elite=285772
	altitems[285770] = 285780 --[Normal] VFX variant (Death Knight, Hollow Sentinel's Vigil / Hollow Sentinel's Perches) real: LFR=285775, Mythic=285777, Heroic=285776, Normal=285770, Gladiator=285771, Elite=285772
	altitems[228836] = 285779 --[?] VFX variant (Death Knight, Hollow Sentinel's Vigil / Hollow Sentinel's Perches) real: LFR=285775, Mythic=285777, Heroic=285776, Normal=285770, Gladiator=285771, Elite=285772
	altitems[228835] = 285778 --[?] VFX variant (Death Knight, Hollow Sentinel's Vigil / Hollow Sentinel's Perches) real: LFR=285775, Mythic=285777, Heroic=285776, Normal=285770, Gladiator=285771, Elite=285772
	altitems[228840] = 285779 --[?] VFX variant (Death Knight, Hollow Sentinel's Vigil / Astral Gladiator's Plate Pauldrons) sibling appearance, same alt as its DNT'd twin
	altitems[228839] = 285778 --[?] VFX variant (Death Knight, Hollow Sentinel's Vigil / Astral Gladiator's Plate Pauldrons) sibling appearance, same alt as its DNT'd twin
	altitems[285799] = 285798 --[LFR] VFX variant (Death Knight, Hollow Sentinel's Vigil / Hollow Sentinel's Stonemask) real: LFR=285799, Mythic=285801, Heroic=285800, Normal=285794, Gladiator=285795, Elite=285796
	altitems[285801] = 285797 --[Mythic] VFX variant (Death Knight, Hollow Sentinel's Vigil / Hollow Sentinel's Stonemask) real: LFR=285799, Mythic=285801, Heroic=285800, Normal=285794, Gladiator=285795, Elite=285796
	altitems[285800] = 285805 --[Heroic] VFX variant (Death Knight, Hollow Sentinel's Vigil / Hollow Sentinel's Stonemask) real: LFR=285799, Mythic=285801, Heroic=285800, Normal=285794, Gladiator=285795, Elite=285796
	altitems[291799] = 285804 --[?] VFX variant (Death Knight, Hollow Sentinel's Vigil / Hollow Sentinel's Stonemask) real: LFR=285799, Mythic=285801, Heroic=285800, Normal=285794, Gladiator=285795, Elite=285796
	altitems[228820] = 285803 --[?] VFX variant (Death Knight, Hollow Sentinel's Vigil / Hollow Sentinel's Stonemask) real: LFR=285799, Mythic=285801, Heroic=285800, Normal=285794, Gladiator=285795, Elite=285796
	altitems[228819] = 285802 --[?] VFX variant (Death Knight, Hollow Sentinel's Vigil / Hollow Sentinel's Stonemask) real: LFR=285799, Mythic=285801, Heroic=285800, Normal=285794, Gladiator=285795, Elite=285796
	altitems[228824] = 285803 --[?] VFX variant (Death Knight, Hollow Sentinel's Vigil / Astral Gladiator's Plate Helmet) sibling appearance, same alt as its DNT'd twin
	altitems[228823] = 285802 --[?] VFX variant (Death Knight, Hollow Sentinel's Vigil / Astral Gladiator's Plate Helmet) sibling appearance, same alt as its DNT'd twin
	altitems[285394] = 285882 --[?] VFX variant (Shaman, Howls of Channeled Fury / Fangs of Channeled Fury) real: LFR=285883, Normal=285878, Mythic=285885, Heroic=285884, Gladiator=285879, Elite=285880
	altitems[285393] = 285881 --[?] VFX variant (Shaman, Howls of Channeled Fury / Fangs of Channeled Fury) real: LFR=285883, Normal=285878, Mythic=285885, Heroic=285884, Gladiator=285879, Elite=285880
	altitems[285396] = 285889 --[?] VFX variant (Shaman, Howls of Channeled Fury / Fangs of Channeled Fury) real: LFR=285883, Normal=285878, Mythic=285885, Heroic=285884, Gladiator=285879, Elite=285880
	altitems[285395] = 285888 --[?] VFX variant (Shaman, Howls of Channeled Fury / Fangs of Channeled Fury) real: LFR=285883, Normal=285878, Mythic=285885, Heroic=285884, Gladiator=285879, Elite=285880
	altitems[228760] = 285887 --[?] VFX variant (Shaman, Howls of Channeled Fury / Fangs of Channeled Fury) real: LFR=285883, Normal=285878, Mythic=285885, Heroic=285884, Gladiator=285879, Elite=285880
	altitems[228759] = 285886 --[?] VFX variant (Shaman, Howls of Channeled Fury / Fangs of Channeled Fury) real: LFR=285883, Normal=285878, Mythic=285885, Heroic=285884, Gladiator=285879, Elite=285880
	altitems[228764] = 285887 --[?] VFX variant (Shaman, Howls of Channeled Fury / Astral Gladiator's Chain Shoulderguard) sibling appearance, same alt as its DNT'd twin
	altitems[228763] = 285886 --[?] VFX variant (Shaman, Howls of Channeled Fury / Astral Gladiator's Chain Shoulderguard) sibling appearance, same alt as its DNT'd twin
	altitems[285983] = 285982 --[LFR] VFX variant (Hunter, Midnight Herald's Pledge / Midnight Herald's Shadowguards) real: LFR=285983, Normal=285978, Mythic=285985, Heroic=285984, Gladiator=285979, Elite=285980
	altitems[285978] = 285981 --[Normal] VFX variant (Hunter, Midnight Herald's Pledge / Midnight Herald's Shadowguards) real: LFR=285983, Normal=285978, Mythic=285985, Heroic=285984, Gladiator=285979, Elite=285980
	altitems[285985] = 285989 --[Mythic] VFX variant (Hunter, Midnight Herald's Pledge / Midnight Herald's Shadowguards) real: LFR=285983, Normal=285978, Mythic=285985, Heroic=285984, Gladiator=285979, Elite=285980
	altitems[285984] = 285988 --[Heroic] VFX variant (Hunter, Midnight Herald's Pledge / Midnight Herald's Shadowguards) real: LFR=285983, Normal=285978, Mythic=285985, Heroic=285984, Gladiator=285979, Elite=285980
	altitems[228688] = 285987 --[?] VFX variant (Hunter, Midnight Herald's Pledge / Midnight Herald's Shadowguards) real: LFR=285983, Normal=285978, Mythic=285985, Heroic=285984, Gladiator=285979, Elite=285980
	altitems[228687] = 285986 --[?] VFX variant (Hunter, Midnight Herald's Pledge / Midnight Herald's Shadowguards) real: LFR=285983, Normal=285978, Mythic=285985, Heroic=285984, Gladiator=285979, Elite=285980
	altitems[228692] = 285987 --[?] VFX variant (Hunter, Midnight Herald's Pledge / Astral Gladiator's Chain Shoulderguard) sibling appearance, same alt as its DNT'd twin
	altitems[228691] = 285986 --[?] VFX variant (Hunter, Midnight Herald's Pledge / Astral Gladiator's Chain Shoulderguard) sibling appearance, same alt as its DNT'd twin
	altitems[286007] = 286006 --[LFR] VFX variant (Hunter, Midnight Herald's Pledge / Midnight Herald's Cowl) real: LFR=286007, Normal=286002, Mythic=286009, Heroic=286008, Gladiator=286003, Elite=286004
	altitems[286002] = 286005 --[Normal] VFX variant (Hunter, Midnight Herald's Pledge / Midnight Herald's Cowl) real: LFR=286007, Normal=286002, Mythic=286009, Heroic=286008, Gladiator=286003, Elite=286004
	altitems[286009] = 286013 --[Mythic] VFX variant (Hunter, Midnight Herald's Pledge / Midnight Herald's Cowl) real: LFR=286007, Normal=286002, Mythic=286009, Heroic=286008, Gladiator=286003, Elite=286004
	altitems[286008] = 286012 --[Heroic] VFX variant (Hunter, Midnight Herald's Pledge / Midnight Herald's Cowl) real: LFR=286007, Normal=286002, Mythic=286009, Heroic=286008, Gladiator=286003, Elite=286004
	altitems[228672] = 286011 --[?] VFX variant (Hunter, Midnight Herald's Pledge / Midnight Herald's Cowl) real: LFR=286007, Normal=286002, Mythic=286009, Heroic=286008, Gladiator=286003, Elite=286004
	altitems[228671] = 286010 --[?] VFX variant (Hunter, Midnight Herald's Pledge / Midnight Herald's Cowl) real: LFR=286007, Normal=286002, Mythic=286009, Heroic=286008, Gladiator=286003, Elite=286004
	altitems[228676] = 286011 --[?] VFX variant (Hunter, Midnight Herald's Pledge / Astral Gladiator's Chain Faceguard) sibling appearance, same alt as its DNT'd twin
	altitems[228675] = 286010 --[?] VFX variant (Hunter, Midnight Herald's Pledge / Astral Gladiator's Chain Faceguard) sibling appearance, same alt as its DNT'd twin
	altitems[286091] = 286090 --[LFR] VFX variant (Evoker, Spellweaver's Immaculate Design / Spellweaver's Immaculate Pauldrons) real: LFR=286091, Normal=286086, Mythic=286093, Heroic=286092, Gladiator=286087, Elite=286088
	altitems[286086] = 286089 --[Normal] VFX variant (Evoker, Spellweaver's Immaculate Design / Spellweaver's Immaculate Pauldrons) real: LFR=286091, Normal=286086, Mythic=286093, Heroic=286092, Gladiator=286087, Elite=286088
	altitems[286093] = 286097 --[Mythic] VFX variant (Evoker, Spellweaver's Immaculate Design / Spellweaver's Immaculate Pauldrons) real: LFR=286091, Normal=286086, Mythic=286093, Heroic=286092, Gladiator=286087, Elite=286088
	altitems[286092] = 286096 --[Heroic] VFX variant (Evoker, Spellweaver's Immaculate Design / Spellweaver's Immaculate Pauldrons) real: LFR=286091, Normal=286086, Mythic=286093, Heroic=286092, Gladiator=286087, Elite=286088
	altitems[228612] = 286095 --[?] VFX variant (Evoker, Spellweaver's Immaculate Design / Spellweaver's Immaculate Pauldrons) real: LFR=286091, Normal=286086, Mythic=286093, Heroic=286092, Gladiator=286087, Elite=286088
	altitems[228611] = 286094 --[?] VFX variant (Evoker, Spellweaver's Immaculate Design / Spellweaver's Immaculate Pauldrons) real: LFR=286091, Normal=286086, Mythic=286093, Heroic=286092, Gladiator=286087, Elite=286088
	altitems[228616] = 286095 --[?] VFX variant (Evoker, Spellweaver's Immaculate Design / Astral Gladiator's Chain Shoulderguard) sibling appearance, same alt as its DNT'd twin
	altitems[228615] = 286094 --[?] VFX variant (Evoker, Spellweaver's Immaculate Design / Astral Gladiator's Chain Shoulderguard) sibling appearance, same alt as its DNT'd twin
	altitems[286115] = 286114 --[LFR] VFX variant (Evoker, Spellweaver's Immaculate Design / Spellweaver's Immaculate Focus) real: LFR=286115, Normal=286110, Mythic=286117, Heroic=286116, Gladiator=286111, Elite=286112
	altitems[286110] = 286113 --[Normal] VFX variant (Evoker, Spellweaver's Immaculate Design / Spellweaver's Immaculate Focus) real: LFR=286115, Normal=286110, Mythic=286117, Heroic=286116, Gladiator=286111, Elite=286112
	altitems[286117] = 286121 --[Mythic] VFX variant (Evoker, Spellweaver's Immaculate Design / Spellweaver's Immaculate Focus) real: LFR=286115, Normal=286110, Mythic=286117, Heroic=286116, Gladiator=286111, Elite=286112
	altitems[286116] = 286120 --[Heroic] VFX variant (Evoker, Spellweaver's Immaculate Design / Spellweaver's Immaculate Focus) real: LFR=286115, Normal=286110, Mythic=286117, Heroic=286116, Gladiator=286111, Elite=286112
	altitems[228596] = 286119 --[?] VFX variant (Evoker, Spellweaver's Immaculate Design / Spellweaver's Immaculate Focus) real: LFR=286115, Normal=286110, Mythic=286117, Heroic=286116, Gladiator=286111, Elite=286112
	altitems[228595] = 286118 --[?] VFX variant (Evoker, Spellweaver's Immaculate Design / Spellweaver's Immaculate Focus) real: LFR=286115, Normal=286110, Mythic=286117, Heroic=286116, Gladiator=286111, Elite=286112
	altitems[228600] = 286119 --[?] VFX variant (Evoker, Spellweaver's Immaculate Design / Astral Gladiator's Chain Faceguard) sibling appearance, same alt as its DNT'd twin
	altitems[228599] = 286118 --[?] VFX variant (Evoker, Spellweaver's Immaculate Design / Astral Gladiator's Chain Faceguard) sibling appearance, same alt as its DNT'd twin
	altitems[285454] = 286198 --[?] VFX variant (Rogue, Shroud of the Sudden Eclipse / Smokemantle of the Sudden Eclipse) real: LFR=286199, Normal=286194, Mythic=286201, Heroic=286200, Gladiator=286195, Elite=286196
	altitems[285453] = 286197 --[?] VFX variant (Rogue, Shroud of the Sudden Eclipse / Smokemantle of the Sudden Eclipse) real: LFR=286199, Normal=286194, Mythic=286201, Heroic=286200, Gladiator=286195, Elite=286196
	altitems[285456] = 286205 --[?] VFX variant (Rogue, Shroud of the Sudden Eclipse / Smokemantle of the Sudden Eclipse) real: LFR=286199, Normal=286194, Mythic=286201, Heroic=286200, Gladiator=286195, Elite=286196
	altitems[285455] = 286204 --[?] VFX variant (Rogue, Shroud of the Sudden Eclipse / Smokemantle of the Sudden Eclipse) real: LFR=286199, Normal=286194, Mythic=286201, Heroic=286200, Gladiator=286195, Elite=286196
	altitems[228536] = 286203 --[?] VFX variant (Rogue, Shroud of the Sudden Eclipse / Smokemantle of the Sudden Eclipse) real: LFR=286199, Normal=286194, Mythic=286201, Heroic=286200, Gladiator=286195, Elite=286196
	altitems[228535] = 286202 --[?] VFX variant (Rogue, Shroud of the Sudden Eclipse / Smokemantle of the Sudden Eclipse) real: LFR=286199, Normal=286194, Mythic=286201, Heroic=286200, Gladiator=286195, Elite=286196
	altitems[228540] = 286203 --[?] VFX variant (Rogue, Shroud of the Sudden Eclipse / Astral Gladiator's Leather Shoulderpads) sibling appearance, same alt as its DNT'd twin
	altitems[228539] = 286202 --[?] VFX variant (Rogue, Shroud of the Sudden Eclipse / Astral Gladiator's Leather Shoulderpads) sibling appearance, same alt as its DNT'd twin
	altitems[285378] = 286294 --[?] VFX variant (Monk, Crash of Fallen Storms / Thunderbund of Fallen Storms) real: LFR=286295, Normal=286290, Mythic=286297, Heroic=286296, Gladiator=286291, Elite=286292
	altitems[285377] = 286293 --[?] VFX variant (Monk, Crash of Fallen Storms / Thunderbund of Fallen Storms) real: LFR=286295, Normal=286290, Mythic=286297, Heroic=286296, Gladiator=286291, Elite=286292
	altitems[285380] = 286301 --[?] VFX variant (Monk, Crash of Fallen Storms / Thunderbund of Fallen Storms) real: LFR=286295, Normal=286290, Mythic=286297, Heroic=286296, Gladiator=286291, Elite=286292
	altitems[285379] = 286300 --[?] VFX variant (Monk, Crash of Fallen Storms / Thunderbund of Fallen Storms) real: LFR=286295, Normal=286290, Mythic=286297, Heroic=286296, Gladiator=286291, Elite=286292
	altitems[228468] = 286299 --[?] VFX variant (Monk, Crash of Fallen Storms / Thunderbund of Fallen Storms) real: LFR=286295, Normal=286290, Mythic=286297, Heroic=286296, Gladiator=286291, Elite=286292
	altitems[228467] = 286298 --[?] VFX variant (Monk, Crash of Fallen Storms / Thunderbund of Fallen Storms) real: LFR=286295, Normal=286290, Mythic=286297, Heroic=286296, Gladiator=286291, Elite=286292
	altitems[228472] = 286299 --[?] VFX variant (Monk, Crash of Fallen Storms / Astral Gladiator's Leather Strap) sibling appearance, same alt as its DNT'd twin
	altitems[228471] = 286298 --[?] VFX variant (Monk, Crash of Fallen Storms / Astral Gladiator's Leather Strap) sibling appearance, same alt as its DNT'd twin
	altitems[286307] = 286306 --[LFR] VFX variant (Monk, Crash of Fallen Storms / Glyphs of Fallen Storms) real: LFR=286307, Normal=286302, Mythic=286309, Heroic=286308, Gladiator=286303, Elite=286304
	altitems[286302] = 286305 --[Normal] VFX variant (Monk, Crash of Fallen Storms / Glyphs of Fallen Storms) real: LFR=286307, Normal=286302, Mythic=286309, Heroic=286308, Gladiator=286303, Elite=286304
	altitems[286309] = 286313 --[Mythic] VFX variant (Monk, Crash of Fallen Storms / Glyphs of Fallen Storms) real: LFR=286307, Normal=286302, Mythic=286309, Heroic=286308, Gladiator=286303, Elite=286304
	altitems[286308] = 286312 --[Heroic] VFX variant (Monk, Crash of Fallen Storms / Glyphs of Fallen Storms) real: LFR=286307, Normal=286302, Mythic=286309, Heroic=286308, Gladiator=286303, Elite=286304
	altitems[228460] = 286311 --[?] VFX variant (Monk, Crash of Fallen Storms / Glyphs of Fallen Storms) real: LFR=286307, Normal=286302, Mythic=286309, Heroic=286308, Gladiator=286303, Elite=286304
	altitems[228459] = 286310 --[?] VFX variant (Monk, Crash of Fallen Storms / Glyphs of Fallen Storms) real: LFR=286307, Normal=286302, Mythic=286309, Heroic=286308, Gladiator=286303, Elite=286304
	altitems[228464] = 286311 --[?] VFX variant (Monk, Crash of Fallen Storms / Astral Gladiator's Leather Shoulderpads) sibling appearance, same alt as its DNT'd twin
	altitems[228463] = 286310 --[?] VFX variant (Monk, Crash of Fallen Storms / Astral Gladiator's Leather Shoulderpads) sibling appearance, same alt as its DNT'd twin
	altitems[285346] = 286330 --[?] VFX variant (Monk, Crash of Fallen Storms / Half-Mask of Fallen Storms) real: LFR=286331, Normal=286326, Mythic=286333, Heroic=286332, Gladiator=286327, Elite=286328
	altitems[285345] = 286329 --[?] VFX variant (Monk, Crash of Fallen Storms / Half-Mask of Fallen Storms) real: LFR=286331, Normal=286326, Mythic=286333, Heroic=286332, Gladiator=286327, Elite=286328
	altitems[285348] = 286337 --[?] VFX variant (Monk, Crash of Fallen Storms / Half-Mask of Fallen Storms) real: LFR=286331, Normal=286326, Mythic=286333, Heroic=286332, Gladiator=286327, Elite=286328
	altitems[285347] = 286336 --[?] VFX variant (Monk, Crash of Fallen Storms / Half-Mask of Fallen Storms) real: LFR=286331, Normal=286326, Mythic=286333, Heroic=286332, Gladiator=286327, Elite=286328
	altitems[228444] = 286335 --[?] VFX variant (Monk, Crash of Fallen Storms / Half-Mask of Fallen Storms) real: LFR=286331, Normal=286326, Mythic=286333, Heroic=286332, Gladiator=286327, Elite=286328
	altitems[228443] = 286334 --[?] VFX variant (Monk, Crash of Fallen Storms / Half-Mask of Fallen Storms) real: LFR=286331, Normal=286326, Mythic=286333, Heroic=286332, Gladiator=286327, Elite=286328
	altitems[228448] = 286335 --[?] VFX variant (Monk, Crash of Fallen Storms / Astral Gladiator's Leather Mask) sibling appearance, same alt as its DNT'd twin
	altitems[228447] = 286334 --[?] VFX variant (Monk, Crash of Fallen Storms / Astral Gladiator's Leather Mask) sibling appearance, same alt as its DNT'd twin
	altitems[286343] = 286342 --[LFR] VFX variant (Monk, Crash of Fallen Storms / Grasp of Fallen Storms) real: LFR=286343, Normal=286338, Mythic=286345, Heroic=286344, Gladiator=286339, Elite=286340
	altitems[286338] = 286341 --[Normal] VFX variant (Monk, Crash of Fallen Storms / Grasp of Fallen Storms) real: LFR=286343, Normal=286338, Mythic=286345, Heroic=286344, Gladiator=286339, Elite=286340
	altitems[286345] = 286349 --[Mythic] VFX variant (Monk, Crash of Fallen Storms / Grasp of Fallen Storms) real: LFR=286343, Normal=286338, Mythic=286345, Heroic=286344, Gladiator=286339, Elite=286340
	altitems[286344] = 286348 --[Heroic] VFX variant (Monk, Crash of Fallen Storms / Grasp of Fallen Storms) real: LFR=286343, Normal=286338, Mythic=286345, Heroic=286344, Gladiator=286339, Elite=286340
	altitems[228436] = 286347 --[?] VFX variant (Monk, Crash of Fallen Storms / Grasp of Fallen Storms) real: LFR=286343, Normal=286338, Mythic=286345, Heroic=286344, Gladiator=286339, Elite=286340
	altitems[228435] = 286346 --[?] VFX variant (Monk, Crash of Fallen Storms / Grasp of Fallen Storms) real: LFR=286343, Normal=286338, Mythic=286345, Heroic=286344, Gladiator=286339, Elite=286340
	altitems[228440] = 286347 --[?] VFX variant (Monk, Crash of Fallen Storms / Astral Gladiator's Leather Grips) sibling appearance, same alt as its DNT'd twin
	altitems[228439] = 286346 --[?] VFX variant (Monk, Crash of Fallen Storms / Astral Gladiator's Leather Grips) sibling appearance, same alt as its DNT'd twin
	altitems[291856] = 286354 --[?] VFX variant (Monk, Crash of Fallen Storms / Footpads of Fallen Storms) real: LFR=286355, Normal=286350, Mythic=286357, Heroic=286356, Gladiator=286351, Elite=286352
	altitems[291855] = 286353 --[?] VFX variant (Monk, Crash of Fallen Storms / Footpads of Fallen Storms) real: LFR=286355, Normal=286350, Mythic=286357, Heroic=286356, Gladiator=286351, Elite=286352
	altitems[291858] = 286361 --[?] VFX variant (Monk, Crash of Fallen Storms / Footpads of Fallen Storms) real: LFR=286355, Normal=286350, Mythic=286357, Heroic=286356, Gladiator=286351, Elite=286352
	altitems[291857] = 286360 --[?] VFX variant (Monk, Crash of Fallen Storms / Footpads of Fallen Storms) real: LFR=286355, Normal=286350, Mythic=286357, Heroic=286356, Gladiator=286351, Elite=286352
	altitems[228428] = 286359 --[?] VFX variant (Monk, Crash of Fallen Storms / Footpads of Fallen Storms) real: LFR=286355, Normal=286350, Mythic=286357, Heroic=286356, Gladiator=286351, Elite=286352
	altitems[228427] = 286358 --[?] VFX variant (Monk, Crash of Fallen Storms / Footpads of Fallen Storms) real: LFR=286355, Normal=286350, Mythic=286357, Heroic=286356, Gladiator=286351, Elite=286352
	altitems[228432] = 286359 --[?] VFX variant (Monk, Crash of Fallen Storms / Astral Gladiator's Leather Treads) sibling appearance, same alt as its DNT'd twin
	altitems[228431] = 286358 --[?] VFX variant (Monk, Crash of Fallen Storms / Astral Gladiator's Leather Treads) sibling appearance, same alt as its DNT'd twin
	altitems[286367] = 286366 --[LFR] VFX variant (Monk, Crash of Fallen Storms / Gi of Fallen Storms) real: LFR=286367, Normal=286362, Mythic=286369, Heroic=286368, Gladiator=286363, Elite=286364
	altitems[286362] = 286365 --[Normal] VFX variant (Monk, Crash of Fallen Storms / Gi of Fallen Storms) real: LFR=286367, Normal=286362, Mythic=286369, Heroic=286368, Gladiator=286363, Elite=286364
	altitems[286369] = 286373 --[Mythic] VFX variant (Monk, Crash of Fallen Storms / Gi of Fallen Storms) real: LFR=286367, Normal=286362, Mythic=286369, Heroic=286368, Gladiator=286363, Elite=286364
	altitems[286368] = 286372 --[Heroic] VFX variant (Monk, Crash of Fallen Storms / Gi of Fallen Storms) real: LFR=286367, Normal=286362, Mythic=286369, Heroic=286368, Gladiator=286363, Elite=286364
	altitems[228420] = 286371 --[?] VFX variant (Monk, Crash of Fallen Storms / Gi of Fallen Storms) real: LFR=286367, Normal=286362, Mythic=286369, Heroic=286368, Gladiator=286363, Elite=286364
	altitems[228419] = 286370 --[?] VFX variant (Monk, Crash of Fallen Storms / Gi of Fallen Storms) real: LFR=286367, Normal=286362, Mythic=286369, Heroic=286368, Gladiator=286363, Elite=286364
	altitems[228424] = 286371 --[?] VFX variant (Monk, Crash of Fallen Storms / Astral Gladiator's Leather Jerkin) sibling appearance, same alt as its DNT'd twin
	altitems[228423] = 286370 --[?] VFX variant (Monk, Crash of Fallen Storms / Astral Gladiator's Leather Jerkin) sibling appearance, same alt as its DNT'd twin
	altitems[286403] = 286402 --[LFR] VFX variant (Druid, Ornaments of the Mother Eagle / Dreamsash of the Mother Eagle) real: LFR=286403, Normal=286398, Mythic=286405, Heroic=286404, Gladiator=286399, Elite=286400
	altitems[286398] = 286401 --[Normal] VFX variant (Druid, Ornaments of the Mother Eagle / Dreamsash of the Mother Eagle) real: LFR=286403, Normal=286398, Mythic=286405, Heroic=286404, Gladiator=286399, Elite=286400
	altitems[286405] = 286409 --[Mythic] VFX variant (Druid, Ornaments of the Mother Eagle / Dreamsash of the Mother Eagle) real: LFR=286403, Normal=286398, Mythic=286405, Heroic=286404, Gladiator=286399, Elite=286400
	altitems[286404] = 286408 --[Heroic] VFX variant (Druid, Ornaments of the Mother Eagle / Dreamsash of the Mother Eagle) real: LFR=286403, Normal=286398, Mythic=286405, Heroic=286404, Gladiator=286399, Elite=286400
	altitems[228316] = 286407 --[?] VFX variant (Druid, Ornaments of the Mother Eagle / Dreamsash of the Mother Eagle) real: LFR=286403, Normal=286398, Mythic=286405, Heroic=286404, Gladiator=286399, Elite=286400
	altitems[228315] = 286406 --[?] VFX variant (Druid, Ornaments of the Mother Eagle / Dreamsash of the Mother Eagle) real: LFR=286403, Normal=286398, Mythic=286405, Heroic=286404, Gladiator=286399, Elite=286400
	altitems[228320] = 286407 --[?] VFX variant (Druid, Ornaments of the Mother Eagle / Astral Gladiator's Leather Strap) sibling appearance, same alt as its DNT'd twin
	altitems[228319] = 286406 --[?] VFX variant (Druid, Ornaments of the Mother Eagle / Astral Gladiator's Leather Strap) sibling appearance, same alt as its DNT'd twin
	altitems[286415] = 286414 --[LFR] VFX variant (Druid, Ornaments of the Mother Eagle / Ritual Pauldrons of the Mother Eagle) real: LFR=286415, Normal=286410, Mythic=286417, Heroic=286416, Gladiator=286411, Elite=286412
	altitems[286410] = 286413 --[Normal] VFX variant (Druid, Ornaments of the Mother Eagle / Ritual Pauldrons of the Mother Eagle) real: LFR=286415, Normal=286410, Mythic=286417, Heroic=286416, Gladiator=286411, Elite=286412
	altitems[286417] = 286421 --[Mythic] VFX variant (Druid, Ornaments of the Mother Eagle / Ritual Pauldrons of the Mother Eagle) real: LFR=286415, Normal=286410, Mythic=286417, Heroic=286416, Gladiator=286411, Elite=286412
	altitems[286416] = 286420 --[Heroic] VFX variant (Druid, Ornaments of the Mother Eagle / Ritual Pauldrons of the Mother Eagle) real: LFR=286415, Normal=286410, Mythic=286417, Heroic=286416, Gladiator=286411, Elite=286412
	altitems[228308] = 286419 --[?] VFX variant (Druid, Ornaments of the Mother Eagle / Ritual Pauldrons of the Mother Eagle) real: LFR=286415, Normal=286410, Mythic=286417, Heroic=286416, Gladiator=286411, Elite=286412
	altitems[228307] = 286418 --[?] VFX variant (Druid, Ornaments of the Mother Eagle / Ritual Pauldrons of the Mother Eagle) real: LFR=286415, Normal=286410, Mythic=286417, Heroic=286416, Gladiator=286411, Elite=286412
	altitems[228312] = 286419 --[?] VFX variant (Druid, Ornaments of the Mother Eagle / Astral Gladiator's Leather Shoulderpads) sibling appearance, same alt as its DNT'd twin
	altitems[228311] = 286418 --[?] VFX variant (Druid, Ornaments of the Mother Eagle / Astral Gladiator's Leather Shoulderpads) sibling appearance, same alt as its DNT'd twin
	altitems[286439] = 286438 --[LFR] VFX variant (Druid, Ornaments of the Mother Eagle / Skymane of the Mother Eagle) real: LFR=286439, Normal=286434, Mythic=286441, Heroic=286440, Gladiator=286435, Elite=286436
	altitems[286434] = 286437 --[Normal] VFX variant (Druid, Ornaments of the Mother Eagle / Skymane of the Mother Eagle) real: LFR=286439, Normal=286434, Mythic=286441, Heroic=286440, Gladiator=286435, Elite=286436
	altitems[286441] = 286445 --[Mythic] VFX variant (Druid, Ornaments of the Mother Eagle / Skymane of the Mother Eagle) real: LFR=286439, Normal=286434, Mythic=286441, Heroic=286440, Gladiator=286435, Elite=286436
	altitems[286440] = 286444 --[Heroic] VFX variant (Druid, Ornaments of the Mother Eagle / Skymane of the Mother Eagle) real: LFR=286439, Normal=286434, Mythic=286441, Heroic=286440, Gladiator=286435, Elite=286436
	altitems[228292] = 286443 --[?] VFX variant (Druid, Ornaments of the Mother Eagle / Skymane of the Mother Eagle) real: LFR=286439, Normal=286434, Mythic=286441, Heroic=286440, Gladiator=286435, Elite=286436
	altitems[228291] = 286442 --[?] VFX variant (Druid, Ornaments of the Mother Eagle / Skymane of the Mother Eagle) real: LFR=286439, Normal=286434, Mythic=286441, Heroic=286440, Gladiator=286435, Elite=286436
	altitems[228296] = 286443 --[?] VFX variant (Druid, Ornaments of the Mother Eagle / Astral Gladiator's Leather Mask) sibling appearance, same alt as its DNT'd twin
	altitems[228295] = 286442 --[?] VFX variant (Druid, Ornaments of the Mother Eagle / Astral Gladiator's Leather Mask) sibling appearance, same alt as its DNT'd twin
	altitems[286475] = 286474 --[LFR] VFX variant (Druid, Ornaments of the Mother Eagle / Vest of the Mother Eagle) real: LFR=286475, Normal=286470, Mythic=286477, Heroic=286476, Gladiator=286471, Elite=286472
	altitems[286470] = 286473 --[Normal] VFX variant (Druid, Ornaments of the Mother Eagle / Vest of the Mother Eagle) real: LFR=286475, Normal=286470, Mythic=286477, Heroic=286476, Gladiator=286471, Elite=286472
	altitems[286477] = 286481 --[Mythic] VFX variant (Druid, Ornaments of the Mother Eagle / Vest of the Mother Eagle) real: LFR=286475, Normal=286470, Mythic=286477, Heroic=286476, Gladiator=286471, Elite=286472
	altitems[286476] = 286480 --[Heroic] VFX variant (Druid, Ornaments of the Mother Eagle / Vest of the Mother Eagle) real: LFR=286475, Normal=286470, Mythic=286477, Heroic=286476, Gladiator=286471, Elite=286472
	altitems[228268] = 286479 --[?] VFX variant (Druid, Ornaments of the Mother Eagle / Vest of the Mother Eagle) real: LFR=286475, Normal=286470, Mythic=286477, Heroic=286476, Gladiator=286471, Elite=286472
	altitems[228267] = 286478 --[?] VFX variant (Druid, Ornaments of the Mother Eagle / Vest of the Mother Eagle) real: LFR=286475, Normal=286470, Mythic=286477, Heroic=286476, Gladiator=286471, Elite=286472
	altitems[228272] = 286479 --[?] VFX variant (Druid, Ornaments of the Mother Eagle / Astral Gladiator's Leather Vestments) sibling appearance, same alt as its DNT'd twin
	altitems[228271] = 286478 --[?] VFX variant (Druid, Ornaments of the Mother Eagle / Astral Gladiator's Leather Vestments) sibling appearance, same alt as its DNT'd twin
	altitems[286523] = 286522 --[LFR] VFX variant (Demon Hunter, Charhound's Vicious Hunt / Charhound's Vicious Hornguards) real: LFR=286523, Mythic=286525, Heroic=286524, Normal=286518, Gladiator=286519, Elite=286520
	altitems[286525] = 286521 --[Mythic] VFX variant (Demon Hunter, Charhound's Vicious Hunt / Charhound's Vicious Hornguards) real: LFR=286523, Mythic=286525, Heroic=286524, Normal=286518, Gladiator=286519, Elite=286520
	altitems[286524] = 286529 --[Heroic] VFX variant (Demon Hunter, Charhound's Vicious Hunt / Charhound's Vicious Hornguards) real: LFR=286523, Mythic=286525, Heroic=286524, Normal=286518, Gladiator=286519, Elite=286520
	altitems[286518] = 286528 --[Normal] VFX variant (Demon Hunter, Charhound's Vicious Hunt / Charhound's Vicious Hornguards) real: LFR=286523, Mythic=286525, Heroic=286524, Normal=286518, Gladiator=286519, Elite=286520
	altitems[228384] = 286527 --[?] VFX variant (Demon Hunter, Charhound's Vicious Hunt / Charhound's Vicious Hornguards) real: LFR=286523, Mythic=286525, Heroic=286524, Normal=286518, Gladiator=286519, Elite=286520
	altitems[228383] = 286526 --[?] VFX variant (Demon Hunter, Charhound's Vicious Hunt / Charhound's Vicious Hornguards) real: LFR=286523, Mythic=286525, Heroic=286524, Normal=286518, Gladiator=286519, Elite=286520
	altitems[228388] = 286527 --[?] VFX variant (Demon Hunter, Charhound's Vicious Hunt / Astral Gladiator's Leather Shoulderpads) sibling appearance, same alt as its DNT'd twin
	altitems[228387] = 286526 --[?] VFX variant (Demon Hunter, Charhound's Vicious Hunt / Astral Gladiator's Leather Shoulderpads) sibling appearance, same alt as its DNT'd twin
	altitems[286547] = 286546 --[LFR] VFX variant (Demon Hunter, Charhound's Vicious Hunt / Charhound's Vicious Scalp) real: LFR=286547, Mythic=286549, Heroic=286548, Normal=286542, Gladiator=286543, Elite=286544
	altitems[286549] = 286545 --[Mythic] VFX variant (Demon Hunter, Charhound's Vicious Hunt / Charhound's Vicious Scalp) real: LFR=286547, Mythic=286549, Heroic=286548, Normal=286542, Gladiator=286543, Elite=286544
	altitems[286548] = 286553 --[Heroic] VFX variant (Demon Hunter, Charhound's Vicious Hunt / Charhound's Vicious Scalp) real: LFR=286547, Mythic=286549, Heroic=286548, Normal=286542, Gladiator=286543, Elite=286544
	altitems[286542] = 286552 --[Normal] VFX variant (Demon Hunter, Charhound's Vicious Hunt / Charhound's Vicious Scalp) real: LFR=286547, Mythic=286549, Heroic=286548, Normal=286542, Gladiator=286543, Elite=286544
	altitems[228368] = 286551 --[?] VFX variant (Demon Hunter, Charhound's Vicious Hunt / Charhound's Vicious Scalp) real: LFR=286547, Mythic=286549, Heroic=286548, Normal=286542, Gladiator=286543, Elite=286544
	altitems[228367] = 286550 --[?] VFX variant (Demon Hunter, Charhound's Vicious Hunt / Charhound's Vicious Scalp) real: LFR=286547, Mythic=286549, Heroic=286548, Normal=286542, Gladiator=286543, Elite=286544
	altitems[228372] = 286551 --[?] VFX variant (Demon Hunter, Charhound's Vicious Hunt / Astral Gladiator's Leather Mask) sibling appearance, same alt as its DNT'd twin
	altitems[228371] = 286550 --[?] VFX variant (Demon Hunter, Charhound's Vicious Hunt / Astral Gladiator's Leather Mask) sibling appearance, same alt as its DNT'd twin
	altitems[286631] = 286630 --[LFR] VFX variant (Warlock, Inquisitor's Feast of Madness / Inquisitor's Gaze of Madness) real: LFR=286631, Normal=286626, Mythic=286633, Heroic=286632, Gladiator=286627, Elite=286628
	altitems[291775] = 286629 --[?] VFX variant (Warlock, Inquisitor's Feast of Madness / Inquisitor's Gaze of Madness) real: LFR=286631, Normal=286626, Mythic=286633, Heroic=286632, Gladiator=286627, Elite=286628
	altitems[286633] = 286637 --[Mythic] VFX variant (Warlock, Inquisitor's Feast of Madness / Inquisitor's Gaze of Madness) real: LFR=286631, Normal=286626, Mythic=286633, Heroic=286632, Gladiator=286627, Elite=286628
	altitems[286632] = 286636 --[Heroic] VFX variant (Warlock, Inquisitor's Feast of Madness / Inquisitor's Gaze of Madness) real: LFR=286631, Normal=286626, Mythic=286633, Heroic=286632, Gladiator=286627, Elite=286628
	altitems[228232] = 286635 --[?] VFX variant (Warlock, Inquisitor's Feast of Madness / Inquisitor's Gaze of Madness) real: LFR=286631, Normal=286626, Mythic=286633, Heroic=286632, Gladiator=286627, Elite=286628
	altitems[228231] = 286634 --[?] VFX variant (Warlock, Inquisitor's Feast of Madness / Inquisitor's Gaze of Madness) real: LFR=286631, Normal=286626, Mythic=286633, Heroic=286632, Gladiator=286627, Elite=286628
	altitems[228236] = 286635 --[?] VFX variant (Warlock, Inquisitor's Feast of Madness / Astral Gladiator's Silk Amice) sibling appearance, same alt as its DNT'd twin
	altitems[228235] = 286634 --[?] VFX variant (Warlock, Inquisitor's Feast of Madness / Astral Gladiator's Silk Amice) sibling appearance, same alt as its DNT'd twin
	altitems[286655] = 286654 --[LFR] VFX variant (Warlock, Inquisitor's Feast of Madness / Inquisitor's Portal to Madness) real: LFR=286655, Normal=286650, Mythic=286657, Heroic=286656, Gladiator=286651, Elite=286652
	altitems[286650] = 286653 --[Normal] VFX variant (Warlock, Inquisitor's Feast of Madness / Inquisitor's Portal to Madness) real: LFR=286655, Normal=286650, Mythic=286657, Heroic=286656, Gladiator=286651, Elite=286652
	altitems[286657] = 286661 --[Mythic] VFX variant (Warlock, Inquisitor's Feast of Madness / Inquisitor's Portal to Madness) real: LFR=286655, Normal=286650, Mythic=286657, Heroic=286656, Gladiator=286651, Elite=286652
	altitems[286656] = 286660 --[Heroic] VFX variant (Warlock, Inquisitor's Feast of Madness / Inquisitor's Portal to Madness) real: LFR=286655, Normal=286650, Mythic=286657, Heroic=286656, Gladiator=286651, Elite=286652
	altitems[228216] = 286659 --[?] VFX variant (Warlock, Inquisitor's Feast of Madness / Inquisitor's Portal to Madness) real: LFR=286655, Normal=286650, Mythic=286657, Heroic=286656, Gladiator=286651, Elite=286652
	altitems[228215] = 286658 --[?] VFX variant (Warlock, Inquisitor's Feast of Madness / Inquisitor's Portal to Madness) real: LFR=286655, Normal=286650, Mythic=286657, Heroic=286656, Gladiator=286651, Elite=286652
	altitems[228220] = 286659 --[?] VFX variant (Warlock, Inquisitor's Feast of Madness / Astral Gladiator's Silk Guise) sibling appearance, same alt as its DNT'd twin
	altitems[228219] = 286658 --[?] VFX variant (Warlock, Inquisitor's Feast of Madness / Astral Gladiator's Silk Guise) sibling appearance, same alt as its DNT'd twin
	altitems[285434] = 286738 --[?] VFX variant (Priest, Eulogy to a Dying Star / Dying Star's Pyrelights) real: LFR=286739, Normal=286734, Mythic=286741, Heroic=286740, Gladiator=286735, Elite=286736
	altitems[285433] = 286737 --[?] VFX variant (Priest, Eulogy to a Dying Star / Dying Star's Pyrelights) real: LFR=286739, Normal=286734, Mythic=286741, Heroic=286740, Gladiator=286735, Elite=286736
	altitems[285436] = 286745 --[?] VFX variant (Priest, Eulogy to a Dying Star / Dying Star's Pyrelights) real: LFR=286739, Normal=286734, Mythic=286741, Heroic=286740, Gladiator=286735, Elite=286736
	altitems[285435] = 286744 --[?] VFX variant (Priest, Eulogy to a Dying Star / Dying Star's Pyrelights) real: LFR=286739, Normal=286734, Mythic=286741, Heroic=286740, Gladiator=286735, Elite=286736
	altitems[228156] = 286743 --[?] VFX variant (Priest, Eulogy to a Dying Star / Dying Star's Pyrelights) real: LFR=286739, Normal=286734, Mythic=286741, Heroic=286740, Gladiator=286735, Elite=286736
	altitems[228155] = 286742 --[?] VFX variant (Priest, Eulogy to a Dying Star / Dying Star's Pyrelights) real: LFR=286739, Normal=286734, Mythic=286741, Heroic=286740, Gladiator=286735, Elite=286736
	altitems[296323] = 286737 --[?] VFX variant (Priest, Eulogy to a Dying Star / ?) sibling appearance, same alt as its DNT'd twin
	altitems[228160] = 286743 --[?] VFX variant (Priest, Eulogy to a Dying Star / Astral Gladiator's Silk Amice) sibling appearance, same alt as its DNT'd twin
	altitems[228159] = 286742 --[?] VFX variant (Priest, Eulogy to a Dying Star / Astral Gladiator's Silk Amice) sibling appearance, same alt as its DNT'd twin
	altitems[285438] = 286762 --[?] VFX variant (Priest, Eulogy to a Dying Star / Dying Star's Veil) real: LFR=286763, Normal=286758, Mythic=286765, Heroic=286764, Gladiator=286759, Elite=286760
	altitems[285437] = 286761 --[?] VFX variant (Priest, Eulogy to a Dying Star / Dying Star's Veil) real: LFR=286763, Normal=286758, Mythic=286765, Heroic=286764, Gladiator=286759, Elite=286760
	altitems[285440] = 286769 --[?] VFX variant (Priest, Eulogy to a Dying Star / Dying Star's Veil) real: LFR=286763, Normal=286758, Mythic=286765, Heroic=286764, Gladiator=286759, Elite=286760
	altitems[285439] = 286768 --[?] VFX variant (Priest, Eulogy to a Dying Star / Dying Star's Veil) real: LFR=286763, Normal=286758, Mythic=286765, Heroic=286764, Gladiator=286759, Elite=286760
	altitems[228140] = 286767 --[?] VFX variant (Priest, Eulogy to a Dying Star / Dying Star's Veil) real: LFR=286763, Normal=286758, Mythic=286765, Heroic=286764, Gladiator=286759, Elite=286760
	altitems[228139] = 286766 --[?] VFX variant (Priest, Eulogy to a Dying Star / Dying Star's Veil) real: LFR=286763, Normal=286758, Mythic=286765, Heroic=286764, Gladiator=286759, Elite=286760
	altitems[228144] = 286767 --[?] VFX variant (Priest, Eulogy to a Dying Star / Astral Gladiator's Silk Guise) sibling appearance, same alt as its DNT'd twin
	altitems[228143] = 286766 --[?] VFX variant (Priest, Eulogy to a Dying Star / Astral Gladiator's Silk Guise) sibling appearance, same alt as its DNT'd twin
	altitems[286834] = 286833 --[LFR] VFX variant (Mage, Augur's Ephemeral Plumage / Augur's Ephemeral Quillsash) real: LFR=286834, Normal=286829, Mythic=286836, Heroic=286835, Gladiator=286830, Elite=286831
	altitems[291779] = 286832 --[?] VFX variant (Mage, Augur's Ephemeral Plumage / Augur's Ephemeral Quillsash) real: LFR=286834, Normal=286829, Mythic=286836, Heroic=286835, Gladiator=286830, Elite=286831
	altitems[286836] = 286840 --[Mythic] VFX variant (Mage, Augur's Ephemeral Plumage / Augur's Ephemeral Quillsash) real: LFR=286834, Normal=286829, Mythic=286836, Heroic=286835, Gladiator=286830, Elite=286831
	altitems[286835] = 286839 --[Heroic] VFX variant (Mage, Augur's Ephemeral Plumage / Augur's Ephemeral Quillsash) real: LFR=286834, Normal=286829, Mythic=286836, Heroic=286835, Gladiator=286830, Elite=286831
	altitems[228088] = 286838 --[?] VFX variant (Mage, Augur's Ephemeral Plumage / Augur's Ephemeral Quillsash) real: LFR=286834, Normal=286829, Mythic=286836, Heroic=286835, Gladiator=286830, Elite=286831
	altitems[228087] = 286837 --[?] VFX variant (Mage, Augur's Ephemeral Plumage / Augur's Ephemeral Quillsash) real: LFR=286834, Normal=286829, Mythic=286836, Heroic=286835, Gladiator=286830, Elite=286831
	altitems[228092] = 286838 --[?] VFX variant (Mage, Augur's Ephemeral Plumage / Astral Gladiator's Silk Belt) sibling appearance, same alt as its DNT'd twin
	altitems[228091] = 286837 --[?] VFX variant (Mage, Augur's Ephemeral Plumage / Astral Gladiator's Silk Belt) sibling appearance, same alt as its DNT'd twin
	altitems[286846] = 286845 --[LFR] VFX variant (Mage, Augur's Ephemeral Plumage / Augur's Ephemeral Orbs of Power) real: LFR=286846, Normal=286841, Mythic=286848, Heroic=286847, Gladiator=286842, Elite=286843
	altitems[286841] = 286844 --[Normal] VFX variant (Mage, Augur's Ephemeral Plumage / Augur's Ephemeral Orbs of Power) real: LFR=286846, Normal=286841, Mythic=286848, Heroic=286847, Gladiator=286842, Elite=286843
	altitems[286848] = 286852 --[Mythic] VFX variant (Mage, Augur's Ephemeral Plumage / Augur's Ephemeral Orbs of Power) real: LFR=286846, Normal=286841, Mythic=286848, Heroic=286847, Gladiator=286842, Elite=286843
	altitems[286847] = 286851 --[Heroic] VFX variant (Mage, Augur's Ephemeral Plumage / Augur's Ephemeral Orbs of Power) real: LFR=286846, Normal=286841, Mythic=286848, Heroic=286847, Gladiator=286842, Elite=286843
	altitems[228080] = 286850 --[?] VFX variant (Mage, Augur's Ephemeral Plumage / Augur's Ephemeral Orbs of Power) real: LFR=286846, Normal=286841, Mythic=286848, Heroic=286847, Gladiator=286842, Elite=286843
	altitems[228079] = 286849 --[?] VFX variant (Mage, Augur's Ephemeral Plumage / Augur's Ephemeral Orbs of Power) real: LFR=286846, Normal=286841, Mythic=286848, Heroic=286847, Gladiator=286842, Elite=286843
	altitems[228084] = 286850 --[?] VFX variant (Mage, Augur's Ephemeral Plumage / Astral Gladiator's Silk Amice) sibling appearance, same alt as its DNT'd twin
	altitems[228083] = 286849 --[?] VFX variant (Mage, Augur's Ephemeral Plumage / Astral Gladiator's Silk Amice) sibling appearance, same alt as its DNT'd twin
	altitems[287321] = 286869 --[?] VFX variant (Mage, Augur's Ephemeral Plumage / Augur's Ephemeral Wide-Brim) real: LFR=286870, Normal=286865, Mythic=286872, Heroic=286871, Gladiator=286866, Elite=286867
	altitems[287320] = 286868 --[?] VFX variant (Mage, Augur's Ephemeral Plumage / Augur's Ephemeral Wide-Brim) real: LFR=286870, Normal=286865, Mythic=286872, Heroic=286871, Gladiator=286866, Elite=286867
	altitems[287323] = 286876 --[?] VFX variant (Mage, Augur's Ephemeral Plumage / Augur's Ephemeral Wide-Brim) real: LFR=286870, Normal=286865, Mythic=286872, Heroic=286871, Gladiator=286866, Elite=286867
	altitems[287322] = 286875 --[?] VFX variant (Mage, Augur's Ephemeral Plumage / Augur's Ephemeral Wide-Brim) real: LFR=286870, Normal=286865, Mythic=286872, Heroic=286871, Gladiator=286866, Elite=286867
	altitems[228064] = 286874 --[?] VFX variant (Mage, Augur's Ephemeral Plumage / Augur's Ephemeral Wide-Brim) real: LFR=286870, Normal=286865, Mythic=286872, Heroic=286871, Gladiator=286866, Elite=286867
	altitems[228063] = 286873 --[?] VFX variant (Mage, Augur's Ephemeral Plumage / Augur's Ephemeral Wide-Brim) real: LFR=286870, Normal=286865, Mythic=286872, Heroic=286871, Gladiator=286866, Elite=286867
	altitems[228068] = 286874 --[?] VFX variant (Mage, Augur's Ephemeral Plumage / Astral Gladiator's Silk Cap) sibling appearance, same alt as its DNT'd twin
	altitems[228067] = 286873 --[?] VFX variant (Mage, Augur's Ephemeral Plumage / Astral Gladiator's Silk Cap) sibling appearance, same alt as its DNT'd twin
