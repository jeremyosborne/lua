--[[
    
Class Tests.

--]]

-- Fix our test path.
package.path = "../src/?.lua;"..package.path

-- Controllable logger.
local log = function(...)
    print(...)
end

-- Assume association with src directory.
local Class = require("class").Class

-- Name of package being tested.
local testSuiteName = "Class"


log("\nBEGIN TESTS:", testSuiteName, "\n")
local tests = {
    
    ["sanity"] = function()
        local TestClass = Class()
        assert(type(TestClass) == "table", "Class is a table.")
        
        local instance = TestClass()
        assert(type(instance) == "table", "Instance is also a table.")
    end,
    
    ["initialization and basic oo expectations"] = function()
        local Point = Class(function(self, x, y)
            self.x = x
            self.y = y
        end)
        Point.x = 42
        Point.y = 24
        Point.coords = function(self)
            return self.x, self.y
        end
        
        local p = Point()
        assert(p.x == 42, "Expected default x")
        assert(p.y == 24, "Expected default y")
        local coordx, coordy = p:coords()
        assert(coordx == 42, "Expected coordinate x")
        assert(coordy == 24, "Expected coordinate y")
        
        local p2 = Point(2, 4)
        assert(p2.x == 2, "Expected default x")
        assert(p2.y == 4, "Expected default y")
        coordx, coordy = p2:coords()
        assert(coordx == 2, "Expected coordinate x")
        assert(coordy == 4, "Expected coordinate y")
    end,
    
    ["basic inheritance"] = function()
        local Point = Class(function(self, x, y)
            self.x = x
            self.y = y
        end)
    
        local Point3 = Class(function(self, x, y, z)
            self:super()._constructor(self, x, y)
            self.z = z
        end, Point)
        Point3.z = 4242
        Point3.coords = function(self)
            return self.x, self.y, self.z
        end
        
        local p = Point3(1, 2, 3)
        assert(p.x == 1, "Expected default x")
        assert(p.y == 2, "Expected default y")        
        assert(p.z == 3, "Expected default z")
    end,
    
    ["metamethods"] = function()
        local Point = Class(function(self, x, y)
            self.x = x
            self.y = y
        end)
        Point.__tostring = function(self)
            return ("%d %d"):format(self.x, self.y)
        end
        
        local p = Point(24, 42)
        assert(tostring(p) == "24 42", "Basic metamethod works.")
        
        local Point3 = Class(function(self, x, y, z)
            self:super()._constructor(self, x, y)
            self.z = z
        end, Point)
        local p3 = Point(1, 2, 3)
        -- Inherited method should only return x and y.
        assert(tostring(p3) == "1 2", "Metamethod inheritence works.")
    end,
}

for testName, test in pairs(tests) do
    local outputMessage = "%s "..testName
    local teststatus, error = pcall(test)
    if teststatus then
        log(outputMessage:format("[PASS]"))
    else
        log(outputMessage:format("[FAIL]"))
        log(error)
    end
end
log("\nEND TESTS:", testSuiteName, "\n")
