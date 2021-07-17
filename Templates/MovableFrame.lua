FigMovableFrameMixin = {}
local movableFrames = {}

-- create an indicator that will be shown when the frame is movable
local function createMovableIndicator(frame)
  frame.movableIndicator = CreateFrame('frame', frame:GetName() .. 'MovingIndicator', frame)
  frame.movableIndicator:SetAllPoints()
  frame.movableIndicator:SetSize(frame:GetSize())
  frame.movableIndicator:SetFrameLevel(frame:GetFrameLevel() + 99)

  -- create an overlay with some text on it
  frame.movableIndicator.overlay = frame.movableIndicator:CreateTexture(frame.movableIndicator:GetName() .. 'Overlay')
  frame.movableIndicator.overlay:SetAllPoints()
  frame.movableIndicator.overlay:SetColorTexture(0, 0, 0, 0.5)
  frame.movableIndicator.overlay:SetDrawLayer('OVERLAY')
  frame.movableIndicator.overlay:Show()

  frame.movableIndicator.text = frame.movableIndicator:CreateFontString(frame.movableIndicator:GetName() .. 'Text', 'OVERLAY', 'Game11Font')
  frame.movableIndicator.text:SetPoint('CENTER', frame.movableIndicator, 'CENTER')
  frame.movableIndicator.text:SetText('MOVABLE')

  frame.movableIndicator:Hide()
end

function FigMovableFrameMixin.registerFrameForMovement(frame)
  if not movableFrames[frame:GetName()] then
    createMovableIndicator(frame)
    movableFrames[frame:GetName()] = frame
  end
end

-- preps frames to be moved or stationary depending on the current /figlock status
function FigMovableFrameMixin.toggleFrameMovement()
  if FigFramesAreLocked then
    for k, v in pairs(movableFrames) do
      local frame = v
      frame.movableIndicator:Hide()
      frame:EnableMouse(frame.mouseEnabledCopy or false)
    end
  else
    for k, v in pairs(movableFrames) do
      local frame = v
      frame.movableIndicator:Show()
      -- store the previous mouseEnabled value to be restored when finished dragging
      frame.mouseEnabledCopy = frame:IsMouseEnabled()
      frame:EnableMouse(true)
    end
  end
end

function FigMovableFrameMixin.moveFrame(frame)
  if not FigFramesAreLocked then
    FigDebug.log('Started dragging frame: ', frame:GetName())
    frame:ClearAllPoints()
    frame:StartMoving()
    frame:SetUserPlaced(true)
  end
end

function FigMovableFrameMixin.stopMovingFrame(frame)
  if not FigFramesAreLocked then
    FigDebug.log('Stopped dragging frame: ', frame:GetName())
    frame:StopMovingOrSizing()
  end
end
