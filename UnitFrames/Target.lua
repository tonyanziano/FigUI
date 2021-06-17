local numberOfAurasPerRow = 10
local auraSize -- will be calculated on initial draw

-- values are from the official WoW target frame source
local maxBuffs = 32
local maxDebuffs = 16

local DebuffTypeColors = {
  -- TODO: confirm 'Bleed' is the correct debuff type
  ['Bleed'] = {
    r = 181/255,
    g = 11/255,
    b = 11/255,
    a = 1
  },
  ['Curse'] = {
    r = 122/255,
    g = 20/255,
    b = 227/255,
    a = 1
  },
  ['Disease'] = {
    r = 232/255,
    g = 173/255,
    b = 79/255,
    a = 1
  },
  ['Magic'] = {
    r = 33/255,
    g = 120/255,
    b = 219/255,
    a = 1
  },
  ['Poison'] = {
    r = 25/255,
    g = 133/255,
    b = 17/255,
    a = 1
  }
}

-- Draw borders for auras to show their type (magic, poison, curse, etc.)
-- Differs slightly from Fig.drawBordersForFrame() because the borders are
-- inset into the icon instead of on the perimeter
local function drawAuraBorders(frame)
  -- draw all borders within a frame on top of the parent frame (gets around the issue of textures being drawn under child frames)
  local borderFrameLevel = frame:GetFrameLevel() + 20
  local borderFrame = CreateFrame('frame', nil, frame)
  borderFrame:SetPoint('CENTER')
  borderFrame:SetFrameLevel(borderFrameLevel)
  borderFrame:SetSize(frame:GetSize())
  frame.borders = borderFrame
  local borderThickness = 1

  -- draw borders
  borderFrame.top = borderFrame:CreateTexture(nil, 'OVERLAY')
  borderFrame.top:SetColorTexture(0, 0, 0, 0)
  borderFrame.top:SetPoint('TOPLEFT', borderFrame, 'TOPLEFT')
  borderFrame.top:SetPoint('TOPRIGHT', borderFrame, 'TOPRIGHT')
  borderFrame.top:SetHeight(borderThickness)

  borderFrame.bottom = borderFrame:CreateTexture(nil, 'OVERLAY')
  borderFrame.bottom:SetColorTexture(0, 0, 0, 0)
  borderFrame.bottom:SetPoint('BOTTOMLEFT', borderFrame, 'BOTTOMLEFT')
  borderFrame.bottom:SetPoint('BOTTOMRIGHT', borderFrame, 'BOTTOMRIGHT')
  borderFrame.bottom:SetHeight(borderThickness)

  borderFrame.left = borderFrame:CreateTexture(nil, 'OVERLAY')
  borderFrame.left:SetColorTexture(0, 0, 0, 0)
  borderFrame.left:SetPoint('TOPLEFT', borderFrame, 'TOPLEFT')
  borderFrame.left:SetPoint('BOTTOMLEFT', borderFrame, 'BOTTOMLEFT')
  borderFrame.left:SetWidth(borderThickness)

  borderFrame.right = borderFrame:CreateTexture(nil, 'OVERLAY')
  borderFrame.right:SetColorTexture(0, 0, 0, 0)
  borderFrame.right:SetPoint('TOPRIGHT', borderFrame, 'TOPRIGHT')
  borderFrame.right:SetPoint('BOTTOMRIGHT', borderFrame, 'BOTTOMRIGHT')
  borderFrame.right:SetWidth(borderThickness)

  function borderFrame.setBorderColor(r, g, b, a)
    borderFrame.top:SetColorTexture(r, g, b, a)
    borderFrame.bottom:SetColorTexture(r, g, b, a)
    borderFrame.left:SetColorTexture(r, g, b, a)
    borderFrame.right:SetColorTexture(r, g, b, a)
  end

  borderFrame:Show()
end

