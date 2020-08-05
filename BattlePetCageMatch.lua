--	///////////////////////////////////////////////////////////////////////////////////////////
--
--	BattlePetCageMatch
--	Author: SLOKnightfall

--	BattlePetCageMatch: Scans bags and puts icons on the Pet Journal for any pet that is currently caged
--

--	License: You are hereby authorized to freely modify and/or distribute all files of this add-on, in whole or in part,
--		providing that this header stays intact, and that you do not claim ownership of this Add-on.
--
--		Additionally, the original owner wishes to be notified by email if you make any improvements to this add-on.
--		Any positive alterations will be added to a future release, and any contributing authors will be
--		identified in the section above.
--
--
--

--	///////////////////////////////////////////////////////////////////////////////////////////

local BPCM = select(2, ...)
BPCM.TSM = {}
local TSM_Version = 3
local addonName, addon = ...
_G["BPCM"] = BPCM
BPCM = LibStub("AceAddon-3.0"):NewAddon(addon,"BattlePetCageMatch", "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
BPCM.Frame = LibStub("AceGUI-3.0")
BPCM.DataBroker = LibStub( "LibDataBroker-1.1" )
BPCM.bagResults = {}

local globalPetList = {}
local playerInv_DB
local Profile
local playerNme
local realmName

local L = LibStub("AceLocale-3.0"):GetLocale("BattlePetCageMatch")

--Registers for LDB addons
LibStub("LibDataBroker-1.1"):NewDataObject(addonName, {
	type = "data source",
	text = addonName,
	--tooltip = L.AUTO_CAGE_TOOLTIP_1,
	icon = "Interface/ICONS/INV_Pet_PetTrap01",
	OnClick = function(self, button, down) 
		--if (button == "RightButton") then
		BPCM.Cage:ResetListCheck()
		--end
	end,
	OnTooltipShow = function(tooltip)
		if not tooltip or not tooltip.AddLine then return end
			tooltip:AddLine(L.AUTO_CAGE_TOOLTIP_1)
		end,
	})


--ACE3 Options Constuctor
local options = {
	name = "BattlePetCageMatch",
	handler = BattlePetCageMatch,
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
				Options_Header = {
					order = 0,
					name = L.OPTIONS_HEADER,
					type = "header",
					width = "full",
				},
				Tradeable = {
					order = 1,
					name = L.OPTIONS_TRADEABLE ,
					desc = L.OPTIONS_TRADEABLE_TOOLTIP,
					type = "toggle",
					set = function(info,val) Profile.No_Trade = val end,
					get = function(info) return Profile.No_Trade end,
					width = "full",
				},

				GlobalList = {
					order = 2,
					name = L.OPTIONS_GLOBAL_LIST,
					desc = L.OPTIONS_GLOBAL_LIST_TOOLTIP,
					type = "toggle",
					set = function(info,val) Profile.Other_Server = val end,
					get = function(info) return Profile.Other_Server end,
					width = "full"
				},
				Inv_Tooltips = {
					order = 3,
					name = L.OPTIONS_INV_TOOLTIPS,
					desc = nil,
					type = "toggle",
					set = function(info,val) Profile.Inv_Tooltips = val end,
					get = function(info) return Profile.Inv_Tooltips end,
					width = "full"
				},
				Icon_Tooltips = {
					order = 3.1,
					name = L.OPTIONS_ICON_TOOLTIPS,
					desc = nil,
					type = "multiselect",
					set = function(info, key, value) Profile.Icon_Tooltips[key] = value end,
					get = function(info,key) return Profile.Icon_Tooltips[key] end,
					width = "full",
					values = {["cage"]= L.OPTIONS_ICON_TOOLTIPS_1, ["value"] = L.OPTIONS_ICON_TOOLTIPS_2, ["db"] = L.OPTIONS_ICON_TOOLTIPS_3},
				},
				Cage_Header = {
					order = 4,
					name = L.OPTIONS_CAGE_HEADER,
					type = "header",
					width = "full",
				},
					Cage_Confirm = {
					order = 4.9,
					name = L.OPTIONS_CAGE_CONFIRM,
					desc = nil,
					type = "toggle",
					set = function(info,val) Profile.Cage_Confirm = val end,
					get = function(info) return Profile.Cage_Confirm end,
					width = "full"
				},
				Cage_Output = {
					order = 5,
					name = L.OPTIONS_CAGE_OUTPUT,
					desc = nil,
					type = "toggle",
					set = function(info,val) Profile.Cage_Output = val end,
					get = function(info) return Profile.Cage_Output end,
					width = "full"
				},
				Cage_Once = {
					order = 5,
					name = L.OPTIONS_CAGE_ONCE,
					desc = nil,
					type = "toggle",
					set = function(info,val) Profile.Cage_Once = val end,
					get = function(info) return Profile.Cage_Once end,
					width = "full"
				},
				Skip_Caged = {
					order = 5.1,
					name = L.OPTIONS_SKIP_CAGED ,
					desc = nil,
					type = "toggle",
					set = function(info,val) Profile.Skip_Caged = val end,
					get = function(info) return Profile.Skip_Caged end,
					width = "full"
				},
				Incomplete_List = {
					order = 5.3,
					name = L.OPTIONS_INCOMPLETE_LIST,
					desc = nil,
					type = "select",
					set = function(info,val) Profile.Incomplete_List = val end,
					get = function(info) return Profile.Incomplete_List end,
					width = "double",
					values = {["new"] = L.OPTIONS_INCOMPLETE_LIST_1, ["old"] =L.OPTIONS_INCOMPLETE_LIST_2, ["prompt"] = L.OPTIONS_INCOMPLETE_LIST_3}
				},
				Linebreak_4 = {
					order = 5.4,
					name = "",
					desc = nil,
					type = "description",
					width = "normal",

				},
				Favorite_Only = {
					order = 6,
					name = L.OPTIONS_FAVORITE_LIST,
					desc = nil,
					type = "select",
					set = function(info,val) Profile.Favorite_Only = val end,
					get = function(info) return Profile.Favorite_Only end,
					width = "normal",
					values = {["include"] = "Include in scan", ["ignore"] ="Ignore in scan", ["only"] = "Only scan favorites"}
				},
				Linebreak_1 = {
					order = 6.1,
					name = "",
					desc = nil,
					type = "description",
					width = "double",

				},
				Cage_Max_Level = {
					order = 7,
					name = L.OPTIONS_CAGE_MAX_LEVEL,
					desc = OPTIONS_CAGE_MAX_LEVEL_TOOLTIP,
					type = "select",
					type = "range",
					set = function(info,val) Profile.Cage_Max_Level = val end,
					get = function(info) return Profile.Cage_Max_Level end,
					width = "double",
					min = 1,
					max = 25,
					step = 1,
				},
				Cage_Max_Quantity = {
					order = 8,
					name = L.OPTIONS_CAGE_MAX_QUANTITY,
					desc = L.OPTIONS_CAGE_MAX_QUANTITY_TOOLTIP,
					type = "select",
					type = "range",
					set = function(info,val) Profile.Cage_Max_Quantity = val end,
					get = function(info) return Profile.Cage_Max_Quantity end,
					width = "double",
					min = 1,
					max = 3,
					step = 1,
				},
				Skip_Auction = {
					order = 9,
					name = L.OPTIONS_SKIP_AUCTION ,
					desc = nil,
					type = "toggle",
					set = function(info,val) Profile.Skip_Auction = val end,
					get = function(info) return Profile.Skip_Auction end,
					disabled = function(info) return not BPCM.TSM_LOADED end,
					width = "full"
				},
				Cage_Max_Price = {
					order = 10,
					name = L.OPTIONS_CAGE_MAX_PRICE,
					desc = nil,
					type = "toggle",
					set = function(info,val) Profile.Cage_Max_Price = val end,
					get = function(info) return Profile.Cage_Max_Price end,
					width = "double",
					disabled = function(info) return not BPCM.TSM_LOADED end,
				},
				Cage_Max_Price_Value = {
					order = 11,
					name = L.OPTIONS_CAGE_MAX_PRICE_VALUE,
					desc = L.OPTIONS_CAGE_MAX_PRICE_VALUE_TOOLTIP ,
					type = "input",
					set = function(info,val) Profile.Cage_Max_Price_Value = BPCM:CleanValues(val) end,
					get = function(info) return tostring(Profile.Cage_Max_Price_Value) end,
					width = "normal",
					disabled = function(info) return not BPCM.TSM_LOADED end,
				},
				Cage_Custom_TSM_Price = {
					order = 11.1,
					name = L.OPTIONS_TSM_USE_CUSTOM.." (Requirest TSM)",
					desc = L.OPTIONS_CAGE_CUSTOM_TOOLTIP,
					type = "toggle",
					set = function(info,val) Profile.Cage_Custom_TSM_Price = val end,
					get = function(info) return Profile.Cage_Custom_TSM_Price end,
					width = "double",
					disabled = function(info) return not BPCM.TSM_LOADED end,
				},
				Cage_Custom_TSM_Price_Value = {
					order = 11.2,
					name = L.OPTIONS_TSM_CUSTOM,
					desc = L.OPTIONS_TSM_CUSTOM_TOOLTIP,
					type = "input",
					set = function(info,val) Profile.Cage_Custom_TSM_Price_Value = BPCM:TSM_CustomSource(val) end,
					get = function(info) return Profile.Cage_Custom_TSM_Price_Value end,
					width = "full",
					disabled = function(info) return not BPCM.TSM_LOADED end,
				},
				Handle_PetWhiteList = {
					order = 12,
					name = L.OPTIONS_HANDLE_PETWHITELIST ,
					desc = nil,
					type = "select",
					set = function(info,val) Profile.Handle_PetWhiteList = val end,
					get = function(info) return Profile.Handle_PetWhiteList end,
					width = "normal",
					values = {["include"] = "Include after normal scan", ["only"] = "Only cage list", ["disable"] = "Do not use list"}
				},
				Linebreak_2 = {
					order = 12.1,
					name = "",
					desc = nil,
					type = "description",
					width = "double",

				},
				PetWhiteList = {
					type = "input",
					multiline = true,
					width = "double",
					name = L.OPTIONS_PETWHITELIST,
					desc = L.OPTIONS_WHITELLIST_TOOLTIP,
					order = 13,
					width = "full",
					get = function(info)
						return BPCM.WhiteListDB:ToString();
					end,
					set = function(info, value)
						local itemList = { strsplit("\n", value:trim()) };
						BPCM.WhiteListDB:Populate(itemList);
					end,
						},
				Handle_PetBlackList = {
					order = 13.1,
					name = L.OPTIONS_HANDLE_PETBLACKLIST,
					desc = L.OPTIONS_HANDLE_PETWHITELIST_TOOLTIP,
					type = "select",
					set = function(info,val) if val == 1 then Profile.Handle_PetBlackList = true; else Profile.Handle_PetBlackList = false end; end,
					get = function(info) if Profile.Handle_PetBlackList  then return 1; else return 2; end; end,
					width = "normal",
					values = {[1] = "On", [2] = "Off"}
				},
				Linebreak_3 = {
					order = 13.2,
					name = "",
					desc = nil,
					type = "description",
					width = "double",

				},
				PetBlackList = {
					type = "input",
					multiline = true,
					width = "double",
					name = L.OPTIONS_PETBLACKLIST,
					desc = L.OPTIONS_BLACKLIST_TOOLTIP,
					order = 14,
					width = "full",
					get = function(info)
						return BPCM.BlackListDB:ToString();
					end,
					set = function(info, value)
						local itemList = { strsplit("\n", value:trim()) };
						BPCM.BlackListDB:Populate(itemList);
					end,
						},

				TSM_Header = {
					order = 15,
					name = L.OPTIONS_TSM_HEADER,
					type = "header",
					width = "full",
				},
				TSM_Header_Text = {
					order = 16,
					name = "Requires TSM",
					type = "description",
					width = "full",
					--image = "Interface/ICONS/INV_Misc_Coin_17",
				},
				TSM_Value = {
					order = 17,
					name = L.OPTIONS_TSM_VALUE,
					desc = L.OPTIONS_TSM_VALUE_TOOLTIP,
					type = "toggle",
					set = function(info,val) Profile.TSM_Value = val end,
					get = function(info) return Profile.TSM_Value end,
					width = "double",
					disabled = function(info) return not BPCM.TSM_LOADED end,
				},
				TSM_Market = {
					order = 18,
					name = L.OPTIONS_TSM_DATASOURCE,
					--desc = "TSM Source to get price data.",
					type = "select",
					set = function(info,val) Profile.TSM_Market = val end,
					get = function(info) return Profile.TSM_Market end,
					width = "normal",
					values = function() return BPCM:TSM_Source() end,
					disabled = function(info) return not BPCM.TSM_LOADED end,
				},
				TSM_Use_Custom = {
					order = 18.1,
					name = L.OPTIONS_TSM_USE_CUSTOM,
					--desc = L.OPTIONS_TSM_FILTER_TOOLTIP,
					type = "toggle",
					set = function(info,val) Profile.TSM_Use_Custom = val end,
					get = function(info) return Profile.TSM_Use_Custom end,
					width = "double",
					disabled = function(info) return not BPCM.TSM_LOADED end,
				},
				TSM_Custom = {
					order = 18.2,
					name = L.OPTIONS_TSM_CUSTOM,
					desc = L.OPTIONS_TSM_CUSTOM_TOOLTIP,
					type = "input",
					set = function(info,val) Profile.TSM_Custom = BPCM:TSM_CustomSource(val) end,
					get = function(info) return Profile.TSM_Custom end,
					width = "full",
					disabled = function(info) return not BPCM.TSM_LOADED end,
				},
				TSM_Filter = {
					order = 19,
					name = L.OPTIONS_TSM_FILTER,
					desc = L.OPTIONS_TSM_FILTER_TOOLTIP,
					type = "toggle",
					set = function(info,val) Profile.TSM_Filter = val end,
					get = function(info) return Profile.TSM_Filter end,
					width = "normal",
					disabled = function(info) return not BPCM.TSM_LOADED end,
				},

				TSM_Filter_Value = {
					order = 20,
					name = L.OPTIONS_CAGE_MAX_PRICE_VALUE,
					desc = L.OPTIONS_CAGE_MAX_PRICE_VALUE_TOOLTIP,
					type = "input",
					set = function(info,val) Profile.TSM_Filter_Value = BPCM:CleanValues(val) end,
					get = function(info) return tostring(Profile.TSM_Filter_Value) end,
					width = "normal",
					disabled = function(info) return not BPCM.TSM_LOADED end,
				},

				TSM_Rank = {
					order = 21,
					name = L.OPTIONS_TSM_RANK,
					type = "select",
					type = "toggle",
					set = function(info,val) Profile.TSM_Rank = val end,
					get = function(info) return Profile.TSM_Rank end,
					width = "full",
					disabled = function(info) return not BPCM.TSM_LOADED end,
				},
				TSM_Rank_Medium = {
					order = 22,
					name = L.OPTIONS_TSM_RANK_MEDIUM,
					type = "select",
					type = "range",
					set = function(info,val) Profile.TSM_Rank_Medium = val end,
					get = function(info) return Profile.TSM_Rank_Medium end,
					width = "normal",
					min = 1,
					max = 10,
					step = 1,
					isPercent = true,
					disabled = function(info) return not BPCM.TSM_LOADED end,
				},
				TSM_Rank_High = {
					order = 23,
					name = L.OPTIONS_TSM_RANK_HIGH,
					type = "select",
					type = "range",
					set = function(info,val) Profile.TSM_Rank_High = val end,
					get = function(info) return Profile.TSM_Rank_High end,
					width = "normal",
					min = 1,
					max = 10,
					step = 1,
					isPercent = true,
					icon = "Interface/ICONS/INV_Misc_Coin_17",
					disabled = function(info) return not BPCM.TSM_LOADED end,
				},
			},
		},

	},
}

