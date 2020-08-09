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

local addonName, addon = ...
--addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
addon.Frame = LibStub("AceGUI-3.0")

local playerInv_DB
local Profile
local playerNme
local realmName

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

--LoadAddOn("Blizzard_Collections")

--ACE3 Options Constuctor
local options = {
	name = addonName,
	handler = addon,
	type = 'group',
	childGroups = "tab",
	inline = true,
	args = {
		settings={
			name = "Options",
			type = "group",
			--inline = true,
			order = 0,
			args={
				Options_Header = {
					order = 0,
					name = "Header",
					type = "header",
					width = "full",
				},
				ShowPartial = {
					order = 1,
					name = L["SHOWPARTIAL"] ,
					desc = "",
					type = "toggle",
					set = function(info,val) ShowPartial = val end,
					get = function(info) return ShowPartial end,
					width = "full",
				},
				Linebreak_4 = {
					order = 5.4,
					name = "",
					desc = nil,
					type = "description",
					width = "normal",

				},

				Linebreak_1 = {
					order = 6.1,
					name = "",
					desc = nil,
					type = "description",
					width = "double",

				},
			},
		},

	},
}

--ACE Profile Saved Variables Defaults
local defaults = {
	profile ={
		ShowPartial = true,
		PartialLimit = 4,
		HideMissing = true,

		
	}
}

---Ace based addon initilization
function addon:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("BetterWardrobe_Options", defaults, true)
	options.args.profiles  = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	LibStub("AceConfigRegistry-3.0"):ValidateOptionsTable(options, addonName)
	LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, options)

	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName, addonName)
	--self.db.RegisterCallback(BPCM, "OnProfileChanged", "RefreshConfig")
	--self.db.RegisterCallback(BPCM, "OnProfileCopied", "RefreshConfig")
	--self.db.RegisterCallback(BPCM, "OnProfileReset", "RefreshConfig")	
end


function addon:OnEnable()
	addon.AddSetDetailFrames(WardrobeCollectionFrame.SetsTransmogFrame)
	addon.AddSetDetailFrames(bwSetsTransmogFrame)

	addon.buildDB()

	addon.WardrobeCollectionFrame_OnLoad(WardrobeCollectionFrame)
	self:Hook("WardrobeCollectionFrame_SetTab", true)
	--self:Hook("WardrobeCollectionFrameSearchBox_OnUpdate", true)	
end


local BASE_SET_BUTTON_HEIGHT = 46
local VARIANT_SET_BUTTON_HEIGHT = 20
local SET_PROGRESS_BAR_MAX_WIDTH = 204
local IN_PROGRESS_FONT_COLOR = CreateColor(0.251, 0.753, 0.251)
local IN_PROGRESS_FONT_COLOR_CODE = "|cff40c040"
local COLLECTION_LIST_WIDTH = 260




--[[

local showframe = false

local b = CreateFrame("Button", "MyButton", WardrobeCollectionFrame, "UIPanelButtonTemplate")
b:SetSize(80 ,22) -- width, height
b:SetText("Button!")
b:SetPoint("LEFT", WardrobeCollectionFrame.progressBar, "RIGHT")
b:SetScript("OnClick", function()
	local baseFrame
	local atTransmogrifier = WardrobeFrame_IsAtTransmogrifier()

	if ( atTransmogrifier ) then
		baseFrame = WardrobeCollectionFrame.SetsTransmogFrame
		collectionFrame = bwSetsTransmogFrame
		BWetsCollectionFrame:Hide()
	else
		baseFrame = WardrobeCollectionFrame.SetsCollectionFrame
		collectionFrame = BWetsCollectionFrame
		bwSetsTransmogFrame:Hide()
	end

	    showframe = not showframe
	    collectionFrame:SetShown( showframe)
	    baseFrame:SetShown(not showframe)
end)
]]

function addon.GetSetsources(setID)
	local setInfo = addon.GetSetInfo(setID)
	local setSources = {}

	for i, item in ipairs(setInfo.items) do
		local _, sourceID = C_TransmogCollection.GetItemInfo(item)
		if sourceID then
			local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
			--setSoruceData[sourceID] = C_TransmogCollection.GetSourceInfo(sourceID)
			setSources[sourceID] = sourceInfo.isCollected
		end
	end

	return setSources
end


local SetsDataProvider = CreateFromMixins(WardrobeSetsDataProviderMixin)

local function mysort(set1, set2)
		if ( set1.expansionID ~= set2.expansionID ) then
			return set1.expansionID > set2.expansionID;
		end

        return set1.name < set2.name;
    end


