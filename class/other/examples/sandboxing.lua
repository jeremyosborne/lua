--[[

Lua itself is an embedded program, and allows functions to be run
as embedded applications within a currently running Lua environment.

--]]

-- Pretend this is some external function.
local test = function()
    p("Test")
end

do
    -- Create a new environment variable.
    enclosed = {
        p = function(message)
            print("TESTING", message)
        end
    }
    
    setfenv(test, enclosed)
    test()
end


-- This will fail because there is no p outside of the test function.
print( pcall(p) )

