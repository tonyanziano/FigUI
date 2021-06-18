local maxNumberOfDebuffs = 8
local timerHeight = 25 -- TODO: get this at runtime
local timerWidth = 100 -- TODO: get this at runtime

local function drawAuras(frame)
  for i = 1, maxNumberOfDebuffs do
    local timer = _G['FigAuraTimer' .. i] or CreateFrame('frame', 'FigAuraTimer' .. i, UIParent, 'FigAuraTimerTemplate')
    local name, icon, _, _, duration, expirationTime, source = UnitDebuff('target', i)

    if name ~= nil and source == 'player' then
      -- draw the timer
      timer.icon.tex:SetTexture(icon)
      if expirationTime > 0 then
        -- pass this information to the timer and let it draw itself
        timer.duration = duration
        timer.expirationTime = expirationTime
      end
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
  frame:SetHeight(maxNumberOfDebuffs * timerHeight)
  frame:SetWidth(timerWidth)

  -- do the initial draw of the debuff timers
  for i = 1, maxNumberOfDebuffs do
    local yOffset = (i - 1) * timerHeight
    local timer = _G['FigAuraTimer' .. i] or CreateFrame('frame', 'FigAuraTimer' .. i, UIParent, 'FigAuraTimerTemplate')
    timer:SetPoint('BOTTOMLEFT', frame, 'BOTTOMLEFT', 0, yOffset)
  end

  -- listen for events to redraw the timers
  frame:SetScript('OnEvent', onEvent)
  frame:RegisterEvent('PLAYER_TARGET_CHANGED');
  frame:RegisterEvent('UNIT_AURA');
end

FigPlayerDebuffTrackerMixin = {
  initialize = initialize
}