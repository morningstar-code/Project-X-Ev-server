--[[ -- Dumpster Diving --

local dumpsterItems = {
    [1] = {chance = 2, id = 'sandwich', quantity = math.random(1,2)},
    [2] = {chance = 2, id = 'water', quantity = math.random(1,2)},
    [3] = {chance = 7, id = 'lockpick', quantity = math.random(1,1)},
    [4] = {chance = 5, id = 'plastic', quantity = math.random(2,9)},
    [5] = {chance = 5, id = 'aluminium', quantity = math.random(5,10)},
    [6] = {chance = 5, id = 'steel', quantity = math.random(6,8)},
    [7] = {chance = 5, id = 'rubber', quantity = math.random(2,7)},
    [8] = {chance = 5, id = 'scrapmetal', quantity = math.random(2,7)},
    [9] = {chance = 3, id = 'bandage', quantity = math.random(1,4)},
    [10] = {chance = 2, id = 'cigarette', quantity = math.random(1,5)},
    [11] = {chance = 4, id = 'rollingpaper', quantity = math.random(1,5)},
    [12] = {chance = 7, id = '1gcrack', quantity = math.random(2,4)},
    [13] = {chance = 6, id = 'maleseed', quantity = math.random(1,2)},
    [14] = {chance = 6, id = 'femaleseed', quantity = math.random(1,2)},
    [15] = {chance = 9, id = 'bandage', quantity = math.random(1,2)},
    [16] = {chance = 60, id = 'bodybag', quantity = 1},
    [17] = {chance = 30, id = 'bodygarbagebag', quantity = 1},
    [18] = {chance = 30, id = 'humanhead', quantity = 1},
    [19] = {chance = 40, id = 'humantorso', quantity = 1},
    [20] = {chance = 20, id = 'humanarm', quantity = 1},
    [21] = {chance = 15, id = 'humanhand', quantity = 1},
    [22] = {chance = 20, id = 'humanleg', quantity = 1},
    [23] = {chance = 15, id = 'humanfinger', quantity = 1},
    [24] = {chance = 15, id = 'humanear', quantity = 1},
    [25] = {chance = 17, id = 'humanbones', quantity = 1},
    [26] = {chance = 30, id = 'humanheart', quantity = 1},
    [27] = {chance = 21, id = 'humaneye', quantity = 1},
    [28] = {chance = 40, id = 'humankidney', quantity = 1},
    [29] = {chance = 50, id = 'humanlungs', quantity = 1},
    [30] = {chance = 14, id = 'humannail', quantity = 1},
    [31] = {chance = 20, id = 'humanpancreas', quantity = 1},
    [32] = {chance = 17, id = 'humantongue', quantity = 1},
    [33] = {chance = 16, id = 'humantooth', quantity = 1},
    [34] = {chance = 14, id = 'godbook', quantity = 1},
    [35] = {chance = 10, id = 'humannail', quantity = 1},
    [36] = {chance = 19, id = 'stoleniphone', quantity = math.random(1,2)},
    [37] = {chance = 8, id = 'stolennokia', quantity = math.random(2,3)},
    [38] = {chance = 8, id = 'stolen5ctchain', quantity = math.random(1,2)},
    [39] = {chance = 8, id = 'stolencasiowatch', quantity = math.random(2,5)},
    [40] = {chance = 33, id = 'zebra', quantity = 1},
    [41] = {chance = 10, id = 'cigar', quantity = 1},
}

RegisterServerEvent('ev:startDumpsterTimer')
AddEventHandler('ev:startDumpsterTimer', function(dumpster)
    startTimer(source, dumpster)
end)

RegisterServerEvent('ev:giveDumpsterReward')
AddEventHandler('ev:giveDumpsterReward', function()
    local source = tonumber(source)
    local item = {}
    local user = exports["ev-base"]:getModule("Player"):GetUser(source)
    local gotID = {}

    item = dumpsterItems[math.random(1, #dumpsterItems)]
    if math.random(1, 75) >= item.chance then
        if tonumber(item.id) == 0 and not gotID[item.id] then
            gotID[item.id] = true
            user:addMoney(item.quantity)
            TriggerClientEvent('DoLongHudText',  source, 'You found $'..item.quantity , 1)
        elseif not gotID[item.id] then
            gotID[item.id] = true
            TriggerClientEvent('player:receiveItem', source, item.id, item.quantity)
            TriggerClientEvent('DoLongHudText', source, 'You found '..item.id, 1)
        end
    else
        TriggerClientEvent('DoLongHudText', source, 'You found nothing!', 2)
    end
end)

function startTimer(id, object)
    local timer = 10 * 60000
    while timer > 0 do
        Wait(1000)
        timer = timer - 1000
        if timer == 0 then
            TriggerClientEvent('ev:removeDumpster', id, object)
        end
    end
end ]]