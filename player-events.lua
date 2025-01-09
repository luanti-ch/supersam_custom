local http = ...

local url = minetest.settings:get("discord_player_events_url")
if not url or url == "" then
    return
end

local function send_webhook(content)
    http.fetch({
		url = url,
		method = "POST",
		extra_headers = {
			"Content-Type: application/json",
			"Accept: application/json"
		},
		timeout = 5,
		data = minetest.write_json({ content = content })
	}, function()
		-- ignore errors
	end)
end

super_sam.on_event(super_sam.EVENT_PLAYER_START, function(player, levelname)
    send_webhook(":play_pause: `" .. player:get_player_name() .. "` starts level **" .. levelname .. "**")
end)

super_sam.on_event(super_sam.EVENT_PLAYER_FINISHED, function(player, levelname)
    send_webhook(":stop_button: `" .. player:get_player_name() .. "` finished level **" .. levelname .. "**")
end)

super_sam.on_event(super_sam.EVENT_PLAYER_ABORTED, function(player)
    send_webhook(":skull_crossbones: `" .. player:get_player_name() .. "` aborted their level")
end)

super_sam.on_event(super_sam.EVENT_TIMEOUT, function(player)
    send_webhook(":super_sam_time: level-timeout for player `" .. player:get_player_name() .. "`")
end)