--ACE Profile Saved Variables Defaults
local defaults = {
	profile ={
		No_Trade = true,
		TSM_Value = true,
		Other_Server = true,
		TSM_Filter = false,
		TSM_Filter_Value = 0,
		TSM_Market = "DBMarket",
		TSM_Use_Custom = false,
		TSM_Custom = "",
		TSM_Rank = true,
		TSM_Rank_Medium = 2,
		TSM_Rank_High = 5,
		Inv_Tooltips = true,
		Icon_Tooltips = {["db"] = false,
				["value"] = false,
				["cage"] = false,},
		Cage_Output = false,
		Cage_Once = true,
		Skip_Caged = true,
		Incomplete_List = "old",
		Skip_Auction = true,
		Favorite_Only = "include",
		Cage_Max_Level = 1,
		Cage_Max_Price = false,
		Cage_Max_Price_Value = 100,
		Cage_Max_Quantity = 1,
		Cage_Custom_TSM_Price = false,
		Handle_PetWhiteList = "include",
		Pet_Whitelist = {},
		Handle_PetBlackList = true,
		Pet_Blacklist = {},
		Cage_Confirm = false,
	}
}


---Builds a list of saved data keyed by pet species id
function BPCM:BuildDBLookupList()
	globalPetList = globalPetList or {}
	for realm, realm_data in pairs(BattlePetCageMatch_Data) do
		for player, player_data in pairs(realm_data) do
			for pet, count in pairs(player_data) do
				globalPetList[pet] = globalPetList[pet] or {}
				globalPetList[pet][player.." - "..realm] = count
			end
		end
	end
