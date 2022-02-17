local QBCore = exports['qb-core']:GetCoreObject()

-- Criar blip para do mapa
Citizen.CreateThread(function()
    local blip = AddBlipForCoord(2977.23, 2792.05, 41.35) -- Mudar coordenadas do blip aqui!
	SetBlipSprite(blip, 78) -- Mudar estilo do blip aqui!
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.7)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 1)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Mine") -- Mudar nome do Blip aqui!
    EndTextCommandSetBlipName(blip)
end)

-- Criar blip para do mapa da lavagem
Citizen.CreateThread(function()
    local blip = AddBlipForCoord(3838.14, 4480.65, 1.12) -- Mudar coordenadas do blip aqui!
	SetBlipSprite(blip, 78) -- Mudar estilo do blip aqui!
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.7)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 1)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Wash Stones") -- Mudar nome do Blip aqui!
    EndTextCommandSetBlipName(blip)
end)

-- Criar blip para do mapa da lavagem
Citizen.CreateThread(function()
    local blip = AddBlipForCoord(382.49, 3586.93, 33.29) -- Mudar coordenadas do blip aqui!
	SetBlipSprite(blip, 78) -- Mudar estilo do blip aqui!
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.7)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 1)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Washed Stones Sell") -- Mudar nome do Blip aqui!
    EndTextCommandSetBlipName(blip)
end)

-- Evento para partir pedras
RegisterNetEvent('mt-mining:client:ApanharPedra')
AddEventHandler("mt-mining:client:ApanharPedra", function()
    QBCore.Functions.Progressbar("pedras", "BROKING STONE", 500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "amb@world_human_const_drill@male@drill@base",
        anim = "base",
        flags = 16,
    }, {}, {}, function() 
        local playerPed = PlayerPedId()
        local success = exports['qb-lock']:StartLockPickCircle(1,30)
   if success then
        StopAnimTask(ped, dict, "base", 1.0)
        TriggerServerEvent("mt-mining:server:DarPedras")
        ClearPedTasks(playerPed)
    else
        QBCore.Functions.Notify("Failed!", "error")
        ClearPedTasks(playerPed)
        end
    end)
end)

-- Target para as pedras
Citizen.CreateThread(function ()
    exports['qb-target']:AddBoxZone("pedras", vector3(2977.23, 2792.05, 41.35), 2, 2, {
        name = "pedras",
        heading = 0,
        debugPoly = false,
    }, {
        options = {
            {
                type = "Client",
                event = "mt-mining:client:ApanharPedra",
                icon = "fas fa-circle",
                label = "Broke Stone",
            },
        },
        distance = 2.5
    })
end)

-- Target para lavar as pedras
Citizen.CreateThread(function ()
    exports['qb-target']:AddBoxZone("lavar", vector3(3838.14, 4480.65, 1.12), 2, 2, {
        name = "lavar",
        heading = 0,
        debugPoly = false,
    }, {
        options = {
            {
                type = "Client",
                event = "mt-mining:client:LavarPedra",
                icon = "fas fa-circle",
                label = "Wash Stone",
            },
        },
        distance = 2.5
    })
end)

-- Evento para lavar pedras
RegisterNetEvent('mt-mining:client:LavarPedra')
AddEventHandler("mt-mining:client:LavarPedra", function()
    QBCore.Functions.Progressbar("lavar", "WASHING STONE", 500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "amb@prop_human_bum_bin@idle_a",
        anim = "idle_a",
        flags = 16,
    }, {}, {}, function() 
        local playerPed = PlayerPedId()
        local success = exports['qb-lock']:StartLockPickCircle(1,30)
   if success then
        StopAnimTask(ped, dict, "idle_a", 1.0)
        TriggerServerEvent("mt-mining:server:LavarPedras")
        ClearPedTasks(playerPed)
    else
        QBCore.Functions.Notify("Failed!", "error")
        ClearPedTasks(playerPed)
        end
    end)
end)

-- spawn ped vendas pedras
local vendasPed = {
	{382.23, 3586.09, 32.29,"Zé Das Couves",3.81,0x039677BD,"cs_jimmyboston"}, -- trocar aqui o ped e a sua loc
  }
  Citizen.CreateThread(function()
	  for _,v in pairs(vendasPed) do
		  RequestModel(GetHashKey(v[7]))
		  while not HasModelLoaded(GetHashKey(v[7])) do
			  Wait(1)
		  end
		  VendaProcPed =  CreatePed(4, v[6],v[1],v[2],v[3], 3374176, false, true)
		  SetEntityHeading(VendaProcPed, v[5])
		  FreezeEntityPosition(VendaProcPed, true)
		  SetEntityInvincible(VendaProcPed, true)
		  SetBlockingOfNonTemporaryEvents(VendaProcPed, true)
		  TaskStartScenarioInPlace(VendaProcPed, "WORLD_HUMAN_AA_SMOKE", 0, true) 
	  end
  end)

-- Target para venda das pedras lavadas
Citizen.CreateThread(function ()
    exports['qb-target']:AddBoxZone("VendaPedras", vector3(382.23, 3586.09, 32.29), 1, 1, {
        name = "VendaPedras",
        heading = 0,
        debugPoly = false,
    }, {
        options = {
            {
                type = "Client",
                event = "mt-mining:client:VenderPedras",
                icon = "fas fa-axe",
                label = "Talk to employee",
            },
        },
        distance = 2.5
    })
end)

-- Menu de vendas
RegisterNetEvent('mt-mining:client:VenderPedras')
AddEventHandler('mt-mining:client:VenderPedras', function()
    exports['qb-menu']:openMenu({
		{
            header = "Stone Sell",
            isMenuHeader = true
        },
        { -- copiar daqui
            header = "Sell Washed Stone",
            txt = "Pricel: 2$",
            params = {
				isServer = true,
                event = "mt-mining:server:VenderPedras",
				args = 1 -- mudar aqui os args
            }
        },		-- até aqui, colar logo aqui em baixo		
        {
            header = "< Close",
            txt = "",
            params = {
                event = "qb-menu:closeMenu"
            }
        },
    })
end)