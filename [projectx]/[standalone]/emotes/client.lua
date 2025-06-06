RegisterNetEvent('printEmoteList');
RegisterNetEvent('animation:Cop');
RegisterNetEvent('animation:Sit');
RegisterNetEvent('animation:Kneel');
RegisterNetEvent('animation:Medic');
RegisterNetEvent('animation:Notepad');
RegisterNetEvent('animation:Traffic');
RegisterNetEvent('animation:Photo');
RegisterNetEvent('animation:Clipboard');
RegisterNetEvent('animation:Lean');
RegisterNetEvent('animation:Smoke');
RegisterNetEvent('animation:Drink');
RegisterNetEvent('animation:Cancel');
RegisterNetEvent('stuckincar');
playing_emote = false;
local smoking = false
local AnimSet = "default"
stuckincar = false


exports("GetAnimSet", function()
  return AnimSet
end)

-- local isInteractivePlaying = false
-- local interactiveData = {}
AddEventHandler('stuckincar',
                function(statusupdated) stuckincar = statusupdated end)

RegisterNetEvent('doAnim');
AddEventHandler('doAnim', function(anim)
    TriggerEvent("animation:PlayAnimation", anim)
end)

AddEventHandler('playCancel', function() endanims("cancel") end)

AddEventHandler('animation:cancel', function() endanims("cancel") end)

AddEventHandler('animation:c', function() endanims("cancel") end)

-- GetEntityAnimCurrentTime(PlayerPedId(),dict,name) <= 0.95
local lastanimplayed = "none"

local restrictedEmotes = {
    ["weights"] = true
}

local emoteCooldowns = {}

function endanims(curanim)
    if stuckincar then return end

    ped = PlayerPedId();

    if DoesEntityExist(obj) then

        DeleteObject(obj)
        obj = 0
    end

    if ped then

        ClearPedTasks(ped);
        playing_emote = false

        ClearPedTasks(ped);
        playing_emote = false
        TriggerEvent("animation:gotCanceled")
        TriggerEvent("turnoffsitting")
        TriggerEvent("destroyProp")
        TriggerEvent("destroyProp69")
        TriggerEvent("destroyPropPerm")
        TriggerEvent("stripclub:stressLoss", false)
        TriggerEvent("firedepartment:forceStop")
        inanimation = false

    end

end

function cancelAnim(ped)
    ClearPedTasks(ped)
    playing_emote = false
    TriggerEvent("fixprone")
    endanims("cancel")
end

local tempenabled = false
local tempset = "move_m@injured"
RegisterNetEvent('AnimSet:Set:temp');
AddEventHandler('AnimSet:Set:temp', function(enabled, enabledSet)
    tempenabled = enabled
    tempset = enabledSet
    TriggerEvent("AnimSet:Set")
end)

RegisterNetEvent('AnimSet:Set');
AddEventHandler('AnimSet:Set', function()
    if tempenabled then
        RequestAnimSet(tempset)
        while not HasAnimSetLoaded(tempset) do Citizen.Wait(0) end
        SetPedMovementClipset(PlayerPedId(), tempset)
        SetPedWeaponMovementClipset(PlayerPedId(), tempset)
        ResetPedStrafeClipset(PlayerPedId())
    else
        if AnimSet == "default" then
            ResetPedMovementClipset(PlayerPedId())
            ResetPedWeaponMovementClipset(PlayerPedId())
            ResetPedStrafeClipset(PlayerPedId())
        else
            RequestAnimSet(AnimSet)
            while not HasAnimSetLoaded(AnimSet) do Citizen.Wait(0) end
            SetPedMovementClipset(PlayerPedId(), AnimSet)
            ResetPedWeaponMovementClipset(PlayerPedId())
            ResetPedStrafeClipset(PlayerPedId())
        end
    end
end)

RegisterNetEvent("emote:setAnimsFromDB");
AddEventHandler("emote:setAnimsFromDB", function(anim)
    if anim == "none" or anim == nil then return end
    if anim == "default" then
        ResetPedMovementClipset(PlayerPedId(), 0)
    else
        RequestAnimSet(anim)
        while not HasAnimSetLoaded(anim) do Citizen.Wait(0) end
        SetPedMovementClipset(PlayerPedId(), anim, true)
    end

    AnimSet = anim;
end)

AddEventHandler("playerSpawned", function()
    TriggerServerEvent("police:getAnimData")
    TriggerServerEvent("police:getEmoteData")
    TriggerServerEvent("stocks:retrieveclientstocks")
end)


RegisterNetEvent('AnimSet:default');
AddEventHandler('AnimSet:default', function()
    ResetPedMovementClipset(PlayerPedId(), 0)
    AnimSet = "default";
    TriggerServerEvent("police:setAnimData", AnimSet)
end)

RegisterNetEvent("Animation:Set:Gait")
AddEventHandler("Animation:Set:Gait", function(pArgs)
    local setGait = pArgs[1]
    RequestAnimSet(setGait)
    while not HasAnimSetLoaded(setGait) do Citizen.Wait(1) end
    SetPedMovementClipset(PlayerPedId(), setGait, 0.2)
    AnimSet = setGait
    TriggerServerEvent("police:setAnimData", AnimSet)
    if setGait == "move_m@swagger" then
      if exports["ev-inventory"]:hasEnoughOfItem("pimpcane", 1) then
        TriggerEvent("ev-propattach:attach", "prop_cs_walking_stick")
      end
    end
end)

RegisterNetEvent("Animation:Set:Reset")
AddEventHandler("Animation:Set:Reset", function()
    TriggerEvent("Animation:Set:Gait",{AnimSet})
end)


function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(0)
    end
end

imdead = 0
RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
    if imdead == 0 then
        imdead = 1
    else
        beingDragged = false
        dragging = false
        imdead = 0
    end
