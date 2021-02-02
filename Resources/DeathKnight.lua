FigDK = {}

function FigDK.updateRunicPower(frame, ...)
  local rp = UnitPower('player')
  frame.runicPower.text:SetText(''..rp)
  frame.runicPower:SetValue(rp)
end

function FigDK.updateRunes(frame, ...)
  for i=1, 6 do
    local start, duration, cooledDown = GetRuneCooldown(i)
    local runeFrame = _G['FigRune'..i]
    runeFrame.cd:SetCooldown(start, duration)
  end
end

function FigDK.handleEvents(frame, event, ...)
  if event == 'RUNE_POWER_UPDATE' then
    local index = ...
    if index >= 1 and index <= 6 then
      FigDK.updateRunes(frame, ...)
    end
  end

  if event == 'UNIT_POWER_UPDATE' then
    local unitId, resource = ...
    if unitId == 'player' and resource == 'RUNIC_POWER' then
      FigDK.updateRunicPower(frame, ...)
    end
  end
end

local runePaddingX, runePaddingY = 2, 0
function FigDK.drawRunes(frame)
  -- positioning and creation
  local numRunes = 6
  local container = frame.runeContainer
  container.tex = container:CreateTexture(nil, 'BACKGROUND')
  container.tex:SetAllPoints(container)
  container.tex:SetColorTexture(0, 0, 0, 0.5) -- gray

  -- find the leftover space in the container after padding and divide it by num of runes
  local containerWidth, containerHeight = container:GetWidth(), container:GetHeight()
  local runeWidth = (containerWidth - ((numRunes - 1) * runePaddingX)) / numRunes
  Fig.runeWidth = runeWidth

  for i=1, numRunes do
    local f = CreateFrame('StatusBar', 'FigRune' .. i, container, 'FigDeathKnightRune')
    f:SetHeight(containerHeight - 2 * runePaddingY)
    f:SetWidth(runeWidth)
    f.cd:SetCountdownFont('FigFontInvis')
    local prevRune = _G['FigRune' .. (i - 1)]
    if not (prevRune == nil) then
      -- place it in relation to the previous rune
      f:SetPoint('LEFT', prevRune, 'LEFT', runeWidth + runePaddingX, 0)
    else
      -- place it in relation to the container
      f:SetPoint('LEFT', f:GetParent(), 'LEFT')
    end
  end
end

function FigDK.initialize(frame)
  frame:RegisterEvent('RUNE_POWER_UPDATE')
  frame:RegisterEvent('UNIT_POWER_UPDATE')
  frame:SetScript('OnEvent', FigDK.handleEvents)

  -- TODO: initial draw?
  FigDK.drawRunes(frame)
  FigDK.updateRunicPower(frame)
end
