RegisterUICallback("ev-vineyard:setupWineboxContainer", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "done" } })
  exports["ev-ui"]:closeApplication("textbox")
  TriggerEvent("inventory:removeItemByMetaKV", data.inputKey.item, 1, "id", data.inputKey.id)
  Wait(250)
  if data.inputKey.item == "vineyardwinebox" then
    RPC.execute("ev-restaurants:getTakeoutBox", {
      box_item_id = "vineyardwinebox",
      image = data.values.image_url,
      item_desc = data.values.description,
      item_name = data.values.name,
      slots = 6,
      weight = 12,
      name = "Wine Box",
    })
    return
  end
  if data.inputKey.item == "vineyardwinebottle" then
    local mData = {
      aged = data.inputKey.aged,
      _image_url = data.values.image_url,
      description = data.values.description,
      _name = data.values.name,
      _hideKeys = { "_name", "_image_url" },
    }
    TriggerEvent("player:receiveItem", "vineyardwinebottle", 1, false, mData, mData)
    return
  end
end)

local setupItems = {
  ["vineyardwinebox"] = true,
  ["vineyardwinebottle"] = true,
}
AddEventHandler("ev-inventory:itemUsed", function(pItem, pData)
  if not setupItems[pItem] then return end
  local info = json.decode(pData)
  if not info.id then return end
  exports["ev-ui"]:openApplication("textbox", {
    callbackUrl = "ev-vineyard:setupWineboxContainer",
    inputKey = { item = pItem, id = info.id, aged = info.aged or '0s' },
    items = {
      { label = "Name", name = "name" },
      { label = "Description", name = "description" },
      { label = "Icon URL", name = "image_url" },
    },
    show = true,
  })
end)

AddEventHandler("ev-inventory:itemUsed", function(pItem, pData)
  if pItem ~= "vineyardwinebottle" then return end
  local info = json.decode(pData)
  if info.id then return end
  local amount = exports["ev-inventory"]:getQuantity("wineglass", true, false)
  if amount == 0 then
    TriggerEvent("DoLongHudText", "You need a wine glass.", 2)
    return
  end
  TriggerEvent("inventory:DegenLastUsedItem", 26)
  TriggerEvent("inventory:removeItem", "wineglass", 1)
  Wait(250)
  info._name = "Glass of " .. info._name
  info._image_url = nil
  TriggerEvent("player:receiveItem", "honestwineglass", 1, false, info, info)
end)
