FigPlayerMixin = {}

local function initCombatIndicator(playerFrame)
  playerFrame.combatIndicator = CreateFrame('frame', 'FigPlayerCombatIndicator', playerFrame, 'FigPlayerCombatIndicatorTemplate')
  playerFrame.combatIndicator:SetPoint('TOPLEFT', playerFrame, 'TOPLEFT', 0, 0)
  playerFrame.combatIndicator:SetScale(0.7)
end

local function onEvent(frame, event, ...)
  if event == 'PLAYER_REGEN_DISABLED' then
    if not frame.combatIndicator then
      initCombatIndicator(frame)
    end
    frame.combatIndicator:Show()
  elseif 'PLAYER_REGEN_ENABLED' then
    if not frame.combatIndicator then
      initCombatIndicator(frame)
    end
    frame.combatIndicator:Hide()
  end
end

function FigPlayerMixin.initialize(frame)
  frame:RegisterEvent('PLAYER_REGEN_DISABLED')
  frame:RegisterEvent('PLAYER_REGEN_ENABLED')
  frame:SetScript('OnEvent', onEvent)

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
  
  -- let the bar initialize
  resourceBar:initialize()
end