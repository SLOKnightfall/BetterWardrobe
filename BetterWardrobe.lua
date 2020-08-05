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
addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
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
end


function addon:OnEnable()
end


--local module = mog:GetModule("MogIt_Wardrobe") or mog:RegisterModule("MogIt_Wardrobe",{});
local sets = {
	Cloth = {},
	Leather = {},
	Mail = {},
	Plate = {},
};

local armor = {
	"Cloth",
	"Leather",
	"Mail",
	"Plate",
};

local list = {};
local data = {
	name = {},
	items = {},
	class = {},
	faction = {},
};

local function AddData(id,name,items,class,faction)
	data.name[id] = name;
	data.items[id] = items;
	data.class[id] = class;
	data.faction[id] = faction;
end

local function GetData(id)
	return data.name[id],data.items[id],data.class[id],data.faction[id]
end

function addon.AddCloth(id,...)
	tinsert(sets.Cloth,id);
	AddData(id,...);
end

function addon.AddLeather(id,...)
	tinsert(sets.Leather,id);
	AddData(id,...);
end

function addon.AddMail(id,...)
	tinsert(sets.Mail,id);
	AddData(id,...);
end

function addon.AddPlate(id,...)
	tinsert(sets.Plate,id);
	AddData(id,...);
end


function addon.AddSet(id, table)
local name, items, class, faction = GetData(id)
local newSet = {["name"] = name,
	["collected"] = true,
	["faction"] = faction,
	["items"] = items
}

tinsert(table, newSet)
end


local SetsDataProvider = CreateFromMixins(WardrobeSetsDataProviderMixin);
local BASE_SET_BUTTON_HEIGHT = 46;
local VARIANT_SET_BUTTON_HEIGHT = 20;
local SET_PROGRESS_BAR_MAX_WIDTH = 204;
local IN_PROGRESS_FONT_COLOR = CreateColor(0.251, 0.753, 0.251);
local IN_PROGRESS_FONT_COLOR_CODE = "|cff40c040";

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
			model.Favorite.Icon:SetShown(set.favorite);
			model.setID = set.setID
			model.setName:SetText(setInfo["name"].."\n"..(setInfo["description"] or ""))
			model.progress:SetText(topSourcesCollected.."/".. topSourcesTotal)
			
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

local function InitFrames(button, name, height)
		local frame = CreateFrame("Frame", nil, WardrobeCollectionFrame.SetsTransmogFrame[button] )
        frame:SetHeight(height)
        frame:SetWidth(120)
        frame.text = frame:CreateFontString(button..name, "OVERLAY", "GameFontHighlightMedium")
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

function addon.AddSetDetailFrames()
	local frame1, frame2
	for i, button in ipairs(buttons) do

		frame1 = InitFrames(button,"progress", 20)
        frame1:SetPoint("TOP", WardrobeCollectionFrame.SetsTransmogFrame[button], "TOP", 0, 0)  
		WardrobeCollectionFrame.SetsTransmogFrame[button].progress = frame1.text

		frame2 = InitFrames(button,"setName", 90)
        frame2:SetPoint("BOTTOM", WardrobeCollectionFrame.SetsTransmogFrame[button], "BOTTOM", 0, 0)  
		WardrobeCollectionFrame.SetsTransmogFrame[button].setName = frame2.text
    end

end
