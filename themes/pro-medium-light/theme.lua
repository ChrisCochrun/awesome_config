--[[
imported from here: https://github.com/barwinco/pro
]]--

local create_theme = require("actionless.common_theme").create_theme
local xresources = require("actionless.xresources")
local dpi = xresources.compute_fontsize

local awful = require("awful")
local theme_dir = awful.util.getdir("config").."/themes/pro-medium-light"

local gtk = {}
gtk.bg = "#B8B8B8"
gtk.fg = "#202020"
gtk.base = "#888888"
gtk.select = "#6d3f68"

local main_theme_color = "#34a890"

local red_light = "#f1cbfb"
local green_light = "#cbf1fb"
local blue_light = "#cbfbf1"

-- GENERATE DEFAULT THEME:
--
local theme = {}

-- TERMINAL COLORSCHEME:
--
local color = xresources.get_current_theme()
color.bg    = gtk.bg
color.fg    = gtk.fg
theme.color = color

theme.fg      = gtk.fg
theme.bg      = gtk.bg
theme.alt_bg  = gtk.base
theme.theme   = gtk.select
theme.warning = "theme.color.2"
theme.error   = "theme.color.1"

theme.border_width              = "6"
theme.border_focus              = main_theme_color
theme.titlebar_focus_border     = "theme.border_focus"

theme.panel_opacity = 1
theme.panel_enbolden_details	= true

theme.widget_close_left_decorators = { 'arrl', 'sq', 'sq' }
theme.widget_close_right_decorators = { 'sq', 'sq', 'arrr', }

-- PANEL COLORS:
--
theme.panel_taglist="theme.bg"
theme.panel_close="theme.bg"
theme.panel_tasklist="theme.null"
theme.panel_media="theme.bg"
theme.panel_info="theme.bg"
theme.panel_layoutbox="theme.bg"

theme.panel_widget_fg_warning	= green_light
theme.panel_widget_fg_error	= red_light
theme.panel_widget_fg = gtk.fg
theme.panel_widget_bg = gtk.bg

theme.fg_urgent		= red_light

theme.taglist_fg_occupied	= gtk.fg
theme.taglist_fg_empty		= gtk.fg
theme.taglist_fg_focus		= blue_light
--theme.taglist_fg_focus		= gtk.fg
--theme.taglist_bg_focus		= theme.border_focus

theme.tasklist_fg_focus		= gtk.fg
theme.tasklist_fg_minimize	= gtk.fg
theme.tasklist_bg_minimize	= gtk.base

theme.titlebar_fg_focus         = "theme.tasklist_fg_focus"
theme.titlebar_fg_normal        = gtk.fg

theme.notification_bg = gtk.fg
theme.notification_fg = gtk.bg

theme.player_artist = gtk.select
theme.player_title = gtk.fg

theme.hotkeys_widget_fg = "theme.fg"

-- CUSTOMIZE default theme:-----------------------------------------------

-- WALLPAPER:
-- Use nitrogen:
--theme.wallpaper_cmd     = "nitrogen --restore"
-- Use wallpaper tile:
theme.wallpaper = theme_dir .. '/pro-medium-light-shadow.png'
theme.wallpaper_layout = "centered"

-- PANEL DECORATIONS:
--
theme.widget_decoration_arrl = 'sq'
theme.widget_decoration_arrr = 'sq'

theme.widget_decoration_image_arrl = theme_dir .. '/icons/common/decoration_l.png'
theme.widget_decoration_image_arrl_warning = theme_dir .. '/icons/common/decoration_l_warn.png'
theme.widget_decoration_image_arrl_error = theme_dir .. '/icons/common/decoration_l_err.png'

theme.widget_decoration_image_arrr = theme_dir .. '/icons/common/decoration_r.png'
theme.widget_decoration_image_arrr_warning = theme_dir .. '/icons/common/decoration_r_warn.png'
theme.widget_decoration_image_arrr_error = theme_dir .. '/icons/common/decoration_r_err.png'

theme.widget_decoration_image_sq = theme_dir .. '/icons/common/decoration_sq.png'
theme.widget_decoration_image_sq_warning = theme_dir .. '/icons/common/decoration_sq_warn.png'
theme.widget_decoration_image_sq_error = theme_dir .. '/icons/common/decoration_sq_err.png'

theme.widget_decoration_image_bg = theme_dir .. '/icons/common/decoration_bg.png'
theme.widget_decoration_image_bg_warning = theme_dir .. '/icons/common/decoration_bg_warn.png'
theme.widget_decoration_image_bg_error = theme_dir .. '/icons/common/decoration_bg_err.png'

local common_icons_dir = theme_dir .. '/icons/common/'
  theme.taglist_squares_sel_empty	= common_icons_dir .. "square_empty.png"
  theme.taglist_squares_unsel_empty	= common_icons_dir .. "square_empty.png"

--theme.widget_decoration_arrl = ''
--theme.widget_decoration_arrr = ''

  theme.titlebar_height		= 24
theme.panel_height		= 22
theme.panel_padding_bottom	= 0

theme.show_widget_icon = true
------------------------------------------------------------------------------
-- FONTS:
--Ubuntu patches:
--theme.font = "Monospace 10.5"
--theme.sans_font = "Sans 10.3"
--theme.tasklist_font = "Sans Bold 10.3"

theme.font = "Monospace Bold " .. tostring(dpi(8))
theme.sans_font = "Sans Bold " .. tostring(dpi(8))
-- Don't use sans font:
--theme.sans_font	= theme.font
--

return create_theme({
  theme=theme, theme_dir=theme_dir
})