function SetsDataProvider:SortSets(sets, reverseUIOrder, ignorePatchID)
	local comparison = function(set1, set2)
		local groupFavorite1 = set1.favoriteSetID and true;
		local groupFavorite2 = set2.favoriteSetID and true;
		if ( groupFavorite1 ~= groupFavorite2 ) then
			return groupFavorite1;
		end
		if ( set1.favorite ~= set2.favorite ) then
			return set1.favorite;
		end

		if ( set1.expansionID ~= set2.expansionID ) then
			return set1.expansionID > set2.expansionID;
		end
		if not ignorePatchID then
			if ( set1.patchID ~= set2.patchID ) then
				return set1.patchID > set2.patchID;
			end
		end
		if ( set1.uiOrder ~= set2.uiOrder ) then
			if ( reverseUIOrder ) then
				return set1.uiOrder < set2.uiOrder;
			else
				return set1.uiOrder > set2.uiOrder;
			end
		end
		if reverseUIOrder then
			return set1.setID < set2.setID;
		else
			return set1.setID > set2.setID;
		end

		return set1.name > set2.name;
	end

	table.sort(sets, comparison)
	table.sort(sets, mysort)
end

function SetsDataProvider:GetBaseSets()
	if ( not self.baseSets ) then
		self.baseSets = addon.GetBaseList() --C_TransmogSets.GetBaseSets();
		--self:DetermineFavorites();
		self:SortSets(self.baseSets);
	end
	return self.baseSets;
end

function SetsDataProvider:GetUsableSets()
	--[[
	if ( not self.usableSets ) then
		self.usableSets = addon.GetBaseList() --C_TransmogSets.GetUsableSets()
		self:SortSets(self.usableSets)
		-- group sets by baseSetID, except for favorited sets since those are to remain bucketed to the front
		for i, set in ipairs(self.usableSets) do
			if ( not set.favorite ) then
				local baseSetID = set.baseSetID or set.setID
				local numRelatedSets = 0
				--for j = i + 1, #self.usableSets do
					--if ( self.usableSets[j].baseSetID == baseSetID or self.usableSets[j].setID == baseSetID ) then
						--numRelatedSets = numRelatedSets + 1
						-- no need to do anything if already contiguous
						--if ( j ~= i + numRelatedSets ) then
							--local relatedSet = self.usableSets[j]
							--tremove(self.usableSets, j)
							--tinsert(self.usableSets, i + numRelatedSets, relatedSet)
						--end
					--end
				--end
			end
		end
	end
	return self.usableSets
	]]
--if ( not self.usableSets ) then
	local availableSets = addon.GetBaseList()
	local usableSets = {} --SetsDataProvider:GetUsableSets()

		for i, set in ipairs(availableSets) do
			local topSourcesCollected, topSourcesTotal = SetsDataProvider:GetSetSourceCounts(set.setID)

			if topSourcesCollected > 0  then --and not C_TransmogSets.IsSetUsable(set.setID) then
				tinsert(usableSets, set)
			end
		end

	self.usableSets = usableSets
	self:SortSets(self.usableSets)
--end
	return self.usableSets
end


function SetsDataProvider:GetSetSourceData(setID)
	if ( not self.sourceData ) then
		self.sourceData = { }
	end

	local sourceData = self.sourceData[setID]

	if ( not sourceData ) then
		local sources = addon.GetSetsources(setID)
		local numCollected = 0
		local numTotal = 0

		for sourceID, collected in pairs(sources) do

			if ( collected ) then
				numCollected = numCollected + 1
			end
			numTotal = numTotal + 1
		end

		sourceData = { numCollected = numCollected, numTotal = numTotal, collected = numCollected == numTotal, sources = sources }
		self.sourceData[setID] = sourceData
	end

	return sourceData
end


function SetsDataProvider:GetSortedSetSources(setID)
	local returnTable = { }
	local sourceData = self:GetSetSourceData(setID)

	for sourceID, collected in pairs(sourceData.sources) do
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)

		if ( sourceInfo ) then
			local sortOrder = EJ_GetInvTypeSortOrder(sourceInfo.invType)
			tinsert(returnTable, { sourceID = sourceID, collected = collected, sortOrder = sortOrder, itemID = sourceInfo.itemID, invType = sourceInfo.invType })
		end
	end

	local comparison = function(entry1, entry2)
		if ( entry1.sortOrder == entry2.sortOrder ) then
			return entry1.itemID < entry2.itemID
		else
			return entry1.sortOrder < entry2.sortOrder
		end
	end

	table.sort(returnTable, comparison)
	return returnTable
end


