--///////////////////////////////////////////////////////////////////////////////////////////
--
-- Better Wardrobe and Collection
-- Author: SLOKnightfall
-- Wardrobe and Collection: Adds additional functionality and sets to the transmog and collection areas
--
--
--///////////////////////////////////////////////////////////////////////////////////////////
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
local GetItemInfoInstant = C_Item and C_Item.GetItemInfoInstant

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
		addon.Init:InitDB()
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
	return not C_AddOns.IsAddOnLoaded("TradeSkillMaster")
end

function optionHandler:TSMSources(info)
	local sources = {}
	local table = {}
	if (C_AddOns.IsAddOnLoaded("TradeSkillMaster")) then
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

	--local PATRONS = {{},{title = 'Patrons', people = addon.Patrons},}

local Patrons = {
	name = "Patrons |TInterface/Addons/BetterWardrobe/Images/Patreon:12:12|t",
	handler = optionHandler,
	get = "Getter",
	set = "Setter",
	type = 'group',
	childGroups = "tab",
	inline = false,
	args = {
			Patronss_Label = {
				order = 1,
				name = function() return addonName .. ' is distributed for free and supported trough donations. A massive thank you to all the supporters on Patreon and Paypal who keep development alive. You can become a patron too at |cFFF96854patreon.com/SLOKnightfall|r.\n\n\n', 'https://www.patreon.com/SLOKnightfall' end,
				type = "description",
				width = "full",

			},
			Patronss_Header = {
				order = 2,
				name = "Patrons",
				type = "header",
				width = "full",
			},

		},
}

