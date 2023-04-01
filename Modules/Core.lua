--	///////////////////////////////////////////////////////////////////////////////////////////
--
--	Better Wardrobe and Collection
--	Author: SLOKnightfall
--	Wardrobe and Collection: Adds additional functionality and sets to the transmog and collection areas
--
--
--	///////////////////////////////////////////////////////////////////////////////////////////
	local CONFIG = ...
	local ADDON, Addon = CONFIG:match('[^_]+'), _G[CONFIG:match('[^_]+')]
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
addon.Plugins = {}
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
		--addon.preview.rotate:SetShown(value)	

	elseif info.arg == "tooltipWidth" then
		addon.preview:SetWidth(value)

	elseif info.arg == "tooltipHeight" then
		addon.preview:SetHeight(value)

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
		---C_TransmogCollection.SetShowMissingSourceInItemTooltips(value)
		SetCVar("missingTransmogSourceInItemTooltips",value)

	elseif info.arg == "ExtraLargeTransmogArea" or info.arg == "LargeTransmogArea" then
		addon.TransmogVendorSizeUpdated = false
		addon.ExtendTransmogView()
	elseif info.arg == "ExtraLargeTransmogAreaMax" then
		addon.ExtendTransmogView(true)

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

local screenWidth =  math.floor(UIParent:GetWidth())
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
			name = L["Options"],
			type = "group",
			childGroups = "tab",
			inline = false,
			order = 0,
			args={
				general_settings={
					name = L["Settings"],
					type = "group",
					childGroups = "tree",
					inline = false,
					order = 1,
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
							width = "full",--1.3,
							arg = "IgnoreClassRestrictions",
						},
						IgnoreClassLookalikeRestrictions = {
							order = 1.3,
							name = L["Only for Raid Lookalike/Recolor Sets"],
							type = "toggle",
							width = 1.4,
							arg = "IgnoreClassLookalikeRestrictions",
							disabled = function() return not addon.Profile.IgnoreClassRestrictions end,
							hidden = true,
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
							width = 1.8,
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
						ExtraLargeTransmogAreaMax = {
							order = 1.3,
							name = L["Max Width"],
							type = "range",
							width = "full",
							min = 1200,
							max = screenWidth,
							step = 1,
							bigStep = 100,
							width = 1.6,
							arg = "ExtraLargeTransmogAreaMax",
							desc = L["ExtraLargeTransmogAreaMax_Tooltip"],
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
						ShowVisualIDTooltips = {
							order = 7.1,
							name = L["Show Item Visual ID"],
							type = "toggle",
							width = "full",
						},
						ShowILevelTooltips = {
							order = 7.1,
							name = L["Show ILevel"],
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
						ShowTokenTooltips = {
							order = 10,
							name = L["Show Token Information"],
							type = "toggle",
							width = 1.6,
							disabled = function() return not addon.Profile.ShowTooltips end,
						},
						ShowWarningTooltips = {
							order = 10,
							name = L["Show unable to uses as transmog warning"],
							type = "toggle",
							width = 1.6,
							disabled = function() return not addon.Profile.ShowTooltips end,
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
								width = 1.2,
							},
							TooltipPreview_Modifier = {
								type = "select",
								order = 2,
								name = L["Only show if modifier is pressed"],
								values = function()
											local tbl = {
												None = L["None"],
											}
											for k,v in pairs(addon.Globals.mods) do
												tbl[k] = k
											end
											return tbl
										end,
								width = 1.2,
							},
							TooltipPreview_MogOnly = {
								type = "toggle",
								order = 2,
								name = L["Only transmogrification items"],
								width = 1.2,
							},
							TooltipPreview_Tokens = {
								type = "toggle",
								order = 2,
								name = L["Try to preview armor tokens"],
								width = 1.875,
							},

							TooltipPreview_Overlap = {
								order = 4,
								name = L["Prevent Comparison Overlap"],
								type = "toggle",
								width = "full",
								desc = L["TooltipPreview_Overlap_Tooltip"],
								hidden = true,
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
											}
											for k,v in pairs(addon.Globals.mods) do
												tbl[k] = k
											end
											return tbl
										end,
								width = 1.2,
								hidden = true,
							},
							TooltipPreview_Spacer1 = {
								order = 8.1,
								name = " ",
								type = "description",
								width = 1,
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
								TooltipPreview_SwapDefault = {
								order = 9,
								name = L["Default to Human Form"],
								type = "toggle",
								width = 1.2,
								desc = L["TooltipPreview_Dress_Tooltip"],
							},
								TooltipPreview_SwapModifier = {
								type = "select",
								order = 10.1,
								name = L["Only swap if modifier is pressed"],
								values = function()
											local tbl = {
												None = "None",
											}
											for k,v in pairs(addon.Globals.mods) do
												tbl[k] = k
											end
											return tbl
										end,
								width = 1.2,
								hidden = false,
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
									vertical = L["Top/bottom"],
									horizontal = L["Left/right"],
								},
								width = 1.2,
								desc = L["TooltipPreview_Anchor_Tooltip"],
							},
							TooltipPreview_Spacer2 = {
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
									addon.preview:SetWidth(280)
									addon.preview:SetHeight(380)
									addon.Profile.TooltipPreview_Width = 280
									addon.Profile.TooltipPreview_Height = 380
								end,
							},
							TooltipPreview_CustomModel = {
								type = "toggle",
								order = 16,
								name = L["Use custom model"],
								width = 1,
								hidden = true,
							},
							TooltipPreview_CustomWarning = {
								order = 16.1,
								name = L["CUSTOM_MODEL_WARNING"],
								type = "description",
								width = 2,
								fontSize = "small",
								hidden = true,

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
								hidden = true,
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
								hidden = true,
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
							width = "full",
						},
						DR_DimBackground = {
							order = 4,
							name = L["Dim Backround Image"],
							type = "toggle",
						},
						DR_HideBackground = {
							order = 5,
							name = L["Hide Backround Image"],
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
						DR_ResizeWindow = {
							order = 9,
							name = L["Resize Window"],
							type = "toggle",
							width = "full",
						},
						DR_Width = {
							type = "range",
							order = 10,
							name = L["Width"],
							step = 1,
							min = 300,
							max = 1000,
							arg = "DR_Width",
							disabled = function() return not addon.Profile.DR_ResizeWindow end,
						},
						DR_Height = {
							type = "range",
							order = 11,
							name = L["Height"],
							step = 1,
							min = 300,
							max = 1000,
							arg = "DR_Height",
							disabled = function() return not addon.Profile.DR_ResizeWindow end,
						},
						DR_ScaleReset = {
							type = "execute",
							order = 12,
							name = L["Reset"],
							func = function()
								local defaultWidth, defaultHeight = 450, 545 
								DressUpFrame:SetWidth(defaultWidth)
								DressUpFrame:SetHeight(defaultHeight)
								addon.Profile.DR_Width = defaultWidth
								addon.Profile.DR_Height = defaultHeight
								DressUpFrame.BW_ResizeFrame = false
							end,
							disabled = function() return not addon.Profile.DR_ResizeWindow end,
						},
					},
				},
			},
		},
			},
		},
		list_profiles ={
			name = L["List Profiles"],
			type = "group",
			childGroups = "tab",
			inline = false,
			order = 6,
			args={
				description = {
							order = 1,
							name = L["Profiles for sharing the various lists across characters"],
							type = "description",
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
			name = L["Items"],
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
				local text = (L["item: %d - %s \n==>\nitem: %d - %s"]):format(data.subID, data.subLink or "", i, data.itemLink or "")
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

function addon.RefreshCollectionListData()
	BW_UIDropDownMenu_SetSelectedID(BW_CollectionList_Dropdown, addon.CollectionList:SelectedCollectionList())
end


local savedOutfits_options = {
	name = "BetterWardrobe",
	type = 'group',
	childGroups = "tab",
	inline = false,
	args = {
	},
}

function addon.RefreshOutfitData()
	local function RemoveCharacterData(name)
		addon.setdb.global.sets[name] = nil

		addon.RefreshOutfitData()
		--addon.RefreshSaveOutfitDropdown()
	end

	local args = {}
	local i = 1
	for name, data in pairs(addon.setdb.global.sets) do
		args["BaseItem"..i] = {
			order = i,
			name = function(info)
				return name
			end,
			type = "description",
			width = 2.5,
			disabled = false,
		}

		args["AddButton"..i] = {				
			order = i + .2,
			name = L["Remove"],
			type = "execute",
			width = .5,
			func = function()  
					return RemoveCharacterData(name) end,
		}	

		i = i + 1
	end
	savedOutfits_options.args = args
end

--ACE Profile Saved Variables Defaults
local defaults = {
	profile = {
		['*'] = true,
		PartialLimit = 4,
		ShowHidden = false,
		TSM_Market = "DBMarket",
		DR_HideBackground = false,
		DR_HideWeapons = false,
		DR_StartUndressed = false,
		DR_HideShirt = false,
		DR_HideTabard = false,	
		TooltipPreview_Width = 300,
		TooltipPreview_Height = 300,
		DR_Width = 450,
		DR_Height = 545,
		ShowItemIDTooltips = false,
		TooltipPreview_Show = false,
		TooltipPreview_Anchor = "horizontal",
		TooltipPreviewRotate = false,
		TooltipPreview_Modifier = L["None"],
		TooltipPreview_ZoomItemModifier = L["None"],
		TooltipPreview_SwapModifier = L["None"],
		TooltipPreview_CustomRace = 1,
		TooltipPreview_CustomGender = 0,
		TooltipPreview_DressingDummy = false,
		IgnoreClassRestrictions = false,
		ExtraLargeTransmogArea = false,
		ExtraLargeTransmogAreaMax = screenWidth,
	}
}
local DB_Defaults = {
	char_defaults = {
		profile = {
			item = {},
			set = {},
			extraset = {},
			outfits = {},
			lastTransmogOutfitIDSpec = {},
			listUpdate = false,
		}
	},

	savedsets_defaults = {
		profile = {autoHideSlot = {}, sorting = 1,},
		global = {sets={}, itemsubstitute = {}, outfits = {}, updates = {},},

	},

	collectionList_defaults = {	
		profile = {
			collectionList = {item = {}, set = {}, extraset = {}, name = "CollectionList"},
			selectedCollectionList = 1,
			lists  = {{item = {}, set = {}, extraset = {}, name = "CollectionList"},},
		},
	},

	list_defaults = {
		profile = {item = {}, set = {}, extraset = {}, },
	},

 	itemsub_defaults = {
		profile = {items = {}}
	},

	charSavedOutfits_defaults = {
		char = {			
			item = {},
			set = {},
			extraset = {},
			outfits = {},
			lastTransmogOutfitIDSpec = {},
			listUpdate = false,
		}
	},
	collection_cache_defaults = {
		global = {sets={}, },

	},
}

local firstRun = false
local function UpdateDB()
	local characterDB = BetterWardrobe_CharacterData
	local listDB = BetterWardrobe_ListData
	local favoriteDB = listDB.favoritesDB or {}
	local collectionDB = listDB.collectionListDB or {}
	local hiddenDB = listDB.HiddenAppearanceDB or {}
	local outfitDB = listDB.OutfitDB or {}
	--local favoriteDB = self.favoriteListDB
	--local collectionDB = self.collectionListDB

	--Check to see if it is a new install
	if not characterDB or (characterDB and not characterDB.profiles) then firstRun = true; return end
	--Update 1. splt favorites and collection tables from characterDB. Update collections to allow multiple lists  10/27/20

	if listDB.lastUpdte ~= 1 then
	--Populate profile keys
		favoriteDB.profileKeys = CopyTable(characterDB.profileKeys)
		collectionDB.profileKeys = CopyTable(characterDB.profileKeys)
		hiddenDB.profileKeys = CopyTable(characterDB.profileKeys)

		--Create profile table
		favoriteDB.profiles = {}
		collectionDB.profiles = {}
		hiddenDB.profiles = {}

		--local profiles  = self.chardb:GetProfiles()
		--do the first db update to allow multiple lists

		for profile, data in pairs(characterDB.profiles) do
			data.lists = data.lists or {}

			if #data.lists == 0 and data.collectionList then
				local listcopy = CopyTable(data.collectionList)
				listcopy.name = L["Collection List"]
				tinsert(data.lists, listcopy)
			end
			data.collectionList = nil
		end
		
		-- do the second update to split into seperate profiles
		for profile, data in pairs(characterDB.profiles) do
			favoriteDB.profiles[profile] = {}
			if data.favorite_items then
				favoriteDB.profiles[profile].item = CopyTable(data.favorite_items)
				data.favorite_items = nil
			end
			if data.favorite then
				favoriteDB.profiles[profile].extraset = CopyTable(data.favorite)
				data.favorite = nil
			end

			collectionDB.profiles[profile] = {}
			if  data.selectedCollectionList then
				collectionDB.profiles[profile].selectedCollectionList = data.selectedCollectionList
				data.selectedCollectionList = nil
			end

			if data.lists then
				collectionDB.profiles[profile].lists = CopyTable(data.lists)
				data.lists = nil
			end

			hiddenDB.profiles[profile] = {}
			if data.item then
				hiddenDB.profiles[profile].item = CopyTable(data.item)
				data.item = nil
			end

			if data.set then
				hiddenDB.profiles[profile].set = CopyTable(data.set)
				data.set = nil
			end

			if data.extraset then
				hiddenDB.profiles[profile].extraset = CopyTable(data.extraset)
				data.extraset = nil
			end


			--collectionDB.profiles[profile].collectionList = nil
			
			
		end

		outfitDB.profileKeys = {}
		outfitDB.char = {}
		for profile, data in pairs(characterDB.profileKeys) do
			outfitDB.profileKeys[profile] = profile

			if characterDB.profiles[data] then
				outfitDB.char[profile] = {}
				if characterDB.profiles[data].outfits then
					outfitDB.char[profile].outfits = CopyTable(characterDB.profiles[data].outfits)
				end
				if characterDB.profiles[data].lastTransmogOutfitIDSpec then
					outfitDB.char[profile].lastTransmogOutfitIDSpec = CopyTable(characterDB.profiles[data].lastTransmogOutfitIDSpec)
				end
			end
		end

		listDB.lastUpdte = 1
	end
end

--Updates the db to reflect new set indexes
local function UpdateDB_8_4()
	BetterWardrobe_Updates = BetterWardrobe_Updates or {}

	if not BetterWardrobe_Updates["8_4"] then
		local characterDB = BetterWardrobe_CharacterData
		local listDB = BetterWardrobe_ListData
		local favoriteDB = listDB.favoritesDB or {}
		local hiddenDB = listDB.HiddenAppearanceDB or {}

		if not favoriteDB.profiles then BetterWardrobe_Updates["8_4"] = true; return end

		for profile, data in pairs(favoriteDB.profiles) do
			local extraSets = {}
			if data.extraset then
				for setid, value in pairs(data.extraset) do
					if setid > 100000 then
						extraSets[setid / 100000] = value
					else
						extraSets[setid + 10000] = value
					end
				end
				data.extraset = extraSets
			end
		end

		for profile, data in pairs(hiddenDB.profiles) do
			local extraSets = {}
			if data.extraset then
				for setid, value in pairs(data.extraset) do
					if setid > 100000 then
						extraSets[setid / 100000] = value

					else
						extraSets[setid + 10000] = value
					end
				end

				data.extraset = extraSets
			end
		end

		BetterWardrobe_Updates["8_4"] = true
	end
end

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

local f = CreateFrame("Frame", nil, UIParent)
f:SetHeight(1)
f:SetWidth(1)
f:SetPoint("TOPLEFT", UIParent, "TOPRIGHT")
f.model = CreateFrame("DressUpModel", nil, UIParent)
--f.model:SetPoint("CENTER", UIParent, "CENTER")
f.model:SetPoint("TOPLEFT", UIParent, "TOPRIGHT")
f.model:SetHeight(1)
f.model:SetWidth(1)
f.model:SetModelScale(1)
f.model:Hide()
f.model:SetAutoDress(false)
f.model:SetUnit("PLAYER")
addon.frame = f

---Ace based addon initilization
function addon:OnInitialize()
	local DB_Defaults = DB_Defaults
	BetterWardrobe_ListData = BetterWardrobe_ListData or {}
	local listDB = BetterWardrobe_ListData
	listDB.favoritesDB = listDB.favoritesDB or {}
	listDB.collectionListDB = listDB.collectionListDB or {}
	listDB.HiddenAppearanceDB = listDB.HiddenAppearanceDB or {}
	listDB.OutfitDB = listDB.OutfitDB or {}

	UpdateDB()
	UpdateDB_8_4()

--Create all the profiled DB
	self.db = LibStub("AceDB-3.0"):New("BetterWardrobe_Options", defaults, true)
	options.args.settings.args.options = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	options.args.settings.args.options.name = L["Options Profiles"]
	options.args.settings.args.options.order = 2

	self.chardb = LibStub("AceDB-3.0"):New("BetterWardrobe_CharacterData", DB_Defaults.char_defaults)
	--options.args.list_profiles.args.charprofiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.chardb)
	--options.args.list_profiles.args.charprofiles.name = L["Profiles - Collection Settings"]

	self.setdb = LibStub("AceDB-3.0"):New("BetterWardrobe_SavedSetData", DB_Defaults.savedsets_defaults)
	self.itemsubdb = LibStub("AceDB-3.0"):New("BetterWardrobe_SubstituteItemData", DB_Defaults.itemsub_defaults, true)
	self.OutfitDB = LibStub("AceDB-3.0"):New(listDB.OutfitDB, DB_Defaults.charSavedOutfits_defaults)

	self.favoritesDB =  LibStub("AceDB-3.0"):New(listDB.favoritesDB, DB_Defaults.list_defaults)
	self.collectionListDB =  LibStub("AceDB-3.0"):New(listDB.collectionListDB, DB_Defaults.collectionList_defaults)
	self.HiddenAppearanceDB =  LibStub("AceDB-3.0"):New(listDB.HiddenAppearanceDB, DB_Defaults.list_defaults)
	self.char_savedOutfits = LibStub("AceDB-3.0"):New("BetterWardrobe_SavedOutfitData", charSavedOutfits_defaults, true)

	self.collectionCache = LibStub("AceDB-3.0"):New("BetterWardrobe_CollectionCache", collection_cache_defaults, true)


	local profile = self.setdb:GetCurrentProfile()
	--self.setdb.global[profile] = self.setdb.char
	addon.SelecteSavedList = false
	options.args.subitems = itemSub_options
	options.args.subitems.name = L["Item Substitution"]

	options.args.char_savedOutfits = savedOutfits_options
	options.args.char_savedOutfits.name = L["Saved Outfits"]

	options.args.subitems.args.options = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.itemsubdb)
	--options.args.char_savedOutfits.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.char_savedOutfits)

	options.args.list_profiles.args.favoriteLists = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.favoritesDB)
	options.args.list_profiles.args.favoriteLists.name = L["Favorite Items & Sets"]
	options.args.list_profiles.args.favoriteLists.order = 2

	options.args.list_profiles.args.collectionLists = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.collectionListDB)
	options.args.list_profiles.args.collectionLists.name = L["Collection List"]
	options.args.list_profiles.args.collectionLists.order = 3

	options.args.list_profiles.args.HiddenAppearanceDB = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.HiddenAppearanceDB)
	options.args.list_profiles.args.HiddenAppearanceDB.name = L["Hidden Items & Sets"]
	options.args.list_profiles.args.HiddenAppearanceDB.order = 4

	LibStub("AceConfigRegistry-3.0"):ValidateOptionsTable(options, addonName)
	LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, options)

	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BetterWardrobe", "BetterWardrobe")
	self.db.RegisterCallback(addon, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(addon, "OnProfileCopied", "RefreshConfig")
	self.collectionListDB.RegisterCallback(addon, "OnProfileChanged", "RefreshCollectionListData")
	self.itemsubdb.RegisterCallback(addon, "OnProfileReset", "RefreshSubItemData")	


	local PATRONS = {{},{title = 'Patrons', people = addon.Patrons},}
	local Credits = LibStub('Sushi-3.1').CreditsGroup(self.optionsFrame, PATRONS, 'Patrons |TInterface/Addons/BetterWardrobe/Images/Patreon:12:12|t')
	Credits:SetSubtitle(addonName .. ' is distributed for free and supported trough donations. A massive thank you to all the supporters on Patreon and Paypal who keep development alive. You can become a patron too at |cFFF96854patreon.com/SLOKnightfall|r.', 'https://www.patreon.com/SLOKnightfall')

	if firstRun then
		listDB.lastUpdte = 1
	end
end

local initialize
function addon:OnEnable()
	_,playerClass, classID = UnitClass("player")
	addon.Profile = self.db.profile
	Profile = addon.Profile

	addon.Init:InitDB()
	--addon.Init:BuildTooltips()
	addon.Init:DressingRoom()
	--addon.Init.LoadCollectionListModule()
	--BW_ColectionListFrameTemplate
	--addon.Init:BuildTooltips()
addon:InitTooltips()
	C_Timer.After(0.5, function()
		addon.RefreshSubItemData()
		addon.RefreshOutfitData()
	end)
	
	addon:RegisterEvent("TRANSMOG_COLLECTION_SOURCE_REMOVED", "EventHandler")
	addon:RegisterEvent("TRANSMOG_COLLECTION_SOURCE_ADDED", "EventHandler")
	if IsAddOnLoaded("Blizzard_Collections") then
		C_Timer.After(0.5, function() addon.Init:LoadModules() end)
	else
		addon:RegisterEvent("ADDON_LOADED", "EventHandler")
	end

	addon:RegisterEvent("PLAYER_ENTERING_WORLD", "EventHandler")

	--Cache any default Blizz Saved Sets
	addon.StoreBlizzardSets()
	initialize = true
end

--Hides default collection window when at transmog vendor
local function UpdateTransmogVendor()
	WardrobeCollectionFrame:Hide()
	BetterWardrobeCollectionFrame:Show()
	BetterWardrobeCollectionFrame:SetContainer(WardrobeFrame)
end

--Loads various modules and builds frames once the Blizzard_Collection addon is loaded
function addon.Init:LoadModules()
	--Check to make sure that the addon has completed loading
	if not initialize then
		C_Timer.After(0.5, function() addon.Init:LoadModules() end)
		return false
	end

	--Check to make sure that the Blizzard Frames have completed loading
	if not WardrobeTransmogFrame then
		C_Timer.After(0.5, function() addon.Init:LoadModules() end)
		return false
	end

	C_Timer.After(0, function() addon.Init:UpdateWardrobeEnhanced() end)

	local f = CreateFrame("Frame", "BetterWardrobeCollectionFrame", UIParent, "BetterWardrobeCollectionFrameTemplate" )
	--Hooks into the colection tabs and sets Better Wardobe when viewing the wardrobe collection
	addon:SecureHook(nil, "CollectionsJournal_UpdateSelectedTab", function(self)
		local selected = CollectionsJournal_GetTab(self)

		-- don't touch the wardrobe frame if it's used by the transmogrifier
		if (WardrobeCollectionFrame:GetParent() == self or not WardrobeCollectionFrame:GetParent():IsShown()) then
			if selected == 5 then
				HideUIPanel(WardrobeFrame)
				WardrobeCollectionFrame:Hide()
				BetterWardrobeCollectionFrame:SetContainer(self)
				if addon.ExtendedTransmogSwap then
					addon.ExtendedTransmogSwap:Show()
				end
			else
				WardrobeCollectionFrame:Hide()
				BetterWardrobeCollectionFrame:Hide()
				if addon.ExtendedTransmogSwap then
					addon.ExtendedTransmogSwap:Hide()
				end
			end
		end
	end)

	--addon.Init:LoadWardrobeModule()

	WardrobeFrame:HookScript("OnShow",  function() UpdateTransmogVendor() end)

	addon:SecureHook(WardrobeTransmogFrame, "GetRandomAppearanceID", function(self) BW_TransmogFrameMixin.GetRandomAppearanceID(self) end)
	addon:SecureHook(WardrobeTransmogFrame, "SelectSlotButton", function(self, slotButton, fromOnClick) BW_TransmogFrameMixin.SelectSlotButton(self, slotButton, fromOnClick) end)
	addon:SecureHook(WardrobeTransmogFrame, "EvaluateSecondaryAppearanceCheckbox", function(self) BW_TransmogFrameMixin.EvaluateSecondaryAppearanceCheckbox(self) end)
	addon:SecureHook(WardrobeTransmogFrame, "GetSelectedTransmogLocation", function(self) BW_TransmogFrameMixin.GetSelectedTransmogLocation(self) end)
	----addon:SecureHook(WardrobeTransmogFrame, "Update", function(self) BW_TransmogFrameMixin.Update(self) end)
	addon:SecureHook(WardrobeTransmogFrame, "SetPendingTransmog", function(self,...) BW_TransmogFrameMixin.Update(self,...) end)
	addon:SecureHook(WardrobeTransmogFrame, "GetSlotButton", function(self,...) BW_TransmogFrameMixin.GetSlotButton(self,...) end)
	--addon:SecureHook(WardrobeTransmogFrame, "OnTransmogApplied", function(self,...) BW_TransmogFrameMixin.OnTransmogApplied(self,...) end)
		
 	addon.Init:initCollectionList()
 	addon.Init:BuildCollectionList()
	addon.Init:BuildTransmogVendorUI()
	addon.Init.SortDropDown_Initialize()
	addon:UpdateCanIMogIt()
	addon:InitExtendedSetsSwap()
	addon.Init.SavedSetsDropDown_Initialize()
end

function addon:EventHandler(event, ...)
	if event == "ADDON_LOADED" and ... == "Blizzard_Collections" then
		addon.Init:LoadModules()
		addon:SendMessage("BW_ADDON_LOADED")
		addon:UnregisterEvent("ADDON_LOADED")
		
		C_Timer.After(0.5, function()
			WardrobeTransmogFrame.ToggleSecondaryAppearanceCheckbox.Label:ClearAllPoints()
			WardrobeTransmogFrame.ToggleSecondaryAppearanceCheckbox:ClearAllPoints()
			WardrobeTransmogFrame.ToggleSecondaryAppearanceCheckbox.Label:SetPoint("RIGHT", BetterWardrobeCollectionFrame.ItemsCollectionFrame.PagingFrame.PageText, "LEFT", -30, 0)
			WardrobeTransmogFrame.ToggleSecondaryAppearanceCheckbox:SetPoint("RIGHT", WardrobeTransmogFrame.ToggleSecondaryAppearanceCheckbox.Label, "LEFT", 0, 0)
		 end)

	elseif (event == "PLAYER_ENTERING_WORLD") then
		addon:SendMessage("BW_OnPlayerEnterWorld")
		C_Timer.After(1, function() addon:ResetSetsCollectionFrame() end)

	elseif (event == "TRANSMOG_COLLECTION_SOURCE_ADDED") then
		local x = ...
		BetterWardrobeCollectionFrameMixin:OnEvent(event, x)

	elseif (event == "TRANSMOG_COLLECTION_SOURCE_REMOVED") then
		local x = ...
		BetterWardrobeCollectionFrameMixin:OnEvent(event, x)
	end
end

local f=CreateFrame("Frame", nil, UIParent)
f:ClearAllPoints()
f:SetPoint("TOPRIGHT", 100, 100)
f:SetSize(1, 1)
f:Hide()
addon.prisonFrame = f