local hasAlreadyEnteredMarker, lastZone
local currentAction, currentActionMsg, currentActionData = nil, nil, {}

function showoldname()
	ESX.TriggerServerCallback('esx_namechanger:getOldName', function(name)
	   
		local elements = {
			{label = name}
		}
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'old_name', {
			title    = _U('current_name_menu_title'),
			align    = Config.MenuAlign,
			elements = elements
		
		}, nil, function(data, menu)
			menu.close()
		end)
	end)		
end

function setnewname()

	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'get_firstname', {
		title = _U('get_firstname_menu'),
	}, function(data2, menu2)
		menu2.close()
			
			if data2.value then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'get_secondname', {
					title = _U('get_secondname_menu'),
				}, function(data3, menu3)
					if data3.value then
						TriggerServerEvent('esx_namechanger:setnewName',data2.value,data3.value)
						menu3.close()
					else
						ESX.ShowNotification(_U('lastname_error'))
					end
				end, function(data3, menu3)
					menu3.close()
				end)
			else
				ESX.ShowNotification(_U('firstname_error'))
			end
	end, function(data2, menu2)
		menu2.close()
	end)

end

function OpenNameChangeShopMenu(zone)

    local elements = {
    {label = _U('show_currentname_label'), value = 'showoldname'},
    {label = _U('set_newname_label'), value = 'setnewname'},
	}
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'namechangeshop', {
        title    = _U('main_Menu_title'),
        align    = Config.MenuAlign,
        elements = elements
    
    }, function(data, menu)
        if data.current.value == 'showoldname' then
            showoldname()
        elseif data.current.value == 'setnewname' then
            setnewname()      
        end
    
    end, function(data, menu)
        menu.close()

		currentAction     = 'shop_menu'
		currentActionMsg  = _U('press_menu')
		currentActionData = {zone = zone}
    end)

end


AddEventHandler('esx_namechanger:hasEnteredMarker', function(zone)
	currentAction     = 'shop_menu'
	currentActionMsg  = _U('press_menu')
	currentActionData = {zone = zone}
end)

AddEventHandler('esx_namechanger:hasExitedMarker', function(zone)
	currentAction = nil
	ESX.UI.Menu.CloseAll()
end)

-- Create Blips
CreateThread(function()
	for k,v in pairs(Config.Zones) do
		for i = 1, #v.Pos, 1 do
			if v.ShowBlip then
			local blip = AddBlipForCoord(v.Pos[i])

			SetBlipSprite (blip, v.Type)
			SetBlipScale  (blip, v.Size)
			SetBlipColour (blip, v.Color)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentSubstringPlayerName(_U('namechanger'))
			EndTextCommandSetBlipName(blip)
		end
	end
	end
end)

-- Enter / Exit marker events
CreateThread(function()
	while true do
		local Sleep = 1500

		if currentAction then
			Sleep = 0
			ESX.ShowHelpNotification(currentActionMsg)

			if IsControlJustReleased(0, 38) and currentAction == 'shop_menu' then
				currentAction = nil
				OpenNameChangeShopMenu(currentActionData.zone)
			end
		end

		local playerCoords = GetEntityCoords(PlayerPedId())
		local isInMarker, currentZone = false

		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				local distance = #(playerCoords - v.Pos[i])

				if distance < Config.DrawDistance then
					Sleep = 0
					if v.ShowMarker then
					DrawMarker(Config.MarkerType, v.Pos[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, Config.MarkerColor.a, false, true, 2, false, nil, nil, false)
				  end
					if distance < 2.0 then
						isInMarker  = true
						currentZone = k
						lastZone    = k
					end
				end
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			TriggerEvent('esx_namechanger:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_namechanger:hasExitedMarker', lastZone)
		end
	Wait(Sleep)
	end
end)
