--	///////////////////////////////////////////////////////////////////////////////////////////
--
--	Better Wardrobe and Collection
--	Author: SLOKnightfall

--	Wardrobe and Collection: Adds additional functionality and sets to the transmog and collection areas
--

--

--	///////////////////////////////////////////////////////////////////////////////////////////

local addonName, addon = ...
---addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
--_G[addonName] = {}
addon.Frame = LibStub("AceGUI-3.0")
addon.itemSourceID = {}
addon.QueueList = {}
addon.validSetCache = {}
addon.usableSourceCache = {}
addon.Init = {}
local newTransmogInfo  = {["latestSource"] = NO_TRANSMOG_SOURCE_ID} --{[99999999] = {[58138] = 10}, }
addon.TRANSMOG_SET_FILTER = {}

local playerInv_DB
local Profile
local playerNme
local realmName

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

--ACE3 Option Handlers
local optionHandler = {}
function optionHandler:Setter(info, value)
	Profile[info[#info]] = value

	if info.arg == "tooltipRotate" then
		addon.tooltip.rotate:SetShown(value);	
	elseif info.arg == "tooltipWidth" then
		addon.tooltip:SetWidth(value);
	elseif info.arg == "tooltipHeight" then
		addon.tooltip:SetHeight(value);
	elseif info.arg == "DR_Width" then
		DressUpFrame:SetWidth(value);
	elseif info.arg == "DR_Height" then
		DressUpFrame:SetHeight(value)

	elseif info.arg == "ShowAdditionalSourceTooltips" then
		C_TransmogCollection.SetShowMissingSourceInItemTooltips(value);
	end
end


function optionHandler:Getter(info)
	return Profile[info[#info]]
end


function optionHandler:TSMDisable(info)
	return not IsAddOnLoaded("TradeSkillMaster")
end


function optionHandler:TSMSources(info)
	local sources = {}
	local table = {}
	if (IsAddOnLoaded("TradeSkillMaster")) then
		TSM_API.GetPriceSourceKeys(sources)
	end

	return sources
end


function optionHandler:TSM_MarketGetter(info)
	if Profile[info[#info]] == "DBMarket" then
		local table = optionHandler:TSMSources(info)
		for i, name in ipairs(table) do
			if name == "DBMarket" then
				Profile[info[#info]] = i
				break
			end	
		end
	end

	return optionHandler:Getter(info)
end


--ACE3 Options Constuctor
local options = {
	name = "BetterWardrobe",
	handler = optionHandler,
	get = "Getter",
	set = "Setter",
	type = 'group',
	childGroups = "tab",
	inline = true,
	args = {
		settings={
			name = "Options",
			type = "group",
			--inline = true,
			order = 0,
			args={
				general_settings={
					name = " ",
					type = "group",
					inline = true,
					order = 1,
					args={
						Options_Header = {
							order = 1,
							name = L["General Options"],
							type = "header",
							width = "full",
						},
						ShowCollectionUpdates = {
							order = 2,
							name = L["Print Set Collection alerts to chat:"],
							type = "toggle",
							width = 1.3,
						},
						ShowSetCollectionUpdates = {
							order = 3,
							name = L["Sets"],
							type = "toggle",
							width = .5,
							disabled = function() return not addon.Profile.ShowCollectionUpdates end,
						},
						ShowExtraSetsCollectionUpdates = {
							order = 4,
							name = L["Extra Sets"],
							type = "toggle",
							width = .6,
							disabled = function() return not addon.Profile.ShowCollectionUpdates end,
						},
						ShowCollectionListCollectionUpdates = {
							order = 5,
							name = L["Collection List"],
							type = "toggle",
							width = .7,
							disabled = function() return not addon.Profile.ShowCollectionUpdates end,
						},
						TSM_Market = {
							order = 6,
							name = L["TSM Source to Use"],
							--desc = "TSM Source to get price data.",
							type = "select",
							get = "TSM_MarketGetter",
							set = "Setter",
							width = "double",
							values = "TSMSources",
							disabled = "TSMDisable",
						}, 
					},
				},
				transmog_settings={
					name = " ",
					type = "group",
					inline = true,
					order = 2,
					args={
						Options_Header_3 = {
							order = 1,
							name = L["Transmog Vendor Window"],
							type = "header",
							width = "full",
						},
						ShowIncomplete = {
							order = 2,
							name = L["Show Incomplete Sets"],
							type = "toggle",
						},
						ShowHidden = {
							order = 3,
							name = L["Show Items set to Hidden"],
							type = "toggle",
							width = 1.6,
						},
						HideMissing = {
							order = 4,
							name = L["Hide Missing Set Pieces at Transmog Vendor"],
							type = "toggle",
							width = "full",
						},
						HiddenMog = {
							order = 5,
							name = L["Use Hidden Transmog for Missing Set Pieces"],
							type = "toggle",
							width = "full",
						},
						PartialLimit = {
							order = 6,
							name = L["Required pieces"],
							type = "range",
							width = "full",
							min = 1,
							max = 8,
							step = 1,
						},
						ShowNames = {
							order = 7,
							name = L["Show Set Names"],
							type = "toggle",
						},
						ShowSetCount = {
							order = 8,
							name = L["Show Collected Count"],
							type = "toggle",
						},
					},
				},
				tooltip_settings={
					name = " ",
					type = "group",
					inline = true,
					order = 3,
					args={
						Tooltip_Header = {
							order = 1,
							name = L["Tooltip Options"],
							type = "header",
							width = "full",
						},
						ShowTooltips = {
							order = 2,
							name = L["Show Set Info in Tooltips"],
							type = "toggle",
							width = 1.2,
						},
						ShowSetTooltips = {
							order = 3,
							name = L["Sets"],
							type = "toggle",
							width = .5,
							disabled = function() return not addon.Profile.ShowTooltips end,
						},
						ShowExtraSetsTooltips = {
							order = 4,
							name = L["Extra Sets"],
							type = "toggle",
							width = .6,
							disabled = function() return not addon.Profile.ShowTooltips end,
						},
						ShowCollectionListTooltips = {
							order = 5,
							name = L["Collection List"],
							type = "toggle",
							width = .7,
							disabled = function() return not addon.Profile.ShowTooltips end,
						},
						ShowDetailedListTooltips = {
							order = 6,
							name = L["Show Set Collection Details"],
							type = "toggle",
							width = "full",
							disabled = function() return not addon.Profile.ShowTooltips end,
						},
						ShowDetailedListTooltips = {
							order = 6,
							name = L["Show Set Collection Details"],
							type = "toggle",
							width = 1.2,
							disabled = function() return not addon.Profile.ShowTooltips end,
						},
						ShowMissingDetailedListTooltips = {
							order = 6.1,
							name = L["Only List Missing Pieces"],
							type = "toggle",
							width = 1.6,
							disabled = function() return not addon.Profile.ShowTooltips or not addon.Profile.ShowDetailedListTooltips  end,
						},
						ShowItemIDTooltips = {
							order = 7,
							name = L["Show Item ID"],
							type = "toggle",
							width = "full",
						},
						ShowOwnedItemTooltips = {
							order = 8,
							name = L["Show if appearance is known"],
							type = "toggle",
							width = 1.2,
						},
						ShowAdditionalSourceTooltips = {
							order = 9,
							name = L["Show if additional sources are available"],
							type = "toggle",
							width = 1.6,
							arg = "ShowAdditionalSourceTooltips"
						},
					},
				},				
				preview_settings={
						name = " ",
						type = "group",
						inline = true,
						order = 4,
						disabled = function() return not addon.Profile.TooltipPreview_Show end,
						args={
							Options_Header_2 = {
							order = 0,
							name = L["Item Preview Options"],
							type = "header",
							width = "full",
						},
							TooltipPreview_Show = {
								order = 1,
								name = L["Appearance Preview"],
								type = "toggle",
								width = 1.2,
								disabled = false,
							},
							TooltipPreview_Modifier = {
								type = "select",
								order =2,
								name = L["Only show if modifier is pressed"],
								values = function()
											local tbl = {
												None = "None",
											};
											for k,v in pairs(addon.Globals.mods) do
												tbl[k] = k;
											end
											return tbl;
										end,
							},
							TooltipPreview_Dress = {
								order = 3,
								name = L["Dress Preview Model"],
								type = "toggle",
								width = "full",
							},
							TooltipPreview_DressingDummy = {
								order = 3.1,
								name = L["Use Dressing Dummy Model"],
								type = "toggle",
								width = "full",
							},
							TooltipPreview_MogOnly = {
								type = "toggle",
								order =3.1,
								name = L["Only transmogrification items"],
								width = "full",
							},
							TooltipPreviewRotate = {
								order = 4,
								name = L["Auto Rotate"],
								type = "toggle",
								width = 1,
								arg = "tooltipRotate",
							},
							TooltipPreview_MouseRotate = {
								type = "toggle",
								order = 5,
								name = L["Rotate with mouse wheel"],
								width = 1.6,
							},
							TooltipPreview_Anchor = {
								type = "select",
								order = 5.01,
								name = L["Anchor point"],
								values = {
									vertical = "Top/bottom",
									horizontal = "Left/right",
								},
							},
							TooltipPreview_Width = {
								type = "range",
								order = 6,
								name = L["Width"],
								step = 1,
								min = 100,
								max = 500,
								arg = "tooltipWidth",
							},
							TooltipPreview_Height = {
								type = "range",
								order = 7,
								name = L["Height"],
								step = 1,
								min = 100,
								max = 500,
								arg = "tooltipHeight",
							},
							TooltipPreview_CustomModel = {
								type = "toggle",
								order = 9,
								name = L["Use custom model"],
								width = "full",
							},
							TooltipPreview_CustomRace = {
								type = "select",
								order = 10,
								name = L["Model race"],
								values = {
									[1] =  C_CreatureInfo.GetRaceInfo(1).raceName, --LBR["Human"],
									[3] = C_CreatureInfo.GetRaceInfo(3).raceName,--["Dwarf"],
									[4] = C_CreatureInfo.GetRaceInfo(4).raceName,--["Night Elf"],
									[7] = C_CreatureInfo.GetRaceInfo(7).raceName,--["Gnome"],
									[11] = C_CreatureInfo.GetRaceInfo(11).raceName,--["Draenei"],
									[22] = C_CreatureInfo.GetRaceInfo(22).raceName, --["Worgen"],
									[2] = C_CreatureInfo.GetRaceInfo(2).raceName, --["Orc"],
									[5] = C_CreatureInfo.GetRaceInfo(5).raceName,--["Undead"],
									[6] = C_CreatureInfo.GetRaceInfo(6).raceName, --["Tauren"],
									[8] = C_CreatureInfo.GetRaceInfo(8).raceName, --["Troll"],
									[10] = C_CreatureInfo.GetRaceInfo(10).raceName, --["Blood Elf"],
									[9] = C_CreatureInfo.GetRaceInfo(9).raceName, --["Goblin"],
									[24] = C_CreatureInfo.GetRaceInfo(24).raceName, --["Pandaren"],
								},
								disabled = function() return not addon.Profile.TooltipPreview_CustomModel or not addon.Profile.ShowTooltipPreview end,
								width = 1.2,
							},
							TooltipPreview_CustomGender = {
								type = "select",
								order =11,
								name = L["Model gender"],
								values = {
									[0] = MALE,
									[1] = FEMALE,
								},
								disabled = function() return not addon.Profile.TooltipPreview_CustomModel or not addon.Profile.ShowTooltipPreview end,
								width = 1.2,
							},
						},
				},
				dressingroom_settings={
					name = " ",
					type = "group",
					inline = true,
					order = 5,
					args={
						Options_Header_2 = {
							order = 1,
							name = L["Dressing Room Options"],
							type = "header",
							width = "full",
						},
						DR_ShowItemButtons = {
							order = 2,
							name = L["Show Item Buttons"],
							type = "toggle",

						},
						DR_ShowControls = {
							order = 3,
							name = L["Show DressingRoom Controls"],
							type = "toggle",
							width = 1.5,
						},
						DR_DimBackground = {
							order = 4,
							name = L["Dim Backround Image"],
							type = "toggle",
						},
						DR_HideBackground = {
							order = 5,
							name = L["Hide  Backround Image"],
							type = "toggle",
							width = 1.5,
						},
						DR_StartUndressed = {
							order = 6,
							name = L["Start Undressed"],
							type = "toggle",
							width = "full",
						},
						DR_HideWeapons = {
							order = 7,
							name = L["Hide Weapons"],
							type = "toggle",
						},
						DR_HideShirt = {
							order = 8,
							name = L["Hide Shirt"],
							type = "toggle",
						},
						DR_HideTabard = {
							order = 9,
							name = L["Hide Tabard"],
							type = "toggle",
						},
						DR_Width = {
								type = "range",
								order = 10,
								name = L["Width"],
								step = 1,
								min = 300,
								max = 1000,
								arg = "DR_Width",
							},
							DR_Height = {
								type = "range",
								order = 11,
								name = L["Height"],
								step = 1,
								min = 300,
								max = 1000,
								arg = "DR_Height",

							},
							DR_ScaleReset = {
								type = "execute",
								order = 112,
								name = L["Reset"],
								func = function() DressUpFrame:SetWidth(450)
								;	DressUpFrame:SetHeight(545) 
								addon.Profile.DR_Width = 450
								addon.Profile.DR_Height = 545
								end,


							},
					},
				},

			},
		},
	},
}

--ACE Profile Saved Variables Defaults
local defaults = {
	profile = {
		['*'] = true,
		PartialLimit = 4,
		ShowHidden = false,
		TSM_Market = "DBMarket",
		DR_HideBackground = false,
		TooltipPreview_Width = 300,
		TooltipPreview_Height = 300,
		DR_Width = 450,
		DR_Height = 545,
		ShowItemIDTooltips = false,
		TooltipPreview_Show = false,
		TooltipPreview_Anchor = "vertical",
		TooltipPreviewRotate = false,
		TooltipPreview_Modifier = "None",
		TooltipPreview_CustomRace = 1,
		TooltipPreview_CustomGender = 0,
		TooltipPreview_DressingDummy = false, 
	}
}

local char_defaults = {
	profile = {
		item = {},
		set = {},
		extraset = {},
		favorite = {},
		outfits = {},
		lastTransmogOutfitIDSpec = {},
		collectionList = {item = {}, set = {}, extraset = {},},
	}
}

---Updates Profile after changes
function addon:RefreshConfig()
	addon.Profile = self.db.profile
	Profile = addon.Profile
end


---Updates Profile after changes
function addon:RefreshCharConfig()
	--addon.Profile = self.db.profile
	--Profile = addon.Profile
end


local BASE_SET_BUTTON_HEIGHT = addon.Globals.BASE_SET_BUTTON_HEIGHT
local VARIANT_SET_BUTTON_HEIGHT = addon.Globals.VARIANT_SET_BUTTON_HEIGHT
local SET_PROGRESS_BAR_MAX_WIDTH = addon.Globals.SET_PROGRESS_BAR_MAX_WIDTH
local IN_PROGRESS_FONT_COLOR =addon.Globals.IN_PROGRESS_FONT_COLOR
local IN_PROGRESS_FONT_COLOR_CODE = addon.Globals.IN_PROGRESS_FONT_COLOR_CODE
local COLLECTION_LIST_WIDTH = addon.Globals.COLLECTION_LIST_WIDTH


local f = CreateFrame("Frame",nil,UIParent)
f:SetHeight(1)
f:SetWidth(1)
f:SetPoint("TOPLEFT", UIParent, "TOPRIGHT")
f.model = CreateFrame("DressUpModel",nil), UIParent
f.model:SetPoint("CENTER", UIParent, "CENTER")
f.model:SetHeight(1)
f.model:SetWidth(1)
f.model:SetModelScale(1)
f.model:SetAutoDress(false)
f.model:SetUnit("PLAYER")
addon.frame = f

---Ace based addon initilization
function addon:OnInitialize()

end


function addon:OnEnable()
	self.db = LibStub("AceDB-3.0"):New("BetterWardrobe_Options", defaults, true)
	options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	options.args.profiles.name = L["Profiles - Options Settings"]

	self.chardb = LibStub("AceDB-3.0"):New("BetterWardrobe_CharacterData", char_defaults)
	options.args.charprofiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.chardb)
	options.args.charprofiles.name = L["Profiles - Collection Settings"]

	LibStub("AceConfigRegistry-3.0"):ValidateOptionsTable(options, addonName)
	LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, options)

	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BetterWardrobe", "BetterWardrobe")
	self.db.RegisterCallback(addon, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(addon, "OnProfileCopied", "RefreshConfig")
	self.db.RegisterCallback(addon, "OnProfileReset", "RefreshConfig")	
	--WardrobeTransmogFrameSpecDropDown_Initialize()

	--BWData = BWData or {}

	addon.Profile = self.db.profile
	Profile = addon.Profile

		addon.Init:BuildDB()
		addon.Init:Blizzard_Wardrobe()
	C_Timer.After(0.2, function()
		
		addon.Init:BuildUI()
		addon.Init:BuildTooltips()
		addon.Init:DressingRoom()
		addon.SetSortOrder(false)
	
	
	WardrobeFilterDropDown_OnLoad(WardrobeCollectionFrame.FilterDropDown)
	--WardrobeCollectionFrame.ItemsCollectionFrame:SetActiveSlot
end )
	self:SecureHook(WardrobeCollectionFrame.ItemsCollectionFrame,"SetActiveSlot")
	self:SecureHook(WardrobeCollectionFrame.ItemsCollectionFrame,"UpdateItems")
	self:Hook(C_TransmogSets,"SetIsFavorite",function()
		C_Timer.After(0, function()
			WardrobeCollectionFrame.SetsCollectionFrame.ScrollFrame:Update()
			WardrobeCollectionFrame.SetsCollectionFrame:OnSearchUpdate()
		end)
	end, true)

	f:RegisterEvent("TRANSMOG_COLLECTION_SOURCE_ADDED")
	f:RegisterEvent("TRANSMOG_COLLECTION_SOURCE_REMOVED")
	f:SetScript("OnEvent", function (self,  ...)BetterWardrobeSetsCollectionMixin:OnEvent(...) end)
	--self:SecureHook(WardrobeOutfitDropDown,"OnUpdate")

		--WardrobeOutfi--tDropDownButton:SetScript("OnMouseDown", function(self)
					--	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
						--BW_WardrobeOutfitFrame:Toggle(self:GetParent())
						--end
				--	)
end


function addon:SetActiveSlot()
	if BW_WardrobeCollectionFrame.activeFrame ~= WardrobeCollectionFrame.ItemsCollectionFrame then
		BW_WardrobeCollectionFrame_SetTab(1)
		--PanelTemplates_ResizeTabsToFit(WardrobeCollectionFrame, TABS_MAX_WIDTH)
	end
end


function addon:UpdateItems(self)
	for i = 1, self.PAGE_SIZE do
		local model = self.Models[i]
		local setID = (model.visualInfo and model.visualInfo.visualID) or model.setID
		local isHidden = addon.chardb.profile.item[setID]
		model.CollectionListVisual.Hidden.Icon:SetShown(isHidden)
		local isInList = addon.chardb.profile.collectionList["item"][setID]
		model.CollectionListVisual.Collection.Collection_Icon:SetShown(isInList)
		model.CollectionListVisual.Collection.Collected_Icon:SetShown(isInList and model.visualInfo and model.visualInfo.isCollected)
	end
end


function addon.GetItemSource(itemID, itemMod)
	--if addon.ArmorSetModCache[itemID] and addon.ArmorSetModCache[itemID][itemMod] then return nil, addon.ArmorSetModCache[itemID][itemMod] end
		local itemSource
		local visualID, sourceID
		if itemMod then
			visualID, sourceID = C_TransmogCollection.GetItemInfo(itemID, itemMod)
		else
			visualID, sourceID = C_TransmogCollection.GetItemInfo(itemID)
		end

		if not sourceID then
			local itemlink = "item:"..itemID..":0"
			f.model:Show()
			f.model:Undress()
			f.model:TryOn(itemlink)
			for i = 1, 19 do
				local source = f.model:GetSlotTransmogSources(i)
				if source ~= 0 then
					--addon.itemSourceID[itemID] = source
					sourceID = source
					break
				end
			end
		end

		if not sourceID then 
			visualID, sourceID = C_TransmogCollection.GetItemInfo(itemID, 0)
		end

	--[[		if sourceID and itemMod then
						addon.modArmor[itemID] = addon.modArmor[itemID] or {}
						addon.modArmor[itemID][itemMod] = sourceID
					end]]

		f.model:Hide()
	return visualID ,sourceID
end


function addon.GetSetsources(setID)
	local setInfo = addon.GetSetInfo(setID)
	local setSources = {}
	local atTransmogrifier = WardrobeFrame_IsAtTransmogrifier()

	if BW_WardrobeCollectionFrame.selectedTransmogTab == 4 or BW_WardrobeCollectionFrame.selectedCollectionTab == 4 then
		if setInfo.sources then
			for i, sourceID in ipairs(setInfo.sources) do	
				if sourceID then
					local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)

					local sources = sourceInfo and C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)
					if sources then
						if #sources > 1 then
							WardrobeCollectionFrame_SortSources(sources)
						end

						setSources[sourceID] = sources[1].isCollected--and sourceInfo.isCollected
					else
						setSources[sourceID] = false
					end
				end
			end
		end

	elseif setInfo.sources then
		for itemID, visualID in pairs(setInfo.sources) do
			local sources =  C_TransmogCollection.GetAppearanceSources(visualID)
			local sourceID, _

			if not sources then 
				_, sourceID = addon.GetItemSource(itemID, setInfo.mod)

				-- Try to generate a source when the item has a
				if not sourceID then
					for i = 0, 4 , 1 do
						_, sourceID = addon.GetItemSource(itemID, setInfo.mod)

						if sourceID then 
							break
						end
					end
				end

				local sourceInfo = sourceID and C_TransmogCollection.GetSourceInfo(sourceID)
				sources = sourceInfo and C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)
			end

			if sources then
				--items[sources.itemID] = true
				if #sources > 1 then
					WardrobeCollectionFrame_SortSources(sources)
				end
				setSources[sources[1].sourceID] = sources[1].isCollected--and sourceInfo.isCollected
			elseif sourceID then 
				setSources[sourceID] = false
			end
		end

	else
		for i, itemID in ipairs(setInfo.items) do
			local visualID, sourceID = addon.GetItemSource(itemID, setInfo.mod) --C_TransmogCollection.GetItemInfo(itemID)
			-- visualID, sourceID = addon.GetItemSource(itemID,setInfo.mod)
			--local sources = C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)	
			if sourceID then
				local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)

				local sources = sourceInfo and C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)
				if sources then
					if #sources > 1 then
						WardrobeCollectionFrame_SortSources(sources)
					end

					setSources[sourceID] = sources[1].isCollected--and sourceInfo.isCollected

				else
					setSources[sourceID] = false
				end
			end
		end
	end
			--setSources[sourceID] = sourceInfo and sourceInfo.isCollected
	return setSources
end

local EmptyArmor = addon.Globals.EmptyArmor

local Sets = {}
addon.Sets = Sets

function Sets:GetEmptySlots()
	local setInfo = {}

	for i,x in pairs(EmptyArmor) do
	 	setInfo[i]=x
	end

	return setInfo
end


function Sets:EmptySlots(transmogSources)
	local EmptySet = self:GetEmptySlots()

	for i, x in pairs(transmogSources) do
			EmptySet[i] = nil
	end

	return EmptySet
end


function Sets:ClearHidden(setList, type)
	if Profile.ShowHidden then return setList end
	local newSet = {}
	for i, setInfo in ipairs(setList) do
		local itemID = setInfo.setID or setInfo.visualID

		if not addon.chardb.profile[type][itemID] then
			tinsert(newSet, setInfo)
		else
			--print("setInfo.name")
		end
	end
	return newSet
end


function Sets.isMogKnown(sourceID)
	local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
	
	if not sourceInfo then return false end
	
	local slotSources = C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)

	local slotColected
	--local slotSources = C_TransmogSets.GetSourcesForSlot(setID, slot)
	if slotSources then
		WardrobeCollectionFrame_SortSources(slotSources, sourceInfo.visualID)
		for i,d in ipairs(slotSources) do
			if d.isCollected then slotColected = d.sourceID end
		end
	end

	return slotColected
