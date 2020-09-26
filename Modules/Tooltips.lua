local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

-----------------------------
-- Adding to tooltip       --
-----------------------------

local function addDoubleLine(tooltip, left_text, right_text)
	tooltip:AddDoubleLine(left_text, right_text, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
end


local function addLine(tooltip, text)
	tooltip:AddLine(text, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, true)
end


local function addToTooltip(tooltip, itemLink, bag, slot)
	
	if not itemLink or tooltip.BW_tooltipWritten or not addon.Profile.ShowTooltips then tooltip.BW_tooltipWritten = true; return end

	tooltip.BW_tooltipWritten = true
	local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemLink)
	if not sourceID then return end
	local addHeader = false

	if addon.Profile.ShowCollectionListTooltips and addon.chardb.profile.collectionList["item"][appearanceID] then
		if not addHeader then 
			addHeader = true
			addLine(tooltip, L["HEADERTEXT"])
		end

		addDoubleLine (tooltip,"|cff87aaff"..L["-Appearance in Collection List-"], " ")
		tooltip:Show()
	end

	local setIDs = C_TransmogSets.GetSetsContainingSourceID(sourceID)
	if addon.Profile.ShowSetTooltips and #setIDs > 0 then 
		if not addHeader then 
			addHeader = true
			addLine(tooltip, L["HEADERTEXT"])
		end

		for i, setID in pairs(setIDs) do 
			local setInfo = C_TransmogSets.GetSetInfo(setID)
			--addLine(tooltip, '--------')
			addDoubleLine (tooltip,"|cffffd100"..L["Part of Set:"], " ")
			local collected, total = addon.SetsDataProvider:GetSetSourceCounts(setID)
			local color = YELLOW_FONT_COLOR_CODE
			if collected == total then 
				color = GREEN_FONT_COLOR_CODE
			end

			addDoubleLine (tooltip," ",L["-%s %s(%d/%d)"]:format(setInfo.name or "", color, collected, total))
		end
		tooltip:Show()
	end

	local setData = addon.IsSetItem(itemLink)
	if addon.Profile.ShowExtraSetsTooltips and setData then 
		if not addHeader then 
			addHeader = true
			addLine(tooltip, L["HEADERTEXT"])
		end
		addDoubleLine (tooltip,"|cffffd100"..L["Part of Extra Set:"], " ")
		for _, data in pairs(setData) do
			local collected, total = addon.ExtraSetsDataProvider:GetSetSourceCounts(data.setID)
			local color = YELLOW_FONT_COLOR_CODE
			if collected == total then 
				color = GREEN_FONT_COLOR_CODE
			end

			addDoubleLine (tooltip," ",L["-%s %s(%d/%d)"]:format(data.name or "", color, collected, total))
		end
		tooltip:Show()
	end

	if addHeader then 
		addLine(tooltip, L["HEADERTEXT"])
		tooltip:Show()
	end
end


local function TooltipCleared(tooltip)
	tooltip.BW_tooltipWritten = false
end


GameTooltip:HookScript("OnTooltipCleared", TooltipCleared)
ItemRefTooltip:HookScript("OnTooltipCleared", TooltipCleared)
ItemRefShoppingTooltip1:HookScript("OnTooltipCleared", TooltipCleared)
ItemRefShoppingTooltip2:HookScript("OnTooltipCleared", TooltipCleared)
ShoppingTooltip1:HookScript("OnTooltipCleared", TooltipCleared)
ShoppingTooltip2:HookScript("OnTooltipCleared", TooltipCleared)
GameTooltip.ItemTooltip.Tooltip:HookScript("OnTooltipCleared", TooltipCleared)

local function CanIMogIt_AttachItemTooltip(tooltip)
	-- Hook for normal tooltips.
	local link = select(2, tooltip:GetItem())
	if link then
		addToTooltip(tooltip, link)
	end
end


GameTooltip:HookScript("OnTooltipSetItem", CanIMogIt_AttachItemTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", CanIMogIt_AttachItemTooltip)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", CanIMogIt_AttachItemTooltip)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", CanIMogIt_AttachItemTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", CanIMogIt_AttachItemTooltip)
ShoppingTooltip2:HookScript("OnTooltipSetItem", CanIMogIt_AttachItemTooltip)
GameTooltip.ItemTooltip.Tooltip:HookScript("OnTooltipSetItem", CanIMogIt_AttachItemTooltip)

hooksecurefunc(GameTooltip, "SetMerchantItem",
	function(tooltip, index)
		addToTooltip(tooltip, GetMerchantItemLink(index))
	end
)


hooksecurefunc(GameTooltip, "SetBuybackItem",
	function(tooltip, index)
		addToTooltip(tooltip, GetBuybackItemLink(index))
	end
)


hooksecurefunc(GameTooltip, "SetBagItem",
	function(tooltip, bag, slot)
		addToTooltip(tooltip, GetContainerItemLink(bag, slot), bag, slot)
	end
)


hooksecurefunc(GameTooltip, "SetLootItem",
	function(tooltip, slot)
		if LootSlotHasItem(slot) then
			local link = GetLootSlotLink(slot)
			addToTooltip(tooltip, link)
		end
	end
)


hooksecurefunc(GameTooltip, "SetLootRollItem",
	function(tooltip, slot)
		addToTooltip(tooltip, GetLootRollItemLink(slot))
	end
)


hooksecurefunc(GameTooltip, "SetInventoryItem",
	function(tooltip, unit, slot)
		addToTooltip(tooltip, GetInventoryItemLink(unit, slot))
	end
)


hooksecurefunc(GameTooltip, "SetGuildBankItem",
	function(tooltip, tab, slot)
		addToTooltip(tooltip, GetGuildBankItemLink(tab, slot))
	end
)


hooksecurefunc(GameTooltip, "SetRecipeResultItem",
	function(tooltip, itemID)
		addToTooltip(tooltip, C_TradeSkillUI.GetRecipeItemLink(itemID))
	end
)


hooksecurefunc(GameTooltip, "SetRecipeReagentItem",
	function(tooltip, itemID, index)
		addToTooltip(tooltip, C_TradeSkillUI.GetRecipeReagentItemLink(itemID, index))
	end
)


hooksecurefunc(GameTooltip, "SetTradeTargetItem",
	function(tooltip, index)
		addToTooltip(tooltip, GetTradeTargetItemLink(index))
	end
)


hooksecurefunc(GameTooltip, "SetQuestLogItem",
	function(tooltip, type, index)
		addToTooltip(tooltip, GetQuestLogItemLink(type, index))
	end
)


hooksecurefunc(GameTooltip, "SetInboxItem",
	function(tooltip, mailIndex, attachmentIndex)
		addToTooltip(tooltip, GetInboxItemLink(mailIndex, attachmentIndex or 1))
	end
)


hooksecurefunc(GameTooltip, "SetSendMailItem",
	function(tooltip, index)
		local name = GetSendMailItem(index)
		local _, link = GetItemInfo(name)
		addToTooltip(tooltip, link)
	end
)


local function OnSetHyperlink(tooltip, link)
	local type, id = string.match(link, ".*(item):(%d+).*")
	if not type or not id then return end
	if type == "item" then
		addToTooltip(tooltip, link)
	end
end


hooksecurefunc(GameTooltip, "SetHyperlink", OnSetHyperlink)