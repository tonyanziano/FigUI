FigTarget = {}

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

local noClassHpColor = {
  r = 1/255,
  g = 1/255,
  b = 1/255
}

function FigTarget.updateHp(frame, unit)
  if unit == 'target' then
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

function FigTarget.updatePower(frame, unit)
  if unit == 'target' then
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

function FigTarget.colorHp(frame, unit)
  local _, class = UnitClass('target')
  local classColor = C_ClassColor.GetClassColor(class)
  if not classColor then
    classColor = noClassHpColor
  end
  frame.hp:SetStatusBarColor(classColor.r, classColor.g, classColor.b, 1)
end

function FigTarget.colorPower(frame, unit)
  local _, powerToken = UnitPowerType(unit)
  local powerColor = powerBarColors[powerToken]
  if not powerColor then
    -- fall back to mana color
    powerColor = powerBarColors['MANA']
  end
  frame.power:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b, 1)
end

function FigTarget.updatePlayerInfo(frame)
  local name, level = UnitName('target'), UnitLevel('target')
  if level == -1 then
    level = '??'
  end
  frame.hp.playerInfo:SetText(format('%s %s', level, name))
end

function FigTarget.updateFrame(frame)
  FigTarget.colorHp(frame, 'target')
  FigTarget.colorPower(frame, 'target')
  FigTarget.updateHp(frame, 'target')
  FigTarget.updatePower(frame, 'target')
  FigTarget.updatePlayerInfo(frame)
end

function FigTarget.handleEvents(frame, event, ...)
  if not frame:IsShown() then
    return
  end

  if event == 'UNIT_HEALTH' then
    FigTarget.updateHp(frame, ...)
  end

  if event == 'UNIT_POWER_UPDATE' then
    FigTarget.updatePower(frame, ...)
  end

  if event == 'PLAYER_ENTERING_WORLD' then
    FigTarget.updateFrame(frame)
  end

  if event == 'PLAYER_TARGET_CHANGED' and UnitExists('target') then
    FigTarget.updateFrame(frame)
  end
end

function FigTarget.initialize(frame)
  -- register for events
  frame:RegisterEvent('UNIT_HEALTH')
  frame:RegisterEvent('UNIT_POWER_UPDATE')
  frame:RegisterEvent('PLAYER_LEVEL_CHANGED')
  frame:RegisterEvent('PLAYER_ENTERING_WORLD')
  frame:RegisterEvent('PLAYER_TARGET_CHANGED')
  frame:SetScript('OnEvent', FigTarget.handleEvents)

  -- TargetFrame:Hide()
end

function FigTarget.onShow(frame)
  FigTarget.updateFrame(frame)
end