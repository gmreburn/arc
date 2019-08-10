local BodyComponent = require('components/physic/body')
local VelocityComponent = require('components/physic/velocity')

local WeaponEntity = require('entities/weapons/Weapon')

local resources = require('core/Resources')

Missile = class("Missile", WeaponEntity)

function Missile:initialize(x, y, angle, team)
    WeaponEntity.initialize(x, y, angle, team)

    self:add(BodyComponent(hc.circle(x, y, SHIP_SIZE / 2), self, SHIP_SIZE / 2, Missile.onCollisionWith))
    self:add(VelocityComponent(MISSILE_VELOCITY * math.cos(theta), MISSILE_VELOCITY * math.sin(theta)))

    love.audio.play(love.audio.newSource('sound/Missile.wav', 'stream'))
end

function Missile:onCollisionWith(entity, delta)
end

return Missile