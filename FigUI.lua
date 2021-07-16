Fig = {}
FigFramesAreLocked = true

-- register slash commands

SLASH_TOGGLE_FRAME_LOCK1 = '/figlock'
function SlashCmdList.TOGGLE_FRAME_LOCK()
  FigFramesAreLocked = not FigFramesAreLocked
  FigMovableFrameMixin.toggleFrameMovement()
  print(format('<FigUI> Frames are now %s.', FigFramesAreLocked and 'locked' or 'unlocked'))
end

SLASH_TOGGLE_FIG_DEBUG1 = '/figdebug'
function SlashCmdList.TOGGLE_FIG_DEBUG()
  if FigDebug then
    FigDebug.logging = not FigDebug.logging
    print(format('<FigUI> Debug logging is now %s.', FigDebug.logging and 'enabled' or 'disabled'))
  end
end

