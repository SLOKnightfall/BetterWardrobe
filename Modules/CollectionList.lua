local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local CollectionList = {}
addon.CollectionList = CollectionList

function CollectionList:BuildCollectionList(complete)
	local list = {}
	local searchString = string.lower(WardrobeCollectionFrameSearchBox:GetText())
	local filterCollected = C_TransmogCollection.GetCollectedShown()
	local filterUncollected = C_TransmogCollection.GetUncollectedShown()
	local filterSource = {}
	
	for i = 1, 6 do
		filterSource[i] = C_TransmogCollection.IsSourceTypeFilterChecked(i)
	end

	for visualID, _ in pairs(addon.chardb.profile.collectionList["item"]) do
		local sources = C_TransmogCollection.GetAppearanceSources(visualID)
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sources[1].sourceID)
		local isCollected = sourceInfo.isCollected
		local sourceType = sourceInfo.sourceType

		if complete then
			tinsert(list, sourceInfo)
		elseif ((not isCollected and filterUncollected)  and (sourceType and not filterSource[sourceType])) or (isCollected and filterCollected)  then
			if searchString then

				for i, data in pairs(sources) do
					local match = string.find(string.lower(data.name or ""), searchString) -- or string.find(baseSet.label, searchString) or string.find(baseSet.description, searchString)
					if match then
						tinsert(list, sourceInfo)
						break
					end
				end
			else
				tinsert(list, sourceInfo)
			end
		end
	end

	return list
end


function CollectionList:BuildShoppingList()
	local collectionList = self:BuildCollectionList(true)
	local shoppingList = {}
	for _, data in ipairs(collectionList) do
		local sources = C_TransmogCollection.GetAppearanceSources(data.visualID)
		for _, data in pairs(sources) do
			local sourceInfo = C_TransmogCollection.GetSourceInfo(data.sourceID)
			tinsert(shoppingList, sourceInfo)
		end
	end

	return shoppingList
end


--Needs to to take account of variant
function CollectionList:UpdateList(type, typeID, add)
	typeID = tonumber(typeID)
	if not typeID then return end
	local addSet = false
	local setName, setInfo, itemModID
	if type == "item" then --TypeID is visualID
		addon.chardb.profile.collectionList[type][typeID] = add or nil
		if WardrobeCollectionFrame.ItemsCollectionFrame:IsShown() then
			WardrobeCollectionFrame.ItemsCollectionFrame:RefreshVisualsList()
			WardrobeCollectionFrame.ItemsCollectionFrame:UpdateItems()
			print(add and L["Appearance added."] or L["Appearance removed."] )
		end
		
		return addon.chardb.profile.collectionList[type][typeID]
	else
		local sources
		if type == "set" then
			sources = C_TransmogSets.GetSetSources(typeID)
			setName = C_TransmogSets.GetSetInfo(typeID).name
		else
			setInfo = addon.GetSetInfo(typeID)
			sources = addon.GetSetsources(typeID)
			setName = "name"
			itemModID = setInfo.mod
		end

		addon.chardb.profile.collectionList[type][typeID] = (add and {}) or nil

		for sourceID, isCollected in pairs(sources) do

			local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
			local visualID = C_TransmogCollection.GetItemInfo(sourceInfo.itemID, itemModID)--(type == "set" and sourceInfo.visualID) or addon.GetItemSource(sourceID, setInfo.mod)

			if add then
				addon.chardb.profile.collectionList[type][typeID][visualID] = (add and not isCollected and add)
			end

			addSet = self:UpdateList("item", visualID, (add and not isCollected) or nil)	
		end

		if type == "set" then
			WardrobeCollectionFrame.SetsCollectionFrame:OnSearchUpdate()
			WardrobeCollectionFrame.SetsTransmogFrame:OnSearchUpdate()
		else
			BW_SetsTransmogFrame:OnSearchUpdate()
			BW_SetsCollectionFrame:OnSearchUpdate()
		end

		--print( addSet and L["%s: Uncollected items added"]:format(setName) or L["No new appearces needed."])
		return addSet
	end	
end


