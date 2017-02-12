pcall(function() jit.on() end)

--[[
OH HI
--]]

-- localization
os.setlocale(os.getenv("LANG"))
local editor = "vim"
require("awful.hotkeys_popup.keys.vim")

local xresources = require("beautiful.xresources")
local awful = require("awful")
require("awful.autofocus")
awful.titlebar.enable_tooltip = false

local debug = require("utils.debug")

local colorscheme = xresources.get_current_theme()

local terminal = 'st'

--@TODO: make a PR with `-b` feature to `xst`
local function st_color_line(theme_table)
  local colors = {}
  for k, v in pairs(theme_table) do
    table.insert(colors, (
      k:match("color(.*)") or
      (k=='background' and "257") or
      (k=='foreground' and "256")
    ).."="..v)
  end
  return table.concat(colors, ",")
end
--local terminal = 'st -b "' .. st_color_line(colorscheme) ..
  --'" -f "'..'Monospace'..':pixelsize='..tostring(xresources.apply_dpi(13))..'" '


-- GLOBALS:
nlog = debug.nlog
log = debug.log

context = {

  DEVEL_DYNAMIC_LAYOUTS = true,
  --DEVEL_DYNAMIC_LAYOUTS = false,

  modkey = "Mod4",
  altkey = "Mod1",

  theme_dir = awful.util.getdir("config") .. "/themes/lcars-xresources-hidpi/theme.lua",
  --theme_dir = awful.util.getdir("config") .. "/themes/gtk/theme.lua",
  --theme_dir = awful.util.getdir("config") .. "/themes/twmish/theme.lua",

  config = {
    net_preset = 'netctl-auto',
    wlan_if = 'wlp12s0',
    eth_if = 'enp0s25',
    music_players = { 'spotify', 'clementine' },
  },

  cmds = {
    terminal = terminal,
    editor_cmd = terminal .. " -e " .. editor,
    compositor = "killall compton; compton",
    file_manager = "nautilus",
    tmux = terminal .. " -e bash \\-c tmux",
    tmux_run   = terminal .. " -e tmux new-session ",
    scrot_preview_cmd = [['mv $f ~/images/ && viewnior ~/images/$f']],
  },

  autorun = {},
  widgets = {},
  menu = {},

  have_battery = true,
  new_top = true,
  sensor = "Core 0",

  apw_on_the_left = false,

}

local local_settings_result, local_settings_details = pcall(function()
  context = require("config.local").init(context) or context
end)
if local_settings_result ~= true then
  nlog("!!!WARNING: local settings not found")
  print(local_settings_details)
end

local persistent = require("actionless.persistent")

local beautiful	= require("beautiful")
beautiful.init(context.theme_dir)

if context.before_config_loaded then
  context.before_config_loaded()
end
local config = require("config")
config.notify.init(context)
config.autorun.init(context)
config.menus.init(context)
config.layouts.init(context)
config.widgets.init(context)
config.toolbar_horizontal.init(context)
config.keys.init(context)
config.signals.init(context)
if persistent.lcarslist.get() then
  config.toolbar_vertical.init(context)
  config.lcars_layout.init(context)
end
config.rules.init(context)
require("hotkeys")
if context.after_config_loaded then
  context.after_config_loaded()
end

local helpers = require('actionless.helpers')
local wlppr = require('actionless.wlppr')
helpers.newinterval(701, wlppr.load_new, true)
--helpers.newinterval(500, change_wallpaper)
--helpers.newinterval(300, change_wallpaper_best)

local ucolor = require("utils.color")

local inverted_colorscheme = awful.util.table.clone(colorscheme)
inverted_colorscheme.background, inverted_colorscheme.foreground =
  inverted_colorscheme.foreground, inverted_colorscheme.background
local is_dark_bg = ucolor.is_dark(inverted_colorscheme.background)
for i=0,15 do
  inverted_colorscheme["color"..tostring(i)] = ucolor.darker(
    inverted_colorscheme["color"..tostring(i)], is_dark_bg and -40 or 40
  )
end
context.cmds.terminal_light = 'st -b "' .. st_color_line(inverted_colorscheme)
  .. '" -f "'..'Monospace'..':pixelsize='..tostring(xresources.apply_dpi(13))..'" '
context.cmds.tmux_light = context.cmds.terminal_light .. " -e tmux"

-- vim: set shiftwidth=2:
