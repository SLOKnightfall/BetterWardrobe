--Positioning & Zoom Logic based on code from AppearanceTooltips by Kemayo https://www.curseforge.com/wow/addons/appearancetooltip


local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local LAT = LibStub("LibArmorToken-1.0")
local LAI = LibStub("LibAppropriateItems-1.0")

local GetScreenWidth = GetScreenWidth
local GetScreenHeight = GetScreenHeight

local class = addon.Globals.CLASS_INFO[select(2, UnitClass("PLAYER"))][2]

local tooltip = {}
local Models = {}
	
tooltip = CreateFrame("Frame", "BW_ProfileTooltip", UIParent, "TooltipBorderedFrameTemplate")
addon.tooltip = tooltip
tooltip:Hide()
tooltip:SetClampedToScreen(true)
tooltip:SetFrameStrata("TOOLTIP")

GameTooltip:SetClampedToScreen( true )


function addon.Init:BuildTooltips()
	Models.normal:SetUnit("player")
	Models.modelZoomed:SetUnit("player")
	tooltip.rotate:SetShown(addon.Profile.TooltipPreviewRotate)
	tooltip:SetSize(addon.Profile.TooltipPreview_Width, addon.Profile.TooltipPreview_Height)
	----C_TransmogCollection.SetShowMissingSourceInItemTooltips(addon.Profile.ShowAdditionalSourceTooltips)

	tooltip:SetScript("OnShow", function(self)
		if addon.Profile.TooltipPreview_MouseRotate and not InCombatLockdown() then
			SetOverrideBinding(tooltip, true, "MOUSEWHEELUP", "BetterWardrobe_TooltipScrollUp")
			SetOverrideBinding(tooltip, true, "MOUSEWHEELDOWN", "BetterWardrobe_TooltipScrollDown")
		end
	end)

	tooltip:SetScript("OnHide",function(self)
		if not InCombatLockdown() then
			ClearOverrideBindings(tooltip)
		end
	end)

	tooltip:SetScript("OnEvent", function(self, event, arg1)
		if event == "PLAYER_REGEN_DISABLED" then
			ClearOverrideBindings(tooltip)
		elseif event == "PLAYER_REGEN_ENABLED" then
			if self:IsForbidden() then return end
			if self:IsShown() and addon.Profile.TooltipPreview_MouseRotate then
				SetOverrideBinding(tooltip, true, "MOUSEWHEELUP", "BetterWardrobe_TooltipScrollUp")
				SetOverrideBinding(tooltip, true, "MOUSEWHEELDOWN", "BetterWardrobe_TooltipScrollDown")
			end
		end
	end)

	tooltip:RegisterEvent("PLAYER_REGEN_DISABLED")
	tooltip:RegisterEvent("PLAYER_REGEN_ENABLED")

	tooltip.check:SetScript("OnUpdate", function(self)
		if (tooltip.owner and tooltip.owner:IsForbidden()) then return end
		if (tooltip.owner and not (tooltip.owner:IsShown() and tooltip.owner:GetItem())) or not tooltip.owner then
			tooltip:Hide()
			tooltip.item = nil
		end
		self:Hide()
	end)

--Change in DF
	--TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(self)
		--local _, itemLink = self:GetItem()
		--tooltip:ShowTooltip(itemLink)
	--end)
	--GameTooltip:HookScript("OnHide", tooltip.HideItem)

	GameTooltip:HookScript("OnTooltipSetItem", function(self)
		local _, itemLink = self:GetItem()
		tooltip:ShowTooltip(itemLink)
	end)
	GameTooltip:HookScript("OnHide", tooltip.HideItem)

	-- hacks for tooltip where GameTooltip:GetItem() returns a broken link
	hooksecurefunc(GameTooltip, "SetQuestItem", function(self, itemType, index)
		tooltip:ShowTooltip(GetQuestItemLink(itemType, index))
		GameTooltip:Show()
	end)


	hooksecurefunc(GameTooltip, "SetQuestLogItem", function(self, itemType, index)
		tooltip:ShowTooltip(GetQuestLogItemLink(itemType, index))
		GameTooltip:Show()
	end)


	-- hooksecurefunc(GameTooltip, "SetRecipeResultItem", function(self, recipeID)
		-- tooltip:ShowTooltip(C_TradeSkillUI.GetRecipeItemLink(recipeID))
		-- GameTooltip:Show()
	-- end)


	--hooksecurefunc(GameTooltip, "SetRecipeReagentItem", function(self, recipeID, reagentIndex)
		--tooltip:ShowTooltip(C_TradeSkillUI.GetRecipeReagentItemLink(recipeID, reagentIndex))
		--GameTooltip:Show()
	--end)



