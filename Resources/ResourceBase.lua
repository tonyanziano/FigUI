FigResourceBaseMixin = {}

-- Resource frames must implement doInitialDraw() and updateResource()
local function onEvent(frame, event, ...)
  if event == 'PLAYER_ENTERING_WORLD' then
    frame:doInitialDraw()
  end
  if event == 'UNIT_POWER_FREQUENT' then
    local _, powerType = ...
    if powerType == frame.powerType then
      frame:updateResource()
    end
  end
end

function FigResourceBaseMixin.initialize(frame)
  print('initializing ', frame:GetName())
  frame:SetScript('OnEvent', onEvent)
  frame:RegisterUnitEvent('UNIT_POWER_FREQUENT', 'player')
  frame:RegisterEvent('PLAYER_ENTERING_WORLD')
end
