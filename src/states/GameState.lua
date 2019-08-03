-- Systems
local DrawSystem = require("systems/draw/DrawSystem")

-- Events
local KeyPressed = require("events/KeyPressed")

-- State superclass
local State = require("core/State")
local GameState = class("GameState", State)

function GameState:load()
    min_dt = 1/30
    self.next_time = love.timer.getTime()

    self.engine = Engine()
    self.eventmanager = EventManager()

    self.engine:addSystem(DrawSystem())

end

function GameState:update(dt)
    self.engine:update(dt)
    self.next_time = self.next_time + min_dt
end

function GameState:draw()
    self.engine:draw()

    local cur_time = love.timer.getTime()
    if self.next_time <= cur_time then
        self.next_time = cur_time
        return
    end

   love.timer.sleep(self.next_time - cur_time)
end

function GameState:keypressed(key, isrepeat)
    self.eventmanager:fireEvent(KeyPressed(key, isrepeat))
end

return GameState
