local QBCore = exports['qb-core']:GetCoreObject()

-- Evento para dar as pedras
RegisterServerEvent("mt-mining:server:DarPedras")
AddEventHandler("mt-mining:server:DarPedras", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
        Player.Functions.AddItem("stone", 1)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["stone"], "add")
        TriggerClientEvent('QBCore:Notify', src, 'You broke Stone!.')
end)

-- Evento para lavar as pedras
RegisterServerEvent("mt-mining:server:LavarPedras")
AddEventHandler("mt-mining:server:LavarPedras", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local stone = Player.Functions.GetItemByName("stone")
    if stone ~= nil then

        if stone.amount >= 1 then
            Player.Functions.RemoveItem("stone", 1)
            Player.Functions.AddItem("washedstone", 1)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["washedstone"], "add")
            TriggerClientEvent('QBCore:Notify', src, 'Stones Whashed.')
        else
            TriggerClientEvent('QBCore:Notify', src, 'You dont have the rigth items...', 'error')
        end
    else
        TriggerClientEvent("QBCore:Notify", src, "Missing something...", "error")
    end
end)

-- Evento para Venda items
RegisterNetEvent('mt-mining:server:VenderPedras', function(args) 
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local args = tonumber(args)
	if args == 1 then 
		local washedstone = Player.Functions.GetItemByName("washedstone")
		if washedstone ~= nil then
			local payment = 2 -- trocar aqui o preço que deseja para o próximo item
			Player.Functions.RemoveItem("washedstone", 1, k)
			Player.Functions.AddMoney('bank', payment , "washedstone-sell")
			TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["washedstone"], "remove", 1)
			TriggerClientEvent('QBCore:Notify', src, "1 "..source.." sell for $"..payment, "success")
			TriggerClientEvent("mt-drugdealer:client:venda", source)
		else
		    TriggerClientEvent('QBCore:Notify', src, "You dont have nothing to sell", "error")
        end 
    end
end)