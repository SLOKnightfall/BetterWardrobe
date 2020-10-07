local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local Profile
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local LISTWINDOW
local AceGUI = LibStub("AceGUI-3.0")

function Export(itemString, button)
	if LISTWINDOW then LISTWINDOW:Hide() end

	for _, listPopup in pairs(BW_WardrobeOutfitFrameMixin.popups) do
		StaticPopup_Hide(listPopup)
	end

	local f = AceGUI:Create("Window")
	f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
	f:SetTitle("Wardrobe Export")
	f:SetLayout("Fill")
	--f:SetAutoAdjustHeight(true)
	f:EnableResize(false)
	_G["BetterWardrobeExportWindow"] = f.frame
	LISTWINDOW = f
	tinsert(UISpecialFrames, "BetterWardrobeExportWindow")

	local MultiLineEditBox = AceGUI:Create("MultiLineEditBox")
	MultiLineEditBox:SetFullHeight(true)
	MultiLineEditBox:SetFullWidth(true)
	MultiLineEditBox:SetLabel("")
	MultiLineEditBox:DisableButton(button)
	f:AddChild(MultiLineEditBox)

	MultiLineEditBox:SetText(itemString or "")
end

--local testString = "compare?items=16955:32570:137109:29337:42376:35221:37363:16952:13075:50632:27512:34675"
--local t2 = "compare?items=163307.0.0.0.0.0.0.0.0.0.5126:163453.0.0.0.0.0.0.0.0.0.5126:163455.0.0.0.0.0.0.0.0.0.5126:163456.0.0.0.0.0.0.0.0.0.5126:163458.0.0.0.0.0.0.0.0.0.5126:163459.0.0.0.0.0.0.0.0.0.5126:163460.0.0.0.0.0.0.0.0.0.5126:163461.0.0.0.0.0.0.0.0.0.5126"

--compare?items=16955:32570:137109:29337:42376:35221:37363:16952:13075:50632:27512:34675
local itemStringShort = "item:%d:0";
local itemStringLong = "item:%d:0::::::::::%d:1:%d";

local function ToStringItem(id, bonus, diff)
	-- itemID, enchantID, instanceDifficulty, numBonusIDs, bonusID1
	if (bonus and bonus ~= 0) or (diff and diff ~= 0) then
		return format(itemStringLong, id, diff or 0, bonus or 0);
	else
		return format(itemStringShort, id);
	end
end


local function ImportSet(importString)
	importString = importString and importString:match("items=([^#]+)")
	if importString then
		local tbl = {};
		for item in importString:gmatch("([^:;]+)") do
			local itemID, bonusMod = item:match("^(%d+)%.%d+%.%d+%.%d+%.%d+%.%d+%.%d+%.%d+%.%d+%.%d+%.(%d+)")
			itemID = itemID or item:match("^(%d+)");
			local link = ToStringItem(tonumber(itemID), tonumber(bonusMod))
			local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(link)
			table.insert(tbl, sourceID)
		end
		BW_DressingRoomHideArmorButton_OnClick()
		DressUpSources(tbl)
	end
end


StaticPopupDialogs["BETTER_WARDROBE_IMPORT_SET_POPUP"] = {
	text = L["Copy and paste a Wowhead Compare URL into the text box below to import"],
	preferredIndex = 3,
	button1 = L["Import"],
	button2 = CANCEL,
	hasEditBox = true,
	maxLetters = 512,
	editBoxWidth = 260,
	OnShow = function(self)
		if LISTWINDOW then LISTWINDOW:Hide() end
		self.editBox:SetText("")
	end,
	EditBoxOnEnterPressed = function(self)
		if (self:GetParent().button1:IsEnabled()) then
			StaticPopup_OnClick(self:GetParent(), 1)
		end
	end,
	OnAccept = function(self)
		ImportSet(self.editBox:GetText());
	end,
	EditBoxOnEscapePressed = HideParentPanel,
	exclusive = true,
	whileDead = true,
};


