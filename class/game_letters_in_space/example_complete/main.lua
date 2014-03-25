--[[

Every Love2d game needs a main file. This is just a requirement of the
system, and every game system will be different.

--]]


--- Diagnostic print statement. Purposely global.
log = function(...)
    if DEBUG then
        print(...)
    end
end    

-- Generalized event publisher. This needs to be made available before 
-- many other things are loaded, might as well do this first.
events = require("lib.events").Events()

-- The audio is global because it is event based.
audio = require("entities.audio")()

-- Use paths relative to our root directory when we require.
-- Always use the full path to allow for caching by file path.
local settings = require("settings")

-- Our list of entities.
local entities = {}

-- Entities
local Letter = require("entities.letter")

-- Utils
local randsign = require("lib.random").randsign

-- React to the keypresses.
-- Expect the data payload to contain the key that was pressed as the
-- first index.
events:sub("keypressed", function(data)
    --Diagnostic.
--    log("keypressed: "..data[1])
    
--    table.insert(entities, Letter(data[1]))
    
--    table.insert(entities, Letter(data[1],
--        -- position randomly in the game window, x first then y.
--        math.random(5, love.graphics:getWidth()-5),
--        math.random(5, love.graphics:getHeight()-5)
--    ))

    table.insert(entities, Letter(data[1],
        -- position randomly in the game window, x first then y.
        math.random(5, love.graphics:getWidth()-5),
        math.random(5, love.graphics:getHeight()-5),
        -- Random velocity in pixels/sec (x then y).
        math.random(10, 100) * randsign(),
        math.random(10, 100) * randsign()
    ))
end)



--- Called prior to the run loop. A chance to load assets.
love.load = function()
    love.graphics.setFont(settings.mainFont)
      
    -- Signal the start of the game.
    events:pub("gamestart")    
end



--- Called once per frame.
-- @param dt {number} Delta (in seconds) since last update.
love.update = function(dt)
    local ents = {}
    for _, ent in pairs(entities) do
        if ent:update(dt) ~= "dead" then
            table.insert(ents, ent)
        end
    end
    entities = ents
end



--- Called once per frame.
love.draw = function()
    -- Hello world!
    --love.graphics.print("Hello World", 400, 300)

    for _, ent in pairs(entities) do
        ent:draw()
    end    
end



--- Callback for key presses.
love.keypressed = function(key, unicode)
    -- quit on escape.
    if key == "escape" then
        love.event.quit()
    elseif unicode > 31 and unicode < 127 then
        -- Just the ascii characters for now.
        --log("keypressed: "..string.char(unicode))
        events:pub("keypressed", {string.char(unicode)})
    end
end



--- Callback when the game quits.
love.quit = function()
    log("Thanks for playing.")

    -- Signal the end of the game.
    events:pub("gamestop")
end
