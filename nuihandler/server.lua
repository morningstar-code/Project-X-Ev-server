local function debugPrint(msg)
    print("[ev-ui server] " .. msg)
end

local function sendResult(src, callbackEvent, data)
    if data == nil then data = {} end
    debugPrint("Sending result for event: " .. callbackEvent)
    TriggerClientEvent(callbackEvent, src, data)
end

local function executeQuery(sql, params, src, callbackEvent, singleRow)
    exports.oxmysql:execute(sql, params, function(result)
        if result == nil then
            debugPrint("DB query returned nil for SQL: " .. sql)
            sendResult(src, callbackEvent, singleRow and {} or {})
        else
            if singleRow then
                sendResult(src, callbackEvent, result[1] or {})
            else
                sendResult(src, callbackEvent, result)
            end
        end
    end)
end

-- List-type stub events (return empty array)
local arrayUiStubs = {
    "ev-ui:getTwats",
    "ev-ui:getTwatterBlue",
    "ev-ui:createDocument",
    "ev-ui:li:getEmails",
    "ev-ui:li:getAdURL",
    "ev-storageunits:client:getUnits",
    "ev-ui:getCurrentApartment",
    "ev-ui:getApartmentTypes",
    "ev-ui:nlts:getDrivers",
    "ev-ui:mdtAction",
    "ev-ui:getEmploymentInformation",
    "ev-ui:getDocumentTypes"
}

for _, ev in ipairs(arrayUiStubs) do
    RegisterNetEvent(ev, function(data, callbackEvent)
        local src = source
        debugPrint("Stub event triggered: " .. ev)
        sendResult(src, callbackEvent, {})
    end)
end

-- Main SQL-backed events:

RegisterNetEvent("ev-ui:laptop:getAuctionItems", function(data, callbackEvent)
    local src = source
    debugPrint("getAuctionItems called")
    executeQuery('SELECT * FROM av_boosting', {}, src, callbackEvent)
end)

RegisterNetEvent("ev-ui:abdultaxi:signOffDuty", function(data, callbackEvent)
    local src = source
    debugPrint("abdultaxi:signOffDuty called")
    executeQuery('SELECT * FROM abdultaxi_drivers WHERE is_on_duty = 1', {}, src, callbackEvent)
end)

RegisterNetEvent("ev-ui:getDocuments", function(data, callbackEvent)
    local src = source
    debugPrint("getDocuments called")
    executeQuery('SELECT * FROM _document_type', {}, src, callbackEvent)
end)

RegisterNetEvent("ev-ui:getDocumentContent", function(data, callbackEvent)
    local src = source
    local id = data.id
    debugPrint("getDocumentContent called with id=" .. tostring(id))
    if not id then
        debugPrint("Missing id param for getDocumentContent")
        sendResult(src, callbackEvent, {})
        return
    end
    executeQuery('SELECT * FROM _document_type WHERE id = ?', {id}, src, callbackEvent, true)
end)

RegisterNetEvent("ev-ui:startEditDocument", function(data, callbackEvent)
    local src = source
    debugPrint("startEditDocument called (stub)")
    sendResult(src, callbackEvent, {})
end)

RegisterNetEvent("ev-ui:nlts:signOffDuty", function(data, callbackEvent)
    local src = source
    debugPrint("nlts:signOffDuty called")
    executeQuery('SELECT * FROM nlts_drivers WHERE is_on_duty = 1', {}, src, callbackEvent)
end)

RegisterNetEvent("ev-ui:getContacts", function(data, callbackEvent)
    local src = source
    local cid = data.cid or data.characterId or data.character_id
    debugPrint("getContacts called for cid=" .. tostring(cid))
    if not cid then
        debugPrint("Missing cid param for getContacts")
        sendResult(src, callbackEvent, {})
        return
    end
    executeQuery('SELECT * FROM _phone_contacts WHERE character_id = ?', {cid}, src, callbackEvent)
end)

RegisterNetEvent("ev-ui:getConversations", function(data, callbackEvent)
    local src = source
    local cid = data.cid or data.characterId or data.character_id
    debugPrint("getConversations called for cid=" .. tostring(cid))
    if not cid then
        debugPrint("Missing cid param for getConversations")
        sendResult(src, callbackEvent, {})
        return
    end
    executeQuery('SELECT * FROM phone_conversations WHERE character_id = ?', {cid}, src, callbackEvent)
end)

