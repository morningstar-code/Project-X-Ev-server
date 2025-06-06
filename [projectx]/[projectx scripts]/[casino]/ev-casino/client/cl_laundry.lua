local LAUNDRY_COORDS = {
  {
    vector3(1010.59, -8.15, 71.46), 1, 1, {
      heading=328,
      minZ=71.26,
      maxZ=72.06,
      data = {
        id = 1,
      },
    },
  },
  {
    vector3(1011.78, -8.77, 71.46), 1, 1, {
      heading=328,
      minZ=71.26,
      maxZ=72.06,
      data = {
        id = 2,
      },
    },
  },
  {
    vector3(1012.93, -9.5, 71.46), 1, 1, {
      heading=328,
      minZ=71.26,
      maxZ=72.06,
      data = {
        id = 3,
      },
    },
  },
  {
    vector3(1014.06, -10.15, 71.46), 1, 1, {
      heading=328,
      minZ=71.26,
      maxZ=72.06,
      data = {
        id = 4,
      },
    },
  },
  {
    vector3(1012.85, -12.16, 71.46), 1, 1, {
      heading=328,
      minZ=71.26,
      maxZ=72.06,
      data = {
        id = 5,
      },
    },
  },
  {
    vector3(1011.72, -11.47, 71.46), 1, 1, {
      heading=328,
      minZ=71.26,
      maxZ=72.06,
      data = {
        id = 6,
      },
    },
  },
  {
    vector3(1010.54, -10.76, 71.46), 1, 1, {
      heading=328,
      minZ=71.26,
      maxZ=72.06,
      data = {
        id = 7,
      },
    },
  },
  {
    vector3(1009.34, -10.1, 71.46), 1, 1, {
      heading=328,
      minZ=71.26,
      maxZ=72.06,
      data = {
        id = 8,
      },
    },
  },
}

Citizen.CreateThread(function()
  for _, v in pairs(LAUNDRY_COORDS) do
    exports["ev-polytarget"]:AddBoxZone("casino_hotel_laundry_machine", v[1], v[2], v[3], v[4])
  end
  exports["ev-interact"]:AddPeekEntryByPolyTarget("casino_hotel_laundry_machine", {{
    id = "casino_laundry_interact",
    label = "Do Laundry",
    icon = "fas fa-money-bill-alt",
    event = "ev-casino:hotel:doLaundry",
  }}, { distance = { radius = 1.5 } })
end)

AddEventHandler("ev-casino:hotel:doLaundry", function(p1, p2, pContext)
  local laundryId = pContext.zones["casino_hotel_laundry_machine"].id
  local coins = exports["ev-inventory"]:getItemsOfType("casinogoldcoin", 1, true)
  local coin = coins[1]
  if not coin then
    TriggerEvent("DoLongHudText", "No coin to insert.", 2)
    return
  end
  local roomId = json.decode(coin.information).room
  local canLaunder = RPC.execute("ev-casino:hotel:canUseLaundry", laundryId, roomId, true)
  if not canLaunder then
    TriggerEvent("DoLongHudText", "Machine in use or coin already used today.", 2)
    return
  end
  
  TriggerEvent("animation:PlayAnimation", "cokecut")
  local finished = exports["ev-taskbar"]:taskBar(15000, [[Adding "Laundry"...]])
  ClearPedTasks(PlayerPedId())
  if finished ~= 100 then return end
  RPC.execute("ev-casino:hotel:canUseLaundry", laundryId, roomId)
end)
