local BPCM = select(2, ...)
local Cage = BPCM:NewModule("BPCM", "AceEvent-3.0", "AceHook-3.0")
BPCM.Cage = Cage
BPCM.Learn_Click = false
local Profile = nil

local L = LibStub("AceLocale-3.0"):GetLocale("BattlePetCageMatch")

local petsToCage = {}
local learn_queue = {}
local learnindex = nil
local skil_list = {}


local function TSMPricelookup(pBattlePetID)
	if (not BPCM.TSM_LOADED) or (not Profile.Cage_Max_Price) then return true end

	local source = (Profile.TSM_Use_Custom and Profile.TSM_Custom) or BPCM.PriceSources[Profile.TSM_Market] or "DBMarket"
	return (BPCM.TSM:GetCustomPriceValue(source, "p:"..pBattlePetID..":1:2") or 0) >= (Profile.Cage_Max_Price_Value *100*100)
end

local function TSMCustomPricelookup(pBattlePetID)
	if (not BPCM.TSM_LOADED) or (not Profile.Cage_Custom_TSM_Price) then return true end
print(Profile.TSM_Market)
	local source = (Profile.TSM_Use_Custom and Profile.TSM_Custom) or BPCM.PriceSources[Profile.TSM_Market] or "DBMarket"
	local custom_value = (BPCM.TSM:GetCustomPriceValue(Profile.Cage_Custom_TSM_Price_Value, "p:"..pBattlePetID..":1:2") or 0)
	return (BPCM.TSM:GetCustomPriceValue(source, "p:"..pBattlePetID..":1:2") or 0) >= custom_value
end


local function TSMAuctionLookup(pBattlePetID)
	if (not BPCM.TSM_LOADED) or (not Profile.Skip_Auction) then return true end
	return BPCM.TSM:GetAuctionQuantity("p:"..pBattlePetID..":1:2") == 0 

end


function Cage:Cage_Message(msg)
	if Profile.Cage_Output then 
		DEFAULT_CHAT_FRAME:AddMessage("\124cffc79c6eCageing:\124r \124cff69ccf0" .. msg .."\124r");
	end
end

function CreateCageListWindow()
local AceGUI = LibStub("AceGUI-3.0")
-- Create a container frame
local f = AceGUI:Create("Frame")
--f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
f:SetTitle("Caging List")
--f:SetStatusText("Status Bar")
--f:SetLayout("fill")

scrollcontainer = AceGUI:Create("SimpleGroup") -- "InlineGroup" is also good
scrollcontainer:SetFullWidth(true)
scrollcontainer:SetFullHeight(true) -- probably?
scrollcontainer:SetLayout("Fill") -- important!

f:AddChild(scrollcontainer)

scroll = AceGUI:Create("ScrollFrame")
scroll:SetLayout("Flow") -- probably?
scrollcontainer:AddChild(scrollcontainer)

local speciesID, customName, level, xp, maxXp, displayID, isFavorite, name, icon, petType, creatureID, sourceText, description, isWild, canBattle, tradable, unique, obtainable = C_PetJournal.GetPetInfoByPetID(petsToCage[1])


-- Create a button
local btn = AceGUI:Create("InteractiveLabel")
--btn:SetWidth(170)
btn:SetText(name)
btn:SetImage(icon)
btn:SetImageSize(16,16)
btn:SetCallback("OnClick", function() print("Click!") end)
-- Add the button to the container
scrollcontainer:AddChild(btn)
local speciesID, customName, level, xp, maxXp, displayID, isFavorite, name, icon, petType, creatureID, sourceText, description, isWild, canBattle, tradable, unique, obtainable = C_PetJournal.GetPetInfoByPetID(petsToCage[5])

local btn = AceGUI:Create("InteractiveLabel")
--btn:SetWidth(170)
btn:SetText(name)
btn:SetImage(icon)
btn:SetImageSize(16,16)
btn:SetCallback("OnClick", function() print("Click!") end)
-- Add the button to the container
scrollcontainer:AddChild(btn)

end


