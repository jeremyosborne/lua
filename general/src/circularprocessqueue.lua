--[[

    Queue up a table of functions for running.

--]]

-- Prototype for our class.
local prototype = {
    --- Which process index are we on?
    _callIndex = 1,
    
    --- Get or set our index.
    -- @param [i] {number} If not passed, we return the current index.
    -- If a number is passed, we set the call index to that number.
    index = function(self, i)
        -- In the case that we attemt to set the index prior to adding
        -- anything to the queue, allow an index of 1.
        local upperbound = #self == 0 and 1 or #self
        
        if type(i) == "number" and i >= 1 and i <= upperbound then
            -- setter
            self._callIndex = i
            return
        elseif i == nil then
            -- getter
            return self._callIndex
        else
            error("Invalid index: "..tostring(i))
        end
    end,
    
    --- Convenience method for table.insert(q, 1, f).
    -- @param f {function} Function to be placed at the front of the queue. 
    unshift = function(self, f)
        if type(f) == "function" then
            table.insert(self, 1, f)
        end
    end,
    
    --- Convenience method for table.insert(q, f).
    -- @param f {function} Function to be appended to the queue.
    append = function(self, f)
        if type(f) == "function" then
            table.insert(self, f)
        end
    end,
}

-- What happens when we call our table.
local call = function(self, ...)
    -- If not empty...
    if #self then
        -- ...assume that we will have at least one function in the queue.
        local isDone = self[self._callIndex](unpack(arg))
        if isDone then
            self._callIndex = self._callIndex + 1
            if self._callIndex > #self then
                self._callIndex = 1
            end
        end
    end
end


--- @class An organized and continuous process queue.
-- Create a queue and add functions to the queue.
-- Call the queue to invoke the next function process.
-- Functions acting as processes should return false if they are not
-- done, and they will be called again.
-- Functions acting as processes should return true if they are
-- done. The next function will be called.
-- If the last function in the queue returns true, the first function
-- in the queue will be called next.
local CircularProcessQueue = function()
    return setmetatable({}, {
        -- Class prototype.
        __index = prototype,
        __call = call,
    })
end



-- Export just the class.
return CircularProcessQueue
