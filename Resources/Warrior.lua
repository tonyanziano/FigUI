FigResourceWarriorMixin = {}

FigResourceWarriorMixin.powerType = 'RAGE'

function FigResourceWarriorMixin.doInitialDraw(frame)
  local playerFrame = _G['FigPlayer']
  if not frame:IsUserPlaced() then
    frame:ClearAllPoints()
    frame:SetPoint('TOPLEFT', playerFrame, 'BOTTOMLEFT', 0, -1)
  end
  frame:SetWidth(playerFrame:GetWidth())
  frame:SetHeight(15)
  local rage, maxRage = UnitPower('player', Enum.PowerType.Rage), UnitPowerMax('player', Enum.PowerType.Rage)
  frame:SetMinMaxValues(rage, maxRage)
  frame:SetValue(rage)
  Fig.drawOutsetBordersForFrame(frame)
  frame.text:SetText(rage)
end

function FigResourceWarriorMixin.updateResource(frame)
  local rage, maxRage = UnitPower('player', Enum.PowerType.Rage), UnitPowerMax('player', Enum.PowerType.Rage)
  frame:SetValue(rage)
  frame.text:SetText(rage)
end
