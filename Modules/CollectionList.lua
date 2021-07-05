local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)


local CollectionList = {}
addon.CollectionList = CollectionList
CollectionList.showAll = true

local MogItLoaded = false


function initCollectionList()
	local f = CreateFrame("Frame", "BW_ColectionListFrame", BetterWardrobeCollectionFrame, "BW_ColectionListFrameTemplate" )
	local ContextMenu = CreateFrame("Frame", addonName .. "ContextMenuFrame", UIParent, "BW_UIDropDownMenuTemplate")
addon.ContextMenu = ContextMenu

end



function CollectionList:BuildCollectionList(complete)
	local list = {}
	local searchString = string.lower(WardrobeCollectionFrameSearchBox:GetText())
	local filterCollected = C_TransmogCollection.GetCollectedShown()
	local filterUncollected = C_TransmogCollection.GetUncollectedShown()
	local filterSource = {}
	local selectedCategory = BetterWardrobeCollectionFrame.ItemsCollectionFrame:GetActiveCategory()
	for i = 1, 6 do
		filterSource[i] = C_TransmogCollection.IsSourceTypeFilterChecked(i)
	end

	local collectionList = addon.CollectionList:CurrentList()
	for visualID, _ in pairs(collectionList["item"]) do
		local sources = C_TransmogCollection.GetAllAppearanceSources(visualID)

		if sources then 
			local sourceInfo = C_TransmogCollection.GetSourceInfo(sources[1])
			local camera = C_TransmogCollection.GetAppearanceCameraID(visualID)	
			sourceInfo.camera = camera
			local isCollected =  false
			local sourceTypes = {}

			for i,d in pairs(sources)do
				local info = C_TransmogCollection.GetSourceInfo(d)
				 if info.sourceType then 
				 	sourceTypes[info.sourceType] = true
				 end
				 local collected = select(5,C_TransmogCollection.GetAppearanceSourceInfo(d))

				 if collected then 
				 	isCollected = true
				 end
			end

			local filter = false
			for i in pairs(sourceTypes) do
				if  filterSource[i] then 
					filter = true
					break
				end
			end

			local catType = sourceInfo.categoryID
			local invTypeMatch = false
			if CollectionList.showAll then
				invTypeMatch = true
			elseif (CollectionList.Category == 117  and catType == 19)  then 
				invTypeMatch = true
			elseif 	(CollectionList.Category == 116  and catType > 11 and catType ~= 19)  then
				invTypeMatch = true
			else
				invTypeMatch = 	catType == CollectionList.Category
			end

			if complete then
				tinsert(list, sourceInfo)
			elseif  (((not isCollected and filterUncollected) and not filter) or (isCollected and filterCollected) ) and invTypeMatch  then

				if searchString then
					for i, data in pairs(sources) do
						local source_info = C_TransmogCollection.GetSourceInfo(data)
						local match = string.find(string.lower(source_info.name or ""), searchString) -- or string.find(baseSet.label, searchString) or string.find(baseSet.description, searchString)
						if match then
							tinsert(list, source_info)
							break
						end
					end
				else
					tinsert(list, sourceInfo)
				end
			end
		end
	end

	return list
end


function CollectionList:BuildShoppingList()
	local collectionList = self:BuildCollectionList(true)
	local shoppingList = {}
	for _, data in ipairs(collectionList) do
		local sources = C_TransmogCollection.GetAllAppearanceSources(data.visualID)
		--local sources = C_TransmogCollection.GetAppearanceSources(data.visualID)
		for _, data in pairs(sources) do
			local sourceInfo = C_TransmogCollection.GetSourceInfo(data)
			tinsert(shoppingList, sourceInfo)
		end
	end

	return shoppingList
end


