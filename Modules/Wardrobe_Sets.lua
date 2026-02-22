local addonName, addon = ...;
addon = LibStub("AceAddon-3.0"):GetAddon(addonName);

local Bizz_C_TransmogSets = C_TransmogSets
addon.C_TransmogSets = addon.C_TransmogSets or {}
local C_TransmogSets = {}
local L = LibStub("AceLocale-3.0"):GetLocale(addonName);

C_TransmogSets.GetSetInfo = addon.C_TransmogSets.GetSetInfo
C_TransmogSets.GetBaseSetID = addon.C_TransmogSets.GetBaseSetID
C_TransmogSets.GetSetNewSources = Bizz_C_TransmogSets.GetSetNewSources
C_TransmogSets.GetFilteredBaseSetsCounts = addon.C_TransmogSets.GetFilteredBaseSetsCounts
C_TransmogSets.SetHasNewSourcesForSlot = Bizz_C_TransmogSets.SetHasNewSourcesForSlot
C_TransmogSets.GetLatestSource = Bizz_C_TransmogSets.GetLatestSource
C_TransmogSets.GetSetsContainingSourceID = Bizz_C_TransmogSets.GetSetsContainingSourceID
C_TransmogSets.GetCameraIDs = Bizz_C_TransmogSets.GetCameraIDs
C_TransmogSets.GetVariantSets = addon.C_TransmogSets.GetVariantSets
C_TransmogSets.GetSourcesForSlot =  addon.C_TransmogSets.GetSourcesForSlot



local SET_MODEL_PAN_AND_ZOOM_LIMITS = {
	["Draenei2"] = { maxZoom = 2.2105259895325, panMaxLeft = -0.56983226537705, panMaxRight = 0.82581323385239, panMaxTop = -0.17342753708363, panMaxBottom = -2.6428601741791 },
	["Draenei3"] = { maxZoom = 3.0592098236084, panMaxLeft = -0.33429977297783, panMaxRight = 0.29183092713356, panMaxTop = -0.079871296882629, panMaxBottom = -2.4141833782196 },
	["Worgen2"] = { maxZoom = 1.9605259895325, panMaxLeft = -0.64045578241348, panMaxRight = 0.59410041570663, panMaxTop = -0.11050206422806, panMaxBottom = -2.2492413520813 },
	["Worgen3"] = { maxZoom = 2.9013152122498, panMaxLeft = -0.2526838183403, panMaxRight = 0.38198262453079, panMaxTop = -0.10407017171383, panMaxBottom = -2.4137926101685 },
	["Worgen3Alt"] = { maxZoom = 3.3618412017822, panMaxLeft = -0.19753229618072, panMaxRight = 0.26802557706833, panMaxTop = -0.073476828634739, panMaxBottom = -1.9255120754242 },
	["Worgen2Alt"] = { maxZoom = 2.9605259895325, panMaxLeft = -0.33268970251083, panMaxRight = 0.36896070837975, panMaxTop = -0.14780110120773, panMaxBottom = -2.1662468910217 },
	["Scourge2"] = { maxZoom = 3.1710526943207, panMaxLeft = -0.3243542611599, panMaxRight = 0.5625838637352, panMaxTop = -0.054175414144993, panMaxBottom = -1.7261047363281 },
	["Scourge3"] = { maxZoom = 2.7105259895325, panMaxLeft = -0.35650563240051, panMaxRight = 0.41562974452972, panMaxTop = -0.07072202116251, panMaxBottom = -1.877711892128 },
	["Orc2"] = { maxZoom = 2.5526309013367, panMaxLeft = -0.64236557483673, panMaxRight = 0.77098786830902, panMaxTop = -0.075792260468006, panMaxBottom = -2.0818419456482 },
	["Orc3"] = { maxZoom = 3.2960524559021, panMaxLeft = -0.22763830423355, panMaxRight = 0.32022559642792, panMaxTop = -0.038521766662598, panMaxBottom = -2.0473554134369 },
	["Gnome3"] = { maxZoom = 2.9605259895325, panMaxLeft = -0.29900181293488, panMaxRight = 0.35779395699501, panMaxTop = -0.076380833983421, panMaxBottom = -0.99909907579422 },
	["Gnome2"] = { maxZoom = 2.8552639484406, panMaxLeft = -0.2777853012085, panMaxRight = 0.29651582241058, panMaxTop = -0.095201380550861, panMaxBottom = -1.0263166427612 },
	["Dwarf2"] = { maxZoom = 2.9605259895325, panMaxLeft = -0.50352156162262, panMaxRight = 0.4159924685955, panMaxTop = -0.07211934030056, panMaxBottom = -1.4946432113648 },
	["Dwarf3"] = { maxZoom = 2.8947370052338, panMaxLeft = -0.37057432532311, panMaxRight = 0.43383255600929, panMaxTop = -0.084960877895355, panMaxBottom = -1.7173190116882 },
	["BloodElf3"] = { maxZoom = 3.1644730567932, panMaxLeft = -0.2654082775116, panMaxRight = 0.28886350989342, panMaxTop = -0.049619361758232, panMaxBottom = -1.9943760633469 },
	["BloodElf2"] = { maxZoom = 3.1710524559021, panMaxLeft = -0.25901651382446, panMaxRight = 0.45525884628296, panMaxTop = -0.085230752825737, panMaxBottom = -2.0548067092895 },
	["Troll2"] = { maxZoom = 2.2697355747223, panMaxLeft = -0.58214980363846, panMaxRight = 0.5104039311409, panMaxTop = -0.05494449660182, panMaxBottom = -2.3443803787231 },
	["Troll3"] = { maxZoom = 3.1249995231628, panMaxLeft = -0.35141581296921, panMaxRight = 0.50875341892242, panMaxTop = -0.063820324838161, panMaxBottom = -2.4224486351013 },
	["Tauren2"] = { maxZoom = 2.1118416786194, panMaxLeft = -0.82946360111237, panMaxRight = 0.83975899219513, panMaxTop = -0.061676319688559, panMaxBottom = -2.035267829895 },
	["Tauren3"] = { maxZoom = 2.9605259895325, panMaxLeft = -0.37433895468712, panMaxRight = 0.40420442819595, panMaxTop = -0.1868137717247, panMaxBottom = -2.2116675376892 },
	["NightElf3"] = { maxZoom = 2.9539475440979, panMaxLeft = -0.27334463596344, panMaxRight = 0.27148312330246, panMaxTop = -0.094710879027844, panMaxBottom = -2.3087983131409 },
	["NightElf2"] = { maxZoom = 2.9144732952118, panMaxLeft = -0.45042458176613, panMaxRight = 0.47114592790604, panMaxTop = -0.10513981431723, panMaxBottom = -2.4612309932709 },
	["Human3"] = { maxZoom = 3.3618412017822, panMaxLeft = -0.19753229618072, panMaxRight = 0.26802557706833, panMaxTop = -0.073476828634739, panMaxBottom = -1.9255120754242 },
	["Human2"] = { maxZoom = 2.9605259895325, panMaxLeft = -0.33268970251083, panMaxRight = 0.36896070837975, panMaxTop = -0.14780110120773, panMaxBottom = -2.1662468910217 },
	["Pandaren3"] = { maxZoom = 2.5921046733856, panMaxLeft = -0.45187762379646, panMaxRight = 0.54132586717606, panMaxTop = -0.11439494043589, panMaxBottom = -2.2257535457611 },
	["Pandaren2"] = { maxZoom = 2.9342107772827, panMaxLeft = -0.36421552300453, panMaxRight = 0.50203305482864, panMaxTop = -0.11241528391838, panMaxBottom = -2.3707413673401 },
	["Goblin2"] = { maxZoom = 2.4605259895325, panMaxLeft = -0.31328883767128, panMaxRight = 0.39014467597008, panMaxTop = -0.089733943343162, panMaxBottom = -1.3402827978134 },
	["Goblin3"] = { maxZoom = 2.9605259895325, panMaxLeft = -0.26144406199455, panMaxRight = 0.30945864319801, panMaxTop = -0.07625275105238, panMaxBottom = -1.2928194999695 },
	["LightforgedDraenei2"] = { maxZoom = 2.2105259895325, panMaxLeft = -0.56983226537705, panMaxRight = 0.82581323385239, panMaxTop = -0.17342753708363, panMaxBottom = -2.6428601741791 },
	["LightforgedDraenei3"] = { maxZoom = 3.0592098236084, panMaxLeft = -0.33429977297783, panMaxRight = 0.29183092713356, panMaxTop = -0.079871296882629, panMaxBottom = -2.4141833782196 },
	["HighmountainTauren2"] = { maxZoom = 2.1118416786194, panMaxLeft = -0.82946360111237, panMaxRight = 0.83975899219513, panMaxTop = -0.061676319688559, panMaxBottom = -2.035267829895 },
	["HighmountainTauren3"] = { maxZoom = 2.9605259895325, panMaxLeft = -0.37433895468712, panMaxRight = 0.40420442819595, panMaxTop = -0.1868137717247, panMaxBottom = -2.2116675376892 },
	["Nightborne3"] = { maxZoom = 2.9539475440979, panMaxLeft = -0.27334463596344, panMaxRight = 0.27148312330246, panMaxTop = -0.094710879027844, panMaxBottom = -2.3087983131409 },
	["Nightborne2"] = { maxZoom = 2.9144732952118, panMaxLeft = -0.45042458176613, panMaxRight = 0.47114592790604, panMaxTop = -0.10513981431723, panMaxBottom = -2.4612309932709 },
	["VoidElf3"] = { maxZoom = 3.1644730567932, panMaxLeft = -0.2654082775116, panMaxRight = 0.28886350989342, panMaxTop = -0.049619361758232, panMaxBottom = -1.9943760633469 },
	["VoidElf2"] = { maxZoom = 3.1710524559021, panMaxLeft = -0.25901651382446, panMaxRight = 0.45525884628296, panMaxTop = -0.085230752825737, panMaxBottom = -2.0548067092895 },
	["MagharOrc2"] = { maxZoom = 2.5526309013367, panMaxLeft = -0.64236557483673, panMaxRight = 0.77098786830902, panMaxTop = -0.075792260468006, panMaxBottom = -2.0818419456482 },
	["MagharOrc3"] = { maxZoom = 3.2960524559021, panMaxLeft = -0.22763830423355, panMaxRight = 0.32022559642792, panMaxTop = -0.038521766662598, panMaxBottom = -2.0473554134369 },
	["DarkIronDwarf2"] = { maxZoom = 2.9605259895325, panMaxLeft = -0.50352156162262, panMaxRight = 0.4159924685955, panMaxTop = -0.07211934030056, panMaxBottom = -1.4946432113648 },
	["DarkIronDwarf3"] = { maxZoom = 2.8947370052338, panMaxLeft = -0.37057432532311, panMaxRight = 0.43383255600929, panMaxTop = -0.084960877895355, panMaxBottom = -1.7173190116882 },
	["KulTiran2"] = { maxZoom =  1.71052598953247, panMaxLeft = -0.667941331863403, panMaxRight = 0.589463412761688, panMaxTop = -0.373320609331131, panMaxBottom = -2.7329957485199 },
	["KulTiran3"] = { maxZoom =  2.22368383407593, panMaxLeft = -0.43183308839798, panMaxRight = 0.445900857448578, panMaxTop = -0.303212702274323, panMaxBottom = -2.49550628662109 },
	["ZandalariTroll2"] = { maxZoom =  2.1710512638092, panMaxLeft = -0.487841755151749, panMaxRight = 0.561356604099274, panMaxTop = -0.385127544403076, panMaxBottom = -2.78562784194946 },
	["ZandalariTroll3"] = { maxZoom =  3.32894563674927, panMaxLeft = -0.376705944538116, panMaxRight = 0.488780438899994, panMaxTop = -0.20890490710735, panMaxBottom = -2.67064166069031 },
	["Mechagnome3"] = { maxZoom = 2.9605259895325, panMaxLeft = -0.29900181293488, panMaxRight = 0.35779395699501, panMaxTop = -0.076380833983421, panMaxBottom = -0.99909907579422 },
	["Mechagnome2"] = { maxZoom = 2.8552639484406, panMaxLeft = -0.2777853012085, panMaxRight = 0.29651582241058, panMaxTop = -0.095201380550861, panMaxBottom = -1.0263166427612 },
	["Vulpera2"] = { maxZoom = 2.4605259895325, panMaxLeft = -0.31328883767128, panMaxRight = 0.39014467597008, panMaxTop = -0.089733943343162, panMaxBottom = -1.3402827978134 },
	["Vulpera3"] = { maxZoom = 2.9605259895325, panMaxLeft = -0.26144406199455, panMaxRight = 0.30945864319801, panMaxTop = -0.07625275105238, panMaxBottom = -1.2928194999695 },
	["Dracthyr2"] = { maxZoom = 2.1118416786194, panMaxLeft = -0.72946360111237, panMaxRight = 0.83975899219513, panMaxTop = -0.061676319688559, panMaxBottom = -2.035267829895 },
	["Dracthyr3"] = { maxZoom = 2.9605259895325, panMaxLeft = -0.37433895468712, panMaxRight = 0.40420442819595, panMaxTop = -0.1868137717247, panMaxBottom = -2.2116675376892 },
	["Dracthyr3Alt"] = { maxZoom = 3.3618412017822, panMaxLeft = -0.19753229618072, panMaxRight = 0.26802557706833, panMaxTop = -0.073476828634739, panMaxBottom = -1.9255120754242 },
	["Dracthyr2Alt"] = { maxZoom = 3.1710524559021, panMaxLeft = -0.25901651382446, panMaxRight = 0.45525884628296, panMaxTop = -0.085230752825737, panMaxBottom = -2.0548067092895 },
	["EarthenDwarf2"] = { maxZoom = 2.9605259895325, panMaxLeft = -0.50352156162262, panMaxRight = 0.4159924685955, panMaxTop = -0.07211934030056, panMaxBottom = -1.4946432113648 },
	["EarthenDwarf3"] = { maxZoom = 2.8947370052338, panMaxLeft = -0.37057432532311, panMaxRight = 0.43383255600929, panMaxTop = -0.084960877895355, panMaxBottom = -1.7173190116882 },
	["Harronir3"] = { maxZoom = 2.9539475440979, panMaxLeft = -0.27334463596344, panMaxRight = 0.27148312330246, panMaxTop = -0.094710879027844, panMaxBottom = -2.3087983131409 },
	["Harronir2"] = { maxZoom = 2.9144732952118, panMaxLeft = -0.45042458176613, panMaxRight = 0.47114592790604, panMaxTop = -0.10513981431723, panMaxBottom = -2.4612309932709 },
};

