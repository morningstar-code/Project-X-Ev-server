local teamPlayersEast = 0
local teamPlayersWest = 0
local gameInProgress = false
local inStadium = false
local flagProp = "prop_golfflag"
local flagPropHash = GetHashKey(flagProp)
local flagObjNetId = 0
local isCarryingFlag = false

local function drawStatusHud()
  if not inStadium then return end
  if gameInProgress or (teamPlayersEast + teamPlayersWest > 0) then
    exports["ev-ui"]:sendAppEvent("status-hud", {
      show = true,
      title = "Paintball - Match " .. (gameInProgress and "In Progress" or "Pending"),
      values = {
        "East Team: " .. teamPlayersEast .. " player(s)",
        "West Team: " .. teamPlayersWest .. " player(s)",
      },
    })
  else
    exports["ev-ui"]:sendAppEvent("status-hud", { show = false })
  end
end

AddEventHandler("ev-paintball:game:interact", function(pArgs)
  local action, ctx = pArgs[1], pArgs[2]
  local isEmp = isNpa()
  if (action == "start" or action == "end") and (not isEmp) then
    TriggerEvent("DoLongHudText", "Talk to a member of staff.", 2)
    return
  end
  RPC.execute("ev-paintball:game:action", action, ctx)
end)

RegisterNetEvent("ev-paintball:game:update", function(pCtx)
  if gameInProgress ~= pCtx.gameInProgress then
    removeAttachedProp()
  end
  -- if pCtx.gameInProgress and (not gameInProgress) then
  --   local url = DUI_URL
  --   local conf = {
  --     tex = "xs_prop_arena_bigscreen_01",
  --     txd = "script_rt_bigscreen_01",
  --     dui = nil,
  --   }
  --   conf.dui = exports["ev-lib"]:getDui(url, 512, 512)
  --   print(conf.dui)
  --   AddReplaceTexture(conf.txd, conf.tex, conf.dui.dictionary, conf.dui.texture)
  -- end
  teamPlayersEast = pCtx.teamPlayersEast
  teamPlayersWest = pCtx.teamPlayersWest
  gameInProgress = pCtx.gameInProgress
  drawStatusHud()
end)

AddEventHandler("ev-paintball:enterStadium", function()
  inStadium = true
  drawStatusHud()
end)
AddEventHandler("ev-paintball:leaveStadium", function()
  inStadium = false
  exports["ev-ui"]:sendAppEvent("status-hud", { show = false })
end)

Citizen.CreateThread(function()
  exports["ev-interact"]:AddPeekEntryByModel({ flagPropHash }, {
    {
      id = "paintballflag",
      event = "ev-paintball:game:pickupFlag",
      icon = "circle",
      label = "Pickup",
    },
  }, { distance = { radius = 1.25 } })
end)

-- Citizen.CreateThread(function()
--   Wait(2000)
--   RPC.execute("ev-paintball:game:action", "join", "east")
--   Wait(2000)
--   RPC.execute("ev-paintball:game:action", "start")
--   -- Wait(10000)
--   -- RPC.execute("ev-paintball:game:action", "end")
-- end)

RegisterNetEvent("ev-paintball:game:spawnFlag", function(pCoords)
  local flagObj = CreateObject(flagPropHash, pCoords, 1, 1, 0)
  Wait(0)
  TriggerServerEvent("ev-paintball:game:spawnedFlag", NetworkGetNetworkIdFromEntity(flagObj))
end)

function loadAnimDict(dict)
  while (not HasAnimDictLoaded(dict)) do
    RequestAnimDict(dict)
    Citizen.Wait(0)
  end
end
AddEventHandler("ev-paintball:game:pickupFlag", function()
  loadAnimDict('anim@narcotics@trash')
  TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 1700, 49, 1.0, 0, 0, 0)
  local finished = exports["ev-taskbar"]:taskBar(3000, "Picking up Flag")
  if finished ~= 100 then return end
  isCarryingFlag = true
  TriggerEvent("ev-props:attachProp", flagProp, 24818, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0)
  TriggerServerEvent("ev-paintball:game:pickedUpFlag")
  -- Wait(5000)
  -- removeAttachedProp()
end)

local isDead = false
AddEventHandler("pd:deathcheck", function()
  isDead = not isDead
  if not isDead then return end
  if gameInProgress and inStadium then
    RPC.execute("ev-paintball:game:action", "leave")
  end
  if not isCarryingFlag then return end
  TriggerEvent("ev-props:removeProp")
  local coordsC = GetEntityCoords(PlayerPedId())
  local coords = vector3(coordsC.x - 0.25, coordsC.y + 0.25, coordsC.z - 1.0)
  TriggerServerEvent("ev-paintball:game:diedWithFlag", coords)
end)
