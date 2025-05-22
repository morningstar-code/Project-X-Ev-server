RegisterNetEvent("ev:flags:get")
AddEventHandler("ev:flags:get", function(callID, netID, entityType, flagType)
    local flags, entity = 0

    if entityType == "player" then
        entity = GetPlayerPed(GetPlayerFromServerId(netID))
    else
        entity = NetworkGetEntityFromNetworkId(netID)
    end

    if DoesEntityExist(entity) then
        flags = DecorGetInt(entity, flagType)
    end

    TriggerServerEvent("ev:flags:set", callID, netID, flagType, flags)
end)

RegisterNetEvent("ev:flags:set")
AddEventHandler("ev:flags:set", function(netID, entityType, flagType, flags)
    local entity = nil

    if entityType == "player" then
        entity = GetPlayerPed(GetPlayerFromServerId(netID))
    else
        entity = NetworkGetEntityFromNetworkId(netID)
    end

    if DoesEntityExist(entity) then
        DecorSetInt(entity, flagType, flags)
    end
end)

function NotifyChange(pType, pEntity, pFlag, pState)
    local event = ('ev:flags:%s:stateChanged'):format(pType)

    TriggerEvent(event, pEntity, pFlag, pState)
    local isNet = NetworkGetEntityIsNetworked(pEntity)
    if isNet then
        local netId = NetworkGetNetworkIdFromEntity(pEntity)
        -- fml... Maybe we should move player flags to its own category?
        if pType == 'ped' and IsPedAPlayer(pEntity) then
            netId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(pEntity))
        end
        TriggerServerEvent(event, netId, pFlag, pState)
    end
end
