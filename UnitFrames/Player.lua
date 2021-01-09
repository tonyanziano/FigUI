FigPlayer = {}

local powerBarColors = {
  ['MANA'] = {
    r = 19/255,
    g = 69/255,
    b = 145/255
  },
  ['RAGE'] = {
    r = 156/255,
    g = 39/255,
    b = 39/255
  },
  ['FOCUS'] = {
    r = 222/255,
    g = 145/255,
    b = 44/255
  },
  ['ENERGY'] = {
    r = 232/255,
    g = 225/255,
    b = 19/255
  },
  ['RUNIC_POWER'] = {
    r = 77/255,
    g = 137/255,
    b = 227/255
  }
}

function FigPlayer.updateHp(frame, unit)
  if unit == 'player' then
    local hp, maxHp = UnitHealth(unit), UnitHealthMax(unit)
    if hp >= 1000 then
      -- do conversion to shorter syntax (eg. 4700 = 4.7k)
      local shortHp = format('%.2f', tostring(hp / 1000)) .. 'k'
      local shortMaxHp = format('%.2f', tostring(maxHp / 1000)) .. 'k'
      frame.hp.text:SetText(shortHp .. ' / '.. shortMaxHp)
    else
      frame.hp.text:SetText(hp .. ' / '.. maxHp)
    end
    frame.hp:SetValue(hp / maxHp * 100)
  end
end

function FigPlayer.updatePower(frame, unit)
  if unit == 'player' then
    local power, maxPower = UnitPower(unit), UnitPowerMax(unit)
    if power >= 1000 then
      -- do conversion to shorter syntax (eg. 4700 = 4.7k)
      local shortPower = format('%.2f', tostring(power / 1000)) .. 'k'
      local shortMaxPower = format('%.2f', tostring(maxPower / 1000)) .. 'k'
      frame.power.text:SetText(shortPower .. ' / '.. shortMaxPower)
    else
      frame.power.text:SetText(power .. ' / '.. maxPower)
    end
    frame.power:SetValue(power / maxPower * 100)
  end
end

function FigPlayer.colorHp(frame, unit)
  local class = UnitClass('player')
  local classColor = C_ClassColor.GetClassColor(class)
  frame.hp:SetStatusBarColor(classColor.r, classColor.g, classColor.b, 1)
end

function FigPlayer.colorPower(frame, unit)
  local powerToken = 'MANA'
  --local _, powerToken = UnitPowerType(unit);
  local powerColor = powerBarColors[powerToken];
  if not powerColor then
    -- fall back to mana color
    powerColor = powerBarColors['MANA']
  end
  frame.power:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b, 1)
end

function FigPlayer.handleEvents(frame, event, ...)
  if event == 'UNIT_HEALTH' then
    FigPlayer.updateHp(frame, ...)
  end

  if event == 'UNIT_POWER_UPDATE' then
    FigPlayer.updatePower(frame, ...)
  end
end

function FigPlayer.initialize(frame)
  -- register for events
  frame:RegisterEvent('UNIT_HEALTH')
  frame:RegisterEvent('UNIT_POWER_UPDATE')
  frame:SetScript('OnEvent', FigPlayer.handleEvents)

  -- initial draw
  local player = 'player'
  FigPlayer.colorHp(frame, 'player')
  FigPlayer.colorPower(frame, 'player')
  FigPlayer.updateHp(frame, 'player')
  FigPlayer.updatePower(frame, 'player')
end