--tooltip.model = CreateFrame("DressUpModel", nil, tooltip)
--Mixin(tooltip.model, WardrobeSetsDetailsModelMixin)
--tooltip.model:SetPoint("TOPLEFT", tooltip, "TOPLEFT", 5, -5)
--tooltip.model:SetPoint("BOTTOMRIGHT", tooltip, "BOTTOMRIGHT", -5, 5)
--tooltip.model:SetAnimation(0, 0)

--tooltip.model:SetLight(true, false, 0, 0.8, -1, 1, 1, 1, 1, 0.3, 1, 1, 1)

end


function Models:Build()
	local model = CreateFrame("DressUpModel", nil, tooltip)
	model:SetFrameLevel(1)
	model:SetPoint("TOPLEFT", tooltip, "TOPLEFT", 5, -5)
	model:SetPoint("BOTTOMRIGHT", tooltip, "BOTTOMRIGHT", -5, 5)
	model:SetKeepModelOnHide(true)
	model:SetScript("OnModelLoaded", function(self, ...)
	model:SetUseTransmogSkin(false)
		-- Makes sure the zoomed camera is correct, if the model isn't loaded right away
		if self.cameraID then
			Model_ApplyUICamera(self, self.cameraID)
		end
	end)
	-- Use the blacked-out model:

	-- Display in combat pose:
	-- model:FreezeAnimation(1)
	return model
end

Models.normal = Models:Build()
Models.normal:SetScript("OnShow", function(self) Models:Reset(self) end)
tooltip.model = Models.normal
Models.modelZoomed = Models:Build()
Models.modelWeapon = Models:Build()


function Models:Reset(model)
	local raceID = addon.Profile.TooltipPreview_CustomRace
	local genderID = addon.Profile.TooltipPreview_CustomGender
	if addon.Profile.TooltipPreview_CustomModel then
		local _, _, dirX, dirY, dirZ, _, ambR, ambG, ambB, _, dirR, dirG, dirB = model:GetLight()
		model:SetCustomRace(raceID, genderID)
		model:SetUseTransmogSkin(true)
	else
		model:Dress()
		model:SetUseTransmogSkin(false)
		model:SetUseTransmogSkin(addon.Profile.TooltipPreview_DressingDummy)
	end

	 model:RefreshCamera()

	if not addon.Profile.TooltipPreview_Dress then
		for i, slotName in ipairs(addon.Globals.slots) do
			local slot = GetInventorySlotInfo(slotName)
			local item = GetInventoryItemLink("player", slot)
			if item then
				model:TryOn(item)
				model:UndressSlot(slot)
			end
		end
		model:UndressSlot(GetInventorySlotInfo("MainHandSlot"))
		model:UndressSlot(GetInventorySlotInfo("SecondaryHandSlot"))
	end
end