function SetsDataProvider:GetBaseSetData(setID)
	if ( not self.baseSetsData ) then
		self.baseSetsData = { }
	end

	if ( not self.baseSetsData[setID] ) then
		local baseSetID = C_TransmogSets.GetBaseSetID(setID)
		if ( baseSetID ~= setID ) then
			return
		end
		local topCollected, topTotal = self:GetSetSourceCounts(setID)
		local setInfo = { topCollected = topCollected, topTotal = topTotal, completed = (topCollected == topTotal) }
		self.baseSetsData[setID] = setInfo
	end

	return self.baseSetsData[setID]
end


BetterWardrobeSetsCollectionScrollFrameMixin = CreateFromMixins(WardrobeSetsCollectionScrollFrameMixin)

function BetterWardrobeSetsCollectionScrollFrameMixin:OnLoad()
	self.scrollBar.trackBG:Show()
	self.scrollBar.trackBG:SetVertexColor(0, 0, 0, 0.75)
	self.scrollBar.doNotHide = true
	self.update = self.Update
	HybridScrollFrame_CreateButtons(self, "BetterWardrobeSetsScrollFrameButtonTemplate", 44, 0)
	--UIDropDownMenu_Initialize(self.FavoriteDropDown, WardrobeSetsCollectionScrollFrame_FavoriteDropDownInit, "MENU")
end


function BetterWardrobeSetsCollectionScrollFrameMixin:OnShow()
	self:RegisterEvent("TRANSMOG_SETS_UPDATE_FAVORITE")
end


function BetterWardrobeSetsCollectionScrollFrameMixin:OnHide()
	self:UnregisterEvent("TRANSMOG_SETS_UPDATE_FAVORITE")
end


function BetterWardrobeSetsCollectionScrollFrameMixin:OnEvent(event, ...)
	if ( event == "TRANSMOG_SETS_UPDATE_FAVORITE" ) then
	--	SetsDataProvider:RefreshFavorites()
		--self:Update()
	end
end


local selectedSetID
function BetterWardrobeSetsCollectionScrollFrameMixin:Update()
	local offset = HybridScrollFrame_GetOffset(self)
	local buttons = self.buttons
	local baseSets =  SetsDataProvider:GetBaseSets() --addon.GetBaseList()

	-- show the base set as selected
	local selectedSetID = self:GetParent():GetSelectedSetID()
	local selectedBaseSetID = selectedSetID --and C_TransmogSets.GetBaseSetID(selectedSetID)

	for i = 1, #buttons do
		local button = buttons[i]
		local setIndex = i + offset

		if ( setIndex <= #baseSets ) then
			local baseSet = baseSets[setIndex]
			--local count, complete = addon.GetSetCompletion(baseSet)
			button:Show()
			button.Name:SetText(baseSet.name)
			local topSourcesCollected, topSourcesTotal = SetsDataProvider:GetSetSourceTopCounts(baseSet.setID)

			local setCollected = topSourcesCollected == topSourcesTotal --baseSet.collected -- C_TransmogSets.IsBaseSetCollected(baseSet.setID)
			local color = IN_PROGRESS_FONT_COLOR

			if ( setCollected ) then
				color = NORMAL_FONT_COLOR
			elseif ( topSourcesCollected == 0 ) then
				color = GRAY_FONT_COLOR
			end

			button.Name:SetTextColor(color.r, color.g, color.b)
			button.Label:SetText((L["NOTE_"..(baseSet.label or 0)] and L["NOTE_"..(baseSet.label or 0) ]) or "")--((L["NOTE_"..baseSet.label] or "X"))
			button.Icon:SetTexture(SetsDataProvider:GetIconForSet(baseSet.setID))
			button.Icon:SetDesaturation((topSourcesCollected == 0) and 1 or 0)
			button.SelectedTexture:SetShown(baseSet.setID == selectedBaseSetID)
			button.Favorite:Hide() --SetShown(baseSet.favoriteSetID)
			--button.New:SetShown(SetsDataProvider:IsBaseSetNew(baseSet.setID))
			button.setID = baseSet.setID

			if ( topSourcesCollected == 0 or setCollected ) then
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

--Collection Set
BetterWardrobeSetsCollectionMixin = CreateFromMixins(WardrobeSetsCollectionMixin)

function BetterWardrobeSetsCollectionMixin:OnLoad()
	self.RightInset.BGCornerTopLeft:Hide()
	self.RightInset.BGCornerTopRight:Hide()

	self.DetailsFrame.Name:SetFontObjectsToTry(Fancy24Font, Fancy20Font, Fancy16Font)
	self.DetailsFrame.itemFramesPool = CreateFramePool("FRAME", self.DetailsFrame, "WardrobeSetsDetailsItemFrameTemplate")

	self.selectedVariantSets = { }
end


function BetterWardrobeSetsCollectionMixin:OnShow()
	self:RegisterEvent("GET_ITEM_INFO_RECEIVED")
	self:RegisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE")
	self:RegisterEvent("TRANSMOG_COLLECTION_UPDATED")
	-- select the first set if not init

	local baseSets = SetsDataProvider:GetBaseSets() --addon.GetBaseList()--addon.sets["Mail" ]
	if ( not self.init ) then
		self.init = true

		if ( baseSets and baseSets[1] ) then
			--self:SelectSet(self:GetDefaultSetIDForBaseSet(baseSets[1].setID))
			self:SelectSet(baseSets[1].setID)

		end

	else
		self:Refresh()
	end

	local latestSource = C_TransmogSets.GetLatestSource()

	if ( latestSource ~= NO_TRANSMOG_SOURCE_ID ) then
		local sets = C_TransmogSets.GetSetsContainingSourceID(latestSource)
		local setID = sets and sets[1]
		if ( setID ) then
			self:SelectSet(setID)
			local baseSetID = C_TransmogSets.GetBaseSetID(setID)
			self:ScrollToSet(baseSetID)
		end
		self:ClearLatestSource()
	end

	--WardrobeCollectionFrame.progressBar:Show()
	--self:UpdateProgressBar()
	self:RefreshCameras()

	--if (self:GetParent().SetsTabHelpBox:IsShown()) then
		--self:GetParent().SetsTabHelpBox:Hide()
		--SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_TRANSMOG_SETS_TAB, true)
	--end
