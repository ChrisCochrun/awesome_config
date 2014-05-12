--[[
	 Licensed under GNU General Public License v2
	  * (c) 2014, Yauheni Kirylau
--]]

local awful			= require("awful")
local escape_f		= require("awful.util").escape
local naughty		= require("naughty")
local wibox			= require("wibox")
local io			= { popen	= io.popen }
local os			= { execute	= os.execute,
					    getenv	= os.getenv }
local string		= { format	= string.format,
					    gmatch	= string.gmatch,
					    match	= string.match }
local setmetatable	= setmetatable

local helpers		= require("widgets.helpers")
local common		= require("widgets.common")
local beautiful		= helpers.beautiful
local markup		= require("widgets.markup")
local asyncshell	= require("widgets.asyncshell")


-- player infos
local player = {id=nil}
local player_status = {}
player.cover = "/tmp/playercover.png"
player.widget = common.widget(beautiful.widget_music)

local function worker(args)
	local args		= args or {}
	local timeout	 = args.timeout or 2
	local popup_timeout	= args.timeout or 5
	local default_art = args.default_art or ""
	local backend = args.backend or "mpd"
	local cover_size  = args.cover_size or 100
	local resize = string.format('%sx%s', cover_size, cover_size)

	-- mpd related
	local host		= args.host or "127.0.0.1"
	local port		= args.port or "6600"
	local password	= args.password or [[""]]
	local music_dir	= args.music_dir or os.getenv("HOME") .. "/Music"
	local cover_script = helpers.scripts_dir .. "mpdcover"
	if backend == 'mpd' then
		player.cmd = 'ncmpcpp'
	elseif backend == 'clementine' then
		player.cmd = 'clementine'
	end
	helpers.set_map("current player track", nil)

-------------------------------------------------------------------------------
	function player.run_player()
			awful.util.spawn_with_shell(player.cmd)
	end
-------------------------------------------------------------------------------
	function player.hide_notification()
		if player.id ~= nil then
			naughty.destroy(player.id)
			player.id = nil
		end
	end
-------------------------------------------------------------------------------
	function player.show_notification()
		player.hide_notification()
		player.id = naughty.notify({
			icon = player.cover,
			title   = player_status.title,
			text = string.format("%s (%s)\n%s", player_status.album, player_status.date, player_status.artist),
			timeout = popup_timeout
		})
	end
-------------------------------------------------------------------------------
	function player.toggle()
		if player_status.state ~= 'pause'
			and player_status.state ~= 'play'
		then
			player.run_player()
			return
		end
		if backend == 'mpd' then awful.util.spawn_with_shell(
			"mpc toggle || ncmpcpp toggle || ncmpc toggle || pms toggle")
		elseif backend == 'clementine' then awful.util.spawn_with_shell(
			"qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 PlayPause")
		end
		player.update()
	end

	function player.next_song()
		if backend == 'mpd' then awful.util.spawn_with_shell(
			"mpc next || ncmpcpp next || ncmpc next || pms next")
		elseif backend == 'clementine' then awful.util.spawn_with_shell(
			"qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 Next")
		end
		player.update()
	end

	function player.prev_song()
		if backend == 'mpd' then awful.util.spawn_with_shell(
			"mpc prev || ncmpcpp prev || ncmpc prev || pms prev")
		elseif backend == 'clementine' then awful.util.spawn_with_shell(
			"qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 Previous")
		end
		player.update()
	end

	player.widget:connect_signal(
		"mouse::enter", function () player.show_notification() end)
	player.widget:connect_signal(
		"mouse::leave", function () player.hide_notification() end)
	player.widget:buttons(awful.util.table.join(
		awful.button({ }, 1, player.toggle),
		awful.button({ }, 5, player.next_song),
		awful.button({ }, 4, player.prev_song)
	))
-------------------------------------------------------------------------------
	function player.update()
		player_status = {
			state  = "N/A",
			file   = "N/A",
			artist = "N/A",
			title  = "N/A",
			album  = "N/A",
			date   = "N/A"
		}
		if backend == 'mpd' then
			asyncshell.request(
				'mpc --format "file:%file%\\nArtist:%artist%\\nTitle:%title%\\nAlbum:%album%\\nDate:%date%"',
				function(f) player.post_update(f) end)
		elseif backend == 'clementine' then
			asyncshell.request(
				"qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 PlaybackStatus",
				function(f) player.clementine_update(f) end)
		end
	end
