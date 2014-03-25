--[[

Countdown for the game.

--]]



local Class = require("lib.class")
local Entity = require("entities.entity")

local settings = require("settings")
local mainFont = settings.mainFont

-- Assumes events is global before this file is loaded for the first time.



--- Create a countdown timer.
-- 
-- Events published:
-- timesup (via countdown component): fires once, when the countdown has 
-- expired (reached zero).
-- 
-- @param time {number} How much time total should elapse before the
-- countdown is done.
local Timer = Class(function(self, time)
    self:addComponent("countdown", time)
end, Entity)

--- Ducktype.
Timer.name = "timer"

--- Update is only component based, so we used the inherited update.

--- Draw the clock.
Timer.draw = function(self)
    local time = self.components.countdown:time()
    
    -- Upper right corner, with a bit of padding.
    local x = love.graphics.getWidth() - mainFont:getWidth(time) - 10
    -- Assume fontsize is the font height, scoot help text down just a bit.
    local y = 10
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(time, x, y)
end



return Timer