local vehiclesForSale = {}
local vehicleList = {}

function insertLog(vin, model, plate, price, financed, commission, tax, shop, buyer, seller)
  if not vin or not model or not plate or not price or not financed or not commission or not tax or not shop or not buyer or not seller then return end

  MySQL.insert.await([[
        INSERT INTO carshop_logs (vin, model, price, financed, commission, tax, shop, buyer, seller)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    ]],
    { vin, model, price, financed, commission, tax, shop, buyer, seller })

  exports["ev-logs"]:AddLog("vehicleShop", vin, model, price, financed, commission, tax, shop, buyer, seller)
end

exports("insertLog", insertLog)

RegisterNetEvent("ev-carshop:change")
AddEventHandler("ev-carshop:change", function(shop, index, model)
  if not shop or not index or not model then return end

  MySQL.update.await([[
        UPDATE carshop_display
        SET ?? = ?
        WHERE ?? = ? AND ?? = ?
    ]],
    { "model", model, "shop", shop, "index", index })

  config[shop].carSpawns[index]["model"] = model

  TriggerClientEvent("ev-carshop:updateDisplay", -1, shop)
end)

RPC.register("ev-carshop:change", function(src, shop, index, model)
  if not shop or not index or not model then return end

  MySQL.update.await([[
        UPDATE carshop_display
        SET ?? = ?
        WHERE ?? = ? AND ?? = ?
    ]],
    { "model", model, "shop", shop, "index", index })

  config[shop].carSpawns[index]["model"] = model

  TriggerClientEvent("ev-carshop:updateDisplay", -1, config[shop].carSpawns)
end)

RegisterNetEvent("ev-carshop:commission")
AddEventHandler("ev-carshop:commission", function(shop, index, commission)
  if not shop or not index or not commission then return end

  local src = source

  config[shop].carSpawns[index]["commission"] = commission

  TriggerClientEvent("DoLongHudText", src, "Commission changed to " .. commission .. "%")
end)

RegisterNetEvent("ev-carshop:sell")
AddEventHandler("ev-carshop:sell", function(plate, shop, index)
  if not plate or not shop or not index then return end

  local src = source

  local user = exports["ev-base"]:getModule("Player"):GetUser(src)
  local info = user:getCurrentCharacter().id
  if not info.id then return end

  local name = info.first_name .. " " .. info.last_name

  config[shop].carSpawns[index]["seller"]["sid"] = src
  config[shop].carSpawns[index]["seller"]["name"] = name

  vehiclesForSale[plate] = GetGameTimer() + 60000
end)

RPC.register('ev-carshop:stockPurchase', function(src, data)
  local BizAccountId = exports["ev-financials"]:getBusinessAccountId(data.location)
  local user = exports["ev-base"]:getModule("Player"):GetUser(src)
  local cid = user:getCurrentCharacter().id
  if not cid then return end

  local accountResult, accountId = exports["ev-financials"]:getDefaultBankAccount(user.character.id, false, false)
  if not accountResult then return false, accountId end
  local bank = exports["ev-financials"]:getAccountBalance(BizAccountId)

  --Checks if the vehicle exists in the database
  local vehicleData = MySQL.single.await("SELECT * FROM carshop_vehicles WHERE model = ?", {data.model})
  if (vehicleData.model == nil) then
    TriggerClientEvent("DoLongHudText", src, "Couldn't find a vehicle with model name: " .. data.model, 2)
      return false
  end 

  --Shop check, If not tuner dont allow them to purchase imports.
  if vehicleData.category == "imports" and vehicleData.shop ~= "tuner" then
    TriggerClientEvent("DoLongHudText", src, "You dont have the ability to purchase imports.", 2)
    return false
  end

  --checks business bank account.
  if bank < (vehicleData.price * data.vehicleAmount) then
    TriggerClientEvent("DoLongHudText", src, "You do not have $" .. (vehicleData.price * data.vehicleAmount) .. " in your busisness account.", 2)
    return false, "You do not have $" .. vehicleData.price .. " in your busisness account."
  end

  --Failsafe + do transaction
  local comment = "Bought " .. data.vehicleAmount .. " " .. vehicleData.model .. "(s) for " .. "$" .. (vehicleData.price * data.vehicleAmount)
  if not exports["ev-financials"]:DoTransaction(src, BizAccountId, 5, (vehicleData.price * data.vehicleAmount), comment, "Vehicle Stock Replenish", "purchase") then 
    TriggerClientEvent("DoLongHudText", src, "You don't have enough money.", 2)
    return false, "You don't have enough money."
  end

  --Updates the stock data in the database
  local stockGrab = MySQL.single.await("SELECT * FROM carshop_vehicles WHERE model = ?", {data.model})
  local stockValue = stockGrab.stock + data.vehicleAmount

  MySQL.update.await([[
        UPDATE carshop_vehicles
        SET ?? = ?
        WHERE ?? = ?
    ]],
    { "stock", stockValue, "model", data.model })

  --Resets the menu data for target.
  local _vehicles = MySQL.query.await([[
        SELECT *
        FROM carshop_vehicles
        ORDER BY category, model
    ]])

  vehicleList = _vehicles

  local _display = MySQL.query.await([[
        SELECT *
        FROM carshop_display
    ]])

  TriggerClientEvent("DoLongHudText", src, "You have Purchased " .. data.model .. " stock replenished ")

  for i, v in ipairs(_display) do
    config[v.shop].carSpawns[v.index]["model"] = v.model
    config[v.shop].carSpawns[v.index]["CarPresets"] = json.decode(v.presets)
    config[v.shop].carSpawns[v.index]["commission"] = 15
    config[v.shop].carSpawns[v.index]["seller"] = {
      ["cid"] = 0,
    }
  end

  return true, "You have Purchased " .. data.model .. " stock replenished"
end)

