local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local IsDressableItem = IsDressableItem;
local GetScreenWidth = GetScreenWidth;
local GetScreenHeight = GetScreenHeight;

local class = L.classBits[select(2, UnitClass("PLAYER"))];

function addon.Init:BuildTooltips()
	addon.tooltip.model:SetUnit("player");
	addon.tooltip.rotate:SetShown(addon.Profile.TooltipPreviewRotate)
	addon.tooltip:SetSize(addon.Profile.TooltipPreview_Width, addon.Profile.TooltipPreview_Height)
	C_TransmogCollection.SetShowMissingSourceInItemTooltips(addon.Profile.ShowAdditionalSourceTooltips);

	addon.tooltip:SetScript("OnShow", function(self)
		if addon.Profile.TooltipPreview_MouseRotate and not InCombatLockdown() then
			SetOverrideBinding(addon.tooltip, true, "MOUSEWHEELUP", "BetterWardrobe_TooltipScrollUp");
			SetOverrideBinding(addon.tooltip, true, "MOUSEWHEELDOWN", "BetterWardrobe_TooltipScrollDown");
		end
	end);

	addon.tooltip:SetScript("OnHide",function(self)
		if not InCombatLockdown() then
			ClearOverrideBindings(addon.tooltip);
		end
	end);

	addon.tooltip:SetScript("OnEvent", function(self, event, arg1)
		if event == "PLAYER_REGEN_DISABLED" then
			ClearOverrideBindings(addon.tooltip);
		elseif event == "PLAYER_REGEN_ENABLED" then
			if self:IsForbidden() then return end
			if self:IsShown() and addon.Profile.TooltipPreview_MouseRotate then
				SetOverrideBinding(addon.tooltip, true, "MOUSEWHEELUP", "BetterWardrobe_TooltipScrollUp");
				SetOverrideBinding(addon.tooltip, true, "MOUSEWHEELDOWN", "BetterWardrobe_TooltipScrollDown");
			end
		end
	end);

	addon.tooltip:RegisterEvent("PLAYER_REGEN_DISABLED");
	addon.tooltip:RegisterEvent("PLAYER_REGEN_ENABLED");

	addon.tooltip.model:SetUnit("player");
	addon.tooltip.model:SetScript("OnShow", addon.tooltip.model.ResetModel);

	addon.tooltip.check:SetScript("OnUpdate", function(self)
		if (addon.tooltip.owner and addon.tooltip.owner:IsForbidden()) then return end
		if (addon.tooltip.owner and not (addon.tooltip.owner:IsShown() and addon.tooltip.owner:GetItem())) or not addon.tooltip.owner then
			addon.tooltip:Hide();
			addon.tooltip.item = nil;
		end
		self:Hide();
	end);

	GameTooltip:HookScript("OnTooltipSetItem", function(self)
		local _, itemLink = self:GetItem();
		addon.tooltip:ShowTooltip(itemLink);
	end);
	GameTooltip:HookScript("OnHide", addon.tooltip.HideItem);


	-- hacks for tooltips where GameTooltip:GetItem() returns a broken link
	hooksecurefunc(GameTooltip, "SetQuestItem", function(self, itemType, index)
		addon.tooltip:ShowTooltip(GetQuestItemLink(itemType, index));
		GameTooltip:Show();
	end);


	hooksecurefunc(GameTooltip, "SetQuestLogItem", function(self, itemType, index)
		addon.tooltip:ShowTooltip(GetQuestLogItemLink(itemType, index));
		GameTooltip:Show();
	end);


	-- hooksecurefunc(GameTooltip, "SetRecipeResultItem", function(self, recipeID)
		-- addon.tooltip:ShowTooltip(C_TradeSkillUI.GetRecipeItemLink(recipeID));
		-- GameTooltip:Show();
	-- end);


	hooksecurefunc(GameTooltip, "SetRecipeReagentItem", function(self, recipeID, reagentIndex)
		addon.tooltip:ShowTooltip(C_TradeSkillUI.GetRecipeReagentItemLink(recipeID, reagentIndex));
		GameTooltip:Show();
	end);
end

