FigResourcePaladinMixin = {}

FigResourcePaladinMixin.powerType = 'HOLY_POWER'

function FigResourcePaladinMixin.doInitialDraw(frame)
  local frameWidth = frame:GetWidth()
  local frameHeight = frame:GetHeight()
  local holyPower = UnitPower('player', Enum.PowerType.HolyPower)
  local maxHolyPower = UnitPowerMax('player', Enum.PowerType.HolyPower)
  local dividerWidth = 1
  local remainingFrameWidth = frameWidth - (dividerWidth * (maxHolyPower - 1))
  local holyPowerWidth = remainingFrameWidth / maxHolyPower
  local holyPowerColor = PowerBarColor['HOLY_POWER']

  for i = 1, maxHolyPower do
    -- draw holy power indicator
    local pip = _G['FigResourcePaladinPip' .. i] or CreateFrame('frame', 'FigResourcePaladinPip' .. i, frame)
    pip:SetSize(holyPowerWidth, frameHeight)
    pip.bgTex = _G[pip:GetName() .. 'Background'] or pip:CreateTexture(pip:GetName() .. 'Background', 'BACKGROUND')
    pip.bgTex:SetColorTexture(0.1, 0.1, 0.1, 1)
    pip.bgTex:SetAllPoints()
    pip.fillTex = _G[pip:GetName() .. 'Fill'] or pip:CreateTexture(pip:GetName() .. 'Fill', 'ARTWORK')
    pip.fillTex:SetColorTexture(holyPowerColor.r, holyPowerColor.g, holyPowerColor.b, 1)
    pip.fillTex:SetAllPoints()

    if i <= holyPower then
      -- the holy power is available
      pip.fillTex:Show()
      pip.available = true
    else
      -- the holy power is unavailable
      pip.fillTex:Hide()
      pip.available = false
    end
    local xOffset = (i - 1) * (holyPowerWidth + dividerWidth)
    pip:SetPoint('LEFT', frame, 'LEFT', xOffset, 0)

    -- draw pip divider
    if i ~= maxHolyPower then
      local divider = _G['FigResourcePaladinDivider' .. i] or CreateFrame('frame', 'FigResourcePaladinDivider' .. i, frame)
      divider:SetSize(dividerWidth, frameHeight)
      divider.tex = divider:CreateTexture(nil, 'BACKGROUND')
      divider.tex:SetAllPoints()
      divider.tex:SetColorTexture(0, 0, 0, 1)
      divider:SetPoint('LEFT', frame, 'LEFT', xOffset + holyPowerWidth, 0)
    end
  end

  Fig.drawOutsetBordersForFrame(frame)
end

function FigResourcePaladinMixin.updateResource(frame)
  local holyPower = UnitPower('player', Enum.PowerType.HolyPower)
  local maxHolyPower = UnitPowerMax('player', Enum.PowerType.HolyPower)
  FigDebug.log('Updating holy power: ', holyPower, maxHolyPower)
  for i = 1, maxHolyPower do
    local pip = _G['FigResourcePaladinPip' .. i]
    if i <= holyPower then
      -- the holy power is available
      pip.fillTex:Show()
      pip.available = true
    else
      -- the holy power is unavailable
      pip.fillTex:Hide()
      pip.available = false
    end
  end
end