end


--
local SetsDataProvider = CreateFromMixins(WardrobeSetsDataProviderMixin)
addon.ExtraSetsDataProvider = SetsDataProvider

function SetsDataProvider:SortSets(sets, reverseUIOrder, ignorePatchID)
	addon.SortSet(sets, reverseUIOrder, ignorePatchID)
	--addon.Sort["DefaultSortSet"](self, sets, reverseUIOrder, ignorePatchID)
end


function SetsDataProvider:ClearSets()
	self.baseSets = nil
	self.baseSetsData = nil
	self.variantSets = nil
	self.usableSets = nil
	self.sourceData = nil
	self.savedSetCache = nil
	addon.DefaultUI:ClearSets()
end


local function CheckMissingLocation(set)
--function addon.Sets:GetLocationBasedCount(set)
	local filtered = false
	local invType = {}

	if not set.items then
		local sources = C_TransmogSets.GetSetSources(set.setID)
		for sourceID in pairs(sources) do
			local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
			local sources = sourceInfo and C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)
			if sources then
				if #sources > 1 then
					WardrobeCollectionFrame_SortSources(sources)
				end
			
				if  addon.missingSelection[sourceInfo.invType] and not sources[1].isCollected then

					return true
				elseif addon.missingSelection[sourceInfo.invType] then 
					filtered = true
				end
			end
		end

	else
		for i, itemID in ipairs(set.items) do
			local visualID, sourceID = addon.GetItemSource(itemID, set.mod)	
			if sourceID then
				local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
				local sources = sourceInfo and C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)
				if sources then
					if #sources > 1 then
						WardrobeCollectionFrame_SortSources(sources)
					end
					invType[sourceInfo.invType] = true
