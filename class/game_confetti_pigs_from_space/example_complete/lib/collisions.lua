--[[

Simple collision detection routines.

--]]

local M = {}



--- A simple circle collision test between entities.
-- A collision is true if any part of the circles, even a single point, 
-- overlap in space.
-- @param ax {number} Center x of first entity.
-- @param ay {number} Center y of first entity.
-- @param ar {number} Radius of first entity.
-- @param bx {number} Center x of second entity.
-- @param by {number} Center y of second entity.
-- @param br {number} Radius of second entity.
-- @return {boolean} true if collision, false if not.
local circle = function(ax, ay, ar, bx, by, br)
    return (ax - bx)^2 + (ay - by)^2 <= (ar + br)^2;
end
-- Export
M.circle = circle



return M
