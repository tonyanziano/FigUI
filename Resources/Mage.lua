FigResourceMageMixin = {}

FigResourceMageMixin.powerType = 'ARCANE_CHARGES'

local arcaneChargesColor = PowerBarColor['ARCANE_CHARGES']

function FigResourceMageMixin.drawArcaneCharges(frame)
  -- draw arcane charge indicators
  local frameWidth, frameHeight = frame:GetWidth(), frame:GetHeight()
  local dividerWidth = 1
  local charges, maxCharges = UnitPower('player', Enum.PowerType.ArcaneCharges), UnitPowerMax('player', Enum.PowerType.ArcaneCharges)
  local remainingFrameWidth = frameWidth - (dividerWidth * (maxCharges - 1))
  local chargeWidth = remainingFrameWidth / maxCharges

  for i = 1, maxCharges do
    local pip = _G['FigResourceMageChargePip' .. i] or CreateFrame('frame', 'FigResourceMageChargePip' .. i, frame)
    pip:SetSize(chargeWidth, frameHeight)
    pip.bgTex = _G[pip:GetName() .. 'Background'] or pip:CreateTexture(pip:GetName() .. 'Background', 'BACKGROUND')
    pip.bgTex:SetColorTexture(0.1, 0.1, 0.1, 1)
    pip.bgTex:SetAllPoints()
    pip.fillTex = _G[pip:GetName() .. 'Fill'] or pip:CreateTexture(pip:GetName() .. 'Fill', 'ARTWORK')
    pip.fillTex:SetColorTexture(arcaneChargesColor.r, arcaneChargesColor.g, arcaneChargesColor.b, 1)
    pip.fillTex:SetAllPoints()

    if i <= charges then
      pip.fillTex:Show()
    else
      pip.fillTex:Hide()
    end
    local xOffset = (i - 1) * (chargeWidth + dividerWidth)
    pip:SetPoint('LEFT', frame, 'LEFT', xOffset, 0)

    -- draw pip divider
    if i ~= maxCharges then
      local divider = _G['FigResourceMageChargeDivider' .. i] or CreateFrame('frame', 'FigResourceMageChargeDivider' .. i, frame)
      divider:SetSize(dividerWidth, frameHeight)
      divider.tex = divider:CreateTexture(nil, 'BACKGROUND')
      divider.tex:SetAllPoints()
      divider.tex:SetColorTexture(0, 0, 0, 1)
      divider:SetPoint('LEFT', frame, 'LEFT', xOffset + chargeWidth, 0)
    end
  end
end

function FigResourceMageMixin.doInitialDraw(frame)
  -- size the arcane charges bar based on the player frame
  local playerFrame = _G['FigPlayer']
  local frameWidth, frameHeight = playerFrame:GetWidth(), 15
  frame:SetWidth(frameWidth)
  frame:SetHeight(frameHeight)
  Fig.drawOutsetBordersForFrame(frame)
  if not frame:IsUserPlaced() then
    frame:ClearAllPoints()
    frame:SetPoint('TOPLEFT', playerFrame, 'BOTTOMLEFT', 0, -1)
  end

  local currentSpec = GetSpecialization()
  if currentSpec then
    local _, currentSpecName = GetSpecializationInfo(currentSpec)
    if currentSpecName == 'Arcane' then
      frame:drawArcaneCharges()
      frame:Show()
    else
      frame:Hide()
    end
  else
    frame:Hide()
  end
end

function FigResourceMageMixin.updateResource(frame)
  local charges, maxCharges = UnitPower('player', Enum.PowerType.ArcaneCharges), UnitPowerMax('player', Enum.PowerType.ArcaneCharges)

  for i = 1, maxCharges do
    local pip = _G['FigResourceMageChargePip' .. i]
    if not pip then
      -- the frame needs to be drawn first -- likely started in spec other than arcane
      frame:doInitialDraw()
      frame.updateResource()
      return
    end
    if i <= charges then
      pip.fillTex:Show()
    else
      pip.fillTex:Hide()
    end
  end
end

local function onEvent(frame, event, ...)
  if event == 'PLAYER_TALENT_UPDATE' then
    frame:doInitialDraw()
  end
end

function FigResourceMageMixin.initializeMageResourceBar(frame)
  frame:RegisterEvent('PLAYER_TALENT_UPDATE')
  frame:HookScript('OnEvent', onEvent)
end
