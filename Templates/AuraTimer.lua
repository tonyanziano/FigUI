local tickRate = 0.1
local function tick(frame, elapsed)
  frame.timeSinceLastTick = frame.timeSinceLastTick + elapsed

  if frame.timeSinceLastTick >= tickRate then
    if frame.expirationTime > 0 then
      -- update the timer
      local timeRemaining = frame.expirationTime - GetTime()
      frame.progress:SetMinMaxValues(0, frame.duration)
      frame.progress:SetValue(timeRemaining)

      -- display an integer until the final 10 seconds
      local timeRemainingText
      if timeRemaining >= 10 then
        timeRemainingText = format('%i', tostring(timeRemaining))
      else
        timeRemainingText = format('%.1f', tostring(timeRemaining))
      end
      frame.progress.text:SetText(timeRemainingText)
    else
      -- it is a permanent debuff like talented Corruption for warlocks
      frame.progress:SetMinMaxValues(0, 1)
      frame.progress:SetValue(1)
      frame.progress.text:SetText('')
    end

    frame.timeSinceLastTick = 0
  end
end

local function initialize(frame)
  frame.totalElapsed = 0
  frame.timeSinceLastTick = 0
  frame:SetScript('OnUpdate', tick)
end

FigAuraTimerTemplateMixin = {
  initialize = initialize
}