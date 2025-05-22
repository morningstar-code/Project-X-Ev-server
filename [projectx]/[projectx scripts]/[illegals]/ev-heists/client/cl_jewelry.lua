local isDarkMarketJewelry = false
local electricalBoxCoords = vector3(-596.04,-283.74,50.49)
local electricalBoxHeading = 296.8
local electricalBoxThermite = {
  x = electricalBoxCoords.x,
  y = electricalBoxCoords.y,
  z = electricalBoxCoords.z,
  h = electricalBoxHeading,
}

local thermiteMinigameUICallbackUrl = "ev-ui:heistsThermiteMinigameResult"
local gameSettings = {
  gameFinishedEndpoint = thermiteMinigameUICallbackUrl,
  gameTimeoutDuration = 14000,
  coloredSquares = 10,
  gridSize = 5,
}

function loadAnimDict(dict)  
  while not HasAnimDictLoaded(dict) do
    RequestAnimDict(dict)
    Citizen.Wait(0)
  end
end 

function AttemptJewelryStoreThermite()
  if #(GetEntityCoords(PlayerPedId()) - electricalBoxCoords) > 1.5 then return false end
    Citizen.CreateThread(function()
      local canRob = RPC.execute("ev-heists:jewelryCanRob")
      if not canRob then
        TriggerEvent("DoLongHudText", "Already burnt!", 2)
        return
      end

      if not isDarkMarketJewelry then return end

      TriggerEvent("inventory:removeItem", "thermitecharge", 1)
      exports["ev-dispatch"]:dispatch("10-90A", "Jewelry Robbery")

      local success = Citizen.Await(ThermiteCharge(electricalBoxThermite, nil, 0.0, gameSettings))
      if success then
        RPC.execute("ev-heists:jewelryStartRobbery")
        RPC.execute("completeTask", "darkmarket_jewel", 2)
        RPC.execute("ev:progression:character:illegalRep", 1, "hackexp")
      else
        RPC.execute("completeTask", "darkmarket_jewel", 3, nil, true)
      end
    end)
  return true
end

local acceptableWeapons = {
  [-942620673] = true,  -- uzi
  [-134995899] = true,  -- mac10
  [497969164] = true,   -- m70
  [-1074790547] = true, -- ak47
  [1192676223] = true,  -- pdm4
  [1432025498] = true,  -- pdshotgun
  [171789620] = true,  -- pdmpx
  [-275439685] = true,  -- DBshotgun
  [487013001] = true,  -- Pumpshotgun
  [1649403952] = true,  -- draco
  [-1472189665] = true, -- Skorpion
}

RegisterNetEvent("startillegaljewelry")
AddEventHandler("startillegaljewelry", function(groupId, groupData, members, task, pState)
  local clientId = PlayerId()
  local src = GetPlayerServerId(clientId)
  for k,v in pairs(members) do
      if tonumber(v.src) == tonumber(src) then
          if tonumber(v.src) ~= tonumber(groupData.leader) then
              isDarkMarketJewelry = pState
              TriggerEvent("ev-phone:JobNotify", task.header, task.task, false, groupId)
          else
              isDarkMarketJewelry = pState
              TriggerEvent("ev-phone:JobNotify", task.header, task.task, true, groupId)
          end
      end
  end
end)

RegisterNetEvent("finishillegaljewelry")
AddEventHandler("finishillegaljewelry", function(members, pState)
  local clientId = PlayerId()
  local src = GetPlayerServerId(clientId)
  for k,v in pairs(members) do
      if tonumber(v.src) == tonumber(src) then
            isDarkMarketJewelry = pState
      end
  end
end)

AddEventHandler("ev-heists:jewelryHitGlassBox", function(p1, p2, pContext)
  -- if not isDarkMarketJewelry then return end
  local id = pContext.zones["jewelry_rob_spot"].id
  local canSmash = RPC.execute("ev-heists:jewelryCanSmashBox", id, false)
  if not canSmash then
    TriggerEvent("DoLongHudText", "Already smashed!", 2)
    return
  end
  local foundWeapon = nil
  for k, v in pairs(acceptableWeapons) do
    if not foundWeapon then
      local hasWeapon = exports["ev-inventory"]:hasEnoughOfItem(tostring(k), 1, false, true)
      if hasWeapon then
        foundWeapon = k
      end
    end
  end
  if not foundWeapon then
    TriggerEvent("DoLongHudText", "You need something bigger to smash this.", 2)
    return
  end
  RPC.execute("ev-heists:jewelryCanSmashBox", id, true)
  local count = RPC.execute("ev-heists:jewelryCount")
  RPC.execute("updateObjectiveData", 'darkmarket_jewel', 3, count)
  GiveWeaponToPed(PlayerPedId(), foundWeapon, 1, false, true)
  SetCurrentPedWeapon(PlayerPedId(), foundWeapon, 1)
  loadAnimDict("missheist_jewel")
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'robberyglassbreak', 0.5)
	TaskPlayAnim(PlayerPedId(), "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
	Citizen.Wait(4200)
  ClearPedTasks(PlayerPedId())
  SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, 1)
  -- $30k pay
  -- watch $50
  -- goldbar $5000
  local rnd = math.random()
  if rnd < 0.15 then
    TriggerEvent("player:receiveItem", "goldbar", 1)
    Wait(100)
    TriggerEvent("player:receiveItem", "rolexwatch", math.random(5, 10))
  else
    TriggerEvent("player:receiveItem", "rolexwatch", math.random(20, 30))
  end
  TriggerServerEvent("ev-gallery:generateGem", "jewelry")
