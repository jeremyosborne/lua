--[[

As time passes, this component counts down and when it hits zero, an
event is fired.

--]]


local Class = require("lib.class")



--- Allow an entity to countdown.
-- 
-- Events published:
-- timesup: fires once, when the countdown has expired (reached zero).
-- Passes an object with the target = countdown owner.
-- 
-- @param owner {Entity} Who owns this component.
-- @param time {Number} How much time to track in the countdown?
local Countdown = Class(function(self, owner, time)
    --- Which entity owns us?
    self.owner = owner
    --- How much time did we have to begin with?
    self.maxTime = time or 60
    --- The timer goes one direction: down.
    self.timeleft = time or 60
    --- This type of timer will only trigger once.
    self.expired = false
end)

--- Update the time and trigger the timesup event if the countdown
-- is done (timesup only triggers once).
-- @param delta {number} How much to change the time. Inverts signage
-- as it assumes a positive delta should count down, not up.
Countdown.update = function(self, delta)
    self.timeleft = self.timeleft - delta
    if self.timeleft <= 0 and not self.expired then
        self.expired = true
        -- Let any listeners know we're done.
        events:pub("timesup", {target = self.owner})
    end
end

--- Convenience method to get display friendly time.
-- @return {number} Human friendly time of the countdown.
Countdown.time = function(self)
    -- Truncated, don't display time < zero.
    return math.max(0, math.floor(self.timeleft))
end

--- Determine age as a percentage of lifetime.
-- @return {number} Age as a percentage of life spent.
Countdown.age = function(self)
    return (self.maxTime-self.timeleft)/self.maxTime
end



return Countdown
