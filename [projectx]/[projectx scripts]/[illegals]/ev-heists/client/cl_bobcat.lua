DecorRegister("BobcatC4Ped", 2)
DecorRegister("BobcatMoneyTruck", 2)

local iplStates = {}
local bobcatSecurityDoorCoords = vector3(883.43, -2268.04, 30.5)
local npcBomberIdlePhase = true
local npcBomber = 0
local isDarkMarketbCat = false

local function updateIpls()
  -- RequestIpl("prologue06_int_np")
  local interiorid = GetInteriorAtCoords(883.4142, -2282.372, 31.44168)
  for k, v in pairs(iplStates) do
    if v then
      ActivateInteriorEntitySet(interiorid, k)
    else
      DeactivateInteriorEntitySet(interiorid, k)
    end
  end
  RefreshInterior(interiorid)
end

local function setupNpcPed(ped, leaveVehicle, coords)
  -- important
  DecorSetBool(ped, 'ScriptedPed', true)
  SetEntityAsMissionEntity(ped, 1, 1)
  if not leaveVehicle then
    local interior = GetInteriorFromEntity(ped)
    local roomHash = GetRoomKeyFromEntity(ped)
    ForceRoomForEntity(ped, interior, roomHash)
  end
  -- health armor
  SetEntityMaxHealth(ped, 2000)
  SetEntityHealth(ped, 2000)
  SetPedArmour(ped, 1000)
  -- relationship
  SetPedRelationshipGroupDefaultHash(ped, `COP`)
  SetPedRelationshipGroupHash(ped, `COP`)
  SetPedAsCop(ped, 1)
  -- weapons
  GiveWeaponToPed(ped, -1768145561, 9999, false, true)
  SetCurrentPedWeapon(ped, -1768145561, true)
  SetPedAmmo(ped, -1768145561, 9999)
  SetAmmoInClip(ped, -1768145561, 9999)
  -- attack
  SetCanAttackFriendly(ped, false, true)
  -- combat
  SetPedCombatMovement(ped, 3)
  SetPedCombatRange(ped, 2)
  SetPedCombatAttributes(ped, 5000, 1)
  -- misc
  SetPedDropsWeaponsWhenDead(ped, false)
  SetPedRandomComponentVariation(ped, true)
  SetPedSeeingRange(ped, 150.0)
  SetPedHearingRange(ped, 150.0)
  SetPedAlertness(ped, 3)
  SetPedCanRagdollFromPlayerImpact(ped, false)
  if leaveVehicle then
    Wait(2000)
  end
  ClearPedTasksImmediately(ped)
  Wait(200)
  if leaveVehicle then
    SetCurrentPedWeapon(ped, -1768145561, true)
    TaskShootAtEntity(ped, PlayerPedId(), -1, `FIRING_PATTERN_FULL_AUTO`)
    return
  end
  if math.random() < 0.8 then
    TaskAimGunAtEntity(ped, PlayerPedId(), -1, 1)
  else
    TaskShootAtEntity(ped, PlayerPedId(), -1, `FIRING_PATTERN_FULL_AUTO`)
  end
end

local function uuid()
  math.randomseed(GetCloudTimeAsInt())
  local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function (c)
      local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
      return string.format('%x', v)
  end)
end

local function notifyBobcatRobbery()
  TriggerServerEvent('dispatch:svNotify', {
    dispatchCode = "10-90F",
    eventId = uuid(),
    origin = {
      x = 881.58,
      y = -2262.64,
      z = 32.44,
    },
  })
  exports["ev-dispatch"]:dispatch("10-90F", "Bob Cat Robbery")
end

local function rModel(pModel)
  RequestModel(pModel)
  while not HasModelLoaded(pModel) do
    Wait(0)
  end
end

RegisterNetEvent("heists:updatebobcatIplStates")
AddEventHandler("heists:updatebobcatIplStates", function(pStates)
  iplStates = pStates
  updateIpls()
end)

RegisterNetEvent("ev-heists:bobcatMoneyTruckSpawnSettings")
AddEventHandler("ev-heists:bobcatMoneyTruckSpawnSettings", function(pNetId)
  SetNetworkIdCanMigrate(pNetId, 1)
  local veh = NetworkGetEntityFromNetworkId(pNetId)
  SetEntityAsMissionEntity(veh, 1, 1)
  local ped = GetPedInVehicleSeat(veh, -1)
  SetEntityAsMissionEntity(ped, 1, 1)
  ped = GetPedInVehicleSeat(veh, 0)
  SetEntityAsMissionEntity(ped, 1, 1)
end)

