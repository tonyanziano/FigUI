Fig = {}
Fig.overlord = CreateFrame('FRAME', 'FigUI-Overlord', UIParent) -- frame that listens for events

-- event handling
events = {};

function events:UNIT_POWER_UPDATE(...)
  local self, unitId, resource = ...
  if resource == 'RUNIC_POWER' then
    -- redraw runic power
  end
end

local function drawRunes()
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
    drawRunes()
  end
end

local function handleEvents(self, event, ...)
  events[event](self, ...)
end

-- Register events
for k, v in pairs(events) do
  print('Registering event handler: '..k)
  Fig.overlord:RegisterEvent(k)
end
Fig.overlord:SetScript('OnEvent', handleEvents)

local function makeFrame(name, parent)
  local f = CreateFrame('FRAME', name, parent or UIParent)
  return f
end


local containerWidth, containerHeight, runePaddingX, runePaddingY = 250, 50, 10, 10
local function drawResource()
  -- positioning and creation
  local container = makeFrame('FigRuneContainer')
  container:SetWidth(containerWidth)
  container:SetHeight(containerHeight)
  container:SetPoint('CENTER', UIParent, 'CENTER', 0, -120)
  container.tex = container:CreateTexture(nil, 'BACKGROUND')
  container.tex:SetAllPoints(container)
  container.tex:SetColorTexture(0, 0, 0, 0.5) -- gray
  container:Show()

  local numRunes = 6
  -- find the leftover space in the container after padding and divide it by num of runes
  local runeWidth = (containerWidth - ((numRunes + 1) * runePaddingX)) / numRunes
  Fig.runeWidth = runeWidth

  for i=1, numRunes do
    local f = makeFrame('FigRune' .. i, container)
    f:SetHeight(containerHeight - 2 * runePaddingY)
    f:SetWidth(runeWidth)
    f:SetPoint('LEFT', f:GetParent(), 'LEFT', (runePaddingX * i) + ((i - 1) * runeWidth), 0)
    -- bg
    f.texture = f:CreateTexture(nil, 'BACKGROUND')
    f.texture:SetAllPoints(f)
    f.texture:SetColorTexture(77, 77, 77, 1) -- gray
    -- fill
    f.fill = f:CreateTexture(nil, 'ARTWORK')
    f.fill:SetPoint('LEFT', f, 'LEFT')
    f.fill:SetWidth(f:GetWidth())
    f.fill:SetHeight(f:GetHeight())
    f.fill:SetColorTexture(0, 50, 0, 1) -- green
    -- animations to make the bar grow
    f.fill.animG = f.fill:CreateAnimationGroup()
    f.fill.RuneRegen = f.fill.animG:CreateAnimation('Scale')
    f.fill.RuneRegen:SetOrigin('LEFT', 0, 0)
  end
end

drawResource()