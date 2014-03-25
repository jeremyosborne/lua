--[[

Lua has one collection: tables. Tables are associative arrays no
matter how they are used, but semantically they can function as
indexed arrays (base 1), dictionaries, and sets.

--]]

local eq = "equipment"

-- Tables are flexible and dynamic. Below is what you can
-- do with a table, not what you should do.
local t = {
    -- Table as indexed array. Lua uses 1 index.
    "hat",
    "leather jerkin",
    "winter scarf",
    "helicopter beanie",
    -- Table as key value, and the various ways of
    -- writing keys.
    name = "Player 1",
    ["class"] = "Digital Wizard",
    [42] = "The answer.",
    [eq] = { "goggles", "carebare stair", },
}

-- The standard ways of iterating tables, and what they provide.
print("Using ipairs...")
for i, v in ipairs(t) do
    print(i, v)
end

print("Using pairs...")
for k, v in pairs(t) do
    print(k, v)
end



-- So tables are collections in Lua, and we have already exercised
-- the associated table module.

-- Tables are dynamic.
t["mutation"] = "third eye"
print(t.mutation)
print(t["mutation"])

-- But even more important, tables have special powers and form
-- the core of all OOP type programming.
print("Before applying metamethods...")
print(t)

-- Lua uses prototypal inheritance and what they call metatables
-- and metamethods.
-- In all of the following methods, self is conveniently passed
-- in by the Lua interpreter. 
t = setmetatable(t, {
    -- Allow pretty printing of ourselves in a string situation.
    __tostring = function(self)
        return self.name
    end,
    -- Called when we attempt to concatenate this object.
    __concat = function(left, right)
        return tostring(left)..tostring(right)
    end,
    -- Called when we attempt to call this object.
    __call = function(self)
        return table.concat(self[eq], ", ")
    end,
    -- The index is powerful. It allows lookup of values
    -- that are not referenced directly on a table.
    __index = {
        -- And of course we can add our own, non-lua determined
        -- methods.
        inventory = function(self)
            inv = {}
            for _, item in ipairs(self) do
                table.insert(inv, item)
            end
            return table.concat(inv, ", ")
        end
    },
})

print("Using metamethods...")
print(t)
print("Hello "..t)
print("I am wearing:", t())
-- The colon below is a bit of syntactic sugar. It passes a self
-- reference in as the first argument.
-- It is the semantic equivalent of a literal call like so:
--
--     t.inventory(t)
--
print("I have the following inventory:", t:inventory())

