FigShaman = {}

function FigShaman.showIfApplicable(frame)
  -- only show if the player is an elemental shaman
  local _, class = UnitClass("player")
  if class == 'SHAMAN' then
    local specIndex = GetSpecialization()
    if specIndex then
      local _, specName = GetSpecializationInfo(specIndex)
      if specName == 'Elemental' then
        frame:Show()
        return
      end
    end
  end
  frame:Hide()
end

function FigShaman.handleEvents(frame, event, ...)
  if event == 'ACTIVE_TALENT_GROUP_CHANGED' then
    FigShaman.showIfApplicable(frame)
  end
  if event == 'PLAYER_LOGIN' then
    -- wait for the player info to load before querying class / sepc
    FigShaman.showIfApplicable(frame)
  end
end

function FigShaman.onUpdate(frame, elapsed)
  local maelstrom = UnitPower('player', Enum.PowerType.Maelstrom)
  frame:SetValue(maelstrom)
  frame.text:SetText(maelstrom)
end

function drawBorders(frame)
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
end

function FigShaman.initialize(frame)
  frame:SetScript('OnEvent', FigShaman.handleEvents)
  frame:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
  frame:RegisterEvent('PLAYER_LOGIN')
  frame:SetScript('OnUpdate', FigShaman.onUpdate)

  frame:SetStatusBarColor(110/255, 110/255, 230/255)
  frame.bg:SetColorTexture(10/255, 10/255, 10/255)
  drawBorders(frame)
end
