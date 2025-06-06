
local closeToCasino = false
SITTING_SCENE = nil
CURRENT_CHAIR_DATA = nil
SELECTED_CHAIR_ID = nil
selectedRulett = nil
Rulettek = {}
closetoRulett = false
currentBetAmount = 0
idleTimer = 0
aimingAtBet = -1
lastAimedBet = -1
local closestChair = -1
sittingAtRouletteTable = false
local dwWaitingForBetTimeout = 0
local timeLeft = 40
local timeoutHowToRoulette = false
local waitingForBetState = false
local shownBetContextOptions = false
local canPlayAtCurrentTable = false

local self = {}
createRulettAsztal = function(index, data)

    self.index = index
    self.data = data
    Config.DebugMsg(string.format('Rulett table creating.. %s', self.index))

    RequestModel(GetHashKey('vw_prop_casino_roulette_01'))
    while not HasModelLoaded(GetHashKey('vw_prop_casino_roulette_01')) do
        Wait(1)
    end

    self.tableObject = CreateObject(GetHashKey('vw_prop_casino_roulette_01'), data.position, false)
    SetEntityHeading(self.tableObject, data.rot)

    RequestModel(GetHashKey('S_F_Y_Casino_01'))
    while not HasModelLoaded(GetHashKey('S_F_Y_Casino_01')) do
        Wait(1)
    end

    local pedOffset = GetObjectOffsetFromCoords(data.position.x, data.position.y, data.position.z, data.rot, 0.0, 0.7, 1.0)
    self.ped = CreatePed(2, GetHashKey('S_F_Y_Casino_01'), pedOffset, data.rot + 180.0, false, true)

    SetEntityCanBeDamaged(self.ped, 0)
    SetPedAsEnemy(self.ped, 0)
    SetBlockingOfNonTemporaryEvents(self.ped, 1)
    SetPedResetFlag(self.ped, 249, 1)
    SetPedConfigFlag(self.ped, 185, true)
    SetPedConfigFlag(self.ped, 108, true)
    SetPedCanEvasiveDive(self.ped, 0)
    SetPedCanRagdollFromPlayerImpact(self.ped, 0)
    SetPedConfigFlag(self.ped, 208, true)

    -- 1.0.1
    SetPedVoiceGroup(self.ped, 'S_M_Y_Casino_01_WHITE_01')
    addRandomClothes(self.ped)

    TaskPlayAnim(self.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'idle', 3.0, 3.0, -1, 2, 0, true, true, true)

    self.numbersData = {}
    self.betData = {}
    self.hoverObjects = {}
    self.betObjects = {}
    self.ballObject = nil

    self.rulettCam = nil
    self.cameraMode = 1

    self.enableCamera = function(state)
        if state then
            self.speakPed('MINIGAME_DEALER_GREET')

            Config.DebugMsg('creating camera..')
            local rot = vector3(270.0, -90.0, self.data.rot + 270.0)
            self.rulettCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', self.data.position.x, self.data.position.y, self.data.position.z + 2.0, rot.x, rot.y, rot.z, 80.0, true, 2)
            SetCamActive(self.rulettCam, true)
            RenderScriptCams(true, 900, 900, true, false)
            Config.DebugMsg('camera setted active.')

            selectedRulett = self.index

            self.betRenderState(true)

            playRulettIdle()

            CreateThread(function()
                while selectedRulett ~= nil do
                    Wait(1000)
                    if idleTimer ~= nil then
                        idleTimer = idleTimer - 1
                        if idleTimer < 1 then
                            Config.DebugMsg('start idle')
                            idleTimer = nil
                            playRulettIdle()
                        end
                    end
                end
            end)

            CreateThread(function()
                while selectedRulett ~= nil do
                    Wait(1)
                    if self.betObjects then
                        for i = 1, #self.betObjects, 1 do
                            local bet = self.betObjects[i]
                            if DoesEntityExist(bet.obj) then
                                local coords = GetEntityCoords(bet.obj)
                                if bet.playerSrc == GetPlayerServerId(PlayerId()) then
                                    -- dwStatusHud({ "Bet: $" .. format_int(bet.betAmount) })
                                end
                            end
                        end
                    end
                end
            end)

            -- CreateThread(function()
            --     while selectedRulett ~= nil do
            --         Wait(125)

            --         -- if IsDisabledControlPressed(0, 172) then
            --         --     currentBetAmount = currentBetAmount + 10
            --         --     changeBetAmount(currentBetAmount)
            --         --     TriggerEvent("DoLongHudText", '+'..currentBetAmount.." bet [lowered]", 1)

            --         -- elseif IsDisabledControlPressed(0, 173) then
            --         --     if currentBetAmount > 0 then
            --         --         currentBetAmount = currentBetAmount - 10

            --         --         if currentBetAmount < 0 then
            --         --             currentBetAmount = 0
            --         --         end
            --         --         changeBetAmount(currentBetAmount)
            --         --         TriggerEvent("DoLongHudText", '-'..currentBetAmount.." bet [lowered]", 1)
            --         --     end
            --         -- end
            --     end
            -- end)

            CreateThread(function()
                while selectedRulett ~= nil do
                    Wait(0)
                    -- DisableAllControlActions(0)
                    if IsDisabledControlJustPressed(0, 202) then
                        self.enableCamera(false)
                    end
                    -- if IsDisabledControlJustPressed(0, 38) then
                    --     self.changeKameraMode()
                    -- end

                    -- if Config.allowCustomBet then
                    --     if IsDisabledControlJustPressed(0, 22) then --Custom Bet [space]
                    --         local tmpInput = getGenericTextInput('How many chips you would like to bet?')
                    --         if tonumber(tmpInput) then
                    --             tmpInput = tonumber(tmpInput)
                    --             if tmpInput > 0 then
                    --                 changeBetAmount(tmpInput)
                    --                 dwStatusHud({ "Bet: $" .. format_int(tmpInput) })
                    --             end
                    --         end
                    --     end
                    -- else

                    -- end
                end
            end)

            Wait(1500)
        else
            dwWaitForBet(false)
            timeoutHowToRoulette = false
            sittingAtRouletteTable = false
            dwIdleState(sittingAtRouletteTable)
            TriggerServerEvent('casino:rulett:notUsing', selectedRulett)
            if DoesCamExist(self.rulettCam) then
                DestroyCam(self.rulettCam, false)
            end
            RenderScriptCams(false, 900, 900, true, false)
            self.betRenderState(false)
            Config.DebugMsg('camera deleted.')
            selectedRulett = nil 
            self.speakPed('MINIGAME_DEALER_LEAVE_NEUTRAL_GAME')

            NetworkStopSynchronisedScene(SITTING_SCENE)

            local endingDict = 'anim_casino_b@amb@casino@games@shared@player@'
            RequestAnimDict(endingDict)
            while not HasAnimDictLoaded(endingDict) do
                Wait(1)
            end

            local whichAnim = nil
            if SELECTED_CHAIR_ID == 1 then
                whichAnim = 'sit_exit_left'
            elseif SELECTED_CHAIR_ID == 2 then
                whichAnim = 'sit_exit_right'
            elseif SELECTED_CHAIR_ID == 3 then
                whichAnim = ({'sit_exit_left', 'sit_exit_right'})[math.random(1, 2)]
            elseif SELECTED_CHAIR_ID == 4 then
                whichAnim = 'sit_exit_left'
            end

            TaskPlayAnim(PlayerPedId(), endingDict, whichAnim, 1.0, 1.0, 2500, 0)
            SetPlayerControl(PlayerId(), 0, 0)
            Wait(3600)
            SetPlayerControl(PlayerId(), 1, 0)
            TriggerServerEvent("casino:taskRemoveFromTable")
        end
    end

    self.changeKameraMode = function()
        if DoesCamExist(self.rulettCam) then
            if self.cameraMode == 1 then
                DoScreenFadeOut(200)
                while not IsScreenFadedOut() do
                    Wait(1)
                end
                self.cameraMode = 2
                local camOffset = GetOffsetFromEntityInWorldCoords(self.tableObject, -1.45, -0.15, 1.45)
                SetCamCoord(self.rulettCam, camOffset)
                SetCamRot(self.rulettCam, -25.0, 0.0, self.data.rot + 270.0, 2)
                SetCamFov(self.rulettCam, 40.0)
                ShakeCam(self.rulettCam, 'HAND_SHAKE', 0.3)
                DoScreenFadeIn(200)
            elseif self.cameraMode == 2 then
                DoScreenFadeOut(200)
                while not IsScreenFadedOut() do
                    Wait(1)
                end
                self.cameraMode = 3
                local camOffset = GetOffsetFromEntityInWorldCoords(self.tableObject, 1.45, -0.15, 2.15)
                SetCamCoord(self.rulettCam, camOffset)
                SetCamRot(self.rulettCam, -58.0, 0.0, self.data.rot + 90.0, 2)
                ShakeCam(self.rulettCam, 'HAND_SHAKE', 0.3)
                SetCamFov(self.rulettCam, 80.0)
                DoScreenFadeIn(200)
            elseif self.cameraMode == 3 then
                DoScreenFadeOut(200)
                while not IsScreenFadedOut() do
                    Wait(1)
                end
                self.cameraMode = 4
                local camOffset = GetWorldPositionOfEntityBone(self.tableObject, GetEntityBoneIndexByName(self.tableObject, 'Roulette_Wheel'))
                local rot = vector3(270.0, -90.0, self.data.rot + 270.0)
                SetCamCoord(self.rulettCam, camOffset + vector3(0.0, 0.0, 0.5))
                SetCamRot(self.rulettCam, rot, 2)
                StopCamShaking(self.rulettCam, false)
                SetCamFov(self.rulettCam, 80.0)
                DoScreenFadeIn(200)
            elseif self.cameraMode == 4 then
                DoScreenFadeOut(200)
                while not IsScreenFadedOut() do
                    Wait(1)
                end
                self.cameraMode = 1
                local rot = vector3(270.0, -90.0, self.data.rot + 270.0)
                SetCamCoord(self.rulettCam, self.data.position + vector3(0.0, 0.0, 2.0))
                SetCamRot(self.rulettCam, rot, 2)
                SetCamFov(self.rulettCam, 80.0)
                StopCamShaking(self.rulettCam, false)
                DoScreenFadeIn(200)
            end
        end
    end

    self.loadTableData = function()
        Config.DebugMsg('Table data creating, loading..')
        self.numbersData = {}
        self.betData = {}
        local e = 1
        for i = 0, 11, 1 do
            for j = 0, 2, 1 do
                table.insert(
                    self.numbersData,
                    {
                        name = e + 1,
                        hoverPos = GetOffsetFromEntityInWorldCoords(self.tableObject, (0.081 * i) - 0.057, (0.167 * j) - 0.192, 0.9448),
                        hoverObject = 'vw_prop_vw_marker_02a'
                    }
                )
                local offset = nil
                if j == 0 then
                    offset = 0.155
                elseif j == 1 then
                    offset = 0.171
                elseif j == 2 then
                    offset = 0.192
                end

                table.insert(
                    self.betData,
                    {
                        betId = e,
                        name = e + 1,
                        pos = GetOffsetFromEntityInWorldCoords(self.tableObject, (0.081 * i) - 0.057, (0.167 * j) - 0.192, 0.9448),
                        objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.081 * i - 0.057, 0.167 * j - 0.192, 0.9448),
                        hoverNumbers = {e}
                    }
                )

                e = e + 1
            end
        end
        table.insert(
            self.numbersData,
            {
                name = 'Zero',
                hoverPos = GetOffsetFromEntityInWorldCoords(self.tableObject, -0.137, -0.148, 0.9448),
                hoverObject = 'vw_prop_vw_marker_01a'
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = 'Zero',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, -0.137, -0.148, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, -0.137, -0.148, 0.9448),
                hoverNumbers = {#self.numbersData}
            }
        )
        table.insert(
            self.numbersData,
            {
                name = 'Double Zero',
                hoverPos = GetOffsetFromEntityInWorldCoords(self.tableObject, -0.133, 0.107, 0.9448),
                hoverObject = 'vw_prop_vw_marker_01a'
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = 'Double Zero',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, -0.133, 0.107, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, -0.133, 0.107, 0.9448),
                hoverNumbers = {#self.numbersData}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = 'RED',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.3, -0.4, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.3, -0.4, 0.9448),
                hoverNumbers = {1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = 'BLACK',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.5, -0.4, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.5, -0.4, 0.9448),
                hoverNumbers = {0, 2, 4, 6, 8, 9, 11, 13, 15, 18, 20, 22, 24, 26, 27, 29, 31, 33, 35}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = 'EVEN',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.15, -0.4, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.15, -0.4, 0.9448),
                hoverNumbers = {2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = 'ODD',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.65, -0.4, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.65, -0.4, 0.9448),
                hoverNumbers = {1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = '1to18',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, -0.02, -0.4, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, -0.02, -0.4, 0.9448),
                hoverNumbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = '19to36',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.78, -0.4, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.78, -0.4, 0.9448),
                hoverNumbers = {19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = '1st 12',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.05, -0.3, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.05, -0.3, 0.9448),
                hoverNumbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = '2nd 12',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.4, -0.3, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.4, -0.3, 0.9448),
                hoverNumbers = {13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = '3rd 12',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.75, -0.3, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.75, -0.3, 0.9448),
                hoverNumbers = {25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = '2to1',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.91, -0.15, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.91, -0.15, 0.9448),
                hoverNumbers = {1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = '2to1',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.91, 0.0, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.91, 0.0, 0.9448),
                hoverNumbers = {2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = '2to1',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.91, 0.15, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.91, 0.15, 0.9448),
                hoverNumbers = {3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36}
            }
        )

        Config.DebugMsg('Table data successfully created..')
    end

    self.speakPed = function(speakName)
        PlayPedAmbientSpeechNative(self.ped, speakName, 'SPEECH_PARAMS_FORCE_NORMAL_CLEAR', 1)
    end

    self.createBetObjects = function(bets)
        for i = 1, #self.betObjects, 1 do
            if DoesEntityExist(self.betObjects[i].obj) then
                DeleteObject(self.betObjects[i].obj)
            end
        end

        self.betObjects = {}

        local existBetId = {}

        for i = 1, #bets, 1 do
            local t = self.betData[bets[i].betId]

            if existBetId[bets[i].betId] == nil then
                existBetId[bets[i].betId] = 0
            else
                existBetId[bets[i].betId] = existBetId[bets[i].betId] + 1
            end

            if t ~= nil then
                local betModelObject = getBetObjectType(bets[i].betAmount)

                if betModelObject ~= nil then
                    RequestModel(betModelObject)
                    while not HasModelLoaded(betModelObject) do
                        Wait(0)
                    end

                    local obj = CreateObject(betModelObject, t.objectPos.x, t.objectPos.y, t.objectPos.z + (existBetId[bets[i].betId] * 0.0081), false)
                    SetEntityHeading(obj, self.data.rot)
                    table.insert(
                        self.betObjects,
                        {
                            obj = obj,
                            betAmount = bets[i].betAmount,
                            playerSrc = bets[i].playerSrc
                        }
                    )
                end
            end
        end
    end

    self.hoverNumbers = function(hoveredNumbers)
        for i = 1, #self.hoverObjects, 1 do
            if DoesEntityExist(self.hoverObjects[i]) then
                DeleteObject(self.hoverObjects[i])
            end
        end

        self.hoverObjects = {}

        for i = 1, #hoveredNumbers, 1 do
            local t = self.numbersData[hoveredNumbers[i]]
            if t ~= nil then
                RequestModel(GetHashKey(t.hoverObject))
                while not HasModelLoaded(GetHashKey(t.hoverObject)) do
                    Wait(1)
                end

                local obj = CreateObject(GetHashKey(t.hoverObject), t.hoverPos, false)
                SetEntityHeading(obj, self.data.rot)

                table.insert(self.hoverObjects, obj)
            end
        end
    end

    self.betRenderState = function(state)
        enabledBetRender = state

        Config.DebugMsg('Bet rendering turned: %s', enabledBetRender)

        if state then
            CreateThread(function()
                while enabledBetRender do
                    Wait(8)

                    if aimingAtBet ~= -1 and lastAimedBet ~= aimingAtBet then
                        Config.DebugMsg('aimed at different bet.')
                        lastAimedBet = aimingAtBet
                        local bettingData = self.betData[aimingAtBet]
                        if bettingData ~= nil then
                            self.hoverNumbers(bettingData.hoverNumbers)
                        else
                            self.hoverNumbers({})
                        end
                    end

                    if aimingAtBet == -1 and lastAimedBet ~= -1 then
                        self.hoverNumbers({})
                    end
                end
            end)

            CreateThread(function()
                while enabledBetRender do
                    Wait(0)

                    ShowCursorThisFrame()

                    local e = Rulettek[selectedRulett]
                    if e ~= nil then
                        local cx, cy = GetNuiCursorPosition()
                        local rx, ry = GetActiveScreenResolution()

                        local n = 30 -- this is for the cursor point, how much to tolerate in range, increasing it you will find it easier to click on the bets.

                        local foundBet = false

                        for i = 1, #self.betData, 1 do
                            local bettingData = self.betData[i]
                            local onScreen, screenX, screenY = World3dToScreen2d(bettingData.pos.x, bettingData.pos.y, bettingData.pos.z)
                            local l = math.sqrt(math.pow(screenX * rx - cx, 2) + math.pow(screenY * ry - cy, 2))
                            if l < n then
                                aimingAtBet = i
                                foundBet = true

                                if IsDisabledControlJustPressed(0, 24) then
                                    local currentBetAmount = RPC.execute("ev-roulette:CurrentBet")
                                    dwStatusHud({ "Bet: $" .. format_int(tonumber(currentBetAmount)) })
                                    if currentBetAmount > 0 then
                                        if Config.RulettTables[selectedRulett] ~= nil then
                                            if currentBetAmount then
                                                PlaySoundFrontend(-1, 'DLC_VW_BET_DOWN', 'dlc_vw_table_games_frontend_sounds', true)
                                                TriggerServerEvent('casino:taskBetRulett', selectedRulett, aimingAtBet, currentBetAmount)
                                            end
                                        end
                                    else
                                        TriggerEvent("DoLongHudText", 'Bet needs to be raised', 2)
                                    end
                                end
                            end
                        end

                        if not foundBet then
                            aimingAtBet = -1
                        end
                    end
                end
            end)
        end
    end

    self.spinRulett = function(tickRate)
        Config.DebugMsg(self.index)
        if DoesEntityExist(self.tableObject) and DoesEntityExist(self.ped) then
            Config.DebugMsg('spinRulett event 1')

            self.speakPed('MINIGAME_DEALER_CLOSED_BETS')
            TaskPlayAnim(self.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'no_more_bets', 3.0, 3.0, -1, 0, 0, true, true, true)

            Wait(1500)

            if DoesEntityExist(self.ballObject) then
                DeleteObject(self.ballObject)
            end

            TaskPlayAnim(self.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'spin_wheel', 3.0, 3.0, -1, 0, 0, true, true, true)

            RequestModel(GetHashKey('vw_prop_roulette_ball'))
            while not HasModelLoaded(GetHashKey('vw_prop_roulette_ball')) do
                Wait(1)
            end

            local ballOffset = GetWorldPositionOfEntityBone(self.tableObject, GetEntityBoneIndexByName(self.tableObject, 'Roulette_Wheel'))

            Config.DebugMsg('spinRulett event 2')

            local LIB = 'anim_casino_b@amb@casino@games@roulette@table'
            RequestAnimDict(LIB)
            while not HasAnimDictLoaded(LIB) do
                Wait(1)
            end

            Wait(3000)

            self.ballObject = CreateObject(GetHashKey('vw_prop_roulette_ball'), ballOffset, false)
            SetEntityHeading(self.ballObject, self.data.rot)
            SetEntityCoordsNoOffset(self.ballObject, ballOffset, false, false, false)
            local h = GetEntityRotation(self.ballObject)
            SetEntityRotation(self.ballObject, h.x, h.y, h.z + 90.0, 2, false)

            if DoesEntityExist(self.tableObject) and DoesEntityExist(self.ped) then
                Config.DebugMsg('spinRulett event 3')

                PlayEntityAnim(self.ballObject, 'intro_ball', LIB, 1000.0, false, true, true, 0, 136704)
                PlayEntityAnim(self.ballObject, 'loop_ball', LIB, 1000.0, false, true, false, 0, 136704)

                PlayEntityAnim(self.tableObject, 'intro_wheel', LIB, 1000.0, false, true, true, 0, 136704)
                PlayEntityAnim(self.tableObject, 'loop_wheel', LIB, 1000.0, false, true, false, 0, 136704)

                PlayEntityAnim(self.ballObject, string.format('exit_%s_ball', tickRate), LIB, 1000.0, false, true, false, 0, 136704)
                PlayEntityAnim(self.tableObject, string.format('exit_%s_wheel', tickRate), LIB, 1000.0, false, true, false, 0, 136704)

                Wait(11e3)

                if DoesEntityExist(self.tableObject) and DoesEntityExist(self.ped) then
                    TaskPlayAnim(self.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'clear_chips_zone1', 3.0, 3.0, -1, 0, 0, true, true, true)
                    Wait(1500)
                    TaskPlayAnim(self.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'clear_chips_zone2', 3.0, 3.0, -1, 0, 0, true, true, true)
                    Wait(1500)
                    TaskPlayAnim(self.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'clear_chips_zone3', 3.0, 3.0, -1, 0, 0, true, true, true)

                    Wait(2000)
                    if DoesEntityExist(self.tableObject) and DoesEntityExist(self.ped) then
                        TaskPlayAnim(self.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'idle', 3.0, 3.0, -1, 0, 0, true, true, true)
                    end

                    Config.DebugMsg('spinRulett event ending')

                    if DoesEntityExist(self.ballObject) then
                        DeleteObject(self.ballObject)
                    end
                end
            end
        end
    end

    self.loadTableData()
    Config.DebugMsg(string.format('Rulett table created %s id', self.index))
    Rulettek[self.index] = self
