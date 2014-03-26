--[[

A simple pub/sub system to generalize and centralize message dispatch.

--]]

-- We need some class constructor.
local Class = require("class").Class



-- Module.
local M = {}



-- Simple identification for each event.
local eventId = 0
local nextId = function()
    eventId = eventId + 1
    return eventId
end

--- Event objects associate callers with callbacks.
-- @param callback {function} The callback function. Passed caller (as
-- first arg, if supplied), followed by any additional arguments during
-- the event.
-- @param caller {mixed} If supplied, this will be passed as the
-- first argument of callback (as the assumed "self" argument).
local Event = Class(function(self, callback, caller)
    self.id = nextId()
    self.callback = callback
    self.caller = caller
end)

--- Triggers the event.
Event.pub = function(self, ...)
    if self.caller then
        self.callback(self.caller, ...)
    else
        self.callback(...)
    end
end

-- Export, in case something else wants to use the event object.
M.Event = Event



--- Construct an event publisher that can be subscribed to.
local Events = Class(function(self)
    -- Hashed container for named events.
    -- A keyed set of tables.
    self.listeners = {}
end)

--- Add a listener to an event.
-- @param event {string} Name of the event.
-- @param callback {function} Function to call when event is triggered.
-- @param [caller] {mixed} If provided and is truthy, will be passed
-- as the first argument to callback (assuming OO self paradigm).
-- @return {number} Event subscription id. Used to remove the subscription.
Events.sub = function(self, event, callback, caller)
    local eobj = Event(callback, caller)

    if not self.listeners[event] then
        self.listeners[event] = {}
    end
    -- Order of execution not guaranteed.
    self.listeners[event][eobj.id] = eobj

    return eobj.id
end

--- Trigger an event.
-- @param event {string} Name of the event to trigger.
-- @param ... {mixed} Arguments to pass to the event callbacks.
Events.pub = function(self, event, ...)
    if self.listeners[event] then
        for _, eobj in pairs(self.listeners[event]) do
            eobj:pub(...)
        end
    end
end

--- Clear a particular listener from a particular event, or clear all
-- listeners from a particular event.
-- @param [event] {string} Name of the event to clear. If this is provided
-- and not id is provided, all listeners for this particular event will
-- be cleared.
-- @param [id] {number} The event id to clear from this list. If this
-- is provided and the event param is not provided all event groups will
-- be searched through and the listener will be removed from the group.
-- Note: the id must still be the second or third argument depending
-- on how this is called.
Events.clear = function(self, event, id)
    if self.listeners[event] and not id then
        self.listeners[event] = nil
    elseif self.listeners[event] and id then
        self.listeners[event][id] = nil
    elseif not event and id then
        for _, eventgroup in pairs(self.listeners) do
            if eventgroup[id] then
                eventgroup[id] = nil
                break
            end
        end
    end
end

-- Export.
M.Events = Events



-- Export.
return M
