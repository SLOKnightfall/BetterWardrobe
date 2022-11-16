local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local tooltipAPI ={}
local GetScreenWidth = GetScreenWidth
local GetScreenHeight = GetScreenHeight

local LAT = LibStub("LibArmorToken-1.0")
--local LAI = LibStub("LibAppropriateItems-1.0")

local IsDressableItem = _G.IsDressableItem or C_Item.IsDressableItemByID
local appearances_known = {}


local SLOT_MAINHAND = GetInventorySlotInfo("MainHandSlot")
local SLOT_OFFHAND = GetInventorySlotInfo("SecondaryHandSlot")
local SLOT_TABARD = GetInventorySlotInfo("TabardSlot")
local SLOT_CHEST = GetInventorySlotInfo("ChestSlot")
local SLOT_SHIRT = GetInventorySlotInfo("ShirtSlot")
local SLOT_HANDS = GetInventorySlotInfo("HandsSlot")
local SLOT_WAIST = GetInventorySlotInfo("WaistSlot")
local SLOT_SHOULDER = GetInventorySlotInfo("ShoulderSlot")
local SLOT_FEET = GetInventorySlotInfo("FeetSlot")
local SLOT_ROBE = -99 -- Magic!

local slot_removals = {
	INVTYPE_WEAPON = {SLOT_MAINHAND},
	INVTYPE_2HWEAPON = {SLOT_MAINHAND},
	INVTYPE_BODY = {SLOT_TABARD, SLOT_CHEST, SLOT_SHOULDER, SLOT_OFFHAND, SLOT_WAIST},
	INVTYPE_CHEST = {SLOT_TABARD, SLOT_OFFHAND, SLOT_WAIST, SLOT_SHIRT},
	INVTYPE_ROBE = {SLOT_TABARD, SLOT_WAIST, SLOT_SHOULDER, SLOT_OFFHAND},
	INVTYPE_LEGS = {SLOT_TABARD, SLOT_WAIST, SLOT_FEET, SLOT_ROBE, SLOT_MAINHAND, SLOT_OFFHAND},
	INVTYPE_WAIST = {SLOT_MAINHAND, SLOT_OFFHAND},
	INVTYPE_FEET = {SLOT_ROBE},
	INVTYPE_WRIST = {SLOT_HANDS, SLOT_CHEST, SLOT_ROBE, SLOT_SHIRT, SLOT_OFFHAND},
	INVTYPE_HAND = {SLOT_OFFHAND},
	INVTYPE_TABARD = {SLOT_WAIST, SLOT_OFFHAND},
}

local always_remove = {
	INVTYPE_WEAPON = true,
	INVTYPE_2HWEAPON = true,
}

local slot_facings = {
	INVTYPE_HEAD = 0,
	INVTYPE_SHOULDER = 0,
	INVTYPE_CLOAK = 3.4,
	INVTYPE_CHEST = 0,
	INVTYPE_ROBE = 0,
	INVTYPE_WRIST = 0,
	INVTYPE_2HWEAPON = 1.6,
	INVTYPE_WEAPON = 1.6,
	INVTYPE_WEAPONMAINHAND = 1.6,
	INVTYPE_WEAPONOFFHAND = -0.7,
	INVTYPE_SHIELD = -0.7,
	INVTYPE_HOLDABLE = -0.7,
	INVTYPE_RANGED = 1.6,
	INVTYPE_RANGEDRIGHT = 1.6,
	INVTYPE_THROWN = 1.6,
	INVTYPE_HAND = 0,
	INVTYPE_WAIST = 0,
	INVTYPE_LEGS = 0,
	INVTYPE_FEET = 0,
	INVTYPE_TABARD = 0,
	INVTYPE_BODY = 0,
}

local tooltip = CreateFrame("Frame", "BW_ProfileTooltip", UIParent, "TooltipBorderedFrameTemplate")
tooltip:SetClampedToScreen(true)
tooltip:SetFrameStrata("TOOLTIP")
tooltip:Hide()