end

Citizen.CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())
        if not closetoRulett then
            closetoRulett = false
            for k, v in pairs(Config.RulettTables) do
                if #(playerCoords - Config.RulettTables[k].position) < 60.0 then
                    closetoRulett = true
                end
            end
        end
        CasinoWaitTimer()
    end
end)

Citizen.CreateThread(function()
    local uiIntShown = false
    while true do
        local playerpos = GetEntityCoords(PlayerPedId())

        for k, v in pairs(Rulettek) do
            if DoesEntityExist(v.tableObject) then
                local objcoords = GetEntityCoords(v.tableObject)
                local dist = Vdist(playerpos, objcoords)
                if not sittingAtRouletteTable then
                    if dist < 3.4 then
                        if not timeoutHowToRoulette then
                            local closestChairData = getClosestChairData(v.tableObject)

                            if closestChairData == nil then
                                break
                            end
                            if not uiIntShown then
                                local background = "info"
                                if exports['ev-inventory']:hasEnoughOfItem("casinomember", 1, false, true) and not isHighRoller then
                                    background = "success"
                                    canPlayAtCurrentTable = true
                                elseif exports['ev-inventory']:hasEnoughOfItem("casinovip", 1, false, true) then
                                    background = "success"
                                    canPlayAtCurrentTable = true
                                else
                                    background = "error"
                                    canPlayAtCurrentTable = false
                                end
                                exports["ev-ui"]:showInteraction("[E] Play Roulette!", background)
                            end
                            uiIntShown = true
                            if IsControlJustPressed(0, 38) then
                                if canPlayAtCurrentTable then
                                    TriggerServerEvent('server_remote:rulett:taskSitDown', k, closestChairData)
                                end
                            end
                        end
                    elseif uiIntShown then
                        uiIntShown = false
                        local background = "info"
                        if exports['ev-inventory']:hasEnoughOfItem("casinomember", 1, false, true) or exports['ev-inventory']:hasEnoughOfItem("casinovip", 1, false, true) then
                            background = "success"
                        else
                            background = "error"
                        end
                        exports["ev-ui"]:hideInteraction(background)
                    end
                elseif uiIntShown then
                    uiIntShown = false
                    local background = "info"
                    if exports['ev-inventory']:hasEnoughOfItem("casinomember", 1, false, true) or exports['ev-inventory']:hasEnoughOfItem("casinovip", 1, false, true) then
                        background = "success"
                    else
                        background = "error"
                    end
                    exports["ev-ui"]:hideInteraction(background)
                end
            end
        end
        CasinoWaitTimer()
    end
end)

