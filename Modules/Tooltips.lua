local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local Profile

local IsDressableItem = IsDressableItem;
local GetScreenWidth = GetScreenWidth;
local GetScreenHeight = GetScreenHeight;

local class = L.classBits[select(2, UnitClass("PLAYER"))];

function dinit()
	Profile = addon.Profile
addon.tooltip.model:SetUnit("player");
  	--mog.tooltip:SetSize(mog.db.profile.tooltipWidth, mog.db.profile.tooltipHeight);
  addon.tooltip.rotate:SetShown(Profile.TooltipPreviewRotate) --mog.db.profile.tooltipRotate);
end

addon.tooltip = CreateFrame("Frame", "MogItTooltip", UIParent, "TooltipBorderedFrameTemplate");
addon.tooltip:Hide();
addon.tooltip:SetClampedToScreen(true);
addon.tooltip:SetFrameStrata("TOOLTIP");
addon.tooltip:SetSize(300,300)

addon.tooltip:SetScript("OnShow", function(self)
	if TooltipPreview_MouseRotate and not InCombatLockdown() then
		SetOverrideBinding(addon.tooltip, true, "MOUSEWHEELUP", "MogIt_TooltipScrollUp");
		SetOverrideBinding(addon.tooltip, true, "MOUSEWHEELDOWN", "MogIt_TooltipScrollDown");
	end
end);

addon.tooltip:SetScript("OnHide",function(self)
	if not InCombatLockdown() then
		ClearOverrideBindings(addon.tooltip);
	end
end);

addon.tooltip:SetScript("OnEvent", function(self, event, arg1)
	if event == "PLAYER_LOGIN" then
		addon.tooltip.model:SetUnit("player");
	elseif event == "PLAYER_REGEN_DISABLED" then
		ClearOverrideBindings(addon.tooltip);
	elseif event == "PLAYER_REGEN_ENABLED" then
		if self:IsForbidden() then return end
		if self:IsShown() and Profile.TooltipPreview_MouseRotate then
			SetOverrideBinding(addon.tooltip, true, "MOUSEWHEELUP", "MogIt_TooltipScrollUp");
			SetOverrideBinding(addon.tooltip, true, "MOUSEWHEELDOWN", "MogIt_TooltipScrollDown");
		end
	end
end);

addon.tooltip:RegisterEvent("PLAYER_LOGIN");
addon.tooltip:RegisterEvent("PLAYER_REGEN_DISABLED");
addon.tooltip:RegisterEvent("PLAYER_REGEN_ENABLED");

addon.tooltip.model = CreateFrame("DressUpModel", nil, addon.tooltip);
addon.tooltip.model:SetPoint("TOPLEFT", addon.tooltip, "TOPLEFT", 5, -5);
addon.tooltip.model:SetPoint("BOTTOMRIGHT", addon.tooltip, "BOTTOMRIGHT", -5, 5);
addon.tooltip.model:SetAnimation(0, 0);
addon.tooltip.model:SetLight(true, false, 0, 0.8, -1, 1, 1, 1, 1, 0.3, 1, 1, 1);





function addon.tooltip.model:ResetModel()
	local db = Profile
	local raceID = Profile.TooltipPreview_CustomRace
	local genderID = Profile.TooltipPreview_CustomGender
	if Profile.TooltipPreview_CustomModel then
		print("cus")
	--self:SetCustomRace(Profile.TooltipPreview_CustomRace, Profile.TooltipPreview_CustomGender);
		--self:RefreshCamera();

		local _, _, dirX, dirY, dirZ, _, ambR, ambG, ambB, _, dirR, dirG, dirB = self:GetLight();
						self:SetBarberShopAlternateForm();
				
						self:SetCustomRace(Profile.TooltipPreview_CustomRace, Profile.TooltipPreview_CustomGender);
			
	else
		self:Dress();
	end
	if not Profile.DressTooltipPreview then
		-- the worst of hacks to prevent certain armor model pieces from getting stuck on the character
		for i, slotName in ipairs(addon.slots) do
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



		--[[if Profile.TooltipPreview_CustomModel then
					--	self:SetCustomRace(Profile.TooltipPreview_CustomRace, Profile.TooltipPreview_CustomGender);
				
						local _, _, dirX, dirY, dirZ, _, ambR, ambG, ambB, _, dirR, dirG, dirB = self:GetLight();
						self:SetBarberShopAlternateForm();
				
						self:SetCustomRace(Profile.TooltipPreview_CustomRace, Profile.TooltipPreview_CustomGender);
				--self:Undress();
				
							C_Timer.After(0, function()
							--CustomModelPosition(self, raceID, genderID);
							C_Timer.After(0, function()
								self:SetLight(true, false, dirX, dirY, dirZ, 1, ambR, ambG, ambB, 1, dirR, dirG, dirB);
							end)	
						end)
							self:RefreshCamera()]];




