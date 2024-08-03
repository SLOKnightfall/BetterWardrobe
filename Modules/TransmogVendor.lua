local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local UI = {}

function addon.Init:BuildTransmogVendorUI()
	UI:CreateButtons()
	UI:CreateDropDown()
	UI.ExtendTransmogView()
	---UpdateSlotButtons()



----Temp fix for reseting head slot position when sencondary slot is toggled
	function WardrobeTransmogFrame:CheckSecondarySlotButtons()
	local headButton = self.HeadButton;
	local mainShoulderButton = self.ShoulderButton;
	local secondaryShoulderButton = self.SecondaryShoulderButton;
	local secondaryShoulderTransmogged = TransmogUtil.IsSecondaryTransmoggedForItemLocation(secondaryShoulderButton.itemLocation);

	local pendingInfo = C_Transmog.GetPending(secondaryShoulderButton.transmogLocation);
	local showSecondaryShoulder = false;
	if not pendingInfo then
		showSecondaryShoulder = secondaryShoulderTransmogged;
	elseif pendingInfo.type == Enum.TransmogPendingType.ToggleOff then
		showSecondaryShoulder = false;
	else
		showSecondaryShoulder = true;
	end

	secondaryShoulderButton:SetShown(showSecondaryShoulder);
	self.ToggleSecondaryAppearanceCheckbox:SetChecked(showSecondaryShoulder);

	local point, relativeTo, relativePoint, xOfs, yOfs = headButton:GetPoint()
	if showSecondaryShoulder then
		headButton:SetPoint("TOP", xOfs, -15);
		secondaryShoulderButton:SetPoint("TOP", mainShoulderButton, "BOTTOM", 0, -10);
	else
		headButton:SetPoint("TOP", xOfs, -41);
		secondaryShoulderButton:SetPoint("TOP", mainShoulderButton, "TOP");
	end

	if not showSecondaryShoulder and self.selectedSlotButton == secondaryShoulderButton then
		self:SelectSlotButton(mainShoulderButton);
	end
end
	----addon:SecureHook(WardrobeTransmogFrame,"CheckSecondarySlotButtons", function()  C_Timer.After(0.1, function() print("SD"); UI.ExtendTransmogView() end)  end)


end


function UI:CreateDropDown()
	WardrobeTransmogFrame.OutfitDropdown:Hide()
	local f = CreateFrame("DropdownButton", "BetterWardrobeTMOutfitDropDown", WardrobeTransmogFrame, "BetterWardrobeSavedSetDropdownTemplate")
	addon:SecureHook(WardrobeTransmogFrame, "OnTransmogApplied", function()
	C_Timer.After(.5, function()
			--if BetterWardrobeOutfitDropDown.selectedOutfitID and BetterWardrobeOutfitDropDown:IsOutfitDressed() then
				--BetterWardrobeOutfitDropDown:OnOutfitApplied(BetterWardrobeOutfitDropDown.selectedOutfitID)
			--end
		end)
		end, true)
end


