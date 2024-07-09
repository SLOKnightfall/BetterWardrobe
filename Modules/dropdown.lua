--	///////////////////////////////////////////////////////////////////////////////////////////
--
--	Module to create the saved set character scrolling menu

--	///////////////////////////////////////////////////////////////////////////////////////////

local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

BetterWardrobeSavedOutfitDropDownMenuMixin = {}

function BetterWardrobeSavedOutfitDropDownMenuMixin:OnLoad()
	local button = _G[self:GetName().."Button"]
	button:SetScript("OnMouseDown", function(self)
						PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
						BetterWardrobeSavedOutfitDropdownFrame:Toggle(self:GetParent())
						end
					)
	BW_UIDropDownMenu_JustifyText(self, "LEFT")
	if ( self.width ) then
		BW_UIDropDownMenu_SetWidth(self, self.width)
	end
end

function BetterWardrobeSavedOutfitDropDownMenuMixin:OnShow()
end

function BetterWardrobeSavedOutfitDropDownMenuMixin:OnHide()
	if BetterWardrobeSavedOutfitDropdownFrame.dropDown == self then
		BetterWardrobeSavedOutfitDropdownFrame:Hide()
	end
end

----

local OUTFIT_FRAME_MIN_STRING_WIDTH = 152
local OUTFIT_FRAME_MAX_STRING_WIDTH = 216
local OUTFIT_FRAME_ADDED_PIXELS = 90	-- pixels added to string width

BetterWardrobeSavedOutfitDropdownFrameMixin = {}

function BetterWardrobeSavedOutfitDropdownFrameMixin:OnHide()
	self.timer = nil
end

function BetterWardrobeSavedOutfitDropdownFrameMixin:Toggle(dropDown)
	if ( self.dropDown == dropDown and self:IsShown() ) then
		BetterWardrobeSavedOutfitDropdownFrame:Hide()
	else
		CloseDropDownMenus()
		self.dropDown = dropDown
		self:Show()
		self:SetPoint("TOPLEFT", self.dropDown, "BOTTOMLEFT", 8, -3)
		self:Update()
	end
end

function BetterWardrobeSavedOutfitDropdownFrameMixin:OnUpdate(elapsed)
	local mouseFocus = GetMouseFocus()
	for i = 1, #self.Buttons do
		local button = self.Buttons[i]
		if ( button == mouseFocus or button:IsMouseOver() ) then
			button.Highlight:Show()
		else
			button.Highlight:Hide()
		end
	end

	if ( BW_UIDROPDOWNMENU_OPEN_MENU ) then
		self:Hide()
	end

	if ( self.timer ) then
		self.timer = self.timer - elapsed
		if ( self.timer < 0 ) then
			self:Hide()
		end
	end
end

function BetterWardrobeSavedOutfitDropdownFrameMixin:StartHideCountDown()
	self.timer = BW_UIDROPDOWNMENU_SHOW_TIME
end

function BetterWardrobeSavedOutfitDropdownFrameMixin:StopHideCountDown()
	self.timer = nil
end

function BetterWardrobeSavedOutfitDropdownFrameMixin:Update()
	local buttons = self.Buttons
	local numButtons = 1
	local stringWidth = 0
	local minStringWidth = self.dropDown.minMenuStringWidth or OUTFIT_FRAME_MIN_STRING_WIDTH
	local maxStringWidth = self.dropDown.maxMenuStringWidth or OUTFIT_FRAME_MAX_STRING_WIDTH
	self:SetWidth(maxStringWidth + OUTFIT_FRAME_ADDED_PIXELS)

	for name in pairs(addon.setdb.global.sets)do
		local button = buttons[numButtons]
		if ( not button ) then
			button = CreateFrame("BUTTON", nil, self.Content, "BetterWardrobeCharacterOutfitButtonTemplate")
			if numButtons == 1 then 
				button:SetPoint("TOPLEFT", self.Content, "TOPLEFT")
				button:SetPoint("TOPRIGHT", self.Content, "TOPRIGHT", -20, 0)
			else
				button:SetPoint("TOPLEFT", buttons[numButtons-1], "BOTTOMLEFT", 0, 0)
				button:SetPoint("TOPRIGHT", buttons[numButtons-1], "BOTTOMRIGHT", 0, 0)
			end
		end

		button:Show();
		button.name = name
		button.Selection:Hide();
		button.Check:Hide();
		button.Text:SetWidth(0);
		button:SetText(NORMAL_FONT_COLOR_CODE..name..FONT_COLOR_CODE_CLOSE);

		stringWidth = max(stringWidth, button.Text:GetStringWidth())
		if ( button.Text:GetStringWidth() > maxStringWidth ) then
			button.Text:SetWidth(maxStringWidth)
		end
		numButtons = numButtons + 1
	end

	for count = numButtons, #buttons do
		buttons[count]:Hide()
	end

	stringWidth = max(stringWidth, minStringWidth)
	stringWidth = min(stringWidth, maxStringWidth)
	self:SetWidth(stringWidth + OUTFIT_FRAME_ADDED_PIXELS)

	if numButtons > 12 then 
		self:SetHeight(30 + 12 * 20)

	else
		self:SetHeight(30 + numButtons * 20)
	end
