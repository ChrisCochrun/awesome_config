theme = {}

themes_dir = os.getenv("HOME") .. "/.config/awesome/themes/noble_dark"
theme.dir = themes_dir
theme.wallpaper= themes_dir .. "/pattern.png"

theme.fg		= "#e6e6e6"
theme.alt_fg		= "#a8a8a8"

theme.bg		= "#3c3c3c"
theme.alt_bg		= "#a562b3"
theme.shiny		= "#ffffff"

theme.theme		= "#ad7fa8"
theme.error		= "#f92672"

theme.border		= "#000000"
theme.sel_border	= "#d33862"
theme.titlebar		= "#3c3c3c"
theme.titlebar_focus	= "#66436C"

theme.font		= "DejaVu Sans Mono 9"
--theme.font		= "Dina 8"
--theme.font		= "Fira Mono 9"
--theme.font		= "Meslo LG S 10"
--theme.font		= "monoOne 10"
--theme.font		= "PT Mono 8"
--theme.font		= "Share Tech Mono 11"
--theme.font		= "Source Code Pro Medium 9.4"
--theme.font		= "tewi 9"

theme.sans_font		= "PT Sans 10"
--theme.sans_font	= "Share Tech 11"
--theme.sans_font	= "Source Sans Pro Regular 10"

theme.fg_normal			= theme.fg
theme.bg_normal			= theme.bg
theme.fg_focus			= theme.fg
theme.bg_focus			= theme.theme
theme.fg_urgent			= theme.bg
theme.bg_urgent			= theme.error

theme.screen_margin		= 0

theme.border_width		= "12"
theme.border_normal		= theme.border
theme.border_focus		= theme.sel_border
theme.border_marked		= theme.error

theme.panel_opacity		= 1.0

theme.taglist_font		= theme.font
theme.taglist_fg_focus		= theme.shiny
theme.taglist_bg_focus		= theme.theme

theme.tasklist_font		= theme.sans_font
theme.tasklist_fg_focus		= theme.fg
theme.tasklist_bg_focus		= theme.bg
theme.tasklist_fg_normal	= theme.fg
theme.tasklist_bg_normal	= theme.bg
theme.tasklist_fg_minimize	= theme.bg
theme.tasklist_bg_minimize	= "#818181"

--theme.titlebar_font		= theme.sans_font
theme.titlebar_font		= "PT Caption Bold 10.5"
--theme.titlebar_font		= "Source Sans Pro Bold 10.5"
theme.titlebar_fg_focus		= theme.shiny
theme.titlebar_fg_normal	= theme.bg
theme.titlebar_bg_focus		= theme.titlebar_focus
theme.titlebar_bg_normal	= theme.titlebar

theme.notification_opacity	= 0.8
theme.notification_font		= theme.sans_font
theme.notification_monofont	= theme.font
theme.notify_fg			= theme.fg_normal
theme.notify_bg			= theme.bg_normal
theme.notify_border		= theme.border_focus

theme.textbox_widget_margin_top	= 1
theme.awful_widget_height	= 14
theme.awful_widget_margin_top	= 2
theme.mouse_finder_color	= theme.error
theme.menu_border_width		= "3"
theme.menu_height		= "16"
theme.menu_width		= "140"

theme.player_text		= "#8d5f88"

-- ICONS

icons_dir = theme.dir .. "/icons/"
theme.icons_dir = icons_dir

theme.taglist_squares_sel	= icons_dir .. "square_sel.png"
theme.taglist_squares_unsel	= icons_dir .. "square_unsel.png"

theme.menu_submenu_icon		= icons_dir .. "submenu.png"
theme.taglist_squares_sel	= icons_dir .. "square_sel.png"
theme.taglist_squares_unsel	= icons_dir .. "square_unsel.png"

theme.arrl			= icons_dir .. "arrl.png"

theme.widget_ac			= icons_dir .. "ac.png"
theme.widget_ac_charging	= icons_dir .. "ac_charging.png"
theme.widget_ac_charging_low	= icons_dir .. "ac_charging_low.png"

