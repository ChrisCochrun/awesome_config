
local awful = require("awful")
local beautiful = require("beautiful")
local menubar = require("actionless.menubar")
local client = client
local capi = {
  screen = screen,
  client = client,
  root = root,
  awesome = awesome,
}

local helpers = require("actionless.helpers")
local titlebar = require("actionless.titlebar")
local menu_addon = require("actionless.menu_addon")
local floats = require("actionless.helpers").client_floats

local hkng = require("awful.hotkeys_popup")


local revelation = require("third_party.revelation")
revelation.fg = beautiful.bg
revelation.font = "Monospace Bold 24"
revelation.init()


local keys = {}
function keys.init(awesome_context)

local modkey = awesome_context.modkey
local altkey = awesome_context.altkey
local cmd = awesome_context.cmds

awful.layout.suit.floating.resize_jump_to_corner = false
awful.layout.suit.tile.resize_jump_to_corner = false

  awesome_context.clientbuttons = awful.util.table.join(
    awful.button({ }, 1,
      function (c)
        client.focus = c;
        c:raise();
      end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
  )

local RESIZE_STEP = beautiful.xresources.apply_dpi(15)

local TO_DEFINE_COLOR = "none"

local TAG_COLOR = "tag"
local CLIENT_COLOR = "client_focus"
local UTILS = "menu"
local IMPORTANT_COLOR = "important"
local CLIENT_MANIPULATION = "client"
local LAYOUT_MANIPULATION = "layout"
local LCARS = "LCARS"

-- {{{ Mouse bindings
capi.root.buttons(awful.util.table.join(
  awful.button({ }, 3, function () awesome_context.menu.mainmenu_toggle() end),
  awful.button({ }, 4, function()
    helpers.tag_view_noempty(-1)
  end),
  awful.button({ }, 5, function()
    helpers.tag_view_noempty(1)
  end)
))
-- }}}

awful.menu.menu_keys.back = { "Left", "h" }
awful.menu.menu_keys.down = { "Down", "j" }
awful.menu.menu_keys.up = { "Up", "k" }
awful.menu.menu_keys.enter = { "Right", "l" }
awful.menu.menu_keys.close = { "Escape", '#133', 'q' }

local bind_key = function(mod, key, press, description, group)
  return awful.key.new(mod, key, press, nil, {description=description, group=group})
end

-- {{{ Key bindings
local globalkeys = awful.util.table.join(

  ----local HELPKEY = "Print"
  --local HELPKEY = "#108" -- Alt Gr
  --bind_key({  }, HELPKEY, "show_help"),
  --bind_key({ "Shift" }, HELPKEY, "show_help"),
  --bind_key({ "Control" }, HELPKEY, "show_help"),
  --bind_key({ altkey }, HELPKEY, "show_help"),
  --bind_key({ modkey, }, HELPKEY, "show_help"),
  --bind_key({ modkey, altkey }, HELPKEY, "show_help"),
  --bind_key({ modkey, altkey, "Shift" }, HELPKEY, "show_help"),
  --bind_key({ modkey, altkey, "Control" }, HELPKEY, "show_help"),
  --bind_key({ modkey, "Shift"    }, HELPKEY, "show_help"),
  --bind_key({ modkey, "Control"  }, HELPKEY, "show_help"),
  --bind_key({ modkey, "Shift", "Control" }, HELPKEY, "show_help"),

  awful.key({modkey}, "/", function()
    hkng.show_help()
  end, nil, {
    description = "show help"
  }),

  -- bind_key({ modkey,  }, "Control", "show_help"), -- show hotkey on hold

  bind_key({ modkey,  altkey  }, "t",
    function() awesome_context.widgets.systray_toggle.toggle() end,
    "toggle systray popup", UTILS
  ),

  bind_key({ modkey,  "Control"  }, "s",
    function() helpers.run_once("xscreensaver-command -lock") end,
    "xscreensaver lock", UTILS
  ),
  bind_key({ modkey,  "Control"  }, "d",
    function() helpers.run_once("sleep 1 && xset dpms force off") end,
    "turn off display", UTILS
  ),


  bind_key({ modkey,        }, ",",
    function()
      helpers.tag_view_noempty(-1)
    end,
    "prev tag", TAG_COLOR
  ),
  bind_key({ modkey,        }, ".",
    function()
      helpers.tag_view_noempty(1)
    end,
    "next tag", TAG_COLOR
  ),
  bind_key({ modkey,        }, "Escape",
    awful.tag.history.restore,
    "cycle tags", TAG_COLOR
  ),
  bind_key({ modkey, altkey }, "r",
    function ()
      local tag = awful.tag.selected(awful.screen.focused())
      if tag then
        awful.prompt.run(
          { prompt = "new tag name: ",
            text = awful.tag.getidx(tag) .. ":" },
          awesome_context.widgets.screen[awful.screen.focused()].promptbox,
          function(new_name)
            if not new_name or #new_name == 0 then
              return
            else
               tag.name = new_name
            end
          end)
      end
    end,
    "Rename tag", TAG_COLOR
  ),

  -- By direction screen focus
  bind_key({ modkey,        }, "Next",
    function() awful.screen.focus_relative(1) end,
    "next screen", TAG_COLOR
  ),
  bind_key({ modkey,        }, "Prior",
    function() awful.screen.focus_relative(-1) end,
    "prev screen", TAG_COLOR
  ),

  -- By direction client focus
  bind_key({ modkey,        }, "Down",
    function()
      awful.client.focus.global_bydirection("down")
      if client.focus then client.focus:raise() end
    end,
    "client focus", CLIENT_COLOR
  ),
  bind_key({ modkey        }, "Up",
    function()
      awful.client.focus.global_bydirection("up")
      if client.focus then client.focus:raise() end
    end,
    "client focus", CLIENT_COLOR
  ),
  bind_key({ modkey        }, "Left",
    function()
      awful.client.focus.global_bydirection("left")
      if client.focus then client.focus:raise() end
    end,
    "client focus", CLIENT_COLOR
  ),
  bind_key({ modkey        }, "Right",
    function()
      awful.client.focus.global_bydirection("right")
      if client.focus then client.focus:raise() end
    end,
    "client focus", CLIENT_COLOR
  ),


  -- By direction client focus (VIM style)
  bind_key({ modkey }, "j",
    function()
      awful.client.focus.global_bydirection("down")
      if client.focus then client.focus:raise() end
    end,
    "client focus", CLIENT_COLOR
  ),
  bind_key({ modkey }, "k",
    function()
      awful.client.focus.global_bydirection("up")
      if client.focus then client.focus:raise() end
    end,
    "client focus", CLIENT_COLOR
  ),
  bind_key({ modkey }, "h",
    function()
      awful.client.focus.global_bydirection("left")
      if client.focus then client.focus:raise() end
    end,
    "client focus", CLIENT_COLOR
  ),
  bind_key({ modkey }, "l",
    function()
      awful.client.focus.global_bydirection("right")
      if client.focus then client.focus:raise() end
    end,
    "client focus", CLIENT_COLOR
  ),


  -- Menus
  bind_key({ modkey,       }, "w",
    function () awesome_context.menu.mainmenu_show(true) end,
    "aWesome menu", UTILS
  ),
  bind_key({ modkey,       }, "i",
    function ()
      awesome_context.menu.instance = menu_addon.clients_on_tag({
        theme = {width=capi.screen[awful.screen.focused()].workarea.width},
        coords = {x=0, y=18}
      })
    end,
    "clients on current tag menu", UTILS
  ),
  bind_key({ modkey,       }, "p",
    function ()
      awesome_context.menu.instance = awful.menu.clients({
        theme = {width=capi.screen[awful.screen.focused()].workarea.width},
        coords = {x=0, y=18}
      })
    end,
    "all clients menu", UTILS
  ),
  bind_key({ modkey, "Control"}, "p",
    --function() awesome_context.menu.menubar:show() end,
    function() menubar.show() end,
    "applications menu", UTILS
  ),
  bind_key({ modkey,        }, "space",
    --function() awful.spawn.with_shell(cmd.dmenu) end,
    function() awesome_context.menu.dmenubar:show() end,
    "app launcher", UTILS
  ),

  bind_key({ modkey, "Control"  }, "n",
    function()
      local c = awful.client.restore()
      -- @TODO: it's a workaround for some strange upstream issue
      if c then client.focus = c end
    end,
    "de-iconify client", TAG_COLOR
  ),

  bind_key({ modkey,        }, "u",
    awful.client.urgent.jumpto,
    "jump to Urgent client", IMPORTANT_COLOR
  ),
  bind_key({ modkey,        }, "Tab",
    function ()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end,
    "cycle clients", CLIENT_COLOR
  ),

  bind_key({ modkey, altkey }, "space",
    function ()
      local s = awful.screen.focused()
      awesome_context.widgets.screen[s].layoutbox.menu:toggle({coords={
        y=0, x=capi.screen[s].geometry.width - beautiful.menu_width
      }})
      --awful.layout.inc(1)
    end,
    "choose layout", LAYOUT_MANIPULATION
  ),
  --bind_key({ modkey, "Control" }, "space",
    --function () awful.layout.inc(-1) end,
    --"prev layout", LAYOUT_MANIPULATION
  --),

  -- Layout tuning
  bind_key({ modkey, altkey }, "Down",
    function ()
      awful.tag.incnmaster(-1)
    end,
    "master-", LAYOUT_MANIPULATION
  ),
  bind_key({ modkey, altkey }, "Up",
    function () awful.tag.incnmaster( 1) end,
    "master+", LAYOUT_MANIPULATION
  ),
  bind_key({ modkey, altkey }, "Left",
    function () awful.tag.incncol(-1) end,
    "columns-", LAYOUT_MANIPULATION
  ),
  bind_key({ modkey, altkey }, "Right",
    function () awful.tag.incncol( 1) end,
    "columns+", LAYOUT_MANIPULATION
  ),

  -- Layout tuning (VIM style)
  bind_key({ modkey, altkey }, "j",
    function () awful.tag.incnmaster(-1) end,
    "master-", LAYOUT_MANIPULATION
  ),
  bind_key({ modkey, altkey }, "k",
    function () awful.tag.incnmaster( 1) end,
    "master+", LAYOUT_MANIPULATION
  ),
  bind_key({ modkey, altkey }, "h",
    function () awful.tag.incncol(-1) end,
    "columns-", LAYOUT_MANIPULATION
  ),
  bind_key({ modkey, altkey }, "l",
    function () awful.tag.incncol( 1) end,
    "columns+", LAYOUT_MANIPULATION
  ),

  bind_key({ modkey, altkey }, "e",
    function ()
      awful.tag.togglemfpol()
      tag.emit_signal("property::layout", t)
    end,
    "toggle expand master", LAYOUT_MANIPULATION
  ),
  bind_key({ modkey, altkey }, "g",
    function ()
      helpers.tag_toggle_gap()
      tag.emit_signal("property::layout", t)
    end,
    "toggle useless gap", LAYOUT_MANIPULATION
  ),

  -- Prompt
  bind_key({ modkey }, "r",
    function () awesome_context.widgets.screen[awful.screen.focused()].promptbox:run() end,
    "Run command...", UTILS
  ),
  bind_key({ modkey }, "x",
    function ()
      awful.prompt.run({ prompt = "Run Lua code: " },
      awesome_context.widgets.screen[awful.screen.focused()].promptbox.widget,
      awful.util.eval, nil,
      awful.util.getdir("cache") .. "/history_eval")
    end,
    "eXecute lua code...", UTILS
  ),

  -- ALSA volume control
  awful.key({}, "#123", function ()
      awesome_context.widgets.volume.Up()
  end),
  awful.key({}, "#122", function ()
      awesome_context.widgets.volume.Down()
  end),
  awful.key({}, "#121", function ()
      awesome_context.widgets.volume.ToggleMute()
  end),
  awful.key({}, "#198", function () awesome_context.widgets.volume.toggle_mic() end),

  -- Music player control
  bind_key({modkey, altkey}, ",",
    function () awesome_context.widgets.music.prev_song() end,
    "prev song", UTILS),
  bind_key({modkey, altkey}, ".",
    function () awesome_context.widgets.music.next_song() end,
    "next song", UTILS),
  bind_key({modkey, altkey}, "/",
    function () awesome_context.widgets.music.toggle() end,
    "Pause", UTILS),

  awful.key({}, "#150", function () awesome_context.widgets.music.prev_song() end),
  awful.key({}, "#148", function () awesome_context.widgets.music.next_song() end),
  -- lenovo keyboard
  awful.key({}, "#173", function () awesome_context.widgets.music.prev_song() end),
  awful.key({}, "#171", function () awesome_context.widgets.music.next_song() end),
  awful.key({}, "#172", function () awesome_context.widgets.music.toggle() end),
  -- lcars keyboard
  awful.key({}, "#180", function () awesome_context.widgets.music.toggle() end),
  awful.key({}, "#163", function () awesome_context.widgets.music.next_song() end),

  bind_key({ modkey }, "c",
    function () os.execute("xsel -p -o | xsel -i -b") end,
    "copy to clipboard", UTILS
  ),

  -- Standard program
  bind_key({ modkey,        }, "Return",
    function () awful.spawn.spawn(cmd.tmux) end,
    "terminal", IMPORTANT_COLOR
  ),
  bind_key({ modkey, altkey }, "Return",
    function ()
      awful.spawn.spawn(cmd.tmux_light)
    end,
    "white terminal", UTILS
  ),
  bind_key({ modkey,        }, "s",
    function () awful.spawn.spawn(cmd.file_manager) end,
    "file manager", UTILS
  ),

  bind_key({ modkey, "Control"  }, "r",
    function()
      awful.spawn.with_shell('xrdb -merge $HOME/.Xresources')
      capi.awesome.restart()
    end,
    "Reload awesome wm", IMPORTANT_COLOR
  ),
  bind_key({ modkey, "Control"    }, "q",
    capi.awesome.quit,
    "Quit awesome wm", IMPORTANT_COLOR
  ),

  -- Scrot stuff
  bind_key({ "Control"      }, "Print",
    function ()
      awful.spawn.with_shell(
      "scrot -ub '%Y-%m-%d--%s_$wx$h_scrot.png' -e " .. cmd.scrot_preview_cmd)
    end,
    "screenshot focused", TO_DEFINE_COLOR
  ),
  bind_key({ altkey        }, "Print",
    function ()
      awful.spawn.with_shell(
      "scrot -s '%Y-%m-%d--%s_$wx$h_scrot.png' -e " .. cmd.scrot_preview_cmd)
    end,
    "screenshot selected", TO_DEFINE_COLOR
  ),
  bind_key({  }, "Print",
    function ()
      awful.spawn.with_shell(
      "scrot '%Y-%m-%d--%s_$wx$h_scrot.png' -e " .. cmd.scrot_preview_cmd)
    end,
    "screenshot all", TO_DEFINE_COLOR
  ),
  bind_key({ "Shift" }, "Print",
    function ()
      awful.spawn.with_shell(
      "scrot '%Y-%m-%d--%s_$wx$h_scrot.png'")
    end,
    "screenshot all", TO_DEFINE_COLOR
  ),

  bind_key({modkey}, "a",
    revelation,
    "Revelation", UTILS
  ),

  bind_key({modkey, altkey}, "p",
    function()
      local t = awful.tag.selected(awful.screen.focused())
      if awful.tag.getproperty(t, 'layout').name == 'lcars' then
        return nlog("fuck you")
      end
      local visible = awful.tag.getproperty(t, 'left_panel_visible')
      awful.tag.setproperty(t, 'left_panel_visible', not visible)
    end,
    "toggle sidebox", LCARS
  ),
  bind_key({modkey, "Control", "Shift"}, "p",
    function()
      local t = awful.tag.selected(awful.screen.focused())
      local visible = awful.tag.getproperty(t, 'left_panel_visible')
      for s = 1, capi.screen.count() do
        for _, t in ipairs(awful.tag.gettags(s)) do
          awful.tag.setproperty(t, 'left_panel_visible', not visible)
        end
      end
    end,
    "toggle sidebox (all tags)", LCARS
  ),
  bind_key({modkey, altkey, "Control"}, "p",
    function()
      if awesome_context.lcarslist_enabled then
        awful.spawn.with_shell("sed -i 's/lcarslist_enabled = true/lcarslist_enabled = false/g' ~/.config/awesome/config/local.lua")
      else
        awful.spawn.with_shell("sed -i 's/lcarslist_enabled = false/lcarslist_enabled = true/g' ~/.config/awesome/config/local.lua")
      end
      capi.awesome.restart()
    end,
    "toggle lcarslist", LCARS
  )
)

awesome_context.clientkeys = awful.util.table.join(

  -- By direction client swap/move
  bind_key({ modkey,  "Shift"    }, "Down",
    function (c)
      if floats(c) then
        local g = c:geometry()
        g.y = g.y + RESIZE_STEP
        c:geometry(g)
      else
        awful.client.swap.global_bydirection("down")
        if client.swap then client.swap:raise() end
      end
    end,
    "client swap", CLIENT_MANIPULATION
  ),
  bind_key({ modkey,  "Shift"    }, "Up",
    function (c)
      if floats(c) then
        local g = c:geometry()
        g.y = g.y - RESIZE_STEP
        c:geometry(g)
      else
        awful.client.swap.global_bydirection("up")
        if client.swap then client.swap:raise() end
      end
    end,
    "client swap", CLIENT_MANIPULATION
  ),
  bind_key({ modkey,  "Shift"    }, "Left",
    function (c)
      if floats(c) then
        local g = c:geometry()
        g.x = g.x - RESIZE_STEP
        c:geometry(g)
      else
        awful.client.swap.global_bydirection("left")
        if client.swap then client.swap:raise() end
      end
    end,
    "client swap", CLIENT_MANIPULATION
  ),
  bind_key({ modkey,  "Shift"    }, "Right",
    function (c)
      if floats(c) then
        local g = c:geometry()
        g.x = g.x + RESIZE_STEP
        c:geometry(g)
      else
        awful.client.swap.global_bydirection("right")
        if client.swap then client.swap:raise() end
      end
    end,
    "client swap", CLIENT_MANIPULATION
  ),

  -- By direction client swap (VIM style)
  bind_key({ modkey, "Shift" }, "j",
    function (c)
      if floats(c) then
        local g = c:geometry()
        g.y = g.y + RESIZE_STEP
        c:geometry(g)
      else
        awful.client.swap.global_bydirection("down")
        if client.swap then client.swap:raise() end
      end
    end,
    "client swap", CLIENT_MANIPULATION
  ),
  bind_key({ modkey, "Shift" }, "k",
    function (c)
      if floats(c) then
        local g = c:geometry()
        g.y = g.y - RESIZE_STEP
        c:geometry(g)
      else
        awful.client.swap.global_bydirection("up")
        if client.swap then client.swap:raise() end
      end
    end,
    "client swap", CLIENT_MANIPULATION
  ),
  bind_key({ modkey, "Shift" }, "h",
    function (c)
      if floats(c) then
        local g = c:geometry()
        g.x = g.x - RESIZE_STEP
        c:geometry(g)
      else
        awful.client.swap.global_bydirection("left")
        if client.swap then client.swap:raise() end
      end
    end,
    "client swap", CLIENT_MANIPULATION
  ),
  bind_key({ modkey, "Shift" }, "l",
    function (c)
      if floats(c) then
        local g = c:geometry()
        g.x = g.x + RESIZE_STEP
        c:geometry(g)
      else
        awful.client.swap.global_bydirection("right")
        if client.swap then client.swap:raise() end
      end
    end,
    "client swap", CLIENT_MANIPULATION
  ),

  -- Client resize
  bind_key({ modkey, "Control"  }, "Right",
    function (c)
      if floats(c) then
        local g = c:geometry()
        g.width = g.width + RESIZE_STEP
        c:geometry(g)
      else
        awful.tag.incmwfact( 0.05)
      end
    end,
    "master size+", LAYOUT_MANIPULATION
  ),
  bind_key({ modkey,  "Control"  }, "Left",
    function (c)
      if floats(c) then
        local g = c:geometry()
        g.width = g.width - RESIZE_STEP
        c:geometry(g)
      else
        awful.tag.incmwfact(-0.05)
      end
    end,
    "master size-", LAYOUT_MANIPULATION
  ),
  bind_key({ modkey, "Control"  }, "Down",
    function (c)
      if floats(c) then
        local g = c:geometry()
        g.height = g.height + RESIZE_STEP
        c:geometry(g)
      else
        awful.client.incwfact(-0.05)
      end
    end,
    "column size-", LAYOUT_MANIPULATION
  ),
  bind_key({ modkey, "Control"  }, "Up",
    function (c)
      if floats(c) then
        local g = c:geometry()
        g.height = g.height - RESIZE_STEP
        c:geometry(g)
      else
        awful.client.incwfact( 0.05)
      end
    end,
    "column size+", LAYOUT_MANIPULATION
  ),

  -- Client resize (VIM style)
  bind_key({ modkey, "Control" }, "l",
    function (c)
      if floats(c) then
        local g = c:geometry()
        g.width = g.width + RESIZE_STEP
        c:geometry(g)
      else
        awful.tag.incmwfact( 0.05)
      end
    end,
    "master size+", LAYOUT_MANIPULATION
  ),
  bind_key({ modkey,  "Control" }, "h",
    function (c)
      if floats(c) then
        local g = c:geometry()
        g.width = g.width - RESIZE_STEP
        c:geometry(g)
      else
        awful.tag.incmwfact(-0.05)
      end
    end,
    "master size-", LAYOUT_MANIPULATION
  ),
  bind_key({ modkey, "Control" }, "j",
    function (c)
      if floats(c) then
        local g = c:geometry()
        g.height = g.height + RESIZE_STEP
        c:geometry(g)
      else
        awful.client.incwfact(-0.05)
      end
    end,
    "column size-", LAYOUT_MANIPULATION
  ),

  bind_key({ modkey, "Control" }, "k",
    function (c)
      if floats(c) then
        local g = c:geometry()
        g.height = g.height - RESIZE_STEP
        c:geometry(g)
      else
        awful.client.incwfact( 0.05)
      end
    end,
    "column size+", LAYOUT_MANIPULATION
  ),


  bind_key({ modkey,        }, "f",
    function (c) c.fullscreen = not c.fullscreen end,
    "toggle client fullscreen", CLIENT_MANIPULATION
  ),
  bind_key({ modkey,        }, "q",
    function (c) c:kill() end,
    "quit app", IMPORTANT_COLOR
  ),
  bind_key({ modkey, "Shift"  }, "f",
    awful.client.floating.toggle,
    "toggle client float", CLIENT_MANIPULATION
  ),
  bind_key({ modkey, "Shift"  }, "Return",
    function (c) c:swap(awful.client.getmaster()) end,
    "put client on master", CLIENT_MANIPULATION
  ),
  bind_key({ modkey,        }, "o",
    awful.client.movetoscreen,
    "move client to other screen", CLIENT_MANIPULATION
  ),
  bind_key({ modkey,        }, "t",
    function (c) c.ontop = not c.ontop end,
    "toggle client on top", CLIENT_MANIPULATION
  ),
  bind_key({ modkey, "Shift"    }, "t",
    function(c)
     awesome_context.widgets.screen[c.screen].manage_client.toggle()
    end,
    "toggle titlebars", CLIENT_MANIPULATION
  ),
  bind_key({ modkey,        }, "n",
    function (c) c.minimized = true end,
    "iconify client", CLIENT_MANIPULATION
  ),
  bind_key({ modkey,        }, "m",
    function (c)
      c.maximized = not c.maximized
    end,
    "maximize client", CLIENT_MANIPULATION
  )
)

local diff = nil
for scr = 1, 2 do
  for i = 1, 12 do

  if scr == 1 then
    -- num keys:
    diff = 9
  elseif scr == 2 then
    -- f-keys:
    if i>10 then
      diff = 84
    else
      diff = 66
    end
  end

  globalkeys = awful.util.table.join(globalkeys,
    bind_key({ modkey }, "#" .. i + diff,
      function ()
        local tag = awful.tag.gettags(scr)[i]
        if tag then awful.tag.viewonly(tag) end
      end,
      i==1 and "go to tag " .. i .. "(screen #" .. scr .. ")",
      TAG_COLOR
    ),
    bind_key({ modkey, "Control" }, "#" .. i + diff,
      function ()
        local tag = awful.tag.gettags(scr)[i]
        if tag then awful.tag.viewtoggle(tag) end
      end,
      i==1 and "toggle tag " .. i .. "(screen #" .. scr .. ")",
      TAG_COLOR
    ),
    bind_key({ modkey, "Shift" }, "#" .. i + diff,
      function ()
        if client.focus then
          local tag = awful.tag.gettags(scr)[i]
          if tag then awful.client.movetotag(tag) end
         end
      end,
      i==1 and "move client to tag " .. i .. "(screen #" .. scr .. ")",
      CLIENT_MANIPULATION
    ),
    bind_key({ modkey, "Control", "Shift" }, "#" .. i + diff,
      function ()
        if client.focus then
          local tag = awful.tag.gettags(scr)[i]
          if tag then awful.client.toggletag(tag) end
        end

      end,
      i==1 and "toggle client to tag " .. i .. "(screen #" .. scr .. ")",
      CLIENT_MANIPULATION
    )
  )
  end
end

-- Set keys
capi.root.keys(globalkeys)
-- }}}


end
return keys
