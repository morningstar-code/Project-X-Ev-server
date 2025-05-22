function locationInit(location)
    local locationConfig = getConfigFor(location)

    if not locationConfig then
        print("^1[ERROR][locationInit] No config for location: " .. tostring(location) .. "^7")
        return {}, false
    end

    if not locationConfig.carSpawns or type(locationConfig.carSpawns) ~= "table" then
        print("^1[ERROR][locationInit] carSpawns missing or not a table for location: " .. tostring(location) .. "^7")
        return {}, false
    end

    return locationConfig.carSpawns, locationConfig.testDriveSpawnPoint
end
