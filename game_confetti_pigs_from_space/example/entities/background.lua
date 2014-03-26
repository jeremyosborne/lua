--[[

Background particle system.

--]]

local Class = require("lib.class")
local Entity = require("entities.entity")

-- Reusable, simple particle.
local particleImage = love.image.newImageData(2, 2)
for y=0, particleImage:getHeight()-1 do
    for x=0, particleImage:getWidth()-1 do
        -- x, y, r, g, b, a
        particleImage:setPixel(x, y, 255, 255, 255, 121)
    end
end
particleImage = love.graphics.newImage(particleImage)

local Background = Class(function(self)

    -- Score changes via game events.
    self:addComponent("eventregister")
    self.components.eventregister:sub("gamestart", self.ongamestart, self)
    self.components.eventregister:sub("gamestop", self.ongamestop, self)

    local system = love.graphics.newParticleSystem(particleImage, 344)
    system:setPosition(love.graphics:getWidth()/2, love.graphics:getHeight()/2)
    system:setOffset(0, 0)
    system:setBufferSize(2000)
    system:setEmissionRate(100)
    system:setLifetime(-1)
    system:setParticleLife(10)
    system:setColors(255, 255, 255, 255)
    system:setSizes(1, 3, 1)
    system:setSpeed(150, 341 )
    system:setDirection(math.rad(87))
    system:setSpread(math.rad(360))
    system:setGravity(0, 0)
    system:setRotation(math.rad(0), math.rad(0))
    system:setSpin(math.rad(0.5), math.rad(5), 1)
    system:setRadialAcceleration(1)
    system:setTangentialAcceleration(1)

    -- Unofficially add onto our component system for free updates.
    self.components.system = system

end, Entity)

--- Ducktype.
Background.name = "background"

Background.draw = function(self)
    -- Set alpha, just in case.
    love.graphics.setColor(255, 255, 255, 255)
    -- The particle system offsets itself relatively at construction
    -- time so we draw at the upper left corner.
    love.graphics.draw(self.components.system, 0, 0)
end

Background.ongamestart = function(self)
    self.components.system:start()
end

Background.ongamestop = function(self)
    self.components.system:stop()
end



return Background