local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)


BW_SetIconMixin = {}

function BW_SetIconMixin:OnEnter()
	if self.Icon:IsVisible() then 
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		if self:GetID() == 1 then
			GameTooltip:SetText(L["No Longer Obtainable"])
		elseif self:GetID() == 2 then
			GameTooltip:SetText(L["Contains Unavailable Items"])
		end
		GameTooltip:Show()
	end
end
