Fig = { frames = {} }

-- register slash commands

SLASH_TOGGLE_FRAME_LOCK1 = '/figlock'
function SlashCmdList.TOGGLE_FRAME_LOCK()
  for _, frame in pairs(Fig.frames) do
    if frame.onToggleLock then
      frame:onToggleLock()
    end
  end
end

SLASH_TOGGLE_FIG_DEBUG1 = '/figdebug';
function SlashCmdList.TOGGLE_FIG_DEBUG()
  if FigDebug then
    FigDebug.logging = not FigDebug.logging
    print(format('Fig debug logging is now %s.', FigDebug.logging and 'enabled' or 'disabled'))
  end
end

