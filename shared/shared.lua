Config = {}
Config.debug = true
Config.target = false -- qb-target, ox_target or false
Config.Finishkey = "F7"
Config.blipColor = 50
Config.markerColor = {111, 82, 193} -- R,G,B

Config.route = {
    [1] = {
        start = vec3(1967.65, 5179.26, 47.87),
        ped = {
            model = 'a_m_y_soucent_03',
            animDict = 'timetable@ron@ig_3_couch',
            anim = 'base',
            heading = 48.48,
        },
        ['route'] = {
            vec3(1961.06, 5184.98, 47.94),
            vec3(1719.4, 4760.41, 42.05),
            vec3(1429.48, 4377.67, 44.59),
            vec3(711.18, 4185.54, 41.08),
            vec3(22.68, 3671.96, 39.76),
            vec3(163.03, 3119.75, 43.43),
            vec3(1183.71, 3265.34, 39.36),
            vec3(2059.93, 3485.78, 43.77),
            vec3(2531.52, 4114.36, 38.76),
            vec3(2591.76, 4669.31, 34.08),
            vec3(2434.49, 5011.46, 46.83),
            vec3(2243.39, 5154.3, 57.89),
        },
    },
    [2] = {
        start = vec3(-1277.90, -559.77, 30.28),
        ped = {
            model = 'a_m_y_soucent_03',
            animDict = 'timetable@ron@ig_3_couch',
            anim = 'base',
            heading = 241.93,
        },
        ['route'] = {
            vec3(163.03, 3119.75, 43.43),
            vec3(1183.71, 3265.34, 39.36),
            vec3(2059.93, 3485.78, 43.77),
            vec3(2531.52, 4114.36, 38.76),
            vec3(2591.76, 4669.31, 34.08),
            vec3(2434.49, 5011.46, 46.83),
            vec3(2243.39, 5154.3, 57.89),
        },
    },
}

Config.progress = {
    duration = 2000,
    position = 'bottom',
    anim = {
        dict = 'amb@prop_human_parking_meter@female@idle_a',
        clip = 'idle_a_female'
    },
}

Config.Lang = {
    star_route_label = '[E] - Iniciar rota',
    star_route_label_target = 'Iniciar rota',
    star_route_notify = 'Rota Iniciada',
    route_label_progress = 'Coletando...',
    error_route_notify = 'Você já está com uma rota ativa.',
    finish_route_notify = 'Rota finalizada',
    finish_route_keymap = 'Cancelar Rota"',
    blip_route = 'Rota de Farm',
}
