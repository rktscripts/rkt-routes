QBCore = exports['qb-core']:GetCoreObject()

lib.callback.register('rkt:routes:server:pay', function(source, type)
    local src = source
    local pay = false
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local amount = math.random(Config.Rewards[type].amountMin,Config.Rewards[type].amountMax)
    if not pay then
        for i = 1, #Config.Rewards[type].reward do
            pay = true
            xPlayer.Functions.AddItem(Config.Rewards[type].reward[i], amount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Rewards[type].reward[i]], 'add', amount)
        end
    end
    return pay
end)