Citizen.CreateThread(function()
    while not closetoRulett do
        Wait(0)
    end

    for rulettIndex, data in pairs(Config.RulettTables) do
        createRulettAsztal(rulettIndex, data)
        print("OLA")

        RequestAnimDict('anim_casino_b@amb@casino@games@roulette@table')
        RequestAnimDict('anim_casino_b@amb@casino@games@roulette@dealer_female')
        RequestAnimDict('anim_casino_b@amb@casino@games@shared@player@')
        RequestAnimDict('anim_casino_b@amb@casino@games@roulette@player')
    end
    Config.DebugMsg('Casino rulett loaded.')
end)

RegisterUICallback("ev-ui:RouletteBet", function(data, cb)
    cb({ data = {}, meta = { ok = true, message = "done" } })
    local action = data.key
    waitingForBetState = false
    drawTimerBar = false
    shownBetContextOptions = false
    for rulettIndex, data in pairs(Config.RulettTables) do
        if action == "prev" then
            TriggerServerEvent('casino:taskBetRulett', rulettIndex, aimingAtBet, currentBetAmount)
        elseif action == "bet" then
           BetRouletteWEW(true)
        elseif action == "leave" then
            self.enableCamera(false)
        end
    end
end)

RegisterUICallback("ev-ui:isRouletteBet", function(data, cb)
    cb({ data = {}, meta = { ok = true, message = "done" } })
    -- exports["ev-ui"]:closeApplication("textbox")
    if data.key ~= "cancel" then
        currentBetAmount = tonumber(data.key)
        changeBetAmount(currentBetAmount)
    end

    if dwWaitingForBetTimeout + 19000 < GetGameTimer() then
      TriggerEvent("DoLongHudText", "Took too long.", 2)
      return
    end
    for rulettIndex, data in pairs(Config.RulettTables) do
        if currentBetAmount >= Config.RulettTables[rulettIndex].limits.min and currentBetAmount <= Config.RulettTables[rulettIndex].limits.max then
            local dwUseChipsResult = RPC.execute("ev-casino:useChips", currentBetAmount)
            dwRefreshChipCount = true
            if dwUseChipsResult then
                PlaySoundFrontend(-1, 'DLC_VW_BET_DOWN', 'dlc_vw_table_games_frontend_sounds', true)
                TriggerServerEvent('casino:taskBetRulett', rulettIndex, aimingAtBet, currentBetAmount)
                self.enableCamera(true)
            else
                currentBetAmount = 0
                TriggerEvent("DoLongHudText", "Not enough chips!", 2)
                Wait(1000)
                if not sittingAtRouletteTable and waitingForBetState then
                    dwWaitForBet(true)
                end
            end
        elseif data.key == "cancel" then
            dwWaitForBet(true)
        end
    end
end)

