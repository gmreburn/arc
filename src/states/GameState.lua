-- Systems
local DrawSystem = require("systems/draw/DrawSystem")
local NetworkSystem = require("systems/NetworkSystem")

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

    self.engine:addSystem(NetworkSystem())
    -- self.engine:addSystem(MapSystem())
    -- self.engine:addSystem(PlayerSystem())
    -- self.engine:addSystem(HUDSystem())    
    self.engine:addSystem(DrawSystem())

    -- local networkListener = require('systems/NetworkSystem')
    -- self.eventmanager.addListener("PrimaryWeaponFired", networkListener, networkListener.onPrimaryWeaponFired)
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
    server:send('keypressed '..playerid..' '..key)
    -- self.eventmanager:fireEvent(KeyPressed(key, isrepeat))
end

function GameState:mousepressed(x, y, button)
    server:send('mousepressed '..playerid..' '..x..' '..y..' '..button)

    -- if(button == 1) then
    --     hero:firePrimaryWeapon()
    -- elseif(button == 2) then
    --     hero:fireSecondaryWeapon()
    -- elseif(button == 3 and hero:get('specialWeapon') ~= WEAPON_GRENADE) then
    --     love.audio.play(love.audio.newSource('sound/GOT_MORT.wav', 'stream'))
    --     hero:selectWeapon(WEAPON_GRENADE)
    -- end
end

function GameState:wheelmoved(x, y)
    -- only send if changed?
    server:send('wheelmoved '..playerid..' '..x..' '..y)

    -- if(y > 0 and hero:get('specialWeapon') ~= WEAPON_MISSILE) then
    --     love.audio.play(love.audio.newSource('sound/GOT_MISS.wav', 'stream'))
    --     hero:selectWeapon(WEAPON_MISSILE)
    -- elseif(y < 0 and hero:get('specialWeapon') ~= WEAPON_BOUNCY) then
    --     love.audio.play(love.audio.newSource('sound/GOT_BOUN.wav', 'stream'))
    --     hero:selectWeapon(WEAPON_BOUNCY)
    -- end
end

return GameState
