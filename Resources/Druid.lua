FigResourceDruidMixin = {}

FigResourceDruidMixin.powerType = 'LUNAR_POWER'

local lunarPowerColor = PowerBarColor[Enum.PowerType.LunarPower]

function FigResourceDruidMixin.doInitialDraw(frame)
  -- size the arcane charges bar based on the player frame
  local playerFrame = _G['FigPlayer']
  local frameWidth, frameHeight = playerFrame:GetWidth(), 15
  frame:SetWidth(frameWidth)
  frame:SetHeight(frameHeight)
  frame:SetStatusBarColor(lunarPowerColor.r, lunarPowerColor.g, lunarPowerColor.b, 1)
  local lunarPower, maxLunarPower = UnitPower('player', Enum.PowerType.LunarPower), UnitPowerMax('player', Enum.PowerType.LunarPower)
  frame:SetMinMaxValues(lunarPower, maxLunarPower)
  frame:SetValue(lunarPower)
  frame.text:SetText(lunarPower)
  Fig.drawOutsetBordersForFrame(frame)
  if not frame:IsUserPlaced() then
    frame:ClearAllPoints()
    frame:SetPoint('TOPLEFT', playerFrame, 'BOTTOMLEFT', 0, -1)
  end

  local currentSpec = GetSpecialization()
  if currentSpec then
    local _, currentSpecName = GetSpecializationInfo(currentSpec)
    if currentSpecName == 'Balance' then
      frame:Show()
    else
      frame:Hide()
    end
  else
    frame:Hide()
  end
end

function FigResourceDruidMixin.updateLunarPower(frame)
  local lunarPower = UnitPower('player', Enum.PowerType.LunarPower)
  frame:SetValue(lunarPower)
  frame.text:SetText(lunarPower)
end

function FigResourceDruidMixin.updateResource(frame)
  local currentSpec = GetSpecialization()
  if currentSpec then
    local _, currentSpecName = GetSpecializationInfo(currentSpec)
    if currentSpecName == 'Balance' then
      frame:updateLunarPower()
      frame:Show()
    else
      frame:Hide()
    end
  else
    frame:Hide()
  end
end

local function onEvent(frame, event, ...)
  if event == 'PLAYER_TALENT_UPDATE' then
    frame:doInitialDraw()
  end
end

function FigResourceDruidMixin.initializeDruidResourceBar(frame)
  frame:RegisterEvent('PLAYER_TALENT_UPDATE')
  frame:HookScript('OnEvent', onEvent)
end
