FigTemplates = {}

local function moveBorderedFrame(overlay)
  local frame = overlay:GetParent()
  if not frame.isLocked then
    frame:StartMoving()
  end
end

local function stopMovingBorderedFrame(overlay)
  local frame = overlay:GetParent()
  frame:StopMovingOrSizing()
end

local function onToggleLock(frame)
  frame.isLocked = not frame.isLocked
  local overlayIsVisible = not frame.isLocked
  frame.overlay:SetShown(overlayIsVisible)
end

function FigTemplates.initializeBorderedFrame(frame)
  Fig.frames[frame:GetName()] = frame
  frame.onToggleLock = onToggleLock
  frame.isLocked = true
  frame:SetClampedToScreen(true)
  frame:EnableMouse(true)
  frame:SetMovable(true)

  -- create overlay for dragging
  frame.overlay = CreateFrame('frame', nil, frame)
  frame.overlay.tex = frame.overlay:CreateTexture(nil, 'OVERLAY')
  frame.overlay.tex:SetAllPoints()
  frame.overlay.tex:SetColorTexture(0, 1, 0, .6)
  frame.overlay:EnableMouse(true)
  frame.overlay:SetShown(false)
  frame.overlay:SetAllPoints()
  frame.overlay:SetFrameLevel(frame:GetFrameLevel() + 5) -- ensure frame is clickable
  frame.overlay:RegisterForDrag('LeftButton')
  frame.overlay:SetScript('OnDragStart', moveBorderedFrame)
  frame.overlay:SetScript('OnDragStop', stopMovingBorderedFrame)

  Fig.drawBordersForFrame(frame)
end
