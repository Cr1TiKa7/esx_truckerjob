-- TODO: Default veriables...
local Keys      = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}


local ESX           = nil
local ped           = PlayerPedId()
local pedCoords     = {}
local pedDuty       = false
local truckVeh      = nil
local trailerVeh    = nil
local jIndex        = nil
local isDrawMarker  = false
local markerPos     = nil
local isInJob       = false

AddEventHandler('playerSpawned', function()
    Citizen.CreateThread(function()
        while ESX == nil do
            Citizen.Wait(10)
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        end
    end)
end)

-- TODO: ESX
Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(10)
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
end)

-- TODO: optimization veriables...
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(250)
        pedCoords = GetEntityCoords(GetPlayerPed(-1)) -- TODO: pedCoords.x, pedCoords.y, pedCoords.z
    end
end)

-- TODO: Create Blip
Citizen.CreateThread(function()
    local blip = CreateCustomBlip(
        Config.TruckerJob.DutyPos,
        Config.Blip['sprite'],
        Config.Blip['display'],
        Config.Blip['scale'],
        Config.Blip['color'],
        Config.Blip['alpha'],
        Config.Blip['friend'],
        Config.Blip['short'],
        Config.Blip['name'],
        'TRUCKERBLIP'
    )
end)

-- TODO: Duty Mark
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local dutyPos = Config.TruckerJob.DutyPos
        DrawCustomMarker(2, dutyPos, true, 1.3, false, true)
        if Vdist(dutyPos.x, dutyPos.y, dutyPos.z, pedCoords.x, pedCoords.y, pedCoords.z) < 1.3 then                
            ShowPedHelpDialog(_U('duty_help_msg'))

            if IsControlPressed(0, Keys['E']) then
                if (pedDuty == false) then
                    pedDuty = true
                    ShowPedHelpDialog(_U('duty_on_msg'))
                    JobSetUniform(Config.JobUniforms.male, Config.JobUniforms.female)
                    Citizen.Wait(1000)
                else
                    pedDuty = false
                    isInJob = false
                    ShowPedHelpDialog(_U('duty_off_msg'))
                    ResetSkin()
                    ResetJob()
                    Citizen.Wait(1000)
                end
            end
        end
        local spawnPos = Config.TruckerJob.SpawnPos
        if isInJob == false and pedDuty then
            DrawCustomMarker(22, spawnPos, true, 1.3, true)
            if Vdist(spawnPos.x, spawnPos.y, spawnPos.z, pedCoords.x, pedCoords.y, pedCoords.z) < 1.3 then                
                ShowPedHelpDialog(_U('get_truck_msg'))
    
                if IsControlPressed(0, Keys['E']) then
                    ShowMenu()
                end
            end
        end
    end
end)

function ShowMenu()
    Citizen.Wait(120)
    ESX.UI.Menu.CloseAll()

    local elem = {}

    local i = 1
    for _, v in ipairs(Config.TruckerJob) do
        for key, _v in ipairs(v.Jobs) do
            table.insert(elem, {label = _v.Name, value = i})
            i = i + 1
        end
    end

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'truckerjobdutymenu',
        {
            title = _U('job_menu_title'),
            align = 'top-left',
            elements = elem
        },

        function(data, menu)
            if (data.current.value ~= nil) then
                isInJob = true
                StartJob(data.current.value)
            end
            menu.close()
        end,

        -- TODO: close menu (ESC, etc...)
        function(data, menu)
            menu.close()
        end
    )
end

