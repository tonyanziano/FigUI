FigRogue = {}

function FigRogue.updateEnergy(frame)
  local energy = UnitPower('player', Enum.PowerType.Energy)
  local maxEnergy = UnitPowerMax('player', Enum.PowerType.Energy)
  frame.status:SetValue(energy)
  frame.status:SetMinMaxValues(0, maxEnergy);
  frame.status.text:SetText(energy)
end

function FigRogue.initialize(frame)

  -- register for events
  frame:SetScript('OnUpdate', FigRogue.updateEnergy)
end
