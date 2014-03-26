--[[

Lua is very simplistic in general, and offers a simple, no frills
interface to working with files.

--]]


local subject = {
    "A dragon",
    "Mom",
    "Santa",
}
local verb = {
    "ate",
    "broke",
    "shaved",
}
local predicate = {
    "a castle",
    "a cow",
    "lots of presents",
}

local createStory = function()
    local story = {
        subject[math.random(#subject)],
        verb[math.random(#verb)],
        predicate[math.random(#predicate)],
    }
    return table.concat(story, " ")
end



-- The os and io modules go hand in hand.
-- Attempt to build a temporary file.
local tmpname = os.tmpname()
-- Opening a file can possibly return error indicators but will not
-- throw an error (no need for pcall).
local f, e = io.open(tmpname, "w")
if f then
    local story = {}
    for i=1, 10 do
        table.insert(story, createStory())
    end
    f:write(table.concat(story, "\n"))
    f:close()
else
    print("Sorry, could not open the file:", tmpname, "due to:", e)
end



print("Reading lines from our file.")
linenum = 0
for line in io.lines(tmpname) do
    linenum = linenum + 1
    print(tmpname, "("..linenum..")", line)
end
-- file is closed for us when we do this form of io.lines.



