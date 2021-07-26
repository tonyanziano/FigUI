FigResources = {}

function FigResources.getResourceBarForPlayer()
  local class = UnitClass('player')

  if class == 'Death Knight' then
    local f = CreateFrame('frame', 'FigResourceDeathKnight', UIParent, 'FigResourceDeathKnightTemplate')
    return f
  elseif class == 'Paladin' then
    local f = CreateFrame('frame', 'FigResourcePaladin', UIParent, 'FigResourcePaladinTemplate')
    return f
  elseif class == 'Rogue' then
    local f = CreateFrame('frame', 'FigResourceRogue', UIParent, 'FigResourceRogueTemplate')
    return f
  elseif class == 'Warlock' then
    local f = CreateFrame('frame', 'FigResourceWarlock', UIParent, 'FigResourceWarlockTemplate')
    return f
  end

  -- class & spec doesn't have a special resource bar
  return nil
end