RegisterNetEvent("ev-ui:getJobCenterJobs", function(data, callbackEvent)
    local src = source
    debugPrint("getJobCenterJobs called")
    executeQuery('SELECT * FROM businesses', {}, src, callbackEvent)
end)

RegisterNetEvent("ev-ui:getAllLicenses", function(data, callbackEvent)
    local src = source
    debugPrint("getAllLicenses called")
    executeQuery('SELECT * FROM bans', {}, src, callbackEvent)
end)

RegisterNetEvent("ev-ui:getAccountCharacters", function(data, callbackEvent)
    local src = source
    debugPrint("getAccountCharacters called")
    executeQuery('SELECT * FROM characters', {}, src, callbackEvent)
end)

RegisterNetEvent("ev-ui:getApartmentInformation", function(data, callbackEvent)
    local src = source
    local cid = data.cid or data.characterId or data.character_id
    debugPrint("getApartmentInformation called for cid=" .. tostring(cid))
    if not cid then
        debugPrint("Missing cid param for getApartmentInformation")
        sendResult(src, callbackEvent, {})
        return
    end
    executeQuery('SELECT * FROM housing WHERE cid = ?', {cid}, src, callbackEvent)
end)

RegisterNetEvent("ev-ui:getBusinessEmployees", function(data, callbackEvent)
    local src = source
    local business_id = data.business_id or data.id
    debugPrint("getBusinessEmployees called for business_id=" .. tostring(business_id))
    if not business_id then
        debugPrint("Missing business_id param for getBusinessEmployees")
        sendResult(src, callbackEvent, {})
        return
    end
    executeQuery('SELECT * FROM _business_employee WHERE business_id = ?', {business_id}, src, callbackEvent)
end)

RegisterNetEvent("ev-ui:getBusinessRoles", function(data, callbackEvent)
    local src = source
    local business_id = data.business_id or data.id
    debugPrint("getBusinessRoles called for business_id=" .. tostring(business_id))
    if not business_id then
        debugPrint("Missing business_id param for getBusinessRoles")
        sendResult(src, callbackEvent, {})
        return
    end
    executeQuery('SELECT * FROM _business_role WHERE business_id = ?', {business_id}, src, callbackEvent)
end)

RegisterNetEvent("ev-ui:getBusinessTypes", function(data, callbackEvent)
    local src = source
    debugPrint("getBusinessTypes called")
    executeQuery('SELECT * FROM _business_type', {}, src, callbackEvent)
end)

RegisterNetEvent("ev-ui:getDispatchData", function(data, callbackEvent)
    local src = source
    debugPrint("getDispatchData called")
    executeQuery('SELECT * FROM dispatch_log', {}, src, callbackEvent)
end)

RegisterNetEvent("ev-ui:getHousingData", function(data, callbackEvent)
    local src = source
    debugPrint("getHousingData called")
    executeQuery('SELECT * FROM housing', {}, src, callbackEvent)
end)

RegisterNetEvent("ev-ui:getProperties", function(data, callbackEvent)
    local src = source
    debugPrint("getProperties called")
    executeQuery('SELECT * FROM housing', {}, src, callbackEvent)
end)

RegisterNetEvent("ev-ui:getTaxOptions", function(data, callbackEvent)
    local src = source
    debugPrint("getTaxOptions called")
    executeQuery('SELECT * FROM _tax_levels', {}, src, callbackEvent)
end)

RegisterNetEvent("ev-ui:getYellowPages", function(data, callbackEvent)
    local src = source
    debugPrint("getYellowPages called")
    executeQuery('SELECT * FROM _phone_advert', {}, src, callbackEvent)
end)

RegisterNetEvent("ev-ui:getDOJData", function(data, callbackEvent)
    local src = source
    debugPrint("getDOJData called (stub)")
    sendResult(src, callbackEvent, {})
end)

