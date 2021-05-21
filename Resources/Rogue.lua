FigRogue = {}

function FigRogue.drawSeparators(frame)
  local frameWidth = frame.comboPoints:GetWidth()
  local numSeparators = 4
  local separatorWidth = 2
  for i=1, numSeparators do
    -- create a texture for each separator and place into overlay layer
    local separator = frame.comboPoints:CreateTexture(nil, 'OVERLAY')
    separator:SetColorTexture(0, 0, 0, 1)
    separator:SetHeight(frame.comboPoints:GetHeight())
    separator:SetWidth(separatorWidth)
    separator:SetPoint('LEFT', frame.comboPoints, 'LEFT', i * (frameWidth / (numSeparators + 1)) - (separatorWidth / 2), 0)
  end
end

function FigRogue.updateEnergy(frame)
  local energy = UnitPower('player', Enum.PowerType.Energy)
  local maxEnergy = UnitPowerMax('player', Enum.PowerType.Energy)
  frame.energy:SetValue(energy)
  frame.energy:SetMinMaxValues(0, maxEnergy);
  frame.energy.text:SetText(energy)
end

function FigRogue.updateComboPoints(frame)
  local comboPoints = UnitPower('player', Enum.PowerType.ComboPoints)
  frame.comboPoints:SetValue(comboPoints)
  frame.comboPoints.text:SetText(comboPoints)
end

function FigRogue.updateResources(frame)
  FigRogue.updateEnergy(frame)
  FigRogue.updateComboPoints(frame)
end

function FigRogue.initialize(frame)
  FigRogue.drawSeparators(frame);
  -- register for events
  frame:SetScript('OnUpdate', FigRogue.updateResources)
end
