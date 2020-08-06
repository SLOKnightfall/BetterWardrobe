--	///////////////////////////////////////////////////////////////////////////////////////////
--
--	BattlePetCageMatch
--	Author: SLOKnightfall

--	BattlePetCageMatch: Scans bags and puts icons on the Pet Journal for any pet that is currently caged
--

--	License: You are hereby authorized to freely modify and/or distribute all files of this add-on, in whole or in part,
--		providing that this header stays intact, and that you do not claim ownership of this Add-on.
--
--		Additionally, the original owner wishes to be notified by email if you make any improvements to this add-on.
--		Any positive alterations will be added to a future release, and any contributing authors will be
--		identified in the section above.
--
--
--

--	///////////////////////////////////////////////////////////////////////////////////////////

--local BPCM = select(2, ...)
local addonName, addon = ...
--_G["BPCM"] = BPCM
--addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
addon.Frame = LibStub("AceGUI-3.0")
--addon.DataBroker = LibStub( "LibDataBroker-1.1" )
addon.bagResults = {}

local globalPetList = {}
local playerInv_DB
local Profile
local playerNme
local realmName

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)


---Ace based addon initilization
function addon:OnInitialize()
	addon.AddSetDetailFrames()
	--addon.bob()
end


function addon:OnEnable()
	UIParent.SetsCollectionFrame:Show()
end


local BASE_SET_BUTTON_HEIGHT = 46;
local VARIANT_SET_BUTTON_HEIGHT = 20;
local SET_PROGRESS_BAR_MAX_WIDTH = 204;
local IN_PROGRESS_FONT_COLOR = CreateColor(0.251, 0.753, 0.251);
local IN_PROGRESS_FONT_COLOR_CODE = "|cff40c040";


local COLLECTION_LIST_WIDTH = 260
--
function addon.bob()
	print("bob")
local frame = CreateFrame("Frame", "BWSetCollectorFrame", UIParent, "ButtonFrameTemplate")
frame:Show()
frame:SetWidth(703)
frame:SetHeight(606)
frame:SetPoint("TOPLEFT",17,-115)
--frame:SetAttribute("UIPanelLayout-defined", true)			-- Allows frame to shift other frames when opened or be shifted when others are opened.
--frame:SetAttribute("UIPanelLayout-enabled", true)			-- http://www.wowwiki.com/Creating_standard_left-sliding_frames
--frame:SetAttribute("UIPanelLayout-area", "left")
--frame:SetAttribute("UIPanelLayout-pushable", 5)
--frame:SetAttribute("UIPanelLayout-width", width)
--frame:SetAttribute("UIPanelLayout-whileDead", true)

local title = CreateFrame("Frame", "$parentTitle", frame)
title:SetWidth(300)
title:SetHeight(14)
title:SetPoint("TOP", 0, -4)
title:SetFrameLevel(100)
title:SetAttribute("parentKey", "Title")
	
frame.TitleText:SetText(addonName)

tinsert(UISpecialFrames, frame:GetName())							-- Hides frame when Escape is pressed or Game menu selected.

  	
local helpButton = CreateFrame("Button","$parentTutorialButton",frame,"MainHelpPlateButton")
helpButton:SetPoint("TOPLEFT",frame, 39, 20)

ShowUIPanel(frame)


--
--  ScrollFrame
--

local leftInset = CreateFrame("Frame","$parentLeftInset",frame,"InsetFrameTemplate")
leftInset:SetWidth(COLLECTION_LIST_WIDTH)
leftInset:SetHeight(496)
leftInset:SetPoint("TOPLEFT", 4, -60)
leftInset:SetPoint("BOTTOMLEFT", 4, 26)
leftInset:SetAttribute("parentKey","LeftInset")
leftInset:SetAttribute("useParentLevel","true")

local scrollFrame = CreateFrame("ScrollFrame","BWSetCollectorScrollFrame",frame,"BetterWardrobeCollectionsScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT","$parentLeftInset","TOPLEFT",2,-5)
scrollFrame:SetPoint("BOTTOMRIGHT","$parentLeftInset","BOTTOMRIGHT", -4, 3)

local function IsShownInList(button)
	top = BWSetCollectorScrollFrame.CollectionsFrame:GetTop()
	bottom = BWSetCollectorScrollFrame.CollectionsFrame:GetBottom()
	buttonTop = button:GetTop()
	buttonBottom = button:GetBottom()
	if buttonBottom < top and buttonTop > bottom then
		return true
	end
	return false
