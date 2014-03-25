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



-- Export
return M
