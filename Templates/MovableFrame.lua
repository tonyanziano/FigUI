FigMovableFrameMixin = {}

function FigMovableFrameMixin.moveFrame(frame)
  if not FigFramesAreLocked then
    frame:StartMoving()
  end
end

function FigMovableFrameMixin.stopMovingFrame(frame)
  if not FigFramesAreLocked then
    frame:StopMovingOrSizing()
  end
end
