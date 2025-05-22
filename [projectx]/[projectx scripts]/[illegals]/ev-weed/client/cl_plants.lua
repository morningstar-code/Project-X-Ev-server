MyStrains = {}
AddEventHandler('ev-spawn:characterSpawned', function()
  local strains = RPC.execute('ev-weed:fetchPlayerStrains')
  setPlayerStrains(strains)
end)

RegisterNetEvent('ev-weed:setPlayerStrains', function(pStrains)
  setPlayerStrains(pStrains)
end)

local currentZone = nil
AddEventHandler("ev-polyzone:enter", function (name)
  if name ~= "changaloa" then return end

  currentZone = name
end)

AddEventHandler("ev-polyzone:exit", function (name)
  if name ~= "changaloa" then return end

  currentZone = nil
end)

RegisterUICallback('ev-weed:getWeedStrains', function(data, cb)
  local strains = RPC.execute('ev-weed:fetchPlayerStrains')
  setPlayerStrains(strains)
  local strainData = {}
  for _,strain in ipairs(MyStrains) do
    strainData[#strainData+1] = {
      n = strain.n,
      p = strain.p,
      k = strain.k,
      name = strain.name,
      genName = getStrainName(strain),
      rep = strain.rep,
    }
  end
  cb({ data = { strains = strainData, threshholds = RepThreshholds }, meta = { ok = true, message = '' } })
end)

