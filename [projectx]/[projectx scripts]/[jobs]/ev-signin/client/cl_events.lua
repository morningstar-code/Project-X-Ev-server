local listening = false
local lastPlate = nil

RegisterNetEvent('nowCopGarage')
AddEventHandler('nowCopGarage', function(job)
  TriggerServerEvent("ev:voice:radio:addPlayerToRadio", 1.0, GetPlayerServerId(PlayerId()))
  TriggerEvent('nowCopDeath')

  if job == "police" then
    TriggerEvent('nowCopSpawn')
  end

  SetPedRelationshipGroupDefaultHash(PlayerPedId(),`MISSION2`)
  SetPedRelationshipGroupHash(PlayerPedId(),`MISSION2`)
  SetPoliceIgnorePlayer(PlayerPedId(),true)
  TriggerEvent("armory:ammo")
end)

RegisterNetEvent("hasSignedOnEms")
AddEventHandler("hasSignedOnEms", function()
  SetPedRelationshipGroupDefaultHash(PlayerPedId(),`MISSION2`)
  SetPoliceIgnorePlayer(PlayerPedId(),true)
end)

RegisterUICallback("ev-signin:handler", function(data, cb)
  local eventData = data.key
  if eventData.sign_in then
    TriggerServerEvent("ev-signin:duty", eventData.job)
  elseif eventData.sign_off then
    signOff()
  end
  cb({ data = {}, meta = { ok = true, message = "done" } })
  --exports["ev-ui"]:hideContextMenu()
end)

RegisterUICallback("ev-signin:spawnVehicle", function(data, cb)
  local eventData = data.key
  if eventData == VOLUNTEER_VEHICLES.STANDARD then
    local currentJob = exports["isPed"]:isPed("myjob")
    if currentJob == "ems" then
      spawnVehicle("emsnspeedo")
    end
  elseif eventData == VOLUNTEER_VEHICLES.FIRETRUCK then
    local currentJob = exports["isPed"]:isPed("myjob")
    if currentJob == "ems" then
      spawnVehicle("firetruk")
    end
  end
  cb({ data = {}, meta = { ok = true, message = "done" } })
end)

function spawnVehicle(pVehicle)
  local spawnLocation = findClosestSpawnPoint(GetEntityCoords(PlayerPedId()))
  local getVehicleInArea = GetClosestVehicle(spawnLocation, 3.000, 0, 70)
  if DoesEntityExist(getVehicleInArea) then
    TriggerEvent("DoLongHudText", "The area is crowded", 2)
    return
  end

  if lastPlate ~= nil then
    TriggerEvent("ev-vehicles:keys:remove", lastPlate)
  end

  local vehicle = GetHashKey(pVehicle)
  RequestModel(vehicle)
  while not HasModelLoaded(vehicle) do
    Wait(0)
  end

  local plate = "EMS ".. GetRandomIntInRange(1000, 9000)
  local spawned_car = CreateVehicle(vehicle, spawnLocation, -20.0, true, false)

  SetVehicleNumberPlateText(spawned_car, plate)
  TriggerEvent("ev-vehicles:keys:addNew",spawned_car,plate)
  TriggerServerEvent('garages:addJobPlate', plate)
  SetPedIntoVehicle(PlayerPedId(), spawned_car, - 1)
  lastPlate = plate
  Wait(250)
end

AddEventHandler("ev-signin:peekAction", function(pArgs, pEntity, pContext)
  if not pArgs.name then return end

  local name = ("%s_sign_in"):format(pArgs.name)

  if name ~= "officer_sign_in" and name ~= "ems_sign_in" and name ~= "ems_volunteer_sign_in" and name ~= "fire_dept_sign_in" and name ~= "public_services_sign_in" and name ~= "driving_instructor_sign_in"  then return end

  exports["ev-ui"]:showContextMenu(MenuData[name])
end)

AddEventHandler("ev-signin:legalAid", function(pArgs, pEntity, pContext)
  TriggerEvent("DoLongHudText", "You now appear as a legal aid.")
  RPC.execute('ev-gov:dojApp:setStatus', "legal_aid", "Available")
end)


AddEventHandler('ev-island:hideBlips', function(pState)
  for _, item in pairs(Blips) do
    if DoesBlipExist(item.blip) then
      if pState then
        SetBlipAlpha(item.blip, 0)
        SetBlipHiddenOnLegend(item.blip, true)
      else
        SetBlipAlpha(item.blip, 255)
        SetBlipHiddenOnLegend(item.blip, false)
      end
    end
  end
end)

-- RegisterNetEvent('event:control:policeGarage')
-- AddEventHandler('event:control:policeGarage', function(useID)
-- 	if useID == 1 then
-- 		TriggerServerEvent('attemptduty')
-- 		TriggerEvent('raid_clothes:inService', true)
-- 	elseif useID == 2 then
-- 		if isCop then
-- 		    isCop = false
-- 			isInService = false
-- 			TriggerEvent('raid_clothes:inService', false)
-- 			TriggerServerEvent("TokoVoip:removePlayerFromAllRadio",GetPlayerServerId(PlayerId()))
-- 			TriggerServerEvent("jobssystem:jobs", "unemployed")
-- 			TriggerServerEvent('myskin_customization:wearSkin')
-- 			TriggerServerEvent('tattoos:retrieve')
-- 			TriggerServerEvent('Blemishes:retrieve')
-- 			TriggerEvent("police:noLongerCop")
-- 			TriggerEvent("logoffmedic")		
-- 			TriggerEvent("loggedoff")					
-- 			TriggerEvent('nowCopDeathOff')
-- 		    TriggerEvent('nowCopSpawnOff')
-- 		    TriggerEvent('nowMedicOff')
-- 		    TriggerServerEvent("TokoVoip:clientHasSelecterCharecter")

-- 		    SetPedRelationshipGroupHash(PlayerPedId(),`PLAYER`)
-- 		    SetPedRelationshipGroupDefaultHash(PlayerPedId(),`PLAYER`)
-- 		    SetPoliceIgnorePlayer(PlayerPedId(),false)
-- 		    TriggerEvent("DoLongHudText",'Signed off Duty!',1)
-- 	    end		
-- 	end
-- end)