addon.tooltip = CreateFrame("Frame", "BW_ProfileTooltip", UIParent, "TooltipBorderedFrameTemplate");
addon.tooltip:Hide();
addon.tooltip:SetClampedToScreen(true);
addon.tooltip:SetFrameStrata("TOOLTIP");

addon.tooltip.model = CreateFrame("DressUpModel", nil, addon.tooltip);
--Mixin(addon.tooltip.model, WardrobeSetsDetailsModelMixin)
addon.tooltip.model:SetPoint("TOPLEFT", addon.tooltip, "TOPLEFT", 5, -5);
addon.tooltip.model:SetPoint("BOTTOMRIGHT", addon.tooltip, "BOTTOMRIGHT", -5, 5);
addon.tooltip.model:SetAnimation(0, 0);
addon.tooltip.model:SetLight(true, false, 0, 0.8, -1, 1, 1, 1, 1, 0.3, 1, 1, 1);

function addon.tooltip.model:ResetModel()
	local raceID = addon.Profile.TooltipPreview_CustomRace
	local genderID = addon.Profile.TooltipPreview_CustomGender
	--if addon.Profile.TooltipPreview_CustomModel then
		--local _, _, dirX, dirY, dirZ, _, ambR, ambG, ambB, _, dirR, dirG, dirB = self:GetLight();
		--print(addon.Profile.TooltipPreview_CustomRace)
		--self:SetCustomRace("Human", Enum.Unitsex.Female);
		--local race = "Human"
		--local sex = UnitSex("player");
		--self.panAndZoomModelType = race..sex;
		--self:SetUseTransmogSkin(true)
	--else
		self:Dress();
		self:SetUseTransmogSkin(addon.Profile.TooltipPreview_DressingDummy)
	--end

	if not addon.Profile.TooltipPreview_Dress then
		for i, slotName in ipairs(addon.Globals.slots) do
			local slot = GetInventorySlotInfo(slotName);
			local item = GetInventoryItemLink("player", slot);
			if item then
				self:TryOn(item);
				self:UndressSlot(slot);
			end
		end
		self:UndressSlot(GetInventorySlotInfo("MainHandSlot"));
		self:UndressSlot(GetInventorySlotInfo("SecondaryHandSlot"));
	end
end

