local function has_key(tab, val)
  if tab == nil then
    return false
  end
  for key, _ in pairs(tab) do
      if key == val then
          return true
      end
  end

  return false
end

RegisterNetEvent("stupid:cunt", function(result) 
  local ownedData = result
  local zoneName, zone = getZone()
  if not zone then return end

  local polcars = RPC.execute("polcars:getPolcars", zone.vehicles)
  local data = {}

  local models = {}
  for _, vehicle in pairs(polcars) do
    models[#models + 1] = vehicle.model
  end

  for _, vehicle in pairs(polcars) do
      if vehicle.first_free == true and not ownedData then
        print("FREE")
        vehicle.retail_price = 1
      end

      data[#data + 1] = {
          title = vehicle.name,
          description = "$" .. vehicle.retail_price .. ".00",
          key = vehicle.model,
          icon = "car",
          children = {
              { title = "Confirm Purchase", description = "", action = "ev-ui:polcarsPurchase", key = vehicle.model },
          },
      }
  end
  exports["ev-ui"]:showContextMenu(data)
end) 

local listening = false
local function listenForKeypress()
  listening = true
  Citizen.CreateThread(function()
      while listening do
          if IsControlJustReleased(0, 38) then
              listening = false
              exports["ev-ui"]:hideInteraction()
              RPC.execute("polcars:checkOwnedStatus") 
              --showPolcarMenu()
          end
          Wait(0)
      end
  end)
end

RegisterUICallback("ev-ui:polcarsPurchase", function(data, cb)
  local zoneName, zone = getZone()
  if not zone then return end
  data.model = data.key
  data.vehicle_name = GetDisplayNameFromVehicleModel(data.model)
  local myJob = exports['isPed']:isPed('myjob')
  local success, message = RPC.execute("polcars:purchasePolcar", zone.vehicles, data, myJob)
  if not success then
      cb({ data = {}, meta = { ok = success, message = message } })
      TriggerEvent("DoLongHudText", message, 2)
      return
  end

  TriggerEvent("DoLongHudText", message, 1)
  cb({ data = {}, meta = { ok = true, message = "done" } })
end)

AddEventHandler("ev-polyzone:enter", function(zone)
  if zones[zone] == nil then return end

  if not hasJob(zones[zone]) then return end
  zones[zone].inZone = true

  exports["ev-ui"]:showInteraction(("[E] %s"):format(zones[zone].label))
  listenForKeypress()
end)

AddEventHandler("ev-polyzone:exit", function(zone)
  if zones[zone] == nil then return end
  exports["ev-ui"]:hideInteraction()
  listening = false
  zones[zone].inZone = false
end)

function hasJob (zone)
  local currentJob = exports["isPed"]:isPed("myjob")
  for _, job in pairs(zone.jobs) do
    if job == currentJob then
      return true
    end
  end
  return false
end

function getZone()
  for zoneName, zone in pairs(zones) do
    if zone.inZone then
      return zoneName, zone
    end
  end
  return nil, nil
end
