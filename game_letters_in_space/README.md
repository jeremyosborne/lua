Letters in space
================
Lua is used a lot in video games. The details of Lua usage will change depending on the game engine that it is used within, but certain ideas will hold. This example is designed to introduce the user to useful ideas and concepts in using Lua for video games (and really, Lua usage in general).

We will be using the Love2d framework as a simple game framework for our examples. If you have not installed it by this point, we will need to make sure it is installed before proceeding.

* see: [Love2d](http://love2d.org/)
* see: [Getting started with Love2d](https://www.love2d.org/wiki/Getting_Started)



Hello Love2d
------------
All of our work will be done in the `example` folder. For reference, the `example_complete` folder contains a version of our final destination (assuming we don't ad lib something different in class).

Before proceeding, we should make sure things are working, and in particular that Love2d is working. Let's do a test of the finished version. Enter the `example_complete` directory and attempt to run the program. Type a bunch of keys on the keyboard. Listen and type some more.

This first example will help us build scaffolding for a slightly more complex game.



Looking over the scaffolding of our game
----------------------------------------
File paths will be referenced from the `example` directory from now on.

Walkthrough of some things that are laid out for us:

* All files that we need already exist, laying out the basic structure of our game.
* The audio sounds live in the `audio` folder.
* The `lib` folder contains some code that falls into more general code, not necessarily tied to a our game (or only loosely tied).
    * `lib/class.lua` is our class code that we made previously, now applied to our game.
* The `entities` folder will consist of game objects that populate our game world.
* Entities will be defined by a general `entities/entity.lua` class, and each of those classes will be defined by components.
* The `components` directory contains general and basic building blocks of our entities.
* The `main.lua` file is required by Love2d, and so we adhere to that structure. It will also contain the main block of our code.
* The `settings.lua` file will contain some general settings for our code.

We will piece together the example in chunks, testing things along the way.



Random module
-------------
The easiest thing to add: our random module. Add the following code to our `lib/random.lua` file:

```lua
--[[

Random functions.

--]]



-- Module
local M = {}



--- Randomize + or - signage.
local randsign = function()
    if math.random() > 0.5 then
        return -1
    else
        return 1
    end
end
-- Export
M.randsign = randsign



-- Export
return M
```

Note the format of the code. We're following the module pattern for this block of code. Let's test the code and make sure things work. Open a Lua interpreter by typing `lua` in the console from the root directory of the game. Let's test out our code with the following:

```lua
do
    local randsign = require("lib.random").randsign
    print("Will be a -1 or +1", randsign())
end
```

Excellent! We have our first new utility function.



Publiser/subscriber style programming with events
-------------------------------------------------
Using events allows us to decouple pieces of our code that we may not want to know about each other. The idea is to allow for listening to specific messages, as well as publishing of specific messages. Whether a message is actually and ever published is indeterminate, and may never be called, but whether or not a message is published or subscribed to will not cause errors in the program.

Open `lib/events.lua` and add the following code:

```lua
--[[

A simple pub/sub system to generalize and centralize message dispatch.

--]]

-- We need some class constructor.
local Class = require("lib.class")



-- Module.
local M = {}



-- Simple identification for each event.
local eventId = 0
local nextId = function()
    eventId = eventId + 1
    return eventId
end

--- Event objects associate callers with callbacks.
-- @param callback {function} The callback function. Passed caller (as
-- first arg, if supplied), followed by any additional arguments during
-- the event.
-- @param caller {mixed} If supplied, this will be passed as the
-- first argument of callback (as the assumed "self" argument).
local Event = Class(function(self, callback, caller)
    self.id = nextId()
    self.callback = callback
    self.caller = caller
end)

--- Triggers the event.
Event.pub = function(self, ...)
    if self.caller then
        self.callback(self.caller, ...)
    else
        self.callback(...)
    end
end

-- Export, in case something else wants to use the event object.
M.Event = Event



--- Construct an event publisher that can be subscribed to.
local Events = Class(function(self)
    -- Hashed container for named events.
    -- A keyed set of tables.
    self.listeners = {}
end)

--- Add a listener to an event.
-- @param event {string} Name of the event.
-- @param callback {function} Function to call when event is triggered.
-- @param [caller] {mixed} If provided and is truthy, will be passed
-- as the first argument to callback (assuming OO self paradigm).
-- @return {number} Event subscription id. Used to remove the subscription.
Events.sub = function(self, event, callback, caller)
    local eobj = Event(callback, caller)

    if not self.listeners[event] then
        self.listeners[event] = {}
    end
    -- Order of execution not guaranteed.
    self.listeners[event][eobj.id] = eobj

    return eobj.id
end

--- Trigger an event.
-- @param event {string} Name of the event to trigger.
-- @param ... {mixed} Arguments to pass to the event callbacks.
Events.pub = function(self, event, ...)
    if self.listeners[event] then
        for _, eobj in pairs(self.listeners[event]) do
            eobj:pub(...)
        end
    end
end

--- Clear a particular listener from a particular event, or clear all
-- listeners from a particular event.
-- @param [event] {string} Name of the event to clear. If this is provided
-- and not id is provided, all listeners for this particular event will
-- be cleared.
-- @param [id] {number} The event id to clear from this list. If this
-- is provided and the event param is not provided all event groups will
-- be searched through and the listener will be removed from the group.
-- Note: the id must still be the second or third argument depending
-- on how this is called.
Events.clear = function(self, event, id)
    if self.listeners[event] and not id then
        self.listeners[event] = nil
    elseif self.listeners[event] and id then
        self.listeners[event][id] = nil
    elseif not event and id then
        for _, eventgroup in pairs(self.listeners) do
            if eventgroup[id] then
                eventgroup[id] = nil
                break
            end
        end
    end
end

-- Export.
M.Events = Events



-- Export.
return M
```

And let's try out the code to get a sense of how this works. Open a `lua` interpreter and:

```lua
do
    -- Create a new event system.
    local events = require("lib.events").Events()
    -- Broadcast an event... nothing happens.
    events:pub("hello", "world")
    -- Listen for the hello event.
    events:sub("hello", function(data)
        print(data.." and universe")
    end)
    
    -- Broadcast the event again.
    -- Will see one print statement.
    events:pub("hello", "world")
    
    -- Keep the "self" of an object.
    o = {
        name = "little o",
        listen = function(self, data)
            print(data.." handled by "..self.name)
        end
    }
    events:sub("hello", o.listen, o)
    
    -- Broadcast the event one more time.
    -- Will see two print statements.
    events:pub("hello", "world")
end
```

That completes our so called third party code. Let's work on piecing together the game.



Game loop and callbacks
-----------------------
Games have some form of run loop, and Love2d encourages this. Let's get a blank screen up and running, as well as layout the basic structure. In `main.lua`, drop in the following:

```lua
--- Called during the game load. A chance to load assets.
--- Diagnostic print statement. Purposely global.
log = function(...)
    if DEBUG then
        print(...)
    end
end    

-- Generalized event publisher. This needs to be made available before 
-- many other things are loaded, might as well do this first.
events = require("lib.events").Events()



--- Called prior to the run loop. A chance to load assets.
love.load = function()

end



--- Called once per frame.
-- @param dt {number} Delta (in seconds) since last update.
love.update = function(dt)

end



--- Called once per frame.
love.draw = function()
    -- Hello world!
    love.graphics.print("Hello World", 400, 300)
end



--- Callback for key presses.
love.keypressed = function(key, unicode)
    -- quit on escape.
    if key == "escape" then
        love.event.quit()
    end
end



--- Callback when the game quits.
love.quit = function()
    log("Thanks for playing.")
end
```

Run the program and we have hello worlded ourself again. Hit escape when you are done.

We see some key concepts in this simple layout.

* We assign callback functions that our game engine uses at specific points.
* The `love.load` function is called prior to our game running, and allows us to load data and assets.
* The `love.update` callback is called every frame to update data before repainting.
* The `love.draw` callback is called every frame to repaint the screen.
* The `love.keypressed` is called when a keypress is detected. In this case, if we hit the escape key, we quit.
* The `love.quit` callback is called on the way to the program exit. It is called once and allows us to clean up (save data, close files, etc.)



Configuration
-------------
We have a minor amount of configuration available to our game, which we will keep available in our `settings.lua` file. Drop the following into `settings.lua`:

```lua
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
```

And in `main.lua` let's make the following additions:

```lua

-- Somewhere towards the top of the file...

-- Use paths relative to our root directory when we require.
-- Always use the full path to allow for caching by file path.
local settings = require("settings")



-- In the love.load function, add the call to setFont...

--- Called prior to the run loop. A chance to load assets.
love.load = function()
    love.graphics.setFont(settings.mainFont)
end
```

Run the game again and we can see the font has gotten bigger. We've also set up some audio assets for use later.



Respond to the keypress
-----------------------
If our goal is to print letters out on the screen, then we need to respond to keypresses. First things first, let's detect which key is pressed and log the keypress out to the screen. In `main.lua` make the following changes:

```lua

-- Find the love.keypressed callback and add the elseif block...

--- Callback for key presses.
love.keypressed = function(key, unicode)
    -- quit on escape.
    if key == "escape" then
        love.event.quit()
    elseif unicode > 31 and unicode < 127 then
        -- Just the ascii characters for now.
        log("keypressed: "..string.char(unicode))
    end
end
```

Test this out. Load up the game, and press a bunch of keys. Make sure the key presses are being logged out to the console.



Abstracting events
------------------
A digression. Before we get too deep into the game, we're going to define a few special moments. These events are of our own design, they don't have anything to do with Love2d. Open up `main.lua` and make the following changes:

```lua

-- In love.load, publish the following event:

--- Called prior to the run loop. A chance to load assets.
love.load = function()
    love.graphics.setFont(settings.mainFont)
      
    -- Signal the start of the game.
    events:pub("gamestart")    
end

-- In love.keypressed, publish the following event:

--- Callback for key presses.
love.keypressed = function(key, unicode)
    -- quit on escape.
    if key == "escape" then
        love.event.quit()
    elseif unicode > 31 and unicode < 127 then
        -- Just the ascii characters for now.
        --log("keypressed: "..string.char(unicode))
        events:pub("keypressed", {string.char(unicode)})
    end
end

-- In love.quit, publish the following event:

--- Callback when the game quits.
love.quit = function()
    log("Thanks for playing.")

    -- Signal the end of the game.
    events:pub("gamestop")
end
```

We could load the game up again, but all we'd see is hello world and the fact that we no longer get the console output for our keys (assuming you commented out the log statement in the keypress callback).

Before loading up, lets listen for the keypress event and log the output. In `main.lua` again make the following changes:

```lua
-- Somewhere after the events object is created...

-- React to the keypresses.
-- Expect the data payload to contain the key that was pressed as the
-- first index.
events:sub("keypressed", function(data)
    --Diagnostic.
    log("keypressed: "..data[1])
end)
```

Excellent! Try running the game again, and make sure that the game outputs the characters like before. We've decoupled the procedural code from the keypress function. Being able to publish and respond to events will become more useful as time goes on.



Entities
--------
Our game is pretty empty without entities. An entity can be anything: a good guy, a bad guy, music, a background image. Let's start out with a simple entity: our music and sound effects player. The first thing we need is the abstract entity class. Open `entities/entity.lua` and drop in the following code:

```lua
--[[

Basic interface for entities in our game.

--]]

local Class = require("lib.class")



--- Equivalent to an abstract class.
local Entity = Class()

-- Base classes should duck type themselves.
Entity.name = "entity"

-- RESERVED: Hash for components.
Entity.components = nil

--- Adds a component to the entity.
-- @param component {string} The name of the component to add.
-- @param ... {mixed} Optional arguments to pass to the component.
Entity.addComponent = function(self, component, ...)
    if not self.components then
        self.components = {}
    end
    if not self.components[component] then
        -- Load and construct all at once.
        self.components[component] = require("components."..component)(self, ...)
    else
        log("WARNING: Not replacing existing component "..component.." on "..self.name)
    end
end

--- Tests for existence of a component on the entity.
-- @param component {string} The name of the component.
-- @return {boolean} true if entity has the component, false if not.
Entity.hasComponent = function(self, component)
    return not not self.components[component]
end

--- Updates the components on an entity if they are meant to be updated.
-- @param dt {number} Delta number of seconds passed since last call.
Entity.update = function(self, dt)
    for _, c in pairs(self.components) do
        if c.update then
            c:update(dt)
        end
    end
    -- Will be nil if the entity does not implement.
    return self.updateResponse
end

--- All entities must implement their own draw function should they
-- wish to draw themselves.
Entity.draw = function(self)
    -- do things...
end



return Entity
```

We have set up the following assumptions with this code:

* All of our entities are classes.
* All of our entities will duck type themselves.
* Most of our entity logic will be component based, and we will add components to an associative array called components on our entities.
* Components themselves will be classes.
* By default, we assume that when we update the entity, we are actually updating our components.
* Entities will have an `updateResponse` property that can signal when we need to do something with the entity, like get rid of it.
* Entities, if they wish to be drawn, must override the no op draw function.



The EventRegister: our first component
--------------------------------------
Components will make up the meat of our entities. The goal is to make components as general as possible, without making them too general or too bloated. Components should be able to subscribe to events, and also remove themselves from events. This will be key to handling the lifecycle of our entities. Before we can finish our audio component, open up `components/eventregister.lua` and drop the code in the file:

```lua
--[[

Manages a set of event subscriptions and allows for explicit cleanup
of these events.

--]]


local Class = require("lib.class")



--- Manages an event register.
-- @param owner {Entity} Who owns this component.
local EventRegister = Class(function(self, owner)
    --- Which entity owns us?
    self.owner = owner

    --- Register of event ids. Required for cancelling a set of explicit
    -- events.
    self.register = {}
end)

--- Wrapper for event addition that remembers the event id for later
-- deletion.
-- (Same signature as the Events:sub).
EventRegister.sub = function(self, event, callback, caller)
    -- Remember the ID.
    table.insert(self.register, events:sub(event, callback, caller))
end

--- Unsubscribe events or classes of events.
-- @param [event] {string} Specific category to remove is so desired,
-- otherwise removes all events.
EventRegister.clear = function(self, event)
    local name = self.owner and self.owner.name or "unknown"
    if event then
        log(("%s: clearing events of type: %s"):format(name, event))
        events:clear(event)
    else
        for _, id in ipairs(self.register) do
            log(("%s: clearing event id: %s"):format(name, id))
            events:clear(nil, id)
        end
    end
end



return EventRegister
```

Essentially this allows our individual entities to subscribe themselves to events, and remove themselves from the pool of event listeners when they're done with events.




Audio: our first entity
-----------------------
With the EventRegister component in place, let's add the Audio entity. Open up `entities/audio.lua` and drop in the following code:

```lua
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
    self.components.eventregister:sub("gamestart", self.ongamestart, self)
    self.components.eventregister:sub("gamestop", self.ongamestop, self)
    self.components.eventregister:sub("keypressed", self.onkeypressed, self)
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

Audio.onkeypressed = function(self)
    love.audio.play(settings.audio.letter)
end


return Audio
```

Somewhere in `main.lua` add the following:

```lua

-- Add toward the top of the file, and below the events initialization.

-- The audio is global because it is event based.
audio = require("entities.audio")()
```

Excellent! Run the game and you should be able to note two things:

* Background music is playing.
* Pressing keys on the keyboard will trigger an "explosion" sound effect.



Position component
------------------
Open `components/position.lua` and drop in the following code:

```lua
--[[

Locates an entity on a position.

--]]


local Class = require("lib.class")



--- Allow an entity to be positioned in 2d.
-- @param owner {Entity} Who owns this component.
-- @param x {number} X coordinate position.
-- @param y {number} Y coordinate position.
local Position = Class(function(self, owner, x, y)
    --- Which entity owns us?
    self.owner = owner

    --- Pixel coords.
    self.x = x or 0
    self.y = y or 0
end)

-- Not an updatable component by itself.



return Position
```

The purpose of the component is to remember the center position of an entity. While the components are implemented a bit differently within the game, let's test out the position component. Open a `lua` interpreter and run the following code:

```lua
do
    local Position = require("components.position")

    -- Our standin player.
    pc = {
        name = "Player 1"
    }
    
    -- Create a position instance.
    pos = Position(pc, 1, 2)
    
    print("Location at pos.x should be 1", pos.x)
    print("Location at pos.y should be 2", pos.y)
    print("owner should be 'Player 1'", pos.owner.name)
    
    -- In game, our component system also attaches a reference to each
    -- component to the .components property on each entity.
end
```

With each entity knowing what components they have, and each component instance knowing its entity owner, we can do some creative things with the dynamic typing system of Lua.



Letters - round 1
-----------------
Now when we type a letter, we want to see the letter on the screen at a random position within the game viewport.

Open up `entities/letter.lua` and drop in round 1 of our code:

```lua
--[[

Letters in space.

--]]

local Class = require("lib.class")
local Entity = require("entities.entity")

local settings = require("settings")
local mainFont = settings.mainFont



--- Create a letter.
-- 
-- @param letter {string} What letter to display?
-- @param x {number} X coordinate of where to place the letter.
-- @param y {number} Y coordinate of where to place the letter.
-- @param vx {number} Velocity magnitude in the x direction.
-- @param vy {number} Velocity magnitude in the y direction.
local Letter = Class(function(self, letter, x, y, vx, vy)
    self.letter = letter
    self:addComponent("position", x, y)

    -- Entities signal their removal from the game by returning truthy.
    self.updateResponse = nil

end, Entity)

--- Ducktype
Letter.name = "letter"

-- Use the inherited update method.

--- Draw.
Letter.draw = function(self)
    -- What we should print.
    local letter = self.letter
    
    -- Where the letter should be centered.
    local pos = self.components.position

    -- Center the letter on the point.
    local x = mainFont:getWidth(letter)/2
    local y = mainFont:getHeight(letter)/2

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(letter, pos.x-x, pos.y-y)
end

return Letter
```

That's enough to get the letter on screen. We need to add some things to manage our Letters. Open up `main.lua` and make the following changes:

```lua

-- Our list of entities.
local entities = {}

-- Entities
local Letter = require("entities.letter")

-- Change the subscription to the "keypress" event to be:
-- React to the keypresses.
-- Expect the data payload to contain the key that was pressed as the
-- first index.
events:sub("keypressed", function(data)
    --Diagnostic.
    --log("keypressed: "..data[1])

    table.insert(entities, Letter(data[1]))
end)



-- Fill in the update callback:

--- Called once per frame.
-- @param dt {number} Delta (in seconds) since last update.
love.update = function(dt)
    local ents = {}
    for _, ent in pairs(entities) do
        if ent:update(dt) ~= "dead" then
            table.insert(ents, ent)
        end
    end
    entities = ents
end



-- Fill in the draw callback:

--- Called once per frame.
love.draw = function()
    -- Hello world!
    --love.graphics.print("Hello World", 400, 300)

    for _, ent in pairs(entities) do
        ent:draw()
    end    
end
```

We're a bit ahead of ourselves with some of the code. Try running the game. All of the letters should appear in the game when we press a key, but they will all appear in the upper left corner.



Positioning the letters
-----------------------
We want to randomly position the letters in our game. That's a simple change. Because our letters already have the Position component, and they're setup to be positioned, we can figure out a random location within the game window and assign that position to each letter. Open up `main.lua` and make the following change:

```lua
-- React to the keypresses.
-- Expect the data payload to contain the key that was pressed as the
-- first index.
events:sub("keypressed", function(data)
    --Diagnostic.
    --log("keypressed: "..data[1])

    --table.insert(entities, Letter(data[1]))

    table.insert(entities, Letter(data[1],
        -- position randomly in the game window, x first then y.
        math.random(5, love.graphics:getWidth()-5),
        math.random(5, love.graphics:getHeight()-5)
    ))
end)
```

This will add the letters on the screen in random positions. Run the game and give it a try.



Velocity - moving the entities
------------------------------
Games might have simple or complex physics models. We're going to opt for simple in these examples. We want to add a velocity component to `components/velocity`:

```lua
--[[

Stores current motion.

--]]


local Class = require("lib.class")



--- 2d motion vector.
-- @param owner {Entity} Who owns this component.
-- @param x {number} X portion of velocity.
-- @param y {number} Y portion of velocity.
local Velocity = Class(function(self, owner, x, y)
    --- Which entity owns us?
    self.owner = owner

    self.x = x or 0
    self.y = y or 0
end)

--- Update position of entity.
-- Assumes coupling with an entity with position.
Velocity.update = function(self, dt)
    local pos = self.owner.components.position
    if pos then
        pos.x = pos.x + self.x*dt
        pos.y = pos.y + self.y*dt
    end
end



return Velocity
```

One interesting thing to note is that the Velocity component won't break if the entity doesn't have a position. In super high performance games, these extra checks might be unwarranted, but when doing simple or rapid development, adding in self protecting code can speed up development and cut down on bugs.

Open up `entites/letter.lua` and make the following addition to our constructor:

```lua

-- The addition is just the velocity component.

local Letter = Class(function(self, letter, x, y, vx, vy)
    self.letter = letter
    self:addComponent("position", x, y)

    -- Entities signal their removal from the game by returning truthy.
    self.updateResponse = nil
    
    -- Add for directed speed.
    self:addComponent("velocity", vx, vy)

end, Entity)
```

Within `main.lua` let's add a randomized velocity to our letters:

```lua

-- Add near the top.

-- Utils
local randsign = require("lib.random").randsign



-- Make our final change the keypress callback.
-- React to the keypresses.
-- Expect the data payload to contain the key that was pressed as the
-- first index.
events:sub("keypressed", function(data)
    --Diagnostic.
--    log("keypressed: "..data[1])
    
--    table.insert(entities, Letter(data[1]))
    
--    table.insert(entities, Letter(data[1],
--        -- position randomly in the game window, x first then y.
--        math.random(5, love.graphics:getWidth()-5),
--        math.random(5, love.graphics:getHeight()-5)
--    ))

    table.insert(entities, Letter(data[1],
        -- position randomly in the game window, x first then y.
        math.random(5, love.graphics:getWidth()-5),
        math.random(5, love.graphics:getHeight()-5),
        -- Random velocity in pixels/sec (x then y).
        math.random(10, 100) * randsign(),
        math.random(10, 100) * randsign()
    ))
end)
```

Test out the game. Clicking on letters should now provide a moving experience.



Countdown - the short life of video game entities
-------------------------------------------------
The life of a video game entity can be long, and it can also, and usually, be very short. Our letters will have a very brief life, and then they will be gone. We'll implement the countdown component to `components/countdown.lua` to allow us to automatically mark the end of a letter's life:

```lua
--[[

As time passes, this component counts down and when it hits zero, an
event is fired.

--]]


local Class = require("lib.class")



--- Allow an entity to countdown.
-- 
-- Events published:
-- timesup: fires once, when the countdown has expired (reached zero).
-- Passes an object with the target = countdown owner.
-- 
-- @param owner {Entity} Who owns this component.
-- @param time {Number} How much time to track in the countdown?
local Countdown = Class(function(self, owner, time)
    --- Which entity owns us?
    self.owner = owner
    --- How much time did we have to begin with?
    self.maxTime = time or 60
    --- The timer goes one direction: down.
    self.timeleft = time or 60
    --- This type of timer will only trigger once.
    self.expired = false
end)

--- Update the time and trigger the timesup event if the countdown
-- is done (timesup only triggers once).
-- @param delta {number} How much to change the time. Inverts signage
-- as it assumes a positive delta should count down, not up.
Countdown.update = function(self, delta)
    self.timeleft = self.timeleft - delta
    if self.timeleft <= 0 and not self.expired then
        self.expired = true
        -- Let any listeners know we're done.
        events:pub("timesup", {target = self.owner})
    end
end

--- Convenience method to get display friendly time.
-- @return {number} Human friendly time of the countdown.
Countdown.time = function(self)
    -- Truncated, don't display time < zero.
    return math.max(0, math.floor(self.timeleft))
end

--- Determine age as a percentage of lifetime.
-- @return {number} Age as a percentage of life spent.
Countdown.age = function(self)
    return (self.maxTime-self.timeleft)/self.maxTime
end



return Countdown
```

To use the component, modify the `entities/letter.lua` to include event registration, countdown, and the ability to listen to the timesup on the individual instance:

```lua

-- Within the constructor...
local Letter = Class(function(self, letter, x, y, vx, vy)
    self.letter = letter
    self:addComponent("position", x, y)

    -- Entities signal their removal from the game by returning truthy.
    self.updateResponse = nil
    
    -- Add for directed speed.
    self:addComponent("velocity", vx, vy)

    self:addComponent("eventregister")
    -- Listen to our own demise, whenever that happens.
    self:addComponent("countdown", 4)
    self.components.eventregister:sub("timesup", self.ontimesup, self)
end, Entity)



-- And add an additional callback

--- Listen for when we're done.
Letter.ontimesup = function(self, data)
    if data.target == self then
        -- Our job here is done.
        self.updateResponse = "dead"
        self.components.eventregister:clear()
        
        -- Diagnostic.
        --log("removing letter:", self.letter)
    end
end
```

And try it out! Letters should now excuse themselves from the play field after their time is up in the game. The console should log the clearing of events, and you can uncomment the diagnostic print statment to see which letter gets removed.

Excellent work!

Now let's take the things we've learned and make more of a game that's got a score and acts like an actual game.
