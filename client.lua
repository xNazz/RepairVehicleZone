local QBCore = exports['qb-core']:GetCoreObject()
local canRepair = false

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

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        if canRepair then
            if IsControlJustPressed(0, 46) and IsPedInAnyVehicle(ped) then
                RepairVehicle(veh)
                QBCore.Functions.Notify('Vehicle Repaired!', 'success')
            end
        end
        Wait(0)
    end
end)

CreateThread(function()
    local zones = {}
    local ped = PlayerPedId()

    for k, v in pairs(Config.RepairZone) do
        zones[#zones+1] = PolyZone:Create(v.points, {
            name = v.name,
            minZ = v.minZ,
            maxZ = v.maxZ,
            debugGrid = false,
        })
    end

    local Repair = ComboZone:Create(zones, {
        name = "Repair", 
        debugPoly = false
    })

    Repair:onPlayerInOut(function(isPointInside, point, zone)
        if isPointInside then
            lib.showTextUI('[E] Repair Vehicle', {
                icon = 'fa-solid fa-screwdriver-wrench',
                position = "left-center"
            })
            canRepair = true
        else
            lib.hideTextUI()
            canRepair = false
        end
    end)
end)