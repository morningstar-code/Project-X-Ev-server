

--[[
    Functions below: Ped spawning / clothing attachment 
    Description: function spawns and skins the peds acourding to the players chars , this is also where the start of the train spawn takes place 
    along with fetching players char data from DB , clothing data is done before this function.
    This also determains the model for the spawning peds be it the one based on char clothing or a empty ped slot
]]


function Login.CreatePlayerCharacterPeds(characterModelData,isReset)
    if Login.actionsBlocked and not isReset then return end
    Login.actionsBlocked = true
    if not isReset then
        Wait(1000)
        Login.LoadFinished = false
        Login.ClearSpawnedPeds()
        CleanUpArea()
        Wait(1000)
        CleanUpArea()

        while Login.isTrainMoving do
            Wait(10)
        end

        while Login.HasTransistionFinished do
            Wait(10)
        end


    end


    Login.CurrentClothing = characterModelData

    RequestModel(`np_m_character_select`)
    local events = exports["ev-base"]:getModule("Events")
    events:Trigger("ev-base:fetchPlayerCharacters", nil, function(data)
        if data.err then
            return
        end
       
        if isReset then
            Login.ClearSpawnedPeds()
        end
        Login.CreatedPeds = {} 
        local PlusOneEmpty = false
		
        local noCharacters = true
		local chars = getCharLimit()
		
        for _=1, chars do
        --for _=1,#Login.spawnLoc do -- Old Method
            local isCustom = false
            local character = nil
            local cid = 0


            local cModelHash = GetHashKey("np_m_character_select")
            if data[_] ~= nil then 
                character = data[_]

                local gender = `mp_male`

                if character.gender == 1 then
                    cModelHash = GetHashKey("mp_f_freemode_01")
                    gender = `mp_female`
                else
                    cModelHash = GetHashKey("mp_m_freemode_01")
                    
                end
                
                cid = character.id

                if characterModelData[cid] ~= nil then cModelHash = tonumber(characterModelData[cid].model) end
				noCharacters = false
            else
                if math.random(2) == 1 then
                    cModelHash = GetHashKey("np_f_character_select")
                end
            end

            -- for i,v in ipairs(Login.custompeds) do
            --     if cModelHash == GetHashKey(v) then
            --         cModelHash = GetHashKey("np_m_character_select")
            --         isCustom = true
            --     end
            -- end
            
            if character == nil and not PlusOneEmpty then
                PlusOneEmpty = _
            end

            local function CreatePedPCall(pHash, pX, pY, pZ)
                local ped = CreatePed(3, pHash, pX, pY, pZ, 0.72, false, false)
                return ped
            end

            Login.RequestModel(cModelHash, function(loaded, model, modelHash)
                if loaded then

                    local newPed = nil 
                    
                    if character ~= nil then
                        local success, rData = pcall(CreatePedPCall, modelHash, Login.spawnLoc[_].x, Login.spawnLoc[_].y, Login.spawnLoc[_].z)
                        if success then
                            newPed = rData
                        else
                            newPed = CreatePed(3, `np_m_character_select`, Login.spawnLoc[_].x, Login.spawnLoc[_].y, Login.spawnLoc[_].z, 0.72, false, false)
                            print("MODEL FAILED TO LOAD IN SPAWN: " .. modelHash)
                        end
                    else
                        if PlusOneEmpty == _ then
                            local success, rData = pcall(CreatePedPCall, modelHash, Login.spawnLoc[_].x, Login.spawnLoc[_].y, Login.spawnLoc[_].z)
                            if success then
                                newPed = rData
                            else
                                newPed = CreatePed(3, `np_m_character_select`, Login.spawnLoc[_].x, Login.spawnLoc[_].y, Login.spawnLoc[_].z, 0.72, false, false)
                                print("MODEL FAILED TO LOAD IN SPAWN: " .. modelHash)
                            end
                        end
                    end
                    
                    if newPed == nil then
                        goto skip_to_next
                    end

                    SetEntityHeading(newPed, Login.spawnLoc[_].w)
                    if character ~= nil and characterModelData[cid] ~= nil and characterModelData[cid] ~= {} and not isCustom then
                        Login.LoadPed(newPed, characterModelData[cid], modelHash)
                    end

                    if not isCustom then
                        if modelHash == GetHashKey("np_f_character_select") or modelHash == GetHashKey("np_m_character_select") then
                            if character ~= nil then
                                SetEntityAlpha(newPed,200,false)
                            else
                                SetEntityAlpha(newPed,0.9,false)
                            end
                        end
                    end

                    TaskLookAtCoord(newPed, vector3(-3968.05, 2015.41, 502.3 ),-1, 0, 2)
                    FreezeEntityPosition(newPed, true)
                    SetEntityInvincible(newPed, true)
                    SetBlockingOfNonTemporaryEvents(newPed, true)

                    Login.currentProtected[newPed] = true

                    if character ~= nil then
                        Login.CreatedPeds[_] = {
                            pedObject = newPed,
                            charId = cid,
                            posId = _
                        }
                    else
                        Login.CreatedPeds[_] = {
                            pedObject = newPed,
                            charId = 0,
                            posId = _
                        }
                    end

                    ::skip_to_next::
                end
            end)
        end


        Wait(600)
        SetNuiFocus(true, true)
        SendNUIMessage({
            open = true,
           chars = data
        })
		
		--If no characters, open Creation menu
        if noCharacters then
            SendNUIMessage({ firstOpen = true })
        end
    end)

    Login.actionsBlocked = false
end

RegisterNetEvent("login:CreatePlayerCharacterPeds")
AddEventHandler("login:CreatePlayerCharacterPeds", Login.CreatePlayerCharacterPeds)


