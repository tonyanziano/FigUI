FigResourceWarriorMixin = {}

FigResourceWarriorMixin.powerType = 'RAGE'

local rageColor = PowerBarColor[Enum.PowerType.Rage]

function FigResourceWarriorMixin.doInitialDraw(frame)
  local playerFrame = _G['FigPlayer']
  if not frame:IsUserPlaced() then
    frame:ClearAllPoints()
    frame:SetPoint('TOPLEFT', playerFrame, 'BOTTOMLEFT', 0, -1)
  end
  frame:SetWidth(playerFrame:GetWidth())
  frame:SetHeight(15)
  frame:SetStatusBarColor(rageColor.r, rageColor.g, rageColor.b, 1)
  local rage, maxRage = UnitPower('player', Enum.PowerType.Rage), UnitPowerMax('player', Enum.PowerType.Rage)
  frame:SetMinMaxValues(rage, maxRage)
  frame:SetValue(rage)
  Fig.drawOutsetBordersForFrame(frame)
  frame.text:SetText(rage)
end

function FigResourceWarriorMixin.updateResource(frame)
  local rage = UnitPower('player', Enum.PowerType.Rage)
  frame:SetValue(rage)
  frame.text:SetText(rage)
end

local function onEvent(frame, event, ...)
  if event == 'PLAYER_TALENT_UPDATE' then
    frame:doInitialDraw()
  end
end

function FigResourceWarriorMixin.initializeWarriorResourceBar(frame)
  frame:RegisterEvent('PLAYER_TALENT_UPDATE')
  frame:HookScript('OnEvent', onEvent)
end
