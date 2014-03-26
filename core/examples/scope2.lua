--[[

Run this file after working on scope.lua.

--]]

print("What is the value of favoriteColor?", favoriteColor)

print("The global table _G accessing favoriteColor", _G.favoriteColor)

-- Require as a way of running and importing other files.
require("scope")

-- Other print statements will be output....

print("What is the value of favoriteColor after require?", favoriteColor)

print("The global table _G accessing favoriteColor", _G.favoriteColor)

print("What is the global _G table?", _G)

print("Does _G point to itself?", _G._G and true or false)

print("What folders do we look in when we require?", package.path)
