--[[

Tests to accompany the ../src/basics.lua lab.

--]]


-- Test libraries.
require('luaspec.luaspec')

-- Source code to test.
require("core")



describe["when calling caps"] = function()
    it["should return a capitalized string"] = function()
        local test = "hello world"
        expect(caps(test)).should_be(test:upper())
    end
end



describe["when calling listWords"] = function()
    local test = "hello world, and universe!"

    it["should return a table"] = function()
        expect(type(listWords(test))).should_be("table")
    end

    it["should return the expected number of words"] = function() 
        expect(#listWords(test)).should_be(4)
    end

end 



describe["when calling listWordsReverse"] = function()
    local test = "hello world, and universe!"

    it["should return a table"] = function()
        expect(type(listWordsReverse(test))).should_be("table")
    end

    it["should return the expected number of words"] = function() 
        expect(#listWordsReverse(test)).should_be(4)
    end

    it["should return the words as a reversed list"] = function()
        local expectedResults = { "universe!", "and", "world,", "hello" }
        local results = listWordsReverse(test)
        for i, word in ipairs(results) do
            expect(word).should_be(expectedResults[i])
        end
    end
    
    it["should return nil for non-string arguments"] = function()
        expect(listWordsReverse(42)).should_be(nil)
        expect(listWordsReverse({})).should_be(nil)
        expect(listWordsReverse(true)).should_be(nil)
    end
end 



describe["when calling mapWords"] = function()
    local test = "hello world, and universe!"

    it["should return a table"] = function()
        local results = mapWords(test, function(...) return 1 end)
        expect(type(results)).should_be("table")
    end

    it["should return the expected number of words"] = function() 
        local results = mapWords(test, function(...) return 1 end)
        expect(#results).should_be(4)
    end

    it["should return the results of the function"] = function()
        local results = mapWords(test, function(...) return 1 end)
        for _, item in ipairs(results) do
            expect(item).should_be(1)
        end    
    end

    it["should return the results of the function part 2"] = function()
        local expected = listWords(test)
        local results = mapWords(test, function(...) return select(1, ...) end)
        for i, item in ipairs(results) do
            expect(item).should_be(expected[i])
        end    
    end
    
end



describe["when calling incrementor"] = function()
    it["should return a number, and the first call is 1"] = function()
        expect(incrementor()).should_be(1)
    end
    
    it["should return the same number when called as a setter"] = function()
        expect(incrementor(0)).should_be(0)
    end

    it["should return a linear progression of numbers"] = function()
        expect(incrementor()).should_be(1)
        expect(incrementor()).should_be(2)
        expect(incrementor()).should_be(3)
        expect(incrementor()).should_be(4)
    end
    
    it["should not expose counter"] = function()
        expect(_G.counter).should_be(nil)
    end
    
end
