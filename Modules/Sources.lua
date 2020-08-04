local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local AceGUI = LibStub("AceGUI-3.0")


local CollectionList = addon.CollectionList
CollectionList.showAll = true

local MogItLoaded = false
local refresh = false
local LISTWINDOW
local vendorDB = {}
local locationDB = {}

local RetrievingDataText =  RED_FONT_COLOR_CODE..RETRIEVING_ITEM_INFO
 
local function GetBossInfo(itemID)
	local drops = C_TransmogCollection.GetAppearanceSourceDrops(itemID)
	local sourceText = ""
	if #drops == 1 then
		sourceText = string.format(WARDROBE_TOOLTIP_ENCOUNTER_SOURCE, drops[1].encounter, drops[1].instance)

		local drop = drops[1]
		local diffText = drop.difficulties[1]
		if diffText then
			for i = 2, #drop.difficulties do
				diffText = diffText..", "..drop.difficulties[i]
			end

			sourceText = sourceText.." "..string.format(PARENS_TEMPLATE, diffText)
		end
	end

	return sourceText
end

local inspectScantip = CreateFrame("GameTooltip", addonName.."ScanningTooltip", nil, "GameTooltipTemplate")
inspectScantip:SetOwner(UIParent, "ANCHOR_NONE")
local needsRefresh
local refreshData
local function GetQuestnfo(questData)
	--for i = 1, #questData do
		local sourceData
		local questID = questData
		local questName
		local link = "quest:"..questID
		inspectScantip:SetHyperlink("quest:"..questID)	
		--local link = "\124cffffff00\124Hquest:%s\124h[%s]\124h\124r"

		if inspectScantip:NumLines() > 0 then
			needsRefresh = nil
			local tooltipLine = _G[addonName.."ScanningTooltipTextLeft1"]
			local text = tooltipLine:GetText()
			if text and text ~= "" then
				questName = text
				--link = link:format(questID,questName)
			end
		else
			needsRefresh = true
		end
		inspectScantip:ClearLines()
		--local zoneName = ("%s: "):format(locationDB[questID][1]) --GetZoneName(QuestToZone[questID],"%s: ").
		local questlocationDB = _G.BetterWardrobeData.questlocationDB or {}
		local zoneid = questlocationDB[tonumber(questID)]
		local zoneid = zoneid and zoneid[1] or 0
		local zoneName = locationDB[zoneid] --GetZoneName(QuestToZone[questID],"%s: ")

		return questName, zoneName, questID, link

end

local function GetDropInfo(dropData)
	local zonelist = {}
	local objectlist = {}
	local containerlist = {}

	for zoneID in string.gmatch(dropData, "(%w+),") do
		if string.match(zoneID, "c") then 
			zoneID = string.gsub(tostring(zoneID),"c","")
			table.insert(containerlist, tonumber(zoneID))

		elseif string.match(zoneID, "o") then
			zoneID = string.gsub(tostring(zoneID),"o","")
			table.insert(objectlist, tonumber(zoneID))

		else
			table.insert(zonelist, tonumber(zoneID))
		end

 	end

	return zonelist, objectlist, containerlist
end

