-- Events
local PlayerChangedVelocity = require('events/PlayerChangedVelocity')

-- State superclass
local GameState = require("states/GameState")
local HeroState = class("HeroState", GameState)
local activeWeapon = WEAPON_MISSILE

function bool_to_number(value)
    return value and 1 or 0
end

local cruise_x, cruise_y, vx, vy = 0
function HeroState:keypressed(key, isrepeat)
    if key == "escape" then
        love.event.quit()
    end

    -- if(key == "home") then
    --     if(cruise_x == -1) then
    --         cruise_x = 0
    --     else
    --         cruise_x = -1
    --     end
    -- elseif(key == "end")
    --     if(cruise_x == 1) then
    --         cruise_x = 0
    --     else
    --         cruise_x = 1
    --     end
    -- elseif(key == "delete")
    --     if(cruise_y == -1) then
    --         cruise_y = 0
    --     else
    --         cruise_y = -1
    --     end
    -- elseif(key == "pagedown")
    --     if(cruise_y == 1) then
    --         cruise_y = 0
    --     else
    --         cruise_y = 1
    --     end
    -- end
    
    vx = bool_to_number(love.keyboard.isDown("right", "pagedown")) - bool_to_number(love.keyboard.isDown("left", "delete"))
    vy = bool_to_number(love.keyboard.isDown("down", "end")) - bool_to_number(love.keyboard.isDown("up", "home"))    

    self.eventmanager:fireEvent(PlayerChangedVelocity(vx, vy))
end

function HeroState:keyreleased(key, isrepeat)
    vx = bool_to_number(love.keyboard.isDown("right", "pagedown")) - bool_to_number(love.keyboard.isDown("left", "delete"))
    vy = bool_to_number(love.keyboard.isDown("down", "end")) - bool_to_number(love.keyboard.isDown("up", "home"))    

    self.eventmanager:fireEvent(PlayerChangedVelocity(vx, vy))
end

local team = TEAM_GREEN
local hero_x, hero_y = 0

function HeroState:mousepressed(x, y, button)
    if(button == 1) then
        stack:current().networkSystem:fireWeapon(FIRE_LASER, team, x, y, findRotation(0, 0, x, y))
    elseif(button == 2) then
        stack:current().networkSystem:fireWeapon(activeWeapon, team, x, y, findRotation(0, 0, x, y))
    elseif(button == 3) and activeWeapon ~= WEAPON_GRENADE then
        love.audio.play(love.audio.newSource('sound/GOT_MORT.wav', 'stream'))
        activeWeapon = WEAPON_GRENADE
    end
end

function HeroState:wheelmoved(x, y)
    if(y > 0 and activeWeapon ~= WEAPON_MISSILE) then
        love.audio.play(love.audio.newSource('sound/GOT_MISS.wav', 'stream'))
        activeWeapon = WEAPON_MISSILE
    elseif(y < 0 and activeWeapon ~= WEAPON_BOUNCY) then
        love.audio.play(love.audio.newSource('sound/GOT_BOUN.wav', 'stream'))
        activeWeapon = WEAPON_BOUNCY
    end
end

function findRotation(x1, y1, x2, y2)
 
    local t = -math.deg(math.atan2(x2-x1,y2-y1))
    if t < 0 then t = t + 360 end;
    return t;
   
end

return HeroState