local g_selectionBehavior = nil;

-- ************************************************************************************************************************************************************
-- **** SETS LIST *********************************************************************************************************************************************
-- ************************************************************************************************************************************************************

local BASE_SET_BUTTON_HEIGHT = 46;
local VARIANT_SET_BUTTON_HEIGHT = 20;
local SET_PROGRESS_BAR_MAX_WIDTH = 204;
local IN_PROGRESS_FONT_COLOR = CreateColor(0.251, 0.753, 0.251);
local IN_PROGRESS_FONT_COLOR_CODE = "|cff40c040";

local Sets = addon.Sets or {};
addon.Sets = Sets
local tabType = {"item", "set", "extraset"}


local SetsDataProvider = CreateFromMixins(BetterWardrobeSetsDataProviderMixin);

local WardrobeSetsCollectionMixin = {};
BetterWardrobeSetsCollectionMixin = WardrobeSetsCollectionMixin

function WardrobeSetsCollectionMixin:OnLoad()
	self.RightInset.BGCornerTopLeft:Hide();
	self.RightInset.BGCornerTopRight:Hide();

	self.DetailsFrame.itemFramesPool = CreateFramePool("FRAME", self.DetailsFrame, "BetterWardrobeSetsDetailsItemFrameTemplate");

	self.DetailsFrame.VariantSetsDropdown:SetSelectionTranslator(function(selection)
		local variantSet = selection.data;
		return variantSet.description or variantSet.name;
	end);

	self.DetailsFrame.VariantSetsDropdown.PrecedingVariantIcon:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		GameTooltip_SetTitle(GameTooltip, TRANSMOG_SET_GRANTS_PRECEDING_VARIANTS, NORMAL_FONT_COLOR, true);
		GameTooltip:Show();
	end);
	self.DetailsFrame.VariantSetsDropdown.PrecedingVariantIcon:SetScript("OnLeave", GameTooltip_Hide);


	self.selectedVariantSets = { };
end

