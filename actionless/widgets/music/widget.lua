--[[
  Licensed under GNU General Public License v2
   * (c) 2014, Yauheni Kirylau
--]]

local awful		= require("awful")
local naughty		= require("naughty")
local beautiful		= require("beautiful")
local os		= { getenv	= os.getenv }
local string		= { format	= string.format }
local setmetatable	= setmetatable

local helpers		= require("actionless.helpers")
local escape_f		= helpers.escape
local common_widget	= require("actionless.widgets.common").widget
local markup		= require("actionless.markup")
local async		= require("actionless.async")

local backends		= require("actionless.widgets.music.backends")


local N_A = "N/A"

-- player infos
local player = {id=nil}
player.cover = "/tmp/playercover.png"
player.widget = common_widget(true)

local function worker(args)
  local args            = args or {}
  local update_interval = args.update_interval or 2
  local timeout         = args.timeout or 5
  local default_art     = args.default_art or ""
  local backend_name    = args.backend or "mpd"
  local cover_size      = args.cover_size or 100
  local font            = args.font
                          or beautiful.tasklist_font or beautiful.font
  local bg = args.bg or beautiful.panel_bg or beautiful.bg
  local fg = args.fg or beautiful.panel_fg or beautiful.fg
  player.widget:set_bg(bg)
  player.widget:set_fg(fg)
  local text_color      = beautiful.player_text or fg or beautiful.fg_normal


  local parse_status_callback = function(player_status)
    player.parse_status(player_status) end

  if backend_name == 'mpd' then
    player.backend = backends.mpd
    player.backend.init(
      args,
      parse_status_callback,
      function() player.show_notification() end)
    player.cmd = args.player_cmd or 'st -e ncmpcpp'
  elseif backend_name == 'clementine' then
    player.backend = backends.clementine
    player.backend.init(
      parse_status_callback)
    player.cmd = args.player_cmd or 'clementine'
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
      title   = player.player_status.title,
      text = string.format(
        "%s (%s)\n%s",
        player.player_status.album,
        player.player_status.date,
        player.player_status.artist
      ),
      timeout = timeout
    })
  end
-------------------------------------------------------------------------------
  function player.toggle()
    if player.player_status.state ~= 'pause'
      and player.player_status.state ~= 'play'
    then
      player.run_player()
      return
    end
    player.backend.toggle()
    player.update()
  end

  function player.next_song()
    player.backend.next_song()
    player.update()
  end

  function player.prev_song()
    player.backend.prev_song()
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
    player.backend.update()
  end
