--[[

Lab based around working with files and the os (as much as Lua can).

There are tests, called specs in the Behavior Driven Development (BDD)
world, that are prewritten.

To run the tests, run the command:

    lua luaspec specs/files_and_sys.lua

The lab is done when the tests pass.

NOTE: Please make all functions global, not local, as the tests expect
globally available functions.

--]]



--- Build a function that takes a file name and a table-array and writes
-- all elements of the table to the file. Assume the lines written to
-- the file need an appended newline.
-- @param filepath {string} File path.
-- @param lines {table} Indexable list of strings to be written to the
-- file. File will only be created if lines contains at least 1 enumerable
-- element.
-- @return {boolean} Return true if everything (seems to) have worked,
-- return false if there was some sort of write error or if lines
-- does not create any lines (and don't create the file, either).
writefile = function(filepath, lines)
    if #lines > 0 then
        local f, e = io.open(filepath, "w")
        if f and not e then
            f:write(table.concat(lines, "\n"))
            return true
        end
    end

    return false
end



--- Build a function that takes two Lua times (in seconds) and returns
-- a human friendly elapsed time.
-- @param t1 {number} Earlier date as seconds since the epoch.
-- @param t2 {number} Later date as seconds since the epoch.
-- @return {string} The elapsed time, expressed as a string, between
-- t1 and t2. The string should have the equivalent format of:
-- "%H.%M.%S" time elapsed.
delta = function(t1, t2)
    local diff = os.difftime(t2, t1)
    local sPerMinute = 60
    local sPerHour = sPerMinute * 60
    
    local hours = math.floor(diff/sPerHour)
    local minutes = math.floor((diff-hours*sPerHour)/sPerMinute)
    local seconds = diff % 60
    return string.format("%02d.%02d.%02d", hours, minutes, seconds)
end


