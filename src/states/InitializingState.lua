-- Systems
local FarplaneSystem = require("systems/draw/FarplaneSystem")

-- States
local State = require("core/State")
local HeroState = require('states/HeroState')
local InitializingState = class("InitializingState", State)

local function applyTransparency(path)
    local rgb2raw = function (float) return math.floor(float*255+0.5) end
    local imageData = love.image.newImageData(path)

    imageData:mapPixel(function(x,y,r,g,b,a)
        -- remove magic transparent color
        if(rgb2raw(r) == 199 and rgb2raw(g) == 43 and rgb2raw(b) == 87) then
            a = 0
        end

        -- change font color from black to white so love2d can modify its color
        if(x < 583 and y > 1201 and y < 1217) then
            if(r == 0 and g == 0 and b == 0) then
                r = 255
                g = 255
                b = 255
                a = 255
            end
        end
        
        return r, g, b, a
    end)

    return imageData    
end

function InitializingState:load()
    -- love.audio.play(love.audio.newSource("sound/SYSINIT.WAV", "static"))
    resources = Resources()
    resources:addImage("tiles", applyTransparency("Tiles.bmp"))
    resources:addImage("tuna", applyTransparency("tuna.bmp"))
    resources:addImage("farplane", "Farplane.bmp")
    resources:addSound("ARMORLO", "sound/ARMORLO.WAV")
    resources:addSound("BASE", "sound/BASE.WAV")
    resources:addSound("BLUE", "sound/BLUE.WAV")
    resources:addSound("bounce", "sound/bounce.WAV")
    resources:addSound("BOUNHITS", "sound/BOUNHITS.WAV")
    resources:addSound("BOUNSHOT", "sound/BOUNSHOT.WAV")
    resources:addSound("DROPFLAG", "sound/DROPFLAG.WAV")
    resources:addSound("FLAGCAP", "sound/FLAGCAP.WAV")
    resources:addSound("FLAGRET", "sound/FLAGRET.WAV")
    resources:addSound("GOT_BOUN", "sound/GOT_BOUN.WAV")
    resources:addSound("GOT_MISS", "sound/GOT_MISS.WAV")
    resources:addSound("GOT_MORT", "sound/GOT_MORT.WAV")
    resources:addSound("Gotpup", "sound/Gotpup.WAV")
    resources:addSound("GREEN", "sound/GREEN.WAV")
    resources:addSound("LASER", "sound/LASER.WAV")
    resources:addSound("LASRHITS", "sound/LASRHITS.WAV")
    resources:addSound("LASRHITW", "sound/LASRHITW.WAV")
    resources:addSound("LOSE", "sound/LOSE.WAV")
    resources:addSound("mine", "sound/mine.WAV")
    resources:addSound("Missile", "sound/Missile.WAV")
    resources:addSound("MORTHIT", "sound/MORTHIT.WAV")
    resources:addSound("MORTLNCH", "sound/MORTLNCH.WAV")
    resources:addSound("Muzzle", "sound/Muzzle.WAV")
    resources:addSound("NEUTRAL", "sound/NEUTRAL.WAV")
    resources:addSound("rd_close", "sound/rd_close.WAV")
    resources:addSound("rd_open", "sound/rd_open.WAV")
    resources:addSound("RED", "sound/RED.WAV")
    resources:addSound("ringin", "sound/ringin.WAV")
    resources:addSound("ROCKHITS", "sound/ROCKHITS.WAV")
    -- resources:addSound("ROCKHITW", "sound/ROCKHITW.WAV") -- corrupt
    resources:addSound("SHIPEXPL", "sound/SHIPEXPL.WAV")
    resources:addSound("SPAWN", "sound/SPAWN.WAV")
    resources:addSound("SW_FLIP", "sound/SW_FLIP.WAV")
    resources:addSound("SW_SPEC", "sound/SW_SPEC.WAV")
    resources:addSound("TEAM", "sound/TEAM.WAV")
    resources:addSound("TEAMWINS", "sound/TEAMWINS.WAV")
    resources:addSound("Unmuzzle", "sound/Unmuzzle.WAV")
    resources:addSound("WARP", "sound/WARP.WAV")
    resources:addSound("WELCOME", "sound/WELCOME.WAV")
    resources:addSound("WIN", "sound/WIN.WAV")
    resources:addSound("YELLOW", "sound/YELLOW.WAV")
    resources:load()

    self.engine = Engine()
    self.eventmanager = EventManager()
    self.engine:addSystem(FarplaneSystem())

    stack:push(HeroState())
end

function InitializingState:update(dt)
    self.engine:update(dt)
end

function InitializingState:draw()
    self.engine:draw()
end

return InitializingState
