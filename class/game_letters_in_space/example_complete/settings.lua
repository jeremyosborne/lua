--[[

Some general settings packed into a Lua table.

--]]



-- Debug mode. Purposely global. Mainly for log statements.
DEBUG = true



-- Hash of settings.
local settings = {}

-- Fonts and text
settings.mainFontSize = 20
-- Assume file is required within a love program.
settings.mainFont = love.graphics.newFont(settings.mainFontSize)

-- Audio assets.
settings.audio = {
    bgm = love.audio.newSource(love.sound.newSoundData("audio/bgm.ogg")),
    letter = love.audio.newSource(love.sound.newSoundData("audio/explosion.ogg")),
}


return settings