--Creates the various buttons used on the Collection Journal
function UI:CreateButtons()
	--Load Queue Button
	local BW_LoadQueueButton = CreateFrame("Button", "BW_LoadQueueButton", WardrobeTransmogFrame, "BetterWardrobeButtonTemplate")
	BW_LoadQueueButton.Icon:SetTexture("Interface\\Buttons\\UI-OptionsButton")
	BW_LoadQueueButton:SetPoint("TOPLEFT", WardrobeTransmogFrame.OutfitDropdown.SaveButton, "TOPRIGHT", 50,-2)
	BW_LoadQueueButton.buttonID = "Import"
	BW_LoadQueueButton:SetScript("OnClick", function(self) BW_TransmogVendorExportButton_OnClick(self) end)
	--BW_LoadQueueButton:SetScript("OnEnter",  function(self) BW_DressingRoomButtonMixin:OnEnter(self) end)

	--Randomize Button, Mixin defined in Randomizer.lua
	local BW_RandomizeButton = CreateFrame("Button", "BW_RandomizeButton", WardrobeTransmogFrame, "BetterWardrobeButtonTemplate")
	BW_RandomizeButton.Icon:SetTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Up")
	Mixin(BW_RandomizeButton, BW_RandomizeButtonMixin)
	BW_RandomizeButton:SetPoint("TOPLEFT", BW_LoadQueueButton, "TOPRIGHT" , 0, 0)
	BW_RandomizeButton:SetScript("OnMouseUp", BW_RandomizeButton.OnMouseUp)
	BW_RandomizeButton:SetScript("OnMouseDown", BW_RandomizeButton.OnMouseDown)
	BW_RandomizeButton:SetScript("OnEnter", BW_RandomizeButton.OnEnter)

	local BW_SlotHideButton = CreateFrame("Button", "BW_SlotHideButton", WardrobeTransmogFrame, "BetterWardrobeButtonTemplate")
	BW_SlotHideButton.buttonID = "HideSlot"
	BW_SlotHideButton:SetScript("OnEnter", function(self) BW_DressingRoomButtonMixin:OnEnter() end)
	
	BW_SlotHideButton.Icon:SetTexture("Interface\\PvPRankBadges\\PvPRank12")
	--Mixin(BW_SlotHideButton, BW_SlotHideButtonMixin)
	BW_SlotHideButton:SetPoint("TOPLEFT", BW_RandomizeButton, "TOPRIGHT" , 0, 0)
	BW_SlotHideButton:SetScript("OnClick", function(self) UI:HideSlotMenu_OnClick(self) end)

	--BW_SlotHideButton:SetScript("OnMouseUp", BW_SlotHideButton.OnMouseUp)
	--BW_SlotHideButton:SetScript("OnMouseDown", BW_SlotHideButton.OnMouseDown)
	--BW_SlotHideButton:SetScript("OnEnter", BW_SlotHideButton.OnEnter)

	----local BW_TransmogOptionsDropDown= CreateFrame("Frame", "BW_TransmogOptionsDropDown", BetterWardrobeCollectionFrame, "BW_UIDropDownMenuTemplate")
	----BW_TransmogOptionsDropDown = BW_TransmogOptionsDropDown

	local f = CreateFrame("Frame", "BW_AltIcon1", WardrobeTransmogFrame.HeadButton, "AltItemtemplate")
	local f = CreateFrame("Frame", "BW_AltIcon3", WardrobeTransmogFrame.ShoulderButton, "AltItemtemplate")
	local f = CreateFrame("Frame", "BW_AltIcon15", WardrobeTransmogFrame.BackButton, "AltItemtemplate")
	local f = CreateFrame("Frame", "BW_AltIcon5", WardrobeTransmogFrame.ChestButton, "AltItemtemplate")
	local f = CreateFrame("Frame", "BW_AltIcon9", WardrobeTransmogFrame.WristButton, "AltItemtemplate")
	local f = CreateFrame("Frame", "BW_AltIcon10", WardrobeTransmogFrame.HandsButton, "AltItemtemplate")
	local f = CreateFrame("Frame", "BW_AltIcon6", WardrobeTransmogFrame.WaistButton, "AltItemtemplate")
	local f = CreateFrame("Frame", "BW_AltIcon7", WardrobeTransmogFrame.LegsButton, "AltItemtemplate")
	local f = CreateFrame("Frame", "BW_AltIcon8", WardrobeTransmogFrame.FeetButton, "AltItemtemplate")



end


function UI:HideSlotMenu_OnClick(parent)
	local Profile = addon.Profile
	local armor = addon.Globals.EmptyArmor
	local name  = addon.QueueList[3]
	local contextMenuData = {{ text = L["Select Slot to Hide"], isTitle = true, notCheckable = true},}
	local profile = addon.setdb.profile.autoHideSlot

	local function GeneratorFunction(owner, rootDescription)
		rootDescription:CreateTitle(L["Select Slot to Hide"]);
		for i = 1, 19 do 
			if armor[i] then
				rootDescription:CreateCheckbox(_G[addon.Globals.INVENTORY_SLOT_NAMES[i]], function() return profile[i] end, function(data) profile[i] = not profile[i] end);
			end
		end
	end

	MenuUtil.CreateContextMenu(parent, GeneratorFunction);