function WardrobeSetsCollectionMixin:OnShow()

	self:RegisterEvent("GET_ITEM_INFO_RECEIVED");
	self:RegisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE");
	self:RegisterEvent("TRANSMOG_COLLECTION_UPDATED");
	-- select the first set if not init
	local baseSets = SetsDataProvider:GetBaseSets();
	local defaultSetID = baseSets and baseSets[1] and self:GetDefaultSetIDForBaseSet(baseSets[1].setID) or nil;
	if ( not self.init ) then
		self.init = true;
		if ( defaultSetID ) then
			self.ListContainer:UpdateDataProvider();
			self:SelectSet(defaultSetID);
		end

		local savedSets = addon.GetSavedList();
		if ( savedSets and savedSets[1] ) then
			self.selectedSavedSetID = savedSets[1].setID;
		end
	else
		local selectedSetID = self:GetSelectedSetID();
		if ( not selectedSetID ) then --or not C_TransmogSets.IsSetVisible(selectedSetID) ) then
			if ( defaultSetID ) then
				self:SelectSet(defaultSetID);
			end
		end
		self:Refresh();
	end

	if defaultSetID then
		local latestSource = C_TransmogSets.GetLatestSource();
		if ( latestSource ~= Constants.Transmog.NoTransmogID ) then
			local sets = C_TransmogSets.GetSetsContainingSourceID(latestSource);
			local setID = sets and sets[1];
			if ( setID ) then
				self:SelectSet(setID);
				local baseSetID = C_TransmogSets.GetBaseSetID(setID);
				self:ScrollToSet(baseSetID, ScrollBoxConstants.AlignCenter);
			end
			self:ClearLatestSource();
		end
	end
	self.DetailsFrame.VariantSetsDropdown:SetupMenu(function(dropdown, rootDescription)
		rootDescription:SetTag("MENU_WARDROBE_VARIANT_SETS");

		local selectedSetID = self:GetSelectedSetID();
		-- If the player has all sets filtered out, there is a chance for this to be nil
		-- If this is nil, the VariantSetsDropdown should not be visible
		if not selectedSetID then
			return;
		end
		--local baseSet = SetsDataProvider:GetBaseSetByID(selectedSetID);
		--if BetterWardrobeCollectionFrame.selectedCollectionTab ~= 4 then
		--variantSets = addon.VariantSets[baseSet.baseSetID] or {}--C_TransmogSets.GetVariantSets(baseSet.baseSetID) or {};
		--if #variantSets > 0 then
			-- variant sets are already filtered for visibility (won't get a hiddenUntilCollected one unless it's collected)
			-- any set will do so just picking first one
			--displayData = variantSets[1];
		--end

		local baseSetID = C_TransmogSets.GetBaseSetID(selectedSetID);

		local function IsSelected(variantSet)
			return variantSet.setID == self:GetSelectedSetID();
		end
		
		local function SetSelected(variantSet)
			self:SelectSet(variantSet.setID);
			local desc = variantSet.description or variantSet.name

			self.DetailsFrame.VariantSetsDropdown:SetText(desc);
		end

		if not baseSetID then return end

		local variantSets = SetsDataProvider:GetVariantSets(baseSetID) or {}

		for index, variantSet in ipairs(SetsDataProvider:GetVariantSets(baseSetID)) do
			--if not variantSet.hiddenUntilCollected or variantSet.collected then
				variantSet.description = variantSet.description or variantSet.name or ""

				local numSourcesCollected, numSourcesTotal = SetsDataProvider:GetSetSourceCounts(variantSet.setID);
				local colorCode = IN_PROGRESS_FONT_COLOR_CODE;
				if numSourcesCollected == numSourcesTotal then
					colorCode = NORMAL_FONT_COLOR_CODE;
				elseif numSourcesCollected == 0 then
					colorCode = GRAY_FONT_COLOR_CODE;
				end

				assertsafe(variantSet.description ~= nil, "TransmogSet %s (%d) missing description / difficulty variant", variantSet.name, variantSet.setID);

				local text = format(ITEM_SET_NAME, (variantSet.description or variantSet.name)..colorCode, numSourcesCollected, numSourcesTotal);
				rootDescription:CreateRadio(text, IsSelected, SetSelected, variantSet);
			--end
		end
	end);

	BetterWardrobeCollectionFrame.progressBar:Show();
	self:UpdateProgressBar();
	self:RefreshCameras();
end

function WardrobeSetsCollectionMixin:OnHide()
	self:UnregisterEvent("GET_ITEM_INFO_RECEIVED");
	self:UnregisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE");
	self:UnregisterEvent("TRANSMOG_COLLECTION_UPDATED");
	SetsDataProvider:ClearSets();
	self:GetParent():ClearSearch(Enum.TransmogSearchType.BaseSets);
end

function WardrobeSetsCollectionMixin:OnEvent(event, ...)
	if ( event == "GET_ITEM_INFO_RECEIVED" ) then
		local itemID = ...;
		for itemFrame in self.DetailsFrame.itemFramesPool:EnumerateActive() do
			if ( itemFrame.itemID == itemID ) then
				self:SetItemFrameQuality(itemFrame);
				break;
			end
		end
	elseif ( event == "TRANSMOG_COLLECTION_ITEM_UPDATE" ) then
		for itemFrame in self.DetailsFrame.itemFramesPool:EnumerateActive() do
			self:SetItemFrameQuality(itemFrame);
		end
	elseif ( event == "TRANSMOG_COLLECTION_UPDATED" ) then
		SetsDataProvider:ClearSets();
		self:Refresh();
		self:UpdateProgressBar();
		self:ClearLatestSource();
	end
end

function WardrobeSetsCollectionMixin:UpdateProgressBar()
	self:GetParent():UpdateProgressBar(C_TransmogSets.GetFilteredBaseSetsCounts());
end

function WardrobeSetsCollectionMixin:ClearLatestSource()
	C_TransmogSets.ClearLatestSource();
	BetterWardrobeCollectionFrame:UpdateTabButtons();
end

function WardrobeSetsCollectionMixin:Refresh()
	self.ListContainer:UpdateDataProvider();
	self:UpdateProgressBar();
	self:DisplaySet(self:GetSelectedSetID());
end


