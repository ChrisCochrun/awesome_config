local generate_theme = require("actionless.common_theme").generate_theme

local awful = require("awful")
local theme_dir = awful.util.getdir("config").."/themes/pokemon_light"

-- TERMINAL COLORSCHEME:
--
local color = {}
--black
color["0"] = '#000000'
color["8"] = '#465457'
--red
color["1"] = '#b60050'
color["9"] = '#F92672'
--green
color["2"] = '#008877'
color["10"] = '#86c22e'
--yellow
color["3"] = '#fc882b'
color["11"] = '#ffea32'
--blue
color["4"] = '#ad7fa8'
color["12"] = '#ad5fc8'
--purple
color["5"] = '#890089'
color["13"] = '#e733b4'
--cyan
color["6"] = '#00a685'
color["14"] = '#51bd8c'
--white
color["7"] = '#888a85'
color["15"] = '#ffffff'

color.bg  = '#ffffff'
color.fg  = '#1a1a1a'
color.c  = '#ae81ff'


-- GENERATE DEFAULT THEME:
--
local theme = generate_theme(
  theme_dir
)

-- CUSTOMIZE default theme:-----------------------------------------------

theme.color = color

-- WALLPAPER:
--
-- Use plain color:
--theme.wallpaper_cmd     = "hsetroot"
-- Use nitrogen:
--theme.wallpaper_cmd     = "nitrogen --restore"
-- Use wallpaper tile:
theme.wallpaper = theme_dir .. '/pattern.png'

-- PANEL DECORATIONS:
--
theme.widget_decoration_arrl = 'sq'
theme.widget_decoration_arrr = 'sq'
theme.show_widget_icon = true

-- FONTS:
--
--theme.font = "Source Code Pro Bold 10.5"
--theme.sans_font = "Source Sans Pro Bold 10.3"
--
--theme.font = "Meslo LG S for Lcarsline Bold 10.5"
--theme.sans_font = "PT Sans Bold 10.3"
--
-- use ~/.fonts.conf, Luke ;)
theme.font = "Monospace Bold 10.5"
theme.sans_font = "Sans Bold 10.3"
--
-- Don't use sans font:
--theme.sans_font	= theme.font


theme = require("actionless.common_theme").fill_theme(theme)
return theme