local function addDoubleLine(tooltip, left_text, right_text)
	tooltip:AddDoubleLine(left_text, right_text, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
end


local function addLine(tooltip, text)
	tooltip:AddLine(text, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, true)
end


local function HasItem(sourceID, includeAlternate)
	if not sourceID then return end
	local found = false
	local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
	if not sourceInfo then return end
	found = sourceInfo.isCollected
	if includeAlternate then
		local _, _, _, _, _, itemClassID, itemSubclassID = GetItemInfoInstant(sourceInfo.itemID)
		local sources = C_TransmogCollection.GetAllAppearanceSources(sourceInfo.visualID)
		for i, sourceID in ipairs(sources) do
			local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
			local _, _, _, _, _, itemClassID2, itemSubclassID2 = GetItemInfoInstant(sourceInfo.itemID)
			if itemSubclassID2 == itemSubclassID and sourceInfo.isCollected then
				found = true
				break
			end
		end
	end
	return found
end


local itemSourceID = {}
local function GetSourceFromItem(item)
	if not itemSourceID[item] then
		local visualID, sourceID = C_TransmogCollection.GetItemInfo(item)
		itemSourceID[item] = sourceID
		if not itemSourceID[item] then
			tooltip.model:SetUnit("player")
			tooltip.model:Undress()
			tooltip.model:TryOn(item)
			for i = 1, 19 do
				local itemTransmogInfo = tooltip.model:GetItemTransmogInfo(i)
				local appearanceID = itemTransmogInfo and itemTransmogInfo.appearanceID or Constants.Transmog.NoTransmogID;

				----local source = tooltip.model:GetSlotTransmogSources(i)
				----if source ~= 0 then
				if appearanceID ~= 0 then

					itemSourceID[item] = appearanceID
					break
				end
			end
		end
	end
	return itemSourceID[item]
end
addon.GetSourceFromItem = GetSourceFromItem

local split = true

function tooltip:ShowTooltip(itemLink)
	tooltip.owner = GameTooltip
	if not itemLink or self.ShowTooltips then return end

	local itemID, _, _, slot = GetItemInfoInstant(itemLink)
	local dressable = itemID and C_Item.IsDressableItemByID(itemID)
	local token = LAT:ItemIsToken(itemID)

	--No need to update tooltips if item is not token or a mog
	if not itemID or (not token and not dressable) then return end
	local self = GameTooltip

	local learned_dupe = false
	local found_tooltipinfo = false
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
		end
		--Adds icon to TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN if found
		if addon.Profile.ShowOwnedItemTooltips and string.find(text_lower, string.lower(TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN) ) then
			line:SetText("|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t "..text)

		end

		if addon.Profile.ShowItemIDTooltips and string.find(text_lower, string.lower(ITEM_LEVEL) ) then
			line:SetText(text.."         "..L["Item ID"]..": |cffffffff"..itemID)
		end
	end
	
	local self = GameTooltip
	token = addon.Profile.ShowTokenTooltips and token
	local item_link, _
	if token then
		local isToken
		for _, itemid in LAT:IterateItemsForTokenAndClass(itemID, class) do
			_, item_link = GetItemInfo(itemid)
			if item_link then
				itemID = itemid
				itemLink = item_link
				isToken = true
				break
			end
		end

		if not isToken then
			for _, tokenclass in LAT:IterateClassesForToken(itemID) do
				for _, itemid in LAT:IterateItemsForTokenAndClass(itemID, tokenclass) do
					_, item_link = GetItemInfo(itemid)
					if item_link then
						itemID = itemid
						itemLink = item_link
						isToken = true
						break
					end
				end
				break
			end
		end

		if isToken then
			addDoubleLine (self,ITEM_PURCHASED_COLON, itemLink)
		end
	end
	
	local tooltip = tooltip
	if addon.Profile.TooltipPreview_Show and (not addon.Globals.mods[addon.Profile.TooltipPreview_Modifier] or addon.Globals.mods[addon.Profile.TooltipPreview_Modifier]()) then
		tooltip:ShowPreview(itemLink)
	end

	if addon.Profile.ShowOwnedItemTooltips and addon.Globals.tooltip_slots[slot] and not learned_dupe then
		local sourceID = GetSourceFromItem(itemLink)
		local hasItem = sourceID and HasItem(sourceID, true)
		if hasItem then
			addLine(self, " ")
			addLine(self, "|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t "..TRANSMOGRIFY_TOOLTIP_APPEARANCE_KNOWN)
		end
	end

	local appropriateItem = LAI:IsAppropriate(itemID)
	if not appropriateItem and addon.Profile.ShowWarningTooltips then 
		addLine(self, RED_FONT_COLOR_CODE..L["Class can't use item for transmog"])
	end

	if addon.Profile.ShowTooltips and not found_tooltipinfo then
		local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemLink)
		if not sourceID then return end
		local addHeader = false
		local inList, count = addon.CollectionList:IsInList(appearanceID, "item", true)

		if addon.Profile.ShowCollectionListTooltips and inList then
			if not addHeader then
				addHeader = true
				--addLine(self, L["HEADERTEXT"])
				addLine(self, " ")
				GameTooltip:AddTexture("Interface\\DialogFrame\\UI-DialogBox-Divider.blp",{width = self:GetWidth()+25, height = 15})

			end

			addDoubleLine (self,"|cff87aaff"..L["-Appearance in %d Collection List-"]:format(count), " ")
		end
		

		local setIDs = C_TransmogSets.GetSetsContainingSourceID(sourceID)
		local shownSetNames = {}
		if addon.Profile.ShowSetTooltips and #setIDs > 0 then
			if not addHeader then
				addHeader = true
				--addLine(self, L["HEADERTEXT"])
				addLine(self, " ")
				
				GameTooltip:AddTexture("Interface\\DialogFrame\\UI-DialogBox-Divider.blp",{width = self:GetWidth()+25, height = 15})

				--GameTooltip:AddTexture("Interface\\QUESTFRAME\\UI-HorizontalBreak.blp",{width = self:GetWidth()-10, height = 15})
			end

			for i, setID in pairs(setIDs) do
				local setInfo = C_TransmogSets.GetSetInfo(setID)
				addDoubleLine (self,"|cffffd100"..L["Part of Set:"], " ")
				local collected, total = addon.SetsDataProvider:GetSetSourceCounts(setID)
				local color = YELLOW_FONT_COLOR_CODE
				if collected == total then
					color = GREEN_FONT_COLOR_CODE
				end
				addDoubleLine (self," ",L["-%s %s(%d/%d)"]:format(setInfo.name or "", color, collected, total))
				shownSetNames[setInfo.name] = true

				if addon.Profile.ShowDetailedListTooltips then
					local sources = addon.GetSetSources(setID)
					for sourceID, collected in pairs(sources) do
						local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
						if collected and not addon.Profile.ShowMissingDetailedListTooltips then
							color = GREEN_FONT_COLOR_CODE
							addDoubleLine (self," ",L["|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t %s%s"]:format(color, sourceInfo.name or ""))
						elseif not collected then
							color = RED_FONT_COLOR_CODE
							addDoubleLine (self," ",L["|TInterface\\RaidFrame\\ReadyCheck-NotReady:0|t %s%s"]:format(color, sourceInfo.name or ""))
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
								addLine(self, " ")
				GameTooltip:AddTexture("Interface\\DialogFrame\\UI-DialogBox-Divider.blp",{width = self:GetWidth()+25, height = 15})
			end
			addDoubleLine (self,"|cffffd100"..L["Part of Extra Set:"], " ")
			for _, data in pairs(setData) do
				--if not shownSetNames[data.name] then 
					local collected, total = addon.SetsDataProvider:GetSetSourceCounts(data.setID)
					local color = YELLOW_FONT_COLOR_CODE
					if collected == total then
						color = GREEN_FONT_COLOR_CODE
					end

					addDoubleLine (self," ",L["-%s %s(%d/%d)"]:format(data.name or "", color, collected, total))

					if addon.Profile.ShowDetailedListTooltips then
						local sources = addon.GetSetsources(data.setID)
						for sourceID, collected in pairs(sources) do
							local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
							if collected and not addon.Profile.ShowMissingDetailedListTooltips then
								color = GREEN_FONT_COLOR_CODE
								addDoubleLine (self," ",L["|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t %s%s"]:format(color, sourceInfo.name or ""))
							elseif not collected then
								color = RED_FONT_COLOR_CODE
								addDoubleLine (self," ",L["|TInterface\\RaidFrame\\ReadyCheck-NotReady:0|t %s%s"]:format(color, sourceInfo.name or ""))
							end
						end
					end
				--end
			end
		end

		if addHeader then
			--addLine(self, L["HEADERTEXT"])
			addLine(self, " ")
			GameTooltip:AddTexture("Interface\\DialogFrame\\UI-DialogBox-Divider.blp",{width = self:GetWidth()+25, height = 15})
		end
		self:Show()
	end
	self.ShowTooltips = true
	
