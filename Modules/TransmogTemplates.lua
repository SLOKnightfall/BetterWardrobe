local addonName, addon = ...

--[[
TransmogOutfitEntryMixin = {
	DYNAMIC_EVENTS = {
		"SPELL_UPDATE_COOLDOWN"
	};
};

function TransmogOutfitEntryMixin:OnLoad()
	self.OutfitIcon:RegisterForDrag("LeftButton");

	self.OutfitIcon:SetScript("OnEnter", function()
		local elementData = self:GetElementData();
		if not elementData then
			return;
		end

		GameTooltip:SetOwner(self.OutfitIcon, "ANCHOR_RIGHT");
		GameTooltip:SetOutfit(elementData.outfitID);
	end);

	self.OutfitIcon:SetScript("OnLeave", GameTooltip_Hide);

	self.OutfitIcon:SetScript("OnDragStart", function()
		self:PickupOutfit();
	end);

	self.OutfitButton:SetScript("OnClick", function(_button, buttonName)
		if buttonName == "LeftButton" then
			PlaySound(SOUNDKIT.UI_TRANSMOG_ITEM_CLICK);
			self:SelectEntry();
		elseif buttonName == "RightButton" then
			MenuUtil.CreateContextMenu(self, function(_owner, rootDescription)
				rootDescription:SetTag("MENU_TRANSMOG_OUTFIT_ENTRY");

				rootDescription:CreateButton(TRANSMOG_EDIT_OUTFIT_SLOT, function()
					self:OpenEditPopup();
				end);
			end);
		end
	end);

	local hideCountdownNumbers = true;
	self.OutfitIcon.Cooldown:SetHideCountdownNumbers(hideCountdownNumbers);

	local drawBling = false;
	self.OutfitIcon.Cooldown:SetDrawBling(drawBling);
end

function TransmogOutfitEntryMixin:OnShow()
	FrameUtil.RegisterFrameForEvents(self, self.DYNAMIC_EVENTS);
	self:UpdateCooldown();
end

function TransmogOutfitEntryMixin:OnHide()
	FrameUtil.UnregisterFrameForEvents(self, self.DYNAMIC_EVENTS);
end

function TransmogOutfitEntryMixin:OnEvent(event, ...)
	if event == "SPELL_UPDATE_COOLDOWN" then
		self:UpdateCooldown();
	end
end

function TransmogOutfitEntryMixin:Init(elementData)
	self.OutfitIcon.Icon:SetTexture(elementData.icon);

	self.OutfitIcon:SetScript("OnClick", function(_button, buttonName)
		local function ClickCallback()
			local allowRemoveOutfit = true;
			local toggleLock = false;

			if buttonName == "RightButton" then
				toggleLock = true;
			end

			C_TransmogOutfitInfo.ChangeDisplayedOutfit(elementData.outfitID, Enum.TransmogSituationTrigger.Manual, toggleLock, allowRemoveOutfit);
		end;

		local includeViewedOutfit = true;
		self:CheckPendingAction(ClickCallback, includeViewedOutfit);
	end);

	local activeOutfitID = C_TransmogOutfitInfo.GetActiveOutfitID();
	self.OutfitIcon.OverlayActive:SetShown(elementData.outfitID == activeOutfitID);

	local isLockedOutfit = C_TransmogOutfitInfo.IsLockedOutfit(elementData.outfitID);
	self.OutfitIcon.OverlayLocked:SetShown(isLockedOutfit);
	self.OutfitIcon.OverlayLocked:ShowAutoCastEnabled(isLockedOutfit);

	local textContent = self.OutfitButton.TextContent;
	textContent.Name:SetText(elementData.name);

	local situationText = "";
	if elementData.situationCategories then
		for index, situationCategory in ipairs(elementData.situationCategories) do
			situationText = situationText..situationCategory;

			if index ~= #elementData.situationCategories then
				situationText = situationText..TRANSMOG_SITUATION_CATEGORY_LIST_SEPARATOR;
			end
		end
	end
	textContent.SituationInfo:SetShown(situationText ~= "");
	textContent.SituationInfo:SetText(situationText);
	textContent:Layout();

	local viewedOutfitID = C_TransmogOutfitInfo.GetCurrentlyViewedOutfitID();
	self:SetSelected(elementData.outfitID == viewedOutfitID);
end

function TransmogOutfitEntryMixin:SetSelected(selected)
	self.OutfitButton.Selected:SetShown(selected);
	self.OutfitButton.TextContent.Name:SetFontObject(selected and "GameFontHighlight" or "GameFontNormal");
end

function TransmogOutfitEntryMixin:PickupOutfit()
	local elementData = self:GetElementData();
	if not elementData then
		return;
	end

	C_TransmogOutfitInfo.PickupOutfit(elementData.outfitID);
end

function TransmogOutfitEntryMixin:SelectEntry()
	local elementData = self:GetElementData();
	if not elementData then
		return;
	end

	local function SelectCallback()
		-- Call the click callback regardless, for things like changing tabs even if selecting the same outfit.
		elementData.onClickCallback();

		local viewedOutfitID = C_TransmogOutfitInfo.GetCurrentlyViewedOutfitID();
		if elementData.outfitID == viewedOutfitID then
			return;
		end

		C_TransmogOutfitInfo.ChangeViewedOutfit(elementData.outfitID);
	end;

	local includeViewedOutfit = false;
	self:CheckPendingAction(SelectCallback, includeViewedOutfit);
end

function TransmogOutfitEntryMixin:OpenEditPopup()
	local elementData = self:GetElementData();
	if not elementData then
		return;
	end

	local includeViewedOutfit = true;
	self:CheckPendingAction(elementData.onEditCallback, includeViewedOutfit);
end

function TransmogOutfitEntryMixin:CheckPendingAction(callback, includeViewedOutfit)
	local elementData = self:GetElementData();
	if not elementData or not callback then
		return;
	end

	local viewedOutfitID = C_TransmogOutfitInfo.GetCurrentlyViewedOutfitID();
	local checkPending = includeViewedOutfit or elementData.outfitID ~= viewedOutfitID;

	if checkPending and (C_TransmogOutfitInfo.HasPendingOutfitTransmogs() or C_TransmogOutfitInfo.HasPendingOutfitSituations()) then
		local dialogData = {
			confirmCallback = callback
		};
		StaticPopup_Show("TRANSMOG_PENDING_CHANGES", nil, nil, dialogData);
	else
		callback();
	end
end

function TransmogOutfitEntryMixin:UpdateCooldown()
	local cooldownInfo = C_Spell.GetSpellCooldown(Constants.TransmogOutfitDataConsts.EQUIP_TRANSMOG_OUTFIT_MANUAL_SPELL_ID);
	if cooldownInfo then
		CooldownFrame_Set(self.OutfitIcon.Cooldown, cooldownInfo.startTime, cooldownInfo.duration, cooldownInfo.isEnabled);
	else
		CooldownFrame_Clear(self.OutfitIcon.Cooldown);
	end
end


TransmogSlotMixin = {};

function TransmogSlotMixin:OnClick(buttonName)
	if not self.slotData then
		return;
	end

	local outfitSlotInfo = self:GetSlotInfo();
	if not outfitSlotInfo then
		return;
	end

	if buttonName == "LeftButton" then
		PlaySound(SOUNDKIT.UI_TRANSMOG_GEAR_SLOT_CLICK);
		self:OnSelect();
	elseif buttonName == "RightButton" then
		if outfitSlotInfo.hasPending then
			PlaySound(SOUNDKIT.UI_TRANSMOG_REVERTING_GEAR_SLOT);
			C_TransmogOutfitInfo.RevertPendingTransmog(self.slotData.transmogLocation:GetSlot(), self.slotData.transmogLocation:GetType(), self.slotData.currentWeaponOptionInfo.weaponOption);
			self:OnSelect();
		end
	end

	self:OnEnter();
end

function TransmogSlotMixin:OnEnter()
	if not self.slotData or not self.slotData.transmogLocation then
		return;
	end

	local outfitSlotInfo = self:GetSlotInfo();
	if not outfitSlotInfo then
		return;
	end

	local function ProcessErrorTooltip()
		if outfitSlotInfo.error == Enum.TransmogOutfitSlotError.Ok then
			return;
		end

		local wrapped = true;
		GameTooltip_AddErrorLine(GameTooltip, outfitSlotInfo.errorText, wrapped);
	end

	local function ProcessWarningTooltip()
		if outfitSlotInfo.warning == Enum.TransmogOutfitSlotWarning.Ok then
			return;
		end

		-- If we are also displaying an error, add a line break.
		if outfitSlotInfo.error ~= Enum.TransmogOutfitSlotError.Ok and outfitSlotInfo.errorText ~= "" then
			GameTooltip_AddBlankLineToTooltip(GameTooltip);
		end

		local wrapped = true;
		GameTooltip_AddErrorLine(GameTooltip, outfitSlotInfo.warningText, wrapped);
	end

	local transmogLocation = self.slotData.transmogLocation;
	if transmogLocation:IsIllusion() then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");

		local name = C_TransmogCollection.GetIllusionStrings(outfitSlotInfo.transmogID);
		if not name or not outfitSlotInfo.canTransmogrify or outfitSlotInfo.displayType == Enum.TransmogOutfitDisplayType.Unassigned or outfitSlotInfo.displayType == Enum.TransmogOutfitDisplayType.Hidden then
			GameTooltip:SetText(WEAPON_ENCHANTMENT);

			if outfitSlotInfo.displayType == Enum.TransmogOutfitDisplayType.Hidden then
				GameTooltip_AddColoredLine(GameTooltip, TRANSMOGRIFY_TOOLTIP_HIDDEN, TRANSMOGRIFY_FONT_COLOR);
			end
		elseif name then
			GameTooltip:AddLine(name);
		end

		ProcessErrorTooltip();
		ProcessWarningTooltip();

		GameTooltip:Show();
	else
		-- For some edgecases, a player may have a slot set to 'show equipped' with no gear in that slot, which can return the hidden appearance transmogID for correct rendering on the model.
		-- Do not show the hidden item name in this case on the tooltip.
		local isHiddenEquipped = outfitSlotInfo.displayType == Enum.TransmogOutfitDisplayType.Equipped and C_TransmogCollection.IsAppearanceHiddenVisual(outfitSlotInfo.transmogID);

		local itemID = C_TransmogCollection.GetSourceItemID(outfitSlotInfo.transmogID);
		if not itemID or not outfitSlotInfo.canTransmogrify or isHiddenEquipped or outfitSlotInfo.displayType == Enum.TransmogOutfitDisplayType.Unassigned or outfitSlotInfo.displayType == Enum.TransmogOutfitDisplayType.Hidden then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT");

			-- Use weapon option name if set.
			-- Use different names if slots are split.
			local slot = transmogLocation:GetSlot();
			local slotName = _G[transmogLocation:GetSlotName()];
			if self.slotData.currentWeaponOptionInfo.weaponOption ~= Enum.TransmogOutfitSlotOption.None then
				slotName = self.slotData.currentWeaponOptionInfo.name;
			elseif C_TransmogOutfitInfo.GetSecondarySlotState(slot) then
				if slot == Enum.TransmogOutfitSlot.ShoulderRight then
					slotName = RIGHTSHOULDERSLOT;
				elseif slot == Enum.TransmogOutfitSlot.ShoulderLeft then
					slotName = LEFTSHOULDERSLOT;
				end
			end
			GameTooltip:SetText(slotName);

			if outfitSlotInfo.displayType == Enum.TransmogOutfitDisplayType.Hidden then
				GameTooltip_AddColoredLine(GameTooltip, TRANSMOGRIFY_TOOLTIP_HIDDEN, TRANSMOGRIFY_FONT_COLOR);
			end

			ProcessErrorTooltip();
			ProcessWarningTooltip();

			GameTooltip:Show();
		elseif itemID then
			local item = Item:CreateFromItemID(itemID);
			self.itemDataLoadedCancelFunc = item:ContinueWithCancelOnItemLoad(function()
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
				GameTooltip_AddColoredLine(GameTooltip, item:GetItemName(), item:GetItemQualityColor().color);

				ProcessErrorTooltip();
				ProcessWarningTooltip();

				GameTooltip:Show();
			end);
		end
	end
end

function TransmogSlotMixin:OnLeave()
	if self.itemDataLoadedCancelFunc then
		self.itemDataLoadedCancelFunc();
		self.itemDataLoadedCancelFunc = nil;
	end

	GameTooltip:Hide();
end

function TransmogSlotMixin:OnSelect()
	local forceRefresh = false;
	self.slotData.transmogFrame:SelectSlot(self, forceRefresh);
end

function TransmogSlotMixin:Init(slotData)
	self.slotData = slotData;
	self.lastOutfitSlotInfo = nil;
end

function TransmogSlotMixin:Release()
	self:SetSelected(false);
	self:SetParent(nil);
end

function TransmogSlotMixin:GetEffectiveTransmogID()
	local outfitSlotInfo = self:GetSlotInfo();
	if not outfitSlotInfo then
		return Constants.Transmog.NoTransmogID;
	end

	return outfitSlotInfo.transmogID;
end

function TransmogSlotMixin:GetSlotInfo()
	if not self.slotData or not self.slotData.transmogLocation then
		return nil;
	end

	local slotInfo = C_TransmogOutfitInfo.GetViewedOutfitSlotInfo(self.slotData.transmogLocation:GetSlot(), self.slotData.transmogLocation:GetType(), self.slotData.currentWeaponOptionInfo.weaponOption);

	-- Some specific weapons may not be able to support illusions.
	if self.slotData.transmogLocation:IsIllusion() then
		local appearanceType = Enum.TransmogType.Appearance;
		local appearanceSlotInfo = C_TransmogOutfitInfo.GetViewedOutfitSlotInfo(self.slotData.transmogLocation:GetSlot(), appearanceType, self.slotData.currentWeaponOptionInfo.weaponOption);
		if appearanceSlotInfo then
			-- If we have a valid warning state, make sure it can show relative to other possible warnings.
			local cannotSupportIllusions = appearanceSlotInfo.transmogID ~= Constants.Transmog.NoTransmogID and not TransmogUtil.CanEnchantSource(appearanceSlotInfo.transmogID);
			if cannotSupportIllusions and slotInfo.warning < Enum.TransmogOutfitSlotWarning.WeaponDoesNotSupportIllusions then
				slotInfo.warning = Enum.TransmogOutfitSlotWarning.WeaponDoesNotSupportIllusions;
				slotInfo.warningText = TRANSMOGRIFY_ILLUSION_INVALID_ITEM;
			end
		end
	end

	return slotInfo;
end

function TransmogSlotMixin:GetSlot()
	if not self.slotData or not self.slotData.transmogLocation then
		return nil;
	end

	return self.slotData.transmogLocation:GetSlot();
end

function TransmogSlotMixin:GetTransmogLocation()
	if not self.slotData then
		return nil;
	end

	return self.slotData.transmogLocation;
end

function TransmogSlotMixin:GetCurrentWeaponOptionInfo()
	if not self.slotData then
		return nil;
	end

	return self.slotData.currentWeaponOptionInfo;
end

function TransmogSlotMixin:SetCurrentWeaponOptionInfo(weaponOptionInfo)
	if not self.slotData or not weaponOptionInfo.enabled then
		return;
	end

	self.slotData.currentWeaponOptionInfo = weaponOptionInfo;
	if self.slotData.transmogLocation:IsAppearance() then
		C_TransmogOutfitInfo.SetViewedWeaponOptionForSlot(self.slotData.transmogLocation:GetSlot(), weaponOptionInfo.weaponOption);
	end
end

function TransmogSlotMixin:SetCurrentWeaponOption(weaponOption)
	if not self.slotData then
		return false;
	end

	-- If weaponOption is not set, set to the first valid option.
	local foundWeaponOption;
	for _index, weaponOptionInfo in ipairs(self.slotData.weaponOptionsInfo) do
		if weaponOptionInfo.enabled and (not weaponOption or weaponOptionInfo.weaponOption == weaponOption) then
			self:SetCurrentWeaponOptionInfo(weaponOptionInfo);
			foundWeaponOption = true;
			break;
		end
	end

	if not foundWeaponOption and self.slotData.artifactOptionsInfo then
		for _index, artifactOptionInfo in ipairs(self.slotData.artifactOptionsInfo) do
			if artifactOptionInfo.enabled and (not weaponOption or artifactOptionInfo.weaponOption == weaponOption) then
				self:SetCurrentWeaponOptionInfo(artifactOptionInfo);
				foundWeaponOption = true;
				break;
			end
		end
	end

	return foundWeaponOption;
end


TransmogAppearanceSlotMixin = CreateFromMixins(TransmogSlotMixin);

TransmogAppearanceSlotMixin.DEFAULT_WEAPON_OPTION_INFO = {
	weaponOption = Enum.TransmogOutfitSlotOption.None,
	name = "",
	enabled = true
};

TransmogAppearanceSlotMixin.DEFAULT_ICON_SIZE = 45;

function TransmogAppearanceSlotMixin:OnLoad()
	self.SavedFrame.Anim:SetScript("OnFinished", function()
		self.SavedFrame:Hide();
		self:Update();
	end);
end

function TransmogAppearanceSlotMixin:OnShow()
	self:Update();
end

function TransmogAppearanceSlotMixin:OnTransmogrifySuccess()
	-- Don't do anything if already animating.
	if not self.slotData or self.SavedFrame:IsShown() then
		return;
	end

	self.SavedFrame:Show();
	self.SavedFrame.Anim:Restart();
end

-- Overridden.
function TransmogAppearanceSlotMixin:Init(slotData)
	TransmogSlotMixin.Init(self, slotData);

	self:RefreshWeaponOptions();

	self.FlyoutDropdown:SetupMenu(function(_dropdown, rootDescription)
		rootDescription:SetTag("MENU_TRANSMOG_WEAPON_OPTIONS");

		local function IsChecked(optionInfo)
			return optionInfo.weaponOption == self.slotData.currentWeaponOptionInfo.weaponOption;
		end

		local function SetChecked(optionInfo)
			if optionInfo == self.slotData.currentWeaponOptionInfo then
				return;
			end

			self:SetCurrentWeaponOptionInfo(optionInfo);

			if self.illusionSlotFrame then
				self.illusionSlotFrame:SetCurrentWeaponOptionInfo(self.slotData.currentWeaponOptionInfo);
			end

			-- Force update selected slot data and refresh visuals based on new weapon option.
			local forceRefresh = true;
			self.slotData.transmogFrame:SelectSlot(self, forceRefresh);
		end

		local function CreateWarningIcon(frame, option)
			-- Do not check this option if it is the current weapon option.
			if self.slotData.currentWeaponOptionInfo.weaponOption == option then
				return;
			end

			if not self.slotData.transmogLocation then
				return;
			end

			-- Only create warning if this weapon option (or any associated illusion slot) has pending changes.
			local outfitSlotInfo = C_TransmogOutfitInfo.GetViewedOutfitSlotInfo(self.slotData.transmogLocation:GetSlot(), self.slotData.transmogLocation:GetType(), option);
			local hasSlotChanges = outfitSlotInfo and (outfitSlotInfo.hasPending or outfitSlotInfo.isTransmogrified);

			local hasIllusionSlotChanges = false;
			if self.illusionSlotFrame then
				local outfitIllusionSlotInfo = C_TransmogOutfitInfo.GetViewedOutfitSlotInfo(self.illusionSlotFrame:GetTransmogLocation():GetSlot(), self.illusionSlotFrame:GetTransmogLocation():GetType(), option);
				hasIllusionSlotChanges = outfitIllusionSlotInfo and (outfitIllusionSlotInfo.hasPending or outfitIllusionSlotInfo.isTransmogrified);
			end

			if not hasSlotChanges and not hasIllusionSlotChanges then
				return;
			end

			local warningIcon = frame:AttachTexture();
			warningIcon:SetPoint("RIGHT");
			warningIcon:SetAtlas("transmog-icon-warning-small", TextureKitConstants.UseAtlasSize);
		end

		for _index, weaponOptionInfo in ipairs(self.slotData.weaponOptionsInfo) do
			local elementDescription = rootDescription:CreateRadio(weaponOptionInfo.name, IsChecked, SetChecked, weaponOptionInfo);
			elementDescription:AddInitializer(function(frame, _description, _menu)
				CreateWarningIcon(frame, weaponOptionInfo.weaponOption);
			end);
			elementDescription:SetEnabled(weaponOptionInfo.enabled);
		end

		if self.slotData.artifactOptionsInfo and #self.slotData.artifactOptionsInfo > 0 then
			rootDescription:CreateDivider();
			rootDescription:CreateTitle(TRANSMOG_ARTIFACT_OPTIONS_HEADER);

			for _index, artifactOptionInfo in ipairs(self.slotData.artifactOptionsInfo) do
				local elementDescription = rootDescription:CreateRadio(artifactOptionInfo.name, IsChecked, SetChecked, artifactOptionInfo);
				elementDescription:AddInitializer(function(frame, _description, _menu)
					CreateWarningIcon(frame, artifactOptionInfo.weaponOption);
				end);
				elementDescription:SetEnabled(artifactOptionInfo.enabled);
			end
		end
	end);
end

-- Overridden.
function TransmogAppearanceSlotMixin:Release()
	TransmogSlotMixin.Release(self);
	self:SetIllusionSlotFrame(nil);
end

function TransmogAppearanceSlotMixin:SetIllusionSlotFrame(illusionSlotFrame)
	self.illusionSlotFrame = illusionSlotFrame;
end

function TransmogAppearanceSlotMixin:GetIllusionSlotFrame()
	return self.illusionSlotFrame;
end

function TransmogAppearanceSlotMixin:SetSelected(selected)
	if not self.slotData then
		return;
	end

	self.SelectedFrame:SetShown(selected);

	if selected then
		local totalOptions = 0;
		if self.slotData.weaponOptionsInfo then
			totalOptions = totalOptions + #self.slotData.weaponOptionsInfo;
		end

		if self.slotData.artifactOptionsInfo then
			totalOptions = totalOptions + #self.slotData.artifactOptionsInfo;
		end

		self.FlyoutDropdown:SetShown(totalOptions > 1);
	else
		self.FlyoutDropdown:Hide();
	end
end

function TransmogAppearanceSlotMixin:RefreshWeaponOptions()
	if not self.slotData or not self.slotData.transmogLocation then
		return;
	end

	-- A weapon slot can have several weapon or artifact options associated with them, and players can select which option they are editing for an outfit via a dropdown.
	-- For example the main hand weapon slot may have both 1 handed and 2 handed weapon options.
	self.slotData.weaponOptionsInfo, self.slotData.artifactOptionsInfo = C_TransmogOutfitInfo.GetWeaponOptionsForSlot(self.slotData.transmogLocation:GetSlot());

	if (not self.slotData.weaponOptionsInfo or #self.slotData.weaponOptionsInfo == 0) and (not self.slotData.artifactOptionsInfo or #self.slotData.artifactOptionsInfo == 0) then
		self:SetCurrentWeaponOptionInfo(self.DEFAULT_WEAPON_OPTION_INFO);
	else
		-- See if the current weapon option still exists and is enabled. If it is, use that, otherwise select new option.
		local foundWeaponOption;
		if self.slotData.currentWeaponOptionInfo then
			foundWeaponOption = self:SetCurrentWeaponOption(self.slotData.currentWeaponOptionInfo);
		end

		-- Current option not found, select the preferred first option based on equipped gear for this slot.
		if not foundWeaponOption then
			local equippedWeaponOption = C_TransmogOutfitInfo.GetEquippedSlotOptionFromTransmogSlot(self.slotData.transmogLocation:GetSlot());
			if equippedWeaponOption then
				foundWeaponOption = self:SetCurrentWeaponOption(equippedWeaponOption);
			end
		end

		-- No current or preferred option found, select the first valid option instead.
		if not foundWeaponOption then
			local weaponOption = nil;
			foundWeaponOption = self:SetCurrentWeaponOption(weaponOption);
		end

		-- No valid options found, set to default.
		if not foundWeaponOption then
			self:SetCurrentWeaponOptionInfo(self.DEFAULT_WEAPON_OPTION_INFO);
		end
	end

	if self.illusionSlotFrame then
		self.illusionSlotFrame:SetCurrentWeaponOptionInfo(self.slotData.currentWeaponOptionInfo);
	end

	-- Close menu as it could show outdated data.
	self.FlyoutDropdown:CloseMenu();
end

function TransmogAppearanceSlotMixin:Update()
	if not self.slotData or not self.slotData.transmogLocation or not self:IsShown() then
		return;
	end

	local outfitSlotInfo = self:GetSlotInfo();
	if not outfitSlotInfo then
		return;
	end

	self:SetEnabled(outfitSlotInfo.canTransmogrify);

	-- Base icon texture.
	-- The texture will either be whatever is set in outfitSlotInfo, or the default slot texture if unset.
	if outfitSlotInfo.texture then
		self.Icon:SetTexture(outfitSlotInfo.texture);
		self.Icon:SetSize(self.DEFAULT_ICON_SIZE, self.DEFAULT_ICON_SIZE);
	else
		local unassignedAtlas = C_TransmogOutfitInfo.GetUnassignedAtlasForSlot(self.slotData.transmogLocation:GetSlot());
		if unassignedAtlas then
			self.Icon:SetAtlas(unassignedAtlas, TextureKitConstants.UseAtlasSize);
		end
	end

	-- Border art.
	local border = "transmog-gearslot-default";
	if not outfitSlotInfo.canTransmogrify then
		border = "transmog-gearslot-disabled";
	elseif outfitSlotInfo.displayType == Enum.TransmogOutfitDisplayType.Assigned then
		border = "transmog-gearslot-transmogrified";
	elseif outfitSlotInfo.displayType == Enum.TransmogOutfitDisplayType.Hidden then
		border = "transmog-gearslot-transmogrified-hidden";
	end

	self.Border:SetAtlas(border, TextureKitConstants.UseAtlasSize);
	self:SetHighlightAtlas(border, "ADD");

	-- Overlay icons.
	self.DisabledIcon:SetShown(not outfitSlotInfo.canTransmogrify);
	self.HiddenVisualIcon:SetShown(outfitSlotInfo.displayType == Enum.TransmogOutfitDisplayType.Hidden);
	self.ShowEquippedIcon:SetShown(outfitSlotInfo.displayType == Enum.TransmogOutfitDisplayType.Equipped);
	self.WarningFrame:SetShown(outfitSlotInfo.warning ~= Enum.TransmogOutfitSlotWarning.Ok);

	-- Pending frame.
	if outfitSlotInfo.hasPending and not self.SavedFrame:IsShown() then
		self.PendingFrame:Show();
		self.PendingFrame.AnimLoop:Restart();

		-- Only play the intro animation if things actually changed on the slot.
		if not self.lastOutfitSlotInfo or self.lastOutfitSlotInfo.displayType ~= outfitSlotInfo.displayType or (self.lastOutfitSlotInfo.displayType ~= Enum.TransmogOutfitDisplayType.Unassigned and self.lastOutfitSlotInfo.transmogID ~= outfitSlotInfo.transmogID) then
			self.PendingFrame.AnimStart:Restart();
		end
	else
		self.PendingFrame.AnimStart:Stop();
		self.PendingFrame.AnimLoop:Stop();
		self.PendingFrame:Hide();
	end

	self.lastOutfitSlotInfo = outfitSlotInfo;
end


TransmogSlotFlyoutDropdownMixin = CreateFromMixins(ButtonStateBehaviorMixin);

-- Overridden.
function TransmogSlotFlyoutDropdownMixin:OnButtonStateChanged()
	local atlas = self:IsDown() and "transmog-button-pullup-pressed" or "transmog-button-pullup";
	self:SetHighlightAtlas(atlas, "ADD");
end

-- Overridden.
function TransmogSlotFlyoutDropdownMixin:OnMenuOpened(menu)
	DropdownButtonMixin.OnMenuOpened(self, menu);

	self:SetNormalAtlas("transmog-button-pullup-open", TextureKitConstants.UseAtlasSize);
	HelpTip:HideAllSystem("TransmogCharacter");
end

-- Overridden.
function TransmogSlotFlyoutDropdownMixin:OnMenuClosed(menu)
	DropdownButtonMixin.OnMenuClosed(self, menu);

	self:SetNormalAtlas("transmog-button-pullup", TextureKitConstants.UseAtlasSize);
end


TransmogIllusionSlotMixin = CreateFromMixins(TransmogSlotMixin);

function TransmogIllusionSlotMixin:OnLoad()
	self.SavedFrame.Anim:SetScript("OnFinished", function()
		self.SavedFrame:Hide();
		self:Update();
	end);
end

function TransmogIllusionSlotMixin:OnShow()
	self:Update();
end

function TransmogIllusionSlotMixin:OnTransmogrifySuccess()
	-- Don't do anything if already animating.
	if not self.slotData or self.SavedFrame:IsShown() then
		return;
	end

	self.SavedFrame:Show();
	self.SavedFrame.Anim:Restart();
end

function TransmogIllusionSlotMixin:SetSelected(selected)
	self.SelectedFrame:SetShown(selected);
end

function TransmogIllusionSlotMixin:Update()
	if not self.slotData or not self.slotData.transmogLocation or not self:IsShown() then
		return;
	end

	local outfitSlotInfo = self:GetSlotInfo();
	if not outfitSlotInfo then
		return;
	end

	self:SetEnabled(outfitSlotInfo.canTransmogrify);

	-- Base icon texture.
	-- The texture will either be whatever is set in outfitSlotInfo, or the default slot texture if unset.
	if outfitSlotInfo.texture then
		self.Icon:SetTexture(outfitSlotInfo.texture);
	else
		self.Icon:SetAtlas("transmog-gearslot-unassigned-enchant", TextureKitConstants.UseAtlasSize);
	end

	-- Border art.
	local border = "transmog-gearslot-default-small";
	if not outfitSlotInfo.canTransmogrify then
		border = "transmog-gearslot-disabled-small";
	elseif outfitSlotInfo.displayType == Enum.TransmogOutfitDisplayType.Assigned then
		border = "transmog-gearslot-transmogrified-small";
	elseif outfitSlotInfo.displayType == Enum.TransmogOutfitDisplayType.Hidden then
		border = "transmog-gearslot-transmogrified-hidden-small";
	end

	self.Border:SetAtlas(border, TextureKitConstants.UseAtlasSize);
	self:SetHighlightAtlas(border, "ADD");

	-- Overlay icons.
	self.DisabledIcon:SetShown(not outfitSlotInfo.canTransmogrify);
	self.HiddenVisualIcon:SetShown(outfitSlotInfo.displayType == Enum.TransmogOutfitDisplayType.Hidden);
	self.ShowEquippedIcon:SetShown(outfitSlotInfo.displayType == Enum.TransmogOutfitDisplayType.Equipped);
	self.WarningFrame:SetShown(outfitSlotInfo.warning ~= Enum.TransmogOutfitSlotWarning.Ok);

	-- Pending frame.
	if outfitSlotInfo.hasPending and not self.SavedFrame:IsShown() then
		self.PendingFrame:Show();
		self.PendingFrame.AnimLoop:Restart();

		-- Only play the intro animation if things actually changed on the slot.
		if not self.lastOutfitSlotInfo or self.lastOutfitSlotInfo.displayType ~= outfitSlotInfo.displayType or (self.lastOutfitSlotInfo.displayType ~= Enum.TransmogOutfitDisplayType.Unassigned and self.lastOutfitSlotInfo.transmogID ~= outfitSlotInfo.transmogID) then
			self.PendingFrame.AnimStart:Restart();
		end
	else
		self.PendingFrame.AnimStart:Stop();
		self.PendingFrame.AnimLoop:Stop();
		self.PendingFrame:Hide();
	end

	self.lastOutfitSlotInfo = outfitSlotInfo;
end


local TransmogWardrobeCollectionTabMixin = {};
BW_TransmogWardrobeCollectionTabMixin = TransmogWardrobeCollectionTabMixin

function TransmogWardrobeCollectionTabMixin:SetTabSelected(isSelected)
	TabSystemButtonArtMixin.SetTabSelected(self, isSelected);

	self.SelectedHighlight:SetShown(isSelected);
end
]]--

local TransmogSearchBoxMixin = {
	WARDROBE_SEARCH_DELAY = 0.6;
};

BW_TransmogSearchBoxMixin = TransmogSearchBoxMixin

function TransmogSearchBoxMixin:OnHide()
	self:SetText("");
	self.ProgressFrame:Hide();
end

function TransmogSearchBoxMixin:OnUpdate(elapsed)
	if not self.searchType or not self.checkProgress then
		return;
	end

	self.updateDelay = self.updateDelay + elapsed;

	if not C_TransmogCollection.IsSearchInProgress(self.searchType) then
		self.checkProgress = false;
	elseif self.updateDelay >= self.WARDROBE_SEARCH_DELAY then
		self.checkProgress = false;
		if not C_TransmogCollection.IsSearchDBLoading() then
			self.ProgressFrame:ShowProgressBar();
		else
			self.ProgressFrame:ShowLoadingFrame();
		end
	end
end

-- Overridden.
function TransmogSearchBoxMixin:OnTextChanged()
	SearchBoxTemplate_OnTextChanged(self);

	self:UpdateSearch();
end

function TransmogSearchBoxMixin:SetSearchType(searchType)
	self.searchType = searchType;
	self.ProgressFrame:SetSearchType(searchType);
end

function TransmogSearchBoxMixin:Reset()
	if not self.searchType then
		return;
	end

	self:SetText("");
	self.ProgressFrame:Hide();
	self.updateDelay = 0;
	self.checkProgress = false;
	C_TransmogCollection.ClearSearch(self.searchType);
end

function addon:SearchSets(data)
	local tab = TransmogFrame and TransmogFrame.WardrobeCollection:GetTab()
	if not tab then return  false end

	local query = TransmogFrame and TransmogFrame.WardrobeCollection.TabContent.ExtraSetsFrame.SearchBox:GetText()  or ""
	
	if tab == 5 then
		query = TransmogFrame and TransmogFrame.WardrobeCollection.TabContent.SetsFrame2.SearchBox:GetText()  or ""
	end

	if query == "" then return true end
	query = string.lower(query)

	local name = data.name and string.find(string.lower(data.name), query, 1, true) 
	local label = data.label and string.find(string.lower(data.label), query, 1, true)
	if name then
		return true
	end

	if label then
		return true
	end

	return false
end

function TransmogSearchBoxMixin:UpdateSearch()
	if not self.searchType then
		return;
	end

	local tab = TransmogFrame.WardrobeCollection:GetTab()

	if self:GetText() == "" then
		C_TransmogCollection.ClearSearch(self.searchType);
		TransmogFrame.WardrobeCollection.TabContent.ExtraSetsFrame:RefreshCollectionEntries()
	else
		if tab == 5 then
			C_TransmogCollection.SetSearch(self.searchType, self:GetText());
		else
			TransmogFrame.WardrobeCollection.TabContent.ExtraSetsFrame:RefreshCollectionEntries()
		end
	end

	-- Restart search tracking.
	self.ProgressFrame:Hide();
	self.updateDelay = 0;
	self.checkProgress = true;
end

--[[
local TransmogSearchBoxProgressMixin = {
	MIN_VALUE = 0;
	MAX_VALUE = 1000;
};

function TransmogSearchBoxProgressMixin:OnLoad()
	self.ProgressBar:SetStatusBarColor(0, .6, 0, 1);
	self.ProgressBar:SetMinMaxValues(self.MIN_VALUE, self.MAX_VALUE);
	self.ProgressBar:SetValue(0);
	self.ProgressBar:GetStatusBarTexture():SetDrawLayer("BORDER");
end

function TransmogSearchBoxProgressMixin:OnHide()
	self.ProgressBar:SetValue(0);
end

function TransmogSearchBoxProgressMixin:OnUpdate(_elapsed)
	if not self.searchType then
		return;
	end

	if self.updateProgressBar then
		if not C_TransmogCollection.IsSearchInProgress(self.searchType) then
			self:Hide();
		else
			local _minValue, maxValue = self.ProgressBar:GetMinMaxValues();
			local searchSize = C_TransmogCollection.SearchSize(self.searchType);
			if searchSize == 0 then
				self.ProgressBar:SetValue(0);
			else
				local searchProgress = C_TransmogCollection.SearchProgress(self.searchType);
				self.ProgressBar:SetValue((searchProgress * maxValue) / searchSize);
			end
		end
	end
end

function TransmogSearchBoxProgressMixin:SetSearchType(searchType)
	self.searchType = searchType;
end

function TransmogSearchBoxProgressMixin:ShowLoadingFrame()
	self.LoadingFrame:Show();
	self.ProgressBar:Hide();
	self.updateProgressBar = false;
	self:Show();
end

function TransmogSearchBoxProgressMixin:ShowProgressBar()
	self.LoadingFrame:Hide();
	self.ProgressBar:Show();
	self.updateProgressBar = true;
	self:Show();
end

local TransmogItemModelMixin = CreateFromMixins(ItemModelBaseMixin);
BW_TransmogItemModelMixin = TransmogItemModelMixin

TransmogItemModelMixin.DYNAMIC_EVENTS = {
	"VIEWED_TRANSMOG_OUTFIT_CHANGED",
	"VIEWED_TRANSMOG_OUTFIT_SLOT_REFRESH"
};

-- Overridden.
function TransmogItemModelMixin:OnLoad()
	ItemModelBaseMixin.OnLoad(self);

	self.SavedFrame.Anim:SetScript("OnFinished", function()
		self.SavedFrame:Hide();
	end);
end

-- Overridden.
function TransmogItemModelMixin:OnEnter()
	ItemModelBaseMixin.OnEnter(self);

	local appearanceInfo = self:GetAppearanceInfo();
	if not appearanceInfo then
		return;
	end

	if C_TransmogCollection.IsNewAppearance(appearanceInfo.visualID) then
		C_TransmogCollection.ClearNewAppearance(appearanceInfo.visualID);

		self.NewVisual:Hide();
	end
end

-- Overridden.
function TransmogItemModelMixin:OnShow()
	FrameUtil.RegisterFrameForEvents(self, self.DYNAMIC_EVENTS);

	-- Don't call into base method, as it would mess with the below check.
	if self.needsReload then
		self:Reload();
	end

	self:UpdateItem();
end

function TransmogItemModelMixin:OnHide()
	FrameUtil.UnregisterFrameForEvents(self, self.DYNAMIC_EVENTS);
end

function TransmogItemModelMixin:OnEvent(event, ...)
	if event == "VIEWED_TRANSMOG_OUTFIT_CHANGED" or event == "VIEWED_TRANSMOG_OUTFIT_SLOT_REFRESH" then
		self:UpdateItemBorder();
	end
end

-- Overridden.
function TransmogItemModelMixin:GetAppearanceInfo()
	if not self.elementData then
		return nil;
	end

	return self.elementData.appearanceInfo;
end

-- Overridden.
function TransmogItemModelMixin:GetCollectionFrame()
	if not self.elementData then
		return nil;
	end

	return self.elementData.collectionFrame;
end

-- Overridden.
function TransmogItemModelMixin:GetAppearanceLink()
	local link = nil;
	local appearanceInfo = self:GetAppearanceInfo();
	local itemsCollectionFrame = self:GetCollectionFrame();
	if not appearanceInfo or not itemsCollectionFrame then
		return link;
	end

	local sources = CollectionWardrobeUtil.GetSortedAppearanceSourcesForClass(appearanceInfo.visualID, C_TransmogCollection.GetClassFilter(), itemsCollectionFrame:GetActiveCategory(), itemsCollectionFrame:GetTransmogLocation());

	local primarySourceID = itemsCollectionFrame:GetChosenVisualSource(appearanceInfo.visualID);
	local sourceIndex = CollectionWardrobeUtil.GetDefaultSourceIndex(sources, primarySourceID);
	local index = CollectionWardrobeUtil.GetValidIndexForNumSources(sourceIndex, #sources);
	local preferArtifact = TransmogUtil.IsCategoryLegionArtifact(itemsCollectionFrame:GetActiveCategory());
	link = CollectionWardrobeUtil.GetAppearanceItemHyperlink(sources[index], preferArtifact);

	return link;
end

-- Overridden.
function TransmogItemModelMixin:CanCheckDressUpClick()
	return false;
end

-- Overridden.
function TransmogItemModelMixin:UpdateCamera()
	self.cameraID = nil;

	local appearanceInfo = self:GetAppearanceInfo();
	local itemsCollectionFrame = self:GetCollectionFrame();
	if not appearanceInfo or not itemsCollectionFrame then
		return;
	end

	local transmogLocation = itemsCollectionFrame:GetTransmogLocation();
	if transmogLocation:IsIllusion() then
		-- For illusions, the source should match the corresponding appearance slot.
		local transmogID = Constants.Transmog.NoTransmogID;
		local cameraVariation;

		-- First see if the appearance slot has a visual we can use.
		local appearanceType = Enum.TransmogType.Appearance;
		local appearanceSlotFrame = itemsCollectionFrame:GetSlotFrameCallback(transmogLocation:GetSlot(), appearanceType);
		if appearanceSlotFrame then
			local appearanceSlotTransmogLocation = appearanceSlotFrame:GetTransmogLocation();
			if appearanceSlotTransmogLocation then
				local checkSecondary = appearanceSlotTransmogLocation:GetSlotName() == "SHOULDERSLOT" and itemsCollectionFrame:HasActiveSecondaryAppearance();
				cameraVariation = TransmogUtil.GetCameraVariation(appearanceSlotTransmogLocation, checkSecondary);
			end

			local outfitSlotInfo = appearanceSlotFrame:GetSlotInfo();
			if outfitSlotInfo then
				transmogID = outfitSlotInfo.transmogID;
			end
		end

		if transmogID == Constants.Transmog.NoTransmogID or self:ShouldLocationUseDefaultVisual() then
			local itemModifiedAppearanceID = C_TransmogOutfitInfo.GetIllusionDefaultIMAIDForCollectionType(itemsCollectionFrame:GetActiveCategory());
			if itemModifiedAppearanceID then
				transmogID = itemModifiedAppearanceID;
			end
		end

		if transmogID ~= Constants.Transmog.NoTransmogID then
			self.cameraID = C_TransmogCollection.GetAppearanceCameraIDBySource(transmogID, cameraVariation);
		end
	else
		local checkSecondary = transmogLocation:GetSlotName() == "SHOULDERSLOT" and itemsCollectionFrame:HasActiveSecondaryAppearance();
		local cameraVariation = TransmogUtil.GetCameraVariation(transmogLocation, checkSecondary);
		self.cameraID = C_TransmogCollection.GetAppearanceCameraID(appearanceInfo.visualID, cameraVariation);
	end
end

function TransmogItemModelMixin:Init(elementData)
	self.elementData = elementData;
	if not self.elementData then
		return;
	end

	self:RefreshItemCamera();
	self.needsReload = true;
end

function TransmogItemModelMixin.Reset(framePool, self)
	Pool_HideAndClearAnchors(framePool, self);
	self.elementData = nil;
end

function TransmogItemModelMixin:UpdateItemBorder()
	local appearanceInfo = self:GetAppearanceInfo();
	local itemsCollectionFrame = self:GetCollectionFrame();
	if not appearanceInfo or not itemsCollectionFrame then
		return;
	end

	local transmogStateAtlas;

	local selectedSlotData = itemsCollectionFrame:GetSelectedSlotCallback();
	if not selectedSlotData or not selectedSlotData.transmogLocation then
		return;
	end

	local outfitSlotInfo = C_TransmogOutfitInfo.GetViewedOutfitSlotInfo(selectedSlotData.transmogLocation:GetSlot(), selectedSlotData.transmogLocation:GetType(), selectedSlotData.currentWeaponOptionInfo.weaponOption);

	local sourceID = appearanceInfo.sourceID;
	if selectedSlotData.transmogLocation:IsAppearance() then
		sourceID = itemsCollectionFrame:GetAnAppearanceSourceFromVisual(appearanceInfo.visualID, nil);
	end

	if outfitSlotInfo and sourceID == outfitSlotInfo.transmogID and outfitSlotInfo.displayType ~= Enum.TransmogOutfitDisplayType.Unassigned and outfitSlotInfo.displayType ~= Enum.TransmogOutfitDisplayType.Equipped then
		if outfitSlotInfo.hasPending then
			transmogStateAtlas = "transmog-itemcard-transmogrified-pending";
		else
			transmogStateAtlas = "transmog-itemcard-transmogrified";
		end
	end

	if transmogStateAtlas then
		self.StateTexture:SetAtlas(transmogStateAtlas, TextureKitConstants.UseAtlasSize);
		self.StateTexture:Show();

		if outfitSlotInfo.hasPending then
			self.PendingFrame:Show();
			self.PendingFrame.Anim:Restart();
		else
			self.PendingFrame.Anim:Stop();
			self.PendingFrame:Hide();
		end

		if itemsCollectionFrame:GetOutfitSlotSavedState() then
			self.SavedFrame:Show();
			self.SavedFrame.Anim:Restart();

			local outfitSlotSaved = false;
			itemsCollectionFrame:SetOutfitSlotSavedState(outfitSlotSaved);
		end
	else
		self.StateTexture:Hide();

		self.PendingFrame.Anim:Stop();
		self.PendingFrame:Hide();
	end
end

function TransmogItemModelMixin:UpdateItem()
	local appearanceInfo = self:GetAppearanceInfo();
	local itemsCollectionFrame = self:GetCollectionFrame();
	if not appearanceInfo or not itemsCollectionFrame then
		return;
	end

	-- Base Appearance
	local isArmor;
	local appearanceVisualID;
	local appearanceVisualSubclass;
	local transmogLocation = itemsCollectionFrame:GetTransmogLocation();
	if transmogLocation:IsIllusion() then
		-- For illusions, the visual should match the corresponding appearance slot.
		local transmogID = Constants.Transmog.NoTransmogID;

		-- First see if the appearance slot has a visual we can use.
		local appearanceType = Enum.TransmogType.Appearance;
		local appearanceSlotFrame = itemsCollectionFrame:GetSlotFrameCallback(transmogLocation:GetSlot(), appearanceType);
		if appearanceSlotFrame then
			local outfitSlotInfo = appearanceSlotFrame:GetSlotInfo();
			if outfitSlotInfo then
				transmogID = outfitSlotInfo.transmogID;
			end
		end

		if transmogID == Constants.Transmog.NoTransmogID or self:ShouldLocationUseDefaultVisual() then
			local itemModifiedAppearanceID = C_TransmogOutfitInfo.GetIllusionDefaultIMAIDForCollectionType(itemsCollectionFrame:GetActiveCategory());
			if itemModifiedAppearanceID then
				transmogID = itemModifiedAppearanceID;
			end
		end

		if transmogID ~= Constants.Transmog.NoTransmogID then
			local appearanceSourceInfo = C_TransmogCollection.GetAppearanceSourceInfo(transmogID);
			if appearanceSourceInfo then
				appearanceVisualID = appearanceSourceInfo.itemAppearanceID;
				appearanceVisualSubclass = appearanceSourceInfo.itemSubclass;
			end
		end
	else
		local selectedSlotData = itemsCollectionFrame:GetSelectedSlotCallback();
		if selectedSlotData and selectedSlotData.transmogLocation then
			local collectionInfo = C_TransmogOutfitInfo.GetCollectionInfoForSlotAndOption(selectedSlotData.transmogLocation:GetSlot(), selectedSlotData.currentWeaponOptionInfo.weaponOption, itemsCollectionFrame:GetActiveCategory());
			isArmor = not collectionInfo or not collectionInfo.isWeapon;
		end
	end

	local canDisplayVisuals = transmogLocation:IsIllusion() or appearanceInfo.canDisplayOnPlayer;
	if not canDisplayVisuals then
		if isArmor then
			self:UndressSlot(transmogLocation:GetSlotID());
		else
			self:ClearModel();
		end
	elseif isArmor then
		local sourceID = itemsCollectionFrame:GetAnAppearanceSourceFromVisual(appearanceInfo.visualID, nil);
		self:TryOn(sourceID);
	elseif appearanceVisualID then
		-- appearanceVisualID is only set when looking at enchants
		self:SetItemAppearance(appearanceVisualID, appearanceInfo.visualID, appearanceVisualSubclass);
	else
		self:SetItemAppearance(appearanceInfo.visualID);
	end

	-- Border State FX
	self:UpdateItemBorder();

	-- Icons
	self.FavoriteVisual:SetShown(appearanceInfo.isFavorite);
	self.HideVisual:SetShown(appearanceInfo.isHideVisual);

	local isNewAppearance = C_TransmogCollection.IsNewAppearance(appearanceInfo.visualID);
	self.NewVisual:SetShown(isNewAppearance);
end

function TransmogItemModelMixin:RefreshItemCamera()
	self:UpdateCamera();
	self:RefreshCamera();
	if self.cameraID then
		Model_ApplyUICamera(self, self.cameraID);
	end
end

function TransmogItemModelMixin:ShouldLocationUseDefaultVisual()
	local useDefaultVisual = false;

	local itemsCollectionFrame = self:GetCollectionFrame();
	if not itemsCollectionFrame then
		useDefaultVisual = true;
		return useDefaultVisual;
	end

	local transmogLocation = itemsCollectionFrame:GetTransmogLocation();
	if transmogLocation:IsIllusion() then
		local slotFrame = itemsCollectionFrame:GetSlotFrameCallback(transmogLocation:GetSlot(), transmogLocation:GetType());
		if slotFrame then
			local outfitSlotInfo = slotFrame:GetSlotInfo();
			if outfitSlotInfo then
				useDefaultVisual = outfitSlotInfo.warning == Enum.TransmogOutfitSlotWarning.WeaponDoesNotSupportIllusions;
			end
		end
	end

	return useDefaultVisual;
end

]]--

local function UpdateOutfit(slot, type, appearance)
	if not appearance then return end
	local info = C_TransmogCollection.GetSourceInfo(appearance)
	local categoryID = (info and info.categoryID) or 0
	local display = (info and  info.isHideVisual and 3) or (info and  not info.isHideVisual and 1) or (not info and 0)
	local option = 0

	if slot == Enum.TransmogOutfitSlot.WeaponMainHand or slot == Enum.TransmogOutfitSlot.WeaponOffHand then
		local spec = GetSpecializationInfo(GetSpecialization())
	
		if (categoryID >= 12 and categoryID <= 17 ) or  categoryID == 28 then
			option = Enum.TransmogOutfitSlotOption.OneHandedWeapon
		elseif categoryID == 18 then
			option = Enum.TransmogOutfitSlotOption.Shield
		elseif categoryID == 19 then
			option = Enum.TransmogOutfitSlotOption.OffHand
		elseif categoryID >= 20 and categoryID <= 24  then
			if spec == 72 then
				option = Enum.TransmogOutfitSlotOption.FuryTwoHandedWeapon
			end
			option = Enum.TransmogOutfitSlotOption.TwoHandedWeapon
		elseif categoryID >= 25 and categoryID <= 27  then
			option = Enum.TransmogOutfitSlotOption.RangedWeapon
		end
	end
	C_TransmogOutfitInfo.SetPendingTransmog(slot, type, option, appearance, display)
end

local function ApplyOutfit(outfit)
	if outfit ~= nil then
		C_TransmogOutfitInfo.ClearAllPendingTransmogs()
		UpdateOutfit(Enum.TransmogOutfitSlot.Head, Enum.TransmogType.Appearance, outfit[1])
		UpdateOutfit(Enum.TransmogOutfitSlot.ShoulderRight, Enum.TransmogType.Appearance, outfit[3])
		UpdateOutfit(Enum.TransmogOutfitSlot.Body, Enum.TransmogType.Appearance, outfit[4])
		UpdateOutfit(Enum.TransmogOutfitSlot.Chest, Enum.TransmogType.Appearance, outfit[5])
		UpdateOutfit(Enum.TransmogOutfitSlot.Waist, Enum.TransmogType.Appearance, outfit[6])
		UpdateOutfit(Enum.TransmogOutfitSlot.Legs, Enum.TransmogType.Appearance, outfit[7])
		UpdateOutfit(Enum.TransmogOutfitSlot.Feet, Enum.TransmogType.Appearance, outfit[8])
		UpdateOutfit(Enum.TransmogOutfitSlot.Wrist, Enum.TransmogType.Appearance, outfit[9])
		UpdateOutfit(Enum.TransmogOutfitSlot.Hand ,Enum.TransmogType.Appearance, outfit[10])
		UpdateOutfit(Enum.TransmogOutfitSlot.Back, Enum.TransmogType.Appearance, outfit[15])
		UpdateOutfit(Enum.TransmogOutfitSlot.WeaponMainHand, Enum.TransmogType.Appearance, outfit[16])
		UpdateOutfit(Enum.TransmogOutfitSlot.WeaponOffHand, Enum.TransmogType.Appearance, outfit[17])
		UpdateOutfit(Enum.TransmogOutfitSlot.Tabard, Enum.TransmogType.Appearance, outfit[19])
		UpdateOutfit(Enum.TransmogOutfitSlot.WeaponMainHand, Enum.TransmogType.Illusion, outfit["mainHandEnchant"])
		UpdateOutfit(Enum.TransmogOutfitSlot.WeaponOffHand, Enum.TransmogType.Illusion, outfit["offHandEnchant"])
	end
end

local function getSourceSlots(data)
	local sources = {}
	for _index, primaryAppearance in pairs(data) do
		local sourceInfo = C_TransmogCollection.GetSourceInfo(primaryAppearance.appearanceID);
		local categoryID = sourceInfo.invType-1
		sources[categoryID] =primaryAppearance.appearanceID

	end
	return sources
end

local TransmogSetBaseModelMixin = {
	DYNAMIC_EVENTS = {
		"VIEWED_TRANSMOG_OUTFIT_SLOT_REFRESH",
		"PLAYER_EQUIPMENT_CHANGED"
	};
};

BW_TransmogSetBaseModelMixin = TransmogSetBaseModelMixin

function TransmogSetBaseModelMixin:OnLoad()
	self:SetAutoDress(false);
	self:FreezeAnimation(0, 0, 0);
	local x, y, z = self:TransformCameraSpaceToModelSpace(CreateVector3D(0, 0, -0.25)):GetXYZ();
	self:SetPosition(x, y, z);

	local enabled = true;
	local lightValues = {
		omnidirectional = false,
		point = CreateVector3D(-1, 1, -1),
		ambientIntensity = 1,
		ambientColor = CreateColor(1, 1, 1),
		diffuseIntensity = 0,
		diffuseColor = CreateColor(1, 1, 1)
	};
	self:SetLight(enabled, lightValues);
end

function TransmogSetBaseModelMixin:OnShow()
	FrameUtil.RegisterFrameForEvents(self, self.DYNAMIC_EVENTS);
	local blend = false;
	self:SetUnit("player", blend, PlayerUtil.ShouldUseNativeFormInModelScene());

	self:UpdateSet();
end

function TransmogSetBaseModelMixin:OnHide()
	FrameUtil.UnregisterFrameForEvents(self, self.DYNAMIC_EVENTS);

	self.SavedFrame.Anim:SetScript("OnFinished", function()
		self.SavedFrame:Hide();
	end);
end

function TransmogSetBaseModelMixin:OnEnter()
	self:RefreshTooltip();
end

function TransmogSetBaseModelMixin:OnLeave()
	GameTooltip:Hide();
end

function TransmogSetBaseModelMixin:OnEvent(event, ...)
	if event == "VIEWED_TRANSMOG_OUTFIT_SLOT_REFRESH" or event == "PLAYER_EQUIPMENT_CHANGED" then
		self:UpdateSet();
	end
end

function TransmogSetBaseModelMixin:OnModelLoaded()
	if self.cameraID then
		Model_ApplyUICamera(self, self.cameraID);
	end
end

function TransmogSetBaseModelMixin:UpdateCamera()
	local _detailsCameraID, transmogCameraID = C_TransmogSets.GetCameraIDs();
	self.cameraID = transmogCameraID;
end

function TransmogSetBaseModelMixin:RefreshSetCamera()
	self:UpdateCamera();
	self:RefreshCamera();
	if self.cameraID then
		Model_ApplyUICamera(self, self.cameraID);
	end
end

function TransmogSetBaseModelMixin:UpdateSet()
	-- Override in your mixin.
end

function TransmogSetBaseModelMixin:RefreshTooltip()
	-- Override in your mixin.
end


local TransmogSetModelMixin = {};
BW_TransmogSetModelMixin = TransmogSetModelMixin

function TransmogSetModelMixin:OnMouseDown(button)
	if not self.elementData then
		return;
	end

	if button == "LeftButton" then
		local sources = getSourceSlots(self.elementData.sourceData.primaryAppearances)
		ApplyOutfit(sources)
		PlaySound(SOUNDKIT.UI_TRANSMOG_ITEM_CLICK);
	end
end

--Function for creating a link in chat for sharing a set as an outfit.
local function LinkSetInChat(itemTransmogInfoList)
  local hyperlink = C_TransmogCollection.GetCustomSetHyperlinkFromItemTransmogInfoList(itemTransmogInfoList)
  if not ChatEdit_InsertLink(hyperlink) then
    ChatFrame_OpenChat(hyperlink);
  end
end

--(Modified)
function TransmogSetModelMixin:OnMouseUp(button)
	if not self.elementData then
		return;
	end

	if button ~= "RightButton" then
		return;
	end

	MenuUtil.CreateContextMenu(self, function(_owner, rootDescription)
		rootDescription:SetTag("MENU_TRANSMOG_SETS_MODEL_FILTER");

		local isFavorite, isGroupFavorite = false, false
		local setType = self.elementData.setType

		if setType == "Blizzard" then
			isFavorite, isGroupFavorite = C_TransmogSets.GetIsFavorite(self.elementData.set.setID);
			setType = "set"
		else
			isFavorite, isGroupFavorite =  addon.favoritesDB.profile.extraset[self.elementData.set.setID], true --C_TransmogSets.GetIsFavorite(self.elementData.set.setID);
			setType = "extraset"
		end

		local isHidden = self.elementData.hidden
		local text = isHidden and SHOW or HIDE;
		rootDescription:CreateButton(text, function()
			addon.HiddenAppearanceDB.profile[setType][self.elementData.setID] = not isHidden
			TransmogFrame.WardrobeCollection.TabContent.SetsFrame2:RefreshCollectionEntries()
			TransmogFrame.WardrobeCollection.TabContent.ExtraSetsFrame:RefreshCollectionEntries()
		end);


		--TODO: handle extra set
		--check if extra set
		--selecte extra set

		local text = isFavorite and TRANSMOG_ITEM_UNSET_FAVORITE or TRANSMOG_ITEM_SET_FAVORITE;
		rootDescription:CreateButton(text, function()
			self:ToggleFavorite(not isFavorite, isGroupFavorite);
		end);

		rootDescription:CreateButton(TRANSMOG_SET_OPEN_COLLECTION, function()
			if self.elementData.setType == "Blizzard" then
				TransmogUtil.OpenCollectionToSet(self.elementData.set.setID);
			else
				--TransmogUtil.OpenCollectionToSet(self.elementData.setID);
				if TransmogUtil.OpenCollectionUI() then
				
					BetterWardrobeCollectionFrame:SetTab(3)
						C_Timer.After(0.5, function() 
							BetterWardrobeCollectionFrame:GoToSet(self.elementData.setID); 
						end)
				end

			end
		end)

--TODO: ENabl
--[[
		--local itemTransmogInfoList = self.elementData.collectionFrame:GetItemTransmogInfoListCallback();
		--if DressUpFrameLinkingSupported() then
			rootDescription:CreateButton("Link in Chat", function()
				if self.elementData.setType == "Blizzard" then
					if self.elementData.setID then
						--LinkSetInChat(C_TransmogCollection.GetCustomSetItemTransmogInfoList(self.elementData.setID));
					end
				else
					 transmogInfo = {}
					customSetTransmogInfo = self.elementData
					for slotID, itemTransmogInfo in ipairs(customSetTransmogInfo.sourceData.primaryAppearances) do
						print(slotID)
						if itemTransmogInfo then
							 itemTransmogInfo2 = ItemUtil.CreateItemTransmogInfo(itemTransmogInfo.appearanceID);
							transmogInfo[slotID] = itemTransmogInfo2
						end
					end
					LinkSetInChat(transmogInfo)
									end
			end);
		--end
]]--
		end);
		
end

-- Overridden. (modified)
function TransmogSetModelMixin:UpdateSet()
	if not self.elementData then
		return;
	end

	-- Base Appearance
	for _index, primaryAppearance in ipairs(self.elementData.sourceData.primaryAppearances) do
		self:TryOn(primaryAppearance.appearanceID);
	end

	self.TitleBar.Text:SetText(self.elementData.name)

	local collected = (self.elementData.set and self.elementData.set.collected) or 
	( self.elementData.pieces and self.elementData.pieces > 0 and self.elementData.collected == self.elementData.pieces )

	-- Border State FX
	local borderAtlas = collected and "transmog-setcard-default" or "transmog-setcard-incomplete";
	self.Border:SetAtlas(borderAtlas);
	self.Highlight:SetAtlas(borderAtlas);
	self.IncompleteOverlay:SetShown(not collected);

	local transmogStateAtlas;
	local appliedSetID, hasPending = self.elementData.collectionFrame:GetFirstMatchingSetID();
	if self.elementData.set.setID == appliedSetID then
		if hasPending then
			transmogStateAtlas = "transmog-setcard-transmogrified-pending";
		else
			transmogStateAtlas = "transmog-setcard-transmogrified";
		end
	end

	if transmogStateAtlas then
		self.TransmogStateTexture:SetAtlas(transmogStateAtlas, TextureKitConstants.IgnoreAtlasSize);
		self.TransmogStateTexture:Show();

		if hasPending then
			self.PendingFrame:Show();
			self.PendingFrame.Anim:Restart();
		else
			self.PendingFrame.Anim:Stop();
			self.PendingFrame:Hide();
		end

		if self.elementData.collectionFrame:GetOutfitSlotSavedState() then
			self.SavedFrame:Show();
			self.SavedFrame.Anim:Restart();

			local outfitSlotSaved = false;
			self.elementData.collectionFrame:SetOutfitSlotSavedState(outfitSlotSaved);
		end
	else
		self.TransmogStateTexture:Hide();

		self.PendingFrame.Anim:Stop();
		self.PendingFrame:Hide();
	end

	-- Icons
	self.Favorite.Icon:SetShown(self.elementData.favorite);
	self.HiddenVisual.Icon:SetShown(self.elementData.hidden);
end

-- Overridden. (modified)
function TransmogSetModelMixin:RefreshTooltip()
	if not self.elementData then
		return;
	end

	local totalQuality = 0;
	local numTotalSlots = 0;
	local waitingOnQuality = false;
	local primaryAppearances = self.elementData.sourceData.primaryAppearances --C_TransmogSets.GetSetPrimaryAppearances(self.elementData.set.setID);
	for _index, primaryAppearance in pairs(primaryAppearances) do
		numTotalSlots = numTotalSlots + 1;
		local sourceInfo = C_TransmogCollection.GetSourceInfo(primaryAppearance.appearanceID);
		if sourceInfo and sourceInfo.quality then
			totalQuality = totalQuality + sourceInfo.quality;
		else
			waitingOnQuality = true;
		end
	end

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	if waitingOnQuality then
		GameTooltip:SetText(RETRIEVING_ITEM_INFO, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
	else
		local setQuality = (numTotalSlots > 0 and totalQuality > 0) and Round(totalQuality / numTotalSlots) or Enum.ItemQuality.Common;
		local setInfo = self.elementData.set --C_TransmogSets.GetSetInfo(self.elementData.set.setID);

		local colorData = ColorManager.GetColorDataForItemQuality(setQuality);
		if colorData then
			GameTooltip:SetText(self.elementData.name, colorData.r, colorData.g, colorData.b);
		else
			GameTooltip:SetText(self.elementData.name);
		end

		if setInfo.label then
			GameTooltip:AddLine(setInfo.label);
		end
	end

	local collected = self.elementData.set.collected or ( self.elementData.pieces and self.elementData.pieces > 0 and self.elementData.collected == self.elementData.pieces)

	if collected  then
		GameTooltip_AddHighlightLine(GameTooltip, TRANSMOG_SET_COMPLETE);
	else
		local text = string.format("%s (%d/%d)", TRANSMOG_SET_INCOMPLETE, self.elementData.collected, self.elementData.pieces)
		GameTooltip_AddDisabledLine(GameTooltip, text);
	end

	GameTooltip:Show();
end

function TransmogSetModelMixin:Init(elementData)
	self.elementData = elementData;
	if not self.elementData then
		return;
	end

	self:RefreshSetCamera();
end

function TransmogSetModelMixin.Reset(framePool, self)
	Pool_HideAndClearAnchors(framePool, self);
	self.elementData = nil;
end

function TransmogSetModelMixin:ToggleFavorite(setFavorite, isGroupFavorite)
	if not self.elementData then
		return;
	end

	local setID = self.elementData.setID;
	if self.elementData.setType == "Blizzard" then
		if setFavorite and isGroupFavorite then
			local baseSetID = C_TransmogSets.GetBaseSetID(setID);
			C_TransmogSets.SetIsFavorite(baseSetID, false);

			for _index, variantSet in ipairs(C_TransmogSets.GetVariantSets(baseSetID)) do
				C_TransmogSets.SetIsFavorite(variantSet.setID, false);
			end
		end

		C_TransmogSets.SetIsFavorite(setID, setFavorite);
	else
		addon.favoritesDB.profile.extraset[setID] = not addon.favoritesDB.profile.extraset[setID]
		TransmogFrame.WardrobeCollection.TabContent.ExtraSetsFrame:RefreshCollectionEntries()
	end

end

local TransmogCustomSetModelMixin = {};
BW_TransmogCustomSetModelMixin = TransmogCustomSetModelMixin

function TransmogCustomSetModelMixin:OnMouseDown(button)
	if not self.elementData then
		return;
	end

	if button == "LeftButton" then
		PlaySound(SOUNDKIT.UI_TRANSMOG_ITEM_CLICK);
		if self.elementData.setType == "Blizzard" then
			C_TransmogOutfitInfo.SetOutfitToCustomSet(self.elementData.customSetID);
		else
			local outfit = addon.OutfitDB.char.outfits[self.elementData.customSetID]
			ApplyOutfit(outfit)
		end
	end
end


--TODO Extra Custom sEt handleer
function TransmogCustomSetModelMixin:OnMouseUp(button)
	if not self.elementData then
		return;
	end

	if button ~= "RightButton" then
		return;
	end

	MenuUtil.CreateContextMenu(self, function(_owner, rootDescription)
		rootDescription:SetTag("MENU_TRANSMOG_CUSTOM_SETS_MODEL_FILTER");

		local itemTransmogInfoList = self.elementData.collectionFrame:GetItemTransmogInfoListCallback();
		if DressUpFrameLinkingSupported() then
			rootDescription:CreateButton(TRANSMOG_CUSTOM_SET_DRESSING_ROOM, function()
				if self.elementData.setType == "Blizzard" then
					DressUpFrame:ShowCustomSet(self.elementData.customSetID);
				else
					local transmogInfo = {}
					local customSetTransmogInfo = addon.OutfitDB.char.outfits[self.elementData.customSetID]
					for slotID, itemTransmogInfo in ipairs(customSetTransmogInfo) do
						if itemTransmogInfo then
							local itemTransmogInfo2 = ItemUtil.CreateItemTransmogInfo(itemTransmogInfo);
							transmogInfo[slotID] = itemTransmogInfo2
						end
					end
					DressUpItemTransmogInfoList(transmogInfo);
				end
			end);
		end

		local itemTransmogInfoList = self.elementData.collectionFrame:GetItemTransmogInfoListCallback();
		if DressUpFrameLinkingSupported() then
			rootDescription:CreateButton("Link in Chat", function()
				if self.elementData.setType == "Blizzard" then
					if self.elementData.customSetID then
						LinkSetInChat(C_TransmogCollection.GetCustomSetItemTransmogInfoList(self.elementData.customSetID));
					end
				else
					local transmogInfo = {}
					local customSetTransmogInfo = addon.OutfitDB.char.outfits[self.elementData.customSetID]
					for slotID, itemTransmogInfo in ipairs(customSetTransmogInfo) do
						if itemTransmogInfo then
							local itemTransmogInfo2 = ItemUtil.CreateItemTransmogInfo(itemTransmogInfo);
							transmogInfo[slotID] = itemTransmogInfo2
						end
					end
					LinkSetInChat(transmogInfo)
				end
			end);
		end

		local itemTransmogInfoList = self.elementData.collectionFrame:GetItemTransmogInfoListCallback();
		rootDescription:CreateButton(TRANSMOG_CUSTOM_SET_RENAME, function()
			if self.elementData.setType == "Blizzard" then
				local name, _icon = C_TransmogCollection.GetCustomSetInfo(self.elementData.customSetID);
				local data = { name = name, customSetID = self.elementData.customSetID, itemTransmogInfoList = itemTransmogInfoList };
				StaticPopup_Show("TRANSMOG_CUSTOM_SET_NAME", nil, nil, data);
			else
				local name = addon.OutfitDB.char.outfits[self.elementData.customSetID];
				local data = { name = name, customSetID = self.elementData.customSetID, itemTransmogInfoList = itemTransmogInfoList };
				StaticPopup_Show("BW_TRANSMOG_CUSTOM_SET_NAME", nil, nil, data);
			end
		end);

		local hasValidAppearance = TransmogUtil.IsValidItemTransmogInfoList(itemTransmogInfoList);
		if hasValidAppearance then
			rootDescription:CreateDivider();

			rootDescription:CreateButton(TRANSMOG_CUSTOM_SET_REPLACE, function()
				if self.elementData.setType == "Blizzard" then
					C_TransmogCollection.ModifyCustomSet(self.elementData.customSetID, itemTransmogInfoList);
				else
					addon:ModifyCustomSet(self.elementData.customSetID, itemTransmogInfoList);
				end
			end);
		end

		rootDescription:CreateDivider();

		rootDescription:CreateButton(RED_FONT_COLOR:WrapTextInColorCode(TRANSMOG_CUSTOM_SET_DELETE), function()

			if self.elementData.setType == "Blizzard" then
				local name, _icon = C_TransmogCollection.GetCustomSetInfo(self.elementData.customSetID);
				StaticPopup_Show("CONFIRM_DELETE_TRANSMOG_CUSTOM_SET", name, nil, self.elementData.customSetID);
			else
				local name = addon.OutfitDB.char.outfits[self.elementData.customSetID].name or "x";
				print(name)
				StaticPopup_Show("BW_CONFIRM_DELETE_TRANSMOG_OUTFIT", name, nil, self.elementData.customSetID);
				--BW_CONFIRM_DELETE_TRANSMOG_OUTFIT
			end

		end);
	end);
end

-- Overridden. (Modified)
function TransmogCustomSetModelMixin:UpdateSet()
	if not self.elementData then
		return;
	end

	-- Base Appearance
	if self.elementData.setType == "Blizzard" then
		local customSetTransmogInfo = C_TransmogCollection.GetCustomSetItemTransmogInfoList(self.elementData.customSetID);
		for slotID, itemTransmogInfo in ipairs(customSetTransmogInfo) do
			self:SetItemTransmogInfo(itemTransmogInfo, slotID);
		end
		local name, _icon = C_TransmogCollection.GetCustomSetInfo(self.elementData.customSetID);
		self.TitleBar.Text:SetText(name)
		self.Extra.Icon:Hide()

	else
		local customSetTransmogInfo = addon.OutfitDB.char.outfits[self.elementData.customSetID]
		for slotID, itemTransmogInfo in ipairs(customSetTransmogInfo) do
			if itemTransmogInfo then
				local itemTransmogInfo2 = ItemUtil.CreateItemTransmogInfo(itemTransmogInfo);
				self:SetItemTransmogInfo(itemTransmogInfo2, slotID);
			end
		end
		self.TitleBar.Text:SetText(customSetTransmogInfo.name)
		self.Extra.Icon:Show()
	end

	-- Border State FX
	local borderAtlas = self.elementData.isCollected and "transmog-setcard-default" or "transmog-setcard-incomplete";
	self.Border:SetAtlas(borderAtlas);
	self.Highlight:SetAtlas(borderAtlas);
	self.IncompleteOverlay:SetShown(not self.elementData.isCollected);

	local transmogStateAtlas;
	local appliedCustomSetID, hasPending = self.elementData.collectionFrame:GetFirstMatchingCustomSetID();
	if self.elementData.customSetID == appliedCustomSetID then
		if hasPending then
			transmogStateAtlas = "transmog-setcard-transmogrified-pending";
		else
			transmogStateAtlas = "transmog-setcard-transmogrified";
		end
	end

	if transmogStateAtlas then
		self.TransmogStateTexture:SetAtlas(transmogStateAtlas, TextureKitConstants.IgnoreAtlasSize);
		self.TransmogStateTexture:Show();

		if hasPending then
			self.PendingFrame:Show();
			self.PendingFrame.Anim:Restart();
		else
			self.PendingFrame.Anim:Stop();
			self.PendingFrame:Hide();
		end

		if self.elementData.collectionFrame:GetOutfitSlotSavedState() then
			self.SavedFrame:Show();
			self.SavedFrame.Anim:Restart();

			local outfitSlotSaved = false;
			self.elementData.collectionFrame:SetOutfitSlotSavedState(outfitSlotSaved);
		end
	else
		self.TransmogStateTexture:Hide();

		self.PendingFrame.Anim:Stop();
		self.PendingFrame:Hide();
	end
	self.Favorite.Icon:SetShown(false);
	self.HiddenVisual.Icon:SetShown(false);

end

-- Overridden.
function TransmogCustomSetModelMixin:RefreshTooltip()
	if not self.elementData then
		return;
	end

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");

	local name, _icon = C_TransmogCollection.GetCustomSetInfo(self.elementData.customSetID);
	GameTooltip:SetText(name);

	if self.elementData.isCollected then
		GameTooltip_AddHighlightLine(GameTooltip, TRANSMOG_CUSTOM_SET_COMPLETE);
	else
		GameTooltip_AddDisabledLine(GameTooltip, TRANSMOG_CUSTOM_SET_INCOMPLETE);
	end

	GameTooltip:Show();
end

function TransmogCustomSetModelMixin:Init(elementData)
	self.elementData = elementData;
	if not self.elementData then
		return;
	end

	self:RefreshSetCamera();
end

function TransmogCustomSetModelMixin.Reset(framePool, self)
	Pool_HideAndClearAnchors(framePool, self);
	self.elementData = nil;
end

--[[

TransmogSituationMixin = {
	DROPDOWN_WIDTH = 305;
};

function TransmogSituationMixin:OnLoad()
	self.Dropdown:SetWidth(self.DROPDOWN_WIDTH);
end

function TransmogSituationMixin:Init(elementData)
	self.elementData = elementData;

	local situationCategoryString = self.elementData.name;
	self.Title:SetText(situationCategoryString);

	local function IsSelected(data)
		return C_TransmogOutfitInfo.GetOutfitSituation(data);
	end

	local function SetSelectedRadio(data)
		if self.selectedSituation then
			C_TransmogOutfitInfo.UpdatePendingSituation(self.selectedSituation, false);
		end

		self.selectedSituation = data;

		C_TransmogOutfitInfo.UpdatePendingSituation(data, true);
	end

	local function SetSelectedCheckbox(data)
		local newValue = not IsSelected(data);
		C_TransmogOutfitInfo.UpdatePendingSituation(data, newValue);
	end

	self.Dropdown:SetupMenu(function(_dropdown, rootDescription)
		rootDescription:SetTag("MENU_TRANSMOG_SITUATION");

		for groupIndex, groupData in ipairs(self.elementData.groupData) do
			for _optionIndex, optionData in ipairs(groupData.optionData) do
				if self.elementData.isRadioButton then
					rootDescription:CreateRadio(optionData.name, IsSelected, SetSelectedRadio, optionData.option);
				else
					rootDescription:CreateCheckbox(optionData.name, IsSelected, SetSelectedCheckbox, optionData.option);
				end
			end

			if groupIndex < #self.elementData.groupData then
				rootDescription:CreateDivider();
			end
		end
	end);

	self.Dropdown:SetScript("OnEnter", function()
		GameTooltip:SetOwner(self.Dropdown, "ANCHOR_RIGHT", 0, 0);
		GameTooltip_AddHighlightLine(GameTooltip, self.elementData.name);
		GameTooltip_AddNormalLine(GameTooltip, self.elementData.description);
		GameTooltip:Show();
	end);

	self.Dropdown:SetScript("OnLeave", GameTooltip_Hide);
end

function TransmogSituationMixin:IsValid()
	-- A situation is considered valid if at least 1 option is selected on it.
	local _previousRadio, _nextRadio, selections = self.Dropdown:CollectSelectionData();
	return #selections > 0;
end

]]--