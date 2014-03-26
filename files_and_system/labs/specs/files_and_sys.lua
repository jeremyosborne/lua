--[[

Tests to accompany the ../src/files_and_sys.lua lab.

--]]

-- Test libraries.
require('luaspec.luaspec')

-- Source code to test.
require("files_and_sys")

-- In Luaspec, we run in a setfenv.
local require = require
local os = os
local print = print



describe["when calling writefile"] = function()
    local tmpname = os.tmpname()
    it["should return false and not write a file when given an empty table"] = function()
        local writestatus = writefile(tmpname, {})
        expect(writestatus).should_be(false)

        -- Sort of a cheater way to test for the non-existence of a file.
        local deletestatus, deleteerror = os.remove(tmpname)
        expect(deleteerror).should_be(nil)
    end
end



describe["when calling delta"] = function()
    it["It should return the expected string"] = function()
        expect(delta(0, 3670)).should_be("01.01.10")
    end
end
