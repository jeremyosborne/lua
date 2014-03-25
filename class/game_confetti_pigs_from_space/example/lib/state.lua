--[[

Simple states for use within our game.

--]]

local Class = require("lib.class")

local M = {}



local State = Class(function(self, id)
    self.id = id
end)
State.update = function(self, dt)
    -- Return truthy if done or passing a message.
    return nil
end
State.enter = function(self)
    -- No return value needed.
end
State.exit = function(self)
    -- No return value needed.
end
-- Export.
M.State = State



local StateManager = Class(function(self)
    -- Hash of states, keyed by id.
    self.states = {}
    -- Id of the current state.
    self.current = nil
end)
StateManager.add = function(self, state) 
    self.states[state.id] = state
end
StateManager.respond = function(self, action)
    if self.states[action] then
        -- clean up current state.
        if self.current then
            self.current:exit()
        end
        -- Switch to new state.
        self.current = self.states[action]
        self.current:enter()
    else
        -- Diagnostic
        log("Warning: unknown action passed to StateManager.change:", action)
    end
end
StateManager.update = function(self, dt)
    if self.current then
        local message = self.current:update(dt)
        if message then
            -- Need to handle message from state.
            self:respond(message)
        end
    end
end
M.StateManager = StateManager



return M