end


function BetterWardrobeSetsCollectionMixin:OnHide()
	self:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
	self:UnregisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE")
	self:UnregisterEvent("TRANSMOG_COLLECTION_UPDATED")
	SetsDataProvider:ClearSets()
	--WardrobeCollectionFrame_ClearSearch(LE_TRANSMOG_SEARCH_TYPE_BASE_SETS)
end


function BetterWardrobeSetsCollectionMixin:OnEvent(event, ...)
	--[[
	if ( event == "GET_ITEM_INFO_RECEIVED" ) then
		local itemID = ...
		for itemFrame in self.DetailsFrame.itemFramesPool:EnumerateActive() do
			if ( itemFrame.itemID == itemID ) then
				self:SetItemFrameQuality(itemFrame)
				break
			end
		end
	elseif ( event == "TRANSMOG_COLLECTION_ITEM_UPDATE" ) then
		for itemFrame in self.DetailsFrame.itemFramesPool:EnumerateActive() do
			self:SetItemFrameQuality(itemFrame)
		end
	elseif ( event == "TRANSMOG_COLLECTION_UPDATED" ) then
		SetsDataProvider:ClearSets()
		self:Refresh()
		self:UpdateProgressBar()
		self:ClearLatestSource()
	end
	]]
end


function BetterWardrobeSetsCollectionMixin:Refresh()
	self.ScrollFrame:Update()
	self:DisplaySet(self:GetSelectedSetID())
end


function BetterWardrobeSetsCollectionMixin:SelectSetFromButton(setID)
	CloseDropDownMenus()
	--self:SelectSet(self:GetDefaultSetIDForBaseSet(setID))
	self:SelectSet(setID)
end


