local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local AceGUI = LibStub("AceGUI-3.0")


local CollectionList = addon.CollectionList
CollectionList.showAll = true

local MogItLoaded = false
local refresh = false
local  LISTWINDOW
local LISTWINDOW2


local function Export(itemString, parent)
	if  LISTWINDOW2 then LISTWINDOW2:Hide() end

	for _, listPopup in pairs(BetterWardrobeOutfitFrameMixin.popups) do
		StaticPopup_Hide(listPopup)
	end
	local url = "https://www.wowhead.com/item="
	local f = AceGUI:Create("Window")
	
	--f:SetBackdrop(	BACKDROP_DIALOG_32_32 )
	f:SetCallback("OnClose",function(f) AceGUI:Release(f) end)
	f:SetCallback("onHide",function(f)print("OC") ;AceGUI:Release(f) end)

	f:SetTitle("WowHead Link")
	f:SetLayout("Fill")
	--f:SetAutoAdjustHeight(true)
	f:EnableResize(false)
	f:SetHeight(100)
	f:SetWidth(450)

		f.frame:SetParent(parent.frame)
		f.frame:SetPoint("CENTER", parent.frame, "CENTER")
	
	--CollectionList.LISTWINDOW
	_G["BetterWardrobeExportWindow"] = f.frame
	--Mixin(f.frame, BackdropTemplateMixin )
	--f.UISpecialFrames:SetBackdrop(	BACKDROP_DIALOG_32_32 )
	LISTWINDOW2 = f
	tinsert(UISpecialFrames, "BetterWardrobeExportWindow")

	local MultiLineEditBox = AceGUI:Create("MultiLineEditBox")
	MultiLineEditBox:SetFullHeight(true)
	MultiLineEditBox:SetFullWidth(true)
	MultiLineEditBox:SetLabel("")
	--MultiLineEditBox:DisableButton(button)
	f:AddChild(MultiLineEditBox)

	--MultiLineEditBox:SetText(url..itemString or "")
end

local function GetBossInfo(itemID)
	local drops = C_TransmogCollection.GetAppearanceSourceDrops(itemID)
	local sourceText = ""
	if ( #drops == 1 ) then
		sourceText = string.format(WARDROBE_TOOLTIP_ENCOUNTER_SOURCE, drops[1].encounter, drops[1].instance)
		showDifficulty = true

		if ( showDifficulty ) then
				local drop = drops[1];
				local diffText = drop.difficulties[1];
				if ( diffText ) then
					for i = 2, #drop.difficulties do
						diffText = diffText..", "..drop.difficulties[i];
					end
				end
				if ( diffText ) then
					sourceText = sourceText.." "..string.format(PARENS_TEMPLATE, diffText);
				end
			end
	end
	return sourceText
end

local inspectScantip = CreateFrame("GameTooltip", addonName.."ScanningTooltip", nil, "GameTooltipTemplate")
inspectScantip:SetOwner(UIParent, "ANCHOR_NONE")
local needsRefresh = {}
local function GetQuestnfo(questData)
	for i = 1, #questData do
		local sourceData
		local questID = questData[i]
		local questName
		local link = "quest:"..questID
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
		--local zoneName = ("%s: "):format(addon.locationDB[questID][1]) --GetZoneName(QuestToZone[questID],"%s: ").
		local zoneid = addon.questlocationDB[tonumber(questID)]
		local zoneid = zoneid and zoneid[1] or 0
		local zoneName = addon.locationDB[zoneid] --GetZoneName(QuestToZone[questID],"%s: ")

		if questName then
			return questName or "", zoneName, link
			--GameTooltip:AddLine(zoneName..questName)
		else
			needsRefresh[questID] = needsRefresh[questID] or 0
			if needsRefresh[questID] <20 then
				needsRefresh[questID] = needsRefresh[questID] + 1
				refresh = true
			else
				refresh = false
			end
			--GameTooltip:AddLine(zoneName.."Quest: "..questID)
		end
	end
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
	local dropData = addon.sourceDB[tonumber(itemID)]

	if dropData then  

				--for sourceID in string.gmatch(dropData, '(%a:%-?%d+:-),') do

		for sourceID in string.gmatch(dropData, '(%a:%-?%d+:-[%s%w]-),') do
			if string.match(sourceID, "p:") then
				print(sourceID)
				--sourceID = string.gsub(tostring(sourceID),"p","")
				for id, pr in string.gmatch(sourceID, 'p:(%w+):(.+)') do
					print(id, pr)
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
				sourceID = string.gsub(tostring(sourceID),"v:","")
				table.insert(vendorList, tonumber(sourceID))

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
				--local zoneName = ("%s: "):format(addon.locationDB[questID][1]) --GetZoneName(QuestToZone[questID],"%s: ")
				local zoneName = addon.locationDB[questID][1] or "" --GetZoneName(QuestToZone[questID],"%s: ")
		
				if questName then
					return questName or "", zoneName
					--GameTooltip:AddLine(zoneName..questName)
				--else
					--GameTooltip:AddLine(zoneName.."Quest: "..questID)
				end
			end]]
