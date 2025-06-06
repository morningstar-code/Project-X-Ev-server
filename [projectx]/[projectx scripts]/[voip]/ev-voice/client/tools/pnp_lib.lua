EV = {}
EV.isDead = false

myJob = "unemployed"
isJudge = false
isDoctor = false
isNews = false
isDoc = false
isPolice = false
isMedic = false
isDead = false
isInstructorMode = false
isCloaked = false

RegisterNetEvent('ev-ui:settings', function(key, value)
    if key ~= 'ev-preferences' then
        return
    end
    local newPhoneVolume = value['phone.volume'] * 10
    local newRadioVolume = value['radio.volume'] * 10

    if newPhoneVolume ~= PhoneVolume then
        SetPhoneVolume(value['phone.volume'] * 10)
    end

    if newRadioVolume ~= RadioVolume then
        SetRadioVolume(value['radio.volume'] * 10)
        SetATCRadioVolume(value['radio.volume'] * 10)
    end

    local radioBalance = value['radio.balance']

    exports['ev-voice']:SetSubmixBalance('radio', radioBalance)
    exports['ev-voice']:SetSubmixBalance('radio_medium_distance', radioBalance)
    exports['ev-voice']:SetSubmixBalance('radio_far_distance', radioBalance)
    exports['ev-voice']:SetSubmixBalance('atc', radioBalance)
    exports['ev-voice']:SetSubmixBalance('drivethru', radioBalance)

    exports['ev-voice']:SetSubmixBalance('phone', value['phone.balance'])
end)

RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
    if not EV.isDead then
        EV.isDead = true
        isDead = true
    else
        EV.isDead = false
        isDead = false
    end
end)

RegisterNetEvent("ev-jobmanager:playerBecameJob")
AddEventHandler("ev-jobmanager:playerBecameJob", function(job, name, notify)
    myJob = job

    if not CanUseFrequency(CurrentChannel, nil, myJob) then
        return SetRadioFrequency()
    end
end)

RegisterNetEvent('ev-admin:cloakStatus', function (pCloaked)
    isCloaked = pCloaked
end)

function IsEmergency(OverWrite)
    local currentJob = exports["isPed"]:isPed("myjob")
    if OverWrite ~= nil then currentJob = OverWrite end


    if currentJob == "police" then return true end
    if currentJob == "ems" then return true end
    if currentJob == "doctor" then return true end
    if currentJob == "doc" then return true end
    if currentJob == "therapist" then return true end

    return false
end

function CanUseFrequency(pFrequency, pNotify, jobOverWrite)
    if not pFrequency then return false end

    if pFrequency == 0 then return true end

    local hasPDRadio = exports["ev-inventory"]:hasEnoughOfItem("radio", 1, false, true)
    local hasCivRadio = exports["ev-inventory"]:hasEnoughOfItem("civradio", 1, false, true)

    local frequency = type(pFrequency) == 'table' and pFrequency.id or pFrequency
    if frequency <= 20 and (not hasPDRadio or not IsEmergency(jobOverWrite)) then
        if pNotify then TriggerEvent('DoLongHudText', 'This frequency is encrypted.', 2) end
        return false
    elseif frequency > 20 and not hasCivRadio then
        if pNotify then TriggerEvent('DoLongHudText', 'PD Walkie cannot operate in civ frequencies.', 2) end
        return false
    end

    return true
end

AddEventHandler('playerSpawned', function()
    myJob = exports["isPed"]:isPed("myjob")
    local initialHudSettings = exports["ev-ui"]:GetPreferences()
    if initialHudSettings['radio.volume'] then
        SetRadioVolume(initialHudSettings['radio.volume'] * 10, true)
        SetATCRadioVolume(initialHudSettings['radio.volume'] * 10, true)
    end
    if initialHudSettings['phone.volume'] then
        SetPhoneVolume(initialHudSettings['phone.volume'] * 10)
    end
    if initialHudSettings['phone.balance'] ~= nil then
        exports['ev-voice']:SetSubmixBalance('phone', initialHudSettings['phone.balance'])
    end
    if initialHudSettings['radio.balance'] ~= nil then
        local radioBalance = initialHudSettings['radio.balance']

        exports['ev-voice']:SetSubmixBalance('radio', radioBalance)
        exports['ev-voice']:SetSubmixBalance('radio_medium_distance', radioBalance)
        exports['ev-voice']:SetSubmixBalance('radio_far_distance', radioBalance)
        exports['ev-voice']:SetSubmixBalance('atc', radioBalance)
        exports['ev-voice']:SetSubmixBalance('drivethru', radioBalance)
    end
end)

exports("CanUseFrequency", CanUseFrequency)