end)
obj = 0
holstered = false
inanimation = false
anims = {
    ["kneel"] = "CODE_HUMAN_MEDIC_KNEEL",
    ["medic"] = "CODE_HUMAN_MEDIC_TEND_TO_DEAD",
    ["traffic"] = "WORLD_HUMAN_CAR_PARK_ATTENDANT",
    ["binoculars"] = "WORLD_HUMAN_BINOCULARS",
    ["bum"] = "WORLD_HUMAN_BUM_FREEWAY",
    ["bumstand"] = "WORLD_HUMAN_BUM_STANDING",
    ["wash"] = "WORLD_HUMAN_BUM_WASH",
    ["cheer"] = "WORLD_HUMAN_CHEERING",
    ["drill"] = "WORLD_HUMAN_CONST_DRILL",
    ["dealer"] = "WORLD_HUMAN_DRUG_DEALER",
    ["filmshocking"] = "WORLD_HUMAN_MOBILE_FILM_SHOCKING",
    ["leafblower"] = "WORLD_HUMAN_GARDENER_LEAF_BLOWER",
    ["gardening"] = "WORLD_HUMAN_GARDENER_PLANT",
    ["guardpatrol"] = "WORLD_HUMAN_GUARD_PATROL",
    ["hammering"] = "WORLD_HUMAN_HAMMERING",
    ["hangout"] = "WORLD_HUMAN_HANG_OUT_STREET",
    ["statue"] = "WORLD_HUMAN_HUMAN_STATUE",
    ["janitor"] = "WORLD_HUMAN_JANITOR",
    ["jog"] = "WORLD_HUMAN_JOG_STANDING",
    ["maid"] = "WORLD_HUMAN_MAID_C",
    ["flex"] = "WORLD_HUMAN_MUSCLE_FLEX",
    ["weights"] = "WORLD_HUMAN_MUSCLE_FREE_WEIGHTS",
    ["musician"] = "WORLD_HUMAN_MUSICIAN",
    ["party"] = "WORLD_HUMAN_PARTYING",
    ["pushups"] = "WORLD_HUMAN_PUSH_UPS",
    ["shinetorch"] = "WORLD_HUMAN_SECURITY_SHINE_TORCH",
    ["weed"] = "WORLD_HUMAN_SMOKING_POT",
    ["impatient"] = "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT",
    ["map"] = "WORLD_HUMAN_TOURIST_MAP",
    ["mechanic"] = "WORLD_HUMAN_VEHICLE_MECHANIC",
    ["welding"] = "WORLD_HUMAN_WELDING",
    ["browse"] = "WORLD_HUMAN_WINDOW_SHOP_BROWSE",
    ["yoga"] = "WORLD_HUMAN_YOGA",
    ["cheer1"] = {
        t = 1,
        a = "backslap_right",
        d = "anim@mp_player_intcelebrationpaired@f_f_backslap"
    },
    ["cheer2"] = {
        t = 1,
        a = "bro_hug_left",
        d = "anim@mp_player_intcelebrationpaired@f_m_bro_hug"
    },
    ["high5"] = {t = 1, a = "highfive_guy_a", d = "mp_ped_interaction"},
    ["arsepick"] = {
        t = 1,
        a = "mp_player_int_arse_pick",
        d = "mp_player_int_upperarse_pick",
        e = "mp_player_int_arse_pick_exit"
    },
    ["ballgrab"] = {
        t = 1,
        a = "mp_player_int_grab_crotch",
        d = "mp_player_int_uppergrab_crotch",
        e = "mp_player_int_grab_crotch_exit"
    },
    ["gangsign3"] = {
        t = 1,
        a = "mp_player_int_bro_love",
        d = "mp_player_int_upperbro_love",
        e = "mp_player_int_bro_love_exit"
    },
    ["fuckyou"] = {
        t = 1,
        a = "mp_player_int_v_sign",
        d = "mp_player_int_upperv_sign",
        e = "mp_player_int_v_sign_exit"
    },

    ["c"] = function(ped)
        if exports["ev-flags"]:HasPedFlag(PlayerPedId(), 'isSittingOnChair') then
          TriggerEvent("ev-emotes:sitOnChair")
        elseif exports["ev-flags"]:HasPedFlag(PlayerPedId(), 'isPoledancing') then
          TriggerEvent("poledance:toggle")
        else
          ClearPedTasks(ped)
          playing_emote = false
          TriggerEvent("fixprone")
          endanims("cancel")
        end
    end,
    ["cancel"] = cancelAnim,
    ["holster"] = function(ped)

        local ped = PlayerPedId()
        if not holstered then
            holstered = true
            loadAnimDict("reaction@intimidation@cop@unarmed")
            TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "intro", 1.0,
                         1.0, -1, 50, 2.0, 0, 0, 0)
            TriggerEvent("actionbar:setEmptyHanded")
        else
            holstered = false
            ClearPedTasks(ped)
        end

    end,

    ["notepad"] = function(ped) TriggerEvent("notepad") end,

    ["clipboard"] = function(ped)
      local testdic = "move_m@clipboard"
      local testanim = "idle"

      if IsPedArmed(ped, 7) then
          TriggerEvent("actionbar:setEmptyHanded")
      end

      RequestAnimDict(testdic)
      while not HasAnimDictLoaded(testdic) and not handCuffed do
          Citizen.Wait(0)
      end

      if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
          ClearPedSecondaryTask(ped)
      else
          local animLength = GetAnimDuration(testdic, testanim)
          TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 49, 0, 0,
                       0, 0)
          TriggerEvent("destroyProp")
      end
      TriggerEvent("attachItem", "clipboard01")
    end,

    ["coffee"] = function(ped)
      local testdic = "amb@world_human_drinking@coffee@male@idle_a"
      local testanim = "idle_c"

      if IsPedArmed(ped, 7) then
          TriggerEvent("actionbar:setEmptyHanded")
      end

      RequestAnimDict(testdic)
      while not HasAnimDictLoaded(testdic) and not handCuffed do
          Citizen.Wait(0)
      end

      if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
          ClearPedSecondaryTask(ped)
      else
          local animLength = GetAnimDuration(testdic, testanim)
          TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 49, 0, 0,
                       0, 0)
          TriggerEvent("destroyProp")
      end
      TriggerEvent("attachItem", "coffee")
    end,

    ["phone"] = function(ped)
      local testdic = "cellphone@"
      local testanim = "cellphone_text_read_base"

      if IsPedArmed(ped, 7) then
          TriggerEvent("actionbar:setEmptyHanded")
      end

      RequestAnimDict(testdic)
      while not HasAnimDictLoaded(testdic) and not handCuffed do
          Citizen.Wait(0)
      end

      if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
          ClearPedSecondaryTask(ped)
      else
          local animLength = GetAnimDuration(testdic, testanim)
          TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 49, 0, 0, 0, 0)
          TriggerEvent("destroyProp")
      end
      TriggerEvent("attachItem", "phone01")
    end,

    ["widephone"] = function(ped)
        local testdic = "yoinks@musclephone"
        local testanim = "musclephone_clip"
  
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end
  
        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end
  
        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 49, 0, 0, 0, 0)
            TriggerEvent("destroyProp")
        end
        TriggerEvent("attachItem", "phone01")
      end,

    ["tennis"] = function(ped)
      local testdic = "amb@world_human_tennis_player@male@base"
      local testanim = "base"

      if IsPedArmed(ped, 7) then
          TriggerEvent("actionbar:setEmptyHanded")
      end

      RequestAnimDict(testdic)
      while not HasAnimDictLoaded(testdic) and not handCuffed do
          Citizen.Wait(0)
      end

      if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
          ClearPedSecondaryTask(ped)
      else
          local animLength = GetAnimDuration(testdic, testanim)
          TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 49, 0, 0,
                       0, 0)
          TriggerEvent("destroyProp")
      end
      TriggerEvent("attachItem", "tennis")
    end,
    ["stupor"] = function(ped)
      local testdic = "amb@world_human_stupor@male_looking_right@base"
      local testanim = "base"

      if IsPedArmed(ped, 7) then
          TriggerEvent("actionbar:setEmptyHanded")
      end

      RequestAnimDict(testdic)
      while not HasAnimDictLoaded(testdic) and not handCuffed do
          Citizen.Wait(0)
      end

      if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
          ClearPedSecondaryTask(ped)
      else
          local animLength = GetAnimDuration(testdic, testanim)
          TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                        0, 0)
      end
    end,
    ["piss"] = function(ped)
      RequestAnimDict("missbigscore1switch_trevor_piss")
      while not HasAnimDictLoaded("missbigscore1switch_trevor_piss") do
          Citizen.Wait(0)
      end
      if IsEntityPlayingAnim(ped, "missbigscore1switch_trevor_piss",
                             "piss_loop", 3) then
          ClearPedTasks(ped)
      else
          TaskPlayAnim(ped, "missbigscore1switch_trevor_piss", "piss_loop",
                       1.0, 1.0, -1, 9, -1, 0, 0, 0)
      end
    end,

    ["shit"] = function(ped)
      local testdic = "missfbi3ig_0"
      local testanim = "shit_loop_trev"

      if IsPedArmed(ped, 7) then
          TriggerEvent("actionbar:setEmptyHanded")
      end

      RequestAnimDict(testdic)
      while not HasAnimDictLoaded(testdic) and not handCuffed do
          Citizen.Wait(0)
      end

      if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
          ClearPedSecondaryTask(ped)
      else
          local animLength = GetAnimDuration(testdic, testanim)
          TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                       0, 0)
      end
    end,
    ["shower"] = function(ped)
        RequestAnimDict("mp_safehouseshower@male@")
        while not HasAnimDictLoaded("mp_safehouseshower@male@") do
            Citizen.Wait(0)
        end
        if IsEntityPlayingAnim(ped, "mp_safehouseshower@male@",
                               "male_shower_idle_a", 3) then
            ClearPedTasks(ped)
        else
            TaskPlayAnim(ped, "mp_safehouseshower@male@", "male_shower_idle_a",
                         1.0, 1.0, -1, 9, -1, 0, 0, 0)
        end
    end,

    ["lean"] = function(ped)
        RequestAnimDict(
            "amb@world_human_leaning@male@wall@back@legs_crossed@base")
        while not HasAnimDictLoaded(
            "amb@world_human_leaning@male@wall@back@legs_crossed@base") do
            Citizen.Wait(0)
        end
        if IsEntityPlayingAnim(ped,
                               "amb@world_human_leaning@male@wall@back@legs_crossed@base",
                               "base", 3) then
            ClearPedTasks(ped)
        else
            TriggerEvent("stripclub:stressLoss", true)
            TaskPlayAnim(ped,
                         "amb@world_human_leaning@male@wall@back@legs_crossed@base",
                         "base", 1.0, 1.0, -1, 9, -1, 0, 0, 0)
        end
    end,

    ["chinups"] = function(ped)
        RequestAnimDict("amb@prop_human_muscle_chin_ups@male@base")
        while not HasAnimDictLoaded("amb@prop_human_muscle_chin_ups@male@base") do
            Citizen.Wait(0)
        end
        if IsEntityPlayingAnim(ped, "amb@prop_human_muscle_chin_ups@male@base",
                               "base", 3) then
            ClearPedTasks(ped)
        else
            TaskPlayAnim(ped, "amb@prop_human_muscle_chin_ups@male@base",
                         "base", 1.0, 1.0, -1, 9, -1, 0, 0, 0)
        end
        playing_emote = false
    end,

    ["situps"] = function(ped)

        RequestAnimDict("amb@world_human_sit_ups@male@idle_a")

        while not HasAnimDictLoaded("amb@world_human_sit_ups@male@idle_a") do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, "amb@world_human_sit_ups@male@idle_a",
                               "idle_a", 3) then
            ClearPedTasks(ped)
        else
            TaskPlayAnim(ped, "amb@world_human_sit_ups@male@idle_a", "idle_a",
                         1.0, 1.0, -1, 9, -1, 0, 0, 0)
        end

        playing_emote = false

    end,

    ["shrug3"] = function(ped)
        RequestAnimDict("oddjobs@bailbond_hobohang_out_street_b")
        while not HasAnimDictLoaded("oddjobs@bailbond_hobohang_out_street_b") do
            Citizen.Wait(0)
        end
        if IsEntityPlayingAnim(ped, "oddjobs@bailbond_hobohang_out_street_b",
                               "idle_b", 3) then
            ClearPedTasks(ped)
        else
            TaskPlayAnim(ped, "oddjobs@bailbond_hobohang_out_street_b",
                         "idle_b", 1.0, 1.0, -1, 9, -1, 0, 0, 0)
        end
        playing_emote = false
    end,

    ["search"] = function(ped)

        local testdic = "missexile3"
        local testanim = "ex03_dingy_search_case_a_michael"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)

        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, -1, 0,
                         0, 0)
        end
        playing_emote = false
    end,

    ["kneel3"] = function(ped)

        local testdic = "oddjobs@hunter"
        local testanim = "idle_a"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)

        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 0.7, 0.7, 1.0, 1, -1, 0, 0, 0)
        end
        playing_emote = false
    end,
    ["uncuff"] = function(ped)
        local testdic = "mp_arresting"
        local testanim = "a_uncuff"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)

        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, 3000, 16, -1, 0,
                         0, 0)
        end
        playing_emote = false
    end,
    ["trunk"] = function(ped)

        local testdic = "fin_ext_p1-7"
        local testanim = "cs_devin_dual-7"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)

        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, -1, 0,
                         0, 0)
        end
        playing_emote = false
    end,

    ["lighter"] = function(ped)

        local testdic = "cover@first_person@weapon@grenade"
        local testanim = "hi_l_cook"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)

        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 48, -1,
                         0, 0, 0)
        end
        playing_emote = false
    end,

    ["kickindoor"] = function(ped)

        local testdic = "missprologuemcs_1"
        local testanim = "kick_down_player_zero"

        RequestAnimDict(testdic)

        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, -1, 0,
                         0, 0)
        end
        Citizen.Wait(1500)
        ClearPedTasks(PlayerPedId())
        playing_emote = false
    end,

    ["stretch5"] = function(ped)

        local testdic = "switch@franklin@bed"
        local testanim = "stretch_short"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)

        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 48, -1,
                         0, 0, 0)
        end
        playing_emote = false
    end,

    ["pill"] = function(ped)
        Citizen.Wait(200)
        local pos = GetOffsetFromEntityInWorldCoords(ped, 0.1, 0.1, 1.0)

        RequestAnimDict("mp_suicide")
        while not HasAnimDictLoaded("mp_suicide") do Citizen.Wait(0) end

        TaskPlayAnim(ped, "mp_suicide", "pill", 8.0, 8.0, 1.0, 48, -1, 0, 0, 0)
        Citizen.Wait(2800)
        ClearPedTasks(PlayerPedId())

        playing_emote = false
    end,

    ["stretch2"] = function(ped)

        local testdic = "switch@franklin@bed"
        local testanim = "stretch_long"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)

        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 48, -1,
                         0, 0, 0)
        end
        playing_emote = false
    end,

    ["getup"] = function(ped)

        local testdic = "switch@franklin@bed"
        local testanim = "sleep_getup_rubeyes"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)

        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)

            local pronepos = GetEntityCoords(PlayerPedId())
            TaskPlayAnim(ped, testdic, testanim, 100.0, 1.0, -1, 8, -1, 0, 0, 0)

            -- TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 8, -1, 0, 0, 0)
        end
        playing_emote = false
    end,

    ["layspike"] = function(ped)

        local testdic =
            "weapons@first_person@aim_rng@generic@projectile@thermal_charge@"
        local testanim = "plant_floor"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)

        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, -1, 48, -1, 0, 0, 0)
        end
        playing_emote = false
    end,

    ["layspike2"] = function(ped)

        local testdic =
            "weapons@first_person@aim_rng@generic@projectile@thermal_charge@"
        local testanim = "plant_floor"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)

        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, -1, 0, -1, 0, 0, 0)
        end
        playing_emote = false
    end,

    ["hairtie"] = function(ped)

        local testdic =
            "amb@code_human_wander_idles@female@idle_a"
        local testanim = "idle_a_hairtouch"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)

        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, -1, 48, -1, 0, 0, 0)
        end
        playing_emote = false
    end,

    ["veston"] = function(ped)

        local testdic =
            "clothingtie"
        local testanim = "try_tie_positive_a"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)

        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, -1, 48, -1, 0, 0, 0)
        end
        playing_emote = false
    end,

    ["dab"] = function(ped)

        local testdic = "amb@world_human_statue@base"
        local testanim = "base"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)

        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        local animLength = GetAnimDuration(testdic, testanim)
        TaskPlayAnim(ped, testdic, testanim, 3.0, 3.0, -1, 48, -1, 0, 0, 0)
        Citizen.Wait(500)
        ClearPedSecondaryTask(ped)

        playing_emote = false
    end,

    ["cokecut"] = function(ped)

        local testdic = "anim@amb@business@coc@coc_unpack_cut@"
        local testanim = "fullcut_cycle_v6_cokecutter"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)

        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, -1, 1, -1, 0, 0, 0)
        end
        playing_emote = false
    end,

    ["beg"] = function(ped)

        local testdic = "oddjobs@bailbond_mountain"
        local testanim = "excited_idle_b"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)

        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 49, -1,
                         0, 0, 0)
        end

    end,
    
    ["searchground"] = function(ped)

        local testdic = "clothingshoes"
        local testanim = "try_shoes_positive_a"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 49, 0, 0,
                         0, 0)
        end

    end,
    ["taxi"] = function(ped)

        local testdic = "taxi_hail"
        local testanim = "hail_taxi"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 48, 0, 0,
                         0, 0)
        end
        TriggerEvent("taxi:slownearest")
        playing_emote = false
    end,

    ["forgetit"] = function(ped)

        local testdic = "taxi_hail"
        local testanim = "forget_it"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 48, 0, 0,
                         0, 0)
        end
        playing_emote = false
    end,

    ["cop"] = function(ped)
        RequestAnimDict("amb@world_human_cop_idles@male@idle_a")
        while not HasAnimDictLoaded("amb@world_human_cop_idles@male@idle_a") do
            Citizen.Wait(0)
        end
        if IsEntityPlayingAnim(ped, "amb@world_human_cop_idles@male@idle_a",
                               "idle_b", 3) then
            ClearPedTasks(ped)
        else
            TriggerEvent("stripclub:stressLoss", true)
            TaskPlayAnim(ped, "amb@world_human_cop_idles@male@idle_a", "idle_b",
                         1.0, 1.0, -1, 9, -1, 0, 0, 0)
        end
    end,

    ["cross"] = function(ped)
        RequestAnimDict(
            "amb@world_human_hang_out_street@female_arms_crossed@base")
        while not HasAnimDictLoaded(
            "amb@world_human_hang_out_street@female_arms_crossed@base") do
            Citizen.Wait(0)
        end
        if IsEntityPlayingAnim(ped,
                               "amb@world_human_hang_out_street@female_arms_crossed@base",
                               "base", 3) then
            ClearPedTasks(ped)
        else
            TriggerEvent("stripclub:stressLoss", true)
            TaskPlayAnim(ped,
                         "amb@world_human_hang_out_street@female_arms_crossed@base",
                         "base", 1.0, 1.0, -1, 9, -1, 0, 0, 0)
        end
    end,

    ["cowerlow"] = function(ped)
        RequestAnimDict("amb@code_human_cower@male@base")
        while not HasAnimDictLoaded("amb@code_human_cower@male@base") do
            Citizen.Wait(0)
        end
        if IsEntityPlayingAnim(ped, "amb@code_human_cower@male@base", "base", 3) then
            ClearPedTasks(ped)
        else
            TriggerEvent("stripclub:stressLoss", true)
            TaskPlayAnim(ped, "amb@code_human_cower@male@base", "base", 1.0,
                         1.0, -1, 9, -1, 0, 0, 0)
        end
    end,

    ["cower"] = function(ped)
        RequestAnimDict("amb@code_human_cower_stand@male@base")
        while not HasAnimDictLoaded("amb@code_human_cower_stand@male@base") do
            Citizen.Wait(0)
        end
        if IsEntityPlayingAnim(ped, "amb@code_human_cower_stand@male@base",
                               "base", 3) then
            ClearPedTasks(ped)
        else
            TriggerEvent("stripclub:stressLoss", true)
            TaskPlayAnim(ped, "amb@code_human_cower_stand@male@base", "base",
                         1.0, 1.0, -1, 32, -1, 0, 0, 0)
        end
    end,

    ["cowerkneel"] = function(ped)
        local testdic = "random@homelandsecurity"
        local testanim = "knees_loop_girl"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,

    ["aware"] = function(ped)
        RequestAnimDict("amb@code_human_cross_road@male@base")
        while not HasAnimDictLoaded("amb@code_human_cross_road@male@base") do
            Citizen.Wait(0)
        end
        if IsEntityPlayingAnim(ped, "amb@code_human_cross_road@male@base",
                               "base", 3) then
            ClearPedTasks(ped)
        else
            TriggerEvent("stripclub:stressLoss", true)
            TaskPlayAnim(ped, "amb@code_human_cross_road@male@base", "base",
                         1.0, 1.0, -1, 9, -1, 0, 0, 0)
        end
    end,

    ["ballscratch"] = function(ped)
        local testdic =
            "amb@code_human_in_car_mp_actions@grab_crotch@std@ds@base"
        local testanim = "idle_a"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 49, 0, 0,
                         0, 0)
        end
    end,

    ["cleanfront"] = function(ped)
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_MAID_CLEAN", 0, true)

        local playerped = PlayerPedId()
        local coordA = GetEntityCoords(playerped, 1)
        local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0,
                                                        0.0)
        local targetVehicle = getVehicleInDirection(coordA, coordB)
        if targetVehicle then
            local finished = false
            while not finished do
                local curL = GetVehicleDirtLevel(targetVehicle) - 0.3

                if curL < 0.0 then finished = true end
                if not playing_emote then finished = true end
                if not targetVehicle then finished = true end
                SetVehicleDirtLevel(targetVehicle, curL)
                Wait(1000)
            end
        end
        playing_emote = false
    end,

    ["lapdance1"] = function(ped)
        local testdic = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1"
        local testanim = "ld_girl_a_song_a_p1_f"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 32, 0, 0,
                         0, 0)
        end
    end,

    ["dancef"] = function(ped)
        local testdic = "anim@amb@nightclub@dancers@solomun_entourage@"
        local testanim = "mi_dance_facedj_17_v1_female^1"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,

    ["dancef2"] = function(ped)
        local testdic = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@"
        local testanim = "high_center"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,

    ["dancef3"] = function(ped)
        local testdic = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@"
        local testanim = "high_center_up"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["dancef4"] = function(ped)
        local testdic =
            "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity"
        local testanim = "hi_dance_facedj_09_v2_female^1"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["dancef5"] = function(ped)
        local testdic =
            "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity"
        local testanim = "hi_dance_facedj_09_v2_female^3"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["dancef6"] = function(ped)
        local testdic = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@"
        local testanim = "high_center_up"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["danceslow2"] = function(ped)
        local testdic = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@"
        local testanim = "low_center"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["danceslow3"] = function(ped)
        local testdic = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@"
        local testanim = "low_center_down"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["danceslow4"] = function(ped)
        local testdic = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@"
        local testanim = "low_center"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["dance"] = function(ped)
        local testdic = "anim@amb@nightclub@dancers@podium_dancers@"
        local testanim = "hi_dance_facedj_17_v2_male^5"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["dance2"] = function(ped)
        local testdic = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@"
        local testanim = "high_center_down"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["dance3"] = function(ped)
        local testdic = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@"
        local testanim = "high_center"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["dance4"] = function(ped)
        local testdic = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@"
        local testanim = "high_center_up"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["danceupper"] = function(ped)
        local testdic = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@"
        local testanim = "high_center"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["danceupper2"] = function(ped)
        local testdic = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@"
        local testanim = "high_center_up"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["danceshy"] = function(ped)
        local testdic = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@"
        local testanim = "low_center"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["danceshy2"] = function(ped)
        local testdic = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@"
        local testanim = "low_center_down"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["danceslow"] = function(ped)
        local testdic = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@"
        local testanim = "low_center"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["dancesilly9"] = function(ped)
        local testdic = "rcmnigel1bnmt_1b"
        local testanim = "dance_loop_tyler"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["dance6"] = function(ped)
        local testdic = "misschinese2_crystalmazemcs1_cs"
        local testanim = "dance_loop_tao"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["dance7"] = function(ped)
        local testdic = "misschinese2_crystalmazemcs1_ig"
        local testanim = "dance_loop_tao"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["dance8"] = function(ped)
        local testdic = "missfbi3_sniping"
        local testanim = "dance_m_default"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["dance88"] = function(ped)
        local testdic = "missfbi3_sniping"
        local testanim = "dance_m_default"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 49, 0, 0,
                         0, 0)
        end
    end,
    ["dancesilly"] = function(ped)
        local testdic = "special_ped@mountain_dancer@monologue_3@monologue_3a"
        local testanim = "mnt_dnc_buttwag"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["dancesilly2"] = function(ped)
        local testdic = "move_clown@p_m_zero_idles@"
        local testanim = "fidget_short_dance"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["dancesilly3"] = function(ped)
        local testdic = "move_clown@p_m_two_idles@"
        local testanim = "fidget_short_dance"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["dancesilly4"] = function(ped)
        local testdic = "anim@amb@nightclub@lazlow@hi_podium@"
        local testanim = "danceidle_hi_11_buttwiggle_b_laz"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["dancesilly5"] = function(ped)
        local testdic = "timetable@tracy@ig_5@idle_a"
        local testanim = "idle_a"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["dancesilly6"] = function(ped)
        local testdic = "timetable@tracy@ig_8@idle_b"
        local testanim = "idle_d"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["dance9"] = function(ped)
        local testdic = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@"
        local testanim = "med_center_up"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["dancesilly8"] = function(ped)
        local testdic = "anim@mp_player_intcelebrationfemale@the_woogie"
        local testanim = "the_woogie"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["dancesilly7"] = function(ped)
        local testdic = "anim@amb@casino@mini@dance@dance_solo@female@var_b@"
        local testanim = "high_center"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["dance5"] = function(ped)
        local testdic = "anim@amb@casino@mini@dance@dance_solo@female@var_a@"
        local testanim = "med_center"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
        end
    end,
    ["danceglowstick"] = function(ped)
        local testdic = "anim@amb@nightclub@lazlow@hi_railing@"
        local testanim = "ambclub_13_mi_hi_sexualgriding_laz"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
            TriggerEvent("destroyProp")
            TriggerEvent("destroyProp69")
        end
        TriggerEvent("attachItem", "glowstickRight")
        TriggerEvent("attachItem69", "glowstickLeft")
    end,
    ["danceglowstick2"] = function(ped)
        local testdic = "anim@amb@nightclub@lazlow@hi_railing@"
        local testanim = "ambclub_12_mi_hi_bootyshake_laz"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
            TriggerEvent("destroyProp")
            TriggerEvent("destroyProp69")
        end
        TriggerEvent("attachItem", "glowstickRight")
        TriggerEvent("attachItem69", "glowstickLeft")
    end,
    ["danceglowstick3"] = function(ped)
        local testdic = "anim@amb@nightclub@lazlow@hi_railing@"
        local testanim = "ambclub_09_mi_hi_bellydancer_laz"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
            TriggerEvent("destroyProp")
            TriggerEvent("destroyProp69")
        end
        TriggerEvent("attachItem", "glowstickRight")
        TriggerEvent("attachItem69", "glowstickLeft")
    end,
    ["dancehorse"] = function(ped)
        local testdic = "anim@amb@nightclub@lazlow@hi_dancefloor@"
        local testanim = "dancecrowd_li_15_handup_laz"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
            TriggerEvent("destroyProp")
        end
        TriggerEvent("attachItem", "toyHorse")
    end,
    ["dancehorse2"] = function(ped)
        local testdic = "anim@amb@nightclub@lazlow@hi_dancefloor@"
        local testanim = "crowddance_hi_11_handup_laz"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
            TriggerEvent("destroyProp")
        end
        TriggerEvent("attachItem", "toyHorse")
    end,
    ["dancehorse3"] = function(ped)
        local testdic = "anim@amb@nightclub@lazlow@hi_dancefloor@"
        local testanim = "dancecrowd_li_11_hu_shimmy_laz"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 1, 0, 0,
                         0, 0)
            TriggerEvent("destroyProp")
        end
        TriggerEvent("attachItem", "toyHorse")
    end,

    ["conv1"] = function(ped)
        local testdic = "special_ped@jessie@monologue_5@monologue_5c"
        local testanim = "jessie_ig_1_p5_heressomthinginteresting_2"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 32, 0, 0,
                         0, 0)
        end
    end,

    ["conv2"] = function(ped)
        local testdic = "special_ped@jessie@monologue_11@monologue_11c"
        local testanim = "jessie_ig_1_p11_canyouimagine_2"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 32, 0, 0,
                         0, 0)
        end
    end,

    ["conv3"] = function(ped)
        local testdic = "rcmjosh4"
        local testanim = "beckon_a_cop_b"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 49, 0, 0,
                         0, 0)
        end
    end,

    ["cross2"] = function(ped)
        local testdic = "rcmme_amanda1"
        local testanim = "stand_loop_cop"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 49, 0, 0,
                         0, 0)
        end
    end,

    ["investigate"] = function(ped)
        local testdic = "amb@code_human_police_investigate@base"
        local testanim = "base"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 49, 0, 0,
                         0, 0)
        end
    end,

    ["umbrella"] = function(ped)
        if obj ~= 0 then

            DeleteObject(obj)
            obj = 0
            ClearPedTasks(ped)
        else
            TriggerEvent("destroyPropPerm")
            if exports["ev-inventory"]:hasEnoughOfItem("umbrella", 1) then

                TriggerEvent("actionbar:setEmptyHanded")

                local finished = exports["ev-taskbar"]:taskBar(2500,"Opening Umbrella")
                if finished == 100 then

                    loadAnimDict("amb@code_human_wander_drinking@male@base")

                    TaskPlayAnim(ped,"amb@code_human_wander_drinking@male@base", "static", 1.0, 1.0, -1, 49, 0, 0, 0, 0)

                    local random = math.random(1, 10)
                    local boneIndex = GetPedBoneIndex(ped, 0xfa70)
                    local bonePos = GetWorldPositionOfEntityBone(ped, boneIndex)

                    if random > 5 then
                        obj = CreateObject(`p_amb_brolly_01`, bonePos.x,bonePos.y, bonePos.z + 0.01, true,false, true)
                    else
                        obj = CreateObject(`p_amb_brolly_01_s`, bonePos.x,bonePos.y, bonePos.z + 0.01, true,false, true)
                    end

                    TriggerEvent("umbrellaLoop")

                    AttachEntityToEntity(obj, ped, GetPedBoneIndex(ped, 57005),0.1, 0, -0.025, -90.0, 90.0, 0.0, true,true, false, true, 1, true)
                end
            end
        end
    end,

    ["curse"] = function(ped)
        loadAnimDict('misscommon@response')
        TaskPlayAnim(PlayerPedId(), 'misscommon@response', 'curse', 0.6, 0.6,
                     1.0, 48, 0.0, 0, 0, 0)
        playing_emote = false
    end,
    ["taunt"] = function(ped)
        loadAnimDict('misscommon@response')
        TaskPlayAnim(PlayerPedId(), 'misscommon@response', 'threaten', 1.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
        playing_emote = false
    end,
    ["what"] = function(ped)
        loadAnimDict('misscommon@response')
        TaskPlayAnim(PlayerPedId(), 'misscommon@response', 'numbnuts', 0.6, 0.6,
                     1.0, 48, 0.0, 0, 0, 0)
        playing_emote = false
    end,
    ["break"] = function(ped)
        loadAnimDict('misscommon@response')
        TaskPlayAnim(PlayerPedId(), 'misscommon@response', 'give_me_a_break',
                     0.6, 0.6, 1.0, 48, 0.0, 0, 0, 0)
        playing_emote = false
    end,
    ["cmon"] = function(ped)
        loadAnimDict('misscommon@response')
        TaskPlayAnim(PlayerPedId(), 'misscommon@response', 'bring_it_on', 0.6,
                     0.6, 1.0, 48, 0.0, 0, 0, 0)
        playing_emote = false
    end,

    ["chair"] = function(ped)
        TriggerEvent("animation:chair")
    end,

    ["carry"] = function(ped) TriggerEvent("animation:Carry") end,

    ["shoosh"] = function(ped)

        loadAnimDict("anim@mp_player_intuppershush")
        TaskPlayAnim(PlayerPedId(), "anim@mp_player_intuppershush", "idle_a_fp",
                     2.0, 2.0, -1, 49, 0, 0, 0, 0)

        Citizen.Wait(2000)
        ClearPedSecondaryTask(ped)
        playing_emote = false
    end,

    ["picknose"] = function(ped)

        loadAnimDict("anim@mp_player_intuppernose_pick")
        TaskPlayAnim(PlayerPedId(), "anim@mp_player_intuppernose_pick", "exit",
                     2.0, 2.0, -1, 48, 0, 0, 0, 0)
        playing_emote = false
    end,
    ["wanker"] = function(ped)

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict("anim@mp_player_intselfiewank")
        while not HasAnimDictLoaded("anim@mp_player_intselfiewank") and
            not handCuffed do Citizen.Wait(0) end

        if IsEntityPlayingAnim(ped, "anim@mp_player_intselfiewank", "idle_a", 3) then
            -- TaskPlayAnim(ped, "anim@mp_player_intselfiewank", "idle_a", 1.0, 1.0, 1.0, 49, 0, 0, 0, 0)
            TaskPlayAnim(ped, "anim@mp_player_intselfiewank", "exit", -8, -8,
                         1.0, 48, 0, 0, 0, 0)
        else
            local animLength = GetAnimDuration("anim@mp_player_intselfiewank",
                                               "idle_a") * 1000
            TaskPlayAnim(ped, "anim@mp_player_intselfiewank", "idle_a", 2.0,
                         1.0, animLength, 49, 0, 0, 0, 0)
        end
        playing_emote = false
    end,

    ["id"] = function(ped)
        loadAnimDict('friends@laf@ig_5')
        TaskPlayAnim(PlayerPedId(), 'friends@laf@ig_5', 'nephew', 5.0, 1.0, 5.0,
                     48, 0.0, 0, 0, 0)
        playing_emote = false
    end,

    ["why"] = function(ped)
        loadAnimDict('gestures@m@standing@fat')
        TaskPlayAnim(PlayerPedId(), 'gestures@m@standing@fat', 'gesture_why',
                     5.0, 1.0, 5.0, 48, 0.0, 0, 0, 0)
        playing_emote = false
    end,

    ["hi"] = function(ped)
        loadAnimDict('gestures@m@standing@fat')
        TaskPlayAnim(PlayerPedId(), 'gestures@m@standing@fat', 'gesture_hello',
                     5.0, 1.0, 5.0, 48, 0.0, 0, 0, 0)
        playing_emote = false
    end,

    ["bye"] = function(ped)
        loadAnimDict('gestures@m@standing@fat')
        TaskPlayAnim(PlayerPedId(), 'gestures@m@standing@fat',
                     'gesture_bye_soft', 5.0, 1.0, 5.0, 48, 0.0, 0, 0, 0)
        playing_emote = false
    end,

    ["come"] = function(ped)
        loadAnimDict('gestures@m@standing@fat')
        TaskPlayAnim(PlayerPedId(), 'gestures@m@standing@fat',
                     'gesture_come_here_hard', 5.0, 1.0, 5.0, 48, 0.0, 0, 0, 0)
        playing_emote = false
    end,

    ["down"] = function(ped)
        loadAnimDict('gestures@m@standing@fat')
        TaskPlayAnim(PlayerPedId(), 'gestures@m@standing@fat',
                     'gesture_hand_down', 5.0, 1.0, 5.0, 48, 0.0, 0, 0, 0)
        playing_emote = false
    end,

    ["yes"] = function(ped)
        loadAnimDict('random@getawaydriver')
        TaskPlayAnim(PlayerPedId(), 'random@getawaydriver',
                     'gesture_nod_yes_hard', 5.0, 1.0, 5.0, 48, 0.0, 0, 0, 0)
        playing_emote = false
    end,

    ["swatcome"] = function(ped)
        loadAnimDict('swat')
        TaskPlayAnim(PlayerPedId(), 'swat', 'come', 5.0, 1.0, 5.0, 48, 0.0, 0,
                     0, 0)
        playing_emote = false
    end,

    ["swatfreeze"] = function(ped)
        loadAnimDict('swat')
        TaskPlayAnim(PlayerPedId(), 'swat', 'freeze', 5.0, 1.0, 5.0, 48, 0.0, 0,
                     0, 0)
        playing_emote = false
    end,

    ["swatrally"] = function(ped)
        loadAnimDict('swat')
        TaskPlayAnim(PlayerPedId(), 'swat', 'rally_point', 5.0, 1.0, 5.0, 48,
                     0.0, 0, 0, 0)
        playing_emote = false
    end,

    ["swatyes"] = function(ped)
        loadAnimDict('swat')
        TaskPlayAnim(PlayerPedId(), 'swat', 'understood', 5.0, 1.0, 5.0, 48,
                     0.0, 0, 0, 0)
        playing_emote = false
    end,
    ["swatback"] = function(ped)
        loadAnimDict('swat')
        TaskPlayAnim(PlayerPedId(), 'swat', 'you_back', 5.0, 1.0, 5.0, 48, 0.0,
                     0, 0, 0)
        playing_emote = false
    end,

    ["swatfwd"] = function(ped)
        loadAnimDict('swat')
        TaskPlayAnim(PlayerPedId(), 'swat', 'you_fwd', 5.0, 1.0, 5.0, 48, 0.0,
                     0, 0, 0)
        playing_emote = false
    end,

    ["swatleft"] = function(ped)
        loadAnimDict('swat')
        TaskPlayAnim(PlayerPedId(), 'swat', 'you_left', 5.0, 1.0, 5.0, 48, 0.0,
                     0, 0, 0)
        playing_emote = false
    end,

    ["swatright"] = function(ped)
        loadAnimDict('swat')
        TaskPlayAnim(PlayerPedId(), 'swat', 'you_right', 5.0, 1.0, 5.0, 48, 0.0,
                     0, 0, 0)
        playing_emote = false
    end,

    ["shocked"] = function(ped)
        local shocked = {}
        for i = 1, 7 do shocked[i] = {} end

        shocked[1]["dict"] = "reaction@male_stand@big_variations@idle_a"
        shocked[1]["anim"] = "react_big_variations_c"
        shocked[2]["dict"] = "reaction@male_stand@big_variations@idle_b"
        shocked[2]["anim"] = "react_big_variations_f"
        shocked[3]["dict"] = "reaction@male_stand@big_variations@idle_c"
        shocked[3]["anim"] = "react_big_variations_q"
        shocked[4]["dict"] = "reaction@male_stand@big_variations@idle_c"
        shocked[4]["anim"] = "react_big_variations_s"
        shocked[5]["dict"] = "reaction@male_stand@small_variations@idle_a"
        shocked[5]["anim"] = "react_small_variations_d"
        shocked[6]["dict"] = "reaction@male_stand@small_variations@idle_b"
        shocked[6]["anim"] = "react_small_variations_e"
        shocked[7]["dict"] = "reaction@male_stand@small_variations@idle_c"
        shocked[7]["anim"] = "react_small_variations_o"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        while playing_emote and not handCuffed do

            local emote = math.random(7)
            local dict = shocked[emote]["dict"]
            local anim = shocked[emote]["anim"]

            RequestAnimDict(dict)
            while not HasAnimDictLoaded(dict) do Citizen.Wait(0) end

            TaskPlayAnim(ped, dict, anim, 1.0, 1.0, -1, 49, 0, 0, 0, 0)
            Citizen.Wait(10000)

        end

    end,

    ["ziptied"] = function(ped)
        local testdic = "re@stag_do@idle_a"
        local testanim = "idle_a_ped"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 49, 0, 0,
                         0, 0)
        end
    end,

    ["breakzipties"] = function(ped)
        local testdic = "re@stag_do@idle_a"
        local testanim = "idle_c_ped"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 49, 0, 0,
                         0, 0)
        end
    end,

    ["wavedown"] = function(ped)
        local testdic = "random@mugging5"
        local testanim = "001445_01_gangintimidation_1_female_idle_b"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 49, 0, 0,
                         0, 0)
        end
    end,

    ["hitch"] = function(ped)
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict("random@hitch_lift")
        while not HasAnimDictLoaded("random@hitch_lift") and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, "random@hitch_lift", "idle_f", 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration("random@hitch_lift", "idle_f")
            TaskPlayAnim(ped, "random@hitch_lift", "idle_f", 2.0, 2.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,
    ["handsup2"] = function(ped)

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict("missfbi5ig_22")
        while not HasAnimDictLoaded("missfbi5ig_22") and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, "missfbi5ig_22",
                               "hands_up_anxious_scientist", 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict('missfbi5ig_22')
            TaskPlayAnim(PlayerPedId(), 'missfbi5ig_22',
                         'hands_up_anxious_scientist', 1.0, 1.0, 1.0, 49, 0.0,
                         0, 0, 0)
        end
    end,

    ["handsup3"] = function(ped)

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict("missfbi5ig_22")
        while not HasAnimDictLoaded("missfbi5ig_22") and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, "missfbi5ig_22", "hands_up_loop_scientist",
                               3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict('missfbi5ig_22')
            TaskPlayAnim(PlayerPedId(), 'missfbi5ig_22',
                         'hands_up_loop_scientist', 1.0, 1.0, 1.0, 49, 0.0, 0,
                         0, 0)
        end
    end,

    ["handshead"] = function(ped)
        if IsEntityPlayingAnim(ped, "random@arrests@busted", "idle_a", 3) then
            ClearPedTasks(ped)
        else
            RequestAnimDict("random@arrests@busted")
            while not HasAnimDictLoaded("random@arrests@busted") and
                not handCuffed do Citizen.Wait(0) end
            local animLength =
                GetAnimDuration("random@arrests@busted", "idle_a")
            TaskPlayAnim(ped, "random@arrests@busted", "idle_a", 1.0, 4.0,
                         animLength, 2, 0, 0, 0, 0)
        end

    end,
    ["handshead2"] = function(ped)
        if IsEntityPlayingAnim(ped, "random@arrests@busted", "idle_a", 3) then
            ClearPedTasks(ped)
        else
            RequestAnimDict("random@arrests@busted")
            while not HasAnimDictLoaded("random@arrests@busted") and
                not handCuffed do Citizen.Wait(0) end
            local animLength =
                GetAnimDuration("random@arrests@busted", "idle_a")
            TaskPlayAnim(ped, "random@arrests@busted", "idle_a", 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,
    ["twerk"] = function(ped)
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict("switch@trevor@mocks_lapdance")
        while not HasAnimDictLoaded("switch@trevor@mocks_lapdance") and
            not handCuffed do Citizen.Wait(0) end

        if IsEntityPlayingAnim(ped, "switch@trevor@mocks_lapdance",
                               "001443_01_trvs_28_idle_stripper", 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict('switch@trevor@mocks_lapdance')

            local animLength = GetAnimDuration("switch@trevor@mocks_lapdance",
                                               "001443_01_trvs_28_idle_stripper")
            TaskPlayAnim(PlayerPedId(), 'switch@trevor@mocks_lapdance',
                         '001443_01_trvs_28_idle_stripper', 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["karate"] = function(ped)
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        loadAnimDict('anim@mp_player_intcelebrationfemale@karate_chops')
        TaskPlayAnim(PlayerPedId(),
                     'anim@mp_player_intcelebrationfemale@karate_chops',
                     'karate_chops', 5.0, 1.0, 5.0, 0, 0.0, 0, 0, 0)
        playing_emote = false
    end,

    ["karate2"] = function(ped)
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        loadAnimDict('anim@mp_player_intcelebrationmale@karate_chops')
        TaskPlayAnim(PlayerPedId(),
                     'anim@mp_player_intcelebrationmale@karate_chops',
                     'karate_chops', 5.0, 1.0, 5.0, 0, 0.0, 0, 0, 0)
        playing_emote = false
    end,

    ["cprstanding"] = function(ped)
        local animDict = "mini@cpr@char_a@cpr_str"
        local animation = "cpr_pumpchest"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 31, 0, 0, 0, 0)
        end
    end,

    ["suicidepill"] = function(ped)
        local pos = GetOffsetFromEntityInWorldCoords(ped, 0.1, 0.1, 1.0)
        local entityWorld =
            GetOffsetFromEntityInWorldCoords(ped, 0.1, 0.1, -1.0)

        RequestAnimDict("mp_suicide")
        while not HasAnimDictLoaded("mp_suicide") do Citizen.Wait(0) end

        if IsEntityPlayingAnim(ped, "mp_suicide", "pill", 3) then
            ClearPedSecondaryTask(ped)
        else
            TaskPlayAnim(ped, "mp_suicide", "pill", 8.0, -8, -1, 9, 0, 0, 0, 0)
            Citizen.Wait(4500)
            exports['ragdoll']:SetPlayerHealth(0)
        end

    end,

    ["drink"] = function(ped)
        local animDict = "mp_player_inteat@pnq"
        local animation = "loop"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 48, 0, 0, 0, 0)
        end
    end,

    ["beast"] = function(ped)
        local animDict = "anim@mp_fm_event@intro"
        local animation = "beast_transform"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["chill"] = function(ped)
        local animDict = "switch@trevor@scares_tramp"
        local animation = "trev_scares_tramp_idle_tramp"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["cloudgaze"] = function(ped)
        local animDict = "switch@trevor@annoys_sunbathers"
        local animation = "trev_annoys_sunbathers_loop_girl"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["cloudgaze2"] = function(ped)
        local animDict = "switch@trevor@annoys_sunbathers"
        local animation = "trev_annoys_sunbathers_loop_guy"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["prone"] = function(ped)
        local animDict = "missfbi3_sniping"
        local animation = "prone_dave"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                                    animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["pullover"] = function(ped)
        local animDict = "misscarsteal3pullover"
        local animation = "pull_over_right"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["idle"] = function(ped)
        local animDict = "anim@heists@heist_corona@team_idles@male_a"
        local animation = "idle"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["idle8"] = function(ped)
        local animDict = "amb@world_human_hang_out_street@male_b@idle_a"
        local animation = "idle_b"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,
    ["idle9"] = function(ped)
        local animDict = "friends@fra@ig_1"
        local animation = "base_idle"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["idle10"] = function(ped)
        local animDict = "mp_move@prostitute@m@french"
        local animation = "idle"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["idle11"] = function(ped)
        local animDict = "random@countrysiderobbery"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["idle2"] = function(ped)
        local animDict = "anim@heists@heist_corona@team_idles@female_a"
        local animation = "idle"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["idle3"] = function(ped)
        local animDict = "anim@heists@humane_labs@finale@strip_club"
        local animation = "ped_b_celebrate_loop"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["idle4"] = function(ped)
        local animDict = "anim@mp_celebration@idles@female"
        local animation = "celebration_idle_f_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["idle5"] = function(ped)
        local animDict = "anim@mp_corona_idles@female_b@idle_a"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["idle6"] = function(ped)
        local animDict = "anim@mp_corona_idles@male_c@idle_a"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["idle7"] = function(ped)
        local animDict = "anim@mp_corona_idles@male_d@idle_a"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["wait3"] = function(ped)
        local animDict =
            "amb@world_human_hang_out_street@female_hold_arm@idle_a"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["idledrunk"] = function(ped)
        local animDict = "random@drunk_driver_1"
        local animation = "drunk_driver_stand_loop_dd1"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["idledrunk2"] = function(ped)
        local animDict = "random@drunk_driver_1"
        local animation = "drunk_driver_stand_loop_dd2"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["idledrunk3"] = function(ped)
        local animDict = "missarmenian2"
        local animation = "standing_idle_loop_drunk"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["airguitar"] = function(ped)
        local animDict = "anim@mp_player_intcelebrationfemale@air_guitar"
        local animation = "air_guitar"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,
    ["airsynth"] = function(ped)
        local animDict = "anim@mp_player_intcelebrationfemale@air_synth"
        local animation = "air_synth"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,
    ["argue"] = function(ped)
        local animDict = "misscarsteal4@actor"
        local animation = "actor_berating_loop"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["argue2"] = function(ped)
        local animDict = "oddjobs@assassinate@vice@hooker"
        local animation = "argue_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["bartender"] = function(ped)
        local animDict = "anim@amb@clubhouse@bar@drink@idle_a"
        local animation = "idle_a_bartender"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["blowkiss"] = function(ped)
        local animDict = "anim@mp_player_intcelebrationfemale@blow_kiss"
        local animation = "blow_kiss"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,
    ["blowkiss2"] = function(ped)
        local animDict = "anim@mp_player_intselfieblow_kiss"
        local animation = "exit"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 48, 0, 0, 0, 0)
        end
    end,
    ["curtsy"] = function(ped)
        local animDict = "anim@mp_player_intcelebrationpaired@f_f_sarcastic"
        local animation = "sarcastic_left"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["comeatmebro"] = function(ped)
        local animDict = "mini@triathlon"
        local animation = "want_some_of_this"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 48, 0, 0, 0, 0)
        end
    end,

    ["cop2"] = function(ped)
        local animDict = "anim@amb@nightclub@peds@"
        local animation = "rcmme_amanda1_stand_loop_cop"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["cop3"] = function(ped)
        local animDict = "amb@code_human_police_investigate@idle_a"
        local animation = "idle_b"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["standguard"] = function(ped)
        local animDict = "amb@world_human_stand_guard@male@idle_a"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["standguard2"] = function(ped)
        local animDict = "anim@miss@low@fin@vagos@"
        local animation = "idle_ped06"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["crossarms"] = function(ped)
        local animDict =
            "amb@world_human_hang_out_street@female_arms_crossed@idle_a"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["crossarms2"] = function(ped)
        local animDict = "amb@world_human_hang_out_street@male_c@idle_a"
        local animation = "idle_b"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["crossarms3"] = function(ped)
        local animDict = "anim@heists@heist_corona@single_team"
        local animation = "single_team_loop_boss"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["crossarms4"] = function(ped)
        local animDict = "random@street_race"
        local animation = "_car_b_lookout"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["crossarms5"] = function(ped)
        local animDict = "anim@amb@nightclub@peds@"
        local animation = "rcmme_amanda1_stand_loop_cop"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["crossarms6"] = function(ped)
        local animDict = "random@shop_gunstore"
        local animation = "_idle"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["crossarmsside"] = function(ped)
        local animDict = "rcmnigel1a_band_groupies"
        local animation = "base_m2"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["damn"] = function(ped)
        local animDict = "anim@am_hold_up@male"
        local animation = "shoplift_mid"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 48, 0, 0, 0, 0)
        end
    end,

    ["pointdown"] = function(ped)
        local animDict = "gestures@f@standing@casual"
        local animation = "gesture_hand_down"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["facepalm2"] = function(ped)
        local animDict = "anim@mp_player_intcelebrationfemale@face_palm"
        local animation = "face_palm"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 48, 0, 0, 0, 0)
        end
    end,

    ["facepalm"] = function(ped)
        local animDict = "random@car_thief@agitated@idle_a"
        local animation = "agitated_idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 48, 0, 0, 0, 0)
        end
    end,

    ["facepalm3"] = function(ped)
        local animDict = "missminuteman_1ig_2"
        local animation = "tasered_2"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 48, 0, 0, 0, 0)
        end
    end,

    ["facepalm4"] = function(ped)
        local animDict = "anim@mp_player_intupperface_palm"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 48, 0, 0, 0, 0)
        end
    end,

    ["fallover"] = function(ped)
        local animDict = "random@drunk_driver_1"
        local animation = "drunk_fall_over"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 2, 0, 0, 0, 0)
        end
    end,
    ["fallover2"] = function(ped)
        local animDict = "mp_suicide"
        local animation = "pistol"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 2, 0, 0, 0, 0)
        end
    end,
    ["fallover3"] = function(ped)
        local animDict = "friends@frf@ig_2"
        local animation = "knockout_plyr"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 2, 0, 0, 0, 0)
        end
    end,
    ["fallover4"] = function(ped)
        local animDict = "anim@gangops@hostage@"
        local animation = "victim_fail"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 2, 0, 0, 0, 0)
        end
    end,
    ["fallasleep"] = function(ped)
        local animDict = "mp_sleep"
        local animation = "sleep_loop"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 63, 0, 0, 0, 0)
        end
    end,

    ["fightme"] = function(ped)
        local animDict = "anim@deathmatch_intros@unarmed"
        local animation = "intro_male_unarmed_c"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,
    ["fightme2"] = function(ped)
        local animDict = "anim@deathmatch_intros@unarmed"
        local animation = "intro_male_unarmed_e"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 48, 0, 0, 0, 0)
        end
    end,
    ["finger"] = function(ped)
        local animDict = "anim@mp_player_intselfiethe_bird"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["finger2"] = function(ped)
        local animDict = "anim@mp_player_intupperfinger"
        local animation = "idle_a_fp"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["smoke"] = function(ped)
        if IsPedInAnyVehicle(ped, false) then
            TriggerEvent("DoLongHudText", "You cannot smoke cigarettes inside vehicles!", 2)
            return
        end
        if exports["ev-inventory"]:hasEnoughOfItem("ciggy", 1) then
            ClearPedTasks(PlayerPedId())
            TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_SMOKING", 0, true)
            TriggerEvent("inventory:removeItem","ciggy", 1)
            TriggerEvent("client:newStress", false, 250)
            playing_emote = true
        end
    end,

    ["smokemale"] = function(ped)
        if exports["ev-inventory"]:hasEnoughOfItem("ciggy", 1) then
            local animDict = "amb@world_human_smoking@male@male_a@base"
            local animation = "base"
            if IsPedArmed(ped, 7) then
                TriggerEvent("actionbar:setEmptyHanded")
            end

            if IsEntityPlayingAnim(ped, animDict, animation, 3) then
                ClearPedSecondaryTask(ped)
            else
                loadAnimDict(animDict)
                local animLength = GetAnimDuration(animDict, animation)
                TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                            animLength, 49, 0, 0, 0, 0)
                TriggerEvent("destroyProp")
            end
            TriggerEvent("attachItem", "cigarette")
            TriggerEvent("inventory:removeItem","ciggy", 1)
        end
    end,

    ["smokefemale"] = function(ped)
        if exports["ev-inventory"]:hasEnoughOfItem("ciggy", 1) then
            local animDict = "amb@world_human_smoking@female@idle_a"
            local animation = "idle_b"
            if IsPedArmed(ped, 7) then
                TriggerEvent("actionbar:setEmptyHanded")
            end

            if IsEntityPlayingAnim(ped, animDict, animation, 3) then
                ClearPedSecondaryTask(ped)
            else
                loadAnimDict(animDict)
                local animLength = GetAnimDuration(animDict, animation)
                TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                            animLength, 49, 0, 0, 0, 0)
                TriggerEvent("destroyProp")
            end
            TriggerEvent("attachItem", "cigarette")
            TriggerEvent("inventory:removeItem","ciggy", 1)
        end
    end,

    ["cigarette"] = function(ped)
        if exports["ev-inventory"]:hasEnoughOfItem("ciggy", 1) then
            local animDict = "amb@world_human_smoking@male@male_a@enter"
            local animation = "enter"
            if IsPedArmed(ped, 7) then
                TriggerEvent("actionbar:setEmptyHanded")
            end

            if IsEntityPlayingAnim(ped, animDict, animation, 3) then
                ClearPedSecondaryTask(ped)
            else
                loadAnimDict(animDict)
                TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                            2600, 0, 0, 0, 0, 0)
                TriggerEvent("destroyProp")
                Wait(2600)
                TriggerEvent("attachItem", "cigmouth")
            end
            TriggerEvent("inventory:removeItem","ciggy", 1)
        end
    end,

    ["cigar"] = function(ped)
        if exports["ev-inventory"]:hasEnoughOfItem("cigar", 1) then
            local animDict = "amb@world_human_smoking@male@male_a@enter"
            local animation = "enter"
            if IsPedArmed(ped, 7) then
                TriggerEvent("actionbar:setEmptyHanded")
            end

            if IsEntityPlayingAnim(ped, animDict, animation, 3) then
                ClearPedSecondaryTask(ped)
            else
                loadAnimDict(animDict)
                TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                            2600, 0, 0, 0, 0, 0)
                TriggerEvent("destroyProp")
                Wait(2600)
                TriggerEvent("attachItem", "cigar1")
            end
            TriggerEvent("inventory:removeItem","cigar", 1)
        end
    end,

    ["cigar2"] = function(ped)
        if exports["ev-inventory"]:hasEnoughOfItem("cigar", 1) then
            local animDict = "amb@world_human_smoking@male@male_a@enter"
            local animation = "enter"
            if IsPedArmed(ped, 7) then
                TriggerEvent("actionbar:setEmptyHanded")
            end

            if IsEntityPlayingAnim(ped, animDict, animation, 3) then
                ClearPedSecondaryTask(ped)
            else
                loadAnimDict(animDict)
                TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                            2600, 0, 0, 0, 0, 0)
                TriggerEvent("destroyProp")
                Wait(2600)
                TriggerEvent("attachItem", "cigar2")
            end
            TriggerEvent("inventory:removeItem","cigar", 1)
        end
    end,

    ["cigar3"] = function(ped)
        if exports["ev-inventory"]:hasEnoughOfItem("cigar", 1) then
            local animDict = "amb@world_human_smoking@male@male_a@enter"
            local animation = "enter"
            if IsPedArmed(ped, 7) then
                TriggerEvent("actionbar:setEmptyHanded")
            end

            if IsEntityPlayingAnim(ped, animDict, animation, 3) then
                ClearPedSecondaryTask(ped)
            else
                loadAnimDict(animDict)
                TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                            2600, 0, 0, 0, 0, 0)
                TriggerEvent("destroyProp")
                Wait(2600)
                TriggerEvent("attachItem", "cigar3")
            end
            TriggerEvent("inventory:removeItem","cigar", 1)
        end
    end,

    ["handshake"] = function(ped)
        local animDict = "mp_ped_interaction"
        local animation = "handshake_guy_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["handshake2"] = function(ped)
        local animDict = "mp_ped_interaction"
        local animation = "handshake_guy_b"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["wait4"] = function(ped)
        local animDict =
            "amb@world_human_hang_out_street@Female_arm_side@idle_a"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["wait5"] = function(ped)
        local animDict = "missclothing"
        local animation = "idle_storeclerk"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["wait6"] = function(ped)
        local animDict = "timetable@amanda@ig_2"
        local animation = "ig_2_base_amanda"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["wait7"] = function(ped)
        local animDict = "rcmnigel1cnmt_1c"
        local animation = "base"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["wait8"] = function(ped)
        local animDict = "rcmjosh1"
        local animation = "idle"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["wait9"] = function(ped)
        local animDict = "rcmjosh2"
        local animation = "josh_2_intp1_base"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["wait10"] = function(ped)
        local animDict = "timetable@amanda@ig_3"
        local animation = "ig_3_base_tracy"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["wait11"] = function(ped)
        local animDict = "misshair_shop@hair_dressers"
        local animation = "keeper_base"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["hiking"] = function(ped)
        local animDict = "move_m@hiking"
        local animation = "idle"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["hug"] = function(ped)
        local animDict = "mp_ped_interaction"
        local animation = "kisses_guy_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,
    ["hug2"] = function(ped)
        local animDict = "mp_ped_interaction"
        local animation = "kisses_guy_b"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,
    ["hug3"] = function(ped)
        local animDict = "mp_ped_interaction"
        local animation = "hugs_guy_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,
    ["inspect"] = function(ped)
        local animDict = "random@train_tracks"
        local animation = "idle_e"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,
    ["jazzhands"] = function(ped)
        local animDict = "anim@mp_player_intcelebrationfemale@jazz_hands"
        local animation = "jazz_hands"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["jog2"] = function(ped)
        local animDict = "amb@world_human_jog_standing@male@idle_a"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["jog3"] = function(ped)
        local animDict = "amb@world_human_jog_standing@female@idle_a"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["jog4"] = function(ped)
        local animDict = "amb@world_human_power_walker@female@idle_a"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 47, 0, 0, 0, 0)
        end
    end,

    ["jog5"] = function(ped)
        local animDict = "move_m@joy@a"
        local animation = "walk"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 47, 0, 0, 0, 0)
        end
    end,

    ["jumpingjacks"] = function(ped)
        local animDict = "timetable@reunited@ig_2"
        local animation = "jimmy_getknocked"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["kneel2"] = function(ped)
        local animDict = "rcmextreme3"
        local animation = "idle"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["kneel3"] = function(ped)
        local animDict = "amb@world_human_bum_wash@male@low@idle_a"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["kneel4"] = function(ped)
        local animDict = "amb@medic@standing@tendtodead@base"
        local animation = "base"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["knock"] = function(ped)
        local animDict = "timetable@jimmy@doorknock@"
        local animation = "knockdoor_idle"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["knock2"] = function(ped)
        local animDict = "missheistfbi3b_ig7"
        local animation = "lift_fibagent_loop"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["knucklecrunch"] = function(ped)
        local animDict = "anim@mp_player_intcelebrationfemale@knuckle_crunch"
        local animation = "knuckle_crunch"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 48, 0, 0, 0, 0)
        end
    end,

    ["lapdance"] = function(ped)
        local animDict = "mp_safehouse"
        local animation = "lap_dance_girl"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,
    ["lean2"] = function(ped)
        local animDict =
            "amb@world_human_leaning@female@wall@back@hand_up@idle_a"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["lean3"] = function(ped)
        local animDict =
            "amb@world_human_leaning@female@wall@back@holding_elbow@idle_a"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["lean4"] = function(ped)
        local animDict = "amb@world_human_leaning@male@wall@back@foot_up@idle_a"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["lean5"] = function(ped)
        local animDict =
            "amb@world_human_leaning@male@wall@back@hands_together@idle_b"
        local animation = "idle_b"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["leanflirt"] = function(ped)
        local animDict = "random@street_race"
        local animation = "_car_a_flirt_girl"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["leanbar2"] = function(ped)
        local animDict = "amb@prop_human_bum_shopping_cart@male@idle_a"
        local animation = "idle_c"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["leanbar3"] = function(ped)
        local animDict = "anim@amb@nightclub@lazlow@ig1_vip@"
        local animation = "clubvip_base_laz"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["leanbar4"] = function(ped)
        local animDict = "anim@heists@prison_heist"
        local animation = "ped_b_loop_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["leanhigh"] = function(ped)
        local animDict = "anim@mp_ferris_wheel"
        local animation = "idle_a_player_one"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["leanhigh2"] = function(ped)
        local animDict = "anim@mp_ferris_wheel"
        local animation = "idle_a_player_two"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["leanside"] = function(ped)
        local animDict = "timetable@mime@01_gc"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["leanside2"] = function(ped)
        local animDict = "misscarstealfinale"
        local animation = "packer_idle_1_trevor"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["leanside3"] = function(ped)
        local animDict = "misscarstealfinalecar_5_ig_1"
        local animation = "waitloop_lamar"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["leanside4"] = function(ped)
        local animDict = "misscarstealfinalecar_5_ig_1"
        local animation = "waitloop_lamar"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["leanside5"] = function(ped)
        local animDict = "rcmjosh2"
        local animation = "josh_2_intp1_base"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["me"] = function(ped)
        local animDict = "gestures@f@standing@casual"
        local animation = "gesture_me_hard"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 48, 0, 0, 0, 0)
        end
    end,

    ["mechanic"] = function(ped)
        local animDict = "mini@repair"
        local animation = "fixing_a_ped"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["mechanic2"] = function(ped)
        local animDict = "amb@world_human_vehicle_mechanic@male@base"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["mechanic3"] = function(ped)
        local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
        local animation = "machinic_loop_mechandplayer"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["mechanic4"] = function(ped)
        local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
        local animation = "machinic_loop_mechandplayer"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["medic2"] = function(ped)
        local animDict = "amb@medic@standing@tendtodead@base"
        local animation = "base"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["meditate"] = function(ped)
        local animDict = "rcmcollect_paperleadinout@"
        local animation = "meditiate_idle"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["meditate2"] = function(ped)
        local animDict = "rcmepsilonism3"
        local animation = "ep_3_rcm_marnie_meditating"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["meditate3"] = function(ped)
        local animDict = "rcmepsilonism3"
        local animation = "base_loop"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["trooperpushup"] = function(ped)
        local animDict = "yoinks@1armpushup"
        local animation = "onearmpushup_clip"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 4.0, 4.0,animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["metal"] = function(ped)
        local animDict = "anim@mp_player_intincarrockstd@ps@"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["no"] = function(ped)
        local animDict = "anim@heists@ornate_bank@chat_manager"
        local animation = "fail"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 48, 0, 0, 0, 0)
        end
    end,

    ["no2"] = function(ped)
        local animDict = "mp_player_int_upper_nod"
        local animation = "mp_player_int_nod_no"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["nosepick"] = function(ped)
        local animDict = "anim@mp_player_intcelebrationfemale@nose_pick"
        local animation = "nose_pick"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 48, 0, 0, 0, 0)
        end
    end,

    ["noway"] = function(ped)
        local animDict = "gestures@m@standing@casual"
        local animation = "gesture_no_way"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 48, 0, 0, 0, 0)
        end
    end,

    ["ok"] = function(ped)
        local animDict = "anim@mp_player_intselfiedock"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["outofbreath"] = function(ped)
        local animDict = "re@construction"
        local animation = "out_of_breath"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["pickup"] = function(ped)
        local animDict = "random@domestic"
        local animation = "pickup_low"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,
    ["push"] = function(ped)
        local animDict = "missfinale_c2ig_11"
        local animation = "pushcar_offcliff_f"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["push2"] = function(ped)
        local animDict = "missfinale_c2ig_11"
        local animation = "pushcar_offcliff_m"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["point"] = function(ped)
        local animDict = "gestures@f@standing@casual"
        local animation = "gesture_point"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["countdown"] = function(ped)
        local animDict = "random@street_race"
        local animation = "grid_girl_race_start"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["pointright"] = function(ped)
        local animDict = "mp_gun_shop_tut"
        local animation = "indicate_right"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["salute"] = function(ped)
        local animDict = "anim@mp_player_intincarsalutestd@ds@"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 48, 0, 0, 0, 0)
        end
    end,

    ["salute2"] = function(ped)
        local animDict = "anim@mp_player_intincarsalutestd@ps@"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["salute3"] = function(ped)
        local animDict = "anim@mp_player_intuppersalute"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["scared"] = function(ped)
        local animDict = "random@domestic"
        local animation = "f_distressed_loop"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["scared2"] = function(ped)
        local animDict = "random@homelandsecurity"
        local animation = "knees_loop_girl"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["screwyou"] = function(ped)
        local animDict = "misscommon@response"
        local animation = "screw_you"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["shakeoff"] = function(ped)
        local animDict = "move_m@_idles@shake_off"
        local animation = "shakeoff_1"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 48, 0, 0, 0, 0)
        end
    end,

    ["shot"] = function(ped)
        local animDict = "random@crash_rescue@wounded@base"
        local animation = "base"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["injured"] = function(ped) anims["shot"](ped) end,

    ["sleep"] = function(ped)
        local animDict = "timetable@tracy@sleep@"
        local animation = "idle_c"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["shrug"] = function(ped)
        local animDict = "gestures@f@standing@casual"
        local animation = "gesture_shrug_hard"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["shrug2"] = function(ped)
        local animDict = "gestures@m@standing@casual"
        local animation = "gesture_shrug_hard"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["sit"] = function(ped)
        local animDict = "anim@amb@business@bgen@bgen_no_work@"
        local animation = "sit_phone_phoneputdown_idle_nowork"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["sit2"] = function(ped)
        local animDict = "rcm_barry3"
        local animation = "barry_3_sit_loop"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["sit3"] = function(ped)
        local animDict = "amb@world_human_picnic@male@idle_a"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["sit4"] = function(ped)
        local animDict = "amb@world_human_picnic@female@idle_a"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["sit5"] = function(ped)
        local animDict = "anim@heists@fleeca_bank@ig_7_jetski_owner"
        local animation = "owner_idle"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["sit6"] = function(ped)
        local animDict = "timetable@jimmy@mics3_ig_15@"
        local animation = "idle_a_jimmy"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["sit7"] = function(ped)
        local animDict = "anim@amb@nightclub@lazlow@lo_alone@"
        local animation = "lowalone_base_laz"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["sit8"] = function(ped)
        local animDict = "timetable@jimmy@mics3_ig_15@"
        local animation = "mics3_15_base_jimmy"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["sit9"] = function(ped)
        local animDict = "amb@world_human_stupor@male@idle_a"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["sitlean"] = function(ped)
        local animDict = "timetable@tracy@ig_14@"
        local animation = "ig_14_base_tracy"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,
    ["sitsad"] = function(ped)
        local animDict = "anim@amb@business@bgen@bgen_no_work@"
        local animation = "sit_phone_phoneputdown_sleeping-noworkfemale"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,
    ["sitscared"] = function(ped)
        local animDict = "anim@heists@ornate_bank@hostages@hit"
        local animation = "hit_loop_ped_b"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,
    ["sitscared2"] = function(ped)
        local animDict = "anim@heists@ornate_bank@hostages@ped_c@"
        local animation = "flinch_loop"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["sitscared3"] = function(ped)
        local animDict = "anim@heists@ornate_bank@hostages@ped_e@"
        local animation = "flinch_loop"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["sitdrunk"] = function(ped)
        local animDict = "timetable@amanda@drunk@base"
        local animation = "base"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["sitchair2"] = function(ped)
        local animDict = "timetable@ron@ig_5_p3"
        local animation = "ig_5_p3_base"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["sitchair3"] = function(ped)
        local animDict = "timetable@reunited@ig_10"
        local animation = "base_amanda"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["sitchair4"] = function(ped)
        local animDict = "timetable@ron@ig_3_couch"
        local animation = "base"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["sitchair5"] = function(ped)
        local animDict = "timetable@jimmy@mics3_ig_15@"
        local animation = "mics3_15_base_tracy"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["sitchair6"] = function(ped)
        local animDict = "timetable@maid@couch@"
        local animation = "base"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["sitchairside"] = function(ped)
        local animDict = "timetable@ron@ron_ig_2_alt1"
        local animation = "ig_2_alt1_base"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["clapangry"] = function(ped)
        local animDict = "anim@arena@celeb@flat@solo@no_props@"
        local animation = "angry_clap_a_player_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["slowclap3"] = function(ped)
        local animDict = "anim@mp_player_intupperslow_clap"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["clap"] = function(ped)
        local animDict = "amb@world_human_cheering@male_a"
        local animation = "base"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["slowclap"] = function(ped)
        local animDict = "anim@mp_player_intcelebrationfemale@slow_clap"
        local animation = "slow_clap"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["slowclap2"] = function(ped)
        local animDict = "anim@mp_player_intcelebrationmale@slow_clap"
        local animation = "slow_clap"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["smell"] = function(ped)
        local animDict = "move_p_m_two_idles@generic"
        local animation = "fidget_sniff_fingers"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 48, 0, 0, 0, 0)
        end
    end,

    ["stickup"] = function(ped)
        local animDict = "random@countryside_gang_fight"
        local animation = "biker_02_stickup_loop"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["stickup2"] = function(ped)
        local animDict = "random@countryside_gang_fight"
        local animation = "biker_02_stickup_loop"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["stumble"] = function(ped)
        local animDict = "misscarsteal4@actor"
        local animation = "stumble"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["stunned"] = function(ped)
        local animDict = "stungun@standing"
        local animation = "damage"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["sunbathe"] = function(ped)
        local animDict = "amb@world_human_sunbathe@male@back@base"
        local animation = "base"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["sunbathe2"] = function(ped)
        local animDict = "amb@world_human_sunbathe@female@back@base"
        local animation = "base"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["t"] = function(ped)
        local animDict = "missfam5_yoga"
        local animation = "a2_pose"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["t2"] = function(ped)
        local animDict = "missfam5_yoga"
        local animation = "a2_pose"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["think5"] = function(ped)
        local animDict = "mp_cp_welcome_tutthink"
        local animation = "b_think"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["think"] = function(ped)
        local animDict = "misscarsteal4@aliens"
        local animation = "rehearsal_base_idle_director"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["think3"] = function(ped)
        local animDict = "timetable@tracy@ig_8@base"
        local animation = "base"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["think2"] = function(ped)
        local animDict = "missheist_jewelleadinout"
        local animation = "jh_int_outro_loop_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["thumbsup3"] = function(ped)
        local animDict = "anim@mp_player_intincarthumbs_uplow@ds@"
        local animation = "enter"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["thumbsup2"] = function(ped)
        local animDict = "anim@mp_player_intselfiethumbs_up"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["thumbsup"] = function(ped)
        local animDict = "anim@mp_player_intupperthumbs_up"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 48, 0, 0, 0, 0)
        end
    end,

    ["type"] = function(ped)
        local animDict = "anim@heists@prison_heiststation@cop_reactions"
        local animation = "cop_b_idle"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["type2"] = function(ped)
        local animDict = "anim@heists@prison_heistig1_p1_guard_checks_bus"
        local animation = "loop"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["type3"] = function(ped)
        local animDict = "mp_prison_break"
        local animation = "hack_loop"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["type4"] = function(ped)
        local animDict = "mp_fbi_heist"
        local animation = "loop"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["warmth"] = function(ped)
        local animDict = "amb@world_human_stand_fire@male@idle_a"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["wave4"] = function(ped)
        local animDict = "random@mugging5"
        local animation = "001445_01_gangintimidation_1_female_idle_b"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["wave2"] = function(ped)
        local animDict = "anim@mp_player_intcelebrationfemale@wave"
        local animation = "wave"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["wave3"] = function(ped)
        local animDict = "friends@fra@ig_1"
        local animation = "over_here_idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["wave"] = function(ped)
        local animDict = "friends@frj@ig_1"
        local animation = "wave_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["wave5"] = function(ped)
        local animDict = "friends@frj@ig_1"
        local animation = "wave_b"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["wave6"] = function(ped)
        local animDict = "friends@frj@ig_1"
        local animation = "wave_c"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["wave7"] = function(ped)
        local animDict = "friends@frj@ig_1"
        local animation = "wave_d"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["wave8"] = function(ped)
        local animDict = "friends@frj@ig_1"
        local animation = "wave_e"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["wave9"] = function(ped)
        local animDict = "gestures@m@standing@casual"
        local animation = "gesture_hello"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["whistle"] = function(ped)
        local animDict = "taxi_hail"
        local animation = "hail_taxi"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["whistle2"] = function(ped)
        local animDict = "rcmnigel1c"
        local animation = "hailing_whistle_waive_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["yeah"] = function(ped)
        local animDict = "anim@mp_player_intupperair_shagging"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 48, 0, 0, 0, 0)
        end
    end,

    ["lift"] = function(ped)
        local animDict = "random@hitch_lift"
        local animation = "idle_f"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["lol"] = function(ped)
        local animDict = "anim@arena@celeb@flat@paired@no_props@"
        local animation = "laugh_a_player_b"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["lol2"] = function(ped)
        local animDict = "anim@arena@celeb@flat@solo@no_props@"
        local animation = "giggle_a_player_b"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["statue2"] = function(ped)
        local animDict = "fra_0_int-1"
        local animation = "cs_lamardavis_dual-1"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 17, 0, 0, 0, 0)
        end
    end,
    ["statue3"] = function(ped)
        local animDict = "club_intro2-0"
        local animation = "csb_englishdave_dual-0"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,
    ["gangsign"] = function(ped)
        local animDict = "mp_player_int_uppergang_sign_a"
        local animation = "mp_player_int_gang_sign_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["gangsign2"] = function(ped)
        local animDict = "mp_player_int_uppergang_sign_b"
        local animation = "mp_player_int_gang_sign_b"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["slump"] = function (ped)
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_BUM_SLUMPED", 0, false)
    end,

    ["passout"] = function(ped)
        local animDict = "missarmenian2"
        local animation = "drunk_loop"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["passout2"] = function(ped)
        local animDict = "missarmenian2"
        local animation = "corpse_search_exit_ped"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["passout3"] = function(ped)
        local animDict = "anim@gangops@morgue@table@"
        local animation = "body_search"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["passout4"] = function(ped)
        local animDict = "mini@cpr@char_b@cpr_def"
        local animation = "cpr_pumpchest_idle"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["passout5"] = function(ped)
        local animDict = "random@mugging4"
        local animation = "flee_backward_loop_shopkeeper"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["petting"] = function(ped)
        local animDict = "creatures@rottweiler@tricks@"
        local animation = "petting_franklin"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["crawl"] = function(ped)
        local animDict = "move_injured_ground"
        local animation = "front_loop"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 33, 0, 0, 0, 0)
        end
    end,

    ["flip2"] = function(ped)
        local animDict = "anim@arena@celeb@flat@solo@no_props@"
        local animation = "cap_a_player_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,
    ["flip"] = function(ped)
        local animDict = "anim@arena@celeb@flat@solo@no_props@"
        local animation = "flip_a_player_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,
    ["slide"] = function(ped)
        local animDict = "anim@arena@celeb@flat@solo@no_props@"
        local animation = "slide_a_player_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,
    ["slide2"] = function(ped)
        local animDict = "anim@arena@celeb@flat@solo@no_props@"
        local animation = "slide_b_player_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,
    ["slide3"] = function(ped)
        local animDict = "anim@arena@celeb@flat@solo@no_props@"
        local animation = "slide_c_player_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,
    ["slugger"] = function(ped)
        local animDict = "anim@arena@celeb@flat@solo@no_props@"
        local animation = "slugger_a_player_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,
    ["flipoff"] = function(ped)
        local animDict = "anim@arena@celeb@podium@no_prop@"
        local animation = "flip_off_a_1st"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["flipoff2"] = function(ped)
        local animDict = "anim@arena@celeb@podium@no_prop@"
        local animation = "flip_off_c_1st"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["bow"] = function(ped)
        local animDict = "anim@arena@celeb@podium@no_prop@"
        local animation = "regal_c_1st"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["bow2"] = function(ped)
        local animDict = "anim@arena@celeb@podium@no_prop@"
        local animation = "regal_a_1st"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["keyfob"] = function(ped)
        local animDict = "anim@mp_player_intmenu@key_fob@"
        local animation = "fob_click"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["golfswing"] = function(ped)
        local animDict = "rcmnigel1d"
        local animation = "swing_a_mark"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,
    ["eat"] = function(ped)
        local animDict = "mp_player_inteat@burger"
        local animation = "mp_player_int_eat_burger"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["reaching"] = function(ped)
        local animDict = "move_m@intimidation@cop@unarmed"
        local animation = "idle"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["wait"] = function(ped)
        local animDict = "random@shop_tattoo"
        local animation = "_idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["wait2"] = function(ped)
        local animDict = "missbigscore2aig_3"
        local animation = "wait_for_van_c"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["wait12"] = function(ped)
        local animDict = "rcmjosh1"
        local animation = "idle"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["wait13"] = function(ped)
        local animDict = "rcmnigel1a"
        local animation = "base"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["lapdance2"] = function(ped)
        local animDict = "mini@strip_club@private_dance@idle"
        local animation = "priv_dance_idle"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["lapdance3"] = function(ped)
        local animDict = "mini@strip_club@private_dance@part2"
        local animation = "priv_dance_p2"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,
    ["slap"] = function(ped)
        local animDict = "melee@unarmed@streamed_variations"
        local animation = "plyr_takedown_front_slap"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["headbutt"] = function(ped)
        local animDict = "melee@unarmed@streamed_variations"
        local animation = "plyr_takedown_front_headbutt"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,
    ["fishdance"] = function(ped)
        local animDict = "anim@mp_player_intupperfind_the_fish"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["peace"] = function(ped)
        local animDict = "mp_player_int_upperpeace_sign"
        local animation = "mp_player_int_peace_sign"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["peace2"] = function(ped)
        local animDict = "anim@mp_player_intupperpeace"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["cpr"] = function(ped)
        local animDict = "mini@cpr@char_a@cpr_str"
        local animation = "cpr_pumpchest"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["ledge"] = function(ped)
        local animDict = "missfbi1"
        local animation = "ledge_loop"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["airplane"] = function(ped)
        local animDict = "missfbi1"
        local animation = "ledge_loop"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["peek"] = function(ped)
        local animDict = "random@paparazzi@peek"
        local animation = "left_peek_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["cough"] = function(ped)
        local animDict = "timetable@gardener@smoking_joint"
        local animation = "idle_cough"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["stretch"] = function(ped)
        local animDict = "mini@triathlon"
        local animation = "idle_e"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["stretch2"] = function(ped)
        local animDict = "mini@triathlon"
        local animation = "idle_f"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["stretch3"] = function(ped)
        local animDict = "mini@triathlon"
        local animation = "idle_d"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["stretch4"] = function(ped)
        local animDict = "rcmfanatic1maryann_stretchidle_b"
        local animation = "idle_e"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["celebrate"] = function(ped)
        local animDict = "rcmfanatic1celebrate"
        local animation = "celebrate"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["punching"] = function(ped)
        local animDict = "rcmextreme2"
        local animation = "loop_punching"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 62, 0, 0, 0, 0)
        end
    end,

    ["superhero"] = function(ped)
        local animDict = "rcmbarry"
        local animation = "base"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["superhero2"] = function(ped)
        local animDict = "rcmbarry"
        local animation = "base"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["mindcontrol"] = function(ped)
        local animDict = "rcmbarry"
        local animation = "mind_control_b_loop"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["mindcontrol2"] = function(ped)
        local animDict = "rcmbarry"
        local animation = "bar_1_attack_idle_aln"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["mindcontrol3"] = function(ped)
        local animDict = "rcmbarry"
        local animation = "bar_1_attack_idle_aln"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["clown"] = function(ped)
        local animDict = "rcm_barry2"
        local animation = "clown_idle_0"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["clown2"] = function(ped)
        local animDict = "rcm_barry2"
        local animation = "clown_idle_1"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["clown3"] = function(ped)
        local animDict = "rcm_barry2"
        local animation = "clown_idle_2"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["clown4"] = function(ped)
        local animDict = "rcm_barry2"
        local animation = "clown_idle_3"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["clown5"] = function(ped)
        local animDict = "rcm_barry2"
        local animation = "clown_idle_6"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["tryclothes"] = function(ped)
        local animDict = "mp_clothing@female@trousers"
        local animation = "try_trousers_neutral_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["tryclothes2"] = function(ped)
        local animDict = "mp_clothing@female@shirt"
        local animation = "try_shirt_positive_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["tryclothes3"] = function(ped)
        local animDict = "mp_clothing@female@shoes"
        local animation = "try_shoes_positive_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["nervous2"] = function(ped)
        local animDict = "mp_missheist_countrybank@nervous"
        local animation = "nervous_idle"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["nervous"] = function(ped)
        local animDict = "amb@world_human_bum_standing@twitchy@idle_a"
        local animation = "idle_c"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["nervous3"] = function(ped)
        local animDict = "rcmme_tracey1"
        local animation = "nervous_loop"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["namaste"] = function(ped)
        local animDict = "timetable@amanda@ig_4"
        local animation = "ig_4_base"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 50, 0, 0, 0, 0)
        end
    end,

    ["dj"] = function(ped)
        local animDict = "anim@amb@nightclub@djs@dixon@"
        local animation = "dixn_dance_cntr_open_dix"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["threaten"] = function(ped)
        local animDict = "random@atmrobberygen"
        local animation = "b_atm_mugging"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["radio"] = function(ped)
        local animDict = "random@arrests"
        local animation = "generic_radio_chatter"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 48, 0, 0, 0, 0)
        end
    end,

    ["pull"] = function(ped)
        local animDict = "random@mugging4"
        local animation = "struggle_loop_b_thief"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["bird"] = function(ped)
        local animDict = "random@peyote@bird"
        local animation = "wakeup"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,
    ["chicken"] = function(ped)
        local animDict = "random@peyote@chicken"
        local animation = "wakeup"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["bark"] = function(ped)
        local animDict = "random@peyote@dog"
        local animation = "wakeup"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    -- These don't do anything for human peds, but need to be here
    -- so they show up in the emotes list and can be favorited/keybound for animal peds.
    ["dogsit"] = function(ped) end,
    ["bark2"] = function(ped) end,
    ["bark3"] = function(ped) end,
    ["bark4"] = function(ped) end,
    ["bark5"] = function(ped) end,
    ["paw"] = function(ped) end,
    ["pet"] = function(ped) end,
    ["dump"] = function(ped) end,
    ["indicateahead"] = function(ped) end,
    ["kennel"] = function(ped) end,
    ["laydown"] = function(ped) end,
    ["carsit"] = function(ped) end,
    ["carenter"] = function(ped) end,
    ["carleave"] = function(ped) end,

    ["rabbit"] = function(ped)
        local animDict = "random@peyote@rabbit"
        local animation = "wakeup"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,
    ["spiderman"] = function(ped)
        local animDict = "missexile3"
        local animation = "ex03_train_roof_idle"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["boi"] = function(ped)
        local animDict = "special_ped@jane@monologue_5@monologue_5c"
        local animation = "brotheradrianhasshown_2"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,
    ["adjust"] = function(ped)
        local animDict = "missmic4"
        local animation = "michael_tux_fidget"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 48, 0, 0, 0, 0)
        end
    end,
    ["handsup"] = function(ped)
        local animDict = "missminuteman_1ig_2"
        local animation = "handsup_base"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,
    ["pee"] = function(ped)
        local animDict = "misscarsteal2peeing"
        local animation = "peeing_loop"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,
    ["mindblown"] = function(ped)
        local animDict = "anim@mp_player_intcelebrationmale@mind_blown"
        local animation = "mind_blown"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["mindblown2"] = function(ped)
        local animDict = "anim@mp_player_intcelebrationfemale@mind_blown"
        local animation = "mind_blown"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 62, 0, 0, 0, 0)
        end
    end,

    ["boxing"] = function(ped)
        local animDict = "anim@mp_player_intcelebrationmale@shadow_boxing"
        local animation = "shadow_boxing"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["boxing2"] = function(ped)
        local animDict = "anim@mp_player_intcelebrationfemale@shadow_boxing"
        local animation = "shadow_boxing"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 1, 0, 0, 0, 0)
        end
    end,

    ["stink"] = function(ped)
        local animDict = "anim@mp_player_intcelebrationfemale@stinker"
        local animation = "stinker"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 48, 0, 0, 0, 0)
        end
    end,

    ["think4"] = function(ped)
        local animDict = "anim@amb@casino@hangout@ped_male@stand@02b@idles"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["adjusttie"] = function(ped)
        local animDict = "clothingtie"
        local animation = "try_tie_positive_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["sweep"] = function(ped)
        local animDict = "amb@world_human_janitor@male@idle_a"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        -- -113902346 broom
        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
            TriggerEvent("destroyProp")
        end
        TriggerEvent("attachItem", "broom")
    end,

    ["peeposhy"] = function(ped)
        local animDict = "nikez@peepo"
        local animation = "shy"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 8.0, 8.0, -1, 49, 0, false, false, false)
        end
    end,

    ["orangejustice"] = function(ped)
        local animDict = "div@justice@new"
        local animation = "orangejustice"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 8.0, 8.0, -1, 1, 0, false, false, false)
        end
    end,

    ["floss"] = function(ped)
        local animDict = "divined@fndances@new"
        local animation = "dbdance12"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 8.0, 8.0, -1, 1, 0, false, false, false)
        end
    end,

    ["crabdance"] = function(ped)
        local animDict = "divined@fndances@new"
        local animation = "dbdance8"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 8.0, 8.0, -1, 1, 0, false, false, false)
        end
    end,

    ["cheerleaderdance"] = function(ped)
        local animDict = "divined@fndances@new"
        local animation = "dbdance7"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 8.0, 8.0, -1, 1, 0, false, false, false)
        end
    end,

    ["loser"] = function(ped)
        local animDict = "nikez@taunts@loser"
        local animation = "loser"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 8.0, 8.0, -1, 54, 0, false, false, false)
        end
    end,

    ["sheesh"] = function(ped)
        local animDict = "clear@custom_anim"
        local animation = "sheesh_clip"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 8.0, 8.0, -1, 48, 0, false, false, false)
        end
    end,

    ["animerun"] = function(ped)
        local animDict = "nikez@anime"
        local animation = "run"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 8.0, 8.0, -1, 49, 0, false, false, false)
        end
    end,

    ["pumping"] = function(ped)
        local animDict = "pumping@custom_anim@pumping"
        local animation = "pumping"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 2.0, 2.0, -1, 1, 0, false, false, false)
        end
    end,

    ["leginjury"] = function(ped)
        local animDict = "yoinks@injury@leg"
        local animation = "yoinks_injury_leg_clip"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 2.0, 2.0, -1, 1, 0, false, false, false)
        end
    end,

    ["rock"] = function(ped)
        local animDict = "yoinks@rps@rock"
        local animation = "yoinks_rps_rock_clip"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 8.0, 8.0, -1, 54, 0, false, false, false)
        end
    end,

    ["paper"] = function(ped)
        local animDict = "yoinks@rps@paper"
        local animation = "yoinks_rps_paper_clip"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 8.0, 8.0, -1, 54, 0, false, false, false)
        end
    end,

    ["scissors"] = function(ped)
        local animDict = "yoinks@rps@scissors"
        local animation = "yoinks_rps_scissors_clip"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 8.0, 8.0, -1, 54, 0, false, false, false)
        end
    end,

    ["strum"] = function(ped)
        local animDict = "amb@world_human_musician@guitar@male@idle_a"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["drum"] = function(ped)
        local animDict = "anim@mp_player_intincarair_drumsbodhi@ds@"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["piano"] = function(ped)
        local animDict = "piano@clear@custom_anim"
        local animation = "piano"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
        end
    end,

    ["squat"] = function(ped)
        local animDict = "squat@nikez"
        local animation = "squat_clip"

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 8.0, 8.0, -1, 2, 0, false, false, false)
        end
    end,

    ["opa"] = function(ped)
        local animDict = "yoinks@opa"
        local animation = "custom_clip"

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 8.0, 8.0, -1, 1, 0, false, false, false)
        end
    end,

    ["griddy"] = function(ped)
        local animDict = "yoinks@griddy"
        local animation = "griddy_clip"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0, animLength, 47, 0, 0, 0, 0)
        end
    end,

    ["pixelcards"] = function(ped)
        local testdic = "yoinks@yugioh"
        local testanim = "yoinks_clip"

        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) and not handCuffed do
            Citizen.Wait(0)
        end

        if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
            ClearPedSecondaryTask(ped)
        else
            local animLength = GetAnimDuration(testdic, testanim)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 49, 0, 0,
                         0, 0)
        end
    end,

    -- Interactive Emotes
    ["makeitrain"] = function(ped)
        local animDict = "anim@mp_player_intupperraining_cash"
        local animation = "idle_a"
        if IsPedArmed(ped, 7) then
            TriggerEvent("actionbar:setEmptyHanded")
        end

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
                         animLength, 49, 0, 0, 0, 0)
            TriggerEvent("destroyProp")
        end
        TriggerEvent("attachItem", "wadofbills")
    end,
}

