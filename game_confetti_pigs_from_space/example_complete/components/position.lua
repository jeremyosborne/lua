--[[

Locates an entity on a position.

--]]


local Class = require("lib.class")



--- Allow an entity to be positioned in 2d.
-- @param owner {Entity} Who owns this component.
-- @param x {number} X coordinate position.
-- @param y {number} Y coordinate position.
local Position = Class(function(self, owner, x, y)
    --- Which entity owns us?
    self.owner = owner

    --- Pixel coords.
    self.x = x or 0
    self.y = y or 0
end)

-- Not an updatable component by itself.



return Position
