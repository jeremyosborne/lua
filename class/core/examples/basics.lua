--[[

This modules is about the basic types that we can use in lua:

    number
    string
    boolean
    nil
    table
    function
    thread
    userdata

This file will demonstrate the basic types and will leave thread and
userdata for later.

This is also a multi-line comment.

--]]

-- This is a single line comment.

-- The default type of a variable is nil, which is the Lua null.
local author

-- This variable references a string. There are single line strings...
local storyTitle = "A Short Story"
-- ...and multiline strings. 
local narrative = [[Once upon a time, the big {{noun}} had 
{{number}} {{nouns}}.
Along {{verb past tense}} a {{noun}} with {{adjective}} {{noun}}.]]

-- The print statement is great text output, as well as diagnostics.
print("It's story time!")
-- String concatenation.
print("The title of our story is: "..storyTitle)
print("The story is incomplete. I will prompt you for the missing words.")

--- Trim whitespace from the left hand side of our string. 
-- There isn't a true standard for documenting Lua functions, but there
-- is an informal standard of beginning the comment with a triple dash.
-- @param s {{string}} The string to trim.
-- @return {{string}} String passed in, minus preceding white space.
local function ltrim(s)
    -- Lua is object oriented, and provides some syntactic sugar via
    -- the colon operator for invoking instance methods.
    -- Lua has basic matching patterns. The following is equivalent to
    -- "Remove all white space from the beginning of the string, group
    -- and ultimately return any non-whitespace characters following
    -- the preceding white space characters."
    return s:match'^%s*(.*%S)' or ''
end


-- Tables fill the role of arrays and key:value maps.
local wordPairs = {}

-- For loops are the main way to iterate.
-- Here we iterate over each of the {{words}} in our narrative.
for wordType in narrative:gmatch("{{.-}}") do
    -- Lua provides a small set of core libraries for use.
    -- The following is equivalent to: "write a line to stdout, no
    -- trailing newline."
    io.write("Please give me a "..wordType..": ")
    -- Lua provides a small set of core libraries for use.
    -- The following is equivalent to: "read a line from standard in."
    -- Note that the colon operator and the dot operator do slightly
    -- different jobs in Lua and hence are not interchangeable.
    -- We also call our own function that we declared earlier.
    local wordValue = ltrim( io.read("*line") )
    -- Save the word pair for later.
    -- Here wordPairs is being treated as an array, and we are inserting
    -- another table into wordPairs that is a key:value map.
    table.insert(wordPairs, {[wordType]=wordValue})
end

local completedNarrative = narrative
-- When iterating over a table, the ipairs method (for arrays) and
-- the pairs method (for key:value maps) are often used. When discarding
-- one of the returned variables, an underscore is often used to denote
-- the ignoring of the value in the loop.
for _, wordPair in ipairs(wordPairs) do
    for wordType, wordValue in pairs(wordPair) do
        -- Replace only the first occurance of wordType with wordValue.
        completedNarrative = completedNarrative:gsub(wordType, wordValue, 1)
    end
end

print("\nThank you for filling in the story. Here is the final version:\n")
print(completedNarrative)
print("")
-- The number type is a double precision number.
-- Here we capture the number of entries in our table.
local wordReplacements = #wordPairs
print( string.format("We replaced %d words in the story", wordReplacements) )
-- Current versions of Lua have a true boolean type.
print("Did we replace more than 2 words?", wordReplacements > 2)

print("The original author of this story was:", author)
print("")