--Needs to to take account of variant
function CollectionList:UpdateList(type, typeID, add, sourceID)
	typeID = tonumber(typeID)
	if not typeID then return end
	local addSet = false
	local setName, setInfo, itemModID
	local selectedList = CollectionList:SelectedCollectionList()
	if selectedList == "MOGIT" then
		return addon.MogIt.UpdateWishlistItem(type, typeID, add, sourceID )
	end

	local collectionList = addon.CollectionList:CurrentList()

	if type == "item" then --TypeID is visualID
		collectionList[type][typeID] = add or nil
		if BetterWardrobeCollectionFrame.ItemsCollectionFrame:IsShown() then
			BetterWardrobeCollectionFrame.ItemsCollectionFrame:RefreshVisualsList()
			BetterWardrobeCollectionFrame.ItemsCollectionFrame:UpdateItems()
			print(add and L["Appearance added."] or L["Appearance removed."] )
		end
		
		return collectionList[type][typeID]
	else
		local sources
		if type == "set" then
			sources = C_TransmogSets.GetSetSources(typeID)
			setName = C_TransmogSets.GetSetInfo(typeID).name
		else
			setInfo = addon.GetSetInfo(typeID)
			sources = addon.GetSetsources(typeID)
			setName = "name"
			itemModID = setInfo.mod or 0
		end

		collectionList[type][typeID] = (add and {}) or nil

		for sourceID, isCollected in pairs(sources) do

			local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
			local visualID = C_TransmogCollection.GetItemInfo(sourceInfo.itemID, itemModID or sourceInfo.itemModID)--(type == "set" and sourceInfo.visualID) or addon.GetItemSource(sourceID, setInfo.mod)

			if add and visualID then
				collectionList[type][typeID][visualID] = add
			end

			addSet = self:UpdateList("item", visualID, add or nil)	
		end

		----if type == "set" then
			BetterWardrobeCollectionFrame.SetsCollectionFrame:OnSearchUpdate()
			BetterWardrobeCollectionFrame.SetsTransmogFrame:OnSearchUpdate()
		----else
		----	BW_SetsTransmogFrame:OnSearchUpdate()
		----	BW_SetsCollectionFrame:OnSearchUpdate()
		-----end

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
		local transmogLocation = TransmogUtil.GetTransmogLocation("HEADSLOT", Enum.TransmogType.Appearance, Enum.TransmogModification.Main);
		BetterWardrobeCollectionFrame.ItemsCollectionFrame:SetActiveSlot(transmogLocation);
		--BetterWardrobeCollectionFrame.ItemsCollectionFrame:SetActiveSlot("HEADSLOT", Enum.TransmogType.Appearance)
		BetterWardrobeCollectionFrame.ItemsCollectionFrame:RefreshVisualsList()
		BetterWardrobeCollectionFrame.ItemsCollectionFrame:UpdateItems()
		BetterWardrobeCollectionFrame.ItemsCollectionFrame.SlotsFrame:SetShown(not toggleState and not atTransmogrifier)
		--WardrobeCollectionFrameWeaponDropDown:SetShown(not toggleState)
		self.CollectionListTitle:SetShown(toggleState)
		local listcount = CollectionList:ListCount("item")
		self.CollectionListHelpText:SetShown(toggleState and listcount == 0)
		self.SlotsFrame:SetShown(toggleState)
	end
end


function BetterWardrobeSetsCollectionListMixin:SetTitle()
	self.CollectionListTitle.Name:SetText(L["Collection List"])
	self.CollectionListHelpText.Name:SetText(L["COLLECTION_LIST_HELP"])
end


function addon.Init:BuildCollectionList()
	CollectionList:AddMogItData()
	CollectionList:CreateDropdown()
end


local spacingNoSmallButton = 2;
local spacingWithSmallButton = 12;
local defaultSectionSpacing = 24;
local shorterSectionSpacing = 19;

function addon:GetActiveCategory()
	return CollectionList.Category
end


function addon:IsWeaponCat()
	return BW_CollectionListButton.ToggleState and CollectionList.Category and CollectionList.Category > 100
end


local catchAll = TransmogUtil.GetTransmogLocation("HEADSLOT", Enum.TransmogType.Appearance, Enum.TransmogModification.Main)
--function WardrobeItemsCollectionMixin:SetActiveSlot(transmogLocation, category, ignorePreviousSlot)
local function slotOnClick(self, transmogLocation)
	local slotButtons = self.parent.Buttons
	for i = 1, #slotButtons do
		local button = slotButtons[i]
		button.SelectedTexture:SetShown(button.transmogLocation:IsEqual(self.transmogLocation))
	end


	if self.transmogLocation:IsAppearance() then
		CollectionList.Category = transmogLocation and self.transmogLocation:GetArmorCategoryID() or self.transmogLocation:GetSlotID() + 100
		CollectionList.showAll = false
		BetterWardrobeCollectionFrame.ItemsCollectionFrame:ChangeModelsSlot(transmogLocation);
	else 

		CollectionList.Category = catchAll and catchAll:GetArmorCategoryID()
		BetterWardrobeCollectionFrame.ItemsCollectionFrame:ChangeModelsSlot(catchAll);
		CollectionList.showAll = true
	end

	CloseDropDownMenus()
	BW_CloseDropDownMenus()
	PlaySound(SOUNDKIT.UI_TRANSMOG_GEAR_SLOT_CLICK);
	BetterWardrobeCollectionFrame.ItemsCollectionFrame:RefreshVisualsList()
	BetterWardrobeCollectionFrame.ItemsCollectionFrame:UpdateItems()
