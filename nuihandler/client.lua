local function debugPrint(msg)
    print("[ev-ui client] " .. msg)
end

local function safeCB(cb, data)
    if cb then
        cb(json.encode({ data = data or {} }))
    else
        debugPrint("Warning: NUI callback missing or nil!")
    end
end

local function nuiServerCallback(nuiEvent)
    RegisterNUICallback(nuiEvent, function(data, cb)
        local callbackEvent = nuiEvent .. ":cb:" .. tostring(math.random(100000, 999999))
        RegisterNetEvent(callbackEvent)
        local eventHandler
        eventHandler = function(result)
            RemoveEventHandler(eventHandler)
            safeCB(cb, result)
        end
        AddEventHandler(callbackEvent, eventHandler)
        TriggerServerEvent(nuiEvent, data, callbackEvent)
    end)
end

local serverEvents = {
    "ev-ui:getAccounts",
    "ev-ui:getAccountTransactions",
    "ev-ui:getContacts",
    "ev-ui:getConversations",
    "ev-ui:getAccountCharacters",
    "ev-ui:getApartmentInformation",
    "ev-ui:getBusinessEmployees",
    "ev-ui:getBusinessRoles",
    "ev-ui:getBusinessTypes",
    "ev-ui:getDispatchData",
    "ev-ui:getHousingData",
    "ev-ui:getProperties",
    "ev-ui:getTaxOptions",
    "ev-ui:getYellowPages",
    "ev-ui:getBlockedTwatterUsers",
    "ev-ui:getCharacterDetails",
    "ev-ui:getLicenses",
    "ev-ui:getNewsArchives",
    "ev-ui:getNewspaperContent",
    "ev-ui:getAssetTaxes",
    "ev-ui:getJobCenterJobs",
    "ev-ui:getAllLicenses",
    "ev-ui:getDocumentContent",
    "ev-ui:getDocuments",
    "ev-ui:getLoans",
    "ev-ui:getCars",
    "ev-ui:laptop:getAuctionItems",
    "ev-ui:abdultaxi:signOffDuty",
    "ev-ui:nlts:signOffDuty",
    "ev-ui:startEditDocument"
}

for _, eventName in ipairs(serverEvents) do
    nuiServerCallback(eventName)
end

-- Simple NUI callbacks without server communication:
RegisterNUICallback("ev-ui:cancelNotepadEmote", function(data, cb)
    safeCB(cb, { success = true })
end)



RegisterUICallback("ev-ui:laptop:getAuctionItems", function(data, cb)
    debugPrint("getAuctionItems called")
    executeQuery('SELECT * FROM av_boosting', {}, cb)
end)

RegisterUICallback("ev-ui:abdultaxi:signOffDuty", function(data, cb)
    debugPrint("abdultaxi:signOffDuty called")
    executeQuery('SELECT * FROM abdultaxi_drivers WHERE is_on_duty = 1', {}, cb)
end)

RegisterUICallback("ev-ui:getDocuments", function(data, cb)
    debugPrint("getDocuments called")
    executeQuery('SELECT * FROM _document_type', {}, cb)
end)

RegisterUICallback("ev-ui:getDocumentContent", function(data, cb)
    local id = data.id
    debugPrint("getDocumentContent called with id=" .. tostring(id))
    if not id then
        debugPrint("Missing id param for getDocumentContent")
        safeCallback(cb, {})
        return
    end
    executeQuery('SELECT * FROM _document_type WHERE id = ?', {id}, cb, true)
end)

RegisterUICallback("ev-ui:startEditDocument", function(data, cb)
    debugPrint("startEditDocument called (stub)")
    safeCallback(cb, {})
end)

RegisterUICallback("ev-ui:nlts:signOffDuty", function(data, cb)
    debugPrint("nlts:signOffDuty called")
    executeQuery('SELECT * FROM nlts_drivers WHERE is_on_duty = 1', {}, cb)
end)

