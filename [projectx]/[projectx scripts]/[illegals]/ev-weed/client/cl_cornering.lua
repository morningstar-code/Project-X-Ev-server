local CurrentlyCornering = false
local CurrentCornerCoords
local CurrentCornerVehicle
local CurrentCornerZone

local UsedPeds = {}
local ActivePeds = {}

local InteractStartCorner = {
  group = { 2 },
  data = {
    {
      id = 'vehicle_startcornering',
      label = 'start cornering weed',
      icon = 'handshake',
      event = 'ev-weed:startCornering',
      parameters = {},
    },
  },
  options = {
    distance = { radius = 5.0 },
    isEnabled = function(pEntity, pContext)
      local hasWeed = exports['ev-inventory']:hasEnoughOfItem('weedbaggie', 1, false, true)
      local isCorneringAlready = false --exports['ev-meth']:IsCornering() 
      local isHeli = IsEntityAVehicle(pEntity) and GetVehicleClass(pEntity) == 15
      return not CurrentlyCornering and hasWeed and not IsPedInAnyVehicle(PlayerPedId(), false) and not isHeli and not isCorneringAlready
    end,
  },
}

local InteractStopCorner = {
  group = { 2 },
  data = {
    {
      id = 'vehicle_stopcornering',
      label = 'stop cornering weed',
      icon = 'handshake-slash',
      event = 'ev-weed:stopCornering',
      parameters = {},
    },
  },
  options = {
    distance = { radius = 5.0 },
    isEnabled = function(pEntity, pContext)
      return CurrentlyCornering and not IsPedInAnyVehicle(PlayerPedId(), false)
    end,
  },
}

local InteractCorner = {
  group = { 1 },
  data = {
    {
      id = 'weed_corner_sale',
      label = 'sell',
      icon = 'comment-dollar',
      event = 'ev-weed:cornerSale',
      parameters = {},
    },
  },
  options = {
    distance = { radius = 2.5 },
    isEnabled = function(pEntity, pContext)
      return CurrentlyCornering and ActivePeds[pEntity] and not IsPedInAnyVehicle(PlayerPedId(), false)
    end,
  },
}

local InteractCornerVehicle = {
  group = { 2 },
  data = {
    {
      id = 'weed_corner_sale_vehicle',
      label = 'prepare baggies',
      icon = 'balance-scale-right',
      event = 'ev-weed:prepareBaggies',
      parameters = {},
    },
  },
  options = {
    distance = { radius = 5.0 },
    isEnabled = function(pEntity, pContext)
      local hasWeed = exports['ev-inventory']:hasEnoughOfItem('weedpackage', 1, false, true)
      return hasWeed
    end,
  },
}

Citizen.CreateThread(function()
  exports['ev-interact']:AddPeekEntryByEntityType(InteractCorner.group, InteractCorner.data, InteractCorner.options)
  exports['ev-interact']:AddPeekEntryByEntityType(InteractCornerVehicle.group, InteractCornerVehicle.data, InteractCornerVehicle.options)
  exports['ev-interact']:AddPeekEntryByEntityType(InteractStartCorner.group, InteractStartCorner.data, InteractStartCorner.options)
  exports['ev-interact']:AddPeekEntryByEntityType(InteractStopCorner.group, InteractStopCorner.data, InteractStopCorner.options)
end)

