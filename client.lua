local canRepair = false

--Keybind to repair
local repairzonebind = lib.addKeybind({
    name = 'repairzone',
    description = 'Press e to repair your vehicle',
    defaultKey = 'E',
    onPressed = function()
        TriggerEvent('nazz:repairzones')
    end
})
repairzonebind:disable(true)

--Function

function getClosestVehicle(coords)
    local ped = cache.ped
    local vehicles = GetGamePool('CVehicle')
    local closestDistance = -1
    local closestVehicle = -1
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end
    for i = 1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance = #(vehicleCoords - coords)

        if closestDistance == -1 or closestDistance > distance then
            closestVehicle = vehicles[i]
            closestDistance = distance
        end
    end
    return closestVehicle, closestDistance
end

local function RepairVehicle(veh)
    local veh = getClosestVehicle()
    SetVehicleFixed(veh)
    SetVehicleEngineOn(veh, true, false)
    SetVehicleTyreFixed(veh, 0)
    SetVehicleTyreFixed(veh, 1)
    SetVehicleTyreFixed(veh, 2)
    SetVehicleTyreFixed(veh, 3)
    SetVehicleTyreFixed(veh, 4)
end

function onEnter(self)
    repairzonebind:disable(false)
end
     
function onExit(self)
    canRepair = false
    repairzonebind:disable(true)
    lib.hideTextUI()
end
     
function inside(self)
    canRepair = true
    lib.showTextUI('[E] Repair Vehicle', {
        icon = 'fa-solid fa-screwdriver-wrench',
        position = "left-center"
    })
end
     
for k, v in pairs(Config.RepairZone) do
    local poly = lib.zones.poly({
    points = v.points,
    thickness = v.thickness,
    debug = true,
    inside = inside,
    onEnter = onEnter,
    onExit = onExit
    })
end

--Event
RegisterNetEvent('nazz:repairzones', function()
    local ped = cache.ped
    if canRepair then
        if IsPedInAnyVehicle(ped) then
            if repairing then return end
            repairing = true
            if lib.progressCircle({
                duration = 5000,
                position = 'bottom',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true
                },
            }) then
	            RepairVehicle(veh)
                lib.notify({
                    title = 'Vehicle Repaired!',
                    type = 'success',
                    position = 'top'
                })
                repairing = false
            end
        else
            lib.notify({
                title = 'Youre not inside vehicle!',
                type = 'error',
                position = 'top'
            })
        end
    else
        lib.notify({
            title = 'Youre outside repair zone!',
            type = 'error',
            position = 'top'
        })
    end
end)
