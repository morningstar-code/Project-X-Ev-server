fx_version 'cerulean'
games {'gta5'}

ui_page "core/client/ui/html/index.html"

--[[ dependencies {
    "ev-polyzone"
} ]]--

files {
    "core/client/ui/html/index.html",
    "core/client/ui/html/css/menu.css",
    "core/client/ui/html/js/ui.js",
    "core/client/ui/html/imgs/logo.png",
    "core/client/ui/html/sounds/wrench.ogg",
    "core/client/ui/html/sounds/respray.ogg"
}

client_scripts {
    '@ev-lib/client/cl_rpc.lua',
    "core/_config/cfg_vehicleCustomisation.lua",
    "core/_config/cfg_vehiclePresets.lua",
    "core/_config/cfg_vehicleExtras.lua",
    "core/_config/cfg_vehicleMods.lua",
    "core/client/ui/cl_ui.lua",
    "core/client/cl_*.lua"
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    '@ev-lib/server/sv_rpc.lua',
    "@ev-lib/server/sv_asyncExports.lua",
    "core/_config/cfg_vehicleCustomisation.lua",
    "core/_config/cfg_vehicleMods.lua",
    "core/server/sv_bennys.lua"
}
