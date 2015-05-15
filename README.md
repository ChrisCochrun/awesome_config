﻿awesome_config
==============

#### Installation
```sh
cd ~/.config/
git clone https://github.com/actionless/awesome_config.git -b devel awesome
cd awesome
git submodule init
git submodule update
# optionally copy config with machine-specific variables
wget https://gist.githubusercontent.com/actionless/229eef7795915068bad9/raw/08c2df45abcc3cb9b08737cadd9058bbfe005e40/local.lua -O config/local.lua
```

 - [lcars](http://i.imgur.com/8C6l5ko.gifv) layout
 - in `*-xresources` themes panel [adapts](http://imgur.com/a/qIAAa) for current xrdb theme

![Screenshot](https://raw.githubusercontent.com/actionless/awesome_config/devel/screenshots/screenshot.png "Screenshot")

The same screenshot with other colors set in ~/.Xresources:

![Screenshot](https://raw.githubusercontent.com/actionless/awesome_config/devel/screenshots/screenshot_lcars.png "Screenshot")

#### Widget popups

@TODO: upload newer screenshots

##### CPU
Shows results from top for last second

![cpu](https://raw.githubusercontent.com/actionless/awesome_config/devel/screenshots/cpu.png "cpu")

##### Memory
Shows unified percentage of used memory for all applications' processes

![mem](https://raw.githubusercontent.com/actionless/awesome_config/devel/screenshots/mem.png "mem")

##### Systray toggle (like in windows xp :) )
![st](http://i.imgur.com/HFfERGC.png "st")

##### Calendar (taken from Lain widgetkit)
![cal](http://i.imgur.com/pB5n12b.png "cal")

##### Music (supports mpd, cmus, clementine, spotify at the _same_ time)
![music](http://i.imgur.com/W7ur5SQ.png "music")

Battery widget shows up only when it draining/charging.
Indicators are changing color to brighter one to show changed state (like too big load average or too low battery).
@TODO: upload screens.