end


function BetterWardrobeSetsCollectionListMixin:CreateSlotButtons()
	local slots = { "head", "shoulder", "back", "chest", "shirt", "tabard", "wrist",  "hands", "waist", "legs", "feet",  "mainhand", "secondaryhand" }
	local parentFrame = self.SlotsFrame;
	local lastButton;
	local xOffset = spacingNoSmallButton;

	local button = CreateFrame("BUTTON", nil, parentFrame, "WardrobeSlotButtonTemplate");
	button:SetSize(40,40)
	button.NormalTexture:ClearAllPoints()
	button.NormalTexture:SetAllPoints()
	button.NormalTexture:SetAtlas("transmog-nav-slot-enchant", false);
	button.transmogLocation = TransmogUtil.GetTransmogLocation("MAINHANDSLOT", Enum.TransmogType.Illusion, Enum.TransmogModification.Main)
	button.parent = parentFrame
	button.SelectedTexture:SetShown(true)

	button:SetPoint("TOPLEFT");
	button:SetScript("OnEnter", function(button) 	GameTooltip:SetOwner(button, "ANCHOR_RIGHT");
	GameTooltip:SetText(L["View All"]);end)
	button:SetScript("OnClick", function(button)  slotOnClick(button, button.transmogLocation) end)
	lastButton = button

	for i = 1, #slots do
		local value = tonumber(slots[i]);
		if ( value ) then
			-- this is a spacer
			xOffset = value;
		else
			local slotString = slots[i];
			local button = CreateFrame("BUTTON", nil, parentFrame, "WardrobeSlotButtonTemplate");
			button.NormalTexture:SetAtlas("transmog-nav-slot-"..slotString, true);
			if ( lastButton ) then
				button:SetPoint("LEFT", lastButton, "RIGHT", xOffset, 0);
			else
				button:SetPoint("TOPLEFT");
			end
			button.slot = string.upper(slotString).."SLOT";
			xOffset = spacingNoSmallButton;
			lastButton = button;
			button.parent = parentFrame
			button.transmogLocation = TransmogUtil.GetTransmogLocation(button.slot, button.transmogType, button.modification);
			button:SetScript("OnClick", function(button )  slotOnClick(button , button.transmogLocation) end)
		end
	end
end



function CollectionList:Dropdown_OnClick(arg1, arg2, checked)
		CollectionList:SelectedCollectionList(arg1)
		--BW_UIDropDownMenu_SetSelectedID(BW_CollectionList_Dropdown, arg1)
		BetterWardrobeCollectionFrame.ItemsCollectionFrame:RefreshVisualsList()
		BetterWardrobeCollectionFrame.ItemsCollectionFrame:UpdateItems()
end

local MogItKey
function CollectionList:Dropdown_Initialize(frame, level, menuList)
	local list = addon.collectionListDB.profile.lists
	local info = BW_UIDropDownMenu_CreateInfo()

	for i, data in pairs(list) do
		 info.func = CollectionList.Dropdown_OnClick
		 info.text, info.arg1 = data.name, i
		 info.value = i
		 info.checked = false
		  BW_UIDropDownMenu_AddButton(info)
		if i == CollectionList:SelectedCollectionList() then
			--BW_UIDropDownMenu_SetSelectedValue(self, data.name)
		end
	end

	if MogItLoaded then 
		
		--key["MOGIT"] = "MogIt Wishlist"
		--local info = BW_UIDropDownMenu_CreateInfo()
		info.func = CollectionList.Dropdown_OnClick
		info.text, info.arg1 = "MogIt Wishlist", #list + 1
		info.checked = false
		MogItKey = info.arg1

		BW_UIDropDownMenu_AddButton(info)
	end
end


