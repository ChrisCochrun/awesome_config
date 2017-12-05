local gears = require("gears")
local awful = require("awful")
local xresources = require("beautiful.xresources")
local theme_assets = require("beautiful.theme_assets")
local dpi = xresources.apply_dpi
local create_theme = require("actionless.common_theme").create_theme
local color_utils = require("actionless.util").color
local gtk_util = require("actionless.util.gtk")


local theme_name = "gtk"
local gsc = gtk_util.get_theme_variables()

local MAIN_COLOR = gsc.selected_bg_color

local theme_dir = awful.util.getdir("config").."/themes/"..theme_name
--local theme = dofile("/usr/share/awesome/themes/xresources/theme.lua")
local theme = {}

theme.gtk = gsc
theme.xrdb = xresources.get_current_theme()

theme.fg = gsc.fg_color
theme.fg_normal = gsc.fg_color
theme.bg = gsc.bg_color
theme.bg_normal = gsc.bg_color
theme.fg_focus = gsc.selected_fg_color
theme.bg_focus = gsc.selected_bg_color

theme.panel_fg = gsc.menubar_fg_color
theme.panel_bg = gsc.menubar_bg_color

theme.panel_widget_bg = gsc.base_color
theme.panel_widget_fg = gsc.text_color

local gtk_border_radius = gsc.border_radius
local gtk_border_width = gsc.border_width
if gtk_border_width < 1 then
  gtk_border_width = 1
end
theme.border_radius = dpi(gtk_border_radius*1.0)
theme.panel_widget_border_radius = dpi(gtk_border_radius*0.8)
--theme.panel_widget_border_radius = dpi(gtk_border_radius*1.0)
--theme.border_radius = dpi(5)
--theme.panel_widget_border_radius = dpi(5)
theme.panel_widget_border_width = dpi(gtk_border_width)
theme.panel_widget_border_width = dpi(gtk_border_width*2)
--theme.panel_widget_border_color = color_utils.mix(gsc.menubar_fg_color, gsc.menubar_bg_color, 0.5)
theme.panel_widget_border_color = color_utils.mix(gsc.menubar_fg_color, gsc.menubar_bg_color, 0.3)


theme.widget_close_bg = gsc.header_button_bg_color
theme.widget_close_fg = gsc.header_button_fg_color

theme.tasklist_fg_focus = theme.panel_fg
theme.tasklist_fg_normal = theme.panel_fg
theme.tasklist_bg_focus = theme.panel_bg
theme.tasklist_bg_normal = theme.panel_bg
theme.tasklist_fg_minimize	= theme.xrdb.background
theme.tasklist_bg_minimize	= theme.xrdb.color4

theme.dir = theme_dir
theme.icons_dir = theme.dir .. "/icons/"

--theme.error = theme.xrdb.color1
--theme.warning = theme.xrdb.color2


-- TERMINAL COLORSCHEME:
--
theme.color = xresources.get_current_theme()

-- PANEL COLORS:
--
theme.panel_taglist = gsc.base_color
theme.panel_close = MAIN_COLOR
--theme.panel_tasklist = gsc.menubar_bg_color
theme.panel_media = MAIN_COLOR
theme.panel_info = theme.xrdb.color13
theme.panel_layoutbox = theme.xrdb.color7
--theme.widget_layoutbox_bg = theme.panel_layoutbox
--theme.widget_layoutbox_fg = theme.panel_widget_fg

-- WALLPAPER:
-- Use nitrogen:
theme.wallpaper = nil
theme.wallpaper_cmd     = "nitrogen --restore"
-- Use wallpaper tile:
--theme.wallpaper = theme_dir .. '/umbreon_pattern.png'

-- PANEL DECORATIONS:
--
theme.show_widget_icon = false

theme.revelation_fg = theme.xrdb.color13
theme.revelation_border_color = theme.xrdb.color13
theme.revelation_bg = theme.panel_bg
theme.revelation_font = "Monospace Bold 24"
-- FONTS:
theme.font = "Monospace Bold 10"
--theme.font = "Sans Bold 10"
theme.tasklist_font = theme.font
theme.small_font = "Monospace 7"
theme.sans_font = "Sans Bold 10"
-- Don't use sans font:
--theme.sans_font	= "theme.font"

--
--MISC:
--

theme.basic_panel_height = dpi(18)
theme.panel_padding_bottom = dpi(3)

--theme.border_width = dpi(3)
--theme.useless_gap = dpi(6)

--theme.border_width = dpi(4)
--theme.useless_gap = dpi(5)

--theme.border_width = dpi(5)
--theme.useless_gap = dpi(4)

--theme.border_width = dpi(4)
theme.useless_gap = dpi(4)

theme.border_width = dpi(gtk_border_width) * 4

theme.base_border_width = theme.border_width
theme.border_width = 0

theme.panel_height = theme.basic_panel_height + theme.panel_padding_bottom
theme.titlebar_height = theme.basic_panel_height + theme.base_border_width*2


