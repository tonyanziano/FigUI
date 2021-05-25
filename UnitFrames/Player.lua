FigPlayerMixin = {}

function FigPlayerMixin.initialize(frame)
  -- get resource bar if applicable
  local resourceBar = FigResources.getResourceBarForPlayer()

  --TODO: position the bar according to compact / pop-out mode
  -- if config.compactResourceBar then
  resourceBar:SetPoint('TOPLEFT', frame, 'BOTTOMLEFT', 0, -4)
  -- else
  -- end

  -- size the bar
  resourceBar:SetWidth(frame:GetWidth())
  resourceBar:SetHeight(25)

  -- have the bar draw its contents to fit the size
  resourceBar:doInitialDraw()
  resourceBar:initialize()
end