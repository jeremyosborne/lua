--[[

    Various diagnostic functions.

--]]



-- Module.
local M = {}

-- {boolean} Whether or not debug mode is set.
M.debug = true



--- Wrapper for print statement.
-- @param ... {string} Args that will be unpacked and passed as
-- is to print.
local log = function(...)
    if M.debug then
        print(...)
    end
end
-- Export
M.log = log




--- Iterate over an object and log the first layer of key/values.
-- @param obj {table} Only table types work. Non table types will
-- generate a log statement, but won't break anything.
-- @param [name] {string} An arbitrary name that will be output
-- with the log statements. Makes things more decipherable for
-- random objects.
local dumpvals = function(obj, name)
    if not M.debug then
        return
    end
  
    local t = type(obj)
    name = name or "unnamed"
  
    log("BEGIN attempted dump of values from "..t.." named: "..name)
    if t == "table" then
        local template = "%-10s %s: %s"
        for k, v in pairs(obj) do
            log(template:format("<"..type(v)..">", tostring(k), tostring(v)))
        end
    else
        log(string.format("Value of <%s> is %s", t, tostring(obj)))
    end
    log("END attempted dump of values from "..t.." named: "..name)
end
-- Export.
M.dumpvals = dumpvals



-- Export module.
return M
