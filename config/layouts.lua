local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local lcars_layout = require("actionless.lcars_layout")
local persistent = require("actionless.persistent")

local layouts = {}


function layouts.init(context)

  -- Table of layouts to cover with awful.layout.inc, order matters.
  context.layouts = {
    awful.layout.suit.tile,
    persistent.lcarslist.get() and lcars_layout.top or awful.layout.suit.tile.bottom,
    awful.layout.suit.corner.nw,
    awful.layout.suit.floating,
    awful.layout.suit.fair,
    awful.layout.suit.spiral,
  }
  awful.layout.layouts = context.layouts
  -- }}}

  -- {{{ Wallpaper
  if beautiful.wallpaper then
    local wallpaper_layout = beautiful.wallpaper_layout or "tiled"
    awful.screen.connect_for_each_screen(function(s)
      gears.wallpaper[wallpaper_layout](beautiful.wallpaper, s)
    end)
  elseif beautiful.wallpaper_cmd then
      awful.spawn.with_shell(beautiful.wallpaper_cmd)
  end
  -- }}}

  -- {{{ Tags
  -- Define a tag table which hold all screen tags.
  context.tags = {}
  awful.screen.connect_for_each_screen(function(s)

    local enabled_layouts = {}
    for i, id in ipairs(persistent.layout.get_all_ids(s, {
      1, 1, 1, 1, 1, 1,
      1, 1, 1, 4, 1, 1,
    })) do
      enabled_layouts[i] = awful.layout.layouts[id]
    end
    local tags = awful.tag(
      persistent.tag.get_all_names(s, {
        '1:bs', '2:web',  '3:ww', '4:im',   '5:mm', 6,
        '7:sp', 8,        '9:sd', '10:nl',  '11', '12'
      }),
      s,
      enabled_layouts
    )

    for tag_number, mwfact in ipairs(persistent.tag.get_all_mwfact(s, {
    --1     2     3      4     5     6
      0.60, 0.75, 0.50,  0.50, 0.50, 0.50,
    --7     8     9      10    11    12
      0.50, 0.50, 0.50,  0.50, 0.50, 0.50
    })) do
        tags[tag_number].master_width_factor = mwfact
    end

    for tag_number, mfpol in ipairs(persistent.tag.get_all_mfpol(s, {
    --1                      2                      3
      "master_width_factor", "expand",              "master_width_factor",
    --4                      5                      6
      "expand",              "master_width_factor", "expand",
    --7                      8                      9
      "expand",              "expand",              "master_width_factor",
    --10                     11                     12
      "expand",              "expand",              "expand"
    })) do
        tags[tag_number].master_fill_policy = mfpol
    end

    context.tags[s.index] = tags

  end)
  -- }}}

end
return layouts