function setPlayerStrains(pStrains)
  MyStrains = {}
  for _, strain in ipairs(pStrains) do
    local npk = {}
    for str in string.gmatch(strain.strain, '([^-]+)') do
      npk[#npk + 1] = tonumber(str)
    end
    MyStrains[#MyStrains + 1] = { n = npk[1], p = npk[2], k = npk[3], rep = strain.rep, canName = strain.canName, name = strain.name }
  end

  table.sort(MyStrains, function(a, b)
    return a['rep'] > b['rep']
  end)
end

AddEventHandler('ev-inventory:itemUsed', function(item, info)
  if item == 'femaleseed' then
    local lastMaterial
    local result = exports['ev-objects']:PlaceObject(PlantConfig.GrowthObjects[1].hash, {
      collision = true,
      forceGroundSnap = true,
      zOffset = PlantConfig.GrowthObjects[1].zOffset,
      distance = 2.0,
    }, function(coords, material, entity)
      if MaterialHashes[material] and not exports["ev-build"]:getModule("func").isInBuilding() then
        lastMaterial = material
        return true
      end
      if currentZone then
        lastMaterial = getFirstKey(MaterialHashes)
        return true
      end
      return false
    end)

    if not result[1] then
      return
    end
    TaskTurnPedToFaceCoord(PlayerPedId(), result[2].coords.x, result[2].coords.y, result[2].coords.z, 3000)
    TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_GARDENER_PLANT', 0, false)
    local finished = exports['ev-taskbar']:taskBar(5000, 'Planting Seed', false, true, false, false, nil, 5.0, PlayerPedId())
    ClearPedTasksImmediately(PlayerPedId())
    if finished == 100 and exports['ev-inventory']:hasEnoughOfItem('femaleseed', 1, false, true) then
      local typeMod = PlantConfig.TypeModifiers[MaterialHashes[lastMaterial]]
      local _info = json.decode(info)
      if _info.strain then
        typeMod.n = _info.strain.n
        typeMod.p = _info.strain.p
        typeMod.k = _info.strain.k
      end
      RPC.execute('ev-weed:plantSeed', result[2].coords, result[2].rotation, typeMod)
    end
  end
end)

AddEventHandler('ev-weed:checkPlant', function(pContext, pEntity)
  local plant = exports['ev-objects']:GetObjectByEntity(pEntity)
  if not plant then
    return
  end
  showPlantMenu(plant)
end)

RegisterUICallback('ev-weed:addWater', function(data, cb)
  cb({ data = {}, meta = { ok = true, message = '' } })
  playPourAnimation(PlayerPedId(), data.key.handle)
  local finished = exports['ev-taskbar']:taskBar(4000, 'Watering', false, true, false, false, nil, 5.0, PlayerPedId())
  ClearPedTasks(PlayerPedId())
  TriggerEvent('destroyProp')
  if finished == 100 then
    local items = exports['ev-inventory']:getItemsOfType('wateringcan', 1, 2)

    if #items < 1 then
      return
    end

    local returnData = RPC.execute('ev-weed:addWater', data.key.id)
    if not returnData then
      return
    end
    local plant = exports['ev-objects']:GetObject(data.key.id)
    showPlantMenu(plant)
    TriggerServerEvent('inventory:degItem', items[1].id, 1, 'wateringcan', data.character.id);
  end
end)

local RangeListener = {}

RegisterUICallback('ev-weed:setFertilizer', function(data, cb)
  cb({ data = {}, meta = { ok = true, message = '' } })
  local inputs
  if data.key.new then
    -- open the range-picker application from ev-ui
    Wait(1)
    exports['ev-ui']:openApplication('range-picker', { submitUrl = 'ev-ui:weed:submitStrainValues' })

    RangeListener.data = promise:new()

    local data = Citizen.Await(RangeListener.data)
    inputs = { n = data[1], p = data[2], k = data[3] }
  else
    inputs = { n = data.key.n, p = data.key.p, k = data.key.k }
  end

  playPourAnimation(PlayerPedId(), data.key.handle)
  local finished = exports['ev-taskbar']:taskBar(2000, 'Adding Fertilizer', false, true, false, false, nil, 5.0, PlayerPedId())
  ClearPedTasks(PlayerPedId())
  TriggerEvent('destroyProp')
  if finished == 100 then
    local returnData = RPC.execute('ev-weed:addFertilizer', data.key.plant.id, inputs, data.key.new)
    if not returnData then
      return
    end
    local plant = exports['ev-objects']:GetObject(data.key.plant.id)
    showPlantMenu(plant)
  end
end)

RegisterUICallback('ev-ui:weed:submitStrainValues', function(pData, cb)
  cb({ pData = {}, meta = { ok = true, message = '' } })
  exports['ev-ui']:closeApplication('range-picker')
  RangeListener.data:resolve(pData.ranges)
end)

RegisterUICallback('ev-weed:addMaleSeed', function(data, cb)
  cb({ data = {}, meta = { ok = true, message = '' } })
  TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_GARDENER_PLANT', 0, true)
  local finished = exports['ev-taskbar']:taskBar(3000, 'Adding Male Seed', false, true, false, false, nil, 5.0, PlayerPedId())
  ClearPedTasks(PlayerPedId())
  if finished == 100 and exports['ev-inventory']:hasEnoughOfItem('maleseed', 1, false) then
    local returnData = RPC.execute('ev-weed:addMaleSeed', data.key.id)
    if not returnData then
      return
    end
    local plant = exports['ev-objects']:GetObject(data.key.id)
    showPlantMenu(plant)
  end
end)
 
RegisterUICallback('ev-weed:removePlant', function(data, cb)
  cb({ data = {}, meta = { ok = true, message = '' } })
  TriggerEvent('animation:PlayAnimation', 'layspike')
  local finished = exports['ev-taskbar']:taskBar(3000, 'Removing', false, true, false, false, nil, 5.0, PlayerPedId())
  ClearPedTasks(PlayerPedId())
  if finished == 100 then
    RPC.execute('ev-weed:removePlant', data.key.id)
  end
end)

AddEventHandler('ev-weed:pickPlant', function(pContext, pEntity)
  local plant = exports['ev-objects']:GetObjectByEntity(pEntity)
  if not plant then
    return
  end

  local timeSinceHarvest = GetCloudTimeAsInt() - plant.data.metadata.lastHarvest
  
  if getPlantGrowthPercent(plant, GetCloudTimeAsInt()) < PlantConfig.HarvestPercent or plant.data.metadata.lastHarvest > 0 and timeSinceHarvest <= (PlantConfig.TimeBetweenHarvest * 60) then
    TriggerEvent('DoLongHudText', 'Not ready for harvesting', 2)
    return
  end

  local plyWeight = exports['ev-inventory']:getCurrentWeight()
  if plyWeight + 35.0 > 250.0 and plant.data.metadata.gender == 0 then
    TriggerEvent('DoLongHudText', 'You do not have enough room to hold the bud.', 2)
    return
  end

  TriggerEvent('animation:PlayAnimation', 'layspike')
  local finished = exports['ev-taskbar']:taskBar(10000, 'Harvesting', false, true, false, false, nil, 5.0, PlayerPedId())
  ClearPedTasks(PlayerPedId())
  if finished == 100 then
    RPC.execute('ev-weed:harvestPlant', plant.id)
  end
end)

function getPlantById(pPlantId)
  return exports['ev-objects']:GetObject(pPlantId)
end

function playPourAnimation(pedId, entityId)
  loadAnimDict('weapon@w_sp_jerrycan')
  TaskTurnPedToFaceEntity(pedId, entityId, 0);
  Wait(100)
  TriggerEvent('attachItem', 'wateringcan2');
  TaskPlayAnim(pedId, 'weapon@w_sp_jerrycan', 'fire', 8.0, -8.0, -1, 49, 0, false, false, false);
  local attachedProp = exports['ev-propattach']:GetAttachedProp();
  if (attachedProp) then
    TriggerServerEvent('fx:waterPour', NetworkGetNetworkIdFromEntity(attachedProp));
  end
end

function showPlantMenu(pPlant)
  -- Build context menu
  local growth = getPlantGrowthPercent(pPlant, GetCloudTimeAsInt())
  local water = pPlant.data.metadata.water
  local myjob = exports['isPed']:isPed('myjob')
  local context = {}
  context[#context + 1] = {
    title = ("Growth: %s%%"):format(string.format('%.2f', growth)),
    description = 'Gender: ' .. (pPlant.data.metadata.gender == 1 and 'Male' or 'Female'),
    icon = 'cannabis',
  }

  -- Only allow adding water/fertilzier before harvest time
  local disableActions = growth >= PlantConfig.HarvestPercent
  context[#context + 1] = {
    title = 'Add Water',
    description = 'Requires a Watering Can',
    icon = 'tint',
    key = pPlant,
    action = 'ev-weed:addWater',
    disabled = water >= 100.0 or not exports['ev-inventory']:hasEnoughOfItem('wateringcan', 1, false),
  }

  local fertChildren = {
    {
      title = 'Create New',
      key = { plant = pPlant, new = true },
      action = 'ev-weed:setFertilizer',
    },
  }

  local curName = 'Unknown'

  for _, strain in ipairs(MyStrains) do
    fertChildren[#fertChildren + 1] = {
      title = strain.name or getStrainName(strain),
      key = { plant = pPlant, n = strain.n, p = strain.p, k = strain.k },
      action = 'ev-weed:setFertilizer',
    }

    if (pPlant.data.metadata.n == strain.n and pPlant.data.metadata.p == strain.p and pPlant.data.metadata.k == strain.k) then
      curName = strain.name or getStrainName(strain)
    end
  end

  context[#context + 1] = {
    title = 'Add Fertilizer',
    description = curName,
    disabled = not exports['ev-inventory']:hasEnoughOfItem('fertilizer', 1, false) or disableActions,
    icon = 'seedling',
    children = fertChildren,
  }

  -- Only allow changing gender in the first 2~ stages
  if getStageFromPercent(growth) < 3 and pPlant.data.metadata.gender == 0 then
    context[#context + 1] = {
      title = 'Add Male Seed',
      description = 'Make the plant preggies',
      icon = 'mars',
      key = pPlant,
      action = 'ev-weed:addMaleSeed',
      disabled = not exports['ev-inventory']:hasEnoughOfItem('maleseed', 1, false),
    }
  end

  if growth >= 95 or myjob == 'police' or myjob == 'judge' then
    context[#context + 1] = {
      title = 'Destroy Plant',
      icon = 'times',
      key = pPlant,
      action = 'ev-weed:removePlant',
    }
  end

  exports['ev-ui']:showContextMenu(context);
end

function getFirstKey(list)
  for k, v in pairs(list) do
    return k
  end
end
