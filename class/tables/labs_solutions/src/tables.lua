--[[

Lab based around working with tables..

There are tests, called specs in the Behavior Driven Development (BDD)
world, that are prewritten.

To run the tests, run the command:

    lua luaspec specs/tables.lua

The lab is done when the tests pass.

NOTE: Please make all functions global, not local, as the tests expect
globally available functions.

--]]



player = {
    name = "Player 1",
    inventory = {},
    
    --- Provide a method named 'getname' that returns the player's name.
    -- @return {string} The player's name.
    getname = function(self)
        return self.name
    end,
    
    --- Provide a method named 'pickup' that appends an item to the 
    -- player's inventory.
    -- @param item {mixed} The item to add to the inventory.
    pickup = function(self, item)
        table.insert(self.inventory, item)
    end,
}

setmetatable(player, {
    --- Provide a method named 'yell' on the "class prototype" that
    -- returns a string.
    -- @param speech {string} What the player will yell.
    -- @return {string} Of the format "%s yells: %s", where arg1 is
    -- the player name and arg2 is speech.
    __index = {
        yell = function(self, speech)
            return ("%s yells: %s"):format(self.name, speech)
        end,
    },

    --- Provide the tostring metamethod that returns the player's name.
    -- @return {string} The player name.
    __tostring = function(self) 
        return self.name
    end
})




--- Build a function named "stackFactory" that returns a new table
-- each time it is called. Each new table has the following properties:
-- * If the table is called, it returns the table length.
-- * The table has a "push" method that appends the non-self argument
--   onto the table.
-- * The table as a "pop" method that pops the last item off the table
--   and returns the item.
-- * Question: Why do we not need to worry about overwriting the push and
--   pop methods?
stackFactory = function()
    return setmetatable({}, {
        __call = function(self)
            return #self
        end,
        __index = {
            push = function(self, item)
                table.insert(self, item)
            end,
            pop = function(self)
                return table.remove(self)
            end,
        }
    })
end
