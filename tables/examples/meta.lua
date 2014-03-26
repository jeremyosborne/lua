--[[

Closer look at the workings of tables, metatables, and metamethods.

--]]

-- Start again with our player object.
local player = {
    name = "Player 1",
    class = "Digital Wizard",
    equipment = { "goggles", "carebare stair", },
}
-- Include an adversary table.
local adversary = {
    name = "Mullog",
    class = "Scruffy thing",
    type = "mob",
    equipment = { "precious", "dirty rags", },
}



-- Tables fill the role of objects, data types, and data structures. 
-- They're also dynamic. Let's add a method.
player.rename = function(self, name)
    self.name = name
end

-- Usage in the literal sense:
player.rename(player, "Player 2")
print("Renamed to:", player.name)
-- Usage with the syntactic method sugar:
player:rename("Player 42")
print("Renamed to:", player.name)



-- What is a metatable? Do tables already have them? (Should be nil.)
print("Metatable for our player:", getmetatable(player))



-- We saw the __tostring metamethod previously.
-- Do metamethods work when added directly to a table?
function player:__tostring()
    return self.name
end


-- Try:
print("Player:", player)
-- Do a literal call to make sure it works.
print("Player:", player:__tostring())



-- Before continuing, please remove the literal __tostring on player.
player.__tostring = nil

-- A table that designed to be a metatable (e.g. object prototype or 
-- template) for our existing entities.
local entitymt = {
    -- Copy and paste the __tostring method here:
    __tostring = function(self)
        return self.name
    end,
    -- The __index allows us to add shared instance methods in the OO 
    -- paradigm.
    __index = {
        -- If the metatable owner does not have a property, properties
        -- are looked up in the __index before returning nil.
        type = "entity",
        -- Make a simple method that drops an item of equipment.
        drop = function(self)
            local n = #self.equipment
            if n then
                return table.remove(self.equipment, math.random(n))
            end
        end    
    },
}

-- Metatables are applied to tables via a call to setmetatable.
-- Metamethods located on metatables automagically work.
setmetatable(player, entitymt)
setmetatable(adversary, entitymt)
-- The tostring method will work automagically.
print("Player:", player, "vs. Adversary:", adversary)
-- Try out:
print("Player drops:", player:drop())
print("Adversary drops:", adversary:drop())
-- Local overrides metatable prototype.
print("Player type:", player.type)
print("Adversary type:", adversary.type)

-- Note: Cannot directly call metamethods in the usual way.
-- We use a protected call because the following will produce errors.
print( pcall(function() print(player:__tostring()) end) )

-- Safer diagnostic tests.
print("Does __tostring exist?", player.__tostring)
print("does player now have a metatable?", getmetatable(player))
print("Does the metatable have __tostring?", getmetatable(player).__tostring)
print("Can we call it?", getmetatable(player).__tostring(player))

