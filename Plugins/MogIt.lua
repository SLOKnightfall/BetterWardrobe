local addonName, addon = ...
--addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)


--Stubs to for when MogIt is not loaded
local MogIt = {}
addon.MogIt = MogIt
function MogIt.GetMogitOutfits() return {} end
function MogIt.GetMogitWishlist() return {["extraset"] = {},["name"] = "MogIt Wishlist",["item"] = {},	["set"] = {},} end
MogIt.MogitSets = {}


if not IsAddOnLoaded("MogIt") then return end
local  mog = _G["MogIt"]
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)


local function SetHooks()
	local ScrollFrames = {WardrobeCollectionFrameScrollFrame.buttons, BW_SetsCollectionFrameScrollFrame.buttons}
--Hooks into the extra sets scroll frame buttons to allow ctrl-right clicking on the button to generate a mogit preview
	for index, buttons in ipairs(ScrollFrames) do
		local orig_OnMouseUp = buttons[1]:GetScript("OnMouseUp")
		for i = 1, #buttons do
			local button = buttons[i]
			button:SetScript("OnMouseUp", function(self, button)
				if IsControlKeyDown() and button == "RightButton" then
					local preview = mog:GetPreview()
					local sources = (index == 1 and C_TransmogSets.GetSetSources(self.setID)) or  addon.GetSetsources(self.setID)
					for source in pairs(sources) do
						mog:AddToPreview(select(6, C_TransmogCollection.GetAppearanceSourceInfo(source)), preview)
					end
					return
				end
				orig_OnMouseUp(self, button)
			end)
		end
	end

	local orig_OnMouseDown = WardrobeCollectionFrame.ItemsCollectionFrame.Models[1]:GetScript("OnMouseDown")


	for i, model in ipairs(WardrobeCollectionFrame.ItemsCollectionFrame.Models) do
		model:SetScript("OnMouseDown", function(self, button)
			if IsControlKeyDown() and button == "RightButton" then
				local link
				local sources = WardrobeCollectionFrame_GetSortedAppearanceSources(self.visualInfo.visualID)
				if WardrobeCollectionFrame.tooltipSourceIndex then
					local index = WardrobeUtils_GetValidIndexForNumSources(WardrobeCollectionFrame.tooltipSourceIndex, #sources)
					link = select(6, C_TransmogCollection.GetAppearanceSourceInfo(sources[index].sourceID))
				end
				mog:AddToPreview(link)
				return
			end
			orig_OnMouseDown(self, button)
		end)
	end
	
end


addon:RegisterMessage("BW_OnPlayerEnterWorld", function() SetHooks() end)


 Wishlist = mog:GetModule("Wishlist")
function MogIt.GetMogitOutfits() 
	local sets = Wishlist:GetSets(nil, true)
	if #sets == 0 then return end

	local mogSets = {}
	for i, set in pairs(sets) do
		local data = {}
		data.name = "MogIt - " .. set.name or ""
		data.set = "mogit"
		data.index = i + 5000
		data.outfitID = 5000 + i
		data.mainHandEnchant = 0
		data.offHandEnchant = 0

		local items = set.items
		for i, invSlot in ipairs(addon.Globals.slots) do
			local slotID = GetInventorySlotInfo(invSlot)
			local item = items[invSlot]
			local icon
			if item then
				local sourceID = addon.GetSourceFromItem(item)
				data[slotID] = sourceID
				if not icon then 
					icon = select(5, GetItemInfoInstant(item))
					data.icon = icon
				end
			end
		end
		MogIt.MogitSets[data.index] = data
		tinsert(mogSets, data)
	end

	return mogSets
end

function MogIt.GetMogitWishlist()
	local list = Wishlist:BuildList()
	local item_list = {["extraset"] = {},["name"] = "MogIt Wishlist",["item"] = {},	["set"] = {},}
	for i, itemlink in ipairs(list) do
		if type(itemlink) == "string" then	
			local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemlink)
			if appearanceID then 
				item_list.item[appearanceID] = true
			end
		end
	end
	return item_list
end


function matchVisual(itemlink)
	local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemlink)
	local list = Wishlist:BuildList()

	for i, mog_itemlink in ipairs(list) do
		if type(mog_itemlink) == "string" then	
			local mog_appearanceID = C_TransmogCollection.GetItemInfo(mog_itemlink)
			if appearanceID == mog_appearanceID then 
				return mog_itemlink
			end
		end
	end

 	return nil
end


function MogIt.UpdateWishlistItem(type, typeID, add)
	local addSet
	if type == "item" then 
		local itemlink
		local sources = C_TransmogCollection.GetAllAppearanceSources(typeID)
		if sources then 
			itemlink = select(6, C_TransmogCollection.GetAppearanceSourceInfo(sources[1]))
		
			if add then 
				Wishlist:AddItem(itemlink)
				mog:BuildList(nil, "Wishlist")
			else
				local mogitItem = matchVisual(itemlink)
				Wishlist:DeleteItem(mogitItem)
				mog:BuildList(nil, "Wishlist")
			end
			print(add and L["Appearance added."] or L["Appearance removed."] )
			WardrobeCollectionFrame.ItemsCollectionFrame:RefreshVisualsList()
			WardrobeCollectionFrame.ItemsCollectionFrame:UpdateItems()
		end
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

		for sourceID, isCollected in pairs(sources) do

			local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)

			local visualID = C_TransmogCollection.GetItemInfo(sourceInfo.itemID, itemModID)--(type == "set" and sourceInfo.visualID) or addon.GetItemSource(sourceID, setInfo.mod)
			if visualID then 

				addSet = MogIt.UpdateWishlistItem("item", visualID, add or nil)	
			end
		end



		--print( addSet and L["%s: Uncollected items added"]:format(setName) or L["No new appearces needed."])
		return addSet
	end

end