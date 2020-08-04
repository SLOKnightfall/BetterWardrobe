local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)


--Artifact = Artifact or {}

--[[function a()
	local artifactID = C_ArtifactUI.GetArtifactItemID()
	Artifact[artifactID] = {}
	for set=1, C_ArtifactUI.GetNumAppearanceSets() do
		local setIndex, setName, setDescription, numAppearanceSlots = C_ArtifactUI.GetAppearanceSetInfo(set)
		Artifact[artifactID][set] = {}

		for appearance = 1, 4 do
			local appearanceID, appearanceName, displayIndex, appearanceUnlocked, unlockConditionText, uiCameraID, altHandUICameraID, swatchR, swatchG, swatchB, modelAlpha, modelDesaturation, appearanceObtainable = C_ArtifactUI.GetAppearanceInfo(set, appearance)
			Artifact[artifactID]["name"] = appearanceName
			Artifact[artifactID][set][appearance] = {
			["setName"] = setName , 
		["setDescription"] = setDescription, 
	["appearanceID"] = appearanceID, 
["displayIndex"] = displayIndex, 
["appearanceUnlocked"] = appearanceUnlocked, 
["unlockConditionText"] = unlockConditionText}
		end
	end
end
]]

local CLASS_ARTIFACT_DATA = {
	EVOKER = {},
	DEATHKNIGHT = {
		[128402] = "Maw of the Damned",
		[128292] = "Blades of the Fallen Prince",
		--[128293] = "Blades of the Fallen Prince",
		[128403] = "Apocalypse",
	},
	DEMONHUNTER = {
		[127829] = "Twinblades of the Deceiver",
		--[127830] = "Twinblades of the Deceiver",
		[128832] = "Aldrachi Warblades",
		--[128831] = "Aldrachi Warblades",
	},
	DRUID = {
		[128858] = "Scythe of Elune",
		--[128859] = "Fangs of Ashamane",
		[128860] = "Fangs of Ashamane",
		[128821] = "Claws of Ursoc",
		--[128822] = "Claws of Ursoc",
		[128306] = "G'Hanir, the Mother Tree",
	},
	HUNTER = {
		[128861] = "Titanstrike",
		[128826] = "Thas'dorah, Legacy of the Windrunners",
		[128808] = "Talonclaw",
	},
	MAGE = {
		[127857] = "Aluneth",
		[128820] = "Felo'melorn",
		--[133959] = "Heart of the Phoenix",
		[128862] = "Ebonchill",
	},
	MONK ={ 
		[128938] = "Fu Zan, the Wanderer's Companion",
		[128937] = "Sheilun, Staff of the Mists",
		[128940] = "Fists of the Heavens",
		--[133948] = "Fists of the Heavens",
	},
	PALADIN ={ 
		[128823] = "The Silver Hand", 
		--[128824] = "Tome of the Silver Hand",
		[128866] = "Truthguard",
		--[128867] = "Oathseeker",
		[120978] = "Ashbringer",
		},
	PRIEST ={ 
		[128868] = "Light's Wrath",
		[128825] = "T'uure, Beacon of the Naaru",
		[128827] = "Xal'atath, Blade of the Black Empire",
		--[133958] = "Secrets of the Void",
	},
	ROGUE ={ 
		[128870] = "The Kingslayers",
		--[128869] = "The Kingslayers",
		[128872] = "The Dreadblades",
		--[134552] = "The Dreadblades",
		[128476] = "Fangs of the Devourer",
		--[128479] = "Fangs of the Devourer",
	},
	SHAMAN = {
		[128935] = "The Fist of Ra-den",
		--[128936] = "The Highkeeper's Ward",
		[128819] = "Doomhammer",
		--[128873] = "Fury of the Stonemother",
		[128911] = "Sharas'dal, Scepter of Tides",
		--[128934] = "Shield of the Sea Queen",
	},
	WARLOCK ={ 
		[128942] = "Ulthalesh, the Deadwind Harvester",
		[128943] = "Skull of the Man'ari",
		--[137246] = "Spine of Thal'kiel",
		[128941] = "Scepter of Sargeras",},
	WARRIOR ={ 
		[128910] = "Strom'kar, the Warbreaker",
		[128908] = "Warswords of the Valarjar",
		--[134553] = "Warswords of the Valarjar",
		[128289] = "Scale of the Earth-Warder",
		--[128288] = "Scaleshard"
	},
}


