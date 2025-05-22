fx_version "cerulean"

games { "gta5" }

description "Victoro Locale System"

version "0.1.0"

server_script "@ev-lib/server/sv_sql.js"
server_script "@ev-lib/server/sv_rpc.js"
server_script "@ev-lib/server/sv_cpx.js"
server_script "@ev-lib/server/sv_asyncExports.js"

client_script "@ev-lib/client/cl_ui.js"
client_script "@ev-lib/client/cl_rpc.js"

server_scripts {
    "server/*.js",
    "server/*.lua",
}

client_scripts {
    "client/*.js",
    "client/*.lua",
}

shared_scripts {
    "shared/*.js"
}