end

function BW_TransmogOptionsButton_OnEnter(self)
	if not addon.Profile.ShowIncomplete then 
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(L["Requires 'Show Incomplete Sets' Enabled"])
		GameTooltip:Show()
	end
end

function BetterWardrobeTransmogVendorOptionsDropDown_OnLoad(self)
end

local dropdownOrder = {DEFAULT, ALPHABETIC, APPEARANCE, COLOR, EXPANSION, ITEM_SOURCE}
local locationDropDown = addon.Globals.locationDropDown

addon.includeLocation = {}
for i, location in pairs(locationDropDown) do
	addon.includeLocation[i] = true
end



-- Base Transmog Sets Window Upates
function UI.ExtendTransmogView(reset)
	if WardrobeFrame and addon.TransmogVendorSizeUpdated and not reset  or not WardrobeFrame then return end

	--if not addon.Profile.LargeTransmogArea or not addon.Profile.ExtraLargeTransmogArea then return end
	local scale = 1
	--BW_LoadQueueButton:ClearAllPoints()
	--BW_LoadQueueButton:SetPoint("TOPLEFT", BetterWardrobeOutfitDropDown.SaveButton, "TOPRIGHT", 5, 0)

	if addon.Profile.ExtraLargeTransmogArea then
		scale = 1.25

        local itemFrameWidth = math.floor(BetterWardrobeCollectionFrame.ItemsCollectionFrame:GetWidth()) + 5
		local screenWidth = addon.Profile.ExtraLargeTransmogAreaMax or math.floor(UIParent:GetWidth())-- 1680 --math.floor(UIParent:GetWidth())
        local frameWidth = screenWidth - itemFrameWidth
        
		WardrobeFrame:SetWidth(screenWidth)
		WardrobeFrame:SetClampedToScreen(true)
		WardrobeFrame:SetHeight(UIParent:GetHeight() -25);
        WardrobeTransmogFrame:SetWidth(frameWidth);

		WardrobeTransmogFrame:SetHeight(WardrobeFrame:GetHeight() -90);
		WardrobeTransmogFrame:SetPoint("TOPLEFT", WardrobeFrame, 4, -60)
		WardrobeTransmogFrame.ModelScene:ClearAllPoints()

		WardrobeTransmogFrame.ModelScene:SetHeight(WardrobeFrame:GetHeight() -90);

		if frameWidth > 800 then 
			WardrobeTransmogFrame.ModelScene:SetWidth(800);
			WardrobeTransmogFrame.ModelScene:SetPoint("TOP", WardrobeTransmogFrame)
			WardrobeTransmogFrame.ModelScene:SetPoint("BOTTOM", WardrobeTransmogFrame)
		else
			WardrobeTransmogFrame.ModelScene:SetPoint("TOPLEFT", WardrobeTransmogFrame, 25, -20)
			WardrobeTransmogFrame.ModelScene:SetPoint("BOTTOMRIGHT", WardrobeTransmogFrame, -25, 20)
		end
		
		WardrobeTransmogFrame.Inset.BG:SetAllPoints()
		WardrobeTransmogFrame.HeadButton:ClearAllPoints()
		
		--WardrobeTransmogFrame.HeadButton:SetPoint("TOP", WardrobeTransmogFrame.ModelScene, "TOP", math.ceil(frameWidth * -0.3), -41) -- -320
		WardrobeTransmogFrame.HeadButton:SetPoint("TOP", WardrobeTransmogFrame.ModelScene, "TOP", math.ceil(frameWidth * -0.35625), -41) -- -320

		WardrobeTransmogFrame.HandsButton:ClearAllPoints()
		--WardrobeTransmogFrame.HandsButton:SetPoint("TOP", WardrobeTransmogFrame.ModelScene, "TOP", math.floor(frameWidth * 0.3), -118) --325
		WardrobeTransmogFrame.HandsButton:SetPoint("TOP", WardrobeTransmogFrame.ModelScene, "TOP", math.floor(frameWidth * 0.35625), -118) --325

		WardrobeTransmogFrame.MainHandButton:ClearAllPoints()
		WardrobeTransmogFrame.MainHandButton:SetPoint("BOTTOM", WardrobeTransmogFrame.ModelScene, "BOTTOM", -26, 15)
		WardrobeTransmogFrame.SecondaryHandButton:ClearAllPoints()
		WardrobeTransmogFrame.SecondaryHandButton:SetPoint("BOTTOM", WardrobeTransmogFrame.ModelScene, "BOTTOM", 27, 15)
		WardrobeTransmogFrame.MainHandEnchantButton:ClearAllPoints()
		WardrobeTransmogFrame.MainHandEnchantButton:SetPoint("BOTTOM", WardrobeTransmogFrame.MainHandButton, "BOTTOM", 0, -20)
		WardrobeTransmogFrame.SecondaryHandEnchantButton:ClearAllPoints()
		WardrobeTransmogFrame.SecondaryHandEnchantButton:SetPoint("BOTTOM", WardrobeTransmogFrame.SecondaryHandButton, "BOTTOM", 0, -20)

		WardrobeTransmogFrame.ModelScene.ClearAllPendingButton:SetPoint("TOPRIGHT", WardrobeTransmogFrame, -20, -20)
		WardrobeTransmogFrame.ModelScene.ControlFrame:SetPoint("TOP", WardrobeTransmogFrame, "TOP", 0, -4)

		--BetterWardrobeOutfitDropDown:ClearAllPoints()
	--BetterWardrobeOutfitDropDown:SetPoint("TOPLEFT", WardrobeTransmogFrame, 35, 28)
		--BW_LoadQueueButton:ClearAllPoints()
		--BW_LoadQueueButton:SetPoint("TOPLEFT", BetterWardrobeOutfitDropDown, "TOPRIGHT", 85, -5)
		BetterWardrobeTMOutfitDropDown:ClearAllPoints()
		BetterWardrobeTMOutfitDropDown:SetPoint("TOPLEFT", 50, 28)

		if UIPanelWindows["WardrobeFrame"] then 
		UIPanelWindows["WardrobeFrame"].width = 1280
		else 
			UIPanelWindows["WardrobeFrame"] ={ area = "left", pushable = 0,	width = 1280 };
		end
	elseif addon.Profile.LargeTransmogArea then 
		WardrobeFrame:SetWidth(1170)
		WardrobeFrame:SetHeight(606)
		WardrobeTransmogFrame:SetWidth(500)
		WardrobeTransmogFrame:SetHeight(495)
		WardrobeTransmogFrame:ClearAllPoints()
		WardrobeTransmogFrame:SetPoint("TOPLEFT", WardrobeFrame, 4, -60)

		WardrobeTransmogFrame.ModelScene:ClearAllPoints()
		WardrobeTransmogFrame.ModelScene:SetWidth(420)
		WardrobeTransmogFrame.ModelScene:SetHeight(420)
		WardrobeTransmogFrame.ModelScene:SetPoint("TOP", WardrobeTransmogFrame, "TOP", 0, -4)

		WardrobeTransmogFrame.Inset:SetWidth(494)
		WardrobeTransmogFrame.Inset:SetHeight(495)
		WardrobeTransmogFrame.Inset:ClearAllPoints()
		WardrobeTransmogFrame.Inset:SetAllPoints()
		WardrobeTransmogFrame.Inset.BG:ClearAllPoints()
		WardrobeTransmogFrame.Inset.BG:SetAllPoints()

		WardrobeTransmogFrame.HeadButton:ClearAllPoints()
		WardrobeTransmogFrame.HeadButton:SetPoint("TOP", WardrobeTransmogFrame.ModelScene, "TOP", -208, -41)

		WardrobeTransmogFrame.HandsButton:ClearAllPoints()
		WardrobeTransmogFrame.HandsButton:SetPoint("TOP", WardrobeTransmogFrame, "TOP", 205, -118)

		WardrobeTransmogFrame.MainHandButton:ClearAllPoints()
		WardrobeTransmogFrame.MainHandButton:SetPoint("TOP", WardrobeTransmogFrame.ModelScene, "BOTTOM", -26, -5)
		WardrobeTransmogFrame.SecondaryHandButton:ClearAllPoints()
		WardrobeTransmogFrame.SecondaryHandButton:SetPoint("TOP", WardrobeTransmogFrame.ModelScene, "BOTTOM", 27, -5)
		WardrobeTransmogFrame.MainHandEnchantButton:ClearAllPoints()
		WardrobeTransmogFrame.MainHandEnchantButton:SetPoint("BOTTOM", WardrobeTransmogFrame.MainHandButton, "BOTTOM", 0, -20)
		WardrobeTransmogFrame.SecondaryHandEnchantButton:ClearAllPoints()
		WardrobeTransmogFrame.SecondaryHandEnchantButton:SetPoint("BOTTOM", WardrobeTransmogFrame.SecondaryHandButton, "BOTTOM", 0, -20)
		
		BetterWardrobeTMOutfitDropDown:ClearAllPoints()
		BetterWardrobeTMOutfitDropDown:SetPoint("TOPLEFT", 50, 28)

		--BetterWardrobeOutfitDropDown:ClearAllPoints()
		--BetterWardrobeOutfitDropDown:SetPoint("TOPLEFT", WardrobeTransmogFrame, 35, 28)
		if UIPanelWindows["WardrobeFrame"] then 
			UIPanelWindows["WardrobeFrame"].width = 1170
		else 
			UIPanelWindows["WardrobeFrame"] ={ area = "left", pushable = 0,	width = 1170 };
		end
	else 		
		WardrobeFrame:SetWidth(965)
		WardrobeFrame:SetHeight(606)
		WardrobeTransmogFrame:SetWidth(300)
		WardrobeTransmogFrame:SetHeight(495)
		WardrobeTransmogFrame:ClearAllPoints()
		WardrobeTransmogFrame:SetPoint("TOPLEFT", WardrobeFrame, 4, -86)

		WardrobeTransmogFrame.ModelScene:ClearAllPoints()
		WardrobeTransmogFrame.ModelScene:SetWidth(294)
		WardrobeTransmogFrame.ModelScene:SetHeight(488)
		WardrobeTransmogFrame.ModelScene:SetPoint("TOPLEFT", WardrobeTransmogFrame, "TOPLEFT", 2, -4)

		WardrobeTransmogFrame.Inset:SetWidth(294)
		WardrobeTransmogFrame.Inset:SetHeight(494)
		WardrobeTransmogFrame.Inset:ClearAllPoints()
		WardrobeTransmogFrame.Inset:SetAllPoints()
		WardrobeTransmogFrame.Inset.BG:ClearAllPoints()
		WardrobeTransmogFrame.Inset.BG:SetAllPoints()

		WardrobeTransmogFrame.ModelScene.ClearAllPendingButton:ClearAllPoints()
		WardrobeTransmogFrame.ModelScene.ClearAllPendingButton:SetPoint("TOPRIGHT", WardrobeTransmogFrame.ModelScene, "TOPRIGHT", -5, -10)
		
		WardrobeTransmogFrame.HeadButton:ClearAllPoints()
		WardrobeTransmogFrame.HeadButton:SetPoint("TOP", WardrobeTransmogFrame.ModelScene, "TOP", -121, -41)
		WardrobeTransmogFrame.HandsButton:ClearAllPoints()
		WardrobeTransmogFrame.HandsButton:SetPoint("TOP", WardrobeTransmogFrame.ModelScene, "TOP", 123, -118)

		WardrobeTransmogFrame.MainHandButton:ClearAllPoints()
		WardrobeTransmogFrame.MainHandButton:SetPoint("BOTTOM", WardrobeTransmogFrame.ModelScene, "BOTTOM", -26, 45)
		WardrobeTransmogFrame.SecondaryHandButton:ClearAllPoints()
		WardrobeTransmogFrame.SecondaryHandButton:SetPoint("BOTTOM", WardrobeTransmogFrame.ModelScene, "BOTTOM", 27, 45)
		WardrobeTransmogFrame.MainHandEnchantButton:ClearAllPoints()
		WardrobeTransmogFrame.MainHandEnchantButton:SetPoint("BOTTOM", WardrobeTransmogFrame.MainHandButton, "BOTTOM", 0, -20)
		WardrobeTransmogFrame.SecondaryHandEnchantButton:ClearAllPoints()
		WardrobeTransmogFrame.SecondaryHandEnchantButton:SetPoint("BOTTOM", WardrobeTransmogFrame.SecondaryHandButton, "BOTTOM", 0, -20)	
		BetterWardrobeTMOutfitDropDown:ClearAllPoints()
		BetterWardrobeTMOutfitDropDown:SetPoint("TOPLEFT", 3, 28)
		--BetterWardrobeOutfitDropDown:ClearAllPoints()
		--BetterWardrobeOutfitDropDown:SetPoint("TOPLEFT", WardrobeTransmogFrame, -14, 28)

		BW_LoadQueueButton:ClearAllPoints()
		--BW_LoadQueueButton:SetPoint("BOTTOMLEFT", BetterWardrobeOutfitDropDown.SaveButton, "TOPLEFT", 0, 5)

		if UIPanelWindows["WardrobeFrame"] then 
			UIPanelWindows["WardrobeFrame"].width = 965
		else 
			UIPanelWindows["WardrobeFrame"] ={ area = "left", pushable = 0,	width = 965 };
		end
	end


    WardrobeTransmogFrame.ToggleSecondaryAppearanceCheckbox:ClearAllPoints()
	WardrobeTransmogFrame.ToggleSecondaryAppearanceCheckbox:SetPoint("LEFT", WardrobeCollectionFrame.ItemsCollectionFrame.ModelR3C1, "LEFT", -5, -110);
    WardrobeTransmogFrame.ToggleSecondaryAppearanceCheckbox:SetFrameLevel(400)

	for i, button in pairs(	WardrobeTransmogFrame.SlotButtons) do
		button:SetScale(scale);

	end
	WardrobeTransmogFrame.ModelScene.ControlFrame:SetScale(scale)
	WardrobeTransmogFrame.ModelScene.ClearAllPendingButton:SetScale(scale)

	UpdateUIPanelPositions()
	addon.TransmogVendorSizeUpdated = true