--159382
local function addDoubleLine(tooltip, left_text, right_text)
	tooltip:AddDoubleLine(left_text, right_text, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
end


local function addLine(tooltip, text)
	tooltip:AddLine(text, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, true)
end


local function HasItem(sourceID, includeAlternate)
	if not sourceID then return end
	local found = false;
	local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
	if not sourceInfo then return end
	found = sourceInfo.isCollected
	if includeAlternate then
		local _, _, _, _, _, itemClassID, itemSubclassID = GetItemInfoInstant(sourceInfo.itemID);
		local sources = C_TransmogCollection.GetAllAppearanceSources(sourceInfo.visualID)
		for i, sourceID in ipairs(sources) do
			local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
			local _, _, _, _, _, itemClassID2, itemSubclassID2 = GetItemInfoInstant(sourceInfo.itemID);
			if itemSubclassID2 == itemSubclassID and sourceInfo.isCollected then
				found = true
				break
			end
		end
	end
	return found
end

local itemSourceID = {}
local function GetSourceFromItem(item)
	if not itemSourceID[item] then
		local visualID, sourceID = C_TransmogCollection.GetItemInfo(item)
		itemSourceID[item] = sourceID
		if not itemSourceID[item] then
			addon.tooltip.model:SetUnit("player")
			addon.tooltip.model:Undress()
			addon.tooltip.model:TryOn(item)
			for i = 1, 19 do
				local source = addon.tooltip.model:GetSlotTransmogSources(i)
				if source ~= 0 then
					itemSourceID[item] = source
					break
				end
			end
		end
	end
	return itemSourceID[item]
end


function addon.tooltip:ShowTooltip(itemLink)
	addon.tooltip.owner = GameTooltip;
	if not itemLink or self.ShowTooltips then return end

	local itemID, _, _, slot = GetItemInfoInstant(itemLink);
	if not itemID then return end
	local self = GameTooltip;

	local learned_dupe = false
	for i = 1, GameTooltip:NumLines() do
		local line = _G["GameTooltipTextLeft"..i]

		local text = line:GetText() or " "
		local text_lower = string.lower(line:GetText() or " " )
		--Check to see if another addon added appearance known text
		if string.find(text_lower, string.lower(TRANSMOGRIFY_TOOLTIP_APPEARANCE_KNOWN)) or
			string.find(text_lower, "item id") then 
			learned_dupe = true
		end
		if addon.Profile.ShowOwnedItemTooltips and string.find(text_lower, string.lower(TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN)) then 
			line:SetText("|TInterface\\RaidFrame\\ReadyCheck-NotReady:0|t "..text)
		end
		--Adds icon to TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN if found
		if addon.Profile.ShowOwnedItemTooltips and string.find(text_lower, string.lower(TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN) ) then 
			line:SetText("|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t "..text)
		end

		if addon.Profile.ShowItemIDTooltips and string.find(text_lower, string.lower(ITEM_LEVEL) ) then 
			line:SetText(text.."         "..L["Item ID"]..": |cffffffff"..itemID)
		end
	end
	
	local itemID, _, _, slot = GetItemInfoInstant(itemLink);
	if not itemID then return end
	local self = GameTooltip;
	
	local tooltip = addon.tooltip;
	if addon.Profile.TooltipPreview_Show and (not addon.Globals.mods[addon.Profile.TooltipPreview_Modifier] or addon.Globals.mods[addon.Profile.TooltipPreview_Modifier]()) then
		if tooltip.item ~= itemLink then
			tooltip.item = itemLink;

			local slot = select(4, GetItemInfoInstant(itemLink));
			if (not addon.Profile.TooltipPreview_MogOnly or select(3, C_Transmog.GetItemInfo(itemID))) and addon.Globals.tooltip_slots[slot] and IsDressableItem(itemLink) then
				tooltip.model:SetFacing(addon.Globals.tooltip_slots[slot]-(addon.Profile.TooltipPreviewRotate and 0.5 or 0));
				tooltip:Show();
				tooltip.owner = self;
				tooltip.repos:Show();
				tooltip.model:ResetModel();
				tooltip.model:TryOn(itemLink);
			else
				tooltip:Hide();
			end
		end
	end

	if addon.Profile.ShowOwnedItemTooltips and addon.Globals.tooltip_slots[slot] and not learned_dupe then
		local sourceID = GetSourceFromItem(itemLink);
		local hasItem = sourceID and HasItem(sourceID, true);
		if hasItem then
			addLine(self, " ")
			addLine(self, "|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t "..TRANSMOGRIFY_TOOLTIP_APPEARANCE_KNOWN);
		end
	end

	if addon.Profile.ShowTooltips then 
		local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemLink)
		if not sourceID then return end
		local addHeader = false

		if addon.Profile.ShowCollectionListTooltips and addon.chardb.profile.collectionList["item"][appearanceID] then
			if not addHeader then 
				addHeader = true
				addLine(self, L["HEADERTEXT"])
			end

			addDoubleLine (self,"|cff87aaff"..L["-Appearance in Collection List-"], " ")
		end
		

		local setIDs = C_TransmogSets.GetSetsContainingSourceID(sourceID)
		if addon.Profile.ShowSetTooltips and #setIDs > 0 then 
			if not addHeader then 
				addHeader = true
				addLine(self, L["HEADERTEXT"])
			end

			for i, setID in pairs(setIDs) do 
				local setInfo = C_TransmogSets.GetSetInfo(setID)
				addDoubleLine (self,"|cffffd100"..L["Part of Set:"], " ")
				local collected, total = addon.SetsDataProvider:GetSetSourceCounts(setID)
				local color = YELLOW_FONT_COLOR_CODE
				if collected == total then 
					color = GREEN_FONT_COLOR_CODE
				end
				addDoubleLine (self," ",L["-%s %s(%d/%d)"]:format(setInfo.name or "", color, collected, total))

				if addon.Profile.ShowDetailedListTooltips then 
					local sources = C_TransmogSets.GetSetSources(setID)
					for sourceID, collected in pairs(sources) do
						local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
						if collected and not addon.Profile.ShowMissingDetailedListTooltips then 
							color = GREEN_FONT_COLOR_CODE
							addDoubleLine (self," ",L["|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t %s%s"]:format(color, sourceInfo.name or ""))
						elseif not collected then 
							color = RED_FONT_COLOR_CODE
							addDoubleLine (self," ",L["|TInterface\\RaidFrame\\ReadyCheck-NotReady:0|t %s%s"]:format(color, sourceInfo.name or ""))
						end
					end
				end
			end
		end

		local setData = addon.IsSetItem(itemLink)
		if addon.Profile.ShowExtraSetsTooltips and setData then 
			if not addHeader then 
				addHeader = true
				addLine(self, L["HEADERTEXT"])
			end

			addDoubleLine (self,"|cffffd100"..L["Part of Extra Set:"], " ")
			for _, data in pairs(setData) do
				local collected, total = addon.ExtraSetsDataProvider:GetSetSourceCounts(data.setID)
				local color = YELLOW_FONT_COLOR_CODE
				if collected == total then 
					color = GREEN_FONT_COLOR_CODE
				end

				addDoubleLine (self," ",L["-%s %s(%d/%d)"]:format(data.name or "", color, collected, total))

				if addon.Profile.ShowDetailedListTooltips then 
					local sources = addon.GetSetsources(data.setID)
					for sourceID, collected in pairs(sources) do
						local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
						if collected and not addon.Profile.ShowMissingDetailedListTooltips then 
							color = GREEN_FONT_COLOR_CODE
							addDoubleLine (self," ",L["|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t %s%s"]:format(color, sourceInfo.name or ""))
						elseif not collected then 
							color = RED_FONT_COLOR_CODE
							addDoubleLine (self," ",L["|TInterface\\RaidFrame\\ReadyCheck-NotReady:0|t %s%s"]:format(color, sourceInfo.name or ""))
						end
					end
				end
			end
		end

		if addHeader then 
			addLine(self, L["HEADERTEXT"])
		end
	end
