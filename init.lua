local MP = minetest.get_modpath(minetest.get_current_modname())

dofile(MP .. "/fixed_time.lua")
dofile(MP .. "/level.lua")

local http = minetest.request_http_api()
loadfile(MP.."/highscore.lua")(http)
loadfile(MP.."/player-events.lua")(http)

-- disabled, not very usable
-- dofile(MP .. "/anticheat.lua")
