local BodyComponent = require('components/physic/body')
local VelocityComponent = require('components/physic/velocity')

local WeaponEntity = require('entities/weapon')

local resources = require('core/Resources')

Mortar = class("Mortar", WeaponEntity)

function Mortar:initialize(start_x, start_y, end_x, end_y, angle, team)
    WeaponEntity.initialize(start_x, start_y, angle, team)

    self:add(BodyComponent(hc.circle(start_x, start_y, SHIP_SIZE / 2), self, SHIP_SIZE / 2, Mortar.onCollisionWith))
    self:add(VelocityComponent(MORTAR_VELOCITY, MORTAR_VELOCITY))

    love.audio.play(love.audio.newSource('sound/Mortar.wav', 'stream'))
end

function Mortar:onCollisionWith(entity, delta)
end

return Mortar