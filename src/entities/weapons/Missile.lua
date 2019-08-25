local BodyComponent = require('components/physic/body')
local VelocityComponent = require('components/physic/velocity')

local WeaponEntity = require('entities/weapons/Weapon')

local resources = require('core/Resources')

Missile = class("Missile", WeaponEntity)

Missile.EnergyCost = MISSILE_ENERGY_COST

function Missile:initialize(position, theta, team)
    WeaponEntity.initialize(position, team)

    self:add(BodyComponent(hc.circle(position.x, position.y, SHIP_SIZE / 4), self, SHIP_SIZE / 4, Missile.onCollisionWith))
    self:add(VelocityComponent(MISSILE_VELOCITY * math.cos(theta), MISSILE_VELOCITY * math.sin(theta)))

    love.audio.play(love.audio.newSource('sound/Missile.wav', 'stream'))
end

function Missile:onCollisionWith(entity, delta)
    if(typeof(entity) == "Tile") then
        love.audio.play(love.audio.newSource('sound/ROCKHITW.wav', 'stream'))
        self:destroy()
    elseif(typeof(entity) == "Ship") then
        love.audio.play(love.audio.newSource('sound/ROCKHITS.wav', 'stream'))
        self.eventManager:fireEvent(MissileHit(entity:getParent():getComponent("Meta").id, self:getParent():getComponent("Meta").id))
        self:destroy()
    end
end

return Missile