end

local function buildsourcelist(visualID)
	local itemSourceDB = addon.sourceDB or {}

	local sources = C_TransmogCollection.GetAppearanceSources(visualID)
	local sourceID = sources and sources.sourceID
	local data = {}
	if sources then
		for i=1,#sources do
			local _,_,_,_,_,itemLink = C_TransmogCollection.GetAppearanceSourceInfo(sources[i].sourceID)
			if itemLink then
				local itemID = itemLink:match("item:(%d+)")
				itemID = tonumber(itemID)
				local sourceData = itemID and itemSourceDB[itemID] or sources[i]
				local sourceType = sources[i].sourceType

				data[i] = {
					["itemID"] = itemID ,
					["itemLink"] = itemLink,
					["sourceType"] = sourceType,
					["sourceData"] = sourceData,
					["sourceID"] = sources[i].sourceID,
				}
			end
		end
	return data
	end
end	

local function GetZoneName(zone)
	return ""
	-- body
end

local function SourcesFrame_SourceData_OnEnter(data)
	local FirstLine = _G["TRANSMOG_SOURCE_"..(data.sourceType)]
	local sourceType = data.sourceType

	if not sourceType then 
		if FirstLine then
				GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR", 0, 0)
			GameTooltip:AddLine(FirstLine)
			GameTooltip:Show()
		end
		return 
	end
		
				GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR", 0, 0)
	if sourceType == 2 then
		if FirstLine then
			GameTooltip:AddLine(FirstLine)
		end

		GameTooltip:AddLine(data.sourceType)
		local sourceData = data.sourceData[2]
		for i = 1, #sourceData do
			local questID = sourceData[i]
			local questName
			inspectScantip:SetHyperlink("quest:"..questID)

			if inspectScantip:NumLines() > 0 then
				local tooltipLine = _G[addonName.."ScanningTooltipTextLeft1"]
				local text = tooltipLine:GetText()
				if text and text ~= "" then
					questName = text
				end
			end
			inspectScantip:ClearLines()
			local zoneName = ("%s: "):format(addon.questlocationDB[questID][1] or "")
			--local zoneName = GetZoneName(QuestToZone[questID],"%s: ")
			if questName then
				GameTooltip:AddLine(zoneName..questName)
			else
				GameTooltip:AddLine(zoneName.."Quest: "..questID)
			end
		end
	end
	GameTooltip:Show()
end	

local AceGUI = LibStub("AceGUI-3.0")

