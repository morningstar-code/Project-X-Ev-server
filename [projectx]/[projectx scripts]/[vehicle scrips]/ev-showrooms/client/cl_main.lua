local isInsideZone = false
zoneName = nil
Citizen.CreateThread(function()
  -- pdm
  exports["ev-polyzone"]:AddBoxZone("pdm", vector3(805.23, -804.24, 42.16), 84.0, 97.6, {
    minZ=25.36,
    maxZ=33.56,
    heading=0
  })
  -- pdm tablets
  -- exports["ev-polyzone"]:AddBoxZone("showroom_tablet", vector3(-57.22, -1091.61, 26.42), 1.2, 2.2, {
  --   heading = 69,
  --   minZ = 25.42,
  --   maxZ = 27.42,
  -- })
  exports["ev-polytarget"]:AddBoxZone("showroom_tablet", vector3(824.61, -825.08, 26.06), 0.5, 0.5, {
    heading=0,
    minZ=26.21,
    maxZ=26.61
  })
  exports["ev-polytarget"]:AddBoxZone("showroom_tablet", vector3(828.08, -825.04, 26.33), 0.5, 0.5, {
    heading=0,
    minZ=26.21,
    maxZ=26.61
  })
  
  -- exports["ev-polyzone"]:AddBoxZone("showroom_tablet", vector3(-40.08, -1106.36, 26.42), 1.2, 2.2, {
  --   heading = 159,
  --   minZ = 25.42,
  --   maxZ = 27.62,
  -- })
  -- exports["ev-polyzone"]:AddBoxZone("showroom_tablet", vector3(-34.22, -1103.49, 26.42), 1.2, 2.2, {
  --   heading = 249,
  --   minZ = 25.42,
  --   maxZ = 27.62,
  -- })

  -- fastlane
  -- exports["ev-polyzone"]:AddBoxZone("fastlane", vector3(-797.42, -230.87, 37.08), 94.0, 80.2, {
  --   heading = 29,
  --   minZ = 35.13,
  --   maxZ = 58.33,
  -- })
  -- fastlane tablets
  -- exports["ev-polyzone"]:AddBoxZone("showroom_tablet", vector3(-792.49, -223.83, 37.08), 1.2, 2.2, {
  --   heading = 209,
  --   minZ = 36.08,
  --   maxZ = 38.28,
  -- })
  -- exports["ev-polyzone"]:AddBoxZone("showroom_tablet", vector3(-788.39, -225.7, 37.08), 1.2, 2.2, {
  --   heading = 304,
  --   minZ = 36.08,
  --   maxZ = 38.28,
  -- })
  -- exports["ev-polyzone"]:AddBoxZone("showroom_tablet", vector3(-782.68, -242.06, 37.08), 1.2, 2.2, {
  --   heading = 299,
  --   minZ = 36.08,
  --   maxZ = 38.48,
  -- })

  -- tuner
  exports["ev-polyzone"]:AddBoxZone("tuner", vector3(141.75, -3045.74, 8.38), 165.4, 126.0, {
    heading = 0,
    minZ = 4.18,
    maxZ = 17.98,
    zoneEvents = {"ev-vehiclelifts:client:StartMovingLift"},
    data = {
      id = "tuner",
    }
  })
  -- tuner tablets
  exports["ev-polytarget"]:AddBoxZone("showroom_tablet", vector3(124.11, -3011.35, 7.04), 2.8, 1, {
    heading = 0,
    minZ = 6.84,
    maxZ = 7.84,
  })
  -- exports["ev-polyzone"]:AddBoxZone("showroom_tablet", vector3(949.34, -956.93, 39.51), 1.2, 2.0, {
  --   heading = 272,
  --   minZ = 38.21,
  --   maxZ = 41.21,
  -- })
  -- exports["ev-polyzone"]:AddBoxZone("showroom_tablet", vector3(917.1, -957.25, 39.51), 1.2, 2.0, {
  --   heading = 2,
  --   minZ = 38.21,
  --   maxZ = 41.21,
  -- })
  -- exports["ev-polytarget"]:AddBoxZone("pdm_job_vehicles", vector3(-33.68, -1106.61, 26.42), 1.0, 0.2, {
  --   heading = 341,
  --   minZ=26.42,
  --   maxZ=27.02,
  --   data = {
  --     id = 1,
  --   },
  -- })
  -- exports['ev-interact']:AddPeekEntryByPolyTarget("pdm_job_vehicles", {{
  --   id = "pdm_job_vehicles",
  --   event = "ev-showrooms:buyJobVehicles",
  --   icon = "car",
  --   label = "Purchase Job Vehicle",
  --   parameters = {},
  -- }}, { distance = { radius = 1.5 } })
  CarPresets = RPC.execute('showroom:getCarPresets')
end)

AddEventHandler("ev-polyzone:enter", function(name)
  if name ~= "pdm" and name ~= "fastlane" and name ~= "tuner" then return end
  zoneName = name
  exports["ev-ui"]:sendAppEvent("game", { location = name })
  experience.onEnter(zoneName)
  locationEnter(zoneName)
end)
AddEventHandler("ev-polyzone:exit", function(name)
  if name ~= "pdm" and name ~= "fastlane" and name ~= "tuner" then return end
  experience.onLeave(name)
  locationLeave(name)
  exports["ev-ui"]:sendAppEvent("game", { location = "world" })
end)