tooltip:SetScript("OnEvent", function(self, event, ...)
	self[event](self, ...)
end)
tooltip:RegisterEvent("PLAYER_LOGIN")
tooltip:RegisterEvent("PLAYER_REGEN_DISABLED")
tooltip:RegisterEvent("PLAYER_REGEN_ENABLED")


function tooltip:PLAYER_LOGIN()
	tooltip.model:SetUnit("player")
	tooltip.modelZoomed:SetUnit("player")
	tooltipAPI.UpdateSources()
	tooltip:SetSize(addon.Profile.TooltipPreview_Width, addon.Profile.TooltipPreview_Height)
end

function tooltip:PLAYER_REGEN_ENABLED()
	if self:IsShown() and addon.Profile.TooltipPreview_MouseRotate then
		SetOverrideBinding(tooltip, true, "MOUSEWHEELUP", "AppearanceKnown_TooltipScrollUp")
		SetOverrideBinding(tooltip, true, "MOUSEWHEELDOWN", "AppearanceKnown_TooltipScrollDown")
	end
end

function tooltip:PLAYER_REGEN_DISABLED()
	ClearOverrideBindings(tooltip)
end

tooltip:SetScript("OnShow", function(self)
	if addon.Profile.TooltipPreview_MouseRotate and not InCombatLockdown() then
		SetOverrideBinding(tooltip, true, "MOUSEWHEELUP", "AppearanceKnown_TooltipScrollUp")
		SetOverrideBinding(tooltip, true, "MOUSEWHEELDOWN", "AppearanceKnown_TooltipScrollDown")
	end
end);

tooltip:SetScript("OnHide",function(self)
	if not InCombatLockdown() then
		ClearOverrideBindings(tooltip);
	end
end)

local function buildModel()
	local model = CreateFrame("DressUpModel", nil, tooltip)
	model:SetFrameLevel(1)
	model:SetPoint("TOPLEFT", tooltip, "TOPLEFT", 5, -5)
	model:SetPoint("BOTTOMRIGHT", tooltip, "BOTTOMRIGHT", -5, 5)
	model:SetKeepModelOnHide(true)
	model:SetUseTransmogSkin(false)
	model:SetScript("OnModelLoaded", function(self, ...)
		if self.cameraID then
			Model_ApplyUICamera(self, self.cameraID)
		end
	end)

	return model
end

tooltip.model = buildModel()
tooltip.modelZoomed = buildModel()
tooltip.modelWeapon = buildModel()

tooltip.model:SetScript("OnShow", function(self)
	-- Initial display will be off-center without this
	tooltipAPI:ResetModel(self)
end)

do
	local function GetTooltipItem(tip)
		if _G.TooltipDataProcessor then
				return TooltipUtil.GetDisplayedItem(tip)
		end
		return tip:GetItem()
	end
	local function OnTooltipSetItem(self)
		tooltipAPI:ShowItem(select(2, GetTooltipItem(self)), self)
	end
	local function OnHide(self)
		tooltipAPI:HideItem()
	end

	local tooltips = {}
	function tooltipAPI.RegisterTooltip(tip)
		if (not tip) or tooltips[tip] then
				return
		end
		if not _G.TooltipDataProcessor then
				tip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
		end
		tip:HookScript("OnHide", OnHide)
		tooltips[tip] = tip
	end

	if _G.TooltipDataProcessor then
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(self, data)
				if tooltips[self] then
					tooltipAPI:ShowItem(select(2, TooltipUtil.GetDisplayedItem(self)), self)
				end
		end)
	end

	tooltipAPI.RegisterTooltip(GameTooltip)
	tooltipAPI.RegisterTooltip(GameTooltip.ItemTooltip.Tooltip)
end

local positioner = CreateFrame("Frame")
positioner:Hide()
positioner:SetScript("OnShow", function(self)
	-- always run immediately
	self.elapsed = TOOLTIP_UPDATE_TIME
end)

