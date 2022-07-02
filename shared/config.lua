Config  = {}

Config.Locale           = 'en'

Config.DrawDistance = 10
Config.MarkerSize = {x = 0.4, y = 0.4, z = 0.2}
Config.MarkerType =  21								--https://docs.fivem.net/docs/game-references/markers/
Config.MarkerColor = {r = 255, g = 255, b = 255, a = 255}

Config.Identifier = 'license'			-- 'steam' without prefix or 'license' with prefix
Config.requiredMoney = 5000			--Money Reqired to change name

Config.MenuAlign = 'bottom-right'


Config.Zones = {	
						--can add multiple zones
	NameChanger = {
			Pos = {
				vector3(-545.208801, -203.894501, 38.210205),
				},
			Size  = 1.0,	--blip size				-- https://docs.fivem.net/docs/game-references/blips/
			Type  = 475,	--blip ID
			Color = 25,		--blip color
			ShowBlip = true,	--to hide blip change it to false
			ShowMarker = true	-- to hide marker chaange it to false
	},

}