local function GetSourceInfo(itemID)
	local zonelist = {}
	local objectlist = {}
	local containerlist = {}
	local questList = {}
	local achievementList = {}
	local professionList = {}
	local vendorList = {}
	local itemSourceDB = (_G.BetterWardrobeData and _G.BetterWardrobeData.sourceDB )or {}
	local dropData = itemSourceDB[tonumber(itemID)]

	if dropData then  
				--for sourceID in string.gmatch(dropData, '(%a:%-?%d+:-),') do

		for sourceID in string.gmatch(dropData, '(%a:%-?%d+:-"-[%s%w%p]-"-),') do
			if string.match(sourceID, "p:") then
				--sourceID = string.gsub(tostring(sourceID),"p","")
				for id, pr in string.gmatch(sourceID, 'p:(%w+):(.+)') do
					table.insert(professionList, {id,pr})
				end

			elseif string.match(sourceID, "c:") then 
				sourceID = string.gsub(tostring(sourceID),"c:","")
				table.insert(containerlist, tonumber(sourceID))

			elseif string.match(sourceID, "o:") then
				sourceID = string.gsub(tostring(sourceID),"o:","")
				table.insert(objectlist, tonumber(sourceID))

			elseif string.match(sourceID, "q:") then
				for id in string.gmatch(sourceID, 'q:(%w+)') do
					table.insert(questList, id)
				end

			elseif string.match(sourceID, "v:") then
				for id, pr in string.gmatch(sourceID, 'v:(%w+):(.+)') do
					table.insert(vendorList, {id,pr})
				end
				--table.insert(vendorList, tonumber(sourceID))

			elseif string.match(sourceID, "a:") then 
				sourceID = string.gsub(tostring(sourceID),"a:","")
				table.insert(achievementList, tonumber(sourceID))

			elseif string.match(sourceID, "l:") then 
				sourceID = string.gsub(tostring(sourceID),"l:","")
				table.insert(zonelist, tonumber(sourceID))
			end
	 	end
	 else
	 end

	return zonelist, objectlist, containerlist, questList, achievementList, professionList, vendorList

	--[[for i = 1, #questData do
				local sourceData
				local questID = questData[i]
				local questName
				inspectScantip:SetHyperlink("quest:"..questID)
				--local link = "\124cffffff00\124Hquest:%s\124h[%s]\124h\124r"
		
		
				if inspectScantip:NumLines() > 0 then
					local tooltipLine = _G[addonName.."ScanningTooltipTextLeft1"]
					local text = tooltipLine:GetText()
					if text and text ~= "" then
						questName = text
						--link = link:format(questID,questName)
					end
				end
				inspectScantip:ClearLines()
				--local zoneName = ("%s: "):format(locationDB[questID][1]) --GetZoneName(QuestToZone[questID],"%s: ")
				local zoneName = locationDB[questID][1] or "" --GetZoneName(QuestToZone[questID],"%s: ")
		
				if questName then
					return questName or "", zoneName
					--GameTooltip:AddLine(zoneName..questName)
				--else
					--GameTooltip:AddLine(zoneName.."Quest: "..questID)
				end
			end]]
end

local function BuildSourceList(visualID)
	if not IsAddOnLoaded("BetterWardrobe_SourceData") then
		EnableAddOn("BetterWardrobe_SourceData")
		LoadAddOn("BetterWardrobe_SourceData")
		vendorDB = (_G.BetterWardrobeData and _G.BetterWardrobeData.vendorDB) or {}
		locationDB = (_G.BetterWardrobeData and _G.BetterWardrobeData.locationDB) or {}
	end

	local itemSourceDB =( _G.BetterWardrobeData and _G.BetterWardrobeData.sourceDB) or {}

	local sources = C_TransmogCollection.GetAllAppearanceSources(visualID)
	local sourceID = sources and sources.sourceID
	local data = {}
	local data_index = 1
	if sources then
		for i=1,#sources do
			local sourceInfo = C_TransmogCollection.GetSourceInfo(sources[i])
			local _,_,_,_,_,itemLink = C_TransmogCollection.GetAppearanceSourceInfo(sources[i])
			if itemLink then
				local itemID = itemLink:match("item:(%d+)")
				itemID = tonumber(itemID)
				local sourceData = itemID and itemSourceDB[itemID] or sourceInfo
				local sourceType = sourceInfo.sourceType
				--Don't want to list items with hidden sources
				if sourceType then 
					data[data_index] = {
						["itemID"] = itemID ,
						["itemLink"] = itemLink,
						["sourceType"] = sourceType,
						["sourceData"] = sourceData,
						["sourceID"] = sources[i],
					}
					data_index = data_index + 1
				end
			end
		end
	end
	return data

end	

local function GetZoneName(zone)
	return ""
end

local function GetPrice(itemID)
	local itemCostDB = (_G.BetterWardrobeData and _G.BetterWardrobeData.itemCostDB) or {}
	local data = itemCostDB[tonumber(itemID)] or "NoData"
	local prices, item, currency = 0, {}, {}

	local index = 0
	for price in string.gmatch(data, '([%d,]-):') do
		index = index + 1
		if index == 1 then
			prices = price

		elseif index == 2 then
			for itemID, cost in string.gmatch(price, '(%d+),(%d+)') do
				if tonumber(itemID) ~= 0 then 
					table.insert(currency, tonumber(itemID))
					table.insert(currency, tonumber(cost))
				end
			end

		elseif index == 3 then
			for itemID, cost in string.gmatch(price, '(%d+),(%d+)') do
				if tonumber(itemID) ~= 0 then 
					table.insert(item, tonumber(itemID))
					table.insert(item, cost)
				end
			end
		end
	end
	return prices, currency, item