positioner:SetScript("OnUpdate", function(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	if self.elapsed < TOOLTIP_UPDATE_TIME then
		return
	end
	self.elapsed = 0

	local owner, our_point, owner_point = tooltipAPI:ComputeTooltipAnchors(tooltip.owner, addon.Profile.TooltipPreview_Anchor)
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

	function tooltipAPI:ComputeTooltipAnchors(owner, anchor)
		-- Because I always forget: x is left-right, y is bottom-top
		-- Logic here: our tooltip should trend towards the center of the screen, unless something is stopping it.
		-- If comparison tooltips are shown, we shouldn't overlap them
		local originalOwner = owner
		local x, y = owner:GetCenter()
		if not (x and y) then
				return
		end

		x = x * owner:GetEffectiveScale()
		-- the y comparison doesn't need this:
		-- y = y * owner:GetEffectiveScale()

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

				local outerx = outermostComparisonShown:GetCenter() * outermostComparisonShown:GetEffectiveScale()
				local ownerx = owner:GetCenter() * owner:GetEffectiveScale()
				if
					-- outermost is right of owner while we're biasing left
					(biasLeft and outerx > ownerx)
					or
					-- outermost is left of owner while we're biasing right
					((not biasLeft) and outerx < ownerx)
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
			(primary == "left" and (owner:GetLeft() - tooltip:GetWidth()) < 0) or (primary == "right" and (owner:GetRight() + tooltip:GetWidth() > GetScreenWidth()))
		then
				return self:ComputeTooltipAnchors(originalOwner, "vertical")
		end
		return owner, unpack(points[primary][secondary])
	end
end

local spinner = CreateFrame("Frame", nil, tooltip);
spinner:Hide()
spinner:SetScript("OnUpdate", function(self, elapsed)
	if not (tooltip.activeModel and tooltip.activeModel:IsVisible()) then
		return self:Hide()
	end
	tooltip.activeModel:SetFacing(tooltip.activeModel:GetFacing() + elapsed)
end)

local hider = CreateFrame("Frame")
hider:Hide()

local function shouldHide(owner)
	if not owner then return true end
	if not owner:IsShown() then return true end
	if _G.TooltipDataProcessor then
		if not TooltipUtil.GetDisplayedItem(owner) then return true end
	else
		if not owner:GetItem() then return true end
	end

	return false
end

hider:SetScript("OnUpdate", function(self)
	if shouldHide(tooltip.owner) then
		spinner:Hide()
		positioner:Hide()
		tooltip:Hide()
		tooltip.item = nil
	end
	self:Hide()
end)

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
	if not id or id == 0 or (not token and not dressable) then return end
	local maybelink, _

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
			line:SetText(text.."         "..L["Item ID"]..": |cffffffff"..id)
		end
	end

	if token then
		-- It's a set token! Replace the id.
		local found
		for _, itemid in LAT:IterateItemsForTokenAndClass(id, class) do
				_, maybelink = GetItemInfo(itemid)
				if maybelink then
					id = itemid
					link = maybelink
					found = true
					break
				end
		end

		if not found then
				for _, tokenclass in LAT:IterateClassesForToken(id) do
					for _, itemid in LAT:IterateItemsForTokenAndClass(id, tokenclass) do
						_, maybelink = GetItemInfo(itemid)
						if maybelink then
								id = itemid
								link = maybelink
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
	if addon.Profile.TooltipPreview_Show and (not addon.Globals.mods[addon.Profile.TooltipPreview_Modifier] or addon.Globals.mods[addon.Profile.TooltipPreview_Modifier]()) and tooltip.item ~= id then
		tooltip.item = id

		local appropriateItem = false --LAI:IsAppropriate(id)

		if slot_facings[slot] and IsDressableItem(id) then --and (not db.currentClass or appropriateItem) then
			local model
			local cameraID, itemCamera
			if addon.Profile.TooltipPreview_ZoomItem or addon.Profile.TooltipPreview_ZoomWeapon then
				cameraID, itemCamera = addon.Camera:GetCameraID(id, addon.Profile.TooltipPreview_CustomModel and addon.Profile.TooltipPreview_CustomRace, addon.Profile.TooltipPreview_CustomModel and addon.Profile.TooltipPreview_CustomGender)
			end

			tooltip.model:Hide()
			tooltip.modelZoomed:Hide()
			tooltip.modelWeapon:Hide()

			local shouldZoom = (addon.Profile.TooltipPreview_ZoomWeapon and cameraID and itemCamera) or (addon.Profile.TooltipPreview_ZoomItem and cameraID and not itemCamera)

			if shouldZoom then
				if itemCamera then
					model = tooltip.modelWeapon
					local appearanceID = C_TransmogCollection.GetItemInfo(link)
					if appearanceID then
						model:SetItemAppearance(appearanceID)
					else
						model:SetItem(id)
					end

				else
					model = tooltip.modelZoomed
					----model:SetUseTransmogSkin(db.zoomMasked and slot ~= "INVTYPE_HEAD")
					self:ResetModel(model)
				end

				model.cameraID = cameraID
				Model_ApplyUICamera(model, cameraID)
				-- ApplyUICamera locks the animation, but...
				model:SetAnimation(0, 0)

			else
				model = tooltip.model

				self:ResetModel(model)
			end

			tooltip.activeModel = model
			model:Show()

			if not cameraID then
				model:SetFacing(slot_facings[slot] - (addon.Profile.TooltipPreviewRotate and 0.5 or 0))
			end

			tooltip:SetParent(for_tooltip)
			tooltip:Show()
			tooltip.owner = for_tooltip

			positioner:Show()
			spinner:SetShown(addon.Profile.TooltipPreviewRotate)

			if slot_removals[slot] and (always_remove[slot] ) then
				-- 1. If this is a weapon, force-remove the item in the main-hand slot! Otherwise it'll get dressed into the
				--    off-hand, maybe, depending on things which are more hassle than it's worth to work out.
				-- 2. Other slots will be entirely covered, making for a useless preview. e.g. shirts.
				for _, slotid in ipairs(slot_removals[slot]) do
					if slotid == SLOT_ROBE then
							local chest_itemid = GetInventoryItemID("player", SLOT_CHEST)
							if chest_itemid and select(4, GetItemInfoInstant(chest_itemid)) == 'INVTYPE_ROBE' then
								slotid = SLOT_CHEST
							end
					end

					if slotid > 0 then
							model:UndressSlot(slotid)
					end
				end
			end
			model:TryOn(link)

		else
			tooltip:Hide()
		end
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

function tooltipAPI:HideItem()
	hider:Show()
end

function tooltipAPI:ResetModel(model)
	if addon.Profile.TooltipPreview_CustomModel then
		model:SetUnit("none")
		model:SetCustomRace(addon.Profile.TooltipPreview_CustomRace, addon.Profile.TooltipPreview_CustomGender)
	else
		model:SetUnit("player")
	end

	model:RefreshCamera()
	
	if addon.Profile.TooltipPreview_Dress then
		model:Dress()
	else
		model:Undress()
	end

	model:SetUseTransmogSkin(addon.Profile.TooltipPreview_DressingDummy)
end

do
	local categorySlots = {
		-- [Enum.TransmogCollectionType.] = "",
		[Enum.TransmogCollectionType.Head] = "HEADSLOT",
		[Enum.TransmogCollectionType.Shoulder] = "SHOULDERSLOT",
		[Enum.TransmogCollectionType.Back] = "BACKSLOT",
		[Enum.TransmogCollectionType.Chest] = "CHESTSLOT",
		[Enum.TransmogCollectionType.Shirt] = "SHIRTSLOT",
		[Enum.TransmogCollectionType.Tabard] = "TABARDSLOT",
		[Enum.TransmogCollectionType.Wrist] = "WRISTSLOT",
		[Enum.TransmogCollectionType.Hands] = "HANDSSLOT",
		[Enum.TransmogCollectionType.Waist] = "WAISTSLOT",
		[Enum.TransmogCollectionType.Legs] = "LEGSSLOT",
		[Enum.TransmogCollectionType.Feet] = "FEETSLOT",
		[Enum.TransmogCollectionType.Wand] = "MAINHANDSLOT",
		[Enum.TransmogCollectionType.OneHAxe] = "MAINHANDSLOT",
		[Enum.TransmogCollectionType.OneHSword] = "MAINHANDSLOT",
		[Enum.TransmogCollectionType.OneHMace] = "MAINHANDSLOT",
		[Enum.TransmogCollectionType.Dagger] = "MAINHANDSLOT",
		[Enum.TransmogCollectionType.Fist] = "MAINHANDSLOT",
		[Enum.TransmogCollectionType.TwoHAxe] = "MAINHANDSLOT",
		[Enum.TransmogCollectionType.TwoHSword] = "MAINHANDSLOT",
		[Enum.TransmogCollectionType.TwoHMace] = "MAINHANDSLOT",
		[Enum.TransmogCollectionType.Staff] = "MAINHANDSLOT",
		[Enum.TransmogCollectionType.Polearm] = "MAINHANDSLOT",
		[Enum.TransmogCollectionType.Bow] = "MAINHANDSLOT",
		[Enum.TransmogCollectionType.Gun] = "MAINHANDSLOT",
		[Enum.TransmogCollectionType.Crossbow] = "MAINHANDSLOT",
		[Enum.TransmogCollectionType.Warglaives] = "MAINHANDSLOT",
		[Enum.TransmogCollectionType.Paired] = "MAINHANDSLOT",
		[Enum.TransmogCollectionType.Shield] = "SECONDARYHANDSLOT",
		[Enum.TransmogCollectionType.Holdable] = "SECONDARYHANDSLOT",
	}

	local categoryID = 1
	function tooltipAPI.UpdateSources()
		if categoryID > 28 then return end
		local location = TransmogUtil.GetTransmogLocation(categorySlots[categoryID], Enum.TransmogType.Appearance, Enum.TransmogModification.Main)
		local categoryAppearances = C_TransmogCollection.GetCategoryAppearances(categoryID, location)
		local acount, scount = 0, 0
		for _, categoryAppearance in pairs(categoryAppearances) do
				acount = acount + 1
				local appearanceSources = C_TransmogCollection.GetAppearanceSources(categoryAppearance.visualID, categoryID, location)
				local known_any
				for _, source in pairs(appearanceSources) do
					if source.isCollected then
						scount = scount + 1
						-- it's only worth saving if we know the source
						known_any = true
					end
				end
				if known_any then
					appearances_known[categoryAppearance.visualID] = true
				else
					-- cleaning up after unlearned appearances:
					appearances_known[categoryAppearance.visualID] = nil
				end
		end

		categoryID = categoryID + 1
		C_Timer.After(.3, tooltipAPI.UpdateSources)
	end
end

function tooltipAPI.CanTransmogItem(itemLink)
	local itemID = GetItemInfoInstant(itemLink)
	if itemID then
		local canBeChanged, noChangeReason, canBeSource, noSourceReason = C_Transmog.CanTransmogItem(itemID)
		return canBeSource, noSourceReason
	end
end

local brokenItems = {
	-- itemid : {appearanceid, sourceid}
	[153268] = {25124, 90807}, -- Enclave Aspirant's Axe
	[153316] = {25123, 90885}, -- Praetor's Ornamental Edge
}
function tooltipAPI.PlayerHasAppearance(itemLinkOrID)
	-- hasAppearance, appearanceFromOtherItem
	local itemID = GetItemInfoInstant(itemLinkOrID)
	if not itemID then return end
	local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemLinkOrID)
	if not appearanceID then
		-- sometimes the link won't actually give us an appearance, but itemID will
		-- e.g. mythic Drape of Iron Sutures from Shadowmoon Burial Grounds
		appearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemID)
	end

	if not appearanceID and brokenItems[itemID] then
		-- ...and there's a few that just need to be hardcoded
		appearanceID, sourceID = unpack(brokenItems[itemID])
	end

	if not appearanceID then return end
	if sourceID and appearances_known[appearanceID] then
		return true, not C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID)
	end

	local sources = C_TransmogCollection.GetAllAppearanceSources(appearanceID)
	if sources then
		local known_any = false
		for _, sourceID2 in pairs(sources) do
				if C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID2) then
					known_any = true
					if itemID == C_TransmogCollection.GetSourceItemID(sourceID2) then
						return true, false
					end
				end
		end

		return known_any, false
	end

	return false
end