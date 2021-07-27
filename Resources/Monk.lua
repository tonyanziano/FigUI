FigResourceMonkMixin = {}

FigResourceMonkMixin.powerType = 'CHI'

-- percentages at which bar should change color
STAGGER_YELLOW_THRESHOLD = .30
STAGGER_RED_THRESHOLD = .60

-- table indices of bar colors
STAGGER_GREEN_INDEX = 1;
STAGGER_YELLOW_INDEX = 2;
STAGGER_RED_INDEX = 3;

local chiColor = PowerBarColor['CHI']

function FigResourceMonkMixin.drawWindwalkerBar(frame)
  -- draw chi indicators
  local frameWidth, frameHeight = frame:GetWidth(), frame:GetHeight()
  frame.chi:SetWidth(frameWidth)
  frame.chi:SetHeight(frameHeight)
  local dividerWidth = 1
  local chi, maxChi = UnitPower('player', Enum.PowerType.Chi), UnitPowerMax('player', Enum.PowerType.Chi)
  local remainingFrameWidth = frameWidth - (dividerWidth * (maxChi - 1))
  local chiWidth = remainingFrameWidth / maxChi

  for i = 1, maxChi do
    local pip = _G['FigResourceMonkChiPip' .. i] or CreateFrame('frame', 'FigResourceMonkChiPip' .. i, frame.chi)
    pip:SetSize(chiWidth, frameHeight)
    pip.bgTex = _G[pip:GetName() .. 'Background'] or pip:CreateTexture(pip:GetName() .. 'Background', 'BACKGROUND')
    pip.bgTex:SetColorTexture(0.1, 0.1, 0.1, 1)
    pip.bgTex:SetAllPoints()
    pip.fillTex = _G[pip:GetName() .. 'Fill'] or pip:CreateTexture(pip:GetName() .. 'Fill', 'ARTWORK')
    pip.fillTex:SetColorTexture(chiColor.r, chiColor.g, chiColor.b, 1)
    pip.fillTex:SetAllPoints()

    if i <= chi then
      pip.fillTex:Show()
    else
      pip.fillTex:Hide()
    end
    local xOffset = (i - 1) * (chiWidth + dividerWidth)
    pip:SetPoint('LEFT', frame, 'LEFT', xOffset, 0)

    -- draw pip divider
    if i ~= maxChi then
      local divider = _G['FigResourceMonkChiDivider' .. i] or CreateFrame('frame', 'FigResourceMonkChiDivider' .. i, frame.chi)
      divider:SetSize(dividerWidth, frameHeight)
      divider.tex = divider:CreateTexture(nil, 'BACKGROUND')
      divider.tex:SetAllPoints()
      divider.tex:SetColorTexture(0, 0, 0, 1)
      divider:SetPoint('LEFT', frame, 'LEFT', xOffset + chiWidth, 0)
    end
  end

  frame.stagger:Hide()
  frame.chi:Show()
end

function FigResourceMonkMixin.drawBrewmasterBar(frame)
  local frameWidth, frameHeight = frame:GetWidth(), frame:GetHeight()
  frame.stagger:SetWidth(frameWidth)
  frame.stagger:SetHeight(frameHeight)

  frame.chi:Hide()
  frame.stagger:Show()
end

function FigResourceMonkMixin.doInitialDraw(frame)
  -- size the monk bar based on the player frame
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
    if currentSpecName == 'Windwalker' then
      frame:drawWindwalkerBar()
    elseif currentSpecName == 'Brewmaster' then
      frame:drawBrewmasterBar()
    else
      frame:Hide()
    end
  else
    frame:Hide()
  end
end

function FigResourceMonkMixin.updateResource(frame)
  local chi, maxChi = UnitPower('player', Enum.PowerType.Chi), UnitPowerMax('player', Enum.PowerType.Chi)

  for i = 1, maxChi do
    local pip = _G['FigResourceMonkChiPip' .. i]
    if not pip then
      -- the frame needs to be drawn first -- likely started in spec other than windwalker
      frame:doInitialDraw()
      frame.updateResource()
      return
    end
    if i <= chi then
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

local staggerTickRate = 0.1
local totalStaggerTimeElapsed = 0
local function updateStaggerBar(frame, elapsed)
  totalStaggerTimeElapsed = totalStaggerTimeElapsed + elapsed
  if totalStaggerTimeElapsed >= staggerTickRate then
    totalStaggerTimeElapsed = 0

    local stagger, maxStagger = UnitStagger('player'), UnitHealthMax('player')
    local percentStagger = stagger / maxStagger
    frame:SetValue(percentStagger)
    local staggerColor = PowerBarColor['STAGGER'][STAGGER_GREEN_INDEX]
    if percentStagger >= STAGGER_RED_THRESHOLD then
      staggerColor = PowerBarColor['STAGGER'][STAGGER_RED_INDEX]
    elseif percentStagger >= STAGGER_YELLOW_THRESHOLD then
      staggerColor = PowerBarColor['STAGGER'][STAGGER_YELLOW_INDEX]
    end
    frame:SetStatusBarColor(staggerColor.r, staggerColor.g, staggerColor.b, 1)
    frame.text:SetText(format('%.1f%%', percentStagger * 100))
  end
end

function FigResourceMonkMixin.initializeMonkResourceBar(frame)
  frame:RegisterEvent('PLAYER_TALENT_UPDATE')
  frame:HookScript('OnEvent', onEvent)
  frame.stagger:SetScript('OnUpdate', updateStaggerBar)
end
