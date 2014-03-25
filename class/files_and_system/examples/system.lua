--[[

Lua is a wonderful scripting language, but is in no way meant to be a
shell scripting language. There are just enough tools for when we
need to do things.

--]]


-- Lua doesn't have a sleep. This isn't 100% reliable for a long program,
-- but will be fine here.
-- Note: I've read this can wrap in extreme circumstances or long uptimes
-- but have never experienced it myself.
local sleep = function(s)
    local done = false
    local time = os.clock() + s
    repeat
        done = time < os.clock()
    until done
end



-- Working with dates.
-- Returns a locale specific date.
print("Program started at:", os.date())
-- And if you know strftime, which I don't
-- see: http://www.cplusplus.com/reference/ctime/strftime/
print("Date in a friendly format:", os.date("%Y-%m-%d %H.%M.%S"))
print("Uptime (in s):", os.clock())
print("Going to sleep for a bit...")
sleep(0.5)
print("Done sleeping.")
print("Uptime (in s):", os.clock())



-- What if we need a specific time?
-- The following creates a date object (table).
local today = os.date("*t")
print("Nicely formatted todays date.")
table.foreach(today, print)
-- What is the date ~3 years from now?
local year = 60*60*24*365
local todayInSeconds = os.time(today)
local future = os.date("*t", todayInSeconds+year)
print(("%d %02d %02d"):format(future.year, future.month, future.day))



-- Execute a system call.
print("Simple echo output.")
local retval = {os.execute("echo hello world")}
for i, out in ipairs(retval) do
    -- First output value is always the exit code.
    print(i, out)
end



print("Incorrect call.")
local retval = {os.execute("doesnotexist")}
for i, out in ipairs(retval) do
    -- First output value is always the exit code.
    print(i, out)
end



-- And if we can create files, good to be able to remove them.
print("Creating a test file and then deleting it.")
local f = io.open("test.txt", "w")
f:write("test\n")
f:close()
local retval = {os.remove("test.txt")}
for i, out in ipairs(retval) do
    -- First output value is always the exit code.
    print(i, out)
end



print("Entering infinite loop....")
while true do
    -- Kill our process with a specific exit number.
    os.exit(0)
end
