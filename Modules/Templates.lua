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

addon.ShowAltForm = false
BetterWardrobeAlteredFormSwapButtonMixin = {}

function BetterWardrobeAlteredFormSwapButtonMixin:OnLoad()
	local _, raceFile = UnitRace("player");
	if raceFile == "Dracthyr" then
		self.Portrait:SetTexture("Interface\\ICONS\\Ability_Evoker_BlessingOfTheBronze.blp")
		self.nativeFormTooltip = L["Switch Form To Visage"];
		self.alternateFormTooltip = L["Switch Form To Dracthyr"];
	elseif raceFile == "Worgen" then
		self:SetHeight(34);
		self.Portrait:SetTexture("Interface\\AddOns\\Narcissus\\Art\\Modules\\DressingRoom\\FormButton-Worgen");
		 self.Portrait:SetTexture("Interface\\ICONS\\Ability_Evoker_BlessingOfTheBronze.blp")
		self.nativeFormTooltip = L["Switch Form To Human"];
		self.alternateFormTooltip = L["Switch Form To Worgen"];
	else
		self:Hide();
	end

	addon.useNativeForm = C_UnitAuras.WantsAlteredForm("player");
	self.useNativeForm = addon.useNativeForm
end


function BetterWardrobeAlteredFormSwapButtonMixin:ShowTooltip()
	local tooltip = GameTooltip;
	tooltip:SetOwner(self, "ANCHOR_NONE");
	tooltip:SetPoint("LEFT", self, "RIGHT", 4, 0);
	if self.useNativeForm then
		GameTooltip_SetTitle(tooltip, self.nativeFormTooltip, NORMAL_FONT_COLOR);
	else
		GameTooltip_SetTitle(tooltip, self.alternateFormTooltip, NORMAL_FONT_COLOR);
	end
	tooltip:Show();
end

function BetterWardrobeAlteredFormSwapButtonMixin:OnEnter()
	self:ShowTooltip();
end

function BetterWardrobeAlteredFormSwapButtonMixin:OnShow()
	addon.useNativeForm = C_UnitAuras.WantsAlteredForm("player");
	self.useNativeForm = addon.useNativeForm
	self:Update()
	
end

function BetterWardrobeAlteredFormSwapButtonMixin:OnLeave()
	GameTooltip_Hide();
end



function BetterWardrobeAlteredFormSwapButtonMixin:OnClick()
	addon.useNativeForm = not addon.useNativeForm 
	self.useNativeForm = not self.useNativeForm

	self:Update()
	if DressUpFrame and DressUpFrame:IsShown() and type(addon.DressinRoomFormSwap) == "function" then
		addon:DressinRoomFormSwap()
	else
		local tabID = addon.GetTab()
		if tabID == 1 then
			local frame = BetterWardrobeCollectionFrame and BetterWardrobeCollectionFrame.ItemsCollectionFrame
			local cat = frame and frame:GetActiveCategory()
			local slot = frame and frame:GetActiveSlot()
			local transmogLocation = slot and TransmogUtil.GetTransmogLocation(slot, Enum.TransmogType.Appearance, Enum.TransmogModification.Main)
			if frame and transmogLocation then frame:SetActiveSlot(transmogLocation, cat, true) end
		else
			local frame = BetterWardrobeCollectionFrame and BetterWardrobeCollectionFrame.SetsCollectionFrame
			if frame and frame.OnUnitModelChangedEvent then frame:OnUnitModelChangedEvent() end
		end
	end
end


function BetterWardrobeAlteredFormSwapButtonMixin:Update()
	local _, raceFile = UnitRace("player");
	if raceFile == "Dracthyr" then
		if self.useNativeForm then 
			self.Portrait:SetTexture("Interface\\ICONS\\Ability_Racial_Visage.blp")
		else
			self.Portrait:SetTexture("Interface\\ICONS\\Ability_Evoker_BlessingOfTheBronze.blp")
		end
	else
		if self.useNativeForm then 
			self.Portrait:SetTexture("Interface\\ICONS\\Ability_Racial_TwoForms.blp")
		else
			self.Portrait:SetTexture("Interface\\ICONS\\Spell_Hunter_LoneWolf.blp")
		end
	end
	self:ShowTooltip()
end
