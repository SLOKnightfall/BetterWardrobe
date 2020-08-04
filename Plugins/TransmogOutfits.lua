local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

--Stubs to for when MogIt is not loaded
local TransmogOutfits = {}
addon.TransmogOutfits = TransmogOutfits

function TransmogOutfits.GetOutfits() return {} end

if not IsAddOnLoaded("TransmogOutfits") then return end
if true then return end -- TODO remove when updated

function TransmogOutfits.GetOutfits() 
	local sets = transmogOutfitOutfits

	if #sets == 0 then return end

	local mogSets = {}
	for i, set in pairs(sets) do
		local data = {}
		--data.items = {}
		--data.sources = {}
		--for index, setdata in pairs(set) do
--[[		for index = 1, 19 do

				local setdata = set[index]
				if setdata then 
					local info = C_TransmogCollection.GetSourceInfo(setdata)
					local itemID = info and info.itemID or 0
					local visualID = info and info.visualID or 0

					if not data.icon and itemID then
						local _, _, _, icon = C_TransmogCollection.GetAppearanceSourceInfo(setdata)
 
						icon = itemID
					end

					data.sources[itemID] = visualID
					tinsert(data.items, itemID)
				end

			--data[index] = setdata
		end]]

		data.set = "transmog_outfits"
		data.setType = "SavedTransmogOutfit"

		data.index = i + 7000		
		data.outfitID = 7000 + i
		data.set = "transmogoutfits"
		data.label = L["TransmogOutfits Saved Set"]

		data.mainHandEnchant = set.enchant1 or Constants.Transmog.NoTransmogID
		data.offHandEnchant = set.enchant2 or Constants.Transmog.NoTransmogID
		--data.enchant1 = nil
		--data.enchant1 = nil
		data.mainShoulder = set[3] or nil
		data.offShoulder = set[33] or nil
		--data[33] = nil
		data.orgIndex = i
		data.name = set.name or ""
		data.itemData = {}

		----data.icon = 133745
		for i, invSlot in ipairs(addon.Globals.slots) do
			local slotID = GetInventorySlotInfo(invSlot)
			local sourceID = set[slotID]
			if sourceID then 
				local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
				if sourceInfo then 
					local appearanceID = sourceInfo.visualID
					local itemID = sourceInfo.itemID
					local itemMod = sourceInfo.itemModID
					data.itemData[slotID] = {"'"..itemID..":"..itemMod.."'", sourceID, appearanceID}

					if not data.icon then
						--local categoryID, visualID, canEnchant, icon, isCollected, itemLink, transmogLink, unknown1 = C_TransmogCollection.GetAppearanceSourceInfo(itemID)
						local _, _, _, _, icon, _, _ = GetItemInfoInstant(itemID) 
						data.icon = icon
					end
				end
			end
		end

		--MogIt.MogitSets[data.index] = data
		tinsert(mogSets, data)
	end

	return mogSets
end


--Catches the TransmogOutfit frame and clears its OnEven script.  This keeps the addons's buttons from being shown.
addon:SecureHook("transmogOutfitFrameCreate", function (frame) 
	frame:SetParent(addon.prisonFrame)
	frame:ClearAllPoints()
	frame:SetPoint("TOPRIGHT",100, 100)
	frame:SetSize(1, 1)
	frame:SetScript("OnEvent", function () end )
end)

transmogOutfitFoundOutfits = {}
local blizzardOutfits = C_TransmogCollection.GetOutfits()
for i = 1, table.getn(blizzardOutfits) do
	transmogOutfitFoundOutfits[i] = i
end
transmogOutfitFoundBlizzardOutfits = table.getn(transmogOutfitFoundOutfits)
for i = 1, table.getn(transmogOutfitOutfits) do
	transmogOutfitFoundOutfits[i + table.getn(blizzardOutfits)] = i + table.getn(blizzardOutfits)
end

addon:SecureHook("TransmogOutfitRemoveYes", function(self) addon:SendMessage("BW_TRANSMOG_COLLECTION_UPDATED") end)
addon:SecureHook("TransmogOutfitRenameDone", function(self) addon:SendMessage("BW_TRANSMOG_COLLECTION_UPDATED") end)

