local validHuntingZones = nil
local animals = nil
local baitDistanceInUnits = nil
local spawnDistanceRadius = nil

local baitLocation = nil
local baitLastPlaced = 0
local targetedEntity = nil
local MyHunt = nil

local animalList = {
    { name = "Boar", hash = `a_c_boar` },
    { name = "Cat", hash = `a_c_cat_01` },
    { name = "Chicken", hash = `a_c_chickenhawk` },
    { name = "Chimp", hash = `a_c_chimp` },
    { name = "Chop", hash = `a_c_chop` },
    { name = "Cormorant", hash = `a_c_cormorant` },
    { name = "Cow", hash = `a_c_cow` },
    { name = "Coyote", hash = `a_c_coyote` },
    { name = "Crow", hash = `a_c_crow` },
    { name = "Deer", hash = `a_c_deer` },
    { name = "Hen", hash = `a_c_hen` },
    { name = "Husky", hash = `a_c_husky` },
    { name = "Mountain-Lion", hash = `a_c_mtlion` },
    { name = "Pig", hash = `a_c_pig` },
    { name = "Pigeon", hash = `a_c_pigeon` },
    { name = "Poodle", hash = `a_c_poodle` },
    { name = "Pug", hash = `a_c_pug` },
    { name = "Rabbit", hash = `a_c_rabbit_01` },
    { name = "Rat", hash = `a_c_rat` },
    { name = "Retriever", hash = `a_c_retriever` },
    { name = "Chimp", hash = `a_c_rhesus` },
    { name = "Rottweiler", hash = `a_c_rottweiler` },
    { name = "Seagull", hash = `a_c_seagull` },
    { name = "Shepherd", hash = `a_c_shepherd` },
    { name = "Westy", hash = `a_c_westy` },
    { name = "Panther", hash = `a_c_panther` },
}

DecorRegister("HuntingMySpawn", 2)
DecorRegister("HuntingIllegal", 2)

local buffStartTime = 0
local buffItems = {
  ["beefdish"] = true,
  ["beefdishc"] = true,
}
AddEventHandler("buffs:triggerBuff", function(item)
  if not buffItems[item] then return end
  if buffStartTime ~= 0 then return end
  buffStartTime = GetGameTimer()
  Citizen.CreateThread(function()
    Citizen.Wait(60000 * 60) -- 1hr
    buffStartTime = 0
  end)
end)

Citizen.CreateThread(function()
    local result = RPC.execute("ev-hunting:getSettings")
    animals = result.animals
    baitDistanceInUnits = result.baitDistanceInUnits
    spawnDistanceRadius = result.spawnDistanceRadius
    validHuntingZones = result.validHuntingZones
end)

AddEventHandler("ev:target:changed", function(pEntity) 
    targetedEntity = pEntity
end)

local function isValidZone()
    print("zone", GetLabelText(GetNameOfZone(GetEntityCoords(PlayerPedId()))))
    return validHuntingZones[GetLabelText(GetNameOfZone(GetEntityCoords(PlayerPedId())))] == true
end

local function getSpawnLoc()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local spawnCoords = nil
    while spawnCoords == nil do
        local spawnX = math.random(-spawnDistanceRadius, spawnDistanceRadius)
        local spawnY = math.random(-spawnDistanceRadius, spawnDistanceRadius)
        local spawnZ = baitLocation.z
        local vec = vector3(baitLocation.x + spawnX, baitLocation.y + spawnY, spawnZ)
        if #(playerCoords - vec) > spawnDistanceRadius then
            spawnCoords = vec
        end
    end
    local worked, groundZ, normal = GetGroundZAndNormalFor_3dCoord(spawnCoords.x, spawnCoords.y, 1023.9)
    spawnCoords = vector3(spawnCoords.x, spawnCoords.y, groundZ)
    return spawnCoords
end

local function spawnAnimal(loc)
    local chance = math.random()
    print("spawnAnimal",chance)
    local foundAnimal = false
    for _, animal in pairs(animals) do
        if foundAnimal == false and animal.chance > chance then
            foundAnimal = animal
            print(chance, animal.chance)
        end
    end
    local modelName = foundAnimal.model
    RequestModel(modelName)
    while not HasModelLoaded(modelName) do
        Citizen.Wait(0)
    end
    local spawnLoc = getSpawnLoc()
    local spawnedAnimal = CreatePed(28, foundAnimal.hash, spawnLoc, true, true, true)
    DecorSetBool(spawnedAnimal, "HuntingMySpawn", true)
    DecorSetBool(spawnedAnimal, "HuntingIllegal", foundAnimal.illegal)

    MyHunt = spawnedAnimal
    print(MyHunt)
    
    if foundAnimal.illegal then
        TriggerEvent("civilian:alertPolice",50.0,"hunt-illegal",0,false,false)
    end
    
    SetModelAsNoLongerNeeded(modelName)
    TaskGoStraightToCoord(spawnedAnimal, loc, 1.0, -1, 0.0, 0.0)
    Citizen.CreateThread(function()
        local finished = false
        while not IsPedDeadOrDying(spawnedAnimal) and not finished do
            local spawnedAnimalCoords = GetEntityCoords(spawnedAnimal)
            if #(loc - spawnedAnimalCoords) < 0.5 then
                ClearPedTasks(spawnedAnimal)
                Citizen.Wait(1500)
                TaskStartScenarioInPlace(spawnedAnimal, "WORLD_DEER_GRAZING", 0, true)
                Citizen.SetTimeout(7500, function()
                    finished = true
                end)
            end
            if #(spawnedAnimalCoords - GetEntityCoords(PlayerPedId())) < 15.0 then
                ClearPedTasks(spawnedAnimal)
                TaskSmartFleePed(spawnedAnimal, PlayerPedId(), 600.0, -1)
                finished = true
            end
            Citizen.Wait(1000)
        end
        if not IsPedDeadOrDying(spawnedAnimal) then
            TaskSmartFleePed(spawnedAnimal, PlayerPedId(), 600.0, -1)
        end
    end)
