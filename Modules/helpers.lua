function bo()
BetterWardrobe_Temp = {}
--print("clear")
for index, colors in pairs(addon.VisualColors) do
	local colorlist = ""
			if colors then
				local newindex = 1
				for c = 1, #colors, 4 do
					local cR = colors:byte(c+0)
					local cG = colors:byte(c+1)
					local cB = colors:byte(c+2)

					--colorlist:byte(c+0) = cR
					--colorlist:byte(c+2) = cG
					--colorlist:byte(c+3) = cG

					--for i=1,#data,2 do
  --file:write(string.char(tonumber(data:sub(i,i+1), 16)))
--end
					local r = string.char(tonumber(cR))
					local g = string.char(tonumber(cG))
					local b = string.char(tonumber(cB))
					colorlist = ([[%s%s%s%s]]):format(colorlist,r,g,b)
					--tinsert(colorlist,cR)
					--tinsert(colorlist,cG)

					--tinsert(colorlist,cB)

					newindex = newindex + 3
				end
			end


BetterWardrobe_Temp[index] = colorlist
end
end



	for i, data in ipairs(Recolors) do 
	table.sort(data, function(a,b) return a<b end)
end
table.sort(Recolors, function(a,b) return a[1]<b[1] end)
BetterWardrobe_Temp = Recolors






function xxxx()



	if not IsAddOnLoaded("BetterWardrobe_SourceData") then
		LoadAddOn("BetterWardrobe_SourceData")
	end
	local ColorTable = (_G.BetterWardrobeData and _G.BetterWardrobeData.ColorTable) or {}
BTT = {}
--AceSerializer:Embed(addon) 
for index, data in pairs(ColorTable) do

local temp =addon:Serialize(data)
BTT[index]= temp
end
end


function yy()

BTT = BTT or {}
_,zz=addon:Deserialize(BTT[156])
--AceSerializer:Embed(addon) 

end
local string_byte = string.byte