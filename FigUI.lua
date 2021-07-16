Fig = {}
FigFramesAreLocked = true

-- register slash commands

SLASH_FIG_HELP1, SLASH_FIG_HELP2 = '/fig', '/fighelp'
local commands = {
  ['/figlock'] = 'Toggles ability to drag frames.',
  ['/figdebug'] = 'Enables debugging output.'
}
local helpText = format('%sFigUI%s available commands:', WrapTextInColorCode('<', 'FF2DEBE5'), WrapTextInColorCode('>', 'FF2DEBE5'))
for k, v in pairs(commands) do
  helpText = helpText .. format('\n%s - %s', WrapTextInColorCode(k, 'FFFAF034'), v)
end
function SlashCmdList.FIG_HELP()
  print(helpText)
end

SLASH_TOGGLE_FRAME_LOCK1 = '/figlock'
function SlashCmdList.TOGGLE_FRAME_LOCK()
  FigFramesAreLocked = not FigFramesAreLocked
  FigMovableFrameMixin.toggleFrameMovement()
  FigDebug.log(format('Frames are now %s.', FigFramesAreLocked and 'locked' or 'unlocked'))
end

SLASH_TOGGLE_FIG_DEBUG1 = '/figdebug'
function SlashCmdList.TOGGLE_FIG_DEBUG()
  if FigDebug then
    FigDebug.logging = not FigDebug.logging
    FigDebug.log(format('Debug logging is now %s.', FigDebug.logging and 'enabled' or 'disabled'))
  end
end