--print(addon.missingSelection[sourceInfo.invType])
					if  addon.missingSelection[sourceInfo.invType] and not sources[1].isCollected then
						return true
					elseif addon.missingSelection[sourceInfo.invType] then 
					filtered = true 
					end
				end
			end
		end
	end

	for type, value in pairs(addon.missingSelection) do
		if value and invType[type] then
			filtered = true
		end
	end

	return not filtered
end


local setsByExpansion = {}
local setsByFilter = {}
function SetsDataProvider:FilterSearch(useBaseSet)
	local baseSets
	if useBaseSet then
		baseSets = SetsDataProvider:GetBaseSets()
	else
		baseSets = SetsDataProvider:GetUsableSets()
	end

	if 	BW_WardrobeCollectionFrame.selectedTransmogTab == 4 or BW_WardrobeCollectionFrame.selectedCollectionTab == 4 then
		self.baseSets = baseSets
		return
	end

	local filteredSets = {}
		local searchString = string.lower(WardrobeCollectionFrameSearchBox:GetText())

		for i, data in ipairs(baseSets) do

			local count , total = SetsDataProvider:GetSetSourceCounts(data.setID)
			local collected = count == total
			if ((addon.filterCollected[1] and collected) or
				(addon.filterCollected[2] and not collected)) and
				CheckMissingLocation(data) and
		 		addon.xpacSelection[data.expansionID] and
				addon.filterSelection[data.filter] and
				(searchString and string.find(string.lower(data.name), searchString)) then -- or string.find(baseSet.label, searchString) or string.find(baseSet.description, searchString)then
				tinsert(filteredSets, data)
		end

		self:SortSets(filteredSets)
		if useBaseSet then
				self.baseSets = filteredSets
		else
				self.usableSets = filteredSets
				self.baseSets = baseSets
		end
	
	--else
		--self.baseSets = baseSets
	end
end


function SetsDataProvider:GetBaseSets(baseSet)
	if (baseSet or not self.baseSets) then
		if (BW_WardrobeCollectionFrame.selectedCollectionTab == 4  or BW_WardrobeCollectionFrame.selectedTransmogTab == 4) then
			self.baseSets = addon.GetSavedList()
			self:SortSets(self.baseSets)
		else
			self.baseSets = Sets:ClearHidden(addon.GetBaseList(), "extraset") --C_TransmogSets.GetBaseSets()
			--self:DetermineFavorites()
			self:SortSets(self.baseSets)
		end
	end

	return self.baseSets
end


function SetsDataProvider:GetSetSourceCounts(setID)
	local sourceData = self:GetSetSourceData(setID)
	return sourceData.numCollected, sourceData.numTotal
end


--Lets CanIMogIt plugin get extra sets count
 function addon.GetSetSourceCounts(setID)
	return SetsDataProvider:GetSetSourceCounts(setID)

end


function addon.Sets:GetLocationBasedCount(set)
	local collectedCount = 0
	local totalCount = 0
	local items = {}

	if not set.items then
		local sources = C_TransmogSets.GetSetSources(set.setID)
		for sourceID in pairs(sources) do
			local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
			local sources = sourceInfo and C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)
			if sources then
				if #sources > 1 then
					WardrobeCollectionFrame_SortSources(sources)
				end
			
				if  addon.includeLocation[sourceInfo.invType] then
					totalCount = totalCount + 1

					if sources[1].isCollected then
						collectedCount = collectedCount + 1
					end
				end
			end
		end

	else
		for i, itemID in ipairs(set.items) do
			local visualID, sourceID = addon.GetItemSource(itemID, set.mod)	
			if sourceID then
				local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
				local sources = sourceInfo and C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)
				if sources then
					if #sources > 1 then
						WardrobeCollectionFrame_SortSources(sources)
					end

					if  addon.includeLocation[sourceInfo.invType] then
						totalCount = totalCount + 1

						if sources[1].isCollected then
							collectedCount = collectedCount + 1
						end
					end
				end
			end
		end
	end

	return collectedCount, totalCount
end
--SetsDataProvider:GetSetSourceCounts(data.setID)

function SetsDataProvider:GetUsableSets(incVariants)
	if (not self.usableSets) then
		local availableSets = SetsDataProvider:GetBaseSets()
		local atTransmogrifier = WardrobeFrame_IsAtTransmogrifier()
		local countData

		--Generates Useable Set
		self.usableSets = {} --SetsDataProvider:GetUsableSets()
		for i, set in ipairs(availableSets) do
			local topSourcesCollected, topSourcesTotal
			if addon.Profile.ShowIncomplete then
				topSourcesCollected, topSourcesTotal = addon.Sets:GetLocationBasedCount(set)
			else
				topSourcesCollected, topSourcesTotal = SetsDataProvider:GetSetSourceCounts(set.setID)
			end


			local cutoffLimit = (addon.Profile.ShowIncomplete and ((topSourcesTotal <= Profile.PartialLimit and topSourcesTotal) or  Profile.PartialLimit)) or topSourcesTotal --SetsDataProvider:GetSetSourceCounts(set.setID)
			if (BW_WardrobeToggle.viewAll and BW_WardrobeToggle.VisualMode) or (not atTransmogrifier and BW_WardrobeToggle.VisualMode) or topSourcesCollected >= cutoffLimit  and topSourcesTotal > 0 then --and not C_TransmogSets.IsSetUsable(set.setID) then
				tinsert(self.usableSets, set)
			end

			if incVariants then
				local variantSets = C_TransmogSets.GetVariantSets(set.setID)
				for i, set in ipairs(variantSets) do
					local topSourcesCollected, topSourcesTotal
					if addon.Profile.ShowIncomplete then
						topSourcesCollected, topSourcesTotal = addon.Sets:GetLocationBasedCount(set)
					else
						topSourcesCollected, topSourcesTotal = SetsDataProvider:GetSetSourceCounts(set.setID)
					end

					if topSourcesCollected == topSourcesTotal then set.collected = true end
					--local cutoffLimit = (topSourcesTotal <= Profile.PartialLimit and topSourcesTotal) or Profile.PartialLimit
					if (BW_WardrobeToggle.viewAll and BW_WardrobeToggle.VisualMode) or (not atTransmogrifier and BW_WardrobeToggle.VisualMode) or topSourcesCollected >= cutoffLimit and topSourcesTotal > 0   then --and not C_TransmogSets.IsSetUsable(set.setID) then
						tinsert(self.usableSets, set)
					end
				end
			end

		end
		self:SortSets(self.usableSets)	
	end

	return self.usableSets
end


function SetsDataProvider:GetSetSourceData(setID)
	if (not self.sourceData) then
		self.sourceData = {}
	end

	local sourceData = self.sourceData[setID]
	if (not sourceData) then
		local sources = addon.GetSetsources(setID)
		local numCollected = 0
		local numTotal = 0
		if sources then
			for sourceID, collected in pairs(sources) do
				if (collected) then
					numCollected = numCollected + 1
				end
				numTotal = numTotal + 1
			end

			sourceData = {numCollected = numCollected, numTotal = numTotal, sources = sources }
			self.sourceData[setID] = sourceData
		end
	end
	return sourceData
end


function addon:SetHasNewSources(setID)
	if newTransmogInfo and newTransmogInfo[setID] then
		return true 
	else
		return false
	end
end


function SetsDataProvider:IsBaseSetNew(baseSetID)
	local baseSetData = self:GetBaseSetData(baseSetID)
	if ( not baseSetData.newStatus ) then
		local newStatus = addon:SetHasNewSources(baseSetID);
		baseSetData.newStatus = newStatus;
	end
	return baseSetData.newStatus;
end


function SetsDataProvider:ResetBaseSetNewStatus(baseSetID)
	local baseSetData = self:GetBaseSetData(baseSetID)
	if ( baseSetData ) then
		--newTransmogInfo[baseSetID] = nil
		baseSetData.newStatus = nil;
	end
end


function SetsDataProvider:GetSortedSetSources(setID)
	local returnTable = {}
	local sourceData = self:GetSetSourceData(setID)

	for sourceID, collected in pairs(sourceData.sources) do
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)

		if (sourceInfo) then
			local sortOrder = EJ_GetInvTypeSortOrder(sourceInfo.invType)
			tinsert(returnTable, {sourceID = sourceID, collected = collected, sortOrder = sortOrder, itemID = sourceInfo.itemID, invType = sourceInfo.invType })
		end
	end

	local comparison = function(entry1, entry2)
		if (entry1.sortOrder == entry2.sortOrder) then
			return entry1.itemID < entry2.itemID
		else
			return entry1.sortOrder < entry2.sortOrder
		end
	end

	table.sort(returnTable, comparison)
	return returnTable
end


function SetsDataProvider:GetBaseSetData(setID)
	if (not self.baseSetsData) then
		self.baseSetsData = {}
	end

	if (not self.baseSetsData[setID]) then
		local baseSetID = setID
		if (baseSetID ~= setID) then
			return
		end
		local topCollected, topTotal = self:GetSetSourceCounts(setID)
		local setInfo = {topCollected = topCollected, topTotal = topTotal, completed = (topCollected == topTotal) }
		self.baseSetsData[setID] = setInfo
	end

	return self.baseSetsData[setID]
end



--=========--
-- Extra Sets Trannsmog Collection Model
BetterWardrobeSetsTransmogModelMixin = CreateFromMixins(WardrobeSetsTransmogModelMixin)

