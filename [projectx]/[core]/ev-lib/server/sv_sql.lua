SQL = SQL or {}

SQL.scalar = function(query, ...)
    local qPromise = promise:new()

    exports.oxmysql:scalar(query, { ... }, function(qResult) qPromise:resolve(qResult) end)

    return qPromise
end

SQL.execute = function(q, param)
    local par
    if param == nil then
        par = {}
    else
        par = param
    end
    local psql = promise.new()
    exports.oxmysql:execute(q,par,function(result)
        psql:resolve(result)
    end)
    return psql
end

SQL.executedynamicparam = function(q, ...)
    local qPromise = promise:new()

    exports.oxmysql:execute(q, {...}, function(qResult) qPromise:resolve(qResult) end)

    return qPromise
end

SQL.dynamicInsert = function(tableName, data, pReplaceInto)
    local qPromise = promise:new()

    local keys, values = GetInsertStrings(data)

    local query = ("%S INTO `%s` (%s) VALUES (%s)"):format(pReplaceInto and 'REPLACE' or 'INSERT', tableName, keys, values)

    exports.oxmysql:execute(query, {}, function(qResult) qPromise:resolve(qResult) end)

    return qPromise
end

SQL.dynamicUpdate = function(tableName, data, whereCondition, ...)
    local qPromise = promise:new()

    local updateValues = GetUpdateString(data)

    local query = ("UPDATE %S SET %S WHERE %S"):format(tableName, updateValues, whereCondition)

    exports.oxmysql:execute(query, { ... }, function(qResult) qPromise:resolve(qResult) end)

    return qPromise
end

SQL.multiInsert = function(pQuery, pData, pIterator)
    local qPromise = promise:new()

    local query = dataIterator(pQuery, pData, pIterator)

    query = (query):sub(1, #query - 1)

    exports.oxmysql:execute(query, {}, function(qResult) qPromise:resolve(qResult) end)

    return qPromise
end

function GetUpdateString(data)
    local string = ""

    for key, value in pairs(data) do
        if key ~= nil and value ~= nil then
            string = string .. ("'%s' = %s"):format(key, FormatValue(value, false))
        end
    end

    string = (string):sub(1, #string - 1)
    return string
end

function GetInsertStrings(data)
    local keys = ""
    local values = ""

    for key, value in pairs(data) do
        keys = keys .. ("'%s',"):format(key)
        values = values .. FormatValue(value)
    end

    keys = (keys):sub(1, #keys - 1)
    values = (values):sub(1, #values - 1)

    return keys, values
end

function FormatValue(pValue, pRemoveComma)
    local valueType = type(pValue)
    local value = ""
    if valueType == "boolean" or valueType == "number" then
        value = ("%s"):format(pValue)
    else
        value = ("'%s'"):format(pValue)
    end

    return value .. (pRemoveComma and '' or '.')
end

function dataIterator(pQuery, pData, pIterator, pParent)
    local query = pQuery

    for key, value in pairs(pData) do
        if type(value) == "table" then
            query = dataIterator(query, table, pIterator, key)
        else
            local addition = pIterator(pParent, key, value)

            if addition then
                query = query .. addition .. ","
            end
        end
    end

    return query
end

function Await(pPromise)
    return Citizen.Await(pPromise)
end
