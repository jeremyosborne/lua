--[[

Basic interface for entities in our game.

--]]

local Class = require("lib.class")



--- Equivalent to an abstract class.
local Entity = Class()

-- Base classes should duck type themselves.
Entity.name = "entity"

-- RESERVED: Hash for components.
Entity.components = nil

--- Adds a component to the entity.
-- @param component {string} The name of the component to add.
-- @param ... {mixed} Optional arguments to pass to the component.
Entity.addComponent = function(self, component, ...)
    if not self.components then
        self.components = {}
    end
    if not self.components[component] then
        -- Load and construct all at once.
        self.components[component] = require("components."..component)(self, ...)
    else
        log("WARNING: Not replacing existing component "..component.." on "..self.name)
    end
end

--- Tests for existence of a component on the entity.
-- @param component {string} The name of the component.
-- @return {boolean} true if entity has the component, false if not.
Entity.hasComponent = function(self, component)
    return not not self.components[component]
end

--- Updates the components on an entity if they are meant to be updated.
-- @param dt {number} Delta number of seconds passed since last call.
Entity.update = function(self, dt)
    for _, c in pairs(self.components) do
        if c.update then
            c:update(dt)
        end
    end
    -- Will be nil if the entity does not implement.
    return self.updateResponse
end

--- All entities must implement their own draw function should they
-- wish to draw themselves.
Entity.draw = function(self)
    -- do things...
end



return Entity