BetterWardrobeSetsCollectionListMixin = {}
function BetterWardrobeSetsCollectionListMixin:Toggle(toggleState)
	if ( IsShiftKeyDown() ) then
		CollectionList:GenerateListView()
	else
		local atTransmogrifier = WardrobeFrame_IsAtTransmogrifier()
		WardrobeCollectionFrame.ItemsCollectionFrame:SetActiveSlot("HEADSLOT", LE_TRANSMOG_TYPE_APPEARANCE)
		WardrobeCollectionFrame.ItemsCollectionFrame:RefreshVisualsList()
		WardrobeCollectionFrame.ItemsCollectionFrame:UpdateItems()
		WardrobeCollectionFrame.ItemsCollectionFrame.SlotsFrame:SetShown(not toggleState and not atTransmogrifier)
		WardrobeCollectionFrameWeaponDropDown:SetShown(not toggleState)
		self.CollectionListTitle:SetShown(toggleState)
	end
end


function BetterWardrobeSetsCollectionListMixin:SetTitle()
	self.CollectionListTitle.Name:SetText(L["Collection List"])
end


--[[	if Wow.IsAddonEnabled("TheUndermineJournal") and TUJMarketInfo then
		local function GetTUJPrice(itemLink, arg)
			local data = TUJMarketInfo(itemLink)
			return data and data[arg] or nil
		end
]]

local function GetCustomPriceValue(source, itemID)
	return TSM_API.GetCustomPriceValue(source, itemID)
end


local function MoneyToString(priceMarket)
	return TSM_API.FormatMoneyString(priceMarket)
end


local TSMSources
local function TSMPricelookup(itemID)
	if (not IsAddOnLoaded("TradeSkillMaster")) then return "" end

	if not TSMSources  then
		TSMSources = {}
		TSM_API.GetPriceSourceKeys(TSMSources)
	end

	local source = TSMSources[addon.db.profile["TSM_Market"]] or "DBMarket"
	return MoneyToString((GetCustomPriceValue(source, "i:"..itemID) or 0) )
end


