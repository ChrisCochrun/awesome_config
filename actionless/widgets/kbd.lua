--[[            
     Licensed under GNU General Public License v2
      * (c) 2013-2014, Yauheni Kirylau             
--]]

local beautiful = require("beautiful")
local setmetatable = setmetatable
local common	= require("actionless.widgets.common")


local kbd = {}
kbd.widget = common.widget()

local function worker(args)
  local args	 = args or {}
  local bg = args.bg or beautiful.panel_widget_bg_warning or beautiful.fg
  local fg = args.fg or beautiful.panel_widget_fg_warning or beautiful.bg
  local layouts = args.layouts or {"eng", "rus"}
  local default_layout = args.default_layout or "eng"
  kbd.widget = common.decorated({
    widget=kbd.widget, bg=bg, fg=fg, widget_inverted=true,
  })
  kbd.widget:hide()

  dbus.request_name("session", "ru.gentoo.kbdd")
  dbus.add_match("session", "interface='ru.gentoo.kbdd',member='layoutChanged'")
  dbus.connect_signal("ru.gentoo.kbdd", function(...)
    local data = {...}
    local layout = data[2] + 1
    local current_layout = layouts[layout]
    if current_layout == default_layout then
      kbd.widget:hide()
    else
      kbd.widget:show()
      kbd.widget:set_markup(current_layout)
    end
  end)

  return setmetatable(kbd, { __index = kbd.widget })
end

return setmetatable(kbd, { __call = function(_, ...) return worker(...) end })
