FigResourceRogueMixin = {}

FigResourceRogueMixin.powerType = 'COMBO_POINTS'

function FigResourceRogueMixin.doInitialDraw(frame)
  local frameWidth = frame:GetWidth()
  local frameHeight = frame:GetHeight()
  local comboPoints = UnitPower('player', Enum.PowerType.ComboPoints)
  local maxComboPoints = UnitPowerMax('player', Enum.PowerType.ComboPoints)
  local dividerWidth = 1
  local remainingFrameWidth = frameWidth - (dividerWidth * (maxComboPoints - 1))
  local comboPointWidth = remainingFrameWidth / maxComboPoints
  local comboPointColor = PowerBarColor['COMBO_POINTS']

  for i = 1, maxComboPoints do
    -- draw combo point indicator
    local pip = _G['FigResourceRoguePip' .. i] or CreateFrame('frame', 'FigResourceRoguePip' .. i, frame)
    pip:SetSize(comboPointWidth, frameHeight)
    pip.bgTex = _G[pip:GetName() .. 'Background'] or pip:CreateTexture(pip:GetName() .. 'Background', 'BACKGROUND')
    pip.bgTex:SetColorTexture(0.1, 0.1, 0.1, 1)
    pip.bgTex:SetAllPoints()
    pip.fillTex = _G[pip:GetName() .. 'Fill'] or pip:CreateTexture(pip:GetName() .. 'Fill', 'ARTWORK')
    pip.fillTex:SetColorTexture(comboPointColor.r, comboPointColor.g, comboPointColor.b, 1)
    pip.fillTex:SetAllPoints()

    if i <= comboPoints then
      -- the combo point is available
      pip.fillTex:Show()
      pip.available = true
    else
      -- the combo point is unavailable
      pip.fillTex:Hide()
      pip.available = false
    end
    local xOffset = (i - 1) * (comboPointWidth + dividerWidth)
    pip:SetPoint('LEFT', frame, 'LEFT', xOffset, 0)

    -- draw pip divider
    if i ~= maxComboPoints then
      local divider = _G['FigResourceRogueDivider' .. i] or CreateFrame('frame', 'FigResourceRogueDivider' .. i, frame)
      divider:SetSize(dividerWidth, frameHeight)
      divider.tex = divider:CreateTexture(nil, 'BACKGROUND')
      divider.tex:SetAllPoints()
      divider.tex:SetColorTexture(0, 0, 0, 1)
      divider:SetPoint('LEFT', frame, 'LEFT', xOffset + comboPointWidth, 0)
    end
  end

  Fig.drawOutsetBordersForFrame(frame)
end

function FigResourceRogueMixin.updateResource(frame)
  local comboPoints = UnitPower('player', Enum.PowerType.ComboPoints)
  local maxComboPoints = UnitPowerMax('player', Enum.PowerType.ComboPoints)
  FigDebug.log('Updating combo points: ', comboPoints, maxComboPoints)
  for i = 1, maxComboPoints do
    local pip = _G['FigResourceRoguePip' .. i]
    if i <= comboPoints then
      -- the combo point is available
      pip.fillTex:Show()
      pip.available = true
    else
      -- the combo point is unavailable
      pip.fillTex:Hide()
      pip.available = false
    end
  end
end