end
addon.tooltip.model:SetScript("OnShow", addon.tooltip.model.ResetModel);


local function addDoubleLine(tooltip, left_text, right_text)
	tooltip:AddDoubleLine(left_text, right_text, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
end


local function addLine(tooltip, text)
	tooltip:AddLine(text, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, true)
end


function addon.tooltip:ShowTooltip(itemLink)
--[[	for i = 1, GameTooltip:NumLines() do
		local line = _G["GameTooltipTextLeft"..i]
		if line:GetText() == TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN then
			line:SetTextColor(136 / 255, 1, 170 / 255)
		end
	end]]
	
	if not itemLink or not Profile.ShowTooltips then return end
	local itemID, _, _, slot = GetItemInfoInstant(itemLink);
	if not itemID then return end
	local self = GameTooltip;
	
	local db = addon.db.profile;
	local tooltip = addon.tooltip;
	if Profile.ShowTooltipPreview and (not tooltip.mod[db.tooltipMod] or tooltip.mod[db.tooltipMod]()) then
		if not self[addon] then
			if tooltip.item ~= itemLink then
				tooltip.item = itemLink;

				local slot = select(4, GetItemInfoInstant(itemLink));
				--if (not db.tooltipMog or select(3, C_Transmog.GetItemInfo(itemID))) and tooltip.slots[slot] and IsDressableItem(itemLink) then

				if Profile.ShowTooltipPreview and IsDressableItem(itemLink) then
					tooltip.model:SetFacing(tooltip.slots[slot]-(Profile.TooltipPreviewRotate and 0.5 or 0));
					tooltip:Show();
					tooltip.owner = self;
					tooltip.repos:Show();
					tooltip.model:ResetModel();
					tooltip.model:TryOn(itemLink);
				else
					tooltip:Hide();
				end
			end
		else
			-- tooltip:Hide();
		end
	end
	

	
	-- add wishlist info about this item
	if not GameTooltip[addon] then
		local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemLink)
		if not sourceID then return end
		local addHeader = false

		if Profile.ShowCollectionListTooltips and addon.chardb.profile.collectionList["item"][appearanceID] then
			if not addHeader then 
				addHeader = true
				addLine(self, L["HEADERTEXT"])
			end

			addDoubleLine (self,"|cff87aaff"..L["-Appearance in Collection List-"], " ")
			self:Show()
		end
	local setIDs = C_TransmogSets.GetSetsContainingSourceID(sourceID)
	if Profile.ShowSetTooltips and #setIDs > 0 then 
		if not addHeader then 
			addHeader = true
			addLine(self, L["HEADERTEXT"])
		end

		for i, setID in pairs(setIDs) do 
			local setInfo = C_TransmogSets.GetSetInfo(setID)
			--addLine(tooltip, '--------')
			addDoubleLine (self,"|cffffd100"..L["Part of Set:"], " ")
			local collected, total = addon.SetsDataProvider:GetSetSourceCounts(setID)
			local color = YELLOW_FONT_COLOR_CODE
			if collected == total then 
				color = GREEN_FONT_COLOR_CODE
			end

			addDoubleLine (self," ",L["-%s %s(%d/%d)"]:format(setInfo.name or "", color, collected, total))
		end
		self:Show()
	end

	local setData = addon.IsSetItem(itemLink)
	if Profile.ShowExtraSetsTooltips and setData then 
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
		end
		self:Show()
	end

	if addHeader then 
		addLine(self, L["HEADERTEXT"])
		self:Show()
	end

	end
end