end

function BetterWardrobeSavedOutfitDropdownFrameMixin:CreateScrollFrame()
	self:SetFrameLevel(5000)
	self.scrollframe = self.scrollframe or CreateFrame("ScrollFrame", self:GetName().."ScrollFrame", self, "UIPanelScrollFrameTemplate")
	self.scrollchild = self.scrollchild or CreateFrame("Frame") -- not sure what happens if you do, but to be safe, don't parent this yet (or do anything with it)
	 
	local scrollbarName = self.scrollframe:GetName()
	self.scrollbar = _G[scrollbarName.."ScrollBar"]
	self.scrollupbutton = _G[scrollbarName.."ScrollBarScrollUpButton"]
	self.scrolldownbutton = _G[scrollbarName.."ScrollBarScrollDownButton"]
	 
	self.scrollupbutton:ClearAllPoints()
	self.scrollupbutton:SetPoint("TOPRIGHT", self.scrollframe, "TOPRIGHT", -2, -2)
	 
	self.scrolldownbutton:ClearAllPoints()
	self.scrolldownbutton:SetPoint("BOTTOMRIGHT", self.scrollframe, "BOTTOMRIGHT", -2, 2)
	 
	self.scrollbar:ClearAllPoints()
	self.scrollbar:SetPoint("TOP", self.scrollupbutton, "BOTTOM", 0, -2)
	self.scrollbar:SetPoint("BOTTOM", self.scrolldownbutton, "TOP", 0, 2)
	 
	self.scrollframe:SetScrollChild(self.scrollchild)
	self.scrollframe:SetAllPoints(self)
	self.scrollframe:ClearAllPoints()
	self.scrollframe:SetPoint("TOPLEFT", self, "TOPLEFT", 11, -15)
	self.scrollframe:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -11, 15)
	self.scrollchild:SetSize(self.scrollframe:GetWidth(), ( self.scrollframe:GetHeight() * 2 ))

	self.moduleoptions = self.moduleoptions or CreateFrame("Frame", nil, self.scrollchild)
	self.moduleoptions:SetAllPoints(self.scrollchild)

	self.Content = self.moduleoptions

	function self.moduleoptions:StartHideCountDown()
		return BetterWardrobeSavedOutfitDropdownFrame:StartHideCountDown()
	end

	function self.moduleoptions:StopHideCountDown()
		return BetterWardrobeSavedOutfitDropdownFrame:StopHideCountDown()
	end
	self.moduleoptions.Buttons = self.moduleoptions.Buttons or {}
	self.Buttons = self.moduleoptions.Buttons
end

--===================================================================================================================================
BetterWardrobeSavedOutfitButtonTemplate = { }

function BetterWardrobeSavedOutfitButtonTemplate:OnClick()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	BetterWardrobeSavedOutfitDropdownFrame:Hide()

	if ( self.name ~= addon.setdb:GetCurrentProfile() ) then 
		addon.SelecteSavedList = self.name
	else
		addon.SelecteSavedList = false
	end

	BetterWardrobeCollectionFrame.SetsCollectionFrame:OnSearchUpdate()
	BetterWardrobeCollectionFrame.SetsTransmogFrame:OnSearchUpdate()
	BW_UIDropDownMenu_SetText(SavedOutfitDropDownMenu, self.name)
end