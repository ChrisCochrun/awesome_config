--[[
  Licensed under GNU General Public License v2 
   * (c) 2013-2014, Yauhen Kirylau
   * (c) 2013, Luke Bonham
   * (c) 2010, Adrian C. <anrxc@sysphere.org>  
--]]

local wibox		= require("wibox")
local awful		= require("awful")
local beautiful		= require("beautiful")

local io		= { popen  = io.popen }
local string		= { match  = string.match,
                            format = string.format }
local setmetatable	= setmetatable

local async	        = require("actionless.async")
local decorated_widget	= require("actionless.widgets.common").decorated
local helpers		= require("actionless.helpers")


-- ALSA volume
local alsa = {}

local function worker(args)
  local args = args or {}
  local color_n = args.color_n or 1

  alsa.widget = decorated_widget({
    left = args.left, right = args.right, color_n = color_n })
  alsa.widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () alsa.toggle() end),
    awful.button({ }, 5, function () alsa.down() end),
    awful.button({ }, 4, function () alsa.up() end)
  ))

  alsa.volume = {
    status = "N/A",
    level = "0"
  }

  alsa.step = args.step or 2
  alsa.update_interval  = args.update_interval or 5
  alsa.channel  = args.channel or "Master"
  alsa.mic_channel = args.mic_channel or "Capture"
  alsa.channels_toggle = args.channels_toggle or {alsa.channel, }

  helpers.set_map("volume in progress", false)

  function alsa.up()
    if helpers.get_map("volume in progress") then
      return
    end
    helpers.set_map("volume in progress", true)

    if alsa.volume.level < 100 then
      alsa.volume.level = alsa.volume.level + alsa.step
    end
    async.execute(
      "amixer -q set " .. alsa.channel .. ",0 " .. alsa.step .. "%+",
      function(f) alsa.post_volume() end)
  end

  function alsa.down()
    if helpers.get_map("volume in progress") then
      return
    end
    helpers.set_map("volume in progress", true)

    if alsa.volume.level > 0 then
      alsa.volume.level = alsa.volume.level - alsa.step
    end
    async.execute(
      "amixer -q set " .. alsa.channel .. ",0 " .. alsa.step .. "%-",
      function(f) alsa.post_volume() end)
  end

  function alsa.post_volume()
    helpers.set_map("volume in progress", false)
    alsa.update_indicator()
  end

  function alsa.toggle()
    if alsa.volume.status == 'off' then
      for _, channel in pairs(alsa.channels_toggle) do 
        awful.util.spawn_with_shell("amixer -q set " .. channel .. ",0 on")
      end
    else
      awful.util.spawn_with_shell("amixer -q set " .. alsa.channel .. ",0 off")
    end
    if alsa.volume.status == 'off' then
      alsa.volume.status = 'on'
    else
      alsa.volume.status = 'off'
    end
    alsa.update_indicator()
  end

  function alsa.toggle_mic()
    awful.util.spawn("amixer -q set " .. alsa.mic_channel .. ",0 toggle")
  end

  function alsa.update_indicator()
    if alsa.volume.status == "off" then
      alsa.widget:set_color('warn')
      alsa.widget:set_image(beautiful.widget_vol_mute)
    elseif alsa.volume.level == 0 then
      alsa.widget:set_color('err')
      alsa.widget:set_image(beautiful.widget_vol_no)
    else
      alsa.widget:set_color(color_n)
      if alsa.volume.level <= 50 then
        alsa.widget:set_image(beautiful.widget_vol_low)
      elseif alsa.volume.level <= 75 then
        alsa.widget:set_image(beautiful.widget_vol)
      else
        alsa.widget:set_image(beautiful.widget_vol_high)
      end
    end
    alsa.widget:set_text(
      string.format(
        "%-4s",
        alsa.volume.level .. "%"
    ))
  end

  function alsa.update()
    async.execute(
      'amixer get ' .. alsa.channel,
      function(str) alsa.post_update(str) end)
  end

  function alsa.post_update(str)
    local level = nil
    level, alsa.volume.status = str:match("([%d]+)%%.*%[([%l]*)")
    alsa.volume.level = tonumber(level) or nil

    if alsa.volume.level == nil
    then
      alsa.volume.level  = 0
      alsa.volume.status = "off"
    end

    if alsa.volume.status == ""
    then
      if alsa.volume.level == 0
      then
        alsa.volume.status = "off"
      else
        alsa.volume.status = "on"
      end
    end

    alsa.update_indicator()
  end

  helpers.newtimer("alsa", alsa.update_interval, alsa.update)
  return setmetatable(alsa, { __index = alsa.widget })
end

return setmetatable(alsa, { __call = function(_, ...) return worker(...) end })
