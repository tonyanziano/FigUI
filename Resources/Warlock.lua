FigWarlock = {}

function FigWarlock.doInitialDraw(frame)
  local frameHeight = frame:GetHeight()
  local soulShards = UnitPower('player', Enum.PowerType.SoulShards)
  local maxSoulShards = UnitPowerMax('player', Enum.PowerType.SoulShards)
  local dividerWidth = 1
  local remainingFrameWidth = frame:GetWidth() - (dividerWidth * (maxSoulShards - 1))
  local soulShardWidth = remainingFrameWidth / maxSoulShards
  for i = 1, maxSoulShards do
    -- draw shard indicator
    local shard = _G['FigResourceWarlockShard' .. i]
    if shard == nil then
      shard = CreateFrame('frame', 'FigResourceWarlockShard' .. i, frame)
    end
    shard:SetSize(soulShardWidth, frameHeight)
    shard.tex = shard:CreateTexture(nil, 'BACKGROUND')
    shard.tex:SetAllPoints()
    if i <= soulShards then
      -- the soul shard is available
      shard.tex:SetColorTexture(0.50,	0.32,	0.55, 1)
    else
      -- the soul shard is unavailable
      shard.tex:SetColorTexture(0.1, 0.1, 0.1, 1)
    end
    local xOffset = (i - 1) * (soulShardWidth + dividerWidth)
    shard:SetPoint('LEFT', frame, 'LEFT', xOffset, 0)

    -- draw shard divider
    if i ~= maxSoulShards then
      local divider = _G['FigResourceWarlockDivider' .. i]
      if divider == nil then
        divider = CreateFrame('frame', 'FigResourceWarlockDivider' .. i, frame)
      end
      divider:SetSize(dividerWidth, frameHeight)
      divider.tex = divider:CreateTexture(nil, 'BACKGROUND')
      divider.tex:SetAllPoints()
      divider.tex:SetColorTexture(0, 0, 0, 1)
      divider:SetPoint('LEFT', frame, 'LEFT', xOffset + soulShardWidth, 0)
    end
  end

  FigTemplates.initializeBorderedFrame(frame)
end

local function updateSoulShards()
  local soulShards = UnitPower('player', Enum.PowerType.SoulShards)
  for i = 1, UnitPowerMax('player', Enum.PowerType.SoulShards) do
    local shard = _G['FigResourceWarlockShard' .. i]
    if i <= soulShards then
      -- the soul shard is available
      shard.tex:SetColorTexture(0.50,	0.32,	0.55, 1)
    else
      -- the soul shard is unavailable
      shard.tex:SetColorTexture(0.1, 0.1, 0.1, 1)
    end
  end
end

local function onEvent(frame, event, ...)
  if event == 'UNIT_POWER_FREQUENT' then
    local _, powerType = ...
    if powerType == 'SOUL_SHARDS' then
      updateSoulShards()
    end
  end
end

function FigWarlock.initialize(frame)
  -- set up redraw logic
  frame:SetScript('OnEvent', onEvent)
  frame:RegisterUnitEvent('UNIT_POWER_FREQUENT', 'player')
end
