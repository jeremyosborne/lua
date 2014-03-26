--[[

Audio player entity.

--]]



local Class = require("lib.class")
local Entity = require("entities.entity")

local settings = require("settings")



--- Create the audio player.
local Audio = Class(function(self)
    
    -- Score changes via game events.
    self:addComponent("eventregister")
    self.components.eventregister:sub("missilelaunchdetected", self.onmissilelaunchdetected, self)
    self.components.eventregister:sub("pigexplosion", self.onpigexplosion, self)
    self.components.eventregister:sub("gamestart", self.ongamestart, self)
    self.components.eventregister:sub("gamestop", self.ongamestop, self)
        
end, Entity)

--- Ducktype.
Audio.name = "audio"

Audio.ongamestart = function(self)
    local bgm = settings.audio.bgm
    -- Allows to play forever.
    bgm:setLooping(true)
    -- Makes it a big quieter.
    bgm:setVolume(0.5)
    
    bgm:play()
end

Audio.ongamestop = function(self)
    local bgm = settings.audio.bgm
    -- Stop the play for now.
    bgm:stop()
end

--- Play audio for missile launches.
Audio.onmissilelaunchdetected = function(self)
    love.audio.play(settings.audio.explosion)
end

--- Play audio for pig explosions.
Audio.onpigexplosion = function(self)
    love.audio.play(settings.audio.pigexplosion)
end



return Audio