function BetterWardrobeSetsTransmogModelMixin:LoadSet(setID)
	local waitingOnData = false
	local transmogSources = {}
	local sources = addon.GetSetsources(setID)
	for sourceID in pairs(sources) do
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
		local slot = C_Transmog.GetSlotForInventoryType(sourceInfo.invType)
		local slotSources = C_TransmogSets.GetSourcesForSlot(setID, slot)
		--WardrobeCollectionFrame_SortSources(slotSources, sourceInfo.visualID)
		local index = WardrobeCollectionFrame_GetDefaultSourceIndex(slotSources, sourceID)
		transmogSources[slot] = (slotSources[index] and slotSources[index].sourceID) or sourceID


		for i, slotSourceInfo in ipairs(slotSources) do
			if (not slotSourceInfo.name) then
				waitingOnData = true
			end
		end
	end

	if (waitingOnData) then
		self.loadingSetID = setID
	else
		self.loadingSetID = nil
		-- if we don't ignore the event, clearing will momentarily set the page to the one with the set the user currently has transmogged
		-- if that's a different page from the current one then the models will flicker as we swap the gear to different sets and back
		self.ignoreTransmogrifyUpdateEvent = true
		C_Transmog.ClearPending()
		self.ignoreTransmogrifyUpdateEvent = false
		C_Transmog.LoadSources(transmogSources, -1, -1)
	end
end

function BetterWardrobeSetsTransmogModelMixin:RefreshTooltip()
	if BW_WardrobeCollectionFrame.selectedTransmogTab == 4 or BW_WardrobeCollectionFrame.selectedCollectionTab == 4 then
		return
	end

	local totalQuality = 0
	local numTotalSlots = 0
	local waitingOnQuality = false
	local sourceQualityTable = self:GetParent().sourceQualityTable
	local sources = addon.GetSetsources(self.setID)
	for sourceID in pairs(sources) do
		numTotalSlots = numTotalSlots + 1
		if (sourceQualityTable[sourceID]) then
			totalQuality = totalQuality + sourceQualityTable[sourceID]
		else
			local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
			if (sourceInfo and sourceInfo.quality) then
				sourceQualityTable[sourceID] = sourceInfo.quality
				totalQuality = totalQuality + sourceInfo.quality
			else
				waitingOnQuality = true
			end
		end
	end

	if (waitingOnQuality) then
		GameTooltip:SetText(RETRIEVING_ITEM_INFO, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		local setQuality = (numTotalSlots > 0 and totalQuality > 0) and Round(totalQuality / numTotalSlots) or LE_ITEM_QUALITY_COMMON
		local color = ITEM_QUALITY_COLORS[setQuality]
		local setInfo = addon.GetSetInfo(self.setID)
		GameTooltip:SetText(setInfo.name, color.r, color.g, color.b)
		if (setInfo.label) then
			GameTooltip:AddLine(setInfo.label)
			GameTooltip:Show()
		end
	end
end

--==

--=======--
-- Extra Sets Collection List
BetterWardrobeSetsCollectionMixin = CreateFromMixins(WardrobeSetsCollectionMixin)

function BetterWardrobeSetsCollectionMixin:OnLoad()
	self.RightInset.BGCornerTopLeft:Hide()
	self.RightInset.BGCornerTopRight:Hide()

	self.DetailsFrame.Name:SetFontObjectsToTry(Fancy24Font, Fancy20Font, Fancy16Font)
	self.DetailsFrame.itemFramesPool = CreateFramePool("FRAME", self.DetailsFrame, "BW_WardrobeSetsDetailsItemFrameTemplate")

	self.selectedVariantSets = {}
end


function BetterWardrobeSetsCollectionMixin:OnShow()
	self:RegisterEvent("GET_ITEM_INFO_RECEIVED")
	self:RegisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE")
	self:RegisterEvent("TRANSMOG_COLLECTION_UPDATED")
	-- select the first set if not init

	local baseSets = SetsDataProvider:GetBaseSets()
	if (not self.init) then
		self.init = true
		if (baseSets and baseSets[1]) then
			--self:SelectSet(self:GetDefaultSetIDForBaseSet(baseSets[1].setID))
			self:SelectSet(baseSets[1].setID)
		end
	else
		self:Refresh()
	end

	local latestSource = newTransmogInfo["latestSource"]

	if (latestSource ~= NO_TRANSMOG_SOURCE_ID) then
		self:SelectSet(latestSource)
		self:ScrollToSet(latestSource)
		self:ClearLatestSource()
	end

	WardrobeCollectionFrame.progressBar:Show()
	self:UpdateProgressBar()
	self:RefreshCameras()

	if (self:GetParent().SetsTabHelpBox:IsShown()) then
		self:GetParent().SetsTabHelpBox:Hide()
		SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_TRANSMOG_SETS_TAB, true)
	end
end