AddEventHandler("ev-inventory:itemUsed", function(item)
  if item ~= "bobcatsecuritycard" then return end
  if #(GetEntityCoords(PlayerPedId()) - bobcatSecurityDoorCoords) > 1.5 then
    TriggerEvent("DoLongHudText", "That doesn't seem right.", 2)
    return
  end

  if not isDarkMarketbCat then return end

  local success = RPC.execute("heists:bobcatUseSecurityCard")
  if not success then return end
  notifyBobcatRobbery()
  TriggerEvent("inventory:removeItem", "bobcatsecuritycard", 1)
end)

RegisterNetEvent("heists:bobcatControlC4Npc")
AddEventHandler("heists:bobcatControlC4Npc", function(pNetId)
  npcBomberIdlePhase = true
  npcBomber = NetworkGetEntityFromNetworkId(pNetId)
  while npcBomber == 0 do
    npcBomber = NetworkGetEntityFromNetworkId(pNetId)
    Wait(100)
  end
  DecorSetBool(npcBomber, 'ScriptedPed', true)
  DecorSetBool(npcBomber, 'BobcatC4Ped', true)
  local interior = GetInteriorFromEntity(npcBomber)
  local roomHash = GetRoomKeyFromEntity(npcBomber)
  ForceRoomForEntity(npcBomber, interior, roomHash)
  SetEntityInvincible(npcBomber, true)
  ClearPedTasksImmediately(npcBomber)
  SetBlockingOfNonTemporaryEvents(npcBomber, true)
  SetPedRandomComponentVariation(npcBomber, true)
  SetPedDropsWeaponsWhenDead(npcBomber, false)
  RequestAnimDict("random@arrests@busted")
  while not HasAnimDictLoaded("random@arrests@busted") do 
    Citizen.Wait(0)
  end
  Wait(500)
  ClearPedTasksImmediately(npcBomber)
  FreezeEntityPosition(npcBomber, true)
  local animLength = GetAnimDuration("random@arrests@busted", "idle_a")
  TaskPlayAnim(npcBomber, "random@arrests@busted", "idle_a", 1.0, 4.0, animLength, 2, 0, 0, 0, 0)
  Citizen.CreateThread(function()
    while npcBomberIdlePhase do
      if not IsEntityPlayingAnim(npcBomber, "random@arrests@busted", "idle_a", 3) then
        ClearPedTasksImmediately(npcBomber)
        TaskPlayAnim(npcBomber, "random@arrests@busted", "idle_a", 1.0, 4.0, animLength, 2, 0, 0, 0, 0)
      end
      Citizen.Wait(1000)
    end
  end)
end)

RegisterNetEvent("heists:bobcatControlC4NpcActivate")
AddEventHandler("heists:bobcatControlC4NpcActivate", function(pOwnerId, pNetId)
  npcBomberIdlePhase = false
  if pOwnerId ~= GetPlayerServerId(PlayerId()) then return end
  local doingShit = true
  Citizen.CreateThread(function()
    local npcBomber = NetworkGetEntityFromNetworkId(pNetId)
    while doingShit do
      NetworkRequestControlOfEntity(npcBomber)
      Wait(1000)
    end
  end)
  Citizen.CreateThread(function()
    local npcBomber = NetworkGetEntityFromNetworkId(pNetId)
    FreezeEntityPosition(npcBomber, false)
    ClearPedTasksImmediately(npcBomber)
    local isAtCoordsCalls = 0
    local function isAtCoords(coords)
      isAtCoordsCalls = isAtCoordsCalls + 1
      if isAtCoordsCalls > 4 then
        isAtCoordsCalls = 0
        return true
      end
      local dist = #(GetEntityCoords(npcBomber) - coords)
      return dist < 1.5
    end
    local coords = vector3(872.26, -2292.27, 32.45)
    TaskGoStraightToCoord(npcBomber, coords, 1.55, -1, 265.59, 1.0)
    while not isAtCoords(coords) do
      Wait(2000)
      ClearPedTasksImmediately()
      TaskGoStraightToCoord(npcBomber, coords, 1.55, -1, 265.59, 1.0)
    end
    SetEntityCoords(npcBomber, coords.x, coords.y, coords.z - 1.0)
    ClearPedTasksImmediately(npcBomber)
    coords = vector3(892.34, -2293.37, 32.45)
    TaskGoStraightToCoord(npcBomber, coords, 1.55, -1, 350.76, 1.0)
    while not isAtCoords(coords) do
      Wait(2000)
      ClearPedTasksImmediately()
      TaskGoStraightToCoord(npcBomber, coords, 1.55, -1, 350.76, 1.0)
    end
    SetEntityCoords(npcBomber, coords.x, coords.y, coords.z - 1.75)
    ClearPedTasksImmediately(npcBomber)
    coords = vector3(893.02, -2284.77, 32.45)
    TaskGoStraightToCoord(npcBomber, coords, 1.55, -1, 84.0, 1.0)
    while not isAtCoords(coords) do
      Wait(2000)
      ClearPedTasksImmediately()
      TaskGoStraightToCoord(npcBomber, coords, 1.55, -1, 84.0, 1.0)
    end
    SetEntityCoords(npcBomber, coords.x, coords.y, coords.z - 1.75)
    ClearPedTasksImmediately()
    Wait(1000)
    GiveWeaponToPed(npcBomber, 741814745, 1, false, true)
    SetCurrentPedWeapon(npcBomber, 741814745, true)
    Citizen.Wait(1000)
    ClearPedTasksImmediately(npcBomber)
    TaskThrowProjectile(npcBomber, vector3(890.518, -2285.068, 31.62272))
    Citizen.Wait(1500)
    GiveWeaponToPed(npcBomber, `WEAPON_PISTOL`, 999, false, true)
    SetCurrentPedWeapon(npcBomber, `WEAPON_PISTOL`, true)
    SetPedAmmo(npcBomber, `WEAPON_PISTOL`, 9999)
    SetAmmoInClip(npcBomber, `WEAPON_PISTOL`, 9999)
    Citizen.Wait(800)
    SetEntityInvincible(npcBomber, false)
    ClearPedTasksImmediately(npcBomber)
    TaskShootAtCoord(npcBomber, vector3(890.518, -2285.068, 31.62272), -1, `FIRING_PATTERN_FULL_AUTO`)
    doingShit = false
  end)
end)

