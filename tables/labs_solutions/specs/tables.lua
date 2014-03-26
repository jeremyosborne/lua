--[[

Tests to accompany the ../src/tables.lua lab.

--]]

-- Test libraries.
require('luaspec.luaspec')

-- Source code to test.
require("tables")

describe["when working with player table"] = function()
    it["should allow a call to :getname()"] = function()
        expect(player:getname()).should_be("Player 1")
    end
        
    it["should allow addition to the inventory with :pickup(item)"] = function()
        player:pickup("bread")
        player:pickup("cheese")
        expect(table.concat(player.inventory, " ")).should_be("bread cheese")
    end
    
    it["should provide a metatable method that :yell(speech) and returns name yells: %s"] = function()
        -- tricky...
        local yelled = player:yell("test")
        expect(yelled).should_be("Player 1 yells: test")
        
        expect(getmetatable(player).__index.yell == player.yell).should_be(true)
    end

    it["should return the name in a tostring()"] = function()
        expect(tostring(player)).should_be("Player 1")
    end
end



describe["when working with stackFactory"] = function()
    it["should return the length when the stack is called"] = function()
        local stack = stackFactory()
        expect(stack()).should_be(0)
        -- Should still behave like a table.
        table.insert(stack, "hello")
        expect(#stack).should_be(1)
        expect(stack()).should_be(1)
    end

    it["should append items to the table when push is called."] = function()
        local stack = stackFactory()
        stack:push("hello")
        stack:push("world")
        expect(stack()).should_be(2)
        expect(stack[2]).should_be("world")
    end

    it["it should pop the item from the end of the stack."] = function()
        local stack = stackFactory()
        stack:push("hello")
        stack:push("world")
        expect(stack()).should_be(2)
        expect(#stack).should_be(2)
        expect(stack:pop()).should_be("world")
        expect(stack:pop()).should_be("hello")
        expect(stack:pop()).should_be(nil)
    end
end