end

function tooltip:ShowPreview(itemLink)
   if not itemLink or not  C_Item.IsDressableItemByID(itemLink) then 
			self:Hide()
			return 
		end
	if self.previewShown then return end
	local itemID, _, _, slot = GetItemInfoInstant(itemLink)
	if self.item ~= itemLink then
		self.item = itemLink
		local slot = select(9, GetItemInfo(itemID))
		------if (not addon.Profile.TooltipPreview_MogOnly or select(3, C_Transmog.GetItemInfo(itemID))) and addon.Globals.tooltip_slots[slot] and C_Item.IsDressableItemByID(itemLink) then

		if addon.Globals.tooltip_slots[slot] and C_Item.IsDressableItemByID(itemLink) then
			local cameraID, itemCamera
			if addon.Profile.TooltipPreview_ZoomItem or addon.Profile.TooltipPreview_ZoomWeapon then
				cameraID, itemCamera = addon.Camera:GetCameraID(itemLink, addon.Profile.TooltipPreview_CustomModel and addon.Profile.TooltipPreview_CustomRace, addon.Profile.TooltipPreview_CustomModel and addon.Profile.TooltipPreview_CustomGender)
			end
			Models.normal:Hide()
			Models.modelZoomed:Hide()
			Models.modelWeapon:Hide()

			local shouldZoom = (addon.Profile.TooltipPreview_ZoomWeapon and cameraID and itemCamera) or (addon.Profile.TooltipPreview_ZoomItem and cameraID and not itemCamera)
			if shouldZoom then
				if itemCamera then
					self.model = Models.modelWeapon
					local appearanceID = C_TransmogCollection.GetItemInfo(itemLink)
					if appearanceID then
						self.model:SetItemAppearance(appearanceID)
					else
						self.model:SetItem(itemID)
					end
				else
					self.model = Models.modelZoomed
					--self.model:SetUseTransmogSkin(db.zoomMasked and slot ~= "INVTYPE_HEAD")
					Models:Reset(self.model)
				end
				self.model.cameraID = cameraID
				Model_ApplyUICamera(self.model, cameraID)
				self.model:SetAnimation(0, 0)
			else
				self.model = Models.normal
				Models:Reset(self.model)
			end

			self.model:Show()
			self:Show()
			self.repos:Show()

			if not cameraID then
				self.model:SetFacing(addon.Camera.slot_facings[slot] - (addon.Profile.TooltipPreviewRotate and 0.5 or 0))
			end

			self.model:TryOn(itemLink)
			self.previewShown = true
		else
			self:Hide()
			Models.normal:Hide()
			Models.modelZoomed:Hide()
			Models.modelWeapon:Hide()
		end
	end