RegisterNetEvent("ev-heists:controlBobcatNpc")
AddEventHandler("ev-heists:controlBobcatNpc", function(pNetId)
  Citizen.CreateThread(function()
    local ped = 0
    while ped == 0 do
      ped = NetworkGetEntityFromNetworkId(pNetId)
      Wait(100)
    end
    setupNpcPed(ped, false, pCoords)
    threadInProgress = false
  end)
end)

AddEventHandler("ev-heists:bobcatPickupLootCache", function(p1, p2, pArgs)
  local type = pArgs.zones["bc_weapon_cache"].id
  ClearPedTasksImmediately(PlayerPedId())
  if not isDarkMarketbCat then return end
  TriggerEvent("animation:runtextanim", "petting")
  RPC.execute("heists:bobcatLootCache", type)
end)

local myJob = nil
RegisterNetEvent("ev-jobmanager:playerBecameJob")
AddEventHandler("ev-jobmanager:playerBecameJob", function(job, name, notify)
  myJob = job
end)

RegisterNetEvent("ev-heists:bobcatMoneyTruckSpawned")
AddEventHandler("ev-heists:bobcatMoneyTruckSpawned", function(pCoords)
  if myJob == "police" then return end
  if not exports['ev-inventory']:hasEnoughOfItem("vpnxja", 1, false, true) then return end
  local moneyTruckLocation = ""
  local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(pCoords.x, pCoords.y, pCoords.z, currentStreetHash, intersectStreetHash)
  local currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
  local intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)
  local zone = tostring(GetNameOfZone(pCoords))

  if intersectStreetName ~= nil and intersectStreetName ~= "" then
    moneyTruckLocation = currentStreetName .. " - " .. intersectStreetName
  elseif currentStreetName ~= nil and currentStreetName ~= "" then
    moneyTruckLocation = currentStreetName
  else
    moneyTruckLocation = "Unknown Location"
  end
  TriggerEvent(
    'phone:emailReceived',
    'Dark Market',
    '#ev-1001',
    'A truck carrying Bobcat Security gear was just seen around: ' .. moneyTruckLocation
  )
end)

local thermiteMinigameUICallbackUrl = "ev-ui:heistsThermiteMinigameResult"
local gameSettings = {
  gameFinishedEndpoint = thermiteMinigameUICallbackUrl,
  gameTimeoutDuration = 14000,
  coloredSquares = 10,
  gridSize = 5,
}

