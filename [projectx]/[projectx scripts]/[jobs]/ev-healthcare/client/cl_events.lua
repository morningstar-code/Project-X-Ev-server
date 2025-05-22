local hospitals = {
  ['pillbox'] = {isTriageEnabled = false},
  ['viceroy'] = {isTriageEnabled = false},
  ['sandy'] = {isTriageEnabled = false},
}
local currentPrompt, isExercising, CanPage = nil, false, true

local EVENTS = {LOCKERS = 1, CLOTHING = 2, SWITCHER = 3}
  
  RegisterNetEvent('ev-healthcare:yoga')
  AddEventHandler('ev-healthcare:yoga', function(pArgs, pEntity, pContext)
    TaskTurnPedToFaceEntity(PlayerPedId(), pEntity, -1)
    Wait(50)
    local animation = AnimationTask:new(PlayerPedId(), 'normal', _L("healthcare-yoga", "Breathe in.."), 30000,
                                        'WORLD_HUMAN_YOGA', nil, nil)
    local result = animation:start()
    result:next(function(data)
      if data == 25 or data == 50 or data == 75 or data == 100 then
        TriggerEvent('client:newStress', false, 1000)
      else
        TriggerEvent("DoLHudText", 2, "healthcare-no-chakra", "You just ruined your chakra.")
      end
      ClearPedTasks(PlayerPedId())
    end)
  end)
  
  RegisterNetEvent('ev-healthcare:exercise')
  AddEventHandler('ev-healthcare:exercise', function(pArgs, pEntity, pContext)
    local function getExerciseAnimation(pModel)
      if pModel == GetHashKey('prop_weight_squat') then
        return 'WORLD_HUMAN_MUSCLE_FREE_WEIGHTS'
      elseif pModel == GetHashKey('prop_beach_bars_02') then
        return 'amb@prop_human_muscle_chin_ups@male@base', 'base'
      end
    end
  
    TaskTurnPedToFaceEntity(PlayerPedId(), pEntity, -1)
    Wait(50)
    local exerciseDict, exerciseAnim = getExerciseAnimation(pContext.model)
    local animation = AnimationTask:new(PlayerPedId(), 'normal', _L("healthcare-getting-buff", "Getting buff as hell"), 15000,
                                        exerciseDict, exerciseAnim, exerciseAnim and 9 or nil)
    local result = animation:start()
    result:next(function(data)
      if data == 100 then
        TriggerEvent('client:newStress', false, math.ceil(450))
      else
        TriggerEvent("DoLHudText", 2, "healthcare-no-gains", "No gains for you bro")
      end
      ClearPedTasks(PlayerPedId())
    end)
  end)
  
  AddEventHandler('ev-base:playerSpawned', function()
    --TriggerServerEvent('doctor:setTriageState', 'Central', false)
    --TriggerServerEvent('doctor:setTriageState', 'Sandy', false)
    TriggerServerEvent('doctor:setTriageState', 'viceroy', false)
  end)
  
  RegisterNetEvent('doctor:setTriageState')
  AddEventHandler('doctor:setTriageState', function(pHospital, pState)
    hospitals[pHospital].isTriageEnabled = pState
  end)
  
  RegisterUICallback('ev-healthcare:handler', function(data, cb)
    local eventData = data.key
    local location = string.match(currentPrompt, '(.-)_')
    if eventData == EVENTS.LOCKERS then
      local cid = exports['isPed']:isPed('cid')
      TriggerEvent('server-inventory-open', '1', ('personalStorage-%s-%s'):format(location, cid))
      TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'LockerOpen', 0.4)
    elseif eventData == EVENTS.CLOTHING then
      TriggerEvent('ev-clothing:openClothing', false, false)
    elseif eventData == EVENTS.SWITCHER then
      TransitionToBlurred(500)
      DoScreenFadeOut(500)
      Wait(1000)
      TriggerEvent('ev-base:clearStates')
      exports['ev-base']:getModule('SpawnManager'):Initialize()
      Wait(1000)
    end
    cb({ data = {}, meta = { ok = true, message = 'done' } })
  end)
  
  local function getDoctorsOnline()
    local doctors = RPC.execute("ev-jobmanager:jobCount", "doctor")
    return doctors
  end
  
  local zoneData = {
    central_checkin = { promptText = _L("healthcare-checkin-prompt", "[E] Check-In") },
    sandy_checkin = { promptText = _L("healthcare-checkin-prompt", "[E] Check-In") },
    hospital_armory = { promptText = _L("healthcare-armory-prompt", "[E] Armory") },
    hospital_clothing_lockers_staff = {
      promptText = _L("healthcare-locker-prompt", "[E] Lockers & Clothes"),
      menuData = {
        {
          title = _L("healthcare-locker-title", "Lockers"),
          description = _L("healthcare-locker-description", "Access your personal locker"),
          action = 'ev-healthcare:handler',
          key = EVENTS.LOCKERS,
        }, {
          title = _L("healthcare-locker-clothing", "Clothing"),
          description = _L("healthcare-locker-clothing-desc", "Gotta look sharp"),
          action = 'ev-healthcare:handler',
          key = EVENTS.CLOTHING,
        },
      },
    },
    hospital_character_switcher_staff = {
      promptText = _L("healthcare-change-character", "[E] Switch Character"),
      menuData = {
        {
          title = _L("healthcare-change-character-title", "Character switch"),
          description = _L("healthcare-change-character-desc", "Go bowling with your cousin"),
          action = 'ev-police:handler',
          key = EVENTS.SWITCHER,
        },
      },
    },
    central_character_switcher_backroom = {
      promptText = _L("healthcare-change-character", "[E] Switch Character"),
      menuData = {
        {
          title = _L("healthcare-change-character-title", "Character switch"),
          description = _L("healthcare-change-character-desc", "Go bowling with your cousin"),
          action = 'ev-police:handler',
          key = EVENTS.SWITCHER,
        },
      },
    },
    morgue_character_switcher_backroom = {
      promptText = _L("healthcare-change-character", "[E] Switch Character"),
      menuData = {
        {
          title = _L("healthcare-change-character-title", "Character switch"),
          description = _L("healthcare-change-character-desc", "Go bowling with your cousin"),
          action = 'ev-police:handler',
          key = EVENTS.SWITCHER,
        },
      },
    },
    parsons_character_switcher_backroom = {
      promptText = _L("healthcare-change-character", "[E] Switch Character"),
      menuData = {
        {
          title = _L("healthcare-change-character-title", "Character switch"),
          description = _L("healthcare-change-character-desc", "Go bowling with your cousin"),
          action = 'ev-police:handler',
          key = EVENTS.SWITCHER,
        },
      },
    },
    infirm_char_switcher_backroom = {
      promptText = _L("healthcare-change-character", "[E] Switch Character"),
      menuData = {
        {
          title = _L("healthcare-change-character-title", "Character switch"),
          description = _L("healthcare-change-character-desc", "Go bowling with your cousin"),
          action = 'ev-police:handler',
          key = EVENTS.SWITCHER,
        },
      },
    },
    elburro_clothing_lockers_staff_char_switcher = {
      promptText = _L("healthcare-locker-prompt", "[E] Lockers & Clothes"),
      menuData = {
        {
          title = _L("healthcare-locker-title", "Lockers"),
          description = _L("healthcare-locker-description", "Access your personal locker"),
          action = 'ev-healthcare:handler',
          key = EVENTS.LOCKERS,
        }, {
          title = _L("healthcare-locker-clothing", "Clothing"),
          description = _L("healthcare-locker-clothing-desc", "Gotta look sharp"),
          action = 'ev-healthcare:handler',
          key = EVENTS.CLOTHING,
        },
        {
          title = _L("healthcare-change-character-title", "Character switch"),
          description = _L("healthcare-change-character-desc", "Go bowling with your cousin"),
          action = 'ev-police:handler',
          key = EVENTS.SWITCHER,
        },
      },
    },
    sandy_clothing_lockers_staff_char_switcher = {
      promptText = _L("healthcare-locker-prompt", "[E] Lockers & Clothes"),
      menuData = {
        {
          title = _L("healthcare-locker-title", "Lockers"),
          description = _L("healthcare-locker-description", "Access your personal locker"),
          action = 'ev-healthcare:handler',
          key = EVENTS.LOCKERS,
        }, {
          title = _L("healthcare-locker-clothing", "Clothing"),
          description = _L("healthcare-locker-clothing-desc", "Gotta look sharp"),
          action = 'ev-healthcare:handler',
          key = EVENTS.CLOTHING,
        },
        {
          title = _L("healthcare-change-character-title", "Character switch"),
          description = _L("healthcare-change-character-desc", "Go bowling with your cousin"),
          action = 'ev-police:handler',
          key = EVENTS.SWITCHER,
        },
      },
    },
  }
  
  local function listenForKeypress(pZone, pDoctors)
    listening = true
    Citizen.CreateThread(function()
      while listening do
        if IsControlJustReleased(0, 38) then
          if pZone == 'hospital_clothing_lockers_staff' or pZone == 'elburro_clothing_lockers_staff_char_switcher' then
            exports['ev-ui']:showContextMenu(zoneData[pZone].menuData)
          elseif pZone == 'central_checkin' or pZone == 'sandy_checkin' then
            local hospital = 'Central'
            if pZone == 'sandy_checkin' then
              hospital = 'Sandy'
            end
            loadAnimDict('anim@narcotics@trash')
            TaskPlayAnim(PlayerPedId(), 'anim@narcotics@trash', 'drop_front', 1.0, 1.0, -1, 1, 0, 0,
                         0, 0)
            local finished = exports['ev-taskbar']:taskBar(1700,
                                                           (pDoctors > 0 and
                                                               not hospitals[hospital].isTriageEnabled) and
                                                               _L("healthcare-task-paging", "Paging a doctor") or
                                                               _L("healthcare-task-credentials", "Checking Credentials"))
            if finished == 100 then
              if pDoctors > 0 and not hospitals[hospital].isTriageEnabled then
                TriggerEvent("DoLHudText", "A doctor has been paged. Please take a seat and wait.", 1)
                TriggerServerEvent('phone:triggerPager', hospital)
              else
                local autoRevive = exports['ev-config']:GetMiscConfig('hospital.revives.auto')
                if autoRevive then
                  TriggerEvent('reviveFunction')
                  Wait(1000)
                end
                TriggerEvent('bed:checkin')
              end
              ClearPedTasksImmediately(PlayerPedId())
            end
          elseif pZone == 'hospital_character_switcher_staff' or pZone ==
              'central_character_switcher_backroom' or pZone == 'morgue_character_switcher_backroom' or
              pZone == 'parsons_character_switcher_backroom' then
            exports['ev-ui']:showContextMenu(zoneData[pZone].menuData)
          elseif pZone == 'hospital_armory' then
            local job = exports['isPed']:isPed('myjob')
            if job == 'doctor' or job == 'ems' or job == 'therapist' then
              TriggerEvent('server-inventory-open', '15', 'Shop')
            else
              TriggerEvent('server-inventory-open', '29', 'Shop')
            end
          end
        end
        Wait(0)
      end
    end)
  end
  
  AddEventHandler('ev-polyzone:enter', function(zone)
    local currentZone = zoneData[zone]
    if currentZone then -- and isCop
      currentPrompt = zone
      local prompt = currentZone.promptText
      local doctors = 0
  
      if zone == 'central_checkin' or zone == 'sandy_checkin' then
        doctors = getDoctorsOnline()
        local hosp = 'Central'
        if zone == 'sandy_checkin' then
          hosp = 'Sandy'
        end
        prompt = (doctors > 0 and not hospitals[hosp].isTriageEnabled) and _L("healthcare-page-doctor", "[E] Page a doctor") or prompt
      end
      exports['ev-ui']:showInteraction(prompt)
      listenForKeypress(zone, doctors)
    end
  end)
  
  AddEventHandler('ev-polyzone:exit', function(zone)
    if zoneData[zone] then
      exports['ev-ui']:hideInteraction()
      listening = false
      currentPrompt = nil
    end
  end)
  
  local acceptPings = true
  
  RegisterNetEvent('ev-healthcare:pageDoctor', function(hospital)
    TriggerEvent('phone:triggerPager', hospital, true)
    TriggerEvent(
      'chatMessage',
      "Hospital",
      { 30, 144, 255 },
      "You have been paged to" .. ' ' .. hospital .. ' ' .. "Hospital" .. '.',
      "feed",
      false,
      { i18n = { "You have been paged to", "Hospital" } }
    )
  end)
  
  RegisterNetEvent('ev-healthcare:patientSpawned', function(roomId)
    if not ensurePermission(true) or not acceptPings then
      return
    end
    local room = getICURoomSpawn(roomId)
    TriggerEvent('chatMessage', _L("healthcare-text-patients", "Patients"), { 30, 144, 255 },
                 'An ICU patient has awoken in ' .. room.name, "feed", false, { i18n = { "An ICU patient has awoken in" } })
  end)
  
  RegisterNetEvent('ev-healthcare:localRespawn', function(hospital)
    local job = exports['isPed']:isPed('myjob')
    if job ~= 'doctor' or not acceptPings then
      return
    end
    TriggerEvent('chatMessage', _L("healthcare-text-patients", "Patients"), { 30, 144, 255 },
                 'Local EMS have delivered a patient to ' .. hospital, "feed", false, { i18n = { "Local EMS have delivered a patient to" } })
  end)
  
  RegisterNetEvent('ev-healthcare:togglePings', function(pArgs)
    if pArgs[2] == 'true' then
      acceptPings = true
    elseif pArgs[2] == 'false' then
      acceptPings = false
    else
      acceptPings = not acceptPings
    end
    TriggerEvent('DoLongHudText', _L("healthcare-toggle-pings", "Toggled hospital pings") .. ' (' .. tostring(acceptPings) .. ')')
  end)
  
  -- board room
  local boardRoomUrl = nil
  local boardRoomDui = nil
  local inRoom = false
  
  AddEventHandler("ev-polyzone:enter", function (name)
    if name == "central_board_room" then
      inRoom = true
      if not boardRoomUrl then
        boardRoomUrl = RPC.execute("ev-healthcare:getBoardRoomUrl")
      end
      boardRoomDui = exports["ev-lib"]:getDui(boardRoomUrl, 512, 512)
      AddReplaceTexture("xm_prop_x17_tv_flat_01", "script_rt_tv_flat_01", boardRoomDui.dictionary, boardRoomDui.texture)
    end
  end)
  
  AddEventHandler("ev-polyzone:exit", function (name)
    if name == "central_board_room" then
      inRoom = false
      if boardRoomDui then
        exports["ev-lib"]:releaseDui(boardRoomDui.id)
        boardRoomDui = nil
      end
      RemoveReplaceTexture("xm_prop_x17_tv_flat_01", "script_rt_tv_flat_01")
    end
  end)
  
  AddEventHandler("onResourceStop", function (resourceName)
    if resourceName == GetCurrentResourceName() then
      if boardRoomDui then
        exports["ev-lib"]:releaseDui(boardRoomDui.id)
        boardRoomDui = nil
      end
      RemoveReplaceTexture("xm_prop_x17_tv_flat_01", "script_rt_tv_flat_01")
    end
  end)
  
  AddEventHandler("ev-healthcare:changeUrl", function ()
    exports['ev-ui']:openApplication('textbox', {
      callbackUrl = 'ev-healthcare:changeDuiUrl',
      inputKey = 1,
      items = {
        {
          icon = "circle",
          label = "URL",
          name = "url",
        },
      },
      show = true,
    })
  end)
  
  RegisterUICallback("ev-healthcare:changeDuiUrl", function(data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    exports['ev-ui']:closeApplication('textbox')
    if not data.values.url then return end
    TriggerServerEvent("ev-healthcare:updateBoardRoomUrl", data.values.url)
  end)
  
  RegisterNetEvent("ev-healthcare:boardRoomUrlUpdated")
  AddEventHandler("ev-healthcare:boardRoomUrlUpdated", function (url)
    boardRoomUrl = url
    if not inRoom then return end
    if not boardRoomDui then
      boardRoomDui = exports["ev-lib"]:getDui(boardRoomUrl, 512, 512)
      AddReplaceTexture("xm_prop_x17_tv_flat_01", "script_rt_tv_flat_01", boardRoomDui.dictionary, boardRoomDui.texture)
    else
      exports["ev-lib"]:releaseDui(boardRoomDui.id)
      RemoveReplaceTexture("xm_prop_x17_tv_flat_01", "script_rt_tv_flat_01")
      boardRoomDui = exports["ev-lib"]:getDui(boardRoomUrl, 512, 512)
      AddReplaceTexture("xm_prop_x17_tv_flat_01", "script_rt_tv_flat_01", boardRoomDui.dictionary, boardRoomDui.texture)
    end
  end)
  
  function ensurePermission(hideText)
    local job = exports['isPed']:isPed('myjob')
    if job == 'doctor' or job == 'ems' or job == 'therapist' then
      return true
    end
    if not hideText then
      TriggerEvent("DoLHudText", 2, "healthcare-no-permission", "You do not have permission for this.")
    end
    return false
  end
  
  function getICURoomsListOptions()
    local options = {}
    for k, v in ipairs(ICU_ROOMS) do
      options[#options + 1] = { id = k, name = v.name }
    end
    return options
  end
  
  function getICURoomSpawn(roomId)
    for k, v in pairs(ICU_ROOMS) do
      if k == roomId then
        return v
      end
    end
  end
  
  function getRoomsForCid(cid)
    local roomIds = RPC.execute('ev-healthcare:icu:rpc:getRooms', cid)
    local rooms = {};
    for k, v in pairs(roomIds) do
      rooms[#rooms + 1] = getICURoomSpawn(v)
    end
    return rooms
  end
  
  -- List Patients
  
  AddEventHandler('ev-healthcare:icu:listPatientsPrompt', function(args)
    if not ensurePermission() then
      return
    end
    exports['ev-ui']:openApplication('textbox', {
      callbackUrl = 'ev-healthcare:icu:ui:listPatients',
      inputKey = 'ev-healthcare:icu:ui:listPatients',
      items = {
        {
          _type = 'select',
          options = getICURoomsListOptions(biz),
          icon = 'user-edit',
          label = _L("healthcare-text-room", "Room"),
          name = 'room',
        },
      },
      show = true,
    });
  end)
  
  RegisterUICallback('ev-healthcare:icu:ui:listPatients', function(data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    exports['ev-ui']:closeApplication('textbox')
    local patients = RPC.execute('ev-healthcare:icu:rpc:getPatients', data.values.room)
    if #patients == 0 then
      TriggerEvent('chatMessage', _L("healthcare-text-patients", "Patients"), { 30, 144, 255 }, _L("healthcare-text-no-patients", "This room has no patients"), "feed", false, { i18n = { "This room has no patients" } })
    else
      TriggerEvent('chatMessage', _L("healthcare-text-patients", "Patients"), { 30, 144, 255 }, table.concat(patients, ', '))
    end
  end)
  
  -- Add patients
  
  AddEventHandler('ev-healthcare:icu:addPatientPrompt', function(args)
    if not ensurePermission() then
      return
    end
  
    exports['ev-ui']:openApplication('textbox', {
      callbackUrl = 'ev-healthcare:icu:ui:addPatient',
      inputKey = 'ev-healthcare:icu:ui:addPatient',
      items = {
        {
          _type = 'select',
          options = getICURoomsListOptions(), 
          icon = 'user-edit',
          label = _L("healthcare-text-room", "Room"),
          name = 'room',
        }, { 
          icon = 'user-edit', 
          label = _L("healthcare-text-id", "Citizen ID"), 
          name = 'cid' 
        }, { 
          icon = 'user-edit', 
          label = _L("healthcare-text-name", "Patient Name"), 
          name = 'citname'  
        },
      },
      show = true,
    });
  end)
  
  RegisterUICallback('ev-healthcare:icu:ui:addPatient', function(data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    exports['ev-ui']:closeApplication('textbox')
    print(json.encode(data))
    RPC.execute('ev-healthcare:icu:rpc:addPatient', data.values.room, data.values.cid, data.values.main, data.values.citname )
  end)
  
  RegisterUICallback('ev-healthcare:icu:ui:getRooms', function(data, cb)
    local rooms = getRoomsForCid(data.cid)
    cb({ data = rooms, meta = { ok = true, message = '' } })
  end)
  
  -- Remove patient
  
  AddEventHandler('ev-healthcare:icu:removePatientPrompt', function(args)
    if not ensurePermission() then
      return
    end
    exports['ev-ui']:openApplication('textbox', {
      callbackUrl = 'ev-healthcare:icu:ui:removePatient',
      inputKey = 'ev-healthcare:icu:ui:removePatient',
      items = {
        {
          _type = 'select',
          options = getICURoomsListOptions(),
          icon = 'user-edit',
          label = _L("healthcare-text-room", "Room"),
          name = 'room',
        }, { icon = 'user-edit', label = _L("healthcare-text-id", "Citizen ID"), name = 'cid' },
      },
      show = true,
    });
  end)
  
  RegisterUICallback('ev-healthcare:icu:ui:removePatient', function(data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    exports['ev-ui']:closeApplication('textbox')
    local success = RPC.execute('ev-healthcare:icu:rpc:removePatient', data.values.room,
                                data.values.cid)
    if success then
      TriggerEvent("DoLHudText", 1, "healthcare-remove-patient", "Successfully removed patient.")
    else
      TriggerEvent("DoLHudText", 2, "healthcare-remove-patient-error", "Unable to remove patient.")
    end
  end)
  
  -- Clear patients
  
  AddEventHandler('ev-healthcare:icu:clearPatientsPrompt', function(args)
    if not ensurePermission() then
      return
    end
    exports['ev-ui']:openApplication('textbox', {
      callbackUrl = 'ev-healthcare:icu:ui:clearPatients',
      inputKey = 'ev-healthcare:icu:ui:clearPatients',
      items = {
        {
          _type = 'select',
          options = getICURoomsListOptions(),
          icon = 'user-edit',
          label = _L("healthcare-text-room", "Room"),
          name = 'room',
        },
      },
      show = true,
    });
  end)
  
  RegisterUICallback('ev-healthcare:icu:ui:clearPatients', function(data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    exports['ev-ui']:closeApplication('textbox')
    RPC.execute('ev-healthcare:icu:rpc:clearPatients', data.values.room)
    TriggerEvent("DoLHudText", 1, "healthcare-patients-cleared", "Patients cleared.")
  end)

RegisterNetEvent('ev-healthcare:icu:client:showPatients')
AddEventHandler('ev-healthcare:icu:client:showPatients', function(patients)
    local elements = {}
    for k,v in pairs(patients) do
        table.insert(elements, {label = v.name .. ' - ' .. v.cid, value = v.cid})
    end
    exports['ev-ui']:openApplication('list', {
        callbackUrl = 'ev-healthcare:icu:ui:showPatients',
        inputKey = 'ev-healthcare:icu:ui:showPatients',
        items = elements,
        show = true,
    });
end)

RegisterUICallback('ev-healthcare:icu:ui:showPatients', function(data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    exports['ev-ui']:closeApplication('list')
    local cid = data.values.value
    local rooms = RPC.execute('ev-healthcare:icu:rpc:getRooms', cid)
    local elements = {}
    for k,v in pairs(rooms) do
        table.insert(elements, {label = ICU_ROOMS[v].name, value = v})
    end
    exports['ev-ui']:openApplication('list', {
        callbackUrl = 'ev-healthcare:icu:ui:showPatientsRooms',
        inputKey = 'ev-healthcare:icu:ui:showPatientsRooms',
        items = elements,
        show = true,
    });
end)

RegisterUICallback('ev-healthcare:icu:ui:showPatientsRooms', function(data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    exports['ev-ui']:closeApplication('list')
    local cid = data.values.value
    local room = data.values.value2
    local patients = RPC.execute('ev-healthcare:icu:rpc:getPatients', room)
    local elements = {}
    for k,v in pairs(patients) do
        table.insert(elements, {label = v, value = v})
    end
    exports['ev-ui']:openApplication('list', {
        callbackUrl = 'ev-healthcare:icu:ui:showPatientsList',
        inputKey = 'ev-healthcare:icu:ui:showPatientsList',
        items = elements,
        show = true,
    });
end)

RegisterUICallback('ev-healthcare:icu:ui:showPatientsList', function(data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    exports['ev-ui']:closeApplication('list')
    local cid = data.values.value
    local room = data.values.value2
    local patient = data.values.value3
    local elements = {
        {icon = 'user-edit', label = _L("healthcare-text-id", "Citizen ID"), name = 'cid', value = cid, disabled = true},
        {icon = 'user-edit', label = _L("healthcare-text-room", "Room"), name = 'room', value = ICU_ROOMS[room].name, disabled = true},
        {icon = 'user-edit', label = _L("healthcare-text-name", "Patient Name"), name = 'citname', value = patient, disabled = true},
    }
    exports['ev-ui']:openApplication('textbox', {
        callbackUrl = 'ev-healthcare:icu:ui:showPatientsInfo',
        inputKey = 'ev-healthcare:icu:ui:showPatientsInfo',
        items = elements,
        show = true,
    });
end)

RegisterUICallback('ev-healthcare:icu:ui:showPatientsInfo', function(data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    exports['ev-ui']:closeApplication('textbox')
end)

RegisterNetEvent('ev-healthcare:icu:client:showPatientsInfo')
AddEventHandler('ev-healthcare:icu:client:showPatientsInfo', function(patients)
    local elements = {}
    for k,v in pairs(patients) do
        table.insert(elements, {label = v.name .. ' - ' .. v.cid, value = v.cid})
    end
    exports['ev-ui']:openApplication('list', {
        callbackUrl = 'ev-healthcare:icu:ui:showPatients',
        inputKey = 'ev-healthcare:icu:ui:showPatients',
        items = elements,
        show = true,
    });
end)
  
exports('getICURoomSpawn', getICURoomSpawn)
  