function StartJob(jobIndex)
    Citizen.CreateThread(function()
        for _, v in ipairs(Config.TruckerJob) do
            jIndex = jobIndex
            local truckJob = Config.TruckerJob
            -- Spawn truck
            ESX.Game.SpawnVehicle(v.Jobs[jobIndex].Vehicle, vector3(truckJob.TruckSpawn.x, truckJob.TruckSpawn.y,truckJob.TruckSpawn.z), truckJob.TruckSpawn.h, function(vehicle)                
                
                if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
                    truckVeh = vehicle
                    Citizen.Wait(200)      
                end
            end)
            -- Spawn trailer
            ESX.Game.SpawnVehicle(v.Jobs[jobIndex].Trailer, vector3(v.Jobs[jobIndex].TrailerSpawn.x, v.Jobs[jobIndex].TrailerSpawn.y, v.Jobs[jobIndex].TrailerSpawn.z), v.Jobs[jobIndex].TrailerSpawn.h, function(vehicle)                
                if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
                    trailerVeh = vehicle
                    Citizen.Wait(200)      
                end
            end)
            ShowPedHelpDialog(_U('enter_truck_msg'))
            SetNewWaypoint(truckJob.TruckSpawn.x, truckJob.TruckSpawn.y)
            while (GetVehiclePedIsIn(ped, truckVeh) == 0)do
                Citizen.Wait(100)
            end
            RemoveSmallBlip(vehBlip)
            ShowPedHelpDialog(_U('get_trailer_msg'))
            SetNewWaypoint(v.Jobs[jobIndex].TrailerSpawn.x, v.Jobs[jobIndex].TrailerSpawn.y)
            while (IsTrailerAttached() == false)do
                Citizen.Wait(100)
            end
            ShowPedHelpDialog(_U('bring_trailer_to_dest_msg'))
            RemoveSmallBlip(trailerBlip)
            SetNewWaypoint(v.Jobs[jobIndex].Destination.x, v.Jobs[jobIndex].Destination.y)
            isDrawMarker = true
            markerPos = v.Jobs[jobIndex].Destination
            BringTrailerToDestination()
        end
    end)    
end

function BringTrailerToDestination()
    Citizen.CreateThread(function()
        local sleep = 100
        while(true) do
            if Vdist(markerPos.x, markerPos.y, markerPos.z, pedCoords.x, pedCoords.y, pedCoords.z) < 5.0 then                
                sleep = 0
                ShowPedHelpDialog(_U('trailer_at_finalpos_msg'))
                if IsControlPressed(0, Keys['E']) then
                    DeleteVehicle(trailerVeh)
                    trailerVeh = nil
                    SetNewWaypoint(Config.TruckerJob.FinalPos.x,Config.TruckerJob.FinalPos.y)
                    markerPos = Config.TruckerJob.FinalPos
                    break
                end
            else
                sleep = 100
            end
            Citizen.Wait(sleep)
        end
        ShowPedHelpDialog(_U('bring_truck_back_msg'))
        BringTruckBack()
    end)
end

function BringTruckBack()
    Citizen.CreateThread(function()
        local sleep = 100
        while (true) do
            if Vdist(markerPos.x, markerPos.y, markerPos.z, pedCoords.x, pedCoords.y, pedCoords.z) < 5.0 then                
                sleep = 0
                ShowPedHelpDialog(_U('truck_at_finalpos_msg'))
                if IsControlPressed(0, Keys['E']) then
                    DeleteVehicle(truckVeh)
                    truckVeh = nil
                    isDrawMarker = false
                    markerPos = nil
                    isInJob = false
                    TriggerServerEvent('esx:truckerjob_confirmPay', GetPlayerServerId(PlayerId()), jIndex)
                    return
                end
            else
                sleep = 100
            end
            Citizen.Wait(sleep)
        end
    end)
end

function ResetJob()
    if DoesEntityExist(truckVeh) and IsEntityAVehicle(truckVeh) then
        ESX.Game.DeleteVehicle(truckVeh)
        truckVeh = nil
    end
    if (DoesEntityExist(trailerVeh)) and IsEntityAVehicle(trailerVeh) then
        ESX.Game.DeleteVehicle(trailerVeh)
        trailerVeh = nil
    end 
end

Citizen.CreateThread(function()
    local sleep = 1000
    while true do
        if isDrawMarker == true and markerPos ~= nil then
            sleep = 0
            DrawMarker(25, markerPos.x, markerPos.y, markerPos.z - 0.5, 0.0, 0.0, 0.0, 
            0.0, 0.0, 0.0, 5.0, 5.0, 5.0, 
            255, 255, 0, 200, 
            true, false, 2, true, nil, nil, false)
        else
            sleep = 1000
        end
        Citizen.Wait(sleep)
    end
end)