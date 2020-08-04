-- Custom dropdown buttons are instantiated by some external system.
-- When calling UIDropDownMenu_AddButton that system sets info.customFrame to the instance of the frame it wants to place on the menu.
-- The dropdown menu creates its button for the entry as it normally would, but hides all elements.  The custom frame is then anchored
-- to that button and assumes responsibility for all relevant dropdown menu operations.
-- The hidden button will request a size that it should become from the custom frame.

BW_UIDropDownMenuButtonMixin = {}

function BW_UIDropDownMenuButtonMixin:OnEnter(...)
	ExecuteFrameScript(self:GetParent(), "OnEnter", ...);
end

function BW_UIDropDownMenuButtonMixin:OnLeave(...)
	ExecuteFrameScript(self:GetParent(), "OnLeave", ...);
end

function BW_UIDropDownMenuButtonMixin:OnMouseDown(button)
	if self:IsEnabled() then
		BW_ToggleDropDownMenu(nil, nil, self:GetParent());
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
	end
end

LargeBW_UIDropDownMenuButtonMixin = CreateFromMixins(BW_UIDropDownMenuButtonMixin);

function LargeBW_UIDropDownMenuButtonMixin:OnMouseDown(button)
	if self:IsEnabled() then
		local parent = self:GetParent();
		BW_ToggleDropDownMenu(nil, nil, parent, parent, -8, 8);
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
	end
end

BW_DropDownExpandArrowMixin = {};

function BW_DropDownExpandArrowMixin:OnEnter()
	local level =  self:GetParent():GetParent():GetID() + 1;

	BW_CloseDropDownMenus(level);

	if self:IsEnabled() then
		local listFrame = _G["BW_DropDownList"..level];
		if ( not listFrame or not listFrame:IsShown() or select(2, listFrame:GetPoint()) ~= self ) then
			BW_ToggleDropDownMenu(level, self:GetParent().value, nil, nil, nil, nil, self:GetParent().menuList, self);
		end
	end
end

function BW_DropDownExpandArrowMixin:OnMouseDown(button)
	if self:IsEnabled() then
		BW_ToggleDropDownMenu(self:GetParent():GetParent():GetID() + 1, self:GetParent().value, nil, nil, nil, nil, self:GetParent().menuList, self);
	end
end

BW_UIDropDownCustomMenuEntryMixin = {};

function BW_UIDropDownCustomMenuEntryMixin:GetPreferredEntryWidth()
	-- NOTE: Only width is currently supported, dropdown menus size vertically based on how many buttons are present.
	return self:GetWidth();
end

function BW_UIDropDownCustomMenuEntryMixin:OnSetOwningButton()
	-- for derived objects to implement
end

function BW_UIDropDownCustomMenuEntryMixin:SetOwningButton(button)
	self:SetParent(button:GetParent());
	self.owningButton = button;
	self:OnSetOwningButton();
end

function BW_UIDropDownCustomMenuEntryMixin:GetOwningDropdown()
	return self.owningButton:GetParent();
end

function BW_UIDropDownCustomMenuEntryMixin:SetContextData(contextData)
	self.contextData = contextData;
end

function BW_UIDropDownCustomMenuEntryMixin:GetContextData()
	return self.contextData;
end
