local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
addon.AltItems = addon.AltItems or {}
local altitems = addon.AltItems

--Midnight Season 2 -- VFX/DNT sourceIDs only; keys are negative placeholders (never match a real sourceID) so this stays loadable while you fill in the correct real tier sourceID by hand.
	altitems[305404] = 305406 --[Gladiator] VFX variant (Mage, Venomous Gladiator's Silk Armor / Venomous Gladiator's Silk Hat) real: Elite=305405, Gladiator=305404, Elite=305405
	altitems[305405] = 305407 --[Elite] VFX variant (Mage, Venomous Gladiator's Silk Armor / Venomous Gladiator's Silk Hat) real: Elite=305405, Gladiator=305404, Elite=305405
	altitems[305408] = 305410 --[Gladiator] VFX variant (Mage, Venomous Gladiator's Silk Armor / Venomous Gladiator's Silk Cap) real: Elite=305409, Gladiator=305408, Elite=305409
	altitems[305409] = 305411 --[Elite] VFX variant (Mage, Venomous Gladiator's Silk Armor / Venomous Gladiator's Silk Cap) real: Elite=305409, Gladiator=305408, Elite=305409
	altitems[305420] = 305422 --[Gladiator] VFX variant (Mage, Venomous Gladiator's Silk Armor / Venomous Gladiator's Silk Mantle) real: Elite=305421, Gladiator=305420, Elite=305421
	altitems[305421] = 305423 --[Elite] VFX variant (Mage, Venomous Gladiator's Silk Armor / Venomous Gladiator's Silk Mantle) real: Elite=305421, Gladiator=305420, Elite=305421
	altitems[305424] = 305426 --[Gladiator] VFX variant (Mage, Venomous Gladiator's Silk Armor / Venomous Gladiator's Silk Amice) real: Elite=305425, Gladiator=305424, Elite=305425
	altitems[305425] = 305427 --[Elite] VFX variant (Mage, Venomous Gladiator's Silk Armor / Venomous Gladiator's Silk Amice) real: Elite=305425, Gladiator=305424, Elite=305425
	altitems[305469] = 305471 --[Elite] VFX variant (Priest, Venomous Gladiator's Silk Armor / Venomous Gladiator's Silk Hood) real: Elite=305469, Gladiator=305468, Elite=305469
	altitems[305468] = 305470 --[Gladiator] VFX variant (Priest, Venomous Gladiator's Silk Armor / Venomous Gladiator's Silk Hood) real: Elite=305469, Gladiator=305468, Elite=305469
	altitems[305473] = 305475 --[Elite] VFX variant (Priest, Venomous Gladiator's Silk Armor / Venomous Gladiator's Silk Guise) real: Elite=305473, Gladiator=305472, Elite=305473
	altitems[305472] = 305474 --[Gladiator] VFX variant (Priest, Venomous Gladiator's Silk Armor / Venomous Gladiator's Silk Guise) real: Elite=305473, Gladiator=305472, Elite=305473
	altitems[305485] = 305487 --[Elite] VFX variant (Priest, Venomous Gladiator's Silk Armor / Venomous Gladiator's Silk Mantle) real: Elite=305485, Gladiator=305484, Elite=305485
	altitems[305484] = 305486 --[Gladiator] VFX variant (Priest, Venomous Gladiator's Silk Armor / Venomous Gladiator's Silk Mantle) real: Elite=305485, Gladiator=305484, Elite=305485
	altitems[305489] = 305491 --[Elite] VFX variant (Priest, Venomous Gladiator's Silk Armor / Venomous Gladiator's Silk Amice) real: Elite=305489, Gladiator=305488, Elite=305489
	altitems[305488] = 305490 --[Gladiator] VFX variant (Priest, Venomous Gladiator's Silk Armor / Venomous Gladiator's Silk Amice) real: Elite=305489, Gladiator=305488, Elite=305489
	altitems[305532] = 305534 --[Gladiator] VFX variant (Warlock, Venomous Gladiator's Silk Armor / Venomous Gladiator's Silk Hood) real: Elite=305533, Gladiator=305532, Elite=305533
	altitems[305533] = 305535 --[Elite] VFX variant (Warlock, Venomous Gladiator's Silk Armor / Venomous Gladiator's Silk Hood) real: Elite=305533, Gladiator=305532, Elite=305533
	altitems[305536] = 305538 --[Gladiator] VFX variant (Warlock, Venomous Gladiator's Silk Armor / Venomous Gladiator's Silk Guise) real: Elite=305537, Gladiator=305536, Elite=305537
	altitems[305537] = 305539 --[Elite] VFX variant (Warlock, Venomous Gladiator's Silk Armor / Venomous Gladiator's Silk Guise) real: Elite=305537, Gladiator=305536, Elite=305537
	altitems[305548] = 305550 --[Gladiator] VFX variant (Warlock, Venomous Gladiator's Silk Armor / Venomous Gladiator's Silk Mantle) real: Elite=305549, Gladiator=305548, Elite=305549
	altitems[305549] = 305551 --[Elite] VFX variant (Warlock, Venomous Gladiator's Silk Armor / Venomous Gladiator's Silk Mantle) real: Elite=305549, Gladiator=305548, Elite=305549
	altitems[305552] = 305554 --[Gladiator] VFX variant (Warlock, Venomous Gladiator's Silk Armor / Venomous Gladiator's Silk Amice) real: Elite=305553, Gladiator=305552, Elite=305553
	altitems[305553] = 305555 --[Elite] VFX variant (Warlock, Venomous Gladiator's Silk Armor / Venomous Gladiator's Silk Amice) real: Elite=305553, Gladiator=305552, Elite=305553
	altitems[305580] = 305582 --[Gladiator] VFX variant (Demon Hunter, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Boots) real: Elite=305581, Gladiator=305580, Elite=305581
	altitems[305581] = 305583 --[Elite] VFX variant (Demon Hunter, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Boots) real: Elite=305581, Gladiator=305580, Elite=305581
	altitems[305584] = 305586 --[Gladiator] VFX variant (Demon Hunter, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Treads) real: Elite=305585, Gladiator=305584, Elite=305585
	altitems[305585] = 305587 --[Elite] VFX variant (Demon Hunter, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Treads) real: Elite=305585, Gladiator=305584, Elite=305585
	altitems[305612] = 305614 --[Gladiator] VFX variant (Demon Hunter, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Spaulders) real: Elite=305613, Gladiator=305612, Elite=305613
	altitems[305613] = 305615 --[Elite] VFX variant (Demon Hunter, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Spaulders) real: Elite=305613, Gladiator=305612, Elite=305613
	altitems[305616] = 305618 --[Gladiator] VFX variant (Demon Hunter, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Shoulderpads) real: Elite=305617, Gladiator=305616, Elite=305617
	altitems[305617] = 305619 --[Elite] VFX variant (Demon Hunter, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Shoulderpads) real: Elite=305617, Gladiator=305616, Elite=305617
	altitems[305620] = 305622 --[Gladiator] VFX variant (Demon Hunter, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Belt) real: Elite=305621, Gladiator=305620, Elite=305621
	altitems[305621] = 305623 --[Elite] VFX variant (Demon Hunter, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Belt) real: Elite=305621, Gladiator=305620, Elite=305621
	altitems[305624] = 305626 --[Gladiator] VFX variant (Demon Hunter, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Strap) real: Elite=305625, Gladiator=305624, Elite=305625
	altitems[305625] = 305627 --[Elite] VFX variant (Demon Hunter, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Strap) real: Elite=305625, Gladiator=305624, Elite=305625
	altitems[305660] = 305662 --[Gladiator] VFX variant (Druid, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Helm) real: Elite=305661, Gladiator=305660, Elite=305661
	altitems[305661] = 305663 --[Elite] VFX variant (Druid, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Helm) real: Elite=305661, Gladiator=305660, Elite=305661
	altitems[305664] = 305666 --[Gladiator] VFX variant (Druid, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Mask) real: Elite=305665, Gladiator=305664, Elite=305665
	altitems[305665] = 305667 --[Elite] VFX variant (Druid, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Mask) real: Elite=305665, Gladiator=305664, Elite=305665
	altitems[305676] = 305678 --[Gladiator] VFX variant (Druid, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Spaulders) real: Elite=305677, Gladiator=305676, Elite=305677
	altitems[305677] = 305679 --[Elite] VFX variant (Druid, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Spaulders) real: Elite=305677, Gladiator=305676, Elite=305677
	altitems[305680] = 305682 --[Gladiator] VFX variant (Druid, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Shoulderpads) real: Elite=305681, Gladiator=305680, Elite=305681
	altitems[305681] = 305683 --[Elite] VFX variant (Druid, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Shoulderpads) real: Elite=305681, Gladiator=305680, Elite=305681
	altitems[305724] = 305726 --[Gladiator] VFX variant (Monk, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Helm) real: Elite=305725, Gladiator=305724, Elite=305725
	altitems[305725] = 305727 --[Elite] VFX variant (Monk, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Helm) real: Elite=305725, Gladiator=305724, Elite=305725
	altitems[305728] = 305730 --[Gladiator] VFX variant (Monk, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Mask) real: Elite=305729, Gladiator=305728, Elite=305729
	altitems[305729] = 305731 --[Elite] VFX variant (Monk, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Mask) real: Elite=305729, Gladiator=305728, Elite=305729
	altitems[305740] = 305742 --[Gladiator] VFX variant (Monk, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Spaulders) real: Elite=305741, Gladiator=305740, Elite=305741
	altitems[305741] = 305743 --[Elite] VFX variant (Monk, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Spaulders) real: Elite=305741, Gladiator=305740, Elite=305741
	altitems[305744] = 305746 --[Gladiator] VFX variant (Monk, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Shoulderpads) real: Elite=305745, Gladiator=305744, Elite=305745
	altitems[305745] = 305747 --[Elite] VFX variant (Monk, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Shoulderpads) real: Elite=305745, Gladiator=305744, Elite=305745
	altitems[305780] = 305782 --[Gladiator] VFX variant (Rogue, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Gloves) real: Elite=305781, Gladiator=305780, Elite=305781
	altitems[305781] = 305783 --[Elite] VFX variant (Rogue, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Gloves) real: Elite=305781, Gladiator=305780, Elite=305781
	altitems[305784] = 305786 --[Gladiator] VFX variant (Rogue, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Grips) real: Elite=305785, Gladiator=305784, Elite=305785
	altitems[305785] = 305787 --[Elite] VFX variant (Rogue, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Grips) real: Elite=305785, Gladiator=305784, Elite=305785
	altitems[305788] = 305790 --[Gladiator] VFX variant (Rogue, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Helm) real: Elite=305789, Gladiator=305788, Elite=305789
	altitems[305789] = 305791 --[Elite] VFX variant (Rogue, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Helm) real: Elite=305789, Gladiator=305788, Elite=305789
	altitems[305792] = 305794 --[Gladiator] VFX variant (Rogue, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Mask) real: Elite=305793, Gladiator=305792, Elite=305793
	altitems[305793] = 305795 --[Elite] VFX variant (Rogue, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Mask) real: Elite=305793, Gladiator=305792, Elite=305793
	altitems[305804] = 305806 --[Gladiator] VFX variant (Rogue, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Spaulders) real: Elite=305805, Gladiator=305804, Elite=305805
	altitems[305805] = 305807 --[Elite] VFX variant (Rogue, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Spaulders) real: Elite=305805, Gladiator=305804, Elite=305805
	altitems[305808] = 305810 --[Gladiator] VFX variant (Rogue, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Shoulderpads) real: Elite=305809, Gladiator=305808, Elite=305809
	altitems[305809] = 305811 --[Elite] VFX variant (Rogue, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Shoulderpads) real: Elite=305809, Gladiator=305808, Elite=305809
	altitems[305812] = 305814 --[Gladiator] VFX variant (Rogue, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Belt) real: Elite=305813, Gladiator=305812, Elite=305813
	altitems[305813] = 305815 --[Elite] VFX variant (Rogue, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Belt) real: Elite=305813, Gladiator=305812, Elite=305813
	altitems[305816] = 305818 --[Gladiator] VFX variant (Rogue, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Strap) real: Elite=305817, Gladiator=305816, Elite=305817
	altitems[305817] = 305819 --[Elite] VFX variant (Rogue, Venomous Gladiator's Leather Armor / Venomous Gladiator's Leather Strap) real: Elite=305817, Gladiator=305816, Elite=305817
	altitems[305828] = 305830 --[Gladiator] VFX variant (Evoker, Venomous Gladiator's Chain Armor / Venomous Gladiator's Armored Scales) real: Elite=305829, Gladiator=305828, Elite=305829
	altitems[305829] = 305831 --[Elite] VFX variant (Evoker, Venomous Gladiator's Chain Armor / Venomous Gladiator's Armored Scales) real: Elite=305829, Gladiator=305828, Elite=305829
	altitems[305832] = 305834 --[Gladiator] VFX variant (Evoker, Venomous Gladiator's Chain Armor / Venomous Gladiator's Scaleguard) real: Elite=305833, Gladiator=305832, Elite=305833
	altitems[305833] = 305835 --[Elite] VFX variant (Evoker, Venomous Gladiator's Chain Armor / Venomous Gladiator's Scaleguard) real: Elite=305833, Gladiator=305832, Elite=305833
	altitems[305852] = 305854 --[Gladiator] VFX variant (Evoker, Venomous Gladiator's Chain Armor / Venomous Gladiator's Chain Helm) real: Elite=305853, Gladiator=305852, Elite=305853
	altitems[305853] = 305855 --[Elite] VFX variant (Evoker, Venomous Gladiator's Chain Armor / Venomous Gladiator's Chain Helm) real: Elite=305853, Gladiator=305852, Elite=305853
	altitems[305856] = 305858 --[Gladiator] VFX variant (Evoker, Venomous Gladiator's Chain Armor / Venomous Gladiator's Chain Faceguard) real: Elite=305857, Gladiator=305856, Elite=305857
	altitems[305857] = 305859 --[Elite] VFX variant (Evoker, Venomous Gladiator's Chain Armor / Venomous Gladiator's Chain Faceguard) real: Elite=305857, Gladiator=305856, Elite=305857
	altitems[305868] = 305870 --[Gladiator] VFX variant (Evoker, Venomous Gladiator's Chain Armor / Venomous Gladiator's Chain Monnion) real: Elite=305869, Gladiator=305868, Elite=305869
	altitems[305869] = 305871 --[Elite] VFX variant (Evoker, Venomous Gladiator's Chain Armor / Venomous Gladiator's Chain Monnion) real: Elite=305869, Gladiator=305868, Elite=305869
	altitems[305872] = 305874 --[Gladiator] VFX variant (Evoker, Venomous Gladiator's Chain Armor / Venomous Gladiator's Chain Shoulderguard) real: Elite=305873, Gladiator=305872, Elite=305873
	altitems[305873] = 305875 --[Elite] VFX variant (Evoker, Venomous Gladiator's Chain Armor / Venomous Gladiator's Chain Shoulderguard) real: Elite=305873, Gladiator=305872, Elite=305873
	altitems[305916] = 305918 --[Gladiator] VFX variant (Hunter, Venomous Gladiator's Chain Armor / Venomous Gladiator's Chain Helm) real: Elite=305917, Gladiator=305916, Elite=305917
	altitems[305917] = 305919 --[Elite] VFX variant (Hunter, Venomous Gladiator's Chain Armor / Venomous Gladiator's Chain Helm) real: Elite=305917, Gladiator=305916, Elite=305917
	altitems[305920] = 305922 --[Gladiator] VFX variant (Hunter, Venomous Gladiator's Chain Armor / Venomous Gladiator's Chain Faceguard) real: Elite=305921, Gladiator=305920, Elite=305921
	altitems[305921] = 305923 --[Elite] VFX variant (Hunter, Venomous Gladiator's Chain Armor / Venomous Gladiator's Chain Faceguard) real: Elite=305921, Gladiator=305920, Elite=305921
	altitems[305932] = 305934 --[Gladiator] VFX variant (Hunter, Venomous Gladiator's Chain Armor / Venomous Gladiator's Chain Monnion) real: Elite=305933, Gladiator=305932, Elite=305933
	altitems[305933] = 305935 --[Elite] VFX variant (Hunter, Venomous Gladiator's Chain Armor / Venomous Gladiator's Chain Monnion) real: Elite=305933, Gladiator=305932, Elite=305933
	altitems[305936] = 305938 --[Gladiator] VFX variant (Hunter, Venomous Gladiator's Chain Armor / Venomous Gladiator's Chain Shoulderguard) real: Elite=305937, Gladiator=305936, Elite=305937
	altitems[305937] = 305939 --[Elite] VFX variant (Hunter, Venomous Gladiator's Chain Armor / Venomous Gladiator's Chain Shoulderguard) real: Elite=305937, Gladiator=305936, Elite=305937
	altitems[305980] = 305982 --[Gladiator] VFX variant (Shaman, Venomous Gladiator's Chain Armor / Venomous Gladiator's Chain Helm) real: Elite=305981, Gladiator=305980, Elite=305981
	altitems[305981] = 305983 --[Elite] VFX variant (Shaman, Venomous Gladiator's Chain Armor / Venomous Gladiator's Chain Helm) real: Elite=305981, Gladiator=305980, Elite=305981
	altitems[305984] = 305986 --[Gladiator] VFX variant (Shaman, Venomous Gladiator's Chain Armor / Venomous Gladiator's Chain Faceguard) real: Elite=305985, Gladiator=305984, Elite=305985
	altitems[305985] = 305987 --[Elite] VFX variant (Shaman, Venomous Gladiator's Chain Armor / Venomous Gladiator's Chain Faceguard) real: Elite=305985, Gladiator=305984, Elite=305985
	altitems[305996] = 305998 --[Gladiator] VFX variant (Shaman, Venomous Gladiator's Chain Armor / Venomous Gladiator's Chain Monnion) real: Elite=305997, Gladiator=305996, Elite=305997
	altitems[305997] = 305999 --[Elite] VFX variant (Shaman, Venomous Gladiator's Chain Armor / Venomous Gladiator's Chain Monnion) real: Elite=305997, Gladiator=305996, Elite=305997
	altitems[306000] = 306002 --[Gladiator] VFX variant (Shaman, Venomous Gladiator's Chain Armor / Venomous Gladiator's Chain Shoulderguard) real: Elite=306001, Gladiator=306000, Elite=306001
	altitems[306001] = 306003 --[Elite] VFX variant (Shaman, Venomous Gladiator's Chain Armor / Venomous Gladiator's Chain Shoulderguard) real: Elite=306001, Gladiator=306000, Elite=306001
	altitems[306044] = 306046 --[Gladiator] VFX variant (Death Knight, Venomous Gladiator's Plate Armor / Venomous Gladiator's Plate Helm) real: Elite=306045, Elite=306045, Gladiator=306044
	altitems[306045] = 306047 --[Elite] VFX variant (Death Knight, Venomous Gladiator's Plate Armor / Venomous Gladiator's Plate Helm) real: Elite=306045, Elite=306045, Gladiator=306044
	altitems[306048] = 306050 --[Gladiator] VFX variant (Death Knight, Venomous Gladiator's Plate Armor / Venomous Gladiator's Plate Helmet) real: Elite=306049, Elite=306049, Gladiator=306048
	altitems[306049] = 306051 --[Elite] VFX variant (Death Knight, Venomous Gladiator's Plate Armor / Venomous Gladiator's Plate Helmet) real: Elite=306049, Elite=306049, Gladiator=306048
	altitems[306060] = 306062 --[Gladiator] VFX variant (Death Knight, Venomous Gladiator's Plate Armor / Venomous Gladiator's Plate Shoulders) real: Elite=306061, Elite=306061, Gladiator=306060
	altitems[306061] = 306063 --[Elite] VFX variant (Death Knight, Venomous Gladiator's Plate Armor / Venomous Gladiator's Plate Shoulders) real: Elite=306061, Elite=306061, Gladiator=306060
	altitems[306064] = 306066 --[Gladiator] VFX variant (Death Knight, Venomous Gladiator's Plate Armor / Venomous Gladiator's Plate Pauldrons) real: Elite=306065, Elite=306065, Gladiator=306064
	altitems[306065] = 306067 --[Elite] VFX variant (Death Knight, Venomous Gladiator's Plate Armor / Venomous Gladiator's Plate Pauldrons) real: Elite=306065, Elite=306065, Gladiator=306064
	altitems[306108] = 306110 --[Gladiator] VFX variant (Paladin, Venomous Gladiator's Plate Armor / Venomous Gladiator's Plate Helm) real: Elite=306109, Gladiator=306108, Elite=306109
	altitems[306109] = 306111 --[Elite] VFX variant (Paladin, Venomous Gladiator's Plate Armor / Venomous Gladiator's Plate Helm) real: Elite=306109, Gladiator=306108, Elite=306109
	altitems[306112] = 306114 --[Gladiator] VFX variant (Paladin, Venomous Gladiator's Plate Armor / Venomous Gladiator's Plate Helmet) real: Elite=306113, Gladiator=306112, Elite=306113
	altitems[306113] = 306115 --[Elite] VFX variant (Paladin, Venomous Gladiator's Plate Armor / Venomous Gladiator's Plate Helmet) real: Elite=306113, Gladiator=306112, Elite=306113
	altitems[306125] = 306127 --[Elite] VFX variant (Paladin, Venomous Gladiator's Plate Armor / Venomous Gladiator's Plate Shoulders) real: Elite=306125, Gladiator=306124, Elite=306125
	altitems[306124] = 306126 --[Gladiator] VFX variant (Paladin, Venomous Gladiator's Plate Armor / Venomous Gladiator's Plate Shoulders) real: Elite=306125, Gladiator=306124, Elite=306125
	altitems[306129] = 306131 --[Elite] VFX variant (Paladin, Venomous Gladiator's Plate Armor / Venomous Gladiator's Plate Pauldrons) real: Elite=306129, Gladiator=306128, Elite=306129
	altitems[306128] = 306130 --[Gladiator] VFX variant (Paladin, Venomous Gladiator's Plate Armor / Venomous Gladiator's Plate Pauldrons) real: Elite=306129, Gladiator=306128, Elite=306129
	altitems[306172] = 306174 --[Gladiator] VFX variant (Warrior, Venomous Gladiator's Plate Armor / Venomous Gladiator's Plate Helm) real: Elite=306173, Gladiator=306172, Elite=306173
	altitems[306173] = 306175 --[Elite] VFX variant (Warrior, Venomous Gladiator's Plate Armor / Venomous Gladiator's Plate Helm) real: Elite=306173, Gladiator=306172, Elite=306173
	altitems[306176] = 306178 --[Gladiator] VFX variant (Warrior, Venomous Gladiator's Plate Armor / Venomous Gladiator's Plate Helmet) real: Elite=306177, Gladiator=306176, Elite=306177
	altitems[306177] = 306179 --[Elite] VFX variant (Warrior, Venomous Gladiator's Plate Armor / Venomous Gladiator's Plate Helmet) real: Elite=306177, Gladiator=306176, Elite=306177
	altitems[306188] = 306190 --[Gladiator] VFX variant (Warrior, Venomous Gladiator's Plate Armor / Venomous Gladiator's Plate Shoulders) real: Elite=306189, Gladiator=306188, Elite=306189
	altitems[306189] = 306191 --[Elite] VFX variant (Warrior, Venomous Gladiator's Plate Armor / Venomous Gladiator's Plate Shoulders) real: Elite=306189, Gladiator=306188, Elite=306189
	altitems[306192] = 306194 --[Gladiator] VFX variant (Warrior, Venomous Gladiator's Plate Armor / Venomous Gladiator's Plate Pauldrons) real: Elite=306193, Gladiator=306192, Elite=306193
	altitems[306193] = 306195 --[Elite] VFX variant (Warrior, Venomous Gladiator's Plate Armor / Venomous Gladiator's Plate Pauldrons) real: Elite=306193, Gladiator=306192, Elite=306193
	altitems[306671] = 306672 --[Mythic] VFX variant (Warrior, Jade Warlord's Dominion / Raging Pauldrons of the Jade Warlord) real: Mythic=306671, Heroic=306670, Normal=306668, LFR=306669
	altitems[306670] = 306673 --[Heroic] VFX variant (Warrior, Jade Warlord's Dominion / Raging Pauldrons of the Jade Warlord) real: Mythic=306671, Heroic=306670, Normal=306668, LFR=306669
	altitems[306668] = 306674 --[Normal] VFX variant (Warrior, Jade Warlord's Dominion / Raging Pauldrons of the Jade Warlord) real: Mythic=306671, Heroic=306670, Normal=306668, LFR=306669
	altitems[306669] = 306675 --[LFR] VFX variant (Warrior, Jade Warlord's Dominion / Raging Pauldrons of the Jade Warlord) real: Mythic=306671, Heroic=306670, Normal=306668, LFR=306669
	altitems[306687] = 306688 --[Mythic] VFX variant (Warrior, Jade Warlord's Dominion / Tempered Horns of the Jade Warlord) real: Mythic=306687, Heroic=306686, Normal=306684, LFR=306685
	altitems[306686] = 306689 --[Heroic] VFX variant (Warrior, Jade Warlord's Dominion / Tempered Horns of the Jade Warlord) real: Mythic=306687, Heroic=306686, Normal=306684, LFR=306685
	altitems[306684] = 306690 --[Normal] VFX variant (Warrior, Jade Warlord's Dominion / Tempered Horns of the Jade Warlord) real: Mythic=306687, Heroic=306686, Normal=306684, LFR=306685
	altitems[306685] = 306691 --[LFR] VFX variant (Warrior, Jade Warlord's Dominion / Tempered Horns of the Jade Warlord) real: Mythic=306687, Heroic=306686, Normal=306684, LFR=306685
	altitems[306743] = 306747 --[Mythic] VFX variant (Paladin, Radiance of the Consecrated Flame / Pauldrons of the Consecrated Flame) real: Mythic=306743, Heroic=306742, Normal=306740, LFR=306741
	altitems[306742] = 306746 --[Heroic] VFX variant (Paladin, Radiance of the Consecrated Flame / Pauldrons of the Consecrated Flame) real: Mythic=306743, Heroic=306742, Normal=306740, LFR=306741
	altitems[306740] = 306745 --[Normal] VFX variant (Paladin, Radiance of the Consecrated Flame / Pauldrons of the Consecrated Flame) real: Mythic=306743, Heroic=306742, Normal=306740, LFR=306741
	altitems[306741] = 306744 --[LFR] VFX variant (Paladin, Radiance of the Consecrated Flame / Pauldrons of the Consecrated Flame) real: Mythic=306743, Heroic=306742, Normal=306740, LFR=306741
	altitems[304392] = 306747 --[Mythic] VFX variant (Paladin, Radiance of the Consecrated Flame / Swelling Sea Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[304391] = 306746 --[Heroic] VFX variant (Paladin, Radiance of the Consecrated Flame / Swelling Sea Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[304389] = 306745 --[Normal] VFX variant (Paladin, Radiance of the Consecrated Flame / Swelling Sea Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[304390] = 306744 --[LFR] VFX variant (Paladin, Radiance of the Consecrated Flame / Swelling Sea Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[306759] = 306760 --[Mythic] VFX variant (Paladin, Radiance of the Consecrated Flame / Warhelm of the Consecrated Flame) real: Mythic=306759, Heroic=306758, Normal=306756, LFR=306757
	altitems[306758] = 306761 --[Heroic] VFX variant (Paladin, Radiance of the Consecrated Flame / Warhelm of the Consecrated Flame) real: Mythic=306759, Heroic=306758, Normal=306756, LFR=306757
	altitems[306756] = 306762 --[Normal] VFX variant (Paladin, Radiance of the Consecrated Flame / Warhelm of the Consecrated Flame) real: Mythic=306759, Heroic=306758, Normal=306756, LFR=306757
	altitems[306757] = 306763 --[LFR] VFX variant (Paladin, Radiance of the Consecrated Flame / Warhelm of the Consecrated Flame) real: Mythic=306759, Heroic=306758, Normal=306756, LFR=306757
	altitems[306815] = 306816 --[Mythic] VFX variant (Death Knight, Baleful Grave-Knight's Crucible / Baleful Grave-Knight's Gibbets) real: LFR=306813, Normal=306812, Heroic=306814, Mythic=306815
	altitems[306814] = 306817 --[Heroic] VFX variant (Death Knight, Baleful Grave-Knight's Crucible / Baleful Grave-Knight's Gibbets) real: LFR=306813, Normal=306812, Heroic=306814, Mythic=306815
	altitems[306812] = 306818 --[Normal] VFX variant (Death Knight, Baleful Grave-Knight's Crucible / Baleful Grave-Knight's Gibbets) real: LFR=306813, Normal=306812, Heroic=306814, Mythic=306815
	altitems[306813] = 306819 --[LFR] VFX variant (Death Knight, Baleful Grave-Knight's Crucible / Baleful Grave-Knight's Gibbets) real: LFR=306813, Normal=306812, Heroic=306814, Mythic=306815
	altitems[306635] = 306816 --[Mythic] VFX variant (Death Knight, Baleful Grave-Knight's Crucible / Pauldrons of the Forgotten Sacrifice) sibling appearance, same alt as its DNT'd twin
	altitems[306634] = 306817 --[Heroic] VFX variant (Death Knight, Baleful Grave-Knight's Crucible / Pauldrons of the Forgotten Sacrifice) sibling appearance, same alt as its DNT'd twin
	altitems[306632] = 306818 --[Normal] VFX variant (Death Knight, Baleful Grave-Knight's Crucible / Pauldrons of the Forgotten Sacrifice) sibling appearance, same alt as its DNT'd twin
	altitems[306633] = 306819 --[LFR] VFX variant (Death Knight, Baleful Grave-Knight's Crucible / Pauldrons of the Forgotten Sacrifice) sibling appearance, same alt as its DNT'd twin
	altitems[306831] = 306832 --[Mythic] VFX variant (Death Knight, Baleful Grave-Knight's Crucible / Baleful Grave-Knight's Casque) real: LFR=306829, Normal=306828, Heroic=306830, Mythic=306831
	altitems[306830] = 306833 --[Heroic] VFX variant (Death Knight, Baleful Grave-Knight's Crucible / Baleful Grave-Knight's Casque) real: LFR=306829, Normal=306828, Heroic=306830, Mythic=306831
	altitems[306828] = 306834 --[Normal] VFX variant (Death Knight, Baleful Grave-Knight's Crucible / Baleful Grave-Knight's Casque) real: LFR=306829, Normal=306828, Heroic=306830, Mythic=306831
	altitems[306829] = 306835 --[LFR] VFX variant (Death Knight, Baleful Grave-Knight's Crucible / Baleful Grave-Knight's Casque) real: LFR=306829, Normal=306828, Heroic=306830, Mythic=306831
	altitems[304404] = 306832 --[Mythic] VFX variant (Death Knight, Baleful Grave-Knight's Crucible / Skullguard of the Risen Sacrifice) sibling appearance, same alt as its DNT'd twin
	altitems[304403] = 306833 --[Heroic] VFX variant (Death Knight, Baleful Grave-Knight's Crucible / Skullguard of the Risen Sacrifice) sibling appearance, same alt as its DNT'd twin
	altitems[304401] = 306834 --[Normal] VFX variant (Death Knight, Baleful Grave-Knight's Crucible / Skullguard of the Risen Sacrifice) sibling appearance, same alt as its DNT'd twin
	altitems[304402] = 306835 --[LFR] VFX variant (Death Knight, Baleful Grave-Knight's Crucible / Skullguard of the Risen Sacrifice) sibling appearance, same alt as its DNT'd twin
	altitems[306887] = 306888 --[Mythic] VFX variant (Shaman, Ophidian Oracle's Prophecy / Hissing Mantle of the Ophidian Oracle) real: Mythic=306887, Heroic=306886, Normal=306884, LFR=306885
	altitems[306886] = 306889 --[Heroic] VFX variant (Shaman, Ophidian Oracle's Prophecy / Hissing Mantle of the Ophidian Oracle) real: Mythic=306887, Heroic=306886, Normal=306884, LFR=306885
	altitems[306884] = 306890 --[Normal] VFX variant (Shaman, Ophidian Oracle's Prophecy / Hissing Mantle of the Ophidian Oracle) real: Mythic=306887, Heroic=306886, Normal=306884, LFR=306885
	altitems[306885] = 306891 --[LFR] VFX variant (Shaman, Ophidian Oracle's Prophecy / Hissing Mantle of the Ophidian Oracle) real: Mythic=306887, Heroic=306886, Normal=306884, LFR=306885
	altitems[304412] = 306888 --[Mythic] VFX variant (Shaman, Ophidian Oracle's Prophecy / Soulslither Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[304411] = 306889 --[Heroic] VFX variant (Shaman, Ophidian Oracle's Prophecy / Soulslither Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[304409] = 306890 --[Normal] VFX variant (Shaman, Ophidian Oracle's Prophecy / Soulslither Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[304410] = 306891 --[LFR] VFX variant (Shaman, Ophidian Oracle's Prophecy / Soulslither Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[306903] = 306904 --[Mythic] VFX variant (Shaman, Ophidian Oracle's Prophecy / Serpent Crown of the Ophidian Oracle) real: Mythic=306903, Heroic=306902, Normal=306900, LFR=306901
	altitems[306902] = 306905 --[Heroic] VFX variant (Shaman, Ophidian Oracle's Prophecy / Serpent Crown of the Ophidian Oracle) real: Mythic=306903, Heroic=306902, Normal=306900, LFR=306901
	altitems[306900] = 306906 --[Normal] VFX variant (Shaman, Ophidian Oracle's Prophecy / Serpent Crown of the Ophidian Oracle) real: Mythic=306903, Heroic=306902, Normal=306900, LFR=306901
	altitems[306901] = 306907 --[LFR] VFX variant (Shaman, Ophidian Oracle's Prophecy / Serpent Crown of the Ophidian Oracle) real: Mythic=306903, Heroic=306902, Normal=306900, LFR=306901
	altitems[304408] = 306904 --[Mythic] VFX variant (Shaman, Ophidian Oracle's Prophecy / Crown of the Eternal Fang) sibling appearance, same alt as its DNT'd twin
	altitems[304407] = 306905 --[Heroic] VFX variant (Shaman, Ophidian Oracle's Prophecy / Crown of the Eternal Fang) sibling appearance, same alt as its DNT'd twin
	altitems[304405] = 306906 --[Normal] VFX variant (Shaman, Ophidian Oracle's Prophecy / Crown of the Eternal Fang) sibling appearance, same alt as its DNT'd twin
	altitems[304406] = 306907 --[LFR] VFX variant (Shaman, Ophidian Oracle's Prophecy / Crown of the Eternal Fang) sibling appearance, same alt as its DNT'd twin
	altitems[306959] = 306960 --[Mythic] VFX variant (Hunter, Skulking Viper's Ambush / Jaws of the Skulking Viper) real: Mythic=306959, Heroic=306958, Normal=306956, LFR=306957
	altitems[306958] = 306961 --[Heroic] VFX variant (Hunter, Skulking Viper's Ambush / Jaws of the Skulking Viper) real: Mythic=306959, Heroic=306958, Normal=306956, LFR=306957
	altitems[306956] = 306962 --[Normal] VFX variant (Hunter, Skulking Viper's Ambush / Jaws of the Skulking Viper) real: Mythic=306959, Heroic=306958, Normal=306956, LFR=306957
	altitems[306957] = 306963 --[LFR] VFX variant (Hunter, Skulking Viper's Ambush / Jaws of the Skulking Viper) real: Mythic=306959, Heroic=306958, Normal=306956, LFR=306957
	altitems[306975] = 306976 --[Mythic] VFX variant (Hunter, Skulking Viper's Ambush / Skulking Viper's Weeping Fangs) real: Mythic=306975, Heroic=306974, Normal=306972, LFR=306973
	altitems[306974] = 306977 --[Heroic] VFX variant (Hunter, Skulking Viper's Ambush / Skulking Viper's Weeping Fangs) real: Mythic=306975, Heroic=306974, Normal=306972, LFR=306973
	altitems[306972] = 306978 --[Normal] VFX variant (Hunter, Skulking Viper's Ambush / Skulking Viper's Weeping Fangs) real: Mythic=306975, Heroic=306974, Normal=306972, LFR=306973
	altitems[306973] = 306979 --[LFR] VFX variant (Hunter, Skulking Viper's Ambush / Skulking Viper's Weeping Fangs) real: Mythic=306975, Heroic=306974, Normal=306972, LFR=306973
	altitems[306629] = 306976 --[Mythic] VFX variant (Hunter, Skulking Viper's Ambush / Crushing Coiler Coif) sibling appearance, same alt as its DNT'd twin
	altitems[306628] = 306977 --[Heroic] VFX variant (Hunter, Skulking Viper's Ambush / Crushing Coiler Coif) sibling appearance, same alt as its DNT'd twin
	altitems[306626] = 306978 --[Normal] VFX variant (Hunter, Skulking Viper's Ambush / Crushing Coiler Coif) sibling appearance, same alt as its DNT'd twin
	altitems[306627] = 306979 --[LFR] VFX variant (Hunter, Skulking Viper's Ambush / Crushing Coiler Coif) sibling appearance, same alt as its DNT'd twin
	altitems[307031] = 307032 --[Mythic] VFX variant (Evoker, Echo of Calamity / Calamitous Echo's Sundered Peaks) real: Mythic=307031, Heroic=307030, Normal=307028, LFR=307029
	altitems[307030] = 307033 --[Heroic] VFX variant (Evoker, Echo of Calamity / Calamitous Echo's Sundered Peaks) real: Mythic=307031, Heroic=307030, Normal=307028, LFR=307029
	altitems[307028] = 307034 --[Normal] VFX variant (Evoker, Echo of Calamity / Calamitous Echo's Sundered Peaks) real: Mythic=307031, Heroic=307030, Normal=307028, LFR=307029
	altitems[307029] = 307035 --[LFR] VFX variant (Evoker, Echo of Calamity / Calamitous Echo's Sundered Peaks) real: Mythic=307031, Heroic=307030, Normal=307028, LFR=307029
	altitems[307047] = 307048 --[Mythic] VFX variant (Evoker, Echo of Calamity / Calamitous Echo's Magmashapers) real: Mythic=307047, Heroic=307046, Normal=307044, LFR=307045
	altitems[307046] = 307049 --[Heroic] VFX variant (Evoker, Echo of Calamity / Calamitous Echo's Magmashapers) real: Mythic=307047, Heroic=307046, Normal=307044, LFR=307045
	altitems[307044] = 307050 --[Normal] VFX variant (Evoker, Echo of Calamity / Calamitous Echo's Magmashapers) real: Mythic=307047, Heroic=307046, Normal=307044, LFR=307045
	altitems[307045] = 307051 --[LFR] VFX variant (Evoker, Echo of Calamity / Calamitous Echo's Magmashapers) real: Mythic=307047, Heroic=307046, Normal=307044, LFR=307045
	altitems[307071] = 307072 --[Mythic] VFX variant (Evoker, Echo of Calamity / Searing Caldera of Calamity) real: Mythic=307071, Heroic=307070, Normal=307068, LFR=307069
	altitems[307070] = 307073 --[Heroic] VFX variant (Evoker, Echo of Calamity / Searing Caldera of Calamity) real: Mythic=307071, Heroic=307070, Normal=307068, LFR=307069
	altitems[307068] = 307074 --[Normal] VFX variant (Evoker, Echo of Calamity / Searing Caldera of Calamity) real: Mythic=307071, Heroic=307070, Normal=307068, LFR=307069
	altitems[307069] = 307075 --[LFR] VFX variant (Evoker, Echo of Calamity / Searing Caldera of Calamity) real: Mythic=307071, Heroic=307070, Normal=307068, LFR=307069
	altitems[307735] = 307072 --[Mythic] VFX variant (Evoker, Echo of Calamity / Awoken Dreadfang Cuirass) sibling appearance, same alt as its DNT'd twin
	altitems[307734] = 307073 --[Heroic] VFX variant (Evoker, Echo of Calamity / Awoken Dreadfang Cuirass) sibling appearance, same alt as its DNT'd twin
	altitems[307732] = 307074 --[Normal] VFX variant (Evoker, Echo of Calamity / Awoken Dreadfang Cuirass) sibling appearance, same alt as its DNT'd twin
	altitems[307733] = 307075 --[LFR] VFX variant (Evoker, Echo of Calamity / Awoken Dreadfang Cuirass) sibling appearance, same alt as its DNT'd twin
	altitems[307095] = 307096 --[Mythic] VFX variant (Rogue, Chosen Bloodslayer's Hexweave / Chosen Bloodslayer's Trophy Belt) real: Mythic=307095, Heroic=307094, Normal=307092, LFR=307093
	altitems[307094] = 307097 --[Heroic] VFX variant (Rogue, Chosen Bloodslayer's Hexweave / Chosen Bloodslayer's Trophy Belt) real: Mythic=307095, Heroic=307094, Normal=307092, LFR=307093
	altitems[307092] = 307098 --[Normal] VFX variant (Rogue, Chosen Bloodslayer's Hexweave / Chosen Bloodslayer's Trophy Belt) real: Mythic=307095, Heroic=307094, Normal=307092, LFR=307093
	altitems[307093] = 307099 --[LFR] VFX variant (Rogue, Chosen Bloodslayer's Hexweave / Chosen Bloodslayer's Trophy Belt) real: Mythic=307095, Heroic=307094, Normal=307092, LFR=307093
	altitems[304396] = 307096 --[Mythic] VFX variant (Rogue, Chosen Bloodslayer's Hexweave / Unpossessed Skullsash) sibling appearance, same alt as its DNT'd twin
	altitems[304395] = 307097 --[Heroic] VFX variant (Rogue, Chosen Bloodslayer's Hexweave / Unpossessed Skullsash) sibling appearance, same alt as its DNT'd twin
	altitems[304393] = 307098 --[Normal] VFX variant (Rogue, Chosen Bloodslayer's Hexweave / Unpossessed Skullsash) sibling appearance, same alt as its DNT'd twin
	altitems[304394] = 307099 --[LFR] VFX variant (Rogue, Chosen Bloodslayer's Hexweave / Unpossessed Skullsash) sibling appearance, same alt as its DNT'd twin
	altitems[307103] = 307104 --[Mythic] VFX variant (Rogue, Chosen Bloodslayer's Hexweave / Chosen Bloodslayer's Voodoo Guards) real: Mythic=307103, Heroic=307102, Normal=307100, LFR=307101
	altitems[307102] = 307105 --[Heroic] VFX variant (Rogue, Chosen Bloodslayer's Hexweave / Chosen Bloodslayer's Voodoo Guards) real: Mythic=307103, Heroic=307102, Normal=307100, LFR=307101
	altitems[307100] = 307106 --[Normal] VFX variant (Rogue, Chosen Bloodslayer's Hexweave / Chosen Bloodslayer's Voodoo Guards) real: Mythic=307103, Heroic=307102, Normal=307100, LFR=307101
	altitems[307101] = 307107 --[LFR] VFX variant (Rogue, Chosen Bloodslayer's Hexweave / Chosen Bloodslayer's Voodoo Guards) real: Mythic=307103, Heroic=307102, Normal=307100, LFR=307101
	altitems[307119] = 307120 --[Mythic] VFX variant (Rogue, Chosen Bloodslayer's Hexweave / Chosen Bloodslayer's Spirit Shroud) real: Mythic=307119, Heroic=307118, Normal=307116, LFR=307117
	altitems[307118] = 307121 --[Heroic] VFX variant (Rogue, Chosen Bloodslayer's Hexweave / Chosen Bloodslayer's Spirit Shroud) real: Mythic=307119, Heroic=307118, Normal=307116, LFR=307117
	altitems[307116] = 307122 --[Normal] VFX variant (Rogue, Chosen Bloodslayer's Hexweave / Chosen Bloodslayer's Spirit Shroud) real: Mythic=307119, Heroic=307118, Normal=307116, LFR=307117
	altitems[307117] = 307123 --[LFR] VFX variant (Rogue, Chosen Bloodslayer's Hexweave / Chosen Bloodslayer's Spirit Shroud) real: Mythic=307119, Heroic=307118, Normal=307116, LFR=307117
	altitems[304364] = 307120 --[Mythic] VFX variant (Rogue, Chosen Bloodslayer's Hexweave / Shadow Hunter's Warmask) sibling appearance, same alt as its DNT'd twin
	altitems[304363] = 307121 --[Heroic] VFX variant (Rogue, Chosen Bloodslayer's Hexweave / Shadow Hunter's Warmask) sibling appearance, same alt as its DNT'd twin
	altitems[304361] = 307122 --[Normal] VFX variant (Rogue, Chosen Bloodslayer's Hexweave / Shadow Hunter's Warmask) sibling appearance, same alt as its DNT'd twin
	altitems[304362] = 307123 --[LFR] VFX variant (Rogue, Chosen Bloodslayer's Hexweave / Shadow Hunter's Warmask) sibling appearance, same alt as its DNT'd twin
	altitems[307127] = 307128 --[Mythic] VFX variant (Rogue, Chosen Bloodslayer's Hexweave / Chosen Bloodslayer's Fanged Grips) real: Mythic=307127, Heroic=307126, Normal=307124, LFR=307125
	altitems[307126] = 307129 --[Heroic] VFX variant (Rogue, Chosen Bloodslayer's Hexweave / Chosen Bloodslayer's Fanged Grips) real: Mythic=307127, Heroic=307126, Normal=307124, LFR=307125
	altitems[307124] = 307130 --[Normal] VFX variant (Rogue, Chosen Bloodslayer's Hexweave / Chosen Bloodslayer's Fanged Grips) real: Mythic=307127, Heroic=307126, Normal=307124, LFR=307125
	altitems[307125] = 307131 --[LFR] VFX variant (Rogue, Chosen Bloodslayer's Hexweave / Chosen Bloodslayer's Fanged Grips) real: Mythic=307127, Heroic=307126, Normal=307124, LFR=307125
	altitems[307175] = 307176 --[Mythic] VFX variant (Monk, Guile of the Monkey King / Tassels of the Monkey King) real: Mythic=307175, Heroic=307174, Normal=307172, LFR=307173
	altitems[307174] = 307177 --[Heroic] VFX variant (Monk, Guile of the Monkey King / Tassels of the Monkey King) real: Mythic=307175, Heroic=307174, Normal=307172, LFR=307173
	altitems[307172] = 307178 --[Normal] VFX variant (Monk, Guile of the Monkey King / Tassels of the Monkey King) real: Mythic=307175, Heroic=307174, Normal=307172, LFR=307173
	altitems[307173] = 307179 --[LFR] VFX variant (Monk, Guile of the Monkey King / Tassels of the Monkey King) real: Mythic=307175, Heroic=307174, Normal=307172, LFR=307173
	altitems[307191] = 307192 --[Mythic] VFX variant (Monk, Guile of the Monkey King / Monkey King's Unyielding Visage) real: Mythic=307191, Heroic=307190, Normal=307188, LFR=307189
	altitems[307190] = 307193 --[Heroic] VFX variant (Monk, Guile of the Monkey King / Monkey King's Unyielding Visage) real: Mythic=307191, Heroic=307190, Normal=307188, LFR=307189
	altitems[307188] = 307194 --[Normal] VFX variant (Monk, Guile of the Monkey King / Monkey King's Unyielding Visage) real: Mythic=307191, Heroic=307190, Normal=307188, LFR=307189
	altitems[307189] = 307195 --[LFR] VFX variant (Monk, Guile of the Monkey King / Monkey King's Unyielding Visage) real: Mythic=307191, Heroic=307190, Normal=307188, LFR=307189
	altitems[306620] = 307192 --[Mythic] VFX variant (Monk, Guile of the Monkey King / Temple Delver's Mystic Helm) sibling appearance, same alt as its DNT'd twin
	altitems[306619] = 307193 --[Heroic] VFX variant (Monk, Guile of the Monkey King / Temple Delver's Mystic Helm) sibling appearance, same alt as its DNT'd twin
	altitems[306617] = 307194 --[Normal] VFX variant (Monk, Guile of the Monkey King / Temple Delver's Mystic Helm) sibling appearance, same alt as its DNT'd twin
	altitems[306618] = 307195 --[LFR] VFX variant (Monk, Guile of the Monkey King / Temple Delver's Mystic Helm) sibling appearance, same alt as its DNT'd twin
	altitems[307247] = 307248 --[Mythic] VFX variant (Druid, Bark of the Enigmatic Dreamwatcher / Enigmatic Dreamwatcher's Plumage) real: Mythic=307247, Heroic=307246, Normal=307244, LFR=307245
	altitems[307246] = 307249 --[Heroic] VFX variant (Druid, Bark of the Enigmatic Dreamwatcher / Enigmatic Dreamwatcher's Plumage) real: Mythic=307247, Heroic=307246, Normal=307244, LFR=307245
	altitems[307244] = 307250 --[Normal] VFX variant (Druid, Bark of the Enigmatic Dreamwatcher / Enigmatic Dreamwatcher's Plumage) real: Mythic=307247, Heroic=307246, Normal=307244, LFR=307245
	altitems[307245] = 307251 --[LFR] VFX variant (Druid, Bark of the Enigmatic Dreamwatcher / Enigmatic Dreamwatcher's Plumage) real: Mythic=307247, Heroic=307246, Normal=307244, LFR=307245
	altitems[307263] = 307264 --[Mythic] VFX variant (Druid, Bark of the Enigmatic Dreamwatcher / Enigmatic Dreamwatcher's Somnolent Stare) real: Mythic=307263, Heroic=307262, Normal=307260, LFR=307261
	altitems[307262] = 307265 --[Heroic] VFX variant (Druid, Bark of the Enigmatic Dreamwatcher / Enigmatic Dreamwatcher's Somnolent Stare) real: Mythic=307263, Heroic=307262, Normal=307260, LFR=307261
	altitems[307260] = 307266 --[Normal] VFX variant (Druid, Bark of the Enigmatic Dreamwatcher / Enigmatic Dreamwatcher's Somnolent Stare) real: Mythic=307263, Heroic=307262, Normal=307260, LFR=307261
	altitems[307261] = 307267 --[LFR] VFX variant (Druid, Bark of the Enigmatic Dreamwatcher / Enigmatic Dreamwatcher's Somnolent Stare) real: Mythic=307263, Heroic=307262, Normal=307260, LFR=307261
	altitems[307731] = 307264 --[Mythic] VFX variant (Druid, Bark of the Enigmatic Dreamwatcher / Gaze of the Coiled Watcher) sibling appearance, same alt as its DNT'd twin
	altitems[307730] = 307265 --[Heroic] VFX variant (Druid, Bark of the Enigmatic Dreamwatcher / Gaze of the Coiled Watcher) sibling appearance, same alt as its DNT'd twin
	altitems[307728] = 307266 --[Normal] VFX variant (Druid, Bark of the Enigmatic Dreamwatcher / Gaze of the Coiled Watcher) sibling appearance, same alt as its DNT'd twin
	altitems[307729] = 307267 --[LFR] VFX variant (Druid, Bark of the Enigmatic Dreamwatcher / Gaze of the Coiled Watcher) sibling appearance, same alt as its DNT'd twin
	altitems[307311] = 307312 --[Mythic] VFX variant (Demon Hunter, Abyssal Doomhound's Pursuit / Abyssal Doomhound's Jeweled Cinch) real: Mythic=307311, Heroic=307310, Normal=307308, LFR=307309
	altitems[307310] = 307313 --[Heroic] VFX variant (Demon Hunter, Abyssal Doomhound's Pursuit / Abyssal Doomhound's Jeweled Cinch) real: Mythic=307311, Heroic=307310, Normal=307308, LFR=307309
	altitems[307308] = 307314 --[Normal] VFX variant (Demon Hunter, Abyssal Doomhound's Pursuit / Abyssal Doomhound's Jeweled Cinch) real: Mythic=307311, Heroic=307310, Normal=307308, LFR=307309
	altitems[307309] = 307315 --[LFR] VFX variant (Demon Hunter, Abyssal Doomhound's Pursuit / Abyssal Doomhound's Jeweled Cinch) real: Mythic=307311, Heroic=307310, Normal=307308, LFR=307309
	altitems[306615] = 307312 --[Mythic] VFX variant (Demon Hunter, Abyssal Doomhound's Pursuit / Slitherscale Girdle) sibling appearance, same alt as its DNT'd twin
	altitems[306614] = 307313 --[Heroic] VFX variant (Demon Hunter, Abyssal Doomhound's Pursuit / Slitherscale Girdle) sibling appearance, same alt as its DNT'd twin
	altitems[306612] = 307314 --[Normal] VFX variant (Demon Hunter, Abyssal Doomhound's Pursuit / Slitherscale Girdle) sibling appearance, same alt as its DNT'd twin
	altitems[306613] = 307315 --[LFR] VFX variant (Demon Hunter, Abyssal Doomhound's Pursuit / Slitherscale Girdle) sibling appearance, same alt as its DNT'd twin
	altitems[307319] = 307320 --[Mythic] VFX variant (Demon Hunter, Abyssal Doomhound's Pursuit / Abyssal Doomhound's Jaws) real: Mythic=307319, Heroic=307318, Normal=307316, LFR=307317
	altitems[307318] = 307321 --[Heroic] VFX variant (Demon Hunter, Abyssal Doomhound's Pursuit / Abyssal Doomhound's Jaws) real: Mythic=307319, Heroic=307318, Normal=307316, LFR=307317
	altitems[307316] = 307322 --[Normal] VFX variant (Demon Hunter, Abyssal Doomhound's Pursuit / Abyssal Doomhound's Jaws) real: Mythic=307319, Heroic=307318, Normal=307316, LFR=307317
	altitems[307317] = 307323 --[LFR] VFX variant (Demon Hunter, Abyssal Doomhound's Pursuit / Abyssal Doomhound's Jaws) real: Mythic=307319, Heroic=307318, Normal=307316, LFR=307317
	altitems[304472] = 307320 --[Mythic] VFX variant (Demon Hunter, Abyssal Doomhound's Pursuit / Frothing Venom Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[304471] = 307321 --[Heroic] VFX variant (Demon Hunter, Abyssal Doomhound's Pursuit / Frothing Venom Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[304469] = 307322 --[Normal] VFX variant (Demon Hunter, Abyssal Doomhound's Pursuit / Frothing Venom Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[304470] = 307323 --[LFR] VFX variant (Demon Hunter, Abyssal Doomhound's Pursuit / Frothing Venom Spaulders) sibling appearance, same alt as its DNT'd twin
	altitems[307351] = 307352 --[Mythic] VFX variant (Demon Hunter, Abyssal Doomhound's Pursuit / Abyssal Doomhound's Footpads) real: Mythic=307351, Heroic=307350, Normal=307348, LFR=307349
	altitems[307350] = 307353 --[Heroic] VFX variant (Demon Hunter, Abyssal Doomhound's Pursuit / Abyssal Doomhound's Footpads) real: Mythic=307351, Heroic=307350, Normal=307348, LFR=307349
	altitems[307348] = 307354 --[Normal] VFX variant (Demon Hunter, Abyssal Doomhound's Pursuit / Abyssal Doomhound's Footpads) real: Mythic=307351, Heroic=307350, Normal=307348, LFR=307349
	altitems[307349] = 307355 --[LFR] VFX variant (Demon Hunter, Abyssal Doomhound's Pursuit / Abyssal Doomhound's Footpads) real: Mythic=307351, Heroic=307350, Normal=307348, LFR=307349
	altitems[304476] = 307352 --[Mythic] VFX variant (Demon Hunter, Abyssal Doomhound's Pursuit / Breakwater Boots) sibling appearance, same alt as its DNT'd twin
	altitems[304475] = 307353 --[Heroic] VFX variant (Demon Hunter, Abyssal Doomhound's Pursuit / Breakwater Boots) sibling appearance, same alt as its DNT'd twin
	altitems[304473] = 307354 --[Normal] VFX variant (Demon Hunter, Abyssal Doomhound's Pursuit / Breakwater Boots) sibling appearance, same alt as its DNT'd twin
	altitems[304474] = 307355 --[LFR] VFX variant (Demon Hunter, Abyssal Doomhound's Pursuit / Breakwater Boots) sibling appearance, same alt as its DNT'd twin
	altitems[307391] = 307392 --[Mythic] VFX variant (Warlock, Damned Necrolyte's Shattered Restraints / Spires of the Damned Necrolyte) real: Mythic=307391, Heroic=307390, Normal=307388, LFR=307389
	altitems[307390] = 307393 --[Heroic] VFX variant (Warlock, Damned Necrolyte's Shattered Restraints / Spires of the Damned Necrolyte) real: Mythic=307391, Heroic=307390, Normal=307388, LFR=307389
	altitems[307388] = 307394 --[Normal] VFX variant (Warlock, Damned Necrolyte's Shattered Restraints / Spires of the Damned Necrolyte) real: Mythic=307391, Heroic=307390, Normal=307388, LFR=307389
	altitems[307389] = 307395 --[LFR] VFX variant (Warlock, Damned Necrolyte's Shattered Restraints / Spires of the Damned Necrolyte) real: Mythic=307391, Heroic=307390, Normal=307388, LFR=307389
	altitems[307407] = 307408 --[Mythic] VFX variant (Warlock, Damned Necrolyte's Shattered Restraints / Skull of the Damned Necrolyte) real: Mythic=307407, Heroic=307406, Normal=307404, LFR=307405
	altitems[307406] = 307409 --[Heroic] VFX variant (Warlock, Damned Necrolyte's Shattered Restraints / Skull of the Damned Necrolyte) real: Mythic=307407, Heroic=307406, Normal=307404, LFR=307405
	altitems[307404] = 307410 --[Normal] VFX variant (Warlock, Damned Necrolyte's Shattered Restraints / Skull of the Damned Necrolyte) real: Mythic=307407, Heroic=307406, Normal=307404, LFR=307405
	altitems[307405] = 307411 --[LFR] VFX variant (Warlock, Damned Necrolyte's Shattered Restraints / Skull of the Damned Necrolyte) real: Mythic=307407, Heroic=307406, Normal=307404, LFR=307405
	altitems[307727] = 307408 --[Mythic] VFX variant (Warlock, Damned Necrolyte's Shattered Restraints / Venomkeeper's Horrific Cowl) sibling appearance, same alt as its DNT'd twin
	altitems[307726] = 307409 --[Heroic] VFX variant (Warlock, Damned Necrolyte's Shattered Restraints / Venomkeeper's Horrific Cowl) sibling appearance, same alt as its DNT'd twin
	altitems[307724] = 307410 --[Normal] VFX variant (Warlock, Damned Necrolyte's Shattered Restraints / Venomkeeper's Horrific Cowl) sibling appearance, same alt as its DNT'd twin
	altitems[307725] = 307411 --[LFR] VFX variant (Warlock, Damned Necrolyte's Shattered Restraints / Venomkeeper's Horrific Cowl) sibling appearance, same alt as its DNT'd twin
	altitems[307463] = 307467 --[Mythic] VFX variant (Priest, Cosmic Penitent's Raiment / Cosmic Penitent's Echoing Screams) real: Mythic=307463, Heroic=307462, Normal=307460, LFR=307461
	altitems[307462] = 307466 --[Heroic] VFX variant (Priest, Cosmic Penitent's Raiment / Cosmic Penitent's Echoing Screams) real: Mythic=307463, Heroic=307462, Normal=307460, LFR=307461
	altitems[307460] = 307465 --[Normal] VFX variant (Priest, Cosmic Penitent's Raiment / Cosmic Penitent's Echoing Screams) real: Mythic=307463, Heroic=307462, Normal=307460, LFR=307461
	altitems[307461] = 307464 --[LFR] VFX variant (Priest, Cosmic Penitent's Raiment / Cosmic Penitent's Echoing Screams) real: Mythic=307463, Heroic=307462, Normal=307460, LFR=307461
	altitems[306607] = 307467 --[Mythic] VFX variant (Priest, Cosmic Penitent's Raiment / Venom Rite Mantle) sibling appearance, same alt as its DNT'd twin
	altitems[306606] = 307466 --[Heroic] VFX variant (Priest, Cosmic Penitent's Raiment / Venom Rite Mantle) sibling appearance, same alt as its DNT'd twin
	altitems[306604] = 307465 --[Normal] VFX variant (Priest, Cosmic Penitent's Raiment / Venom Rite Mantle) sibling appearance, same alt as its DNT'd twin
	altitems[306605] = 307464 --[LFR] VFX variant (Priest, Cosmic Penitent's Raiment / Venom Rite Mantle) sibling appearance, same alt as its DNT'd twin
	altitems[307479] = 307483 --[Mythic] VFX variant (Priest, Cosmic Penitent's Raiment / Cosmic Penitent's Truesight) real: Mythic=307479, Heroic=307478, Normal=307476, LFR=307477
	altitems[307478] = 307482 --[Heroic] VFX variant (Priest, Cosmic Penitent's Raiment / Cosmic Penitent's Truesight) real: Mythic=307479, Heroic=307478, Normal=307476, LFR=307477
	altitems[307476] = 307481 --[Normal] VFX variant (Priest, Cosmic Penitent's Raiment / Cosmic Penitent's Truesight) real: Mythic=307479, Heroic=307478, Normal=307476, LFR=307477
	altitems[307477] = 307480 --[LFR] VFX variant (Priest, Cosmic Penitent's Raiment / Cosmic Penitent's Truesight) real: Mythic=307479, Heroic=307478, Normal=307476, LFR=307477
	altitems[304456] = 307483 --[Mythic] VFX variant (Priest, Cosmic Penitent's Raiment / Errant Scrollsage's Hood) sibling appearance, same alt as its DNT'd twin
	altitems[304455] = 307482 --[Heroic] VFX variant (Priest, Cosmic Penitent's Raiment / Errant Scrollsage's Hood) sibling appearance, same alt as its DNT'd twin
	altitems[304453] = 307481 --[Normal] VFX variant (Priest, Cosmic Penitent's Raiment / Errant Scrollsage's Hood) sibling appearance, same alt as its DNT'd twin
	altitems[304454] = 307480 --[LFR] VFX variant (Priest, Cosmic Penitent's Raiment / Errant Scrollsage's Hood) sibling appearance, same alt as its DNT'd twin
	altitems[307535] = 307536 --[Mythic] VFX variant (Mage, Primal Leywarden's Attire / Primal Leywarden's Manaflux) real: Mythic=307535, Heroic=307534, Normal=307532, LFR=307533
	altitems[307534] = 307537 --[Heroic] VFX variant (Mage, Primal Leywarden's Attire / Primal Leywarden's Manaflux) real: Mythic=307535, Heroic=307534, Normal=307532, LFR=307533
	altitems[307532] = 307538 --[Normal] VFX variant (Mage, Primal Leywarden's Attire / Primal Leywarden's Manaflux) real: Mythic=307535, Heroic=307534, Normal=307532, LFR=307533
	altitems[307533] = 307539 --[LFR] VFX variant (Mage, Primal Leywarden's Attire / Primal Leywarden's Manaflux) real: Mythic=307535, Heroic=307534, Normal=307532, LFR=307533
	altitems[304452] = 307536 --[Mythic] VFX variant (Mage, Primal Leywarden's Attire / Ornaments of the Eternal Coil) sibling appearance, same alt as its DNT'd twin
	altitems[304451] = 307537 --[Heroic] VFX variant (Mage, Primal Leywarden's Attire / Ornaments of the Eternal Coil) sibling appearance, same alt as its DNT'd twin
	altitems[304449] = 307538 --[Normal] VFX variant (Mage, Primal Leywarden's Attire / Ornaments of the Eternal Coil) sibling appearance, same alt as its DNT'd twin
	altitems[304450] = 307539 --[LFR] VFX variant (Mage, Primal Leywarden's Attire / Ornaments of the Eternal Coil) sibling appearance, same alt as its DNT'd twin
	altitems[307551] = 307552 --[Mythic] VFX variant (Mage, Primal Leywarden's Attire / Crown of the Primal Leywarden) real: Mythic=307551, Heroic=307550, Normal=307548, LFR=307549
	altitems[307550] = 307553 --[Heroic] VFX variant (Mage, Primal Leywarden's Attire / Crown of the Primal Leywarden) real: Mythic=307551, Heroic=307550, Normal=307548, LFR=307549
	altitems[307548] = 307554 --[Normal] VFX variant (Mage, Primal Leywarden's Attire / Crown of the Primal Leywarden) real: Mythic=307551, Heroic=307550, Normal=307548, LFR=307549
	altitems[307549] = 307555 --[LFR] VFX variant (Mage, Primal Leywarden's Attire / Crown of the Primal Leywarden) real: Mythic=307551, Heroic=307550, Normal=307548, LFR=307549
