local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local tooltipAPI ={}
local GetScreenWidth = GetScreenWidth
local GetScreenHeight = GetScreenHeight

local LAT = LibStub("LibArmorToken-1.0")
local LAI = LibStub("LibAppropriateItems-1.0")

local IsDressableItem = _G.IsDressableItem or C_Item.IsDressableItemByID
local appearances_known = {}
local tooltips = {}

function tooltipAPI.RegisterTooltip(tip)
	if not tip or tooltips[tip] then
		return
	end

	tooltips[tip] = tip
end

if TooltipDataProcessor then
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(self, data)
	end)
end

tooltipAPI.RegisterTooltip(GameTooltip)
tooltipAPI.RegisterTooltip(GameTooltip.ItemTooltip.Tooltip)

----
local function addDoubleLine(tooltip, left_text, right_text)
	tooltip:AddDoubleLine(left_text, right_text, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
end

local function addLine(tooltip, text)
	tooltip:AddLine(text, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, true)
end

local _, class = UnitClass("player")
function tooltipAPI:ShowItem(link, for_tooltip)
	if not link then return end

	for_tooltip = for_tooltip or GameTooltip
	local id = tonumber(link:match("item:(%d+)"))
	local dressable = id and C_Item.IsDressableItemByID(id)
	local token = addon.Profile.ShowTokenTooltips and LAT:ItemIsToken(id)

	--No need to update tooltips if item is not token or a mog
	if not id or id == 0 or (not token and not dressable) then 
		return
	end

	local _, itemLink
	local learned_dupe = false
	local found_tooltipinfo = false
	local found_systemTooltip = false
	for i = 1, GameTooltip:NumLines() do
		local line = _G["GameTooltipTextLeft"..i]

		local text = line:GetText() or " "
		local text_lower = string.lower(line:GetText() or " " )
		--Check to see if another addon added appearance known text
		if string.find(text_lower, string.lower(TRANSMOGRIFY_TOOLTIP_APPEARANCE_KNOWN)) or
			string.find(text_lower, "item id") then
			learned_dupe = true
		end

		if string.find(text_lower, string.lower(L["HEADERTEXT"])) then
			found_tooltipinfo = true
		end

		if addon.Profile.ShowOwnedItemTooltips and string.find(text_lower, string.lower(TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN)) then
			line:SetText("|TInterface\\RaidFrame\\ReadyCheck-NotReady:0|t "..text)
			found_systemTooltip = true
		end
		--Adds icon to TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN if found
		if addon.Profile.ShowOwnedItemTooltips and string.find(text_lower, string.lower(TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN) ) then
			line:SetText("|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t "..text)
			found_systemTooltip = true
		end

		if addon.Profile.ShowItemIDTooltips and string.find(text_lower, string.lower(ITEM_LEVEL) ) then
			line:SetText(text.."         "..L["Item ID"]..": |cffffffff"..id)
		end
	end

	if addon.Profile.ShowOwnedItemTooltips and not 	found_systemTooltip then
		local hasAppearance, appearanceFromOtherItem = tooltipAPI.PlayerHasAppearance(link)

		local label
		if not tooltipAPI.CanTransmogItem(link) then
			label = "|c00ffff00" .. TRANSMOGRIFY_INVALID_DESTINATION
		else
			if hasAppearance then
				if appearanceFromOtherItem then
					label = "|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t " .. (TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN):gsub(', ', ',\n')
				else
					label = "|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t " .. TRANSMOGRIFY_TOOLTIP_APPEARANCE_KNOWN
				end
			else
				label = "|TInterface\\RaidFrame\\ReadyCheck-NotReady:0|t |cffff0000" .. TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN
			end
		end

		addDoubleLine(GameTooltip,label,"")
	end

	local appropriateItem = LAI:IsAppropriate(id)

	if addon.Profile.ShowOwnedItemTooltips and not 	appropriateItem then
			addDoubleLine(GameTooltip, "|TInterface\\RaidFrame\\ReadyCheck-NotReady:0|t |cffff0000Your class can't transmogrify this item", "")
		end

	if token then
		-- It's a set token! Replace the id.
		local found
		for _, itemid in LAT:IterateItemsForTokenAndClass(id, class) do
				_, itemLink = GetItemInfo(itemid)
				if itemLink then
					id = itemid
					link = itemLink
					found = true
					break
				end
		end

		if not found then
			for _, tokenclass in LAT:IterateClassesForToken(id) do
				for _, itemid in LAT:IterateItemsForTokenAndClass(id, tokenclass) do
					_, itemLink = GetItemInfo(itemid)
					if itemLink then
						id = itemid
						link = itemLink
						found = true
						break
					end
				end
				break
			end
		end

		if found then
				for_tooltip:AddDoubleLine(ITEM_PURCHASED_COLON, link)
				for_tooltip:Show()
		end
	end

	local slot = select(9, GetItemInfo(id))

	if addon.Profile.ShowTooltips and not found_tooltipinfo then
		local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(id)
		if not sourceID then return end
		local addHeader = false
		local inList, count = addon.CollectionList:IsInList(appearanceID, "item", true)

		if addon.Profile.ShowCollectionListTooltips and inList then
			if not addHeader then
				addHeader = true
				--addLine(self, L["HEADERTEXT"])
				addLine(GameTooltip, " ")
				GameTooltip:AddTexture("Interface\\DialogFrame\\UI-DialogBox-Divider.blp",{width = GameTooltip:GetWidth()+25, height = 15})
			end

			addDoubleLine (GameTooltip,"|cff87aaff"..L["-Appearance in %d Collection List-"]:format(count), " ")
		end
		

		local setIDs = C_TransmogSets.GetSetsContainingSourceID(sourceID)
		local shownSetNames = {}
		if addon.Profile.ShowSetTooltips and #setIDs > 0 then
			if not addHeader then
				addHeader = true
				--addLine(self, L["HEADERTEXT"])
				addLine(GameTooltip, " ")
				
				GameTooltip:AddTexture("Interface\\DialogFrame\\UI-DialogBox-Divider.blp",{width = GameTooltip:GetWidth()+25, height = 15})

				--GameTooltip:AddTexture("Interface\\QUESTFRAME\\UI-HorizontalBreak.blp",{width = self:GetWidth()-10, height = 15})
			end

			for i, setID in pairs(setIDs) do
				local setInfo = C_TransmogSets.GetSetInfo(setID)
				addDoubleLine (GameTooltip,"|cffffd100"..L["Part of Set:"], " ")
				local collected, total = addon.SetsDataProvider:GetSetSourceCounts(setID)
				local color = YELLOW_FONT_COLOR_CODE
				if collected == total then
					color = GREEN_FONT_COLOR_CODE
				end

				addDoubleLine (GameTooltip," ",L["-%s %s(%d/%d)"]:format(setInfo.name or "", color, collected, total))
				shownSetNames[setInfo.name] = true

				if addon.Profile.ShowDetailedListTooltips then
					local sources = addon.GetSetSources(setID)
					for sourceID, collected in pairs(sources) do
						local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
						if collected and not addon.Profile.ShowMissingDetailedListTooltips then
							color = GREEN_FONT_COLOR_CODE
							addDoubleLine (GameTooltip," ",L["|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t %s%s"]:format(color, sourceInfo.name or ""))
						elseif not collected then
							color = RED_FONT_COLOR_CODE
							addDoubleLine (GameTooltip," ",L["|TInterface\\RaidFrame\\ReadyCheck-NotReady:0|t %s%s"]:format(color, sourceInfo.name or ""))
						end
					end
				end
			end
		end

		local setData = addon.IsSetItem(itemLink)
		if addon.Profile.ShowExtraSetsTooltips and setData then
			if not addHeader then
				addHeader = true
				--addLine(self, L["HEADERTEXT"])
								addLine(GameTooltip, " ")
				GameTooltip:AddTexture("Interface\\DialogFrame\\UI-DialogBox-Divider.blp",{width = GameTooltip:GetWidth()+25, height = 15})
			end

			addDoubleLine (GameTooltip,"|cffffd100"..L["Part of Extra Set:"], " ")
			for _, data in pairs(setData) do
				--if not shownSetNames[data.name] then 
					local collected, total = addon.SetsDataProvider:GetSetSourceCounts(data.setID)
					local color = YELLOW_FONT_COLOR_CODE
					if collected == total then
						color = GREEN_FONT_COLOR_CODE
					end

					addDoubleLine (GameTooltip," ",L["-%s %s(%d/%d)"]:format(data.name or "", color, collected, total))

					if addon.Profile.ShowDetailedListTooltips then
						local sources = addon.GetSetsources(data.setID)
						for sourceID, collected in pairs(sources) do
							local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
							if collected and not addon.Profile.ShowMissingDetailedListTooltips then
								color = GREEN_FONT_COLOR_CODE
								addDoubleLine (GameTooltip," ",L["|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t %s%s"]:format(color, sourceInfo.name or ""))
							elseif not collected then
								color = RED_FONT_COLOR_CODE
								addDoubleLine (GameTooltip," ",L["|TInterface\\RaidFrame\\ReadyCheck-NotReady:0|t %s%s"]:format(color, sourceInfo.name or ""))
							end
						end
					end
				--end
			end
		end

		if addHeader then
			--addLine(self, L["HEADERTEXT"])
			addLine(GameTooltip, " ")
			GameTooltip:AddTexture("Interface\\DialogFrame\\UI-DialogBox-Divider.blp",{width = GameTooltip:GetWidth()+25, height = 15})
		end

		GameTooltip:Show()
	end
end


function tooltipAPI.CanTransmogItem(itemLink)
	local itemID = GetItemInfoInstant(itemLink)
	if itemID then
		local canBeChanged, noChangeReason, canBeSource, noSourceReason = C_Transmog.CanTransmogItem(itemID)
		return canBeSource, noSourceReason
	end
end


function tooltipAPI.PlayerHasAppearance(itemLinkOrID)
	-- hasAppearance, appearanceFromOtherItem
	local itemID = GetItemInfoInstant(itemLinkOrID)
	if not itemID then return end
	local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemLinkOrID)
	if not appearanceID then
		appearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemID)
	end

	if not appearanceID then return end

	if sourceID and appearances_known[appearanceID] then
		return true, not C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID)
	end

	local sources = C_TransmogCollection.GetAllAppearanceSources(appearanceID)
	if sources then
		local known_any = false
		for _, id in pairs(sources) do
				if C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(id) then
					known_any = true
					if itemID == C_TransmogCollection.GetSourceItemID(id) then
						return true, false
					end
				end
		end

		return known_any, false
	end

	return false
end