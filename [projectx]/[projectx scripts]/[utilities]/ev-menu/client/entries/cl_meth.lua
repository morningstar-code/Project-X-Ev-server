-- local GeneralEntries, SubMenu = MenuEntries['meth'], {}

-- local MethActions = {
--     {
--         data = {
--             id = 'meth:enterDoor',
--             title = 'Enter Door',
--             icon = '#meth-enter-door',
--             event = 'ev-meth:enterDoor',
--             parameters = {}
--         },
--         isEnabled = function ()
--             return exports['ev-inventory']:hasEnoughOfItem('methlabkey', 1, false) or exports['ev-meth']:isInsideUnlockedDoorZone() or isPolice
--         end
--     },
--     {
--         data = {
--             id = 'meth:destroyProperty',
--             title = 'Destroy Property',
--             icon = '#meth-destroy-property',
--             event = 'ev-meth:seizeLab',
--             parameters = {}
--         },
--         isEnabled = function ()
--             return isPolice
--         end
--     },
-- }

-- Citizen.CreateThread(function()
--     for index, data in ipairs(MethActions) do
--         SubMenu[index] = data.data.id
--         MenuItems[data.data.id] = data
--     end
--     GeneralEntries[#GeneralEntries+1] = {
--         data = {
--             id = 'meth',
--             icon = '#meth-actions',
--             title = 'Door Actions',
--         },
--         subMenus = SubMenu,
--         isEnabled = function()
--             local inside = exports['ev-meth']:isInsideDoorZone()
--             local hasKey = exports['ev-inventory']:hasEnoughOfItem('methlabkey', 1, false)
--             local insideUnlocked = exports['ev-meth']:isInsideUnlockedDoorZone()
--             return not isDead and inside and (hasKey or insideUnlocked or isPolice)
--         end,
--     }
-- end)