end

local function baitDown()
    Citizen.CreateThread(function()
        while baitLocation ~= nil do
            local coords = GetEntityCoords(PlayerPedId())
            if #(baitLocation - coords) > baitDistanceInUnits then
                if math.random() < 1.0 then
                    spawnAnimal(baitLocation)
                    baitLocation = nil
                end
            end
            Citizen.Wait(10000)
        end
    end)
end

local skinnedHumans = {}
AddEventHandler("ev-inventory:itemUsed", function(item)
    if item == "huntingbait" then
        print("using huntingbait")
        if not isValidZone() then
            TriggerEvent("DoLongHudText", "You can't hunt here...", 2)
            return
        end
        if baitLastPlaced ~= 0 and GetGameTimer() < (baitLastPlaced + (60000 * math.random(4, 7))) then -- 4-7 minutes
            TriggerEvent("DoLongHudText", "Your nose can't take it yet...", 2)
            return
        end
        baitLocation = nil
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
        local finished = exports["ev-taskbar"]:taskBar(15000, "Placing Bait", false, true, false, false, nil, 5.0, PlayerPedId())
        ClearPedTasks(PlayerPedId())
        if finished ~= 100 then
            baitLocation = nil
            TriggerEvent("DoLongHudText", "Placement Cancelled", 2)
            return
        end
        TriggerEvent("evidence:dna","Animal-Bait")
        baitLastPlaced = GetGameTimer()
        baitLocation = GetEntityCoords(PlayerPedId())
        TriggerEvent("DoLongHudText", "Wew, pungenty...", 1)
        TriggerEvent("inventory:removeItem", item, 1)
        baitDown()
    end
    if item == "huntingknife" then
        print("using huntingknife")
        local isAnimal = GetPedType(targetedEntity) == 28
        local isHuman = GetPedType(targetedEntity) == 4 or GetPedType(targetedEntity) == 5
        if (not isAnimal and not isHuman) or not IsPedDeadOrDying(targetedEntity) then
            TriggerEvent("DoLongHudText", "No animal found", 2)
            return
        end
        print(MyHunt)
        print(targetedEntity)
        if (MyHunt ~= targetedEntity) then return TriggerEvent("DoLongHudText", "did i hunt that ?", 2) end
        local myAnimal = targetedEntity
        TaskTurnPedToFaceEntity(PlayerPedId(), myAnimal, -1)
        Citizen.Wait(1500)
        ClearPedTasksImmediately(PlayerPedId())
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
        local text = isAnimal and "Preparing Animal" or "Preparing"
        local finished = exports["ev-taskbar"]:taskBar(30000, text, false, true, false, false, nil, 5.0, targetedEntity)
        if finished ~= 100 then
            ClearPedTasksImmediately(PlayerPedId())
            TriggerEvent("DoLongHudText", "Preparing Cancelled", 2)
            return
        end

        if isHuman and not isAnimal then
            if skinnedHumans[targetedEntity] then
                return
            end

            skinnedHumans[targetedEntity] = true
            ClearPedTasks(PlayerPedId())
            ClearPedSecondaryTask(PlayerPedId())
            TriggerEvent("client:newStress", true, 150)
            TriggerEvent("evidence:dna","Human remains")
            TriggerEvent("Evidence:StateSet",28,1200)
            TriggerEvent("player:receiveItem", "questionablemeat", 1)
            if math.random() < 0.2 then
              TriggerServerEvent('loot:useItem', "deadhuman")
            end
            return
        end

        -- this is a model to leave it up the 
        local animalName = GetAnimalName(myAnimal)
        TriggerEvent("Evidence:StateSet", 28, 1200)
        TriggerEvent("evidence:dna", animalName)
        ClearPedTasks(PlayerPedId())
        ClearPedSecondaryTask(PlayerPedId())
        local mySpawn = DecorExistOn(myAnimal, "HuntingMySpawn") and DecorGetBool(myAnimal, "HuntingMySpawn")
        local illegalSpawn = DecorExistOn(myAnimal, "HuntingIllegal") and DecorGetBool(myAnimal, "HuntingIllegal")
        RPC.execute("ev-hunting:getSkinnedItem", NetworkGetNetworkIdFromEntity(myAnimal), mySpawn, illegalSpawn, animalName, buffStartTime ~= 0)
        TriggerEvent("client:newStress", true, 150)
        MyHunt = 0
    end
end)

function GetAnimalName(myAnimal)
    local animalHash = GetEntityModel(myAnimal)
    local animalDNA = "Unknown-Animal"
    for i,v in ipairs(animalList) do
        if v.hash == animalHash then
            animalDNA = v.name
        end
    end
    return animalDNA
end