end

local function GetCollectionButton(index)
	local buttons = BWSetCollectorFrame.CollectionsFrame.Contents.Collections;
	if ( not buttons[index] ) then
		local button = CreateFrame("BUTTON", nil, BWSetCollectorFrame.CollectionsFrame.Contents, "BetterWardrobeCollectionTemplate");
		buttons[index] = button;
	end
	return buttons[index];
end



--
--  Model
--

local rightInset = CreateFrame("Frame","$parentRightInset",frame,"InsetFrameTemplate")
rightInset:SetPoint("TOPRIGHT", -6, -60)
rightInset:SetPoint("BOTTOMLEFT", leftInset, "BOTTOMRIGHT", 20, 0)
rightInset:SetAttribute("parentKey","RightInset")
rightInset:SetAttribute("useParentLevel","true")

local setDisplay = CreateFrame("Frame","BetterWardrobeSetDisplay",rightInset)
setDisplay:SetPoint("TOPLEFT",rightInset,"TOPLEFT", 3, -3)
setDisplay:SetPoint("BOTTOMRIGHT",rightInset,"BOTTOMRIGHT", -3, 3)
setDisplay:SetAttribute("parentKey","BetterWardrobeSetDisplay")
setDisplay.Texture = setDisplay:CreateTexture("setTexture","BACKGROUND")
setDisplay.Texture:SetAllPoints(setDisplay)
setDisplay.Texture:SetTexture("Interface\\PetBattles\\MountJournal-BG",false)
setDisplay.Texture:SetTexCoord(0,0.78515625,0,1)

local shadowOverlay = CreateFrame("Frame",nil,setDisplay,"ShadowOverlayTemplate")
shadowOverlay:SetAllPoints(true)
shadowOverlay:SetAttribute("useParentLevel","true")
shadowOverlay:SetAttribute("parentKey","ShadowOverlay")

local progressDisplay = CreateFrame("Button","BetterWardrobeSummaryButton",setDisplay)
progressDisplay:SetWidth(56)
progressDisplay:SetHeight(56)
progressDisplay:SetPoint("BOTTOM","$parent","BOTTOM",0,15)
progressDisplay.Summary = progressDisplay:CreateFontString("$parentSummary","OVERLAY","GameFontNormalLarge")
progressDisplay.Summary:SetPoint("CENTER", 0, 2)
progressDisplay.Summary:SetText(" ")
progressDisplay.Background = progressDisplay:CreateTexture("$parentBackground","BACKGROUND")
progressDisplay.Background:SetTexture(0,0,0,0.7)
progressDisplay.Background:SetPoint("TOPLEFT",3,-3)
progressDisplay.Background:SetPoint("BOTTOMRIGHT",-3,3)
progressDisplay.Texture = progressDisplay:CreateTexture("$parentTexture","OVERLAY")
progressDisplay.Texture:SetAtlas("collections-itemborder-uncollected")
progressDisplay.Texture:SetPoint("TOPLEFT",0,0)
progressDisplay.Texture:SetPoint("BOTTOMRIGHT",0,0)
progressDisplay:SetFrameLevel(10)
progressDisplay:RegisterForClicks("AnyDown")
--progressDisplay:SetScript("OnClick", SetCollectorSummaryButton_OnClick)
progressDisplay:Hide()

local modelFrame = CreateFrame("DressUpModel","$parentModelFrame",setDisplay,"ModelWithZoomTemplate") --"ModelWithControlsTemplate")
modelFrame:SetPoint("TOPLEFT", setDisplay, "TOPLEFT", 0, 0)
modelFrame:SetPoint("BOTTOMRIGHT", setDisplay, "BOTTOMRIGHT", 0, 0)
modelFrame:SetAttribute("parentKey","ModelFrame")
modelFrame:SetAttribute("useParentLevel","true")

function addon:InitializeModel()
	modelFrame:SetUnit("PLAYER")
end

	addon:InitializeModel()

end



BetterWardrobeSetsCollectionScrollFrameMixin = CreateFromMixins(WardrobeSetsCollectionScrollFrameMixin);

