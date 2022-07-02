fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'Capy#1256'
description 'Change Identity First name and last name inexchange of money'
version '1.0'


shared_scripts { 
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	'shared/config.lua'
}

client_scripts {	
	'Client/*.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'Server/*.lua'
}


dependencies {
	'es_extended',
}
