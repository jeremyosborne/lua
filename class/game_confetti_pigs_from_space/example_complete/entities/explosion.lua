--[[

Explosive blast for blowing up confetti pigs.

--]]

local Class = require("lib.class")
local Entity = require("entities.entity")



--- Determine radius as it changes over time. Override to the radius
-- component update function.
-- @param self {component} Here, self is the radius component.
local updateRadius = function(self)
    -- Size of radius changes overtime.    
    self.radius = math.sin(math.pi*self.owner.components.countdown:age())*self.maxRadius
end



--- Create an explosion at a particular location.
-- 
-- @param x {number} X coordinate of where to place the explosion.
-- @param y {number} Y coordinate of where to place the explosion.
-- @param [lifetime] {number} Number of seconds the explosion should last
-- on screen.
local Explosion = Class(function(self, x, y, lifetime)
    self:addComponent("position", x, y)
    self:addComponent("countdown", lifetime or 2)
    self:addComponent("eventregister")
    self:addComponent("radius", 30, 0)
    -- Override the update function.
    self.components.radius.update = updateRadius

    -- Entities signal their removal from the game by returning truthy.
    self.updateResponse = nil

    -- Listen to our own demise, whenever that happens.
    self.components.eventregister:sub("timesup", self.ontimesup, self)
end, Entity)

--- Ducktype
Explosion.name = "explosion"

-- Use the inherited update method.

--- Draw.
Explosion.draw = function(self)
    local pos = self.components.position
    local alpha = math.max(130, 255*self.components.countdown:age())
    love.graphics.setColor(121, 121, 255, alpha)
    -- mode, x, y, radius, segments-in-circle
    love.graphics.circle("fill", pos.x, pos.y, self.components.radius.radius, 65)
end

--- Listen for when we're done.
Explosion.ontimesup = function(self, data)
    if data.target == self then
        -- Our job here is done.
        self.updateResponse = "dead"
        self.components.eventregister:clear()
    end
end


return Explosion