function BetterWardrobeSetsCollectionScrollFrameMixin:OnLoad()
	self.scrollBar.trackBG:Show();
	self.scrollBar.trackBG:SetVertexColor(0, 0, 0, 0.75);
	self.scrollBar.doNotHide = true;
	self.update = self.Update;
	HybridScrollFrame_CreateButtons(self, "BetterWardrobeSetsScrollFrameButtonTemplate", 44, 0);
	--UIDropDownMenu_Initialize(self.FavoriteDropDown, WardrobeSetsCollectionScrollFrame_FavoriteDropDownInit, "MENU");
end

function BetterWardrobeSetsCollectionScrollFrameMixin:OnShow()
	self:RegisterEvent("TRANSMOG_SETS_UPDATE_FAVORITE");
end

function BetterWardrobeSetsCollectionScrollFrameMixin:OnHide()
	self:UnregisterEvent("TRANSMOG_SETS_UPDATE_FAVORITE");
end

function BetterWardrobeSetsCollectionScrollFrameMixin:OnEvent(event, ...)
	if ( event == "TRANSMOG_SETS_UPDATE_FAVORITE" ) then
	--	SetsDataProvider:RefreshFavorites();
		--self:Update();
	end
end

local selectedSetID
function BetterWardrobeSetsCollectionScrollFrameMixin:Update()
	print("UD")
	local offset = HybridScrollFrame_GetOffset(self);
	local buttons = self.buttons;
	local baseSets = addon.sets["Mail" ]
	local name, items
	-- show the base set as selected
	local selectedSetID = self:GetParent():GetSelectedSetID();
	--print(selectedSetID)
	--local selectedBaseSetID = selectedSetID and C_TransmogSets.GetBaseSetID(selectedSetID);

	for i = 1, #buttons do
		local button = buttons[i];
		local setIndex = i + offset;
		if ( setIndex <= #baseSets ) then
			local baseSet = baseSets[setIndex];
			--print(baseSet)
			local name, items = addon.GetSetData(baseSet)
			local  icon = addon.GetSetIcon(baseSet)
			local count, complete = addon.GetSetCompletion(baseSet)
			button:Show();
			button.Name:SetText(name);
			local topSourcesCollected, topSourcesTotal = addon.GetSetCompletion(baseSet)
			--print(topSourcesCollected)
			--print(topSourcesTotal)
			--local setCollected = C_TransmogSets.IsBaseSetCollected(baseSet.setID);
			local color = IN_PROGRESS_FONT_COLOR;
			--if ( setCollected ) then
				--color = NORMAL_FONT_COLOR;
			--elseif ( topSourcesCollected == 0 ) then
				--color = GRAY_FONT_COLOR;
			--end
			button.Name:SetTextColor(color.r, color.g, color.b);
			--button.Label:SetText(baseSet.label);
			button.Icon:SetTexture(icon);
			--button.Icon:SetDesaturation((topSourcesCollected == 0) and 1 or 0);
			--button.SelectedTexture:SetShown(baseSet.setID == selectedBaseSetID);
			--button.Favorite:SetShown(baseSet.favoriteSetID);
			--button.New:SetShown(SetsDataProvider:IsBaseSetNew(baseSet.setID));
			button.setID = baseSet;

			if ( topSourcesCollected == 0 or setCollected ) then
				button.ProgressBar:Hide();
			else
				button.ProgressBar:Show();
				button.ProgressBar:SetWidth(SET_PROGRESS_BAR_MAX_WIDTH * topSourcesCollected / topSourcesTotal);
			end
			--button.IconCover:SetShown(not setCollected);
		else
			button:Hide();
		end
	end

	local extraHeight = (self.largeButtonHeight and self.largeButtonHeight - BASE_SET_BUTTON_HEIGHT) or 0;
	local totalHeight = #baseSets * BASE_SET_BUTTON_HEIGHT + extraHeight;
	HybridScrollFrame_Update(self, totalHeight, self:GetHeight());
end



--local BetterWardrobeSetsTransmogMixin = CreateFromMixins(WardrobeSetsTransmogMixin);
BetterWardrobeSetsCollectionMixin = CreateFromMixins(WardrobeSetsCollectionMixin);

function BetterWardrobeSetsCollectionMixin:OnLoad()
	--self.RightInset.BGCornerTopLeft:Hide();
	--self.RightInset.BGCornerTopRight:Hide();

	--self.DetailsFrame.Name:SetFontObjectsToTry(Fancy24Font, Fancy20Font, Fancy16Font);
	--self.DetailsFrame.itemFramesPool = CreateFramePool("FRAME", self.DetailsFrame, "WardrobeSetsDetailsItemFrameTemplate");

	self.selectedVariantSets = { };
end

function BetterWardrobeSetsCollectionMixin:OnShow()
	self:RegisterEvent("GET_ITEM_INFO_RECEIVED");
	self:RegisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE");
	self:RegisterEvent("TRANSMOG_COLLECTION_UPDATED");
	-- select the first set if not init



	local baseSets = addon.sets["Mail" ]
	--if ( not self.init ) then
		--self.init = true;
		--if ( baseSets and baseSets[1] ) then
			--self:SelectSet(self:GetDefaultSetIDForBaseSet(baseSets[1].setID));
		--end
	--else
		self:Refresh();
	--end

	local latestSource = C_TransmogSets.GetLatestSource();
	if ( latestSource ~= NO_TRANSMOG_SOURCE_ID ) then
		local sets = C_TransmogSets.GetSetsContainingSourceID(latestSource);
		local setID = sets and sets[1];
		if ( setID ) then
			self:SelectSet(setID);
			local baseSetID = C_TransmogSets.GetBaseSetID(setID);
			self:ScrollToSet(baseSetID);
		end
		self:ClearLatestSource();
	end

	--WardrobeCollectionFrame.progressBar:Show();
	--self:UpdateProgressBar();
	--self:RefreshCameras();

	--if (self:GetParent().SetsTabHelpBox:IsShown()) then
		--self:GetParent().SetsTabHelpBox:Hide()
		--SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_TRANSMOG_SETS_TAB, true);
	--end

