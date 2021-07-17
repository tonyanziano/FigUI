FigPlayerMixin = {}

local function initCombatIndicator(playerFrame)
  playerFrame.combatIndicator = CreateFrame('frame', 'FigPlayerCombatIndicator', playerFrame, 'FigPlayerCombatIndicatorTemplate')
  playerFrame.combatIndicator:SetPoint('TOPLEFT', playerFrame, 'TOPLEFT', 0, 0)
  playerFrame.combatIndicator:SetScale(0.7)
end

local function initRestingIndicator(playerFrame)
  -- the resting indicator is anchored to the combat indicator
  if not playerFrame.combatIndicator then
    initCombatIndicator(playerFrame)
  end
  playerFrame.restingIndicator = CreateFrame('frame', 'FigPlayerRestingIndicator', playerFrame, 'FigPlayerRestingIndicatorTemplate')
  playerFrame.restingIndicator:SetPoint('TOPLEFT', playerFrame.combatIndicator, 'TOPRIGHT', 0, 0)
  playerFrame.restingIndicator:SetScale(0.7)
end

local function onEvent(frame, event, ...)
  if event == 'PLAYER_REGEN_DISABLED' then
    if not frame.combatIndicator then
      initCombatIndicator(frame)
    end
    frame.combatIndicator:Show()
  elseif event == 'PLAYER_REGEN_ENABLED' then
    if not frame.combatIndicator then
      initCombatIndicator(frame)
    end
    frame.combatIndicator:Hide()
  elseif event == 'PLAYER_UPDATE_RESTING' or event == 'PLAYER_ENTERING_WORLD' then
    if not frame.restingIndicator then
      initRestingIndicator(frame)
    end
    frame.restingIndicator:SetShown(IsResting())
  end
end

function FigPlayerMixin.initialize(frame)
  frame:RegisterEvent('PLAYER_ENTERING_WORLD')
  frame:RegisterEvent('PLAYER_REGEN_DISABLED')
  frame:RegisterEvent('PLAYER_REGEN_ENABLED')
  frame:RegisterEvent('PLAYER_UPDATE_RESTING')
  frame:SetScript('OnEvent', onEvent)

  -- hide default player frame
  PlayerFrame:Hide();

  -- get resource bar if applicable
  local resourceBar = FigResources.getResourceBarForPlayer(frame)

  if resourceBar then
    resourceBar:SetPoint('TOPLEFT', frame, 'BOTTOMLEFT', 0, -4)

    -- size the bar
    resourceBar:SetWidth(frame:GetWidth())
    resourceBar:SetHeight(25)

    resourceBar:doInitialDraw()
  end
end