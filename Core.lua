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
addon.UI = {}
addon.Init = {}
local newTransmogInfo  = {["latestSource"] = NO_TRANSMOG_SOURCE_ID} --{[99999999] = {[58138] = 10}, }
addon.TRANSMOG_SET_FILTER = {}
_G[addonName] = {}

local playerInv_DB
local Profile
local playerNme
local realmName
local playerClass, classID,_


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
		DressUpFrame:SetWidth(value)
		DressUpFrame.BW_ResizeFrame = true
	elseif info.arg == "DR_Height" then
		DressUpFrame:SetHeight(value)
		DressUpFrame.BW_ResizeFrame = true
	elseif info.arg == "DR_OptionsEnable" then
		if not Profile.DR_OptionsEnable then
			addon:DressingRoom_Disable()
		else
			addon:DressingRoom_Enable()
		end
	elseif info.arg == IgnoreClassRestrictions or info.arg == IgnoreClassLookalikeRestrictions then 
		--addon.extraSetsCache = nil
		addon.Init:BuildDB()

	elseif info.arg == "ShowAdditionalSourceTooltips" then
		C_TransmogCollection.SetShowMissingSourceInItemTooltips(value);

	elseif info.arg == "ExtraLargeTransmogArea" or info.arg == "LargeTransmogArea" then 
		WardrobeFrame.extended = false
		addon.ExtendTransmogView()
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
						
						IgnoreClassRestrictions = {
							order = 1.2,
							name = L["Ignore Class Restriction Filter"],
							type = "toggle",
							width = 1.3,
							arg = "IgnoreClassRestrictions",
						},
						IgnoreClassLookalikeRestrictions = {
							order = 1.3,
							name = L["Only for Raid Lookalike/Recolor Sets"],
							type = "toggle",
							width = 1.4,
							arg = "IgnoreClassLookalikeRestrictions",
							disabled = function() return not addon.Profile.IgnoreClassRestrictions end,
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
							LargeTransmogArea = {
							order = 1.1,
							name = L["Larger Transmog Area"],
							type = "toggle",
							width = 1.2,
							arg = "LargeTransmogArea",
							desc = L["LargeTransmogArea_Tooltip"],
						},
						ExtraLargeTransmogArea = {
							order = 1.2,
							name = L["Extra Large Transmog Area"],
							type = "toggle",
							width = 1.4,
							arg = "ExtraLargeTransmogArea",
							desc = L["ExtraLargeTransmogArea_Tooltip"],
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
								width = "full",
								disabled = false,
							},
							TooltipPreview_MogOnly = {
								type = "toggle",
								order = 2,
								name = L["Only transmogrification items"],
								width = 1.875,
							},
							TooltipPreview_Modifier = {
								type = "select",
								order = 3,
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
								width = 1.2,
							},
							TooltipPreview_Overlap = {
								order = 4,
								name = L["Prevent Comparrison Overlap"],
								type = "toggle",
								width = "full",
								desc = L["TooltipPreview_Overlap_Tooltip"],
							},
							TooltipPreview_Zoom = {
								order = 5,
								name = L["Zoom:"],
								type = "description",
								width = .4,
								fontSize = "medium",
							},
							TooltipPreview_ZoomWeapon = {
								order = 6,
								name = L["On Weapons"],
								type = "toggle",
								width = .8,
							},
							TooltipPreview_ZoomItem = {
								order = 7,
								name = L["On Clothes"],
								type = "toggle",
								width = .675,
							},
							TooltipPreview_ZoomModifier = {
								type = "select",
								order = 8,
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
								width = 1.2,
							},
							TooltipPreview_Dress = {
								order = 9,
								name = L["Dress Preview Model"],
								type = "toggle",
								width = 1.2,
								desc = L["TooltipPreview_Dress_Tooltip"],
							},
							TooltipPreview_DressingDummy = {
								order = 10,
								name = L["Use Dressing Dummy Model"],
								type = "toggle",
								width = 1.6,
								desc = L["TooltipPreview_DressingDummy"],
							},

							TooltipPreviewRotate = {
								order = 11,
								name = L["Auto Rotate"],
								type = "toggle",
								width = 1.2,
								arg = "tooltipRotate",
								desc = L["TooltipPreviewRotate_Tooltip"],
							},
							TooltipPreview_MouseRotate = {
								type = "toggle",
								order = 12,
								name = L["Rotate with mouse wheel"],
								width = 1.6,
								desc = L["TooltipPreview_MouseRotate_Tooltip"],
							},
							TooltipPreview_Anchor = {
								width = 1.2,
								type = "select",
								order = 13,
								name = L["Anchor point"],
								values = {
									vertical = "Top/bottom",
									horizontal = "Left/right",
								},
								width = 1.2,
								desc = L["TooltipPreview_Anchor_Tooltip"],
							},
							TooltipPreview_Spacer1 = {
								order = 13.1,
								name = " ",
								type = "description",
								width = .4,
								fontSize = "medium",
								width = 1.6
							},
							TooltipPreview_Width = {
								type = "range",
								order = 14,
								name = L["Width"],
								step = 1,
								min = 100,
								max = 500,
								arg = "tooltipWidth",
								width = 1,
							},
							TooltipPreview_Height = {
								type = "range",
								order = 15,
								name = L["Height"],
								step = 1,
								min = 100,
								max = 500,
								arg = "tooltipHeight",
								width = 1,
							},
							TooltipPreview_Reset = {
								type = "execute",
								order = 15.1,
								name = L["Reset"],
								func = function() 
									addon.tooltip:SetWidth(280)
									addon.tooltip:SetHeight(380)
									addon.Profile.TooltipPreview_Width = 280
									addon.Profile.TooltipPreview_Height = 380
								end,
							},
							TooltipPreview_CustomModel = {
								type = "toggle",
								order = 16,
								name = L["Use custom model"],
								width = 1,
								--hidden = true,
							},
							TooltipPreview_CustomWarning = {
								order = 16.1,
								name = L["CUSTOM_MODEL_WARNING"],
								type = "description",
								width = 2,
								fontSize = "small",
							},
							TooltipPreview_CustomRace = {
								type = "select",
								order = 17,
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
								--hidden = true,
							},
							TooltipPreview_CustomGender = {
								type = "select",
								order = 18,
								name = L["Model gender"],
								values = {
									[0] = MALE,
									[1] = FEMALE,
								},
								disabled = function() return not addon.Profile.TooltipPreview_CustomModel or not addon.Profile.ShowTooltipPreview end,
								width = 1.2,
								--hidden = true, 
							},
						},
				},
				dressingroom_settings={
					name = " ",
					type = "group",
					inline = true,
					order = 5,
					disabled = function() return not addon.Profile.DR_OptionsEnable end,
					args={
						Options_Header_2 = {
							order = 1,
							name = L["Dressing Room Options"],
							type = "header",
							width = "full",
						},
						DR_OptionsEnable = {
							order = 1.2,
							name = L["Enable"],
							type = "toggle",
							disabled = false, 
							width = "full",
							arg = "DR_OptionsEnable"
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
							func = function() 
								DressUpFrame:SetWidth(450)
								DressUpFrame:SetHeight(545) 
								addon.Profile.DR_Width = 450
								addon.Profile.DR_Height = 545
								DressUpFrame.BW_ResizeFrame = false
							end,
						},
					},
				},
			},
		},
	},
}
local subTextFields={}
local itemSub_options = {
	name = "BetterWardrobe",
	type = 'group',
	childGroups = "tab",
	inline = false,
	args = {

		settings={
			name = "Items",
			type = "group",
			--inline = true,
			order = 0,
			inline = false,
			childGroups = "tab",
			args={
				BaseItem = {
					order = 1,
					name = L["Base Item ID"],
					type = "input",
					width = 1,
					set = function(info, value) subTextFields[1] = value end,
					get = function(info) return subTextFields[1] end,
					validate = function(info, value) 
						local id = tonumber(value)
						if not id then return L["Not a valid itemID"] end

						local itemEquipLoc1 = GetItemInfoInstant(tonumber(value)) 

						if itemEquipLoc1 == nil then 
						--message(itemID.." not a valid itemID")
								return L["Not a valid itemID"]
						else 
							return true
						end
					end,
				},	
				ReplacementItem = {				
					order = 2,
					name = L["Replacement Item ID"],
					type = "input",
					width = 1,
					set = function(info, value) subTextFields[2] = value end,
					get = function(info) return subTextFields[2] end,
					validate = function(info, value) 
						local id = tonumber(value)
						if not id then return L["Not a valid itemID"] end

						local itemEquipLoc1 = GetItemInfoInstant(tonumber(value)) 

						if itemEquipLoc1 == nil then 
						--message(itemID.." not a valid itemID")
								return L["Not a valid itemID"]
						else 
							return true
						end
					end,
				},	
				AddButton = {				
							order = 3,
							name = L["Add"],
							type = "execute",
							width = 1,
							func = function(info) 
								addon.SetItemSubstitute(subTextFields[1], subTextFields[2])
							end,

							validate = function(info, value) 
								local _, _, _, itemEquipLoc1 = GetItemInfoInstant(tonumber(subTextFields[1]) )
								local _, _, _, itemEquipLoc2 = GetItemInfoInstant(tonumber(subTextFields[2]) )

								if itemEquipLoc1 ~= itemEquipLoc2 then 
									return L["Item Locations Don't Match"] 
								else
									return true
								end
							end,
							},	
				settings={
					name = L["Saved Item Substitutes"],
					type = "group",
					order = 5,
					inline = true,
					args = {},
					plugins= {},
				},
			},
		},
	},
}


