local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

--Option values are freshly allocated each call, so match by value, not identity.
local function OptionsMatch(a, b)
	if a == b then return true end
	if type(a) ~= "table" or type(b) ~= "table" then return false end
	for k, v in pairs(a) do
		if not OptionsMatch(v, b[k]) then return false end
	end
	for k in pairs(b) do
		if a[k] == nil then return false end
	end
	return true
end

local function ForEachSituationOption(callback)
	local situationsData = C_TransmogOutfitInfo.GetUISituationCategoriesAndOptions()
	if not situationsData then return end
	for _, categoryData in ipairs(situationsData) do
		for _, groupData in ipairs(categoryData.groupData) do
			for _, optionData in ipairs(groupData.optionData) do
				callback(optionData)
			end
		end
	end
end

function addon:GetSituationPresets()
	BetterWardrobe_ListData.SituationPresetsDB = BetterWardrobe_ListData.SituationPresetsDB or {}
	return BetterWardrobe_ListData.SituationPresetsDB
end

function addon:GetSituationPreset(name)
	for _, preset in ipairs(self:GetSituationPresets()) do
		if preset.name == name then
			return preset
		end
	end
	return nil
end

function addon:CaptureSituationPreset(name)
	local selections = {}
	ForEachSituationOption(function(optionData)
		if C_TransmogOutfitInfo.GetOutfitSituation(optionData.option) then
			table.insert(selections, CopyTable(optionData.option))
		end
	end)

	local preset = self:GetSituationPreset(name)
	if preset then
		preset.selections = selections
	else
		preset = { name = name, selections = selections }
		table.insert(self:GetSituationPresets(), preset)
	end
	return preset
end

function addon:ApplySituationPreset(preset)
	ForEachSituationOption(function(optionData)
		local shouldSelect = false
		for _, saved in ipairs(preset.selections) do
			if OptionsMatch(optionData.option, saved) then
				shouldSelect = true
				break
			end
		end
		C_TransmogOutfitInfo.UpdatePendingSituation(optionData.option, shouldSelect)
	end)
	C_TransmogOutfitInfo.CommitPendingSituations()
end

function addon:DeleteSituationPresetByRef(presetRef)
	local presets = self:GetSituationPresets()
	for i, preset in ipairs(presets) do
		if preset == presetRef then
			table.remove(presets, i)
			return
		end
	end
end

StaticPopupDialogs["BW_NAME_SITUATION_PRESET"] = {
	preferredIndex = 3,
	text = L["Save Situations As"],
	button1 = SAVE,
	button2 = CANCEL,
	OnAccept = function(dialog)
		local name = dialog:GetEditBox():GetText()
		if name == "" then return end
		if addon:GetSituationPreset(name) then
			StaticPopup_Show("BW_CONFIRM_OVERWRITE_SITUATION_PRESET", name, nil, name)
		else
			addon:CaptureSituationPreset(name)
		end
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	hasEditBox = 1,
	maxLetters = 31,
	OnShow = function(dialog)
		dialog:GetButton1():Disable()
		dialog:GetEditBox():SetFocus()
	end,
	OnHide = function(dialog)
		dialog:GetEditBox():SetText("")
	end,
	EditBoxOnEnterPressed = function(editBox)
		if editBox:GetParent():GetButton1():IsEnabled() then
			StaticPopup_OnClick(editBox:GetParent(), 1)
		end
	end,
	EditBoxOnTextChanged = function(editBox)
		local parent = editBox:GetParent()
		if parent:GetEditBox():GetText() ~= "" then
			parent:GetButton1():Enable()
		else
			parent:GetButton1():Disable()
		end
	end,
	EditBoxOnEscapePressed = function(editBox)
		editBox:GetParent():Hide()
	end,
}

StaticPopupDialogs["BW_CONFIRM_OVERWRITE_SITUATION_PRESET"] = {
	preferredIndex = 3,
	text = L["A preset named '%s' already exists. Overwrite it?"],
	button1 = YES,
	button2 = NO,
	OnAccept = function(dialog, name)
		addon:CaptureSituationPreset(name)
	end,
	hideOnEscape = 1,
	timeout = 0,
	whileDead = 1,
}

StaticPopupDialogs["BW_CONFIRM_RENAME_OVERWRITE_SITUATION_PRESET"] = {
	preferredIndex = 3,
	text = L["A preset named '%s' already exists. Overwrite it?"],
	button1 = YES,
	button2 = NO,
	OnAccept = function(dialog, data)
		addon:DeleteSituationPresetByRef(data.existing)
		data.preset.name = data.newName
	end,
	hideOnEscape = 1,
	timeout = 0,
	whileDead = 1,
}

