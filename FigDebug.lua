FigDebug = {
  -- sample icons to use for debugging
  icons = {
   {
     -- blessing of spellwarding
     icon = 135880,
     spellId = 204018
   },
   {
     -- flameshock
     icon = 135813,
     spellId = 188389
   }
  },
  logging = false
}

function FigDebug.log(...)
  if FigDebug.logging then
    print(...)
  end
end

function FigDebug.drawRedBackgroundOnFrame(frame)
  frame._debuffTexGreen = frame:CreateTexture(nil, 'BACKGROUND')
  frame._debuffTexGreen:SetAllPoints()
  frame._debuffTexGreen:SetColorTexture(1, 0, 0, 0.5)
end

function FigDebug.drawGreenBackgroundOnFrame(frame)
  frame._debuffTexGreen = frame:CreateTexture(nil, 'BACKGROUND')
  frame._debuffTexGreen:SetAllPoints()
  frame._debuffTexGreen:SetColorTexture(0, 1, 0, 0.5)
end

function FigDebug.drawBlueBackgroundOnFrame(frame)
  frame._debuffTexGreen = frame:CreateTexture(nil, 'BACKGROUND')
  frame._debuffTexGreen:SetAllPoints()
  frame._debuffTexGreen:SetColorTexture(0, 0, 1, 0.5)
end