--Dropdownmenu for the Collection List
function CollectionList:CreateDropdown()
	BW_CollectionList_Dropdown = CreateFrame("Frame", "BW_CollectionList_Dropdown", BW_ColectionListFrame, "BW_UIDropDownMenuTemplate")

	--BW_CollectionList_Dropdown = BW_UIDropDownMenu_Create("BW_CollectionList_Dropdown", BW_ColectionListFrame)
	BW_CollectionList_Dropdown:SetPoint("BOTTOM", -80, 15)
	local level = BW_ColectionListFrame:GetFrameLevel()
	BW_CollectionList_Dropdown:SetFrameLevel(level+1)
	--BW_UIDropDownMenu_SetWidth(BW_CollectionList_Dropdown, 157) -- Use in place of dropDown:SetWidth
-- Bind an initializer function to the dropdown; see previous sections for initializer function examples.
	BW_UIDropDownMenu_Initialize(BW_CollectionList_Dropdown, CollectionList.Dropdown_Initialize)
	BW_UIDropDownMenu_SetText(BW_CollectionList_Dropdown, "")

	BW_UIDropDownMenu_SetSelectedID(BW_CollectionList_Dropdown, CollectionList:SelectedCollectionList())

	BW_ColectionListFrame.dropdownFrame = BW_CollectionList_Dropdown

	--"BW_CollectionListOptionsButton"
	local button = CreateFrame("Button", "BW_CollectionListOptionsButton", BW_CollectionList_Dropdown, "SquareIconButtonTemplate")
	button:SetSize(30,30)
		button:SetPoint("LEFT", "BW_CollectionList_DropdownButton", "RIGHT", 1, -2)
		button.Icon:SetTexture("Interface\\Buttons\\UI-OptionsButton")
		button.Icon:SetSize(15,15)
		button:SetScript("OnClick", function(button) CollectionList:OptionButton_OnClick(button) end)
					--	BW_DressingRoomButton_OnEnter(self, "Settings")
					--</OnEnter>
end


local action
function CollectionList:OptionButton_OnClick(button)
	local  ContextMenu = addon.ContextMenu
	local Profile = addon.Profile
	local name  = addon.QueueList[3]
	local disable = CollectionList:SelectedCollectionList() == "MOGIT"
	local contextMenuData = {
		{
			text =  L["Add List"],
			func = function()
				action = "add"
				BetterWardrobeOutfitFrameMixin:ShowPopup("BW_NAME_COLLECTION")
			end,
			isNotRadio = true,
			notCheckable = true,
		},
		{
			text = L["Rename"],
			func = function() 
				action = "rename"
				BetterWardrobeOutfitFrameMixin:ShowPopup("BW_NAME_COLLECTION")
			end,
			isNotRadio = true,
			notCheckable = true,
			disabled = disable,
		},
		{
			text = L["Delete"],
			func = function()
				CollectionList:DeleteList()
			end,
			isNotRadio = true,
			notCheckable = true,
			disabled = disable,
		},
		{
			text = L["Add by Item ID"],
			func = function()
				BetterWardrobeOutfitFrameMixin:ShowPopup("BETTER_WARDROBE_COLLECTIONLIST_ITEM_POPUP")
			end,
			isNotRadio = true,
			notCheckable = true,
			disabled = disable,
		},
	}

	BW_UIDropDownMenu_SetAnchor(ContextMenu, 0, 0, "BOTTOMLEFT", button, "BOTTOMLEFT")
	BW_EasyMenu(contextMenuData, ContextMenu, ContextMenu, 0, 0, "MENU")	
end


function CollectionList:AddMogItData()
	MogItLoaded = true --IsAddOnLoaded("MogIt")
	 if not MogItLoaded and CollectionList:SelectedCollectionList() == "MOGIT" then 
	 	CollectionList:SelectedCollectionList(1)
	 end
end