end


function tooltip.HideItem(self)
	self.ShowTooltips = nil
	tooltip.owner = nil
	tooltip.previewShown = nil
	tooltip.repos:Hide()
	tooltip.check:Show()
	tooltip:Hide()
end

tooltip.check = CreateFrame("Frame")
	tooltip.check:ClearAllPoints()
	tooltip.check:SetPoint("TOPRIGHT",100, 100)
	tooltip.check:SetSize(1,1)
tooltip.check:Hide()

tooltip.rotate = CreateFrame("Frame",nil,tooltip)
	tooltip.rotate:ClearAllPoints()
	tooltip.rotate:SetPoint("TOPRIGHT",100, 100)
	tooltip.rotate:SetSize(1,1)
tooltip.rotate:Hide()
tooltip.rotate:SetScript("OnUpdate",function(self,elapsed)
	tooltip.model:SetFacing(tooltip.model:GetFacing() + elapsed)
end)

tooltip.repos = CreateFrame("Frame")
	tooltip.repos:ClearAllPoints()
	tooltip.repos:SetPoint("TOPRIGHT",100, 100)
	tooltip.repos:SetSize(1,1)
tooltip.repos:Hide()
tooltip.repos:SetScript("OnShow", function(self)
	self.elapsed = TOOLTIP_UPDATE_TIME
end)

