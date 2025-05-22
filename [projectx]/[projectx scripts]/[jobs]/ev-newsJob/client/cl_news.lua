DecorRegister("NEWS_LIGHT", 2)
CurrentMode = nil

IsRecording = false
CurrentOverlay = false
IsEmployed = false
CurrentOverlayText = ""

CurrentRecording = {}
CurrentCamera = {}

local ActiveLights = {}

local windDirections = {
    { short = "N", long =  "North" },
    { short = "NE", long = "Northeast" },
    { short = "E", long = "East" },
    { short = "SE", long = "Southeast" },
    { short = "S", long = "South" },
    { short = "SW", long = "Southwest" },
    { short = "W", long = "West" },
    { short = "NW", long = "Northwest" }
}

Citizen.CreateThread(function()
    exports["ev-interact"]:AddPeekEntryByModel({`prop_tv_cam_02`, `p_tv_cam_02_s`}, {{
            event = "ev-newsjob:useStudioCamera",
            id = "np_news_studio_camera",
            icon = "fas fa-video",
            label = "Operate",
            parameters = {},
        }}, {
            distance = { radius = 2.0 },
            isEnabled = function(pEntity)
                local myjob = exports["isPed"]:isPed("myjob")
                if myjob == "news" then
                    return true
                end
                return false
            end,
    })

    exports["ev-interact"]:AddPeekEntryByModel({`prop_studio_light_02`}, {{
        event = "ev-newsjob:pickupLight",
        id = "np_news_pickup_light",
        icon = "fas fa-lightbulb",
        label = "Pick Up",
        parameters = {},
    }}, {
        distance = { radius = 5.0 },
        isEnabled = function(pEntity)
            return NetworkGetEntityIsNetworked(pEntity)
        end,
    })

    exports['ev-interact']:AddPeekEntryByPolyTarget('ev-newsjob:equipment', {{
        event = "ev-newsjob:equipmentStore",
        id = "news_job_equipment_store",
        icon = "fas fa-newspaper",
        label = "Equipment"
    }}, { distance = { radius = 3.0 } })

    exports['ev-interact']:AddPeekEntryByPolyTarget('ev-newsjob:controlboard', {{
        event = "ev-newsjob:ingestFootage",
        id = "news_job_footage_upload",
        icon = "fas fa-upload",
        label = "Ingest Footage"
    }}, { distance = { radius = 3.0 } })

    exports['ev-interact']:AddPeekEntryByPolyTarget('ev-newsjob:sequencer', {{
        event = "ev-newsjob:duplicateFootage",
        id = "news_job_footage_duplicate",
        icon = "fas fa-copy",
        label = "Copy Footage"
    }}, { distance = { radius = 3.0 } })

    exports['ev-interact']:AddPeekEntryByPolyTarget('ev-newsjob:checkWeather', {{
        event = "ev-newsjob:checkWeather",
        id = "news_job_weather_check",
        icon = "fas fa-cloud-sun-rain",
        label = "Check Weather"
    }}, { distance = { radius = 3.0 } })

    exports['ev-interact']:AddPeekEntryByPolyTarget('ev-newsjob:openArchives', {{
        event = "ev-newsjob:openArchives",
        id = "news_job_archives",
        icon = "fas fa-atlas",
        label = "Open Archives"
    }}, { distance = { radius = 3.0 } })

    exports['ev-interact']:AddPeekEntryByPolyTarget('ev-newsjob:ceoChangeUrl', {{
        event = "ev-newsjob:playTape",
        id = "news_job_change_url",
        icon = "fas fa-circle",
        label = "Play Tape"
    }}, { distance = { radius = 3.0 } })

    exports['ev-interact']:AddPeekEntryByPolyTarget('ev-newsjob:ceoChangeUrl', {{
        event = "ev-newsjob:stopTape",
        id = "news_job_stop_url",
        icon = "fas fa-circle",
        label = "Stop Tape"
    }}, { distance = { radius = 3.0 } })

    local lights = RPC.execute("ev-newsjob:getLights")
    TriggerEvent("ev-newsjob:setLights", lights)
end)

