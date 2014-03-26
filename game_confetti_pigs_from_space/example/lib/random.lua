--[[

Random functions.

--]]



-- Module
local M = {}



--- Randomize + or - signage.
local randsign = function()
    if math.random() > 0.5 then
        return -1
    else
        return 1
    end
end
-- Export
M.randsign = randsign



--- Randomize an edge of a box.
local randrectside = function(width, height)
    -- Which side will the target enter from?
    local side = math.random(0, 3)
    -- Descriptor for suggested location.
    local descriptor

    if side == 0 then
        -- top, heading down
        descriptor = {
            x = width/2 + 
                randsign()*math.random(width/4),
            y = 0,
            side = side,
        }
    elseif side == 1 then
        -- right, heading left
        descriptor = {
            x = width,
            y = height/2 + 
                randsign()*math.random(height/4),
            side = side,
        }
    elseif side == 2 then
        -- bottom, heading up
        descriptor = {
            x = width/2 + 
                randsign()*math.random(width/4),
            y = height,
            side = side,
        }
    else
        -- left, heading right
        descriptor = {
            x = 0,
            y = height/2 + 
                randsign()*math.random(height/4),
            side = side,
        }
    end
    
    return descriptor
end
-- Export.
M.randrectside = randrectside



-- Export
return M
