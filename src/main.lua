require 'constants'

-- Main Lövetoys Library
lovetoys = require("lib/lovetoys/lovetoys")
lovetoys.initialize({globals = true, debug = true})

-- Framework Requirements
require("core/Stackhelper")
require("core/Resources")

local MenuState = require("states/MenuState")

function love.load()
    -- love.audio.play(love.audio.newSource("sound/SYSINIT.WAV", "queue"))

    resources = Resources()
    -- resources:addImage("farplane", "Farplane.bmp")
    -- resources:addImage("tiles", "Tiles.bmp")
    -- resources:addImage("tuna", tunaImageData)
    -- resources:addSound("ARMORLO", "sound/ARMORLO.WAV")
    -- resources:addSound("BASE", "sound/BASE.WAV")
    -- resources:addSound("BLUE", "sound/BLUE.WAV")
    -- resources:addSound("bounce", "sound/bounce.WAV")
    -- resources:addSound("BOUNHITS", "sound/BOUNHITS.WAV")
    -- resources:addSound("BOUNSHOT", "sound/BOUNSHOT.WAV")
    -- resources:addSound("DROPFLAG", "sound/DROPFLAG.WAV")
    -- resources:addSound("FLAGCAP", "sound/FLAGCAP.WAV")
    -- resources:addSound("FLAGRET", "sound/FLAGRET.WAV")
    -- resources:addSound("GOT_BOUN", "sound/GOT_BOUN.WAV")
    -- resources:addSound("GOT_MISS", "sound/GOT_MISS.WAV")
    -- resources:addSound("GOT_MORT", "sound/GOT_MORT.WAV")
    -- resources:addSound("Gotpup", "sound/Gotpup.WAV")
    -- resources:addSound("GREEN", "sound/GREEN.WAV")
    -- resources:addSound("LASER", "sound/LASER.WAV")
    -- resources:addSound("LASRHITS", "sound/LASRHITS.WAV")
    -- resources:addSound("LASRHITW", "sound/LASRHITW.WAV")
    -- resources:addSound("LOSE", "sound/LOSE.WAV")
    -- resources:addSound("mine", "sound/mine.WAV")
    -- resources:addSound("Missile", "sound/Missile.WAV")
    -- resources:addSound("MORTHIT", "sound/MORTHIT.WAV")
    -- resources:addSound("MORTLNCH", "sound/MORTLNCH.WAV")
    -- resources:addSound("Muzzle", "sound/Muzzle.WAV")
    -- resources:addSound("NEUTRAL", "sound/NEUTRAL.WAV")
    -- resources:addSound("rd_close", "sound/rd_close.WAV")
    -- resources:addSound("rd_open", "sound/rd_open.WAV")
    -- resources:addSound("RED", "sound/RED.WAV")
    -- resources:addSound("ringin", "sound/ringin.WAV")
    -- resources:addSound("ROCKHITS", "sound/ROCKHITS.WAV")
    -- -- resources:addSound("ROCKHITW", "sound/ROCKHITW.WAV") -- corrupt
    -- resources:addSound("SHIPEXPL", "sound/SHIPEXPL.WAV")
    -- resources:addSound("SPAWN", "sound/SPAWN.WAV")
    -- resources:addSound("SW_FLIP", "sound/SW_FLIP.WAV")
    -- resources:addSound("SW_SPEC", "sound/SW_SPEC.WAV")
    -- resources:addSound("TEAM", "sound/TEAM.WAV")
    -- resources:addSound("TEAMWINS", "sound/TEAMWINS.WAV")
    -- resources:addSound("Unmuzzle", "sound/Unmuzzle.WAV")
    -- resources:addSound("WARP", "sound/WARP.WAV")
    -- -- resources:addSound("WELCOME", "sound/WELCOME.WAV")
    -- resources:addSound("WIN", "sound/WIN.WAV")
    -- resources:addSound("YELLOW", "sound/YELLOW.WAV")

    resources:load()

    stack = StackHelper()
    stack:push(MenuState())
end

function love.update(dt)
    stack:current():update(dt)
end

function love.draw()
    stack:current():draw()
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