RegisterUICallback("ev-ui:getContacts", function(data, cb)
    local cid = data.cid or data.characterId or data.character_id
    debugPrint("getContacts called for cid=" .. tostring(cid))
    if not cid then
        debugPrint("Missing cid param for getContacts")
        safeCallback(cb, {})
        return
    end
    executeQuery('SELECT * FROM _phone_contacts WHERE character_id = ?', {cid}, cb)
end)

RegisterUICallback("ev-ui:getConversations", function(data, cb)
    local cid = data.cid or data.characterId or data.character_id
    debugPrint("getConversations called for cid=" .. tostring(cid))
    if not cid then
        debugPrint("Missing cid param for getConversations")
        safeCallback(cb, {})
        return
    end
    executeQuery('SELECT * FROM phone_conversations WHERE character_id = ?', {cid}, cb)
end)

RegisterUICallback("ev-ui:getJobCenterJobs", function(data, cb)
    debugPrint("getJobCenterJobs called")
    executeQuery('SELECT * FROM businesses', {}, cb)
end)

RegisterUICallback("ev-ui:getAllLicenses", function(data, cb)
    debugPrint("getAllLicenses called")
    executeQuery('SELECT * FROM bans', {}, cb)
end)

RegisterUICallback("ev-ui:getAccountCharacters", function(data, cb)
    debugPrint("getAccountCharacters called")
    executeQuery('SELECT * FROM characters', {}, cb)
end)

RegisterUICallback("ev-ui:getApartmentInformation", function(data, cb)
    local cid = data.cid or data.characterId or data.character_id
    debugPrint("getApartmentInformation called for cid=" .. tostring(cid))
    if not cid then
        debugPrint("Missing cid param for getApartmentInformation")
        safeCallback(cb, {})
        return
    end
    executeQuery('SELECT * FROM housing WHERE cid = ?', {cid}, cb)
end)

RegisterUICallback("ev-ui:getBusinessEmployees", function(data, cb)
    local business_id = data.business_id or data.id
    debugPrint("getBusinessEmployees called for business_id=" .. tostring(business_id))
    if not business_id then
        debugPrint("Missing business_id param for getBusinessEmployees")
        safeCallback(cb, {})
        return
    end
    executeQuery('SELECT * FROM _business_employee WHERE business_id = ?', {business_id}, cb)
end)

RegisterUICallback("ev-ui:getBusinessRoles", function(data, cb)
    local business_id = data.business_id or data.id
    debugPrint("getBusinessRoles called for business_id=" .. tostring(business_id))
    if not business_id then
        debugPrint("Missing business_id param for getBusinessRoles")
        safeCallback(cb, {})
        return
    end
    executeQuery('SELECT * FROM _business_role WHERE business_id = ?', {business_id}, cb)
end)

RegisterUICallback("ev-ui:getBusinessTypes", function(data, cb)
    debugPrint("getBusinessTypes called")
    executeQuery('SELECT * FROM _business_type', {}, cb)
end)

RegisterUICallback("ev-ui:getDispatchData", function(data, cb)
    debugPrint("getDispatchData called")
    executeQuery('SELECT * FROM dispatch_log', {}, cb)
end)

RegisterUICallback("ev-ui:getHousingData", function(data, cb)
    debugPrint("getHousingData called")
    executeQuery('SELECT * FROM housing', {}, cb)
end)

RegisterUICallback("ev-ui:getProperties", function(data, cb)
    debugPrint("getProperties called")
    executeQuery('SELECT * FROM housing', {}, cb)
end)

RegisterUICallback("ev-ui:getTaxOptions", function(data, cb)
    debugPrint("getTaxOptions called")
    executeQuery('SELECT * FROM _tax_levels', {}, cb)
end)

RegisterUICallback("ev-ui:getYellowPages", function(data, cb)
    debugPrint("getYellowPages called")
    executeQuery('SELECT * FROM _phone_advert', {}, cb)
end)

RegisterUICallback("ev-ui:getDOJData", function(data, cb)
    debugPrint("getDOJData called (stub)")
    safeCallback(cb, {})
end)

