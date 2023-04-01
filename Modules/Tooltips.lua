local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local LAT = LibStub("LibArmorToken-1.0")
local LAI = LibStub("LibAppropriateItems-1.0")

local collectedAppearances = {}
local weaponSlots = {"INVTYPE_2HWEAPON", "INVTYPE_WEAPON", "INVTYPE_WEAPONMAINHAND", "INVTYPE_RANGED", "INVTYPE_RANGEDRIGHT", "INVTYPE_THROWN",}
local offhandSlots = {"INVTYPE_WEAPONOFFHAND", "INVTYPE_SHIELD", "INVTYPE_HOLDABLE",}

local function IsAppearanceCollected(item)
	local itemID = GetItemInfoInstant(item)

	if not itemID then return end

	local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(item)
	local appearanceID2, sourceID2 = C_TransmogCollection.GetItemInfo(itemID)
	appearanceID = appearanceID or appearanceID2
	sourceID = sourceID or sourceID2

	if not appearanceID then return end

	if sourceID and addon:IsCollected(appearanceID) then
		return true, not C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID)
	end

	local sources = C_TransmogCollection.GetAllAppearanceSources(appearanceID)
	if sources then
		for _, sourceID in pairs(sources) do
			if C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID) then
				if itemID == C_TransmogCollection.GetSourceItemID(sourceID) then
					return true, false
				else
					return true, true
				end
			end
		end
	end

	return false, false
end

local function CreateModelFrame()
	local model = CreateFrame("DressUpModel", nil, preview)
	model:SetKeepModelOnHide(true)
	model:ClearAllPoints()
	model:SetPoint("TOPLEFT", preview, "TOPLEFT", 7, -7)
	model:SetPoint("BOTTOMRIGHT", preview, "BOTTOMRIGHT", -7, 7)

    model:SetScript("OnModelLoaded", function(self, ...)
        if self.cameraID then
            Model_ApplyUICamera(self, self.cameraID)
        end
    end)

	function model:Reset()
		self:RefreshCamera()
		self:SetUseTransmogSkin(addon.Profile.TooltipPreview_DressingDummy)
		self:SetModelUnit()
		self:SetDress()
	end

	function model:SetModelUnit()
		self:SetUnit("player", false, true)
		local _, raceFilename = UnitRace("player");
		local gender = UnitSex("player") 
		local force =  addon.Profile.TooltipPreview_SwapModifier ~= L["None"] and addon.Globals.mods[addon.Profile.TooltipPreview_SwapModifier]()

		local inAltForm = select(2, C_PlayerInfo.GetAlternateFormInfo())
		if (raceFilename == "Dracthyr" or raceFilename == "Worgen") then
			local modelID, altModelID
			if raceFilename == "Worgen" then
				if gender == 3 then
					modelID = 307453
					altModelID = 1000764
				else
					modelID = 307454
					altModelID = 1011653
				end

			elseif raceFilename == "Dracthyr" then
				modelID = 4207724

				if gender == 3 then
					altModelID = 4220448
				else
					altModelID = 4395382
				end
			end

			if addon.Profile.TooltipPreview_SwapDefault or ( force and  not inAltForm) or (not force and inAltForm)  then
				self:SetUnit("player", false, false)
				self:SetModel(altModelID)	
			else
				self:SetUnit("player", false, true)
				self:SetModel(modelID)
			end
		end

	end

	function model:SetDress()
		if addon.Profile.TooltipPreview_Dress then
			self:Dress()

		else
			self:Undress()
		end
	end

	return model
end

function addon:InitTooltips()
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(self)
		if self == GameTooltip or self == GameTooltip.ItemTooltip.Tooltip then
			preview:ShowPreview(select(2, TooltipUtil.GetDisplayedItem(self)), self)
		end
	end)

	GameTooltip:HookScript("OnHide", function() 
		if (AuctionHouseFrame and not AuctionHouseFrame:IsShown()) or not AuctionHouseFrame then 
			preview:Hide()
			preview:OnHide2() 
		end 
	end)

	preview:SetSize(addon.Profile.TooltipPreview_Width, addon.Profile.TooltipPreview_Height)
	preview.model = CreateModelFrame()
	preview.zoom = CreateModelFrame()