AddEventHandler('ev-weed:startCornering', function(pContext, pEntity)
  CurrentCornerCoords = GetEntityCoords(PlayerPedId())
  CurrentCornerZone = GetNameOfZone(CurrentCornerCoords)

  if not WhitelistedZones[CurrentCornerZone] then
    TriggerEvent('DoLongHudText', 'Nobody is buying around here')
    return
  end

  local canCorner, message = RPC.execute('ev-weed:startCorner', CurrentCornerCoords)
  TriggerEvent('DoLongHudText', message)

  if not canCorner then
    return
  end

  CurrentlyCornering = true
  CurrentCornerVehicle = pEntity

  Sync.SetVehicleDoorOpen(CurrentCornerVehicle, 5, false, false)

  -- Ped spawn loop
  Citizen.CreateThread(function()
    while CurrentlyCornering and CornerConfig.PopulateRate ~= -1 do
      PopulateNow()
      Wait(CornerConfig.PopulateRate)
    end
  end)

  -- Ped Acquisition loop
  Citizen.CreateThread(function()
    local notFoundCount = 0
    while CurrentlyCornering do
      local plyCoords = GetEntityCoords(PlayerPedId())
      if #(CurrentCornerCoords - plyCoords) > 50.0 or #(GetEntityCoords(CurrentCornerVehicle) - plyCoords) > 50.0 then
        TriggerEvent('DoLongHudText', 'No longer selling...')
        stopCornering()
        return
      end

      local peds = GetGamePool('CPed')
      local foundPed
      for _, ped in ipairs(peds) do
        if not IsPedDeadOrDying(ped, true) and not IsPedAPlayer(ped) and not IsPedFleeing(ped) and IsPedOnFoot(ped) and
            not IsPedInAnyVehicle(ped, true) and IsPedHuman(ped) and NetworkGetEntityIsNetworked(ped) and not IsPedInMeleeCombat(ped) and
            not UsedPeds[ped] and not ActivePeds[ped] and #(CurrentCornerCoords - GetEntityCoords(ped)) < 100.0 then
          TriggerEvent('DoLongHudText', message)
          foundPed = ped
          notFoundCount = 0
          break
        end
      end

      if not foundPed then
        notFoundCount = notFoundCount + 1
      else
        local retval, coords = GetPointOnRoadSide(CurrentCornerCoords.x, CurrentCornerCoords.y, CurrentCornerCoords.z, 1)
        RPC.execute('ev-weed:cornerPed', coords, NetworkGetNetworkIdFromEntity(foundPed), NetworkGetNetworkIdFromEntity(CurrentCornerVehicle))
      end

      if notFoundCount > 7 then
        TriggerEvent('DoLongHudText', 'Looks like this spot has dried up.')
        stopCornering()
        return
      end

      Wait(CornerConfig.TimeBetweenAcquisition)
    end
  end)
end)

local weedItems = { 'corner-weed-item1', 'corner-weed-item2', 'corner-weed-item3', 'corner-weed-item4', 'corner-weed-item5' }

local weedItemsEng = { 'Kief', 'Baggie', 'Papers', 'Weed Pipe', 'Joint' }

