--[[

Manages a set of event subscriptions and allows for explicit cleanup
of these events.

--]]


local Class = require("lib.class")



--- Manages an event register.
-- @param owner {Entity} Who owns this component.
local EventRegister = Class(function(self, owner)
    --- Which entity owns us?
    self.owner = owner

    --- Register of event ids. Required for cancelling a set of explicit
    -- events.
    self.register = {}
end)

--- Wrapper for event addition that remembers the event id for later
-- deletion.
-- (Same signature as the Events:sub).
EventRegister.sub = function(self, event, callback, caller)
    -- Remember the ID.
    table.insert(self.register, events:sub(event, callback, caller))
end

--- Unsubscribe events or classes of events.
-- @param [event] {string} Specific category to remove is so desired,
-- otherwise removes all events.
EventRegister.clear = function(self, event)
    local name = self.owner and self.owner.name or "unknown"
    if event then
        log(("%s: clearing events of type: %s"):format(name, event))
        events:clear(event)
    else
        for _, id in ipairs(self.register) do
            log(("%s: clearing event id: %s"):format(name, id))
            events:clear(nil, id)
        end
    end
end



return EventRegister