RPC.register('ev-carshop:buy', function(pSource, pParams)
  local businessAccountId = exports["ev-financials"]:getBusinessAccountId(pParams.shop)
  local user = exports["ev-base"]:getModule("Player"):GetUser(pSource)
  local cid = user:getCurrentCharacter().id
  if not cid then return end

  local accountResult, accountId = exports["ev-financials"]:getDefaultBankAccount(user.character.id, false, false)
  if not accountResult then return false, accountId end

  local bank = exports["ev-financials"]:getAccountBalance(accountId)

  if bank < pParams.finalprice then
    return false, "You do not have $" .. pParams.finalprice .. " in your bank account."
  end

  local comment = "Brought " .. pParams.name
  local success = exports["ev-financials"]:DoBusinessTransaction(-1, accountId, businessAccountId, tonumber(pParams.finalprice), 3, comment, cid, tonumber(pParams.finalprice), "transfer")

  if not success then
    return false, "You don't have enough money."
  end

  local comment2 = "Commission from " .. pParams.name
  -- local success2, message2 = exports["ev-financials"]:transaction(groupBank, sellerAccount, pParams.commission, comment2, 0, 1)
  -- if not success2 then
  --     TriggerClientEvent("DoLongHudText", src, message2)
  --     return
  -- end

  local vehicleData = exports["ev-vehicles"]:GenerateVehicleInfo(pSource, cid, pParams.model, "pdm", "pdm", false, pParams.name, false, false, false)
  if not vehicleData then
    return false, "Error while inserting vehicle data to db"
  end

  TriggerEvent("ev:vehicles:InsertVehicleData", pSource, vehicleData)

  --Updates the stock data in the database
  local stockValue = pParams.stock - 1

  MySQL.update.await([[
        UPDATE carshop_vehicles
        SET ?? = ?
        WHERE ?? = ?
    ]],
    { "stock", stockValue, "model", pParams.model })

  --Resets the menu data for target.
  local _vehicles = MySQL.query.await([[
        SELECT *
        FROM carshop_vehicles
        ORDER BY category, model
    ]])

  vehicleList = _vehicles

  local _display = MySQL.query.await([[
        SELECT *
        FROM carshop_display
    ]], { pParams.shop })

  for i, v in ipairs(_display) do
    config[v.shop].carSpawns[v.index]["model"] = v.model
    config[v.shop].carSpawns[v.index]["CarPresets"] = json.decode(v.presets or "")
    config[v.shop].carSpawns[v.index]["commission"] = 15
    config[v.shop].carSpawns[v.index]["seller"] = {
      ["cid"] = 0,
    }
  end

  return true, "You have Purchase " .. pParams.name .. " Check the garage through your phone "
end)

RPC.register("ev-carshop:getVehicles", function(src, shop)
  local _vehicles = {}

  for i, v in ipairs(vehicleList) do
    if v["shop"] == shop then
      table.insert(_vehicles, v)
    end
  end

  return _vehicles
end)

