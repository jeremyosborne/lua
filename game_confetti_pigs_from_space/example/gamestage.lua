--[[

The main game.

--]]


local State = require("lib.state").State
local EventRegister = require("components.eventregister")
local Timer = require("entities.timer")
local Explosion = require("entities.explosion")
local Pig = require("entities.pig")
local Particle = require("entities.particle")
local Background = require("entities.background")
local collideCircle = require("lib.collisions").circle
local randrectside = require("lib.random").randrectside

local settings = require("settings")
local mainFont = settings.mainFont


local gameStage = State("game")

--- Called to setup our stage.
gameStage.enter = function(self)
    log("gameStage: entering")

    -- Window caption.
    love.graphics.setCaption("Confetti pigs are coming for you")

    -- Response from update (for StageManager).
    self.updateResponse = nil

    -- Use a component explicitly.
    self.eventregister = EventRegister(self)
    
    -- Background view.
    self.background = Background()
    
    -- Volatile collection for explosions.
    self.explosions = {}
    
    -- Volatile collection for pigs.
    self.pigs = {}
    
    -- Particle collection.
    self.particles = {}

    -- Tell the world the game has started.
    events:pub("gamestart")
end

--- Called each frame to update our state.
-- 
-- Events published:
-- * outsideboundaries -> When a pig goes outside of the boundaries.
-- Passes the target property pointing to the pig that is outside.
-- * pigexplosion -> When a pig hits an explosion. Passes the target
-- property pointing to the pig that hit the explosion.
gameStage.update = function(self, dt)

end

--- Called each frame and used to draw things related to our stage.
gameStage.draw = function(self)

end

--- Attempt to add a pig to the level.
gameStage.addpig = function(self)

end

--- React to mousepresses (launch missiles).
-- 
-- Events published:
-- missilelaunchdetected -> Happens whenever the mouse is pressed.
gameStage.onmousepress = function(self, data)
    log("gameStage: mousepress event:", table.concat(data, ","))


end

--- React to timesup.
gameStage.ontimesup = function(self, data)
    if data.target.name == "timer" then
        log("gameStage: TIMES UP!")
        -- Transition to the end game.
        self.updateResponse = "end"
    end
end

--- Cleanup.
gameStage.exit = function(self)
    log("gameStage: removing up event listeners.")

    -- Tell the world the game has started.
    events:pub("gamestop")

    self.eventregister:clear()
    log("gameStage: exiting")
end



return gameStage
