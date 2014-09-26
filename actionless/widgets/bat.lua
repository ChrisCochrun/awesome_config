--[[
  Licensed under GNU General Public License v2
   * (c) 2014, Yauheni Kirylau
--]]

local naughty		= require("naughty")
local wibox		= require("wibox")
local beautiful		= require("beautiful")

local async		= require("actionless.async")
local helpers 		= require("actionless.helpers")
local h_string 		= require("actionless.string")
local parse 		= require("actionless.parse")
local common_widget	= require("actionless.widgets.common").widget


-- Batterys info
local bat = {}
bat.widget = common_widget()
bat.now = {
  percentage = "N/A",
  state = "N/A",
  on_low_battery = nil
}

local function worker(args)
  local args = args or {}
  local update_interval = args.update_interval or 30
  local device = args.device or "battery_BAT0"
  local bg = args.bg or beautiful.panel_fg or beautiful.fg
  local fg = args.fg or beautiful.panel_bg or beautiful.bg
  local hide_if_charged = args.hide_if_charged or true

  function bat.update()
    async.execute(
      'upower -i /org/freedesktop/UPower/devices/' .. device,
      function(str) bat.post_update(str) end)
  end

  function bat.post_update(str)
    bat.now = parse.find_values_in_string(
      str, "[ ]+(.*):[ ]+(.*)",
      { percentage='percentage',
        state='state',
        on_low_battery='on-low-battery' }
    )
    bat.now.percentage = h_string.only_digits(bat.now.percentage)

    if hide_if_charged and bat.now.state == 'fully-charged' then
      bat.widget:set_text('')
    else
      bat.widget:set_markup(
        string.format("%-4s", bat.now.percentage .. "%")
      )
      -- charged:
      if bat.now.state == 'fully-charged' then
        bat.widget:set_image(beautiful.widget_ac)
        bat.widget:set_bg(bg)
        bat.widget:set_fg(fg)
      -- charging:
      elseif bat.now.state == 'charging' then
        if bat.now.percentage < 30 then
          bat.widget:set_image(beautiful.widget_ac_charging_low)
          bat.widget:set_bg(beautiful.warning)
          bat.widget:set_fg(fg)
        else
          bat.widget:set_image(beautiful.widget_ac_charging)
          bat.widget:set_bg(bg)
          bat.widget:set_fg(fg)
        end
      -- on battery:
      else
        if bat.now.on_low_battery == 'yes' then
          bat.widget:set_image(beautiful.widget_battery_empty)
          bat.widget:set_bg(beautiful.error)
          bat.widget:set_fg(fg)
        elseif bat.now.percentage < 30 then
          bat.widget:set_image(beautiful.widget_battery_low)
          bat.widget:set_bg(beautiful.warning)
          bat.widget:set_fg(fg)
        else
          bat.widget:set_image(beautiful.widget_battery)
          bat.widget:set_bg(bg)
          bat.widget:set_fg(fg)
        end
      end
    end
    -- notifications for low and critical states
    --if bat.now.perc <= 5
    --then
    --        bat.id = naughty.notify({
    --            text = "shutdown imminent",
    --            title = "battery nearly exhausted",
    --            position = "top_right",
    --            update_interval = 15,
    --            fg="#000000",
    --            bg="#ffffff",
    --            ontop = true,
    --            replaces_id = bat.id
    --        }).id
    --end
  end

  helpers.newtimer("bat_widget_" .. device, update_interval, bat.update)

  return bat.widget
end

return setmetatable(bat, { __call = function(_, ...) return worker(...) end })
