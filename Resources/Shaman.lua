FigResourceShamanMixin = {}

FigResourceShamanMixin.powerType = 'MAELSTROM'

local maelstromColor = PowerBarColor[Enum.PowerType.Maelstrom]

function FigResourceShamanMixin.doInitialDraw(frame)
  local currentSpec = GetSpecialization()
  if currentSpec then
    local _, currentSpecName = GetSpecializationInfo(currentSpec)
    if currentSpecName == 'Elemental' then
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
  frame:SetStatusBarColor(maelstromColor.r, maelstromColor.g, maelstromColor.b, 1)
  local maelstrom, maxMaelstrom = UnitPower('player', Enum.PowerType.Maelstrom), UnitPowerMax('player', Enum.PowerType.Maelstrom)
  frame:SetMinMaxValues(maelstrom, maxMaelstrom)
  frame:SetValue(maelstrom)
  Fig.drawOutsetBordersForFrame(frame)
  frame.text:SetText(maelstrom)
end

function FigResourceShamanMixin.updateResource(frame)
  local maelstrom = UnitPower('player', Enum.PowerType.Maelstrom)
  frame:SetValue(maelstrom)
  frame.text:SetText(maelstrom)
end

local function onEvent(frame, event, ...)
  if event == 'PLAYER_TALENT_UPDATE' then
    frame:doInitialDraw()
  end
end

function FigResourceShamanMixin.initializeShamanResourceBar(frame)
  frame:RegisterEvent('PLAYER_TALENT_UPDATE')
  frame:HookScript('OnEvent', onEvent)
end
