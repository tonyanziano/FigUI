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

function FigShaman.initialize(frame)
  frame:SetScript('OnEvent', FigShaman.handleEvents)
  frame:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
  frame:RegisterEvent('PLAYER_LOGIN')
  frame:SetScript('OnUpdate', FigShaman.onUpdate)

  frame:SetStatusBarColor(110/255, 110/255, 230/255)
  frame.bg:SetColorTexture(10/255, 10/255, 10/255)
  Fig.drawOutsetBordersForFrame(frame)
end
