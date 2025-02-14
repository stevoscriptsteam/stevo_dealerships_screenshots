local config = lib.require('config')
local vehicles = config.vehicles
local savedCoords = vec3
local currentVehicleEntity = nil
local cam = nil

local spawnCoord = config.carCoords.xyz
local spawnHeading = config.carCoords.w

local function CreateCamera()
    if not DoesCamExist(cam) then
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(cam, config.camCoords.x, config.camCoords.y, config.camCoords.z)
        SetCamRot(cam, config.camRot.x,config.camRot.y,config.camRot.z, 2)
        SetCamFov(cam, config.camFov)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, true)
    end
end

local function DestroyCamera()
    if DoesCamExist(cam) then
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(cam, false)
        cam = nil
    end
end
local function SpawnVehicle(vehicleModel)
    local modelHash = GetHashKey(vehicleModel)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(10)
    end
    local veh = CreateVehicle(modelHash, spawnCoord.x, spawnCoord.y, spawnCoord.z, spawnHeading, false, true)
    SetVehicleOnGroundProperly(veh)
    FreezeEntityPosition(veh, true)
    return veh
end

local function DeleteVehicle(veh)
    if DoesEntityExist(veh) then
        DeleteEntity(veh)
    end
end

local awaitingScreenshot = false

local function takeScreenshotForVehicle(id)
    local vehicle = vehicles[id]
    local model = vehicle.model

    while DoesEntityExist(currentVehicleEntity) do 
        DeleteVehicle(currentVehicleEntity)
    end

    if IsModelInCdimage(model) then
        if not cam then
            CreateCamera()
        end

        currentVehicleEntity = SpawnVehicle(model)

        Wait(2000)

        awaitingScreenshot = true

        exports['screenshot-basic']:requestScreenshotUpload(
            "https://api.fivemerr.com/v1/media/images",
            "file",
            {
                headers = { Authorization = config.fivemerrApiToken },
                encoding = 'png'
            },
            function(data)
                local image = json.decode(data)
                if image then
                    local newUrl = image.url
                    print("Captured image for " .. model .. " -> " .. newUrl)
                    TriggerServerEvent('updateVehicleImage', id, newUrl)
                    Wait(2000)
                    awaitingScreenshot =false
                else
                    print("Failed to get image for " .. model)
                end

                DeleteVehicle(currentVehicleEntity)
                currentVehicleEntity = nil
            end
        )
    else
        print("Model " .. model .. " is not in the CD image.")
    end
end

RegisterCommand('screenshotVehicles', function()
    savedCoords = GetEntityCoords(cache.ped)
    Wait(500)
    SetEntityCoords(cache.ped, config.pedCoords.x,config.pedCoords.y,config.pedCoords.z)
    for id, vehicle in pairs(vehicles) do
        takeScreenshotForVehicle(id)
        while awaitingScreenshot do Wait(100) end
    end
    DestroyCamera()
    TriggerServerEvent('finishScreenshot')
    SetEntityCoords(cache.ped, savedCoords.x, savedCoords.y, savedCoords.z)
end)
