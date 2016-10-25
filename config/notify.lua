local naughty = require("naughty")
local gears = require("gears")
local beautiful = require("beautiful")

local awesome = awesome

local notify = {}

function notify.init(_)

  naughty.config.defaults.opacity = beautiful.notification_opacity
  naughty.config.defaults.font = beautiful.notification_font
  naughty.config.defaults.bg = beautiful.notification_bg
  naughty.config.defaults.fg = beautiful.notification_fg
  naughty.config.defaults.border_color = beautiful.notification_border_color
  naughty.config.defaults.border_width = beautiful.notification_border_width
  naughty.config.defaults.margin = beautiful.notification_margin

  --naughty.config.defaults.shape = gears.shape.rounded_rect
  --naughty.config.defaults.shape_args = {beautiful.notification_border_radius or beautiful.border_radius}
  naughty.config.defaults.shape = function(cr,w,h)
    gears.shape.rounded_rect(
      cr, w, h, beautiful.notification_border_radius or beautiful.border_radius
    )
  end

  naughty.config.presets.low.opacity = beautiful.notification_opacity
  naughty.config.presets.low.font = beautiful.notification_font

  naughty.config.presets.critical.opacity = beautiful.notification_opacity
  naughty.config.presets.critical.font = beautiful.notification_font


  -- {{{ Error handling
  -- Check if awesome encountered an error during startup and fell back to
  -- another config (This code will only ever execute for the fallback config)
  if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
  end

  -- Handle runtime errors after startup
  do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
      -- Make sure we don't go into an endless error loop
      if in_error then return end
      in_error = true

      naughty.notify({ preset = naughty.config.presets.critical,
                       title = "Oops, an error happened!",
                       text = err })
      in_error = false
    end)
  end
  -- }}}
end
return notify
