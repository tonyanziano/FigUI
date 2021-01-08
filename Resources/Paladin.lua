FigPaladin = {}

FigPaladin.showTicks = true

function FigPaladin.drawTicks(frame)
  local frameWidth = frame:GetWidth()
  local numTicks = 4
  local tickWidth = 2
  for i=1, numTicks do
    -- create a texture for each tick and place into overlay layer
    local tick = frame.status:CreateTexture(nil, 'OVERLAY')
    tick:SetColorTexture(1, 1, 1, 1)
    tick:SetHeight(frame:GetHeight())
    tick:SetWidth(2)
    tick:SetPoint('LEFT', frame, 'LEFT', i * (frameWidth / (numTicks + 1)) - (tickWidth / 2), 0)
  end
end

function FigPaladin.updateHolyPower(frame)
  local holyPower = UnitPower('player', 9) -- 9 is the enum for holy power
  frame.status:SetValue(holyPower)
  frame.status.text:SetText('' .. holyPower)
end

function FigPaladin.handleEvents(frame, event, ...)
  if event == 'UNIT_POWER_UPDATE' then
    local unitId, powerType = ...
    if unitId == 'player' and powerType == 'HOLY_POWER' then
      FigPaladin.updateHolyPower(frame)
    end
  end
end

function FigPaladin.initialize(frame)
  -- register for events
  frame:RegisterEvent('UNIT_POWER_UPDATE')
  frame:SetScript('OnEvent', FigPaladin.handleEvents)

  -- do initial draw
  FigPaladin.drawTicks(frame)
  FigPaladin.updateHolyPower(frame)
end