AddEventHandler("ev-newsjob:checkWeather", function(pParameters, pEntity, pContext)
    local myjob = exports["isPed"]:isPed("myjob")
    if myjob ~= "news" then
        return TriggerEvent("DoLongHudText", "You must be signed in to check this")
    end

    local weatherData = RPC.execute("ev-weather:server:weather:getProgression")

    local animDict = 'anim@heists@prison_heiststation@cop_reactions'
    loadAnimDict(animDict)
    TaskPlayAnim(PlayerPedId(), animDict, 'cop_b_idle', 2.0, -2.0, -1, 1, 1.0, false, false, false)
    exports["ev-taskbar"]:taskBar(5000, "Reading Weather Data")
    showWeatherContext(weatherData)
    Wait(1000)
    ClearPedTasks(PlayerPedId())
end)

AddEventHandler("ev-newsjob:useStudioCamera", function(pArgs, pEntity)
    CurrentPeekCamera = pEntity
    activatePeekCamera()
end)

AddEventHandler("ev-newsjob:pickupLight", function(pArgs, pEntity)
    RPC.execute("ev-newsjob:removeLight", NetworkGetNetworkIdFromEntity(pEntity))
end)

AddEventHandler('ev-newsjob:equipmentStore', function(pParameters, pEntity, pContext)
    TriggerEvent("server-inventory-open", "42077", "Shop")
end)

AddEventHandler('ev-newsjob:duplicateFootage', function(pParameters, pEntity, pContext)
    local tapes = exports["ev-inventory"]:getItemsOfType("newstape", 10, true, { copy = 0, finalized = true })
    local context = {
        {
            title = "Select a tape to copy"
        }
    }
    for index,tape in ipairs(tapes) do
        local info = json.decode(tape.information)

        context[#context+1] = {
            title = ("%s - Duration: %ss"):format(info.id, info.duration),
            description = ("Date: %s"):format(info.dateString),
            action = "ev-newsjob:copyTape",
            key = tape
        }
    end
    exports['ev-ui']:showContextMenu(context)
end)

AddEventHandler('ev-newsjob:playTape', function(pParameters, pEntity, pContext)
    IsEmployed = exports["ev-business"]:IsEmployedAt("lsbn")
    if not IsEmployed then return end
    local tapes = exports["ev-inventory"]:getItemsOfType("newstape", 10, true, { finalized = true })
    local context = {
        {
            title = "Select a tape to play"
        }
    }
    for index,tape in ipairs(tapes) do
        local info = json.decode(tape.information)

        local children = {}
        for _,clip in ipairs(info.clips) do
            local url = (clip.type == "clip" and ("https://clips.twitch.tv/embed?clip=%s&autoplay=true&parent=twitch.tv"):format(clip.url)) or
            (clip.type == "vod" and ("https://player.twitch.tv/?video=%s&volume=0.5&parent=twitch.tv"):format(clip.url)) or
            (clip.type == "streamable" and ("https://streamable.com/o/%s?autoplay=1"):format(clip.url)) or
            (clip.type == "youtube" and ("https://www.youtube.com/embed/%s?autoplay=1"):format(clip.url)) or
            (clip.type == "imgur" and ("https://i.imgur.com/%s"):format(clip.url))
            children[#children+1] = {
                title = clip.title,
                description = url,
                action = "ev-newsjob:playClip",
                key = url
            }
        end
        context[#context+1] = {
            title = ("%s - Duration: %ss"):format(info.id, info.duration),
            description = ("Date: %s"):format(info.dateString),
            children = children
        }
    end
    exports['ev-ui']:showContextMenu(context)
end)

AddEventHandler('ev-newsjob:stopTape', function(pParameters, pEntity, pContext)
    RPC.execute("ev-newsjob:playClip", "https://i.imgur.com/P1698yo.png")
end)