StaticPopupDialogs["BW_CONFIRM_DELETE_SITUATION_PRESET"] = {
	preferredIndex = 3,
	text = L["Delete preset '%s'?"],
	button1 = YES,
	button2 = NO,
	OnAccept = function(dialog, presetRef)
		addon:DeleteSituationPresetByRef(presetRef)
	end,
	hideOnEscape = 1,
	timeout = 0,
	whileDead = 1,
}

local SituationPresetEditFrame = CreateFrame("Frame", "BW_SituationPresetEditFrame", UIParent)
SituationPresetEditFrame:SetFrameStrata("DIALOG")
SituationPresetEditFrame:SetSize(320, 174)
SituationPresetEditFrame:SetPoint("CENTER")
SituationPresetEditFrame:Hide()
SituationPresetEditFrame.exclusive = true
SituationPresetEditFrame.hideOnEscape = true
SituationPresetEditFrame.Border = CreateFrame("Frame", nil, SituationPresetEditFrame, "DialogBorderTemplate")

SituationPresetEditFrame.Title = SituationPresetEditFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
SituationPresetEditFrame.Title:SetPoint("TOP", 0, -20)
SituationPresetEditFrame.Title:SetText(L["Situation Name"])

local EditBox = CreateFrame("EditBox", nil, SituationPresetEditFrame)
SituationPresetEditFrame.EditBox = EditBox
EditBox:SetSize(260, 32)
EditBox:SetPoint("TOP", 0, -40)
EditBox:SetAutoFocus(false)
EditBox:SetFontObject(ChatFontNormal)
EditBox:SetMaxLetters(31)
EditBox:SetHistoryLines(1)

local editBoxLeft = EditBox:CreateTexture(nil, "BACKGROUND")
editBoxLeft:SetSize(32, 32)
editBoxLeft:SetPoint("LEFT", -10, 0)
editBoxLeft:SetTexture([[Interface\ChatFrame\UI-ChatInputBorder-Left2]])
local editBoxRight = EditBox:CreateTexture(nil, "BACKGROUND")
editBoxRight:SetSize(32, 32)
editBoxRight:SetPoint("RIGHT", 10, 0)
editBoxRight:SetTexture([[Interface\ChatFrame\UI-ChatInputBorder-Right2]])
local editBoxMiddle = EditBox:CreateTexture(nil, "BACKGROUND")
editBoxMiddle:SetHeight(32)
editBoxMiddle:SetTexture([[Interface\ChatFrame\UI-ChatInputBorder-Mid2]])
editBoxMiddle:SetHorizTile(true)
editBoxMiddle:SetPoint("TOPLEFT", editBoxLeft, "TOPRIGHT")
editBoxMiddle:SetPoint("TOPRIGHT", editBoxRight, "TOPLEFT")

EditBox:SetScript("OnEnterPressed", function() SituationPresetEditFrame:OnAccept() end)
EditBox:SetScript("OnEscapePressed", function() StaticPopupSpecial_Hide(SituationPresetEditFrame) end)
EditBox:SetScript("OnTextChanged", function(self)
	SituationPresetEditFrame.AcceptButton:SetEnabled(self:GetText() ~= "")
end)

local AcceptButton = CreateFrame("Button", nil, SituationPresetEditFrame, "UIPanelButtonTemplate")
SituationPresetEditFrame.AcceptButton = AcceptButton
AcceptButton:SetSize(120, 22)
AcceptButton:SetPoint("TOPLEFT", 33, -80)
AcceptButton:SetText(ACCEPT)
AcceptButton:SetScript("OnClick", function()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	SituationPresetEditFrame:OnAccept()
end)

local CancelButton = CreateFrame("Button", nil, SituationPresetEditFrame, "UIPanelButtonTemplate")
SituationPresetEditFrame.CancelButton = CancelButton
CancelButton:SetSize(120, 22)
CancelButton:SetPoint("TOPRIGHT", -33, -80)
CancelButton:SetText(CANCEL)
CancelButton:SetScript("OnClick", function()
	StaticPopupSpecial_Hide(SituationPresetEditFrame)
end)

local Separator = SituationPresetEditFrame:CreateTexture(nil, "ARTWORK")
Separator:SetSize(276, 1)
Separator:SetPoint("TOP", 0, -127)
Separator:SetColorTexture(1, 1, 1, 0.14)

local UpdateButton = CreateFrame("Button", nil, SituationPresetEditFrame, "UIPanelButtonTemplate")
SituationPresetEditFrame.UpdateButton = UpdateButton
UpdateButton:SetSize(120, 22)
UpdateButton:SetPoint("BOTTOMLEFT", 33, 17)
UpdateButton:SetText(L["Update"])
UpdateButton:SetScript("OnClick", function()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	SituationPresetEditFrame:OnUpdate()
end)

