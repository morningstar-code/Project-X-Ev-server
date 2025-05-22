local AccessCache = {}

AddEventHandler('ev:vehicles:hasBusinessGarageAccess', function(pGarageId, cb)
    local timer = GetGameTimer()

    if AccessCache[pGarageId] and timer - AccessCache[pGarageId]['timer'] < 5000 then
        return cb(AccessCache[pGarageId]['allowed'])
    end

    local success = RPC.execute("ev-business:hasGarageAccess", pGarageId)

    AccessCache[pGarageId] = { allowed = success, timer = timer }

    return cb(success)
end)