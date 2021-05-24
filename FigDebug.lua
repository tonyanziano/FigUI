Fig.debug = {
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
  }
}

function Fig.debug.drawRedBackgroundOnFrame(frame)
  frame._debuffTexGreen = frame:CreateTexture(nil, 'BACKGROUND')
  frame._debuffTexGreen:SetAllPoints()
  frame._debuffTexGreen:SetColorTexture(1, 0, 0, 0.5)
end

function Fig.debug.drawGreenBackgroundOnFrame(frame)
  frame._debuffTexGreen = frame:CreateTexture(nil, 'BACKGROUND')
  frame._debuffTexGreen:SetAllPoints()
  frame._debuffTexGreen:SetColorTexture(0, 1, 0, 0.5)
end

function Fig.debug.drawBlueBackgroundOnFrame(frame)
  frame._debuffTexGreen = frame:CreateTexture(nil, 'BACKGROUND')
  frame._debuffTexGreen:SetAllPoints()
  frame._debuffTexGreen:SetColorTexture(0, 0, 1, 0.5)
end