RegisterNetEvent("ev-ui:getBlockedTwatterUsers", function(data, callbackEvent)
    local src = source
    local cid = data.cid or data.characterId or data.character_id
    debugPrint("getBlockedTwatterUsers called for cid=" .. tostring(cid))
    if not cid then
        debugPrint("Missing cid param for getBlockedTwatterUsers")
        sendResult(src, callbackEvent, {})
        return
    end
    executeQuery('SELECT * FROM _phone_twat_block WHERE cid = ?', {cid}, src, callbackEvent)
end)

RegisterNetEvent("ev-ui:getCars", function(data, callbackEvent)
    local src = source
    debugPrint("getCars called")
    executeQuery('SELECT * FROM carshop_vehicles', {}, src, callbackEvent)
end)

RegisterNetEvent("ev-ui:getCharacterDetails", function(data, callbackEvent)
    local src = source
    local cid = data.cid or data.characterId or data.character_id
    debugPrint("getCharacterDetails called for cid=" .. tostring(cid))
    if not cid then
        debugPrint("Missing cid param for getCharacterDetails")
        sendResult(src, callbackEvent, {})
        return
    end
    executeQuery('SELECT * FROM characters WHERE id = ?', {cid}, src, callbackEvent, true)
end)

RegisterNetEvent("ev-ui:getLicenses", function(data, callbackEvent)
    local src = source
    local cid = data.cid or data.characterId or data.character_id
    debugPrint("getLicenses called for cid=" .. tostring(cid))
    if not cid then
        debugPrint("Missing cid param for getLicenses")
        sendResult(src, callbackEvent, {})
        return
    end
    executeQuery('SELECT ul.*, l.name, l.code FROM user_licenses ul LEFT JOIN _license l ON l.code = ul.code WHERE ul.character_id = ?', {cid}, src, callbackEvent)
end)

RegisterNetEvent("ev-ui:getLoans", function(data, callbackEvent)
    local src = source
    debugPrint("getLoans called (stub)")
    sendResult(src, callbackEvent, {})
end)

RegisterNetEvent("ev-ui:getNewsArchives", function(data, callbackEvent)
    local src = source
    debugPrint("getNewsArchives called")
    executeQuery('SELECT * FROM _news', {}, src, callbackEvent)
end)

RegisterNetEvent("ev-ui:getNewspaperContent", function(data, callbackEvent)
    local src = source
    local nid = data.news_id or data.newsId or data.id
    debugPrint("getNewspaperContent called for id=" .. tostring(nid))
    if not nid then
        debugPrint("Missing news id param for getNewspaperContent")
        sendResult(src, callbackEvent, {})
        return
    end
    executeQuery('SELECT * FROM _news WHERE id = ?', {nid}, src, callbackEvent, true)
end)

RegisterNetEvent("ev-ui:getAssetTaxes", function(data, callbackEvent)
    local src = source
    debugPrint("getAssetTaxes called")
    executeQuery('SELECT * FROM financials_tax_levels', {}, src, callbackEvent)
end)

RegisterNetEvent("ev-ui:getAccounts", function(data, callbackEvent)
    local src = source
    local cid = data.cid or data.characterId or data.character_id
    debugPrint("getAccounts called for cid=" .. tostring(cid))
    if not cid then
        debugPrint("Missing cid param for getAccounts")
        sendResult(src, callbackEvent, {})
        return
    end

    local sql = [[
        SELECT a.id, a.account_type, a.balance, a.account_number, a.name
        FROM _account a
        INNER JOIN _account_access aa ON aa.account_id = a.id
        WHERE aa.character_id = ?
    ]]
    executeQuery(sql, {cid}, src, callbackEvent)
end)

RegisterNetEvent("ev-ui:getAccountTransactions", function(data, callbackEvent)
    local src = source
    local accountId = data.accountId or data.account_id
    debugPrint("getAccountTransactions called for accountId=" .. tostring(accountId))
    if not accountId then
        debugPrint("Missing accountId param for getAccountTransactions")
        sendResult(src, callbackEvent, {})
        return
    end
    executeQuery("SELECT * FROM _account_transactions WHERE account_id = ? ORDER BY id DESC LIMIT 50", {accountId}, src, callbackEvent)
end)

RegisterNetEvent("ev-ui:cancelNotepadEmote", function(data, callbackEvent)
    local src = source
    debugPrint("cancelNotepadEmote called")
    sendResult(src, callbackEvent, {success = true})
end)
