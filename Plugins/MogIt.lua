local addonName, addon = ...
--addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)


--Stubs to for when MogIt is not loaded
local MogIt = {}
addon.MogIt = MogIt
function MogIt.GetMogitOutfits() return {} end
function MogIt.GetMogitWishlist() return {["extraset"] = {},["name"] = "MogIt Wishlist",["item"] = {},	["set"] = {},} end
MogIt.MogitSets = {}

function MogIt:DeleteSet(setName, noConfirm)
end
function MogIt:RenameSet(setName)
end

if not IsAddOnLoaded("MogIt") then return end
if true then return end --TODO remove when updated
local  mog = _G["MogIt"]
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local Wishlist = mog:GetModule("Wishlist")

local function SetHooks()
	if addon:IsHooked(Wishlist, "DeleteSet") then return end
	addon:SecureHook(Wishlist, "DeleteSet", function(self)  addon:SendMessage("BW_TRANSMOG_COLLECTION_UPDATED") end)
	addon:SecureHook(Wishlist, "RenameSet", function(self) addon:SendMessage("BW_TRANSMOG_COLLECTION_UPDATED") end)
	addon:SecureHook(Wishlist, "CreateSet", function(self) addon:SendMessage("BW_TRANSMOG_COLLECTION_UPDATED") end)
	addon:SecureHook(Wishlist, "GetSet", function(self) addon:SendMessage("BW_TRANSMOG_COLLECTION_UPDATED") end)
	addon:SecureHook(Wishlist, "BuildList", function(self) addon:SendMessage("BW_TRANSMOG_COLLECTION_UPDATED") end)
end

function MogIt:DeleteSet(setName, noConfirm)
	Wishlist:DeleteSet(setName, noConfirm)
	--addon:SendMessage("BW_TRANSMOG_COLLECTION_UPDATED")
end

function MogIt:RenameSet(setName)
	Wishlist:RenameSet(setName)
	--addon:SendMessage("BW_TRANSMOG_COLLECTION_UPDATED")
end
local function UpdateFrames()
	local ScrollFrames = {BetterWardrobeCollectionFrameScrollFrame.buttons, WardrobeCollectionFrameScrollFrame.buttons}
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

	local orig_OnMouseDown = BetterWardrobeCollectionFrame.ItemsCollectionFrame.Models[1]:GetScript("OnMouseDown")


	for i, model in ipairs(BetterWardrobeCollectionFrame.ItemsCollectionFrame.Models) do
		model:SetScript("OnMouseDown", function(self, button)
			if IsControlKeyDown() and button == "RightButton" then
				local link
				local sources = WardrobeCollectionFrame_GetSortedAppearanceSources(self.visualInfo.visualID)
				if BetterWardrobeCollectionFrame.tooltipSourceIndex then
					local index = WardrobeUtils_GetValidIndexForNumSources(BetterWardrobeCollectionFrame.tooltipSourceIndex, #sources)
					link = select(6, C_TransmogCollection.GetAppearanceSourceInfo(sources[index].sourceID))
				end
				mog:AddToPreview(link)
				return
			end
			orig_OnMouseDown(self, button)
		end)
	end



	
end

addon:RegisterMessage("BW_ADDON_LOADED", function() UpdateFrames() end)

addon:RegisterMessage("BW_OnPlayerEnterWorld", function() SetHooks() end)



function MogIt.GetMogitOutfits() 
	local sets = Wishlist:GetSets(nil, true)
	if #sets == 0 then return end

	local mogSets = {}
	local slotList = addon.Globals.slots
	for i, set in pairs(sets) do
		local data = {}
		data.name = set.name or ""
		--data.name = "MogIt - " .. set.name or ""
		data.set = "mogit"
		data.setType = "SavedMogIt"
		data.label = L["MogIt Set"]
		data.index = i + 6000
		data.outfitID = 6000 + i
		data.mainHandEnchant = 0
		data.offHandEnchant = 0
		data.offShoulder = 0
		data.itemData = data.itemData or {}

		for i, invSlot in ipairs(slotList) do
			local slotID = GetInventorySlotInfo(invSlot)
			local itemLink = set.items[invSlot]
		--print(itemLink)
			if itemLink then
				local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemLink)
				local sourceInfoSuccess, sourceInfo = pcall(C_TransmogCollection.GetSourceInfo, sourceID)
				if (sourceInfoSuccess) then
					local appearanceID = sourceInfo.visualID
					local itemID = sourceInfo.itemID
					local itemMod = sourceInfo.itemModID
					--print(invSlot)
					data.itemData[slotID] = {"'"..itemID..":"..itemMod.."'", sourceID, appearanceID}
					if not data.icon then
						--local categoryID, visualID, canEnchant, icon, isCollected, itemLink, transmogLink, unknown1 = C_TransmogCollection.GetAppearanceSourceInfo(itemLink)
						local _, _, _, _, icon, _, _ = GetItemInfoInstant(itemLink) 
						data.icon = icon
					end
				end
			end
		end
		--[[local items = set.items
						local sources = {}
						for i, invSlot in ipairs(addon.Globals.slots) do
							local slotID = GetInventorySlotInfo(invSlot)
							local item = items[invSlot]
							data.items[slotID] = item
							local icon
							if item then
								local sourceID = addon.GetSourceFromItem(item)
								local sourceInfo =  C_TransmogCollection.GetSourceInfo(sourceID)
								--print(sourceID)
								sources[item] = sourceInfo.visualID
								if not icon then 
									icon = select(5, GetItemInfoInstant(item))
									data.icon = icon
								end
							end
						end]]
		--data.sources = sources
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


local function matchVisual(itemlink)
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
			BetterWardrobeCollectionFrame.ItemsCollectionFrame:RefreshVisualsList()
			BetterWardrobeCollectionFrame.ItemsCollectionFrame:UpdateItems()
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

local MAX_DEFAULT_OUTFITS = C_TransmogCollection.GetNumMaxOutfits()
local function IsDefaultSet(outfitID)
	
	return outfitID < MAX_DEFAULT_OUTFITS  -- #C_TransmogCollection.GetOutfits()--MAX_DEFAULT_OUTFITS 
end

function MogIt:CopySet(outfitID)
	local icon
	local outfit

	local itemTransmogInfoList = {}
	local setdata = addon.GetSetInfo(outfitID)
	local name = setdata.name.." (Copy)"
	local icon = setdata.icon
	local itemlist = setdata.sources

	--for key, transmogSlot in pairs(TRANSMOG_SLOTS) do
	for slotID = 1, 19 do
		--local slotID = transmogSlot.location:GetSlotID();
		local itemTransmogInfo = ItemUtil.CreateItemTransmogInfo(itemlist[slotID] or 0, 0, 0);
		itemTransmogInfoList[slotID] = itemTransmogInfo
	end

	if (outfitID and IsDefaultSet(outfitID)) or (#C_TransmogCollection.GetOutfits() < MAX_DEFAULT_OUTFITS)  then 
		outfitID = C_TransmogCollection.NewOutfit(name, icon, itemTransmogInfoList);
	else
		tinsert(addon.OutfitDB.char.outfits, setdata)
		outfit = addon.OutfitDB.char.outfits[#addon.OutfitDB.char.outfits]
		outfit["name"] = name
		outfit.setID = nil
		--outfit["icon"] = setdata.icon
		--outfit.itemTransmogInfoList =  itemTransmogInfoList or {}
	end

	addon:SendMessage("BW_TRANSMOG_COLLECTION_UPDATED")
end
