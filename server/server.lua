
CreateThread(function ()
    if GetResourceState('qb-core') == 'started' then QBCore = exports['qb-core']:GetCoreObject() end
    if GetResourceState('qb-inventory') == 'started' or GetResourceState('ps-inventory') == 'started' then
        Inventory = 'qb'
    elseif GetResourceState('ox_inventory') == 'started' then
        Inventory = 'ox'
    else
        print("Você não está usando um inventário compatível. Será necessário fazer edições no código. \n You are not using a supported inventory, it will be required to make edits.")
    end
end)


lib.callback.register('rkt:routes:server:pay', function(source, index)
    local src = source
    local pay = false
    local amount = math.random(Config.Rewards[index].amountMin,Config.Rewards[index].amountMax)
    if not pay then
        for i = 1, #Config.Rewards[index].reward do
            if Inventory == 'qb' then
                local xPlayer = QBCore.Functions.GetPlayer(src)
                if xPlayer.Functions.AddItem(Config.Rewards[index].reward[i], amount) then
                    pay = true
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Rewards[index].reward[i]], 'add', amount)
                end
            elseif Inventory == 'ox' then
                if exports.ox_inventory:AddItem(src, Config.Rewards[index].reward[i], amount) then
                    pay = true
                end
            end
        end
    end
    return pay
end)