--Tweaks original function to allow changes via the BW saved set list
function TransmogOutfitSearchOutfit()
	local blizzardOutfits = C_TransmogCollection.GetOutfits()
	transmogOutfitFoundOutfits = {}
	if (transmogOutfitSelectSearchBox and transmogOutfitSelectSearchBox:GetText() == "") or not transmogOutfitSelectSearchBox then
		for i = 1, table.getn(blizzardOutfits) do
			transmogOutfitFoundOutfits[i] = i
		end
		transmogOutfitFoundBlizzardOutfits = table.getn(transmogOutfitFoundOutfits)
		for i = 1, table.getn(transmogOutfitOutfits) do
			transmogOutfitFoundOutfits[i + table.getn(blizzardOutfits)] = i + table.getn(blizzardOutfits)
		end
	else
		j = 0
		for i = 1, table.getn(blizzardOutfits) do
			if string.find(blizzardOutfits[i].name, transmogOutfitSelectSearchBox:GetText()) then
				transmogOutfitFoundOutfits[j] = i
				j = j + 1
			end
		end
		transmogOutfitFoundBlizzardOutfits = table.getn(transmogOutfitFoundOutfits)
		for i = 1, table.getn(transmogOutfitOutfits) do
			if string.find(transmogOutfitOutfits[i]["name"], transmogOutfitSelectSearchBox:GetText()) then
				transmogOutfitFoundOutfits[j] = i
				j = j + 1
			end
		end
	end
	if transmogOutfitSelectFrame and transmogOutfitSelectFrame:IsVisible() then
		transmogOutfitSelectFrame:Hide()
		transmogOutfitSelectFrame:Show()
	end
end

function TransmogOutfits:RenameSet(setID)
	if not setID then return end

	local blizzardOutfits = C_TransmogCollection.GetOutfits()
	setID = setID - 7000
	local setData = transmogOutfitOutfits[setID]

	local index = setID + #blizzardOutfits
	transmogOutfitCurrentOutfit = index

	transmogOutfitRenameNameBox:SetText(setData.name)
	transmogOutfitRenameFrame:Show()
end

function TransmogOutfits:DeleteSet(setID)
	if not setID then return end
		
	local blizzardOutfits = C_TransmogCollection.GetOutfits()
	setID = setID - 7000
	local index = setID + #blizzardOutfits
	transmogOutfitCurrentOutfit = index
	TransmogOutfitRemoveOutfit()
end

local MAX_DEFAULT_OUTFITS = C_TransmogCollection.GetNumMaxOutfits()
local function IsDefaultSet(outfitID)
	
	return outfitID - 5000 < MAX_DEFAULT_OUTFITS  -- #C_TransmogCollection.GetOutfits()--MAX_DEFAULT_OUTFITS 
end

function TransmogOutfits:CopySet(setID)
	if not setID then return end
		
	local icon
	local outfit

	local itemTransmogInfoList = {}
	local setdata = addon.GetSetInfo(setID)
	local name = setdata.name.." (Copy)"
	local icon = setdata.icon
	local itemlist = setdata.sources

	--for key, transmogSlot in pairs(TRANSMOG_SLOTS) do
	for slotID = 1, 19 do
		--local slotID = transmogSlot.location:GetSlotID();
		local itemTransmogInfo = ItemUtil.CreateItemTransmogInfo(itemlist[slotID] or 0, 0, 0);
		itemTransmogInfoList[slotID] = itemTransmogInfo
	end

	if (setID and IsDefaultSet(setID)) or (#C_TransmogCollection.GetOutfits() < MAX_DEFAULT_OUTFITS)  then 
		setID = C_TransmogCollection.NewOutfit(name, icon, itemTransmogInfoList);
	else
		tinsert(addon.OutfitDB.char.outfits, setdata)
		outfit = addon.OutfitDB.char.outfits[#addon.OutfitDB.char.outfits]
		outfit["name"] = name
		outfit.setID = nil
	end

	addon:SendMessage("BW_TRANSMOG_COLLECTION_UPDATED")
end



--[[function MogIt:TransmogOutfits(outfitID)
	local icon
	local outfit

	itemTransmogInfoList = {}
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
		tinsert(addon.OutfitDB.char.outfits, {})
		outfit = addon.OutfitDB.char.outfits[#addon.OutfitDB.char.outfits]
		outfit["name"] = name
		outfit["icon"] = setdata.icon
		outfit.itemTransmogInfoList =  itemTransmogInfoList or {}
	end

	addon:SendMessage("BW_TRANSMOG_COLLECTION_UPDATED")
end]]