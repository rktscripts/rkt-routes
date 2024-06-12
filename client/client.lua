QBCore = exports['rkt-core']:GetCoreObject()
local inRoute = false
local selected = 1

CreateThread(function ()
    if not Config.target then
        for k,v in pairs(Config.route) do
            local box = lib.zones.box({
                coords = v.start,
                size = vec3(1.5, 1.5, 1.5),
                rotation = 45,
                debug = Config.debug,
                inside = inside,
                onEnter = onEnter,
                onExit = onExit
            })
        end
    elseif Config.Target == 'ox_target' then
        for k,v in pairs(Config.route) do
            exports.ox_target:addSphereZone({
                coords = v.start,
                radius = 1,
                debug = Config.debug,
                options = {
                    label = Config.Lang.star_route_label_target,
                    icon = 'box',
                    distance = 1,
                    onSelect = function ()
                        QBCore.Functions.Notify(Config.Lang.star_route_notify, "success", 2000)
                        createBlips(k, selected)
                        inRoute = true
                        startRoute(k)
                    end
                }
            })
        end
    elseif Config.Target == 'qb-target' then
        for k,v in pairs(Config.route) do
        exports['qb-target']:AddBoxZone("name", v.start, 1.5, 1.6, { 
            name = "name",
            heading = 12.0,
            debugPoly = Config.debug,
            minZ = 36.7,
            maxZ = 38.9,
            }, {
            options = {
                {
                    type = "client",
                    icon = 'box',
                    label = Config.Lang.star_route_label_target,
                    action = function(entity)
                        QBCore.Functions.Notify(Config.Lang.star_route_notify, "success", 2000)
                        createBlips(k, selected)
                        inRoute = true
                        startRoute(k)
                    end,
                    }
                },
                distance = 1,
            })
        end
    end
end)

--------------------------------------------------------------
--------------- ZONE FUNCTIONS
--------------------------------------------------------------

function onEnter(self)
    if not inRoute then
        lib.showTextUI(Config.Lang.star_route_label)
    end
end

function onExit(self)
    lib.hideTextUI()
end

function inside(self)
    if IsControlJustPressed(0, 38) then
        QBCore.Functions.Notify(Config.Lang.star_route_notify, "success", 2000)
        createBlips(self.id, selected)
        inRoute = true
        startRoute(self.id)
        lib.hideTextUI()
    end
end


--------------------------------------------------------------
--------------- ROUTE BLIPS CREATE
--------------------------------------------------------------


function createBlips(type, selected)
    blips = AddBlipForCoord(Config.route[type]['route'][selected].x, Config.route[type]['route'][selected].y, Config.route[type]['route'][selected].z)
    SetBlipSprite(blips, 1)
    SetBlipColour(blips, 5)
    SetBlipScale(blips, 0.4)
    SetBlipAsShortRange(blips, false)
    SetBlipRoute(blips, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Lang.blip_route)
    EndTextCommandSetBlipName(blips)
end

--------------------------------------------------------------
--------------- ROUTE START
--------------------------------------------------------------

function startRoute(type)
    while inRoute do
        local ped = PlayerPedId()
        local timedistance = 1000
        local releaseCoords = vector3(Config.route[type]['route'][selected].x, Config.route[type]['route'][selected].y, Config.route[type]['route'][selected].z)
        local targetCoords = GetEntityCoords(ped)
        local distance = #(releaseCoords-targetCoords.xyz)
        local maxRoute = 1
        if distance <= 5.0 then
            timedistance = 4
            DrawMarker(23, Config.route[type]['route'][selected].x, Config.route[type]['route'][selected].y, Config.route[type]['route'][selected].z-0.98, 0, 0, 0, 0, 0.0, 0.0, 1.0, 1.0, 0.0, 195, 23, 24, 200, 0, 0, 0, 0)
            if distance <= 2 then
                if not IsPedInAnyVehicle(ped) and IsControlJustReleased(0, 38) then
                    if inRoute then
                        if lib.progressBar({
                            duration = 2000,
                            position = 'bottom',
                            useWhileDead = false,
                            canCancel = true,
                            disable = {
                                car = true,
                            },
                            anim = {
                                dict = 'mp_player_intdrink',
                                clip = 'loop_bottle'
                            },
                        }) then
                            lib.callback('rkt:routes:server:pay', source, function(pagamento)
                                if pagamento then
                                    RemoveBlip(blips)
                                    for i = 0, #Config.route[type]['route'] do
                                        maxRoute = i
                                    end
                                    if selected == maxRoute then
                                        selected = 1
                                    else
                                        selected = selected + 1
                                    end
                                    createBlips(type, selected)
                                end
                            end, type)
                        else
                            
                        end
                        
                    end
                end
            end
        end
        Wait(timedistance)
    end
end

--------------------------------------------------------------
--------------- CREATE PED
--------------------------------------------------------------

CreateThread(function ()
    for k,v in pairs(Config.route) do
        RequestModel(GetHashKey(v.ped.model))
        while not HasModelLoaded(GetHashKey(v.ped.model)) do
            Wait(0)
        end
        routeMan = CreatePed(4, GetHashKey(v.ped.model), v.start.x, v.start.y, v.start.z-1, v.ped.heading, false, true)
        FreezeEntityPosition(routeMan, true)
        SetBlockingOfNonTemporaryEvents(routeMan, true)
        SetEntityInvincible(routeMan, true)
        BlockAllSpeechFromPed(routeMan, true)
        RequestAnimDict(v.ped.animDict)
        while not HasAnimDictLoaded(v.ped.animDict) do
            Citizen.Wait(1)
        end
        TaskPlayAnim(routeMan, v.ped.animDict, v.ped.anim, 8.0, 0, -1, 1, 0, 0, 0)
    end
end)

--------------------------------------------------------------
--------------- CANCEL ROUTE
--------------------------------------------------------------

RegisterKeyMapping('+cancelroute', Config.Lang.finish_route_keymap, 'keyboard', Config.Finishkey)

RegisterCommand('+cancelroute', function()
    if inRoute then
        inRoute = false
        selected = 1
        RemoveBlip(blips)
        QBCore.Functions.Notify(Config.Lang.finish_route_notify, "error", 2000)
    end
end)