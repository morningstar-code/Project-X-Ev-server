local trailer = nil

Citizen.CreateThread(function()
  local entry = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "miscscripts_vehicletrailer_set",
            label = "Set Trailer",
            icon = "fas fa-circle",
            event = "ev-miscscripts:vehicletrailer:set",
            parameters = {},
        },
				{
					id = "miscscripts_vehicletrailer_open",
					label = "Open Trailer",
					icon = "fas fa-circle",
					event = "ev-miscscripts:vehicletrailer:openDoor",
					parameters = {},
				},
				{
					id = "miscscripts_vehicletrailer_close",
					label = "Close Trailer",
					icon = "fas fa-circle",
					event = "ev-miscscripts:vehicletrailer:closeDoor",
					parameters = {},
				},
				{
					id = "miscscripts_vehicletrailer_lower_ramp",
					label = "Lower Top Ramp",
					icon = "fas fa-circle",
					event = "ev-miscscripts:vehicletrailer:lowerTop",
					parameters = {},
				},
				{
					id = "miscscripts_vehicletrailer_up_ramp",
					label = "Reset Top Ramp",
					icon = "fas fa-circle",
					event = "ev-miscscripts:vehicletrailer:toggleTop",
					parameters = {},
				}
    },
    options = {
        distance = { radius = 2.5 },
        isEnabled = function(pEntity)
          local model = GetEntityModel(pEntity)
          return model == `tr2`
        end,
    }
  }
  exports["ev-interact"]:AddPeekEntryByEntityType(entry.group, entry.data, entry.options)
end)


local topDown = false
RegisterCommand("toggletop", function()

	if topDown then
		Sync.SetVehicleDoorShut(trailer, 4, false, false)
		topDown = false
	else
		topDown = true
		Sync.SetVehicleDoorOpen(trailer, 4, false, false)
	end

end, false)

RegisterCommand("setcar", function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

	local targetCoords = GetEntityCoords(vehicle, false)
	local offset = GetOffsetFromEntityGivenWorldCoords(trailer, targetCoords.x, targetCoords.y, targetCoords.z)
	local entityRotation = GetEntityRotation(vehicle, 2)
	print(entityRotation)
	AttachEntityToEntity(vehicle, trailer, 0.0, offset.x, offset.y, offset.z, entityRotation.x, entityRotation.y, 0.0, false, false, true, false, 0, true)
end, false)

RegisterCommand("unsetcar", function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

	DetachEntity(vehicle, true, true)
end, false)

RegisterNetEvent("ev-miscscripts:vehicletrailer:set")
AddEventHandler("ev-miscscripts:vehicletrailer:set", function(pContext, pEntity)
	trailer = pEntity
	TriggerEvent("DoLongHudText", "Successfully set trailer", 1)
end)

RegisterNetEvent("ev-miscscripts:vehicletrailer:openDoor")
AddEventHandler("ev-miscscripts:vehicletrailer:openDoor", function(pContext, pEntity)
	Sync.SetVehicleDoorOpen(pEntity, 5, false, false)
	TriggerEvent("DoLongHudText", "Successfully opened trailer", 1)
end)

RegisterNetEvent("ev-miscscripts:vehicletrailer:closeDoor")
AddEventHandler("ev-miscscripts:vehicletrailer:closeDoor", function(pContext, pEntity)
	Sync.SetVehicleDoorShut(pEntity, 5, true, true)
	TriggerEvent("DoLongHudText", "Successfully closed trailer", 1)
end)

RegisterNetEvent("ev-miscscripts:vehicletrailer:toggleTop")
AddEventHandler("ev-miscscripts:vehicletrailer:toggleTop", function(pContext, pEntity)
	Sync.SetVehicleDoorShut(pEntity, 4, 0, 1)
end)

RegisterNetEvent("ev-miscscripts:vehicletrailer:lowerTop")
AddEventHandler("ev-miscscripts:vehicletrailer:lowerTop", function(pContext, pEntity)
	Sync.SetVehicleDoorOpen(pEntity, 4, 0, 1)
end)

function isVehicleDoorOpen(pEntity, pDoor)
	return GetVehicleDoorAngleRatio(pEntity, pDoor) >= 0.1
end
