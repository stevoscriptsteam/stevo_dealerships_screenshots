local config = lib.require('config')
local vehicles = config.vehicles

RegisterNetEvent('updateVehicleImage')
AddEventHandler('updateVehicleImage', function(model, newImageUrl)
    local pdm = vehicles
    if pdm and pdm[model] then
        pdm[model].image = newImageUrl
        print("Server: Updated image for " .. model)
    else
        print("Server: Vehicle " .. model .. " not found in dealership table.")
    end
end)

local function serializeTable(val, indent)
    indent = indent or ""
    local result = ""
    if type(val) == "table" then
        result = result .. "{\n"
        for k, v in pairs(val) do
            local key
            if type(k) == "string" and k:match("^[%a_][%w_]*$") then
                key = k
            else
                key = "[" .. serializeTable(k, indent .. "    ") .. "]"
            end
            result = result .. indent .. "    " .. key .. " = " .. serializeTable(v, indent .. "    ") .. ",\n"
        end
        result = result .. indent .. "}"
    elseif type(val) == "string" then
        result = result .. string.format("%q", val)
    else
        result = result .. tostring(val)
    end
    return result
end
RegisterNetEvent('finishScreenshot')
AddEventHandler('finishScreenshot', function()
    local fileContent = "return " .. serializeTable(vehicles, "") .. "\n"
    local resourceName = GetCurrentResourceName()
    local success = SaveResourceFile(resourceName, "modified_dealership.lua", fileContent, -1)
    if success then
        print("Server: Successfully exported modified dealership table to modified_dealership.lua")
    else
        print("Server: Failed to export the modified dealership table.")
    end
end)
