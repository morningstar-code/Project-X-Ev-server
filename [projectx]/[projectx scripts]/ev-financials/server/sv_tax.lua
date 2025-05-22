taxLevels = {}

Citizen.CreateThread(function()
    local taxQuery = "SELECT * FROM _tax_level"
    local taxQuery2 = "SELECT * FROM _tax_category"
    local taxLevelData = Await(SQL.execute(taxQuery))
    local taxCategoryData = Await(SQL.execute(taxQuery2))

    for k, v in pairs(taxLevelData) do
        taxLevels[v.tax_category_id] = {}
        taxLevels[v.tax_category_id].level = v.tax_level
    end

    Wait(2000)

    for _, taxCategory in pairs(taxCategoryData) do
        if taxLevels[taxCategory.id] then
            taxLevels[taxCategory.id].name = taxCategory.name
        else
            taxLevels[taxCategory.id] = { name = taxCategory.name, level = 0 }
        end
    end

    -- ✅ REGISTER AFTER TAXES ARE LOADED
    RPC.register("PriceWithTaxString", function(pAmount, pTaxCategory)
        if not pAmount or not pTaxCategory then return nil end

        -- ✅ Safety check
        if not taxLevels or next(taxLevels) == nil then
            print("[Tax Debug] Tax levels not loaded yet")
            return nil
        end

        local taxAmount = calculateTax(pAmount, pTaxCategory)
        local percentage = getTaxLevelByName(pTaxCategory)
        if not taxAmount or not percentage then return nil end

        return {
            total = math.floor(taxAmount),
            text = ("(%s%% Tax)"):format(percentage)
        }
    end)
end)


-- pActualTaxPercentage [Optional]
-- If you set this paramter you will override the currentTaxRateWith whatever you set, i.e. good to use on old transactions
function taxOfSale(pSalesPrice, pTaxCategory, pActualTaxPercentage)
    local taxLevel = --[[pActualTaxPercentage or ]] getTaxLevel(pTaxCategory)
    return math.ceil(pSalesPrice - (pSalesPrice / (1 + (taxLevel / 100))))
end

function calculateTax(pSalesPrice, pTaxCategory)
    local taxLevel = getTaxLevel(pTaxCategory)
    local totalPrice = pSalesPrice + taxOfSale(pSalesPrice, pTaxCategory)

    return totalPrice
end

function purchaseTaxableItem(pSourceAccountId, pTargetAccountId, pPrice, pTaxType, pTransactionNote, pTargetAccountBalanceMinus)
    local price = calculateTax(pPrice, pTaxType)

    local currBalance = getAccountBalance(pSourceAccountId)

    if currBalance < price then
        return { ok = false, message = "Not enough money :(" }
    end
    -- TODO: put tax in state acct
    -- TODO: put balance in pTargetAccountId minus pTargetAccountBalanceMinus
    local result = adjustAccountBalance(pSourceAccountId, "remove", price)
    if not result then
        return { ok = false, message = "Could not adjust account balance" }
    end
    return { ok = true, price = price }
end

function cancelTaxableAsset(pAssetType, pAssetId)
    if not pAssetType then return false end
    if not pAssetId then return false end

    local cancelTaxQuery = [[
        DELETE FROM _tax_asset WHERE `asset_type` = ? and `asset_id` = ?
    ]]

    local pResult = Await(SQL.execute(cancelTaxQuery, pAssetType, pAssetId))

    return pResult.affectedRows > 0
end

function priceWithTaxString(pPrice, pTaxCategoryId)
    if not pPrice then return false end
    if not pTaxCategoryId then return false end
    local taxLevel = getTaxLevel(pTaxCategoryId)
    local totalPrice = pPrice + taxOfSale(pPrice, pTaxCategoryId)

    local data = { text = totalPrice..(" Incl. %s tax"):format(taxLevel.."%"), total = totalPrice}

    return data
end

function hasOutStandingTaxPayments(pCharacterId, pAssetType)
    if not pCharacterId then return false end

    local hasDebtQuery = [[
        SELECT TRUE as 'HAS_ANY_DEBT' FROM _tax_payment tp INNER JOIN _tax_asset ta ON ta.id = tp.tax_payment_id WHERE ta.asset_owner_id = ? AND !tp.is_paid
    ]]

    if pAssetType then
        hasDebtQuery = hasDebtQuery .. " AND asset_type = ?"
    end

    hasDebtQuery = hasDebtQuery .. " LIMIT 1"

    return Await(SQL.scalar(hasDebtQuery, pCharacterId, pAssetType)) or false
end

function getTaxLevelById(pTaxCategoryId)
    local categoryId = tonumber(pTaxCategoryId)
    if taxLevels[categoryId] then
        return taxLevels[categoryId].level
    else
        return 0
    end
end

function getTaxLevelByName(pTaxCategoryName)
    if not pTaxCategoryName then return false end

    for k, v in pairs(taxLevels) do
        if v.name == pTaxCategoryName then
            return v.level
        end
    end

    print("[1] No tax level found for "..pTaxCategoryName)

    return 0
end

function getTaxCategoryIdByName(pTaxCategoryName)
    if not pTaxCategoryName then return false end

    for k, v in pairs(taxLevels) do
        if v.name == pTaxCategoryName then
            return k
        end
    end

    print("[2] No tax level found for "..pTaxCategoryName)

    return 0
end

function getTaxLevel(pTaxCategory)
    if (type(pTaxCategory) == "number") then
        return getTaxLevelById(pTaxCategory)
    elseif (type(pTaxCategory) == "string") then
        return getTaxLevelByName(pTaxCategory)
    end

    return 0
end

function setTaxLevel(pOptions)
    local option = pOptions[1]
    local id = option.id
    local new_level = option.new_level

    local query = [[
        UPDATE _tax_level SET tax_new_level = @new_level WHERE tax_category_id = @id
    ]]

    local result = Await(SQL.execute(query, {
        id = id,
        new_level = new_level
    }))

    return result and result or false, result and result or "No tax levels found"
end

function getTaxLevels(pOnlyEditable)
    local query = [[
        SELECT
            tl.tax_level as 'level',
            tl.tax_new_level as 'new_level',
            tc.name as 'name',
            tc.id as 'id'
        FROM
            _tax_level tl
            INNER JOIN _tax_category tc ON tc.id = tl.tax_category_id
    ]]

    if pOnlyEditable then
        query = query .. [[
            WHERE tl.is_editable = 1
        ]]
    end

    local result = Await(SQL.execute(query))

    return result and result or false, result and result or "No tax levels found"
end

function getTaxHistory()
    return false, "Not implemented yet"
end

function getAssetTaxes(pCid)
    return false, "Not implemented yet"
end

exports("GetTaxLevel", getTaxLevel)
exports("GetTaxLevelById", getTaxLevelById)
exports("PriceWithTaxString", priceWithTaxString)
exports("CalculateTax", calculateTax)
exports("TaxOfSale", taxOfSale)
exports("GenerateTaxableAsset", generateTaxableAsset)
exports("CancelTaxableAsset", cancelTaxableAsset)
exports("purchaseTaxableItem", purchaseTaxableItem)
exports("HasOutstandingTaxPayments", hasOutStandingTaxPayments)


RegisterCommand("taxdebug", function()
    Citizen.SetTimeout(3000, function()
        local result = RPC.execute("PriceWithTaxString", 1000, "Services")
        print(json.encode(result))
    end)
end)



