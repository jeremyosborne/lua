--[[

Letters in space.

--]]

local Class = require("lib.class")
local Entity = require("entities.entity")

local settings = require("settings")
local mainFont = settings.mainFont



--- Create a letter.
-- 
-- @param letter {string} What letter to display?
-- @param x {number} X coordinate of where to place the letter.
-- @param y {number} Y coordinate of where to place the letter.
-- @param vx {number} Velocity magnitude in the x direction.
-- @param vy {number} Velocity magnitude in the y direction.
local Letter = Class(function(self, letter, x, y, vx, vy)
    self.letter = letter
    self:addComponent("position", x, y)

    -- Entities signal their removal from the game by returning truthy.
    self.updateResponse = nil

    -- Add for directed speed.
    self:addComponent("velocity", vx, vy)

    self:addComponent("eventregister")
    -- Listen to our own demise, whenever that happens.
    self:addComponent("countdown", 4)
    self.components.eventregister:sub("timesup", self.ontimesup, self)
end, Entity)

--- Ducktype
Letter.name = "letter"

-- Use the inherited update method.

--- Draw.
Letter.draw = function(self)
    -- What we should print.
    local letter = self.letter
    
    -- Where the letter should be centered.
    local pos = self.components.position

    -- Center the letter on the point.
    local x = mainFont:getWidth(letter)/2
    local y = mainFont:getHeight(letter)/2

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(letter, pos.x-x, pos.y-y)
end

--- Listen for when we're done.
Letter.ontimesup = function(self, data)
    if data.target == self then
        -- Our job here is done.
        self.updateResponse = "dead"
        self.components.eventregister:clear()
        
        -- Diagnostic.
        --log("removing letter:", self.letter)
    end
end

return Letter
