
--[[
                                                  
     Licensed under GNU General Public License v2
      * (c) 2013-2014, Yauheni Kirylau
                                                  
--]]
local naughty      = require("naughty")
local beautiful    = require("beautiful")

local helpers = require("actionless.helpers")
local parse = require("actionless.parse")
local newtimer = helpers.newtimer
local font = helpers.font
local common_widget = require("actionless.widgets.common").widget


-- CPU usage
-- widgets.cpu
local cpu = {
  last_total = 0,
  last_active = 0,
  now = {}
}
cpu.widget = common_widget()
cpu.widget:set_image(beautiful.widget_cpu)
cpu.widget:connect_signal("mouse::enter", function () cpu.show_notification() end)
cpu.widget:connect_signal("mouse::leave", function () cpu.hide_notification() end)

local function worker(args)
  local args     = args or {}
  local update_interval  = args.update_interval or 5
  local bg = args.bg or beautiful.panel_fg or beautiful.fg
  local fg = args.fg or beautiful.panel_bg or beautiful.bg
  cpu.cores_number = args.cores_number or 8
  cpu.font = args.font or font
  cpu.timeout = args.timeout or 0

  cpu.list_len = args.list_length or 10
  cpu.command = args.command
    or [[ top -o \%CPU -b -n 1 -w 512 ]] ..
       [[ | grep " PID" -A ]] .. cpu.list_len + 1 ..
       [[ | awk '{if ($7 > 0.0) {printf "%5s %4s %s\n", $1, $7, $11}}' ]]

  function cpu.hide_notification()
    if cpu.id ~= nil then
      naughty.destroy(cpu.id)
      cpu.id = nil
    end
  end

  function cpu.show_notification()
    cpu.hide_notification()
    local output = parse.command_to_string(cpu.command)
    if output ~= '' then
      output = "  PID %CPU COMMAND\n" .. output
    else
      output = "no running processes atm"
    end
    cpu.id = naughty.notify({
      text = output,
      timeout = cpu.timeout,
      preset = beautiful.naughty_mono_preset
    })
  end

  function cpu.update()
    cpu.now.la1, cpu.now.la5, cpu.now.la15 = parse.find_in_file(
      "/proc/loadavg",
      "^([0-9.]+) ([0-9.]+) ([0-9.]+) .*")
    if tonumber(cpu.now.la1) > cpu.cores_number * 2 then
      cpu.widget:set_bg(beautiful.panel_widget_bg_error)
      cpu.widget:set_fg(beautiful.panel_widget_fg_error)
    elseif tonumber(cpu.now.la1) > cpu.cores_number then
      cpu.widget:set_bg(beautiful.panel_widget_bg_warning)
      cpu.widget:set_fg(beautiful.panel_widget_fg_warning)
    else
      cpu.widget:set_fg(fg)
      cpu.widget:set_bg(bg)
    end
    cpu.widget:set_text(
      string.format(
        "%-4s ",
        cpu.now.la1
    ))
  end

  newtimer("cpu", update_interval, cpu.update)

  return setmetatable(cpu, { __index = cpu.widget })
end

return setmetatable(cpu, { __call = function(_, ...) return worker(...) end })
