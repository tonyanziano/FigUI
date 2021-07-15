FigMovableFrameMixin = {}

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
