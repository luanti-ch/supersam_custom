super_sam.on_event("level_finished", function(player, highscore_name, score, rank)
    beerchat.on_channel_message("main", "SYSTEM", "➢ Player '" .. player:get_player_name() ..
        "' finished level '" .. highscore_name ..
        "' with " .. score ..
        " points and rank " .. (rank and rank or "<none>")
    )
end)