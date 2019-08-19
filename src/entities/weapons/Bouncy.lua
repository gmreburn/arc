local BodyComponent = require('components/physic/body')
local VelocityComponent = require('components/physic/velocity')

local WeaponEntity = require('entities/weapons/Weapon')

local resources = require('core/Resources')

Bouncy = class("Bouncy", WeaponEntity)

function Bouncy:initialize(x, y, angle, team)
    WeaponEntity.initialize(x, y, angle, team)

    self:add(BodyComponent(hc.circle(x, y, SHIP_SIZE / 2), self, SHIP_SIZE / 2, Bouncy.onCollisionWith))
    self:add(VelocityComponent(BOUNCY_VELOCITY * math.cos(theta), BOUNCY_VELOCITY * math.sin(theta)))

    love.audio.play(love.audio.newSource('sound/BOUNSHOT.wav', 'stream'))
end

function Bouncy:onCollisionWith(entity, delta)
    if(typeof(entity) == "Tile") then
        love.audio.play(love.audio.newSource('sound/bounce.wav', 'stream'))
        -- bounce off surface
    elseif(typeof(entity) == "Ship") then
        love.audio.play(love.audio.newSource('sound/BOUNHITS.wav', 'stream'))
        self.eventManager:fireEvent(BouncyHit(entity:getParent():getComponent("Meta").id, self:getParent():getComponent("Meta").id))
        self:destroy()
    end
end

return Bouncy