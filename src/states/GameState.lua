local hc = require('lib/HC')

-- Systems
local DrawSystem = require("systems/draw/DrawSystem")
local FarplaneSystem = require("systems/draw/FarplaneSystem")
local RectangleDrawSystem = require("systems/draw/RectangleDrawSystem")
local HUDSystem = require("systems/logic/HUDSystem")
local NetworkSystem = require("systems/logic/NetworkSystem")

-- Events
local HeroEntityChanged = require('events/HeroEntityChanged')

-- States
local State = require("core/State")
local GameState = class("GameState", State)

function GameState:load()
    hc.resetHash(SHIP_SIZE*4)
    self.engine = Engine()
    self.eventmanager = EventManager()

    self.engine:addSystem(NetworkSystem(self.eventmanager))
    self.engine:addSystem(FarplaneSystem())
    self.engine:addSystem(RectangleDrawSystem())
    -- self.engine:addSystem(MapSystem())
    -- self.engine:addSystem(PlayerSystem())
    self.engine:addSystem(HUDSystem(self.eventmanager))
    self.engine:addSystem(DrawSystem())
end

function GameState:update(dt)
    self.engine:update(dt)
end

function GameState:draw()
    self.engine:draw()
end

return GameState