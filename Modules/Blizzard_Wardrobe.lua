-- C_TransmogCollection.GetItemInfo(itemID, [itemModID]/itemLink/itemName) = appearanceID, sourceID
-- C_TransmogCollection.GetAllAppearanceSources(appearanceID) = { sourceID } This is cross-class, but no guarantee a source is actually attainable
-- C_TransmogCollection.GetSourceInfo(sourceID) = { data }
-- 15th return of GetItemInfo is expansionID
-- new events: TRANSMOG_COLLECTION_SOURCE_ADDED and TRANSMOG_COLLECTION_SOURCE_REMOVED, parameter is sourceID, can be cross-class (wand unlocked from ensemble while on warrior)
local addonName, addon = ...
--addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local Profile
local Sets

addon.DefaultUI = {}

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local BASE_SET_BUTTON_HEIGHT = addon.Globals.BASE_SET_BUTTON_HEIGHT
local VARIANT_SET_BUTTON_HEIGHT = addon.Globals.VARIANT_SET_BUTTON_HEIGHT
local SET_PROGRESS_BAR_MAX_WIDTH = addon.Globals.SET_PROGRESS_BAR_MAX_WIDTH
local IN_PROGRESS_FONT_COLOR =addon.Globals.IN_PROGRESS_FONT_COLOR
local IN_PROGRESS_FONT_COLOR_CODE = addon.Globals.IN_PROGRESS_FONT_COLOR_CODE
local COLLECTION_LIST_WIDTH = addon.Globals.COLLECTION_LIST_WIDTH

local EmptyArmor = addon.Globals.EmptyArmor

function addon.Init:Blizzard_Wardrobe()
	Profile = addon.Profile
	Sets = addon.Sets
end


local TAB_ITEMS = 1;
local TAB_SETS = 2;




local function GetPage(entryIndex, pageSize)
	return floor((entryIndex-1) / pageSize) + 1
end
--CollectionList:BuildCollectionList()

--===WardrobeCollectionFrame.ItemsCollectionFrame overwrites
local EXCLUSION_CATEGORY_OFFHAND	= 1
local EXCLUSION_CATEGORY_MAINHAND	= 2

local ItemsCollectionFrame = WardrobeCollectionFrame.ItemsCollectionFrame

function WardrobeItemsCollectionMixin:GoToSourceID(sourceID, transmogLocation, forceGo, forTransmog)
	local categoryID, visualID;
	if ( transmogLocation:IsAppearance() ) then
		--if ( slot and forTransmog ) then
			categoryID, visualID = C_TransmogCollection.GetAppearanceSourceInfo(sourceID, transmogLocation.slotID);
		--end
	elseif ( transmogLocation:IsIllusion() ) then
		visualID = C_TransmogCollection.GetIllusionSourceInfo(sourceID);
	end

	if ( visualID or forceGo ) then
		self.jumpToVisualID = visualID;
		if ( self.activeCategory ~= categoryID or not self.transmogLocation:IsEqual(transmogLocation) ) then
			self:SetActiveSlot(transmogLocation, categoryID);
		else
			if not self.filteredVisualsList then
				self:RefreshVisualsList();
			end
			self:ResetPage();
		end
	end
end

function ItemsCollectionFrame:ResetPage()
	local page = 1;
	local selectedVisualID = NO_TRANSMOG_VISUAL_ID;
	if ( C_TransmogCollection.IsSearchInProgress(WardrobeCollectionFrame.activeFrame.searchType) ) then
		self.resetPageOnSearchUpdated = true;
	else
		if ( self.jumpToVisualID ) then
			selectedVisualID = self.jumpToVisualID;
			self.jumpToVisualID = nil;
		elseif ( self.jumpToLatestAppearanceID and not WardrobeFrame_IsAtTransmogrifier() ) then
			selectedVisualID = self.jumpToLatestAppearanceID;
			self.jumpToLatestAppearanceID = nil;
		end
	end
	if ( selectedVisualID and selectedVisualID ~= NO_TRANSMOG_VISUAL_ID ) then
		local visualsList = self:GetFilteredVisualsList();
		for i = 1, #visualsList do
			if ( visualsList[i].visualID == selectedVisualID ) then
				page = GetPage(i, self.PAGE_SIZE);
				break;
			end
		end
	end
	self.PagingFrame:SetCurrentPage(page);
	self:UpdateItems();
end

