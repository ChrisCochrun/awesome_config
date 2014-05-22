
local awful = require("awful")
local wibox = require("wibox")
local menubar = require("menubar")
local capi = { screen = screen,
               client = client,
               mouse = mouse }

local widgets = require("actionless.widgets")
local helpers = require("actionless.helpers")
local bars = require("actionless.bars")
local menu_addon = require("actionless.menu_addon")


local keys = {}


function keys.init(status)

local modkey = "Mod4"
local altkey = "Mod1"

local cmd = status.cmds

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
	awful.button({ }, 3, function () mymainmenu:toggle() end),
	awful.button({ }, 5, awful.tag.viewnext),
	awful.button({ }, 4, awful.tag.viewprev)
))
-- }}}
-- {{{ Key bindings
local globalkeys = awful.util.table.join(

	awful.key({ modkey,	"Control"	}, "t",
		function() systray_toggle.toggle() end),
	awful.key({ modkey,	"Control"	}, "s",
		function() run_once("xscreensaver-command -lock") end),

	awful.key({ modkey,				}, ",",
                function()
                  awful.tag.viewprev(helpers.get_current_screen())
                end),
	awful.key({ modkey,				}, ".",
                function()
                  awful.tag.viewnext(helpers.get_current_screen())
                end),
	awful.key({ modkey,				}, "Escape",
		awful.tag.history.restore),

	-- By direction screen focus
	awful.key({ modkey,				}, "Next",
		function()
			awful.screen.focus_relative(1)
		end),
	awful.key({ modkey,				}, "Prior",
		function()
			awful.screen.focus_relative(-1)
		end),

	-- By direction client focus
	awful.key({ modkey,				}, "Down",
		function()
			awful.client.focus.bydirection("down")
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey				}, "Up",
		function()
			awful.client.focus.bydirection("up")
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey				}, "Left",
		function()
			awful.client.focus.bydirection("left")
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey				}, "Right",
		function()
			awful.client.focus.bydirection("right")
			if client.focus then client.focus:raise() end
		end),

	-- By direction client swap
	awful.key({ modkey,	"Shift"		}, "Down",
		function()
			awful.client.swap.bydirection("down")
			if client.swap then client.swap:raise() end
		end),
	awful.key({ modkey,	"Shift"		}, "Up",
		function()
			awful.client.swap.bydirection("up")
			if client.swap then client.swap:raise() end
		end),
	awful.key({ modkey,	"Shift"		}, "Left",
		function()
			awful.client.swap.bydirection("left")
			if client.swap then client.swap:raise() end
		end),
	awful.key({ modkey,	"Shift"		}, "Right",
		function()
			awful.client.swap.bydirection("right")
			if client.swap then client.swap:raise() end
		end),

	-- Client resize
	awful.key({ modkey, "Control"	}, "Right",	
		function () awful.tag.incmwfact( 0.05) end),
	awful.key({ modkey,	"Control"	}, "Left",
		function () awful.tag.incmwfact(-0.05) end),
	awful.key({ modkey, "Control"	}, "Down",
		function () awful.client.incwfact(-0.05) end),
	awful.key({ modkey, "Control"	}, "Up",
		function () awful.client.incwfact( 0.05) end),

	-- Layout tuning
	awful.key({ modkey, altkey }, "Left",
		function () awful.tag.incnmaster(-1) end),
	awful.key({ modkey, altkey }, "Right",
		function () awful.tag.incnmaster( 1) end),
	awful.key({ modkey, altkey }, "Down",
		function () awful.tag.incncol(-1) end),
	awful.key({ modkey, altkey }, "Up",
		function () awful.tag.incncol( 1) end),

	-- By direction client focus (VIM style)
	awful.key({ modkey }, "j",
		function()
			awful.client.focus.bydirection("down")
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey }, "k",
		function()
			awful.client.focus.bydirection("up")
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey }, "h",
		function()
			awful.client.focus.bydirection("left")
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey }, "l",
		function()
			awful.client.focus.bydirection("right")
			if client.focus then client.focus:raise() end
		end),

	-- By direction client swap (VIM style)
	awful.key({ modkey, "Shift" }, "j",
		function()
			awful.client.swap.bydirection("down")
			if client.swap then client.swap:raise() end
		end),
	awful.key({ modkey, "Shift" }, "k",
		function()
			awful.client.swap.bydirection("up")
			if client.swap then client.swap:raise() end
		end),
	awful.key({ modkey, "Shift" }, "h",
		function()
			awful.client.swap.bydirection("left")
			if client.swap then client.swap:raise() end
		end),
	awful.key({ modkey, "Shift" }, "l",
		function()
			awful.client.swap.bydirection("right")
			if client.swap then client.swap:raise() end
		end),

	-- Client resize (VIM style)
	awful.key({ modkey, "Control" }, "l",
		function () awful.tag.incmwfact( 0.05) end),
	awful.key({ modkey,	"Control" }, "h",
		function () awful.tag.incmwfact(-0.05) end),
	awful.key({ modkey, "Control" }, "j",
		function () awful.client.incwfact(-0.05) end),
	awful.key({ modkey, "Control" }, "k",
		function () awful.client.incwfact( 0.05) end),

	-- Layout tuning (VIM style)
	awful.key({ modkey, altkey }, "h",
		function () awful.tag.incnmaster(-1) end),
	awful.key({ modkey, altkey }, "l",
		function () awful.tag.incnmaster( 1) end),
	awful.key({ modkey, altkey }, "j",
		function () awful.tag.incncol(-1) end),
	awful.key({ modkey, altkey }, "k",
		function () awful.tag.incncol( 1) end),


	-- Menus
	awful.key({ modkey,		   }, "w",
		function () mymainmenu:show() end),
	awful.key({ modkey,		   }, "i",
		function ()
			instance = menu_addon.clients_on_tag({
				theme = {width=capi.screen[mouse.screen].workarea.width},
				coords = {x=0, y=18}})
		end),
	awful.key({ modkey,		   }, "p",
		function ()
			instance = awful.menu.clients({
					theme = {width=capi.screen[mouse.screen].workarea.width},
					coords = {x=0, y=18}})
		end),
	awful.key({ modkey, "Control"}, "p",
		function() menubar.show() end),
	--awful.key({ modkey,        }, "space",
	--	function() menubar.show() end),
	awful.key({ modkey,        }, "space",
		function() awful.util.spawn_with_shell(cmd.dmenu) end),

	-- Layout manipulation
	awful.key({ modkey, "Control"	}, "n",
		awful.client.restore),

	awful.key({ modkey,				}, "u",
		awful.client.urgent.jumpto),
	awful.key({ modkey,				}, "Tab",
		function ()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end),

	awful.key({ altkey,				}, "space",
		function () awful.layout.inc(layouts, 1) end),
	awful.key({ altkey, "Shift"		}, "space",
		function () awful.layout.inc(layouts, -1) end),


	-- Prompt
	awful.key({ modkey }, "r",
		function () mypromptbox[mouse.screen]:run() end),
	awful.key({ modkey }, "x",
		function ()
			awful.prompt.run({ prompt = "Run Lua code: " },
			mypromptbox[mouse.screen].widget,
			awful.util.eval, nil,
			awful.util.getdir("cache") .. "/history_eval")
		end),

	-- ALSA volume control
	awful.key({}, "#123", function () volumewidget.up() end),
	awful.key({}, "#122", function () volumewidget.down() end),
	awful.key({}, "#121", function () volumewidget.toggle() end),
	awful.key({}, "#198", function () volumewidget.toggle_mic() end),

	-- MPD control
	awful.key({}, "#150", function () mpdwidget.prev_song() end),
	awful.key({}, "#148", function () mpdwidget.next_song() end),
	awful.key({}, "#172", function () mpdwidget.toggle() end),

	-- Copy to clipboard
	awful.key({ modkey }, "c",
		function () os.execute("xsel -p -o | xsel -i -b") end),

	-- Standard program
	awful.key({ modkey,				}, "Return",
		function () awful.util.spawn(cmd.tmux) end),
	awful.key({ modkey,				}, "s",
		function () awful.util.spawn(cmd.file_manager) end),
	awful.key({ modkey, "Control"	}, "c",
		function () awful.util.spawn_with_shell(cmd.chromium) end),
	awful.key({ modkey, "Control"	}, "g",
		function () awful.util.spawn_with_shell(cmd.chrome) end),
	awful.key({ modkey, "Control"	}, "f",
		function () awful.util.spawn_with_shell(cmd.firefox) end),

	awful.key({ modkey, "Control"	}, "r",
		awesome.restart),
	awful.key({ modkey, "Shift"		}, "q",
		awesome.quit),

	-- Scrot stuff
	awful.key({ "Control"			}, "Print", 
		function ()
			awful.util.spawn_with_shell(
			"scrot -ub '%Y-%m-%d--%s_$wx$h_scrot.png' -e " .. cmd.scrot_preview_cmd)
		end),
	awful.key({ altkey				}, "Print",
		function ()
			awful.util.spawn_with_shell(
			"scrot -s '%Y-%m-%d--%s_$wx$h_scrot.png' -e " .. cmd.scrot_preview_cmd)
		end),
	awful.key({						}, "Print",
		function ()
			awful.util.spawn_with_shell(
			"scrot '%Y-%m-%d--%s_$wx$h_scrot.png' -e " .. cmd.scrot_preview_cmd)
		end)

)

