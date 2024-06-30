fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

description 'smdx-bathing'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@smdx-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua'
}

client_scripts {
    'client/client.lua',
    'client/structs.js'
}

server_scripts {
    'server/server.lua'
}

dependencies {
    'smdx-core',
    'smdx-appearance',
    'smdx-wardrobe'
}

lua54 'yes'
