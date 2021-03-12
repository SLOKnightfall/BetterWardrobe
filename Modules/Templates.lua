local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)


BW_SetIconMixin = {}

function BW_SetIconMixin:OnEnter()
	if self.Icon:IsVisible() then 
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(L["Contains Unavailable Items"])
		GameTooltip:Show()
	end
end