end

--Removes any text from the option value fields to only leave numbers
function BPCM:CleanValues(value)
	value = (string.match(value,"(%d*)"))
	return tonumber(value) or 0
end


---Scans the players bags and logs any caged battle pets
function BPCM:BPScanBags()
	wipe(playerInv_DB)
	wipe(BPCM.bagResults )
	BPCM.bagResults = {}
	for t=0,4 do
		local slots = GetContainerNumSlots(t);
		if (slots > 0) then
			for c=1,slots do
				local _,_,_,_,_,_,itemLink,_,_,itemID = GetContainerItemInfo(t,c)

				if (itemID == 82800) then
				local _, _, _, _, speciesID,_ , _, _, _, _, _, _, _, _, cageName = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
				--local recipeName = select(4, strsplit("|", link))
				--printable = gsub(itemLink, "\124", "\124\124");

				speciesID = tonumber(speciesID)
				BPCM.bagResults [speciesID]= BPCM.bagResults [speciesID] or {}
				BPCM.bagResults [speciesID]["count"] = (BPCM.bagResults [speciesID]["count"] or 0) + 1
				BPCM.bagResults [speciesID]["data"] = BPCM.bagResults [speciesID]["data"] or {}
				tinsert(BPCM.bagResults [speciesID]["data"],itemLink )

				playerInv_DB[speciesID] = BPCM.bagResults [speciesID]
				end
			end
		end

	end
	BPCM:BuildDBLookupList()