end

preview = CreateFrame("Frame", "BW_ProfileTooltip", UIParent, "TooltipBorderedFrameTemplate")
addon.preview = preview
preview:SetFrameStrata("TOOLTIP")
preview:Hide()
preview:RegisterEvent("PLAYER_REGEN_DISABLED")

preview:SetScript("OnEvent", function(self, event, ...)
	if event == PLAYER_REGEN_DISABLED then  
		ClearOverrideBindings(self) 
	end
end)

preview:SetScript("OnUpdate", function(self, elapsed)
	if (addon.Profile.TooltipPreviewRotate and preview.previewModel and preview.previewModel:IsVisible()) then
		preview.previewModel:SetFacing(preview.previewModel:GetFacing() + elapsed)
	end

	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed >= TOOLTIP_UPDATE_TIME then
		self.elapsed = 0
	end

	preview:SetAnchor(preview, preview.parent)
end)

preview:SetScript("OnShow", function(self)
	self.elapsed = TOOLTIP_UPDATE_TIME
	if addon.Profile.TooltipPreview_MouseRotate and not InCombatLockdown() then
		SetOverrideBinding(self, true, "MOUSEWHEELUP", "BETTERWARDROBE_PREVIEW_SCROLL_UP")
		SetOverrideBinding(self, true, "MOUSEWHEELDOWN", "BETTERWARDROBE_PREVIEW_SCROLL_DOWN")
	end
end)

preview:SetScript("OnHide",function(self)
	if not InCombatLockdown() then
		ClearOverrideBindings(self)
	end
end)

function preview:SetShown()
	self:SetParent(self.parent)
	self:Show()
	self.model:SetShown(self.previewModel == self.model)
	self.zoom:SetShown(self.previewModel == self.zoom)
end

function preview:OnHide2()
	if not self.parent or not self.parent:IsShown() or not TooltipUtil.GetDisplayedItem(self.parent) then
		self:Hide()
		self.item = nil
		self.previewModel = nil
	end
end

function preview:SetAnchor(tooltip, parent)
	local primaryTooltip = self.parent.shoppingTooltips[1] 
	primaryTooltip =  primaryTooltip:IsShown() and primaryTooltip or parent

	local leftPos = self.parent:GetLeft()  or 0;
	local rightPos = self.parent:GetRight()  or 0;

	local rightDist = 0;
	local screenWidth = GetScreenWidth();
	rightDist = screenWidth - rightPos;


	local anchor = addon.db.profile.TooltipPreview_Anchor
	local relativeAnchor
	local x,y = parent:GetCenter();
	local yShift = y / GetScreenHeight() > 0.5
	local xShift

	if rightDist < leftPos then
		xShift = true
	else
		xShift = false;
	end

local anchorFrame =	TooltipComparisonManager.anchorFrame

	if anchor == "vertical" then 
		--if ((parent:GetBottom() + self:GetHeight()) > GetScreenHeight() - 100) then 
		anchor = (yShift and "TOP") or "BOTTOM"
		relativeAnchor = (yShift and "BOTTOM") or "TOP"
		anchor = (xShift and anchor.."LEFT") or anchor.."RIGHT"
		relativeAnchor = (xShift and relativeAnchor.."LEFT") or relativeAnchor.."RIGHT"
	else

		anchor = (xShift and "RIGHT") or "LEFT"
		relativeAnchor = (xShift and "LEFT") or "RIGHT"
		if TooltipComparisonManager.anchorFrame and TooltipComparisonManager.anchorFrame.IsEmbedded then
			local primaryAnchor,_,primaryRelativeAnchor = primaryTooltip:GetPoint(2)
			anchor = ((xShift or primaryAnchor and primaryAnchor == "LEFT") and "LEFT" ) or "RIGHT"
			relativeAnchor = ((xShift or primaryRelativeAnchor and primaryRelativeAnchor == "RIGHT") and "RIGHT" ) or "LEFT"
		end

		anchor = "TOP"..anchor
		relativeAnchor = "TOP"..relativeAnchor
	end

	self:ClearAllPoints()
	self:SetPoint(anchor, primaryTooltip, relativeAnchor)
end

