fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'pigeon-indicators'
author 'Pigeon Studios'
description 'Indicators and hazard lights on the arrow keys, synced for every player, and off by themselves after a turn.'
version '1.0.0'
repository 'https://github.com/pigeon-studios-uk/pigeon-indicators'

-- Pigeon Studios version registry entry, read by server/version_check.lua.
pigeon_slug 'pigeon-indicators'

shared_script 'configuration/config.lua'

client_scripts {
    'locales/*.lua',
    'client/main.lua',
}

server_scripts {
    'server/main.lua',
    'server/version_check.lua',
}
