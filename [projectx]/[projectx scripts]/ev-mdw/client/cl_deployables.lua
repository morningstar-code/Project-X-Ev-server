local lastPlace = 0

AddEventHandler("ev-inventory:itemUsed", function(pItem)
  local info = exports["ev-inventory"]:itemListInfo(pItem)
  info = json.decode(info)
  if not info.deployableObject then return end
  local cid = exports["isPed"]:isPed("cid")
  local result = exports['ev-objects']:PlaceAndSaveObject(
    info.deployableObject,
    { cid = cid, item = pItem },
    { groundSnap = true, allowHousePlacement = true },
    function(pCoords, pMaterial, pEntity)
      return true
    end,
    "objects",
    info.deployableExpires
  )
  if not result then return end
  local stillhasItem = exports['ev-inventory']:hasEnoughOfItem(pItem, 1, false, true)
  if not stillhasItem then
    return exports["ev-objects"]:DeleteObject(result)
  end
  TriggerEvent("inventory:removeItem", pItem, 1)
  lastPlace = GetGameTimer()
end)

AddEventHandler("ev-deployables:pickup", function(p1, p2, p3)
  local cid = p3.meta.data.metadata.cid
  local myCid = exports["isPed"]:isPed("cid")
  if (cid ~= myCid) and (cid ~= -1) then
    TriggerEvent("DoLongHudText", "You cannot do that.", 2)
    return
  end
  local id = p3.meta.id
  exports["ev-objects"]:DeleteObject(id)
  TriggerEvent("player:receiveItem", p3.meta.data.metadata.item, 1)
end)

AddEventHandler("ev-deployables:remove", function(p1, p2, p3)
  local cid = p3.meta.data.metadata.cid
  local myCid = exports["isPed"]:isPed("cid")
  if (cid ~= myCid) and (cid ~= -1) then
    TriggerEvent("DoLongHudText", "You cannot do that.", 2)
    return
  end
  local finished = exports["ev-taskbar"]:taskBar(5000, "Removing")
  if finished ~= 100 then return end
  local id = p3.meta.id
  exports["ev-objects"]:DeleteObject(id)
end)

Citizen.CreateThread(function()
  Citizen.Wait(5000)
  local items = exports["ev-inventory"]:getFullItemList()
  local models = {}
  for _, item in pairs(items) do
    if item.deployableObject then
      models[#models + 1] = GetHashKey(item.deployableObject)
    end
  end
  exports["ev-interact"]:AddPeekEntryByModel(models, {
    {
      id = "pickupdeployable",
      event = "ev-deployables:pickup",
      icon = "circle",
      label = "Grab",
    },
  }, {
    distance = { radius = 25.0 },
    isEnabled = function(p1, p2)
      return ((p2
        and p2.meta
        and p2.meta.data
        and p2.meta.data.metadata
        and p2.meta.data.metadata.item) and (lastPlace + 60000) > GetGameTimer()) and true or false
    end,
  })
  exports["ev-interact"]:AddPeekEntryByModel(models, {
    {
      id = "removedeployable",
      event = "ev-deployables:remove",
      icon = "circle",
      label = "Remove",
    },
  }, {
    distance = { radius = 25.0 },
    isEnabled = function(p1, p2)
      return (p2
        and p2.meta
        and p2.meta.data
        and p2.meta.data.metadata
        and p2.meta.data.metadata.item) and true or false
    end,
  })
end)
