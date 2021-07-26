FigResourceDeathKnightMixin = {}

FigResourceDeathKnightMixin.powerType = 'RUNIC_POWER'
local MAX_RUNES = 6
local runicPowerColor = PowerBarColor[Enum.PowerType.RunicPower]

local function setBorders(frame)
  if frame.leftBorder then
    frame.leftBorder:SetStartPoint('BOTTOMLEFT')
    frame.leftBorder:SetEndPoint('TOPLEFT')
  end
  if frame.rightBorder then
    frame.rightBorder:SetStartPoint('BOTTOMRIGHT')
    frame.rightBorder:SetEndPoint('TOPRIGHT')
  end
  if frame.topBorder then
    frame.topBorder:SetStartPoint('TOPLEFT')
    frame.topBorder:SetEndPoint('TOPRIGHT')
  end
  if frame.bottomBorder then
    frame.bottomBorder:SetStartPoint('BOTTOMLEFT')
    frame.bottomBorder:SetEndPoint('BOTTOMRIGHT')
  end
end

local runeColors = {
  Blood = { r = 209/255, g = 21/255, b = 21/255 },
  Frost = { r = 98/255, g = 206/255, b = 240/255 },
  Unholy = { r = 132/255, g = 227/255, b = 54/255 }
}

local function colorRunes()
  local currentSpec = GetSpecialization()
  local runeColor
  if currentSpec then
     local _, currentSpecName = GetSpecializationInfo(currentSpec)
     runeColor = runeColors[currentSpecName]

  else
    runeColor = runeColors.Unholy
  end

  for i = 1, MAX_RUNES do
    local rune = _G['FigRune' .. i]
    rune:SetStatusBarColor(runeColor.r, runeColor.g, runeColor.b, 1)
  end
end

function FigResourceDeathKnightMixin.doInitialDraw(frame)
  local playerFrame = _G['FigPlayer']
  local playerFrameWidth = playerFrame:GetWidth()
  frame:SetSize(playerFrameWidth, 23)

  -- runic power
  frame.runicPower:SetWidth(playerFrameWidth)
  frame.runicPower:SetHeight(15)
  local runicPower = UnitPower('player', Enum.PowerType.RunicPower)
  frame.runicPower.text:SetText(runicPower)
  frame.runicPower:SetValue(runicPower)
  frame.runicPower:SetStatusBarColor(runicPowerColor.r, runicPowerColor.g, runicPowerColor.b, 1)
  frame.runicPower:SetPoint('BOTTOMLEFT', frame, 'BOTTOMLEFT')
  setBorders(frame.runicPower)

  -- rune container
  local runeContainerWidth, runeContainerHeight = playerFrameWidth, 8
  local runeWidth = runeContainerWidth / MAX_RUNES
  frame.runeContainer:SetWidth(runeContainerWidth)
  frame.runeContainer:SetHeight(runeContainerHeight)
  frame.runeContainer:SetPoint('TOPLEFT', frame, 'TOPLEFT')
  setBorders(frame.runeContainer)

  -- runes
  for i = 1, MAX_RUNES do
    local rune = _G['FigRune' .. i]
    rune:SetWidth(runeWidth)
    rune:SetHeight(runeContainerHeight)
    local xOffset = (i - 1) * runeWidth
    rune:SetPoint('LEFT', frame.runeContainer, 'LEFT', xOffset, 0)
  end
  colorRunes()
end

-- update runic power
function FigResourceDeathKnightMixin.updateResource(frame)
  local runicPower, maxRunicPower = UnitPower('player', Enum.PowerType.RunicPower), UnitPowerMax('player', Enum.PowerType.RunicPower)
  frame.runicPower:SetMinMaxValues(0, maxRunicPower)
  frame.runicPower:SetValue(runicPower)
  frame.runicPower.text:SetText(runicPower)
end

local function updateRunes()
  for i = 1, MAX_RUNES do
    local start, duration, runeReady = GetRuneCooldown(i)
    local rune = _G['FigRune' .. i]
    rune.startTime = start
    rune.duration = duration
    rune.isReady = runeReady
  end
end

local function onEvent(frame, event, ...)
  if event == 'PLAYER_TALENT_UPDATE' then
    colorRunes()
  elseif event == 'RUNE_POWER_UPDATE' then
    updateRunes()
  end
end

function FigResourceDeathKnightMixin.initializeRuneEvents(frame)
  frame:RegisterEvent('PLAYER_TALENT_UPDATE')
  frame:RegisterEvent('RUNE_POWER_UPDATE')
  frame:HookScript('OnEvent', onEvent)
end

FigDeathKnightRuneMixin = {}

function FigDeathKnightRuneMixin.updateRune(frame)
  if frame.isReady or frame.startTime == nil then
    frame:SetValue(1)
    frame.cd:Hide()
  else
    -- calculate the percentage of the cooldown elapsed
    local now = GetTime()
    local startTime, duration = frame.startTime, frame.duration
    local elapsed = now - startTime
    local remaining = math.ceil(duration - elapsed)
    local percentElapsed = elapsed / duration
    frame:SetValue(percentElapsed)
    frame.cd:SetText(remaining)
    frame.cd:Show()
  end
end

function FigDeathKnightRuneMixin.initialize(frame)
  local start, duration, runeReady = GetRuneCooldown(frame.runeIndex)
  frame.startTime = start
  frame.duration = duration
  frame.isReady = runeReady

  setBorders(frame)
end