end

function BetterWardrobeSetsCollectionMixin:OnHide()
	self:UnregisterEvent("GET_ITEM_INFO_RECEIVED");
	self:UnregisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE");
	self:UnregisterEvent("TRANSMOG_COLLECTION_UPDATED");
	--SetsDataProvider:ClearSets();
	--WardrobeCollectionFrame_ClearSearch(LE_TRANSMOG_SEARCH_TYPE_BASE_SETS);
end

function BetterWardrobeSetsCollectionMixin:OnEvent(event, ...)
	--[[
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
	]]
end

function BetterWardrobeSetsCollectionMixin:Refresh()
	self.ScrollFrame:Update();
	self:DisplaySet(self:GetSelectedSetID());
end

function BetterWardrobeSetsCollectionMixin:SelectSetFromButton(setID)
	CloseDropDownMenus();
	--self:SelectSet(self:GetDefaultSetIDForBaseSet(setID));
	self:SelectSet(setID);
	print(setID)
end


function BetterWardrobeSetsCollectionMixin:SelectSet(setID)
	self.selectedSetID = setID;

	--local baseSetID = C_TransmogSets.GetBaseSetID(setID);
	--local variantSets = SetsDataProvider:GetVariantSets(baseSetID);
	--if ( #variantSets > 0 ) then
	--	self.selectedVariantSets[baseSetID] = setID;
	--end

	self:Refresh();
end


	BetterWardrobeSetsCollectionMixin.DetailsFrame = WardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame
	BetterWardrobeSetsCollectionMixin.Model = WardrobeCollectionFrame.SetsCollectionFrame.Model


local itemSourceID = {}
local model = CreateFrame("DressUpModel")
model:SetAutoDress(false)

local function GetSourceFromItem(item)
	if not itemSourceID[item] then
		local visualID, sourceID = C_TransmogCollection.GetItemInfo(item)
		itemSourceID[item] = sourceID
		if not itemSourceID[item] then
			model:SetUnit("player")
			model:Undress()
			model:TryOn(item)
			for i = 1, 19 do
				local source = model:GetSlotTransmogSources(i)
				if source ~= 0 then
					itemSourceID[item] = source
					break
				end
			end
		end
	end
	return itemSourceID[item]
end





function BetterWardrobeSetsCollectionMixin:DisplaySet(setID)
print(self.selectedSetID)

	local setInfo = setID
	if ( not setInfo ) then
		self.DetailsFrame:Hide();
		self.Model:Hide();
		return;
	else
		self.DetailsFrame:Show();
		self.Model:Show();
	end
local name, items = addon.GetSetData(setInfo)

	self.DetailsFrame.Name:SetText(name);
	if ( self.DetailsFrame.Name:IsTruncated() ) then
		self.DetailsFrame.Name:Hide();
		self.DetailsFrame.LongName:SetText(name);
		self.DetailsFrame.LongName:Show();
	else
		self.DetailsFrame.Name:Show();
		self.DetailsFrame.LongName:Hide();
	end

	self.DetailsFrame.Label:Hide()
	self.DetailsFrame.LimitedSet:Hide()
	--local newSourceIDs = C_TransmogSets.GetSetNewSources(setID);

	self.DetailsFrame.itemFramesPool:ReleaseAll();
	self.Model:Undress();
	local BUTTON_SPACE = 37;	-- button width + spacing between 2 buttons
	--local sortedSources = SetsDataProvider:GetSortedSetSources(setID);
	local xOffset = -floor((#items - 1) * BUTTON_SPACE / 2);
	--for i = 1, #sortedSources do

	for i = 1, #items do
		local source = GetSourceFromItem(items[i])
		local itemFrame = self.DetailsFrame.itemFramesPool:Acquire();
		itemFrame.sourceID = source
		itemFrame.itemID = items[i]

		local  _, _, _, category, texture  = GetItemInfoInstant(items[i])
		--local _,_,_,texture = C_TransmogCollection.GetAppearanceSourceInfo(items[i])
		--itemFrame.collected = sortedSources[i].collected;
		--itemFrame.invType = sortedSources[i].invType;
		--local texture = C_TransmogCollection.GetSourceIcon(items[i]);
		itemFrame.Icon:SetTexture(texture);
		--if ( sortedSources[i].collected ) then
		--	itemFrame.Icon:SetDesaturated(false);
			--itemFrame.Icon:SetAlpha(1);
			--itemFrame.IconBorder:SetDesaturation(0);
		--	itemFrame.IconBorder:SetAlpha(1);

			--local transmogSlot = C_Transmog.GetSlotForInventoryType(itemFrame.invType);
			--if ( C_TransmogSets.SetHasNewSourcesForSlot(setID, transmogSlot) ) then
			--	itemFrame.New:Show();
			--	itemFrame.New.Anim:Play();
			--else
				--itemFrame.New:Hide();
				--itemFrame.New.Anim:Stop();
			--end
		--else
			--itemFrame.Icon:SetDesaturated(true);
			--itemFrame.Icon:SetAlpha(0.3);
			--itemFrame.IconBorder:SetDesaturation(1);
			--itemFrame.IconBorder:SetAlpha(0.3);
			--itemFrame.New:Hide();
		--end
		--self:SetItemFrameQuality(itemFrame);
	
		itemFrame:SetPoint("TOP", self.DetailsFrame, "TOP", xOffset + (i - 1) * BUTTON_SPACE, -94);
		
		itemFrame:Show();
		self.Model:TryOn(source);
	end

	-- variant sets
	--local baseSetID = C_TransmogSets.GetBaseSetID(setID);
	--local variantSets = SetsDataProvider:GetVariantSets(baseSetID);
	--if ( #variantSets == 0 )  then
		--self.DetailsFrame.VariantSetsButton:Hide();
	--else
		--self.DetailsFrame.VariantSetsButton:Show();
		--self.DetailsFrame.VariantSetsButton:SetText(setInfo.description);
--	end
end

function BetterWardrobeSetsCollectionMixin:SetAppearanceTooltip(frame)
	GameTooltip:SetOwner(frame, "ANCHOR_RIGHT");
	self.tooltipTransmogSlot = C_Transmog.GetSlotForInventoryType(frame.invType);
	self.tooltipPrimarySourceID = frame.sourceID;
	self:RefreshAppearanceTooltip();
end

function BetterWardrobeSetsCollectionMixin:RefreshAppearanceTooltip()
	print("RTT")
	if ( not self.tooltipTransmogSlot ) then
		return;
	end
print(self:GetSelectedSetID())
	local sources = C_TransmogSets.GetSourcesForSlot(self:GetSelectedSetID(), self.tooltipTransmogSlot);
	if ( #sources == 0 ) then
		-- can happen if a slot only has HiddenUntilCollected sources
		local sourceInfo = C_TransmogCollection.GetSourceInfo(self.tooltipPrimarySourceID);
		tinsert(sources, sourceInfo);
	end
	WardrobeCollectionFrame_SortSources(sources, sources[1].visualID, self.tooltipPrimarySourceID);
	WardrobeCollectionFrame_SetAppearanceTooltip(self, sources, self.tooltipPrimarySourceID);
end