--[[

Represents the radius of this entity.

--]]


local Class = require("lib.class")



--- Allow an entity to express its size as a radius.
-- @param owner {Entity} Who owns this component.
-- @param radius {number} How many pixels is the radius.
-- @param [initialRadius] {number} If provided, this is the initial radius
-- of the entity.
local Radius = Class(function(self, owner, radius, initialRadius)
    --- Which entity owns us?
    self.owner = owner
    --- Deals with changing radius.
    self.maxRadius = radius
    --- Current radius size.
    self.radius = initialRadius or radius
end)

--- If the radius changes over time, implement this function.
-- @param delta {number} Time passed since last call.
Radius.update = function(self, delta)
    -- noop, implement to modify radius.
end



return Radius
