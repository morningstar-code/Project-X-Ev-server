AddEventHandler("ev-inventory:itemUsed", function(item, metaData)
    local meta = json.decode(metaData)
    if item == "heistlaptop3" then -- fleeca, green
        FleecaUsePanel(meta.id)
        return
    end
    if item == "heistlaptop2" then -- paleto, blue
        if PaletoCanUsePanel() then
            PaletoUsePanel(meta.id)
            return
        end
        TriggerEvent("DoLongHudText", "That doesn't seem right", 2)
    end
    if item == "heistlaptop4" then -- vault upper, red
        if VaultUpperCanUsePanel() then
            VaultUpperUsePanel(meta.id)
            return
        end
        TriggerEvent("DoLongHudText", "That doesn't seem right", 2)
    end
    if item == "heistlaptop1" then -- vault lower, gold
        if VaultLowerCanUsePanel() then
            VaultLowerUsePanel(meta.id)
            return
        end
        TriggerEvent("DoLongHudText", "That doesn't seem right", 2)
        return
    end
end)