--https://www.wowhead.com/item=163307/honorbound-centurions-vambraces?bonus=5126:1562#see-also
local WowheadURL = "www.wowhead.com/item=(%d+).-bonus=(%d+):%d*"
local itemStringPattern_Long = "item:(%d+):%d*:%d*:%d*:%d*:%d*:%d*:%d*:%d*:%d*:%d*:(%d*):%d*:([%d:]+)"
local itemStringPattern_Short = ":(%d+)"
local function ToNumberItem(item)
	if type(item) == "string" then
		local id, diff, bonus = item:match(itemStringPattern_Long) --or item:match(itemStringPattern_Short);
		-- bonus ID can also be warforged, socketed, etc
		-- if there is more than one bonus ID, need to check all
		if bonus then
			if not tonumber(bonus) then
				for bonusID in gmatch(bonus, "%d+") do
					if bonusID then
						bonus = tonumber(bonusID)
						break;
					end
				end
			elseif not bonusDiffs[tonumber(bonus)] then
				bonus = nil;
			end
		end

		id = id or item:match("item:(%d+)");
		return tonumber(id), tonumber(bonus), tonumber(diff);
	elseif type(item) == "number" then
		return item;
	end
end


local function ImportItem(importString)
	local text = importString
	if text then
		local itemID = ToNumberItem(text);
		if not id then
			itemID,bonusMod = text:match("item=(%d+)"),text:match("bonus=(%d+)");
		end
		if not itemID then
			itemID = text:match("(%d+).-$");
			bonusMod = nil;
		end
		local link = ToStringItem(tonumber(itemID), tonumber(bonusMod))
		DressUpLink(link)
	end
end


StaticPopupDialogs["BETTER_WARDROBE_IMPORT_ITEM_POPUP"] = {
	text = L["Type the item ID or url in the text box below"],
	preferredIndex = 3,
	button1 = ADD,
	button2 = CANCEL,
	hasEditBox = true,
	maxLetters = 512,
	editBoxWidth = 260,
	OnShow = function() if LISTWINDOW then LISTWINDOW:Hide() end end,
	OnAccept = function(self)
		ImportItem(self.editBox:GetText());
	end,
	EditBoxOnEnterPressed = function(self)
		if (self:GetParent().button1:IsEnabled()) then
			StaticPopup_OnClick(self:GetParent(), 1)
		end
	end,
	EditBoxOnEscapePressed = HideParentPanel;
	exclusive = true,
	whileDead = true,
};



function addon:ExportSet()
	local str;
	local Buttons = BW_DressingRoomFrame.PreviewButtonFrame.Slots
	for index, button in pairs(Buttons) do
		local itemlink = nil
		local slot = button:GetID()
		
		--if not DressingRoom:IsSlotHidden(slot) then
			itemlink = button.itemLink --GetInventoryItemLink("player", slot)
			if itemlink then
				local id,bonus = ToNumberItem(itemlink)
				str = (str and str..":" or "compare?items=")..id..(bonus and ".0.0.0.0.0.0.0.0.0."..bonus or "")
			end
		--end
	end
	Export(str,false)
	--return str
end

local linkText = "f(%d,%d);"
function addon:CreateChatLink()
	local string = [[/run local function f(i,b)DressUpItemLink("item:"..i.."::::::::::::9:"..b);end;]]
	local Buttons = BW_DressingRoomFrame.PreviewButtonFrame.Slots
	for index, button in pairs(Buttons) do
		local itemlink = nil
		local slot = button:GetID()
		
		--if not DressingRoom:IsSlotHidden(slot) then
			itemlink = button.itemLink --GetInventoryItemLink("player", slot)
			if itemlink then
				local id,bonus = ToNumberItem(itemlink)
				string = string..linkText:format(id,bonus or 0)
			end
		--end
	end
	Export(string,false)
end
--/run local function f(i,b)DressUpItemLink("item:"..i.."::::::::::::9:"..b);end;f(27457,0);f(27489,0);f(27539,0);f(27548,0);f(27748,0);f(27790,0);f(27897,0);f(28221,0);