AddEventHandler("ev-ui:application-closed", function(name)
    if name ~= "contextmenu" then return end
    if sittingAtRouletteTable and waitingForBetState then
        waitingForBetState = false
        drawTimerBar = false
        shownBetContextOptions = false
        TriggerServerEvent("Roulette:standRoulette")
    end
end)

RegisterNetEvent('client_callback:rulett:taskSitDown')
AddEventHandler('client_callback:rulett:taskSitDown', function(rulettIndex, chairData)
    -- exports['progressBars']:drawBar(4000, 'Sitting...')
    -- Framework.Functions.Notify("Sitting...", "primary", 3200)
    sittingAtRouletteTable = true
    timeoutHowToRoulette = true
    dwIdleState(sittingAtRouletteTable)
    SELECTED_CHAIR_ID = chairData.chairId
    CURRENT_CHAIR_DATA = chairData
    SITTING_SCENE = NetworkCreateSynchronisedScene(chairData.position, chairData.rotation, 2, 1, 0, 1065353216, 0, 1065353216)
    RequestAnimDict('anim_casino_b@amb@casino@games@shared@player@')
    while not HasAnimDictLoaded('anim_casino_b@amb@casino@games@shared@player@') do
        Wait(1)
    end

    local randomSit = ({'sit_enter_left', 'sit_enter_right'})[math.random(1, 2)]
    NetworkAddPedToSynchronisedScene(PlayerPedId(), SITTING_SCENE, 'anim_casino_b@amb@casino@games@shared@player@', randomSit, 2.0, -2.0, 13, 16, 2.0, 0)
    NetworkStartSynchronisedScene(SITTING_SCENE)
    SetPlayerControl(PlayerId(), 0, 0)
    startRulett(rulettIndex, SELECTED_CHAIR_ID)
    Wait(4000)
    SetPlayerControl(PlayerId(), 1, 0)
end)

