Fig = {}
Fig.overlord = CreateFrame('FRAME', 'FigUI-Overlord', UIParent) -- frame that listens for events

-- event handling
events = {};

FigDK = {}

function FigDK.drawRunicPower(frame)
  local rp = UnitPower('player')
  frame.text:SetText(''..rp)
  frame:SetValue(rp)
end

function events:UNIT_POWER_UPDATE(...)
  local unitId, resource = ...
  if unitId == 'player' and resource == 'RUNIC_POWER' then
    FigDK.drawRunicPower(_G['FigResourceDKRunicPower'])
  end
end

local function updateRunes()
  for i=1, 6 do
    local start, duration, cooledDown = GetRuneCooldown(i)
    if not cooledDown then
      -- update the bar
      local runeFrame = _G['FigRune' ..i]
      runeFrame.fill.RuneRegen:SetDuration(duration)
      runeFrame.fill.RuneRegen:SetScale(Fig.runeWidth, 1)
      runeFrame.fill:SetWidth(1)
      -- TODO: set opacity to less?
      runeFrame.fill.animG:Play()
      -- TODO: on the end of the animation, reset the width to max
    else
      -- fill the bar
    end
  end
end

function events:RUNE_POWER_UPDATE(...)
  local runeIndex, _ = ...
  if runeIndex == 1 then
    updateRunes()
  end
end

local function handleEvents(self, event, ...)
  events[event](self, ...)
end

-- Register events
for k, v in pairs(events) do
  Fig.overlord:RegisterEvent(k)
end
Fig.overlord:SetScript('OnEvent', handleEvents)

local function makeFrame(name, parent)
  local f = CreateFrame('FRAME', name, parent or UIParent)
  return f
end

local function getTexturePath(texture)
  return 'Interface\\AddOns\\FigUI-2\\Textures\\' .. texture
end

local runePaddingX, runePaddingY = 2, 0
function FigDK.drawRunes()
  -- positioning and creation
  local numRunes = 6
  local container = _G['FigResourceDKRunes']
  container.tex = container:CreateTexture(nil, 'BACKGROUND')
  container.tex:SetAllPoints(container)
  container.tex:SetColorTexture(0, 0, 0, 0.5) -- gray

  -- find the leftover space in the container after padding and divide it by num of runes
  local containerWidth, containerHeight = container:GetWidth(), container:GetHeight()
  local runeWidth = (containerWidth - ((numRunes - 1) * runePaddingX)) / numRunes
  Fig.runeWidth = runeWidth

  for i=1, numRunes do
    local f = makeFrame('FigRune' .. i, container)
    f:SetHeight(containerHeight - 2 * runePaddingY)
    f:SetWidth(runeWidth)
    local prevRune = _G['FigRune' .. (i - 1)]
    if not (prevRune == nil) then
      -- place it in relation to the previous rune
      f:SetPoint('LEFT', prevRune, 'LEFT', runeWidth + runePaddingX, 0)
    else
      -- place it in relation to the container
      f:SetPoint('LEFT', f:GetParent(), 'LEFT')
    end
    
    -- bg
    f.texture = f:CreateTexture(nil, 'BACKGROUND')
    f.texture:SetAllPoints(f)
    f.texture:SetColorTexture(77/255, 77/255, 77/255, 1) -- gray
    -- fill
    f.fill = f:CreateTexture(nil, 'ARTWORK')
    f.fill:SetVertexColor(.36, .17, .89, 1) -- yellow
    f.fill:SetTexture(getTexturePath('GenericBarFill'))
    f.fill:SetPoint('LEFT', f, 'LEFT')
    f.fill:SetWidth(f:GetWidth())
    f.fill:SetHeight(f:GetHeight())
    -- animations to make the bar grow
    f.fill.animG = f.fill:CreateAnimationGroup()
    f.fill.RuneRegen = f.fill.animG:CreateAnimation('Scale')
    f.fill.RuneRegen:SetOrigin('LEFT', 0, 0)
  end
end
