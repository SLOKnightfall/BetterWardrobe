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
addon.ShowExportPopup = Export



--local testString = "compare?items=16955:32570:137109:29337:42376:35221:37363:16952:13075:50632:27512:34675"
--local t2 = "compare?items=163307.0.0.0.0.0.0.0.0.0.5126:163453.0.0.0.0.0.0.0.0.0.5126:163455.0.0.0.0.0.0.0.0.0.5126:163456.0.0.0.0.0.0.0.0.0.5126:163458.0.0.0.0.0.0.0.0.0.5126:163459.0.0.0.0.0.0.0.0.0.5126:163460.0.0.0.0.0.0.0.0.0.5126:163461.0.0.0.0.0.0.0.0.0.5126"

--compare?items=16955:32570:137109:29337:42376:35221:37363:16952:13075:50632:27512:34675

--local string2 = "/outfit v1 194960,0,0,194987,194953,0,0,0,194954,194955,194956,194957,93239,-1,0,0,0"

local function ImportSet(importString)
	--Current export format (see ExportSet/CreateChatLinkTransmogVendor): a runnable /run macro
	--that calls DressUpItemLink per item. Replay those same calls instead of executing the macro.
	if importString:find("DressUpItemLink", 1, true) then
		for itemID, bonusID in importString:gmatch("f%((%d+),(%d+)%)") do
			DressUpItemLink(("item:%s::::::::::::9:%s"):format(itemID, bonusID))
		end
		return
	end

	--Legacy format: /outfit v1 <sourceID>,<sourceID>,... . Blizzard removed the API that generated
	--these (TransmogUtil.CreateOutfitSlashCommand), but parsing/applying an old one still works.
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


addon.importFrom = nil
StaticPopupDialogs["BETTER_WARDROBE_IMPORT_SET_POPUP"] = {
	text = L["Copy and paste a WoW Outfit Link into the text box below to import"],
	preferredIndex = 3,
	button1 = L["Import"],
	button2 = CANCEL,
	hasEditBox = true,
	maxLetters = 512,
	editBoxWidth = 260,
	OnShow = function(dialog, data)
		if LISTWINDOW then LISTWINDOW:Hide() end
		dialog:GetEditBox():SetText("")
	end,
	EditBoxOnEnterPressed = function(editBox, data)
		if (editBox:GetParent().GetButton1():IsEnabled()) then
			StaticPopup_OnClick(editBox:GetParent(), 1)
		end
	end,
	OnAccept = function(dialog, data)
		if addon.importFrom == "tmog"  then
			IE.ImportTransmogVendorSet(dialog:GetEditBox():GetText())
		else
			ImportSet(dialog:GetEditBox():GetText());
		end
		addon.importFrom = nil
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
	if not importString or importString == "" then return end
	DressUpItemLink(importString)
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
	OnAccept = function(dialog, data)
		if addon.importFrom == "Transmog" then
			ImportItemTransMogVendor(dialog:GetEditBox():GetText())
		else
			ImportItem(dialog:GetEditBox():GetText());
		end
		addon.importFrom = nil
	end,
	EditBoxOnEnterPressed = function(editBox, data)
		if (editBox:GetParent():GetButton1():IsEnabled()) then
			StaticPopup_OnClick(editBox:GetParent(), 1)
		end
	end,
	EditBoxOnEscapePressed = HideParentPanel;
	exclusive = true,
	whileDead = true,
};
local function GetSourceItemData(sourceID)
	if not sourceID or sourceID <= 0 then
		return nil
	end

	local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)

	if not sourceInfo then
		return nil
	end

	local itemID = sourceInfo.itemID
	local itemModID = sourceInfo.itemModID or 0

	if not itemID or itemID <= 0 then
		return nil
	end

	return itemID, itemModID
end


local function GetVendorSourceID(transmogLocation)
	if not transmogLocation then
		return nil
	end

	local visualInfo = C_Transmog.GetSlotVisualInfo(transmogLocation)

	if not visualInfo then
		return nil
	end

	-- Если пользователь только выбрал трансмог,
	-- но ещё не нажал "Применить", берём pending.
	local sourceID = visualInfo.pendingSourceID

	-- Если pending нет, берём уже применённый трансмог.
	if not sourceID or sourceID <= 0 then
		sourceID = visualInfo.appliedSourceID
	end

	if not sourceID or sourceID <= 0 then
		return nil
	end

	return sourceID
end
--Blizzard removed TransmogUtil.CreateOutfitSlashCommand (the /outfit v1 link generator this used),
--so exporting now reuses the same DressUpItemLink macro format as the existing "post to chat" command.
function addon:ExportSet()
	if C_Transmog.IsAtTransmogNPC() then
		self:CreateChatLinkTransmogVendor()
	else
		self:CreateChatLink()
	end
end

function addon:ExportTransmogVendorSet()
	local sources = {}

	for _, transmogSlot in pairs(TRANSMOG_SLOTS) do
		local location = transmogSlot.location

		if location and location:IsAppearance() then
			local sourceID = GetVendorSourceID(location)
			table.insert(sources, tostring(sourceID or 0))
		end
	end

	local str = "/outfit v1 " .. table.concat(sources, ",")
	Export(str, false)
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
			local transmogLocation = TransmogUtil.CreateTransmogLocation(slot, Enum.TransmogType.Appearance, false);
			C_Transmog.SetPending(transmogLocation, pendingInfo);
		end
	end
end

local linkText = "f(%d,%d);"
function addon:CreateChatLink()
	local string = [[/run local function f(i,b)DressUpItemLink("item:"..i.."::::::::::::9:"..b);end;]]

	local Buttons = BW_DressingRoomFrame.PreviewButtonFrame.Slots

	for _, button in pairs(Buttons) do
		local sourceID = button.sourceID

		if sourceID then
			local itemID, itemModID = GetSourceItemData(sourceID)

			if itemID then
				string = string .. linkText:format(itemID, itemModID)
			end
		end
	end

	print(string)
	Export(string, false)
end


function addon:CreateChatLinkTransmogVendor()
	local string = [[/run local function f(i,b)DressUpItemLink("item:"..i.."::::::::::::9:"..b);end;]]

	for _, transmogSlot in pairs(TRANSMOG_SLOTS) do
		local location = transmogSlot.location

		if location and location:IsAppearance() then
			local sourceID = GetVendorSourceID(location)

			if sourceID then
				local itemID, itemModID = GetSourceItemData(sourceID)

				if itemID then
					string = string .. linkText:format(itemID, itemModID)
				end
			end
		end
	end

	print(string)
	Export(string, false)
end


function BW_TransmogVendorExportButton_OnClick(self)
	MenuUtil.CreateContextMenu(self, function(_owner, rootDescription)
		rootDescription:CreateTitle(L["Import/Export Options"]);

		rootDescription:CreateButton(L["Import Item"], function()
			BetterWardrobeOutfitManager:ShowPopup("BETTER_WARDROBE_IMPORT_ITEM_POPUP")
		end);

		rootDescription:CreateButton(L["Import Set"], function()
			BetterWardrobeOutfitManager:ShowPopup("BETTER_WARDROBE_IMPORT_SET_POPUP")
		end);

		rootDescription:CreateButton(L["Export Set"], function()
			addon:ExportSet()
		end);
	end);
end

--/run local function f(i,b)DressUpItemLink("item:"..i.."::::::::::::9:"..b);end;f(27457,0);f(27489,0);f(27539,0);f(27548,0);f(27748,0);f(27790,0);f(27897,0);f(28221,0);
