--[[
    Pigeon Indicators: client.

    The driver presses Left or Right for an indicator and Down for the hazard lights; the same key again
    turns it off. After a turn, the indicator turns itself off once the wheel is straight again.

    GTA doesn't sync indicators between players, so the driver's game asks the server, which checks they're
    the driver and keeps the lights in the vehicle's `pigeonIndicators` state bag (1 left, 2 right,
    3 hazards). Every game shows the lights from it, when it changes and when the vehicle comes into range.
]]

local OFF, LEFT, RIGHT, HAZARD = 0, 1, 2, 3
local TURN_LEFT, TURN_RIGHT = 1, 0      -- SetVehicleIndicatorLights: 1 is the left light, 0 the right
local STRAIGHT = 5.0                    -- degrees of steering that count as straight

-- 'auto' follows ox_lib's language (the ox:locale convar), and English when that isn't set.
local locale = Config.Locale == 'auto' and GetConvar('ox:locale', 'en') or Config.Locale
local strings = Locales[locale] or Locales.en

local blockedClass = {}
for _, class in ipairs(Config.BlockedClasses or {}) do blockedClass[class] = true end

local watch = 0                         -- bumped on every press, so only the newest turn watch keeps going

local function show(veh, state)
    SetVehicleIndicatorLights(veh, TURN_LEFT, state == LEFT or state == HAZARD)
    SetVehicleIndicatorLights(veh, TURN_RIGHT, state == RIGHT or state == HAZARD)
end

local function stateOf(veh)
    return tonumber(Entity(veh).state.pigeonIndicators) or OFF
end

--- The vehicle the player is driving, or nil.
local function driving()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh == 0 or GetPedInVehicleSeat(veh, -1) ~= ped or blockedClass[GetVehicleClass(veh)] then return nil end
    return veh
end

local function send(veh, state)
    TriggerServerEvent('pigeon-indicators:set', VehToNet(veh), state)
end

--- Signed change in heading from a to b, -180 to 180. Positive is turning left.
local function turned(a, b)
    return (b - a + 540.0) % 360.0 - 180.0
end

local function watchTurn(veh, state)
    if not Config.AutoCancel or (state ~= LEFT and state ~= RIGHT) then return end
    watch = watch + 1
    local mine = watch
    CreateThread(function()
        local last = GetEntityHeading(veh)
        local total = 0.0
        local need = tonumber(Config.CancelDegrees) or 50
        while watch == mine and driving() == veh and stateOf(veh) == state do
            local heading = GetEntityHeading(veh)
            local change = turned(last, heading)
            last = heading
            total = total + (state == LEFT and change or -change)
            if total < 0.0 then total = 0.0 end
            if total >= need and math.abs(GetVehicleSteeringAngle(veh)) < STRAIGHT then
                send(veh, OFF)
                break
            end
            Wait(100)
        end
    end)
end

local function press(state)
    local veh = driving()
    if not veh then return end
    local new = stateOf(veh) == state and OFF or state
    send(veh, new)
    -- Show it straight away; the state bag confirms it a moment later.
    show(veh, new)
    watch = watch + 1
    watchTurn(veh, new)
end

AddStateBagChangeHandler('pigeonIndicators', nil, function(bagName, _, value)
    local veh = GetEntityFromStateBagName(bagName)
    local giveUp = GetGameTimer() + 2000
    while veh == 0 and GetGameTimer() < giveUp do
        Wait(100)
        veh = GetEntityFromStateBagName(bagName)
    end
    if veh ~= 0 then show(veh, tonumber(value) or OFF) end
end)

---------------------------------------------------------------------------
-- Keys, commands and exports

local keys, commands = Config.Keys or {}, Config.Commands

RegisterCommand(commands.left, function() press(LEFT) end, false)
RegisterKeyMapping(commands.left, strings.key_left or Locales.en.key_left, 'keyboard', keys.left or '')

RegisterCommand(commands.right, function() press(RIGHT) end, false)
RegisterKeyMapping(commands.right, strings.key_right or Locales.en.key_right, 'keyboard', keys.right or '')

RegisterCommand(commands.hazard, function() press(HAZARD) end, false)
RegisterKeyMapping(commands.hazard, strings.key_hazard or Locales.en.key_hazard, 'keyboard', keys.hazard or '')

local NAMES = { [LEFT] = 'left', [RIGHT] = 'right', [HAZARD] = 'hazard' }

--- 'left', 'right', 'hazard' or nil for a vehicle (the player's own if none is given).
exports('GetIndicators', function(veh)
    veh = veh or GetVehiclePedIsIn(PlayerPedId(), false)
    if not veh or veh == 0 then return nil end
    return NAMES[stateOf(veh)]
end)
