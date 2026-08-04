local addonName, addon = ...

local function Message(text)
	if addon.Print then addon:Print(text) else print(addonName .. ": " .. text) end
end

local function CountTable(values)
	local count = 0
	for _ in pairs(values or {}) do count = count + 1 end
	return count
end

local auditRunning = false

local function StartAudit()
	if auditRunning then
		Message("A transmog audit is already running.")
		return
	end

	local queue, seen = {}, {}
	local apiSets = C_TransmogSets.GetAllSets and C_TransmogSets.GetAllSets() or {}
	for _, data in ipairs(apiSets or {}) do
		local key = "api:" .. tostring(data.setID)
		if data.setID and not seen[key] then
			seen[key] = true
			queue[#queue + 1] = {data = data, isAPI = true}
		end
	end
	local function AddCustomSet(setID, data)
		local key = "custom:" .. tostring(setID)
		if data and not seen[key] then
			seen[key] = true
			queue[#queue + 1] = {data = data, isAPI = false}
		end
	end
	for setID, data in pairs(addon._embeddedArmorSets or {}) do AddCustomSet(setID, data) end
	for _, armorSets in pairs(addon.ArmorSets or {}) do
		if type(armorSets) == "table" then
			for setID, data in pairs(armorSets) do AddCustomSet(setID, data) end
		end
	end

	local result = {
		sources = 0, issues = {}, noSourceAPI = 0, noSourceCustom = 0,
		pending = 0, missingInventory = 0, unsupportedInventory = 0,
		characterRestricted = 0, currentAlternates = 0,
	}
	local index = 1
	auditRunning = true
	Message(string.format("Starting transmog audit for %d sets. The scan runs in small batches to avoid freezing the UI.", #queue))

	local function AddIssue(text)
		result.issues[#result.issues + 1] = text
	end

	local function Finish()
		auditRunning = false
		Message(string.format("Audit complete: %d sets, %d sources, %d issues, %d current-character alternate items.", #queue, result.sources, #result.issues, result.currentAlternates))
		Message(string.format("Bundled static data: %d sets; %d explicit alternate source entries across all armor types.", addon.BundledExtendedArmorSetCount or CountTable(addon._embeddedArmorSets), addon.BundledExtendedAlternateCount or 0))
		Message(string.format("No-source API sets: %d; no-source custom sets: %d; character-restricted sources: %d; pending API sources: %d.", result.noSourceAPI, result.noSourceCustom, result.characterRestricted, result.pending))
		Message(string.format("Missing inventory types: %d; unsupported inventory types: %d.", result.missingInventory, result.unsupportedInventory))
		for issueIndex = 1, math.min(50, #result.issues) do Message(result.issues[issueIndex]) end
		if #result.issues > 50 then Message(string.format("%d additional issues were omitted from chat.", #result.issues - 50)) end
	end

	local function ProcessBatch()
		local last = math.min(index + 74, #queue)
		for queueIndex = index, last do
			local entry = queue[queueIndex]
			local data = entry.data
			local sourceIDs = {}
			if entry.isAPI then
				for _, appearance in ipairs(C_TransmogSets.GetSetPrimaryAppearances(data.setID) or {}) do
					if appearance.appearanceID then sourceIDs[appearance.appearanceID] = true end
				end
			else
				for sourceID in pairs(data.extendedSources or data.sources or {}) do sourceIDs[sourceID] = true end
				for _, itemData in pairs(data.itemData or {}) do
					if type(itemData) == "table" and itemData[2] then sourceIDs[itemData[2]] = true end
				end
				for _, alternates in pairs(data.extendedAltSources or data.altSources or {}) do
					for alternateIndex = 2, #alternates do
						local info = C_TransmogCollection.GetSourceInfo(alternates[alternateIndex])
						if info then result.currentAlternates = result.currentAlternates + 1 end
					end
				end
			end

			if not next(sourceIDs) then
				if entry.isAPI then
					result.noSourceAPI = result.noSourceAPI + 1
				else
					result.noSourceCustom = result.noSourceCustom + 1
					AddIssue(string.format("Custom set %s (%s): no source IDs returned", tostring(data.setID), tostring(data.name or "unknown")))
				end
			end

			for sourceID in pairs(sourceIDs) do
				result.sources = result.sources + 1
				local info = C_TransmogCollection.GetSourceInfo(sourceID)
				if not info then
					result.pending = result.pending + 1
				elseif not info.invType then
					result.missingInventory = result.missingInventory + 1
					AddIssue(string.format("Set %s: source %s has no inventory type", tostring(data.setID), tostring(sourceID)))
				else
					local slotID = C_Transmog.GetSlotForInventoryType(info.invType)
					if not slotID then
						result.unsupportedInventory = result.unsupportedInventory + 1
						AddIssue(string.format("Set %s: source %s uses unsupported inventory type %s", tostring(data.setID), tostring(sourceID), tostring(info.invType)))
					end
				end
			end
		end
		index = last + 1
		if index <= #queue then C_Timer.After(0, ProcessBatch) else Finish() end
	end

	ProcessBatch()
end

SLASH_BETTERWARDROBEAUDIT1 = "/bwaudit"
SlashCmdList.BETTERWARDROBEAUDIT = StartAudit
