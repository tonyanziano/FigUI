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
    local percentHp = format('%i', tostring(hp / maxHp * 100))
    local shortHp = Fig.prettyPrintNumber(hp)
    frame.hp.text:SetText(format('%s - %s%%', shortHp, percentHp))
    frame.hp:SetValue(percentHp)
  end
end

function FigPlayer.updatePower(frame, unit)
  if unit == 'player' then
    local power, maxPower = UnitPower(unit), UnitPowerMax(unit)
    local percentPower = format('%i', tostring(power / maxPower * 100))
    local shortPower = Fig.prettyPrintNumber(power)
    frame.power.text:SetText(format('%s - %s%%', shortPower, percentPower))
    frame.power:SetValue(percentPower)
  end
end

function FigPlayer.colorHp(frame)
  local _, class = UnitClass('player')
  local classColor = C_ClassColor.GetClassColor(class)
  frame.hp:SetStatusBarColor(classColor.r, classColor.g, classColor.b, 1)
end

function FigPlayer.colorPower(frame)
  local _, powerToken = UnitPowerType('player')
  local powerColor = powerBarColors[powerToken]
  if not powerColor then
    -- fall back to mana color
    powerColor = powerBarColors['MANA']
  end
  frame.power:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b, 1)
end

function FigPlayer.updatePlayerInfo(frame)
  local name, level = UnitName('player'), UnitLevel('player')
  frame.hp.playerInfo:SetText(format('%s %s', level, name))
end

function FigPlayer.updateCombatState(frame)
  frame.hp.combat:SetShown(UnitAffectingCombat('player'))
end

function FigPlayer.updateRestingState(frame)
  frame.hp.resting:SetShown(IsResting())
end

function FigPlayer.updateFrame(frame)
  FigPlayer.updateHp(frame, 'player')
  FigPlayer.updatePower(frame, 'player')
  FigPlayer.updatePlayerInfo(frame)
  FigPlayer.updateCombatState(frame)
  FigPlayer.updateRestingState(frame)
end

function FigPlayer.handleEvents(frame, event, ...)
  if event == 'UNIT_HEALTH' then
    FigPlayer.updateHp(frame, ...)
  end

  if event == 'UNIT_POWER_UPDATE' then
    FigPlayer.updatePower(frame, ...)
  end

  if event == 'PLAYER_LEVEL_CHANGED' then
    FigPlayer.updatePlayerInfo(frame)
  end

  if event == 'PLAYER_REGEN_DISABLED' or event == 'PLAYER_REGEN_ENABLED' then
    FigPlayer.updateCombatState(frame)
  end

  if event == 'PLAYER_UPDATE_RESTING' then
    FigPlayer.updateRestingState(frame)
  end

  if event == 'PLAYER_ENTERING_WORLD' then
    FigPlayer.updateFrame(frame)
  end
end

function FigPlayer.initialize(frame)
  -- register for events
  frame:RegisterEvent('UNIT_HEALTH')
  frame:RegisterEvent('UNIT_POWER_UPDATE')
  frame:RegisterEvent('PLAYER_LEVEL_CHANGED')
  frame:RegisterEvent('PLAYER_REGEN_DISABLED')
  frame:RegisterEvent('PLAYER_REGEN_ENABLED')
  frame:RegisterEvent('PLAYER_UPDATE_RESTING')
  frame:RegisterEvent('PLAYER_ENTERING_WORLD')
  frame:SetScript('OnEvent', FigPlayer.handleEvents)

  PlayerFrame:Hide()

  -- initial draw
  -- TODO: make this respect the user's frame positioning
  frame:SetPoint('CENTER', UIParent, 'CENTER', -200, -240)
  FigPlayer.colorHp(frame)
  FigPlayer.colorPower(frame)
  FigPlayer.updateFrame(frame)
end