end


---Searches database for pet data
--Pram: PetID(num) - ID of the pet to look up
--Pram: Ignore(bool) - ignore data for current player
--Return:  string - String containing findings
function BPCM:SearchList(PetID, ignore)
	local string = nil
	if globalPetList[PetID] then
		for player, data in pairs(globalPetList[PetID])do

			if (playerNme.." - "..realmName == player) and ignore then
			else
				string = string or ""
				string = string..player..": "..data.count.."\n"-- - L: "
				--for _, itemLink in ipairs(data.data)do
					--local _, _, _, _, _,level  = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
					--string= string..level..", \n"
				--end
			end
		end
	end
	return string
end


---Builds tooltip data
--Pram: frame - Name of frame to attach tooltip to
function BPCM:BuildToolTip(frame)
	local tooltip_DB = nil
	local tooltip_Value = nil
	local tooltip_Cage = nil
	local tooltip = nil

	local speciesID = (frame:GetParent()):GetParent().speciesID
	--print(BPCM:SearchList(speciesID,true))
	GameTooltip:SetOwner(frame, "ANCHOR_LEFT");

	if frame.display then
		tooltip_DB = BPCM:SearchList(speciesID, true)
	end

	if BPCM.TSM_LOADED and (frame.petlink) then
		tooltip_Value = BPCM:pricelookup(frame.petlink) or "N/A"  
	end

	if frame.cage then
		tooltip_Cage= "Inventory: "..(BPCM.bagResults[tonumber(speciesID)].count)
	end

	GameTooltip:SetText((tooltip_Value or tooltip_Cage or tooltip_DB or ""), nil, nil, nil, nil, true)
	GameTooltip:Show()	
end

---Builds tooltip data
--Pram: frame - Name of frame to attach tooltip to
function BPCM:BuildIconToolTip(frame)
	GameTooltip:SetOwner(frame, "ANCHOR_RIGHT");
	local tooltip_DB = nil
	local tooltip_Value = nil
	local tooltip_Cage = nil
	local tooltip = nil
	
	local petlink = frame:GetParent().petlink 
	if Profile.Icon_Tooltips["db"]then
		tooltip_DB= BPCM:SearchList(frame:GetParent().speciesID,true) 
	end

	if BPCM.TSM_LOADED and Profile.Icon_Tooltips["value"] and (petlink) then
		tooltip_Value = BPCM:pricelookup(petlink) 
	end

	if Profile.Icon_Tooltips["cage"]  and frame:GetParent().speciesID then
	local inv = BPCM.bagResults[tonumber(frame:GetParent().speciesID)] or 0
		if inv == 0 then 
		else

			tooltip_Cage= "Inventory: "..(BPCM.bagResults[tonumber(frame:GetParent().speciesID)].count)
		end
	end

	if (tooltip_Cage or tooltip_Value or tooltip_DB) then
		GameTooltip:SetText((tooltip_Value or tooltip_Cage or tooltip_DB), nil, nil, nil, nil, true)
		GameTooltip:AddLine(((tooltip_Value and tooltip_Cage) or tooltip_DB), nil, nil, nil, nil, true)
		GameTooltip:AddLine((tooltip_Value and tooltip_DB), nil, nil, nil, nil, true)
	end

	GameTooltip:Show()
end



---Initilizes the buttons and creates the appropriate on click behaviour
--Pram: frame - frame that the checkbox should be added to
--Pram: index - index used to refrence the checkbox that is created created
--Return:  checkbox - the created checkbox frame
function BPCM:init_button(frame, index)
	local buttton = CreateFrame("Button", "CageMatch"..index, frame, "UICheckButtonTemplate")
	buttton:SetPoint("BOTTOMRIGHT")
	buttton.SpeciesID = 0
	buttton:SetScript("OnClick", function() end)
	buttton:SetScript("OnEnter", function (...) BPCM:BuildToolTip(buttton); end)
	buttton:SetScript("OnLeave", function() GameTooltip:Hide(); end)

	buttton:SetButtonState("NORMAL", true)
	buttton:SetWidth(20)
	buttton:SetHeight(20)
	return buttton
end


---Initilizes the buttons and creates the appropriate on click behaviour
--Pram: frame - frame that the checkbox should be added to
--Pram: index - index used to refrence the checkbox that is created created
--Return:  checkbox - the created checkbox frame
function BPCM:pricelookup(itemID)
	local tooltip
	local rank = 1
	local source = (Profile.TSM_Use_Custom and Profile.TSM_Custom) or BPCM.PriceSources[Profile.TSM_Market] or "DBMarket"

	local priceMarket = BPCM.TSM:GetCustomPriceValue(source, itemID) or 0 

	if Profile.TSM_Filter and (priceMarket <= (Profile.TSM_Filter_Value *100*100)) then
		return false
	elseif Profile.TSM_Filter and (priceMarket >= (Profile.TSM_Filter_Value *100*100) *Profile.TSM_Rank_High) then
		rank = 3
	elseif Profile.TSM_Filter and (priceMarket >= (Profile.TSM_Filter_Value *100*100) *Profile.TSM_Rank_Medium) then
		rank = 2
	end

	if priceMarket then
		tooltip = BPCM.TSM:MoneyToString(priceMarket)--("%dg %ds %dc"):format(priceMarket / 100 / 100, (priceMarket / 100) % 100, priceMarket % 100)
	else
		tooltip = "No Market Data"
	end

	return tooltip, rank
