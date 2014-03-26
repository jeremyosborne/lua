--[[

Score for the game.

--]]



local Class = require("lib.class")
local Entity = require("entities.entity")

local settings = require("settings")
local mainFont = settings.mainFont

-- Assumes events is global before this file is loaded for the first time.



--- Create a score keeper.
-- @param [score] {number} Initial score.
local Score = Class(function(self, score)
    -- What we all want to increase in a game :)
    self.score = score or 0
    
    -- Score changes via game events.
    self:addComponent("eventregister")
    self.components.eventregister:sub("missilelaunchdetected", self.onmissilelaunchdetected, self)
    self.components.eventregister:sub("pigexplosion", self.onpigexplosion, self)
    
end, Entity)

--- Ducktype.
Score.name = "score"

--- No need for update override for Score.

--- Draw the score.
Score.draw = function(self)
    love.graphics.setColor(255, 255, 255, 255)
    -- Upper left corner, with a bit of padding.
    love.graphics.print("Score: "..tostring(self.score), 10, 10)
end

--- Adjust score for missile launch.
Score.onmissilelaunchdetected = function(self)
    self.score = self.score - 1
end

--- Adjust score for missile launch.
Score.onpigexplosion = function(self)
    self.score = self.score + 3
end

--- Resets the score to zero.
Score.reset = function(self)
    self.score = 0
end


return Score
