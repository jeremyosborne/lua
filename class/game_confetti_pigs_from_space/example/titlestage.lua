--[[

The title stage for our game.

--]]


local State = require("lib.state").State
local EventRegister = require("components.eventregister")

local settings = require("settings")
local mainFont = settings.mainFont

local titleStage = State("title")

--- Called to setup our stage.
titleStage.enter = function(self)
    log("titleStage: entering")

    -- Window caption.
    love.graphics.setCaption("Beware the Confetti Pigs")

    -- Response from update.
    self.updateResponse = nil

    -- Use a component explicitly.
    self.eventregister = EventRegister(self)
    -- Subscribe ourselves to events.
    self.eventregister:sub("mousepressed", self.onmousepress, self)
    
    -- For controlling the marquee.
    self.marquee = 'Confetti Pigs from Space'
    self.displayedMarquee = ""
    self.helpText = "Click to start."
    -- Total time passed, to mod against total number of letters.
    self.timePassed = 0
end

--- Called each frame to update our state.
titleStage.update = function(self, dt)
    -- Update the marquee.
    self.timePassed = self.timePassed + dt
    if self.timePassed*5 / #self.marquee > 1 then
        self.displayedMarquee = self.marquee
    else
        self.displayedMarquee = self.marquee:sub(1, math.max(1, self.timePassed*5 % #self.marquee))
    end 
    
    return self.updateResponse
end

--- Called each frame and used to draw things related to our stage.
titleStage.draw = function(self)
    local windowCenterX = love.graphics.getWidth()/2
    local windowCenterY = love.graphics.getHeight()/2

    -- Center marquee.    
    local x = windowCenterX - mainFont:getWidth(self.displayedMarquee)/2
    local y = windowCenterY - mainFont:getHeight(self.displayedMarquee)/2

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(self.displayedMarquee, x, y)
    
    -- Center help text, assuming next line down.
    x = windowCenterX - mainFont:getWidth(self.helpText)/2
    -- Assume fontsize is the font height, scoot help text down just a bit.
    y = windowCenterY - mainFont:getHeight(self.helpText)/2 + settings.mainFontSize + 2
    love.graphics.print(self.helpText, x, y)
end

--- Callback or mousepress events.
titleStage.onmousepress = function(self, data)
    log("titleStage: received mousepress:", table.concat(data, ","))
    
    self.updateResponse = "game"
end

titleStage.exit = function(self)
    log("titleStage: removing up event listeners.")
    self.eventregister:clear()

    log("titleStage: exiting")
end



return titleStage
