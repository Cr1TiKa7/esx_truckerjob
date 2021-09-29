ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:truckerjob_confirmPay')
AddEventHandler('esx:truckerjob_confirmPay', function(source, jIndex)
  ConfirmPayment(source, jIndex)
end)

function ConfirmPayment(source, jIndex)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    MySQL.Async.fetchAll('select * from users where identifier = @identifier', {['@identifier'] = identifier}, function(result)
        local pay = Config.TruckerJob[1].Jobs[jIndex].Price
        xPlayer.addMoney(pay)
        TriggerClientEvent('chatMessage', xPlayer.source, _U('complete_job_msg', pay))
      end)
end

