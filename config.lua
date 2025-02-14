return {
    fivemerrApiToken = 'ENTER API TOKEN',
    carCoords = vec4(-1064.6782, -74.6680, -91.6237, 90.0),
    camCoords = vec3(-1068.0, -78.0, -90.0),
    pedCoords = vec3(-1070, -79, -90),
    camRot = vec3(0.0, 0.0, -44.0),
    camFov = 45.0,

    vehicles  = { -- Add them simply like this
        ['monroe'] = {
            image = "https://files.fivemerr.com/images/5a3c6598-816a-463a-8376-fa659ae4c6ab.png",
            price = 6100,
            label = "Pegassi Monroe",
            model = "monroe",
            category = "Sports Classics",
        },
        ['blade'] = {
            image = "https://files.fivemerr.com/images/4990d632-c0ea-4f59-a805-3e808fdea12e.png",
            price = 4300,
            label = "Vapid Blade",
            model = "blade",
            category = "Muscle",
        },
        ['btype'] = {
            image = "https://files.fivemerr.com/images/7a098584-c8a3-4929-a002-403b8a280d8d.png",
            price = 6400,
            label = "Albany Roosevelt",
            model = "btype",
            category = "Sports Classics",
        },
    }
}