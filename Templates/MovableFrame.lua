FigMovableFrameMixin = { movableFrames = {} }

function FigMovableFrameMixin.registerFrameForMovement(frame)
  if not FigMovableFrameMixin.movableFrames[frame:GetName()] then
    FigMovableFrameMixin.movableFrames[frame:GetName()] = frame
  end
end

-- preps frames to be moved or stationary depending on the current /figlock status
function FigMovableFrameMixin.toggleFrameMovement()
  if FigFramesAreLocked then
    for k, v in pairs(FigMovableFrameMixin.movableFrames) do
      local frame = v
      frame:EnableMouse(frame.mouseEnabledCopy or false)
    end
  else
    for k, v in pairs(FigMovableFrameMixin.movableFrames) do
      local frame = v
      -- store the previous mouseEnabled value to be restored when finished dragging
      frame.mouseEnabledCopy = frame:IsMouseEnabled()
      frame:EnableMouse(true)
    end
  end
end

function FigMovableFrameMixin.moveFrame(frame)
  if not FigFramesAreLocked then
    FigDebug.log('<FigUI> Started dragging frame: ', frame:GetName())
    frame:ClearAllPoints()
    frame:StartMoving()
    frame:SetUserPlaced(true)
  end
end

function FigMovableFrameMixin.stopMovingFrame(frame)
  if not FigFramesAreLocked then
    FigDebug.log('<FigUI> Stopped dragging frame: ', frame:GetName())
    frame:StopMovingOrSizing()
  end
end
