Citizen.CreateThread(function()
  exports["ev-polyzone"]:AddBoxZone("speed_trap", vector3(106.93, -999.17, 29.4), 48.8, 41.8, {
    heading = 340,
    minZ = 28.2,
    maxZ = 33.4,
    data = {
      id = "1",
    },
  })
  exports["ev-polyzone"]:AddBoxZone("speed_trap", vector3(174.81, -819.97, 31.17), 53.4, 53.4, {
    heading = 340,
    minZ = 29.97,
    maxZ = 35.17,
    data = {
      id = "2",
    },
  })
  exports["ev-polyzone"]:AddBoxZone("speed_trap", vector3(-101.0, -1139.78, 25.07), 53.4, 53.4, {
    heading = 350,
    minZ = 23.87,
    maxZ = 29.07,
    data = {
      id = "3",
    },
  })
  exports["ev-polyzone"]:AddBoxZone("speed_trap", vector3(-33.25, -944.16, 28.69), 53.4, 53.4, {
    heading = 350,
    minZ = 27.49,
    maxZ = 32.69,
    data = {
      id = "4",
    },
  })
  exports["ev-polyzone"]:AddBoxZone("speed_trap", vector3(241.23, -625.83, 40.25), 41.6, 38.8, {
    heading = 350,
    minZ = 37.65,
    maxZ = 44.25,
    data = {
      id = "5",
    },
  })
  exports["ev-polyzone"]:AddBoxZone("speed_trap", vector3(286.66, -854.85, 28.49), 55.8, 59.6, {
    data = {
      id = "6",
    },
    heading = 350,
    minZ = 25.89,
    maxZ = 32.49,
  })
  exports["ev-polyzone"]:AddBoxZone("little_moscow", vector3(328.27, -1042.47, 29.35), 165.2, 129.0, {
    heading = 0,
    minZ = 28.35,
    maxZ = 131.75
  })
end)

local currentJob = nil
RegisterNetEvent("ev-jobmanager:playerBecameJob")
AddEventHandler("ev-jobmanager:playerBecameJob", function(job, name, notify)
    currentJob = job
end)

AddEventHandler("ev-polyzone:enter", function(name)
  if name ~= "speed_trap" then return end
  if currentJob == "police" or currentJob == "ems" or currentJob == "doc" then return end
  local veh = GetVehiclePedIsIn(PlayerPedId())
  if veh == 0 then return end
  local speed = GetEntitySpeed(veh) * 2.23
  if speed < 80 then return end
  TriggerEvent("client:newStress", true, math.random(200, 400), true)
  -- TriggerServerEvent("ev-mdt:triggerSpeedTrap", NetworkGetNetworkIdFromEntity(veh))
end)

-- AddEventHandler("ev-polyzone:enter", function(name)
--   if name == "little_moscow" then
--     print("should make BLIZZARD")
--     exports["ev-weather"]:FreezeWeather(true, "BLIZZARD")
--   end
-- end)

-- AddEventHandler("ev-polyzone:exit", function(name)
--   if name == "little_moscow" then
--     print("should make CLEAR")
--     exports["ev-weather"]:FreezeWeather(false, "CLEAR")
--   end
-- end)