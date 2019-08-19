require 'constants'

-- Main Lövetoys Library
lovetoys = require("lib/lovetoys/lovetoys")
lovetoys.initialize({globals = true, debug = true})

-- Framework Requirements
require("core/Stackhelper")
require("core/Resources")

local next_time = nil
lovebird = require("lib/lovebird")
lovebird.update()

function love.load()
    min_dt = 1 / 30
    next_time = love.timer.getTime()

    stack = StackHelper()

    local server = false
    if(server) then
        stack:push(require("states/ServerState"))
    else
        stack:push(require("states/InitializingState"))
        lovebird.port = 8001
    end
end

function love.update(dt)
    lovebird.update()
    stack:current():update(dt)
    next_time = next_time + min_dt
end

function love.draw()
    stack:draw()

    local cur_time = love.timer.getTime()
    if next_time <= cur_time then
        next_time = cur_time
        return
    end

   love.timer.sleep(next_time - cur_time)
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