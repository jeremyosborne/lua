--[[

The evil confetti pigs.

--]]

local Class = require("lib.class")
local Entity = require("entities.entity")

local settings = require("settings")
local pigImage = settings.images.pig
-- These will be used a lot.
local pigWidth = pigImage:getWidth()
local pigHeight = pigImage:getHeight()
-- Adjust until happy.
local pigRadius = pigWidth/2



--- Create a confetti pig at a particular location.
-- 
-- @param x {number} X coordinate of where to place the pig.
-- @param y {number} Y coordinate of where to place the pig.
-- @param vx {number} Velocity magnitude in the x direction.
-- @param vy {number} Velocity magnitude in the y direction.
-- @param [lifetime] {number} Minimum lifetime the pig should be on screen
-- before being allowed to be garbage collected (allows pigs to start out
-- side the screen).
local Pig = Class(function(self, x, y, vx, vy, lifetime)
    self:addComponent("position", x, y)
    self:addComponent("velocity", vx or 0, vy or 0)
    self:addComponent("eventregister")
    self:addComponent("radius", pigRadius)

    -- Entities signal their removal from the game by returning truthy.
    self.updateResponse = nil

    -- Allow ourselves to be removed if we are outside the game view
    -- and we've been in the game long enough.
    self.components.eventregister:sub("outsideboundaries", self.onoutsideboundaries, self)
    self.components.eventregister:sub("pigexplosion", self.onpigexplosion, self)
end, Entity)

--- Ducktype
Pig.name = "pig"

-- Use the inherited update method.

--- Draw.
Pig.draw = function(self)
    local pos = self.components.position
    
    -- Reset transparancy.
    love.graphics.setColor(255, 255, 255, 255)
    -- drawable, x, y, r, sx, sy, ox, oy, kx, ky
    love.graphics.draw(pigImage, 
        -- Position
        pos.x, pos.y,
        -- Rotation 
        0, 
        -- Scale
        1, 1, 
        -- offset from position (assumed negative)
        pigWidth/2, pigHeight/2)
end

--- Listen for outside boundaries event.
Pig.onoutsideboundaries = function(self, data)
    if data.target == self then
        self.updateResponse = "dead"
        self.components.eventregister:clear()
    end
end

--- We have hit an explosion.
Pig.onpigexplosion = function(self, data)
    if data.target == self then
        self.updateResponse = "dead"
        self.components.eventregister:clear()
    end
end



return Pig