animsDog = {
    ["cancel"] = cancelAnim,
    ["dogsit"] = function(ped)
        TaskStartScenarioInPlace(ped, "WORLD_DOG_SITTING_ROTTWEILER", -1, true)
    end,

    ["bark"] = function(ped)
        local animDict = "creatures@rottweiler@amb@world_dog_barking@idle_a"
        local animation = "idle_a"

        loadAnimDict(animDict)
        local animLength = GetAnimDuration(animDict, animation)
        TaskPlayAnim(ped, animDict, animation, 1.0, 1.0, animLength, 0, 0, 0, 0, 0)
    end,

    ["bark2"] = function(ped)
        local animDict = "creatures@rottweiler@melee@streamed_taunts@"
        local animation = "taunt_02"

        loadAnimDict(animDict)
        local animLength = GetAnimDuration(animDict, animation)
        TaskPlayAnim(ped, animDict, animation, 1.0, 1.0, animLength, 0, 0, 0, 0, 0)
    end,

    ["bark3"] = function(ped)
        local animDict = "creatures@rottweiler@melee@streamed_taunts@"
        local animation = "taunt_01"

        loadAnimDict(animDict)
        local animLength = GetAnimDuration(animDict, animation)
        TaskPlayAnim(ped, animDict, animation, 1.0, 1.0, animLength, 0, 0, 0, 0, 0)
    end,

    ["bark4"] = function(ped)
        TaskStartScenarioInPlace(ped, "WORLD_DOG_BARKING_SHEPHERD", -1, true)
    end,

    ["bark5"] = function(ped)
        local animDict = "creatures@rottweiler@melee@streamed_taunts@"
        local animation = "taunt_01"

        loadAnimDict(animDict)
        local animLength = GetAnimDuration(animDict, animation)
        TaskPlayAnim(ped, animDict, animation, 1.0, 1.0, animLength, 48, 0, 0, 0, 0)
    end,

    ["beg"] = function(ped)
        local animDict = "creatures@rottweiler@tricks@"

        loadAnimDict(animDict)
        local sequenceId = OpenSequenceTask()
        TaskPlayAnim(0, animDict, "beg_enter", 8.0, -8.0, -1, 4096, 0, false, false, false)
        TaskPlayAnim(0, animDict, "beg_loop", 8.0, -8.0, -1, 4096, 0, false, false, false)
        TaskPlayAnim(0, animDict, "beg_loop", 8.0, -8.0, -1, 4096, 0, false, false, false)
        TaskPlayAnim(0, animDict, "beg_exit", 8.0, -8.0, -1, 4096, 0, false, false, false)
        CloseSequenceTask(sequenceId)
        TaskPerformSequence(ped, sequenceId)
        ClearSequenceTask()
    end,

    ["paw"] = function(ped)
        local animDict = "creatures@rottweiler@tricks@"

        loadAnimDict(animDict)
        local sequenceId = OpenSequenceTask()
        TaskPlayAnim(0, animDict, "sit_enter", 8.0, -8.0, -1, 4096, 0, false, false, false)
        TaskPlayAnim(0, animDict, "paw_right_enter", 8.0, -8.0, -1, 4096, 0, false, false, false)
        TaskPlayAnim(0, animDict, "paw_right_loop", 8.0, -8.0, -1, 4096, 0, false, false, false)
        TaskPlayAnim(0, animDict, "paw_right_loop", 8.0, -8.0, -1, 4096, 0, false, false, false)
        TaskPlayAnim(0, animDict, "paw_right_exit", 8.0, -8.0, -1, 4096, 0, false, false, false)
        TaskPlayAnim(0, animDict, "sit_exit", 8.0, -8.0, -1, 4096, 0, false, false, false)
        CloseSequenceTask(sequenceId)
        TaskPerformSequence(ped, sequenceId)
        ClearSequenceTask()
    end,

    ["pet"] = function(ped)
        local animDict = "creatures@rottweiler@tricks@"
        local animation = "petting_chop"

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(ped, animDict, animation, 1.0, 4.0, animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["dump"] = function(ped)
        local animDict = "creatures@rottweiler@move"

        loadAnimDict(animDict)
        local sequenceId = OpenSequenceTask()
        TaskPlayAnim(0, animDict, "dump_enter", 8.0, -8.0, -1, 4096, 0, false, false, false)
        TaskPlayAnim(0, animDict, "dump_loop", 8.0, -8.0, -1, 4096, 0, false, false, false)
        TaskPlayAnim(0, animDict, "dump_exit", 8.0, -8.0, -1, 4096, 0, false, false, false)
        CloseSequenceTask(sequenceId)
        TaskPerformSequence(ped, sequenceId)
        ClearSequenceTask()
    end,

    ["pee"] = function(ped)
        local animDict = "creatures@rottweiler@move"

        loadAnimDict(animDict)
        local sequenceId = OpenSequenceTask()
        TaskPlayAnim(0, animDict, "pee_right_enter", 8.0, -8.0, -1, 4096, 0, false, false, false)
        TaskPlayAnim(0, animDict, "pee_right_idle", 8.0, -8.0, -1, 4096, 0, false, false, false)
        TaskPlayAnim(0, animDict, "pee_right_exit", 8.0, -8.0, -1, 4096, 0, false, false, false)
        CloseSequenceTask(sequenceId)
        TaskPerformSequence(ped, sequenceId)
        ClearSequenceTask()
    end,

    ["indicateahead"] = function(ped)

        local animDict = "creatures@rottweiler@indication@"
        local animation = "indicate_ahead"

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
           loadAnimDict(animDict)
            local animLength = GetAnimDuration(animDict, animation)
            TaskPlayAnim(ped, animDict, animation, 1.0, 4.0, animLength, 0, 0, 0, 0, 0)
        end
    end,

    ["kennel"] = function(ped)
        local animDict = "creatures@rottweiler@amb@sleep_in_kennel@"

        loadAnimDict(animDict)
        TaskPlayAnim(ped, animDict, "sleep_in_kennel", 1000.0, -8.0, -1, 1, 0, false, false, false)
        Citizen.CreateThread(function()
            while playing_emote do
                if IsControlJustReleased(0, 38) then
                    TaskPlayAnim(ped, animDict, "exit_kennel", 8.0, -8.0, -1, 0, 0, false, false, false)
                    Wait(8000)
                    endanims(lastanimplayed)
                end
                Wait(0)
            end
        end)
    end,

    ["laydown"] = function(ped)
        local animDict = "creatures@rottweiler@move"
        local animation = "dying"

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            TaskPlayAnim(ped, animDict, animation, 1.0, -1, -1, 2, 0, 0, 0, 0)
        end
    end,

    ["carsit"] = function(ped)
        local animDict = "creatures@rottweiler@in_vehicle@std_car"
        local playerVeh = GetVehiclePedIsIn(PlayerPedId())
        if playerVeh == 0 then return end

        local vehLayout = GetVehicleLayoutHash(playerVeh);
        if vehLayout == -1965057835 or vehLayout == 919485892 or vehLayout == -1838563680 or vehLayout == 1768419516
        or vehLayout == 1576485197 or vehLayout == 929009548 or vehLayout == -497732145
        or vehLayout == -1659990386 or vehLayout == -662028469 or vehLayout == 1939145032 then
            animDict = "creatures@rottweiler@in_vehicle@van"
        end
        if vehLayout == -2066252141 or vehLayout == 1105669833 or vehLayout == 542797648 or vehLayout == 68566729
        or vehLayout == -1887744178 or vehLayout == -782720499 or vehLayout == -1150063973 or vehLayout == 1630950849
        or vehLayout == -463340997 or vehLayout == 2033852426 then
            animDict = "creatures@rottweiler@in_vehicle@low_car"
        end
        if vehLayout == 434478421 or vehLayout == 1816176348 or vehLayout == 1710903184 or vehLayout == 1663892749 then
            animDict = "creatures@rottweiler@in_vehicle@4x4"
        end

        loadAnimDict(animDict)
        TaskPlayAnim(ped, animDict, "sit", 1000.0, -1000.0, -1, 33, 0, false, false, false)
    end,

    ["carenter"] = function(ped)
        local animDict = "creatures@rottweiler@in_vehicle@std_car"
        local currentTarget = exports['ev-target']:GetCurrentEntity()
        local playerVeh = IsModelAVehicle(GetEntityModel(currentTarget)) and currentTarget or 0
        if playerVeh == 0 then return end

        local vehLayout = GetVehicleLayoutHash(playerVeh)
        if vehLayout == -1965057835 or vehLayout == 919485892 or vehLayout == -1838563680 or vehLayout == 1768419516
        or vehLayout == 1576485197 or vehLayout == 929009548 or vehLayout == -497732145
        or vehLayout == -1659990386 or vehLayout == -662028469 or vehLayout == 1939145032 then
            animDict = "creatures@rottweiler@in_vehicle@van"
        end
        if vehLayout == -2066252141 or vehLayout == 1105669833 or vehLayout == 542797648 or vehLayout == 68566729
        or vehLayout == -1887744178 or vehLayout == -782720499 or vehLayout == -1150063973 or vehLayout == 1630950849
        or vehLayout == -463340997 or vehLayout == 2033852426 then
            animDict = "creatures@rottweiler@in_vehicle@low_car"
        end
        if vehLayout == 434478421 or vehLayout == 1816176348 or vehLayout == 1710903184 or vehLayout == 1663892749 then
            animDict = "creatures@rottweiler@in_vehicle@4x4"
        end

        loadAnimDict(animDict)

        local seatBone, doorIndex, seatIndex, zRot = nil, nil, nil, 0.0
        local currentTargetCoords = exports['ev-target']:GetCurrentTargetCoords()
        local frontPassengerSideDist = #(currentTargetCoords - GetWorldPositionOfEntityBone(playerVeh, GetEntityBoneIndexByName(playerVeh, "seat_pside_f")))
        local rearPassengerSideDist = #(currentTargetCoords - GetWorldPositionOfEntityBone(playerVeh, GetEntityBoneIndexByName(playerVeh, "seat_pside_r")))
        local rearDriverSideDist = #(currentTargetCoords - GetWorldPositionOfEntityBone(playerVeh, GetEntityBoneIndexByName(playerVeh, "seat_dside_r")))

        if frontPassengerSideDist < rearPassengerSideDist and frontPassengerSideDist < rearDriverSideDist then
            seatBone = "seat_pside_f"
            doorIndex = 1
            seatIndex = 0
        elseif rearPassengerSideDist < rearDriverSideDist then
            seatBone = "seat_pside_r"
            doorIndex = 3
            seatIndex = 3
        else
            seatBone = "seat_dside_r"
            doorIndex = 2
            seatIndex = 3
            zRot = 200.0
        end

        if GetPedInVehicleSeat(playerVeh, seatIndex) ~= 0 then return end

        Sync.SetVehicleDoorOpen(playerVeh, doorIndex, false, false)
        SetPedCanRagdoll(ped, false)
        Wait(300)
        local netScene = NetworkCreateSynchronisedScene(0, 0, 0, 0, 0, zRot, 2, false, false, 1065353216, 0, 1.3)
        NetworkAttachSynchronisedSceneToEntity(netScene, playerVeh, GetEntityBoneIndexByName(playerVeh, seatBone))
        NetworkAddPedToSynchronisedScene(ped, netScene, animDict, "get_in", 1000.0, -8.0, 4.0, 0, 1000.0, 0)
        NetworkStartSynchronisedScene(netScene)
        Wait(2000)
        TaskWarpPedIntoVehicle(ped, playerVeh, seatIndex)
        Wait(1000)
        ForcePedAiAndAnimationUpdate(ped, true, true)
        TaskPlayAnim(ped, animDict, "sit", 8.0, -8.0, -1, 1, 0, false, false, false)
        Sync.SetVehicleDoorShut(playerVeh, doorIndex, false)
        Wait(1000)
        SetPedCanRagdoll(ped, true)
    end,

    ["carleave"] = function(ped)
        local animDict = "creatures@rottweiler@in_vehicle@std_car"
        local playerVeh = GetVehiclePedIsIn(PlayerPedId())
        if playerVeh == 0 then return end

        local vehLayout = GetVehicleLayoutHash(playerVeh)
        if vehLayout == -1965057835 or vehLayout == 919485892 or vehLayout == -1838563680 or vehLayout == 1768419516
        or vehLayout == 1576485197 or vehLayout == 929009548 or vehLayout == -497732145
        or vehLayout == -1659990386 or vehLayout == -662028469 or vehLayout == 1939145032 then
            animDict = "creatures@rottweiler@in_vehicle@van"
        end
        if vehLayout == -2066252141 or vehLayout == 1105669833 or vehLayout == 542797648 or vehLayout == 68566729
        or vehLayout == -1887744178 or vehLayout == -782720499 or vehLayout == -1150063973 or vehLayout == 1630950849
        or vehLayout == -463340997 or vehLayout == 2033852426 then
            animDict = "creatures@rottweiler@in_vehicle@low_car"
        end
        if vehLayout == 434478421 or vehLayout == 1816176348 or vehLayout == 1710903184 or vehLayout == 1663892749 then
            animDict = "creatures@rottweiler@in_vehicle@4x4"
        end

        loadAnimDict(animDict)

        local seatBone, doorIndex, zRot = nil, nil, 0.0
        local frontPassengerSidePed = GetPedInVehicleSeat(playerVeh, 0)
        local rearPassengerSidePed = GetPedInVehicleSeat(playerVeh, 2)
        local rearMiddlePed = GetPedInVehicleSeat(playerVeh, 3)

        if frontPassengerSidePed == ped then
            seatBone = "seat_pside_f"
            doorIndex = 1
        elseif rearPassengerSidePed == ped or (rearMiddlePed == ped and rearPassengerSidePed == 0) then
            seatBone = "seat_pside_r"
            doorIndex = 3
        else
            seatBone = "seat_dside_r"
            doorIndex = 2
            zRot = 200.0
        end

        SetPedCanRagdoll(ped, false)
        Sync.SetVehicleDoorOpen(playerVeh, doorIndex, false, false)
        local netScene = NetworkCreateSynchronisedScene(0, 0, 0, 0, 0, zRot, 2, false, false, 1065353216, 0, 1.3)
        NetworkAttachSynchronisedSceneToEntity(netScene, playerVeh, GetEntityBoneIndexByName(playerVeh, seatBone))
        NetworkAddPedToSynchronisedScene(ped, netScene, animDict, "get_out", 1000.0, -8.0, 4.0, 0, 1000.0, 0)
        NetworkStartSynchronisedScene(netScene)
        TaskLeaveVehicle(ped, playerVeh, 16)
        ForcePedAiAndAnimationUpdate(ped, true, true)
        Wait(2000)
        ForcePedAiAndAnimationUpdate(ped, true, true)
        Sync.SetVehicleDoorShut(playerVeh, doorIndex, false)
        ClearPedTasks(ped)
        Wait(4000)
        SetPedCanRagdoll(ped, true)
    end,
}

animsSmallDog = {
    ["cancel"] = cancelAnim,
    ["dogsit"] = function(ped)
        TaskStartScenarioInPlace(ped, "WORLD_DOG_SITTING_SMALL", -1, true)
    end,

    ["bark"] = function(ped)
        local animDict = "creatures@pug@amb@world_dog_barking@idle_a"
        local animation = "idle_a"

        loadAnimDict(animDict)
        local animLength = GetAnimDuration(animDict, animation)
        TaskPlayAnim(ped, animDict, animation, 1.0, 1.0, animLength, 0, 0, 0, 0, 0)
    end,

    ["laydown"] = function(ped)
        local animDict = "creatures@pug@move"
        local animation = "dying"

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            TaskPlayAnim(ped, animDict, animation, 1.0, -1, -1, 2, 0, 0, 0, 0)
        end
    end,
}

animsCat = {
  ["cancel"] = cancelAnim,
  ["catsleep"] = function(ped)

      local animDict = "creatures@cat@amb@world_cat_sleeping_ground@enter"
      local animation = "enter"

      if IsPedArmed(ped, 7) then
          TriggerEvent("actionbar:setEmptyHanded")
      end 

      if IsEntityPlayingAnim(ped, animDict, animation, 3) then
          ClearPedSecondaryTask(ped)
      else
          loadAnimDict(animDict)
          TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, -1, -1, 2, 0, 0, 0, 0)
      end
  end,

  ["catsit"] = function(ped)

      local animDict = "creatures@cat@amb@world_cat_sleeping_ledge@idle_a"
      local animation = "idle_a"

      if IsPedArmed(ped, 7) then
          TriggerEvent("actionbar:setEmptyHanded")
      end

      if IsEntityPlayingAnim(ped, animDict, animation, 3) then
          ClearPedSecondaryTask(ped)
      else
          loadAnimDict(animDict)
          TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, -1, -1, 2, 0, 0, 0, 0)
      end
  end,

  ["catstretch"] = function(ped)

      local animDict = "creatures@cat@amb@peyote@enter"
      local animation = "enter"

      if IsPedArmed(ped, 7) then
          TriggerEvent("actionbar:setEmptyHanded")
      end

      if IsEntityPlayingAnim(ped, animDict, animation, 3) then
          ClearPedSecondaryTask(ped)
      else
          loadAnimDict(animDict)
          TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, -1, -1, 2, 0, 0, 0, 0)
      end
  end,
}

