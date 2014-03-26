--[[

Definition of the various stages of the game.

--]]



local StateManager = require("lib.state").StateManager



local stageManager = StateManager()
--- Augment our stageManager to deal with other necessary functions.
stageManager.draw = function(self)
    if self.current and self.current.draw then
        self.current:draw()
    end
end
stageManager.onevent = function(self, event, data)
    if self.current and self.current.onevent then
        self.current:onevent(event, data)
    end
end



return stageManager