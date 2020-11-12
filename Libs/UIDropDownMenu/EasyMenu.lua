--$Id: LibEasyMenu.lua 62 2020-10-31 18:10:55Z arithmandar $
-- Simplified Menu Display System
--	This is a basic system for displaying a menu from a structure table.
--
--	See UIDropDownMenu.lua for the menuList details.
--
--	Args:
--		menuList - menu table
--		menuFrame - the UI frame to populate
--		anchor - where to anchor the frame (e.g. CURSOR)
--		x - x offset
--		y - y offset
--		displayMode - border type
--		autoHideDelay - how long until the menu disappears
--
--
-- ----------------------------------------------------------------------------
-- Localized Lua globals.
-- ----------------------------------------------------------------------------

function BW_EasyMenu(menuList, menuFrame, anchor, x, y, displayMode, autoHideDelay )
	if ( displayMode == "MENU" ) then
		menuFrame.displayMode = displayMode;
	end
	BW_UIDropDownMenu_Initialize(menuFrame, BW_EasyMenu_Initialize, displayMode, nil, menuList)
	--LibDD:UIDropDownMenu_Initialize(menuFrame, function(...) LibDD:EasyMenu_Initialize( ... ) end, displayMode, nil, menuList);
	--bDD:ToggleDropDownMenu(1, nil, menuFrame, anchor, x, y, menuList, nil, autoHideDelay);
	BW_ToggleDropDownMenu(1, nil, menuFrame, anchor, x, y, menuList, nil)
end

function BW_EasyMenu_Initialize( frame, level, menuList )
	for index = 1, #menuList do
		local value = menuList[index]
		if (value.text) then
			value.index = index;
			--LibDD:UIDropDownMenu_AddButton( value, level );
			BW_UIDropDownMenu_AddButton(value, level)
		end
	end
end