function WardrobeSetsCollectionMixin:DisplaySet(setID)
	if not setID then return end

	local setInfo = (setID and C_TransmogSets.GetSetInfo(setID)) or nil;
	local buildID = (select(4, GetBuildInfo())) or nil;

	if ( not setInfo ) then
		self.DetailsFrame:Hide();
		self.Model:Hide();
		return;
	else
		self.DetailsFrame:Show();
		self.Model:Show();
	end

	self.DetailsFrame.BW_LinkSetButton.setID = setID;
	local sources = setInfo.sources or {};

	local holidayName = nil
	for sourceID,_ in pairs(sources) do
		holidayName = C_TransmogCollection.GetSourceRequiredHoliday(sourceID);
		if holidayName then  
			break 
		end
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

	if holidayName then
		self.DetailsFrame.HolidayLabel:Show() 
		self.DetailsFrame.HolidayLabel:SetText(TRANSMOG_APPEARANCE_USABLE_HOLIDAY:format(holidayName));
	else
		self.DetailsFrame.HolidayLabel:Hide() 
	end

	self.DetailsFrame.Label:SetText((setInfo.label or "")..((not setInfo.isClass and setInfo.className) and " -"..setInfo.className.."-" or "") );

	--@debug@
		self.DetailsFrame.HolidayLabel:Show() 
		self.DetailsFrame.HolidayLabel:SetText(setID);
	--@end-debug@

	if ((setInfo.description == ELITE) and setInfo.patchID < buildID) or (setID <= 1446 and setID >=1436) then
		setInfo.noLongerObtainable = true;
		setInfo.limitedTimeSet = nil;
	end


	if setInfo.limitedTimeSet then
		self.DetailsFrame.LimitedSet.Text:SetText(TRANSMOG_SET_LIMITED_TIME_SET);
		self.DetailsFrame.LimitedSet:Show();

		--self.DetailsFrame.LimitedSet.Text:SetText(TRANSMOG_SET_LIMITED_TIME_SET)--factionNames.opposingFaction)--.." only");
	elseif setInfo.noLongerObtainable then
		self.DetailsFrame.LimitedSet.Icon:SetAtlas("transmog-icon-remove");
		self.DetailsFrame.LimitedSet.Text:SetText(L["No Longer Obtainable"]);
		self.DetailsFrame.LimitedSet:Show();
	else
		self.DetailsFrame.LimitedSet:Hide();
	end
		

	if setInfo.requiredFaction then
		if setInfo.requiredFaction == "Alliance" then
			self.DetailsFrame.Faction:Show()
			self.DetailsFrame.Faction.Alliance:Show()
			self.DetailsFrame.Faction.Horde:Hide()

		elseif setInfo.requiredFaction == "Horde" then
			self.DetailsFrame.Faction:Show()
			self.DetailsFrame.Faction.Horde:Show()
			self.DetailsFrame.Faction.Alliance:Hide()

		end

		self.DetailsFrame.Faction.Horde:SetDesaturated(true)
		self.DetailsFrame.Faction.Horde:SetAlpha(.9)
		self.DetailsFrame.Faction.Alliance:SetDesaturated(true)
		self.DetailsFrame.Faction.Alliance:SetAlpha(.4)

	else
		self.DetailsFrame.Faction:Hide()
		self.DetailsFrame.Faction.Horde:Hide()
		self.DetailsFrame.Faction.Alliance:Hide()
	end

	self.DetailsFrame.Label:SetText(setInfo.label);
	self.DetailsFrame.LimitedSet:SetShown(setInfo.limitedTimeSet);

	local newSourceIDs = C_TransmogSets.GetSetNewSources(setID);
	--	local newSourceIDs = C_TransmogSets.GetSetNewSources(setID) or addon.GetSetNewSources(setID);


	self.DetailsFrame.itemFramesPool:ReleaseAll();
	self.Model:Undress();
	local BUTTON_SPACE = 37;	-- button width + spacing between 2 buttons
	local sortedSources = SetsDataProvider:GetSortedSetSources(setID);
	
	local row1 = #sortedSources;
	local row2 = 0;
	local yOffset1 = -94;
	if row1 > 10 then
		row2 = row1 - 10;
		row1 = 10;
		yOffset1 = -74;
	end
	local xOffset = -floor((row1 - 1) * BUTTON_SPACE / 2)
	local xOffset2 = -floor((row2 - 1) * BUTTON_SPACE / 2)
	local yOffset2 = yOffset1 - 40;
	local move = (#sortedSources > 10)

	self.DetailsFrame.IconRowBackground:ClearAllPoints()
	self.DetailsFrame.IconRowBackground:SetPoint("TOP", 0, move and -50 or -78)
	self.DetailsFrame.IconRowBackground:SetHeight(move and 120 or 64)
	self.DetailsFrame.Name:ClearAllPoints()
	self.DetailsFrame.Name:SetPoint("TOP", 0,  move and -17 or -37)
	self.DetailsFrame.LongName:ClearAllPoints()
	self.DetailsFrame.LongName:SetPoint("TOP", 0, move and -10 or -30)
	self.DetailsFrame.Label:ClearAllPoints()
	self.DetailsFrame.Label:SetPoint("TOP", 0, move and -43 or -63)


	local mainShoulder, offShoulder, mainHand, offHand

	for i = 1, #sortedSources do
		local itemFrame = self.DetailsFrame.itemFramesPool:Acquire();
		itemFrame.sourceID = sortedSources[i].sourceID;
		itemFrame.itemID = sortedSources[i].itemID;
		itemFrame.collected = sortedSources[i].collected;
		itemFrame.invType = sortedSources[i].invType;
		itemFrame.setID = setID
		local slot = C_Transmog.GetSlotForInventoryType(itemFrame.invType)
		local altid = addon:CheckAltItem(itemFrame.sourceID)
		if altid and type(altid) ~= "table" then
			altid = {altid}
		end

		if altid then
			itemFrame.AltItem:Show()
			itemFrame.AltItem.baseId = itemFrame.sourceID
			itemFrame.AltItem.altid = altid
			--itemFrame.AltItem.useAlt = true
			itemFrame.AltItem.setID = setID
			itemFrame.AltItem.index = itemFrame.AltItem.index or 0

		else
			itemFrame.AltItem:Hide()
			itemFrame.AltItem.baseId = nil
			itemFrame.AltItem.altid = nil
			itemFrame.AltItem.useAlt = false
			itemFrame.AltItem.setID = nil
			itemFrame.AltItem.index = nil
		end

		if itemFrame.AltItem.useAlt then 
			itemFrame.sourceID = altid[itemFrame.AltItem.index]
		end

		if slot == 3 and not mainShoulder then 
			mainShoulder = itemFrame.sourceID;
			offShoulder = setInfo.offShoulder;
		elseif slot ==16 then 
			mainHand = itemFrame.sourceID;
		elseif slot == 17 then
			offhand = itemFrame.sourceID;
		end

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

		itemFrame.Replacement:SetAlpha(0.3);

		local hasSubItem = addon.HasSubItem(setID)
		--Show marker if the item has been swapped
		if hasSubItem and hasSubItem[itemFrame.sourceID] then
			itemFrame.Replacement:Show()
		else
			itemFrame.Replacement:Hide()
		end

		self:SetItemFrameQuality(itemFrame);
		self:SetItemUseability(itemFrame);

		if i <= 10 then
			itemFrame:SetPoint("TOP", self.DetailsFrame, "TOP", xOffset + (i - 1) * BUTTON_SPACE, yOffset1);
		else
			itemFrame:SetPoint("TOP", self.DetailsFrame, "TOP", xOffset2 + (i - 11) * BUTTON_SPACE, yOffset2);
		end
		itemFrame:Show();

		local invType = sortedSources[i].invType - 1;

		if invType  == 20 then invType = 5 end
		if not addon.setdb.profile.autoHideSlot.toggle or ( addon.setdb.profile.autoHideSlot.toggle and not addon.setdb.profile.autoHideSlot[invType]) then
			if itemFrame.AltItem.useAlt then 
				self.Model:TryOn(itemFrame.AltItem.altid[itemFrame.AltItem.index]);
			else
				self.Model:TryOn(sortedSources[i].sourceID);
			end
		end
	end

	-- variant sets
	local showVariantSetsDropdown = false;
	local variantSets
	if (BetterWardrobeCollectionFrame.selectedCollectionTab ~= TAB_SAVED_SETS ) then

		-- variant sets
		local baseSetID = C_TransmogSets.GetBaseSetID(setID);

		variantSets = SetsDataProvider:GetVariantSets(baseSetID);
		if variantSets then
			local numVisibleSets = 0;
			for i, set in ipairs(variantSets) do
				--if not set.hiddenUntilCollected or set.collected then
					numVisibleSets = numVisibleSets + 1;
				--end
			end
			showVariantSetsDropdown = numVisibleSets > 1;
		end
	end

	if (BetterWardrobeCollectionFrame.selectedCollectionTab == TAB_SAVED_SETS ) then
		showVariantSetsDropdown = false
	end

	if showVariantSetsDropdown then
		self.DetailsFrame.VariantSetsDropdown:Show();
		local desc = setInfo.description or setInfo.name
		self.DetailsFrame.VariantSetsDropdown:SetText(desc);
	else
		self.DetailsFrame.VariantSetsDropdown:Hide();
	end

	local showPrecedingVariantIcon = false;
	if (BetterWardrobeCollectionFrame.selectedCollectionTab == 2 ) then
		-- Preceding variant icon
		if showVariantSetsDropdown and variantSets then
			showPrecedingVariantIcon = true;
			local foundPrecedingVariantSet = false;
			for _, set in ipairs(variantSets) do
				--if (set.uiOrder < setInfo.uiOrder) and (not set.hiddenUntilCollected or set.collected) then
				if (set.uiOrder < setInfo.uiOrder) then
					foundPrecedingVariantSet = true;
					if not set.grantAsPrecedingVariant then
						-- found a preceding variant set that doesn't have the flag, don't show the variant icon
						showPrecedingVariantIcon = false;
						break;
					end
				end
			end

			-- If we never found a preceding variant set, don't show the variant icon
			showPrecedingVariantIcon = showPrecedingVariantIcon and foundPrecedingVariantSet;
		end
	end

	self.DetailsFrame.VariantSetsDropdown.PrecedingVariantIcon:SetShown(showPrecedingVariantIcon);
end

function BetterWardrobeSetsCollectionMixin:SetItemUseability(itemFrame)
	itemFrame.CanUse:Hide()
	local itemCollectionStatus = itemFrame.itemCollectionStatus;
	if itemCollectionStatus == "CollectedCharCantUse" then
		itemFrame.CanUse:Show();
		--itemFrame.Icon:SetDesaturated(false);
		itemFrame.CanUse.Icon:SetDesaturation(0);
		itemFrame.CanUse.Icon:SetVertexColor(1,0.8,0);

		itemFrame.CanUse.Icon:SetAtlas("PlayerRaidBlip");		
		--itemFrame.Icon:SetAlpha(0.6);
		itemFrame.CanUse.Icon:SetAlpha(0.5);
	elseif itemCollectionStatus ==  "NotCollectedUnavailable"then
		itemFrame.CanUse:Show();
		---itemFrame.Icon:SetDesaturated(true);
		itemFrame.CanUse.Icon:SetDesaturation(0);
		itemFrame.CanUse.Icon:SetVertexColor(1,1,1);
		itemFrame.CanUse.Icon:SetAtlas("PlayerDeadBlip");
		--itemFrame.Icon:SetAlpha(0.3);
		itemFrame.CanUse.Icon:SetAlpha(0.5);
		--itemFrame.New:Hide();
	else
		itemFrame.CanUse:Hide();
	end
end

function WardrobeSetsCollectionMixin:SetItemFrameQuality(itemFrame)
	if itemFrame.collected then
		local quality = C_TransmogCollection.GetSourceInfo(itemFrame.sourceID).quality;


		local atlasData = ColorManager.GetAtlasDataForWardrobeSetItemQuality(quality);
		if atlasData then
			itemFrame.IconBorder:SetAtlas(atlasData.atlas, true);

			if atlasData.overrideColor then
				itemFrame.IconBorder:SetVertexColor(atlasData.overrideColor.r, atlasData.overrideColor.g, atlasData.overrideColor.b);
			else
				itemFrame.IconBorder:SetVertexColor(1, 1, 1);
			end
		end
	else
		itemFrame.IconBorder:SetAtlas("loottab-set-itemborder-white", true);
		itemFrame.IconBorder:SetVertexColor(1, 1, 1);
	end
end

function WardrobeSetsCollectionMixin:OnSearchUpdate()
	if ( self.init ) then
		SetsDataProvider:ClearBaseSets();
		SetsDataProvider:ClearVariantSets();
		SetsDataProvider:ClearUsableSets();
		self:Refresh();
	end
end

function WardrobeSetsCollectionMixin:OnUnitModelChangedEvent()
	if ( IsUnitModelReadyForUI("player") ) then
		self.Model:RefreshUnit();
		-- clearing cameraID so it resets zoom/pan
		self.Model.cameraID = nil;
		self.Model:UpdatePanAndZoomModelType();
		self:RefreshCameras();
		self:Refresh();
		return true;
	else
		return false;
	end
end

function WardrobeSetsCollectionMixin:RefreshCameras()
	if ( self:IsShown() ) then
		local detailsCameraID, transmogCameraID = C_TransmogSets.GetCameraIDs();
		local model = self.Model;
		self.Model:RefreshCamera();
		Model_ApplyUICamera(self.Model, detailsCameraID);
		if ( model.cameraID ~= detailsCameraID ) then
			model.cameraID = detailsCameraID;
			model.defaultPosX, model.defaultPosY, model.defaultPosZ, model.yaw = GetUICameraInfo(detailsCameraID);
		end
	end
end

function WardrobeSetsCollectionMixin:SelectBaseSetID(baseSetID)
	self:SelectSet(self:GetDefaultSetIDForBaseSet(baseSetID));
end

function WardrobeSetsCollectionMixin:GetDefaultSetIDForBaseSet(baseSetID)
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

function WardrobeSetsCollectionMixin:SelectSet(setID)
	if BetterWardrobeCollectionFrame.selectedCollectionTab ~=4 then

		if BetterWardrobeCollectionFrame.selectedCollectionTab == 2 then
			self.selectedSetID = setID;
		elseif BetterWardrobeCollectionFrame.selectedCollectionTab == 3 then
			self.selectedExtraSetID = setID;

		end	
		--self.selectedSetID = setID;

		local baseSetID = C_TransmogSets.GetBaseSetID(setID);

		local variantSets = SetsDataProvider:GetVariantSets(baseSetID);
		if ( #variantSets > 0 ) then
			self.selectedVariantSets[baseSetID] = setID;
		end

	elseif BetterWardrobeCollectionFrame.selectedCollectionTab == 4 then
		self.selectedSavedSetID = setID;
	end
	--self:Refresh();
	self:DisplaySet(setID);
end

function WardrobeSetsCollectionMixin:GetSelectedSetID()
	if BetterWardrobeCollectionFrame.selectedCollectionTab == 2 then
		return self.selectedSetID;
	elseif BetterWardrobeCollectionFrame.selectedCollectionTab == 3 then
		--return self.selectedSetID;
		return self.selectedExtraSetID;
	elseif BetterWardrobeCollectionFrame.selectedCollectionTab == 4 then
		return self.selectedSavedSetID;
	end	
end

function WardrobeSetsCollectionMixin:HasSetsToShow()
	local sets = SetsDataProvider:GetBaseSets();
	return sets and sets[1];
end

function WardrobeSetsCollectionMixin:SetAppearanceTooltip(frame)
	GameTooltip:SetOwner(frame, "ANCHOR_RIGHT");
	self.tooltipTransmogSlot = C_Transmog.GetSlotForInventoryType(frame.invType);
	self.tooltipPrimarySourceID = frame.sourceID;
	self.tooltipSlot = _G[TransmogUtil.GetSlotName(frame.transmogSlot)];
	self:RefreshAppearanceTooltip();
end

function WardrobeSetsCollectionMixin:RefreshAppearanceTooltip()
	if ( not self.tooltipTransmogSlot ) then
		return;
	end
	local data = self
	local sources = C_TransmogSets.GetSourcesForSlot(self:GetSelectedSetID(), self.tooltipTransmogSlot, data);

	if ( #sources == 0 ) then
		-- can happen if a slot only has HiddenUntilCollected sources
		local sourceInfo = C_TransmogCollection.GetSourceInfo(self.tooltipPrimarySourceID);
		tinsert(sources, sourceInfo);
	end
	CollectionWardrobeUtil.SortSources(sources, sources[1].visualID, self.tooltipPrimarySourceID); 
	local warningString = CollectionWardrobeUtil.GetBestVisibilityWarning(self.Model, self.transmogLocation, sources);
	self:GetParent():SetAppearanceTooltip(self, sources, self.tooltipPrimarySourceID, warningString, self.tooltipSlot);
end

function WardrobeSetsCollectionMixin:ClearAppearanceTooltip()
	self.tooltipTransmogSlot = nil;
	self.tooltipPrimarySourceID = nil;
	self:GetParent():HideAppearanceTooltip();
end

function WardrobeSetsCollectionMixin:HandleKey(key)
	if ( not self:GetSelectedSetID() ) then
		return false;
	end
	local selectedSetID = C_TransmogSets.GetBaseSetID(self:GetSelectedSetID());
	local _, index = SetsDataProvider:GetBaseSetByID(selectedSetID);
	if ( not index ) then
		return;
	end
	if ( key == WARDROBE_DOWN_VISUAL_KEY ) then
		index = index + 1;
	elseif ( key == WARDROBE_UP_VISUAL_KEY ) then
		index = index - 1;
	end
	local sets = SetsDataProvider:GetBaseSets();
	index = Clamp(index, 1, #sets);
	self:SelectSet(self:GetDefaultSetIDForBaseSet(sets[index].setID));

	self:ScrollToSet(sets[index].setID, ScrollBoxConstants.AlignNearest);
end

function WardrobeSetsCollectionMixin:ScrollToSet(setID, alignment)
	local scrollBox = self.ListContainer.ScrollBox;

	local baseSetID = C_TransmogSets.GetBaseSetID(setID);
	local function FindSet(elementData)
		return elementData.setID == baseSetID;
	end;

	scrollBox:ScrollToElementDataByPredicate(FindSet, alignment);
end

function WardrobeSetsCollectionMixin:OpenInDressingRoom(setID)
	if DressUpFrame:IsShown() then 
	else
		DressUpFrame_Show(DressUpFrame)
		C_Timer.After(0, function() self:OpenInDressingRoom(setID) 
		return 
	end)
	end
		
	--local setType = tabType[addon.GetTab()]
	-----local setInfo = addon.getFullList(setID) --addon:GetSetInfo(setID)
	local setInfo = C_TransmogSets.GetSetInfo(setID);

	local setType = "Blizzard" --setInfo.setType;

	--local setType = addon.QueueList[1]
	--local setID = addon.QueueList[2]
	local playerActor = DressUpFrame.ModelScene:GetPlayerActor()

	if not playerActor or not setID then
		return false;
	end

	local sources = nil;

	if setType == "Blizzard" then
		sources = {}
		local sourceInfo = C_TransmogSets.GetSetPrimaryAppearances(setID)
		for i, data in ipairs(sourceInfo) do
			sources[data.appearanceID] = false
		end

	else--if setType == "ExtraSet" then
		sources = setInfo.sources
	end

	if not sources then return end

	playerActor:Undress()
	for i, d in pairs(sources)do
		playerActor:TryOn(i)
	end

	import = true
	--DressUpSources(sources)
	import = false
	--TODO: Enable with Dressingroom files
	----addon:UpdateDressingRoom()
end

function BetterWardrobeSetsCollectionMixin:LinkSet(setID)
	local playerActor = self.Model
	
	local itemTransmogInfoList = playerActor and playerActor:GetItemTransmogInfoList();
	if not itemTransmogInfoList then
		return;
	end

	local hyperlink = C_TransmogCollection.GetCustomSetHyperlinkFromItemTransmogInfoList(itemTransmogInfoList)
	
	if not ChatEdit_InsertLink(hyperlink) then
		ChatFrame_OpenChat(hyperlink)
	end
end

local WardrobeSetsScrollFrameButtonMixin = {};
BetterWardrobeSetsScrollFrameButtonMixin = WardrobeSetsScrollFrameButtonMixin

local function variantsTooltip(elementData, variantSets)
	if BetterWardrobeCollectionFrame.selectedCollectionTab == 4 then
		return ""
	end

	if not variantSets then return "" end
	local  ratioText = ""
	--table.sort(variantSets, function(a,b) return (a.name) < (b.name) end);

	for i, setdata in ipairs(variantSets) do
		local have, total = addon.SetsDataProvider:GetSetSourceCounts(setdata.setID)
		text = setdata.description or setdata.name
		 ratioText =  ratioText..text..": ".. have .. "/" .. total.."\n"
	end

	return ratioText
end

function WardrobeSetsScrollFrameButtonMixin:Init(elementData)
	local displayData = elementData;

	if not displayData then return end

	--self.elementData = elementData
	--zzz = elementData
	local variantSets = SetsDataProvider:GetVariantSets(elementData.setID) or {} --C_TransmogSets.GetVariantSets(elementData.setID) or {};
	local topSourcesCollected, topSourcesTotal
	local baseSet = SetsDataProvider:GetBaseSetByID(elementData.setID);
	if BetterWardrobeCollectionFrame.selectedCollectionTab ~= 4 then
		if #variantSets > 0 then
			-- variant sets are already filtered for visibility (won't get a hiddenUntilCollected one unless it's collected)
			-- any set will do so just picking first one
			--displayData = variantSets[1];
		end

		local subName = gsub(displayData.name, " %(Recolor%)", "")
		if addon.Profile.IgnoreClassRestrictions then 
			self.Name:SetText(subName..((displayData.className) and " ("..displayData.className..")" or "") );
		else
			self.Name:SetText(subName );
		end

		topSourcesCollected, topSourcesTotal = SetsDataProvider:GetSetSourceTopCounts(displayData.setID);
		-- progress visuals use the top collected progress, so collected visuals should reflect the top completion status as well
		topSourcesCollected = topSourcesCollected or 0
		topSourcesTotal = topSourcesTotal or 0

		local setCollected = displayData.collected or topSourcesCollected == topSourcesTotal;
		local color = IN_PROGRESS_FONT_COLOR;
		if ( setCollected ) then
			color = NORMAL_FONT_COLOR;
		elseif ( topSourcesCollected == 0 ) then
			color = GRAY_FONT_COLOR;
		end

		displayData.icon = displayData.icon or SetsDataProvider:GetIconForSet(displayData.setID)

		self.Name:SetTextColor(color.r, color.g, color.b);
		self.Label:SetText(displayData.label);
		self.IconFrame:SetIconTexture(SetsDataProvider:GetIconForSet(displayData.setID));
		self.IconFrame:SetIconDesaturation((topSourcesCollected == 0) and 1 or 0);
		self.IconFrame:SetIconCoverShown(not setCollected);
		self.IconFrame:SetIconColor(displayData.validForCharacter and HIGHLIGHT_FONT_COLOR or RED_FONT_COLOR);
		self.IconFrame:SetFavoriteIconShown(elementData.favoriteSetID)
		self.New:SetShown(SetsDataProvider:IsBaseSetNew(elementData.setID));
		self.setID = elementData.setID;

		if #variantSets <= 1  or (C_AddOns.IsAddOnLoaded("CanIMogIt") and CanIMogItOptions["showSetInfo"]) then
			self.Variants:Hide()
			self.Variants.Count:SetText(0)
		else
			self.Variants:Show()
			self.Variants.Count:SetText(#variantSets)
		end
	else
		self.Variants:Hide()
		self.Variants.Count:SetText(0)
	end

	self.Store:SetShown((addon.MiscSets.TRADINGPOST_SETS[self.setID] or displayData.filter == 9) and addon.Profile.ShowShopIcon);
	if not C_AddOns.IsAddOnLoaded("CanIMogIt")then
		self.Store:ClearAllPoints();
		self.Store:SetPoint("TOPRIGHT", 0, -25);

	else
		self.Store:ClearAllPoints();
		self.Store:SetPoint("TOPRIGHT",self.IconFrame, 5, -25);
		self.Store:SetFrameLevel(560);
		self.Remix:SetPoint("TOPRIGHT",self.IconFrame, 5, -25);
		self.Remix:SetFrameLevel(560);

	end

	self.Remix:SetShown(addon.MiscSets.REMIX_SETS[self.setID] );
	self.Remix:SetShown(false );

	self.EditButton:Hide();

	self.variantInfo = variantsTooltip(elementData, variantSets);

	local setInfo = addon.GetSetInfo(displayData.setID);
	--local isFavorite = 	C_TransmogSets.GetIsFavorite(displayData.setID);
	local isHidden = addon.HiddenAppearanceDB.profile.set[displayData.setID];
	local isInList = addon.CollectionList:IsInList(displayData.setID, "set");

	if BetterWardrobeCollectionFrame.selectedCollectionTab == 3 then
		isInList = addon.CollectionList:IsInList(displayData.setID, "extraset");
		isFavorite = addon.favoritesDB.profile.extraset[displayData.setID];
		isHidden = addon.HiddenAppearanceDB.profile.extraset[displayData.setID];
	end

	if BetterWardrobeCollectionFrame.selectedCollectionTab == 2 or BetterWardrobeCollectionFrame.selectedCollectionTab == 3  then
		self.New:SetShown(SetsDataProvider:IsBaseSetNew(elementData.setID));
	end

	if BetterWardrobeCollectionFrame.selectedCollectionTab == 4 then
		self.IconFrame:SetIconDesaturation(0);
		self.IconFrame:SetIconCoverShown(false);
		self.IconFrame:SetIconColor(HIGHLIGHT_FONT_COLOR);
		self.Store:SetShown(false);
		self.Remix:SetShown(false );
		self.New:SetShown(false);
		self.EditButton:Show();
	end

	self.IconFrame:SetFavoriteIconShown(isFavorite or elementData.favoriteSetID)

	--self.Favorite:SetShown(isFavorite or elementData.favoriteSetID);
	self.CollectionListVisual.Hidden.Icon:SetShown(isHidden);
	----self.CollectionListVisual.Unavailable:SetShown(CheckSetAvailability(displayData.setID));
	----self.CollectionListVisual.UnavailableItems:SetShown(CheckSetAvailability(displayData.setID));
	--self.CollectionListVisual.InvalidTexture:SetShown(BetterWardrobeCollectionFrame.selectedCollectionTab == 3 and not displayData.isClass);


	self.EditButton:SetShown((BetterWardrobeCollectionFrame:CheckTab(4) and (self.setID < 50000 or self.setID >=70000 or C_AddOns.IsAddOnLoaded("MogIt"))))
	topSourcesCollected = topSourcesCollected or 0
	topSourcesTotal = topSourcesTotal or 0

	if ( topSourcesCollected == 0 or setCollected ) then
		self.ProgressBar:Hide();
	else
		self.ProgressBar:Show();
		self.ProgressBar:SetWidth(SET_PROGRESS_BAR_MAX_WIDTH * topSourcesCollected / topSourcesTotal);
	end
	--self.variantInfo = variantsTooltip(elementData, variantSets);
	self:SetSelected(SelectionBehaviorMixin.IsElementDataIntrusiveSelected(elementData));
end

function WardrobeSetsScrollFrameButtonMixin:SetSelected(selected)
	self.SelectedTexture:SetShown(selected);
end

local function ToggleHidden(model, isHidden)
	local GetItemInfo = C_Item and C_Item.GetItemInfo
	local tabID = addon.GetTab()
	if tabID == 1 then
		local visualID = model.visualInfo.visualID;
		local _, _, _, _, _, itemLink = C_TransmogCollection.GetAppearanceSourceInfo(visualID);
		local name, link;
		if itemLink then 
			local source = CollectionWardrobeUtil.GetSortedAppearanceSources(visualID, addon.GetItemCategory(visualID), addon.GetTransmogLocation(itemLink))[1];
			name, link = GetItemInfo(source.itemID);
		end

		if not link then
			link = visualID
		end
		addon.HiddenAppearanceDB.profile.item[visualID] = not isHidden and link;
		--self:UpdateWardrobe()
		print(string.format("%s "..link.." %s", isHidden and L["unhiding_item"] or L["hiding_item"], isHidden and L["inhiding_item_end"] or L["hiding_item_end"] ));
		BetterWardrobeCollectionFrame.ItemsCollectionFrame:RefreshVisualsList();
		BetterWardrobeCollectionFrame.ItemsCollectionFrame:UpdateItems();

	elseif tabID == 2 then

		local setInfo = C_TransmogSets.GetSetInfo(tonumber(model.setID));
		local name = setInfo["name"];

		local baseSetID = C_TransmogSets.GetBaseSetID(model.setID);

		local atTransmogrifier = C_Transmog.IsAtTransmogNPC()

		--print(model.setID)
		--print(baseSetID)
		addon.HiddenAppearanceDB.profile.set[baseSetID] = not isHidden and name or nil;


		--local sourceinfo = C_TransmogSets.GetSetPrimaryAppearances(baseSetID);
		--for i,data in pairs(sourceinfo) do
			--local info = C_TransmogCollection.GetSourceInfo(i);
			--	addon.HiddenAppearanceDB.profile.item[info.visualID] = not isHidden and info.name or nil;
		--end

		local variantSets = addon.SetsDataProvider:GetVariantSets(baseSetID) --C_TransmogSets.GetVariantSets(baseSetID);
			for i, data in ipairs(variantSets) do
				addon.HiddenAppearanceDB.profile.set[data.setID] = not isHidden and data.name or nil;

				--local sourceinfo = C_TransmogSets.GetSetPrimaryAppearances(data.setID);
				--for i,data in pairs(sourceinfo) do
					--local info = C_TransmogCollection.GetSourceInfo(i);
						--addon.HiddenAppearanceDB.profile.item[info.visualID] = not isHidden and info.name or nil;
				--end
		end	
		--BetterWardrobeCollectionFrame.SetsCollectionFrame:OnSearchUpdate();
		print(format("%s "..name.." %s", isHidden and L["unhiding_set"] or L["hiding_set"], isHidden and L["unhiding_set_end"] or L["hiding_set_end"]))
	else
		local setInfo = addon.GetSetInfo(model.setID);
		local name = setInfo["name"];
		addon.HiddenAppearanceDB.profile.extraset[model.setID] = not isHidden and name or nil;
		print(format("%s "..name.." %s", isHidden and L["unhiding_set"] or L["hiding_set"], isHidden and L["unhiding_set_end"] or L["hiding_set_end"]));
		BetterWardrobeCollectionFrame.SetsCollectionFrame:OnSearchUpdate();

	end
			--self:UpdateWardrobe()
end


function WardrobeSetsScrollFrameButtonMixin:OnClick(buttonName, down)

	if BetterWardrobeCollectionFrame.selectedCollectionTab == 4 then
		if ( buttonName == "LeftButton" ) then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
			g_selectionBehavior:Select(self);
		end
	else
		if ( buttonName == "LeftButton" ) then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
			g_selectionBehavior:Select(self);
			--addon:DebugData(self.setID)
		elseif ( buttonName == "RightButton" ) then
			MenuUtil.CreateContextMenu(self, function(owner, rootDescription)
				rootDescription:SetTag("MENU_WARDROBE_SETS_SET");

				local baseSetID = self.setID;
				local baseSet = SetsDataProvider:GetBaseSetByID(baseSetID);
				local useDescription = (#SetsDataProvider:GetVariantSets(baseSetID) > 0);
				local type = tabType[addon.GetTab()];

				local isHidden = addon.HiddenAppearanceDB.profile[type][baseSetID]
				rootDescription:CreateButton(TRANSMOG_OUTFIT_POST_IN_CHAT, function()
					BetterWardrobeSetsCollectionMixin:LinkSet(self.baseSetID or self.setID);
				end);

				rootDescription:CreateButton(isHidden and SHOW or HIDE, function()
					--self.setID = self.baseSetID; 
					ToggleHidden(self, isHidden);
					addon.Init:InitDB()
					--RefreshLists()
				end);

				local text;
				local targetSetID;
				local favorite = baseSet.favoriteSetID ~= nil or addon.favoritesDB.profile.extraset[baseSetID];
				if favorite then
					targetSetID = baseSet.favoriteSetID or baseSetID;
					if useDescription then
						local setInfo = C_TransmogSets.GetSetInfo(baseSet.favoriteSetID);
						text = format(TRANSMOG_SETS_UNFAVORITE_WITH_DESCRIPTION, setInfo.description or setInfo.name or baseSet.name );
					else
						text = TRANSMOG_ITEM_UNSET_FAVORITE;
					end
				else
					targetSetID = BetterWardrobeCollectionFrame.SetsCollectionFrame:GetDefaultSetIDForBaseSet(baseSetID);
					if useDescription then
						local setInfo = C_TransmogSets.GetSetInfo(targetSetID);
						text = format(TRANSMOG_SETS_FAVORITE_WITH_DESCRIPTION, setInfo.description or setInfo.name);
					else
						text = TRANSMOG_ITEM_SET_FAVORITE;
					end
				end

				rootDescription:CreateButton(text, function()
					--addon.C_TransmogSets.SetIsFavorite(targetSetID, not favorite);
					--addon.C_TransmogSets.SetIsFavorite(baseSetID, not favorite);


					addon.Init:InitDB()
					--RefreshLists()
				end);
			end);
		end
	end
end

local WardrobeSetsScrollFrameButtonIconFrameMixin = {};
BetterWardrobeSetsScrollFrameButtonIconFrameMixin = WardrobeSetsScrollFrameButtonIconFrameMixin

function WardrobeSetsScrollFrameButtonIconFrameMixin:OnEnter()
	self:DisplaySetTooltip();
end

function WardrobeSetsScrollFrameButtonIconFrameMixin:OnLeave()
	GameTooltip_Hide();
end

function WardrobeSetsScrollFrameButtonIconFrameMixin:SetIconTexture(texture)
	self.Icon:SetTexture(texture);
end

function WardrobeSetsScrollFrameButtonIconFrameMixin:SetIconDesaturation(desaturation)
	self.Icon:SetDesaturation(desaturation);
end

function WardrobeSetsScrollFrameButtonIconFrameMixin:SetIconCoverShown(shown)
	self.Cover:SetShown(shown);
end

function WardrobeSetsScrollFrameButtonIconFrameMixin:SetFavoriteIconShown(shown)
	self.Favorite:SetShown(shown);
end

function WardrobeSetsScrollFrameButtonIconFrameMixin:SetIconColor(color)
	self.Icon:SetVertexColor(color:GetRGB());
end

local function ConvertClassMaskToClassList(classMask)
	local classList = "";
	for classID = 1, GetNumClasses() do
		local classAllowed = FlagsUtil.IsSet(classMask, bit.lshift(1, (classID - 1)));
		local allowedClassInfo = classAllowed and C_CreatureInfo.GetClassInfo(classID);
		if allowedClassInfo then
			if classList == "" then
				classList = classList .. allowedClassInfo.className;
			else
				classList = classList .. LIST_DELIMITER .. allowedClassInfo.className;
			end
		end
	end

	return classList;
end

local function TryAppendUnmetSetRequirementsToTooltip(setInfo, tooltip)
	if setInfo.validForCharacter then
		return;
	end

	local classRequirementMet = setInfo.classMask == 0 or FlagsUtil.IsSet(setInfo.classMask, bit.lshift(1, (PlayerUtil.GetClassID() - 1)));
	if not classRequirementMet then
		local allowedClassList = ConvertClassMaskToClassList(setInfo.classMask);
		if allowedClassList ~= "" then
			GameTooltip_AddErrorLine(tooltip, ITEM_CLASSES_ALLOWED:format(allowedClassList));
		end
	end
end

function WardrobeSetsScrollFrameButtonIconFrameMixin:DisplaySetTooltip()
	local setID = self:GetParent().setID;
	local setInfo = setID and C_TransmogSets.GetSetInfo(setID);
	if not setInfo then
		return;
	end

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip_AddHighlightLine(GameTooltip, setInfo.name);
	TryAppendUnmetSetRequirementsToTooltip(setInfo, GameTooltip);
	GameTooltip:Show();
end

local WardrobeSetsCollectionContainerMixin = { };
BetterWardrobeSetsCollectionContainerMixin = WardrobeSetsCollectionContainerMixin

function WardrobeSetsCollectionContainerMixin:OnLoad()
	local view = CreateScrollBoxListLinearView();
	view:SetElementInitializer("BetterWardrobeSetsScrollFrameButtonTemplate", function(button, elementData)
		C_Timer.After(.05, function() button:Init(elementData); end)
	end);
	view:SetPadding(0,0,44,0,0);

	ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, view);

	g_selectionBehavior = ScrollUtil.AddSelectionBehavior(self.ScrollBox, SelectionBehaviorFlags.Intrusive);
	g_selectionBehavior:RegisterCallback(SelectionBehaviorMixin.Event.OnSelectionChanged, function(o, elementData, selected)
		local button = self.ScrollBox:FindFrame(elementData);
		if button then
			button:SetSelected(selected);

			if selected then
				local setCollectionFrame = self:GetParent();
				setCollectionFrame:SelectBaseSetID(elementData.setID);
			end
		end
	end, self);
end

function WardrobeSetsCollectionContainerMixin:OnShow()
	self:RegisterEvent("TRANSMOG_SETS_UPDATE_FAVORITE");
end

function WardrobeSetsCollectionContainerMixin:OnHide()
	self:UnregisterEvent("TRANSMOG_SETS_UPDATE_FAVORITE");
end

function WardrobeSetsCollectionContainerMixin:OnEvent(event, ...)
	if ( event == "TRANSMOG_SETS_UPDATE_FAVORITE" ) then
		SetsDataProvider:RefreshFavorites();
		self:UpdateDataProvider();
	end
end

function WardrobeSetsCollectionContainerMixin:ReinitializeButtonWithBaseSetID(baseSetID)
	local frame = self.ScrollBox:FindFrameByPredicate(function(frame, elementData)
		return elementData.setID == baseSetID;
	end);

	if frame then
		frame:Init(frame:GetElementData());
	end
end

function WardrobeSetsCollectionContainerMixin:UpdateDataProvider()
	local dataProvider = CreateDataProvider(SetsDataProvider:GetBaseSets());
	self.ScrollBox:SetDataProvider(dataProvider, ScrollBoxConstants.RetainScrollPosition);
	self:UpdateListSelection();
end

function WardrobeSetsCollectionContainerMixin:UpdateListSelection()
	local selectedSetID = self:GetParent():GetSelectedSetID();
	if selectedSetID then
		self:SelectElementDataMatchingSetID(C_TransmogSets.GetBaseSetID(selectedSetID));
	end
end

function WardrobeSetsCollectionContainerMixin:SelectElementDataMatchingSetID(setID)
	g_selectionBehavior:SelectElementDataByPredicate(function(elementData)
		return elementData.setID == setID;
	end);
end

local WardrobeSetsDetailsModelMixin = { };
BetterWardrobeSetsDetailsModelMixin = WardrobeSetsDetailsModelMixin

function WardrobeSetsDetailsModelMixin:OnLoad()
	self:SetAutoDress(false);
	self:SetUnit("player", false, PlayerUtil.ShouldUseNativeFormInModelScene());
	self:UpdatePanAndZoomModelType();

	local lightValues = { omnidirectional = false, point = CreateVector3D(-1, 0, 0), ambientIntensity = .7, ambientColor = CreateColor(.7, .7, .7), diffuseIntensity = .6, diffuseColor = CreateColor(1, 1, 1) };
	local enabled = true;
	self:SetLight(enabled, lightValues);
end

function WardrobeSetsDetailsModelMixin:OnShow()
	self:SetUnit("player", false, PlayerUtil.ShouldUseNativeFormInModelScene());
end

function WardrobeSetsDetailsModelMixin:UpdatePanAndZoomModelType()
	local hasAlternateForm, inAlternateForm = C_PlayerInfo.GetAlternateFormInfo();
	if ( not self.panAndZoomModelType or self.inAlternateForm ~= inAlternateForm ) then
		local _, race = UnitRace("player");
		local sex = UnitSex("player");
		if ( inAlternateForm ) then
			self.panAndZoomModelType = race..sex.."Alt";
		else
			self.panAndZoomModelType = race..sex;
		end
		self.inAlternateForm = inAlternateForm;
	end
end

function WardrobeSetsDetailsModelMixin:GetPanAndZoomLimits()
	return SET_MODEL_PAN_AND_ZOOM_LIMITS[self.panAndZoomModelType];
end

function WardrobeSetsDetailsModelMixin:OnUpdate(elapsed)
	if ( IsUnitModelReadyForUI("player") ) then
		if ( self.rotating ) then
			if ( self.yaw ) then
				local x = GetCursorPosition();
				local diff = (x - self.rotateStartCursorX) * MODELFRAME_DRAG_ROTATION_CONSTANT;
				self.rotateStartCursorX = GetCursorPosition();
				self.yaw = self.yaw + diff;
				if ( self.yaw < 0 ) then
					self.yaw = self.yaw + (2 * PI);
				end
				if ( self.yaw > (2 * PI) ) then
					self.yaw = self.yaw - (2 * PI);
				end
				self:SetRotation(self.yaw, false);
			end
		elseif ( self.panning ) then
			if ( self.defaultPosX ) then
				local cursorX, cursorY = GetCursorPosition();
				local modelX = self:GetPosition();
				local panSpeedModifier = 100 * sqrt(1 + modelX - self.defaultPosX);
				local modelY = self.panStartModelY + (cursorX - self.panStartCursorX) / panSpeedModifier;
				local modelZ = self.panStartModelZ + (cursorY - self.panStartCursorY) / panSpeedModifier;
				local limits = self:GetPanAndZoomLimits();
				modelY = Clamp(modelY, limits.panMaxLeft, limits.panMaxRight);
				modelZ = Clamp(modelZ, limits.panMaxBottom, limits.panMaxTop);
				self:SetPosition(modelX, modelY, modelZ);
			end
		end
	end
end

function WardrobeSetsDetailsModelMixin:OnMouseDown(button)
	if ( button == "LeftButton" ) then
		self.rotating = true;
		self.rotateStartCursorX = GetCursorPosition();
	elseif ( button == "RightButton" ) then
		self.panning = true;
		self.panStartCursorX, self.panStartCursorY = GetCursorPosition();
		local modelX, modelY, modelZ = self:GetPosition();
		self.panStartModelY = modelY;
		self.panStartModelZ = modelZ;
	end
end

function WardrobeSetsDetailsModelMixin:OnMouseUp(button)
	if ( button == "LeftButton" ) then
		self.rotating = false;
	elseif ( button == "RightButton" ) then
		self.panning = false;
	end
end

function WardrobeSetsDetailsModelMixin:OnMouseWheel(delta)
	local posX, posY, posZ = self:GetPosition();
	posX = posX + delta * 0.5;
	local limits = self:GetPanAndZoomLimits();
	posX = Clamp(posX, self.defaultPosX, limits.maxZoom);
	self:SetPosition(posX, posY, posZ);
end

function WardrobeSetsDetailsModelMixin:OnModelLoaded()
	if ( self.cameraID ) then
		Model_ApplyUICamera(self, self.cameraID);
	end
end

local WardrobeSetsDetailsItemMixin = { };
BetterWardrobeSetsDetailsItemMixin = WardrobeSetsDetailsItemMixin
function WardrobeSetsDetailsItemMixin:OnShow()
	self:RegisterEvent("TRANSMOG_COLLECTION_ITEM_FAVORITE_UPDATE");

	if ( not self.sourceID ) then
		return;
	end

	local sourceInfo = C_TransmogCollection.GetSourceInfo(self.sourceID);
	self.visualID = sourceInfo.visualID;

	self.Favorite.Icon:SetShown(C_TransmogCollection.GetIsAppearanceFavorite(self.visualID));
end

function WardrobeSetsDetailsItemMixin:OnHide()
	self:UnregisterEvent("TRANSMOG_COLLECTION_ITEM_FAVORITE_UPDATE");
end


function WardrobeSetsDetailsItemMixin:OnEnter()
	self.transmogSlot = C_Transmog.GetSlotForInventoryType(self.invType);

	self:GetParent():GetParent():SetAppearanceTooltip(self)

	self:SetScript("OnUpdate",
		function()
			if IsModifiedClick("DRESSUP") then
				ShowInspectCursor();
			else
				ResetCursor();
			end
		end
	);

	if ( self.New:IsShown() ) then
		self.New:Hide();

		local setID = BetterWardrobeCollectionFrame.SetsCollectionFrame:GetSelectedSetID();
		C_TransmogSets.ClearSetNewSourcesForSlot(setID, self.transmogSlot);
		local baseSetID = C_TransmogSets.GetBaseSetID(setID);
		SetsDataProvider:ResetBaseSetNewStatus(baseSetID);

		BetterWardrobeCollectionFrame.SetsCollectionFrame.ListContainer:ReinitializeButtonWithBaseSetID(baseSetID);
	end
end

function WardrobeSetsDetailsItemMixin:OnEvent(event, ...)
	if ( event == "TRANSMOG_COLLECTION_ITEM_FAVORITE_UPDATE" ) then
		local itemAppearanceID, isFavorite = ...;

		if ( self.visualID == itemAppearanceID ) then
			self.Favorite.Icon:SetShown(isFavorite);
		end
	end
end


function WardrobeSetsDetailsItemMixin:OnLeave()
	self:SetScript("OnUpdate", nil);
	ResetCursor();
	BetterWardrobeCollectionFrame:HideAppearanceTooltip();
end

function WardrobeSetsDetailsItemMixin:OnMouseDown(button)
	if ( IsModifiedClick("CHATLINK") ) then
		local sourceInfo = C_TransmogCollection.GetSourceInfo(self.sourceID);
		local slot = C_Transmog.GetSlotForInventoryType(sourceInfo.invType);
		local sources = C_TransmogSets.GetSourcesForSlot(self:GetParent():GetParent():GetSelectedSetID(), slot);
		if ( #sources == 0 ) then
			-- can happen if a slot only has HiddenUntilCollected sources
			tinsert(sources, sourceInfo);
		end
		CollectionWardrobeUtil.SortSources(sources, sourceInfo.visualID, self.sourceID);
		if ( BetterWardrobeCollectionFrame.tooltipSourceIndex ) then
			local index = CollectionWardrobeUtil.GetValidIndexForNumSources(BetterWardrobeCollectionFrame.tooltipSourceIndex, #sources);
			local appearanceSourceInfo = C_TransmogCollection.GetAppearanceSourceInfo(sources[index].sourceID);

			if ( appearanceSourceInfo and appearanceSourceInfo.itemLink ) then
				HandleModifiedItemClick(appearanceSourceInfo.itemLink);
			end
		end
	elseif ( IsModifiedClick("DRESSUP") ) then
		DressUpVisual(self.sourceID);
	end
end

function WardrobeSetsDetailsItemMixin:OnMouseUp(button)
	if button == "RightButton" then
		if not self.collected then
			return;
		end

		MenuUtil.CreateContextMenu(self, function(owner, rootDescription)
			rootDescription:SetTag("MENU_WARDROBE_SETS_SET_DETAIL");

			local appearanceID = self.visualID;
			local favorite = C_TransmogCollection.GetIsAppearanceFavorite(appearanceID);
			local text = favorite and TRANSMOG_ITEM_UNSET_FAVORITE or TRANSMOG_ITEM_SET_FAVORITE;
			rootDescription:CreateButton(text, function()
				C_TransmogCollection.SetIsAppearanceFavorite(appearanceID, not favorite);
			end);
		end);
	end
end

local EmptyArmor = addon.Globals.EmptyArmor

function Sets:GetEmptySlots()
	local setInfo = {}

	for i,x in pairs(EmptyArmor) do
		setInfo[i]=x;
	end

	return setInfo;
end

function Sets:EmptySlots(transmogSources)
	local EmptySet = self:GetEmptySlots()

	for i, x in pairs(transmogSources) do
			EmptySet[i] = nil;
	end

	return EmptySet;
end