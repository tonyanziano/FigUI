Fig = {}

if not FigConfig then
  print('No saved Fig config detected. Generating new table.')
  FigConfig = { }
else
  print('Picked up Fig config from saved variables')
end

-- register slash commands
SLASH_SHOW_OPTIONS1, SLASH_SHOW_OPTIONS2 = '/fig', '/figui'
function SlashCmdList.SHOW_OPTIONS()
  -- this function is bugged and calling it twice navigates to the correct panel
  InterfaceOptionsFrame_OpenToCategory(FigConfigPanel)
  InterfaceOptionsFrame_OpenToCategory(FigConfigPanel)
end