self.ShowTooltips = true
	--/relself:Show()
end


function addon.tooltip.HideItem(self)
	addon.tooltip.owner = nil;
	addon.tooltip.repos:Hide();
	addon.tooltip.check:Show();
end


addon.tooltip.check = CreateFrame("Frame");
addon.tooltip.check:Hide();

addon.tooltip.repos = CreateFrame("Frame");
addon.tooltip.repos:Hide();
addon.tooltip.repos:SetScript("OnUpdate", function(self)
		if (not addon.tooltip.owner) then return end

	local x,y = addon.tooltip.owner:GetCenter();
	if x and y then
		addon.tooltip:ClearAllPoints();
		local anchorpoint, ownerpoint;
		if addon.Profile.TooltipPreview_Anchor == "vertical" then
			if y / GetScreenHeight() > 0.5 then
				anchorpoint = "TOP";
				ownerpoint = "BOTTOM";
			else
				anchorpoint = "BOTTOM";
				ownerpoint = "TOP";
			end
			if x / GetScreenWidth() > 0.5 then
				anchorpoint = anchorpoint.."LEFT";
				ownerpoint = ownerpoint.."LEFT";
			else
				anchorpoint = anchorpoint.."RIGHT";
				ownerpoint = ownerpoint.."RIGHT";
			end
		else
			if x / GetScreenWidth() > 0.5 then
				anchorpoint = "RIGHT";
				ownerpoint = "LEFT";
			else
				anchorpoint = "LEFT";
				ownerpoint = "RIGHT";
			end
			if y / GetScreenHeight() > 0.5 then
				anchorpoint = "TOP"..anchorpoint;
				ownerpoint = "TOP"..ownerpoint;
			else
				anchorpoint = "BOTTOM"..anchorpoint;
				ownerpoint = "BOTTOM"..ownerpoint;
			end
		end
		addon.tooltip:SetPoint(anchorpoint, addon.tooltip.owner, ownerpoint);
		self:Hide();
	end
end);

addon.tooltip.rotate = CreateFrame("Frame",nil,addon.tooltip);
addon.tooltip.rotate:Hide();
addon.tooltip.rotate:SetScript("OnUpdate",function(self,elapsed)
	addon.tooltip.model:SetFacing(addon.tooltip.model:GetFacing() + elapsed);
end);