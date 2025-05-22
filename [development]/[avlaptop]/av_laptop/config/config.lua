Config = {}
Config.Framework = "QBCore" -- QBCore or ESX
Config.DefaultWallpaper = "https://cdn.discordapp.com/attachments/982104385679159296/1149759027522306098/1920x1080-px-artwork-BMW-BMW-M6-car-depth-of-field-1265877-wallhere.com.jpg" -- Default wallpaper
Config.GiveNUI = true -- Used for mini music player
Config.NuiCommand = "nui" -- Command used to activate the cursor on screen and minimize/close the music player
Config.LaptopItem = "laptop" -- The item used to open laptop
Config.HackingDeviceITem = 'false' -- Item used to hack laptops, set false if you don't want ppl be able to hack other players laptops.
Config.AlertOwner = true -- Alert laptop owner when someone's trying to hack his laptop?
Config.OldESX = false -- True if you are using the old ESX not ESX legacy, for ESX legacy uncomment the ESX line from fxmanifest.lua
Config.Inventory = "ev-inventory" -- (available options: qb-inventory, lj-inventory, ox_inventory and qs-inventory)
Config.AdminLevel = "admin" -- Used for some apps to give extra permissions to edit/delete info (for ex. racing app: admins can create/remove tracks or events)

Config.Apps = {
    {
        name = "darkmarket",
        label = "Black Market",
        isEnabled = function()
            return hasItem('vpnxj') 
        end
    },
    {
        name = "boosting",
        label = "Boosting",
        isEnabled = function() 
            local vpn = hasItem('vpnxj')
            local dongle = hasItem('phonedongle')
            if vpn and dongle then 
                return true 
            else 
                return false 
            end
        end
    },
    {
        name = "cupcake",
        label = "Cupcake Swap",
        isEnabled = function()
            return true
        end
    },
    {
        name = "campro",
        label = "CamPro",
        isEnabled = function()
            return true
        end
    },
    {
        name = "business",
        label = "Business",
        isEnabled = function()
            return false
        end
    },
    {
        name = "meth",
        label = "Humane Labs",
        isEnabled = function()
            return hasItem('black_usb')
        end
    },
    {
        name = "music",
        label = "Music",
        isEnabled = function()
            return true
        end
    },
    {
        name = "gang",
        label = "Gang",
        isEnabled = function()
            if GetResourceState('av_gangs') ~= "started" then
                return false
            end
            local gang = exports['av_gangs']:getGang()
            if gang and gang['name'] then
                return true
            else
                return false
            end
        end
    },
    {
        name = "racing",
        label = "Racing",
        isEnabled = function() 
            local vpn = hasItem('vpnxj')
            local dongle = hasItem('phonedongle')
            if vpn and dongle then 
                return true 
            else 
                return false 
            end
        end
    },
    {
        name = "realestate",
        label = "Real Estate",
        isEnabled = function()
            return false
        end
    },

}

-- Has item?
function hasItem(name) 
    local qty = 1
    if tonumber(amount) then 
        qty = tonumber(amount)
    end

    local hasItem = exports["ev-inventory"]:hasEnoughOfItem(name, 1, false, true)
    if hasItem then 
        return true
    end
    return false
end