function CollectionList:AddList(name)
	if not name then return false end

	local profile = addon.collectionListDB.profile
	local default = {item = {}, set = {}, extraset = {}, name = name}
	tinsert(profile.lists, default)
	local list = CollectionList:SelectedCollectionList(#profile.lists)
	BetterWardrobeCollectionFrame.ItemsCollectionFrame:RefreshVisualsList()
	BetterWardrobeCollectionFrame.ItemsCollectionFrame:UpdateItems()

	return true
end


function CollectionList:RenameList(name)
	if not name then return false end

	local profile = addon.collectionListDB.profile
	local list = CollectionList:CurrentList()
	list.name = name
	BW_CollectionList_DropdownText:SetText(list.name)
	return true
end


function CollectionList:DeleteList()
	local profile = addon.collectionListDB.profile
	if #profile.lists == 1 then 
		--Error cant delete last list
		return false 
	end
	tremove(profile.lists, CollectionList:SelectedCollectionList())
	CollectionList:SelectedCollectionList(1)
	BetterWardrobeCollectionFrame.ItemsCollectionFrame:RefreshVisualsList()
	BetterWardrobeCollectionFrame.ItemsCollectionFrame:UpdateItems()
	return true
end


function CollectionList:IsInList(itemID, itemType, full)
	itemType = itemType or "item"
	if full then
		local profile = addon.collectionListDB.profile.lists
		local count = 0

		for i, data in ipairs(profile) do
			local collectionList = profile[i]
			if not collectionList then return end
			local isInList = collectionList[itemType][itemID]
			if isInList then count = count + 1 end
		end
		return count ~= 0, count
	else
		local collectionList = addon.CollectionList:CurrentList()
		xxx= collectionList
		local isInList = collectionList[itemType][itemID] or false
		return isInList	
	end
end




--[[	if Wow.IsAddonEnabled("TheUndermineJournal") and TUJMarketInfo then
		local function GetTUJPrice(itemLink, arg)
			local data = TUJMarketInfo(itemLink)
			return data and data[arg] or nil
		end
]]
function CollectionList:ListCount(type)
	local list = CollectionList:CurrentList()[type]
	local counter = 0
	for i in pairs(list) do
		counter = counter +1
	end
	return counter
end


function CollectionList:CurrentList()
	local selectedList = CollectionList:SelectedCollectionList()
	if selectedList == MogItKey then 
		return addon.MogIt.GetMogitWishlist()
	else
		return addon.collectionListDB.profile.lists[selectedList]
	end
end


--Returns selected list and  sets list if value is included
function CollectionList:SelectedCollectionList(value)
	if value then 
		addon.collectionListDB.profile.selectedCollectionList = value
		BW_UIDropDownMenu_SetSelectedID(BW_CollectionList_Dropdown, value)
		local list = CollectionList:CurrentList()
		if not list then return end
		BW_CollectionList_DropdownText:SetText(list.name)

	end

	return addon.collectionListDB.profile.selectedCollectionList
end


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
	scrollcontainer:SetHeight(f.frame:GetHeight()-75)
	scrollcontainer:SetLayout("Fill") -- important!
	f:AddChild(scrollcontainer)

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
				scroll:AddChild(Heading)
			end
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
	CheckBox:DisableButton(true)
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

function CollectionListTooltip_OnEnter(self)
						GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
						GameTooltip:SetText(L["Click: Show Collection List"])
						GameTooltip:AddLine(L["Shift Click: Show Detail List"])
						GameTooltip:Show()
					end

BW_CollectionListDropDownMixin = {}

--BW_DressingRoomMixin

function BW_CollectionListDropDownMixin:OnLoad()
	local button = _G[self:GetName().."Button"]
	button:Hide()
end


StaticPopupDialogs["BETTER_WARDROBE_COLLECTIONLIST_ITEM_POPUP"] = {
	text = L["Type the item ID in the text box below"],
	preferredIndex = 3,
	button1 = ADD,
	button2 = CANCEL,
	hasEditBox = true,
	maxLetters = 512,
	editBoxWidth = 260,
	OnShow = function() if LISTWINDOW then LISTWINDOW:Hide() end end,
	OnAccept = function(self)

		local itemID = self.editBox:GetText()
		if not itemID then  return false end
		local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(tonumber(itemID))
		if not appearanceID then return false end

		CollectionList:UpdateList("item", appearanceID, true)
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

StaticPopupDialogs["BW_NAME_COLLECTION"] = {
	preferredIndex = 3,
	text = L["List Name"],
	button1 = SAVE,
	button2 = CANCEL,
	OnAccept = function(self)
		local name = self.editBox:GetText()
		if action == "add" then 
			CollectionList:AddList(name)
		elseif action == "rename" then 
			CollectionList:RenameList(name)
		end
		action = nil
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	hasEditBox = 1,
	maxLetters = 31,
	OnShow = function(self)
		self.button1:Disable()
		self.button2:Enable()
		self.editBox:SetFocus()
	end,
	OnHide = function(self)
		self.editBox:SetText("")
	end,
	EditBoxOnEnterPressed = function(self)
		if (self:GetParent().button1:IsEnabled()) then
			StaticPopup_OnClick(self:GetParent(), 1)
		end
	end,
	EditBoxOnTextChanged = function (self)
		local parent = self:GetParent()
		if (parent.editBox:GetText() ~= "") then
			parent.button1:Enable()
		else
			parent.button1:Disable()
		end
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide()
	end
}

