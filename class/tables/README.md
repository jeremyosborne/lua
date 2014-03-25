Tables
======
A table in Lua is a catch all object that is amazingly versatile. To take full advantage of Lua as a programming language, we must thoroughly understand tables.

* see: [Tables as collections tutorial](http://lua-users.org/wiki/TablesTutorial)
* see: [Metamethods and metatables](http://lua-users.org/wiki/MetamethodsTutorial)
* see: [Object-oriented programming in Lua](http://lua-users.org/wiki/ObjectOrientationTutorial)
    * see: [Another OOP tutorial](http://lua-users.org/wiki/InheritanceTutorial)



Tables as collections
---------------------
The table datatype is normally used as a collection. As a collection it can function as an indexed array, an associative array, and a set out of the box.

```lua
-- Simple table.
local t = {}

-- Inserting some elements into the table, a "push" is assumed.
table.insert(t, "hello")
table.insert(t, "world")

-- Inserting into the first index.
table.insert(t, 1, "universe")

print("Iterating an indexed table.")
for i, value in ipairs(t) do
    print(i, value)
end

print("Popping the last value of the table, which is:", table.remove(t))

print("Popping the first value of the table, which is:", table.remove(t, 1))

print("How long is the table?", #t)

print(string.format("The element at t[1], aka. 'you had me at %s'", t[1]))

print("Emptying out the last element of the table, which is:", table.remove(t))

-- As an associative array.
t["test"] = "yes"
t[42] = "hi there"
print("Table as an associative array has length:", #t)

print("Iterating the table as an associative array.")
for key, value in pairs(t) do
    print(key, value)
end

-- As a set.
s = {}
s["chainmail"] = true
s["sword"] = true

-- One way to check.
if s["chainmail"] then
    print("We've got some chainmail.")
end

if s["longsword"] then
    print("We shouldn't have a longsword, we only have a sword.")
else
    print("We don't have a longsword.")
end

-- Another way to check.
local does_have = s["sword"] and "yes we do have a sword" or "no, a rustmonster must have eaten the sword"
print(does_have)
```



Tables as objects
-----------------
Expanding on the notion of tables as associative arrays, tables can act as abstract data types.

```lua
--- Simple factory method that produces some objects.
local cakeFactory = function()
    return {
        name = "cake",
        isReal = false,
        typeOfCake = function(self)
            if self.isReal then
                return "Yes this is a cake."
            else
                return "The cake is a lie."
            end
        end
    }
end

print("Making our first cake.")
c = cakeFactory()
print( c:typeOfCake() )
-- which is equivalent to.
print( c.typeOfCake(c) )

print("Making another cake.")
c2 = cakeFactory()
-- Objects are dynamic.
c2.isReal = true
print("c2 type:", c2:typeOfCake())
print("c type:", c:typeOfCake())
```



Metatables and "magic" metamethods
----------------------------------
Metatables, which provide prototypal inheritance, provide the mechanism for object-oriented programming in Lua.

```lua
-- A literal table.
local m = {
    -- __index is the identifier of a magic method
    __index = {
        test = "hello"
    }
}

-- When a table is not acting as a meta table, all declarations are literal.
print("Value of test on m is nil:", m.test)
print("Value of test on m.__index.test", m.__index.test)

-- However, when we take a table, and set a meta table for it, Lua will
-- make use of any magic properties and methods.
local obj = {}
setmetatable(obj, m)
print("The value of test on obj should be 'hello':", obj.test)

-- m acts as the class definition for obj.
if pcall(obj) then
    print("obj is callable.")
else
    print("by default, obj is not callable")
end

-- Set the magic __call property on our metatable to make obj callable.
m.__call = function(self)
    return "The length of the table is: "..tostring(#self)
end

print(obj())
table.insert(obj, "ration")
print(obj())

-- Tables are still tables...
print("Iterating our table.")
for i, value in ipairs(obj) do
    print(i, value)
end
```
