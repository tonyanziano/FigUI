FigResources = {}

function FigResources.getResourceBarForPlayer()
  local class = UnitClass('player')

  if class == 'Warlock' then
    local f = CreateFrame('frame', 'FigResourceWarlock', UIParent, 'FigResourceWarlockTemplate')
    return f
  end

  -- class & spec doesn't have a special resource bar
  return nil
end