AddEventHandler("ev-heists:bobcatThermiteMoneyTruckDoor", function(pArgs, pEntity, pContext)
  local netId = NetworkGetNetworkIdFromEntity(pEntity)
  NetworkRequestControlOfEntity(pEntity)
  local truckCoords = GetEntityCoords(pEntity)
  local thermiteCoords = GetOffsetFromEntityInWorldCoords(pEntity, 0.0, -3.55, 0.0)
  local heading = GetEntityHeading(pEntity)
  local thermiteCoordsWithHeading = {
    x = thermiteCoords.x,
    y = thermiteCoords.y,
    z = thermiteCoords.z + 1.0,
    h = heading,
  }
  TriggerEvent("inventory:removeItem", "thermitecharge", 1)
  TriggerServerEvent('dispatch:svNotify', {
    dispatchCode = "10-90D",
    eventId = uuid(),
    origin = {
      x = truckCoords.x,
      y = truckCoords.y,
      z = truckCoords.z,
    },
  })
  exports["ev-dispatch"]:dispatch("10-90A", "Bob Cat Truck Robbery")

  Sync.FreezeEntityPosition(pEntity, true)
  local success = Citizen.Await(ThermiteCharge(thermiteCoordsWithHeading, nil, 0.0, gameSettings))
  if not success then return end
  RPC.execute("ev-heists:bobcatMoneyTruckBegin", netId)
end)

RegisterNetEvent("heists:bobcatMoneyTruckSetup")
AddEventHandler("heists:bobcatMoneyTruckSetup", function(pNetId)
  local veh = NetworkGetEntityFromNetworkId(pNetId)
  DecorSetBool(veh, 'BobcatMoneyTruck', true)
  SetVehicleDoorsLocked(veh, 3)
  FreezeEntityPosition(veh, 1)
  SetVehicleDoorBroken(veh, 2, 0)
  SetVehicleDoorBroken(veh, 3, 0)
  SetVehicleUndriveable(veh, true)
  SetVehicleEngineOn(veh, false, false, true)
  Citizen.CreateThread(function()
    local ped1 = CreatePedInsideVehicle(veh, 4, `s_m_m_armoured_01`, 1, 1, 1)
    setupNpcPed(ped1, true)
  end)
  Citizen.CreateThread(function()
    local ped2 = CreatePedInsideVehicle(veh, 4, `s_m_m_armoured_01`, 2, 1, 1)
    setupNpcPed(ped2, true)
  end)
end)

AddEventHandler("ev-heists:bobcatMoneyTruckTakeGoods", function(p1, pEntity)
  RPC.execute("ev-heists:bobcatMoneyTruckLootPlease", NetworkGetNetworkIdFromEntity(pEntity))
end)

AddEventHandler("ev-heists:interactBobcatC4Npc", function(pArgs, pEntity)
  RPC.execute("heists:activateC4Npc", NetworkGetNetworkIdFromEntity(pEntity))
end)

Citizen.CreateThread(function()
  exports["ev-polytarget"]:AddBoxZone("bc_weapon_cache", vector3(882.07, -2282.89, 32.44), 1.8, 0.4, {
    heading=335,
    minZ=29.64,
    maxZ=31.04,
    data = {
      id = "smgs",
    },
  })
  exports["ev-polytarget"]:AddBoxZone("bc_weapon_cache", vector3(882.58, -2285.71, 30.47), 0.4, 1.0, {
    heading = 340,
    minZ = 29.87,
    maxZ = 30.67,
    data = {
      id = "explosives",
    },
  })
  exports["ev-polytarget"]:AddBoxZone("bc_weapon_cache", vector3(886.47, -2286.88, 30.47), 0.8, 1.0, {
    heading = 0,
    minZ = 29.87,
    maxZ = 31.27,
    data = {
      id = "rifles",
    },
  })
  exports['ev-interact']:AddPeekEntryByPolyTarget('bc_weapon_cache', {{
    event = "ev-heists:bobcatPickupLootCache",
    id = "bcpickuplootstash",
    icon = "fas fa-circle",
    label = "Grab!",
    parameters = {},
  }}, {
    distance = { radius = 3.5 },
  })

  iplStates = RPC.execute("heists:bobcatGetIplStates")
  updateIpls()
end)

--

local inStockade = false
local deliveryLocation = nil
AddEventHandler('baseevents:enteredVehicle', function(pVehicle, pSeat, pName, pClass)
  if GetEntityModel(pVehicle) ~= `STOCKADE` or pSeat ~= -1 then
    inStockade = false
    return
  end
  if myJob == "police" then return end
  inStockade = true
  local netId = NetworkGetNetworkIdFromEntity(pVehicle)
  Citizen.CreateThread(function()
    while inStockade do
      local atDeliveryLocation = false
      if deliveryLocation and #(GetEntityCoords(PlayerPedId()) - deliveryLocation) < 4.0 then
        atDeliveryLocation = true
      end
      TriggerServerEvent("ev-heists:bobcat:inStockade", netId, atDeliveryLocation)
      Citizen.Wait(15000)
    end
    deliveryLocation = nil
  end)
  -- Citizen.CreateThread(function()
  --   while inStockade do
  --     local truckCoords = GetEntityCoords(pVehicle)
  --     TriggerServerEvent('dispatch:svNotify', {
  --       dispatchCode = "10-90D",
  --       eventId = uuid(),
  --       origin = {
  --         x = truckCoords.x,
  --         y = truckCoords.y,
  --         z = truckCoords.z,
  --       },
  --     })
  --     Citizen.Wait(60000)
  --   end
  -- end)
end)

