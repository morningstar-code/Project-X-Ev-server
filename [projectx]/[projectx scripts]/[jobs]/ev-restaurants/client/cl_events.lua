
AddEventHandler('ev-restaurants:getTakeoutItem', function(pParameters, pEntity, pContext)
    local data = pContext.zones['restaurant_takeout']
    if data.id == 'snr_1' then
        local BENTO_BOXES = {
            'pnp_bento_1.png',
            'pnp_bento_2.png',
            'pnp_bento_3.png',
            'pnp_bento_4.png',
            'pnp_bento_5.png',
            'pnp_bento_6.png',
        }
        data.image = 'icons/' .. BENTO_BOXES[math.random(#BENTO_BOXES)]
    end
    RPC.execute('ev-restaurants:getTakeoutBox', pContext.zones['restaurant_takeout'])
end)

AddEventHandler('ev-restaurants:openFridge', function(pParams, pEntity, pContext)
    local id = pParams.isEditorPeek and exports["ev-housing"]:getCurrentPropertyID() or pContext.zones['restaurant_fridge'].id
    TriggerEvent("server-inventory-open", "1", "burgerjob_fridge-" .. SERVER_CODE .. ":" .. id)
end)

local containerItems = {
    ['burgershotbag'] = true,
    ['murdermeal'] = true,
    ['wrappedgift'] = true,
    ['casinobag'] = true,
    ['bentobox'] = true,
    ['pizzabox'] = true,
    ['roostertakeout'] = true,
    ['cockbox'] = true,
    ['heistduffelbag'] = true,
    ['lostcut2'] = true,
    ['vineyardwinebox'] = true,
    ['custombagitem'] = true,
}

local toyItems = {
    ['randomtoy'] = true,
    ['randomtoy2'] = true,
    ['randomtoy3'] = true,
    ['cockegg'] = true,
    ['uwutoy'] = true,
}
AddEventHandler("ev-inventory:itemUsed", function(item, info)
    if containerItems[item] then
        local data = json.decode(info)
        TriggerEvent("InteractSound_CL:PlayOnOne","unwrap",0.1)
        TriggerEvent("inventory-open-container", data.inventoryId, data.slots, data.weight)
        return
    end
    if toyItems[item] then
        local finished = exports["ev-taskbar"]:taskBar(1000, "Opening")
        if finished == 100 then
            TriggerServerEvent('loot:useItem', item) 
            TriggerEvent("inventory:removeItem", item, 1)
        end
        return
    end
end)

AddEventHandler('ev-restaurants:shelfPrompt', function(pParams, pEntity, pContext)
    local id = pParams.isEditorPeek and exports["ev-housing"]:getCurrentPropertyID() or pContext.zones['restaurant_shelf'].id
    TriggerEvent("server-inventory-open", "1", "restaurants_shelf-" .. id)
end)

local generatedToys = {}

local function logToyGeneration(pRestaurant, pAmount)
    local pId = tostring(GetPlayerServerId(PlayerId()))

    if not generatedToys[pRestaurant] then generatedToys[pRestaurant] = {} end
    if not generatedToys[pRestaurant][pId] then generatedToys[pRestaurant][pId] = { amount = 0, lastReportedAmount = 0 } end

    if generatedToys[pRestaurant][pId].amount then
        generatedToys[pRestaurant][pId].amount = generatedToys[pRestaurant][pId].amount + pAmount
        local newlyMadeToys = generatedToys[pRestaurant][pId].amount - generatedToys[pRestaurant][pId].lastReportedAmount
        if newlyMadeToys >= 10 then
            TriggerServerEvent("ev-restaurants:reportToysMade", pRestaurant, newlyMadeToys, generatedToys[pRestaurant][pId].amount)
            generatedToys[pRestaurant][pId].lastReportedAmount = generatedToys[pRestaurant][pId].amount
        end
    end
end

AddEventHandler('ev-restaurants:getToyItem', function(pParameters, pEntity, pContext)
    local data = pContext.zones['restaurant_takeout']

    if not data.toy then
        return
    end

    local prompt = exports['ev-ui']:OpenInputMenu({
        {
            label = 'Enter Amount',
            name = 'amount',
            icon = 'pencil-alt',
            maxLength = 2,
        }
    }, function(values)
        return tonumber(values.amount) and values.amount:len() > 0 and values.amount:len() < 99
    end)

    if not prompt then
        return
    end

    local amount = tonumber(prompt.amount)
    logToyGeneration(data.restaurant, amount)
    TriggerEvent('player:receiveItem', data.toy, amount, false)
end)

AddEventHandler('ev-restaurants:viewSafeCash', function(pParameters, pEntity, pContext)
    local business

    if pParameters and pParameters.isEditorPeek then
        business = exports["ev-housing"]:getCurrentPropertyID()
    else
        business = pContext.meta.metaData.business
    end

    local context = RPC.execute('ev-restaurants:getSafeCash', business)
    if not context then
        return
    end
    exports['ev-ui']:showContextMenu(context)
end)

AddEventHandler('ev-restaurants:takeSafeCash', function(pParameters, pEntity, pContext)
    local business
    local isNotRestaurant = false
    if pParameters and pParameters.isEditorPeek then
        business = exports["ev-housing"]:getCurrentPropertyID()
        isNotRestaurant = true
    else
        business = pContext.meta.metaData.business
    end
    RPC.execute('ev-restaurants:takeSafeCash', business, isNotRestaurant)
end)

AddEventHandler('ev-restaurants:tradeInCash',  function(pParameters, pEntity, pContext)
    local item = exports['ev-inventory']:getItemsOfType('envelope', 1, true, {
        cashEnvelope = true,
    })[1]
    if not item then
        return
    end
    local info = json.decode(item.information)
    RPC.execute('ev-restaurants:depositCash', info)
end)

AddEventHandler('ev-restaurants:crackSafe', function(pParameters, pEntity, pContext)
    local business
    local isNotRestaurant = false
    if pParameters and pParameters.isEditorPeek then
        business = exports["ev-housing"]:getCurrentPropertyID()
        isNotRestaurant = true
    else
        business = pContext.meta.metaData.business
    end

    local animDict = "mini@safe_cracking"
    local anim = "dial_turn_clock_slow"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
      Citizen.Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), animDict, anim, 8.0, 1.0, -1, 1, -1, false, false, false)
    local finished = exports['ev-taskbar']:taskBar(30000, "Cracking", false, true, false, false, nil, 5.0, PlayerPedId())
    ClearPedTasks(PlayerPedId())
    if finished == 100 then
        RPC.execute('ev-restaurants:crackSafe', business)
    end
end)

AddEventHandler('ev-restaurants:setWorkHours', function(pParameters, pEntity, pContext)
    local biz = pContext.zones['restaurant_sign_on'].biz

    local times = {}
    for i=0,24 do
        local label = ''
        if i < 10 then
            label = '0' .. i .. ':00'
        else
            label = i .. ':00'
        end

        times[#times+1] = {
            id = i,
            name = label,
        }
    end

    local prompt = exports['ev-ui']:OpenInputMenu({
        {
            label = 'Opening Time',
            name = 'open',
            icon = 'clock',
            _type = 'select',
            options = times,
        },
        {
            label = 'Closing Time',
            name = 'close',
            icon = 'clock',
            _type = 'select',
            options = times,
        },
    }, function(values)
        return values.open and values.close and values.open < values.close
    end)

    if not prompt then
        return
    end

    RPC.execute('ev-restaurants:setWorkHours', biz, prompt.open, prompt.close)
end)

AddEventHandler('ev-restaurants:viewWorkHours', function(pParameters, pEntity, pContext)
    local biz = pContext.zones['restaurant_sign_on'].biz
    local context = RPC.execute('ev-restaurants:getWorkHours', biz)
    exports['ev-ui']:showContextMenu(context)
end)