theme.left_panel_internal_corner_radius = dpi(30)

theme.left_panel_width = dpi(120)
theme.left_widget_min_height = dpi(120)

theme.menu_height		= dpi(16)
theme.menu_width		= dpi(150)
theme.menu_border_color = theme.xrdb.color1


theme.apw_fg_color = MAIN_COLOR
theme.apw_fg_color = gsc.selected_bg_color
--theme.apw_bg_color = color_utils.darker(gsc.menubar_bg_color, 40)
theme.apw_bg_color = gsc.base_color
theme.apw_mute_bg_color = "theme.xrdb.color1"
theme.apw_mute_fg_color = "theme.xrdb.color9"


--theme.taglist_squares_sel       = "theme.null"
--theme.taglist_squares_unsel     = "theme.null"
--theme.taglist_fg_focus		= "theme.theme"
theme.taglist_fg_focus		= gsc.selected_fg_color
theme.taglist_bg_focus		= gsc.selected_bg_color
--theme.taglist_bg_focus		= {
        --type  = "linear" ,
        --from  = { 0, 0, },
        --to    = { 0, theme.panel_height, },
        --stops = {
            --{ 0, gsc.selected_bg_color },
            --{ 0.49, color_utils.darker(gsc.selected_bg_color, -20)..88 },
            --{ 1, gsc.selected_bg_color },
        --}
    --}
theme.taglist_fg_occupied	= gsc.text_color
theme.taglist_bg_occupied	= gsc.base_color

theme.taglist_fg_occupied = gsc.header_button_fg_color
theme.taglist_bg_occupied = gsc.header_button_bg_color


theme.border_normal = gsc.menubar_bg_color
theme.border_focus = gsc.wm_border_focused_color
theme.titlebar_border = gsc.menubar_bg_color
theme.titlebar_fg_normal	= color_utils.mix(gsc.menubar_fg_color, gsc.menubar_bg_color)
theme.titlebar_bg_normal	= "theme.titlebar_border"
theme.notification_border_radius = "theme.border_radius"

if theme.border_radius > 0 then
  local rounded_rect_shape = function(cr,w,h)
    gears.shape.rounded_rect(
      cr, w, h, theme.notification_border_radius
    )
  end
  local less_rounded_rect_shape = function(cr,w,h)
    gears.shape.rounded_rect(
      cr, w, h, theme.panel_widget_border_radius
    )
  end
  theme.titlebar_fg_focus		= gsc.menubar_fg_color
  theme.titlebar_bg_focus		= "theme.titlebar_bg_normal"
  theme.notification_shape = rounded_rect_shape
  theme.tasklist_shape_minimized = less_rounded_rect_shape
else
  --theme.titlebar_fg_focus		= theme.titlebar_border
  --theme.titlebar_bg_focus		= theme.bg_focus
  --theme.titlebar_fg_focus		= gsc.selected_fg_color
  theme.titlebar_bg_focus		= gsc.wm_border_focused_color
  theme.notification_shape = nil
end

theme.panel_widget_spacing = dpi(10)
theme.panel_widget_spacing_medium = dpi(8)
theme.panel_widget_spacing_small = dpi(4)

theme.panel_widget_bg_error = theme.xrdb.color1
theme.panel_widget_fg_error = theme.xrdb.color15

--theme.widget_music_bg = color_utils.mix(MAIN_COLOR, gsc.menubar_fg_color, 0.6)
--theme.widget_music_bg = MAIN_COLOR
theme.widget_music_bg = "theme.border_focus"
--


theme = create_theme({ theme_name=theme_name, theme=theme, })


-- Recolor titlebar icons:
theme = theme_assets.recolor_layout(theme, theme.panel_fg)
theme = theme_assets.recolor_titlebar_normal(theme, theme.titlebar_fg_normal)
theme = theme_assets.recolor_titlebar_focus(theme, theme.titlebar_fg_focus)

if color_utils.is_dark(theme.panel_bg) then
  theme.clock_fg = color_utils.darker(theme.panel_fg, -16)
  --theme.tasklist_fg_focus = color_utils.darker(theme.xrdb.foreground, 12)
else
  theme.clock_fg = color_utils.darker(theme.panel_fg, 16)
end

if awesome.composite_manager_running then
  theme.border = theme.border .."dd"
  theme.border_normal       = theme.border_normal .."dd"
  theme.border_focus        = theme.border_focus .."dd"
  theme.titlebar_bg_normal  = theme.titlebar_bg_normal.."dd"
  theme.titlebar_bg_focus   = theme.titlebar_bg_focus.."dd"
end

theme.actionless_titlebar_bg_normal = theme.titlebar_bg_normal
if theme.border_radius > 0 then
  theme.actionless_titlebar_bg_focus  = theme.border_focus
else
  theme.actionless_titlebar_bg_focus  = theme.gtk.wm_border_focused_color
end

return theme
