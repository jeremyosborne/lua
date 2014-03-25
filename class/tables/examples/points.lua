--[[

Testing out our Class constructor.

--]]



-- Using the module pattern, we don't dump things into the global
-- environment, and we can catch things returned from the module.
local Class = require("class")



--- Build a 2d point class that can be used to construct other points.
-- We receive our instance reference from our callback. Consumers of
-- Point2 will only pass in 2 arguments.
local Point2 = Class(function(self, x, y)
    self.x = x or 100
    if y then
        self.y = y
    end
    -- We do not need to return our instance here. It is returned
    -- by the class management code.
end, {
    -- Prototype settings. The advantage of using prototypal inheritence
    -- is that the memory can be shared by all. Note that primitives
    -- like this are shared only until they are changed on the
    -- instance.
    y = 200,
})
-- Instead of a metamethod, we'll implement a callable tostring method.
-- The colon syntax for calling and the syntax for implementing work the
-- same. Lua implicitly substitutes "self" as the self reference variable.
function Point2:tostring()
    return ("%s %s"):format(self.x, self.y)
end



-- TEST
-- Build some objects and test out our class.
local p1 = Point2()
local p2 = Point2(300)
local p3 = Point2(4, 2)
-- We can call methods explicitly...
print("p1", p1.tostring(p1))
-- ...but methods are usually easier to call with the colon syntax.
print("p2", p2:tostring())
print("p3", p3:tostring())



-- Build a Point3 object that inherits from Point2.
local Point3 = Class(function(self, x, y, z)
    -- If we want to use the constructor, we can call explicitly.
    self.super()._constructor(self, x, y)
    -- Implement our own point functionality.
    self.z = z or 999
    
    -- Inherit from our baseclass.    
end, Point2)
-- Implement our own tostring method, this time writing it explicitly.
Point3.tostring = function(self)
    -- Use our parent method, and then append our z index.
    return (self.super().tostring(self))..(" %s"):format(self.z)
end



-- TEST :)
local p4 = Point3(1, 2, 3)
print("p4", p4:tostring())
