--[[

Every Love2d game needs a main file. This is just a requirement of the
system, and every game system will be different.

--]]



-- Use paths relative to our root directory when we require.
-- Always use the full path to allow for caching by file path.
local settings = require("settings")
local stageManager = require("stagemanager")



-- Generalized event publisher. This needs to be made available before 
-- many other things are loaded, might as well do this first.
events = require("lib.events").Events()

-- The score keeper needs to be global because it is shared.
--score = require("entities.score")()

-- The audio is global because it is event based.
audio = require("entities.audio")()

--- Diagnostic print statement. Purposely global.
log = function(...)
    if DEBUG then
        print(...)
    end
end    



--- Called during the game load. A chance to load assets.
love.load = function()
    love.graphics.setFont(settings.mainFont)
    
    -- Initialize our game stages.
    stageManager:add( require("titlestage") )
    stageManager:add( require("gamestage") )
    stageManager:add( require("endstage") )
    -- Set the initial state.
    stageManager:respond("title")
end



--- Called once per frame.
-- @param dt {number} Delta (in seconds) since last update.
love.update = function(dt)
    stageManager:update(dt)
end



--- Called once per frame.
love.draw = function()
    stageManager:draw()
end



--- Callback for key presses.
love.keypressed = function(key, unicode)
    -- quit on escape, don't pass to the stagemanager.
    if key == "escape" then
        love.event.quit()
    end
end



--- Callback for mouse clicks.
love.mousepressed = function(x, y, button)
    -- Generalize events for our application.
    events:pub("mousepressed", {x, y})
end



--- Callback when the game quits.
love.quit = function()
    log("Thanks for playing.")
end