end

local refresh_count = 0
local function AddAdditional(parent, index, data, itemID)
	local f = {}
	local Collected = AceGUI:Create("Icon")
	Collected:SetImageSize(20,20)
	Collected:SetWidth(30)
	parent:AddChild(Collected)

	local SourceInfo = AceGUI:Create("InteractiveLabel")
	SourceInfo:SetHeight(20)
	local link, sourceName

	--Boss Drop
	if index == 0 then 
		sourceName = data
		transmogSource = _G["TRANSMOG_SOURCE_1"] or ""
		SourceInfo:SetText(("-%s: %s"):format(transmogSource, sourceName or L["No Data Available"]))

	--World Drop
	elseif index == 1 then
		sourceName = data
		transmogSource = _G["TRANSMOG_SOURCE_4"] or ""
		local zoneList = ""
		for index, zone in ipairs(data) do
			if locationDB[zone] then 
				zoneList = zoneList .. (locationDB[zone])..", "
			end
		end
		SourceInfo:SetText(("-%s: %s"):format(transmogSource, zoneList))

	--Container
	elseif index == 2 then 
		local item = Item:CreateFromItemID(tonumber(data))
		item:ContinueOnItemLoad(function()
			local name = item:GetItemName() 
			SourceInfo:SetText(("-%s: %s"):format(L["Created by"], name))
		end)
	elseif index == 3 then 
		local item = Item:CreateFromItemID(tonumber(data))
		item:ContinueOnItemLoad(function()
			local name = item:GetItemName() 
			SourceInfo:SetText(("-%s: %s"):format(L["Contained in"], name))
		end)

	--Quest
	elseif index == 4 then 
		sourceName, zoneName, questID, link = GetQuestnfo(data)
		transmogSource = _G["TRANSMOG_SOURCE_2"] or ""

		if sourceName then 
			sourceName = ACHIEVEMENT_COLOR_CODE..sourceName..L.ENDCOLOR
		else
			if refresh_count < 100 then
				sourceName = RetrievingDataText..L.ENDCOLOR
			else

			end
		end

		if zoneName then
			SourceInfo:SetText(("-%s: %s - [%s] "):format(transmogSource, zoneName, sourceName or L["No Data Available"].." (QuestID:"..questID..")"))
		else
			SourceInfo:SetText(("-%s: [%s] "):format(transmogSource, sourceName or "Quest"..questID))
		end

	--Achievement
	elseif index == 5 then 
		local id, name, points = GetAchievementInfo(data)
		sourceName = name
		link = GetAchievementLink(id)
		transmogSource = _G["TRANSMOG_SOURCE_5"] or ""
		sourceName = ACHIEVEMENT_COLOR_CODE..sourceName..L.ENDCOLOR
		SourceInfo:SetText(("-%s: [%s]"):format(transmogSource, sourceName))

	--Profession
	elseif index == 6 then 
		spellID = data[1]
		profession = data[2]
		link = GetSpellLink(spellID)

		local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(spellID)
		--local id, name, points = GetAchievementInfo(sourceName)
		sourceName = name
		sourceName = ACHIEVEMENT_COLOR_CODE..sourceName..L.ENDCOLOR
		SourceInfo:SetText(("-%s: [%s]"):format(L[profession], sourceName or L["No Data Available"]))

	--Vendor
	elseif index == 7 then 
		sourceName = data[1]
		vendorName = data[2]
		local zonedata = vendorDB[tonumber(sourceName)] or {}
		local zones = ""
		for i, zondID in ipairs(zonedata) do
			if locationDB[tonumber(zondID)] then 
				zones = zones..locationDB[tonumber(zondID)]..","
			end
		end

		transmogSource = _G["TRANSMOG_SOURCE_3"] or ""
		prices, currency, items = GetPrice(itemID)
		price_text = ""
		local goldCost = tonumber(prices)
		if goldCost > 0 then
			price_text = price_text .. GetCoinTextureString(goldCost).."   "
			SourceInfo:SetText(("-%s: %s - %s: %s - Price: %s"):format( transmogSource, L[vendorName] or L["No Data Available"], L["Zone"], zones or "?", price_text))
		end

		for i = 1, #currency, 2 do
			if currency[i] then 
				local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(tonumber(currency[i]))
				local name = currencyInfo.name
				local icon = currencyInfo.iconFileID
				local cost = currency[i + 1] or 0

				local text = price_text
				price_text = price_text..cost.." |T"..icon..":0|t ".."["..name.."] "
				SourceInfo:SetText(("-%s: %s - %s: %s - Price: %s"):format( transmogSource, L[vendorName] or L["No Data Available"], L["Zone"], zones or "?", price_text))

			end
		end

		for i = 1, #items, 2 do
			if items[i] then 
				local item = Item:CreateFromItemID(tonumber(items[i]))
				local cost = items[i + 1]
				item:ContinueOnItemLoad(function()
					local name = item:GetItemName()
					local icon = item:GetItemIcon()
					local text = price_text
					text = text..cost.." |T"..icon..":0|t ".."["..name.."] "
					SourceInfo:SetText(("-%s: %s - %s: %s - Price: %s"):format( transmogSource, L[vendorName] or L["No Data Available"], L["Zone"], zones or "?", text))

				end)

			end
		end
	else
		if data then 
			transmogSource = _G["TRANSMOG_SOURCE_"..data] or ""
			SourceInfo:SetText(("-%s: %s"):format(transmogSource,L["No Data Available"]))

		else
			SourceInfo:SetText(("-%s"):format(L["No Data Available"]))
		end
	end

	SourceInfo:SetCallback("OnEnter", function()
		GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR", 0, 0)
		if (link) then 
			GameTooltip:SetHyperlink(link)
			GameTooltip:Show()
		end
	end)
	
	SourceInfo:SetCallback("OnLeave", function() GameTooltip:Hide()	end)
	SourceInfo:SetRelativeWidth(.86)
	parent:AddChild(SourceInfo)

	local LinkButton = AceGUI:Create("InteractiveLabel")
	LinkButton:SetWidth(60)
	LinkButton:SetHeight(20)

	parent:AddChild(LinkButton)
	local sourceName = ""
	local zoneName, questlink
