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