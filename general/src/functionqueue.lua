--[[

    Queue up a table of functions for running.

--]]

local log = require("diag").log

--- @class Emulate an iterable queue with a simple table.
local FunctionQueue = function()
    return setmetatable({}, {
        -- Class prototype.
        __index = {
            --- Convenience method insted of table.insert(fq, f, 1)
            -- @param f {function} Function to be placed at the front of the queue. 
            unshift = function(self, f)
                if type(f) == "function" then
                    table.insert(self, 1, f)
                else
                    log("FunctionQueue WARNING: Attempting to unshift type("..type(f)..") which is not a function.")                
                end
            end,
            --- Convenience method instead of table.insert(fq, fx).
            -- @param f {function} Function to be appended. 
            append = function(self, f)
                if type(f) == "function" then
                    table.insert(self, f)
                else
                    log("FunctionQueue WARNING: Attempting to append type("..type(f)..") which is not a function.")
                end
            end,
        },
        --- Iterate and call all functions when table is called as a function.
        -- inserted into the table in the indexable array positions.
        -- @param ... Varargs that will be unpacked and
        -- passed as formal arguments to the calling function.
        -- @return {number} How many of the functions in the table
        -- were called.
        __call = function(self, ...)
            -- Iterate over each of our entries and call.
            local callcount = 0
            for _,f in ipairs(self) do
                if type(f) == "function" then
                    f(unpack(arg))
                    callcount = callcount + 1
                else
                    log("FunctionQueue WARNING: Attempting to call type("..type(f)..") which is not a function.")
                end
            end
            return callcount
        end
    })
end



-- Export just the class.
return FunctionQueue
