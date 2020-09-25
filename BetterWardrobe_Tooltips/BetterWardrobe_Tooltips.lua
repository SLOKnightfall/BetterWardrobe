local frame = CreateFrame("FRAME");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
local function eventHandler(self, event, ...)
 LoadAddOn("Blizzard_Collections")
end
frame:SetScript("OnEvent", eventHandler);