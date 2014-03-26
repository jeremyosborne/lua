--[[

Coroutines are functions that are provided a separate call stack.
The operation of a coroutine can be paused (yielded) and resumed
for as long as the coroutine does not exit as a real function
exits.

--]]



--- Any function can be a coroutine.
-- Coroutines function a bit like closure based functions,
-- but they get their own call stack that is managed
-- separately and don't need functions within functions
-- to keep state.
local randomEncounter = function()
    local encounters = { 
        "orc",
        "rabid teddy bear",
        "army of fleas",
    }

    print("Diagnostic: which thread?", coroutine.running())

    while true do
        -- The coroutine library enables a function to
        -- keep stack state.
        -- Return and pause the function.
        coroutine.yield(encounters[math.random(#encounters)])
    end
end


-- Need to formally create the stack for the coroutine, can't
-- just call the function.
local enc = coroutine.create(randomEncounter)

-- Our coroutine will run forever, so let's just call it a couple
-- of times and see what happens.
print( "Status:", coroutine.status(enc) )
print( "Random encounter:", coroutine.resume(enc) )
print( "Random encounter:", coroutine.resume(enc) )
print( "Random encounter:", coroutine.resume(enc) )
print( "Random encounter:", coroutine.resume(enc) )
print( "Status:", coroutine.status(enc) )
-- What happens when run outside a coroutine?
print( "Is this a coroutine?", coroutine.running() )

print("What's on the coroutine library?")
table.foreach(coroutine, print)



-- Coroutines can get access to outer data.
local names = {
    "rajeshre",
    "bobbie",
    "harsha",
    "kim",
    "ryan",
    "matt",
    "janna",
    "loan",
    "cath",
    "tony",
    "archer",
}

-- Different approach to simple name generator.
-- Wrap makes working with a coroutine a bit simpler.
local namings = coroutine.wrap(function()
    while #names > 0 do
        coroutine.yield(table.remove(names))
    end
end)

-- Wrapped coroutines are just functions to the
-- outside world.
print("What is namings?", type(namings))

print("First name from list", namings())

print("Iterate list of names.")
for name in namings do
    print(name)
end

print("Did we empty the names table?", #names == 0)