local function BuildDruidAppearances(artifactID, table)
	local sourceList = {}
	local apperanceIDs = {9, 13, 17, 21, 25, 29}

	for i in pairs(apperanceIDs) do
		local artifactData = addon.Globals.ARTIFACT_DATA[artifactID]
		local _, specName  = GetSpecializationInfoByID(artifactData.specID)
		local camera

		for _, i in pairs(apperanceIDs) do
			local data = artifactData.sets[i]
			local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(artifactID, i)
			local cameraVariation = 0

			local appearanceCameraID = C_TransmogCollection.GetAppearanceCameraID(appearanceID, cameraVariation)
			if appearanceCameraID == 0 then
				for i = 9, 32 do
					local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(artifactID, i) -- 128861
					local cameraVariation = 0
					local camera = C_TransmogCollection.GetAppearanceCameraID(appearanceID, cameraVariation)	

					if camera ~= 0 then 
						appearanceCameraID = camera
						break
					end
				end
			end

			local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
			if sourceInfo then
				if not appearanceCameraID or appearanceCameraID == 0 then 
					sourceInfo.camera = camera
				else
					sourceInfo.camera = appearanceCameraID
				end
				
				sourceInfo.sourceID = sourceID
				sourceInfo.specID = artifactData.specID
				sourceInfo.specName = specName
				sourceInfo.sources = {}
				sourceInfo.expansionID = 6
				sourceInfo.itemLink = itemLink
				sourceInfo.isUsable = true
				sourceInfo.artifact = true
				sourceInfo.mod = i
				sourceInfo.artifactID = itemID

				if 	addon.Globals.UNLOCK_DATA[data.unlock] then 
					sourceInfo.unlock = addon.Globals.UNLOCK_DATA[data.unlock].unlock
					sourceInfo.unlockAch = addon.Globals.UNLOCK_DATA[data.unlock].ach
				end

				tinsert(table, sourceInfo)
			end
		end
	end

	return table
end

local visualIDIndex = {}
local sourcelist = {}
function addon.BuildClassArtifactAppearanceList() 
	wipe(visualIDIndex)
	wipe(sourcelist)

	local _, playerClass, classID = UnitClass("player")
	local artifactList = CLASS_ARTIFACT_DATA[playerClass]
	local uiOrderBase = 0

	for itemID in pairs(artifactList) do 
		uiOrderBase = uiOrderBase + 100
		local artifactData = addon.Globals.ARTIFACT_DATA[itemID]
		local _, specName  = GetSpecializationInfoByID(artifactData.specID)
		local camera

		for index, data in pairs(artifactData.sets) do
			local appearanceID, sourceID = data.appearance, data.source
			local cameraVariation = 0
			local appearanceCameraID = C_TransmogCollection.GetAppearanceCameraID(appearanceID,cameraVariation)

			if appearanceCameraID == 0 then
				for i = 9, 32 do
					local appearanceID, sourceID = data.appearance, data.source
					local cameraVariation = 0

					local camera = C_TransmogCollection.GetAppearanceCameraID(appearanceID, cameraVariation)	

					if camera ~= 0 then 
						appearanceCameraID = camera
						break
					end
				end

				local _, _, _, _, _, itemClassID, itemSubClassID = GetItemInfoInstant(itemID)
				if (itemClassID == 2 or itemClassID == 4) and addon.Globals.CAMERAS[itemClassID][itemSubClassID] then 
					appearanceCameraID = addon.Globals.CAMERAS[itemClassID][itemSubClassID]
				end
			end

			local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
			if sourceInfo then
				if not appearanceCameraID or appearanceCameraID == 0 then 
					sourceInfo.camera = camera
				else
					sourceInfo.camera = appearanceCameraID
				end
				
				if itemID == 128860 or itemID == 128821 then 
					sourceInfo.visualID = sourceInfo.visualID
					sourceInfo.name = data.name
				else
					sourceInfo.name = data.name
				end

				if data.shapeshiftID then 
					sourceInfo.shapeshiftID = data.shapeshiftID
					if data.shapeshiftID == 74269 or data.shapeshiftID == 74270 or data.shapeshiftID == 74271 or data.shapeshiftID == 74272 then
						sourceInfo.camera = 200
					else
						sourceInfo.camera = data.cameraID or 48
					end
				end

				sourceInfo.uiOrder = uiOrderBase + index
				sourceInfo.sourceID = sourceID
				sourceInfo.specID = artifactData.specID
				sourceInfo.specName = specName
				sourceInfo.sources = {}
				sourceInfo.expansionID = 6
				sourceInfo.itemLink = itemLink
				sourceInfo.isUsable = true
				sourceInfo.artifact = true
				sourceInfo.mod = index
				sourceInfo.artifactID = itemID
				if 	addon.Globals.UNLOCK_DATA[data.unlock] then 
					sourceInfo.unlock = addon.Globals.UNLOCK_DATA[data.unlock].unlock
					sourceInfo.unlockAch = addon.Globals.UNLOCK_DATA[data.unlock].ach
				end

				visualIDIndex[sourceInfo.visualID] = sourceInfo
				tinsert(sourcelist, sourceInfo)
			end
		end	
	end
	return sourcelist