-------------------------------------------------------------------------------
	function player.mpd_update(f)
		for line in f:lines() do

			if string.match(line,"%[playing%]") then
				player_status.state  = 'play'
			elseif string.match(line,"%[paused%]") then
				player_status.state = 'pause' end

			k, v = string.match(line, "([%w]+):(.*)$")
			if     k == "file"   then player_status.file   = v
			elseif k == "Artist" then player_status.artist = escape_f(v)
			elseif k == "Title"  then player_status.title  = escape_f(v)
			elseif k == "Album"  then player_status.album  = escape_f(v)
			elseif k == "Date"   then player_status.date   = escape_f(v)
			end

		end
		player.parse_status()
	end

	function player.clementine_update(f)
		for line in f:lines() do
			if string.match(line,"Playing") then
				player_status.state  = 'play'
			elseif string.match(line,"Paused") then
				player_status.state = 'pause' end
		end
		if player_status.state == 'play'
			or player_status.state == 'pause'
		then
			asyncshell.request(
				"qdbus org.mpris.MediaPlayer2.clementine /Player GetMetadata",
				function(f) player.clementine_post_update(f) end)
		else
			player.parse_status()
		end
	end
	function player.clementine_post_update(f)
		for line in f:lines() do
			k, v = string.match(line, "([%w]+): (.*)$")
			if     k == "location" then
				player_status.file = v:match("^file://(.*)$")
			elseif k == "artist" then player_status.artist = escape_f(v)
			elseif k == "title"  then player_status.title  = escape_f(v)
			elseif k == "album"  then player_status.album  = escape_f(v)
			elseif k == "year"   then player_status.date   = escape_f(v)
			elseif k == "arturl" then
				player_status.cover	= v:match("^file://(.*)$")
			end
		end
		player.parse_status()
	end
-------------------------------------------------------------------------------
	function player.predict_missing_tags()
		if player_status.file == 'N/A'
			or player_status.file == ''
		then
			return
		end

		if player_status.artist == "N/A"
			or player_status.artist == ''
		then
			player_status.artist = escape_f(
				player_status.file:match("^.*[/](.*)[/]%d+ [-] .*[/]")
			) or escape_f(
				player_status.file:match("^(.*)[/]%d+ [-] .*")
			) or escape_f(
				player_status.file:match("^.*[/](.*) [-] .*")
			) or escape_f(
				player_status.file:match("^(.*)[/].*")
			) or "N/A"
		end

		if player_status.title == "N/A"
			or player_status.title == ''
		then
			player_status.title = escape_f(
				player_status.file:match(".*[/].* [-] (.*)[.].*")
			) or escape_f(
				player_status.file:match(".*[/](.*) [.].*")
			) or escape_f(player_status.file)
		end
	end
-------------------------------------------------------------------------------
	function player.parse_status()
		player.predict_missing_tags()
		local artist = ""
		local title = ""

		if player_status.state == "play" then
			artist = player_status.artist
			title  = player_status.title
			player.widget.icon_widget:set_image(beautiful.widget_music_on)
			if player_status.title ~= helpers.get_map("current player track") then
				player.process_new_song()
			end
		elseif player_status.state == "pause" then
			artist = "player"
			title  = "paused"
			helpers.set_map("current player track", nil)
			player.widget.icon_widget:set_image(beautiful.widget_music)
		else
			-- stop
			player.widget.icon_widget:set_image(beautiful.widget_music)
		end

		player.widget.text_widget:set_markup(
			'<span font="' .. beautiful.tasklist_font .. '">' ..
			markup(beautiful.player_text, markup.bold(artist)) ..
			' ' ..
			title ..
			'</span>')
	end
-------------------------------------------------------------------------------
	function player.process_new_song()
		helpers.set_map("current player track", player_status.title)
		local command = ''
		if backend == 'clementine' then
			command = string.format(
				[[convert "%q" -thumbnail "%q" -gravity center -background "none" -extent "%q" "%q"]],
				player_status.cover, resize, resize, player.cover)
		elseif backend == 'mpd' then
			command = string.format(
				"%s %q %q %d %q",
				cover_script, music_dir, player_status.file, cover_size, default_art)
		end
		asyncshell.request(
			command,
			function(f) player.show_notification() end)
	end
-------------------------------------------------------------------------------
	helpers.newtimer("player", timeout, player.update)
	return setmetatable(player, { __index = player.widget })
end

return setmetatable(
	player,
	{ __call = function(_, ...)
		return worker(...)
	end }
)
