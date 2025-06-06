local lastDamageTaken = {
  hash = "",
  source = -1,
  melee = false,
}

RegisterServerEvent('police:isDead')
AddEventHandler('police:isDead', function(pDeathHash, pDeathSource, pIsViolent, pIsMinor)
  local src = source
  local ped = GetPlayerPed(src)

  lastDamageTaken.hash = pDeathHash
  local deathSource = GetPedSourceOfDeath(player)
  if not deathSource or deathSource == 0 then deathSource = lastDamageTaken.source end

  local killer = pDeathSource ~= -1 and pDeathSource or deathSource
  local title = GetPlayerName(src) .. "(" .. src .. ")" .. " is Dead"
  TriggerEvent("ev-log:server:CreateLog", "DeathStatus", title, "red", "**" .. GetPlayerName(src) .. "** (" .. src .. ") " .. " Has Been Killed By " .. killer)
end)

RegisterServerEvent('reviveGranted')
AddEventHandler('reviveGranted', function(t)
  local src = source
  if t then src = t end

  TriggerClientEvent('reviveFunction', t)
end)

RegisterServerEvent('serverCPR')
AddEventHandler('serverCPR', function()
  TriggerClientEvent('revive', source)
end)

RegisterServerEvent('ragdoll:dead')
AddEventHandler('ragdoll:dead', function(state)
  local src = source
  local user = exports["ev-base"]:getModule("Player"):GetUser(src)

  local cid = user:getCurrentCharacter().id
  if not cid then return end

  MySQL.update.await([[
        UPDATE characters
        SET is_dead = ?
        WHERE id = ?
    ]],
    { state, cid })
end)

RegisterServerEvent('ragdoll:emptyInventory')
AddEventHandler('ragdoll:emptyInventory', function()
  local src = source
  local user = exports["ev-base"]:getModule("Player"):GetUser(src)

  local cid = user:getCurrentCharacter().id
  if not cid then return end

  TriggerEvent("ev-inventory:clear", src, cid)
end)

RPC.register('ev-ragdoll:fetchDeaths', function(src)
  local user = exports["ev-base"]:getModule("Player"):GetUser(src)

  local cid = user:getCurrentCharacter().id
  if not cid then return end

  return GetDeathCount(cid)
end)

RPC.register('ev-ragdoll:addDeath', function(src, pMinor)
  local user = exports["ev-base"]:getModule("Player"):GetUser(src)

  local cid = user:getCurrentCharacter().id
  if not cid then return end

  if not pMinor then
    local count = GetDeathCount(cid)

    local deaths = MySQL.update.await([[
            UPDATE characters
            SET deathes = ?
            WHERE id = ?
        ]],
      { count + 1, cid })

    return GetDeathCount(cid)
  else
    return GetDeathCount(cid)
  end
end)


function GetDeathCount(cid)
  local deaths = MySQL.scalar.await([[
        SELECT deathes
        FROM characters
        WHERE id = ?
    ]],
    { cid })

  return deaths
end

function isDead(cid)
  local data = MySQL.scalar.await([[
        SELECT is_dead
        FROM characters
        WHERE id = ?
    ]],
    { cid })

  return data
end

exports("GetDeathCount", GetDeathCount)
exports("isDead", isDead)
