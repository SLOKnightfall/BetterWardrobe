--test
--local addonName, addon = ...
--_G["BPCM"] = BPCM
--addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
local addonName, addon = ...
--_G["BPCM"] = BPCM
local set = {1321,"Beaststalker Armor (Recolor)",{29520,29521,29519,31328},nil}


local SetsDataProvider = CreateFromMixins(WardrobeSetsDataProviderMixin);
local BASE_SET_BUTTON_HEIGHT = 46;
local VARIANT_SET_BUTTON_HEIGHT = 20;
local SET_PROGRESS_BAR_MAX_WIDTH = 204;
local IN_PROGRESS_FONT_COLOR = CreateColor(0.251, 0.753, 0.251);
local IN_PROGRESS_FONT_COLOR_CODE = "|cff40c040";


function SetsDataProvider:GetBaseSets()
	if ( not self.baseSets ) then
		self.baseSets = C_TransmogSets.GetBaseSets();
		self:DetermineFavorites();
		self:SortSets(self.baseSets);
	end
	return self.baseSets;
end

--[[
function SetsDataProvider:GetUsableSets()
	if ( not self.usableSets ) then
		self.usableSets = C_TransmogSets.GetUsableSets();
		self:SortSets(self.usableSets);
		-- group sets by baseSetID, except for favorited sets since those are to remain bucketed to the front
		for i, set in ipairs(self.usableSets) do
			if ( not set.favorite ) then
				local baseSetID = set.baseSetID or set.setID;
				local numRelatedSets = 0;
				for j = i + 1, #self.usableSets do
					if ( self.usableSets[j].baseSetID == baseSetID or self.usableSets[j].setID == baseSetID ) then
						numRelatedSets = numRelatedSets + 1;
						-- no need to do anything if already contiguous
						if ( j ~= i + numRelatedSets ) then
							local relatedSet = self.usableSets[j];
							tremove(self.usableSets, j);
							tinsert(self.usableSets, i + numRelatedSets, relatedSet);
						end
					end
				end
			end
		end
	end
	return self.usableSets;
end
]]

function SetsDataProvider:GetUsableSets()
	local availableSets = SetsDataProvider:GetBaseSets();
	local usableSets = {} --SetsDataProvider:GetUsableSets();
		for i, set in ipairs(availableSets) do
			local topSourcesCollected, topSourcesTotal = SetsDataProvider:GetSetSourceCounts(set.setID);

			if topSourcesCollected > 0  then --and not C_TransmogSets.IsSetUsable(set.setID) then
				tinsert(usableSets, set)
			end

			local variantSets = C_TransmogSets.GetVariantSets(set.setID);
			for i, set in ipairs(variantSets) do
				local topSourcesCollected, topSourcesTotal = SetsDataProvider:GetSetSourceCounts(set.setID);
				if topSourcesCollected > 0  then --and not C_TransmogSets.IsSetUsable(set.setID) then
					tinsert(usableSets, set)
				end
			end
		end
	self.usableSets = usableSets
	self:SortSets(self.usableSets);
	return self.usableSets;
end


