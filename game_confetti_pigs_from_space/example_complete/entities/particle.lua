--[[

Remnants of an exploded confetti pig.

--]]

local Class = require("lib.class")
local Entity = require("entities.entity")
local randsign = require("lib.random").randsign



--- Create a particle of confetti at a particular location.
-- (Simplistic particle, could be used elsewhere.)
-- @param x {number} X coordinate of where to place the particle.
-- @param y {number} Y coordinate of where to place the particle.
-- @param [lifetime] {number} Number of seconds the particle should last
-- on the screen.
local Particle = Class(function(self, x, y, lifetime)
    self:addComponent("position", x, y)
    self:addComponent("countdown", lifetime or 8)
    self:addComponent("eventregister")
    self:addComponent("radius", 6)
    self:addComponent("velocity", 
        randsign()*math.random(10, 30),
        randsign()*math.random(10, 30))    

    -- Entities signal their removal from the game by returning truthy.
    self.updateResponse = nil

    -- Listen to our own demise, whenever that happens.
    self.components.eventregister:sub("timesup", self.ontimesup, self)
end, Entity)

--- Ducktype
Particle.name = "particle"

-- Use the inherited update method.

--- Draw.
Particle.draw = function(self)
    local pos = self.components.position
    local alpha = math.min(170, math.max(255, 255/self.components.countdown:age()))
    love.graphics.setColor(20, 240, 20, alpha)
    -- mode, x, y, radius, segments-in-circle
    love.graphics.circle("fill", pos.x, pos.y, self.components.radius.radius, 10)
end

--- Listen for when we're done.
Particle.ontimesup = function(self, data)
    if data.target == self then
        -- Our job here is done.
        self.updateResponse = "dead"
        self.components.eventregister:clear()
    end
end


return Particle