animsBigCat = {
  ["cancel"] = cancelAnim,
  ["bigcatpace"] = function(ped)

      local animDict = "anim@scripted@island@hs4_scope_cctv_p1@panther@"
      local animation = "pace_v2"

      if IsPedArmed(ped, 7) then
          TriggerEvent("actionbar:setEmptyHanded")
      end

      if IsEntityPlayingAnim(ped, animDict, animation, 3) then
          ClearPedSecondaryTask(ped)
      else
          loadAnimDict(animDict)
          TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, -1, -1, 2, 0, 0, 0, 0)
      end
  end,

  ["bigcatrest"] = function(ped)
    TaskStartScenarioInPlace(ped, "WORLD_MOUNTAIN_LION_REST", -1, true)
  end,

  ["bigcatrest2"] = function(ped)

      local animDict = "anim@scripted@island@hs4_scope_cctv_p1@panther@"
      local animation = "rest_base"

      if IsPedArmed(ped, 7) then
          TriggerEvent("actionbar:setEmptyHanded")
      end

      if IsEntityPlayingAnim(ped, animDict, animation, 3) then
          ClearPedSecondaryTask(ped)
      else
          loadAnimDict(animDict)
          TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, -1, -1, 2, 0, 0, 0, 0)
      end
  end,

  ["bigcatrest3"] = function(ped)

      local animDict = "anim@scripted@island@hs4_scope_cctv_p1@panther@"
      local animation = "rest_front"

      if IsPedArmed(ped, 7) then
          TriggerEvent("actionbar:setEmptyHanded")
      end

      if IsEntityPlayingAnim(ped, animDict, animation, 3) then
          ClearPedSecondaryTask(ped)
      else
          loadAnimDict(animDict)
          TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, -1, -1, 2, 0, 0, 0, 0)
      end
  end,

  ["bigcatrest4"] = function(ped)

      local animDict = "anim@scripted@island@hs4_scope_cctv_p1@panther@"
      local animation = "rest_left"

      if IsPedArmed(ped, 7) then
          TriggerEvent("actionbar:setEmptyHanded")
      end

      if IsEntityPlayingAnim(ped, animDict, animation, 3) then
          ClearPedSecondaryTask(ped)
      else
          loadAnimDict(animDict)
          TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, -1, -1, 2, 0, 0, 0, 0)
      end
  end,

  ["bigcatrest5"] = function(ped)

      local animDict = "creatures@cougar@amb@world_cougar_rest@idle_a"
      local animation = "idle_a"

      if IsPedArmed(ped, 7) then
          TriggerEvent("actionbar:setEmptyHanded")
      end

      if IsEntityPlayingAnim(ped, animDict, animation, 3) then
          ClearPedSecondaryTask(ped)
      else
          loadAnimDict(animDict)
          TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, -1, -1, 2, 0, 0, 0, 0)
      end
  end,

  ["bigcatvehicle"] = function(ped)

      local animDict = "creatures@retriever@amb@world_dog_sitting@idle_a"
      local animation = "idle_a"

      if IsPedArmed(ped, 7) then
          TriggerEvent("actionbar:setEmptyHanded")
      end

      if IsEntityPlayingAnim(ped, animDict, animation, 3) then
          ClearPedSecondaryTask(ped)
      else
          loadAnimDict(animDict)
          TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, -1, -1, 2, 0, 0, 0, 0)
      end
  end,

  ["bigcatattack"] = function(ped)

      local animDict = "creatures@cougar@melee@streamed_core@"
      local animation = "ground_attack_0"

      if IsPedArmed(ped, 7) then
          TriggerEvent("actionbar:setEmptyHanded")
      end

      if IsEntityPlayingAnim(ped, animDict, animation, 3) then
          ClearPedSecondaryTask(ped)
      else
          loadAnimDict(animDict)
          TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, -1, -1, 2, 0, 0, 0, 0)
          Wait(2800)
          ClearPedTasks(ped)
      end
  end,
  
  ["bigcatdead"] = function(ped)

    local animDict = "creatures@cougar@move"
    local animation = "dead_right"

    if IsPedArmed(ped, 7) then
        TriggerEvent("actionbar:setEmptyHanded")
    end

    if IsEntityPlayingAnim(ped, animDict, animation, 3) then
        ClearPedSecondaryTask(ped)
    else
        loadAnimDict(animDict)
        TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, -1, -1, 2, 0, 0, 0, 0)
    end