end


---Initilizes of data sources from TSM for the options dropdown
--Return:  sources - table of data sources available
function BPCM:TSM_Source()
	local sources
	if BPCM.TSM_LOADED  then
		sources = BPCM.TSM:GetPriceSources()
	else
		sources = {}
	end

	return sources
end


---Uses TSM's API to validate a custom price string to use instead of a stanard market source
function BPCM:TSM_CustomSource(price)
	local isValid, err = BPCM.TSM:ValidateCustomPrice(price)
	if not isValid then
		--print(string.format(L.TSM_CUSTOM_ERROR, BPCM.TSM:GetInlineColor("link") .. price .. "|r", err))
		print(err)
	else
		return price
	end
end


function BPCM:PositionIcons(button)
	local Anchor = "BOTTOMRIGHT"
	local offset = 0
	if BPCM.PJE_LOADED and BPCM.REMATCH_LOADED and RematchPetPanel.List.ScrollFrame:IsVisible() then
		Anchor = "TOPRIGHT"
		offset = -5
	else 	
		Anchor = "BOTTOMRIGHT"
		offset = 0
	end


	if button.BP_Global.display then
		button.BP_Global:ClearAllPoints()
		button.BP_Global:SetPoint(Anchor,offset,offset)

		if button.BP_Value.display then 	
			button.BP_Value:ClearAllPoints()
			button.BP_Cage:ClearAllPoints()
			button.BP_Value:SetPoint("TOPRIGHT", button.BP_Global, "TOPLEFT")
			button.BP_Cage:SetPoint("TOPRIGHT", button.BP_Value, "TOPLEFT")
		else

			button.BP_Cage:ClearAllPoints();
			button.BP_Cage:SetPoint("TOPRIGHT", button.BP_Global, "TOPLEFT")
		end
	else
		if button.BP_Value.display then 
			button.BP_Value:ClearAllPoints()
			button.BP_Value:SetPoint(Anchor,offset,offset)
			button.BP_Cage:ClearAllPoints();
			button.BP_Cage:SetPoint("TOPRIGHT", button.BP_Value, "TOPLEFT")
		else
			button.BP_Cage:ClearAllPoints()
			button.BP_Cage:SetPoint(Anchor,offset,offset)
		end
	end
end

local function SetCageIcon(button, speciesID)
				button.BP_Cage:Hide()
				button.petlink = "p:"..speciesID..":1:2"
				button.speciesID = speciesID
				if BPCM.bagResults [speciesID] then
					button.BP_Cage.icon:SetTexture("Interface/ICONS/INV_Pet_PetTrap01")
					button.BP_Cage.cage = true;
					button.BP_Cage.speciesID = speciesID
					button.BP_Cage:Show()
				else
					button.BP_Cage:Hide()
				end
end

local function SetTSMValue(button, speciesID)
				if BPCM.TSM_LOADED and Profile.TSM_Value then
					button.BP_Value.petlink = "p:"..speciesID..":1:2"
					local pass, rank = BPCM:pricelookup(button.BP_Value.petlink)

					if Profile.TSM_Filter and not pass then
						button.BP_Value:Hide()
						button.BP_Value.display = false
					else
						if Profile.TSM_Rank and rank == 2 then
							button.BP_Value.icon:SetTexture("Interface/ICONS/INV_Misc_Coin_18")
							elseif Profile.TSM_Rank and  rank == 3 then
							button.BP_Value.icon:SetTexture("Interface/ICONS/INV_Misc_Coin_17")
						else
							button.BP_Value.icon:SetTexture("Interface/ICONS/INV_Misc_Coin_19")
						end
						button.BP_Value.display = true
						button.BP_Value:Show()
					end
				else
					button.BP_Value:Hide()
					button.BP_Value.display = false
				end
			end