AddEventHandler("ev-inventory:itemUsed", function(pItemId, pItemInfo, pInventoryName, pSlot)
    if pItemId == "newscamera" then
        local parsedInfo = json.decode(pItemInfo)
        local cameraId = parsedInfo.id
        local cameraIncrement = parsedInfo.camera_increment
        if not cameraIncrement then cameraIncrement = 0 end

        IsEmployed = exports["ev-business"]:IsEmployedAt("lsbn")

        clearTools()
        if CurrentMode == "camera" then
            CurrentMode = nil
            return
        end
        createCamera()
        useTool(CamAnimDict, CamAnimName, "camera")
        --Camera key listener
        Citizen.CreateThread(function()
            CurrentCamera = {
                id = cameraId,
                increment = cameraIncrement
            }
            while CurrentMode == "camera" do
                if IsDisabledControlJustReleased(0, 25) then
                    if CurrentlyUsingCamera then
                        if CurrentOverlay then
                            exports["ev-ui"]:sendAppEvent("newscam", { show = false })
                            exports["ev-ui"]:sendAppEvent("hud", { display = true })
                        end
                        CurrentlyUsingCamera = false
                    else
                        Citizen.CreateThread(activateHeldCamera)
                    end
                end
                Wait(0)
            end
            CurrentlyUsingCamera = false
        end)
    end

    if pItemId == "newsmic" then
        IsEmployed = exports["ev-business"]:IsEmployedAt("lsbn")
        clearTools()
        if CurrentMode == "mic" then
            CurrentMode = nil
            return
        end
        TriggerEvent("attachItem", IsEmployed and "tvmic02" or "tvmic01")
        useTool("move_weapon@pistol@copc", "idle", "mic")
    end

    if pItemId == "newsboom" then
        clearTools()
        if CurrentMode == "boom" then
            CurrentMode = nil
            return
        end
        TriggerEvent("attachItem","boomMIKE01")
        useTool("missfra1", "mcs2_crew_idle_m_boom", "boom")
    end

    if pItemId == "newstape" then
        local parsedInfo = json.decode(pItemInfo)
        if parsedInfo.finalized == nil then
            editTapeContext(parsedInfo)
        else
            openTapeContext(parsedInfo)
        end
    end

    if pItemId == "newslight" then
        local elements = {
            { name = "r", label = "Red (0-555)", icon = "paintbrush" },
            { name = "g", label = "Green (0-555)", icon = "paintbrush" },
            { name = "b", label = "Blue (0-555)", icon = "paintbrush" },
        }

        local prompt = exports['ev-ui']:OpenInputMenu(elements, function(values)
            if not values.r then values.r = 200 end
            if not values.g then values.g = 200 end
            if not values.b then values.b = 200 end
            local redValue = tonumber(values.r)
            local greenValue = tonumber(values.g)
            local blueValue = tonumber(values.b)
            local red = redValue and redValue >= 0 and redValue <= 555
            local green = greenValue and greenValue >= 0 and greenValue <= 555
            local blue = blueValue and blueValue >= 0 and blueValue <= 555
            return red and green and blue
        end)

        if not prompt then return end
        if not prompt.r then prompt.r = 200 end
        if not prompt.g then prompt.g = 200 end
        if not prompt.b then prompt.b = 200 end

        local pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.15, -0.5)
        local heading = GetEntityHeading(PlayerPedId())

        local success, message = RPC.execute("ev-newsjob:placeLight", pos, heading, prompt)

        if not success then return end

        local timeout = 10
        while not NetworkDoesEntityExistWithNetworkId(message.netId) and timeout > 0 do
            timeout = timeout - 1
            Wait(1000)
        end

        local ent = NetworkGetEntityFromNetworkId(message.netId)
        DecorSetBool(ent, "NEWS_LIGHT", 1)
        PlaceObjectOnGroundProperly(ent)
        TriggerEvent("inventory:removeItem", "newslight", 1)
    end
end)

