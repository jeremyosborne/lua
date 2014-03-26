--[[
    
Events tests.

--]]

-- Fix our test path.
package.path = "../src/?.lua;"..package.path

-- Controllable logger.
local log = function(...)
    print(...)
end

-- Assume association with src directory.
local Event = require("events").Event
local Events = require("events").Events

-- Name of package being tested.
local testSuiteName = "events"


log("\nBEGIN TESTS:", testSuiteName, "\n")
local tests = {
    
    ["sanity for Event object"] = function()
        local e1 = Event()
        local e2 = Event()
        assert(e2.id > e1.id, "Younger events, higher ids.")
        
        local e3 = Event(function(arg1)  
            assert(arg1 == 42, "pub works as expected")
        end)
        e3:pub(42)
    end,
    
    ["Event instances preserve context"] = function()
        local testCaller = {x = 42}
        local e = Event(function(caller, arg1)
            assert(caller.x == 42, "Calling context passed.")
            assert(arg1 == 24, "Arguments passed following caller.")
        end, testCaller)
        e:pub(24)
    end,
    
    ["sanity for Events object"] = function()
        local events = Events()
        local subid = events:sub("test", function(arg1)
            assert(arg1 == 42, "Received argument when event called.")
        end)
        events:pub("test", 42)
        assert(type(subid) == "number", "Recieved a number as a subscription id.")
    end,
    
    ["Events publishes multiple events, calls expected number of callbacks"] = function()
        local events = Events()
        -- Expected tests
        local expected = 5
        local testsrun = 0

        events:sub("test", function() 
            testsrun = testsrun + 1
        end)
        events:sub("test", function() 
            testsrun = testsrun + 1
        end)
        events:sub("test2", function() 
            testsrun = testsrun + 1
        end)
        events:pub("test")
        events:pub("test")
        events:pub("test2")
        -- Should not affect anything, and also shouldn't throw an error.
        events:pub("test_dummy")
        -- Count by total number of event callbacks.
        assert(testsrun == expected, "Total expected number of callbacks called.")
    end,
    
    ["Events clears events properly"] = function()
        local events = Events()
        -- Expected tests
        local expected = 3
        local testsrun = 0
        
        local cancelId = events:sub("test", function()
            testsrun = testsrun + 1
        end)
        events:sub("test", function()
            testsrun = testsrun + 1
        end)
        
        -- Count is two here.
        events:pub("test")
        events:clear("test", cancelId)
        
        -- Count should be three here.
        events:pub("test")
        
        events:clear("test")
        
        -- Count should still be three here.
        events:pub("test")
        
        assert(expected == testsrun, "Total expected number of callbacks called.")
    end,

    ["Events clears with just an id properly"] = function()
        local events = Events()
        -- Expected tests
        local expected = 3
        local testsrun = 0
        
        local cancelId = events:sub("test", function()
            testsrun = testsrun + 1
        end)
        events:sub("test", function()
            testsrun = testsrun + 1
        end)
        
        -- Count is two here.
        events:pub("test")

        events:clear(nil, cancelId)
        
        -- Count should be three here.
        events:pub("test")
        
        assert(expected == testsrun, "Total expected number of callbacks called.")
    end,
}

for testName, test in pairs(tests) do
    local outputMessage = "%s "..testName
    local teststatus, error = pcall(test)
    if teststatus then
        log(outputMessage:format("[PASS]"))
    else
        log(outputMessage:format("[FAIL]"))
        log(error)
    end
end
log("\nEND TESTS:", testSuiteName, "\n")
