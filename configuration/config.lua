Config = {}

-- Language for the key binding names in GTA's settings. 'auto' follows ox_lib's language (setr ox:locale
-- "de" in server.cfg) and is English when that isn't set. Or name a file from locales/, such as 'de'.
Config.Locale = 'auto'

-- Keys and commands. Players can change the keys in GTA's Settings -> Key Bindings -> FiveM.
-- Codes: https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
Config.Keys = {
    left = 'LEFT',
    right = 'RIGHT',
    hazard = 'DOWN',
}
Config.Commands = {
    left = 'indicatorleft',
    right = 'indicatorright',
    hazard = 'hazards',
}

-- Turn the indicator off by itself after a turn, like a real car: once the vehicle has turned at least
-- Config.CancelDegrees that way and the wheel is straight again. false keeps it on until pressed again.
Config.AutoCancel = true
Config.CancelDegrees = 50

-- Vehicle classes without indicators. 13 cycles, 14 boats, 15 helicopters, 16 planes, 21 trains.
-- Classes: https://docs.fivem.net/natives/?_0x29439776AAA00A62
Config.BlockedClasses = { 13, 14, 15, 16, 21 }

-- Update checks are controlled in server.cfg for every Pigeon Studios resource at once:
--     set pigeon_update_check "on"      (default)  |  "quiet"  |  "off"
