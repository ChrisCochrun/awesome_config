
--[[
												  
	 Licensed under GNU General Public License v2 
	  * (c) 2013,	  Luke Bonham				
	  * (c) 2010-2012, Peter Hofmann			  
												  
--]]

local newtimer		= require("widgets.helpers").newtimer
local font     = require("widgets.helpers").font

local wibox		   = require("wibox")
local naughty     = require("naughty")

local io			  = { lines  = io.lines,
						 popen = io.popen }
local math			= { floor  = math.floor }
local string		  = { format = string.format,
						  gmatch = string.gmatch,
						  len	= string.len }

local setmetatable	= setmetatable

-- Memory usage (ignoring caches)
-- lain.widgets.mem
local mem = {}
mem.widget = wibox.widget.textbox('')
mem.widget:connect_signal("mouse::enter", function () mem.show_notification() end)
mem.widget:connect_signal("mouse::leave", function () mem.hide_notification() end)

local function worker(args)
	local args	 = args or {}
	local timeout  = args.timeout or 3
	local settings = args.settings or function() end
	mem.list_len = args.list_length or 10
	mem.timeout = args.timeout or 0
	mem.font = args.font or font

	function mem.hide_notification()
		if mem.id ~= nil then
			naughty.destroy(mem.id)
			mem.id = nil
		end
	end

	function mem.show_notification()
		mem.hide_notification()
		local f = io.popen("ps aux | awk '{print $2, $4, $11}' | sort -k2r | head -n " .. mem.list_len)
		local output = ''
		for line in f:lines() do
			output = output .. line .. '\n'
		end
		mem.id = naughty.notify({
			text = output,
			timeout = mem.timeout
				})
	end

	function update()
		mem_now = {}
		for line in io.lines("/proc/meminfo")
		do
			for k, v in string.gmatch(line, "([%a]+):[%s]+([%d]+).+")
			do
				if	 k == "MemTotal"  then mem_now.total = math.floor(v / 1024)
				elseif k == "MemFree"   then mem_now.free  = math.floor(v / 1024)
				elseif k == "Buffers"   then mem_now.buf   = math.floor(v / 1024)
				elseif k == "Cached"	then mem_now.cache = math.floor(v / 1024)
				elseif k == "SwapTotal" then mem_now.swap  = math.floor(v / 1024)
				elseif k == "SwapFree"  then mem_now.swapf = math.floor(v / 1024)
				end
			end
		end

		mem_now.used = mem_now.total - (mem_now.free + mem_now.buf + mem_now.cache)
		mem_now.swapused = mem_now.swap - mem_now.swapf

		widget = mem.widget
		settings()
	end

	newtimer("mem", timeout, update)

	return mem.widget
end

return setmetatable(mem, { __call = function(_, ...) return worker(...) end })
