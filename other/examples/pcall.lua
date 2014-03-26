--[[

Lua does not have a try/catch block. Instead, it uses
closure based protected calls.

--]]

-- This method will work just fine.
local good = function()
    return "hi there"
end

-- This method will break.
local bad = function()
    return Player.name 
end



-- Protected call will return a boolean call status as
-- the first return value, and n+1 return values represent
-- the return values of the called function.
local status, retval = pcall(good)
print("pcall status of good:", status)
print("pcall retval of good:", retval)

status, retval = pcall(bad)
print("pcall status of bad:", status)
print("pcall retval of bad:", retval)



-- Two other conveniences around pcall:
-- * use an anonymous function. 
-- * pack the results in a table.
local name1, name2, results
results = { pcall(function()
    name1 = good()
    name2 = good()
    bad()
    print("shouldn't see.")
end) }
print("Results contains")
for i, v in ipairs(results) do
    print(i, v)
end
-- That which doesn't error still executes.
print("name1", name1)
print("name2", name2)