local DeleteButton = CreateFrame("Button", nil, SituationPresetEditFrame, "UIPanelButtonTemplate")
SituationPresetEditFrame.DeleteButton = DeleteButton
DeleteButton:SetSize(120, 22)
DeleteButton:SetPoint("BOTTOMRIGHT", -33, 17)
DeleteButton:SetText(L["Delete"])
DeleteButton:SetScript("OnClick", function()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	SituationPresetEditFrame:OnDelete()
end)

SituationPresetEditFrame:SetScript("OnHide", function()
	PlaySound(SOUNDKIT.IG_MAINMENU_CLOSE)
end)

addon:SecureHookScript(TransmogFrame, "OnHide", function()
	StaticPopupSpecial_Hide(SituationPresetEditFrame)
end)

function SituationPresetEditFrame:ShowForPreset(preset)
	StaticPopupSpecial_Show(self)
	self.preset = preset
	self.EditBox:SetText(preset.name)
end

function SituationPresetEditFrame:OnAccept()
	if not self.AcceptButton:IsEnabled() then return end
	local newName = self.EditBox:GetText()
	StaticPopupSpecial_Hide(self)
	if not self.preset or newName == "" or newName == self.preset.name then
		return
	end

	local existing = addon:GetSituationPreset(newName)
	if existing and existing ~= self.preset then
		StaticPopup_Show("BW_CONFIRM_RENAME_OVERWRITE_SITUATION_PRESET", newName, nil,
			{ preset = self.preset, existing = existing, newName = newName })
		return
	end

	self.preset.name = newName
end

function SituationPresetEditFrame:OnUpdate()
	StaticPopupSpecial_Hide(self)
	if self.preset then
		addon:CaptureSituationPreset(self.preset.name)
	end
end

function SituationPresetEditFrame:OnDelete()
	StaticPopupSpecial_Hide(self)
	StaticPopup_Show("BW_CONFIRM_DELETE_SITUATION_PRESET", self.preset.name, nil, self.preset)
end

function addon:CreateSituationPresetUI(SituationsFrame)
	if not SituationsFrame or not SituationsFrame.DefaultsButton or SituationsFrame.BW_PresetDropdown then
		return
	end

	local Dropdown = CreateFrame("DropdownButton", nil, SituationsFrame, "WowStyle1DropdownTemplate")
	SituationsFrame.BW_PresetDropdown = Dropdown
	Dropdown:SetPoint("TOPRIGHT", SituationsFrame.DefaultsButton, "BOTTOMRIGHT", 0, -8)
	Dropdown:SetWidth(150)
	Dropdown:SetDefaultText(L["Presets"])

	Dropdown:SetupMenu(function(_dropdown, rootDescription)
		rootDescription:SetTag("MENU_BW_SITUATION_PRESETS")

		rootDescription:CreateButton(L["Create Preset"], function()
			StaticPopup_Show("BW_NAME_SITUATION_PRESET")
		end)
		rootDescription:CreateDivider()

		local presets = addon:GetSituationPresets()
		if #presets == 0 then
			local button = rootDescription:CreateButton(GRAY_FONT_COLOR:WrapTextInColorCode(L["No Presets Saved"]), function() end)
			button:SetEnabled(false)
		end

		for _, preset in ipairs(presets) do
			local button = rootDescription:CreateButton(preset.name, function()
				addon:ApplySituationPreset(preset)
			end)
			button:AddInitializer(function(button, description, menu)
				local gearButton = MenuTemplates.AttachAutoHideGearButton(button)
				gearButton:SetPoint("RIGHT")
				MenuUtil.HookTooltipScripts(gearButton, function(tooltip)
					GameTooltip_SetTitle(tooltip, L["Edit Preset"])
				end)
				gearButton:SetScript("OnClick", function()
					SituationPresetEditFrame:ShowForPreset(preset)
					menu:Close()
				end)
			end)
		end
	end)
end

--Adds a "Select Preset" entry to the outfit slot list's native right-click menu (Blizzard's own
--TransmogOutfitEntryMixin, MENU_TRANSMOG_OUTFIT_ENTRY tag).
Menu.ModifyMenu("MENU_TRANSMOG_OUTFIT_ENTRY", function(_owner, rootDescription)
	local presets = addon:GetSituationPresets()
	if #presets == 0 then
		return
	end

	local submenu = rootDescription:CreateButton(L["Select Preset"])
	for _, preset in ipairs(presets) do
		submenu:CreateButton(preset.name, function()
			addon:ApplySituationPreset(preset)
		end)
	end
end)