function BetterWardrobeSetsCollectionMixin:OnHide()
	self:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
	self:UnregisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE")
	self:UnregisterEvent("TRANSMOG_COLLECTION_UPDATED")
	SetsDataProvider:ClearSets()
	--WardrobeCollectionFrame_ClearSearch(LE_TRANSMOG_SEARCH_TYPE_BASE_SETS

end


local inventoryTypes = {
	["INVTYPE_AMMO"] = INVSLOT_AMMO;
	["INVTYPE_HEAD"] = INVSLOT_HEAD;
	["INVTYPE_NECK"] = INVSLOT_NECK;
	["INVTYPE_SHOULDER"] = INVSLOT_SHOULDER;
	["INVTYPE_BODY"] = INVSLOT_BODY;
	["INVTYPE_CHEST"] = INVSLOT_CHEST;
	["INVTYPE_ROBE"] = INVSLOT_CHEST;
	["INVTYPE_WAIST"] = INVSLOT_WAIST;
	["INVTYPE_LEGS"] = INVSLOT_LEGS;
	["INVTYPE_FEET"] = INVSLOT_FEET;
	["INVTYPE_WRIST"] = INVSLOT_WRIST;
	["INVTYPE_HAND"] = INVSLOT_HAND;
	["INVTYPE_FINGER"] = INVSLOT_FINGER1;
	["INVTYPE_TRINKET"] = INVSLOT_TRINKET1;
	["INVTYPE_CLOAK"] = INVSLOT_BACK;
	["INVTYPE_WEAPON"] = INVSLOT_MAINHAND;
	["INVTYPE_SHIELD"] = INVSLOT_OFFHAND;
	["INVTYPE_2HWEAPON"] = INVSLOT_MAINHAND;
	["INVTYPE_WEAPONMAINHAND"] = INVSLOT_MAINHAND;
	["INVTYPE_WEAPONOFFHAND"] = INVSLOT_OFFHAND;
	["INVTYPE_HOLDABLE"] = INVSLOT_OFFHAND;
	["INVTYPE_RANGED"] = INVSLOT_RANGED;
	["INVTYPE_THROWN"] = INVSLOT_RANGED;
	["INVTYPE_RANGEDRIGHT"] = INVSLOT_RANGED;
	["INVTYPE_RELIC"] = INVSLOT_RANGED;
	["INVTYPE_TABARD"] = INVSLOT_TABARD;
	["INVTYPE_BAG"] = CONTAINER_BAG_OFFSET;
	["INVTYPE_QUIVER"] = CONTAINER_BAG_OFFSET;
}

function BetterWardrobeSetsCollectionMixin:OnEvent(event, ...)
	if (event == "GET_ITEM_INFO_RECEIVED") then
		local itemID = ...
		for itemFrame in self.DetailsFrame.itemFramesPool:EnumerateActive() do
			if (itemFrame.itemID == itemID) then
				self:SetItemFrameQuality(itemFrame)
				break
			end
		end

	elseif (event == "TRANSMOG_COLLECTION_SOURCE_ADDED") then
		if not addon.Profile.ShowCollectionUpdates then return end
		local sourceID = ...
		local categoryID, visualID, canEnchant, icon, isCollected, itemLink, transmogLink, _ = C_TransmogCollection.GetAppearanceSourceInfo(sourceID)
		local itemID, _, _, itemEquipLoc = GetItemInfoInstant(itemLink)
		--print(ExtractHyperlinkString(transmogLink))
		local setIDs = C_TransmogSets.GetSetsContainingSourceID(sourceID)
		if setIDs and  addon.Profile.ShowSetCollectionUpdates then 
			for i, setID in pairs(setIDs) do 
				local setInfo = C_TransmogSets.GetSetInfo(setID)
				print((YELLOW_FONT_COLOR_CODE..L["Added missing appearances of: \124cffff7fff\124H%s:%s\124h[%s]\124h\124r"]):format("transmogset", setID, setInfo.name))
				return
			end
		end

		if addon.Profile.ShowCollectionListCollectionUpdates and addon.chardb.profile.collectionList["item"][visualID] then  
			print((YELLOW_FONT_COLOR_CODE..L["Added appearance in Collection List"]))
		end

		local setItem = addon.IsSetItem(itemLink)
		
		if setItem and addon.Profile.ShowExtraSetsCollectionUpdates then 
			--local item = tonumber(itemLink:match("item:(%d+)"))
			
			newTransmogInfo = newTransmogInfo or {}

			for setID, setInfo in pairs(setItem) do 
			--local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
				--local setInfo = C_TransmogSets.GetSetInfo(setID)
				local setInfo = addon.GetSetInfo(setID)
				newTransmogInfo["latestSource"] = setID
				newTransmogInfo[setID] = newTransmogInfo[setID] or {}
				newTransmogInfo[setID][itemID] = inventoryTypes[itemEquipLoc]

				print((YELLOW_FONT_COLOR_CODE..L["Added missing appearances of: \124cffff7fff\124H%s:%s\124h[%s]\124h\124r"]):format("transmogset-extra", setID, setInfo.name))
				return
			end
		end
		SetsDataProvider:ClearSets()

	elseif (event == "TRANSMOG_COLLECTION_SOURCE_REMOVED") then
		local sourceID = ...
		local categoryID, visualID, canEnchant, icon, isCollected, itemLink, transmogLink, _ = C_TransmogCollection.GetAppearanceSourceInfo(sourceID)
		local setItem = addon.IsSetItem(itemLink)
		if setItem then 
			--local item = tonumber(itemLink:match("item:(%d+)"))
			local itemID, _, _, itemEquipLoc = GetItemInfoInstant(itemLink)
			newTransmogInfo = newTransmogInfo or {}

			for setID, setInfo in pairs(setItem) do 
				addon.ClearSetNewSourcesForSlot(setID, inventoryTypes[itemEquipLoc])
				SetsDataProvider:ResetBaseSetNewStatus(setID)
				if 	newTransmogInfo["latestSource"] == setID then 
					self:ClearLatestSource()
				end
			end
		end
		SetsDataProvider:ClearSets()

	elseif (event == "TRANSMOG_COLLECTION_ITEM_UPDATE") then
		for itemFrame in self.DetailsFrame.itemFramesPool:EnumerateActive() do
			self:SetItemFrameQuality(itemFrame)
		end

	elseif (event == "TRANSMOG_COLLECTION_UPDATED") then
		SetsDataProvider:ClearSets()
		self:Refresh()
		self:UpdateProgressBar()
		self:ClearLatestSource()
	end
end


function addon.SetHasNewSourcesForSlot(setID, transmogSlot)
	if not  newTransmogInfo[setID] then return false end
	for itemID, location in pairs(newTransmogInfo[setID]) do
		if location  == transmogSlot then 
			return true
		end	
	end
	return false
end 


function addon.ClearSetNewSourcesForSlot(setID, transmogSlot)
	if not  newTransmogInfo[setID] then return end

	local count = 0
	for itemID, location in pairs(newTransmogInfo[setID]) do
		count = count + 1
		if location  == transmogSlot then 
			newTransmogInfo[setID][itemID] = nil
			count = count - 1
		end
	end

	if count <= 0 then 
		newTransmogInfo[setID] = nil
		SetsDataProvider:ResetBaseSetNewStatus(setID)
	end
end


function addon.GetSetNewSources(setID)
	local sources = {}
	if not  newTransmogInfo[setID] then return sources end

	for itemID in pairs(newTransmogInfo[setID]) do
		local _, soucre = C_TransmogCollection.GetItemInfo(itemID)
		tinsert(sources, source)
	end
	return sources
end


function BetterWardrobeSetsCollectionMixin:Refresh()
	self.ScrollFrame:Update()
	if BW_WardrobeCollectionFrame.selectedCollectionTab == 4 then
		self:DisplaySavedSet(self:GetSelectedSavedSetID())
	else
		self:DisplaySet(self:GetSelectedSetID())
	end
end


local function GetSetCounts()
	local sets = addon.GetBaseList()
	local totalSets = #sets
	local collectedSets = 0

	for i, data in ipairs(sets) do
		local topSourcesCollected, topSourcesTotal = SetsDataProvider:GetSetSourceCounts(data.setID)
		if topSourcesCollected == topSourcesTotal then
			collectedSets = collectedSets + 1
		end
	end
	return collectedSets, totalSets
end


function BetterWardrobeSetsCollectionMixin:UpdateProgressBar()
	WardrobeCollectionFrame_UpdateProgressBar(GetSetCounts())
end


function BetterWardrobeSetsCollectionMixin:ClearLatestSource()
	newTransmogInfo["latestSource"] = NO_TRANSMOG_SOURCE_ID
	BW_WardrobeCollectionFrame_UpdateTabButtons();
end


function BetterWardrobeSetsCollectionMixin:DisplaySet(setID)
	local setInfo = (setID and addon.GetSetInfo(setID)) or nil
	if (not setInfo) then
		self.DetailsFrame:Hide()
		self.Model:Hide()
		return
	else
		self.DetailsFrame:Show()
		self.Model:Show()
	end

	self.DetailsFrame.Name:SetText(setInfo.name)
	if (self.DetailsFrame.Name:IsTruncated()) then
		self.DetailsFrame.Name:Hide()
		self.DetailsFrame.LongName:SetText(setInfo.name)
		self.DetailsFrame.LongName:Show()
	else
		self.DetailsFrame.Name:Show()
		self.DetailsFrame.LongName:Hide()
	end

	self.DetailsFrame.Label:SetText(setInfo.label)

	local newSourceIDs = addon.GetSetNewSources(setID)

	self.DetailsFrame.itemFramesPool:ReleaseAll()
	self.Model:Undress()
	local BUTTON_SPACE = 37	-- button width + spacing between 2 buttons
	local sortedSources = SetsDataProvider:GetSortedSetSources(setID)
	local xOffset = -floor((#setInfo.items - 1) * BUTTON_SPACE / 2)

	for i = 1, #sortedSources do
		local itemFrame = self.DetailsFrame.itemFramesPool:Acquire()
		itemFrame.sourceID = sortedSources[i].sourceID
		itemFrame.itemID = sortedSources[i].itemID
		itemFrame.collected = sortedSources[i].collected
		itemFrame.invType = sortedSources[i].invType
		local texture = C_TransmogCollection.GetSourceIcon(sortedSources[i].sourceID)
		itemFrame.Icon:SetTexture(texture)
		if (sortedSources[i].collected) then
			itemFrame.Icon:SetDesaturated(false)
			itemFrame.Icon:SetAlpha(1)
			itemFrame.IconBorder:SetDesaturation(0)
			itemFrame.IconBorder:SetAlpha(1)

			local transmogSlot = C_Transmog.GetSlotForInventoryType(itemFrame.invType)
			if (addon.SetHasNewSourcesForSlot(setID, transmogSlot)) then
				itemFrame.New:Show()
				itemFrame.New.Anim:Play()
			else
				itemFrame.New:Hide()
				itemFrame.New.Anim:Stop()
			end
		else
			itemFrame.Icon:SetDesaturated(true)
			itemFrame.Icon:SetAlpha(0.3)
			itemFrame.IconBorder:SetDesaturation(1)
			itemFrame.IconBorder:SetAlpha(0.3)
			itemFrame.New:Hide()
		end

		self:SetItemFrameQuality(itemFrame)
		itemFrame:SetPoint("TOP", self.DetailsFrame, "TOP", xOffset + (i - 1) * BUTTON_SPACE, -94)
		itemFrame:Show()
		self.Model:TryOn(sortedSources[i].sourceID)
	end
end


function BetterWardrobeSetsCollectionMixin:DisplaySavedSet(setID)
	local setInfo = (setID and addon.GetSetInfo(setID)) or nil
	if (not setInfo) then
		self.DetailsFrame:Hide()
		self.Model:Hide()
		return
	else
		self.DetailsFrame:Show()
		self.Model:Show()
	end

	self.DetailsFrame.Name:SetText(setInfo.name)
	if (self.DetailsFrame.Name:IsTruncated()) then
		self.DetailsFrame.Name:Hide()
		self.DetailsFrame.LongName:SetText(setInfo.name)
		self.DetailsFrame.LongName:Show()
	else
		self.DetailsFrame.Name:Show()
		self.DetailsFrame.LongName:Hide()
	end

	self.DetailsFrame.Label:SetText(setInfo.label)

	self.DetailsFrame.itemFramesPool:ReleaseAll()
	self.Model:Undress()
	local row1 = 0
	local row2 = 0
	local yOffset1 = -94

	if setInfo then
		for i = 1, #setInfo.sources do
			local sourceInfo = setInfo.sources[i] and C_TransmogCollection.GetSourceInfo(setInfo.sources[i])
			if sourceInfo then
				row1 = row1 + 1
			end
		end

		if row1 > 10 then
			row2 = row1 - 10
			row1 = 10
			yOffset1 = -74
		end
	end

	local BUTTON_SPACE = 37	-- button width + spacing between 2 buttons
	local sortedSources = setInfo.sources --SetsDataProvider:GetSortedSetSources(setID)
	local xOffset = -floor((row1 - 1) * BUTTON_SPACE / 2)
	local xOffset2 = -floor((row2 - 1) * BUTTON_SPACE / 2)
	local yOffset2 = yOffset1 - 40
	local itemCount = 0

	for i = 1, #sortedSources do
		if sortedSources[i] then
	
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sortedSources[i])
		if sourceInfo then
		itemCount = itemCount + 1
			local itemFrame = self.DetailsFrame.itemFramesPool:Acquire()
			itemFrame.sourceID = sourceInfo.sourceID
			--itemFrame.itemID = sourceInfo.itemID
			itemFrame.collected = sourceInfo.isCollected
			itemFrame.invType = sourceInfo.invType
			local texture = C_TransmogCollection.GetSourceIcon(sourceInfo.sourceID)
			itemFrame.Icon:SetTexture(texture)
			if (sourceInfo.isCollected) then
				itemFrame.Icon:SetDesaturated(false)
				itemFrame.Icon:SetAlpha(1)
				itemFrame.IconBorder:SetDesaturation(0)
				itemFrame.IconBorder:SetAlpha(1)
			else
				itemFrame.Icon:SetDesaturated(true)
				itemFrame.Icon:SetAlpha(0.3)
				itemFrame.IconBorder:SetDesaturation(1)
				itemFrame.IconBorder:SetAlpha(0.3)
				itemFrame.New:Hide()
			end

			self:SetItemFrameQuality(itemFrame)
			local move = (itemCount > 10)

			if itemCount <= 10 then
				itemFrame:SetPoint("TOP", self.DetailsFrame, "TOP", xOffset + (itemCount - 1) * BUTTON_SPACE, yOffset1)

			else
				itemFrame:SetPoint("TOP", self.DetailsFrame, "TOP", xOffset2 + (itemCount - 11) * BUTTON_SPACE, yOffset2)


			end

				self.DetailsFrame.IconRowBackground:ClearAllPoints()
				self.DetailsFrame.IconRowBackground:SetPoint("TOP", 0, move and -50 or -78)
				self.DetailsFrame.IconRowBackground:SetHeight(move and 120 or 64)
				self.DetailsFrame.Name:ClearAllPoints()
				self.DetailsFrame.Name:SetPoint("TOP", 0,  move and -17 or -37)
				self.DetailsFrame.LongName:ClearAllPoints()
				self.DetailsFrame.LongName:SetPoint("TOP", 0, move and -10 or -30)
				self.DetailsFrame.Label:ClearAllPoints()
				self.DetailsFrame.Label:SetPoint("TOP", 0, move and -43 or -63)

			itemFrame:Show()
			self.Model:TryOn(sourceInfo.sourceID)
			end
		end
	end
end


function BetterWardrobeSetsCollectionMixin:OnSearchUpdate()
	if (self.init) then
		SetsDataProvider:ClearBaseSets()
		SetsDataProvider:ClearVariantSets()
		SetsDataProvider:ClearUsableSets()
		SetsDataProvider:FilterSearch(true)
		self:Refresh()
	end
end


function BetterWardrobeSetsCollectionMixin:SelectSetFromButton(setID)
	CloseDropDownMenus()
	--self:SelectSet(self:GetDefaultSetIDForBaseSet(setID))
	self:SelectSet(setID)
end


function BetterWardrobeSetsCollectionMixin:GetSelectedSavedSetID()
	if not self.selectedSavedSetID then
		local savedSets = addon.GetSavedList()
		if savedSets then 
			self.selectedSavedSetID = savedSets[1].setID
		end
	end

	return self.selectedSavedSetID
end


function BetterWardrobeSetsCollectionMixin:GetSelectedSetID()
	if not self.selectedSetID then
		local savedSets = SetsDataProvider:GetBaseSets(true)
		self.selectedSetID = savedSets[1].setID
	end
	return self.selectedSetID
end


function BetterWardrobeSetsCollectionMixin:SelectSet(setID)
	if BW_WardrobeCollectionFrame.selectedCollectionTab == 4 then
		self:SelectSavedSet(setID)
	else
		self.selectedSetID = setID
	end

	self:Refresh()
end


function BetterWardrobeSetsCollectionMixin:SelectSavedSet(setID)
		self.selectedSavedSetID = setID
end


function BetterWardrobeSetsCollectionMixin:SetAppearanceTooltip(frame)
	GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
	self.tooltipTransmogSlot = C_Transmog.GetSlotForInventoryType(frame.invType)
	self.tooltipPrimarySourceID = frame.sourceID
	self:RefreshAppearanceTooltip()
end


local function GetDropDifficulties(drop)
	local text = drop.difficulties[1]
	if (text) then
		for i = 2, #drop.difficulties do
			text = text..", "..drop.difficulties[i]
		end
	end
	return text
end


local needsRefresh = false
function BW_WardrobeCollectionFrame_SetAppearanceTooltip(contentFrame, sources, primarySourceID)
	BW_WardrobeCollectionFrame.tooltipContentFrame = contentFrame

	for i = 1, #sources do
		if (sources[i].isHideVisual) then
			GameTooltip:SetText(sources[i].name)
			return
		end
	end

	local firstVisualID = sources[1].visualID
	local passedFirstVisualID = false

	local headerIndex
	if (not BW_WardrobeCollectionFrame.tooltipSourceIndex) then
		headerIndex = WardrobeCollectionFrame_GetDefaultSourceIndex(sources, primarySourceID)
	else
		headerIndex = WardrobeUtils_GetValidIndexForNumSources(BW_WardrobeCollectionFrame.tooltipSourceIndex, #sources)
	end
	BW_WardrobeCollectionFrame.tooltipSourceIndex = headerIndex
	headerSourceID = sources[headerIndex].sourceID

	local name, nameColor, sourceText, sourceColor = WardrobeCollectionFrameModel_GetSourceTooltipInfo(sources[headerIndex])
	if name == RETRIEVING_ITEM_INFO then needsRefresh = true end

	GameTooltip:SetText(name, nameColor.r, nameColor.g, nameColor.b)

	if (sources[headerIndex].sourceType == TRANSMOG_SOURCE_BOSS_DROP and not sources[headerIndex].isCollected) then
		local drops = C_TransmogCollection.GetAppearanceSourceDrops(headerSourceID)
		if (drops and #drops > 0) then
			local showDifficulty = false
			if (#drops == 1) then
				sourceText = _G["TRANSMOG_SOURCE_"..TRANSMOG_SOURCE_BOSS_DROP]..": "..string.format(WARDROBE_TOOLTIP_ENCOUNTER_SOURCE, drops[1].encounter, drops[1].instance)
				showDifficulty = true
			else
				-- check if the drops are the same instance
				local sameInstance = true
				local firstInstance = drops[1].instance
				for i = 2, #drops do
					if (drops[i].instance ~= firstInstance) then
						sameInstance = false
						break
					end
				end
				-- ok, if multiple instances check if it's the same tier if the drops have a single tier
				local sameTier = true
				local firstTier = drops[1].tiers[1]
				if (not sameInstance and #drops[1].tiers == 1) then
					for i = 2, #drops do
						if (#drops[i].tiers > 1 or drops[i].tiers[1] ~= firstTier) then
							sameTier = false
							break
						end
					end
				end
				-- if same instance or tier, check if we have same difficulties and same instanceType
				local sameDifficulty = false
				local sameInstanceType = false
				if (sameInstance or sameTier) then
					sameDifficulty = true
					sameInstanceType = true
					for i = 2, #drops do
						if (drops[1].instanceType ~= drops[i].instanceType) then
							sameInstanceType = false
						end

						if (#drops[1].difficulties ~= #drops[i].difficulties) then
							sameDifficulty = false
						else
							for j = 1, #drops[1].difficulties do
								if (drops[1].difficulties[j] ~= drops[i].difficulties[j]) then
									sameDifficulty = false
									break
								end
							end
						end
					end
				end
				-- override sourceText if sameInstance or sameTier
				if (sameInstance) then
					sourceText = _G["TRANSMOG_SOURCE_"..TRANSMOG_SOURCE_BOSS_DROP]..": "..firstInstance
					showDifficulty = sameDifficulty
				elseif (sameTier) then
					local location = firstTier
					if (sameInstanceType) then
						if (drops[1].instanceType == INSTANCE_TYPE_DUNGEON) then
							location = string.format(WARDROBE_TOOLTIP_DUNGEONS, location)
						elseif (drops[1].instanceType == INSTANCE_TYPE_RAID) then
							location = string.format(WARDROBE_TOOLTIP_RAIDS, location)
						end
					end
					sourceText = _G["TRANSMOG_SOURCE_"..TRANSMOG_SOURCE_BOSS_DROP]..": "..location
				end
			end

			if (showDifficulty) then
				local diffText = GetDropDifficulties(drops[1])
				if (diffText) then
					sourceText = sourceText.." "..string.format(PARENS_TEMPLATE, diffText)
				end
			end
		end
	end

	if (not sources[headerIndex].isCollected) then
		GameTooltip:AddLine(sourceText, sourceColor.r, sourceColor.g, sourceColor.b, 1, 1)
	end

	local useError
	local appearanceCollected = sources[headerIndex].isCollected
	if (#sources > 1 and not appearanceCollected) then
		-- only add "Other items using this appearance" if we're continuing to the same visualID
		if (firstVisualID == sources[2].visualID) then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(WARDROBE_OTHER_ITEMS, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
		end

		for i = 1, #sources do
			-- first time we transition to a different visualID, add "Other items that unlock this slot"
			if (not passedFirstVisualID and firstVisualID ~= sources[i].visualID) then
				passedFirstVisualID = true
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(WARDROBE_ALTERNATE_ITEMS)
			end

			local name, nameColor, sourceText, sourceColor = WardrobeCollectionFrameModel_GetSourceTooltipInfo(sources[i])
			if name == RETRIEVING_ITEM_INFO then needsRefresh = true end

			if (i == headerIndex) then
				name = WARDROBE_TOOLTIP_CYCLE_ARROW_ICON..name
				useError = sources[i].useError
			else
				name = WARDROBE_TOOLTIP_CYCLE_SPACER_ICON..name
			end
			GameTooltip:AddDoubleLine(name, sourceText, nameColor.r, nameColor.g, nameColor.b, sourceColor.r, sourceColor.g, sourceColor.b)
		end
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(WARDROBE_TOOLTIP_CYCLE, GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b, true)
		BW_WardrobeCollectionFrame.tooltipCycle = true
	else
		useError = sources[headerIndex].useError
		BW_WardrobeCollectionFrame.tooltipCycle = nil
	end

	if (appearanceCollected) then
		if (useError) then
			GameTooltip:AddLine(useError, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, true)
		elseif (not WardrobeFrame_IsAtTransmogrifier()) then
			GameTooltip:AddLine(WARDROBE_TOOLTIP_TRANSMOGRIFIER, GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b, 1, 1)
		end

		if (not useError) then
			local holidayName = C_TransmogCollection.GetSourceRequiredHoliday(headerSourceID)
			if (holidayName) then
				GameTooltip:AddLine(TRANSMOG_APPEARANCE_USABLE_HOLIDAY:format(holidayName), LIGHTBLUE_FONT_COLOR.r, LIGHTBLUE_FONT_COLOR.g, LIGHTBLUE_FONT_COLOR.b, true)
			end
		end
	end

	GameTooltip:Show()
end

function BetterWardrobeSetsCollectionMixin:RefreshAppearanceTooltip()
	if (not self.tooltipTransmogSlot) then
		return
	end

	local sourceInfo = C_TransmogCollection.GetSourceInfo(self.tooltipPrimarySourceID)
	local visualID = sourceInfo.visualID
	local sources = C_TransmogCollection.GetAppearanceSources(visualID) or {} --Can return nil if no longer in game
	
	if (#sources == 0) then
		-- can happen if a slot only has HiddenUntilCollected sources
		local sourceInfo = C_TransmogCollection.GetSourceInfo(self.tooltipPrimarySourceID)
		tinsert(sources, sourceInfo)
	end

	WardrobeCollectionFrame_SortSources(sources, sources[1].visualID, self.tooltipPrimarySourceID)
	BW_WardrobeCollectionFrame_SetAppearanceTooltip(self, sources, self.tooltipPrimarySourceID)

	C_Timer.After(.05, function() if needsRefresh then self:RefreshAppearanceTooltip(); needsRefresh = false; end; end) --Fix for items that returned retreaving info
end

BetterWardrobeSetsCollectionScrollFrameMixin = CreateFromMixins(WardrobeSetsCollectionScrollFrameMixin)

local function BW_WardrobeSetsCollectionScrollFrame_FavoriteDropDownInit(self)
	if (not self.baseSetID) then
		return
	end

	local baseSet = SetsDataProvider:GetBaseSetByID(self.baseSetID)
	--local variantSets = SetsDataProvider:GetVariantSets(self.baseSetID)
	local useDescription = false

	local info = UIDropDownMenu_CreateInfo()
	info.notCheckable = true
	info.disabled = nil
	local isFavorite = addon.chardb.profile.favorite[self.baseSetID]

	if (isFavorite) then
		info.text = BATTLE_PET_UNFAVORITE
		info.func = function()
			addon.chardb.profile.favorite[self.baseSetID] = nil
			BW_SetsCollectionFrame:Refresh()
			BW_SetsCollectionFrame:OnSearchUpdate()
		end
	else
		--local targetSetID = WardrobeCollectionFrame.SetsCollectionFrame:GetDefaultSetIDForBaseSet(self.baseSetID)
		info.text = BATTLE_PET_FAVORITE
		info.func = function()
			addon.chardb.profile.favorite[self.baseSetID] = true
			BW_SetsCollectionFrame:Refresh()
			BW_SetsCollectionFrame:OnSearchUpdate()
		end
	end

	UIDropDownMenu_AddButton(info, level)
	info.disabled = nil

	info.text = CANCEL
	info.func = nil
	UIDropDownMenu_AddButton(info, level)
end


function BetterWardrobeSetsCollectionScrollFrameMixin:OnLoad()
	self.scrollBar.trackBG:Show()
	self.scrollBar.trackBG:SetVertexColor(0, 0, 0, 0.75)
	self.scrollBar.doNotHide = true
	self.update = self.Update
	HybridScrollFrame_CreateButtons(self, "WardrobeSetsScrollFrameButtonTemplate", 44, 0)
	UIDropDownMenu_Initialize(self.FavoriteDropDown, BW_WardrobeSetsCollectionScrollFrame_FavoriteDropDownInit, "MENU")
end


function BetterWardrobeSetsCollectionScrollFrameMixin:Update()
	local offset = HybridScrollFrame_GetOffset(self)
	local buttons = self.buttons
	local baseSets = SetsDataProvider:GetBaseSets() --addon.GetBaseList()
	local selectedBaseSetID
	-- show the base set as selected

	if BW_WardrobeCollectionFrame.selectedCollectionTab == 4 then
		selectedBaseSetID = self:GetParent():GetSelectedSavedSetID()
	else

		selectedBaseSetID = self:GetParent():GetSelectedSetID()
	end

	for i = 1, #buttons do
		local button = buttons[i]
		local setIndex = i + offset

		if (setIndex <= #baseSets) then
			local baseSet = baseSets[setIndex]

			local isFavorite = addon.chardb.profile.favorite[baseSet.setID]
			local isHidden = addon.chardb.profile.extraset[baseSet.setID]

			--local count, complete = addon.GetSetCompletion(baseSet)
			button:Show()
			button.Name:SetText(baseSet.name)
			local topSourcesCollected, topSourcesTotal = SetsDataProvider:GetSetSourceTopCounts(baseSet.setID)

			local setCollected = topSourcesCollected == topSourcesTotal --baseSet.collected -- C_TransmogSets.IsBaseSetCollected(baseSet.setID)
			local color = IN_PROGRESS_FONT_COLOR

			if (setCollected) then
				color = NORMAL_FONT_COLOR
			elseif (topSourcesCollected == 0) then
				color = GRAY_FONT_COLOR
			end

			button.setCollected = setCollected
			button.Name:SetTextColor(color.r, color.g, color.b)
			button.Label:SetText(baseSet.label) --(L["NOTE_"..(baseSet.label or 0)] and L["NOTE_"..(baseSet.label or 0)]) or "")--((L["NOTE_"..baseSet.label] or "X"))
			button.Icon:SetTexture(baseSet.icon or SetsDataProvider:GetIconForSet(baseSet.setID))
			button.Icon:SetDesaturation((baseSet.collected and 0) or ((topSourcesCollected == 0) and 1) or 0)
			button.SelectedTexture:SetShown(baseSet.setID == selectedBaseSetID)
			button.Favorite:SetShown(isFavorite)
			button.CollectionListVisual.Hidden.Icon:SetShown(isHidden)
			local isInList = addon.chardb.profile.collectionList["extraset"][baseSet.setID]
			button.CollectionListVisual.Collection.Collection_Icon:SetShown(isInList)
			button.CollectionListVisual.Collection.Collected_Icon:SetShown(isInList and setCollected)
			--button.CollectionListVisual.Collection.Collected_Icon:SetShown(false
			button.New:SetShown(SetsDataProvider:IsBaseSetNew(baseSet.setID))
			button.setID = baseSet.setID

			if (topSourcesCollected == 0 or setCollected) then
				button.ProgressBar:Hide()
			else
				button.ProgressBar:Show()
				button.ProgressBar:SetWidth(SET_PROGRESS_BAR_MAX_WIDTH * topSourcesCollected / topSourcesTotal)
			end
			button.IconCover:SetShown(not setCollected)
		else
			button:Hide()
		end
	end

	local extraHeight = (self.largeButtonHeight and self.largeButtonHeight - BASE_SET_BUTTON_HEIGHT) or 0
	local totalHeight = #baseSets * BASE_SET_BUTTON_HEIGHT + extraHeight
	HybridScrollFrame_Update(self, totalHeight, self:GetHeight())
end

BW_WardrobeSetsDetailsItemMixin = CreateFromMixins(WardrobeSetsDetailsItemMixin)
function BW_WardrobeSetsDetailsItemMixin:OnEnter()
	self:GetParent():GetParent():SetAppearanceTooltip(self)

	self:SetScript("OnUpdate",
		function()
			if IsModifiedClick("DRESSUP") then
				ShowInspectCursor()
			else
				ResetCursor()
			end
		end
	)

	if (self.New:IsShown()) then
		local transmogSlot = C_Transmog.GetSlotForInventoryType(self.invType)
		local setID = BW_WardrobeCollectionFrame.BW_SetsCollectionFrame:GetSelectedSetID()
		addon.ClearSetNewSourcesForSlot(setID, transmogSlot)
		local baseSetID = C_TransmogSets.GetBaseSetID(setID)
		SetsDataProvider:ResetBaseSetNewStatus(setID)
		BW_WardrobeCollectionFrame.BW_SetsCollectionFrame:Refresh()
	end
end


function BW_WardrobeSetsDetailsItemMixin:OnMouseDown()
	if (IsModifiedClick("CHATLINK")) then
		local sourceInfo = C_TransmogCollection.GetSourceInfo(self.sourceID)
		local slot = C_Transmog.GetSlotForInventoryType(sourceInfo.invType)
		local sources = C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)
		if (not sources or #sources == 0) then
			-- can happen if a slot only has HiddenUntilCollected sources or if no longer in game
			sources = sources or {}
			tinsert(sources, sourceInfo)
		end

		WardrobeCollectionFrame_SortSources(sources, sourceInfo.visualID, self.sourceID)
		if (BW_WardrobeCollectionFrame.tooltipSourceIndex) then
			local index = WardrobeUtils_GetValidIndexForNumSources(BW_WardrobeCollectionFrame.tooltipSourceIndex, #sources)
			local link = select(6, C_TransmogCollection.GetAppearanceSourceInfo(sources[index].sourceID))
			if (link) then
				HandleModifiedItemClick(link)
			end
		end
	elseif (IsModifiedClick("DRESSUP")) then
		DressUpVisual(self.sourceID)
	end
end

--========--
-----Extra Sets Transmog Vendor Window

BetterWardrobeSetsTransmogMixin = CreateFromMixins(WardrobeSetsTransmogMixin)

function BetterWardrobeSetsTransmogMixin:LoadSet(setID)
	if BW_WardrobeCollectionFrame.selectedTransmogTab == 4 or BW_WardrobeCollectionFrame.selectedCollectionTab == 4 then
		BW_WardrobeOutfitDropDown:SelectOutfit(setID - 5000, true)
		return
	end

	local waitingOnData = false
	local transmogSources = {}
	local sources = addon.GetSetsources(setID)
	local combineSources = IsShiftKeyDown()
	local selectedItems = {}
	local SourceList = {}

	for sourceID in pairs(sources) do
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
		if sourceInfo then
			local slot = C_Transmog.GetSlotForInventoryType(sourceInfo.invType)
			local slotSources = C_TransmogCollection.GetAppearanceSources(sourceInfo.visualID)
			if slotSources then
				WardrobeCollectionFrame_SortSources(slotSources, sourceInfo.visualID)
				local knownID = Sets.isMogKnown(sourceID)
				if knownID then transmogSources[slot] = knownID end

				local index = WardrobeCollectionFrame_GetDefaultSourceIndex(slotSources, sourceID)
				--WardrobeCollectionFrame_SortSources(slotSources, sourceInfo.visualID)

				if combineSources then
					local _, hasPending = C_Transmog.GetSlotInfo(slot, LE_TRANSMOG_TYPE_APPEARANCE)
					if hasPending then
						local _,_,_,_,sourceID, appearanceID = C_Transmog.GetSlotVisualInfo(slot, LE_TRANSMOG_TYPE_APPEARANCE)
						local emptyappearanceID, emptySourceID = EmptyArmor[slot] and C_TransmogCollection.GetItemInfo(EmptyArmor[slot])

						if appearanceID == emptyappearanceID then
							C_Transmog.ClearPending(slot, LE_TRANSMOG_TYPE_APPEARANCE)
							transmogSources[slot] = slotSources[index].sourceID
						else				
							transmogSources[slot] = sourceID
						end
						--transmogSources[slot] = slotSources[index].sourceID
					end
				--else

				--transmogSources[slot] = slotColected
					--transmogSources[slot] = sourceInfo.sourceID
					--transmogSources[slot] = slotSources[index].sourceID
				end
			end

			for i, slotSourceInfo in ipairs(sourceInfo) do
				if (not slotSourceInfo.name) then
					waitingOnData = true
				end
			end
		end
	end

	if (waitingOnData) then
		self.loadingSetID = setID
	else
		self.loadingSetID = nil
		-- if we don't ignore the event, clearing will momentarily set the page to the one with the set the user currently has transmogged
		-- if that's a different page from the current one then the models will flicker as we swap the gear to different sets and back
		self.ignoreTransmogrifyUpdateEvent = true
		C_Transmog.ClearPending()
		self.ignoreTransmogrifyUpdateEvent = false
		C_Transmog.LoadSources(transmogSources, -1, -1)

		if Profile.HiddenMog then	
			local clearSlots = Sets:EmptySlots(transmogSources)
			for i, x in pairs(clearSlots) do
				local _, source = addon.GetItemSource(x) --C_TransmogCollection.GetItemInfo(x)
				C_Transmog.SetPending(i, LE_TRANSMOG_TYPE_APPEARANCE,source)
			end

			local emptySlotData = Sets:GetEmptySlots()
			for i, x in pairs(transmogSources) do
				if not C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(x) and i ~= 7 and emptySlotData[i] then
					local _, source = addon.GetItemSource(emptySlotData[i]) --C_TransmogCollection.GetItemInfo(emptySlotData[i])
					C_Transmog.SetPending(i, LE_TRANSMOG_TYPE_APPEARANCE, source)
				end
			end
		end
	end
end


function BetterWardrobeSetsTransmogMixin:OnShow()
	self:RegisterEvent("TRANSMOGRIFY_UPDATE")
	self:RegisterEvent("TRANSMOGRIFY_SUCCESS")
	self:RegisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE")
	self:RegisterEvent("TRANSMOG_COLLECTION_UPDATED")
	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	self:RegisterEvent("TRANSMOG_SETS_UPDATE_FAVORITE")
	self:RefreshCameras()
	local RESET_SELECTION = true
	self:Refresh(RESET_SELECTION)
	WardrobeCollectionFrame.progressBar:Show()
	self:UpdateProgressBar()
	self.sourceQualityTable = {}

	if (self:GetParent().SetsTabHelpBox:IsShown()) then
		self:GetParent().SetsTabHelpBox:Hide()
		SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_TRANSMOG_SETS_VENDOR_TAB, true)
	end
end


function BetterWardrobeSetsTransmogMixin:OnHide()
	self:UnregisterEvent("TRANSMOGRIFY_UPDATE")
	self:UnregisterEvent("TRANSMOGRIFY_SUCCESS")
	self:UnregisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE")
	self:UnregisterEvent("TRANSMOG_COLLECTION_UPDATED")
	self:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED")
	self:UnregisterEvent("TRANSMOG_SETS_UPDATE_FAVORITE")
	self.loadingSetID = nil
	SetsDataProvider:ClearSets()
	WardrobeCollectionFrame_ClearSearch(LE_TRANSMOG_SEARCH_TYPE_USABLE_SETS)
	self.sourceQualityTable = nil
end


function BetterWardrobeSetsTransmogMixin:UpdateProgressBar()
	WardrobeCollectionFrame_UpdateProgressBar(GetSetCounts())
end


function BetterWardrobeSetsTransmogMixin:UpdateSets()
	local usableSets = SetsDataProvider:GetUsableSets()

	if BW_WardrobeCollectionFrame.selectedTransmogTab == 4 or BW_WardrobeCollectionFrame.selectedCollectionTab == 4 then
			usableSets = addon.GetSavedList()
	end

	self.PagingFrame:SetMaxPages(ceil(#usableSets / self.PAGE_SIZE))
	local pendingTransmogModelFrame = nil
	local indexOffset = (self.PagingFrame:GetCurrentPage() - 1) * self.PAGE_SIZE

	for i = 1, self.PAGE_SIZE do
		local model = self.Models[i]
		local index = i + indexOffset
		local set = usableSets[index]

		if (set) then
			model:Show()

			--if (model.setID ~= set.setID) then
				model:Undress()
				local sourceData =  SetsDataProvider:GetSetSourceData(set.setID)
				for sourceID in pairs(sourceData.sources) do
					if (not Profile.HideMissing and (not BW_WardrobeToggle.VisualMode or (Sets.isMogKnown(sourceID) and BW_WardrobeToggle.VisualMode))) or
						(Profile.HideMissing and (BW_WardrobeToggle.VisualMode or Sets.isMogKnown(sourceID))) then
						model:TryOn(sourceID)
					else
					end
				end
			--end

			local transmogStateAtlas

			if (set.setID == self.appliedSetID and set.setID == self.selectedSetID) then
				transmogStateAtlas = "transmog-set-border-current-transmogged"
			elseif (set.setID == self.selectedSetID) then
				transmogStateAtlas = "transmog-set-border-selected"
				pendingTransmogModelFrame = model
			end

			if (transmogStateAtlas) then
				model.TransmogStateTexture:SetAtlas(transmogStateAtlas, true)
				model.TransmogStateTexture:Show()
			else
				model.TransmogStateTexture:Hide()
			end

			local topSourcesCollected, topSourcesTotal
			if addon.Profile.ShowIncomplete then
				topSourcesCollected, topSourcesTotal = addon.Sets:GetLocationBasedCount(set)
			else
				topSourcesCollected, topSourcesTotal = SetsDataProvider:GetSetSourceCounts(set.setID)
			end

			local setInfo = addon.GetSetInfo(set.setID)
			local isFavorite = addon.chardb.profile.favorite[set.setID]
			local isHidden = addon.chardb.profile.extraset[set.setID]
			model.setCollected = topSourcesCollected == topSourcesTotal
			model.Favorite.Icon:SetShown(isFavorite)
			model.CollectionListVisual.Hidden.Icon:SetShown(isHidden)
			local isInList = addon.chardb.profile.collectionList["extraset"][set.setID]
			model.CollectionListVisual.Collection.Collection_Icon:SetShown(isInList)
			model.CollectionListVisual.Collection.Collected_Icon:SetShown(isInList and model.setCollected)
			--model.CollectionListVisual.Collection.Collected_Icon:SetShown(false)
			model.setID = set.setID
			model.SetInfo.setName:SetText(setInfo["name"].."\n"..(setInfo["description"] or ""))
			if BW_WardrobeCollectionFrame.selectedTransmogTab == 4 or BW_WardrobeCollectionFrame.selectedCollectionTab == 4 then
				model.SetInfo.progress:Hide()
			else
				model.SetInfo.progress:Show()
				model.SetInfo.progress:SetText(topSourcesCollected.."/".. topSourcesTotal)
			end
		else
			model:Hide()
		end
	end

	if (pendingTransmogModelFrame) then
		self.PendingTransmogFrame:SetParent(pendingTransmogModelFrame)
		self.PendingTransmogFrame:SetPoint("CENTER")
		self.PendingTransmogFrame:Show()

		if (self.PendingTransmogFrame.setID ~= pendingTransmogModelFrame.setID) then
			self.PendingTransmogFrame.TransmogSelectedAnim:Stop()
			self.PendingTransmogFrame.TransmogSelectedAnim:Play()
			self.PendingTransmogFrame.TransmogSelectedAnim2:Stop()
			self.PendingTransmogFrame.TransmogSelectedAnim2:Play()
			self.PendingTransmogFrame.TransmogSelectedAnim3:Stop()
			self.PendingTransmogFrame.TransmogSelectedAnim3:Play()
			self.PendingTransmogFrame.TransmogSelectedAnim4:Stop()
			self.PendingTransmogFrame.TransmogSelectedAnim4:Play()
			self.PendingTransmogFrame.TransmogSelectedAnim5:Stop()
			self.PendingTransmogFrame.TransmogSelectedAnim5:Play()
		end

		self.PendingTransmogFrame.setID = pendingTransmogModelFrame.setID
	else
		self.PendingTransmogFrame:Hide()
	end

	self.NoValidSetsLabel:SetShown(not C_TransmogSets.HasUsableSets())
end


function BetterWardrobeSetsTransmogMixin:OnSearchUpdate()
	SetsDataProvider:ClearUsableSets()
	SetsDataProvider:FilterSearch()
	self:UpdateSets()
end


local function GetPage(entryIndex, pageSize)
	return floor((entryIndex-1) / pageSize) + 1
end


function BetterWardrobeSetsTransmogMixin:ResetPage()
	local page = 1

	if (self.selectedSetID) then
		local usableSets = SetsDataProvider:GetUsableSets()
		self.PagingFrame:SetMaxPages(ceil(#usableSets / self.PAGE_SIZE))
		for i, set in ipairs(usableSets) do
			if (set.setID == self.selectedSetID) then
				page = GetPage(i, self.PAGE_SIZE)
				break
			end
		end
	end

	self.PagingFrame:SetCurrentPage(page)
	self:UpdateSets()
end


function BetterWardrobeSetsTransmogMixin:OpenRightClickDropDown()
	if (not self.RightClickDropDown.activeFrame) then
		return
	end

	local setID = self.RightClickDropDown.activeFrame.setID
	local info = UIDropDownMenu_CreateInfo()
	local isFavorite = addon.chardb.profile.favorite[setID]
	if (isFavorite) then
		info.text = BATTLE_PET_UNFAVORITE
		info.func = function()
			addon.chardb.profile.favorite[setID] = nil
			BW_SetsTransmogFrame:Refresh()
			BW_SetsTransmogFrame:OnSearchUpdate()
		 end
	else
		info.text = BATTLE_PET_FAVORITE
		info.func = function()
			addon.chardb.profile.favorite[setID] = true
			BW_SetsTransmogFrame:Refresh()
			BW_SetsTransmogFrame:OnSearchUpdate()
		end
	end
	info.notCheckable = true
	UIDropDownMenu_AddButton(info)
	-- Cancel
	info = UIDropDownMenu_CreateInfo()
	info.notCheckable = true
	info.text = CANCEL
	UIDropDownMenu_AddButton(info)
end


do
	local function OpenRightClickDropDown(self)
		self:GetParent():OpenRightClickDropDown()
	end


	function BW_WardrobeSetsTransmogModelRightClickDropDown_OnLoad(self)
		UIDropDownMenu_Initialize(self, OpenRightClickDropDown, "MENU")
	end
end

local TAB_ITEMS = addon.Globals.TAB_ITEMS
local TAB_SETS = addon.Globals.TAB_SETS
local TAB_EXTRASETS = addon.Globals.TAB_EXTRASETS
local TAB_SAVED_SETS = addon.Globals.TAB_SAVED_SETS
local TABS_MAX_WIDTH = addon.Globals.TABS_MAX_WIDTH

function BW_WardrobeCollectionFrame_OnLoad(self)
	WardrobeCollectionFrameTab1:Hide()
	WardrobeCollectionFrameTab2:Hide()
	BW_WardrobeCollectionFrameTab1:Show()
	BW_WardrobeCollectionFrameTab2:Show()
	BW_WardrobeCollectionFrameTab3:Show()
	BW_WardrobeCollectionFrameTab4:Hide()
	--local level = CollectionsJournal:GetFrameLevel()
	local level = BW_WardrobeCollectionFrame:GetFrameLevel()
	CollectionsJournal:SetFrameLevel(level - 1)

	PanelTemplates_SetNumTabs(self, 4)
	PanelTemplates_SetTab(self, TAB_ITEMS)
	PanelTemplates_ResizeTabsToFit(self, TABS_MAX_WIDTH)
	self.selectedCollectionTab = TAB_ITEMS
	self.selectedTransmogTab = TAB_ITEMS

end


function BW_WardrobeCollectionFrame_OnEvent(self, event, ...)
	if (event == "UNIT_MODEL_CHANGED") then
		local hasAlternateForm, inAlternateForm = HasAlternateForm()
		if ((self.inAlternateForm ~= inAlternateForm or self.updateOnModelChanged)) then
			if (self.activeFrame:OnUnitModelChangedEvent()) then
				self.inAlternateForm = inAlternateForm
				self.updateOnModelChanged = nil
			end
		end
	elseif (event == "TRANSMOG_SEARCH_UPDATED") then
		local searchType, arg1 = ...
		--if (searchType == self.activeFrame.searchType) then
			--self.activeFrame:OnSearchUpdate(arg1)
		--end
	end
end


function BW_WardrobeCollectionFrame_UpdateTabButtons()
	-- sets tab
	BW_WardrobeCollectionFrame.SetsTab.FlashFrame:SetShown(C_TransmogSets.GetLatestSource() ~= NO_TRANSMOG_SOURCE_ID and not WardrobeFrame_IsAtTransmogrifier());
	BW_WardrobeCollectionFrame.ExtraSetsTab.FlashFrame:SetShown(newTransmogInfo["latestSource"] ~= NO_TRANSMOG_SOURCE_ID and not WardrobeFrame_IsAtTransmogrifier())
end


	addon.TRANSMOG_SET_FILTER[LE_TRANSMOG_SET_FILTER_COLLECTED] = C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_COLLECTED)
	addon.TRANSMOG_SET_FILTER[LE_TRANSMOG_SET_FILTER_UNCOLLECTED] = C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_UNCOLLECTED)
	addon.TRANSMOG_SET_FILTER[LE_TRANSMOG_SET_FILTER_PVP] = C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVP)
	addon.TRANSMOG_SET_FILTER[LE_TRANSMOG_SET_FILTER_PVE] = C_TransmogSets.GetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVE)

function BW_WardrobeCollectionFrame_OnShow(self)
	CollectionsJournal:SetPortraitToAsset("Interface\\Icons\\inv_chest_cloth_17")
	local level = CollectionsJournal:GetFrameLevel()
	BW_WardrobeCollectionFrame:SetFrameLevel(level+10)

	self:RegisterUnitEvent("UNIT_MODEL_CHANGED", "player")
	self:RegisterEvent("TRANSMOG_SEARCH_UPDATED")

	local hasAlternateForm, inAlternateForm = HasAlternateForm()
	self.inAlternateForm = inAlternateForm

	if (WardrobeFrame_IsAtTransmogrifier()) then
		BW_WardrobeCollectionFrame_SetTab(TAB_ITEMS)
		C_TransmogSets.SetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_COLLECTED, true);
		C_TransmogSets.SetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_UNCOLLECTED, true);
		C_TransmogSets.SetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVP, true);
		C_TransmogSets.SetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVE, true);

	else
		BW_WardrobeCollectionFrame_SetTab(TAB_ITEMS)
		C_TransmogSets.SetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_COLLECTED, addon.TRANSMOG_SET_FILTER[LE_TRANSMOG_SET_FILTER_COLLECTED] );
		C_TransmogSets.SetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_UNCOLLECTED, addon.TRANSMOG_SET_FILTER[LE_TRANSMOG_SET_FILTER_UNCOLLECTED] );
		C_TransmogSets.SetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVP, addon.TRANSMOG_SET_FILTER[LE_TRANSMOG_SET_FILTER_PVP] );
		C_TransmogSets.SetBaseSetsFilter(LE_TRANSMOG_SET_FILTER_PVE, addon.TRANSMOG_SET_FILTER[LE_TRANSMOG_SET_FILTER_PVE] );
	end
	BW_WardrobeCollectionFrame_UpdateTabButtons()

	if #addon.GetSavedList() > 0 then 
		WardrobeCollectionFrame.progressBar:SetWidth(160)
		WardrobeCollectionFrame.progressBar.border:SetWidth(169)
		WardrobeCollectionFrame.progressBar:ClearAllPoints()
		WardrobeCollectionFrame.progressBar:SetPoint("TOPLEFT", WardrobeCollectionFrame.ItemsTab, "TOPLEFT", 250, -11)
		WardrobeCollectionFrame.searchBox:SetWidth(105)
		BW_WardrobeCollectionFrameTab4:Show()
	end
end


function BW_WardrobeCollectionFrame_OnHide(self)
	self:UnregisterEvent("UNIT_MODEL_CHANGED")
	self:UnregisterEvent("TRANSMOG_SEARCH_UPDATED")

	--C_TransmogCollection.EndSearch()
	self.jumpToVisualID = nil
	for i, frame in ipairs(BW_WardrobeCollectionFrame.ContentFrames) do
		frame:Hide()
	end

	WardrobeCollectionFrame.selectedTransmogTab = TAB_ITEMS
	BW_WardrobeCollectionFrame.selectedTransmogTab = TAB_ITEMS

	WardrobeCollectionFrame.selectedCollectionTab = TAB_ITEMS
	BW_WardrobeCollectionFrame.selectedCollectionTab = TAB_ITEMS

	addon:InitTables()
	SetsDataProvider:ClearSets()
	addon:ClearCache()

end


function BetterWardrobeSetsCollectionMixin:HandleKey(key)
	if (not self:GetSelectedSetID()) then
		return false
	end

	local selectedSetID = self:GetSelectedSetID()
	local _, index = SetsDataProvider:GetBaseSetByID(selectedSetID)
	if (not index) then
		return
	end

	if (key == WARDROBE_DOWN_VISUAL_KEY) then
		index = index + 1
	elseif (key == WARDROBE_UP_VISUAL_KEY) then
		index = index - 1
	end

	local sets = SetsDataProvider:GetBaseSets()
	index = Clamp(index, 1, #sets)
	self:SelectSet(sets[index].setID)
	self:ScrollToSet(sets[index].setID)
end


function BetterWardrobeSetsCollectionMixin:ScrollToSet(setID)
	local totalHeight = 0
	local scrollFrameHeight = self.ScrollFrame:GetHeight()
	local buttonHeight = self.ScrollFrame.buttonHeight
	for i, set in ipairs(SetsDataProvider:GetBaseSets()) do
		if (set.setID == setID) then
			local offset = self.ScrollFrame.scrollBar:GetValue()
			if (totalHeight + buttonHeight > offset + scrollFrameHeight) then
				offset = totalHeight + buttonHeight - scrollFrameHeight
			elseif (totalHeight < offset) then
				offset = totalHeight
			end
			self.ScrollFrame.scrollBar:SetValue(offset, true)
			break
		end
		totalHeight = totalHeight + buttonHeight
	end
end


function BW_WardrobeCollectionFrame_OnKeyDown(self, key)
	if (self.tooltipCycle and key == WARDROBE_CYCLE_KEY) then
		self:SetPropagateKeyboardInput(false)
		if (IsShiftKeyDown()) then
			self.tooltipSourceIndex = self.tooltipSourceIndex - 1
		else
			self.tooltipSourceIndex = self.tooltipSourceIndex + 1
		end
		self.tooltipContentFrame:RefreshAppearanceTooltip()
	elseif (key == WARDROBE_PREV_VISUAL_KEY or key == WARDROBE_NEXT_VISUAL_KEY or key == WARDROBE_UP_VISUAL_KEY or key == WARDROBE_DOWN_VISUAL_KEY) then
		if (self.activeFrame:CanHandleKey(key)) then
			self:SetPropagateKeyboardInput(false)
			self.activeFrame:HandleKey(key)
		else
			self:SetPropagateKeyboardInput(true)
		end
	else
		self:SetPropagateKeyboardInput(true)
	end
end


function addon.Sets:SelectedVariant(setID)
	local baseSetID = C_TransmogSets.GetBaseSetID(setID) --or setID
	if not baseSetID then return end

	local variantSets = SetsDataProvider:GetVariantSets(baseSetID)
	if not variantSets then return end
	
	local useDescription = (#variantSets > 0)
	local targetSetID = WardrobeCollectionFrame.SetsCollectionFrame:GetDefaultSetIDForBaseSet(baseSetID)
	local match = false

	for i, data in ipairs(variantSets) do
		if addon.chardb.profile.collectionList["set"][data.setID] then
			match = data.setID
		end
	end

	if useDescription then
		local setInfo = C_TransmogSets.GetSetInfo(targetSetID)
		local matchInfo = match and C_TransmogSets.GetSetInfo(match).description or nil

		return targetSetID, setInfo.description, match, matchInfo
	end
end