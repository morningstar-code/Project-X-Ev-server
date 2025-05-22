local carSpawns = {}
local spawnedVehicles = {}
local currentLocation = nil
CarPresets = {}

function getLocation()
  return currentLocation
end

function locationEnter(location)
  currentLocation = location
  cars, testDriveSpawnPoint = RPC.execute("showroom:locationInit", "pdm")
  setTestDriveLocation(testDriveSpawnPoint)
  spawn(cars)
end

function locationLeave(location)
  currentLocation = nil
  setTestDriveLocation(nil)
  despawn()
  RPC.execute("showroom:locationRemove", location)
end

function despawn()
  for i = 1, #spawnedVehicles do
    local veh = spawnedVehicles[i]
    DeleteVehicle(veh)
    spawnedVehicles[i] = nil
  end
end

function spawn(carsToSpawn)
  if not carsToSpawn or type(carsToSpawn) ~= "table" then
    print("^1[ERROR] carsToSpawn is nil or not a table, cannot spawn cars!^7")
    return
  end

  for i = 1, #carsToSpawn do
    local car = carsToSpawn[i]
    if not carSpawns[i] or not spawnedVehicles[i] or carSpawns[i].model ~= car.model then
      local vehToDespawn = spawnedVehicles[i]
      if vehToDespawn then
        DeleteVehicle(vehToDespawn)
      end

      local model = GetHashKey(car.model)
      RequestModel(model)
      while not HasModelLoaded(model) do
        Citizen.Wait(0)
      end

      local veh = CreateVehicle(
        model,
        car.coords.x,
        car.coords.y,
        car.coords.z - 1,
        car.coords.w,
        false,
        false
      )
      SetModelAsNoLongerNeeded(model)
      SetVehicleOnGroundProperly(veh)
      SetEntityInvincible(veh, true)
      SetVehicleDoorsLocked(veh, 2)

      local preset = CarPresets[car.model]
      if preset then
        exports["ev-vehicles"]:SetVehicleAppearance(veh, preset.appearance and preset.appearance or {})
        exports["ev-vehicles"]:SetVehicleMods(veh, preset.mods and preset.mods or {})

        if car.fitment and car.fitment.w_width then
          DecorSetBool(veh, "ev-wheelfitment_applied", true)
          DecorSetFloat(veh, "ev-wheelfitment_w_width", preset.fitment.w_width)
          DecorSetFloat(veh, "ev-wheelfitment_w_fl", preset.fitment.w_fl)
          DecorSetFloat(veh, "ev-wheelfitment_w_fr", preset.fitment.w_fr)
          DecorSetFloat(veh, "ev-wheelfitment_w_rl", preset.fitment.w_rl)
          DecorSetFloat(veh, "ev-wheelfitment_w_rr", preset.fitment.w_rr)
        end
      end

      FreezeEntityPosition(veh, true)
      SetVehicleNumberPlateText(veh, i .. "CARSALE")
      spawnedVehicles[i] = veh
    end
  end
  carSpawns = carsToSpawn
end


RegisterNetEvent("showroom:updateCarSpawns")
AddEventHandler("showroom:updateCarSpawns", function(cars)  
  spawn(cars)
end)

RegisterNetEvent("showroom:setFitment", function(pNetId, pFitment)
  local vehicle = NetworkGetEntityFromNetworkId(pNetId)
  if not vehicle then return end
  DecorSetBool(vehicle, "ev-wheelfitment_applied", true)
  DecorSetFloat(vehicle, "ev-wheelfitment_w_width", pFitment.w_width)
  DecorSetFloat(vehicle, "ev-wheelfitment_w_fl", pFitment.w_fl)
  DecorSetFloat(vehicle, "ev-wheelfitment_w_fr", pFitment.w_fr)
  DecorSetFloat(vehicle, "ev-wheelfitment_w_rl", pFitment.w_rl)
  DecorSetFloat(vehicle, "ev-wheelfitment_w_rr", pFitment.w_rr)
end)

RegisterNetEvent("showroom:setCarPresets", function(pPresets)
  CarPresets = pPresets
end)

RegisterNetEvent("showroom:updateCarPreset", function(pCarModel, pPreset)
  CarPresets[pCarModel] = pPreset
end)