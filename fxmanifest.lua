fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'rkt'
description 'Route Script For QBCore'
version '1.0.0'

client_scripts {
	"client/*.lua"
}

server_scripts {
	"server/server.lua",
    "server/cfg.lua"
}

shared_scripts {'@ox_lib/init.lua', 'shared/*.lua' }