RegisterUICallback("ev-ui:showroomDisplayCar", function(data, cb)
  RPC.execute("showroom:changeSpawnedCar", getLocation(), data.index, data.model)
  cb({ data = {}, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("ev-ui:showroomSellCar", function(data, cb)
  local veh = GetVehiclePedIsUsing(PlayerPedId())
  if not isTestDriveVehicle(veh) then
    cb({ data = {}, meta = { ok = false, message = 'Cannot sell this vehicle' } })
    return
  end
  data.vehicle_id = veh
  data.vehicle_net_id = NetworkGetNetworkIdFromEntity(veh)
  data.vehicle_model = getTestDriveVehicleModelName(veh)
  data.vehicle_driveforce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
  RPC.execute("showroom:offerVehicle", data)
  cb({ data = {}, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("ev-ui:showroomPurchaseCurrentVehicle", function(data, cb)
  local data = data._data
  local _data = data._data

  local veh = NetToVeh(_data.vehicle_net_id)
  
  if _data.vehicle_net_id ~= NetworkGetNetworkIdFromEntity(GetVehiclePedIsUsing(PlayerPedId())) then
    cb({ data = {}, meta = { ok = false, message = "Not in the right car..." } })
    return
  end

  local name = _data.vehicle_model
  _data.vehicle_name = GetLabelText(GetDisplayNameFromVehicleModel(name)) or "vehicle"
  local vModel = GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))
  _data.is_motorcycle = IsThisModelABike(vModel) or IsThisModelAQuadbike(vModel)
  local success, message = RPC.execute("showroom:purchaseVehicle", name, data, zoneName, false)

  if success then
    resetMods(veh)
    cb({ data = {}, meta = { ok = true, message = 'done' } })
  else
    cb({ data = {}, meta = { ok = false, message = message } })
  end
end)

function resetMods(pVehicle)
  local mods = {
    ["Spoilers"] = -1,
    ["FrontBumper"] = -1,
    ["RearBumper"] = -1,
    ["SideSkirt"] = -1,
    ["Exhaust"] = -1,
    ["Frame"] = -1,
    ["Grille"] = -1,
    ["Hood"] = -1,
    ["Fender"] = -1,
    ["RightFender"] = -1,
    ["Roof"] = -1,
    ["Engine"] = -1,
    ["Brakes"] = -1,
    ["Transmission"] = -1,
    ["Horns"] = -1,
    ["Suspension"] = -1,
    ["Armor"] = -1,
    ["UNK17"] = 0,
    ["Turbo"] = 0,
    ["UNK19"] = 0,
    ["TireSmoke"] = 0,
    ["UNK21"] = 0,
    ["XenonHeadlights"] = -1,
    ["FrontWheels"] = -1,
    ["BackWheels"] = -1,
    ["PlateHolder"] = -1,
    ["VanityPlates"] = -1,
    ["InteriorTrim"] = -1,
    ["Ornaments"] = -1,
    ["Dashboard"] = -1,
    ["Dials"] = -1,
    ["DoorSpeakers"] = -1,
    ["Seats"] = -1,
    ["SteeringWheel"] = -1,
    ["ShiftLeavers"] = -1,
    ["Plaques"] = -1,
    ["Speakers"] = -1,
    ["Trunk"] = -1,
    ["Hydraulics"] = -1,
    ["EngineBlock"] = -1,
    ["AirFilter"] = -1,
    ["Struts"] = -1,
    ["ArchCover"] = -1,
    ["Aerials"] = -1,
    ["ExteriorTrim"] = -1,
    ["Tank"] = -1,
    ["Windows"] = -1,
    ["UNK47"] = -1,
    ["Livery"] = -1,
  }
  exports["ev-vehicles"]:SetVehicleMods(pVehicle, mods)
  exports["ev-vehicles"]:SetVehicleAppearance(pVehicle, { colors = {}, tint = 0 })
end

RegisterNetEvent("showroom:purchaseVehiclePrompt")
AddEventHandler("showroom:purchaseVehiclePrompt", function(data)
  SendUIMessage({
    source = "ev-nui",
    app = "phone",
    data = {
      action = "vehicle-purchase",
      _data = data,
      price = data.price,
      tax = data.tax,
    },
  })
end)

-- FROM old veh_shop
local firstspawn = 0
AddEventHandler('playerSpawned', function(spawn)
	if firstspawn == 0 then
		RemoveIpl('v_carshowroom')
		RemoveIpl('shutter_open')
		RemoveIpl('shutter_closed')
		RemoveIpl('shr_int')
		RemoveIpl('csr_inMission')
		RequestIpl('v_carshowroom')
		RequestIpl('shr_int')
		RequestIpl('shutter_closed')
		firstspawn = 1
	end
end)


AddEventHandler("onClientResourceStart", function()
  RemoveIpl('v_carshowroom')
  RemoveIpl('shutter_open')
  RemoveIpl('shutter_closed')
  RemoveIpl('shr_int')
  RemoveIpl('csr_inMission')
  RequestIpl('v_carshowroom')
  RequestIpl('shr_int')
  RequestIpl('shutter_closed')
end)

RegisterUICallback("ev-ui:showroomGetCarConfig", function(data, cb)
  local conf = RPC.execute("showroom:getCarConfig", zoneName or nil)
  cb({ data = conf, meta = { ok = true, message = 'done' } })
end)

--
local jobVehicleData = {
  ["taxi"] = { price = 2500, name = "Taxi" },
  ["flatbed"] = { price = 2500, name = "Tow Truck" },
  ["rumpo"] = { price = 3500, name = "News Rumpo" },
}
AddEventHandler("ev-showrooms:buyJobVehicles", function()
  Wait(200)
  exports['ev-ui']:showContextMenu({
    {
      title = "Taxi",
      description = '$2,500.00',
      action = 'ev-showrooms:buyJobVehicleAction',
      key = 'taxi',
    },
    {
      title = "Tow Truck (Flatbed)",
      description = '$2,500.00',
      action = 'ev-showrooms:buyJobVehicleAction',
      key = 'flatbed',
    },
    {
      title = "News Rumpo",
      description = '$3,500.00',
      action = 'ev-showrooms:buyJobVehicleAction',
      key = 'rumpo',
    },
  })
end)

-- data.character.id
-- data.character.bank_account_id
-- data.model
-- data.price
-- data.name
RegisterUICallback("ev-showrooms:buyJobVehicleAction", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = 'done' } })
  data.model = data.key
  data.price = jobVehicleData[data.key].price
  data.name = jobVehicleData[data.key].name
  local purchased, purchasedMessage = RPC.execute("ev-showrooms:purchaseJobVehicle", data)
  if purchased then
    SendUIMessage({
      source = "ev-nui",
      app = "phone",
      data = {
        action = "notification",
        target_app = "home-screen",
        title = "Car Purchased",
        body = "Delivered to the No3 parking lot!",
        show_even_if_app_active = true,
      }
    })
  else
    TriggerEvent("DoLongHudText", purchasedMessage, 2)
  end
end)

RegisterUICallback("ev-showrooms:catalogPurchasePublic", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = 'done' } })
  exports["ev-ui"]:closeApplication("showroom")
  Wait(1)
  local car = data.car
  if not car.active then
    return TriggerEvent("DoLongHudText", "That car can't be sold.")
  end

  if car.owner_only then
    return TriggerEvent("DoLongHudText", "That car can't be sold.")
  end

  if car.current_stock == 0 or car.current_stock < -1 then
    return TriggerEvent("DoLongHudText", "That car is out of stock.")
  end

  if car.tuner then
    return TriggerEvent("DoLongHudText", "That car can't be sold.")
  end

  local stats = StatsCache[car.hash]

  RPC.execute("showroom:purchaseCatalogPrompt", {
    vehicle_model = car.model,
    vehicle_driveforce = stats.info[1].value / 10,
    state_id = data.character.id,
    price = car.retail_price,
    vehicle_import_price = car.import_price,
    character = data.character,
    vehicle_name = car.name,
    is_motorcycle = stats.vehClass == "M"
  })
