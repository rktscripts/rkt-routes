fx_version "cerulean"
use_experimental_fxv2_oal 'yes'
game 'gta5'
lua54 'yes'

version '1.0'

client_scripts {
	"client/*.lua"
}

server_scripts {
	"server/server.lua",
    "server/cfg.lua",
	"server/version.lua"
}

shared_scripts {'@ox_lib/init.lua', 'shared/*.lua' }