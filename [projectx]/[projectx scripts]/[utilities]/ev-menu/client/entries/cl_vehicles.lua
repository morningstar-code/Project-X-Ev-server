local VehicleEntries = MenuEntries['vehicles']

VehicleEntries[#VehicleEntries+1] = {
  data = {
      id = "247goods",
      title = "Grab goods",
      icon = "#obj-box",
      event = "ev-jobs:247delivery:takeGoods"
  },
  isEnabled = function(pEntity, pContext)
    return not IsDisabled() and GetEntityModel(pEntity) == `benson` and isCloseToTrunk(pEntity, PlayerPedId()) and not IsPedInAnyVehicle(PlayerPedId(), false)
  end
}

VehicleEntries[#VehicleEntries+1] = {
    data = {
        id = "vehicle-parkvehicle",
        title = "Park Vehicle",
        icon = "#vehicle-parkvehicle",
        event = "vehicle:storeVehicle"
    },
    isEnabled = function(pEntity, pContext)
      return not IsDisabled() and exports['ev-vehicles']:HasVehicleKey(pEntity) and exports['ev-vehicles']:IsOnParkingSpot(pEntity, false) and not IsPedInAnyVehicle(PlayerPedId(), false)
    end
}

-- VehicleEntries[#VehicleEntries+1] = {
--   data = {
--       id = "impound-vehicle",
--       title = "Impound Request",
--       icon = "#vehicle-impound",
--       event = "ev-jobs:impound:openImpoundRequestMenu",
--       parameters = {}
--   },
--   isEnabled = function(pEntity, pContext)
--     return not IsDisabled() and pContext.distance <= 2.5 and not IsPedInAnyVehicle(PlayerPedId(), false)
--   end
-- }

VehicleEntries[#VehicleEntries+1] = {
  data = {
      id = "impound-vehicle",
      title = "Impound Request",
      icon = "#vehicle-impound",
      event = "ev-jobs:impound:openImpoundRequestMenu",
      parameters = {}
  },
  isEnabled = function(pEntity, pContext)
    return not IsDisabled() and pContext.distance <= 2.5 and not IsPedInAnyVehicle(PlayerPedId(), false)
  end
}

VehicleEntries[#VehicleEntries+1] = {
    data = {
        id = "impound-vehicle",
        title = "Impound Vehicle",
        icon = "#vehicle-impound",
        event = "ev-jobs:impound:openImpoundMenu",
    },
    isEnabled = function(pEntity, pContext)
      return not IsDisabled() and pContext.distance <= 2.5 and (CurrentJob == 'impound' or CurrentJob == 'pd_impound') and IsImpoundDropOff and not IsPedInAnyVehicle(PlayerPedId(), false)
    end
}

VehicleEntries[#VehicleEntries+1] = {
  data = {
      id = "prepare-boat-trailer",
      title = "Prep for Mount",
      icon = "#vehicle-plate-remove",
      event = "vehicle:primeTrailerForMounting"
  },
  isEnabled = function(pEntity, pContext)
    local model = GetEntityModel(pEntity)
    return not IsDisabled() and (model == `boattrailer` or model == `trailersmall`)
  end
}
