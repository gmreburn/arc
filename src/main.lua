require 'constants'

-- Main Lövetoys Library
lovetoys = require("lib/lovetoys/lovetoys")
lovetoys.initialize({globals = true, debug = true})

-- Framework Requirements
require("core/Stackhelper")
require("core/Resources")

local InitializingState = require("states/InitializingState")

function love.load()
    min_dt = 1 / 30
    self.next_time = love.timer.getTime()

    stack = StackHelper()
    stack:push(InitializingState())
end

function love.update(dt)
    require("lib/lovebird").update()
    stack:current():update(dt)
    self.next_time = self.next_time + min_dt
end

function love.draw()
    stack:draw()

    local cur_time = love.timer.getTime()
    if self.next_time <= cur_time then
        self.next_time = cur_time
        return
    end

   love.timer.sleep(self.next_time - cur_time)
end

function love.keypressed(key, isrepeat)
    stack:current():keypressed(key, isrepeat)
end

function love.keyreleased(key, isrepeat)
    stack:current():keyreleased(key, isrepeat)
end

function love.mousepressed(x, y, button)
    stack:current():mousepressed(x, y, button)
end

function love.wheelmoved(x, y)
    stack:current():wheelmoved(x, y)
end