--Cycles through pet journal and creates a table of pets that match cageing rules
function Cage:GeneratePetList()
	C_PetJournal.ClearSearchFilter(); -- Clear filter so we have a full pet list.
	C_PetJournal.SetPetSortParameter(LE_SORT_BY_LEVEL); -- Sort by level, ensuring higher level pets are encountered first.

	local total, owned = C_PetJournal.GetNumPets();
	local petCache = {};
	petsToCage = {};

	for index = 1, owned do -- Loop every pet owned (unowned will be over the offset).
		local pGuid, pBattlePetID, _, pNickname, pLevel, pIsFav, _, pName, _, _, _, _, _, _, _, pIsTradeable = C_PetJournal.GetPetInfoByIndex(index);
		if pBattlePetID then 
			local numCollected = C_PetJournal.GetNumCollectedInfo(tonumber(pBattlePetID))
			petCache[pName] = (pIsTradeable and pGuid) or nil

			if ((pIsFav and (Profile.Favorite_Only == "include" or Profile.Favorite_Only == "only")) or (not pIsFav and (Profile.Favorite_Only == "include" or Profile.Favorite_Only == "ignore")))
			and pIsTradeable 
			--and (tonumber(pLevel) <= tonumber(Profile.Cage_Max_Level))
			and numCollected >= Profile.Cage_Max_Quantity
			and ((Profile.Skip_Caged and not BPCM.bagResults[pBattlePetID]) or (not Profile.Skip_Caged and true))
			and ((Profile.Handle_PetBlackList and not BPCM.BlackListDB:FindIndex(pName)) or (not Profile.Handle_PetBlackList and true))
			--and ((Profile.Handle_PetWhiteList == "only" and BPCM.WhiteListDB:FindIndex(pName)) or ((Profile.Handle_PetWhiteList == "include"  or Profile.Handle_PetWhiteList == "disable" ) and true))

			and ((Profile.Handle_PetWhiteList == "only" and false) or ((Profile.Handle_PetWhiteList == "include"  or Profile.Handle_PetWhiteList == "disable" ) and true))
			and ((Profile.Cage_Once and not petCache[pBattlePetID] ) or (not Profile.Cage_Once  and true))
			and TSMPricelookup(pBattlePetID) 
			and TSMCustomPricelookup(pBattlePetID)
			and TSMAuctionLookup(pBattlePetID) then
				if (tonumber(pLevel) <= tonumber(Profile.Cage_Max_Level)) then  --Breaks if included in previous if statement
					Cage:Cage_Message(pName .. " :: " .. L.CAGED_MESSAGE)
					table.insert(petsToCage, pGuid)
					petCache[pBattlePetID] = true
				end

			elseif 	 (Profile.Handle_PetBlackList and  BPCM.BlackListDB:FindIndex(pName)) then
				Cage:Cage_Message(pName .. " :: " .. L.CAGED_MESSAGE_BLACKLIST)
			end
		end
	end

	if (Profile.Handle_PetWhiteList == "include" or Profile.Handle_PetWhiteList == "only" )then 
		for pName, pGuid in pairs(petCache) do
			if type(pName)== "string" and BPCM.WhiteListDB:FindIndex(pName) then
				Cage:Cage_Message(pName .. " :: " .. L.CAGED_MESSAGE_WHITELIST)
				table.insert(petsToCage, pGuid)
			end
		end
	end

	Cage:Cage_Message(#petsToCage .. " Pets to Cage")
	if #petsToCage > 0  then 
		BPCM.eventFrame.petIndex = 1

		CreateCageListWindow()
		--Cage:StartCageing(BPCM.eventFrame.petIndex)
	end
end


---Initializes the cageing process
function Cage:StartCageing(index)
	if not Cage:inventorySpaceCheck() then
		BPCM.eventFrame.pendingUpdate = false
		Cage:Cage_Message(L.FULL_INVENTORY)
		return false
	end

	--The Cagepet function is delayed slightly so the game does not get overloaded
	C_Timer.NewTimer(.25, function()C_PetJournal.CagePetByID(petsToCage[index]) end)
	BPCM.eventFrame.petIndex = index + 1
	BPCM.eventFrame.pendingUpdate = true
	return true
end

--Verifies that there is free bag space
function Cage:inventorySpaceCheck()
	local free=0
	for bag=0,NUM_BAG_SLOTS do
		local bagFree,bagFam = GetContainerNumFreeSlots(bag)
		if bagFam==0 then
			free = free + bagFree
		end
	end
	if free == 0 then 
		return false
	else
		return true
	end
end

--The auto cageing has to be haneled by an event.  Trying to use an loop overwhelms the game and only a few pets are caged.
--The frame watches for any time a pet is caged and then tries to cage a new pet after a short delay, which then triggers 
-- the next pet on the list being caged untill no pets are in the list.  

-- Event handling frame.
local eventFrame = CreateFrame("Button", "BPCM_LearnButton", UIParent, "SecureActionButtonTemplate")
--local eventFrame = CreateFrame("FRAME")
BPCM.eventFrame  = eventFrame
eventFrame.pendingUpdate = false
eventFrame.petIndex = nil
eventFrame:RegisterEvent("PET_JOURNAL_PET_DELETED");
eventFrame:RegisterEvent("UI_ERROR_MESSAGE");
eventFrame:RegisterEvent("BAG_UPDATE");
eventFrame:RegisterEvent("NEW_PET_ADDED");
eventFrame:SetScript("OnEvent", function(self, event, ...)
	if InCombatLockdown() then return end
	if event == "PET_JOURNAL_PET_DELETED" then
		local index = eventFrame.petIndex or 2
		if self.pendingUpdate then
	
			if index > #petsToCage then
				self.pendingUpdate = false
				eventFrame.petIndex = nil
				petsToCage = {}
				Cage:Cage_Message(L.CAGE_COMPLETE)
			else
				Cage:StartCageing(index)
			end
		end
	elseif (event == "BAG_UPDATE") then
		BPCM.Create_Learn_Queue()

	elseif (event == "UI_ERROR_MESSAGE" and select(2,...) == SPELL_FAILED_CANT_ADD_BATTLE_PET )or event == "NEW_PET_ADDED" then
		if BPCM.Learn_Click then
			if not learnindex then
				BPCM.Create_Learn_Queue()
			else
				learnindex = learnindex + 1
				Cage:Update_Learn_Queue_Macro()
			end
		end
		BPCM.Learn_Click = false
	end
end);
eventFrame:SetAttribute("type1", "macro") -- left click causes macro		
--eventFrame:SetAttribute("macrotext1","/run BPCM.Create_Learn_Queue();\n/run BPCM.Learn_Click = true;") -- text for macro on left click
eventFrame:SetAttribute("macrotext1","/use pet cage;\n/run BPCM.Learn_Click = true;") -- text for macro on left click

--Virtual Button to attach the Learn Keybinding to
--local learnbutton = CreateFrame("Button", "BPCM_LearnButton", UIParent, "SecureActionButtonTemplate")
--learnbutton:SetAttribute("type1", "macro") -- left click causes macro		
--learnbutton:SetAttribute("macrotext1","/run BPCM.Create_Learn_Queue()") -- text for macro on left click


function Cage:CreateButton(parent)
	local cageButton = CreateFrame("Button", "BPCM_CageButton_"..parent, PetJournal);
	cageButton:SetNormalTexture("Interface/ICONS/INV_Pet_PetTrap01")
	cageButton:SetPoint("RIGHT", PetJournalFindBattle, "LEFT", 0, 0);
	cageButton:SetWidth(20)
	cageButton:SetHeight(20)
	cageButton:SetScript("OnClick", function(self, button, down) 
		local Shift = IsShiftKeyDown()
		if Shift then
			LibStub("AceConfigDialog-3.0"):Open("BattlePetCageMatch")
		else
			Cage:Controll()
		end
	end);
	cageButton:SetScript("OnEnter",
		function(self)
			GameTooltip:SetOwner (self, "ANCHOR_RIGHT");
			GameTooltip:SetText(L.AUTO_CAGE_TOOLTIP_1, 1, 1, 1);
			GameTooltip:AddLine(L.AUTO_CAGE_TOOLTIP_2, nil, nil, nil, true);
			GameTooltip:AddLine(L.AUTO_CAGE_TOOLTIP_3, nil, nil, nil, true);
			GameTooltip:Show();
		end
	);
	cageButton:SetScript("OnLeave",
		function()
			GameTooltip:Hide();
		end
	);
	return cageButton
end


function Cage:OnEnable()
	Profile = BPCM.Profile

	-- Add caging buttons to Pet Journal & Rematch
	BPCM.cageButton = Cage:CreateButton("PetJournal")

	if IsAddOnLoaded("Rematch") then
		BPCM.RecountcageButton = Cage:CreateButton("Recount")
		BPCM.RecountcageButton:SetParent("RematchToolbar")
		BPCM.RecountcageButton:ClearAllPoints()
		BPCM.RecountcageButton:SetPoint("LEFT", RematchToolbar.PetCount, "RIGHT", 25, 0)
		BPCM.RecountcageButton:SetWidth(32)
		BPCM.RecountcageButton:SetHeight(32)
		BPCM.RecountcageButton:Show()
	end
end


--Dialog Box for user decided handeling of an existing cage list
StaticPopupDialogs["BPCM_CONTINUE_CAGEING"] = {
  text = L.CONTINUE_CAGEING_DIALOG_TEXT,
  button1 = L.CONTINUE_CAGEING_DIALOG_YES,
  button2 = L.CONTINUE_CAGEING_DIALOG_NO,
  OnAccept = function ()
	Cage:StartCageing(BPCM.eventFrame.petIndex)
  end,

   OnCancel = function (_,reason)
          Cage:GeneratePetList()
  end,
  enterClicksFirstButton  = true,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}

--Dialog Box for user decided handeling of an existing cage list
StaticPopupDialogs["BPCM_STOP_CAGEING"] = {
  text = L.STOP_CAGEING_DIALOG_TEXT,
  button1 = L.CONTINUE_CAGEING_DIALOG_YES,
  button2 = L.CONTINUE_CAGEING_DIALOG_NO,
  OnAccept = function ()
	
  end,

   OnCancel = function (_,reason)
          Cage:StartCageing(BPCM.eventFrame.petIndex)
  end,
  enterClicksFirstButton  = true,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}

--Dialog Box for user decided handeling of an existing cage list
StaticPopupDialogs["BPCM_START_CAGEING"] = {
  text = L.START_CAGEING_DIALOG_TEXT,
  button1 = L.CONTINUE_CAGEING_DIALOG_YES,
  button2 = L.CONTINUE_CAGEING_DIALOG_NO,
  OnAccept = function ()
	Cage:ResetListCheck()
  end,

   OnCancel = function (_,reason)
  end,
  enterClicksFirstButton  = true,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}


function Cage:Controll()
	--Allows stoping of an auto cage process
	if BPCM.eventFrame.pendingUpdate == true then
		BPCM.eventFrame.pendingUpdate = false
		StaticPopup_Show("BPCM_STOP_CAGEING")
		return
	end

	if Profile.Cage_Confirm then
		StaticPopup_Show("BPCM_START_CAGEING")
		
	else
		Cage:ResetListCheck()
	end

end


--Determines how an existing cage list should be handled
function Cage:ResetListCheck()



	if #petsToCage > 0  and Profile.Incomplete_List == "prompt" then
		StaticPopup_Show("BPCM_CONTINUE_CAGEING")
	elseif #petsToCage > 0  and Profile.Incomplete_List == "old" then
		Cage:StartCageing(BPCM.eventFrame.petIndex)
	else
		Cage:GeneratePetList()
	end
end


--Updates Button Macro to use cage based on bag & slot from cage list
function Cage:Update_Learn_Queue_Macro()
	if InCombatLockdown() then return end
	if learnindex <= #learn_queue then
		local macro = "/use "..learn_queue[learnindex][1].." "..learn_queue[learnindex][2]..";\n/run BPCM.Learn_Click = true;"
		BPCM_LearnButton:SetAttribute("macrotext1", macro)
	else 
		BPCM_LearnButton:SetAttribute("macrotext1","/use pet cage;\n/run BPCM.Learn_Click = true;") -- text for macro on left click
		--BPCM_LearnButton:SetAttribute("macrotext1","/run BPCM.Create_Learn_Queue();\n/run BPCM.Learn_Click = true;")
		learnindex = nil
		learn_queue = {}
		--print(L.LEARN_COMPLETE)
	end
end


--Scans bags and creats a list the bag & slot positison for any found cages
function BPCM.Create_Learn_Queue()
	wipe(learn_queue)
	for t=0,4 do 
		local slots = GetContainerNumSlots(t);
		if (slots > 0) then
			for c=1,slots do
				local _,_,_,_,_,_,itemLink,_,_,itemID = GetContainerItemInfo(t,c)
				if (itemID == 82800) then
					local _, _, _, _, speciesId,_ , _, _, _, _, _, _, _, _, cageName = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
					local speciesID = tonumber(speciesId)
					local numCollected, limit = C_PetJournal.GetNumCollectedInfo(speciesId)
					--only queue if can be learned
					if numCollected < limit then 
						tinsert(learn_queue, {t,c})
					else
						--print("Skipping ".. cageName..", max already learned")
					end
				end
			end
		end	
		
	end

		learnindex = 1

	Cage:Update_Learn_Queue_Macro()
end



