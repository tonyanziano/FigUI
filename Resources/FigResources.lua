FigResources = {}

function FigResources.getResourceBarForPlayer()
  local class = UnitClass('player')

  if class == 'Death Knight' then
    local f = CreateFrame('frame', 'FigResourceDeathKnight', UIParent, 'FigResourceDeathKnightTemplate')
    return f
  elseif class == 'Mage' then
    local f = CreateFrame('frame', 'FigResourceMage', UIParent, 'FigResourceMageTemplate')
    return f
  elseif class == 'Monk' then
    local f = CreateFrame('frame', 'FigResourceMonk', UIParent, 'FigResourceMonkTemplate')
    return f
  elseif class == 'Paladin' then
    local f = CreateFrame('frame', 'FigResourcePaladin', UIParent, 'FigResourcePaladinTemplate')
    return f
  elseif class == 'Priest' then
    local f = CreateFrame('statusbar', 'FigResourcePriest', UIParent, 'FigResourcePriestTemplate')
    return f
  elseif class == 'Rogue' then
    local f = CreateFrame('frame', 'FigResourceRogue', UIParent, 'FigResourceRogueTemplate')
    return f
  elseif class == 'Shaman' then
    local f = CreateFrame('statusbar', 'FigResourceShaman', UIParent, 'FigResourceShamanTemplate')
    return f
  elseif class == 'Warlock' then
    local f = CreateFrame('frame', 'FigResourceWarlock', UIParent, 'FigResourceWarlockTemplate')
    return f
  elseif class == 'Warrior' then
    local f = CreateFrame('statusbar', 'FigResourceWarrior', UIParent, 'FigResourceWarriorTemplate')
    return f
  end

  -- class & spec doesn't have a special resource bar
  return nil
end