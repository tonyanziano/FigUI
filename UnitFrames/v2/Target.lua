local numberOfAurasPerRow = 10
local auraSize -- will be calculated on initial draw

-- values are from the official WoW target frame source
local maxBuffs = 32
local maxDebuffs = 16

local function createAuraFrame(index, auraContainer, auraNameSuffix)
  local f = CreateFrame('Frame', 'FigTarget' .. auraNameSuffix .. index, auraContainer, 'FigAuraTemplate')
  f:SetSize(auraSize, auraSize)
  -- icon
  f.tex = f:CreateTexture(nil, 'BACKGROUND')
  f.tex:SetPoint('TOPLEFT', f, 'TOPLEFT')
  f.tex:SetAllPoints()
  -- count
  f.count = f:CreateFontString(nil, 'OVERLAY')
  f.count:SetPoint('BOTTOMRIGHT', f.tex, 'BOTTOMRIGHT')
  f.count:SetFont("Fonts\\FRIZQT__.TTF", 8, 'OUTLINE')
  f.count:SetTextHeight(8)
  -- cooldown
  f.cd = CreateFrame('Cooldown', nil, f, 'CooldownFrameTemplate')
  f.cd:SetHideCountdownNumbers(true)
  f.cd:SetReverse(true) -- foreground should be the icon and the swip should dim the icon
  f.cd:SetAllPoints()
  return f
end

local function doInitialDrawOfAuras(frame)
  -- draw buff / debuff containers
  auraSize = frame:GetWidth() / numberOfAurasPerRow
  if frame.buffs == nil then
    frame.buffs = CreateFrame('Frame', 'FigTargetBuffs', frame)
    frame.buffs:SetWidth(frame:GetWidth())
    -- hide the buffs frame until we actually have buffs to render;
    -- setting height to 0 bugs out the debuff bar's relative anchor so
    -- we use -1 instead
    frame.buffs:SetHeight(-1)
    frame.buffs:Hide()
    frame.buffs:SetPoint('TOPLEFT', frame, 'BOTTOMLEFT', 0, -4)
  end
  if frame.debuffs == nil then
    frame.debuffs = CreateFrame('Frame', 'FigTargetDebuffs', frame)
    frame.debuffs:SetWidth(frame:GetWidth())
    local maxDebuffRows = math.ceil(maxDebuffs / numberOfAurasPerRow)
    frame.debuffs:SetHeight(auraSize * maxDebuffRows) -- debuffs frame can always be full height because it comes after the buffs frame
    frame.debuffs:Show()
    frame.debuffs:SetPoint('TOPLEFT', frame.buffs, 'BOTTOMLEFT')
  end

  -- draw and position buffs
  for i = 1, maxBuffs do
    local aura = createAuraFrame(i, frame.buffs, 'Buff')
    -- row and col start at 0
    local auraRow = math.ceil(i / numberOfAurasPerRow) - 1
    local auraCol = (i % numberOfAurasPerRow) - 1
    if auraCol == -1 then
      -- end of row
      auraCol = numberOfAurasPerRow - 1
    end
    local yOffset = -(auraRow * aura:GetHeight())
    local xOffset = auraCol * aura:GetWidth()
    aura:SetPoint('TOPLEFT', frame.buffs, 'TOPLEFT', xOffset, yOffset)
    aura:Show()
  end

  -- draw and position debuffs
  for i = 1, maxDebuffs do
    local aura = createAuraFrame(i, frame.debuffs, 'Debuff')
    -- row and col start at 0
    local auraRow = math.ceil(i / numberOfAurasPerRow) - 1
    local auraCol = (i % numberOfAurasPerRow) - 1
    if auraCol == -1 then
      -- end of row
      auraCol = numberOfAurasPerRow - 1
    end
    local yOffset = -(auraRow * aura:GetHeight())
    local xOffset = auraCol * aura:GetWidth()
    aura:SetPoint('TOPLEFT', frame.debuffs, 'TOPLEFT', xOffset, yOffset)
    aura:Show()
  end

  frame.hasDrawnAuras = true
end

local function drawAuras(frame)
  if frame.hasDrawnAuras == nil then
    doInitialDrawOfAuras(frame)
  end

  local unit = frame.trackingUnit

  -- populate the aura frames with data
  frame.buffs:SetHeight(-1)
  frame.buffs:Hide()
  for i = 1, maxBuffs do
    local aura = _G['FigTargetBuff' .. i]
    local name, icon, count, _, duration, expirationTime, _, _, _, spellId = UnitBuff(unit, i)

    if name ~= nil then
      -- draw the buff
      aura.spellId = spellId
      aura.tex:SetTexture(icon)
      if count > 0 then
        aura.count:SetText(count)
      else
        aura.count:SetText('')
      end
      if expirationTime > 0 then
        aura.cd:Clear()
        aura.cd:SetCooldown(expirationTime - duration, duration)
      end
      aura:Show()

      -- calculate the height of the buffs bar
      local numBuffRows = math.ceil(i / numberOfAurasPerRow)
      frame.buffs:SetHeight(numBuffRows * auraSize)
      frame.buffs:Show()
    else
      -- hide the buff
      aura:Hide()
    end
  end

  for i = 1, maxDebuffs do
    local aura = _G['FigTargetDebuff' .. i]
    local name, icon, count, _, duration, expirationTime, _, _, _, spellId = UnitDebuff(unit, i)

    if name ~= nil then
      -- draw the debuff
      aura.spellId = spellId
      aura.tex:SetTexture(icon)
      if count > 0 then
        aura.count:SetText(count)
      else
        aura.count:SetText('')
      end
      if expirationTime > 0 then
        aura.cd:Clear()
        aura.cd:SetCooldown(expirationTime - duration, duration)
      end
      aura:Show()
    else
      -- hide the debuff
      aura:Hide()
    end
  end
end

FigTargetOptions = {
  drawAuras = drawAuras
}