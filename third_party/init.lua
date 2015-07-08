local function script_path()
   return debug.getinfo(2, "S").source:sub(2):match("(.*/)")
end
local path = script_path()
package.path = package.path .. ';'.. path .. '?/init.lua'
package.path = package.path .. ';'.. path .. '?.lua'

local third_party = {
  collision = require("collision"),
  eminent = require("eminent"),
  revelation = require("revelation"),
  --forgotten = require("forgotten"),
}

return third_party
