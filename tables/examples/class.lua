--[[

Simple class builder.

--]]



--- Class constructor.
-- @param [constructor] {function} Optional constructor. Passed instance
-- reference followed by any arguments.
-- @param [baseClass] {table} A parent class. Inheritance set 
-- prototypically.
-- @return {table} A callable table will be returned, one that can
-- be used to construct instances of this class.
local Class = function(constructor, baseClass)

    -- Constructor is always callable.
    constructor = constructor or function(self) end
    -- Normalize our baseClass.
    baseClass = baseClass or {}
    
    -- Classes themselves are tables in Lua.
    local class = {
        -- Keep a reference to our constructor.
        _constructor = constructor,
        -- Lua has no concept of super, so we make one up.
        super = function()
            return baseClass
        end,
    }
    -- Our class is it's own prototype. This allows us to add
    -- methods to our class after construction.
    class.__index = class
    
    -- Construct our class...
    setmetatable(class, { 
        -- We inherit anything we don't supply from our baseClass...
        __index = baseClass,
        
        -- When we call our class table, we construct an instance.
        __call = function(_, ...)
            -- This is our instance...
            local inst = {}
            -- ...that inherits all methods on our class...
            setmetatable(inst, class)
            -- ...that can initialize itself...
            constructor(inst, ...)
            -- ... we make our instance available to the program...
            return inst
        end,
    })

    -- Return the class itself to our application for use.
    return class
end



-- Export the class
return Class

