BW_FilterComponent = EnumUtil.MakeEnum(
	"TextButton", 			-- Simple button with white text 
	"Checkbox", 			-- Button with a small checkbox on the left and white description text on the right
	"Radio", 				-- Button with a small radio check icon on the left and white description text on the right
	"DynamicFilterSet", 	-- Generates a variable number of filter buttons (TextButton, Checkbox, or Radio) based on the numFilters function that is passed in. 
	"Space", 				-- Empty space (uninteractable)
	"Separator", 			-- Grey separator line (uninteractable)
	"Title", 				-- Yellow text (uninteractable)
	"Submenu", 				-- White text with a small arrow on the right, hovering over this will display the submenu. An optional "on click" function can be specified. 
	"CustomFunction" 		-- Calls the passed in function to initialize filters (for complex/special cases)
);

--[[
	Usage:

	BW_UIDropDownMenu_Initialize(self, ExampleFilterDropDown_Initialize, "MENU");

	function ExampleFilterDropDown_Initialize(self, level)
		local filterSystem = {
			onUpdate = [Function] -- Optional function that is called when a button in the dropdown is clicked
			filters = {
				INSERT FILTERS HERE
				Examples:
				{ type = BW_FilterComponent.TextButton, text = [String], set = [Function], },
				{ type = BW_FilterComponent.Checkbox, text = [String], set = [Function], isSet = [Function], filter = [nil, String/Number] (Optional, passed to "set" and "isSet"), },
				{ type = BW_FilterComponent.Radio, text = [String], set = [Function], isSet = [Function], filter = [nil, String/Number] (Optional, passed to "set" and "isSet"), },
				{ type = BW_FilterComponent.DynamicFilterSet,
				  buttonType = [BW_FilterComponent] -- Supports TextButton, Checkbox, Radio
				  set = [Function],
				  isSet = [Function],
				  numFilters = [Function],
				  filterValidation = [Function], -- OPTIONAL 
				  nameFunction = [Function] -- OPTIONAL - Mutually exclusive with globalPrepend
				  globalPrepend = [String], -- OPTIONAL - Mutually exclusive with nameFunction
				  globalPrependOffset = [Number] -- OPTIONAL 
				},
				{ type = BW_FilterComponent.Space, },
				{ type = BW_FilterComponent.Title, text = [String], },
				{ type = BW_FilterComponent.Submenu, text = [String], value = [Number], childrenInfo = {
						filters = {
							INSERT SUBMENU FILTERS HERE
						},
					},
				},
				{ type = BW_FilterComponent.CustomFunction, customFunc = [Function], Note: customFunc will recieve the FilterSystem as it's first argument },
			},
		};

		BW_FilterDropDownSystem.Initialize(self, filterSystem, level);
	end
--]]

BW_FilterDropDownSystem = {};

function BW_FilterDropDownSystem.Initialize(dropdown, filterSystem, level)
	if level == 1 then
		BW_FilterDropDownSystem.SetUpDropDownLevel(dropdown, filterSystem, level);
	else
		for filterIndex, filterInfo in ipairs(filterSystem.filters) do
			if filterInfo.value == BW_UIDROPDOWNMENU_MENU_VALUE and level == 2 then
				local subMenuLayout = filterInfo.childrenInfo;
				subMenuLayout.onUpdate = filterSystem.onUpdate;
				BW_FilterDropDownSystem.SetUpDropDownLevel(dropdown, subMenuLayout, level);
				return;
			elseif level == 3 then
				local secondLevelFilters = filterInfo.childrenInfo;
				if secondLevelFilters then
					for secondLevelFilterIndex, secondLevelFilterInfo in ipairs(secondLevelFilters.filters) do
						if secondLevelFilterInfo.value == BW_UIDROPDOWNMENU_MENU_VALUE then
							local subMenuLayout = secondLevelFilterInfo.childrenInfo;
							subMenuLayout.onUpdate = filterSystem.onUpdate;
							BW_FilterDropDownSystem.SetUpDropDownLevel(dropdown, subMenuLayout, level);
							return;
						end
					end
				end
			end
		end
	end
end

function BW_FilterDropDownSystem.SetUpDropDownLevel(dropdown, filterSystem, level)
	for filterIndex, filterInfo in ipairs(filterSystem.filters) do
		if filterInfo.type == BW_FilterComponent.TextButton then
			local set = function()
							filterInfo.set();
							if filterSystem.onUpdate then
								filterSystem.onUpdate();
							end
						end
			BW_FilterDropDownSystem.AddTextButton(filterInfo.text, set, level, filterInfo.hideMenuOnClick);
		elseif filterInfo.type == BW_FilterComponent.Checkbox then
			local set = function(_, _, _, value)
						filterInfo.set(value);
						if filterSystem.onUpdate then
							filterSystem.onUpdate();
						end
					end
			local isSet = function() return filterInfo.isSet(filterInfo.filter); end;
			BW_FilterDropDownSystem.AddCheckBoxButton(filterInfo.text, set, isSet, level, filterInfo.hideMenuOnClick);
		elseif filterInfo.type == BW_FilterComponent.Radio then
			local set = function(_, _, _, value)
						filterInfo.set(value);

						-- Only one radio button should be turned on at a time, force a refresh so the others can turn themselves off 
						if not filterInfo.hideMenuOnClick then
							BW_UIDropDownMenu_RefreshAll(BW_UIDropDownMenu_OPEN_MENU);
						end

						if filterSystem.onUpdate then
							filterSystem.onUpdate();
						end
					end
			local isSet = function() return filterInfo.isSet(filterInfo.filter); end;
			BW_FilterDropDownSystem.AddRadioButton(filterInfo.text, set, isSet, level, filterInfo.hideMenuOnClick);
		elseif filterInfo.type == BW_FilterComponent.DynamicFilterSet then
			-- Pass this function through since we may need it as well
			filterInfo.onUpdate = filterSystem.onUpdate;
			BW_FilterDropDownSystem.AddDynamicFilterSet(filterInfo, level);
		elseif filterInfo.type == BW_FilterComponent.Space then
			BW_FilterDropDownSystem.AddSpace(level);
		elseif filterInfo.type == BW_FilterComponent.Separator then
			BW_FilterDropDownSystem.AddSeparator(level);
		elseif filterInfo.type == BW_FilterComponent.Title then
			BW_FilterDropDownSystem.AddTitle(filterInfo.text, level);
		elseif filterInfo.type == BW_FilterComponent.Submenu and filterInfo.childrenInfo ~= nil then
			BW_FilterDropDownSystem.AddSubMenuButton(filterInfo.text, filterInfo.value, filterInfo.set, level);
		elseif filterInfo.type == BW_FilterComponent.CustomFunction then
			filterInfo.customFunc(filterSystem, level);
		end
	end
end

function BW_FilterDropDownSystem.AddTextButton(text, set, level, hideMenuOnClick)
	local textButtonInfo = {
		keepShownOnClick = not hideMenuOnClick,
		isNotRadio = true,
		notCheckable = true,
		func = set,
		text = text,
	};

	BW_UIDropDownMenu_AddButton(textButtonInfo, level);
end

function BW_FilterDropDownSystem.AddTextButtonToFilterSystem(filterSystem, text, set, level, hideMenuOnClick)
	local setWrapper = function(button, buttonName, down)
		set(button, buttonName, down);

		if filterSystem.onUpdate then
			filterSystem.onUpdate();
		end
	end

	BW_FilterDropDownSystem.AddTextButton(text, setWrapper, level, hideMenuOnClick);
end

function BW_FilterDropDownSystem.AddCheckBoxButton(text, setChecked, isChecked, level, hideMenuOnClick)
	local checkBoxInfo = {
		keepShownOnClick = not hideMenuOnClick,
		isNotRadio = true,
		text = text,
		func = setChecked,
		checked = isChecked,
	};

	BW_UIDropDownMenu_AddButton(checkBoxInfo, level);
end

function BW_FilterDropDownSystem.AddCheckBoxButtonToFilterSystem(filterSystem, text, setChecked, isChecked, level, hideMenuOnClick)
	local setCheckedWrapper = function(button, arg1, arg2, value)
		setChecked(button, arg1, arg2, value);

		if filterSystem.onUpdate then
			filterSystem.onUpdate();
		end
	end
	
	BW_FilterDropDownSystem.AddCheckBoxButton(text, setCheckedWrapper, isChecked, level, hideMenuOnClick);
end

function BW_FilterDropDownSystem.AddRadioButton(text, setSelected, isSelected, level, hideMenuOnClick)
	local radioButtonInfo = {
		keepShownOnClick = not hideMenuOnClick,
		text = text,
		func = setSelected,
		checked = isSelected,
	};

	BW_UIDropDownMenu_AddButton(radioButtonInfo, level);
end

function BW_FilterDropDownSystem.AddRadioButtonToFilterSystem(filterSystem, text, setSelected, isSelected, level, hideMenuOnClick)
	local setSelectedWrapper = function()
		setSelected();

		-- Only one radio button should be turned on at a time, force a refresh so the others can turn themselves off  
		if not hideMenuOnClick then
			BW_UIDropDownMenu_RefreshAll(BW_UIDropDownMenu_OPEN_MENU);
		end

		if filterSystem.onUpdate then
			filterSystem.onUpdate();
		end
	end
	BW_FilterDropDownSystem.AddRadioButton(text, setSelectedWrapper, isSelected, level, hideMenuOnClick);
end

function BW_FilterDropDownSystem.AddDynamicFilterSet(filterSetInfo, level)
	local numFilters = filterSetInfo.numFilters();
	local hasCustomOrder = not not filterSetInfo.customSortOrder;
	for i = 1, numFilters, 1 do
		local currIndex = not (hasCustomOrder and filterSetInfo.customSortOrder[i]) and i or filterSetInfo.customSortOrder[i].index;
		local validated = not filterSetInfo.filterValidation or filterSetInfo.filterValidation(currIndex);
		if validated then
			local function GetFilterName(currIndex)
				if filterSetInfo.nameFunction then
					return filterSetInfo.nameFunction(currIndex);
				end

				if filterSetInfo.globalPrepend then
					local offset = filterSetInfo.globalPrependOffset;
					local globalPrepend = filterSetInfo.globalPrepend .. (offset and offset + currIndex or currIndex);
					return _G[globalPrepend];
				end
				
				return "";
			end

			local name = GetFilterName(currIndex);
			if filterSetInfo.buttonType == BW_FilterComponent.TextButton then
				local set =	function()
							filterSetInfo.set();
							if filterSetInfo.onUpdate then
								filterSetInfo.onUpdate();
							end
						end					
				BW_FilterDropDownSystem.AddTextButton(name, set, level, filterSetInfo.hideMenuOnClick)
			else
				local isSet = function() return filterSetInfo.isSet(currIndex); end;
				if filterSetInfo.buttonType == BW_FilterComponent.Checkbox then
					local set =	function(_, _, _, value)
								filterSetInfo.set(currIndex, value);
								if filterSetInfo.onUpdate then
									filterSetInfo.onUpdate();
								end
							end
					BW_FilterDropDownSystem.AddCheckBoxButton(name, set, isSet, level, filterSetInfo.hideMenuOnClick);
				elseif filterSetInfo.buttonType == BW_FilterComponent.Radio then
					local set =	function(_, _, _, value)
								filterSetInfo.set(currIndex, value);
								if filterSetInfo.onUpdate then
									filterSetInfo.onUpdate();
								end
							
								-- Only one radio button should be turned on at a time, force a refresh so the others can turn themselves off 
								if not filterSetInfo.hideMenuOnClick then
									BW_UIDropDownMenu_RefreshAll(BW_UIDropDownMenu_OPEN_MENU);
								end
							end

					BW_FilterDropDownSystem.AddRadioButton(name, set, isSet, level, filterSetInfo.hideMenuOnClick);
				end
			end
		end
	end
end

function BW_FilterDropDownSystem.AddSpace(level)
	BW_UIDropDownMenu_AddButton(level);
end

function BW_FilterDropDownSystem.AddSeparator(level)
	BW_UIDropDownMenu_AddSeparator(level);
end

function BW_FilterDropDownSystem.AddTitle(text, level)
	local headerInfo = {
		isNotRadio = true,
		notCheckable = true,
		isTitle = true;
		text = text,
	};

	BW_UIDropDownMenu_AddButton(headerInfo, level);
end

function BW_FilterDropDownSystem.AddSubMenuButton(text, value, set, level)
	local subMenuInfo = {
		keepShownOnClick = true,
		hasArrow = true,
		notCheckable = true,
		func = set,
		text = text,
		value = value,
	};

	BW_UIDropDownMenu_AddButton(subMenuInfo, level)
end