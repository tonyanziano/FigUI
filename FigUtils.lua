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
  if duration > (60 * 60 * 24) then
    -- days
    return format('%id', math.ceil(dutation / (60 * 60 * 24)))
  elseif duration > (60 * 60) then
    -- hours
    return format('%ih', math.ceil(duration / (60 * 60)))
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
    -- draw all borders within a frame on top of the parent frame (gets around the issue of textures being drawn under child frames)
    local borderFrameLevel = frame:GetFrameLevel() + 20
    local borderFrame = CreateFrame('frame', nil, frame)
    borderFrame:SetPoint('CENTER')
    borderFrame:SetFrameLevel(borderFrameLevel)
    borderFrame:SetSize(frame:GetSize())
    frame.borders = borderFrame
    local borderThickness = 1 -- TODO: make this configurable
    
    -- draw borders
    borderFrame.top = borderFrame:CreateTexture(nil, 'OVERLAY')
    borderFrame.top:SetColorTexture(0, 0, 0, 1)
    borderFrame.top:SetPoint('BOTTOMLEFT', borderFrame, 'TOPLEFT', -borderThickness, 0)
    borderFrame.top:SetPoint('BOTTOMRIGHT', borderFrame, 'TOPRIGHT', borderThickness, 0)
    borderFrame.top:SetHeight(borderThickness)

    borderFrame.bottom = borderFrame:CreateTexture(nil, 'OVERLAY')
    borderFrame.bottom:SetColorTexture(0, 0, 0, 1)
    borderFrame.bottom:SetPoint('TOPLEFT', borderFrame, 'BOTTOMLEFT', -borderThickness, 0)
    borderFrame.bottom:SetPoint('TOPRIGHT', borderFrame, 'BOTTOMRIGHT', borderThickness, 0)
    borderFrame.bottom:SetHeight(borderThickness)

    borderFrame.left = borderFrame:CreateTexture(nil, 'OVERLAY')
    borderFrame.left:SetColorTexture(0, 0, 0, 1)
    borderFrame.left:SetPoint('TOPRIGHT', borderFrame, 'TOPLEFT')
    borderFrame.left:SetPoint('BOTTOMRIGHT', borderFrame, 'BOTTOMLEFT')
    borderFrame.left:SetWidth(borderThickness)

    borderFrame.right = borderFrame:CreateTexture(nil, 'OVERLAY')
    borderFrame.right:SetColorTexture(0, 0, 0, 1)
    borderFrame.right:SetPoint('TOPLEFT', borderFrame, 'TOPRIGHT')
    borderFrame.right:SetPoint('BOTTOMLEFT', borderFrame, 'BOTTOMRIGHT')
    borderFrame.right:SetWidth(borderThickness)

    borderFrame:Show()
    frame.hasBorders = true
  end
end

function Fig.hideBordersForFrame(frame)
  if not frame then return end
  if frame.hasBorders then
    frame.borders:Hide();
  end
end

function Fig.showBordersForFrame(frame)
  if not frame then return end
  if frame.hasBorders then
    frame.borders:Show()
  end
end