local UpdateButton
---Updates the icons on Pet Journal to tag caged pets
 function BPCM:UpdatePetList_Icons()
 	if not PetJournal:IsVisible() or (Rematch and RematchPetPanel.List.ScrollFrame:IsVisible()) then return end

	local scrollFrame = (Rematch and RematchPetPanel.List.ScrollFrame:IsVisible() and RematchPetPanel.List.ScrollFrame)
			or (PetJournalEnhanced and PetJournalEnhancedListScrollFrame:IsVisible() and PetJournalEnhancedListScrollFrame)
			or (PetJournalListScrollFrame)

	local roster = Rematch and Rematch.Roster

	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local buttons = scrollFrame.buttons
	local numPets = C_PetJournal.GetNumPets()
	local showPets = true
	
	if  ( numPets < 1 ) then return end  --If there are no Pets then nothing needs to be done.

	local numDisplayedPets =(Rematch and RematchPetPanel.List.ScrollFrame:IsVisible() and  #roster.petList)
		or (PetJournalEnhanced and PetJournalEnhancedListScrollFrame:IsVisible() and BPCM.Sorting:GetNumPets())
		or C_PetJournal.GetNumPets()

	for i=1, #buttons do
		local button = buttons[i]
		local displayIndex = i + offset
		local button_name = button:GetName()
		local pet_icon_frame = (Rematch and _G[button_name].Pet) or _G[button_name].dragButton
		if ( displayIndex <= numDisplayedPets ) then

			local index = (Rematch and RematchPetPanel.List.ScrollFrame:IsVisible() and displayIndex)
			or (PetJournalEnhanced and PetJournalEnhancedListScrollFrame:IsVisible() and BPCM.Sorting:GetPetByIndex(displayIndex)["index"])
			or displayIndex

			local speciesID, level, petName, tradeable
			local petID = (Rematch and RematchPetPanel.List.ScrollFrame:IsVisible() and roster.petList[index]) or nil
			local idType = (Rematch and RematchPetPanel.List.ScrollFrame:IsVisible() and Rematch:GetIDType(petID)) or nil

			--Get data from proper indexes based on addon loaded and visable
			if Rematch and RematchPetPanel.List.ScrollFrame:IsVisible() and idType=="pet" then -- this is an owned pet
				speciesID, _, level, _, _, _, _, petName, _, petType, _, _, _, _, _, tradeable = C_PetJournal.GetPetInfoByPetID(petID)

			elseif Rematch and RematchPetPanel.List.ScrollFrame:IsVisible() and idType=="species" then -- speciesID for unowned pets
				speciesID = petID
				petName, _, _, _, _, _, _, _, tradeable = C_PetJournal.GetPetInfoBySpeciesID(petID)
			else
				petID,speciesID,_,_,level,_,_,petName,_,_,_,_,_,_,_,tradeable =  C_PetJournal.GetPetInfoByIndex(index)
			end

			if  button.BP_InfoFrame then
			else
				pet_icon_frame:SetScript("OnEnter", function (...) BPCM:BuildIconToolTip(pet_icon_frame); end)
					pet_icon_frame:SetScript("OnLeave", function() GameTooltip:Hide(); end)

				--button.BP_Cage = BPCM:init_button(button, i.."C")
				--button.BP_Value = BPCM:init_button(button, i.."V")
				--button.BP_Value:SetTexture("Interface/ICONS/INV_Misc_Coin_19")
				--button.BP_Global= BPCM:init_button(button, i.."G")
				--button.BP_Global:SetTexture("Interface/ICONS/INV_Misc_Note_04")

				local frame = CreateFrame("Frame", "CageMatch"..i, button, "BPCM_ICON_TEMPLATE")
				frame:ClearAllPoints()
				frame:SetPoint("BOTTOMRIGHT", 0,0);
				frame.no_trade:ClearAllPoints()
				frame.no_trade:SetPoint("BOTTOMRIGHT", 0,0);
				button.BP_InfoFrame  = frame
			end

			button.BP_InfoFrame.speciesID = speciesID
			button.BP_InfoFrame.petlink = "p:"..speciesID..":1:2"


			if tradeable then
			--Set Cage icon info
				SetCageIcon(button.BP_InfoFrame.icons, speciesID)
				button.BP_InfoFrame.icons:Show()		
				button.BP_InfoFrame.no_trade:Hide()


				--Set Value icon info
				SetTSMValue(button.BP_InfoFrame.icons, speciesID)

				--Set Global icon info
				if BPCM:SearchList(speciesID,true) then
					button.BP_InfoFrame.icons.BP_Global:Show()
					button.BP_InfoFrame.icons.BP_Global.speciesID = speciesID
					button.BP_InfoFrame.icons.BP_Global.display = true
				else
					button.BP_InfoFrame.icons.BP_Global:Hide()
					button.BP_InfoFrame.icons.BP_Global.display = false
				end

			else
				if Profile.No_Trade then
					--button.BP_InfoFrame.icons.BP_Cage:SetTexture("Interface/Buttons/UI-GROUPLOOT-PASS-DOWN")
					--button.BP_InfoFrame.icons.BP_Cage:Show()
					button.BP_InfoFrame.no_trade:Show()
				else
					--button.BP_InfoFrame.icons.BP_Cage:Hide()
					button.BP_InfoFrame.no_trade:Hide()
				end

				
				button.BP_InfoFrame.icons:Hide()

--[[
				button.BP_InfoFrame.icons.BP_Cage.cage = false
				button.BP_InfoFrame.icons.BP_Cage.tooltip = nil
				button.BP_InfoFrame.icons.BP_Value.tooltip = nil
				button.BP_InfoFrame.icons.BP_Value.display = false
				button.BP_InfoFrame.icons.BP_Value:Hide()
				button.BP_InfoFrame.icons.BP_Value.petlink = nil
				button.BP_InfoFrame.icons.BP_Global.speciesID = nil
				button.BP_InfoFrame.icons.BP_Global:Hide()
				button.BP_InfoFrame.icons.BP_Global.display = false
				button.BP_InfoFrame.petlink = nil
				button.BP_InfoFrame.speciesID = nil
				]]--
			end
			BPCM:PositionIcons(button.BP_InfoFrame.icons)
			--button.BPCM:Show()

		else
			button.BP_InfoFrame.icons.BP_Cage:Hide()
			button.BP_InfoFrame.icons.BP_Value:Hide()
			button.BP_InfoFrame.icons.BP_Global:Hide()
			button.BP_InfoFrame.icons.BP_Value.display = false
			button.BP_InfoFrame.icons.BP_Global.display = false
						button.BP_InfoFrame:Hide()

		end
	end
end


function BPCM:UpdateButtons()
	if BPCM.REMATCH_LOADED  and RematchToolbar:IsVisible() then
		BPCM.cageButton:SetParent("RematchToolbar")
		BPCM.cageButton:SetPointSetPoint("LEFT", RematchToolbar.PetCount, "RIGHT", 25, 0)
		BPCM.cageButton:SetWidth(20)
		BPCM.cageButton:SetHeight(20)
	else
		BPCM.cageButton:SetParent("PetJournal")
		BPCM.cageButton:SetPoint("RIGHT", PetJournalFindBattle, "LEFT", 0, 0)

		BPCM.cageButton:SetWidth(20)
		BPCM.cageButton:SetHeight(20)
	end
end


function BPCM:BattlePetTooltip_Show(self, speciesID)
	local ownedText = self.Owned:GetText() or "" -- C_PetJournal.GetOwnedBattlePetString(species)
	local source = (Profile.Inv_Tooltips  and BPCM:SearchList(speciesID) ) or ""
	if source then
		local origHeight = self.Owned:GetHeight()
		self.Owned:SetWordWrap(true)
		self.Owned:SetText(ownedText .."|n" .. source)
		self:SetHeight(self:GetHeight() + self.Owned:GetHeight() - origHeight + 2)

		if self == FloatingBattlePetTooltip then
			self.Delimiter:SetPoint("TOPLEFT", self.Owned, "BOTTOMLEFT", -6, -2)
		end
	else
		self.Owned:SetWordWrap(false)

		if self == FloatingBattlePetTooltip then
			self.Delimiter:SetPoint("TOPLEFT", self.SpeedTexture, "BOTTOMLEFT", -6, -5)
		end
	end
end


local function UpdateData()
	BPCM:BPScanBags()
	BPCM:UpdatePetList_Icons()
end


---Updates Profile after changes
function BPCM:RefreshConfig()
	BPCM.Profile = self.db.profile
	Profile = BPCM.Profile
end


---Ace based addon initilization
function BPCM:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("BattlePetCageMatch_Options", defaults, true)
	options.args.profiles  = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	LibStub("AceConfigRegistry-3.0"):ValidateOptionsTable(options, "BattlePetCageMatch")
	LibStub("AceConfig-3.0"):RegisterOptionsTable("BattlePetCageMatch", options)

	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BattlePetCageMatch", "BattlePetCageMatch")
	self.db.RegisterCallback(BPCM, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(BPCM, "OnProfileCopied", "RefreshConfig")
	self.db.RegisterCallback(BPCM, "OnProfileReset", "RefreshConfig")

	BattlePetCageMatch_Data = BattlePetCageMatch_Data or {}
	playerNme = UnitName("player")
	realmName = GetRealmName()
	BattlePetCageMatch_Data[realmName] = BattlePetCageMatch_Data[realmName]  or {}
	BattlePetCageMatch_Data[realmName][playerNme] =  BattlePetCageMatch_Data[realmName][playerNme] or {}
	playerInv_DB = BattlePetCageMatch_Data[realmName][playerNme]

	BPCM.Profile = self.db.profile
	Profile = BPCM.Profile

	BPCM.BlackListDB = BPCM.PetBlacklist:new()
	BPCM.WhiteListDB = BPCM.PetWhitelist:new()
end

local function TSMVersionCheck()
	if TSM_API then 
		TSM_Version = 4
	else
		TSM_Version = 3
	end
end

function BPCM:OnEnable()
	BPCM:RegisterEvent("AUCTION_HOUSE_CLOSED", UpdateData)
	BPCM:RegisterEvent("BANKFRAME_CLOSED", UpdateData)
	BPCM:RegisterEvent("GUILDBANKFRAME_CLOSED", UpdateData)
	BPCM:RegisterEvent("DELETE_ITEM_CONFIRM", UpdateData)
	BPCM:RegisterEvent("MERCHANT_CLOSED", UpdateData)
	BPCM:RegisterEvent("NEW_PET_ADDED", UpdateData)
	BPCM:RegisterEvent("PET_JOURNAL_PET_DELETED", UpdateData)
	BPCM:RegisterEvent("MAIL_CLOSED", UpdateData)

	--Hooking PetJournal functions
	LoadAddOn("Blizzard_Collections")
	hooksecurefunc("PetJournal_UpdatePetList", UpdateData)
	hooksecurefunc(PetJournalListScrollFrame,"update", function(...)BPCM:UpdatePetList_Icons(); end)
	hooksecurefunc("BattlePetToolTip_Show", function(species, level, quality, health, power, speed, customName)
		BPCM:BattlePetTooltip_Show(BattlePetTooltip, species)
	end)

	--self:HookScript(PetJournal, "OnShow", function(...) BPCM:UpdateButtons(); end)

	--PetJournalEnhanced hooks
	if IsAddOnLoaded("PetJournalEnhanced") then
		hooksecurefunc(PetJournalEnhancedListScrollFrame,"update", function(...)BPCM:UpdatePetList_Icons(); end)
		 local PJE = LibStub("AceAddon-3.0"):GetAddon("PetJournalEnhanced")
		 BPCM.Sorting = PJE:GetModule(("Sorting"))
	end

	--Rematch hooks
	if IsAddOnLoaded("Rematch") then
		hooksecurefunc(Rematch,"FillCommonPetListButton", function(...)BPCM:UpdateRematch(...); end)

		--Rematch.Roster
	end

	BPCM.TSM_LOADED =  IsAddOnLoaded("TradeSkillMaster") --and IsAddOnLoaded("TradeSkillMaster_AuctionDB")
	BPCM.PJE_LOADED =  IsAddOnLoaded("PetJournalEnhanced")
	BPCM.REMATCH_LOADED =  IsAddOnLoaded("Rematch")
	TSMVersionCheck()
end

-- Binding Variables
BINDING_HEADER_BATTLEPETCAGEMATCH = "Battle Pet Cage Match"
BINDING_NAME_BPCM_AUTOCAGE = L.AUTO_CAGE_TOOLTIP_1
BINDING_NAME_BPCM_MOUSEOVER_CAGE = L.BPCM_MOUSEOVER_CAGE
_G["BINDING_NAME_CLICK BPCM_LearnButton:LeftButton"] = L.KEYBIND_LEARN


local recount_index = 1
function BPCM:UpdateRematch(button, petID)

--if not PetJournal:IsVisible() or RematchPetPanel.List.ScrollFrame:IsVisible() then return end

	local scrollFrame = (Rematch and RematchPetPanel.List.ScrollFrame:IsVisible() and RematchPetPanel.List.ScrollFrame)
			or (PetJournalEnhanced and PetJournalEnhancedListScrollFrame:IsVisible() and PetJournalEnhancedListScrollFrame)
			or (PetJournalListScrollFrame)

	local roster = Rematch and Rematch.Roster
	local button_name = button:GetName()

	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local buttons = scrollFrame.buttons
	local numPets = C_PetJournal.GetNumPets()
	local showPets = true
	
		local pet_icon_frame =  button.Pet
		

			--local index = (Rematch and RematchPetPanel.List.ScrollFrame:IsVisible() and displayIndex)
			--or (PetJournalEnhanced and PetJournalEnhancedListScrollFrame:IsVisible() and BPCM.Sorting:GetPetByIndex(displayIndex)["index"])
			--or displayIndex

			local speciesID, level, petName, tradeable
			--local petID = (Rematch and RematchPetPanel.List.ScrollFrame:IsVisible() and roster.petList[index]) or nil
			local idType = (Rematch and RematchPetPanel.List.ScrollFrame:IsVisible() and Rematch:GetIDType(petID)) or nil

			--Get data from proper indexes based on addon loaded and visable
			if Rematch and RematchPetPanel.List.ScrollFrame:IsVisible() and idType=="pet" then -- this is an owned pet
				speciesID, _, level, _, _, _, _, petName, _, petType, _, _, _, _, _, tradeable = C_PetJournal.GetPetInfoByPetID(petID)

			elseif Rematch and RematchPetPanel.List.ScrollFrame:IsVisible() and idType=="species" then -- speciesID for unowned pets
				speciesID = petID
				petName, _, _, _, _, _, _, _, tradeable = C_PetJournal.GetPetInfoBySpeciesID(petID)
			else
				--petID,speciesID,_,_,level,_,_,petName,_,_,_,_,_,_,_,tradeable =  C_PetJournal.GetPetInfoByIndex(index)
			end

			if  button.BP_InfoFrame then
			else
				--pet_icon_frame:SetScript("OnEnter", function (...) BPCM:BuildIconToolTip(pet_icon_frame); end)
				--pet_icon_frame:SetScript("OnLeave", function() GameTooltip:Hide(); end)

				--button.BP_Cage = BPCM:init_button(button, i.."C")
				--button.BP_Value = BPCM:init_button(button, i.."V")
				--button.BP_Value:SetTexture("Interface/ICONS/INV_Misc_Coin_19")
				--button.BP_Global= BPCM:init_button(button, i.."G")
				--button.BP_Global:SetTexture("Interface/ICONS/INV_Misc_Note_04")

				local frame = CreateFrame("Frame", "CageMatch_RC"..recount_index, button, "BPCM_ICON_TEMPLATE")
				frame:ClearAllPoints()
				frame:SetPoint("BOTTOMRIGHT", 0,0);
				frame.no_trade:ClearAllPoints()
				frame.no_trade:SetPoint("BOTTOMRIGHT", 0,0);
				button.BP_InfoFrame  = frame
			end

			button.BP_InfoFrame.speciesID = speciesID
			button.BP_InfoFrame.petlink = "p:"..speciesID..":1:2"


			if tradeable then
			--Set Cage icon info
				SetCageIcon(button.BP_InfoFrame.icons, speciesID)
				button.BP_InfoFrame.icons:Show()		
				button.BP_InfoFrame.no_trade:Hide()


				--Set Value icon info
				SetTSMValue(button.BP_InfoFrame.icons, speciesID)

				--Set Global icon info
				if BPCM:SearchList(speciesID,true) then
					button.BP_InfoFrame.icons.BP_Global:Show()
					button.BP_InfoFrame.icons.BP_Global.speciesID = speciesID
					button.BP_InfoFrame.icons.BP_Global.display = true
				else
					button.BP_InfoFrame.icons.BP_Global:Hide()
					button.BP_InfoFrame.icons.BP_Global.display = false
				end

			else
				if Profile.No_Trade then
					--button.BP_InfoFrame.icons.BP_Cage:SetTexture("Interface/Buttons/UI-GROUPLOOT-PASS-DOWN")
					--button.BP_InfoFrame.icons.BP_Cage:Show()
					button.BP_InfoFrame.no_trade:Show()
				else
					--button.BP_InfoFrame.icons.BP_Cage:Hide()
					button.BP_InfoFrame.no_trade:Hide()
				end

				
				button.BP_InfoFrame.icons:Hide()

--[[
				button.BP_InfoFrame.icons.BP_Cage.cage = false
				button.BP_InfoFrame.icons.BP_Cage.tooltip = nil
				button.BP_InfoFrame.icons.BP_Value.tooltip = nil
				button.BP_InfoFrame.icons.BP_Value.display = false
				button.BP_InfoFrame.icons.BP_Value:Hide()
				button.BP_InfoFrame.icons.BP_Value.petlink = nil
				button.BP_InfoFrame.icons.BP_Global.speciesID = nil
				button.BP_InfoFrame.icons.BP_Global:Hide()
				button.BP_InfoFrame.icons.BP_Global.display = false
				button.BP_InfoFrame.petlink = nil
				button.BP_InfoFrame.speciesID = nil
				]]--
			end
			BPCM:PositionIcons(button.BP_InfoFrame.icons)
			--button.BPCM:Show()


	
	


end

--Support for TSM3 and updated API for TSM4


function BPCM.TSM:GetCustomPriceValue(source, itemID)

	if TSM_Version == 3 then 
		return TSMAPI:GetCustomPriceValue(source, itemID)
	else
		return TSM_API.GetCustomPriceValue(source, itemID)
	end
end

function BPCM.TSM:MoneyToString(priceMarket)

	if TSM_Version == 3 then 
		return TSMAPI:MoneyToString(priceMarket)
	else
		return TSM_API.FormatMoneyString(priceMarket)
	end
end


function BPCM.TSM:GetAuctionQuantity(pBattlePetID)

	if TSM_Version == 3 then 
		return TSMAPI.Inventory:GetAuctionQuantity(pBattlePetID)
	else
		return  TSMAPI_FOUR.Inventory.GetAuctionQuantity(pBattlePetID)
	end

end

function BPCM.TSM:ValidateCustomPrice(price)
	if TSM_Version == 3 then 
		return TSMAPI:ValidateCustomPrice(price)
	else
		return TSM_API.IsCustomPriceValid(price)
	end
end

BPCM.PriceSources = {}
function BPCM.TSM:GetPriceSources()
	if TSM_Version == 3 then 
		return TSMAPI:GetPriceSources()
	else
		local table = {}
		 TSM_API.GetPriceSourceKeys(BPCM.PriceSources) 
		return BPCM.PriceSources
	end
end