fx_version 'cerulean'
games { 'rdr3', 'gta5' }

description 'Play sounds'
version '1.1.5'

-- Client Scripts
client_script {
    '@ev-errorlog/client/cl_errorlog.lua',
    '@ev-lib/client/cl_infinity.lua',
    '@ev-lib/client/cl_rpc.lua',
    'client/main.lua'
}

shared_script 'shared/sh_*.*'

-- Server Scripts
server_script {
    '@ev-lib/server/sv_rpc.lua',
    '@ev-lib/server/sv_infinity.lua',
    'server/main.lua'
}

-- NUI Default Page
ui_page('client/html/index.html')

-- Files needed for NUI
-- DON'T FORGET TO ADD THE SOUND FILES TO THIS!
files({
    'client/html/index.html',
    'client/html/sounds/*.ogg',
    'client/html/sounds/Spells/*.ogg'
})
