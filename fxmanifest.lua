--Metadata
fx_version 'bodacious'
games {'gta5'}

author 'Cr1TiKa7'
description 'ESX Trucker Job'
version '1.0'

client_scripts {
    '@es_extended/locale.lua',
    '@cr1tika7_utils/client_utils.lua',
    'config.lua',
    'locales/de.lua',
    'locales/en.lua',
    'client/main.lua'
}

server_scripts {
    '@es_extended/locale.lua',
    'config.lua',
	'@mysql-async/lib/MySQL.lua',
    'locales/de.lua',
    'locales/en.lua',
    'server/server.lua'
}