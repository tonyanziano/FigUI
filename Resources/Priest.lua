FigResourcePriestMixin = {}

FigResourcePriestMixin.powerType = 'INSANITY'

local insanityColor = PowerBarColor[Enum.PowerType.Insanity]

function FigResourcePriestMixin.doInitialDraw(frame)
  local currentSpec = GetSpecialization()
  if currentSpec then
    local _, currentSpecName = GetSpecializationInfo(currentSpec)
    if currentSpecName == 'Shadow' then
      frame:Show()
    else
      frame:Hide()
      return
    end
  else
    frame:Hide()
    return
  end

  local playerFrame = _G['FigPlayer']
  if not frame:IsUserPlaced() then
    frame:ClearAllPoints()
    frame:SetPoint('TOPLEFT', playerFrame, 'BOTTOMLEFT', 0, -1)
  end
  frame:SetWidth(playerFrame:GetWidth())
  frame:SetHeight(15)
  frame:SetStatusBarColor(insanityColor.r, insanityColor.g, insanityColor.b, 1)
  local insanity, maxInsanity = UnitPower('player', Enum.PowerType.Insanity), UnitPowerMax('player', Enum.PowerType.Insanity)
  frame:SetMinMaxValues(insanity, maxInsanity)
  frame:SetValue(insanity)
  Fig.drawOutsetBordersForFrame(frame)
  frame.text:SetText(insanity)
end

function FigResourcePriestMixin.updateResource(frame)
  local insanity = UnitPower('player', Enum.PowerType.Insanity)
  frame:SetValue(insanity)
  frame.text:SetText(insanity)
end

local function onEvent(frame, event, ...)
  if event == 'PLAYER_TALENT_UPDATE' then
    frame:doInitialDraw()
  end
end

function FigResourcePriestMixin.initializePriestResourceBar(frame)
  frame:RegisterEvent('PLAYER_TALENT_UPDATE')
  frame:HookScript('OnEvent', onEvent)
end
