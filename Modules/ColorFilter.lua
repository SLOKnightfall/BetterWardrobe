local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local R1, G1, B1, cat1

--Deduped from Globals.colors, then merged where two names are visually close (Delta-E 1994, addon:CompareLAB,
--~13 threshold) so the swatch row isn't cluttered with near-identical entries: red+crimson, white+lavender,
--purple+indigo, silver+pink, gold+yellow. matchNames carries every merged name for the ItemAppearance
--filename check, so clicking "Red" still matches a filename that says "crimson".
local SWATCH_GROUPS = {
	{"red", "crimson"},
	{"white", "lavender"},
	{"purple", "indigo"},
	{"silver", "pink"},
	{"gold", "yellow"},
	{"blue"}, {"teal"}, {"cyan"}, {"green"}, {"orange"}, {"brown"}, {"maroon"}, {"black"}, {"gray", "grey"},
}

local SWATCH_COLORS = {}
for _, group in ipairs(SWATCH_GROUPS) do
	local repName = group[1]
	local rgb = addon.Globals.colors[repName]
	SWATCH_COLORS[#SWATCH_COLORS + 1] = {name = repName, matchNames = group, r = rgb[1], g = rgb[2], b = rgb[3]}
end
table.sort(SWATCH_COLORS, function(a, b) return a.name < b.name end)

local function ButtonOnEnter(self)
	if not self.tooltip then return end
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddLine(self.tooltip)
	GameTooltip:Show()
end

local function ButtonOnLeave(self)
	GameTooltip_Hide()
end

local function resetFilters()
	ColorPickerFrame:Hide()
	addon.ColorFilterButton.colorSwatch:Hide()
	BetterWardrobeCollectionFrame.ItemsCollectionFrame.recolors = nil
	addon.ColorFilterButton.revert:Hide()
	if BetterWardrobeCollectionFrame.ItemsCollectionFrame:IsShown() then
		BetterWardrobeCollectionFrame.ItemsCollectionFrame:RefreshVisualsList()
		BetterWardrobeCollectionFrame.ItemsCollectionFrame:UpdateItems()
	end
end

--https://www.easyrgb.com/en/math.php  Standard-RGB → XYZ
function addon:ConvertRGB_to_LAB(r, g, b)
	local var_R = r / 255
	local var_G = g / 255
	local var_B = b / 255
	
	if var_R > 0.04045 then
		var_R = math.pow((var_R + 0.055) / 1.055, 2.4)
	else                  
		var_R = var_R / 12.92
	end

	if var_G > 0.04045 then
		var_G = math.pow((var_G + 0.055) / 1.055, 2.4)
	else
		var_G = var_G / 12.92
	end

	if var_B > 0.04045 then
		var_B = math.pow((var_B + 0.055) / 1.055, 2.4)
	else                  
		var_B = var_B / 12.92
	end

	var_R = var_R * 100
	var_G = var_G * 100
	var_B = var_B * 100

	local X = var_R * 0.4124 + var_G * 0.3576 + var_B * 0.1805
	local Y = var_R * 0.2126 + var_G * 0.7152 + var_B * 0.0722
	local Z = var_R * 0.0193 + var_G * 0.1192 + var_B * 0.9505

	--XYZ → CIE-L*ab
	local var_X = X / 95.044
	local var_Y = Y / 100.000
	local var_Z = Z / 108.755

	if var_X > 0.008856 then
		var_X = math.pow(var_X, 1/3)
	else                   
		var_X = ( 7.787 * var_X ) + ( 16 / 116 )
	end

	if var_Y > 0.008856 then
		var_Y = math.pow(var_Y, 1/3)
	else
		var_Y = ( 7.787 * var_Y ) + ( 16 / 116 )
	end

	if var_Z > 0.008856 then
		var_Z = math.pow(var_Z, 1/3)
	else                   
		var_Z = ( 7.787 * var_Z ) + ( 16 / 116 )
	end

	local L = ( 116 * var_Y ) - 16
	local A = 500 * ( var_X - var_Y )
	local B = 200 * ( var_Y - var_Z )
	
	return L, A, B
end

--Delta E1994
function addon:CompareLAB(R1, G1, B1, R2, G2, B2)
	local L = R1 - R2
	local A = G1 - G2
	local B = B1 - B2

	local XC1 = math.sqrt((G1 * G1) + (B1 * B1))
	local XC2 = math.sqrt((G2 * G2) + (B2 * B2))
	local xDC  = XC1 - XC2
	local xDH = (A * A) + (B * B) - (xDC * xDC)

	if xDH < 0 then
		xDH = 0
	else
		xDH =  math.sqrt(xDH)
	end

	local xSC = 1 + (0.045 * XC1)
	local xSH = 1 + (0.015 * XC1)
	local xDL  = L / 1
	local xDC  = xDC  / xSC
	local xDH  = xDH / xSH
	local i = (xDL  * xDL)  + (xDC  * xDC)  + (xDH  * xDH)

	if i < 0 then
		return 0

	else
		return math.sqrt(i)
	end
end

function addon:GetColorTable()
	if not C_AddOns.IsAddOnLoaded("BetterWardrobe_SourceData") then
		C_AddOns.EnableAddOn("BetterWardrobe_SourceData")
		C_AddOns.LoadAddOn("BetterWardrobe_SourceData")
	end
	return (_G.BetterWardrobeData and _G.BetterWardrobeData.ColorTable) or {}
end

function addon:VisualMatchesColorLab(visualID, colorTable, labA, labB, labC, tolerance)
	local item_colors = colorTable[visualID]
	if not item_colors then return false end

	tolerance = tolerance or 22

	local _, colors = addon:Deserialize(item_colors)
	for i = 1, #colors, 3 do
		local R = colors[2][i + 0]
		local G = colors[2][i + 1]
		local B = colors[2][i + 2]

		if R and G and B then
			local colorDifferece = addon:CompareLAB(labA, labB, labC, addon:ConvertRGB_to_LAB(R, G, B))
			if colorDifferece <= tolerance then
				return true
			end
		end
	end
	return false
end

local function SelectColor()
	local ColorTable = addon:GetColorTable()
	ColorPickerFrame.hasOpacity = false
	if not ColorPickerFrame then return end

	local function ColorPickerCallback()
		if not ColorPickerFrame then return end

		local ItemsCollectionFrame = BetterWardrobeCollectionFrame.ItemsCollectionFrame
		local R2, G2, B2 = ColorPickerFrame:GetColorRGB()
		ColorPickerFrame.previousValues = {R2, G2, B2,1}; 
		if (R1 == R2) and (G1 == G2) and (B1 == B2) and (cat1 == ItemsCollectionFrame.activeCategory) then
			return
		end

		R1, G1, B1, cat1 = R2, G2, B2, ItemsCollectionFrame.activeCategory

		local transmogAppearances = C_TransmogCollection.GetCategoryAppearances(ItemsCollectionFrame.activeCategory, ItemsCollectionFrame.transmogLocation)
		addon.ColorFilterButton.colorSwatch:Show()
		addon.ColorFilterButton.colorSwatch:SetVertexColor(R2, G2, B2, 1)

		R2 = R2 * 255
		G2 = G2 * 255
		B2 = B2 * 255

		--Swatches use idealized/pure RGB, which real sampled item colors rarely match closely,
		--so widen the tolerance for a swatch-triggered pick; manual wheel picks keep the default.
		local tolerance = addon.colorPickerFromSwatch and 22 or nil
		local swatchColorNames = addon.colorPickerFromSwatch and addon.colorPickerSwatchNames
		addon.colorPickerFromSwatch = false
		addon.colorPickerSwatchNames = nil
		local ItemAppearance = (_G.BetterWardrobeData and _G.BetterWardrobeData.ItemAppearanceByID) or {}

		local labA, labB, labC = addon:ConvertRGB_to_LAB(R2, G2, B2)
		for i = #transmogAppearances, 1, -1 do
			local visualID = transmogAppearances[i].visualID
			local nameMatch = false
			if swatchColorNames and ItemAppearance[visualID] then
				for _, colorName in ipairs(swatchColorNames) do
					if strfind(ItemAppearance[visualID], colorName, 1, true) then
						nameMatch = true
						break
					end
				end
			end
			if not nameMatch and not addon:VisualMatchesColorLab(visualID, ColorTable, labA, labB, labC, tolerance) then
				tremove(transmogAppearances, i)
			end
		end

		addon.ColorFilterButton.revert:Show()

		ItemsCollectionFrame.visualsList = transmogAppearances
		ItemsCollectionFrame:FilterVisuals()
		ItemsCollectionFrame:SortVisuals()

		ItemsCollectionFrame.PagingFrame:SetMaxPages(ceil(#ItemsCollectionFrame.filteredVisualsList / ItemsCollectionFrame.PAGE_SIZE))
		ItemsCollectionFrame:ResetPage()
	end

	ColorPickerFrame.swatchFunc = ColorPickerCallback
	ColorPickerFrame.cancelFunc = function() resetFilters() end
	--ColorPickerFrame:SetColorRGB(.64,.64,.64,1)
	ColorPickerFrame:ClearAllPoints()
	ColorPickerFrame:SetPoint("TOPLEFT", BetterWardrobeCollectionFrame, "TOPRIGHT", 6, -8)
	addon.colorPickerIsOurs = true
	ColorPickerFrame:Show()
	ColorPickerFrame.Content.ColorSwatchOriginal:Hide()

	--ColorPickerFrame.Content.ColorSwatchOriginal:Hide()

end

--Quick-pick swatches shown inside the (shared, global) ColorPickerFrame only when we're the ones
--who opened it; clicking one just sets the picker's color, which drives the existing swatchFunc
--filter callback the same as manually dragging the wheel would.
local COLORPICKER_ORIGINAL_HEIGHT = ColorPickerFrame:GetHeight()
local SWATCH_SIZE, SWATCH_SPACING, MAX_SWATCHES_PER_ROW = 16, 3, 10
--Balance the grid instead of a fixed per-row count, so e.g. 14 swatches lay out as 7+7, not 10+4.
local SWATCH_ROWS = ceil(#SWATCH_COLORS / MAX_SWATCHES_PER_ROW)
local SWATCHES_PER_ROW = ceil(#SWATCH_COLORS / SWATCH_ROWS)
local swatchContainer

local function CreateColorPickerSwatches()
	local container = CreateFrame("Frame", nil, ColorPickerFrame)
	container:SetPoint("TOPLEFT", ColorPickerFrame.Content.ColorPicker, "BOTTOMLEFT", 0, -18)

	container:SetSize(SWATCHES_PER_ROW * (SWATCH_SIZE + SWATCH_SPACING), SWATCH_ROWS * (SWATCH_SIZE + SWATCH_SPACING))

	for i, color in ipairs(SWATCH_COLORS) do
		local row = floor((i - 1) / SWATCHES_PER_ROW)
		local col = (i - 1) % SWATCHES_PER_ROW

		local swatch = CreateFrame("Button", nil, container)
		swatch:SetSize(SWATCH_SIZE, SWATCH_SIZE)
		swatch:SetPoint("TOPLEFT", col * (SWATCH_SIZE + SWATCH_SPACING), -row * (SWATCH_SIZE + SWATCH_SPACING))

		local tex = swatch:CreateTexture(nil, "ARTWORK")
		tex:SetAllPoints()
		tex:SetColorTexture(color.r / 255, color.g / 255, color.b / 255, 1)

		swatch.tooltip = L[color.name] or color.name
		swatch:SetScript("OnEnter", ButtonOnEnter)
		swatch:SetScript("OnLeave", ButtonOnLeave)
		swatch:SetScript("OnClick", function()
			addon.colorPickerFromSwatch = true
			addon.colorPickerSwatchNames = color.matchNames
			ColorPickerFrame.Content.ColorPicker:SetColorRGB(color.r / 255, color.g / 255, color.b / 255)
		end)
	end

	return container
end

ColorPickerFrame:HookScript("OnShow", function()
	if addon.colorPickerIsOurs then
		swatchContainer = swatchContainer or CreateColorPickerSwatches()
		ColorPickerFrame:SetHeight(COLORPICKER_ORIGINAL_HEIGHT + SWATCH_ROWS * (SWATCH_SIZE + SWATCH_SPACING) + 18)
		swatchContainer:Show()
	elseif swatchContainer then
		swatchContainer:Hide()
	end
end)

--ColorPickerFrame is one shared global frame. We anchor it beside the wardrobe while it's ours;
--put it back at Blizzard's default (screen center) on close, or every later color picker in any
--addon opens at that stale spot on top of whatever is there.
ColorPickerFrame:HookScript("OnHide", function()
	if addon.colorPickerIsOurs then
		ColorPickerFrame:ClearAllPoints()
		ColorPickerFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
		ColorPickerFrame.Content.ColorSwatchOriginal:Show()
	end
	addon.colorPickerIsOurs = false
	ColorPickerFrame:SetHeight(COLORPICKER_ORIGINAL_HEIGHT)
	if swatchContainer then
		swatchContainer:Hide()
	end
end)
--Beside a screen-filling transmog frame there is often no room to the right; keep it on screen.
ColorPickerFrame:SetClampedToScreen(true)

function addon.Init:InitFilterButtons()
	local frame = CreateFrame("Button", nil, BetterWardrobeCollectionFrame.ItemsCollectionFrame)
	local atTransmogrifier = C_Transmog.IsAtTransmogNPC();
	frame:ClearAllPoints()
	local slotButtons = BetterWardrobeCollectionFrame.ItemsCollectionFrame.SlotsFrame.Buttons
	local lastSlotButton
	for i = 1, #slotButtons do
		if not slotButtons[i].isSmallButton then
			lastSlotButton = slotButtons[i]
		end
	end
	frame:SetPoint("LEFT", lastSlotButton, "RIGHT", 12, 0)
	frame:SetSize(25, 25)

	frame:SetScript("OnHide",function()
		ColorPickerFrame:Hide()
		ColorPickerFrame.Content.ColorSwatchOriginal:Show()

		addon.ColorFilterButton.colorSwatch:Hide()
		BetterWardrobeCollectionFrame.ItemsCollectionFrame.recolors = nil
		addon.ColorFilterButton.revert:Hide()
		end)

	addon.ColorFilterFrame = frame
	local btn = CreateFrame("Button", nil, frame)
	btn:SetWidth(13)
	btn:SetHeight(13)
	btn:SetPoint("CENTER")
			btn:SetScript("OnClick",function(self)
			SelectColor()
		end)
	btn:SetScript("OnEnter",ButtonOnEnter)
	btn:SetScript("OnLeave",ButtonOnLeave)
	btn.tooltip = L["Select color"]
	addon.ColorFilterButton = btn

	local colorSwatch = btn:CreateTexture(nil, "OVERLAY")
	colorSwatch:SetWidth(13)
	colorSwatch:SetHeight(13)
	colorSwatch:SetTexture(130939) -- Interface\\ChatFrame\\ChatFrameColorSwatch
	colorSwatch:SetPoint("CENTER")
	colorSwatch:Hide()
	btn.colorSwatch = colorSwatch

	local checkers = btn:CreateTexture(nil, "BACKGROUND")
	btn.checkers = checkers
	checkers:SetWidth(13)
	checkers:SetHeight(13)
	checkers:SetTexture(188523) -- Tileset\\Generic\\Checkers
	checkers:SetTexCoord(.25, 0, 0.5, .25)
	checkers:SetDesaturated(true)
	checkers:SetVertexColor(1, 1, 1, 0.75)
	checkers:SetPoint("CENTER", colorSwatch)
	checkers:Show()

	local border = frame:CreateTexture(nil, "OVERLAY")
	border:SetTexture([[Interface\CastingBar\UI-CastingBar-Arena-Shield]])
	border:SetSize(43, 43)
	border:SetPoint("LEFT", -1,-1)

	local revert = CreateFrame("Button", nil, frame)
	revert:SetPoint("CENTER", 16,15)
	revert:SetWidth(20)
	revert:SetHeight(20)
	revert:Hide()
	revert:SetScript("OnClick", function(self)
			resetFilters()
		end)

	revert:SetScript("OnEnter", ButtonOnEnter)
	revert:SetScript("OnLeave", ButtonOnLeave)
	revert.tooltip = L["Reset"]
	btn.revert = revert

	local texture = revert:CreateTexture(nil, "OVERLAY")
	texture:SetAtlas("transmog-icon-revert-small")
	texture:SetAllPoints()
end


local ct = {}
 local function EncodeColors()
 	--print("run")
	 ColorTable = ct --(_G.BetterWardrobeData and _G.BetterWardrobeData.ColorTable2) or {}
	BTT = {}
	--AceSerializer:Embed(addon)
	for index, data in pairs(ColorTable) do
--print(index)
		local temp =addon:Serialize(data)
		BTT[index]= temp
	end
end

local function yy()
	BTT = nil
	local ColorTable = (_G.BetterWardrobeData and _G.BetterWardrobeData.ColorTable) or {}
  	_,temp =addon:Deserialize(ColorTable[156])
end