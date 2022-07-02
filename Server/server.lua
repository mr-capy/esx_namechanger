ESX.RegisterServerCallback('esx_namechanger:getOldName', function(source, cb)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
     local name = xPlayer.getName()
      if name then
        cb(name)
      else
        name = 'not found.'
        cb(name)
      end
  end)


function getIdentifer(Source)
      local source = Source
      local identifier = nil
      for k,v in pairs(GetPlayerIdentifiers(source))do
        if (Config.Identifier == "license") and string.sub(v, 1, string.len("license:")) == "license:" then
          identifier= string.gsub(v, 'license:', '')
        elseif (Config.Identifier == "steam") and string.sub(v, 1, string.len("steam:")) == "steam:" then
          identifier= string.gsub(v, 'steam:', 'steam:')
        end
      end
    return identifier
end


RegisterServerEvent('esx_namechanger:setnewName')
AddEventHandler('esx_namechanger:setnewName',function(firstname,lastname)
    local Firstname = firstname
    local lastname  = lastname
    local Source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = getIdentifer(Source)
    local money = xPlayer.getMoney()
    local bank = xPlayer.getAccount("bank").money
    local requiredMoney = Config.requiredMoney

    if money >= requiredMoney then
        if identifier then
              xPlayer.setName(('%s %s'):format(firstname, lastname))
              MySQL.query('UPDATE users SET firstname = ?,lastname = ? WHERE identifier = ? ', {firstname,lastname,identifier}, function(affectedRows)
              if affectedRows then
                xPlayer.removeMoney(Config.requiredMoney)
                xPlayer.showNotification(_U('new_name_updated_success'))
                xPlayer.showNotification(_U('new_name_is',firstname,lastname))
              else
                xPlayer.showNotification(_U('database_error_contact_admin'))
              end
              end)
        end  
    elseif bank >= requiredMoney then
      if identifier then
        xPlayer.setName(('%s %s'):format(firstname, lastname))
        MySQL.query('UPDATE users SET firstname = ?,lastname = ? WHERE identifier = ? ', {firstname,lastname,identifier}, function(affectedRows)
        if affectedRows then
          xPlayer.removeAccountMoney('bank', Config.requiredMoney)
          xPlayer.showNotification(_U('new_name_updated_success'))
          xPlayer.showNotification(_U('new_name_is',firstname,lastname))
          
        else
          xPlayer.showNotification(_U('database_error_contact_admin'))
        end
        end)
      end
    else
        xPlayer.showNotification(_U('reuired_money',requiredMoney))
    end

end)

  function checkidentifierserverside(source)
    local identifier  = nil
    
      for k,v in pairs(GetPlayerIdentifiers(source))do
          if (Config.Identifier == "license") and string.sub(v, 1, string.len("license:")) == "license:" then
            identifier= string.gsub(v, 'license:', '')
          elseif (Config.Identifier == "steam") and string.sub(v, 1, string.len("steam:")) == "steam:" then
            identifier= string.gsub(v, 'steam:', 'steam:')
          end
      end
      
      return identifier
  end
