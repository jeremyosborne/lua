--[[

Stores current motion.

--]]


local Class = require("lib.class")



--- 2d motion vector.
-- @param owner {Entity} Who owns this component.
-- @param x {number} X portion of velocity.
-- @param y {number} Y portion of velocity.
local Velocity = Class(function(self, owner, x, y)
    --- Which entity owns us?
    self.owner = owner

    self.x = x or 0
    self.y = y or 0
end)

--- Update position of entity.
-- Assumes coupling with an entity with position.
Velocity.update = function(self, dt)
    local pos = self.owner.components.position
    if pos then
        pos.x = pos.x + self.x*dt
        pos.y = pos.y + self.y*dt
    end
end



return Velocity