function addon.tooltip.HideItem(self)
	addon.tooltip.owner = nil;
	addon.tooltip.repos:Hide();
	addon.tooltip.check:Show();
end

addon.tooltip.check = CreateFrame("Frame");
addon.tooltip.check:Hide();
addon.tooltip.check:SetScript("OnUpdate", function(self)
	if (addon.tooltip.owner and addon.tooltip.owner:IsForbidden()) then return end
	if (addon.tooltip.owner and not (addon.tooltip.owner:IsShown() and addon.tooltip.owner:GetItem())) or not addon.tooltip.owner then
		addon.tooltip:Hide();
		addon.tooltip.item = nil;
	end
	self:Hide();
end);

addon.tooltip.repos = CreateFrame("Frame");
addon.tooltip.repos:Hide();
addon.tooltip.repos:SetScript("OnUpdate", function(self)
	local x,y = addon.tooltip.owner:GetCenter();
	if x and y then
		addon.tooltip:ClearAllPoints();
		local mogpoint, ownerpoint;
		if Profile.TooltipPreview_Anchor == "vertical" then
			if y / GetScreenHeight() > 0.5 then
				mogpoint = "TOP";
				ownerpoint = "BOTTOM";
			else
				mogpoint = "BOTTOM";
				ownerpoint = "TOP";
			end
			if x / GetScreenWidth() > 0.5 then
				mogpoint = mogpoint.."LEFT";
				ownerpoint = ownerpoint.."LEFT";
			else
				mogpoint = mogpoint.."RIGHT";
				ownerpoint = ownerpoint.."RIGHT";
			end
		else
			if x / GetScreenWidth() > 0.5 then
				mogpoint = "RIGHT";
				ownerpoint = "LEFT";
			else
				mogpoint = "LEFT";
				ownerpoint = "RIGHT";
			end
			if y / GetScreenHeight() > 0.5 then
				mogpoint = "TOP"..mogpoint;
				ownerpoint = "TOP"..ownerpoint;
			else
				mogpoint = "BOTTOM"..mogpoint;
				ownerpoint = "BOTTOM"..ownerpoint;
			end
		end
		addon.tooltip:SetPoint(mogpoint, addon.tooltip.owner, ownerpoint);
		self:Hide();
	end
end);

addon.tooltip.rotate = CreateFrame("Frame",nil,addon.tooltip);
addon.tooltip.rotate:Hide();
addon.tooltip.rotate:SetScript("OnUpdate",function(self,elapsed)
	addon.tooltip.model:SetFacing(addon.tooltip.model:GetFacing() + elapsed);
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
--//




addon.slots = {
	"HeadSlot",
	"ShoulderSlot",
	"BackSlot",
	"ChestSlot",
	"ShirtSlot",
	"TabardSlot",
	"WristSlot",
	"HandsSlot",
	"WaistSlot",
	"LegsSlot",
	"FeetSlot",
	"MainHandSlot",
	"SecondaryHandSlot",
};


--// Tables
addon.tooltip.slots = {
	INVTYPE_HEAD = 0,
	INVTYPE_SHOULDER = 0,
	INVTYPE_CLOAK = 3.4,
	INVTYPE_CHEST = 0,
	INVTYPE_BODY = 0,
	INVTYPE_ROBE = 0,
	INVTYPE_SHIRT = 0,
	INVTYPE_TABARD = 0,
	INVTYPE_WRIST = 0,
	INVTYPE_2HWEAPON = 1.6,
	INVTYPE_WEAPON = 1.6,
	INVTYPE_WEAPONMAINHAND = 1.6,
	INVTYPE_WEAPONOFFHAND = -0.7,
	INVTYPE_SHIELD = -0.7,
	INVTYPE_HOLDABLE = -0.7,
	INVTYPE_RANGED = 1.6,
	INVTYPE_RANGEDRIGHT = 1.6,
	INVTYPE_THROWN = 1.6,
	INVTYPE_HAND = 0,
	INVTYPE_WAIST = 0,
	INVTYPE_LEGS = 0,
	INVTYPE_FEET = 0,
};

addon.tooltip.mod = {
	Shift = IsShiftKeyDown,
	Ctrl = IsControlKeyDown,
	Alt = IsAltKeyDown,
};
--//
