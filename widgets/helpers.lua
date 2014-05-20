
--[[
                                                  
     Licensed under GNU General Public License v2 
      * (c) 2013-2014  Yauheni Kirylau
      * (c) 2013,      Luke Bonham                
      * (c) 2010-2012, Peter Hofmann              
                                                  
--]]
local settings = require("widgets.settings")

local debug  = require("debug")

local awful = require("awful")
local capi   = { timer = timer }
local io     = { open = io.open,
                 lines = io.lines }
local rawget = rawget

local theme_dir = settings.theme_dir
-- Lain helper functions for internal use
local helpers = {}

helpers.beautiful = require("beautiful")
helpers.beautiful.init(awful.util.getdir("config") .. theme_dir .. "theme.lua")
helpers.font = string.match(helpers.beautiful.font, "([%a, ]+) %d+")

helpers.dir    = debug.getinfo(1, 'S').source:match[[^@(.*/).*$]]
helpers.icons_dir   = awful.util.getdir("config") .. theme_dir .. 'icons/'
helpers.scripts_dir = helpers.dir .. 'scripts/'

helpers.mono_preset = { font=helpers.beautiful.notification_monofont,
				        opacity=helpers.beautiful.notification_opacity }

-- {{{ Modules loader

function helpers.wrequire(table, key)
    local module = rawget(table, key)
    return module or require(table._NAME .. '.' .. key)
end

-- }}}

-- {{{ Timer maker

helpers.timer_table = {}

function helpers.newtimer(name, timeout, fun, nostart)
    helpers.timer_table[name] = capi.timer({ timeout = timeout })
    helpers.timer_table[name]:connect_signal("timeout", fun)
    helpers.timer_table[name]:start()
    if not nostart then
        helpers.timer_table[name]:emit_signal("timeout")
    end
end

-- }}}

-- {{{ A map utility

helpers.map_table = {}

function helpers.set_map(element, value)
    helpers.map_table[element] = value
end

function helpers.get_map(element)
    return helpers.map_table[element]
end

-- }}}

function helpers.only_digits(str)
  return tonumber(str:match("%d+"))
end

-- {{{ Read the ... of a file or return nil.


function helpers.flines_to_lines(f)
  if not f then return nil end
  local lines = {}
  local counter = 1
  for line in f:lines() do 
    lines[counter] = line
    counter = counter + 1
  end
  return lines
end

function helpers.table_merge(t, set)
    for _, v in ipairs(set) do
        table.insert(t, v)
    end
end

function helpers.dict_getn(dict)
  local num_items = 0
  for k,v in pairs(dict) do
    num_items = num_items + 1
  end
  return num_items
end

function helpers.dict_merge(t, set)
    for k, v in pairs(set) do
        t[k] = v
    end
end
----------------------------------------------

function helpers.find_in_lines(lines, regex)
  local match = nil
  for _, line in ipairs(lines) do
    match = line:match(regex)
    if match then
      return match
    end
  end
end

function helpers.find_value_in_lines(lines, regex, match_key)
  local key, value = nil, nil
  for _, line in ipairs(lines) do
    key, value = line:match(regex)
    if key == match_key then
      return value
    end
  end
end

function helpers.find_values_in_lines(lines, regex, match_keys)
  local key, value = nil, nil
  local values = {}
  local match_keys_length = helpers.dict_getn(match_keys)
  for _, line in ipairs(lines) do
    if match_keys_length <= 0 then
      return values
    end
    key, value = line:match(regex)
    for result_key, match_key in pairs(match_keys) do
      if key == match_key then
        values[result_key] = value
        match_keys[key] = nil
        match_keys_length = match_keys_length - 1
      end
    end
  end
  return values
end

----------------------------------------------

function helpers.first_line_in_fo(f)
  if not f then return nil end
  return f:read("*l")
end

function helpers.find_in_fo(f, regex)
  return helpers.find_in_lines(
    helpers.flines_to_lines(f), regex)
end

function helpers.find_value_in_fo(f, regex, match_key)
  return helpers.find_value_in_lines(
    helpers.flines_to_lines(f),
    regex, match_key)
end

----------------------------------------

function helpers.first_line_in_file(f)
  fp = io.open(f)
  local content = helpers.first_line_in_fo(fp)
  fp:close()
  return content
end

function helpers.find_value_in_file(file_name, regex, match_key)
  fp = io.open(file_name)
  content = helpers.find_value_in_fo(
    fp, regex, match_key)
  fp:close()
  return content
end

-- }}}

return helpers