end

function addon.GetClassArtifactAppearanceList() 
	return sourcelist
end

function addon.ClearArtifactData()
	wipe(visualIDIndex)
	wipe(sourcelist)
end

function addon.GetArtifactSourceInfo(visualID)
	return visualIDIndex[visualID] 
end

function addon.SetArtifactAppearanceTooltip(contentFrame, sourceInfo, sourceID)
	BetterWardrobeCollectionFrame.tooltipContentFrame = contentFrame
	BetterWardrobeCollectionFrame.tooltipSourceIndex = 1

	if sourceInfo then 
		local name, nameColor = sourceInfo.name, ARTIFACT_GOLD_COLOR
		local sourceText, sourceColor = BetterWardrobeCollectionFrame:GetAppearanceSourceTextAndColor(sourceInfo)
		GameTooltip:SetText(name, nameColor:GetRGBA())


		----local name, nameColor, sourceText, sourceColor = WardrobeCollectionFrameModel_GetSourceTooltipInfo(sourceInfo)
		----GameTooltip:SetText(name)--, nameColor.r, nameColor.g, nameColor.b)
		-- print(sourceInfo.sourceType)
		--[[	--GameTooltip:AddLine(" ")
					if sourceInfo.mod <= 12 then 
						GameTooltip:AddLine(L["Base Appearance"])
					elseif sourceInfo.mod <= 16 then
						GameTooltip:AddLine(L["Class Hall Appearance"])
					elseif sourceInfo.mod <= 20 then
						GameTooltip:AddLine(L["Mythic Dungeon Quests Appearance"])
					elseif sourceInfo.mod <=24 then
						GameTooltip:AddLine(L["PvP Appearance"])
			
					elseif sourceInfo.mod <= 28 then
						GameTooltip:AddLine(L["Hidden Appearance"])
			
					else
						GameTooltip:AddLine(L["Mage Tower Appearance"])
					end]]
		
			GameTooltip:AddLine(sourceInfo.specName)
			if not sourceInfo.isCollected then
				if sourceInfo.mod >= 25 and sourceInfo.mod <= 28 and not sourceInfo.unlock then 
					GameTooltip:AddLine(L["Learned from Item"])
				else
					GameTooltip:AddLine(sourceInfo.unlock)
				end
			end
		
		GameTooltip:Show()
	else
		--print (self.tooltipVisualID)
	end
end


--[[
	local Model = CreateFrame( "PlayerModel" )
	--- @return Model path for DisplayID.
		Model:SetDisplayInfo( 74269 )
		Model:Show()
		Model:SetPoint("CENTER")
		Model:SetSize(250, 250)
		--Model:SetFacing(math.pi/5)
		Model_ApplyUICamera(Model, 1612)

				local counter =1600
				function bb()
					Model_ApplyUICamera(Model, counter)
					print(counter)
					counter = counter +1
					if counter < 1613 then 
					C_Timer.After(.5, function() bb() end)

					end
end]]