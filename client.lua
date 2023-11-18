local QBCore = exports['qb-core']:GetCoreObject()
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
local function RepairVehicle(veh)
    local veh = QBCore.Functions.GetClosestVehicle()
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
    local ped = PlayerPedId()
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
                QBCore.Functions.Notify('Vehicle Repaired!', 'success')
                repairing = false
            end
        else
            QBCore.Functions.Notify('Youre not inside vehicle!', 'error')
        end
    else
        QBCore.Functions.Notify('Youre outside repair zone!!', 'error')
    end
end)
