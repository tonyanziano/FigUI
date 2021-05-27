local function getMenuFunctionForUnit(frame, unit)
  if unit == 'player' then
    return function()
      ToggleDropDownMenu(1, nil, PlayerFrameDropDown, frame, 0, 0);
    end
  elseif unit == 'target' then
    return function()
      ToggleDropDownMenu(1, nil, TargetFrameDropDown, frame, 0, 0);
    end
  elseif strfind(unit, 'party', 0) then
    return function()
      ToggleDropDownMenu(1, nil, PartyFrameDropDown, frame, 0, 0);
    end
  elseif unit == 'pet' then
    return function()
      ToggleDropDownMenu(1, nil, PetFrameDropDown, frame, 0, 0);
    end
  end
  return nil
end

local function drawHpForUnitFrame(frame)
  local unit = frame.trackingUnit

  -- color the bar
  if UnitIsPlayer(unit) then
    local _, classToken = UnitClass(unit)
    local classColor = C_ClassColor.GetClassColor(classToken)
    frame.hp:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
  else
    -- color for NPC
    if UnitIsFriend('player', unit) then
      frame.hp:SetStatusBarColor(23/255, 166/255, 29/255)
    else
      frame.hp:SetStatusBarColor(209/255, 19/255, 19/255)
    end
  end

  -- update the status text
  if UnitIsDeadOrGhost(unit) then
    frame.hp.text:SetText('DEAD')
    frame.hp:SetValue(0)
  else
    local hp, maxHp = UnitHealth(unit), UnitHealthMax(unit)
    if maxHp == 0 then return end -- hp has not loaded yet -- let next redraw do the work
    local percentHp = format('%.1f', tostring(hp / maxHp * 100))
    local shortHp = Fig.prettyPrintNumber(hp)
    if frame.percentHpOnly ~= nil then
      frame.hp.text:SetText(format('%s%%', percentHp))
    else
      frame.hp.text:SetText(format('%s - %s%%', shortHp, percentHp))
    end
    frame.hp:SetValue(percentHp)
  end

  -- update the name
  local name = UnitName(unit)
  frame.hp.name:SetText(name)

  -- update the level & classification
  local level = UnitLevel(unit)
  if level == -1 then
    level = '??'
  end
  local classification = UnitClassification(unit)
  local eliteIdentifier, rareIdentifier = '', ''
  if strfind(classification, 'elite') then
    eliteIdentifier = '(Elite)'
  end
  if strfind(classification, 'rare') then
    rareIdentifier = '*'
  end
  frame.hp.level:SetText(format('Lv. %s %s %s', level, eliteIdentifier, rareIdentifier))
end

local function drawPowerForUnitFrame(frame)
  local unit = frame.trackingUnit

  -- color the bar
  local powerType = UnitPowerType(unit)
  local powerColor = PowerBarColor[powerType]
  frame.power:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)

  -- update the status text
  local power, maxPower = UnitPower(unit), UnitPowerMax(unit)
  if maxPower == -1 or maxPower == 0 then
    frame.power.text:SetText('')
    frame.power:SetValue(0)
    return
  end
  local percentPower = tostring(power / maxPower * 100)
  frame.power.text:SetText(format('%.1f%%', percentPower))
  frame.power:SetValue(percentPower)
end

local function drawUnitFrame(frame, elapsed)
  drawHpForUnitFrame(frame)
  drawPowerForUnitFrame(frame)
end

local function onEvent(frame, event, ...)
  if event == 'UNIT_AURA' then
    frame:drawAuras()
  end
  if event == 'PLAYER_TARGET_CHANGED' then
    frame:drawAuras()
  end
end

function FigTemplates.initializeUnitFrame(frame)
  -- make it function like a Blizzard unit frame
  local unit = frame.trackingUnit
  SecureUnitButton_OnLoad(frame, unit, getMenuFunctionForUnit(frame, unit))
  RegisterUnitWatch(frame)
  frame:RegisterForClicks('LeftButtonUp', 'RightButtonUp');

  -- draw auras if the frame cares about them
  if frame.drawAuras ~= nil then
    frame:RegisterUnitEvent('UNIT_AURA', unit)
    -- special case for target frame
    if unit == 'target' then
      frame:RegisterUnitEvent('PLAYER_TARGET_CHANGED')
    end
  end

  -- other initialization
  frame:SetScript('OnEvent', onEvent)
  frame:SetScript('OnUpdate', drawUnitFrame);
  FigTemplates.initializeBorderedFrame(frame)
  frame.hp:SetWidth(frame:GetWidth())
  frame.hp:SetHeight(frame:GetHeight() * .80) -- hp takes 80% of frame height
  frame.power:SetWidth(frame:GetWidth())
  frame.power:SetHeight(frame:GetHeight() * .20) -- power takes 20% of frame height

  -- the unit frame name should be truncated before bleeding into the status text
  frame.hp.name:SetWidth(frame.hp:GetWidth() / 3)
  if frame.oneLineName then
    frame.hp.name:SetMaxLines(1)
  end
end
