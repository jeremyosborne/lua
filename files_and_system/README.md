Lua file and operating system
=============================
Lua is a scripting language, but is not a shell-scripting and system adminstration language.

* see: [OS library tutorial](http://lua-users.org/wiki/OsLibraryTutorial)
* see: [IO library tutorial](http://lua-users.org/wiki/IoLibraryTutorial)



OS library
----------
Limited to mainly handling dates and times, executing shell commands, and a few file helpers (tmp naming and file deletion).

```lua
-- Getting a date as a table.
local now = os.date('*t')
print(string.format("It is the %sth hour of the %sth day of the year %s", now.hour, now.yday, now.year))

-- Careful of case sensitivity on your system.
print("You appear to be USER named", os.getenv("USER"))
print("and your PATH is", os.getenv("PATH"))

print("If I wanted a tmp file, I could call it by the name of:", os.tmpname())
```



IO library
----------
Basic file I/O for Lua. Simple and elegant, and likely all that is needed for getting data in and out of an application.

```lua
-- Basic usage.
local path = os.tmpname() 
f = io.open(path, "w")

-- The colon is syntactic sugar for Lua objects.
f:write("Hello world!\n")
f:write("Hello world again!\n")

f:close()

print("Attemping to read the data from", path)
f = io.open(path, "r")

-- Iterate the file.
print("Reading the file line by line.")
for line in f:lines() do
    print(line)
end

-- File object as pointer.
print("File pointer located at the final byte of the file:", f:seek("cur"))
print("Rewinding the file pointer.")
f:seek("set", 0)

print("Slurping all the data out of the file as a string.")
local filedata = f:read("*a")
print("The data from the file:")
print(filedata)

print("Closing the file.")
f:close()
```
