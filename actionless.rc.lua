-- localization
os.setlocale(os.getenv("LANG"))

require("eminent")
local awful = require("awful")
require("awful.autofocus")
local naughty = require("naughty")
local beautiful	= require("beautiful")
local theme_dir = awful.util.getdir("config") .. "/themes/actionless/theme.lua"
beautiful.init(theme_dir)

local config = require("config")
local status = {}
config.notify.init(status)
config.variables.init(status)
config.autorun.init(status)
config.layouts.init(status)
config.menus.init(status)
config.toolbar.init(status)
config.keys.init(status)
config.rules.init(status)
config.signals.init(status)