RegisterUICallback('ev-newsjob:startRecording', function (data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    IsRecording = true

    exports["ev-ui"]:sendAppEvent("newscam", { recording = true })

    local playerPos = GetEntityCoords(PlayerPedId())
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, playerPos.x, playerPos.y, playerPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    street1 = street1:gsub("'", "")
    street2 = street2:gsub("'", "")
    if street2 ~= "" then street2 = "[" .. street2 .. "]" end
    local zone = GetNameOfZone(playerPos.x, playerPos.y, playerPos.z)
    local playerZoneName = GetLabelText(zone)
    CurrentRecording = {
        camera_id = data.key.id,
        camera_increment = data.key.increment,
        timestamp = GetCloudTimeAsInt(),
        coords = GetEntityCoords(PlayerPedId()),
        location = ("%s - %s %s"):format(playerZoneName, street1, street2)
    }
end)

RegisterUICallback('ev-newsjob:copyTape', function (data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    local cid = exports["isPed"]:isPed("cid")
    local info = json.decode(data.key.information)
    exports["ev-taskbar"]:taskBar(1500, "Creating Copy")
    info.copy = 1
    info._image_url = "icons/np_news_tape_copy.png"
    info.Duplicate = true
    TriggerEvent("player:receiveItem", "newstape", 1, false, {}, json.encode(info))
end)

RegisterUICallback('ev-newsjob:stopRecording', function (data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    saveRecording()
end)

RegisterUICallback('ev-newsjob:cancelRecording', function (data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    IsRecording = false
    exports["ev-ui"]:sendAppEvent("newscam", { recording = false })
end)

RegisterUICallback('ev-newsjob:viewClip', function (data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    --exports["ev-ui"]:openApplication("twitchplayer", { url = data.key.url, type = data.key.type })
end)

RegisterUICallback('ev-newsjob:playClip', function (data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    RPC.execute("ev-newsjob:playClip", data.key)
end)

RegisterUICallback('ev-newsjob:addClip', function (data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })

    Wait(1)

    local elements = {
        { name = "title", label = "Clip Title", icon = "heading" },
        { name = "url", label = "URL (twitch clip/vod, streamable, youtube, imgur)", icon = "camera" },
    }

    local prompt = exports['ev-ui']:OpenInputMenu(elements, function(values)
        if not values.title or not values.url then return false end

        if values.title:len() > 50 then
            TriggerEvent("DoLongHudText", "Title too long.")
            return false
        end

        if values.url:len() > 255 then
            TriggerEvent("DoLongHudText", "URL too long.")
            return false
        end

        local checkClip = values.url:match("clips%.twitch%.tv/(.*)$")
        local checkVod = values.url:match("twitch%.tv/videos/(%d*)?")
        local checkStreamable = values.url:match("streamable%.com/(.*)$")
        local checkYoutube = values.url:match("youtube%.com/watch%?v=(.*)$") or values.url:match("youtu%.be/(.*)$")
        local checkImgur = values.url:match("i%.imgur%.com/(.*)$")

        if not checkClip and not checkVod and not checkStreamable and not checkYoutube and not checkImgur then
            TriggerEvent("DoLongHudText", "Invalid URL")
            return false
        end

        return true
    end)
    if not prompt then return end

    local clipTag = prompt.url:match("clips%.twitch%.tv/(.*)$")
    local vodTag = prompt.url:match("twitch%.tv/videos/(.*)")
    local streamableTag = prompt.url:match("streamable%.com/(.*)$")
    local youtubeTag = prompt.url:match("youtube%.com/watch%?v=(.*)$") or prompt.url:match("youtu%.be/(.*)$")
    local imgurTag = prompt.url:match("i%.imgur%.com/(.*)$")

    if not clipTag and not vodTag and not streamableTag and not youtubeTag and not imgurTag then
        TriggerEvent("DoLongHudText", "not matched :( - " .. prompt.url)
        return
    end

    if vodTag then
        vodTag = vodTag:gsub("%?", "&")
    end

    local tapeId = data.key
    local tapes = exports["ev-inventory"]:getItemsOfType("newstape", 1, true, {id = tapeId})
    local cid = exports["isPed"]:isPed("cid")
    local info = json.decode(tapes[1].information)

    if not info.clips then info.clips = {} end

    info.clips[#info.clips+1] = {
        title = prompt.title,
        url = clipTag or vodTag or streamableTag or youtubeTag or imgurTag,
        type = (clipTag and "clip") or (vodTag and "vod") or (streamableTag and "streamable") or (youtubeTag and "youtube") or (imgurTag and "imgur")
    }

    TriggerServerEvent("server-update-item", cid, "newstape", tapes[1].slot, json.encode(info))
    Wait(1)
    editTapeContext(info)
end)

RegisterUICallback('ev-newsjob:removeClip', function (data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    local tapeId = data.key.tape
    local tapes = exports["ev-inventory"]:getItemsOfType("newstape", 1, true, {id = tapeId})
    local cid = exports["isPed"]:isPed("cid")
    local info = json.decode(tapes[1].information)

    for index,clip in ipairs(info.clips) do
        if clip.url == data.key.clip.url and clip.title == data.key.clip.title then
            table.remove(info.clips, index)
            break
        end
    end

    TriggerServerEvent("server-update-item", cid, "newstape", tapes[1].slot, json.encode(info))
    Wait(1)
    editTapeContext(info)
end)

RegisterUICallback('ev-newsjob:finalizeTape', function (data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    local tapeId = data.key

    local tapes = exports["ev-inventory"]:getItemsOfType("newstape", 1, true, {id = tapeId})
    local cid = exports["isPed"]:isPed("cid")
    local info = json.decode(tapes[1].information)

    if not info.finalized then
        info.finalized = true
        info._image_url = "icons/np_news_tape_final.png"
        info._hideKeys[#info._hideKeys+1] = "finalized"
    end

    TriggerServerEvent("server-update-item", cid, "newstape", tapes[1].slot, json.encode(info))
end)

RegisterUICallback('ev-newsjob:toggleOverlay', function (data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    toggleOverlay()
end)

RegisterUICallback('ev-newsjob:addTapeTitle', function (data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })

    Wait(1)

    local elements = {
        { name = "title", label = "Tape Title", icon = "heading" },
    }

    local prompt = exports['ev-ui']:OpenInputMenu(elements, function(values)
        if not values.title then return false end

        if values.title:len() > 50 then
            TriggerEvent("DoLongHudText", "Title too long.")
            return false
        end

        return true
    end)
    if not prompt then return end

    local tapeId = data.key
    local tapes = exports["ev-inventory"]:getItemsOfType("newstape", 1, true, {id = tapeId})
    local cid = exports["isPed"]:isPed("cid")
    local info = json.decode(tapes[1].information)

    info.title = prompt.title

    TriggerServerEvent("server-update-item", cid, "newstape", tapes[1].slot, json.encode(info))
    Wait(1)
    editTapeContext(info)
end)

RegisterUICallback('ev-newsjob:setOverlayText', function (data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    Wait(1)
    local elements = {
        { name = "overlayText", label = "Text", icon = "pencil-alt" },
    }

    local prompt = exports['ev-ui']:OpenInputMenu(elements, function(values)
        local textString = tostring(values.overlayText)
        if not textString then textString = '' end
        return textString:len() >= 0 and textString:len() < 255
    end)
    if not prompt then return end

    if not prompt.overlayText then prompt.overlayText = '' end

    CurrentOverlayText = prompt.overlayText
    if IsEmployed then
        exports["ev-ui"]:sendAppEvent("newscam", { text = CurrentOverlayText })
    end
end)

RegisterNetEvent('ev-newsjob:clearTools')
AddEventHandler('ev-newsjob:clearTools', function()
    clearTools()
    CurrentMode = nil
end)

RegisterNetEvent('ev-newsjob:setLights')
AddEventHandler('ev-newsjob:setLights', function(pLights)
    if #ActiveLights == 0 then
        local nearLights = false
        Citizen.CreateThread(function()
            while #ActiveLights > 0 do
                nearLights = false
                local playerPos = GetEntityCoords(PlayerPedId())
                for _, light in ipairs(ActiveLights) do
                    if #(playerPos - light.pos) < 90 then
                        nearLights = true
                        break
                    end
                end
                Wait(5000)
            end
        end)
        Citizen.CreateThread(function()
            while #ActiveLights > 0 do
                local playerPos = GetEntityCoords(PlayerPedId())
                for _,light in ipairs(ActiveLights) do
                    if #(playerPos - light.pos) < 90 then
                        local lightObject = NetworkGetEntityFromNetworkId(light.netId)
                        local spotlightHeading = GetEntityHeading(lightObject) + 85

                        if spotlightHeading < 0 then
                            spotlightHeading = 360.0 + spotlightHeading
                        end

                        local x,y = quickmafs(spotlightHeading)
                        local coords = GetOffsetFromEntityInWorldCoords(lightObject, 0.0, 1.0, 2.0)
                        DrawSpotLight(coords.x + 0.0, coords.y + 0.0, coords.z + 0.0, x + 0.0, y + 0.0, -0.0043, tonumber(light.rgb.r), tonumber(light.rgb.g), tonumber(light.rgb.b), 40.0, 20.0, 10.0, 35.0, 30.5)
                    end
                end
                Wait(0)
                if not nearLights then
                    Wait(5000)
                end
            end
        end)
    end
    ActiveLights = pLights
end)

RegisterNetEvent('ev-newsjob:removeLight')
AddEventHandler('ev-newsjob:removeLight', function(pLightIndex)
    table.remove(ActiveLights, pLightIndex)
end)

function openTapeContext(pItemInfo)
    local context = { 
        {
            title = ("Tape %s - Duration: %ds"):format(pItemInfo.id, pItemInfo.duration),
            description = ("%s"):format(pItemInfo.location)
        },
        {
            title = ("Date Recorded: %s"):format(pItemInfo.dateString)
        }
    }

    if pItemInfo.title then
        context[#context+1] = {
            title = ("%s"):format(pItemInfo.title)
        }
    end

    if pItemInfo.clips then
        for idx,clip in ipairs(pItemInfo.clips) do
            local url = (clip.type == "clip" and ("https://clips.twitch.tv/%s"):format(clip.url)) or
            (clip.type == "vod" and ("https://player.twitch.tv/?video=%s&volume=0.5&parent=twitch.tv"):format(clip.url)) or
            (clip.type == "streamable" and ("https://streamable.com/%s"):format(clip.url)) or
            (clip.type == "youtube" and ("https://youtu.be/%s"):format(clip.url)) or
            (clip.type == "imgur" and ("https://i.imgur.com/%s"):format(clip.url))
            context[#context+1] = {
                title = url,
                description = clip.title,
                --action = "ev-newsjob:viewClip",
                key = clip
            }
        end
    end

    exports['ev-ui']:showContextMenu(context)
end

function editTapeContext(pItemInfo)
    local context = {
        {
            title = ("Tape %s - Duration: %ds"):format(pItemInfo.id, pItemInfo.duration),
            description = ("%s"):format(pItemInfo.location)
        },
        {
            title = ("Date Recorded: %s"):format(pItemInfo.dateString)
        },
        {
            title = "Finalize Tape",
            description = "You will not be able to make changes",
            children = {{
                title = "Yes",
                action = "ev-newsjob:finalizeTape",
                key = pItemInfo.id
            }}
        },
        {
            title = "Edit Title",
            description = pItemInfo.title and "Current Title: " .. pItemInfo.title or "",
            action = "ev-newsjob:addTapeTitle",
            key = pItemInfo.id
        }
    }

    if pItemInfo.clips then
        for idx,clip in ipairs(pItemInfo.clips) do
            local url = (clip.type == "clip" and ("https://clips.twitch.tv/%s"):format(clip.url)) or
            (clip.type == "vod" and ("https://player.twitch.tv/?video=%s&volume=0.5&parent=twitch.tv"):format(clip.url)) or
            (clip.type == "streamable" and ("https://streamable.com/%s"):format(clip.url)) or
            (clip.type == "youtube" and ("https://youtu.be/%s"):format(clip.url)) or
            (clip.type == "imgur" and ("https://i.imgur.com/%s"):format(clip.url))
            context[#context+1] = {
                title = url,
                description = clip.title,
                children = {{
                    title = "Remove",
                    action = "ev-newsjob:removeClip",
                    key = { tape = pItemInfo.id, clip = clip }
                }}
            }
        end
    end

    context[#context+1] = {
        title = "Add Clip",
        description = "Add a clip or VOD to this footage.",
        action = "ev-newsjob:addClip",
        key = pItemInfo.id
    }

    exports['ev-ui']:showContextMenu(context)
end

function useTool(pAnimDict, pAnimName, pMode)
    CurrentMode = pMode
    Citizen.CreateThread(function()
        while not HasAnimDictLoaded(pAnimDict) do
            RequestAnimDict(pAnimDict)
            Citizen.Wait(0)
        end
        while CurrentMode == pMode do
            if not IsEntityPlayingAnim(PlayerPedId(), pAnimDict, pAnimName, 3) then
                TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
                TaskPlayAnim(GetPlayerPed(PlayerId()), pAnimDict, pAnimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
            end

            DisablePlayerFiring(PlayerId(), true)
            DisableControlAction(0, 25, true) -- disable aim
            DisableControlAction(0, 44, true) -- INPUT_COVER
            DisableControlAction(0, 37, true) -- INPUT_SELECT_WEAPON
            TriggerEvent("actionbar:setEmptyHanded", true)

            Wait(0)
        end

        if pMode == "camera" and IsRecording then
            saveRecording()
        end
    end)
end

function saveRecording()
    IsRecording = false

    exports["ev-ui"]:sendAppEvent("newscam", { recording = false })

    --Update camera footage count
    local cameras = exports["ev-inventory"]:getItemsOfType("newscamera", 1, true, {id = CurrentRecording.camera_id})
    local cid = exports["isPed"]:isPed("cid")
    local info = json.decode(cameras[1].information)
    if not info.camera_increment then
        info.camera_increment = 0
        info._hideKeys = {"camera_increment"}
    end
    info.camera_increment = tonumber(info.camera_increment) + 1
    CurrentCamera.increment = info.camera_increment
    TriggerServerEvent("server-update-item", cid, "newscamera", cameras[1].slot, json.encode(info))

    CurrentRecording._hideKeys = {"coords", "camera_id", "camera_increment", "timestamp", "duration", "_image_url", "clips", "ingested", "copy"}
    CurrentRecording.duration = GetCloudTimeAsInt() - CurrentRecording.timestamp
    CurrentRecording.id = CurrentRecording.camera_id .. "-" .. CurrentRecording.camera_increment
    CurrentRecording._image_url = "icons/np_news_tape.png"

    local year, month, day, hour, minute, second = GetPosixTime()
    CurrentRecording.dateString = ("%d/%d/%d %02d:%02d:%02d UTC"):format(month, day, year, hour - 1, minute, second)
    CurrentRecording.ingested = 0
    CurrentRecording.copy = 0
    TriggerEvent("player:receiveItem", "newstape", 1, false, {}, json.encode(CurrentRecording))
end

function clearTools()
    TriggerEvent("disabledWeapons",false)
    ClearPedTasks(PlayerPedId())
    TriggerEvent("destroyProp")
    removeCamera()
end

function showWeatherContext(pWeatherData)
    local context = {}
    for index,weather in pairs(pWeatherData) do
        local randomFactor = ((100 - weather.temperature) * 10) + (index * 2)
        context[#context+1] = {
            title = ("%s %s "):format(weather.name, convertTime(weather.expectedAt + randomFactor)),
            description = ("%sF - %.2fmph %s %s "):format(math.floor(weather.temperature + (randomFactor / 50)), weather.windSpeed * 2.236936, windDirections[math.ceil(weather.windDir)].long,
                weather.rainLevel > 0 and "with PoP at " .. weather.rainLevel .. "%" or ""),
            disabled = index == 1
        }
    end
    exports['ev-ui']:showContextMenu(context)
end

function toggleOverlay()
    CurrentOverlay = not CurrentOverlay
    if IsEmployed and CurrentlyUsingCamera then
        exports["ev-ui"]:sendAppEvent("newscam", { show = CurrentOverlay })
        exports["ev-ui"]:sendAppEvent("hud", { display = not CurrentOverlay })
    end
end

exports("CurrentOverlay", function()
    return {
        enabled = CurrentOverlay,
        text = CurrentOverlayText
    }
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function convertTime(expected)
    local difference = expected - GetCloudTimeAsInt()
    if difference < 0 then
        local absolute = math.abs(difference)
        local hours = math.floor(absolute / 3600)
        local minutes = math.floor((absolute - (hours * 3600)) / 60)
        if (difference < -3600) then
            return ('observed %d hour(s) and %d minutes ago'):format(hours, minutes)
        end
        return ('observed %d minutes ago'):format(minutes)
    end
    if difference == 0 then
        return 'expected now'
    end
    local hours = math.floor(difference / 3600)
    local minutes = math.floor((difference - (hours * 3600)) / 60)
    if difference > 3600 then
        return ('expected in %d hour(s) and %d minutes'):format(hours, minutes)
    end
    return ('expected in %d minutes'):format(minutes)
end

function quickmafs(dir)
    local x = 0.0
    local y = 0.0
    local dir = dir
    if dir >= 0.0 and dir <= 90.0 then
        local factor = (dir/9.2) / 10
        x = -1.0 + factor
        y = 0.0 - factor
    end
    if dir > 90.0 and dir <= 180.0 then
        dirp = dir - 90.0
        local factor = (dirp/9.2) / 10
        x = 0.0 + factor
        y = -1.0 + factor
    end
    if dir > 180.0 and dir <= 270.0 then
        dirp = dir - 180.0
        local factor = (dirp/9.2) / 10
        x = 1.0 - factor
        y = 0.0 + factor
    end
    if dir > 270.0 and dir <= 360.0 then
        dirp = dir - 270.0
        local factor = (dirp/9.2) / 10
        x = 0.0 - factor
        y = 1.0 - factor
    end
    return x,y
end

local CurrentClipUrl = "https://i.imgur.com/P1698yo.png"
local InCeoRoom = false

AddEventHandler("ev-polyzone:enter", function(zone)
    if zone == "ev-newsjob:ceoRoom" then
      if not dui then
        dui = exports["ev-lib"]:getDui(CurrentClipUrl, 2048, 1024)
        AddReplaceTexture('vw_prop_vw_cinema_tv_01', 'script_rt_tvscreen', dui.dictionary, dui.texture)
      else
        exports["ev-lib"]:changeDuiUrl(dui.id, CurrentClipUrl)
      end
      InCeoRoom = true
    end
end)

AddEventHandler("ev-polyzone:exit", function(zone)
    if zone == "ev-newsjob:ceoRoom" then
      RemoveReplaceTexture('vw_prop_vw_cinema_tv_01', 'script_rt_tvscreen')
      if dui ~= nil then
        exports["ev-lib"]:releaseDui(dui.id)
        dui = nil
      end
      InCeoRoom = false
    end
end)

RegisterNetEvent("ev-newsjob:playClipUrl")
AddEventHandler("ev-newsjob:playClipUrl", function(pUrl)
    CurrentClipUrl = pUrl
    if InCeoRoom and dui then
        exports["ev-lib"]:changeDuiUrl(dui.id, CurrentClipUrl)
    end
end)


AddEventHandler('ev-newsjob:playMovie', function(pParameters, pEntity, pContext)
    IsEmployed = exports['ev-business']:IsEmployedAt('lsbn') or exports['ev-business']:IsEmployedAt('statecontracting') or exports['ev-business']:IsEmployedAt('smol_dick_realtors')
        if not IsEmployed then
            TriggerEvent("DoLongHudText", "Speak to a LSBN employee.")
        return
     end
    local prompt = exports['ev-ui']:OpenInputMenu({{
        label = 'URL',
        name = 'url',
        icon = 'link',
    }}, function(values) return values and values.url end)
    if not prompt then return end
    local url = prompt.url
    RPC.execute("ev-newsjob:playMovie", url)
end)

AddEventHandler('ev-newsjob:stopMovie', function(pParameters, pEntity, pContext)
    IsEmployed = exports['ev-business']:IsEmployedAt('lsbn') or exports['ev-business']:IsEmployedAt('statecontracting') or exports['ev-business']:IsEmployedAt('smol_dick_realtors')
        if not IsEmployed then
            TriggerEvent("DoLongHudText", "Speak to a LSBN employee.")
        return
     end
    RPC.execute("ev-newsjob:playMovie", "https://i.imgur.com/P1698yo.png")
end)
