--[[

Function techniques in Lua.

--]]

--- Not a function. An object we can work with.
local player = {
    name = "Player 1",
    endurance = 100,
    speed = 20,
    inventory = {
        "beanie",
        "spiderman underoos",
        "campbell's soup",
    }
}

--- Global function available to all within this Lua environment.
-- Find an index within the current list, or return nil if none.
-- @param t {table} Table to search through. Assuming array format.
-- @param what {mixed} Something to look for within the table.
function index(t, what)
    -- If we want default values, the idiom is:
    what = what or ""
    for i, v in ipairs(t) do
        if v:lower() == what:lower() then
            return i
        end
    end
    -- functions don't have to have a return value.
    -- lacking a specific return, lua functions will return nil.
end

--- Local functions are scoped within their current boundaries.
-- Eats food contained within an inventory.
-- @param entity {table} Entity that wants to eat. Objects are passed
-- by reference.
-- @param food {string} Name of food to eat from inventory. 
-- @return {string} The item eaten.
local function eat(entity, food)
    if food:lower() ~= "spiderman underoos" then
        local i = index(entity.inventory, food)
        if i then
            return table.remove(entity.inventory, i)
        end
    end
end

-- Test out our function.
print("Trying to feed our player.")
print( eat(player, "car") or "couldn't eat that" )
print( eat(player, "spiderman underoos") or "couldn't eat that" )
print( eat(player, "campbell's soup") or "couldn't eat that" )

-- Objects are passed to functions by reference.
print("What is left in our inventory after feeding?")
-- table.foreach appears to be one of those deprecated functions that
-- might be around forever for diagnostic purposes.
table.foreach(player.inventory, print)



--- Functions are first order objects in Lua and can be assigned to
-- identifiers.
-- @param entity {table} An entity that implements endurance and speed.
-- @return {number} How far the entity can run.
local runningDistance = function(entity)
    if entity.endurance and entity.speed then
        return entity.endurance * entity.speed
    else
        return 0
    end
end

--- Functions can be passed to other functions, and functions can take 
-- variable arguments.
-- @param entity {table} The entity to take for a jog.
-- @param ... {function} Any number of functions to calculate distance
-- of the jog.
-- @return {number} How far jogged total.
local jog = function(entity, ...)
    local totalDistance = 0
    -- We can reference this vararg notation within the function.
    -- The varargs have a historical 'arg' reference table which can
    -- be employed, or we can employ like so:
    for n=1, select('#',...) do
        totalDistance = totalDistance + select(n,...)(entity)
    end
    return totalDistance
end


-- Try things out and make sure they work.
print("Total pixels jogged:", jog(player, runningDistance, runningDistance))



--- Lua functions support multiple return values.
-- @return {string} 3 strings used for names (multiple return values).
local rename = function()
    return "Player", "1", "Redux"
end

-- And how Lua interacts with them.
player.name = rename()
print("The new name is:", player.name)
-- Try again.
local first, middle, last = rename()
player.name = first.." "..middle.." "..last
print("The new name is now:", player.name)
