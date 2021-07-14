-- placeholder
local panel = CreateFrame('frame', 'FigConfigPanel', UIParent, 'BackdropTemplate')
panel.name = "Fig UI"
panel.okay = function ()
  -- save changes
end
panel.cancel = function ()
  -- discard changes?
end
InterfaceOptions_AddCategory(panel)

panel.lastControl = nil
local panelHorizontalPadding = 4

-- onToggle: function (self, checked)
function addCheckbox(label, onToggle)
  local checkBoxVertPadding = 4
  local checkBox = CreateFrame('CheckButton', 'figcheck', panel, 'ChatConfigCheckButtonTemplate')
  checkBox.Text:SetText(label)
  checkBox.Text:SetPoint('LEFT', checkBox, 'RIGHT')
  checkBox.func = onToggle
  --checkBox.tooltip -- can define this to add a tooltip

  if panel.lastControl then
    -- set position relative to last control
    checkBox:SetPoint('TOPLEFT', panel.lastControl, 'BOTTOMLEFT', 0, -checkBoxVertPadding)
  else
    -- set position relative to top of panel
    checkBox:SetPoint('TOPLEFT', panel, 'TOPLEFT', panelHorizontalPadding, -checkBoxVertPadding)
  end
  panel.lastControl = checkBox;
end
addCheckbox('Borders')

-- local btn = CreateFrame('Button', nil, panel, 'OptionsButtonTemplate')
-- btn:SetText('push me')
-- btn:SetPoint('TOPLEFT', panel, 'TOPLEFT')