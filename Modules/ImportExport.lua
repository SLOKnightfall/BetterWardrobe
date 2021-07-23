local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local Profile
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local LISTWINDOW
local AceGUI = LibStub("AceGUI-3.0")


local IE ={}

local function Export(itemString, button)
	if LISTWINDOW then LISTWINDOW:Hide() end

	for _, listPopup in pairs(BetterWardrobeOutfitFrameMixin.popups) do
		StaticPopup_Hide(listPopup)
	end

	local f = AceGUI:Create("Window")
	
	--f:SetBackdrop(	BACKDROP_DIALOG_32_32 )
	f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
	f:SetTitle("Wardrobe Export")
	f:SetLayout("Fill")
	--f:SetAutoAdjustHeight(true)
	f:EnableResize(false)
	_G["BetterWardrobeExportWindow"] = f.frame
	--Mixin(f.frame, BackdropTemplateMixin )
	--f.UISpecialFrames:SetBackdrop(	BACKDROP_DIALOG_32_32 )
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
			table.insert(tbl, link)
		end
		BW_DressingRoomHideArmorButton_OnClick()
		for i, link in ipairs(tbl) do
			DressUpLink(link)
		end
	end
end


local importFrom = nil
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
		if importFrom == "Transmog" then 
			IE.ImportTransmogVendorSet(self.editBox:GetText())
		else
			ImportSet(self.editBox:GetText());
		end
		importFrom = nil
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


local function ImportItemTransMogVendor(importString)
	local transmogSources = {}
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
		local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(link)
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
		if sourceInfo then
			local slot = C_Transmog.GetSlotForInventoryType(sourceInfo.invType);
			transmogSources[slot] = sourceID
			C_Transmog.LoadSources(transmogSources, -1, -1);
		end
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
		if importFrom == "Transmog" then 
			ImportItemTransMogVendor(self.editBox:GetText())
		else
			ImportItem(self.editBox:GetText());
		end
		importFrom = nil
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


local function ExportTransmogVendorSet()
	local str;
	for key, transmogSlot in pairs(TRANSMOG_SLOTS) do
		if ( transmogSlot.location:IsAppearance() ) then
			
			----local sourceID = WardrobeOutfitDropDown:GetSlotSourceID(transmogSlot.location)
			local _, _, sourceID = TransmogUtil.GetInfoForEquippedSlot(transmogSlot.location);
			if ( sourceID ) then
				local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
				if sourceInfo then 
					local id = sourceInfo.itemID
					local bonus = sourceInfo.itemModID
					str = (str and str..":" or "compare?items=")..id..(bonus and ".0.0.0.0.0.0.0.0.0."..bonus or "")
				end
			end
		end
	end
	Export(str,false)
end


--compare?items=57290.0.0.0.0.0.0.0.0.0.0:163458.0.0.0.0.0.0.0.0.0.1:37513.0.0.0.0.0.0.0.0.0.0:173460.0.0.0.0.0.0.0.0.0.0:98093.0.0.0.0.0.0.0.0.0.0:38115.0.0.0.0.0.0.0.0.0.0:152399.0.0.0.0.0.0.0.0.0.0:80698.0.0.0.0.0.0.0.0.0.0:167829.0.0.0.0.0.0.0.0.0.0:98149.0.0.0.0.0.0.0.0.0.0:35870.0.0.0.0.0.0.0.0.0.0:62968.0.0.0.0.0.0.0.0.0.0:155409.0.0.0.0.0.0.0.0.0.0