theme.widget_battery		= icons_dir .. "battery.png"
theme.widget_battery_low	= icons_dir .. "battery_low.png"
theme.widget_battery_empty	= icons_dir .. "battery_empty.png"

theme.widget_mem		= icons_dir .. "mem.png"
theme.widget_cpu		= icons_dir .. "cpu.png"
theme.widget_temp		= icons_dir .. "temp.png"
theme.widget_net		= icons_dir .. "net.png"
theme.widget_hdd		= icons_dir .. "hdd.png"

theme.widget_net_wireless	= icons_dir .. "net_wireless.png"
theme.widget_net_wired		= icons_dir .. "net_wired.png"
theme.widget_net_searching	= icons_dir .. "net_searching.png"

theme.widget_music		= icons_dir .. "note.png"
theme.widget_music_on		= icons_dir .. "note_on.png"
theme.widget_vol_high		= icons_dir .. "vol_high.png"
theme.widget_vol		= icons_dir .. "vol.png"
theme.widget_vol_low		= icons_dir .. "vol_low.png"
theme.widget_vol_no		= icons_dir .. "vol_no.png"
theme.widget_vol_mute		= icons_dir .. "vol_mute.png"
theme.widget_mail		= icons_dir .. "mail.png"
theme.widget_mail_on		= icons_dir .. "mail_on.png"

theme.dropdown_icon		= icons_dir .. "dropdown.png"

theme.tasklist_disable_icon = true
--theme.tasklist_floating = "*"
--theme.tasklist_maximized_horizontal = "_"
--theme.tasklist_maximized_vertical = "|"

layout_icons_dir = icons_dir .. "layout/"
theme.layout_icons_dir = layout_icons_dir
theme.layout_tile		= layout_icons_dir .. "tile.png"
theme.layout_tilegaps		= layout_icons_dir .. "tilegaps.png"
theme.layout_tileleft		= layout_icons_dir .. "tileleft.png"
theme.layout_tilebottom		= layout_icons_dir .. "tilebottom.png"
theme.layout_tiletop		= layout_icons_dir .. "tiletop.png"
theme.layout_fairv		= layout_icons_dir .. "fairv.png"
theme.layout_fairh		= layout_icons_dir .. "fairh.png"
theme.layout_spiral		= layout_icons_dir .. "spiral.png"
theme.layout_dwindle		= layout_icons_dir .. "dwindle.png"
theme.layout_max		= layout_icons_dir .. "max.png"
theme.layout_fullscreen		= layout_icons_dir .. "fullscreen.png"
theme.layout_magnifier		= layout_icons_dir .. "magnifier.png"
theme.layout_floating		= layout_icons_dir .. "floating.png"

titlebar_icons_dir = icons_dir .. "titlebar/"
theme.titlebar_icons_dir = titlebar_icons_dir
theme.titlebar_close_button_focus = titlebar_icons_dir .. "/close_focus.png"
theme.titlebar_close_button_normal = titlebar_icons_dir .. "/close_normal.png"

theme.titlebar_ontop_button_focus_active = titlebar_icons_dir .. "/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = titlebar_icons_dir .. "/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive = titlebar_icons_dir .. "/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = titlebar_icons_dir .. "/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active = titlebar_icons_dir .. "/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = titlebar_icons_dir .. "/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive = titlebar_icons_dir .. "/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = titlebar_icons_dir .. "/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active = titlebar_icons_dir .. "/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = titlebar_icons_dir .. "/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive = titlebar_icons_dir .. "/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = titlebar_icons_dir .. "/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active = titlebar_icons_dir .. "/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = titlebar_icons_dir .. "/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive = titlebar_icons_dir .. "/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = titlebar_icons_dir .. "/maximized_normal_inactive.png"

theme.titlebar_minimize_button_focus_active = titlebar_icons_dir .. "/minimized_focus.png"
theme.titlebar_minimize_button_normal_active = titlebar_icons_dir .. "/minimized_normal.png"
theme.titlebar_minimize_button_focus_inactive = titlebar_icons_dir .. "/minimized_focus.png"
theme.titlebar_minimize_button_normal_inactive = titlebar_icons_dir .. "/minimized_normal.png"

return theme