end
addon.ExtendTransmogView = UI.ExtendTransmogView




local function UpdateSlotButtons()
	for i, button in pairs(WardrobeTransmogFrame.SlotButtons) do
		addon:SecureHook(button, "OnUserSelect", function(slotButton, fromOnClick) 
			if slotButton then
				slotButton:SetSelected(true);
				if (fromOnClick and BetterWardrobeCollectionFrame.activeFrame ~= BetterWardrobeCollectionFrame.ItemsCollectionFrame) then
					BetterWardrobeCollectionFrame:ClickTab(BetterWardrobeCollectionFrame.ItemsTab);
				end
				if ( BetterWardrobeCollectionFrame.activeFrame == BetterWardrobeCollectionFrame.ItemsCollectionFrame ) then
					local _, _, selectedSourceID = TransmogUtil.GetInfoForEquippedSlot(slotButton.transmogLocation);
					local forceGo = slotButton.transmogLocation:IsIllusion();
					local forTransmog = true;
					local effectiveCategory;
					if slotButton.transmogLocation:IsEitherHand() then
						effectiveCategory = C_Transmog.GetSlotEffectiveCategory(slotButton.transmogLocation);
					end
					BetterWardrobeCollectionFrame.ItemsCollectionFrame:GoToSourceID(selectedSourceID, slotButton.transmogLocation, forceGo, forTransmog, effectiveCategory);
					BetterWardrobeCollectionFrame.ItemsCollectionFrame:SetTransmogrifierAppearancesShown(true);
				end
			else
				BetterWardrobeCollectionFrame.ItemsCollectionFrame:SetTransmogrifierAppearancesShown(false);
			end
		end)

	end
end