function IE.ImportTransmogVendorSet(importString)
	importString = importString and importString:match("items=([^#]+)")
	if importString then
		local transmogSources = {};
		for item in importString:gmatch("([^:;]+)") do
			local itemID, bonusMod = item:match("^(%d+)%.%d+%.%d+%.%d+%.%d+%.%d+%.%d+%.%d+%.%d+%.%d+%.(%d+)")
			itemID = itemID or item:match("^(%d+)");
			local link = ToStringItem(tonumber(itemID), tonumber(bonusMod))
			local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(link)
			if sourceID then 
			local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
				if sourceInfo then
					local slot = C_Transmog.GetSlotForInventoryType(sourceInfo.invType);
					local pendingInfo = TransmogUtil.CreateTransmogPendingInfo(Enum.TransmogPendingType.Apply, appearanceID);
					local transmogLocation = TransmogUtil.CreateTransmogLocation(slot, Enum.TransmogType.Appearance, Enum.TransmogModification.Main);
					C_Transmog.SetPending(transmogLocation, pendingInfo);
				end

			end
		end
	end
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


function addon:CreateChatLinkTransmogVendor()
	local string = [[/run local function f(i,b)DressUpItemLink("item:"..i.."::::::::::::9:"..b);end;]]
	for key, transmogSlot in pairs(TRANSMOG_SLOTS) do
		if ( transmogSlot.location:IsAppearance() ) then
			local _, _, sourceID = TransmogUtil.GetInfoForEquippedSlot(transmogSlot.location)
			----local sourceID = WardrobeOutfitDropDown:GetSlotSourceID(transmogSlot.location)
			if ( sourceID ) then
				local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
				if sourceInfo then 
					local id = sourceInfo.itemID
					local bonus = sourceInfo.itemModID  or 0
					string = string..linkText:format(id,bonus)
				end
			end
		end
	end
	Export(string,false)
end


function BW_TransmogVendorExportButton_OnClick(self)
	local Profile = addon.Profile
	local name  = addon.QueueList[3]
	local contextMenuData = {
		{
			text = L["Import/Export Options"], isTitle = true, notCheckable = true,
		},
		{
			text = L["Load Set: %s"]:format( name or L["None Selected"]),
			func = function()
				local setType = addon.QueueList[1]
				local setID = addon.QueueList[2]
				if setType == "set" then
					BetterWardrobeCollectionFrame.SetsTransmogFrame:LoadSet(setID)
				elseif setType == "extraset" then
					BetterWardrobeCollectionFrame.SetsTransmogFrame:LoadSet(setID)
				end
			end,
			isNotRadio = true,
			notCheckable = true,
		},
		{
			text = L["Import Item"],
			func = function()
				importFrom = "Transmog"
				BetterWardrobeOutfitFrameMixin:ShowPopup("BETTER_WARDROBE_IMPORT_ITEM_POPUP")
			end,
			isNotRadio = true,
			notCheckable = true,
		},
		{
			text = L["Import Set"],
			func = function()
				importFrom = "Transmog"
				BetterWardrobeOutfitFrameMixin:ShowPopup("BETTER_WARDROBE_IMPORT_SET_POPUP")
			end,
			isNotRadio = true,
			notCheckable = true,
		},
		{
			text = L["Export Set"],
			func = function()
				ExportTransmogVendorSet()
			end,
			notCheckable = true,
			isNotRadio = true,
		},
				{
			text = L["Create Dressing Room Command Link"],
			func = function()
				addon:CreateChatLinkTransmogVendor()
			end,
			notCheckable = true,
			isNotRadio = true,
		},
	}
	
	BW_UIDropDownMenu_SetAnchor(addon.ContextMenu, 0, 0, "TOPLEFT", self, "TOPLEFT")
	BW_EasyMenu(contextMenuData, addon.ContextMenu, addon.ContextMenu, 0, 0, "MENU")
	
	--DropDownList1:ClearAllPoints()
	--DropDownList1:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
	--DropDownList1:SetClampedToScreen(true)
end


--/run local function f(i,b)DressUpItemLink("item:"..i.."::::::::::::9:"..b);end;f(27457,0);f(27489,0);f(27539,0);f(27548,0);f(27748,0);f(27790,0);f(27897,0);f(28221,0);