RegisterUICallback("ev-ui:getBlockedTwatterUsers", function(data, cb)
    local cid = data.cid or data.characterId or data.character_id
    debugPrint("getBlockedTwatterUsers called for cid=" .. tostring(cid))
    if not cid then
        debugPrint("Missing cid param for getBlockedTwatterUsers")
        safeCallback(cb, {})
        return
    end
    executeQuery('SELECT * FROM _phone_twat_block WHERE cid = ?', {cid}, cb)
end)

RegisterUICallback("ev-ui:getCars", function(data, cb)
    debugPrint("getCars called")
    executeQuery('SELECT * FROM carshop_vehicles', {}, cb)
end)

RegisterUICallback("ev-ui:getCharacterDetails", function(data, cb)
    local cid = data.cid or data.characterId or data.character_id
    debugPrint("getCharacterDetails called for cid=" .. tostring(cid))
    if not cid then
        debugPrint("Missing cid param for getCharacterDetails")
        safeCallback(cb, {})
        return
    end
    executeQuery('SELECT * FROM characters WHERE id = ?', {cid}, cb, true)
end)

RegisterUICallback("ev-ui:getLicenses", function(data, cb)
    local cid = data.cid or data.characterId or data.character_id
    debugPrint("getLicenses called for cid=" .. tostring(cid))
    if not cid then
        debugPrint("Missing cid param for getLicenses")
        safeCallback(cb, {})
        return
    end
    executeQuery('SELECT ul.*, l.name, l.code FROM user_licenses ul LEFT JOIN _license l ON l.code = ul.code WHERE ul.character_id = ?', {cid}, cb)
end)

RegisterUICallback("ev-ui:getLoans", function(data, cb)
    debugPrint("getLoans called (stub)")
    safeCallback(cb, {})
end)

RegisterUICallback("ev-ui:getNewsArchives", function(data, cb)
    debugPrint("getNewsArchives called")
    executeQuery('SELECT * FROM _news', {}, cb)
end)

RegisterUICallback("ev-ui:getNewspaperContent", function(data, cb)
    local nid = data.news_id or data.newsId or data.id
    debugPrint("getNewspaperContent called for id=" .. tostring(nid))
    if not nid then
        debugPrint("Missing news id param for getNewspaperContent")
        safeCallback(cb, {})
        return
    end
    executeQuery('SELECT * FROM _news WHERE id = ?', {nid}, cb, true)
end)

RegisterUICallback("ev-ui:getAssetTaxes", function(data, cb)
    debugPrint("getAssetTaxes called")
    executeQuery('SELECT * FROM financials_tax_levels', {}, cb)
end)

RegisterUICallback("ev-ui:getAccounts", function(data, cb)
    local cid = data.cid or data.characterId or data.character_id
    debugPrint("getAccounts called for cid=" .. tostring(cid))
    if not cid then
        debugPrint("Missing cid param for getAccounts")
        safeCallback(cb, {})
        return
    end

    local sql = [[
        SELECT a.id, a.account_type, a.balance, a.account_number, a.name
        FROM _account a
        INNER JOIN _account_access aa ON aa.account_id = a.id
        WHERE aa.character_id = ?
    ]]
    executeQuery(sql, {cid}, cb)
end)

RegisterUICallback("ev-ui:getAccountTransactions", function(data, cb)
    local accountId = data.accountId or data.account_id
    debugPrint("getAccountTransactions called for accountId=" .. tostring(accountId))
    if not accountId then
        debugPrint("Missing accountId param for getAccountTransactions")
        safeCallback(cb, {})
        return
    end
    executeQuery("SELECT * FROM _account_transactions WHERE account_id = ? ORDER BY id DESC LIMIT 50", {accountId}, cb)
end)

RegisterUICallback("ev-ui:cancelNotepadEmote", function(data, cb)
    debugPrint("cancelNotepadEmote called")
    safeCallback(cb, {success = true})
end)
