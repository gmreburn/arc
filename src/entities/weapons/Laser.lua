local BodyComponent = require('components/physic/body')
local VelocityComponent = require('components/physic/velocity')

local WeaponEntity = require('entities/weapon')

local resources = require('core/Resources')

Laser = class("Laser", WeaponEntity)

function Laser:initialize(x, y, theta, team)
    WeaponEntity.initialize(x, y, theta, team)

    self:add(BodyComponent(hc.circle(x, y, SHIP_SIZE / 2), self, SHIP_SIZE / 2, Laser.onCollisionWith))
    self:add(VelocityComponent(LASER_VELOCITY * math.cos(theta), LASER_VELOCITY * math.sin(theta)))

    love.audio.play(love.audio.newSource('sound/laser.wav', 'stream'))
end

function Laser:onCollisionWith(entity, delta)
end

return Laser