function addon.RefreshSubItemData()
	local function RemoveItemSubstitute(itemID)
	addon:RemoveItemSubstitute(itemID)
	end
	local args = {} 
	for i, data in pairs(addon.itemsubdb.profile.items) do
		args["BaseItem"..i] = {
			order = i,
			name = function(info)
				local text = ("item: %d - %s ==> item: %d - %s"):format(data.subID, data.subLink or "", i, data.itemLink or "")
				return text 
			end,
			type = "description",
			width = 2.5,
			disabled = false,
		}

		args["AddButton"..i] = {				
			order = i+2,
			name = L["Remove"],
			type = "execute",
			width = .5,
			func = function()   
					return RemoveItemSubstitute(i) end,
		}	
	end
	itemSub_options.args.settings.args.settings.plugins["items"] = args
end

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
		TooltipPreview_ZoomItemModifier = "None",
		TooltipPreview_CustomRace = 1,
		TooltipPreview_CustomGender = 0,
		TooltipPreview_DressingDummy = false, 
		IgnoreClassRestrictions = false,
		ExtraLargeTransmogArea = false,
	}
}

local char_defaults = {
	profile = {
		item = {},
		set = {},
		extraset = {},
		favorite = {},
		favorite_items = {},
		outfits = {},
		lastTransmogOutfitIDSpec = {},
		collectionList = {item = {}, set = {}, extraset = {}, name = "CollectionList"},
		selectedCollectionList = 1,
		lists = {},
		listUpdate = false,
	}
}

