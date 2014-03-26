--[[

Functions can operate as iterators in a for loop.

--]]



-- Something to iterate over.
local colorTable = {"red", "orange", "yellow", "green", "blue"}

--- Iterators are simply functions that provide output feasible for use
-- within a for loop. This is not the ideal way to write an iterator.
-- @return {string} A single element of the color table.
local colors = function()
    local max = #colorTable
    if max > 0 then
        local choice = math.random(max)
        return table.remove(colorTable, choice)
    end    
end

-- Since our iterator relies on stateful data in our module, we pass
-- in the iterator by name and it will be called each pass through the
-- for loop until it returns nil. Not the most elegant solution.
for choice in colors do
    print("Color chosen:", choice)
end





--- A function that takes a table and returns a random choice from the 
-- table until all choices are exhausted.
-- Closure allows us to write a more ideal functional iterator.
-- @param choices {table} Indexed table of choices.
-- @return {mixed} A single element of the table.
local choiceIter = function(choices)
    -- We keep state by returning a function that gets called for
    -- ever part of the for loop.
    
    -- Defensive copy.
    local choicesCopy = {}
    for k,v in pairs(choices) do 
        choicesCopy[k] = v 
    end

    -- Seed the random number generator, as on some systems (Mac mainly)
    -- not seeding will return the same general values each time.
    -- This is because general Lua distros use C's rand and srand methods
    -- which can be more, or less, random depending on implementation.
    math.randomseed(os.time())
    -- Throw out the first 5 - 10 random numbers.
    for i=1, math.random(5, 10) do
        -- pass...
    end

    return function()
        -- min 1, max inclusive.
        local max = #choicesCopy
        if max > 0 then
            local choice = math.random(max)
            return table.remove(choicesCopy, choice)
        end
    end
end



-- The iter function is called as part of the for loop setup, which
-- returns the stateful closure function that is actually used during
-- the for loop.
for choice in choiceIter({"red", "orange", "yellow", "green", "blue"}) do
    print("Color chosen:", choice)
end