function Login.changeChar(isLeft)
    local position = 0

    if Login.CurrentPedInfo ~= nil then position = Login.CurrentPedInfo.position end
    
    
    pedData = findCharPed(pedCaught,false)

    local maxPedAmount = 0
    for k,v in pairs(Login.CreatedPeds) do
        maxPedAmount = maxPedAmount + 1
    end
    
    if position == nil then position = 1 end

    if isLeft then
        position = position-1 

        if position <= 0 then position = maxPedAmount end
    else
        position = position+1 

        if position > maxPedAmount then position = 1 end
    end

    if Login.CreatedPeds[position] ~= nil then
        Login.CurrentPedInfo = {
            charId = Login.CreatedPeds[position].charId,
            position = position
        }
    end
    
    if Login.CurrentPedInfo ~= nil then
        SendNUIMessage({
            update = true,
            currentSelect = Login.CurrentPedInfo,
            fadeHover = false,
            forceHover = true
        })
    end
end
--[[
    Functions below: base attachment
    Description: dealing with ev-base functionality in order to set/get the correct information for chars
]]

function Login.getCharacters(isReset)
    local events = exports["ev-base"]:getModule("Events")
    if not isReset then
        TransitionFromBlurred(500)
        events:Trigger("ev-base:loginPlayer", nil, function(data)
            if type(data) == "table" and data.err then
                return
            end
        end)
    end

    events:Trigger("ev-base:fetchPlayerCharacters", nil, function(data)
        if data.err then
            print("Found error in getting player Char")
            return
        end

        local charIds = {}

        for k,v in ipairs(data) do
            charIds[#charIds + 1] = v.id
        end

        TriggerServerEvent("login:getCharModels", charIds, isReset)
    end)
end




--[[
	Functions below: character handlers 
	Description: dealing with finding information about characters 
]]

function Login.SelectedChar(data)
	Login.ClearSpawnedPeds()
	TriggerEvent("character:PlayerSelectedCharacter")
	local events = exports["ev-base"]:getModule("Events")
	events:Trigger("ev-base:selectCharacter", data.actionData, function(returnData)
        if not returnData.loggedin or not returnData.chardata then sendMessage({err = {err = true, msg = "There was a problem logging in as that character, if the problem persists, contact an administrator <br/> Cid: " .. tostring(data.selectcharacter)}}) return end

        local LocalPlayer = exports["ev-base"]:getModule("LocalPlayer")
        LocalPlayer:setCurrentCharacter(returnData.chardata)
        if Login.CurrentClothing[data.actionData] == nil then
        	Login.setClothingForChar()
        else
            deleteTrain()
            
	        SetPlayerInvincible(PlayerPedId(), true)
	        TriggerEvent("ev-base:firstSpawn")
	    end
    end)
end


--[[
	Functions below: Clothing handlers
	Description: Attachted to raid_clothes this deals with new chars or chars without clothes being selected and giveing the clothes
]]


function Login.setClothingForChar()
    Login.actionsBlocked = true

    SendNUIMessage({
      close = true
    })
    SetEntityVisible(PlayerPedId(), true)

    SetEntityCoords(PlayerPedId(),-3963.54,2013.95, 499.92)
    SetEntityHeading(PlayerPedId(),64.71)

    SetGameplayCamRelativeHeading(180.0)
    SetGameplayCamRelativePitch(1.0, 1.0)

    Wait(800)

    for i=1,25 do
      local posoffset = GetCamCoord(LoginSafe.Cam)
      local setpos = VecLerp(posoffset.x,posoffset.y,posoffset.z, -3965.88,2014.55, 501.6, i/30, true)
      SetCamCoord(LoginSafe.Cam, setpos)
      Wait(15)
    end

    Login.Open = false
    local LocalPlayer = exports["ev-base"]:getModule("LocalPlayer")
    local gender = LocalPlayer:getCurrentCharacter().gender

    if gender ~= 0 then
        SetSkin(GetHashKey("mp_f_freemode_01"), true)
    else
        SetSkin(GetHashKey("mp_m_freemode_01"), true)
    end

    TriggerEvent("raid_clothes:openClothing", false, false, true)
    TriggerEvent("raid_clothes:inSpawn", true)

    SetEntityHeading(PlayerPedId(),64.71)

    SetGameplayCamRelativeHeading(180.0)

    SetGameplayCamRelativePitch(4.0, 1.0)
end

RegisterNetEvent("ev-spawn:finishedClothing")
AddEventHandler("ev-spawn:finishedClothing", function(endType)
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local pos = vector3(-3965.88,2014.55, 501.6)
    local distance = #(playerCoords - pos)

    TriggerEvent("raid_clothes:inSpawn", false)

    if distance <= 10 then
        SetEntityVisible(PlayerPedId(), false)
    	if endType == "Finished" then
            DoScreenFadeOut(2)
    		spawnChar()
    	else
    		backToMenu()
    	end
    end	
end)


function backToMenu()
    Login.actionsBlocked = false
	SetCamActive(LoginSafe.Cam, true)
	RenderScriptCams(true, false, 0, true, true)
	Login.nativeStart(true)
end

function spawnChar()
    Login.actionsBlocked = false
    deleteTrain()

    SetPlayerInvincible(PlayerPedId(), true)
    TriggerEvent("ev-base:firstSpawn")

    SendNUIMessage({
        default = true
    })

    Login.Selected = false
    Login.CurrentPedInfo = nil
    Login.CurrentPed = nil
    Login.CreatedPeds = {}
end

RegisterNetEvent("character:finishedLoadingChar")
AddEventHandler("character:finishedLoadingChar", function()
    Login.characterLoaded()
end)