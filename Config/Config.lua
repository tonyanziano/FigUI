-- placeholder
local panel = CreateFrame('FRAME', 'FigConfigPanel', UIParent, 'BackdropTemplate')
panel.name = "Fig UI"
panel.okay = function ()
  print('okay pressed')
end
panel.cancel = function ()
  print('cancel pressed')
end
panel.default = function ()
  print('default pressed')
end
InterfaceOptions_AddCategory(panel)

local checkBox = CreateFrame('CheckButton', nil, panel, 'ChatConfigCheckButtonTemplate')
checkBox:SetPoint('TOPLEFT', panel, 'TOPLEFT', 4, 4)

local btn = CreateFrame('Button', nil, panel, 'OptionsButtonTemplate')
btn:SetText('push me')
btn:SetPoint('TOPLEFT', panel, 'TOPLEFT', 8, 8)