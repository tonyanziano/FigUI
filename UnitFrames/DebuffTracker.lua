local maxNumberOfDebuffs = 8
local measuringFrame = CreateFrame('frame', 'FigAuraTimerTemplateMeasuringFrame', UIParent, 'FigAuraTimerTemplate')
measuringFrame:Hide()

local function drawAuras(frame)
  for i = 1, maxNumberOfDebuffs do
    local timer = _G['FigAuraTimer' .. i]
    local name, icon, _, debuffType, duration, expirationTime, source = UnitDebuff('target', i)

    if name ~= nil and source == 'player' then
      -- draw the timer
      timer.icon.tex:SetTexture(icon)
      if debuffType ~= nil then
        local debuffTypeColor = FigDebuffTypeColors[debuffType]
        timer.progress:SetStatusBarColor(debuffTypeColor.r, debuffTypeColor.g, debuffTypeColor.b, debuffTypeColor.a)
      else
        local debuffTypeColor = FigDebuffTypeColors['Generic']
        timer.progress:SetStatusBarColor(debuffTypeColor.r, debuffTypeColor.g, debuffTypeColor.b, debuffTypeColor.a)
      end
      -- pass this information to the timer and let it draw itself
      timer.duration = duration
      timer.expirationTime = expirationTime
      timer:Show()
    else
      -- hide the timer
      timer:Hide()
    end
  end
end

local function onEvent(frame, event, ...)
  if event == 'UNIT_AURA' then
    drawAuras(frame)
  end
  if event == 'PLAYER_TARGET_CHANGED' then
    drawAuras(frame)
  end
end

local function initialize(frame)
  -- draw the container
  local containerWidth = _G['FigPlayer']:GetWidth()
  local timerHeight = measuringFrame:GetHeight()
  frame:SetHeight(maxNumberOfDebuffs * timerHeight)
  frame:SetWidth(containerWidth)

  -- do the initial draw of the debuff timers
  for i = 1, maxNumberOfDebuffs do
    local yOffset = (i - 1) * timerHeight
    local timer = _G['FigAuraTimer' .. i] or CreateFrame('frame', 'FigAuraTimer' .. i, UIParent, 'FigAuraTimerTemplate')
    timer:SetPoint('BOTTOMLEFT', frame, 'BOTTOMLEFT', 0, yOffset)
    timer.progress:SetWidth(containerWidth - measuringFrame.icon:GetWidth())
  end

  -- listen for events to redraw the timers
  frame:SetScript('OnEvent', onEvent)
  frame:RegisterEvent('PLAYER_TARGET_CHANGED');
  frame:RegisterEvent('UNIT_AURA');
end

FigPlayerDebuffTrackerMixin = {
  initialize = initialize
}