function startRulett(index, chairId)
    if Rulettek[index] then
        TriggerServerEvent('casino:taskStartRoulette', index, chairId)
    end
end

RegisterNetEvent('client:casino:openRulett')
AddEventHandler('client:casino:openRulett',function(rulettIndex)
    if Rulettek[rulettIndex] ~= nil then
        Wait(4000)
        dwWaitForBet(true)
    end
end)

RegisterNetEvent('casino:rulett:startSpin')
AddEventHandler('casino:rulett:startSpin', function(rulettIndex, tickRate)
    if Rulettek[rulettIndex] ~= nil then

        Config.DebugMsg(string.format('rulett table index: %s, tickrate: %s', rulettIndex, tickRate))
        Rulettek[rulettIndex].spinRulett(tickRate)

        if selectedRulett == rulettIndex then
            Config.DebugMsg('impartial anim play')
            playImpartial()
        end
    end
end)

RegisterNetEvent('client:rulett:updateStatusz')
AddEventHandler('client:rulett:updateStatusz', function(rulettIndex, ido, statusz)
    if Rulettek[rulettIndex] ~= nil then
        Rulettek[rulettIndex].ido = ido
        Rulettek[rulettIndex].statusz = statusz
    end
end)

RegisterNetEvent('client:rulett:updateTableBets')
AddEventHandler('client:rulett:updateTableBets', function(rulettIndex, bets)
    if Rulettek[rulettIndex] ~= nil then
        Rulettek[rulettIndex].createBetObjects(bets)
    end
end)

