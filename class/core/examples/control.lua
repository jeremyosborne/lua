--[[

Flow of control in Lua.

--]]

print("What is your name?")
local name = io.read("*line")
print("What is your favorite color?")
local color = io.read("*line")
print("What is the airspeed velocity of an unladen swallow?")
local airspeed = io.read("*line")



-- If, elseif, else blocks.
if type(name) ~= "number" then
    print(name, "is not a number type.")
end

if type(name) == "number" then
    print(name, "is a number")
elseif type(name) == "nil" then
    print(name, "is nil")
elseif type(name) == "string" then
    print(name, "is a string, as expected")
else
    print(name, "[infamous should not get here statement]")
end

-- A tiny warning about what passes and fails truth checks.
-- false and nil behave as expected, but 0 is treated as a truthy value
-- and is not a failure like in C. This is for historical reasons when
-- nil used to be the only failure value and false didn't exist.
if 0 or false or nil then
    print(0, false, nil, ": at least one value is truthy.")
else
    print(0, false, nil, ": all values are falsey.")
end



-- For loops, and a future note: indexing is 1s based in Lua, not 0.
-- For loops have a few forms. This is the straightforward step form,
-- from i to #name.
print("Your favorite color displayed vertically:")
for i = 1, #color do
    -- There isn't an simple way to get a single letter in a string, so...
    print(color:sub(i, i))
end

print("Iterating math.pi by 0.5 increments")
for i = 0, math.pi, 0.5 do
    print(i)
end



-- The do end block is mainly for scoping, which will be talked about
-- separately and hinted at here.
do
    local color = "red"
    print("Color in the do-end block is:", color)
end
print("Your color is still:", color)



-- While and repeat blocks, roughly the same.
print("Your name repeated a couple of times")
while true do
    print(name)
    break
end
repeat
    print(name)
until true



-- Since zero is a truthy value, this will pass.
if tonumber(airspeed) then
    print(airspeed, "is a number.")
else
    print("The airspeed you gave is not a number.")
end

-- And an equivalent ternary operation, like above.
local converted = tonumber(airspeed) and airspeed or "not a number."
print("Airspeed is:", converted)