-------------------------------------------------------------------------------
  function player.predict_missing_tags(player_status)

    local naughty = {notify = function()end}

    if player_status.file then
      player_status.file = player_status.file:match("^.*://(.*)$")
        or player_status.file
    else
      player_status.file = N_A
    end
    if player_status.cover then
      player_status.cover = player_status.cover:match("^file://(.*)$")
        or player_status.file
    else
      player_status.cover = default_art or N_A
    end

    if player_status.file == N_A or player_status.file == ''
    then
      return player_status
    end

    local a
    --1
    a = player_status.file:match("^.*[/](.*)[/]%d+[-%. ].*[/]")
    if a then naughty.notify({text="*/(Artist Name)/Year - Album/*"}) else
    --2
    a = player_status.file:match("^.*[/]%d+ [-] (.*) [-] .*[.].+")
    if a then naughty.notify({text=2}) else
    --3
    a = player_status.file:match("^(.*)[/]%d+ [-] .*[/]")
    if a then naughty.notify({text=3}) else
    --4
    a = player_status.file:match(".*[/].*[/](.*)[/].*[.].+$")
    if a then naughty.notify({text="/path/to/(Artist or VA)/Song name.ext"}) else
    --5
    a = player_status.file:match("^.*[/]([!/]*)[/][!/]*[.].+$")
    if a then naughty.notify({text=5}) else
    --6
    a = player_status.file:match("^(.*)[/]%d+ [-] .*[/]")
    if a then naughty.notify({text=6}) else
    --7
    a = player_status.file:match("^.*[/](.*) [-] [!/]*[.].+")
    if a then naughty.notify({text=7}) else
    --8
    a = player_status.file:match("^(.*)[/]%d+ [-] .*")
    if a then naughty.notify({text=8}) else
    --9
    a = player_status.file:match("^(.*)[/].*")
    if a then a = ''; naughty.notify({text=9})
    end --9
    end --8
    end --7
    end --6
    end --5
    end --4
    end --3
    end --2
    end --1

    local t = player_status.title
    local new_t
    local f = player_status.file
    naughty.notify({text=t})
    if t:match('%.mp3') then
      --1
      new_t = t:match('^%d+[%. -_]+(.*)%.mp3')
      if new_t then naughty.notify({text="10. - (Song Title).mp3"}) else
      --2
      new_t = t:match('(.*)%.mp3')
      if new_t then naughty.notify({text="(Song Title).mp3"}) else
      new_t = f; naughty.notify({text="Song Title.mp3"})
      end --1
      end --2
    else
      --1
      new_t = f:match(".*[/].* [-] (.*)[.].+$")
      if t then naughty.notify({text="t1"}) else
      --2
      new_t = f:match(".*[/]%d+[ -]+(.*)[.].+$")
      if t then naughty.notify({text="t2"}) else
      --3
      new_t = f:match(".*[/](.*) [.].*")
      if t then naughty.notify({text="t3"}) else
      --4
      new_t = f:match(".*[/](.*)[.].*")
      if t then naughty.notify({text="t4"}) else
      new_t = f; naughty.notify({text="t5"})
      end --4
      end --3
      end --2
      end --1
    end

    if not t or #t == 0 or t:match('%.mp3') then
      player_status.title = new_t
    end
    if not player_status.artist or #player_status.artist == 0 then
      player_status.artist = a
    end

    -- let's insert placeholders for all the missing fields
    for _, k in ipairs({
      'file', 'locationartist', 'title', 'album', 'date', 'cover', 'artist',
    }) do
      if not player_status[k] then
        player_status[k] = N_A
      end
    end
    return player_status
  end
-------------------------------------------------------------------------------
  function player.parse_status(player_status)
    player_status = player.predict_missing_tags(player_status)
    player.player_status = player_status

    local artist = ""
    local title = ""

    if player_status.state == "play" then
      -- playing
      artist = player_status.artist
      title = player_status.title
      player.widget:set_image(beautiful.widget_music_on)
      if #player_status.artist + #player_status.title > 40 then
        if #player_status.artist > 15 then
          --artist = string.format("%.15s", player_status.artist) .. "…"
          artist = helpers.unicode_max_length(player_status.artist, 15) .. "…"
        end
        if #player_status.title > 25 then
          --title = string.format("%.25s", player_status.title) .. "…"
          title = helpers.unicode_max_length(player_status.title, 25) .. "…"
        end
      end
      artist = markup.fg.color(text_color, escape_f(artist))
      title = escape_f(title)
      -- playing new song
      if player_status.title ~= helpers.get_map("current player track") then
        helpers.set_map("current player track", player_status.title)
        player.resize_cover()
      end
    elseif player_status.state == "pause" then
      -- paused
      artist = "player"
      title  = "paused"
      helpers.set_map("current player track", nil)
      player.widget:set_image(beautiful.widget_music)
    else
      -- stop
      player.widget:set_image(beautiful.widget_music_off)
    end


    if player_status.state == "play" or player_status.state == "pause" then
      player.widget:set_bg(bg)
      player.widget:set_fg(fg)
      player.widget:set_markup(
        markup.font(font,
          markup.bold(
            artist)
          .. " " ..
          markup.fg.color(fg,
            title)
          .. " ")
      )
    else
      player.widget:set_text('')
      player.widget:set_bg(fg)
      player.widget:set_fg(bg)
    end
  end
-------------------------------------------------------------------------------
function player.resize_cover()
  if player.backend.resize_cover then
    return player.backend.resize_cover(cover_size, default_art)
  end
  local resize = string.format('%sx%s', cover_size, cover_size)
  async.execute(
    string.format(
      [[convert %q -thumbnail %q -gravity center -background "none" -extent %q %q]],
      player.player_status.cover,
      resize,
      resize,
      player.cover),
    function(f) player.show_notification() end)
end
-------------------------------------------------------------------------------
  helpers.newtimer("player", update_interval, player.update)
  return setmetatable(player, { __index = player.widget })
end

return setmetatable(
  player,
  { __call = function(_, ...)
      return worker(...)
    end }
)