end

local refresh_VisID
function CollectionList:GenerateSourceListView(visualID)
	if self.LISTWINDOW then self.LISTWINDOW:Hide() end
	local f = AceGUI:Create("Window")
	f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
	f:SetCallback("OnHide",function(widget) AceGUI:Release(widget) end)

	f:SetTitle(L["Sources"])
	f:SetStatusText("Status Bar")
	f:SetLayout("LIST")
	f:EnableResize(false)
	_G["BetterWardrobeCollectionListWindow"] = f.frame
	self.LISTWINDOW = f
	tinsert(UISpecialFrames, "BetterWardrobeCollectionListWindow")

	local scrollcontainer = AceGUI:Create("SimpleGroup")
	scrollcontainer:SetFullWidth(true)
	scrollcontainer:SetHeight(f.frame:GetHeight()-85)
	scrollcontainer:SetLayout("Fill") -- important!
	f:AddChild(scrollcontainer)

	local MultiLineEditBox = AceGUI:Create("MultiLineEditBox")
	MultiLineEditBox:SetFullWidth(true)
	MultiLineEditBox:SetLabel("")
	MultiLineEditBox.button:Hide()
	MultiLineEditBox.scrollBar:Hide()
	MultiLineEditBox:SetHeight(25)

	f:AddChild(MultiLineEditBox)
	MultiLineEditBox.frame:ClearAllPoints()
	local scroll = AceGUI:Create("ScrollFrame")
	scroll:SetLayout("Flow")
	scroll:SetFullWidth(true)
	scroll:SetFullHeight(true)
	scrollcontainer:AddChild(scroll)	

	local list = BuildSourceList(visualID)
	for i, data in ipairs(list) do
		if data then
			local categoryID, visualID, canEnchant, itemIcon, isCollected, itemLink, transmogLink = C_TransmogCollection.GetAppearanceSourceInfo(data.sourceID)
			local collectedStatus = ""

			if isCollected then 
				collectedStatus = GREEN_FONT_COLOR_CODE.."["..L["Collected"].."]"..L.ENDCOLOR
			else
				collectedStatus = RED_FONT_COLOR_CODE.."["..L["Not Collected"].."]"..L.ENDCOLOR
			end

			local itemName, _, itemQuality = GetItemInfo(itemLink)
			--local itemID =GetItemInfoFromHyperlink(itemLink)
			local nameColor = ITEM_QUALITY_COLORS[itemQuality] or ""
			local transmogSource = data.sourceType and _G["TRANSMOG_SOURCE_"..(data.sourceType)] or ""
			local bossInfo = ""
			--Additionals:SetText(("|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t    +%s More"):format(total_count-1))

			local Collected = AceGUI:Create("Icon")
			if isCollected then
				Collected:SetImage("Interface\\RaidFrame\\ReadyCheck-Ready")
			else
				Collected:SetImage("Interface\\RaidFrame\\ReadyCheck-NotReady")
			end

			Collected:SetImageSize(20, 20)
			Collected:SetWidth(25)
			scroll:AddChild(Collected)

			local icon = AceGUI:Create("Icon")
			icon:SetImage(itemIcon)
			icon:SetImageSize(20,20)
			scroll:AddChild(icon)
			icon:SetWidth(25)

			local CheckBox = AceGUI:Create("InteractiveLabel")
			CheckBox:SetHeight(25)

			local priceText = ""
			itemName = itemName and nameColor.hex..itemName..L.ENDCOLOR or ""
			CheckBox:SetText(itemName)

			CheckBox:SetCallback("OnClick", function()
				if IsModifiedClick("CHATLINK") then
					if itemLink then
						HandleModifiedItemClick(itemLink)
					end

				elseif IsModifiedClick("DRESSUP") then
					DressUpVisual(data.sourceID)
				end
			end)

			CheckBox:SetCallback("OnEnter", function()
				GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR", 0, 0)
				if (itemLink) then 
					GameTooltip:SetHyperlink(itemLink)
					GameTooltip:Show()
				end
			end)
			
			CheckBox:SetCallback("OnLeave", function()
				GameTooltip:Hide()
			end)

			CheckBox:SetRelativeWidth(.83)
			scroll:AddChild(CheckBox)

			local LinkButton = AceGUI:Create("Button")
			LinkButton:SetText("Link")
			LinkButton:SetWidth(60)
			LinkButton:SetHeight(25)
			LinkButton:SetCallback("OnClick", function()
				local url = "https://www.wowhead.com/item="
				MultiLineEditBox:SetText(url..data.itemID) 
			end)

			scroll:AddChild(LinkButton)
			local sourceName = ""
			local zoneName, questlink
			local datafound = false

			if data.sourceType and data.sourceType == 1 then
				sourceName = GetBossInfo(data.sourceID)
				AddAdditional(scroll, 0, sourceName, data.itemID)
				datafound = true
			end

			local zonelist, objectlist, containerlist, questList, achievementList, professionList, vendorList = GetSourceInfo(data.itemID)			if #zonelist > 0 then
				AddAdditional(scroll, 1, zonelist, data.itemID)
				datafound = true
			end

			local DB_List = {objectlist,containerlist,questList,achievementList ,professionList,vendorList}
			for index, list in ipairs(DB_List) do
				for _, db_data in ipairs(list) do
					AddAdditional(scroll, index + 1, db_data, data.itemID)
					datafound = true
				end 
			end

			if not datafound then 
				AddAdditional(scroll, 10, data.sourceType, data.itemID)
			end
		end
	end

	MultiLineEditBox.frame:SetPoint("BOTTOM", f.frame,"BOTTOM", 0, -15)
	if needsRefresh and refresh_count < 100 then
		refresh_VisID = visualID
		refresh_count = refresh_count + 1
		C_Timer.After(0, function() CollectionList:GenerateSourceListView(refresh_VisID) end)

	else
		refresh_VisID = nil
		refresh_count = 0	
	end
end

function CollectionListTooltip_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(L["Click: Show Collection List"])
	GameTooltip:AddLine(L["Shift Click: Show Detail List"])
	GameTooltip:Show()
end

BW_CollectionListDropDownMixin = {}