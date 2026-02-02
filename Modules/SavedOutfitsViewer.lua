local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local SavedSetsFrame = {}

local function GetCustomSetsFrame()
	return TransmogFrame
	   and TransmogFrame.WardrobeCollection
	   and TransmogFrame.WardrobeCollection.TabContent
	   and TransmogFrame.WardrobeCollection.TabContent.CustomSetsFrame
end


function addon:HookCustomSetsOnHide()
	local frame = GetCustomSetsFrame()
	if not frame then
		C_Timer.After(0.1, function() self:HookCustomSetsOnHide() end)
		return
	end

	if self.customSetsHooked then
		return
	end
	self.customSetsHooked = true

	-- AceHook version of hooking OnHide
	self:HookScript(frame, "OnHide", "OnCustomSetsHide")
end

function addon:OnCustomSetsHide()
	if SavedSetsFrame.SavedListFrame then
		SavedSetsFrame.SavedListFrame:Hide()

		local cs = GetCustomSetsFrame()
		if cs and cs.PagedContent then
			cs.PagedContent:Show()
		end
	end
end

function addon:CreateCustomSetsButton()
	local frame = GetCustomSetsFrame()
	if not frame then
		C_Timer.After(1, addon.CreateCustomSetsButton)
		return
	end

	if frame.BW_SavedSetsButton then
		return
	end

	local btn = CreateFrame("Button", "BW_SavedSetsButton", frame, "UIPanelButtonTemplate")
	btn:SetSize(90, 22)
	btn:SetText("BW Saved")
	btn:Show()
	btn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -10)
	btn:SetScript("OnClick", function()
		SavedSetsFrame:ShowFrame()
	end)

	SavedSetsFrame:FrameCreate()

	frame.BW_SavedSetsButton = btn
end

local CameraTranslate = {
    ["BloodElf2"]           = { 0.058,  0.68,  0.05 },
    ["BloodElf3"]           = { 0.058,  0.98, -0.05 },

    ["DarkIronDwarf2"]      = {-0.012,  0.28, -0.45 },
    ["DarkIronDwarf3"]      = { 0.038,  0.78, -0.48 },

    ["Draenei2"]            = {-0.092, -0.72,  0.25 },
    ["Draenei3"]            = {-0.042,  1.23,  0.35 },

    ["Dracthyr2"]           = {-0.862, -0.52,  0.65 },
    ["Dracthyr3"]           = {-0.862, -0.52,  0.65 },

    ["Dwarf2"]              = { 0.038,  0.28, -0.45 },
    ["Dwarf3"]              = { 0.008,  0.78, -0.48 },

    ["EarthenDwarf2"]       = { 0.038,  0.28, -0.45 },
    ["EarthenDwarf3"]       = { 0.008,  0.78, -0.48 },

    ["Gnome2"]              = { 0.108,  1.28, -0.85 },
    ["Gnome3"]              = {-0.112,  1.08, -0.90 },

    ["Goblin2"]             = { 0.108,  0.98, -0.75 },
    ["Goblin3"]             = {-0.112,  0.78, -0.68 },

    ["Harronir2"]           = {-0.042,  0.88,  0.40 },
    ["Harronir3"]           = { 0.058,  1.08,  0.25 },

    ["HighmountainTauren2"] = {-0.012, -1.32,  0.35 },
    ["HighmountainTauren3"] = {-0.242, -0.52,  0.35 },

    ["Human2"]              = { 0.058,  0.48, -0.05 },
    ["Human3"]              = { 0.058,  0.98, -0.05 },

    ["KulTiran2"]           = { 0.108, -0.02,  0.45 },
    ["KulTiran3"]           = { 0.038,  0.68,  0.45 },

    ["LightforgedDraenei2"] = {-0.092, -0.72,  0.25 },
    ["LightforgedDraenei3"] = {-0.042,  0.98,  0.35 },

    ["MagharOrc2"]          = { 0.158, -0.82, -0.05 },
    ["MagharOrc3"]          = {-0.092,  0.58,  0.00 },

    ["Mechagnome2"]         = { 0.038,  1.18, -0.85 },
    ["Mechagnome3"]         = {-0.062,  1.18, -0.90 },

    ["Nightborne2"]         = { 0.108, -0.02,  0.35 },
    ["Nightborne3"]         = { 0.108,  0.73,  0.30 },

    ["NightElf2"]           = {-0.042, -0.02,  0.35 },
    ["NightElf3"]           = { 0.058,  0.73,  0.30 },

    ["Orc2"]                = { 0.058, -0.82, -0.05 },
    ["Orc3"]                = {-0.092,  0.58,  0.00 },
    ["Orc4"]                = {-0.092, -0.82, -0.05 },

    ["Pandaren2"]           = {-0.242, -1.02,  0.05 },
    ["Pandaren3"]           = {-0.192, -0.42,  0.05 },

    ["Scourge2"]            = {-0.042,  0.58, -0.15 },
    ["Scourge3"]            = { 0.178,  0.98, -0.10 },

    ["Tauren2"]             = {-0.012, -1.32,  0.35 },
    ["Tauren3"]             = {-0.242, -0.52,  0.35 },

    ["Troll2"]              = { 0.278,  0.08,  0.15 },
    ["Troll3"]              = {-0.012,  0.68,  0.35 },

    ["VoidElf2"]            = { 0.058,  0.68,  0.05 },
    ["VoidElf3"]            = { 0.058,  0.98, -0.05 },

    ["Vulpera2"]            = {-0.112,  0.68, -0.75 },
    ["Vulpera3"]            = {-0.112,  0.68, -0.70 },

    ["Worgen2"]             = { 0.158, -0.72,  0.15 },
    ["Worgen3"]             = { 0.008,  0.08,  0.25 },

    ["ZandalariTroll2"]     = { 0.058, -0.17,  0.60 },
    ["ZandalariTroll3"]     = {-0.142,  0.38,  0.75 },
}

