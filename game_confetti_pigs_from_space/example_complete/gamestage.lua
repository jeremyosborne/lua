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
    -- Subscribe ourselves to events.
    self.eventregister:sub("mousepressed", self.onmousepress, self)
    self.eventregister:sub("timesup", self.ontimesup, self)

    -- Entity singletons.    
    -- Countdown timer and callback for end of time.
    self.timer = Timer(settings.game.gameLength)
    -- Reset the player score when we get here.
    score:reset()
    
    -- Bacgkround view.
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

    -- Update the countdown.
    self.timer:update(dt)
    
    -- Play dumb and update the score, just in case we want to use it later.
    score:update(dt)

    -- Update the background.
    self.background:update(dt)

    -- Update Pigs.
    local pigs = {}
    for _, ent in pairs(self.pigs) do
        if ent:update(dt) ~= "dead" then
            table.insert(pigs, ent)
        end
    end
    self.pigs = pigs
    -- Attempt to add a pig.
    self:addpig()
        
    -- Update explosions.
    local explosions = {}
    for _, ent in pairs(self.explosions) do
        if ent:update(dt) ~= "dead" then
            table.insert(explosions, ent)
        end
    end
    self.explosions = explosions
            
    -- Check for collisions between pigs and explosions.
    -- Remove pigs if they are out of the screen.
    local winx = love.graphics:getWidth()/2
    local winy = love.graphics:getHeight()/2
    local winrad = math.sqrt(winx^2 + winy^2)
    for _, ent in pairs(self.pigs) do
        local pigx = ent.components.position.x
        local pigy = ent.components.position.y
        local pigr = ent.components.radius.radius
        local winCollision = collideCircle(pigx, pigy, pigr,
            winx, winy, winrad)
        if not winCollision then
            -- Pig is not inside the game area anymore.
            events:pub("outsideboundaries", {target = ent})
        else
            -- Check for collisions with explosions on the screen.
            for _, exp in pairs(self.explosions) do
                local expx = exp.components.position.x
                local expy = exp.components.position.y
                local expr = exp.components.radius.radius
                local expCollision = collideCircle(pigx, pigy, pigr,
                    expx, expy, expr)
                if expCollision then
                    events:pub("pigexplosion", {target = ent})
                    -- Add some particles.
                    for i=3, math.random(3, 7) do
                        table.insert(self.particles, Particle(pigx, pigy))
                    end
                end
            end
        end
    end

    -- Update particles.
    local particles = {}
    for _, ent in pairs(self.particles) do
        if ent:update(dt) ~= "dead" then
            table.insert(particles, ent)
        end
    end
    self.particles = particles
    
    return self.updateResponse
end

--- Called each frame and used to draw things related to our stage.
gameStage.draw = function(self)

    -- Draw the background.
    self.background:draw()

    -- Draw countdown.    
    self.timer:draw()

    -- Draw score.
    score:draw()

    -- Draw pigs.
    for _, ent in pairs(self.pigs) do
        ent:draw()
    end    
    
    -- Draw explosions.
    for _, ent in pairs(self.explosions) do
        ent:draw()
    end    
    
    -- Draw particles.
    for _, ent in pairs(self.particles) do
        ent:draw()
    end
end

--- Attempt to add a pig to the level.
gameStage.addpig = function(self)
    -- Assume about 60 frames a second.
    if math.random(1, settings.game.pigSpawnChance) ~= 1 then
        return
    end

    local pigEntrance = randrectside(love.graphics:getWidth(), love.graphics:getHeight())
    local pigvxDirection = 0
    if pigEntrance.side == 1 then
        -- Move left.
        pigvxDirection = -1
    elseif pigEntrance.side == 3 then
        -- Move right.
        pigvxDirection = 1
    end
    local pigvx = pigvxDirection * math.random(settings.game.pigMinSpeed, settings.game.pigMaxSpeed)
    local pigvyDirection = 0
    if pigEntrance.side == 0 then
        -- Move down.
        pigvyDirection = 1
    elseif pigEntrance.side == 2 then
        -- Move up.
        pigvyDirection = -1
    end
    local pigvy = pigvyDirection * math.random(settings.game.pigMinSpeed, settings.game.pigMaxSpeed)
    
    table.insert(self.pigs, Pig(pigEntrance.x, pigEntrance.y, pigvx, pigvy))
end

--- React to mousepresses (launch missiles).
-- 
-- Events published:
-- missilelaunchdetected -> Happens whenever the mouse is pressed.
gameStage.onmousepress = function(self, data)
    log("gameStage: mousepress event:", table.concat(data, ","))
    -- Add an explosion on the mouse click.
    table.insert(self.explosions, Explosion(data[1], data[2], settings.game.explosionLifetime))
    events:pub("missilelaunchdetected")    
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