end)

Citizen.CreateThread(function()
  exports["ev-polytarget"]:AddBoxZone("jewelry_rob_spot", vector3(-625.78, -238.71, 38.06), 2.2, 1, {
    heading=305,
    -- debugPoly=true,
    minZ=37.66,
    maxZ=38.46,
    data = {
      id = 1,
    },
  })
  exports["ev-polytarget"]:AddBoxZone("jewelry_rob_spot", vector3(-626.55, -234.64, 38.06), 2.2, 0.6, {
    heading=306,
    -- debugPoly=true,
    minZ=37.66,
    maxZ=38.46,
    data = {
      id = 2,
    },
  })
  exports["ev-polytarget"]:AddBoxZone("jewelry_rob_spot", vector3(-627.18, -233.87, 38.06), 2.2, 0.6, {
    heading=306,
    -- debugPoly=true,
    minZ=37.66,
    maxZ=38.46,
    data = {
      id = 3,
    },
  })
  exports["ev-polytarget"]:AddBoxZone("jewelry_rob_spot", vector3(-619.33, -234.53, 38.06), 2.2, 0.6, {
    heading=306,
    -- debugPoly=true,
    minZ=37.66,
    maxZ=38.46,
    data = {
      id = 4,
    },
  })
  exports["ev-polytarget"]:AddBoxZone("jewelry_rob_spot", vector3(-617.42, -229.71, 38.06), 2.2, 0.6, {
    heading=216,
    -- debugPoly=true,
    minZ=37.66,
    maxZ=38.46,
    data = {
      id = 5,
    },
  })
  exports["ev-polytarget"]:AddBoxZone("jewelry_rob_spot", vector3(-619.54, -226.82, 38.06), 2.2, 0.6, {
    heading=216,
    -- debugPoly=true,
    minZ=37.66,
    maxZ=38.46,
    data = {
      id = 6,
    },
  })
  exports["ev-polytarget"]:AddBoxZone("jewelry_rob_spot", vector3(-624.72, -227.0, 38.06), 2.2, 0.6, {
    heading=126,
    -- debugPoly=true,
    minZ=37.66,
    maxZ=38.46,
    data = {
      id = 7,
    },
  })
  exports["ev-polytarget"]:AddBoxZone("jewelry_rob_spot", vector3(-620.47, -232.97, 38.06), 1.4, 0.6, {
    heading=126,
    -- debugPoly=true,
    minZ=37.66,
    maxZ=38.66,
    data = {
      id = 8,
    },
  })
  exports["ev-polytarget"]:AddBoxZone("jewelry_rob_spot", vector3(-620.11, -230.74, 38.06), 1.4, 0.6, {
    heading=36,
    -- debugPoly=true,
    minZ=37.66,
    maxZ=38.66,
    data = {
      id = 9,
    },
  })
  exports["ev-polytarget"]:AddBoxZone("jewelry_rob_spot", vector3(-621.47, -229.05, 38.06), 1.4, 0.6, {
    heading=36,
    -- debugPoly=true,
    minZ=37.66,
    maxZ=38.66,
    data = {
      id = 10,
    },
  })
  exports["ev-polytarget"]:AddBoxZone("jewelry_rob_spot", vector3(-623.62, -228.63, 38.06), 1.4, 0.6, {
    heading=306,
    -- debugPoly=true,
    minZ=37.66,
    maxZ=38.66,
    data = {
      id = 11,
    },
  })
  exports["ev-polytarget"]:AddBoxZone("jewelry_rob_spot", vector3(-624.04, -230.82, 38.06), 1.4, 0.6, {
    heading=216,
    -- debugPoly=true,
    minZ=37.66,
    maxZ=38.66,
    data = {
      id = 12,
    },
  })
  exports["ev-polytarget"]:AddBoxZone("jewelry_rob_spot", vector3(-622.53, -232.86, 38.06), 1.4, 0.6, {
    heading=216,
    -- debugPoly=true,
    minZ=37.66,
    maxZ=38.66,
    data = {
      id = 13,
    },
  })
  exports['ev-interact']:AddPeekEntryByPolyTarget("jewelry_rob_spot", {{
    event = "ev-heists:jewelryHitGlassBox",
    id = "jewelryhitglassbox",
    icon = "fas fa-circle",
    label = "Smash!",
    parameters = {},
  }}, { distance = { radius = 2.0 } })
end)