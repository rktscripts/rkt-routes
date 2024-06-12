local lang = Config.Lang['pt-br']
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
                    label = lang.star_route_label_target,
                    icon = 'box',
                    distance = 1,
                    onSelect = function ()
                        Notify('SUCCESS', lang.star_route_notify, "success")
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
                    label = lang.star_route_label_target,
                    action = function(entity)
                        Notify('SUCCESS', lang.star_route_notify, "success")
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
        lib.showTextUI(lang.star_route_label, {
            icon = 'E',
            style = {
                borderRadius = '8px',
                backgroundColor = '#020202',
                color = '#6f52c1'
            }
        })
    end
end

function onExit(self)
    lib.hideTextUI()
end

function inside(self)
    if IsControlJustPressed(0, 38) then
        Notify('SUCCESS', lang.star_route_notify, "success")
        createBlips(self.id, selected)
        inRoute = true
        startRoute(self.id)
        lib.hideTextUI()
    end
end

function Notify(title, text, type)
    lib.notify({
        title = title,
        description = text,
        type = type
    })
end

--------------------------------------------------------------
--------------- ROUTE BLIPS CREATE
--------------------------------------------------------------


function createBlips(index, selected)
    blips = AddBlipForCoord(Config.route[index]['route'][selected].x, Config.route[index]['route'][selected].y, Config.route[index]['route'][selected].z)
    SetBlipSprite(blips, 1)
    SetBlipColour(blips, Config.blipColor)
    SetBlipScale(blips, 0.4)
    SetBlipAsShortRange(blips, false)
    SetBlipRoute(blips, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(lang.blip_route)
    EndTextCommandSetBlipName(blips)
end

--------------------------------------------------------------
--------------- ROUTE START
--------------------------------------------------------------

function startRoute(index)
    while inRoute do
        local ped = PlayerPedId()
        local timedistance = 1000
        local releaseCoords = vector3(Config.route[index]['route'][selected].x, Config.route[index]['route'][selected].y, Config.route[index]['route'][selected].z)
        local targetCoords = GetEntityCoords(ped)
        local distance = #(releaseCoords-targetCoords.xyz)
        local maxRoute = 1
        if distance <= 5.0 then
            timedistance = 4
            DrawMarker(23, Config.route[index]['route'][selected].x, Config.route[index]['route'][selected].y, Config.route[index]['route'][selected].z-0.98, 0, 0, 0, 0, 0.0, 0.0, 1.0, 1.0, 0.0, Config.markerColor[1], Config.markerColor[2], Config.markerColor[3], 200, 0, 0, 0, 0)
            if distance <= 2 then
                if not IsPedInAnyVehicle(ped) and IsControlJustReleased(0, 38) then
                    if inRoute then
                        if lib.progressBar({
                            duration = Config.progress.duration,
                            label = lang.route_label_progress,
                            position = Config.progress.position,
                            useWhileDead = false,
                            allowSwimming = false,
                            allowCuffed = false,
                            allowFalling = false,
                            canCancel = true,
                            disable = {
                                car = true,
                                move = true,
                                combat = true,
                                sprint = true
                            },
                            anim = {
                                dict = Config.progress.anim.dict,
                                clip = Config.progress.anim.clip,
                                flag = 0
                            },
                        }) then
                            lib.callback('rkt:routes:server:pay', source, function(pagamento)
                                if pagamento then
                                    RemoveBlip(blips)
                                    for i = 0, #Config.route[index]['route'] do
                                        maxRoute = i
                                    end
                                    if selected == maxRoute then
                                        selected = 1
                                    else
                                        selected = selected + 1
                                    end
                                    createBlips(index, selected)
                                end
                            end, index)
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
local routeMan = 0
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

RegisterKeyMapping('+cancelroute', lang.finish_route_keymap, 'keyboard', Config.Finishkey)

RegisterCommand('+cancelroute', function()
    if inRoute then
        inRoute = false
        selected = 1
        RemoveBlip(blips)
        Notify('ERROR', lang.finish_route_notify, "error")
    end
end, false)
