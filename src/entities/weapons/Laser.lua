local BodyComponent = require('components/physic/body')
local VelocityComponent = require('components/physic/velocity')

local WeaponEntity = require('entities/weapons/Weapon')

local resources = require('core/Resources')

Laser = class("Laser", WeaponEntity)

Laser.EnergyCost = LASER_ENERGY_COST

function Laser:initialize(position, theta, team)
    WeaponEntity.initialize(position, team)

    self:add(BodyComponent(hc.circle(position.x, position.y, SHIP_SIZE / 8), self, SHIP_SIZE / 8, Laser.onCollisionWith))
    self:add(VelocityComponent(LASER_VELOCITY * math.cos(theta), LASER_VELOCITY * math.sin(theta)))

    love.audio.play(love.audio.newSource('sound/laser.wav', 'stream'))
end

function Laser:onCollisionWith(entity, delta)
    if(typeof(entity) == "Tile") then
        love.audio.play(love.audio.newSource('sound/LASRHITW.wav', 'stream'))
        -- bounce off surface
    elseif(typeof(entity) == "Ship") then
        love.audio.play(love.audio.newSource('sound/LASRHITS.wav', 'stream'))
        self.eventManager:fireEvent(LaserHit(entity:getParent():getComponent("Meta").id, self:getParent():getComponent("Meta").id))
        self:destroy()
    end
end

return Laser