function getClosestChairData(tableObject)
    local localPlayer = PlayerPedId()
    local playerpos = GetEntityCoords(localPlayer)
    if DoesEntityExist(tableObject) then
        local chairs = {'Chair_Base_01', 'Chair_Base_02', 'Chair_Base_03', 'Chair_Base_04'}
        for i = 1, #chairs, 1 do
            local objcoords = GetWorldPositionOfEntityBone(tableObject, GetEntityBoneIndexByName(tableObject, chairs[i]))
            local dist = Vdist(playerpos, objcoords)
            if dist < 1.7 then
                return {
                    position = objcoords,
                    rotation = GetWorldRotationOfEntityBone(tableObject, GetEntityBoneIndexByName(tableObject, chairs[i])),
                    chairId = Config.ChairIds[chairs[i]]
                }
            end
        end
    end
end

function getBetObjectType(betAmount)
    if betAmount < 10 then
        return GetHashKey('vw_prop_vw_coin_01a')
    elseif betAmount >= 10 and betAmount < 50 then
        return GetHashKey('vw_prop_chip_10dollar_x1')
    elseif betAmount >= 50 and betAmount < 100 then
        return GetHashKey('vw_prop_chip_50dollar_x1')
    elseif betAmount >= 100 and betAmount < 500 then
        return GetHashKey('vw_prop_chip_100dollar_x1')
    elseif betAmount >= 500 and betAmount < 1000 then
        return GetHashKey('vw_prop_chip_500dollar_x1')
    elseif betAmount >= 1000 and betAmount < 5000 then
        return GetHashKey('vw_prop_chip_1kdollar_x1')
    elseif betAmount >= 5000 then
        return GetHashKey('vw_prop_plaq_10kdollar_x1')
    else -- this should never happen, but yeah.
        return GetHashKey('vw_prop_plaq_10kdollar_x1')
    end

    -- these are deprecated, it looks cool, but it hides some data, you can put it in you like the big chip piles.

    -- elseif bets[i].betAmount >= 10000 and bets[i].betAmount < 25000 then
    --     return GetHashKey('vw_prop_vw_chips_pile_01a')
    -- elseif bets[i].betAmount >= 25000 and bets[i].betAmount < 50000 then
    --     return GetHashKey('vw_prop_vw_chips_pile_02a')
    -- elseif bets[i].betAmount >= 50000 then
    --     return GetHashKey('vw_prop_vw_chips_pile_03a')
    -- end
end

function CasinoWaitTimer()
    if not closetoRulett then
        Wait(5000)
    else
        Wait(0)
    end
end

RegisterNetEvent('client:rulett:playBetAnim')
AddEventHandler('client:rulett:playBetAnim', function(chairId)
    local sex = 0

    if GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') then
        sex = 1
    end

    local rot = CURRENT_CHAIR_DATA.rotation

    if chairId == 4 then
        rot = rot + vector3(0.0, 0.0, 90.0)
    elseif chairId == 3 then
        rot = rot + vector3(0.0, 0.0, -180.0)
    elseif chairId == 2 then
        rot = rot + vector3(0.0, 0.0, -90.0)
    elseif chairId == 1 then
        chairId = 1
        rot = rot + vector3(0.0, 0.0, -90.0)
    end

    local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_male@seat_%s@regular@0%sa@play@v01', chairId, chairId)
    if sex == 1 then
        L = string.format('anim_casino_b@amb@casino@games@roulette@ped_female@seat_%s@regular@0%sa@play@v01', chairId, chairId)
    end

    RequestAnimDict(L)
    while not HasAnimDictLoaded(L) do
        Wait(1)
    end

    if CURRENT_CHAIR_DATA ~= nil then
        local currentScene = NetworkCreateSynchronisedScene(CURRENT_CHAIR_DATA.position, rot, 2, 1, 0, 1065353216, 0, 1065353216)
        NetworkAddPedToSynchronisedScene(
            PlayerPedId(),
            currentScene,
            L,
            ({'place_bet_zone1', 'place_bet_zone2', 'place_bet_zone3'})[math.random(1, 3)],
            4.0,
            -2.0,
            13,
            16,
            1148846080,
            0
        )
        NetworkStartSynchronisedScene(currentScene)

        idleTimer = 8
    end
end)