local function GetBossInfo(itemID)
	local drops = C_TransmogCollection.GetAppearanceSourceDrops(itemID)
	local sourceText = ""
	if ( #drops == 1 ) then
		sourceText = _G["TRANSMOG_SOURCE_"..TRANSMOG_SOURCE_BOSS_DROP]..": "..string.format(WARDROBE_TOOLTIP_ENCOUNTER_SOURCE, drops[1].encounter, drops[1].instance)
		showDifficulty = true
	end
	return sourceText
end


local  LISTWINDOW
--local pGuid, pBattlePetID, _, pNickname, pLevel, pIsFav, _, pName, _, _, _, _, _, _, _, pIsTradeable = C_PetJournal.GetPetInfoByIndex(index)
local AceGUI = LibStub("AceGUI-3.0")
function CollectionList:GenerateListView()
	if self.LISTWINDOW then self.LISTWINDOW:Hide() end

	-- Create a container frame
	local f = AceGUI:Create("Window")
	f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
	f:SetTitle("Cageing List")
	f:SetStatusText("Status Bar")
	f:SetLayout("Flow")
	--f:SetAutoAdjustHeight(true)
	f:EnableResize(false)
	_G["BetterWardrobeCollectionListWindow"] = f.frame
	self.LISTWINDOW = f
	tinsert(UISpecialFrames, "BetterWardrobeCollectionListWindow")

	local scrollcontainer = AceGUI:Create("SimpleGroup")
	scrollcontainer:SetFullWidth(true)
	--scrollcontainer:SetFullHeight(true) -- probably?
	scrollcontainer:SetHeight(f.frame:GetHeight()-75)
	scrollcontainer:SetLayout("Fill") -- important!
	f:AddChild(scrollcontainer)

	--local tabs = AceGUI:Create("TabGroup")
	--f:AddChild(tabs)

	local scroll = AceGUI:Create("ScrollFrame")
	scroll:SetLayout("Flow")
	scroll:SetFullWidth(true)
	scroll:SetFullHeight(true)
	scrollcontainer:AddChild(scroll)	

	local btn = AceGUI:Create("Button")
	btn:SetWidth(170)
	btn:SetHeight(25)
	btn:SetText(L["Export TSM Groups"])
	btn:SetCallback("OnClick", function()  CollectionList:TSMGroupExport() end)
	f:AddChild(btn)
	btn:ClearAllPoints()
	btn:SetPoint("BOTTOMRIGHT")

	local list = CollectionList:BuildShoppingList()

	for i, data in ipairs(list) do
			--cal itemID, itemType, itemSubType, itemEquipLoc, icon, itemClassID, itemSubClassID = GetItemInfoInstant(data.itemID)
		if data then
			local _, itemLink, _, _, _, _, _, _, _, itemIcon, _, _, _, _, expacID = GetItemInfo(data.itemID)
			local nameColor = ITEM_QUALITY_COLORS[data.quality] or ""
			local transmogSource = data.sourceType and _G["TRANSMOG_SOURCE_"..(data.sourceType)] or L.OM_GOLD..L["Collected"]..L.ENDCOLOR
			local bossInfo = ""

			local CheckBox = AceGUI:Create("InteractiveLabel")
			local priceText = TSMPricelookup(data.itemID)
			local name = data.name and nameColor.hex..data.name..L.ENDCOLOR or ""

			if data.sourceType and data.sourceType == 1 then
				bossinfo = GetBossInfo(data.sourceID)
				CheckBox:SetText(L.COLLECTIONLIST_TEXT:format(name, bossinfo))
			elseif data.sourceType and (data.sourceType == 3 or data.sourceType == 4 or data.sourceType == 6) then
				CheckBox:SetText(L.SHOPPINGLIST_TEXT:format( name, transmogSource, priceText ))
			else
				CheckBox:SetText(L.COLLECTIONLIST_TEXT:format(name, transmogSource))
			end

			CheckBox:SetImage(itemIcon)
			CheckBox:SetImageSize(20,20)
			CheckBox:SetFullWidth(true)

						if i == 1 or list[i-1].visualID ~= data.visualID then
							local Heading = AceGUI:Create("Heading")
							Heading:SetFullWidth(true)
							--Checkbox2:SetRelativeWidth(.02)
							scroll:AddChild(Heading)
						end
			CheckBox:SetCallback("OnClick", function()
				if ( IsModifiedClick("CHATLINK") ) then
						if ( itemLink ) then
							--print(itemLink)
							HandleModifiedItemClick(itemLink)
						end
				elseif ( IsModifiedClick("DRESSUP") ) then
					DressUpVisual(data.sourceID)
				end
			end)
			CheckBox:SetCallback("OnEnter", function()
				GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR", 0, 0)
				GameTooltip:SetHyperlink(itemLink)
				GameTooltip:Show()
			end)
			CheckBox:SetCallback("OnLeave", function()
				GameTooltip:Hide()
			end)
			scroll:AddChild(CheckBox)
		end
	end
end


--Exports a TSM group listing.  Items are grouped by visualID
function CollectionList:TSMGroupExport()
	if self.LISTWINDOW then self.LISTWINDOW:Hide() end
	local f = AceGUI:Create("Window")
	f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
	f:SetTitle("TSM Export")
	f:SetLayout("Fill")
	--f:SetAutoAdjustHeight(true)
	f:EnableResize(false)
	_G["BetterWardrobeCollectionExportWindow"] = f.frame
	LISTWINDOW = f
	tinsert(UISpecialFrames, "BetterWardrobeCollectionExportWindow")

	local CheckBox = AceGUI:Create("MultiLineEditBox")
	CheckBox:SetFullHeight(true)
	CheckBox:SetFullWidth(true)
	CheckBox:SetLabel("")
	f:AddChild(CheckBox)

	local list = CollectionList:BuildShoppingList()
	local itemString = ""
	local groupCount = 1
	local lastVisual
	for i, data in ipairs(list) do
		if data.sourceType and (data.sourceType == 3 or data.sourceType == 4 or data.sourceType == 6) then
			if i == 1 or lastVisual ~= data.visualID then
				itemString = L["%sgroup:Appearance Group %s,"]:format(itemString, groupCount)
				groupCount = groupCount + 1
				lastVisual = data.visualID
			end	
			itemString = itemString.."i:"..data.itemID..","
		end

	end
	CheckBox:SetText(itemString)
end