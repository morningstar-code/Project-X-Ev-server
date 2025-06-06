-- This resource is part of the default Cfx.re asset pack (cfx-server-data)
-- Altering or recreating for local use only is strongly discouraged.

version '1.0.0'
author 'Cfx.re <root@cfx.re>'
description 'Provides baseline chat functionality using a NUI-based interface.'
repository 'https://github.com/citizenfx/cfx-server-data'

ui_page 'dist/ui.html'

client_script {
  "@ev-lib/client/cl_infinity.lua",
  'cl_*.lua',
}
server_script {
  "@ev-lib/shared/sh_util.lua",
  "@ev-lib/server/sv_infinity.lua",
  'sv_*.lua',
}

files {
  'dist/ui.html',
  'dist/index.css',
  'html/vendor/*.css',
  'html/vendor/image/*.png',
  'html/vendor/fonts/*.woff2',
}

fx_version 'adamant'
games { 'rdr3', 'gta5' }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'


--webpack_config 'webpack.config.js'