local function AddAdditional(parent)
	local f = {}
	local Collected = AceGUI:Create("Icon")
	Collected:SetImageSize(20,20)
	Collected:SetWidth(25)
	parent:AddChild(Collected)

	local icon = AceGUI:Create("Icon")
	icon:SetImageSize(20,20)
	parent:AddChild(icon)
	icon:SetWidth(25)

	local CheckBox = AceGUI:Create("InteractiveLabel")
	CheckBox:SetFont(CheckBox.label:GetFont(),12)
	CheckBox:SetHeight(25)



	--[[			if i == 1 or list[i-1].visualID ~= data.visualID then
		local Heading = AceGUI:Create("Heading")
		Heading:SetFullWidth(true)
		parent:AddChild(Heading)
	end]]
	CheckBox:SetCallback("OnClick", function()
		if ( IsModifiedClick("CHATLINK") ) then
				if ( itemLink ) then
					HandleModifiedItemClick(itemLink)
				end
		elseif ( IsModifiedClick("DRESSUP") ) then
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

	CheckBox:SetRelativeWidth(.25)
	parent:AddChild(CheckBox)

	local LinkButton = AceGUI:Create("Button")
	LinkButton:SetText("Link")
	LinkButton:SetWidth(60)
	LinkButton:SetHeight(25)


	LinkButton:SetCallback("OnClick", function()
		Export(data.itemID, parent)
	end)
	parent:AddChild(LinkButton)
	local sourceName = ""
	local zoneName, questlink

	--Export
	--

	local SourceInfo = AceGUI:Create("InteractiveLabel")
	SourceInfo:SetFont(SourceInfo.label:GetFont(),12)
	SourceInfo:SetHeight(40)

	SourceInfo:SetRelativeWidth(.50)
	parent:AddChild(SourceInfo)

	local Additionals = AceGUI:Create("InteractiveLabel")
	Additionals:SetWidth(55)
	parent:AddChild(Additionals)



end

function CollectionList:GenerateSourceListView(visualID)

	if self.LISTWINDOW then self.LISTWINDOW:Hide() end


	-- Create a container frame
	local f = AceGUI:Create("Window")
	f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
	f:SetCallback("OnHide",function(widget) AceGUI:Release(widget) end)

	f:SetTitle(L["Sources"])
	f:SetStatusText("Status Bar")
	f:SetLayout("Flow")
	--f:SetAutoAdjustHeight(true)
	f:EnableResize(false)
	_G["BetterWardrobeCollectionListWindow"] = f.frame
	self.LISTWINDOW = f
	tinsert(UISpecialFrames, "BetterWardrobeCollectionListWindow")

	local scrollcontainer = AceGUI:Create("SimpleGroup")
	scrollcontainer:SetFullWidth(true)
	scrollcontainer:SetHeight(f.frame:GetHeight()-75)
	scrollcontainer:SetLayout("Fill") -- important!
	f:AddChild(scrollcontainer)

	local scroll = AceGUI:Create("ScrollFrame")
	scroll:SetLayout("Flow")
	scroll:SetFullWidth(true)
	scroll:SetFullHeight(true)
	scrollcontainer:AddChild(scroll)	

	local list = buildsourcelist(visualID)
	for i, data in ipairs(list) do
			--cal itemID, itemType, itemSubType, itemEquipLoc, icon, itemClassID, itemSubClassID = GetItemInfoInstant(data.itemID)
		if data then
			local categoryID, visualID, canEnchant, itemIcon, isCollected, itemLink, transmogLink = C_TransmogCollection.GetAppearanceSourceInfo(data.sourceID)
			local collectedStatus = ""

			if isCollected then 
				collectedStatus = GREEN_FONT_COLOR_CODE.."["..L["Collected"].."]"..L.ENDCOLOR
			else
				collectedStatus = RED_FONT_COLOR_CODE.."["..L["Not Collected"].."]"..L.ENDCOLOR
			end

			local itemName, _, itemQuality = GetItemInfo(itemLink)
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
			Collected:SetImageSize(20,20)
			Collected:SetWidth(25)
			scroll:AddChild(Collected)

			local icon = AceGUI:Create("Icon")
			icon:SetImage(itemIcon)
			icon:SetImageSize(20,20)
			scroll:AddChild(icon)
			icon:SetWidth(25)

			local CheckBox = AceGUI:Create("InteractiveLabel")
			CheckBox:SetFont(CheckBox.label:GetFont(),12)
			CheckBox:SetHeight(25)
			local priceText = ""
			itemName = itemName and nameColor.hex..itemName..L.ENDCOLOR or ""
			CheckBox:SetText(itemName)


			--[[			if i == 1 or list[i-1].visualID ~= data.visualID then
				local Heading = AceGUI:Create("Heading")
				Heading:SetFullWidth(true)
				scroll:AddChild(Heading)
			end]]
			CheckBox:SetCallback("OnClick", function()
				if ( IsModifiedClick("CHATLINK") ) then
						if ( itemLink ) then
							HandleModifiedItemClick(itemLink)
						end
				elseif ( IsModifiedClick("DRESSUP") ) then
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

			CheckBox:SetRelativeWidth(.25)
			scroll:AddChild(CheckBox)

			local LinkButton = AceGUI:Create("Button")
			LinkButton:SetText("Link")
			LinkButton:SetWidth(60)
			LinkButton:SetHeight(25)


			LinkButton:SetCallback("OnClick", function()
				Export(data.itemID, scroll)
			end)
			scroll:AddChild(LinkButton)
			local sourceName = ""
			local zoneName, questlink

			--Export
			--

			local zonelist, objectlist, containerlist, questList, achievementList, professionList, vendorList = GetSourceInfo(data.itemID)
			local profession, link, sourceDB

			local SourceInfo = AceGUI:Create("InteractiveLabel")
			SourceInfo:SetFont(SourceInfo.label:GetFont(),12)
			SourceInfo:SetHeight(40)

			SourceInfo:SetRelativeWidth(.50)
			scroll:AddChild(SourceInfo)

			local Additionals = AceGUI:Create("InteractiveLabel")
			Additionals:SetWidth(55)
			scroll:AddChild(Additionals)
			--dungeon


			if data.sourceType then
				if data.sourceType and data.sourceType == 1 then
					sourceName = GetBossInfo(data.sourceID)
					SourceInfo:SetText(("    %s: %s"):format(transmogSource, sourceName or L["No Data Available"]))


				--quest
				--TODO: fix data loading issue
				--elseif data.sourceType and data.sourceType == 2 then
				elseif #questList > 0 then 
					sourceName, zoneName, link = GetQuestnfo(questList)
					data.questName = sourceName
					sourceDB = questList
					transmogSource = _G["TRANSMOG_SOURCE_2"] or ""
					sourceName = ACHIEVEMENT_COLOR_CODE..sourceName..L.ENDCOLOR

					if zoneName then
						--SourceInfo:SetText(("    %s: %s - %s: [%s]"):format(L["Zone"], zoneName or "?", transmogSource, sourceName or L["No Data Available"]))
						SourceInfo:SetText(("    %s: %s - [%s] "):format(transmogSource, zoneName, sourceName or L["No Data Available"]))
					else
						SourceInfo:SetText(("    %s: [%s] "):format(transmogSource, sourceName or L["No Data Available"]))
					end


					
				--Vendor
				--TODO:  ADD vendor info

				--elseif data.sourceType and data.sourceType == 3 then
				elseif #vendorList > 0 then 
					sourceName = vendorList[1]
					sourceDB = vendorList
					transmogSource = _G["TRANSMOG_SOURCE_3"] or ""

					SourceInfo:SetText(("    %s: %s - %s: [%s]"):format( L["Zone"], zoneName or "?", transmogSource, sourceName or L["No Data Available"]))

					--local  id, name, points = GetAchievementInfo(sourceName)
					--sourceName = name
				
				--World Drop
				--elseif data.sourceType and data.sourceType == 4 then
				elseif #zonelist > 0 then 

						sourceName = zonelist[1]
						--zonelist, objectlist, containerlist = GetDropInfo(data.sourceData)
						sourceDB = zonelist
						transmogSource = _G["TRANSMOG_SOURCE_4"] or ""

						SourceInfo:SetText(("    %s: %s"):format(transmogSource, addon.locationDB[zonelist[1]] or zonelist[1]))

					
				--Achievement  Done
				--elseif data.sourceType and data.sourceType == 5 then
				elseif #achievementList > 0 then
					sourceName = achievementList[1]
					local id, name, points = GetAchievementInfo(sourceName)
					sourceName = name
					sourceDB = achievementList
					link = GetAchievementLink(id)
					transmogSource = _G["TRANSMOG_SOURCE_5"] or ""
					SourceInfo:SetText(("    %s: %s"):format(transmogSource, name))

				--professionList  Done
				elseif #professionList > 0 then
					spellID = professionList[1][1]
					profession = professionList[1][2]
					link = GetSpellLink(spellID)
					sourceDB = professionList

					local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(spellID)
					--local id, name, points = GetAchievementInfo(sourceName)
					sourceName = name
					sourceName = ACHIEVEMENT_COLOR_CODE..sourceName..L.ENDCOLOR

					SourceInfo:SetText(("    %s: [%s]"):format(L[profession], sourceName or L["No Data Available"]))
				end
			end

			if containerlist and #containerlist > 0 then
				local item = Item:CreateFromItemID(tonumber(containerlist[1]))
				item:ContinueOnItemLoad(function()
					local name = item:GetItemName() 
					SourceInfo:SetText(("    %s: %s"):format(L["Conatined in"], name))
				end)
			end

			local total_count = #zonelist + #objectlist + #containerlist + #questList + #achievementList + #professionList + #vendorList
			local DB_List = {zonelist ,objectlist,containerlist,questList,achievementList ,professionList,vendorList}
			if total_count > 1 then

				for _,list in ipairs(DB_List) do
					--if #list > 2 then
						for _, data in ipairs(list) do
							AddAdditional(scroll)
						end 
					--end
				end
					--AddAdditional(parent)
--
				--Additionals:SetFont("GameFontHighlightSmall",12)

				--Additionals:SetText(("+%s More"):format(total_count-1))
			end

			if data.sourceType ~=1 and total_count == 0 then 
					SourceInfo:SetText(("    %s"):format(L["No Data Available"]))

			end
							
			local itemID = tonumber(itemLink:match("item:(%d+)"))
				
			SourceInfo:SetCallback("OnEnter", function(self)
				--SourcesFrame_SourceData_OnEnter(data)
				GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR", 0, 0)
				if (link) then 
					GameTooltip:SetHyperlink(link)
					GameTooltip:Show()
				end
			end)
			
			SourceInfo:SetCallback("OnLeave", function()
				GameTooltip:Hide()
			end)

			if refresh then
				refresh = false
				do
					local vis = visualID
					C_Timer.After(0, function() CollectionList:GenerateSourceListView(vis) end)
				end
			end
		end
	end
end




function CollectionListTooltip_OnEnter(self)
						GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
						GameTooltip:SetText(L["Click: Show Collection List"])
						GameTooltip:AddLine(L["Shift Click: Show Detail List"])
						GameTooltip:Show()
					end

BW_CollectionListDropDownMixin = {}
