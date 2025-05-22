local EmployedAt, UpdatedAt = {}, 0
local PermissionCache = {}

function RefreshEmploymentList()
    local characterId = exports['isPed']:isPed('cid')

    local _, employment = RPC.execute("GetEmploymentInformation", { character = { id = characterId } })

    EmployedAt, UpdatedAt = {}, GetGameTimer()

    -- Defensive check for nil/non-table result
    if type(employment) == "table" then
        for _, business in ipairs(employment) do
            if business.code then
                EmployedAt[business.code] = true
            end
        end
    else
        print("^1[ev-business] WARNING: employment data was nil or not a table!^7")
    end
end

exports('RefreshEmploymentList', RefreshEmploymentList)

function IsEmployedAt(pBusiness)
    if (GetGameTimer() - UpdatedAt) > 1 * 60000 then RefreshEmploymentList() end

    return EmployedAt[pBusiness] == true
end

exports('IsEmployedAt', IsEmployedAt)

function HasPermission(pBusiness, pPermission)
    if not PermissionCache[pBusiness] then
        PermissionCache[pBusiness] = {}
    end
    if not PermissionCache[pBusiness][pPermission] or (GetGameTimer() - PermissionCache[pBusiness][pPermission].UpdatedAt) > 15 * 60000 then
        local cid = exports["isPed"]:isPed("cid")
        local success = RPC.execute("ev-business:hasPermission", pBusiness, pPermission, cid)
        PermissionCache[pBusiness][pPermission] = {
            UpdatedAt = GetGameTimer(),
            hasPermission = success
        }
    end
    return PermissionCache[pBusiness][pPermission].hasPermission
end

exports('HasPermission', HasPermission)

RegisterNetEvent('ev-spawn:characterSpawned')
AddEventHandler('ev-spawn:characterSpawned', RefreshEmploymentList)

RegisterCommand("hotreload", function()
    RefreshEmploymentList()
end)

RegisterNetEvent('ev-business:employmentStatus')
AddEventHandler('ev-business:employmentStatus', function(pBusiness, pEmployed)
    EmployedAt[pBusiness] = pEmployed
end)

RegisterNetEvent('ev-business:bustPermissionCache')
AddEventHandler('ev-business:bustPermissionCache', function(pBusiness)
    PermissionCache[pBusiness] = nil
end)