function BetterWardrobeItemsModelMixin_OnMouseDown(self, button)

	local itemsCollectionFrame = self:GetParent();
	if ( IsModifiedClick("CHATLINK") ) then
		local link;
		if ( itemsCollectionFrame.transmogLocation:IsIllusion() ) then
			link = select(3, C_TransmogCollection.GetIllusionSourceInfo(self.visualInfo.sourceID));
		else
			local sources = WardrobeCollectionFrame_GetSortedAppearanceSources(self.visualInfo.visualID, self.activeCategory);
			if ( WardrobeCollectionFrame.tooltipSourceIndex ) then
				local index = WardrobeUtils_GetValidIndexForNumSources(WardrobeCollectionFrame.tooltipSourceIndex, #sources);
				link = select(6, C_TransmogCollection.GetAppearanceSourceInfo(sources[index].sourceID));
			end
		end
		if ( link ) then
			HandleModifiedItemClick(link);
		end
		return;
	elseif ( IsModifiedClick("DRESSUP") ) then
		local slot = itemsCollectionFrame:GetActiveSlot();
		if ( itemsCollectionFrame.transmogLocation:IsAppearance() ) then
			local sourceID = itemsCollectionFrame:GetAnAppearanceSourceFromVisual(self.visualInfo.visualID, nil);
			-- don't specify a slot for ranged weapons
			if ( WardrobeUtils_IsCategoryRanged(itemsCollectionFrame:GetActiveCategory()) or  WardrobeUtils_IsCategoryLegionArtifact(itemsCollectionFrame:GetActiveCategory()) ) then
				slot = nil;
			end
			DressUpVisual(sourceID, slot);
		elseif ( itemsCollectionFrame.transmogLocation:IsIllusion() ) then
			local weaponSourceID = WardrobeCollectionFrame_GetWeaponInfoForEnchant(itemsCollectionFrame.transmogLocation);
			DressUpVisual(weaponSourceID, slot, self.visualInfo.sourceID);
		end
		return;
	end

	if ( button == "LeftButton" ) then
		BW_CloseDropDownMenus();
		self:GetParent():SelectVisual(self.visualInfo.visualID);
	elseif ( button == "RightButton" and not itemsCollectionFrame.transmogLocation:IsIllusion() and not IsModifierKeyDown() ) then
		local dropDown = self:GetParent().RightClickDropDown;
		if ( dropDown.activeFrame ~= self ) then
			BW_CloseDropDownMenus();
		end
		--if ( not self.visualInfo.isCollected or self.visualInfo.isHideVisual or itemsCollectionFrame.transmogLocation:IsIllusion() ) then
			--return;
		--end
		dropDown.activeFrame = self;
		BW_ToggleDropDownMenu(1, nil, dropDown, self, -6, -3);
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
	end
end


function WardrobeCollectionFrame_GetSortedAppearanceSources(visualID, categoryID)
	--if categoryID == 29 then
	local artifactSourceInfo =  addon.GetArtifactSourceInfo(visualID)
		if artifactSourceInfo and not WardrobeFrame_IsAtTransmogrifier() then  
		return {artifactSourceInfo}
	else
		local sources = C_TransmogCollection.GetAppearanceSources(visualID, categoryID);
		if not sources then 
			local AllSources = C_TransmogCollection.GetAllAppearanceSources(visualID)
			sources = {}
			for i = 1, #AllSources do
				tinsert (sources,C_TransmogCollection.GetSourceInfo(AllSources[i]))
			end
		end

		return WardrobeCollectionFrame_SortSources(sources);
	end
end




--[[function WardrobeCollectionFrame_GetSortedAppearanceSources(visualID)
	local slotID = nil
	if (filterBySlot == true) then
		local slot = WardrobeCollectionFrame.ItemsCollectionFrame:GetActiveSlot();
		if (slot) then
			slotID = GetInventorySlotInfo(slot)
		end
	end
	--local sources = C_TransmogCollection.GetAppearanceSources(visualID);
	local sources = C_TransmogCollection.GetAllAppearanceSources(visualID)
	local sortlist = {}
	for i = 1, #sources do
		tinsert (sortlist,C_TransmogCollection.GetSourceInfo(sources[i]))
	end

	return WardrobeCollectionFrame_SortSources(sortlist);
end]]


local CameraID = {
  [1]  = 542,
  [2]  = 543,
  [3]  = 544,
  [4]  = 545,
  [5]  = 546,
  [6]  = 547,
  [7]  = 548,
  [8]  = 549,
  [9]  = 550,
  [10] = 551,
  [11] = 552,
}

function ItemsCollectionFrame:GetCameraID(visualID, armor)
	local id = C_TransmogCollection.GetAppearanceCameraID(visualID)
	if id ~= 0 then
		return id
	else
		local sourceID = self:GetAnAppearanceSourceFromVisual(visualID, nil);
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
		local _, _, _, _, _, itemClassID, itemSubClassID = GetItemInfoInstant(sourceInfo.itemID)

		if not armor then 
			local appearance_camera
			local _, _, _, _, _, itemClassID, itemSubClassID = GetItemInfoInstant(sourceInfo.itemID)
			if (itemClassID == 2 or itemClassID == 4) and addon.Globals.CAMERAS[itemClassID][itemSubClassID] then 
				appearance_camera = addon.Globals.CAMERAS[itemClassID][itemSubClassID] or 0
			else 

			end
			return appearance_camera
		elseif armor then 
			local categoryID = sourceInfo.categoryID
			if CameraID[categoryID] then 
				return CameraID[categoryID]
			else
				return 0
			end
		end
	end
end

--[[function WardrobeItemsCollectionMixin:ToggleRightShoulderDisplay(show)
	local lastButton = nil;
	for i, button in ipairs(self.SlotsFrame.Buttons) do
		if not button.isSmallButton then
			local slotName =  button.transmogLocation:GetSlotName();
			if slotName == "BACKSLOT" then
				local xOffset = show and spacingWithSmallButton or spacingNoSmallButton;
				button:SetPoint("LEFT", lastButton, "RIGHT", xOffset, 0);
			elseif slotName == "HANDSSLOT" or slotName == "MAINHANDSLOT" then
				local xOffset = show and shorterSectionSpacing or defaultSectionSpacing;
				button:SetPoint("LEFT", lastButton, "RIGHT", xOffset, 0);
			end
			lastButton = button;
		end
	end
	self.SlotsFrame.rightShoulderButton:SetShown(show);

	if self.transmogLocation then
		-- if it was selected and got hidden, reset to left shoulder
		-- otherwise if left selected, update cameras
		local leftShoulderTransmogLocation = TransmogUtil.GetTransmogLocation("SHOULDERSLOT", Enum.TransmogType.Appearance, Enum.TransmogModification.None);
		if not show and self.transmogLocation:IsEqual(self.SlotsFrame.rightShoulderButton.transmogLocation) then		
			self:SetActiveSlot(leftShoulderTransmogLocation);
		elseif self.transmogLocation:IsEqual(leftShoulderTransmogLocation) then
			self:UpdateItems();
		end
	end
end
]]

local WARDROBE_MODEL_SETUP_GEAR = {
	["CHESTSLOT"] = 78420,
	["LEGSSLOT"] = 78425,
	["FEETSLOT"] = 78427,
	["HANDSSLOT"] = 78426,
	["HEADSLOT"] = 78416,
}
local function resetModel(model)
	model:SetUnit("player")
	for slot, ID in pairs(WARDROBE_MODEL_SETUP_GEAR) do 
		model:TryOn(ID);
	end
	model.needsReset = false
end

function ItemsCollectionFrame:UpdateItems()
	local isArmor;
	local cameraID;
	local appearanceVisualID;	-- for weapon when looking at enchants
	local appearanceVisualSubclass;
	local changeModel = false;
	local isAtTransmogrifier = WardrobeFrame_IsAtTransmogrifier();

	if ( self.transmogLocation:IsIllusion() ) then
		-- for enchants we need to get the visual of the item in that slot
		local appearanceSourceID;
		appearanceSourceID, appearanceVisualID, appearanceVisualSubclass = WardrobeCollectionFrame_GetWeaponInfoForEnchant(self.transmogLocation);
		cameraID = C_TransmogCollection.GetAppearanceCameraIDBySource(appearanceSourceID);
		if ( appearanceVisualID ~= self.illusionWeaponVisualID ) then
			self.illusionWeaponVisualID = appearanceVisualID;
			changeModel = true;
		end
	else
		local _, isWeapon = C_TransmogCollection.GetCategoryInfo(self.activeCategory);
		isArmor = not isWeapon and not addon:IsWeaponCat();
	end

	local tutorialAnchorFrame;
	local checkTutorialFrame = self.transmogLocation:IsAppearance() and not WardrobeFrame_IsAtTransmogrifier()
								and not GetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_TRANSMOG_MODEL_CLICK);

	local baseSourceID, baseVisualID, appliedSourceID, appliedVisualID, appliedCategoryID, pendingSourceID, pendingVisualID, pendingCategoryID, hasPendingUndo;
	local showUndoIcon;
	if ( isAtTransmogrifier ) then
		baseSourceID, baseVisualID, appliedSourceID, appliedVisualID, appliedCategoryID, pendingSourceID, pendingVisualID, pendingCategoryID, hasPendingUndo = C_Transmog.GetSlotVisualInfo(self.transmogLocation);
		if ( appliedVisualID ~= NO_TRANSMOG_VISUAL_ID ) then
			if ( hasPendingUndo ) then
				pendingVisualID = baseVisualID;
				showUndoIcon = true;
			end
			-- current border (yellow) should only show on untransmogrified items
			baseVisualID = nil;
		end
		-- hide current border (yellow) or current-transmogged border (purple) if there's something pending
		if ( pendingVisualID ~= NO_TRANSMOG_VISUAL_ID ) then
			baseVisualID = nil;
			appliedVisualID = nil;
		end
	end

	local cameraVariation = self:GetCameraVariation();

	local pendingTransmogModelFrame = nil;
	local indexOffset = (self.PagingFrame:GetCurrentPage() - 1) * self.PAGE_SIZE;
	for i = 1, self.PAGE_SIZE do
		local model = self.Models[i];

		local index = i + indexOffset;
		local visualInfo = self.filteredVisualsList[index];
		if ( visualInfo ) then
			model:Show();

			if model.needsReset then 
				resetModel(model)
			end

			local isWeapon
			if visualInfo.categoryID and visualInfo.categoryID > 11 then 
				isWeapon = true
			end

			-- camera
			if ( self.transmogLocation:IsAppearance()  ) then
				if visualInfo.artifact then
					cameraID = visualInfo.camera
				else
					cameraID = self:GetCameraID(visualInfo.visualID, isArmor and not isWeapon) 
				end
			end

			if ( model.cameraID ~= cameraID ) then
				Model_ApplyUICamera(model, cameraID);
				model.cameraID = cameraID;
			end
			model.zoom = nil

			--Dont really care about useable status for colelction list
			if BW_CollectionListButton.ToggleState then 
				visualInfo.isUsable = true
			end


			--if ( visualInfo ~= model.visualInfo or changeModel ) then
				if ( isArmor and not isWeapon) then
					local sourceID = self:GetAnAppearanceSourceFromVisual(visualInfo.visualID, nil);
					model:TryOn(sourceID);
					model:Show()

				elseif(visualInfo.shapeshiftID) then 
					model.cameraID = visualInfo.camera
					Model_ApplyUICamera(model, visualInfo.camera);
					model:SetDisplayInfo( visualInfo.shapeshiftID );
					model:MakeCurrentCameraCustom()
					
					if model.cameraID == 1602 then 
						model.zoom =-.75
						model:SetCameraDistance(-5)
						model:SetPosition(-13.25,0,-2.447)
					end 
					model:Show()
					
				elseif ( appearanceVisualID ) then
					-- appearanceVisualID is only set when looking at enchants
					model:SetItemAppearance(appearanceVisualID, visualInfo.visualID, appearanceVisualSubclass);
				else
					model:SetItemAppearance(visualInfo.visualID);
					if isWeapon then 
						model.needsReset = true
					end
				end
			--end
			model.visualInfo = visualInfo;

			-- state at the transmogrifier
			local transmogStateAtlas;
			if ( visualInfo.visualID == appliedVisualID and appliedCategoryID == self.activeCategory) then
				transmogStateAtlas = "transmog-wardrobe-border-current-transmogged";
			elseif ( visualInfo.visualID == baseVisualID ) then
				transmogStateAtlas = "transmog-wardrobe-border-current";
			elseif ( visualInfo.visualID == pendingVisualID and pendingCategoryID == self.activeCategory) then
				transmogStateAtlas = "transmog-wardrobe-border-selected";
				pendingTransmogModelFrame = model;
			end
			if ( transmogStateAtlas ) then
				model.TransmogStateTexture:SetAtlas(transmogStateAtlas, true);
				model.TransmogStateTexture:Show();
			else
				model.TransmogStateTexture:Hide();
			end

			-- border
			if ( not visualInfo.isCollected ) then
				model.Border:SetAtlas("transmog-wardrobe-border-uncollected");
			elseif ( not visualInfo.isUsable ) then
				model.Border:SetAtlas("transmog-wardrobe-border-unusable");
			else
				model.Border:SetAtlas("transmog-wardrobe-border-collected");
			end

			if ( C_TransmogCollection.IsNewAppearance(visualInfo.visualID) ) then
				model.NewString:Show();
				model.NewGlow:Show();
			else
				model.NewString:Hide();
				model.NewGlow:Hide();
			end
			-- favorite
			model.Favorite.Icon:SetShown(addon:IsFavoriteItem(visualInfo.visualID) or visualInfo.isFavorite);
			-- hide visual option
			model.HideVisual.Icon:SetShown(isAtTransmogrifier and visualInfo.isHideVisual);

			if ( GameTooltip:GetOwner() == model ) then
				model:OnEnter();
			end

			-- find potential tutorial anchor in the 1st row
			if ( checkTutorialFrame ) then
				if ( i < self.NUM_COLS and not WardrobeCollectionFrame.tutorialVisualID and visualInfo.isCollected and not visualInfo.isHideVisual ) then
					tutorialAnchorFrame = model;
				elseif ( WardrobeCollectionFrame.tutorialVisualID and WardrobeCollectionFrame.tutorialVisualID == visualInfo.visualID ) then
					tutorialAnchorFrame = model;
				end
			end
		else
			model:Hide();
			model.visualInfo = nil;
		end
	end
	if ( pendingTransmogModelFrame ) then
		self.PendingTransmogFrame:SetParent(pendingTransmogModelFrame);
		self.PendingTransmogFrame:SetPoint("CENTER");
		self.PendingTransmogFrame:Show();
		if ( self.PendingTransmogFrame.visualID ~= pendingVisualID ) then
			self.PendingTransmogFrame.TransmogSelectedAnim:Stop();
			self.PendingTransmogFrame.TransmogSelectedAnim:Play();
			self.PendingTransmogFrame.TransmogSelectedAnim2:Stop();
			self.PendingTransmogFrame.TransmogSelectedAnim2:Play();
			self.PendingTransmogFrame.TransmogSelectedAnim3:Stop();
			self.PendingTransmogFrame.TransmogSelectedAnim3:Play();
			self.PendingTransmogFrame.TransmogSelectedAnim4:Stop();
			self.PendingTransmogFrame.TransmogSelectedAnim4:Play();
			self.PendingTransmogFrame.TransmogSelectedAnim5:Stop();
			self.PendingTransmogFrame.TransmogSelectedAnim5:Play();
		end
		self.PendingTransmogFrame.UndoIcon:SetShown(showUndoIcon);
		self.PendingTransmogFrame.visualID = pendingVisualID;
	else
		self.PendingTransmogFrame:Hide();
	end
	-- progress bar
	self:UpdateProgressBar();
	-- tutorial
	if ( checkTutorialFrame ) then
		if ( C_TransmogCollection.HasFavorites() ) then
			SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_TRANSMOG_MODEL_CLICK, true);
			tutorialAnchorFrame = nil;
		elseif ( tutorialAnchorFrame ) then
			if ( not WardrobeCollectionFrame.tutorialVisualID ) then
				WardrobeCollectionFrame.tutorialVisualID = tutorialAnchorFrame.visualInfo.visualID;
			end
			if ( WardrobeCollectionFrame.tutorialVisualID ~= tutorialAnchorFrame.visualInfo.visualID ) then
				tutorialAnchorFrame = nil;
			end
		end
	end
	if ( tutorialAnchorFrame ) then
		local helpTipInfo = {
			text = TRANSMOG_MOUSE_CLICK_TUTORIAL,
			buttonStyle = HelpTip.ButtonStyle.Close,
			cvarBitfield = "closedInfoFrames",
			bitfieldFlag = LE_FRAME_TUTORIAL_TRANSMOG_MODEL_CLICK,
			targetPoint = HelpTip.Point.BottomEdgeCenter,
		};
		HelpTip:Show(self, helpTipInfo, tutorialAnchorFrame);
	else

		HelpTip:Hide(self, TRANSMOG_MOUSE_CLICK_TUTORIAL);
	end