AddEventHandler('baseevents:leftVehicle', function(pVehicle)
  inStockade = false
end)

RegisterNetEvent("ev-heists:bobcat:updateDeliveryLocation")
AddEventHandler("ev-heists:bobcat:updateDeliveryLocation", function(pLocation, pEmailed)
  deliveryLocation = pLocation
  local blip = AddBlipForCoord(pLocation)
  SetBlipSprite(blip, 440)
  SetBlipScale(blip, 1.4)
  SetBlipColour(blip, 5)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Truck Drop")
  EndTextCommandSetBlipName(blip)
  if not pEmailed then
    TriggerEvent('phone:emailReceived', 'Dark Market', '#BC-1001', 'A blip has been added to your GPS, deliver the truck! Stay in the drivers seat.')
  end
end)

RegisterUICallback("ev-ui:heists:acceptBobcatJob", function(data, cb)
  cb({ data = {}, meta = { success = true, message = "" }})
  TriggerServerEvent("ev-heists:bobcat:acceptBobcatOffer")
end)

RegisterNetEvent("ev-heists:bobcat:offerSecurityTruck")
AddEventHandler("ev-heists:bobcat:offerSecurityTruck", function()
  local hasVpn = exports["ev-inventory"]:hasEnoughOfItem("vpnxja", 1, false, true)
  if not hasVpn then return end
  SendUIMessage({
    source = "ev-nui",
    app = "phone",
    data = {
      action = "bobcat-truck-claim",
    },
  })
end)

local truckHasSpawned = false
RegisterNetEvent("ev-heists:bobcat:securityTruckResult")
AddEventHandler("ev-heists:bobcat:securityTruckResult", function(isMyTruck, pLocation)
  if not isMyTruck then
    TriggerEvent( 'phone:emailReceived', 'Dark Market', '#ST-1001', 'You were not chosen for the truck this time.')
    return
  end
  TriggerEvent('phone:emailReceived', 'Dark Market', '#ST-1001', 'A truck for pickup has been placed on your GPS. The access codes are on this phone, you must drive it.')
  local blip = AddBlipForCoord(pLocation)
  SetBlipSprite(blip, 440)
  SetBlipScale(blip, 1.4)
  SetBlipColour(blip, 5)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Truck Pickup")
  EndTextCommandSetBlipName(blip)
  Citizen.CreateThread(function()
    while not truckHasSpawned do
      truckHasSpawned = RPC.execute("ev-heists:bobcat:updateMyLocationForTruck", GetEntityCoords(PlayerPedId()))
      Citizen.Wait(5000)
    end
    truckHasSpawned = false
  end)
end)

RegisterNetEvent("ev-heists:bobcat:updateMyLocationForTruckSpawned")
AddEventHandler("ev-heists:bobcat:updateMyLocationForTruckSpawned", function(pNetId)
  local vehicle = NetworkGetEntityFromNetworkId(pNetId)
  Sync.SetVehicleOnGroundProperly(vehicle)
  Sync.SetVehicleDoorsLocked(vehicle, 2)
end)

RegisterNetEvent("startillegalbCat")
AddEventHandler("startillegalbCat", function(groupId, groupData, members, task, pState)
  local clientId = PlayerId()
  local src = GetPlayerServerId(clientId)
  for k,v in pairs(members) do
      if tonumber(v.src) == tonumber(src) then
          if tonumber(v.src) ~= tonumber(groupData.leader) then
            isDarkMarketbCat = pState
            TriggerEvent("ev-phone:JobNotify", task.header, task.task, false, groupId)
          else
            isDarkMarketbCat = pState
            TriggerEvent("ev-phone:JobNotify", task.header, task.task, true, groupId)
          end
      end
  end
end)

RegisterNetEvent("finishillegalbCat")
AddEventHandler("finishillegalbCat", function(members, pState)
  local clientId = PlayerId()
  local src = GetPlayerServerId(clientId)
  for k,v in pairs(members) do
      if tonumber(v.src) == tonumber(src) then
        isDarkMarketbCat = pState
      end
  end
end)