local function createAuraFrame(index, auraContainer, auraNameSuffix)
  local f = _G['FigTarget' .. auraNameSuffix .. index] or CreateFrame('frame', 'FigTarget' .. auraNameSuffix .. index, auraContainer, 'FigAuraTemplate')
  f.unit = 'target'
  f:SetSize(auraSize, auraSize)
  -- icon
  f.tex = f:CreateTexture(nil, 'BACKGROUND')
  f.tex:SetPoint('TOPLEFT', f, 'TOPLEFT')
  f.tex:SetAllPoints()
  -- count
  f.count = f:CreateFontString(nil, 'OVERLAY')
  f.count:SetPoint('BOTTOMRIGHT', f.tex, 'BOTTOMRIGHT')
  f.count:SetFont("Fonts\\FRIZQT__.TTF", 14, 'OUTLINE')
  f.count:SetTextHeight(14)
  -- cooldown
  f.cd = _G[f:GetName() .. 'CoolDown'] or CreateFrame('cooldown', _G[f:GetName() .. 'CoolDown'], f, 'CooldownFrameTemplate')
  f.cd:SetHideCountdownNumbers(true)
  f.cd:SetReverse(true) -- foreground should be the icon and the swip should dim the icon
  f.cd:SetAllPoints()
  -- borders -- for debuff type & ability to spell steal
  drawAuraBorders(f)

  return f
end

local function doInitialDrawOfAuras(frame)
  -- draw buff / debuff containers
  auraSize = frame:GetWidth() / numberOfAurasPerRow
  if frame.buffs == nil then
    frame.buffs = _G['FigTargetBuffs'] or CreateFrame('frame', 'FigTargetBuffs', frame)
    frame.buffs:SetWidth(frame:GetWidth())
    -- hide the buffs frame until we actually have buffs to render;
    -- setting height to 0 bugs out the debuff bar's relative anchor so
    -- we use -1 instead
    frame.buffs:SetHeight(-1)
    frame.buffs:Hide()
    frame.buffs:SetPoint('TOPLEFT', frame, 'BOTTOMLEFT', 0, -4)
  end
  if frame.debuffs == nil then
    frame.debuffs = _G['FigTargetDebuffs'] or CreateFrame('frame', 'FigTargetDebuffs', frame)
    frame.debuffs:SetWidth(frame:GetWidth())
    local maxDebuffRows = math.ceil(maxDebuffs / numberOfAurasPerRow)
    frame.debuffs:SetHeight(auraSize * maxDebuffRows) -- debuffs frame can always be full height because it comes after the buffs frame
    frame.debuffs:Show()
    frame.debuffs:SetPoint('TOPLEFT', frame.buffs, 'BOTTOMLEFT')
  end

  -- draw and position buffs
  for i = 1, maxBuffs do
    local aura = createAuraFrame(i, frame.buffs, 'Buff')
    aura.unit = frame.trackingUnit
    aura.index = i
    aura.filter = 'HELPFUL'
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
    aura.unit = frame.trackingUnit
    aura.index = i
    aura.filter = 'HARMFUL'
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
    -- draw and position all the aura frames
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
    local name, icon, count, debuffType, duration, expirationTime, _, _, _, spellId = UnitDebuff(unit, i)

    if name ~= nil then
      -- draw the debuff
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
      if debuffType ~= nil then
        local debuffTypeColor = DebuffTypeColors[debuffType]
        aura.borders.setBorderColor(debuffTypeColor.r, debuffTypeColor.g, debuffTypeColor.b, debuffTypeColor.a)
        aura.borders:Show()
      else
        aura.borders:Hide()
      end
      aura:Show()
    else
      -- hide the debuff
      aura:Hide()
    end
  end
end

local function initialize(frame)
  -- hide default target frame
  TargetFrame:SetScript('OnUpdate', nil)
  TargetFrame:SetScript('OnEvent', nil)
  TargetFrame:Hide()
end

FigTargetOptions = {
  drawAuras = drawAuras,
  initialize = initialize,
  oneLineName = true
}