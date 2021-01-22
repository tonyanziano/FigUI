FigPaladin = {}

FigPaladin.showSeparators = true

function FigPaladin.drawSeparators(frame)
  local frameWidth = frame:GetWidth()
  local numSeparators = 4
  local separatorWidth = 2
  for i=1, numSeparators do
    -- create a texture for each separator and place into overlay layer
    local separator = frame:CreateTexture(nil, 'OVERLAY')
    separator:SetColorTexture(0, 0, 0, 1)
    separator:SetHeight(frame:GetHeight())
    separator:SetWidth(2)
    separator:SetPoint('LEFT', frame, 'LEFT', i * (frameWidth / (numSeparators + 1)) - (separatorWidth / 2), 0)
  end
end

function FigPaladin.updateHolyPower(frame)
  local holyPower = UnitPower('player', 9) -- 9 is the enum for holy power
  frame:SetValue(holyPower)
  frame.text:SetText('' .. holyPower)
end

function FigPaladin.handleEvents(frame, event, ...)
  if event == 'UNIT_POWER_UPDATE' then
    local unitId, powerType = ...
    if unitId == 'player' and powerType == 'HOLY_POWER' then
      FigPaladin.updateHolyPower(frame)
    end
  end

  if event == 'PLAYER_ENTERING_WORLD' then
    FigPaladin.updateHolyPower(frame)
  end
end

function FigPaladin.initialize(frame)
  -- register for events
  frame:RegisterEvent('UNIT_POWER_UPDATE')
  frame:RegisterEvent('PLAYER_ENTERING_WORLD')
  frame:SetScript('OnEvent', FigPaladin.handleEvents)

  -- do initial draw
  FigPaladin.drawSeparators(frame)
  FigPaladin.updateHolyPower(frame)
end