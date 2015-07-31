---------------------------------------------------------------------------
--- Menu generation module for menubar
--
-- @author Antonio Terceiro
-- @copyright 2009, 2011-2012 Antonio Terceiro, Alexander Yakushev
-- @release v3.5.2-602-g4996334
-- @module menubar.menu_gen
---------------------------------------------------------------------------

-- Grab environment
local awful = require("awful")
local utils = require("menubar.utils")
local pairs = pairs
local ipairs = ipairs
local string = string
local table = table

local menu_gen = {}

--- Specify the mapping of .desktop Categories section to the
-- categories in the menubar. If "use" flag is set to false then any of
-- the applications that fall only to this category will not be shown.
menu_gen.all_categories = { }

--@TODO: merge this func with awful.prompt------------------------------------
--
--- Private data
local history_file_path = awful.util.getdir("cache") .. "/history"
local data = {}
data.history = {}
function menu_gen.add_history_record(record, id)
    id = id or history_file_path
    table.insert(data.history[id]['table'], record)
end
--- Load history file in history table
-- @param id The data.history identifier which is the path to the filename.
-- @param[opt] max The maximum number of entries in file.
function menu_gen.history_check_load(id, max)
    id = id or history_file_path
    if id and id ~= ""
        and not data.history[id] then
	data.history[id] = { max = 50, table = {} }

	if max then
            data.history[id].max = max
	end

	local f = io.open(id, "r")

	-- Read history file
	if f then
            for line in f:lines() do
                --if awful.util.table.hasitem(data.history[id].table, line) == nil then
                        table.insert(data.history[id].table, line)
                        if #data.history[id].table >= data.history[id].max then
                           break
                        end
                --end
            end
            f:close()
	end
    end
end
--- Save history table in history file
-- @param id The data.history identifier
function menu_gen.history_save(id)
    id = id or history_file_path
    if data.history[id] then
        local f = io.open(id, "w")
        if not f then
            local i = 0
            for d in id:gmatch(".-/") do
                i = i + #d
            end
            util.mkdir(id:sub(1, i - 1))
            f = assert(io.open(id, "w"))
        end
	for i = 1, math.min(#data.history[id].table, data.history[id].max) do
            f:write(data.history[id].table[i] .. "\n")
        end
       f:close()
    end
end
-----
-- move this one to awful.util.table ?
----------
local function ReverseTable(t)
    local reversedTable = {}
    local itemCount = #t
    for k, v in ipairs(t) do
        reversedTable[itemCount + 1 - k] = v
    end
    return reversedTable
end
------------------------------------------------------------------------------

--- Generate an array of all visible menu entries.
-- @return all menu entries.
function menu_gen.generate()

    menu_gen.history_save(history_file_path)
    menu_gen.history_check_load(history_file_path, 666)
    local history_table = data.history[history_file_path]['table']

    local result = {}

    -- @TODO: count number of occurences, sort by most used

    for _, command in ipairs(ReverseTable(history_table)) do
                table.insert(result, { name = command,
                                       cmdline = command,
                                       icon = nil,
                                       category = nil })
    end
    return result
end

return menu_gen

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