end,

    ["laydown"] = function(ped)
        local animDict = "creatures@cougar@move"
        local animation = "dying"

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            TaskPlayAnim(ped, animDict, animation, 1.0, -1, -1, 2, 0, 0, 0, 0)
        end
    end,
}

animsCoyote = {
    ["cancel"] = cancelAnim,
    ["coyoterest"] = function(ped)
        TaskStartScenarioInPlace(ped, "WORLD_COYOTE_REST", -1, true)
    end,

    ["coyotehowl"] = function(ped)
        TaskStartScenarioInPlace(ped, "WORLD_COYOTE_HOWL", -1, true)
    end,

    ["laydown"] = function(ped)
        local animDict = "creatures@coyote@move"
        local animation = "dying"

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            TaskPlayAnim(ped, animDict, animation, 1.0, -1, -1, 2, 0, 0, 0, 0)
        end
    end,
}

animsDeer = {
    ["cancel"] = cancelAnim,
    ["deergraze"] = function(ped)
        TaskStartScenarioInPlace(ped, "WORLD_DEER_GRAZING", -1, true)
    end,
    ["laydown"] = function(ped)
        local animDict = "creatures@deer@move"
        local animation = "dying"

        if IsEntityPlayingAnim(ped, animDict, animation, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(animDict)
            TaskPlayAnim(ped, animDict, animation, 1.0, -1, -1, 2, 0, 0, 0, 0)
        end
    end,
}

animsBear = {
    ["cancel"] = cancelAnim,
    ["sit"] = function(ped)
        local dictName = 'bear@animation'
        local animName = 'bearsquat'

        if IsEntityPlayingAnim(ped, dictName, animName, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(dictName)
            TaskPlayAnim(PlayerPedId(), dictName, animName, 2.0, 2.0, -1, 2, 0.0)
        end
    end,
    ["salute"] = function(ped)
        local dictName = "bear@animation"
        local animName = "bearsalute"

        if IsEntityPlayingAnim(ped, dictName, animName, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(dictName)
            TaskPlayAnim(PlayerPedId(), dictName, animName, 2.0, 2.0, -1, 2, 0.0)
        end
    end,
    ["dance"] = function(ped)
        local dictName = "bear@animation"
        local animName = "beardance"

        if IsEntityPlayingAnim(ped, dictName, animName, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(dictName)
            TaskPlayAnim(PlayerPedId(), dictName, animName, 2.0, 2.0, -1, 1, 0.0)
        end
    end,
    ["yes"] = function(ped)
        local dictName = "bear@animation"
        local animName = "bearnod"

        if IsEntityPlayingAnim(ped, dictName, animName, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(dictName)
            TaskPlayAnim(PlayerPedId(), dictName, animName, 2.0, 2.0, -1, 1, 0.0)
        end
    end,
    ["no"] = function(ped)
        local dictName = "bear@animation"
        local animName = "bearnopers"

        if IsEntityPlayingAnim(ped, dictName, animName, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(dictName)
            TaskPlayAnim(PlayerPedId(), dictName, animName, 2.0, 2.0, -1, 1, 0.0)
        end
    end,
    ["wave"] = function(ped)
        local dictName = "bear@animation"
        local animName = "bearwave"

        if IsEntityPlayingAnim(ped, dictName, animName, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(dictName)
            TaskPlayAnim(PlayerPedId(), dictName, animName, 2.0, 2.0, -1, 0, 0.0)
        end
    end,
    ["fall"] = function(ped)
        local dictName = "bear@animation"
        local animName = "bearfalling"

        if IsEntityPlayingAnim(ped, dictName, animName, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(dictName)
            TaskPlayAnim(PlayerPedId(), dictName, animName, 2.0, 2.0, -1, 2, 0.0)
        end
    end,
    ["getup"] = function(ped)
        local dictName = "creatures@deer@getup"
        local animName = "getup_l"

        if IsEntityPlayingAnim(ped, dictName, animName, 3) then
            ClearPedSecondaryTask(ped)
        else
            loadAnimDict(dictName)
            TaskPlayAnim(PlayerPedId(), dictName, animName, 2.0, 2.0, -1, 0, 0.0)
        end
    end,
}


local function PlayAnim2(ped, anim, dict, exit)
    if stuckincar then return end
    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do Citizen.Wait(0) end

    if IsEntityPlayingAnim(ped, dict, anim, 3) then
        ClearPedSecondaryTask(ped)
    else
        local animlength = math.ceil(GetAnimDuration(dict, anim) * 1000)

        TaskPlayAnim(ped, dict, anim, 1.0, 1.0, animlength, 48, 0, 0, 0, 0)

    end
end

function EndAnim(dict, anim)

    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do Citizen.Wait(0) end
    animlength = GetAnimDuration(dict, anim) * 1000

    TaskPlayAnim(PlayerPedId(), dict, anim, 999999.0, 1.0, animlength, 48, 0, 0,
                 0, 0)
end

local dogs = {
    [`a_c_shepherd`] = true,
    [`a_c_retriever`] = true,
    [`a_c_rottweiler`] = true,
    [`a_c_husky`] = true,
    [`a_c_chop`] = true,
    [`a_c_shepherd_np`] = true,
    [`a_c_husky_np`] = true,
    [`a_c_chop_np`] = true,
    [`a_c_pit_np`] = true,
    [`a_c_retriever_np`] = true,
}

local smalldogs = {
    [`a_c_westy`] = true,
    [`a_c_westy_np`] = true,
    [`a_c_pug`] = true,
    [`a_c_pug_np`] = true,
    [`a_c_poodle`] = true,
}

local cats = {
    [`a_c_cat_01`] = true,
    [`a_c_racoon_01`] = true,
}

local bigcats = {
  [`a_c_panther`] = true,
  [`a_c_mtlion`] = true,
  [`a_c_leopard`] = true,
}

local deerlikeModels = {
    [`a_c_deer`] = true,
    [`a_c_horse`] = true
}

AddEventHandler("animation:PlayAnimation", function(anim)
    if imdead == 0 and not stuckincar and not IsPedGettingUp(PlayerPedId()) then
        local ped = PlayerPedId()

        if ped then

            if playing_emote then
                endanims(anim)
                if lastanimplayed == anim then return end
            end

            lastanimplayed = anim
            playing_emote = true
            local animName = string.lower(anim)
            local anim = nil
            local model = GetEntityModel(PlayerPedId())

            if dogs[model] then
                anim = animsDog[animName]
            elseif smalldogs[model] then
                anim = animsSmallDog[animName]
            elseif cats[model] then
                anim = animsCat[animName]
            elseif bigcats[model] then
              anim = animsBigCat[animName]
            elseif model == `a_c_coyote` then
                anim = animsCoyote[animName]
            elseif deerlikeModels[model] then
                anim = animsDeer[animName]
            elseif model == `BrnBear` then
                anim = animsBear[animName]
            else
                anim = anims[animName]
            end


            if not anim then
                playing_emote = false
                return
            end

            if restrictedEmotes[animName] then
                local time = GetGameTimer()
                if emoteCooldowns[animName] and time - emoteCooldowns[animName] < 5000 then
                    return
                end
                emoteCooldowns[animName] = time
            end

            if type(anim) == "function" then
                anim(ped);
                StressTest(animName);
                return
            end

            if type(anim) == "table" and anim.t == 1 then
                PlayAnim2(ped, anim.a, anim.d, anim.e);
                StressTest(animName);
                return
            end

            if not (IsPedInAnyVehicle(PlayerPedId(), false)) then

                if anim == "WORLD_HUMAN_PAPARAZZI" or anim ==
                    "WORLD_HUMAN_MOBILE_FILM_SHOCKING" then
                    TriggerEvent("evidence:trigger")
                end

                TaskStartScenarioInPlace(ped, anim, 0, false)
                playing_emote = false
                --
            end

            StressTest(animName)

        end
    end
end)

function StressTest(animName)
    if (animName == "pushups" or animName == "situps" or animName == "chinups" or
        animName == "weights") and
        (#(GetEntityCoords(PlayerPedId()) - vector3(1744.53, 2646.94, 45.61)) <
            10.0 or
            #(GetEntityCoords(PlayerPedId()) - vector3(1777.21, 2495.7, 45.83)) <
            10.0) then
        local finished =
            exports["ev-taskbar"]:taskBar(15000, "Relieving Stress")
        if finished == 100 then
            TriggerEvent("client:newStress", false, math.random(100, 550))
            playing_emote = false
        end
    end
end

RegisterNetEvent('umbrellaLoop')
AddEventHandler('umbrellaLoop', function()

    while obj ~= 0 do
        Citizen.Wait(1)

        local dead = exports["isPed"]:isPed("dead")
        if dead then TriggerEvent("animation:PlayAnimation", "umbrella") end
        local curw = GetSelectedPedWeapon(PlayerPedId())
        local noweapon = `WEAPON_UNARMED`
        if noweapon ~= curw then
            TriggerEvent("animation:PlayAnimation", "umbrella")
        end
        if not IsEntityPlayingAnim(PlayerPedId(),
                                   "amb@code_human_wander_drinking@male@base",
                                   "static", 3) then
            ClearPedTasks(PlayerPedId())
            loadAnimDict("amb@code_human_wander_drinking@male@base")
            TaskPlayAnim(PlayerPedId(),
                         "amb@code_human_wander_drinking@male@base", "static",
                         1.0, 1.0, -1, 49, 0, 0, 0, 0)

        end
        ClearPedWetness(PlayerPedId())
    end
    ClearPedTasks(PlayerPedId())
end)

function getVehicleInDirection(coordFrom, coordTo)
    local offset = 0
    local rayHandle
    local vehicle
    for i = 0, 100 do
        rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z,
                                        coordTo.x, coordTo.y,
                                        coordTo.z + offset, 10, PlayerPedId(), 0)
        a, b, c, d, vehicle = GetRaycastResult(rayHandle)
        offset = offset - 1
        if vehicle ~= 0 then break end
    end
    local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
    if distance > 25 then vehicle = nil end
    return vehicle ~= nil and vehicle or 0
end

-- nikes is looser

RegisterNetEvent('notepad')
AddEventHandler('notepad', function()

    local veh = GetVehiclePedIsUsing(PlayerPedId())
    if GetPedInVehicleSeat(veh, -1) ~= PlayerPedId() then

        RequestAnimDict("amb@medic@standing@timeofdeath@base")
        while not HasAnimDictLoaded("amb@medic@standing@timeofdeath@base") do
            Citizen.Wait(0)
        end
        TriggerEvent("attachItem", "notepad01")
        TriggerEvent("attachItem69", "pencil01")
        TaskPlayAnim(PlayerPedId(), "amb@medic@standing@timeofdeath@base",
                     "base", 8.0, 0.01, -1, 49, 0, 0, 0, 0)
        Citizen.Wait(1000)
        while IsEntityPlayingAnim(PlayerPedId(),
                                  "amb@medic@standing@timeofdeath@base", "base",
                                  3) do Citizen.Wait(1) end

        RequestAnimDict("amb@medic@standing@timeofdeath@exit")
        while not HasAnimDictLoaded("amb@medic@standing@timeofdeath@exit") do
            Citizen.Wait(0)
        end
        TaskPlayAnim(PlayerPedId(), "amb@medic@standing@timeofdeath@exit",
                     "exit", 0.1, 1.0, 1.0, 48, 0, 0, 0, 0)

        Citizen.Wait(5000)
        TriggerEvent("destroyProp")
        TriggerEvent("destroyProp69")

    else
        TriggerEvent("DoShortHudText", "In Vehicle.", 2)
    end

end)

RegisterNetEvent('animation:runtextanim2')
AddEventHandler('animation:runtextanim2', function(anim)
    TriggerEvent("animation:PlayAnimation", anim)
end)
-- p_cop_tutdealer_leaning@idle_b idle_e

-- mp_suicide pistol

RegisterNetEvent("expressions")
AddEventHandler("expressions", function(pArgs)
    if #pArgs ~= 1 then return end
    local expressionName = pArgs[1]
    SetFacialIdleAnimOverride(PlayerPedId(), expressionName, 0)
    return
end)

RegisterNetEvent("expressions:clear")
AddEventHandler("expressions:clear",
                function() ClearFacialIdleAnimOverride(PlayerPedId()) end)