AddEventHandler('ev-weed:cornerSale', function(pContext, pEntity)
  if not DoesEntityExist(pEntity) == 1 or IsPedDeadOrDying(pEntity) then
    return
  end

  local hasBaggies = exports['ev-inventory']:hasEnoughOfItem('weedbaggie', 1, true)
  if not hasBaggies then
    TriggerEvent('DoLongHudText', 'You need more baggies to sell')
    return
  end

  SetPedCanRagdoll(PlayerPedId(), false)
  PlayAmbientSpeech1(pEntity, 'Generic_Hi', 'Speech_Params_Force')
  TaskTurnPedToFaceEntity(PlayerPedId(), pEntity, 1000)
  TaskPlayAnim(PlayerPedId(), 'mp_safehouselost@', 'package_dropoff', 8.0, -8.0, -1, 4096, 0, false, false, false)
  RPC.execute('ev-weed:cornerSyncHandoff', CurrentCornerCoords, NetworkGetNetworkIdFromEntity(pEntity))

  Wait(2000)
  SetPedCanRagdoll(PlayerPedId(), true)
  if CornerConfig.DropEvidence and math.random() < 0.3 then
    local rndItem = math.random(1, #weedItems)
    TriggerEvent('evidence:drugs', weedItemsEng[rndItem])
  end

  local didSale = RPC.execute('ev-weed:cornerSale', CurrentCornerCoords, NetworkGetNetworkIdFromEntity(pEntity), CurrentCornerZone)
  if didSale then
    PlayAmbientSpeech1(pEntity, 'Chat_State', 'Speech_Params_Force')
    TriggerEvent('money:clean', 0.07)
    TriggerServerEvent('ev-heists:generateSafeCrackingTool')
  end
  if didSale and math.random() < 0.05 then
    TriggerEvent('meth:drugsale')
  end
end)

AddEventHandler('ev-weed:prepareBaggies', function(pContext, pEntity)
  if CornerConfig.RequireScales then
    local hasScale = exports['ev-inventory']:hasEnoughOfItem('qualityscales', 1, false) or exports['ev-inventory']:hasEnoughOfItem('smallscales', 1, false)
    if not hasScale then
      TriggerEvent('DoLongHudText', 'You need a scale', 2)
      return
    end
  end

  local hasBaggies = exports['ev-inventory']:hasEnoughOfItem('emptybaggies', CornerConfig.BaggiesPerBrick / 4, false)
  if not hasBaggies then
    TriggerEvent('DoLongHudText', 'You need more empty baggies', 2)
    return
  end

  loadAnimDict('mini@repair')
  TaskTurnPedToFaceEntity(PlayerPedId(), pEntity, 0)
  local finished = exports['ev-taskbar']:taskBar(30000, 'Preparing', false, true, false, false, nil, 5.0, pEntity)
  if finished == 100 then
    local weedpackages = exports['ev-inventory']:getItemsOfType('weedpackage', 1, true)
    if #weedpackages == 0 then
      return
    end
    -- local package = weedpackages[1]
    -- local info = json.decode(package.information)
    RPC.execute('ev-weed:prepareBaggies')
  end
end)

AddEventHandler('ev-weed:stopCornering', function(pContext, pEntity)
  TriggerEvent('DoLongHudText', 'No longer selling...')
  stopCornering()
end)

RegisterNetEvent('ev-weed:addCorneredPed')
AddEventHandler('ev-weed:addCorneredPed', function(pPed)
  local ped = NetworkGetEntityFromNetworkId(pPed)
  ActivePeds[ped] = false
end)

RegisterNetEvent('ev-weed:cornerSyncHandoff')
AddEventHandler('ev-weed:cornerSyncHandoff', function(pPed)
  local ped = NetworkGetEntityFromNetworkId(pPed)
  local relation = GetPedRelationshipGroupHash(ped)
  SetRelationshipBetweenGroups(0, `PLAYER`, relation)
  SetRelationshipBetweenGroups(0, relation, `PLAYER`)
  if NetworkHasControlOfEntity(ped) then
    TaskHandoff(ped)
  end
end)

RegisterNetEvent('ev-weed:cornerPed')
AddEventHandler('ev-weed:cornerPed', function(pPed, pCornerCoords, pVehicle)
  local ped = NetworkGetEntityFromNetworkId(pPed)
  ActivePeds[ped] = true
  UsedPeds[ped] = true
  if NetworkHasControlOfEntity(ped) then
    local robber = math.random()
    if robber > 0.9969 then
      TaskRobTrunk(ped, pCornerCoords, NetworkGetEntityFromNetworkId(pVehicle))
      ActivePeds[ped] = false
    else
      TaskWalkToCorner(ped, pCornerCoords)
    end
  end
end)

RegisterNetEvent('ev-weed:cleanCornerPeds')
AddEventHandler('ev-weed:cleanCornerPeds', function()
  UsedPeds = {}
end)

function stopCornering()
  for ped, _ in pairs(ActivePeds) do
    Sync.SetEntityAsNoLongerNeeded(ped)
    Sync.SetPedKeepTask(ped, false)
  end
  ActivePeds = {}
  CurrentlyCornering = false
  CurrentCornerCoords = nil
  CurrentCornerVehicle = nil
  CurrentCornerZone = nil
  RPC.execute('ev-weed:stopCorner')
end

function TaskHandoff(pPed)
  loadAnimDict('mp_safehouselost@')
  ClearPedTasks(pPed)

  local taskSeq = OpenSequenceTask()
  TaskSetBlockingOfNonTemporaryEvents(0, true)
  TaskTurnPedToFaceEntity(0, PlayerPedId(), 0)
  TaskPlayAnim(0, 'mp_safehouselost@', 'package_dropoff', 8.0, -8.0, -1, 0, 0, false, false, false)
  TaskSetBlockingOfNonTemporaryEvents(0, false)
  TaskWanderStandard(0, 10.0, 10)
  CloseSequenceTask(taskSeq)

  TaskPerformSequence(pPed, taskSeq)
  ClearSequenceTask()
  SetPedKeepTask(pPed)
end

function TaskWalkToCorner(pPed, pCornerCoords)
  ClearPedTasks(pPed)
  local animDict, anim = getRandomIdle()
  loadAnimDict(animDict)

  local randomLength = (math.random() * 7.0) + 3.0
  local taskSeq = OpenSequenceTask()
  TaskSetBlockingOfNonTemporaryEvents(0, true)
  TaskFollowNavMeshToCoord(0, pCornerCoords, 1.0, -1, randomLength, true, 40000.0)
  TaskTurnPedToFaceEntity(0, PlayerPedId(), 0)
  TaskPlayAnim(0, animDict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
  TaskPause(0, 10000)
  TaskSetBlockingOfNonTemporaryEvents(0, false)
  TaskWanderStandard(0, 10.0, 10)
  CloseSequenceTask(taskSeq)

  TaskPerformSequence(pPed, taskSeq)
  ClearSequenceTask()
  SetPedKeepTask(pPed, true)

  SetEntityAsMissionEntity(pPed, true, true)
  SetTimeout(120000, function()
    Sync.SetEntityAsNoLongerNeeded(pPed)
    Sync.SetPedKeepTask(pPed, false)
  end)
end

function TaskRobTrunk(pPed, pCornerCoords, pCornerVehicle)
  ClearPedTasks(pPed)
  -- This is a good "Robber" script or something, goes to trunk and plays anim, then runs away
  loadAnimDict('mini@repair')

  local taskSeq = OpenSequenceTask()
  TaskSetBlockingOfNonTemporaryEvents(0, true)
  TaskFollowNavMeshToCoord(0, pCornerCoords, 10.0, -1, 1.0, true, 40000.0)
  TaskTurnPedToFaceEntity(0, pCornerVehicle, 0)
  TaskPlayAnim(0, 'mini@repair', 'fixing_a_player', 8.0, -8.0, -1, 1, 0, false, false, false)
  TaskSetBlockingOfNonTemporaryEvents(0, false)
  TaskSmartFleePed(0, PlayerPedId(), 100.0, -1, false, false)
  CloseSequenceTask(taskSeq)

  TaskPerformSequence(pPed, taskSeq)
  ClearSequenceTask()
  SetPedKeepTask(pPed, true)

  SetEntityAsMissionEntity(pPed, true, true)
  SetTimeout(120000, function()
    Sync.SetEntityAsNoLongerNeeded(pPed)
    Sync.SetPedKeepTask(pPed, false)
  end)
end

function getRandomIdle()
  local idles = {
    ['anim@mp_corona_idles@male_c@idle_a'] = 'idle_a',
    ['friends@fra@ig_1'] = 'base_idle',
    ['amb@world_human_hang_out_street@male_b@idle_a'] = 'idle_b',
    ['anim@heists@heist_corona@team_idles@male_a'] = 'idle',
    ['anim@mp_celebration@idles@female'] = 'celebration_idle_f_a',
    ['anim@mp_corona_idles@female_b@idle_a'] = 'idle_a',
    ['random@shop_tattoo'] = '_idle_a',
  }
  for animDict, anim in pairs(idles) do
    if math.random() < 0.2 then
      return animDict, anim
    end
  end
  return 'rcmjosh1', 'idle'
end

function loadAnimDict(pDict)
  while (not HasAnimDictLoaded(pDict)) do
    RequestAnimDict(pDict)
    Citizen.Wait(5)
  end
end

exports('IsCornering', function()
  return CurrentlyCornering
end)