function SavedSetsFrame:ShowFrame()
	if self.SavedListFrame:IsShown() then
		self.SavedListFrame:Hide()
		TransmogFrame.WardrobeCollection.TabContent.CustomSetsFrame.PagedContent:Show()
		return
	end

	TransmogFrame.WardrobeCollection.TabContent.CustomSetsFrame.PagedContent:Hide()

	local _, race = UnitRace("player")
	local sex = UnitSex("player")
	local key = race..sex
	local baseCamera = { -0.108, -2.78, 1.55 }

	local _, alteredForm = C_PlayerInfo.GetAlternateFormInfo()
	for i = 1, 9 do
		local model = self.Models[i]
		model.actor:SetModelByUnit("player", false, true, false, not alteredForm)
		model.actor:SetYaw(-1.5)
		model:SetPaused(true)
		model:SetCameraOrientationByAxisVectors(0, 1, 0, -1, 0, 0, 0, 0, 1)

		local file = model.actor:GetModelFileID()
		if file == 1968587 then
			key = "Orc4"
		elseif file == 4395382 then
			key = "BloodElf"..sex
		elseif file == 1000764 or file == 1011653 or file == 4220448 then
			key = "Human"..sex
		end

		local x = CameraTranslate[key][1] + baseCamera[1]
		local y = CameraTranslate[key][2] + baseCamera[2]
		local z = CameraTranslate[key][3] + baseCamera[3]

		model:SetCameraPosition(x,y,z)
	end

	self.SavedListFrame:Show()
	self.Select = true
end

local pageNum = 1
function SavedSetsFrame:FrameCreate()
	if self.SavedListFrame then
		return
	end

	-- Create a Blizzard-styled panel using ButtonFrameTemplate
	local parent = TransmogFrame.WardrobeCollection
	self.SavedListFrame = CreateFrame("Frame", nil, parent, "CustomSetsFrameTemplate")

	local frame = self.SavedListFrame

	frame:ClearAllPoints()
	frame:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -60)
	frame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, 5)
	frame:SetFrameStrata("HIGH")

	-- Title text provided by the template
	if frame.TitleText then
		frame.TitleText:SetText("Saved Sets")
	end

	---------------------------------------------------------
	-- MODEL GRID (3x3)
	---------------------------------------------------------
	self.Models = {}

	local index
	for i = 1, 3 do
		for j = 1, 3 do
			index = j + (i - 1) * 3

			-- ModelScene cannot use BackdropTemplate
			local model = CreateFrame("ModelScene", tostring(index), frame)
			model:SetSize(180, 230)
			model:SetPoint("CENTER", frame, "CENTER", -200 + (j - 1) * 200, 250 - (i - 1) * 245)
			model:EnableMouse(true)
			model:SetScript("OnMouseDown", function(f, btn)
				SavedSetsFrame:OnClick(f, btn)
			end)

			-- Add a backdrop using a child frame
			local bg = CreateFrame("Frame", nil, model, "BackdropTemplate")
			bg:SetAllPoints()
			bg:SetBackdrop({
				bgFile = "Interface/Tooltips/UI-Tooltip-Background",
				tile = true, tileSize = 16, edgeSize = 16,
				insets = { left = 1, right = 1, top = 1, bottom = 1 }
			})
			bg:SetBackdropBorderColor(1, 0.82, 0, 1)
			bg:SetBackdropColor(0, 0, 0, 1) -- black background

			local edge = CreateFrame("Frame", nil, model, "BackdropTemplate")
			edge:SetAllPoints()
			edge:SetBackdrop({
				edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
				tile = true, tileSize = 16, edgeSize = 16,
				insets = { left = 1, right = 1, top = 1, bottom = 1 }
			})
			edge:SetBackdropBorderColor(1, 0.82, 0, 1)
			-- Make sure the border is BEHIND the model
			bg:SetFrameLevel(model:GetFrameLevel() - 1)

			-- Now ensure the model is above the border
			model:SetFrameLevel(bg:GetFrameLevel() + 1)

			-- Text label
			local text = model:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
			text:SetSize(290, 150)
			text:SetPoint("BOTTOM", model, "BOTTOM", 0, -50)
			text:SetJustifyH("CENTER")
			text:SetJustifyV("MIDDLE")

			-- Actor
			model.actor = model:CreateActor("actor", "TransmogCustomSetModelTemplate")
			model.actor:Show()

			self.Models[index] = model
			model.text = text
		end
	end

	---------------------------------------------------------
	-- PAGING CONTROLS
	---------------------------------------------------------
	frame.PagedContent.PagingControls.NextPageButton:SetScript("OnClick", function()
		SavedSetsFrame:PageForward()
	end)

	frame.PagedContent.PagingControls.PrevPageButton:SetScript("OnClick", function()
		SavedSetsFrame:PageBack()
	end)

	frame:SetScript("OnShow", function()
		SavedSetsFrame:OnShow()
	end)

	frame:Hide()
