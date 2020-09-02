-- C_TransmogCollection.GetItemInfo(itemID, [itemModID]/itemLink/itemName) = appearanceID, sourceID
-- C_TransmogCollection.GetAllAppearanceSources(appearanceID) = { sourceID } This is cross-class, but no guarantee a source is actually attainable
-- C_TransmogCollection.GetSourceInfo(sourceID) = { data }
-- 15th return of GetItemInfo is expansionID
-- new events: TRANSMOG_COLLECTION_SOURCE_ADDED and TRANSMOG_COLLECTION_SOURCE_REMOVED, parameter is sourceID, can be cross-class (wand unlocked from ensemble while on warrior)
local addonName, addon = ...
--addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