function BetterWardrobeSetsCollectionMixin:SelectSet(setID)
	self.selectedSetID = setID

	--local baseSetID = C_TransmogSets.GetBaseSetID(setID)
	--local variantSets = SetsDataProvider:GetVariantSets(baseSetID)
	--if ( #variantSets > 0 ) then
	--	self.selectedVariantSets[baseSetID] = setID
	--end

	self:Refresh()
end

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
	local setInfo = setID

	if ( not setInfo ) then
		self.DetailsFrame:Hide()
		self.Model:Hide()
		return
	else
		self.DetailsFrame:Show()
		self.Model:Show()
	end

	local setInfo = addon.GetSetInfo(setID)

	self.DetailsFrame.Name:SetText(setInfo.name)

	if ( self.DetailsFrame.Name:IsTruncated() ) then
		self.DetailsFrame.Name:Hide()
		self.DetailsFrame.LongName:SetText(setInfo.name)
		self.DetailsFrame.LongName:Show()
	else
		self.DetailsFrame.Name:Show()
		self.DetailsFrame.LongName:Hide()
	end

	self.DetailsFrame.Label:Hide()
	--local newSourceIDs = C_TransmogSets.GetSetNewSources(setID)

	self.DetailsFrame.itemFramesPool:ReleaseAll()
	self.Model:Undress()
	local BUTTON_SPACE = 37	-- button width + spacing between 2 buttons
	local sortedSources = SetsDataProvider:GetSortedSetSources(setID)
	local xOffset = -floor((#setInfo.items - 1) * BUTTON_SPACE / 2)

	for i = 1, #sortedSources do
		--local source = GetSourceFromItem(sortedSources[i])
		local itemFrame = self.DetailsFrame.itemFramesPool:Acquire()
		itemFrame.sourceID = sortedSources[i].sourceID
		itemFrame.itemID = sortedSources[i].itemID
		itemFrame.collected = sortedSources[i].collected
		itemFrame.invType = sortedSources[i].invType
		local texture = C_TransmogCollection.GetSourceIcon(sortedSources[i].sourceID)
		itemFrame.Icon:SetTexture(texture)

		if ( sortedSources[i].collected ) then
			itemFrame.Icon:SetDesaturated(false)
			itemFrame.Icon:SetAlpha(1)
			itemFrame.IconBorder:SetDesaturation(0)
			itemFrame.IconBorder:SetAlpha(1)
			local transmogSlot = C_Transmog.GetSlotForInventoryType(itemFrame.invType)

			if ( C_TransmogSets.SetHasNewSourcesForSlot(setID, transmogSlot) ) then
				itemFrame.New:Show()
				itemFrame.New.Anim:Play()
			else
				itemFrame.New:Hide()
				itemFrame.New.Anim:Stop()
			end
		else
			itemFrame.Icon:SetDesaturated(true)
			itemFrame.Icon:SetAlpha(0.3)
			itemFrame.IconBorder:SetDesaturation(1)
			itemFrame.IconBorder:SetAlpha(0.3)
			itemFrame.New:Hide()
		end

		self:SetItemFrameQuality(itemFrame)
		itemFrame:SetPoint("TOP", self.DetailsFrame, "TOP", xOffset + (i - 1) * BUTTON_SPACE, -94)
		itemFrame:Show()
		self.Model:TryOn(sortedSources[i].sourceID)
	end

	-- variant sets
	--local baseSetID = C_TransmogSets.GetBaseSetID(setID)
	--local variantSets = SetsDataProvider:GetVariantSets(baseSetID)
	--if ( #variantSets == 0 )  then
		--self.DetailsFrame.VariantSetsButton:Hide()
	--else
		--self.DetailsFrame.VariantSetsButton:Show()
		--self.DetailsFrame.VariantSetsButton:SetText(setInfo.description)
--	end
end


function BetterWardrobeSetsCollectionMixin:SetAppearanceTooltip(frame)
	GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
	self.tooltipTransmogSlot = C_Transmog.GetSlotForInventoryType(frame.invType)
	self.tooltipPrimarySourceID = frame.sourceID
	self:RefreshAppearanceTooltip()
end


function BetterWardrobeSetsCollectionMixin:RefreshAppearanceTooltip()
	if ( not self.tooltipTransmogSlot ) then
		return
	end

--local allSources = C_TransmogCollection.GetAllAppearanceSources(appearanceID)
	local sources = C_TransmogSets.GetSourcesForSlot(self:GetSelectedSetID(), self.tooltipTransmogSlot) or {}
	if ( #sources == 0 ) then
		-- can happen if a slot only has HiddenUntilCollected sources

	local sourceInfo = C_TransmogCollection.GetSourceInfo(self.tooltipPrimarySourceID)
	--	print(C_TransmogCollection.GetItemInfo(sourceInfo.itemID))
		--local appearanceID = C_TransmogCollection.GetItemInfo(sourceInfo.itemID)
		--local allSources = C_TransmogCollection.GetAllAppearanceSources(appearanceID)

		--tinsert(allSources, sourceInfo)
				tinsert(sources, sourceInfo)

	end

	WardrobeCollectionFrame_SortSources(sources, sources[1].visualID, self.tooltipPrimarySourceID)
	WardrobeCollectionFrame_SetAppearanceTooltip(self, sources, self.tooltipPrimarySourceID)
end

---Trannsmog Custom Sets
BWWardrobeSetsTransmogModelMixin = CreateFromMixins(WardrobeSetsTransmogModelMixin)

function BWWardrobeSetsTransmogModelMixin:RefreshTooltip()
	local totalQuality = 0
	local numTotalSlots = 0
	local waitingOnQuality = false
	local sourceQualityTable = self:GetParent().sourceQualityTable
	--[[
	local sources = C_TransmogSets.GetSetSources(self.setID)
	for sourceID in pairs(sources) do
		numTotalSlots = numTotalSlots + 1
		if ( sourceQualityTable[sourceID] ) then
			totalQuality = totalQuality + sourceQualityTable[sourceID]
		else
			local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
			if ( sourceInfo and sourceInfo.quality ) then
				sourceQualityTable[sourceID] = sourceInfo.quality
				totalQuality = totalQuality + sourceInfo.quality
			else
				waitingOnQuality = true
			end
		end
	end]]
	if ( waitingOnQuality ) then
		GameTooltip:SetText(RETRIEVING_ITEM_INFO, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		local setQuality = (numTotalSlots > 0 and totalQuality > 0) and Round(totalQuality / numTotalSlots) or LE_ITEM_QUALITY_COMMON
		local color = ITEM_QUALITY_COLORS[setQuality]
		local setInfo = addon.GetSetInfo(self.setID)
		GameTooltip:SetText(setInfo.name, color.r, color.g, color.b)
		if ( setInfo.label ) then
			GameTooltip:AddLine(L["NOTE_"..(setInfo.label or 0)])--((L["NOTE_"..baseSet.label] or "X"))

			GameTooltip:Show()
		end
	end

end


function BWWardrobeSetsTransmogModelMixin:LoadSet(setID)
	local waitingOnData = false
	local transmogSources = { }
	local sources = addon.GetSetsources(setID)
	for sourceID in pairs(sources) do
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
		local slot = C_Transmog.GetSlotForInventoryType(sourceInfo.invType)
		local slotSources = C_TransmogSets.GetSourcesForSlot(setID, slot)
		--WardrobeCollectionFrame_SortSources(slotSources, sourceInfo.visualID)
		local index = WardrobeCollectionFrame_GetDefaultSourceIndex(slotSources, sourceID)
		transmogSources[slot] = slotSources[index].sourceID

		for i, slotSourceInfo in ipairs(slotSources) do
			if ( not slotSourceInfo.name ) then
				waitingOnData = true
			end
		end
	end
	if ( waitingOnData ) then
		self.loadingSetID = setID
	else
		self.loadingSetID = nil
		-- if we don't ignore the event, clearing will momentarily set the page to the one with the set the user currently has transmogged
		-- if that's a different page from the current one then the models will flicker as we swap the gear to different sets and back
		self.ignoreTransmogrifyUpdateEvent = true
		C_Transmog.ClearPending()
		self.ignoreTransmogrifyUpdateEvent = false
		C_Transmog.LoadSources(transmogSources, -1, -1)
	end
end


BetterWardrobeSetsTransmogMixin = CreateFromMixins(WardrobeSetsTransmogMixin)

function BetterWardrobeSetsTransmogMixin:OnShow()
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

	--if (self:GetParent().SetsTabHelpBox:IsShown()) then
		--self:GetParent().SetsTabHelpBox:Hide()
		--SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_TRANSMOG_SETS_VENDOR_TAB, true)
	--end
end

function BetterWardrobeSetsTransmogMixin:SelectSet(setID)
	self.selectedSetID = setID;
	self:LoadSet(setID);
	self:ResetPage();
end

do
	local EmptyArmor = {
		[1] = 134110,
		--[2] = 134112, neck
		[3] = 134112,
		--[4] = 168659, shirt
		[5] = 168659,
		[6] = 143539,
		--[7] = 158329, pants
		[8] = 168664,
		[9] = 168665,  --wrist
		[10] = 158329, --handr
}

	 function GetEmptySlots()
	 	local setInfo = {}

	 	for i,x in pairs(EmptyArmor) do
	 		setInfo[i]=x
	 	end

		return setInfo
	end

end

function EmptySlots(transmogSources)
	local EmptySet= GetEmptySlots()

	for i, x in pairs(transmogSources) do
			EmptySet[i] = nil
	end

	return EmptySet
end


function BetterWardrobeSetsTransmogMixin:LoadSet(setID)
	local waitingOnData = false
	local transmogSources = { }
	local sources = addon.GetSetsources(setID)

	for sourceID in pairs(sources) do
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
		local slot = C_Transmog.GetSlotForInventoryType(sourceInfo.invType)
		--local slotSources = C_TransmogSets.GetSourcesForSlot(setID, slot)
		--WardrobeCollectionFrame_SortSources(slotSources, sourceInfo.visualID)
		--local index = WardrobeCollectionFrame_GetDefaultSourceIndex(slotSources, sourceID)
		transmogSources[slot] = sourceInfo.sourceID

		for i, slotSourceInfo in ipairs(sourceInfo) do
			if ( not slotSourceInfo.name ) then
				waitingOnData = true
			end
		end
	end

	if ( waitingOnData ) then
		self.loadingSetID = setID

	else
		self.loadingSetID = nil
		-- if we don't ignore the event, clearing will momentarily set the page to the one with the set the user currently has transmogged
		-- if that's a different page from the current one then the models will flicker as we swap the gear to different sets and back
		self.ignoreTransmogrifyUpdateEvent = true
		C_Transmog.ClearPending()
		self.ignoreTransmogrifyUpdateEvent = false
		C_Transmog.LoadSources(transmogSources, -1, -1)

		local clearSlots = EmptySlots(transmogSources)
		for i, x in pairs(clearSlots) do
			local _,  source =C_TransmogCollection.GetItemInfo(x)
			C_Transmog.SetPending(i, LE_TRANSMOG_TYPE_APPEARANCE,source)
		end

		local emptySlotData = GetEmptySlots()
		for i, x in pairs(transmogSources) do
			if not C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(x) and i ~= 7 then
				local _,  source = C_TransmogCollection.GetItemInfo(emptySlotData[i])
				C_Transmog.SetPending(i, LE_TRANSMOG_TYPE_APPEARANCE, source)
			end
		end
	
	end
end


function BetterWardrobeSetsTransmogMixin:UpdateSets()
	local usableSets = SetsDataProvider:GetUsableSets()
	self.PagingFrame:SetMaxPages(ceil(#usableSets / self.PAGE_SIZE))
	local pendingTransmogModelFrame = nil
	local indexOffset = (self.PagingFrame:GetCurrentPage() - 1) * self.PAGE_SIZE

	for i = 1, self.PAGE_SIZE do
		local model = self.Models[i]
		local index = i + indexOffset
		local set = usableSets[index]

		if ( set ) then
			model:Show()

			if ( model.setID ~= set.setID ) then
				model:Undress()
				local sourceData = SetsDataProvider:GetSetSourceData(set.setID)

				for sourceID  in pairs(sourceData.sources) do
					model:TryOn(sourceID)
				end
			end

			local transmogStateAtlas

			if ( set.setID == self.appliedSetID and set.setID == self.selectedSetID ) then
				transmogStateAtlas = "transmog-set-border-current-transmogged"
			elseif ( set.setID == self.selectedSetID ) then
				transmogStateAtlas = "transmog-set-border-selected"
				pendingTransmogModelFrame = model
			end

			if ( transmogStateAtlas ) then
				model.TransmogStateTexture:SetAtlas(transmogStateAtlas, true)
				model.TransmogStateTexture:Show()
			else
				model.TransmogStateTexture:Hide()
			end

			local topSourcesCollected, topSourcesTotal = SetsDataProvider:GetSetSourceCounts(set.setID)
			local setInfo = addon.GetSetInfo(set.setID)

			model.Favorite.Icon:SetShown(set.favorite)
			model.setID = set.setID
			model.setName:SetText(setInfo["name"].."\n"..(setInfo["description"] or ""))
			model.progress:SetText(topSourcesCollected.."/".. topSourcesTotal)
		else
			model:Hide()
		end
	end

	if ( pendingTransmogModelFrame ) then
		self.PendingTransmogFrame:SetParent(pendingTransmogModelFrame)
		self.PendingTransmogFrame:SetPoint("CENTER")
		self.PendingTransmogFrame:Show()

		if ( self.PendingTransmogFrame.setID ~= pendingTransmogModelFrame.setID ) then
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


local function GetPage(entryIndex, pageSize)
	return floor((entryIndex-1) / pageSize) + 1
end


function BetterWardrobeSetsTransmogMixin:ResetPage()
	local page = 1

	if ( self.selectedSetID ) then
		local usableSets = SetsDataProvider:GetUsableSets()
		self.PagingFrame:SetMaxPages(ceil(#usableSets / self.PAGE_SIZE))
		for i, set in ipairs(usableSets) do
			if ( set.setID == self.selectedSetID ) then
				page = GetPage(i, self.PAGE_SIZE)
				break
			end
		end
	end

	self.PagingFrame:SetCurrentPage(page)
	self:UpdateSets()
end


--- Functionality to add 3rd tab to windows
local TAB_ITEMS = 1;
local TAB_SETS = 2;
local TAB_EXTRASETS = 3;
local TABS_MAX_WIDTH = 185;

function addon:WardrobeCollectionFrame_SetTab(tabID)
	PanelTemplates_SetTab(WardrobeCollectionFrame, tabID);
	local atTransmogrifier = WardrobeFrame_IsAtTransmogrifier();
	if ( atTransmogrifier ) then
		WardrobeCollectionFrame.selectedTransmogTab = tabID;
	else
		WardrobeCollectionFrame.selectedCollectionTab = tabID;
	end
	if ( tabID == TAB_ITEMS ) then
		WardrobeCollectionFrame.activeFrame = WardrobeCollectionFrame.ItemsCollectionFrame;
		WardrobeCollectionFrame.ItemsCollectionFrame:Show();
		WardrobeCollectionFrame.SetsCollectionFrame:Hide();
		WardrobeCollectionFrame.SetsTransmogFrame:Hide();
		WardrobeCollectionFrame.bwSetsTransmogFrame:Hide();
		WardrobeCollectionFrame.BWetsCollectionFrame:Hide();
		WardrobeCollectionFrame.searchBox:ClearAllPoints();
		WardrobeCollectionFrame.searchBox:SetPoint("TOPRIGHT", -107, -35);
		WardrobeCollectionFrame.searchBox:SetWidth(115);
		WardrobeCollectionFrame.searchBox:SetEnabled(WardrobeCollectionFrame.ItemsCollectionFrame.transmogType == LE_TRANSMOG_TYPE_APPEARANCE);
		WardrobeCollectionFrame.FilterButton:Show();
		WardrobeCollectionFrame.FilterButton:SetEnabled(WardrobeCollectionFrame.ItemsCollectionFrame.transmogType == LE_TRANSMOG_TYPE_APPEARANCE);
	elseif ( tabID == TAB_SETS ) then
		WardrobeCollectionFrame.ItemsCollectionFrame:Hide();
		WardrobeCollectionFrame.bwSetsTransmogFrame:Hide();
		WardrobeCollectionFrame.BWetsCollectionFrame:Hide();
		WardrobeCollectionFrame.searchBox:ClearAllPoints();
		if ( atTransmogrifier )  then
			WardrobeCollectionFrame.activeFrame = WardrobeCollectionFrame.SetsTransmogFrame;
			WardrobeCollectionFrame.searchBox:SetPoint("TOPRIGHT", -107, -35);
			WardrobeCollectionFrame.searchBox:SetWidth(115);
			WardrobeCollectionFrame.FilterButton:Hide();
		else
			WardrobeCollectionFrame.activeFrame = WardrobeCollectionFrame.SetsCollectionFrame;
			WardrobeCollectionFrame.searchBox:SetPoint("TOPLEFT", 19, -69);
			WardrobeCollectionFrame.searchBox:SetWidth(145);
			WardrobeCollectionFrame.FilterButton:Show();
			WardrobeCollectionFrame.FilterButton:SetEnabled(true);
		end
		WardrobeCollectionFrame.searchBox:SetEnabled(true);
		WardrobeCollectionFrame.SetsCollectionFrame:SetShown(not atTransmogrifier);
		WardrobeCollectionFrame.SetsTransmogFrame:SetShown(atTransmogrifier);
	elseif ( tabID == TAB_EXTRASETS ) then
		WardrobeCollectionFrame.ItemsCollectionFrame:Hide();
		WardrobeCollectionFrame.SetsCollectionFrame:Hide();
		WardrobeCollectionFrame.SetsTransmogFrame:Hide();
		WardrobeCollectionFrame.searchBox:ClearAllPoints();
		if ( atTransmogrifier )  then
			WardrobeCollectionFrame.activeFrame = WardrobeCollectionFrame.bwSetsTransmogFrame;
			WardrobeCollectionFrame.searchBox:SetPoint("TOPRIGHT", -107, -35);
			WardrobeCollectionFrame.searchBox:SetWidth(115);
			WardrobeCollectionFrame.FilterButton:Hide();
		else
			WardrobeCollectionFrame.activeFrame = WardrobeCollectionFrame.BWetsCollectionFrame;
			WardrobeCollectionFrame.searchBox:SetPoint("TOPLEFT", 19, -69);
			WardrobeCollectionFrame.searchBox:SetWidth(145);
			WardrobeCollectionFrame.FilterButton:Show();
			WardrobeCollectionFrame.FilterButton:SetEnabled(true);
		end
		WardrobeCollectionFrame.searchBox:SetEnabled(true);
		WardrobeCollectionFrame.BWetsCollectionFrame:SetShown(not atTransmogrifier);
		WardrobeCollectionFrame.bwSetsTransmogFrame:SetShown(atTransmogrifier);
	end
end


--Reloads WardrobeCollectionFrame to include new tab
function addon.WardrobeCollectionFrame_OnLoad(self)
	PanelTemplates_SetNumTabs(self, 3);
	PanelTemplates_SetTab(self, TAB_ITEMS);
	PanelTemplates_ResizeTabsToFit(self, TABS_MAX_WIDTH);
	self.selectedCollectionTab = TAB_ITEMS;
	self.selectedTransmogTab = TAB_ITEMS;
end

function addon:WardrobeCollectionFrameSearchBox_OnUpdate()
	print("hook")
end