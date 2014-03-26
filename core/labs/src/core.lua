--[[

Lab based around working with text, functions, and basics of Lua.

There are tests, called specs in the Behavior Driven Development (BDD)
world, that are prewritten.

To run the tests, run the command:

    lua luaspec specs/core.lua

The lab is done when the tests pass.

NOTE: Please make all functions global, not local, as the tests expect
globally available functions.

--]]



--- Build a function that takes a string and returns an uppercase
-- version of the string.
-- @param s {string} The string to capitalize.
-- @param {string} A capitalized string.
caps = function(s)

end



--- Build a function that takes a string, splits the "words" of the string
-- (sequences of characters surrounded by whitespace) into a list, and
-- returns the list.
-- @param s {string} String to split.
-- @return {table} List of worlds (array style table).
listWords = function(s)

end



--- Build a function that takes a string, and returns a list of words
-- in reverse order.
-- This function should also protect against non string values and
-- return nil if someone passes a non-string value.
-- @param s {string} String to split into a list.
-- @return {table} List of worlds (array style table) in reverse order.
listWordsReverse = function(s)

end



--- Write a function that takes a string and a function.
-- The string is split into words, and the function is then run on
-- each set of words.
-- Whatever is returned from the function is placed (mapped) into a
-- table. That table is then returned.
-- Think of this function like a functional map that does string to
-- list conversion first (see http://en.wikipedia.org/wiki/Map_%28higher-order_function%29).
-- @param s {string} The string to add to a list.
-- @param op {function} A function that will receive each word in order and
-- will return some value.
-- @return {table} A map of values resulting from the function calls and
-- subsequent return values.
mapWords = function(s, op)

end



--- Build a function named incrementor that manages a variable named 
-- counter that is not accessible to other things in this file, nor 
-- accessible to things outside of this file. 
-- On any call that passes an argument, return that argument if it is
-- a number and set the internal counter to that number.
-- On any call that does not pass an argument in, increment the counter
-- by 1 permanently and return the new value.
-- The default initial return value should be 1.
do
    incrementor = function(n) 

    end
end