RegisterNetEvent('client:rulett:playWinAnim')
AddEventHandler('client:rulett:playWinAnim', function(chairId)
    local rot = CURRENT_CHAIR_DATA.rotation
    dwStatusHud({ "Waiting for bet..." })

    if chairId == 4 then
        rot = rot + vector3(0.0, 0.0, 90.0)
    elseif chairId == 3 then
        rot = rot + vector3(0.0, 0.0, -180.0)
    elseif chairId == 2 then
        rot = rot + vector3(0.0, 0.0, -90.0)
    elseif chairId == 1 then
        chairId = 1
        rot = rot + vector3(0.0, 0.0, -90.0)
    end

    local sex = 0
    local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_male@seat_%s@regular@0%sa@reacts@v01', chairId, chairId)

    if GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') then
        sex = 1
    end

    if sex == 1 then
        local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_female@seat_%s@regular@0%sa@reacts@v01', chairId, chairId)
    end

    RequestAnimDict(L)
    while not HasAnimDictLoaded(L) do
        Wait(1)
    end

    if CURRENT_CHAIR_DATA ~= nil then
        local currentScene = NetworkCreateSynchronisedScene(CURRENT_CHAIR_DATA.position, rot, 2, 1, 0, 1065353216, 0, 1065353216)
        NetworkAddPedToSynchronisedScene(PlayerPedId(), currentScene, L, 'reaction_great', 4.0, -2.0, 13, 16, 1148846080, 0)
        NetworkStartSynchronisedScene(currentScene)

        idleTimer = 8
    end
end)

RegisterNetEvent('client:rulett:playLossAnim', function(chairId)
    local rot = CURRENT_CHAIR_DATA.rotation
    dwStatusHud({ "Waiting for bet..." })

    if chairId == 4 then
        rot = rot + vector3(0.0, 0.0, 90.0)
    elseif chairId == 3 then
        rot = rot + vector3(0.0, 0.0, -180.0)
    elseif chairId == 2 then
        rot = rot + vector3(0.0, 0.0, -90.0)
    elseif chairId == 1 then
        chairId = 1
        rot = rot + vector3(0.0, 0.0, -90.0)
    end

    local sex = 0
    local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_male@seat_%s@regular@0%sa@reacts@v01', chairId, chairId)

    if GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') then
        sex = 1
    end

    if sex == 1 then
        local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_female@seat_%s@regular@0%sa@reacts@v01', chairId, chairId)
    end

    RequestAnimDict(L)
    while not HasAnimDictLoaded(L) do
        Wait(1)
    end

    if CURRENT_CHAIR_DATA ~= nil then
        local currentScene = NetworkCreateSynchronisedScene(CURRENT_CHAIR_DATA.position, rot, 2, 1, 0, 1065353216, 0, 1065353216)
        NetworkAddPedToSynchronisedScene(
            PlayerPedId(),
            currentScene,
            L,
            ({'reaction_bad_var01', 'reaction_bad_var02', 'reaction_terrible'})[math.random(1, 3)],
            4.0,
            -2.0,
            13,
            16,
            1148846080,
            0
        )
        NetworkStartSynchronisedScene(currentScene)

        idleTimer = 8
    end
end)

function playImpartial()
    local rot = CURRENT_CHAIR_DATA.rotation

    if SELECTED_CHAIR_ID == 4 then
        rot = rot + vector3(0.0, 0.0, 90.0)
    elseif SELECTED_CHAIR_ID == 3 then
        rot = rot + vector3(0.0, 0.0, -180.0)
    elseif SELECTED_CHAIR_ID == 2 then
        rot = rot + vector3(0.0, 0.0, -90.0)
    elseif SELECTED_CHAIR_ID == 1 then
        SELECTED_CHAIR_ID = 1
        rot = rot + vector3(0.0, 0.0, -90.0)
    end

    local sex = 0
    local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_male@seat_%s@regular@0%sa@reacts@v01', SELECTED_CHAIR_ID, SELECTED_CHAIR_ID)

    if GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') then
        sex = 1
    end

    if sex == 1 then
        local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_female@seat_%s@regular@0%sa@reacts@v01', SELECTED_CHAIR_ID, SELECTED_CHAIR_ID)
    end

    RequestAnimDict(L)
    while not HasAnimDictLoaded(L) do
        Wait(1)
    end

    if CURRENT_CHAIR_DATA ~= nil then
        local currentScene = NetworkCreateSynchronisedScene(CURRENT_CHAIR_DATA.position, rot, 2, 1, 0, 1065353216, 0, 1065353216)
        NetworkAddPedToSynchronisedScene(
            PlayerPedId(),
            currentScene,
            L,
            ({'reaction_impartial_var01', 'reaction_impartial_var02', 'reaction_impartial_var03'})[math.random(1, 3)],
            4.0,
            -2.0,
            13,
            16,
            1148846080,
            0
        )
        NetworkStartSynchronisedScene(currentScene)

        idleTimer = 8
    end
end

function playRulettIdle()
    local rot = CURRENT_CHAIR_DATA.rotation

    if SELECTED_CHAIR_ID == 4 then
        rot = rot + vector3(0.0, 0.0, 90.0)
    elseif SELECTED_CHAIR_ID == 3 then
        rot = rot + vector3(0.0, 0.0, -180.0)
    elseif SELECTED_CHAIR_ID == 2 then
        rot = rot + vector3(0.0, 0.0, -90.0)
    elseif SELECTED_CHAIR_ID == 1 then
        SELECTED_CHAIR_ID = 1
        rot = rot + vector3(0.0, 0.0, -90.0)
    end

    local sex = 0
    local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_male@seat_%s@regular@0%sa@idles', SELECTED_CHAIR_ID, SELECTED_CHAIR_ID)

    if GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') then
        sex = 1
    end

    if sex == 1 then
        local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_female@seat_%s@regular@0%sa@idles', SELECTED_CHAIR_ID, SELECTED_CHAIR_ID)
    end

    RequestAnimDict(L)
    while not HasAnimDictLoaded(L) do
        Wait(1)
    end

    if CURRENT_CHAIR_DATA ~= nil then
        local currentScene = NetworkCreateSynchronisedScene(CURRENT_CHAIR_DATA.position, rot, 2, 1, 0, 1065353216, 0, 1065353216)
        NetworkAddPedToSynchronisedScene(PlayerPedId(), currentScene, L, ({'idle_a', 'idle_b', 'idle_c', 'idle_d'})[math.random(1, 4)], 1.0, -2.0, 13, 16, 1148846080, 0)
        NetworkStartSynchronisedScene(currentScene)
    end
