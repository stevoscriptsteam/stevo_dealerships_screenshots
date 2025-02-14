fx_version 'cerulean'
game 'gta5'
use_experimental_fxv2_oal 'yes'
lua54 'yes'


author "StevoScripts"
description "Screenshotting tool for stevo_dealerships"
version '1.0.0'


shared_script {
  '@ox_lib/init.lua'
}

client_scripts {
  'resource/client.lua',
}

server_scripts {
  'resource/server.lua',
}

files {
  'config.lua',
}