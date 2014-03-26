Lua core
========
Lua is not a large language. It is a very concise language. It has a small number of reserved words, a small number of standard libraries, and can take a much shorter time to commit to memory compared to a lot of other languages.

* see: [Lua homepage](http://www.lua.org/)
* see: [Lua Wiki](http://lua-users.org/wiki/)
* see: [Lua Tutorials](http://lua-users.org/wiki/TutorialDirectory)
* see: [Lua Binaries and Installers](http://luabinaries.sourceforge.net/download.html)
* see: [Lua 5.1 reference](http://www.lua.org/manual/5.1/)


Requirements
------------
It is assumed at this point that you have Lua installed and available from the commandline before proceeding. The examples are based around Lua 5.1. You sould be able to run:
    
    lua -v

and see something like:

    Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio

Anything in the 5.1.x range should be good.



Reserved words
--------------
Lua has very few reserved words. They are:

    and       break     do        else      elseif
    end       false     for       function  if
    in        local     nil       not       or
    repeat    return    then      true      until
    while



Comments
--------
Comments are ignored by the Lua interpreter.

```lua
-- Single line comment.

--- Convention, not requirement, for starting a comment block describing
-- a function, parameters, and return values.
function doSomething()
    -- TODO: something
end

--[[
    Technically a multiline comment...
]]

--[[
    ...although this is the convention you will see and that will be used
    in this code for multiline comments because....
--]]

-- ...while debugging, adding a third dash to the comment close will
-- activate the code.
--[[
    -- Debug stuff...
    print("The value of n is %s" % n)
---]]
```



Datatypes
----------
Lua has a handful of included datatypes:

    number
    string
    boolean
    nil
    function
    table
    thread
    userdata

Some examples of the immediately usable datatypes follow. The `userdate` and `thread` datatypes will be examined elsewhere. 



### number
Any number, whether floating point or integer, belongs to the same type in Lua.

```lua
x = 1
y = 2.1
print(x + y)
print("Type of x", type(x) )
print("Type of y", type(y) )

-- Careful. As a comparison to other languages, 0 passes a truth check.
-- This happens for historical reasons. For truth and false checks,
-- make sure you are testing for nil or false.
local x = 0
if x then
    print("zero has passed a truth check (what you should see in Lua)")
else
    print("zero is falsey (in other languages, but not in Lua)")
end
```



### string
Strings are just lines of text in Lua. They do not do variable/token replacement automagically (unless the string is being enacted on by a method like `string.format`). There are multiple ways of writing strings:

```lua
s = "A single line string."
print(s)
print("Type of s", type(s))

s2 = 'Also a single line string.'
print(s2)
print("Type of s2", type(s2))

s3 = [[A
multi-line
string.]]
print(s3)
print("Type of s3", type(s3))

s4 = 'String respects \n escape \n sequences.'
print(s4)
s5 = [[Bracked strings \n are \n more literal.]]
print(s5)

s6 = [===[Bracketed string [[with brackets]]. Yay!]===]
print(s6)
```



### boolean
A relatively new datatype to Lua, although a common datatype in most modern languages. Works as we'd expect.

```lua
-- This will produce true.
print("1 equals 1 is", 1 == 1)

-- Detecting a boolean type.
local f = false
print("type of boolean is boolean:", type(f))

-- Not actually true.
print("does true equal one?", true == 1)

-- Not true, either.
print("does false equal zero?", false == 0)

-- Also not true.
print("does false equal nil?", false == nil)

-- The following will work as expected.
local x = false
if x then
    print("false passes a truth check")
else
    print("false fails a truth check (this is the right answer)")
end
```



### nil
The null, or nothing value is `nil`. It's the default value for uninitialized or undefined variables.

```lua
-- Testing types.
print("the type of nil is nil", type(nil))

-- Before we declare the variable.
print("the value of x is nil", x)

-- Before we define the variable.
local x
print("the value of x is still nil", x)

-- After we define the variable.
x = 42
print("the value of x is no longer nil", x)

-- The value of some tests.
print("nil == false is false (different types)", nil == false)
print("nil == 0 is false (different types)", nil == 0)
print("nil == nil is true", nil == nil)
```



### function
Functions are first class objects in Lua, which means they can be assigned to variables, passed around, and even written inside of other functions. Unlike some languages, like JavaScript and Python, functions are still more subroutines than objects and you don't go around attaching properties to them. If you need a verstile datatype that does everything, see the `table` type.

```lua
-- One way to write a simple function...
function f()
    print("hello function")
end
-- ...and to call that function.
f()

-- Another, and equivalent way, to write the same function (although
-- using a different identifier.
g = function()
    print("hello function")
end
-- ... and we call that function the same way.
g()

-- Function with a single argument and a return value.
local x = function(f)
    return f + 1
end
print("the value of x(2) should be 3:", x(2))

print("the type of a function is function", type(x))

-- Functions can take variable arguments and can return multiple values.
local multi = function(x, ...)
    print("the value of x is", x)
    print("the value of everything else...")
    for n=1, select('#', ...) do
        print(string.format("The value of the %dth optional argument is %s", n, select(n,...)))
    end
    -- Hand back everything.
    return x, ...
end
-- Catch all of the return values. Don't need to catch any values you
-- don't want to.
local x, y, z = multi(1, 2, 3)
print("The value of x is", x)
print("The value of y is", y)
print("The value of z is", z)
```



### table
The ultimate datatype in Lua, as well as the only default collection type. The table type provides indexed arrays, associative (key=value) arrays, and OOP through prototypal inheritance.

```lua
-- A simple table as an array, with mixed values.
t = { "donut", 42, false }

-- Indexing is 1s based.
print("The value of the first index should be 'donut':", t[1])

-- Length of an array-like table.
print("The length of the table should be 3:", #t)

-- Iterating a simple table as an array in Lua.
for i, value in ipairs(t) do
    print(string.format("At index %s the value is %s", i, tostring(value)))
end



-- A simple table as an associative array, also using a key that isn't
-- allowed by default (so we put it in square brackets).
t2 = { arnold="terminator", [42]="42" }
print("The value of t2['arnold'] should be 'terminator'", t2['arnold'])

-- ... below because the identifier arnold is nil, and nil points to nil.
print("The value of t2[arnold] should be nil", t2[arnold])
print("The value of t2[42] should be '42'", t2[42])
print("The value of t2['42'] should also be '42'", t2[42])

-- Only the indexed values contribute to length, key=value pairs do not.
print("The indexed length of our associative array should be 0:", #t2)

-- Basic way of iterating an associative array.
for key, value in pairs(t2) do
    print(string.format("At key %s the value is %s", tostring(key), tostring(value)))
end
```



Flow of control
---------------
Flow of control is very C-like.

```lua
-- The name.
local name = "test"

-- If, elseif, else blocks.
print("Testing the type of our variable name.")
if type(name) == "number" then
    print(name, "is a number")
elseif type(name) == "string" then
    print(name, "is a string, as expected")
else
    print(name, "[infamous should not get here statement]")
end

-- Basic for loop: initial value, end value, step value.
print("Iterating math.pi by 0.5 increments")
for i = 0, math.pi, 0.5 do
    print(i)
end

-- A do end block, which creates scope.
do
    local name = "42"
    print("Your name is:", name)
end
print("Outside of the do block, your name is:", name)

-- While block. Repeats until false, or we break.
while true do
    print("Will print once from a while loop:", name)
    break
end

-- Repeat block. Repeats until true, or we break.
repeat
    print("Will print your name once from a repeat block:", name)
until true

-- Lua doesn't exactly have a ternary.
local converted = tonumber(name) and name or "not a number"
print("Value of your name after passed to tonumber() is:", converted)
```



Variables and identifiers
-------------------------
Variables and identifiers in Lua are dynamically typed according to their underlying data. Variables are also scoped, and are global by default.

```lua
-- Variables are global by default.
x = "global"

do
    -- Local value of a variable.
    local y = "local"
    print("The value of x should be 'global':", x)
    print("The value of y should be 'local':", y)
end

print("The value of x should be 'global':", x)
print("The value of y should be nil:", y)

do
    local x = "the local x"
    print("The value of x should be 'the local x':", x)
    -- Global values are stored in a global dictionary. We can explicitly 
    -- reference global variables.
    print("The value of _G.x should be 'global':", _G.x)
end

print("The type of _G should be 'table'", type(_G))
```

