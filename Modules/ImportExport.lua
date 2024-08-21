--TODO:  Rework broken import/export using new set links
local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local Profile
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local LISTWINDOW
local AceGUI = LibStub("AceGUI-3.0")
local itemLink = "item:%d:0";
local itemLinkMod = "item:%d:0:::::::::::1:%d";
local itemBonusPattern = "item:(%d+):%d*:%d*:%d*:%d*:%d*:%d*:%d*:%d*:%d*:%d*:(%d*):%d*:([%d:]+)"

local IE ={}

local function Export(itemString)
	if LISTWINDOW then LISTWINDOW:Hide() end

	local f = AceGUI:Create("Window")
	f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
	f:SetTitle("Wardrobe Export")
	f:SetLayout("Fill")
	f:EnableResize(false)
	_G["BetterWardrobeExportWindow"] = f.frame
	LISTWINDOW = f
	tinsert(UISpecialFrames, "BetterWardrobeExportWindow")

	local MultiLineEditBox = AceGUI:Create("MultiLineEditBox")
	MultiLineEditBox:SetFullHeight(true)
	MultiLineEditBox:SetFullWidth(true)
	MultiLineEditBox:SetLabel("")
	f:AddChild(MultiLineEditBox)

	MultiLineEditBox:SetText(itemString or "")
end



--local testString = "compare?items=16955:32570:137109:29337:42376:35221:37363:16952:13075:50632:27512:34675"
--local t2 = "compare?items=163307.0.0.0.0.0.0.0.0.0.5126:163453.0.0.0.0.0.0.0.0.0.5126:163455.0.0.0.0.0.0.0.0.0.5126:163456.0.0.0.0.0.0.0.0.0.5126:163458.0.0.0.0.0.0.0.0.0.5126:163459.0.0.0.0.0.0.0.0.0.5126:163460.0.0.0.0.0.0.0.0.0.5126:163461.0.0.0.0.0.0.0.0.0.5126"

--compare?items=16955:32570:137109:29337:42376:35221:37363:16952:13075:50632:27512:34675

--local string2 = "/outfit v1 194960,0,0,194987,194953,0,0,0,194954,194955,194956,194957,93239,-1,0,0,0"

local function ImportSet(importString)
	local itemData = {}
	importString = string.gsub(importString,"/outfit v1", "")
	for item in importString:gmatch("[(%-?%d+)]+") do
		table.insert(itemData, item)
	end

	local itemTransmogInfoList ={} 

	for i = 1, 19 do
		local secondary = 0
		local sourceID = itemData[i]

		if sourceID then 
			itemTransmogInfo = ItemUtil.CreateItemTransmogInfo(sourceID or 0, secondary, 0)
		else
			itemTransmogInfo = ItemUtil.CreateItemTransmogInfo( 0, 0, 0)
		end
		itemTransmogInfoList[i] = itemTransmogInfo	
	end

	DressUpItemTransmogInfoList(itemTransmogInfoList)
end


local importFrom = nil
addon.importFrom = importFrom
StaticPopupDialogs["BETTER_WARDROBE_IMPORT_SET_POPUP"] = {
	text = L["Copy and paste a WoW Outfit Link into the text box below to import"],
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
		if importFrom == "tmog"  then 
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



--/outfit v1 194960,0,0,194987,194953,0,0,0,194954,194955,194956,194957,93239,-1,0,0,0
--https://www.wowhead.com/item=163307/honorbound-centurions-vambraces?bonus=5126:1562#see-also
--local WowheadURL = "www.wowhead.com/item=(%d+).-bonus=(%d+):%d*"

local function ConvertItemLink(item)
end


local function ImportItem(importString)
end


local function ImportItemTransMogVendor(importString)
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
	local playerActor = DressUpFrame.ModelScene:GetPlayerActor();
	local itemTransmogInfoList = playerActor and playerActor:GetItemTransmogInfoList();
	if not itemTransmogInfoList then
		return;
	end

	local slashCommand = TransmogUtil.CreateOutfitSlashCommand(itemTransmogInfoList);
	Export(slashCommand)
end

function addon:ExportTransmogVendorSet()
	local str = "/outfit v1 ";
	for key, transmogSlot in pairs(TRANSMOG_SLOTS) do
		if ( transmogSlot.location:IsAppearance() ) then
			
			----local sourceID = WardrobeOutfitDropDown:GetSlotSourceID(transmogSlot.location)
			local _, _, sourceID = TransmogUtil.GetInfoForEquippedSlot(transmogSlot.location);
			if ( sourceID ) then
				str = str..sourceID..","
			else
				str = str.."0,"
			end
		end
	end
	Export(str,false)
end

function IE.ImportTransmogVendorSet(importString)
	local transmogSources = {}
	importString = string.gsub(importString,"/outfit v1", "")
	for item in importString:gmatch("[(%-?%d+)]+") do
		table.insert(transmogSources, item)
	end

	for _,sourceID in ipairs(transmogSources) do
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
		if sourceInfo then
			local slot = C_Transmog.GetSlotForInventoryType(sourceInfo.invType);
			local pendingInfo = TransmogUtil.CreateTransmogPendingInfo(Enum.TransmogPendingType.Apply, sourceID);
			local transmogLocation = TransmogUtil.CreateTransmogLocation(slot, Enum.TransmogType.Appearance, Enum.TransmogModification.Main);
			C_Transmog.SetPending(transmogLocation, pendingInfo);
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
				local id, dif, bonus = ConvertItemLink(itemlink)
				string = string..linkText:format(id,bonus or 0)
			end
		--end
	end
	print(string)
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
end

--/run local function f(i,b)DressUpItemLink("item:"..i.."::::::::::::9:"..b);end;f(27457,0);f(27489,0);f(27539,0);f(27548,0);f(27748,0);f(27790,0);f(27897,0);f(28221,0);