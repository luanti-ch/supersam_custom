local http = ...

local url = minetest.settings:get("discord_highscore_url")
if not url or url == "" then
    return
end

local old_set_level_highscore = super_sam_highscore.set_level_highscore
super_sam_highscore.set_level_highscore = function(levelname, highscore, playername, score)
    local content = ""
    content = content .. "## Highscore for level _" .. levelname .. "_\n"

    for i, entry in ipairs(highscore) do
        local icon = ""
        if i == 1 then
            icon = ":first_place:"
        elseif i == 2 then
            icon = ":second_place:"
        elseif i == 3 then
            icon = ":third_place:"
        elseif i == 10 then
            icon = ":poop:"
        end

        local suffix = ""
        if entry.name == playername and entry.score == score then
            -- mark new entry
            suffix = " :new:"
        end

        content = content .. "* " .. icon ..
            " $ **" .. entry.score .. "**" ..
            " `" .. entry. name .. "`" ..
            " (" .. os.date('%Y-%m-%d', entry.timestamp) .. ")" ..
            suffix ..
            "\n"
    end

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

    return old_set_level_highscore(levelname, highscore)
end