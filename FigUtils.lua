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

-- Shortens a duration in seconds to a prettier form:
-- Ex. 3600 -> 1h, 180 -> 3m, etc
function Fig.prettyPrintDuration(duration)
  if duration > 3600 then
    -- hours
    return format('%ih', math.ceil(duration / 3600))
  elseif duration > 60 then
    -- minutes
    return format('%im', math.ceil(duration / 60))
  else
    --seconds
    return format('%is', math.ceil(duration))
  end
end

function Fig.drawBordersForFrame(frame)
  if not frame then return end

  if not frame.hasBorders then
    -- draw borders
    frame.top = frame:CreateTexture(nil, 'OVERLAY')
    frame.top:SetColorTexture(0, 0, 0, 1)
    frame.top:SetPoint('TOPLEFT', frame, 'TOPLEFT')
    frame.top:SetPoint('TOPRIGHT', frame, 'TOPRIGHT')
    frame.top:SetHeight(2)

    frame.bottom = frame:CreateTexture(nil, 'OVERLAY')
    frame.bottom:SetColorTexture(0, 0, 0, 1)
    frame.bottom:SetPoint('BOTTOMLEFT', frame, 'BOTTOMLEFT')
    frame.bottom:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT')
    frame.bottom:SetHeight(2)

    frame.left = frame:CreateTexture(nil, 'OVERLAY')
    frame.left:SetColorTexture(0, 0, 0, 1)
    frame.left:SetPoint('TOPLEFT', frame, 'TOPLEFT')
    frame.left:SetPoint('BOTTOMLEFT', frame, 'BOTTOMLEFT')
    frame.left:SetWidth(2)

    frame.right = frame:CreateTexture(nil, 'OVERLAY')
    frame.right:SetColorTexture(0, 0, 0, 1)
    frame.right:SetPoint('TOPRIGHT', frame, 'TOPRIGHT')
    frame.right:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT')
    frame.right:SetWidth(2)

    frame.hasBorders = true
  end
end

function Fig.hideBordersForFrame(frame)
  if not frame then return end
  if frame.hasBorders then
    frame.top:Hide()
    frame.bottom:Hide()
    frame.left:Hide()
    frame.right:Hide()
  end
end

function Fig.showBordersForFrame(frame)
  if not frame then return end
  if frame.hasBorders then
    frame.top:Show()
    frame.bottom:Show()
    frame.left:Show()
    frame.right:Show()
  end
end

function Fig.drawBordersForFrame_OLD(frame)
  if not frame then return end
  
  local borderThickness = 2
  borderThickness = PixelUtil.GetNearestPixelSize(borderThickness, frame:GetEffectiveScale(), 1)
  if not frame.hasBorders then
    -- draw borders
    local top = frame:CreateLine()
    top:SetColorTexture(0, 0, 0, 1)
    top:SetStartPoint('TOPLEFT', frame, -borderThickness/2, borderThickness/2)
    top:SetEndPoint('TOPRIGHT', frame, borderThickness/2, borderThickness/2)
    top:SetThickness(borderThickness)
    frame.topBorder = top
    
    local bot = frame:CreateLine()
    bot:SetColorTexture(0, 0, 0, 1)
    bot:SetStartPoint('BOTTOMLEFT', frame, -borderThickness/2, -borderThickness/2)
    bot:SetEndPoint('BOTTOMRIGHT', frame, borderThickness/2, -borderThickness/2)
    bot:SetThickness(borderThickness)
    frame.botBorder = bot
    
    local left = frame:CreateLine()
    left:SetColorTexture(0, 0, 0, 1)
    left:SetStartPoint('TOPLEFT', frame, -borderThickness/2, borderThickness/2)
    left:SetEndPoint('BOTTOMLEFT', frame, -borderThickness/2, -borderThickness/2)
    left:SetThickness(borderThickness)
    frame.leftBorder = left
    
    local right = frame:CreateLine()
    right:SetColorTexture(0, 0, 0, 1)
    right:SetStartPoint('TOPRIGHT', borderThickness/2, borderThickness/2)
    right:SetEndPoint('BOTTOMRIGHT', borderThickness/2, -borderThickness/2)
    right:SetThickness(borderThickness)
    frame.rightBorder = right

    frame.hasBorders = true
  end
end