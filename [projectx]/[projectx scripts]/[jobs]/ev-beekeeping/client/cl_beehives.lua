local BeeHives = {}
local ActiveBeehives = {}

local inZone = 0
local setDeleteAll = false
local isPlacing = false
local hasShownMessage = false

--Creates da hives
--TODO: cache close hives
Citizen.CreateThread(function()
    while true do
        local plyCoords = GetEntityCoords(PlayerPedId())
        if BeeHives == nil then BeeHives = {} end
        for idx, hive in ipairs(BeeHives) do
            if idx % 100 == 0 then
                Wait(0) --Process 100 per frame
            end
            --convert timestamp -> growth percent
            local harvestPercent = getHiveReadyPercent(hive)
            if #(plyCoords - hive.coords) < (50.0 + harvestPercent) and not setDeleteAll then
                local curStage = getStageFromPercent(harvestPercent)
                local isChanged = (ActiveBeehives[hive.id] and ActiveBeehives[hive.id].stage ~= curStage)

                if isChanged then
                    removeBeehive(hive.id)
                end

                if not ActiveBeehives[hive.id] or isChanged then
                    local beeHive = createBeehiveStageAtCoords(curStage, hive.coords, hive.heading)
                    ActiveBeehives[hive.id] = {
                        object = beeHive,
                        stage = curStage
                    }
                end
            else
                removeBeehive(hive.id)
            end
        end
        if setDeleteAll then
            BeeHives = {}
            setDeleteAll = false
        end
        Wait(2000)
    end
end)

AddEventHandler("ev-inventory:itemUsed", function(item)
    if not isPlacing and item == "beehive" then
        if inZone > 0 then
            isPlacing = true
            if not hasShownMessage then
                local message = "\n" .. "Rotate with arrow keys" .. "\n" .. "Press [Enter] to place when hive is visible" .. "\n" .. "Press [Escape] to cancel."
                TriggerEvent(
                    'chatMessage',
                   'Instructions' .. ' ',
                    3,
                    message,
                    2500
                );
                hasShownMessage = true
            end
            placeObject("np_beehive", function(pPlaced, pCoords, pHeading)
                if pPlaced then
                    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_HAMMERING", 0, true)
                    local finished = exports["ev-taskbar"]:taskBar(15000, "Installing beehive", false, true, false, false, nil, 5.0, PlayerPedId())
                    ClearPedTasks(PlayerPedId())
                    if finished == 100 then
                        RPC.execute("ev-beekeeping:installHive", pCoords, pHeading)
                        TriggerEvent("inventory:removeItem", item, 1)
                    end
                else
                    TriggerEvent("DoLongHudText", "Couldn't place it or you canceled.")
                end
                isPlacing = false
            end)
        else
            TriggerEvent("DoLongHudText", "I should find a better area to install this in.")
        end
    end
end)

AddEventHandler("ev-beekeeping:checkBeehive", function(pContext, pEntity)
    local hiveId = getHiveId(pEntity)
    if not hiveId then return end
    showHiveMenu(hiveId)
end)