end


function SavedSetsFrame:PageForward()
	self.Page = self.Page + 1
	self:OnShow()

	if self.Page > 1 then
		self.SavedListFrame.PagedContent.PagingControls.PrevPageButton:Enable()
	end

	if self.Page == self.NumPages then
		self.SavedListFrame.PagedContent.PagingControls.NextPageButton:Disable()
	end
end

function SavedSetsFrame:PageBack()
	self.Page = self.Page - 1

	if self.Page == 0 then
		self.Page = 1
	end

	if self.Page > 1 then
		self.SavedListFrame.PagedContent.PagingControls.PrevPageButton:Enable()
	end

	if self.Page == 1 then
		self.SavedListFrame.PagedContent.PagingControls.PrevPageButton:Disable()
		self.SavedListFrame.PagedContent.PagingControls.NextPageButton:Enable()
	end
	self:OnShow()
end

function SavedSetsFrame:UpdateOutfit(slot, type, appearance)
	if not appearance then return end
	local info = C_TransmogCollection.GetSourceInfo(appearance)
	local categoryID = (info and info.categoryID) or 0
	local display = (info and  info.isHideVisual and 3) or (info and  not info.isHideVisual and 1) or (not info and 0)
	local option = 0

	if slot == Enum.TransmogOutfitSlot.WeaponMainHand or slot == Enum.TransmogOutfitSlot.WeaponOffHand then
		local spec = GetSpecializationInfo(GetSpecialization())
	
		if (categoryID >= 12 and categoryID <= 17 ) or  categoryID == 28 then
			option = Enum.TransmogOutfitSlotOption.OneHandedWeapon
		elseif categoryID >= 20 and categoryID <= 24  then
			if spec == 72 then
				option = Enum.TransmogOutfitSlotOption.FuryTwoHandedWeapon
			end
			option = Enum.TransmogOutfitSlotOption.TwoHandedWeapon
		elseif categoryID >= 25 and categoryID <= 27  then
			option = Enum.TransmogOutfitSlotOption.RangedWeapon
		elseif categoryID == 19 then
			option = Enum.TransmogOutfitSlotOption.OffHand
		elseif categoryID == 18 then
			option = Enum.TransmogOutfitSlotOption.Shield
		end
	end

	C_TransmogOutfitInfo.SetPendingTransmog(slot, type, option, appearance, display)
end

