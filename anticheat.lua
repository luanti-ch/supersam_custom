-- simple node-based anticheat

-- list of blocks that trigger a level-reset if the player is found inside them
local checked_blocks = {
    ["super_sam:ice"] = true,
    ["super_sam:glass"] = true,
    ["super_sam:dirt"] = true,
    ["super_sam:grass"] = true,
    ["super_sam:stone"] = true,
    ["super_sam:cobble"] = true
}

-- periodic per-player check
local function check_player(player)
	local has_noclip = minetest.check_player_privs(player, "noclip")
	if has_noclip then
		-- player with noclip priv, skip check
		return
	end

	local playername = player:get_player_name()
    local ppos = player:get_pos()
	local node = minetest.get_node(ppos)
	if checked_blocks[node.name] then
        local msg = "player " .. playername .. " entered a checked block: " .. node.name ..
        " @ " .. minetest.pos_to_string(ppos)

        -- chat relay
        beerchat.on_channel_message("main", "SYSTEM", msg)
        -- logs
		minetest.log("action", msg)
        -- player
        minetest.chat_send_player(playername, "Anticheat triggered, level has been reset!")
        -- action
        super_sam_level.abort_level(player)
	end
end

-- check for player-block positions every second
local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 1 then
		return
	end
	timer = 0

	for _, player in pairs(minetest.get_connected_players()) do
		check_player(player)
	end
end)