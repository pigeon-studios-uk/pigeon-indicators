--[[
    Pigeon Indicators: server.

    Sets a vehicle's `pigeonIndicators` state bag (1 left, 2 right, 3 hazards, nil off) when its driver
    asks, after checking the vehicle exists, the player is its driver, and they aren't sending too many.
]]

local RATE_MS = 150             -- the shortest time between two changes from one player

local last = {}

AddEventHandler('playerDropped', function() last[source] = nil end)

RegisterNetEvent('pigeon-indicators:set', function(netId, state)
    local src = source
    if type(netId) ~= 'number' or (state ~= 0 and state ~= 1 and state ~= 2 and state ~= 3) then return end

    local now = GetGameTimer()
    if last[src] and now - last[src] < RATE_MS then return end
    last[src] = now

    local veh = NetworkGetEntityFromNetworkId(netId)
    if veh == 0 or not DoesEntityExist(veh) or GetEntityType(veh) ~= 2 then return end
    local ped = GetPlayerPed(src)
    if ped == 0 or GetPedInVehicleSeat(veh, -1) ~= ped then return end

    Entity(veh).state:set('pigeonIndicators', state ~= 0 and state or nil, true)
end)
