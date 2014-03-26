--[[
    
    CircularProcessQueue Tests.

--]]

-- Fix our test path.
package.path = "../src/?.lua;"..package.path

-- Assume association with src directory.
local log = require("diag").log
local CircularProcessQueue = require("circularprocessqueue")



log("BEGIN TESTS: CircularProcessQueue.")
local tests = {
    
    ["sanity"] = function()
        local cq = CircularProcessQueue()
        assert(type(cq) == "table", "is of type table.")
        assert(type(cq.append) == "function", "append function exists") 
        cq:append(function() end)
        assert(1 == #cq, "one entry in the fq.")
        cq:append(10)
        assert(1 == #cq, "still one entry in the fq (only functions allowed.")
        local g = function() end
        cq:unshift(g)
        assert(2 == #cq, "Two functions in the queue.")
        assert(cq[1] == g, "gx in the first index as expected.")
    end,
    
    ["functional test: index bounds check"] = function()
        local cq = CircularProcessQueue()
        
        assert(1 == cq:index(), "Index is 1 by default.")
        cq:index(1)
        assert(1 == cq:index(), "Can stay within bounds even without processes.")
        status = pcall(cq.index, cq, "HELLO")
        assert(status == false, "Correctly throw an error with bad index value.")
    end,

    ["functional test: iterate queued functions"] = function()
        -- A process.
        local a = 0
        local f = function()
            if a == 0 then
                a = 42
            else
                a = 0
            end
            return true
        end
        -- Another process.
        local b = 0
        local g = function() 
            b = 24
            return true
        end
        
        -- Make sure we have side effects from running.
        local cq = CircularProcessQueue()
        cq:append(f)
        cq:append(g)

        -- Check first index.
        assert(1 == cq:index(), "initial index is 1.")
        -- First run test.
        cq()
        assert(42 == a, "a set to correct value.")
        assert(0 == b, "b set to correct value.")
        assert(2 == cq:index(), "index is 2.")
        -- Second run test.
        cq()
        assert(42 == a, "a set to correct value.")
        assert(24 == b, "b set to correct value.")
        assert(1 == cq:index(), "index is back to 1.")
        -- Third run test, we should be back at the beginning.
        cq()
        assert(0 == a, "a set to correct value.")
        assert(24 == b, "b set to correct value.")
        
        -- Act as a setter.
        cq:index(1)
        cq()
        assert(42 == a, "a set to correct value.")
        assert(24 == b, "b set to correct value.")
    end,
    
    ["functional test: passing arguments"] = function()
        -- A process.
        local a = 0
        local f = function(arg)
            a = arg
            return true
        end
        local cq = CircularProcessQueue()
        cq:append(f)
        cq("hello")
        assert("hello" == a, "argument passed to function correctly.")
        cq("world")
        assert("world" == a, "argument passed to function correctly.")
        cq()
        assert(nil == a, "argument passed to function correctly.")
    end
}

for testName, test in pairs(tests) do
    log("running test: "..testName)
    -- Assert will throw an error if things are screwed up.
    test()
end
log("END TESTS: CircularProcessQueue.")
