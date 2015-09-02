--[[
  Licensed under GNU General Public License v2
   * (c) 2013-2014, Yauheni Kirylau
--]]

local beautiful		= require("beautiful")
local awful             = require("awful")

local newinterval	= require("actionless.helpers").newinterval
local common_widget	= require("actionless.widgets.common").widget
local parse		= require("utils.parse")


local netctl = {
  widget = common_widget()
}

local function worker(args)
  local args = args or {}
  local update_interval = args.update_interval or 5
  local font = args.font or beautiful.tasklist_font or beautiful.font
  local bg = args.bg or beautiful.panel_bg or beautiful.bg
  local fg = args.fg or beautiful.panel_fg or beautiful.fg
  netctl.timeout = args.timeout or 0
  netctl.font = args.font or font

  netctl.widget:set_bg(bg)
  netctl.widget:set_fg(fg)

  netctl.preset = args.preset or 'bond' -- or netctl or netctl-auto
  netctl.wlan_if = args.wlan_if or 'wlan0'
  netctl.eth_if = args.eth_if or 'eth0'

  function netctl.update()
    if netctl.preset == 'bond' then
      netctl.update_bond()
    elseif netctl.preset == 'netctl-auto' then
      netctl.netctl_auto_update()
    elseif netctl.preset == 'netctl' then
      netctl.netctl_update()
    elseif netctl.preset == 'systemd' then
      netctl.systemd_update()
    end
  end

  function netctl.systemd_update()
    awful.util.spawn_with_line_callback(
      "systemctl list-unit-files systemd-networkd.service",
      function(str)
        netctl.update_widget(
          str:match("systemd%-(networkd)%.service.*enabled.*"
          ) or 'networkd...')
      end)
  end

  function netctl.update_bond()
    netctl.interface = parse.find_in_file(
      "/proc/net/bonding/bond0",
      "Currently Active Slave: (.*)"
    ) or 'bndng.err'
    if netctl.interface == netctl.eth_if then
      netctl.update_widget('ethernet')
    elseif netctl.interface == netctl.wlan_if then
      netctl.wpa_update()
    elseif netctl.interface == "None" then
      netctl.update_widget("bndng...")
    else
      netctl.update_widget(netctl.interface)
    end
  end

  function netctl.wpa_update()
    awful.util.spawn_with_line_callback(
      "sudo wpa_cli status",
      function(str)
        netctl.update_widget(
          str:match(".*ssid=(.*)\n.*"
          ) or 'wpa...')
      end)
  end

  function netctl.netctl_auto_update()
    awful.util.spawn_with_line_callback(
      'sudo netctl-auto current',
      function(str)
        if #str ~= 0 then
          netctl.interface = netctl.wlan_if
          netctl.update_widget(str:match("^(.*)\n.*"))
        else
          netctl.interface = nil
          netctl.update_widget('nctl-a...')
        end
      end)
  end

  function netctl.netctl_update()
    awful.util.spawn_with_line_callback(
      "systemctl list-unit-files 'netctl@*'",
      function(str)
        netctl.update_widget(
          str:match("netctl@(.*)%.service.*enabled"
          ) or 'nctl...')
      end)
  end

  function netctl.update_widget(network_name)
    netctl.widget:set_text(network_name)
    if netctl.interface == netctl.eth_if then
      netctl.widget:set_image(beautiful.widget_net_wired)
    elseif netctl.interface == netctl.wlan_if then
      netctl.widget:set_icon('net_wifi')
    else
      netctl.widget:set_image(beautiful.widget_net_searching)
    end
  end

  newinterval(update_interval, netctl.update)

  return setmetatable(
    netctl,
    { __index = netctl.widget })
end

return setmetatable(
  netctl,
  { __call = function(_, ...)
    return worker(...)
  end }
)
