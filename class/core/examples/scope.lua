--[[

Variable scoping in Lua.
Build this file and then require it elsewhere, like from the Lua
interpreter.

--]]

-- This variable will be available to all files within our environment.
favoriteColor = "red"

-- This variable will only be available within our file.
local testColor = "blue"

do
    -- Lua provides block scoping.
    local testColor = "purple"
    print("The testColor is:", testColor)
end

print("No, the testColor is:", testColor)

-- Lacking any local reference, we access an outer scope variable.
do
    if true then
        testColor = "purple"
    end
end
print("Now the testColor is:", testColor)

--- Lua exhibits closure.
-- @param number {number} A number we wish to add 42 to.
-- @return {function} A function to call in the future.
local f = function(number)
    number = number or 0
    return function()
        number = number + 42
        return number
    end
end

local g = f(100)
print("g() is", g())
print("then g() is", g())

