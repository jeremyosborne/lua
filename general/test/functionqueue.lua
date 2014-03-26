--[[
    
    FunctionQueue Tests.

--]]

-- Fix our test path.
package.path = "../src/?.lua;"..package.path

-- Assume association with src directory.
local log = require("diag").log
local FunctionQueue = require("functionqueue")



log("BEGIN TESTS: FunctionQueue.")
local tests = {
    
    ["FunctionQueue sanity"] = function()
        local fq = FunctionQueue()
        assert(type(fq) == "table", "is of type table.")
        assert(type(fq.append) == "function", "append function exists") 
        fq:append(function() end)
        assert(1 == #fq, "one entry in the fq.")
        fq:append(10)
        assert(1 == #fq, "still one entry in the fq (only functions allowed.")
        local g = function() end
        fq:unshift(g)
        assert(2 == #fq, "Two functions in the queue.")
        assert(fq[1] == g, "gx in the first index as expected.")
        
        assert(2 == fq(), "Two functions should have been called.")
    end,
    
    ["FunctionQueue functional test: iterate queued functions"] = function()
        local a = 0
        local f = function()
            a = 42
        end
        
        local b = 0
        local g = function() 
            b = 24
        end
        
        -- Make sure we have side effects from running.
        local fq = FunctionQueue()
        fq:append(f)
        fq:append(g)
        local howmany = fq()
        assert(2 == howmany, "Ran 2 functions.")
        assert(42 == a, "a set to correct value.")
        assert(24 == b, "b set to correct value.")
    end,
}

for testName, test in pairs(tests) do
    log("running test: "..testName)
    -- Assert will throw an error if things are screwed up.
    test()
end
log("END TESTS: FunctionQueue.")