function SavedSetsFrame:ApplyOutfit(index)
	local outfit = addon.OutfitDB.char.outfits[index]
	if outfit ~= nil then
		C_TransmogOutfitInfo.ClearAllPendingTransmogs()
		self:UpdateOutfit(Enum.TransmogOutfitSlot.Head, Enum.TransmogType.Appearance, outfit[1])
		self:UpdateOutfit(Enum.TransmogOutfitSlot.ShoulderRight, Enum.TransmogType.Appearance, outfit[3])
		self:UpdateOutfit(Enum.TransmogOutfitSlot.Body, Enum.TransmogType.Appearance, outfit[4])
		self:UpdateOutfit(Enum.TransmogOutfitSlot.Chest, Enum.TransmogType.Appearance, outfit[5])
		self:UpdateOutfit(Enum.TransmogOutfitSlot.Waist, Enum.TransmogType.Appearance, outfit[6])
		self:UpdateOutfit(Enum.TransmogOutfitSlot.Legs, Enum.TransmogType.Appearance, outfit[7])
		self:UpdateOutfit(Enum.TransmogOutfitSlot.Feet, Enum.TransmogType.Appearance, outfit[8])
		self:UpdateOutfit(Enum.TransmogOutfitSlot.Wrist, Enum.TransmogType.Appearance, outfit[9])
		self:UpdateOutfit(Enum.TransmogOutfitSlot.Hand ,Enum.TransmogType.Appearance, outfit[10])
		self:UpdateOutfit(Enum.TransmogOutfitSlot.Back, Enum.TransmogType.Appearance, outfit[15])
		self:UpdateOutfit(Enum.TransmogOutfitSlot.WeaponMainHand, Enum.TransmogType.Appearance, outfit[16])
		self:UpdateOutfit(Enum.TransmogOutfitSlot.WeaponOffHand, Enum.TransmogType.Appearance, outfit[17])
		self:UpdateOutfit(Enum.TransmogOutfitSlot.Tabard, Enum.TransmogType.Appearance, outfit[19])
		self:UpdateOutfit(Enum.TransmogOutfitSlot.WeaponMainHand, Enum.TransmogType.Illusion, outfit["mainHandEnchant"])
		self:UpdateOutfit(Enum.TransmogOutfitSlot.WeaponOffHand, Enum.TransmogType.Illusion, outfit["offHandEnchant"])
	end
end

function SavedSetsFrame:OnClick(frame, button)
	local buttonID = tonumber(frame:GetName())
	local index = buttonID + 9 * (SavedSetsFrame.Page - 1)

	if button == "LeftButton" then
		SavedSetsFrame:ApplyOutfit(index)
	end
end

function SavedSetsFrame:OnShow()
	self.NumPages = math.ceil(#addon.OutfitDB.char.outfits / 9)
	self.Page = self.Page or 1
	if self.NumPages <= 0 then
		self.NumPages = 1
	end

	if self.Page > self.NumPages then
		self.Page = self.NumPages
	end

	if self.NumPages >= 2 then
		self.SavedListFrame.PagedContent.PagingControls.NextPageButton:Enable()
	end

	self.SavedListFrame.PagedContent.PagingControls.PageText:SetText("Page " .. self.Page .. "/" .. self.NumPages)
	
	for i = 1, 9 do
		self.Models[i]:Show()
		local outfits = addon.OutfitDB.char.outfits[i + 9 * (self.Page - 1)]
		if outfits ~= nil then
			local actor = self.Models[i].actor
			self.Models[i].text:SetText(outfits.name)

			actor:Undress()
			actor:SetItemTransmogInfo(ItemUtil.CreateItemTransmogInfo(outfits[1], nil, nil), 1)
			actor:SetItemTransmogInfo(ItemUtil.CreateItemTransmogInfo(outfits[3], nil, nil), 3)
			actor:SetItemTransmogInfo(ItemUtil.CreateItemTransmogInfo(outfits[4], nil, nil), 4)
			actor:SetItemTransmogInfo(ItemUtil.CreateItemTransmogInfo(outfits[5], nil, nil),5)
			actor:SetItemTransmogInfo(ItemUtil.CreateItemTransmogInfo(outfits[6], nil, nil), 6)
			actor:SetItemTransmogInfo(ItemUtil.CreateItemTransmogInfo(outfits[7], nil, nil), 7)
			actor:SetItemTransmogInfo(ItemUtil.CreateItemTransmogInfo(outfits[8], nil, nil), 8)
			actor:SetItemTransmogInfo(ItemUtil.CreateItemTransmogInfo(outfits[9], nil, nil), 9)
			actor:SetItemTransmogInfo(ItemUtil.CreateItemTransmogInfo(outfits[10], nil, nil), 10)
			actor:SetItemTransmogInfo(ItemUtil.CreateItemTransmogInfo(outfits[15], nil, nil), 15)
			actor:SetItemTransmogInfo(ItemUtil.CreateItemTransmogInfo(outfits[16], nil, outfits["mainHandEnchant"]), 16)
			actor:SetItemTransmogInfo(ItemUtil.CreateItemTransmogInfo(outfits[17], nil, outfits["offHandEnchant"]), 17)
			actor:SetItemTransmogInfo(ItemUtil.CreateItemTransmogInfo(outfits[19], nil, nil), 19)
		else
			self.Models[i]:Hide()
		end
	end
end