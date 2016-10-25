local awful = require("awful")

local run_once = require("actionless.helpers").run_once


local autorun = {}

function autorun.init(awesome_context)

  awful.spawn.with_shell('xinput set-prop 12 "Device Accel Velocity Scaling" 26')
  awful.spawn.with_shell('xinput set-prop 12 "Evdev Middle Button Emulation" 1')
  awful.spawn.with_shell('xinput set-prop 12 "Evdev Wheel Emulation" 1')
  awful.spawn.with_shell('xinput set-prop 12 "Evdev Wheel Emulation Button" 3')
  awful.spawn.with_shell('xinput set-prop 12 "Evdev Wheel Emulation Inertia" 20')
  awful.spawn.with_shell('xinput set-prop 12 "Evdev Wheel Emulation Timeout" 200')

  --run_once("gnome-session")
  --run_once("/usr/lib/gnome-settings-daemon/gnome-settings-daemon")
  --awful.spawn.with_shell("eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)")
  --awful.spawn.with_shell("/home/lie/.screenlayout/awesome.sh")
  --run_once("redshift")
  awful.spawn.with_shell("xset r rate 250 25")
  --awful.spawn.with_shell("xset r rate 250 10")
  awful.spawn.with_shell("xset b off") -- turn off beep
  --run_once(awesome_context.cmds.compositor)
  --run_once('/usr/lib/gnome-settings-daemon/gnome-settings-daemon-localeexec')
  awful.spawn.with_shell("xsettingsd")
  run_once("pulseaudio")
  awful.spawn.with_shell("start-pulseaudio-x11")
  run_once("xfce4-power-manager")
  run_once("dropbox")
  run_once("megasync")
  --run_once("xscreensaver -no-splash")
  --run_once("unclutter -root")
  run_once("unclutter")
  run_once("setxkbmap -layout us,ru -variant ,winkeys -option grp:caps_toggle,grp_led:caps,terminate:ctrl_alt_bksp,compose:ralt")
  run_once("kbdd")
  --run_once("mopidy -q 2>&1 >> $HOME/.cache/mopidy.log")
  --run_once("urxvtd")

  for _, item in ipairs(awesome_context.autorun) do
    awful.spawn.with_shell(item)
  end

end

return autorun