end


function ItemsCollectionFrame:SortVisuals()
		if WardrobeCollectionFrame.selectedCollectionTab == 1 then 

		if self:GetActiveCategory()  and self:GetActiveCategory() ~= 29 then
			addon.Sort[1][addon.sortDB.sortDropdown](self)
			--BW_SortDropDown:SetDisabled(false)
			--BW_SortDropDown.dropdown:SetText(COMPACT_UNIT_FRAME_PROFILE_SORTBY.." "..L[addon.sortDB.sortDropdown])
--			UIDropDownMenu_EnableDropDown(BW_SortDropDown)
			--UIDropDownMenu_SetText(BW_SortDropDown, COMPACT_UNIT_FRAME_PROFILE_SORTBY.." "..L[addon.sortDB.sortDropdown])

			--self:UpdateItems()
		elseif self:GetActiveCategory()  and self:GetActiveCategory() == 29 then
			addon.Sort[1][1](self)
			--BW_SortDropDown.dropdown:SetDisabled(true)
			--BW_SortDropDown.dropdown:SetText(COMPACT_UNIT_FRAME_PROFILE_SORTBY.." "..L["Default"])
		--	UIDropDownMenu_DisableDropDown(BW_SortDropDown)
			--UIDropDownMenu_SetText(BW_SortDropDown, COMPACT_UNIT_FRAME_PROFILE_SORTBY.." "..L["Default"])
		else
			addon.Sort[1][1](self)
		--	BW_SortDropDown.dropdown:SetDisabled(true)
		--	BW_SortDropDown.dropdown:SetText(COMPACT_UNIT_FRAME_PROFILE_SORTBY.." "..L["Default"])
		--	UIDropDownMenu_DisableDropDown(BW_SortDropDown)
		--	UIDropDownMenu_SetText(BW_SortDropDown, COMPACT_UNIT_FRAME_PROFILE_SORTBY.." "..L["Default"])
			--self:UpdateItems()
		end
	end
end


