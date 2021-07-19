FigResourceWarlockMixin = {}

FigResourceWarlockMixin.powerType = 'SOUL_SHARDS'

function FigResourceWarlockMixin.doInitialDraw(frame)
  local frameHeight = frame:GetHeight()
  local soulShards = UnitPower('player', Enum.PowerType.SoulShards)
  local maxSoulShards = UnitPowerMax('player', Enum.PowerType.SoulShards)
  local dividerWidth = 1
  local remainingFrameWidth = frame:GetWidth() - (dividerWidth * (maxSoulShards - 1))
  local soulShardWidth = remainingFrameWidth / maxSoulShards

  for i = 1, maxSoulShards do
    -- draw shard indicator
    local shard = _G['FigResourceWarlockShard' .. i] or CreateFrame('frame', 'FigResourceWarlockShard' .. i, frame)
    shard:SetSize(soulShardWidth, frameHeight)
    shard.bgTex = _G[shard:GetName() .. 'Background'] or shard:CreateTexture(shard:GetName() .. 'Background', 'BACKGROUND')
    shard.bgTex:SetColorTexture(0.1, 0.1, 0.1, 1)
    shard.bgTex:SetAllPoints()
    shard.fillTex = _G[shard:GetName() .. 'Fill'] or shard:CreateTexture(shard:GetName() .. 'Fill', 'ARTWORK')
    shard.fillTex:SetColorTexture(0.50,	0.32,	0.55, 1)
    shard.fillTex:SetAllPoints()

    if i <= soulShards then
      -- the soul shard is available
      shard.fillTex:Show()
      shard.available = true
    else
      -- the soul shard is unavailable
      shard.fillTex:Hide()
      shard.available = false
    end
    local xOffset = (i - 1) * (soulShardWidth + dividerWidth)
    shard:SetPoint('LEFT', frame, 'LEFT', xOffset, 0)

    -- draw shard divider
    if i ~= maxSoulShards then
      local divider = _G['FigResourceWarlockDivider' .. i] or CreateFrame('frame', 'FigResourceWarlockDivider' .. i, frame)
      divider:SetSize(dividerWidth, frameHeight)
      divider.tex = divider:CreateTexture(nil, 'BACKGROUND')
      divider.tex:SetAllPoints()
      divider.tex:SetColorTexture(0, 0, 0, 1)
      divider:SetPoint('LEFT', frame, 'LEFT', xOffset + soulShardWidth, 0)
    end
  end

  Fig.drawOutsetBordersForFrame(frame)
end

function FigResourceWarlockMixin.updateResource()
  local soulShards = UnitPower('player', Enum.PowerType.SoulShards)
  local maxSoulShards = UnitPowerMax('player', Enum.PowerType.SoulShards)
  FigDebug.log('Updating soul shards: ', soulShards, maxSoulShards)
  for i = 1, maxSoulShards do
    local shard = _G['FigResourceWarlockShard' .. i]
    if i <= soulShards then
      -- the soul shard is available
      shard.fillTex:Show()
      shard.available = true
    else
      -- the soul shard is unavailable
      shard.fillTex:Hide()
      shard.available = false
    end
  end
end
