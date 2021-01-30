function Fig.makeFrame(name, parent)
  local f = CreateFrame('FRAME', name, parent or UIParent)
  return f
end

function Fig.getTexturePath(texture)
  return 'Interface\\AddOns\\FigUI\\Textures\\' .. texture
end

function Fig.prettyPrintNumber(num)
  if num >= 1000 then
    -- do conversion to shorter syntax (eg. 4700 = 4.7k)
    return format('%.1f', tostring(num / 1000)) .. 'k'
  else
    return tostring(num)
  end
end

function Fig.drawBordersForFrame(frame)
  if not frame then return end
  
  local borderThickness = 2
  borderThickness = PixelUtil.GetNearestPixelSize(borderThickness, frame:GetEffectiveScale(), 1)
  if not frame.hasBorders then
    -- draw borders

    local top = frame:CreateLine()
    top:SetColorTexture(0, 0, 0, 1)
    top:SetStartPoint('TOPLEFT', frame, -1, 1)
    top:SetEndPoint('TOPRIGHT', frame, 1, 1)
    top:SetThickness(borderThickness)
    
    local bot = frame:CreateLine()
    bot:SetColorTexture(0, 0, 0, 1)
    bot:SetStartPoint('BOTTOMLEFT', frame, -1, -1)
    bot:SetEndPoint('BOTTOMRIGHT', frame, 1, -1)
    bot:SetThickness(borderThickness)
    
    local left = frame:CreateLine()
    left:SetColorTexture(0, 0, 0, 1)
    left:SetStartPoint('TOPLEFT', frame, -1, 1)
    left:SetEndPoint('BOTTOMLEFT', frame, -1, -1)
    left:SetThickness(borderThickness)
    
    local right = frame:CreateLine()
    right:SetColorTexture(0, 0, 0, 1)
    right:SetStartPoint('TOPRIGHT', 1, 1)
    right:SetEndPoint('BOTTOMRIGHT', 1, -1)
    right:SetThickness(borderThickness)

    frame.hasBorders = true
  end
end