----
local function addDoubleLine(tooltip, left_text, right_text)
	tooltip:AddDoubleLine(left_text, right_text, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
end

local function addLine(tooltip, text)
	tooltip:AddLine(text, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, true)
end

local function addDivider()
	GameTooltip:AddTexture("Interface\\DialogFrame\\UI-DialogBox-Divider.blp",{width = GameTooltip:GetWidth() + 25, height = 15})
end

function preview:GetSlotFacing(slot)
	if tContains ( weaponSlots, slot) then 
		return 1.5

	elseif tContains ( offhandSlots, slot) then
		return -.05

	elseif slot == "INVTYPE_CLOAK" then
		return 0

	else
		return 0
	end
end

local removalList = {
	INVTYPE_HEAD = {INVSLOT_SHOULDER},
	INVTYPE_CHEST = {INVSLOT_SHOULDER, INVSLOT_BODY, INVSLOT_TABARD, INVSLOT_WAIST, INVSLOT_OFFHAND,},
	INVTYPE_BODY = {INVSLOT_SHOULDER, INVSLOT_CHEST, INVSLOT_TABARD, INVSLOT_WAIST, INVSLOT_OFFHAND,},
	INVTYPE_TABARD = {INVSLOT_WAIST, INVSLOT_OFFHAND,},
	INVTYPE_WRIST = {INVSLOT_BODY, INVSLOT_CHEST, INVSLOT_HAND, INVSLOT_OFFHAND,},
	INVTYPE_HAND = {INVSLOT_OFFHAND,},
	INVTYPE_LEGS = {INVSLOT_TABARD, INVSLOT_CHEST, INVSLOT_WAIST, INVSLOT_FEET, INVSLOT_MAINHAND, INVSLOT_OFFHAND,},
	INVTYPE_WAIST = {INVSLOT_MAINHAND, INVSLOT_OFFHAND,},
	INVTYPE_FEET = {INVSLOT_CHEST,},
	INVTYPE_WEAPON = {INVSLOT_MAINHAND,},
	INVTYPE_2HWEAPON = {INVSLOT_MAINHAND,},
}

function preview:RemoveSurrounding(slot)
	if removalList[slot] or slot == "INVTYPE_WEAPON"  or slot == "INVTYPE_OFFHAND" then 
		for _, slotid in ipairs(removalList[slot]) do
			if slotid > 0 then
				self.previewModel:UndressSlot(slotid)
			end
		end
	end
end

local exchangeFor = {}
local function LookUpToken(id)
	local _, class = UnitClass("player")
	local itemLink
	for _, itemID in LAT:IterateItemsForTokenAndClass(id, class) do
		local item = Item:CreateFromItemID(itemID)
		item:ContinueOnItemLoad(function()
			local link = item:GetItemLink()

			if link then
				tinsert(exchangeFor, link)
				return 
			end
		end)
	end

	for _, clases in LAT:IterateClassesForToken(id) do
		for _, itemID in LAT:IterateItemsForTokenAndClass(id, clases) do
			local item = Item:CreateFromItemID(itemID)
			item:ContinueOnItemLoad(function()
				local link = item:GetItemLink()
				if link then
					tinsert(exchangeFor, link)
				end
			end)
		end
	end	
end

function preview:ShowPreview(itemLink, parent)
	if not itemLink then self:Hide() return end
	exchangeFor = {}
	parent = parent or GameTooltip
	self.parent = parent
	local id = tonumber(itemLink:match("item:(%d+)"))
	local dressable = id and C_Item.IsDressableItemByID(id)
	local token = addon.Profile.ShowTokenTooltips and LAT:ItemIsToken(id)
	--print((not id or id == 0) or not token and not dressable)
	if not dressable then 
		self:Hide()
		return
	end

	if token then
		LookUpToken(id)
		if exchangeFor and #exchangeFor > 0 then 
			local items = exchangeFor[1].."and "..#exchangeFor.. "other items"
			parent:AddDoubleLine(ITEM_PURCHASED_COLON, items)
		end
	end

	local learned_dupe = false
	local found_tooltipinfo = false
	local found_systemTooltip = false
	for i = 1, GameTooltip:NumLines() do
		local line = _G["GameTooltipTextLeft"..i]

		local text = line:GetText() or " "
		local text_lower = string.lower(line:GetText() or " " )

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
	
	if addon.Profile.ShowItemIDTooltips  then
			addDoubleLine(GameTooltip,L["Item Visual ID"]..": |cffffffff"..id, "")
	end
	if addon.Profile.ShowOwnedItemTooltips and not found_systemTooltip then
		local apperanceKnownText, canTransmog
		local itemID = GetItemInfoInstant(itemLink)
		if itemID then
			canTransmog = select(3, C_Transmog.CanTransmogItem(itemID))
		end
		local collected, altCollected = IsAppearanceCollected(itemLink)

		if not canTransmog then
			apperanceKnownText = "|c00ffff00" .. TRANSMOGRIFY_INVALID_DESTINATION
		else
			local check = "Ready"
			local warning = ""
			local color = ""

			if collected then
				if altCollected then
					warning = TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN
				else
					warning = TRANSMOGRIFY_TOOLTIP_APPEARANCE_KNOWN
				end
			else
				warning = TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN
				check = "NotReady"
				color = "|cffff0000"
			end

			apperanceKnownText = ("|TInterface\\RaidFrame\\ReadyCheck-%s:0|t %s%s"):format(check, color, warning)
		end

		addDoubleLine(GameTooltip, apperanceKnownText,"")
	end

	local isAppropriate = LAI:IsAppropriate(id)
	if addon.Profile.ShowOwnedItemTooltips and not isAppropriate then
		addDoubleLine(GameTooltip, L["|TInterface\\RaidFrame\\ReadyCheck-NotReady:0|t %s%s"]:format("|cffff0000", L["Your class can't transmogrify this item"]))	
	end

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
				GameTooltip:AddTexture("Interface\\DialogFrame\\UI-DialogBox-Divider.blp", {width = GameTooltip:GetWidth() + 25, height = 15})
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
				
				GameTooltip:AddTexture("Interface\\DialogFrame\\UI-DialogBox-Divider.blp", {width = GameTooltip:GetWidth() + 25, height = 15})
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
				GameTooltip:AddTexture("Interface\\DialogFrame\\UI-DialogBox-Divider.blp", {width = GameTooltip:GetWidth() + 25, height = 15})
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
			GameTooltip:AddTexture("Interface\\DialogFrame\\UI-DialogBox-Divider.blp", {width = GameTooltip:GetWidth() + 25, height = 15})
		end

		--GameTooltip:Show()
	end

	local slot = select(9, GetItemInfo(id))
	if addon.Profile.TooltipPreview_Show and (not addon.Globals.mods[addon.Profile.TooltipPreview_Modifier] or addon.Globals.mods[addon.Profile.TooltipPreview_Modifier]()) and self.item ~= id then
		self.item = id
		--local itemFacing = self:GetSlotFacing(slot)
		if C_Item.IsDressableItemByID(id)  then
			local cameraID, isWeapon, zoomPreview
			if addon.Profile.TooltipPreview_ZoomItem or addon.Profile.TooltipPreview_ZoomWeapon then
				cameraID, isWeapon = addon.Camera:GetCameraID(id)
			end
			zoomPreview =  cameraID and (addon.Profile.TooltipPreview_ZoomItem and not isWeapon) or (addon.Profile.TooltipPreview_ZoomWeapon and isWeapon)

			if zoomPreview then
				self.previewModel = self.zoom
				self.previewModel:Reset()
				if isWeapon then
					local appearanceID = C_TransmogCollection.GetItemInfo(itemLink)
					if appearanceID then
						self.previewModel:SetItemAppearance(appearanceID)
					else
						self.previewModel:SetItem(id)
					end
				end
				Model_ApplyUICamera(self.previewModel, cameraID)
			else
				self.previewModel = self.model
				self.previewModel:Reset()
			end
			
			if cameraID then
				local itemFacing = self.previewModel:GetFacing()
				self.previewModel:SetFacing(itemFacing - ((addon.Profile.TooltipPreviewRotate and 1) or 0))
			end

			self:SetShown()
			self:RemoveSurrounding(slot)

			C_Timer.After(0, function()
				if self.previewModel then 
					self.previewModel:TryOn(itemLink)
				end
			end)
		else
			self:Hide()
		end
	end 
end