FigTemplates = {}

function moveBackdrop(overlay)
  local frame = overlay:GetParent()
  if not frame.isLocked then
    frame:StartMoving()
  end
end

function stopMovingBackdrop(overlay)
  local frame = overlay:GetParent()
  frame:StopMovingOrSizing()
end

function onToggleLock(frame)
  frame.isLocked = not frame.isLocked
  local overlayIsVisible = not frame.isLocked
  frame.overlay:SetShown(overlayIsVisible)
end

function FigTemplates.initalizeBackdrop(frame)
  -- temp
  Fig.frames[frame:GetName()] = frame
  frame.onToggleLock = onToggleLock
  frame.isLocked = true
  frame:SetClampedToScreen(true)

  -- create overlay for dragging
  frame.overlay:SetShown(false)
  frame.overlay:SetAllPoints()
  frame.overlay:SetFrameLevel(frame:GetFrameLevel() + 5) -- ensure frame is clickable
  frame.overlay:RegisterForDrag('LeftButton')
  frame.overlay:SetScript('OnDragStart', moveBackdrop)
  frame.overlay:SetScript('OnDragStop', stopMovingBackdrop)
end
