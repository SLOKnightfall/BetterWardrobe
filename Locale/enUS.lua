local AddOnFolderName, private = ...

-- See http://wow.curseforge.com/addons/ion-status-bars/localization/
local L = _G.LibStub("AceLocale-3.0"):NewLocale("BetterWardrobe", "enUS", true)

if not L then return end
--@localization(locale="enUS", format="lua_additive_table", handle-unlocalized="comment")@
 local commandColor = "FFFFC654";