end

function addRandomClothes(ped)
    local r = math.random(1, 5)

    if r == 1 then
        SetPedComponentVariation(ped, 0, 4, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 4, 0, 0)
        SetPedComponentVariation(ped, 3, 2, 1, 0)
        SetPedComponentVariation(ped, 4, 1, 0, 0)
        SetPedComponentVariation(ped, 6, 1, 0, 0)
        SetPedComponentVariation(ped, 7, 1, 0, 0)
        SetPedComponentVariation(ped, 8, 2, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 0, 0, 0)
        SetPedPropIndex(ped, 1, 0, 0, false)
    elseif r == 2 then
        SetPedComponentVariation(ped, 0, 3, 1, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 3, 1, 0)
        SetPedComponentVariation(ped, 3, 1, 1, 0)
        SetPedComponentVariation(ped, 4, 1, 0, 0)
        SetPedComponentVariation(ped, 6, 1, 0, 0)
        SetPedComponentVariation(ped, 7, 2, 0, 0)
        SetPedComponentVariation(ped, 8, 1, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 0, 0, 0)
    elseif r == 3 then
        SetPedComponentVariation(ped, 0, 3, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 3, 0, 0)
        SetPedComponentVariation(ped, 3, 0, 1, 0)
        SetPedComponentVariation(ped, 4, 1, 0, 0)
        SetPedComponentVariation(ped, 6, 1, 0, 0)
        SetPedComponentVariation(ped, 7, 1, 0, 0)
        SetPedComponentVariation(ped, 8, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 0, 0, 0)
        SetPedPropIndex(ped, 1, 0, 0, false)
    elseif r == 4 then
        SetPedComponentVariation(ped, 0, 2, 1, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 2, 1, 0)
        SetPedComponentVariation(ped, 3, 3, 3, 0)
        SetPedComponentVariation(ped, 4, 1, 0, 0)
        SetPedComponentVariation(ped, 6, 1, 0, 0)
        SetPedComponentVariation(ped, 7, 2, 0, 0)
        SetPedComponentVariation(ped, 8, 3, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 0, 0, 0)
    end
end

local isDwIdleStateActive = false
function dwIdleState(act)
  if act and not isDwIdleStateActive then
    isDwIdleStateActive = true
    dwStatusHud({ "Waiting for dealer..." })
  elseif not act and isDwIdleStateActive then
    isDwIdleStateActive = false
    exports["ev-ui"]:sendAppEvent("status-hud", {
      show = false,
    })
  end
end

local dwCurrentChipCount = 0
local dwRefreshChipCount = true
function dwStatusHud(pValues)
    dwCurrentChipCount = RPC.execute("ev-casino:getCurrentChipCount")
    local title = "Roulette "
    local values = {}
    values[#values + 1] = "Balance: $" .. format_int(dwCurrentChipCount)
    for _, v in pairs(pValues) do
        values[#values + 1] = v
    end
    exports["ev-ui"]:sendAppEvent("status-hud", {
        show = true,
        title = title,
        values = values,
    })
end

local playedCasinoGuiSound = false
function format_int(number)
    local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
    int = int:reverse():gsub("(%d%d%d)", "%1,")
    return minus .. int:reverse():gsub("^,", "") .. fraction .. '.00'
end

function changeBetAmount(amount)
    currentBetAmount = amount
    dwStatusHud({ "Bet: $" .. format_int(currentBetAmount) })
    PlaySoundFrontend(-1, 'DLC_VW_BET_HIGHLIGHT', 'dlc_vw_table_games_frontend_sounds', true)
end

function getGenericTextInput(type)
    if type == nil then
        type = ''
    end
    AddTextEntry('FMMC_MPM_NA', tostring(type))
    DisplayOnscreenKeyboard(1, 'FMMC_MPM_NA', tostring(type), '', '', '', '', 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0)
        Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        if result then
            return result
        end
    end
    return false
end

function dwWaitForBet(act)
    waitingForBetState = act
    if waitingForBetState then
        dwWaitingForBetTimeout = GetGameTimer()
        Wait(2000)
        if sittingAtRouletteTable then
            -- shownHitStandContextOptions = false
            local data = {}
            data = {
                {
                    action = "ev-ui:RouletteBet",
                    title = "Bet Chips",
                    description = "",
                    key = "bet",
                },
                {
                    action = "ev-ui:RouletteBet",
                    title = "Rebet",
                    description = "Bet your previous bet.",
                    key = "prev",
                },
                {
                    action = "ev-ui:RouletteBet",
                    title = "Leave Table",
                    description = "",
                    key = "leave",
                },
            }
            exports["ev-ui"]:showContextMenu(data)
            dwStatusHud({ "Waiting for bet..." })
        end
        return
    end
end

function BetRouletteWEW(act)
    waitingForBetState = act
    if waitingForBetState then
        dwWaitingForBetTimeout = GetGameTimer()
        Wait(500)
        if sittingAtRouletteTable then
            -- shownHitStandContextOptions = false
            local data = {}
            data = {
                {
                    action = "ev-ui:isRouletteBet",
                    title = "Place Bet",
                    description = "$100.00",
                    key = 100,
                },
                {
                    action = "ev-ui:isRouletteBet",
                    title = "Place Bet",
                    description = "$250.00",
                    key = 250,
                },
                {
                    action = "ev-ui:isRouletteBet",
                    title = "Place Bet",
                    description = "$500.00",
                    key = 500,
                },
                {
                    action = "ev-ui:isRouletteBet",
                    title = "Place Bet",
                    description = "$1000.00",
                    key = 1000,
                },
                {
                    action = "ev-ui:isRouletteBet",
                    title = "Cancel Bet",
                    description = "Cancel current bet placement",
                    key = "cancel",
                },
            }
            exports["ev-ui"]:showContextMenu(data)
            dwStatusHud({ "Waiting for bet..." })
        end
        return
    end
end
