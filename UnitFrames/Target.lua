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

-- updates the duration and stacks of an aura
function FigTarget.updateAuraStatus(frame, elapsed)
  local totalElapsed = frame.elapsedSinceLastStatusTick + elapsed
  if totalElapsed >= frame.statusTick then
    frame.elapsedSinceLastStatusTick = 0
    local _, _, count, _, _, expirationTime = UnitAura('target', frame.slot, frame.auraType)
    if expirationTime == 0 or expirationTime == nil then
      frame.text:SetText(nil)
    else
      frame.text:SetText(Fig.prettyPrintDuration(expirationTime - GetTime()))
    end
    if count == 0 or count == nil then
      frame.stackCount:SetText(nil)
    else
      frame.stackCount:SetText(count)
    end
  else
    frame.elapsedSinceLastStatusTick = totalElapsed
  end
end

function FigTarget.initAuraConfig()
  -- create a frame to measure width
  local dummyFrame = _G['FigDummyAura'] or CreateFrame('Frame', 'FigDummyAura', UIParent, 'FigTargetAuraTemplate')
  FigTarget.aurasPerRow = math.floor(FigTargetFrame:GetWidth() / dummyFrame:GetWidth())
  FigTarget.auraTextHeight = dummyFrame.text:GetHeight()
  FigTarget.auraWidth = dummyFrame:GetWidth()
  FigTarget.auraHeight = dummyFrame:GetHeight()
  if dummyFrame:IsShown() then
    dummyFrame:Hide()
  end
end

local maxNumAuras = 40
local targetBotBorderCompensation = 5

function FigTarget.updateAuras(frame)
  -- draw buffs
  frame.numBuffRows = nil
  for i = 1, maxNumAuras / 2 do
    local name, icon, count, debuffType, duration, expirationTime, source, isStealable,
      nameplateShowPersonal, spellId = UnitBuff('target', i)
    local f = _G['FigTargetBuff' .. i] or CreateFrame('Frame', 'FigTargetBuff' .. i, frame, 'FigTargetBuffTemplate')
    if not f.slot then
      f.slot = i
    end
    if name then
      local xOffset = FigTarget.auraWidth * ((i - 1) % FigTarget.aurasPerRow)
      local rowNum = math.floor((i - 1) / FigTarget.aurasPerRow)
      local yOffset = FigTarget.auraHeight * rowNum
      if rowNum >= 1 then
        -- make sure it clears the duration text of the previous row
        yOffset = yOffset + FigTarget.auraTextHeight
      end
      f:SetPoint('TOPLEFT', frame, 'BOTTOMLEFT', xOffset, -yOffset - targetBotBorderCompensation)
      f.texture:SetTexture(icon)
      f.auraIndex = i
      frame.numBuffRows = rowNum -- used to position the debuffs
      f:Show()
    else
      f.auraIndex = nil
      f:Hide()
    end
  end

  -- draw debuffs
  for i = 1, maxNumAuras / 2 do
    local name, icon, count, debuffType, duration, expirationTime, source, isStealable,
      nameplateShowPersonal, spellId = UnitDebuff('target', i)
    local f = _G['FigTargetDebuff' .. i] or CreateFrame('Frame', 'FigTargetDebuff' .. i, frame, 'FigTargetDebuffTemplate')
    if not f.slot then
      f.slot = i
    end
    if name then
      local xOffset = FigTarget.auraWidth * ((i - 1) % FigTarget.aurasPerRow)
      local debuffRowsStartPos
      if frame.numBuffRows ~= nil then
        debuffRowsStartPos = (frame.numBuffRows + 1) * (FigTarget.auraHeight + FigTarget.auraTextHeight) + targetBotBorderCompensation
      else
        debuffRowsStartPos = 0 + targetBotBorderCompensation
      end
      local yOffset = FigTarget.auraHeight * math.floor((i - 1) / FigTarget.aurasPerRow) + debuffRowsStartPos
      f:SetPoint('TOPLEFT', frame, 'BOTTOMLEFT', xOffset, -yOffset)
      f.texture:SetTexture(icon)
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

  frame:SetPoint('CENTER', UIParent, 'CENTER', 200, -240)
  FigTarget.initAuraConfig()
end

function FigTarget.onShow(frame)
  FigTarget.updateFrame(frame)
end