end)

RegisterUICallback("ev-ui:showroomPurchaseCatalogVehicle", function(data, cb)
  local name = data._data.vehicle_model
  data.vehicle_name = data._data.vehicle_name
  local success, message = RPC.execute("showroom:purchaseVehicle", name, data, zoneName, true, true)

  if success then
    RPC.execute("showroom:stockDecrease", name)
    cb({ data = {}, meta = { ok = true, message = 'done' } })
  else
    cb({ data = {}, meta = { ok = false, message = message } })
  end
end)

local carConfig = {
    {
        model = "sultan",
        name = "Sultan",
        group = "Sports",
        active = true,
        pdm = true,
        owner_only = false,
        showroom_image_url = "",
        retail_price = 42000,
        current_stock = 5,
        vehClass = "A",
    },
    {
        model = "oracle2",
        name = "Oracle XS",
        group = "Coupes",
        active = true,
        pdm = true,
        owner_only = false,
        showroom_image_url = "",
        retail_price = 32000,
        current_stock = 2,
        vehClass = "B",
    }
}

local function getCarByModel(model)
    for _,car in ipairs(carConfig) do
        if car.model == model then return car end
    end
    return nil
end

RegisterNUICallback('ev-ui:showroomGetCarConfig', function(data, cb)
    cb({ data = carConfig })
end)

RegisterNUICallback('ev-ui:showroomChangeCar', function(data, cb)
    local car = getCarByModel(data.model)
    if not car then
        cb({data={speed=0, acceleration=0, handling=0, braking=0}})
        return
    end
    cb({
        data = {
            speed = math.random(60, 90),
            acceleration = math.random(60, 90),
            handling = math.random(60, 90),
            braking = math.random(60, 90)
        }
    })
end)