tooltip.repos:SetScript("OnUpdate", function(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	if self.elapsed < TOOLTIP_UPDATE_TIME then
		return
	end
	self.elapsed = 0

	local owner, our_point, owner_point = tooltip:ComputeTooltipAnchors(tooltip.owner, addon.Profile.TooltipPreview_Anchor)
	if our_point and owner_point then
		tooltip:ClearAllPoints()
		tooltip:SetPoint(our_point, owner, owner_point)
	end
end)

do
	local points = {
		-- key is the direction our tooltip should be biased, with the first component being the primary (i.e. "on the top side, to the left")
		-- these are [our point, owner point]
		top = {
			left = {"BOTTOMRIGHT", "TOPRIGHT"},
			right = {"BOTTOMLEFT", "TOPLEFT"},
		},
		bottom = {
			left = {"TOPRIGHT", "BOTTOMRIGHT"},
			right = {"TOPLEFT", "BOTTOMLEFT"},
		},
		left = {
			top = {"BOTTOMRIGHT", "BOTTOMLEFT"},
			bottom = {"TOPRIGHT", "TOPLEFT"},
		},
		right = {
			top = {"BOTTOMLEFT", "BOTTOMRIGHT"},
			bottom = {"TOPLEFT", "TOPRIGHT"},
		},
	}
	function tooltip:ComputeTooltipAnchors(owner, anchor)
		-- Because I always forget: x is left-right, y is bottom-top
		-- Logic here: our tooltip should trend towards the center of the screen, unless something is stopping it.
		-- If comparison tooltip are shown, we shouldn't overlap them
		local originalOwner = owner
		local x, y = owner:GetCenter()
		if not (x and y) then
			return
		end
		x = x * owner:GetEffectiveScale()

		local biasLeft, biasDown
		-- we want to follow the direction the tooltip is going, relative to the cursor
		biasLeft = x < GetCursorPosition()
		biasDown = y > GetScreenHeight() / 2

		local outermostComparisonShown
		if owner.shoppingTooltips then
			local comparisonTooltip1, comparisonTooltip2 = unpack( owner.shoppingTooltips )
			if comparisonTooltip1:IsShown() or comparisonTooltip2:IsShown() then
				if comparisonTooltip1:IsShown() and comparisonTooltip2:IsShown() then
					if comparisonTooltip1:GetCenter() > comparisonTooltip2:GetCenter() then
						-- 1 is right of 2
						outermostComparisonShown = biasLeft and comparisonTooltip2 or comparisonTooltip1
					else
						-- 1 is left of 2
						outermostComparisonShown = biasLeft and comparisonTooltip1 or comparisonTooltip2
					end
				else
					outermostComparisonShown = comparisonTooltip1:IsShown() and comparisonTooltip1 or comparisonTooltip2
				end
				if
					-- outermost is right of owner while we're biasing left
					(biasLeft and outermostComparisonShown:GetCenter() > owner:GetCenter())
					or
					-- outermost is left of owner while we're biasing right
					((not biasLeft) and outermostComparisonShown:GetCenter() < owner:GetCenter())
				then
					-- the comparison won't be in the way, so ignore it
					outermostComparisonShown = nil
				end
			end
		end

		local primary, secondary
		if anchor == "vertical" then
			-- attaching to the top/bottom of the tooltip
			-- only care about comparisons to avoid overlapping them
			primary = biasDown and "bottom" or "top"
			if outermostComparisonShown then
				secondary = biasLeft and "right" or "left"
			else
				secondary = biasLeft and "left" or "right"
			end
		else -- horizontal
			primary = biasLeft and "left" or "right"
			secondary = biasDown and "bottom" or "top"
			if outermostComparisonShown then
				if addon.Profile.TooltipPreview_Overlap then
					owner = outermostComparisonShown
				else
					-- show on the opposite side of the bias, probably overlapping the cursor, since that's better than overlapping the comparison
					primary = biasLeft and "right" or "left"
				end
			end
		end
		if
			-- would we be pushing against the edge of the screen?
			(primary == "left" and (owner:GetLeft() - tooltip:GetWidth()) < 0)
			or (primary == "right" and (owner:GetRight() + tooltip:GetWidth() > GetScreenWidth()))
		then
			return self:ComputeTooltipAnchors(originalOwner, "vertical")
		end
		return owner, unpack(points[primary][secondary])
	end
end