status.clientkeys = awful.util.table.join(
	awful.key({ modkey,				}, "f",
		function (c) c.fullscreen = not c.fullscreen end),
	awful.key({ modkey,				}, "q",
		function (c) c:kill() end),
	awful.key({ modkey, "Control"	}, "space",
		awful.client.floating.toggle),
	awful.key({ modkey, "Control"	}, "Return",
		function (c) c:swap(awful.client.getmaster()) end),
	awful.key({ modkey,				}, "o",
		awful.client.movetoscreen),
	awful.key({ modkey,				}, "t",
		function (c) c.ontop = not c.ontop end),
	awful.key({ modkey, "Shift"		}, "t",
		bars.titlebar_toggle),
	awful.key({ modkey,				}, "n",
		function (c) c.minimized = true end),
	awful.key({ modkey,				}, "m",
		function (c)
			c.maximized_horizontal = not c.maximized_horizontal
			c.maximized_vertical   = not c.maximized_vertical
		end)
)

for screen = 1, 2 do
  for i = 1, 12 do

	if screen == 1 then
		-- num keys:
		diff = 9
	elseif screen == 2 then
		-- f-keys:
		if i>10 then
			diff = 84
		else
			diff = 66
		end
	end

	globalkeys = awful.util.table.join(globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + diff,
			function ()
				local tag = awful.tag.gettags(screen)[i]
				if tag then awful.tag.viewonly(tag) end
			  end),
		-- Toggle tag.
		awful.key({ modkey, "Control" }, "#" .. i + diff,
			function ()
				local tag = awful.tag.gettags(screen)[i]
				if tag then awful.tag.viewtoggle(tag) end
			end),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + diff,
			function ()
				if client.focus then
					local tag = awful.tag.gettags(screen)[i]
					if tag then awful.client.movetotag(tag) end
				 end
			end),
		-- Toggle tag.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + diff,
			function ()
				if client.focus then
					local tag = awful.tag.gettags(screen)[i]
					if tag then awful.client.toggletag(tag) end
				end
			end))
  end
end

status.clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}


end
return keys
