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
    local percentHp = format('%i', tostring(hp / maxHp * 100))
    local shortHp = Fig.prettyPrintNumber(hp)
    frame.hp.text:SetText(format('%s - %s%%', shortHp, percentHp))
    frame.hp:SetValue(percentHp)
  end
end

function FigTarget.updatePower(frame, unit)
  if unit == 'target' then
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

local maxNumAuras = 40
local aurasPerRow = 10

function FigTarget.updateAuras(frame)
  local auraWidth, auraHeight
  -- draw buffs
  frame.numBuffRows = nil
  for i = 1, maxNumAuras / 2 do
    local name, icon, count, debuffType, duration, expirationTime, source, isStealable,
      nameplateShowPersonal, spellId = UnitBuff('target', i)
    local f = _G['FigTargetBuff' .. i] or CreateFrame('Frame', 'FigTargetBuff' .. i, frame, 'FigTargetBuffTemplate')
    if name then
      if not auraWidth or not auraHeight then
        -- get the aura width and height
        auraWidth, auraHeight = f:GetWidth(), f:GetHeight()
      end
      local xOffset = auraWidth * ((i - 1) % aurasPerRow)
      local rowNum = math.floor((i - 1) / aurasPerRow)
      local yOffset = auraHeight * rowNum
      f:SetPoint('TOPLEFT', frame, 'BOTTOMLEFT', xOffset, -yOffset)
      f.texture:SetTexture(icon)
      if duration and duration ~= 0 then
        f.cd:Show()
        f.cd:SetCountdownFont('FigFontInvis')
        f.cd:SetCooldown(GetTime(), duration)
      else
        f.cd:Hide()
      end
      f.auraIndex = i
      frame.numBuffRows = rowNum -- used to position the debuffs
      f:Show()
    else
      f.auraIndex = nil
      f:Hide()
    end
  end

  -- draw debuffs
  -- TODO: add cooldowns
  for i = 1, maxNumAuras / 2 do
    local name, icon, count, debuffType, duration, expirationTime, source, isStealable,
      nameplateShowPersonal, spellId = UnitDebuff('target', i)
    local f = _G['FigTargetDebuff' .. i] or CreateFrame('Frame', 'FigTargetDebuff' .. i, frame, 'FigTargetDebuffTemplate')
    if name then
      if not auraWidth or not auraHeight then
        -- get the aura width and height
        auraWidth, auraHeight = f:GetWidth(), f:GetHeight()
      end
      local xOffset = auraWidth * ((i - 1) % aurasPerRow)
      local debuffRowsStartPos
      if frame.numBuffRows ~= nil then
        debuffRowsStartPos = (frame.numBuffRows + 1) * auraHeight
      else
        debuffRowsStartPos = 0
      end
      local yOffset = auraHeight * math.floor((i - 1) / aurasPerRow) + debuffRowsStartPos
      f:SetPoint('TOPLEFT', frame, 'BOTTOMLEFT', xOffset, -yOffset)
      f.texture:SetTexture(icon)
      f.textureTint:SetColorTexture(1, 0, 0, 0.3)
      f.auraIndex = i
      f:Show()
    else
      f.auraIndex = nil
      f:Hide()
    end
  end
end

function FigTarget.updateFrame(frame)
  FigTarget.colorHp(frame, 'target')
  FigTarget.colorPower(frame, 'target')
  FigTarget.updateHp(frame, 'target')
  FigTarget.updatePower(frame, 'target')
  FigTarget.updatePlayerInfo(frame)
  FigTarget.updateAuras(frame)
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

  if event == 'UNIT_AURA' and ... == 'target' then
    FigTarget.updateAuras(frame)
  end
end

function FigTarget.initialize(frame)
  -- register for events
  frame:RegisterEvent('UNIT_HEALTH')
  frame:RegisterEvent('UNIT_POWER_UPDATE')
  frame:RegisterEvent('PLAYER_LEVEL_CHANGED')
  frame:RegisterEvent('PLAYER_ENTERING_WORLD')
  frame:RegisterEvent('PLAYER_TARGET_CHANGED')
  frame:RegisterEvent('UNIT_AURA')
  frame:SetScript('OnEvent', FigTarget.handleEvents)

  -- hide default target frame
  TargetFrame:SetScript('OnEvent', nil)

  -- TODO: make this respect the user's frame positioning
  frame:SetPoint('CENTER', UIParent, 'CENTER', 200, -240)
end

function FigTarget.onShow(frame)
  FigTarget.updateFrame(frame)
end