local function addPatrons()
	for i, namex in ipairs(addon.Patrons) do
		Patrons.args["name"..i] = {
				order = i + 2,
				name = namex,
				type = "description",
				width = ".3",
			}
	end
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
							hidden = true,

						},
						ExtraLargeTransmogArea = {
							order = 1.2,
							name = L["Extra Large Transmog Area"],
							type = "toggle",
							width = 1.4,
							arg = "ExtraLargeTransmogArea",
							desc = L["ExtraLargeTransmogArea_Tooltip"],
							hidden = true,
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
							hidden = true,

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
							disabled = true,
							hidden = true,
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
	--BW_UIDropDownMenu_SetSelectedID(BW_CollectionList_Dropdown, addon.CollectionList:SelectedCollectionList())
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

--[[
	local function CopyCharacterData(name)

		--need to copy over default blizzard saved sets
		--print(name)
		--local profile = addon.setdb:GetCurrentProfile()

		--addon.setdb.global.sets[profile] = CopyTable(addon.setdb.global.sets[name])
--zx=addon.setdb.global.sets[name]
		--addon.setdb:CopyProfile(addon.setdb.global.sets[name], silent)

		--addon.RefreshOutfitData()
		--addon.RefreshSaveOutfitDropdown()
		--addon:RefreshConfig()
	end
]]--
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

		--args["CopyButton"..i] = {

			--order = i + .2,
			--name = L["Copy"],
			--type = "execute",
			--width = .5,
			--func = function()
			-- return CopyCharacterData(name) end,
	-- }

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
		CurrentFactionSets = true,
		ExtraLargeTransmogArea = false,
		ExtraLargeTransmogAreaMax = screenWidth,
		AutoApply = false,
		ItemSortMode = "Default",
		SetSortMode = "Default",
		JournalItemSortMode = 1, --addon.ItemSortMode.Default (SortingFunctions.lua loads after Core.lua, so a literal is used here)
		JournalItemSortReverse = false,
		ItemSortReverse = false,
		SetSortReverse = false,
		ShowAltAppearanceIcon = true,
		ShowOnlyAltAppearanceSets = false,
		ShowOnlyAltAppearanceItems = false,
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
	listDB.SituationPresetsDB = listDB.SituationPresetsDB or {}
	listDB.SharedSetsDB = listDB.SharedSetsDB or {}

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

	LibStub("AceConfig-3.0"):RegisterOptionsTable("Patrons", Patrons)

	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BetterWardrobe", "BetterWardrobe")
	self.patrons = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Patrons", "Patrons |TInterface/Addons/BetterWardrobe/Images/Patreon:12:12|t","BetterWardrobe")

	self.db.RegisterCallback(addon, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(addon, "OnProfileCopied", "RefreshConfig")
	self.collectionListDB.RegisterCallback(addon, "OnProfileChanged", "RefreshCollectionListData")
	self.itemsubdb.RegisterCallback(addon, "OnProfileReset", "RefreshSubItemData")

	--local PATRONS = {{},{title = 'Patrons', people = addon.Patrons},}
	--local Credits = LibStub('Sushi-3.1').CreditsGroup(self.optionsFrame, PATRONS, 'Patrons |TInterface/Addons/BetterWardrobe/Images/Patreon:12:12|t')
	--Credits:SetSubtitle(addonName .. ' is distributed for free and supported trough donations. A massive thank you to all the supporters on Patreon and Paypal who keep development alive. You can become a patron too at |cFFF96854patreon.com/SLOKnightfall|r.', 'https://www.patreon.com/SLOKnightfall')
	self.OutfitDB.char.lastTransmogOutfitIDSpec = {}

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

	--Stamp this character's class every login (not just when StoreBlizzardSets() runs on save) so the
	--character-picker popout (CreateCharacterPickerPopout, Data/DataBase.lua) can class-color the
	--roster for anyone who has logged in at least once since this was added, without needing them to
	--re-save a set first.
	addon.setdb.global.characterClass = addon.setdb.global.characterClass or {}
	addon.setdb.global.characterClass[addon.setdb:GetCurrentProfile()] = playerClass

	addon.Init:DressingRoom()
	--addon.Init.LoadCollectionListModule()
	addon:InitTooltips()
	addPatrons()
	addon:RegisterEvent("TRANSMOG_COLLECTION_SOURCE_REMOVED", "EventHandler")
	addon:RegisterEvent("TRANSMOG_COLLECTION_SOURCE_ADDED", "EventHandler")
	addon:RegisterEvent("PLAYER_ENTERING_WORLD", "EventHandler")

	--Cache any default Blizz Saved Sets
	---addon.StoreBlizzardSets()
	initialize = true
	--Blizzard_Collections/Transmog are .toc Dependencies now instead of forced here.

	C_Timer.After(1, function() addon.Init:LoadModules() end)
end

--Loads various modules and builds frames once the Blizzard_Collection addon is loaded
function addon.Init:LoadModules()
	--Check to make sure that the addon has completed loading
	if not initialize then
		C_Timer.After(0.5, function() addon.Init:LoadModules() end)
		return false
	end

	local f = CreateFrame("Frame", "BetterWardrobeCollectionFrame", TransmogFrame.WardrobeCollection, "BetterWardrobeCollectionFrameTemplate" )
	--Saved Sets tab (tab 4) re-enabled -- was hidden to work around renamed Outfit*->CustomSet* APIs, now fixed.
	--BetterWardrobeCollectionFrameTab4:Hide()
	addon:setFrames()
	addon.Init:InitFilterButtons()
	--Hooks into the colection tabs and sets Better Wardobe when viewing the wardrobe collection
	addon:SecureHook(nil, "CollectionsJournal_UpdateSelectedTab", function(self)
		local selected = CollectionsJournal_GetTab(self)

		-- don't touch the wardrobe frame if it's used by the transmogrifier
		if (WardrobeCollectionFrame:GetParent() == self or not WardrobeCollectionFrame:GetParent():IsShown()) then
			if selected == 5 then
				--HideUIPanel(WardrobeFrame)
				WardrobeCollectionFrame:Hide()
				BetterWardrobeCollectionFrame:Show()

				if addon.ExtendedTransmogSwap then
					addon.ExtendedTransmogSwap:Show()
				end
			else
				BetterWardrobeCollectionFrame:Hide()
				if addon.ExtendedTransmogSwap then
					addon.ExtendedTransmogSwap:Hide()
				end
			end
		end
	end)

	C_Timer.After(0, function()
		----addon:UpdatePetTracker()
	addon.Init:initCollectionList()
	addon.Init:BuildCollectionList()
		--BuildTransmogVendorUI stays disabled: TransmogVendor.xml isn't loaded by the .toc, unfinished/unwired.
		----addon.Init:BuildTransmogVendorUI()
		addon:UpdateCanIMogIt()
		----addon:InitExtendedSetsSwap()

		local selected = CollectionsJournal_GetTab(CollectionsJournal)
		BetterWardrobeCollectionFrame:SetShown(selected == 5)

		if C_AddOns.IsAddOnLoaded("ElvUI") then
			addon.ApplyElvUISkin()
		end

	end)
end

function addon:UpdateTabs()
	TransmogFrame.WardrobeCollection.TabHeaders:SetTabShown(TransmogFrame.WardrobeCollection.itemsTabID, true);
	TransmogFrame.WardrobeCollection.TabHeaders:SetTabShown(TransmogFrame.WardrobeCollection.setsTabID, false);
	TransmogFrame.WardrobeCollection.TabHeaders:SetTabShown(TransmogFrame.WardrobeCollection.custmSetsTabID, false);
	TransmogFrame.WardrobeCollection.TabHeaders:SetTabShown(TransmogFrame.WardrobeCollection.situationsTabID, false);

	--TransmogFrame.WardrobeCollection.TabHeaders:SetTabShown(TransmogFrame.WardrobeCollection.BW_SetsFrame2TabID, true);
	--TransmogFrame.WardrobeCollection.TabHeaders:SetTabShown(TransmogFrame.WardrobeCollection.extracustomsetsTabID, true);
end

--Self-contained: Transmog.lua's own TransmogWardrobeItemsMixin overrides are dead (inside a
--reference-only comment block), so this doesn't call into them.
local function BW_GetVendorSourceInfo(sourceID)
	return sourceID and C_TransmogCollection.GetSourceInfo(sourceID)
end

local function BW_GetVendorItemSourceName(sourceID)
	local sourceInfo = BW_GetVendorSourceInfo(sourceID)
	return sourceInfo and sourceInfo.name or ""
end

local function BW_ReverseComparator(comparator, reverse)
	if not reverse then return comparator end
	return function(a, b) return comparator(b, a) end
end

local BW_VENDOR_ITEM_SORT_COMPARATORS = {
	Alphabetic = function(element1, element2)
		return BW_GetVendorItemSourceName(element1.appearanceInfo.sourceID) < BW_GetVendorItemSourceName(element2.appearanceInfo.sourceID)
	end,
	Appearance = function(element1, element2)
		return element1.appearanceInfo.visualID < element2.appearanceInfo.visualID
	end,
	ItemSource = function(element1, element2)
		local info1 = BW_GetVendorSourceInfo(element1.appearanceInfo.sourceID)
		local info2 = BW_GetVendorSourceInfo(element2.appearanceInfo.sourceID)
		local type1 = (info1 and info1.sourceType) or 0
		local type2 = (info2 and info2.sourceType) or 0
		if type1 == type2 then
			return BW_GetVendorItemSourceName(element1.appearanceInfo.sourceID) < BW_GetVendorItemSourceName(element2.appearanceInfo.sourceID)
		end
		return type1 < type2
	end,
	Color = function(element1, element2)
		local result = addon:CompareItemColor(element1.appearanceInfo.visualID, element2.appearanceInfo.visualID)
		if result ~= nil then return result end
		return BW_GetVendorItemSourceName(element1.appearanceInfo.sourceID) < BW_GetVendorItemSourceName(element2.appearanceInfo.sourceID)
	end,
	Expansion = function(element1, element2)
		local sourceInfo1 = BW_GetVendorSourceInfo(element1.appearanceInfo.sourceID)
		local sourceInfo2 = BW_GetVendorSourceInfo(element2.appearanceInfo.sourceID)
		local expansion1 = addon.GetItemExpansionID(sourceInfo1 and sourceInfo1.itemID)
		local expansion2 = addon.GetItemExpansionID(sourceInfo2 and sourceInfo2.itemID)
		if expansion1 and expansion2 and expansion1 ~= expansion2 then
			return expansion1 > expansion2
		end
		return BW_GetVendorItemSourceName(element1.appearanceInfo.sourceID) < BW_GetVendorItemSourceName(element2.appearanceInfo.sourceID)
	end,
	ItemLevel = function(element1, element2)
		local sourceInfo1 = BW_GetVendorSourceInfo(element1.appearanceInfo.sourceID)
		local sourceInfo2 = BW_GetVendorSourceInfo(element2.appearanceInfo.sourceID)
		local itemID1 = sourceInfo1 and sourceInfo1.itemID
		local itemID2 = sourceInfo2 and sourceInfo2.itemID
		if itemID1 then C_Item.RequestLoadItemDataByID(itemID1) end
		if itemID2 then C_Item.RequestLoadItemDataByID(itemID2) end
		local ilvl1 = itemID1 and select(4, C_Item.GetItemInfo(itemID1))
		local ilvl2 = itemID2 and select(4, C_Item.GetItemInfo(itemID2))
		if ilvl1 and ilvl2 and ilvl1 ~= ilvl2 then
			return ilvl1 > ilvl2
		end
		return BW_GetVendorItemSourceName(element1.appearanceInfo.sourceID) < BW_GetVendorItemSourceName(element2.appearanceInfo.sourceID)
	end,
	ItemID = function(element1, element2)
		local sourceInfo1 = BW_GetVendorSourceInfo(element1.appearanceInfo.sourceID)
		local sourceInfo2 = BW_GetVendorSourceInfo(element2.appearanceInfo.sourceID)
		local itemID1 = (sourceInfo1 and sourceInfo1.itemID) or 0
		local itemID2 = (sourceInfo2 and sourceInfo2.itemID) or 0
		return itemID1 < itemID2
	end,
}

local function BW_RefreshVendorItemsList(itemsFrame)
	if not itemsFrame.transmogLocation or not itemsFrame.activeCategoryID then return end

	local entries
	if itemsFrame.transmogLocation:IsIllusion() then
		entries = C_TransmogCollection.GetIllusions()
	else
		entries = C_TransmogCollection.GetCategoryAppearances(itemsFrame.activeCategoryID, itemsFrame.transmogLocation:GetData())
	end

	local compareEntries = BW_ReverseComparator(BW_VENDOR_ITEM_SORT_COMPARATORS[addon.Profile.ItemSortMode] or function(element1, element2)
		local source1 = element1.appearanceInfo
		local source2 = element2.appearanceInfo
		if source1.isCollected ~= source2.isCollected then return source1.isCollected end
		if source1.isUsable ~= source2.isUsable then return source1.isUsable end
		if source1.isFavorite ~= source2.isFavorite then return source1.isFavorite end
		if source1.canDisplayOnPlayer ~= source2.canDisplayOnPlayer then return source1.canDisplayOnPlayer end
		if source1.isHideVisual ~= source2.isHideVisual then return source1.isHideVisual end
		if source1.hasActiveRequiredHoliday ~= source2.hasActiveRequiredHoliday then return source1.hasActiveRequiredHoliday end
		if source1.uiOrder and source2.uiOrder then return source1.uiOrder > source2.uiOrder end
		return source1.sourceID > source2.sourceID
	end, addon.Profile.ItemSortReverse)

	local collectionElements = {}
	for _, itemEntry in ipairs(entries) do
		if (itemEntry.isUsable and itemEntry.isCollected) or itemEntry.alwaysShowItem then
			table.insert(collectionElements, {
				templateKey = "COLLECTION_ITEM",
				appearanceInfo = itemEntry,
				collectionFrame = itemsFrame,
			})
		end
	end

	table.sort(collectionElements, compareEntries)

	local dataProvider = CreateDataProvider({{elements = collectionElements}})
	itemsFrame.PagedContent:SetDataProvider(dataProvider, true)
end

function addon:CreateVendorItemsFilterButton(itemsFrame)
	if itemsFrame.BW_FilterButton then
		return itemsFrame.BW_FilterButton
	end

	local original = itemsFrame.FilterButton

	local filterButton = CreateFrame("DropdownButton", nil, itemsFrame, "WowStyle1FilterDropdownTemplate")
	filterButton.resizeToText = false
	filterButton:SetPoint("TOPRIGHT", original, "TOPRIGHT")
	filterButton:SetSize(original:GetSize())
	filterButton:SetText(FILTER)

	--Blizzard re-Shows original on later events (changing slots, etc.), so keep re-hiding it.
	original:HookScript("OnShow", function(self)
		filterButton:SetSize(self:GetSize())
		self:Hide()
	end)
	original:Hide()

	filterButton:SetupMenu(function(_dropdown, rootDescription)
		local sortSubmenu = rootDescription:CreateButton(L["Sort By"])
		local function IsSortModeSelected(mode)
			return addon.Profile.ItemSortMode == mode
		end
		local function SetSortMode(mode)
			addon.Profile.ItemSortMode = mode
			BW_RefreshVendorItemsList(itemsFrame)
		end
		sortSubmenu:CreateRadio(L["Default"], IsSortModeSelected, SetSortMode, "Default")
		sortSubmenu:CreateRadio(L["Alphabetic"], IsSortModeSelected, SetSortMode, "Alphabetic")
		sortSubmenu:CreateRadio(L["Appearance"], IsSortModeSelected, SetSortMode, "Appearance")
		sortSubmenu:CreateRadio(L["Item Source"], IsSortModeSelected, SetSortMode, "ItemSource")
		sortSubmenu:CreateRadio(L["Color"], IsSortModeSelected, SetSortMode, "Color")
		sortSubmenu:CreateRadio(L["Expansion"], IsSortModeSelected, SetSortMode, "Expansion")
		sortSubmenu:CreateRadio(L["Item Level"], IsSortModeSelected, SetSortMode, "ItemLevel")
		sortSubmenu:CreateRadio(L["Item ID"], IsSortModeSelected, SetSortMode, "ItemID")
		sortSubmenu:CreateDivider()
		sortSubmenu:CreateCheckbox(L["Reverse"], function() return addon.Profile.ItemSortReverse end, function()
			addon.Profile.ItemSortReverse = not addon.Profile.ItemSortReverse
			BW_RefreshVendorItemsList(itemsFrame)
		end)

		rootDescription:CreateDivider()

		local sourcesSubmenu = rootDescription:CreateButton(SOURCES)

		sourcesSubmenu:CreateButton(CHECK_ALL, function()
			C_TransmogCollection.SetAllSourceTypeFilters(true)
			BW_RefreshVendorItemsList(itemsFrame)
			return MenuResponse.Refresh
		end)

		sourcesSubmenu:CreateButton(UNCHECK_ALL, function()
			C_TransmogCollection.SetAllSourceTypeFilters(false)
			BW_RefreshVendorItemsList(itemsFrame)
			return MenuResponse.Refresh
		end)

		local function IsChecked(filter)
			return C_TransmogCollection.IsSourceTypeFilterChecked(filter)
		end

		local function SetChecked(filter)
			C_TransmogCollection.SetSourceTypeFilter(filter, not IsChecked(filter))
			BW_RefreshVendorItemsList(itemsFrame)
		end

		for filterIndex = 1, C_TransmogCollection.GetNumTransmogSources() do
			if (C_TransmogCollection.IsValidTransmogSource(filterIndex)) then
				sourcesSubmenu:CreateCheckbox(_G["TRANSMOG_SOURCE_"..filterIndex], IsChecked, SetChecked, filterIndex)
			end
		end
	end)

	filterButton:SetIsDefaultCallback(function()
		return C_TransmogCollection.IsUsingDefaultFilters()
	end)

	filterButton:SetDefaultCallback(function()
		C_TransmogCollection.SetDefaultFilters()
		BW_RefreshVendorItemsList(itemsFrame)
	end)

	itemsFrame.BW_FilterButton = filterButton
	return filterButton
end

function addon:EventHandler(event, ...)
	if event == "ADDON_LOADED" and ... == "Blizzard_Collections" then
		addon:SendMessage("BW_ADDON_LOADED")
		addon:UnregisterEvent("ADDON_LOADED")

	elseif event == "PLAYER_LOGIN" then

	elseif event == "PLAYER_ENTERING_WORLD" then
		addon:SendMessage("BW_OnPlayerEnterWorld")

		--See OnEnable: these are now .toc Dependencies instead of runtime LoadAddOn() calls.

		C_Timer.After(1, function()
			if not TransmogFrame then return end
			if not TransmogFrame.WardrobeCollection.TabContent.BW_SetsFrame2 then
				local f = CreateFrame("Frame", nil, TransmogFrame.WardrobeCollection.TabContent,"ExtraSetsFrameTemplate")
				TransmogFrame.WardrobeCollection.TabContent.BW_SetsFrame2 = f
				TransmogFrame.WardrobeCollection.TabHeaders.setsFrame2TabID = TransmogFrame.WardrobeCollection:AddNamedTab(L["Sets"],  TransmogFrame.WardrobeCollection.TabContent.BW_SetsFrame2);
				TransmogFrame.WardrobeCollection.TabContent.BW_SetsFrame2:Init(TransmogFrame.WardrobeCollection)

				local f = CreateFrame("Frame", nil, TransmogFrame.WardrobeCollection.TabContent,"ExtraSetsFrameTemplate")
				TransmogFrame.WardrobeCollection.TabContent.BW_ExtraSetsFrame = f
				TransmogFrame.WardrobeCollection.TabHeaders.extrasetsTabID = TransmogFrame.WardrobeCollection:AddNamedTab(L["Extra Sets"],  TransmogFrame.WardrobeCollection.TabContent.BW_ExtraSetsFrame);
				TransmogFrame.WardrobeCollection.TabContent.BW_ExtraSetsFrame:Init(TransmogFrame.WardrobeCollection)

				local f = CreateFrame("Frame", nil, TransmogFrame.WardrobeCollection.TabContent,"CustomSetsFrame2")
				TransmogFrame.WardrobeCollection.TabContent.BW_ExtraCustomSetsFrame = f
				TransmogFrame.WardrobeCollection.TabHeaders.extracustomsetsTabID = TransmogFrame.WardrobeCollection:AddNamedTab(TRANSMOG_TAB_CUSTOM_SETS,  TransmogFrame.WardrobeCollection.TabContent.BW_ExtraCustomSetsFrame);
				TransmogFrame.WardrobeCollection.TabContent.BW_ExtraCustomSetsFrame:Init(TransmogFrame.WardrobeCollection)
				TransmogFrame.WardrobeCollection.TabHeaders.situationsTabID2 = TransmogFrame.WardrobeCollection:AddNamedTab(TRANSMOG_TAB_SITUATIONS, TransmogFrame.WardrobeCollection.TabContent.SituationsFrame);
				addon:CreateSituationPresetUI(TransmogFrame.WardrobeCollection.TabContent.SituationsFrame);

				local f = CreateFrame("Frame", nil, TransmogFrame.WardrobeCollection.TabContent.ItemsFrame.PagedContent,"BW_PagingControlsHorizontalTemplate")
				f:ClearAllPoints()
				f:SetPoint("TOPLEFT", TransmogFrame.WardrobeCollection.TabContent.ItemsFrame.PagedContent, "BOTTOM", -120, 40)
				TransmogFrame.WardrobeCollection.TabContent.ItemsFrame.PagedContent.PagingControls:Hide()
				TransmogFrame.WardrobeCollection.TabContent.ItemsFrame.PagedContent.PagingControls = f

				--FirstPageButton/LastPageButton are our own addition; Blizzard's PagingControlsMixin
				--only greys out Prev/Next, so sync the desaturation for these two ourselves.
				hooksecurefunc(f, "UpdateControls", function(self)
					local atFirst = self:GetCurrentPage() <= 1;
					local atLast = self:GetCurrentPage() >= self:GetMaxPages();
					self.FirstPageButton:SetEnabled(not atFirst);
					self.FirstPageButton:GetNormalTexture():SetDesaturated(atFirst);
					self.LastPageButton:SetEnabled(not atLast);
					self.LastPageButton:GetNormalTexture():SetDesaturated(atLast);
				end);

				xpcall(addon.CreateVendorItemsFilterButton, geterrorhandler(), addon, TransmogFrame.WardrobeCollection.TabContent.ItemsFrame)

				 self:SecureHookScript(TransmogFrame, "OnShow", function() C_Timer.After(.1, function() addon:UpdateTabs(); end) end)
				addon:CreateButtons()
			end
			addon:UpdateTabs();
		 end)

		----C_Timer.After(1, function() addon:ResetSetsCollectionFrame() end)

	elseif (event == "TRANSMOG_COLLECTION_SOURCE_ADDED") then
		local x = ...
		BetterWardrobeCollectionFrameMixin:OnEvent(event, x)

	elseif (event == "TRANSMOG_COLLECTION_SOURCE_REMOVED") then
		local x = ...
		BetterWardrobeCollectionFrameMixin:OnEvent(event, x)
	end
end

local f = CreateFrame("Frame", nil, UIParent)
f:ClearAllPoints()
f:SetPoint("TOPRIGHT", 100, 100)
f:SetSize(1, 1)
f:Hide()
addon.prisonFrame = f

function BetterWardrobe_OnAddonCompartmentClick(addonName, buttonName, menuButtonFrame)
	ToggleCollectionsJournal(5)
end