RegisterUICallback('ev-beekeeping:addQueen', function (data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
    local finished = exports["ev-taskbar"]:taskBar(15000, "Adding Queen bee", false, true, false, false, nil, 5.0, PlayerPedId())
    ClearPedTasks(PlayerPedId())
    if finished == 100 then
        RPC.execute("ev-beekeeping:addQueen", data.key.id)
        TriggerEvent("inventory:removeItem", "beequeen", 1)
    end
end)

RegisterUICallback('ev-beekeeping:removeHive', function (data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    TriggerEvent("animation:PlayAnimation","layspike")
    local finished = exports["ev-taskbar"]:taskBar(15000, "Removing", false, true, false, false, nil, 5.0, PlayerPedId())
    ClearPedTasks(PlayerPedId())
    if finished == 100 then
        local getReady = getHiveReadyPercent(getHiveById(data.key.id)) > 20.0
        local success = RPC.execute("ev-beekeeping:removeHive", data.key, getReady)
        if not success then
            print("Could not remove. pid:", data.key.id)
        end
    end
end)

AddEventHandler("ev-beekeeping:harvestHive", function(pContext, pEntity)
    local hiveId = getHiveId(pEntity)
    if not hiveId then return end

    local hive = getHiveById(hiveId)
    local timeSinceHarvest = GetCloudTimeAsInt() - hive.last_harvest
    if getHiveReadyPercent(hive) < HiveConfig.HarvestPercent or timeSinceHarvest <= (HiveConfig.TimeBetweenHarvest * 60) then
        TriggerEvent("DoLongHudText", "Not ready for harvesting", 2)
        return
    end

    local plyWeight = exports["ev-inventory"]:getCurrentWeight()
    if plyWeight + 90.0 > 250.0 then
        TriggerEvent("DoLongHudText", "You do not have enough room to hold the harvest.", 2)
        return
    end

    TriggerEvent("animation:PlayAnimation","layspike")
    local finished = exports["ev-taskbar"]:taskBar(5000, "Harvesting", false, true, false, false, nil, 5.0, PlayerPedId())
    ClearPedTasks(PlayerPedId())
    if finished == 100 then
        RPC.execute("ev-beekeeping:harvestHive", hiveId)
    end
end)

AddEventHandler("ev-polyzone:enter", function(zone, data)
    if zone == "ev-beekeeping:bee_zone" then
        inZone = inZone + 1
        if inZone == 1 then
            local result = RPC.execute("ev-beekeeping:getBeehives")
        end
    end
end)

AddEventHandler("ev-polyzone:exit", function(zone, data)
    if zone == "ev-beekeeping:bee_zone" then
        inZone = inZone - 1
        stopPlacing()
        if inZone < 0 then inZone = 0 end
        if inZone == 0 then
            setDeleteAll = true
        end
    end
end)

RegisterNetEvent('ev-beekeeping:trigger_zone')
AddEventHandler('ev-beekeeping:trigger_zone', function (type, pData)
    --Update all hives
    if type == 1 then
        for _, hive in ipairs(BeeHives) do
            local keep = false
            for _, newhive in ipairs(pData) do
                if hive.id == newhive.id then
                    keep = true
                    break
                end
            end

            if not keep then
                removeBeehive(hive.id)
            end
        end
        BeeHives = pData
    end

    --New hive being added
    if type == 2 then
        BeeHives[#BeeHives+1] = pData
    end

    --hive being harvested/updated
    if type == 3 then
        for idx, hive in ipairs(BeeHives) do
            if hive.id == pData.id then
                BeeHives[idx] = pData
                break
            end
        end
    end
  
    --hive being removed
    if type == 4 then
        for idx, hive in ipairs(BeeHives) do
            if hive.id == pData.id then
                table.remove(BeeHives, idx)
                removeBeehive(hive.id)
                break
            end
        end
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for idx, hive in pairs(ActiveBeehives) do
        DeleteObject(hive.object)
    end
end)

function createBeehiveStageAtCoords(pStage, pCoords, pHeading)
    local model = HiveConfig.HiveObjects[pStage].hash
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    local hiveObject = CreateObject(model, pCoords.x, pCoords.y, pCoords.z, 0, 0, 0)
    FreezeEntityPosition(hiveObject, true)
    if not pHeading then pHeading = 0.0 end
    SetEntityHeading(hiveObject, pHeading + 0.00001)
    -- SetEntityProofs(
    --   hiveObject --[[ Entity ]], 
    --   true --[[ boolean ]], 
    --   true --[[ boolean ]], 
    --   true --[[ boolean ]], 
    --   true --[[ boolean ]], 
    --   true --[[ boolean ]], 
    --   true --[[ boolean ]], 
    --   true --[[ boolean ]], 
    --   true --[[ boolean ]]
    -- )
    return hiveObject
end

function removeBeehive(pHiveId)
    if ActiveBeehives[pHiveId] then
        DeleteObject(ActiveBeehives[pHiveId].object)
        ActiveBeehives[pHiveId] = nil
    end
end

function getStageFromPercent(pPercent)
  if pPercent < 50.0 then
    return 1
  elseif pPercent >= 50.0 and pPercent < 100.0 then
    return 2
  else
    return 3
  end
end

function getHiveReadyPercent(pHive)
    local timeDiff = (GetCloudTimeAsInt() - math.max(pHive.last_harvest, pHive.timestamp)) / 60
    local queenFactor = (pHive.has_queen and HiveConfig.QueenFactor or 1)
    local growthFactors = (HiveConfig.GrowthTime / queenFactor)
    return math.min((timeDiff / growthFactors) * 100, 100.0)
end

function getHiveId(pEntity)
    for hiveId, hive in pairs(ActiveBeehives) do
        if hive.object == pEntity then
            return hiveId
        end
    end
end

function getHiveById(pHiveId)
    for _, hive in pairs(BeeHives) do
        if hive.id == pHiveId then
            return hive
        end
    end
end

function showHiveMenu(pHiveId)
    local hive = getHiveById(pHiveId)
    --Build context menu
    local harvest = getHiveReadyPercent(hive)
    local myjob = exports["isPed"]:isPed("myjob")
    local context = {}
    context[#context+1] = {
        title = 'Ready to harvest' .. ': ' .. string.format("%.2f", harvest) .. '%',
        description = (hive.has_queen and "Has Queen" or "No Queen"),
    }
    --Only allow changing gender in the first 2~ stages
    if getStageFromPercent(harvest) < 2 and not hive.has_queen then
        context[#context+1] = {
            title = 'Add Queen bee',
            key = { id = pHiveId },
            action = 'ev-beekeeping:addQueen',
            description = 'Make the hive happy.',
            disabled = not exports["ev-inventory"]:hasEnoughOfItem("beequeen", 1, false)
        }
    end

    if harvest >= 95 or myjob == "police" or myjob == "judge" then
        context[#context+1] = {
            title = 'Destroy Hive',
            key = { id = pHiveId },
            action = 'ev-beekeeping:removeHive',
        }
    end

    exports['ev-ui']:showContextMenu(context)
end
