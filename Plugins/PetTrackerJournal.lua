local addonName, addon = ...
--addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

function addon:UpdatePetTracker()
end

if not C_AddOns.IsAddOnLoaded("PetTracker") then return end

--Fixes frame issues when PetTracker is being used
function addon:UpdatePetTracker()
	if not PetTrackerRivalsJournalList then  return end
	PetTrackerRivalsJournalList:HookScript("OnShow",  function() BetterWardrobeCollectionFrame:Hide() end)
	PetTrackerRivalsJournalList:HookScript("OnHide",  function() 
		if 	WardrobeCollectionFrame:IsShown() then
			BetterWardrobeCollectionFrame:Show()
		end
 	end)
end