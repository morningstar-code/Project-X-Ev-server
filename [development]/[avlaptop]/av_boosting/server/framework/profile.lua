RegisterServerEvent('av_boosting:myProfile', function(data)
    local src = source
    local newUsername = false
    local newPhoto = false
    local username = data[1]
    local photo = data[2]
    local identifier = exports['av_laptop']:getIdentifier(src)
    local exists = MySQL.query.await('SELECT * FROM av_boosting WHERE identifier = ?', {identifier})
    if exists and exists[1] then
        print("First")
        local newPic = photo
        local newName = username
        if string.len(newPic) <= 0 then
            newPic = exists[1]['photo']
        end
        if string.len(newName) > Config.MaxUsernameCharacters then
            TriggerClientEvent('av_laptop:notification',src,Lang['app_title'],Lang['too_long'],"error")
            return
        end
        if string.len(newName) <= 0 then
            newName = exists[1]['name']
        end
        MySQL.update.await('UPDATE av_boosting SET name = ?, photo = ? WHERE identifier = ?', {newName, newPic, identifier})
        TriggerClientEvent('av_laptop:notification',src,Lang['app_title'],Lang['profile_updated'],"success")
    else
        print("second")
        local newPic = photo
        local newName = username
        if string.len(newPic) <= 0 then
            newPic = Config.DefaultPicture
        end
        if string.len(newName) <= 0 then
            newName = "User-"..math.random(11,9999)
        end
        if string.len(username) > Config.MaxUsernameCharacters then
            TriggerClientEvent('av_laptop:notification',src,Lang['app_title'],Lang['too_long'],"error")
            return
        end
        MySQL.insert.await('INSERT INTO av_boosting (identifier, name, photo, level, hacks, deliveries, time) VALUES (?, ?, ?, ?, ?, ?, ?)', {identifier, newName, newPic, 0, 0, 0, 9999990000})
        TriggerClientEvent('av_laptop:notification',src,Lang['app_title'],Lang['profile_updated'],"success")
    end
end)