FigToT = {}

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
  r = 37/255,
  g = 143/255,
  b = 16/255
}

local function truncateString(str)
  if string.len(str) >= 4 then
    return string.sub(str, 1, 4) .. '...'
  end
  return str
end

function FigToT.updateHp(frame, unit)
  if unit == 'targettarget' then
    local hp, maxHp = UnitHealth(unit), UnitHealthMax(unit)
    local percentHp = format('%i', tostring(hp / maxHp * 100))
    local shortHp = Fig.prettyPrintNumber(hp)
    frame.hp.text:SetText(format('%s - %s%%', shortHp, percentHp))
    frame.hp:SetValue(percentHp)
  end
end

function FigToT.updatePower(frame, unit)
  if unit == 'targettarget' then
    local power, maxPower = UnitPower(unit), UnitPowerMax(unit)
    if maxPower == 0 then
      -- handle the case of 0 / 0 power
      frame.power.text:SetText('N/A')
      frame.power:SetValue(0)
      return
    end
    local percentPower = format('%i', tostring(power / maxPower * 100))
    local shortPower = Fig.prettyPrintNumber(power)
    frame.power.text:SetText(format('%s - %s%%', shortPower, percentPower))
    frame.power:SetValue(percentPower)
  end
end

function FigToT.colorHp(frame, unit)
  local _, class = UnitClass('targettarget')
  local classColor
  if class then 
    classColor = C_ClassColor.GetClassColor(class)
    if not classColor then
      classColor = noClassHpColor
    end
  else
    classColor = noClassHpColor
  end
  frame.hp:SetStatusBarColor(classColor.r, classColor.g, classColor.b, 1)
end

function FigToT.colorPower(frame, unit)
  local _, powerToken = UnitPowerType(unit)
  local powerColor = powerBarColors[powerToken]
  if not powerColor then
    -- fall back to mana color
    powerColor = powerBarColors['MANA']
  end
  frame.power:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b, 1)
end

function FigToT.updatePlayerInfo(frame)
  local name = UnitName('targettarget')
  name = truncateString(name)
  frame.hp.playerInfo:SetText(name)
end

function FigToT.updateFrame(frame)
  if UnitExists('targettarget') then
    FigToT.colorHp(frame, 'targettarget')
    FigToT.colorPower(frame, 'targettarget')
    FigToT.updateHp(frame, 'targettarget')
    FigToT.updatePower(frame, 'targettarget')
    FigToT.updatePlayerInfo(frame)
  end
end

local tickRate = 0.4
local totalElapsed = 0
function FigToT.handleUpdate(frame, elapsed)
  totalElapsed = totalElapsed + elapsed
  if totalElapsed >= tickRate then
    FigToT.updateFrame(frame)
    totalElapsed = 0
  end
end

function FigToT.handleEvents(frame, event, ...)
  if not frame:IsShown() then
    return
  end

  if event == 'PLAYER_ENTERING_WORLD' then
    FigToT.updateFrame(frame)
  end

  if event == 'PLAYER_TARGET_CHANGED' then
    FigToT.updateFrame(frame)
  end
end

function FigToT.initialize(frame)
  -- register for events
  frame:RegisterEvent('PLAYER_ENTERING_WORLD')
  frame:RegisterEvent('PLAYER_TARGET_CHANGED')
  frame:SetScript('OnEvent', FigToT.handleEvents)
  frame:SetScript('OnUpdate', FigToT.handleUpdate)
end

function FigToT.onShow(frame)
  FigToT.updateFrame(frame)
end