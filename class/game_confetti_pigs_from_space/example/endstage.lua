--[[

The end stage for our game.

--]]


local State = require("lib.state").State
local EventRegister = require("components.eventregister")

local settings = require("settings")
local mainFont = settings.mainFont


local endStage = State("end")

--- Called to setup our stage.
endStage.enter = function(self)
    log("endStage: entering")

    -- Window caption.
    love.graphics.setCaption("This is the end")

    -- Response from update.
    self.updateResponse = nil

    -- Use a component explicitly.
    self.eventregister = EventRegister(self)
    -- Subscribe ourselves to events.
    self.eventregister:sub("mousepressed", self.onmousepress, self)

    self.endText = "The End.\nThank you for playing.\nClick to start again."
end

--- Called each frame to update our state.
endStage.update = function(self, dt)
    return self.updateResponse
end

--- Called each frame and used to draw things related to our stage.
endStage.draw = function(self)
    local textLeft = 30
    local textWidth = love.graphics.getWidth() - (textLeft*2)
    -- Still need to calculate vertical offset for vertical centering.
    local textTop = love.graphics.getHeight()/2 - mainFont:getHeight(self.endText)/2

    -- Center our text across the available space, with padding on the left
    -- (and right), padding from the top, letting printf do most of the 
    -- work for us (unlike what we do in the titleStage).
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf(self.endText, textLeft, textTop, textWidth, 'center')

    -- Display the final score.
    score:draw()
end

--- Callback or mousepress events.
endStage.onmousepress = function(self, data)
    log("endStage: received mousepress:", table.concat(data, ","))
    
    self.updateResponse = "game"
end

endStage.exit = function(self)
    log("endStage: removing up event listeners.")
    self.eventregister:clear()

    log("endStage: exiting")
end



return endStage
