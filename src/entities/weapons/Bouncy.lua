local BodyComponent = require('components/physic/body')
local VelocityComponent = require('components/physic/velocity')

local WeaponEntity = require('entities/weapons/Weapon')

local resources = require('core/Resources')

Bouncy = class("Bouncy", WeaponEntity)

function Bouncy:initialize(x, y, angle, team)
    WeaponEntity.initialize(x, y, angle, team)

    self:add(BodyComponent(hc.circle(x, y, SHIP_SIZE / 2), self, SHIP_SIZE / 2, Bouncy.onCollisionWith))
    self:add(VelocityComponent(BOUNCY_VELOCITY * math.cos(theta), BOUNCY_VELOCITY * math.sin(theta)))

    love.audio.play(love.audio.newSource('sound/Bouncy.wav', 'stream'))
end

function Bouncy:onCollisionWith(entity, delta)
end

return Bouncy