local savedsets_defaults = {
		profile = {},
		global = {sets={}, itemsubstitute = {}, outfits = {}, updates = {},},
}

local itemsub_defaults = {
		profile = {items = {}}
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
	_,playerClass, classID = UnitClass("player")


	self.db = LibStub("AceDB-3.0"):New("BetterWardrobe_Options", defaults, true)
	options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	options.args.profiles.name = L["Profiles - Options Settings"]

	self.chardb = LibStub("AceDB-3.0"):New("BetterWardrobe_CharacterData", char_defaults)
	options.args.charprofiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.chardb)
	options.args.charprofiles.name = L["Profiles - Collection Settings"]

	self.setdb = LibStub("AceDB-3.0"):New("BetterWardrobe_SavedSetData", savedsets_defaults)

	self.itemsubdb = LibStub("AceDB-3.0"):New("BetterWardrobe_SubstituteItemData", itemsub_defaults, true)
	local profile = self.setdb:GetCurrentProfile()

	--self.setdb.global[profile] = self.setdb.char
	addon.SelecteSavedList = false
	options.args.subitems = itemSub_options
	options.args.subitems.name = L["Item Substitution"]

	options.args.subitems.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.itemsubdb)


	LibStub("AceConfigRegistry-3.0"):ValidateOptionsTable(options, addonName)
	LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, options)

	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BetterWardrobe", "BetterWardrobe")
	self.db.RegisterCallback(addon, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(addon, "OnProfileCopied", "RefreshConfig")

	self.itemsubdb.RegisterCallback(addon, "OnProfileReset", "RefreshSubItemData")	


	--WardrobeTransmogFrameSpecDropDown_Initialize()

	--BWData = BWData or {}

	addon.Profile = self.db.profile
	Profile = addon.Profile
	addon.Init:InitDB()
	addon.Init:Blizzard_Wardrobe()
	--C_Timer.After(0.2, function()
		--addon.SetItemSubstitute(1314, 9780)
		addon.Init:BuildUI()
		addon.Init:BuildTooltips()
		addon.Init:DressingRoom()
		--addon.SetSortOrder(false)
		addon.Init:BuildCollectionList()
		addon.Init:BuildTransmogVendorUI()
		addon.Init:BuildCollectionJournalUI()
		
	WardrobeFilterDropDown_OnLoad(WardrobeCollectionFrame.FilterDropDown)
	--WardrobeCollectionFrame.ItemsCollectionFrame:SetActiveSlot
--end )

	C_Timer.After(0.5, function()
		addon.RefreshSubItemData()
	end)
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

				--WardrobeCollectionFrame.ItemsCollectionFrame.RightShoulderCheckbox:Show() 
end