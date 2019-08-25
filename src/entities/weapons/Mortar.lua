local BodyComponent = require('components/physic/body')
local VelocityComponent = require('components/physic/velocity')

local WeaponEntity = require('entities/weapons/Weapon')

local resources = require('core/Resources')

Mortar = class("Mortar", WeaponEntity)

Mortar.EnergyCost = MORTAR_ENERGY_COST

function Mortar:initialize(origin_position, dest_position, team)
    WeaponEntity.initialize(origin_position, team)

    self:add(BodyComponent(hc.circle(origin_position.x, origin_position.y, SHIP_SIZE / 2), self, SHIP_SIZE / 2, Mortar.onCollisionWith))
    self:add(VelocityComponent(MORTAR_VELOCITY, MORTAR_VELOCITY))

    love.audio.play(love.audio.newSource('sound/MORTLNCH.wav', 'stream'))
end

function Mortar:onCollisionWith(entity, delta)
    if(typeof(entity) == "Tile") then
        -- need to expand this into child entities and destroy the radius upon hitting a wall
    elseif(typeof(entity) == "Ship") then
        love.audio.play(love.audio.newSource('sound/MORTHIT.wav', 'stream'))
        self.eventManager:fireEvent(MortarHit(entity:getParent():getComponent("Meta").id, self:getParent():getComponent("Meta").id))
        self:destroy()
    end
end

return Mortar