-- "dynamic" tagging
require("eminent")
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Notification library
local naughty = require("naughty")
menubar = require("menubar")
-- awesome std c library
local capi = { screen = screen }

-- my own widgets
local widgets	= require("actionless.widgets")
local settings	= require("actionless.settings")
local helpers	= require("actionless.helpers")
local beautiful	= helpers.beautiful

local config	= require("config")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({ preset = naughty.config.presets.critical,
	                 title = "Oops, there were errors during startup!",
	                 text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function (err)
		-- Make sure we don't go into an endless error loop
		if in_error then return end
		in_error = true

		naughty.notify({ preset = naughty.config.presets.critical,
		                 title = "Oops, an error happened!",
		                 text = err })
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
naughty.config.presets.normal.opacity = beautiful.notification_opacity
naughty.config.presets.low.opacity = beautiful.notification_opacity
naughty.config.presets.critical.opacity = beautiful.notification_opacity

naughty.config.presets.normal.font = beautiful.notification_font
naughty.config.presets.low.font = beautiful.notification_font
naughty.config.presets.critical.font = beautiful.notification_font
-- localization
os.setlocale(os.getenv("LANG"))
-- common
modkey	 = "Mod4"
altkey	 = "Mod1"
--terminal = "urxvtc" or "xterm"
terminal = "st" or "urxvt -lsp 1 -geometry 120x30" or "xterm"
--terminal = "dwt -b" or "xterm"
editor	 = "vim" or os.getenv("EDITOR") or "nano" or "vi"
editor_cmd = terminal .. " -e " .. editor

-- user defined
--browser	= "dwb"
chromium   = "GTK2_RC_FILES=~/.gtkrc-2.0.browsers chromium --enable-user-stylesheet"
chrome   = "GTK2_RC_FILES=~/.gtkrc-2.0.browsers google-chrome --enable-user-stylesheet"
firefox	= "firefox -P actionless "
gui_editor = "/opt/sublime_text/sublime_text"
compositor = "compton --xrender-sync --xrender-sync-fence"
graphics   = "pinta"
file_manager = "pcmanfm"
--tmux	   = terminal .. [[ -e "sh -c 'TERM=xterm-256color tmux'" ]]
tmux = terminal .. " -e tmux"
--musicplr   = terminal .. " --geometry=850x466 -e ncmpcpp"
musicplr   = terminal .. " -e ncmpcpp"
tmux_run   = terminal .. " -e tmux new-session"
dmenu = "~/.config/dmenu/dmenu-recent.sh"
scrot_preview_cmd = [['mv $f ~/images/ &amp; viewnior ~/images/$f']]


-- {{{ Autostart applications
function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
	findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

--awful.util.spawn_with_shell("eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)")
--awful.util.spawn_with_shell("/home/lie/.screenlayout/awesome.sh")
awful.util.spawn_with_shell("xset r rate 250 25")
awful.util.spawn_with_shell("xset b off")
run_once(compositor)
run_once("xscreensaver -no-splash")
run_once("unclutter")

run_once("gxkb")
-- }}}

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.floating,
	awful.layout.suit.fair,
	awful.layout.suit.fair.horizontal,
	awful.layout.suit.spiral
}
awful.layout.layouts = layouts
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
	for s = 1, screen.count() do
		gears.wallpaper.tiled(beautiful.wallpaper, s)
	end
else if beautiful.wallpaper_cmd then
		run_once(beautiful.wallpaper_cmd)
end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ '1:bs', '2:web', '3:ww', '4:im', '5:mm', 6, 7, 8, '9:sd', '0:nl' }, s, awful.layout.layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
									{ "kill compositor", "killall compton" },
									{ "start compositor", compositor },
									{ "open terminal", terminal }
								  }
						})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
									 menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

menubar.geometry = {
   height = 18,
   width = capi.screen[1].workarea.width,
   x = 0,
   y = capi.screen[1].workarea.height - 18
}

--require("freedesktop/freedesktop")

config.toolbar.init()
config.keys.init()
config.signals.init()
