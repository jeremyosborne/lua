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

-- Game settings.
settings.game = {
    -- How long is the game (in seconds).
    gameLength = 60,
    -- How long do explosions last on the screen (in seconds).
    explosionLifetime = 2,
    -- Min speed for pigs (pixels per second).
    pigMinSpeed = 50,
    -- Max speed for pigs (pixels per seconds).
    pigMaxSpeed = 250,
    -- 1 in this chance per frame of a pig appearing.
    pigSpawnChance = 15,
}

-- Image assets.
settings.images = {
    pig = love.graphics.newImage("images/pig.png"),
}

-- Audio assets.
settings.audio = {
    bgm = love.audio.newSource(love.sound.newSoundData("audio/bgm.ogg")),
    explosion = love.audio.newSource(love.sound.newSoundData("audio/explosion.ogg")),
    pigexplosion = love.audio.newSource(love.sound.newSoundData("audio/pigexplosion.ogg")),
}


return settings