function ItemsCollectionFrame:RefreshVisualsList()
	if ( self.transmogLocation:IsIllusion() ) then
		self.visualsList = C_TransmogCollection.GetIllusions()
	else
		if( WardrobeCollectionFrame.ItemsCollectionFrame.transmogLocation:IsMainHand() ) then
			if self.activeCategory == 29 and not WardrobeFrame_IsAtTransmogrifier() then 
				--Replace the default artifact list with complete visuals
				self.visualsList = addon.GetClassArtifactAppearanceList() 
			else 
				self.visualsList = C_TransmogCollection.GetCategoryAppearances(self.activeCategory, EXCLUSION_CATEGORY_MAINHAND)
			end
		elseif (WardrobeCollectionFrame.ItemsCollectionFrame.transmogLocation:IsOffHand() ) then
			self.visualsList = C_TransmogCollection.GetCategoryAppearances(self.activeCategory, EXCLUSION_CATEGORY_OFFHAND)
		else
			self.visualsList = C_TransmogCollection.GetCategoryAppearances(self.activeCategory)
		end

	end

	--Mod to allow visual view of sets from the journal
	if BW_CollectionListButton.ToggleState then self.visualsList = addon.CollectionList:BuildCollectionList() end

	self:FilterVisuals()
	self.filteredVisualsList = addon.Sets:ClearHidden(self.filteredVisualsList, "item")--self.visualsList
	self:SortVisuals()

	self.PagingFrame:SetMaxPages(ceil(#self.filteredVisualsList / self.PAGE_SIZE))
end


function ItemsCollectionFrame:SetAppearanceTooltip(frame)
	GameTooltip:SetOwner(frame, "ANCHOR_RIGHT");
	self.tooltipVisualID = frame.visualInfo.visualID;

	if self.activeCategory == 29 and not WardrobeFrame_IsAtTransmogrifier() then 
		if ( not self.tooltipVisualID ) then
			return;
		end
		addon.SetArtifactAppearanceTooltip(self, frame.visualInfo)
 	else
		self:RefreshAppearanceTooltip();
	end
end

--[[function ItemsCollectionFrame:RefreshAppearanceTooltip()
	if ( not self.tooltipVisualID ) then
		return;
	end

	if self.activeCategory == 29 then 
		addon.SetArtifactAppearanceTooltip(self)
 	else
	--if self.viaual
		local sources = WardrobeCollectionFrame_GetSortedAppearanceSources(self.tooltipVisualID, self.activeCategory);
		local chosenSourceID = self:GetChosenVisualSource(self.tooltipVisualID);
		WardrobeCollectionFrame_SetAppearanceTooltip(self, sources, chosenSourceID);
	end
end]]
do
	local function displayset(setID) C_Timer.After(addon.ViewDelay, function()
			BW_WardrobeCollectionFrame.BW_SetsCollectionFrame:SelectSet(setID)
			BW_WardrobeCollectionFrame.BW_SetsCollectionFrame:ScrollToSet(setID)
			BW_WardrobeCollectionFrame.BW_SetsCollectionFrame:DisplaySet(setID)
			addon.ViewDelay = 0
			end)	
		end
local tempLink
local tempSetID
	hooksecurefunc("WardrobeCollectionFrame_OpenTransmogLink",  function(link) 
	--addon:Hook("WardrobeCollectionFrame_OpenTransmogLink", function(link)
		--if InCombatLockdown() then return end
		if ( not CollectionsJournal:IsVisible() or not WardrobeCollectionFrame:IsVisible() ) then
			--securecall(function() ToggleCollectionsJournal(5) end)
		end
		tempLink = link

		local linkType, id = strsplit(":", tempLink);

		if ( linkType == "transmogappearance" ) then
			--local sourceID = tonumber(id);
			BW_WardrobeCollectionFrame_SetTab(TAB_ITEMS);

			-- For links a base appearance is fine
			--local categoryID = C_TransmogCollection.GetAppearanceSourceInfo(sourceID);
			--local slot = WardrobeCollectionFrame_GetSlotFromCategoryID(categoryID);
			--local transmogLocation = TransmogUtil.GetTransmogLocation(slot, Enum.TransmogType.Appearance, Enum.TransmogModification.None);
			--WardrobeCollectionFrame.ItemsCollectionFrame:GoToSourceID(sourceID, transmogLocation);

		elseif ( linkType == "transmogset") then
			--local setID = tonumber(id);
			BW_WardrobeCollectionFrame_SetTab(TAB_SETS);
			--BW_WardrobeCollectionFrame.BW_SetsCollectionFrame:SelectSet(setID);
			--BW_WardrobeCollectionFrame.SetsCollectionFrame:SelectSet(setID);

		elseif ( linkType == "transmogset-extra") then
			local setID = tonumber(id)

			addon:RegisterMessage("BW_TRANSMOG_EXTRASETSHOWN", function(self) 
				addon:UnregisterMessage("BW_TRANSMOG_EXTRASETSHOWN")
				displayset(setID)
			end)

			local setInfo = addon.GetSetInfo(setID)
			local armorType = setInfo.armorType
			if armorType ~= addon.selectedArmorType then 
				addon.selectedArmorType = armorType
				BW_WardrobeCollectionFrame_SetTab(2)
				BW_WardrobeCollectionFrame_SetTab(3)
			else 
				BW_WardrobeCollectionFrame_SetTab(3)

			end

			displayset(setID)
		end
	end, true)
end


local function CheckMissingLocation(setInfo)
--function addon.Sets:GetLocationBasedCount(set)
	local filtered = false
	local invType = {}
	local missingSelection = addon.Filters.Base.missingSelection

		local sources = C_TransmogSets.GetSetSources(setInfo.setID)
		for sourceID in pairs(sources) do
			local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
			local sources = sourceInfo and C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)
			if sources then
				if #sources > 1 then
					WardrobeCollectionFrame_SortSources(sources)
				end
				if  missingSelection[sourceInfo.invType] and not sources[1].isCollected then

					return true
				elseif missingSelection[sourceInfo.invType] then 
					filtered = true
				end
			end
		end

	for type, value in pairs(missingSelection) do
		if value and invType[type] then
			filtered = true
		end
	end

	return not filtered
end



local SetsDataProvider = CreateFromMixins(WardrobeSetsDataProviderMixin)
addon.SetsDataProvider = SetsDataProvider

function SetsDataProvider:SortSets(sets, reverseUIOrder, ignorePatchID)
	--local sortedSources = SetsDataProvider:GetSortedSetSources(data.setID)
	addon.SortSet(sets, reverseUIOrder, ignorePatchID)
	--addon.Sort["DefaultSortSet"](self, sets, reverseUIOrder, ignorePatchID)
end



function SetsDataProvider:GetBaseSets()
	--getAllSets(type)
	if (not self.baseSets) then
		--local all sets = addon.GetAllSets()
	self.baseSets = addon.Sets:ClearHidden(C_TransmogSets.GetBaseSets(), "set")
	--self.baseSets = addon.GetAllSets()-- BaseList --addon.Sets:ClearHidden(C_TransmogSets.GetAllSets(), "set")

		local atTransmogrifier = WardrobeFrame_IsAtTransmogrifier()

		local filteredSets = {}
		local xpacSelection = addon.Filters.Base.xpacSelection
		for i, data in ipairs(self.baseSets) do
			if (xpacSelection[data.expansionID + 1] and CheckMissingLocation(data)) or atTransmogrifier  then 
				tinsert(filteredSets, data)
			end
		end

		self.baseSets = filteredSets

		self:DetermineFavorites()
		self:SortSets(self.baseSets)
	end
	return self.baseSets
end

function SetsDataProvider:GetBaseSetByID(baseSetID)
	local baseSets = self:GetBaseSets();
	for i = 1, #baseSets do
		if ( baseSets[i].setID == baseSetID ) then
			return baseSets[i], i;
		end
	end
	return nil, nil;
end

function SetsDataProvider:GetUsableSets(incVariants)
	if (not self.usableSets) then
		local atTransmogrifier = WardrobeFrame_IsAtTransmogrifier()
		local setIDS = {}

		if not Profile.ShowIncomplete  then 
			self.usableSets = C_TransmogSets.GetUsableSets()
			self:SortSets(self.usableSets)
			-- group sets by baseSetID, except for favorited sets since those are to remain bucketed to the front
			for i, set in ipairs(self.usableSets) do
				setIDS[set.baseSetID or set.setID] = true
				if (not set.favorite) then
					local baseSetID = set.baseSetID or set.setID
					local numRelatedSets = 0
					for j = i + 1, #self.usableSets do
						if (self.usableSets[j].baseSetID == baseSetID or self.usableSets[j].setID == baseSetID) then
							numRelatedSets = numRelatedSets + 1
							-- no need to do anything if already contiguous
							if (j ~= i + numRelatedSets) then
								local relatedSet = self.usableSets[j]
								tremove(self.usableSets, j)
								tinsert(self.usableSets, i + numRelatedSets, relatedSet)
							end
						end
					end
				end
			end
			return self.usableSets
		end

		if Profile.ShowIncomplete or BW_WardrobeToggle.VisualMode then 
			self.usableSets = {}
			local availableSets = self:GetBaseSets()
			for i, set in ipairs(availableSets) do
				if not setIDS[set.setID or set.baseSetID] then 
					local topSourcesCollected, topSourcesTotal = addon.Sets:GetLocationBasedCount(set) --SetsDataProvider:GetSetSourceCounts(set.setID)
					local cutoffLimit = (topSourcesTotal <= Profile.PartialLimit and topSourcesTotal) or Profile.PartialLimit --SetsDataProvider:GetSetSourceCounts(set.setID)

					if ((not atTransmogrifier and BW_WardrobeToggle.VisualMode) or topSourcesCollected >= cutoffLimit and topSourcesTotal > 0 )then --and not C_TransmogSets.IsSetUsable(set.setID) then
					--if (BW_WardrobeToggle.viewAll and BW_WardrobeToggle.VisualMode) or (not atTransmogrifier and BW_WardrobeToggle.VisualMode) or topSourcesCollected >= cutoffLimit  and topSourcesTotal > 0 then --and not C_TransmogSets.IsSetUsable(set.setID) then

						
						tinsert(self.usableSets, set)
					end
				end

				if incVariants then 
					local variantSets = C_TransmogSets.GetVariantSets(set.setID)
					for i, set in ipairs(variantSets) do
						if not setIDS[set.setID or set.baseSetID] then 
							local topSourcesCollected, topSourcesTotal = addon.Sets:GetLocationBasedCount(set)--SetsDataProvider:GetSetSourceCounts(set.setID)
							if topSourcesCollected == topSourcesTotal then set.collected = true end
							if ((not atTransmogrifier and BW_WardrobeToggle.VisualMode) or topSourcesCollected >= Profile.PartialLimit and topSourcesTotal > 0)  then --and not C_TransmogSets.IsSetUsable(set.setID) then
								tinsert(self.usableSets, set)
							end
						end
						
					end
				end
			end

		elseif not Profile.ShowIncomplete  then 
			self.usableSets = C_TransmogSets.GetUsableSets()

			self:SortSets(self.usableSets)
			-- group sets by baseSetID, except for favorited sets since those are to remain bucketed to the front
			for i, set in ipairs(self.usableSets) do
				setIDS[set.baseSetID or set.setID] = true
				if (not set.favorite) then
					local baseSetID = set.baseSetID or set.setID
					local numRelatedSets = 0
					for j = i + 1, #self.usableSets do
						if (self.usableSets[j].baseSetID == baseSetID or self.usableSets[j].setID == baseSetID) then
							numRelatedSets = numRelatedSets + 1
							-- no need to do anything if already contiguous
							if (j ~= i + numRelatedSets) then
								local relatedSet = self.usableSets[j]
								tremove(self.usableSets, j)
								tinsert(self.usableSets, i + numRelatedSets, relatedSet)
							end
						end
					end
				end
			end
		end
				
		self:SortSets(self.usableSets)
	end

	return addon.Sets:ClearHidden(self.usableSets, "set") 
end


--[[function SetsDataProvider:GetVariantSets(baseSetID)
	if ( not self.variantSets ) then
		self.variantSets = { };
	end

	local variantSets = self.variantSets[baseSetID];
	if ( not variantSets ) then
		variantSets = C_TransmogSets.GetVariantSets(baseSetID);
		if type(variantSets) == "number" then 
							--print(variantSets)
							local setData = C_TransmogSets.GetSetInfo(variantSets)
							--print(C_TransmogSets.GetSetInfo(variantSets))
							--	setData.baseSetID = baseSetID
							variantSets = {setData}
						end
						--print(#variantSets)
--
		self.variantSets[baseSetID] = variantSets;
		if ( #variantSets > 0 ) then
			-- add base to variants and sort
			local baseSet = self:GetBaseSetByID(baseSetID);
			--print(baseSet)
			if ( baseSet ) then
				--print(baseSet)
				tinsert(variantSets, baseSet);
			end
			local reverseUIOrder = true;
			local ignorePatchID = true;
			self:SortSets(variantSets, reverseUIOrder, ignorePatchID);
		end
	end
	return variantSets;
end

function WardrobeSetsDataProviderMixin:DetermineFavorites()
	-- if a variant is favorited, so is the base set
	-- keep track of which set is favorited
	local baseSets = self:GetBaseSets();
	for i = 1, #baseSets do
		local baseSet = baseSets[i];
		baseSet.favoriteSetID = nil;
		if ( baseSet.favorite ) then
			baseSet.favoriteSetID = baseSet.setID;
		else
			local variantSets = self:GetVariantSets(baseSet.setID);
			for j = 1, #variantSets do
				if ( variantSets[j].favorite ) then
					baseSet.favoriteSetID = variantSets[j].setID;
					break;
				end
			end
		end
	end
end]]

function SetsDataProvider:FilterSearch()
	local baseSets = self:GetUsableSets(true)
	local filteredSets = {}
	local searchString = string.lower(WardrobeCollectionFrameSearchBox:GetText())

	if searchString then 
		for i = 1, #baseSets do
			local baseSet = baseSets[i]
			local match = string.find(string.lower(baseSet.name), searchString) -- or string.find(baseSet.label, searchString) or string.find(baseSet.description, searchString)
			
			if match then 
				tinsert(filteredSets, baseSet)
			end
		end

		self.usableSets = filteredSets 
	else 
		self.usableSets = baseSets 
	end
	self:SortSets(self.usableSets)

end

function SetsDataProvider:ClearSets()
	self.baseSets = nil;
	self.baseSetsData = nil;
	self.variantSets = nil;
	self.usableSets = nil;
	self.sourceData = nil;
end

function addon.DefaultUI:ClearSets()
	SetsDataProvider:ClearSets()
end

--===WardrobeCollectionFrame.SetsCollectionFrame===--
function WardrobeCollectionFrame.SetsCollectionFrame:OnSearchUpdate()
	if (self.init) then
		SetsDataProvider:ClearBaseSets()
		SetsDataProvider:ClearVariantSets()
		SetsDataProvider:ClearUsableSets()
		self:Refresh()
	end
end


function WardrobeCollectionFrame.SetsCollectionFrame:OnShow()
	self:RegisterEvent("GET_ITEM_INFO_RECEIVED")
	self:RegisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE")
	self:RegisterEvent("TRANSMOG_COLLECTION_UPDATED")
	-- select the first set if not init
	local baseSets = SetsDataProvider:GetBaseSets()
	if (not self.init) then
		self.init = true
		if (baseSets and baseSets[1]) then
			self:SelectSet(self:GetDefaultSetIDForBaseSet(baseSets[1].setID))
		end
	else
		self:Refresh()
	end

	local latestSource = C_TransmogSets.GetLatestSource()
	if (latestSource ~= NO_TRANSMOG_SOURCE_ID) then
		local sets = C_TransmogSets.GetSetsContainingSourceID(latestSource)
		local setID = sets and sets[1]
		if (setID) then
			self:SelectSet(setID)
			local baseSetID = C_TransmogSets.GetBaseSetID(setID)
			self:ScrollToSet(baseSetID)
		end
		self:ClearLatestSource()
	end
	addon.Init:BuildDB()
	WardrobeCollectionFrame.progressBar:Show()
	self:UpdateProgressBar()
	self:RefreshCameras()

	if HelpTip:IsShowing(WardrobeCollectionFrame, TRANSMOG_SETS_TAB_TUTORIAL) then
		HelpTip:Hide(WardrobeCollectionFrame, TRANSMOG_SETS_TAB_TUTORIAL);
		SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_TRANSMOG_SETS_TAB, true);
	end
end

function WardrobeCollectionFrame.SetsCollectionFrame:DisplaySet(setID)
	local setInfo = (setID and C_TransmogSets.GetSetInfo(setID)) or nil;
	if ( not setInfo ) then
		self.DetailsFrame:Hide();
		self.Model:Hide();
		return;
	else
		self.DetailsFrame:Show();
		self.Model:Show();
	end

	self.DetailsFrame.Name:SetText(setInfo.name);
	if ( self.DetailsFrame.Name:IsTruncated() ) then
		self.DetailsFrame.Name:Hide();
		self.DetailsFrame.LongName:SetText(setInfo.name);
		self.DetailsFrame.LongName:Show();
	else
		self.DetailsFrame.Name:Show();
		self.DetailsFrame.LongName:Hide();
	end
	self.DetailsFrame.Label:SetText(setInfo.label);
	self.DetailsFrame.LimitedSet:SetShown(setInfo.limitedTimeSet);

	local newSourceIDs = C_TransmogSets.GetSetNewSources(setID);

	self.DetailsFrame.itemFramesPool:ReleaseAll();
	self.Model:Undress();
	local BUTTON_SPACE = 37;	-- button width + spacing between 2 buttons
	local sortedSources = SetsDataProvider:GetSortedSetSources(setID);
	local xOffset = -floor((#sortedSources - 1) * BUTTON_SPACE / 2);
	for i = 1, #sortedSources do
		local itemFrame = self.DetailsFrame.itemFramesPool:Acquire();
		itemFrame.sourceID = sortedSources[i].sourceID;
		itemFrame.itemID = sortedSources[i].itemID;
		itemFrame.collected = sortedSources[i].collected;
		itemFrame.invType = sortedSources[i].invType;
		local texture = C_TransmogCollection.GetSourceIcon(sortedSources[i].sourceID);
		itemFrame.Icon:SetTexture(texture);
		if ( sortedSources[i].collected ) then
			itemFrame.Icon:SetDesaturated(false);
			itemFrame.Icon:SetAlpha(1);
			itemFrame.IconBorder:SetDesaturation(0);
			itemFrame.IconBorder:SetAlpha(1);

			local transmogSlot = C_Transmog.GetSlotForInventoryType(itemFrame.invType);
			if ( C_TransmogSets.SetHasNewSourcesForSlot(setID, transmogSlot) ) then
				itemFrame.New:Show();
				itemFrame.New.Anim:Play();
			else
				itemFrame.New:Hide();
				itemFrame.New.Anim:Stop();
			end
		else
			itemFrame.Icon:SetDesaturated(true);
			itemFrame.Icon:SetAlpha(0.3);
			itemFrame.IconBorder:SetDesaturation(1);
			itemFrame.IconBorder:SetAlpha(0.3);
			itemFrame.New:Hide();
		end
		self:SetItemFrameQuality(itemFrame);
		itemFrame:SetPoint("TOP", self.DetailsFrame, "TOP", xOffset + (i - 1) * BUTTON_SPACE, -94);
		itemFrame:Show();
		if not addon.setdb.profile.autoHideSlot.toggle or( addon.setdb.profile.autoHideSlot.toggle and not addon.setdb.profile.autoHideSlot[sortedSources[i].invType -1]) then
			self.Model:TryOn(sortedSources[i].sourceID)
		end
	end

	-- variant sets
	local baseSetID = C_TransmogSets.GetBaseSetID(setID);
	local variantSets = SetsDataProvider:GetVariantSets(baseSetID);
	if ( #variantSets == 0 )  then
		self.DetailsFrame.VariantSetsButton:Hide();
	else
		self.DetailsFrame.VariantSetsButton:Show();
		self.DetailsFrame.VariantSetsButton:SetText(setInfo.description);
	end

end


function WardrobeCollectionFrame.SetsCollectionFrame:GetDefaultSetIDForBaseSet(baseSetID)
	if ( SetsDataProvider:IsBaseSetNew(baseSetID) ) then
		if ( C_TransmogSets.SetHasNewSources(baseSetID) ) then
			return baseSetID;
		else
			local variantSets = SetsDataProvider:GetVariantSets(baseSetID);
			for i, variantSet in ipairs(variantSets) do
				if ( C_TransmogSets.SetHasNewSources(variantSet.setID) ) then
					return variantSet.setID;
				end
			end
		end
	end

	if ( self.selectedVariantSets[baseSetID] ) then
		return self.selectedVariantSets[baseSetID];
	end

	local baseSet = SetsDataProvider:GetBaseSetByID(baseSetID);
	if ( baseSet.favoriteSetID ) then
		return baseSet.favoriteSetID;
	end
	-- pick the one with most collected, higher difficulty wins ties
	local highestCount = 0;
	local highestCountSetID;
	local variantSets = SetsDataProvider:GetVariantSets(baseSetID);
	for i = 1, #variantSets do
		local variantSetID = variantSets[i].setID;
		local numCollected = SetsDataProvider:GetSetSourceCounts(variantSetID);
		if ( numCollected > 0 and numCollected >= highestCount ) then
			highestCount = numCollected;
			highestCountSetID = variantSetID;
		end
	end
	return highestCountSetID or baseSetID;
end


function WardrobeCollectionFrame.SetsCollectionFrame:HandleKey(key)
	if (not self:GetSelectedSetID()) then
		return false
	end
	local selectedSetID = C_TransmogSets.GetBaseSetID(self:GetSelectedSetID())
	local _, index = SetsDataProvider:GetBaseSetByID(selectedSetID)
	if (not index) then
		return
	end
	if (key == WARDROBE_DOWN_VISUAL_KEY) then
		index = index + 1
	elseif (key == WARDROBE_UP_VISUAL_KEY) then
		index = index - 1
	end
	local sets = SetsDataProvider:GetBaseSets()
	index = Clamp(index, 1, #sets)
	self:SelectSet(self:GetDefaultSetIDForBaseSet(sets[index].setID))
	self:ScrollToSet(sets[index].setID)
end


function WardrobeCollectionFrame.SetsCollectionFrame:ScrollToSet(setID)
	local totalHeight = 0
	local scrollFrameHeight = self.ScrollFrame:GetHeight()
	local buttonHeight = self.ScrollFrame.buttonHeight
	for i, set in ipairs(SetsDataProvider:GetBaseSets()) do
		if (set.setID == setID) then
			local offset = self.ScrollFrame.scrollBar:GetValue()
			if (totalHeight + buttonHeight > offset + scrollFrameHeight) then
				offset = totalHeight + buttonHeight - scrollFrameHeight
			elseif (totalHeight < offset) then
				offset = totalHeight
			end
			self.ScrollFrame.scrollBar:SetValue(offset, true)
			break
		end
		totalHeight = totalHeight + buttonHeight
	end
end


WardrobeCollectionFrame.SetsCollectionFrame:SetScript("OnShow", WardrobeCollectionFrame.SetsCollectionFrame.OnShow)


function WardrobeCollectionFrame.SetsTransmogFrame:OnSearchUpdate()
	SetsDataProvider:ClearUsableSets()
	SetsDataProvider:FilterSearch()
	WardrobeCollectionFrame.SetsTransmogFrame:UpdateSets()
end


--local BetterWardrobeSetsTransmogMixin = CreateFromMixins(WardrobeSetsTransmogMixin)

function WardrobeCollectionFrame.SetsTransmogFrame:UpdateSets()
	local usableSets = SetsDataProvider:GetUsableSets(true)
	self.PagingFrame:SetMaxPages(ceil(#usableSets / self.PAGE_SIZE))
	local pendingTransmogModelFrame = nil
	local indexOffset = (self.PagingFrame:GetCurrentPage() - 1) * self.PAGE_SIZE
	for i = 1, self.PAGE_SIZE do
		local model = self.Models[i]
		local index = i + indexOffset
		local set = usableSets[index]

		if (set) then
			model:Show()

			--if (model.setID ~= set.setID) then
				model:Undress()
				local sourceData = SetsDataProvider:GetSetSourceData(set.setID)

				for sourceID in pairs(sourceData.sources) do
					--if (not Profile.HideMissing and not BW_WardrobeToggle.VisualMode) or (Profile.HideMissing and BW_WardrobeToggle.VisualMode) or (Profile.HideMissing and isMogKnown(sourceID)) then 
					if (not Profile.HideMissing and (not BW_WardrobeToggle.VisualMode or (Sets.isMogKnown(sourceID) and BW_WardrobeToggle.VisualMode))) or 
						(Profile.HideMissing and (BW_WardrobeToggle.VisualMode or Sets.isMogKnown(sourceID))) then 
						model:TryOn(sourceID)
					end
				end
			--end

			local transmogStateAtlas
			if (set.setID == self.appliedSetID and set.setID == self.selectedSetID) then
				transmogStateAtlas = "transmog-set-border-current-transmogged"
			elseif (set.setID == self.selectedSetID) then
				transmogStateAtlas = "transmog-set-border-selected"
				pendingTransmogModelFrame = model
			end

			if (transmogStateAtlas) then
				model.TransmogStateTexture:SetAtlas(transmogStateAtlas, true)
				model.TransmogStateTexture:Show()
			else
				model.TransmogStateTexture:Hide()
			end

			local topSourcesCollected, topSourcesTotal
			if addon.Profile.ShowIncomplete then 
				topSourcesCollected, topSourcesTotal = addon.Sets:GetLocationBasedCount(set)
			else
				topSourcesCollected, topSourcesTotal = SetsDataProvider:GetSetSourceCounts(set.setID) 
			end
 
			local setInfo = C_TransmogSets.GetSetInfo(set.setID)

			model.Favorite.Icon:SetShown(C_TransmogSets.GetIsFavorite(set.setID))
			model.setID = set.setID

			local isHidden = addon.HiddenAppearanceDB.profile.set[set.setID]
			model.CollectionListVisual.Hidden.Icon:SetShown(isHidden)


			local isInList = addon.CollectionList:IsInList(set.setID, "set")
			model.CollectionListVisual.Collection.Collection_Icon:SetShown(isInList)
			model.CollectionListVisual.Collection.Collected_Icon:SetShown(isInList and C_TransmogSets.IsBaseSetCollected(set.setID))

			model.SetInfo.setName:SetText((Profile.ShowNames and setInfo["name"].."\n"..(setInfo["description"] or "")) or "")
			model.SetInfo.progress:SetText((Profile.ShowSetCount and topSourcesCollected.."/".. topSourcesTotal) or "")
			model.setCollected = topSourcesCollected == topSourcesTotal


		else
			model:Hide()
		end
	end

	if (pendingTransmogModelFrame) then
		self.PendingTransmogFrame:SetParent(pendingTransmogModelFrame)
		self.PendingTransmogFrame:SetPoint("CENTER")
		self.PendingTransmogFrame:Show()
		if (self.PendingTransmogFrame.setID ~= pendingTransmogModelFrame.setID) then
			self.PendingTransmogFrame.TransmogSelectedAnim:Stop()
			self.PendingTransmogFrame.TransmogSelectedAnim:Play()
			self.PendingTransmogFrame.TransmogSelectedAnim2:Stop()
			self.PendingTransmogFrame.TransmogSelectedAnim2:Play()
			self.PendingTransmogFrame.TransmogSelectedAnim3:Stop()
			self.PendingTransmogFrame.TransmogSelectedAnim3:Play()
			self.PendingTransmogFrame.TransmogSelectedAnim4:Stop()
			self.PendingTransmogFrame.TransmogSelectedAnim4:Play()
			self.PendingTransmogFrame.TransmogSelectedAnim5:Stop()
			self.PendingTransmogFrame.TransmogSelectedAnim5:Play()
		end
		self.PendingTransmogFrame.setID = pendingTransmogModelFrame.setID
	else
		self.PendingTransmogFrame:Hide()
	end

	self.NoValidSetsLabel:SetShown(not C_TransmogSets.HasUsableSets())
end


function WardrobeCollectionFrame.SetsTransmogFrame:LoadSet(setID)
	local waitingOnData = false
	local transmogSources = { }
	local sources = C_TransmogSets.GetSetSources(setID)
	local combineSources = IsShiftKeyDown()
	local selectedItems = {}

	for sourceID in pairs(sources) do
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
		local slot = C_Transmog.GetSlotForInventoryType(sourceInfo.invType)
		local slotSources = C_TransmogSets.GetSourcesForSlot(setID, slot)
		if slotSources then 
			WardrobeCollectionFrame_SortSources(slotSources, sourceInfo.visualID)
			local index = WardrobeCollectionFrame_GetDefaultSourceIndex(slotSources, sourceID)
			local knownID = Sets.isMogKnown(sourceID)
			if knownID then transmogSources[slot] = knownID end

			if combineSources then 
				local transmogLocation = TransmogUtil.GetTransmogLocation(slot, Enum.TransmogType.Appearance, Enum.TransmogModification.None)
				local _, hasPending = C_Transmog.GetSlotInfo(transmogLocation)
				if hasPending then 
						local  baseSourceID, baseVisualID, appliedSourceID, appliedVisualID, appliedCategoryID, pendingSourceID, pendingVisualID  = C_Transmog.GetSlotVisualInfo(transmogLocation)
						--local _,_,_,_, pendingVisualID, pendingSourceID = C_Transmog.GetSlotVisualInfo(transmogLocation)
						local emptyappearanceID, emptySourceID = EmptyArmor[slot] and C_TransmogCollection.GetItemInfo(EmptyArmor[slot])
						if pendingVisualID == emptyappearanceID then
							C_Transmog.ClearPending(transmogLocation)
							transmogSources[slot] = slotSources[index].sourceID
						else				
							transmogSources[slot] = pendingSourceID
						end
				else
					transmogSources[slot] = (slotSources[index] and slotSources[index].sourceID) or sourceID
				end
			else

				transmogSources[slot] = (slotSources[index] and slotSources[index].sourceID) or sourceID
			end
	

			for i, slotSourceInfo in ipairs(slotSources) do
				if (not slotSourceInfo.name) then
					waitingOnData = true
				end
			end
		end
	end
	if (waitingOnData) then
		self.loadingSetID = setID
	else
		self.loadingSetID = nil
		-- if we don't ignore the event, clearing will momentarily set the page to the one with the set the user currently has transmogged
		-- if that's a different page from the current one then the models will flicker as we swap the gear to different sets and back
		self.ignoreTransmogrifyUpdateEvent = true
		C_Transmog.ClearAllPending();
		self.ignoreTransmogrifyUpdateEvent = false
		C_Transmog.LoadSources(transmogSources, -1, -1)
		local emptySlotData = addon.Sets:GetEmptySlots()

		if Profile.HiddenMog then				
			for i, x in pairs(transmogSources) do
				if not C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(x) and (i ~= 7 or i ~= 4 or i ~= 19) and emptySlotData[i] then
					local transmogLocation = TransmogUtil.GetTransmogLocation(i, Enum.TransmogType.Appearance, Enum.TransmogModification.None);

					local _, source = addon.GetItemSource(emptySlotData[i]) -- C_TransmogCollection.GetItemInfo(emptySlotData[i])
					C_Transmog.SetPending(transmogLocation, source, Enum.TransmogType.Appearance)
				end
			end
		end

		--hide any slots marked as alwayws hide
		local alwaysHideSlots = addon.setdb.profile.autoHideSlot
		for key, transmogSlot in pairs(TRANSMOG_SLOTS) do
			local slotID = transmogSlot.location:GetSlotID();
			if alwaysHideSlots[slotID] then 
				local transmogLocation = TransmogUtil.GetTransmogLocation(slotID, Enum.TransmogType.Appearance, Enum.TransmogModification.None);
				local _, source = addon.GetItemSource(emptySlotData[slotID]) -- C_TransmogCollection.GetItemInfo(emptySlotData[i])
				C_Transmog.SetPending(transmogLocation, source, Enum.TransmogType.Appearance)	
			end
		end

	end
end


function WardrobeTransmogButton_OnClick(self, button)
	local isTransmogrified, hasPending, isPendingCollected, canTransmogrify, cannotTransmogrifyReason, hasUndo = C_Transmog.GetSlotInfo(self.transmogLocation);
	-- save for sound to play on TRANSMOGRIFY_UPDATE event
	self.hadUndo = hasUndo;
	if ( button == "RightButton" ) then
		if ( hasPending or hasUndo ) then
			PlaySound(SOUNDKIT.UI_TRANSMOG_REVERTING_GEAR_SLOT);
			C_Transmog.ClearPending(self.transmogLocation);
			WardrobeTransmogButton_Select(self, true);
		elseif ( isTransmogrified ) then
			PlaySound(SOUNDKIT.UI_TRANSMOG_REVERTING_GEAR_SLOT);
			C_Transmog.SetPending(self.transmogLocation, 0);
			WardrobeTransmogButton_Select(self, true);
		end
	else
		PlaySound(SOUNDKIT.UI_TRANSMOG_GEAR_SLOT_CLICK);
		WardrobeTransmogButton_Select(self, true);
	end
	if ( self.UndoButton ) then
		self.UndoButton:Hide();
	end
	WardrobeTransmogButton_OnEnter(self);
end


function WardrobeCollectionFrame.SetsTransmogFrame:ResetPage()
	local page = 1
	if (self.selectedSetID) then
		local usableSets = SetsDataProvider:GetUsableSets(true)
		self.PagingFrame:SetMaxPages(ceil(#usableSets / self.PAGE_SIZE))
		for i, set in ipairs(usableSets) do
			if (set.setID == self.selectedSetID) then
				page = GetPage(i, self.PAGE_SIZE)
				break
			end
		end
	end
	self.PagingFrame:SetCurrentPage(page)
	self:UpdateSets()
end


function WardrobeCollectionFrame.SetsTransmogFrame:OnShow()
	self:RegisterEvent("TRANSMOGRIFY_UPDATE")
	self:RegisterEvent("TRANSMOGRIFY_SUCCESS")
	self:RegisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE")
	self:RegisterEvent("TRANSMOG_COLLECTION_UPDATED")
	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	self:RegisterEvent("TRANSMOG_SETS_UPDATE_FAVORITE")
	self:RefreshCameras()
	local RESET_SELECTION = true
	self:Refresh(RESET_SELECTION)
	WardrobeCollectionFrame.progressBar:Show()
	self:UpdateProgressBar()
	self.sourceQualityTable = { }
	addon.Init:BuildDB()

	addon.ExtendTransmogView()


	if HelpTip:IsShowing(WardrobeCollectionFrame, TRANSMOG_SETS_TAB_TUTORIAL) then
		HelpTip:Hide(WardrobeCollectionFrame, TRANSMOG_SETS_TAB_TUTORIAL);
		BW_WardrobeCollectionFrame.SetsTabHelpBox:Hide()
		SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_TRANSMOG_SETS_VENDOR_TAB, true)
	end
end




local function SetsTransmogFrame_OnHide()
	self:UnregisterEvent("TRANSMOGRIFY_UPDATE")
	self:UnregisterEvent("TRANSMOGRIFY_SUCCESS")
	self:UnregisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE")
	self:UnregisterEvent("TRANSMOG_COLLECTION_UPDATED")
	self:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED")
	self:UnregisterEvent("TRANSMOG_SETS_UPDATE_FAVORITE")
	self.loadingSetID = nil
	SetsDataProvider:ClearSets()
	WardrobeCollectionFrame_ClearSearch(LE_TRANSMOG_SEARCH_TYPE_USABLE_SETS)
	self.sourceQualityTable = nil
	BW_WardrobeToggle.VisualMode = false
end

--self:SecureHook(WardrobeCollectionFrame.SetsTransmogFrame,function() SetsTransmogFrame_OnHide() end)
--addon:SecureHook(WardrobeCollectionFrame_OnHide,function() SetsDataProvider:ClearSets() end)

--addon:SecureHook(WardrobeCollectionFrame.SetsTransmogFrame,"OnShow", function()  SetsDataProvider:ClearSets() end)



function WardrobeCollectionFrame.SetsTransmogFrame:OnEvent(event, ...)
	if (event == "TRANSMOGRIFY_UPDATE" and not self.ignoreTransmogrifyUpdateEvent) then
		self:Refresh()
	elseif (event == "TRANSMOGRIFY_SUCCESS") then
		-- this event fires once per slot so in the case of a set there would be up to 9 of them
		if (not self.transmogrifySuccessUpdate) then
			self.transmogrifySuccessUpdate = true
			C_Timer.After(0, function() self.transmogrifySuccessUpdate = nil self:Refresh() end)
		end
	elseif (event == "TRANSMOG_COLLECTION_UPDATED" or event == "TRANSMOG_SETS_UPDATE_FAVORITE") then
		SetsDataProvider:ClearSets()
		self:Refresh()
		self:UpdateProgressBar()
	elseif (event == "TRANSMOG_COLLECTION_ITEM_UPDATE") then
		if (self.loadingSetID) then
			local setID = self.loadingSetID
			self.loadingSetID = nil
			self:LoadSet(setID)
		end
		if (self.tooltipModel) then
			self.tooltipModel:RefreshTooltip()
		end
	elseif (event == "PLAYER_EQUIPMENT_CHANGED") then
		if (self.selectedSetID) then
			self:LoadSet(self.selectedSetID)
		end
		self:Refresh()
	end
end

WardrobeCollectionFrame.SetsTransmogFrame:SetScript("OnShow", WardrobeCollectionFrame.SetsTransmogFrame.OnShow)
--WardrobeCollectionFrame.SetsTransmogFrame:SetScript("OnHide", WardrobeCollectionFrame.SetsTransmogFrame.OnHide)
WardrobeCollectionFrame.SetsTransmogFrame:SetScript("OnEvent", WardrobeCollectionFrame.SetsTransmogFrame.OnEvent)

local function RefreshLists()
	local tabID = addon.GetTab()
				WardrobeCollectionFrame.SetsCollectionFrame:OnSearchUpdate()
				--WardrobeCollectionFrame.SetsTransmogFrame:OnSearchUpdate()
	end


function WardrobeCollectionFrame.SetsCollectionFrame.ScrollFrame:Update()
	local offset = HybridScrollFrame_GetOffset(self)
	local buttons = self.buttons
	local baseSets = SetsDataProvider:GetBaseSets()

	-- show the base set as selected
	local selectedSetID = self:GetParent():GetSelectedSetID()
	local selectedBaseSetID = selectedSetID and C_TransmogSets.GetBaseSetID(selectedSetID)

	for i = 1, #buttons do
		local button = buttons[i]
		local setIndex = i + offset
		if (setIndex <= #baseSets) then
			local baseSet = baseSets[setIndex]
			button:Show()
			button.Name:SetText(baseSet.name)
			local topSourcesCollected, topSourcesTotal = SetsDataProvider:GetSetSourceTopCounts(baseSet.setID)
			local setCollected = C_TransmogSets.IsBaseSetCollected(baseSet.setID)
			local color = IN_PROGRESS_FONT_COLOR
			if (setCollected) then
				color = NORMAL_FONT_COLOR
			elseif (topSourcesCollected == 0) then
				color = GRAY_FONT_COLOR
			end
			button.Name:SetTextColor(color.r, color.g, color.b)
			button.Label:SetText(baseSet.label)
			button.Icon:SetTexture(SetsDataProvider:GetIconForSet(baseSet.setID))
			button.Icon:SetDesaturation((topSourcesCollected == 0) and 1 or 0)
			button.SelectedTexture:SetShown(baseSet.setID == selectedBaseSetID)
			button.Favorite:SetShown(baseSet.favoriteSetID and true)
			local isHidden = addon.HiddenAppearanceDB.profile.set[baseSet.setID]
			button.CollectionListVisual.Hidden.Icon:SetShown(isHidden)

			local variantSets = SetsDataProvider:GetVariantSets(baseSet.setID)
			local variantSelected
			for i, data in ipairs(variantSets) do
				if addon.CollectionList:IsInList(data.setID, "set") then 
					variantSelected = data.setID
				end
			end

			local isInList = addon.CollectionList:IsInList(variantSelected and variantSelected or baseSet.setID, "set")
			button.CollectionListVisual.Collection.Collection_Icon:SetShown(isInList)
			button.CollectionListVisual.Collection.Collected_Icon:SetShown(isInList and C_TransmogSets.IsBaseSetCollected(baseSet.setID))
			button.New:SetShown(SetsDataProvider:IsBaseSetNew(baseSet.setID))
			button.setID = baseSet.setID

			if (topSourcesCollected == 0 or setCollected) then
				button.ProgressBar:Hide()
			else
				button.ProgressBar:Show()
				button.ProgressBar:SetWidth(SET_PROGRESS_BAR_MAX_WIDTH * topSourcesCollected / topSourcesTotal)
			end
			button.IconCover:SetShown(not setCollected)
		else
			button:Hide()
		end
	end

	local extraHeight = (self.largeButtonHeight and self.largeButtonHeight - BASE_SET_BUTTON_HEIGHT) or 0
	local totalHeight = #baseSets * BASE_SET_BUTTON_HEIGHT + extraHeight
	HybridScrollFrame_Update(self, totalHeight, self:GetHeight())
end
--This bit sets "update" which is set via on load and triggers when scrolling. Its what caused sorting issues
WardrobeCollectionFrame.SetsCollectionFrame.ScrollFrame.update = WardrobeCollectionFrame.SetsCollectionFrame.ScrollFrame.Update