RPC.register("showroom:locationInit", function(src, shop)
  -- Debug step 1: What shop was requested?
  print("^2[DEBUG][showroom:locationInit] Requested shop: " .. tostring(shop) .. "^7")
  
  -- Debug step 2: Get config for this shop
  local data = getConfigFor(shop)
  if not data then
    print("^1[ERROR][showroom:locationInit] getConfigFor(" .. tostring(shop) .. ") returned nil!^7")
  end

  -- Debug step 3: Is carSpawns present and a table?
  local spawns = {}
  if data then
    if not data.carSpawns then
      print("^1[ERROR][showroom:locationInit] config for shop " .. tostring(shop) .. " has no carSpawns!^7")
    elseif type(data.carSpawns) ~= "table" then
      print("^1[ERROR][showroom:locationInit] carSpawns for shop " .. tostring(shop) .. " is not a table (type: " .. type(data.carSpawns) .. ")!^7")
    elseif next(data.carSpawns) == nil then
      print("^3[WARNING][showroom:locationInit] carSpawns for shop " .. tostring(shop) .. " is an empty table!^7")
      spawns = data.carSpawns
    else
      -- Normal, valid carSpawns
      spawns = data.carSpawns
      print("^2[DEBUG][showroom:locationInit] carSpawns for shop " .. tostring(shop) .. " loaded with " .. tostring(#spawns) .. " entries.^7")
    end
  end

  -- Final guard: If spawns is not a table, set to empty
  if type(spawns) ~= "table" then
    spawns = {}
    print("^1[ERROR][showroom:locationInit] Final fallback: spawns not a table, returning empty table.^7")
  end

  -- For even more verbose debugging, show the keys/models (only in development)
  if #spawns > 0 then
    for i, car in ipairs(spawns) do
      print("^2[DEBUG][showroom:locationInit] Spawn index: " .. tostring(i) .. ", Model: " .. tostring(car.model or "nil") .. "^7")
    end
  end

  -- Always return a table, never nil
  return spawns, false
end)



RPC.register("showroom:getCarPresets", function(src)
  local TempPresets = {}
  for k, v in pairs(config) do
    for index, data in pairs(config[k].carSpawns) do
      if data["CarPresets"] ~= "{}" or "[]" then
        TempPresets[data["model"]] = data["CarPresets"]
      end
    end
  end
  return TempPresets
end)

RPC.register("ev-carshop:getInformations", function(src, shop, index)
  if not shop or not index then return end

  local model = config[shop].carSpawns[index]["model"]
  if not model then return end

  local infos = nil
  for i, v in ipairs(vehicleList) do
    if v["model"] == model and v["shop"] == shop then
      infos = v
      infos["seller"] = config[shop].carSpawns[index]["seller"]
      infos["commission"] = config[shop].carSpawns[index]["commission"]
      break
    end
  end

  return infos
end)

RPC.register("ev-carshop:forSale", function(plate)
  if vehiclesForSale[plate] and vehiclesForSale[plate] > GetGameTimer() then
    return vehiclesForSale[plate]
  else
    return GetGameTimer() + 60000
  end
end)

Citizen.CreateThread(function()
  local _vehicles = MySQL.query.await([[
    SELECT *
    FROM carshop_vehicles
    ORDER BY category, model
  ]])

  vehicleList = _vehicles

  local _display = MySQL.query.await([[
        SELECT *
        FROM carshop_display
    ]])

  for i, v in ipairs(_display) do
    if (config[v.shop] and config[v.shop].carSpawns[v.index]) then
      config[v.shop].carSpawns[v.index]["model"] = v.model
      config[v.shop].carSpawns[v.index]["CarPresets"] = json.decode(v.presets)
      config[v.shop].carSpawns[v.index]["commission"] = 15
      config[v.shop].carSpawns[v.index]["seller"] = {
        ["cid"] = 0,
      }
    end
  end
end)


RPC.register("carshop:getVehicles", function(src, shop)
    -- Query vehicles for the specified shop from the DB
    local vehicles = MySQL.query.await([[
        SELECT model, price, category, stock, shop FROM carshop_vehicles WHERE shop = ?
    ]], {shop})

    -- Return the results to the UI
    return { items = vehicles }
end)