function SetsDataProvider:GetVariantSets(baseSetID)
	if ( not self.variantSets ) then
		self.variantSets = { };
	end

	local variantSets = self.variantSets[baseSetID];
	if ( not variantSets ) then
		variantSets = C_TransmogSets.GetVariantSets(baseSetID);
		self.variantSets[baseSetID] = variantSets;
		if ( #variantSets > 0 ) then
			-- add base to variants and sort
			local baseSet = self:GetBaseSetByID(baseSetID);
			if ( baseSet ) then
				tinsert(variantSets, baseSet);
			end
			local reverseUIOrder = true;
			local ignorePatchID = true;
			self:SortSets(variantSets, reverseUIOrder, ignorePatchID);
		end
	end
	return variantSets;
end

function SetsDataProvider:GetSetSourceData(setID)
	if ( not self.sourceData ) then
		self.sourceData = { };
	end

	local sourceData = self.sourceData[setID];
	if ( not sourceData ) then
		local sources = C_TransmogSets.GetSetSources(setID);
		local numCollected = 0;
		local numTotal = 0;
		for sourceID, collected in pairs(sources) do
			if ( collected ) then
				numCollected = numCollected + 1;
			end
			numTotal = numTotal + 1;
		end
		sourceData = { numCollected = numCollected, numTotal = numTotal, sources = sources };
		self.sourceData[setID] = sourceData;
	end
	return sourceData;
end

function SetsDataProvider:GetBaseSetData(setID)
	if ( not self.baseSetsData ) then
		self.baseSetsData = { };
	end
	if ( not self.baseSetsData[setID] ) then
		local baseSetID = C_TransmogSets.GetBaseSetID(setID);
		if ( baseSetID ~= setID ) then
			return;
		end
		local topCollected, topTotal = self:GetSetSourceCounts(setID);
		local variantSets = self:GetVariantSets(setID);
		for i = 1, #variantSets do
			local numCollected, numTotal = self:GetSetSourceCounts(variantSets[i].setID);
			if ( numCollected > topCollected ) then
				topCollected = numCollected;
				topTotal = numTotal;
			end
		end
		local setInfo = { topCollected = topCollected, topTotal = topTotal, completed = (topCollected == topTotal) };
		self.baseSetsData[setID] = setInfo;
	end
	return self.baseSetsData[setID];
end


function SetsDataProvider:ClearSets()
	self.baseSets = nil;
	self.baseSetsData = nil;
	self.variantSets = nil;
	self.usableSets = nil;
	self.sourceData = nil;
end

function SetsDataProvider:ClearBaseSets()
	self.baseSets = nil;
end

function SetsDataProvider:ClearVariantSets()
	self.variantSets = nil;
end

function SetsDataProvider:ClearUsableSets()
	self.usableSets = nil;
end

function SetsDataProvider:DetermineFavorites()
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
end

function SetsDataProvider:RefreshFavorites()
	self.baseSets = nil;
	self.variantSets = nil;
	self:DetermineFavorites();
end


local BetterWardrobeSetsTransmogMixin = CreateFromMixins(WardrobeSetsTransmogMixin);

function BetterWardrobeSetsTransmogMixin:UpdateSets()
	local usableSets = SetsDataProvider:GetUsableSets();
	WardrobeCollectionFrame.SetsTransmogFrame.PagingFrame:SetMaxPages(ceil(#usableSets / WardrobeCollectionFrame.SetsTransmogFrame.PAGE_SIZE));
	local pendingTransmogModelFrame = nil;
	local indexOffset = (WardrobeCollectionFrame.SetsTransmogFrame.PagingFrame:GetCurrentPage() - 1) * WardrobeCollectionFrame.SetsTransmogFrame.PAGE_SIZE;
	for i = 1, WardrobeCollectionFrame.SetsTransmogFrame.PAGE_SIZE do
		local model = WardrobeCollectionFrame.SetsTransmogFrame.Models[i];
		local index = i + indexOffset;
		local set = usableSets[index];
		if ( set ) then
			model:Show();
			if ( model.setID ~= set.setID ) then
				model:Undress();
				local sourceData = SetsDataProvider:GetSetSourceData(set.setID);
				for sourceID  in pairs(sourceData.sources) do
					model:TryOn(sourceID);
				end
			end
			local transmogStateAtlas;
			if ( set.setID == WardrobeCollectionFrame.SetsTransmogFrame.appliedSetID and set.setID == WardrobeCollectionFrame.SetsTransmogFrame.selectedSetID ) then
				transmogStateAtlas = "transmog-set-border-current-transmogged";
			elseif ( set.setID == WardrobeCollectionFrame.SetsTransmogFrame.selectedSetID ) then
				transmogStateAtlas = "transmog-set-border-selected";
				pendingTransmogModelFrame = model;
			end
			if ( transmogStateAtlas ) then
				model.TransmogStateTexture:SetAtlas(transmogStateAtlas, true);
				model.TransmogStateTexture:Show();
			else
				model.TransmogStateTexture:Hide();
			end
			local topSourcesCollected, topSourcesTotal = SetsDataProvider:GetSetSourceCounts(set.setID);
			local setInfo = C_TransmogSets.GetSetInfo(set.setID)
			model.Favorite.Icon:SetShown(C_TransmogSets.GetIsFavorite(set.setID))
			model.setID = set.setID
			model.setName:SetText(setInfo["name"].."\n"..(setInfo["description"] or ""))
			model.progress:SetText(topSourcesCollected.."/".. topSourcesTotal)
		print(setInfo.label)
			
		else
			model:Hide();
		end
	end

	if ( pendingTransmogModelFrame ) then
		self.PendingTransmogFrame:SetParent(pendingTransmogModelFrame);
		self.PendingTransmogFrame:SetPoint("CENTER");
		self.PendingTransmogFrame:Show();
		if ( self.PendingTransmogFrame.setID ~= pendingTransmogModelFrame.setID ) then
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
		self.PendingTransmogFrame.setID = pendingTransmogModelFrame.setID;
	else
		self.PendingTransmogFrame:Hide();
	end

	self.NoValidSetsLabel:SetShown(not C_TransmogSets.HasUsableSets());
end

local function GetPage(entryIndex, pageSize)
	return floor((entryIndex-1) / pageSize) + 1;
end

function BetterWardrobeSetsTransmogMixin:ResetPage()
	local page = 1;
	if ( self.selectedSetID ) then
		local usableSets = SetsDataProvider:GetUsableSets();
		self.PagingFrame:SetMaxPages(ceil(#usableSets / self.PAGE_SIZE));
		for i, set in ipairs(usableSets) do
			if ( set.setID == self.selectedSetID ) then
				page = GetPage(i, self.PAGE_SIZE);
				break;
			end
		end
	end
	self.PagingFrame:SetCurrentPage(page);
	self:UpdateSets();
end

Mixin(WardrobeCollectionFrame.SetsTransmogFrame,BetterWardrobeSetsTransmogMixin)

local function InitFrames(frame, button, name, height)
		local frame = CreateFrame("Frame", nil, frame[button] )
        frame:SetHeight(height)
        frame:SetWidth(120)
        frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightMedium")
        frame.text:SetWidth(frame:GetWidth())
        frame.text:SetHeight(frame:GetHeight())
        frame.text:SetPoint("TOP", frame, "TOP", 0, 0)        
        frame.text:SetSize(frame:GetWidth(), frame:GetHeight())
        frame.text:SetJustifyV("CENTER")
        frame.text:SetJustifyH("CENTER")
        frame.text:SetText("--")
		return frame
end

local buttons = {"ModelR1C1","ModelR1C2","ModelR1C3","ModelR1C4","ModelR2C1","ModelR2C2","ModelR2C3","ModelR2C4"}

function addon.AddSetDetailFrames(frame)
	local frame1, frame2
	for i, button in ipairs(buttons) do

		frame1 = InitFrames(frame, button,"progress", 20)
        frame1:SetPoint("TOP", frame[button], "TOP", 0, 0)  
		frame[button].progress = frame1.text

		frame2 = InitFrames(frame, button,"setName", 90)
        frame2:SetPoint("BOTTOM", frame[button], "BOTTOM", 0, 0)  
		frame[button].setName = frame2.text
    end
end